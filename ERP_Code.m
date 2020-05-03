%% NOTES: The following code is written in MATLAB script. It should be used
% as a reference point for how to plot, visualize, and model event-related potentials (ERPs)
% to derive insights about cognition. These are critical for understanding specific neural
% responses, usually from ONE electrode, that are likely to be a result of a measurable thought,
% intention, or other reaction to a stimulus. Event related potentials DO NOT have use in analyzing
% overall neural functionality or 'brain state'. For understanding the state of ones brain
% at large, we would use to use HFD analysis (for signal complexity), time-frequency analysis,
% spectral analysis, and other signal relativity methods to get a larger picture.


 My recommendation is that you download MATLAB
% and run this script, but replace the behavioral data in the first section with
% a free online set of behavioral data. This will also mean that many lines of
% code that pull from specific columns of data (e.g. memory.response_time)
% should be replaced with the corresponding data from your behavioral set to
% make the code execute properly (e.g. table_name.column_name)
% Go to www.mathworks.com to learn proper documentation.

%% Important Note
% In MATLAB, '%' is used as the commenting symbol. '%%' makes a new block of code
% For different sections of code, search for '%%' symbols as indicators



%% ERP  --- memory --- P3 component
%1) Get a list of filenames for first 10 good subjects

data_directory = '%type in the path where your specific EEG data file is located';

timeInterval = [-200 1200]; %in MILLIseconds!

subjectIDs = [6 7 10]; %this is to analyze multiple participants (i.e. subject 6, 7, and 10)
nSubjects = length(subjectIDs);

%preallocate
maxNTrialsPerSub = 228; %amount of epochs for N-back task
memory_stim_eeg.Subject = NaN([nSubjects*maxNTrialsPerSub 1]);    %column vector
memory_stim_eeg.SubjectID = NaN([nSubjects*maxNTrialsPerSub 1]);  %column vector
memory_stim_eeg.Trial = NaN([nSubjects*maxNTrialsPerSub 1]);      %column vector
memory_stim_eeg.Pz = NaN([nSubjects*maxNTrialsPerSub 717]);       %[trial X timepoints] matrix

%compile EEG data at pz,  subject by subject
row = 0;
for k = 1:nSubjects
    %get real subject number
    sub_num = subjectIDs(k);
    fprintf('adding data from subject #%i ... ', sub_num);
    %load this subjects data
    %this load command introduces EEG, extEEG & subject to our workspace)
    memory_stim_fileName = '\PRRL_6_memory_stim_lowpass_etc';
        %wrote 6 and it loads all 3 so this still works fine
        fprintf('PRRL_%i_memory_stim_lowpass_etc.mat', sub_num);
    load([data_directory memory_stim_fileName]);

    %do this part ONLY once
    if row == 0
        %find which time points are in relevant interval (in ms)
        times = EEG.times;
        in_time_interval = timeInterval(1) <= times & times <= timeInterval(2)
        %extract channel name strings & get index of the relevant channels
        channel_names = {EEG.chanlocs.labels};
        Pz = find(ismember(channel_names, 'Pz'));
    end

    %for every file
    %get REAL trial indices for EEG trials
    real_trial_indices = subject.good_trials;
    n_trials = length(real_trial_indices);
    if ~isequal(size(EEG.data, 3), length(subject.good_trials));
        error('mismatch in number of trials,  doofus!');
    end
    %compile EEG data, etc.
    memory_stim_eeg.Subject((row + 1) : (row+n_trials)) = k;
    memory_stim_eeg.SubjectID((row + 1) : (row + n_trials)) = sub_num;
    memory_stim_eeg.Trial((row + 1) : (row + n_trials)) = real_trial_indices;
    %note: EEG.data is an electrides X timepoints X trials matrix
    memory_stim_eeg.Pz((row + 1) : (row + n_trials), :) = squeeze(EEG.data(Pz, in_time_interval, :))';

    %compile corresponding behavioral data for these trials
    memory_stim_beh = memory;
    %must reorganize this so "Nth" row in mem_stim_eeg.Pz corresponds to
    %Nth row in mem_stim_beh

    %increment row counter
    row = row + n_trials;
    fprintf('done.\n');
end

%clean up
times  = times(in_time_interval);
no_data = isnan(memory_stim_eeg.Subject);
memory_stim_eeg.Subject(no_data) = [];
memory_stim_eeg.SubjectID(no_data) = [];
memory_stim_eeg.Pz(no_data, :) = [];

%% plot ERP's

% GRAND ERP (experiment-level ERP) %

%(currently ignoring trial type, so this isn't a meaningful ERP)

trials_I_care_about = memory_stim_eeg.Trial >= 3 & memory_stim_eeg.Trial <= 200; %edit this to select a condition/correct trials/good outcome/etc.
%average across first dimension (across trials)
grand_ERP = mean(memory_stim_eeg.Pz(trials_I_care_about,:),1);

fig = figure('color', [1 1 1]);
f_pos = fig.Position;
fig.Position = [f_pos(1:2) 550 350];
hold on

%plot
plot(times, grand_ERP, 'color', 'k', 'linewidth', 3)

%formatting
xlabel('time (ms)')
ylabel('voltage (\muV)')
ylim([-10 10])
title('Pz')
set(gca,'fontsize',18)
box on


%%
%if mem_stim_eeg.SubjectID(n) == mem_stim_beh.subject(n)
%AND
%mem_stim_eeg.Trial(n) == mem_stim_beh.trial(n)
%then you did it correctly

%% matching the eeg subject IDs with behavioral subject IDs
[idx, loc] = ismember(memory_stim_eeg.Trial, memory_stim_beh.trial); %finds index & location of data that's a member of eeg trials & beh trials
out = loc(idx);
out = find(any(abs(bsxfun(@minus,memory_stim_eeg.Trial,memory_stim_beh.trial.')) < eps(100))); %finds any data where these values match
matched_trials = memory(out, :); %table of matched trials
%% matching the eeg trials with behavioral subject trials
[idx2, loc2] = ismember(memory_stim_eeg.SubjectID, memory_stim_beh.subject); %finds index & location of data that's a member of eeg subjects & beh subjects
out2 = loc2(idx2);
out2 = find(any(abs(bsxfun(@minus,memory_stim_eeg.SubjectID, memory_stim_beh.subject.')) < eps(100))); %finds any data where these values match
matched_subjects = memory(out2, :); %table of matched subjects

%% inner joining two tables to match trials and subjects
final_table = innerjoin(matched_trials, matched_subjects, 'keys', [1 2]);

%% Plot the grand ERP (average across trials, ignore subject) at Pz electrode
%% Plot 1: Correct trials vs incorrect trials (two lines on one plot)

% GRAND ERP (experiment-level ERP) %

%(currently ignoring trial type, so this isn't a meaningful ERP)

correct_trials_I_care_about = final_table.correct_matched_trials == 1;
incorrect_trials_I_care_about = final_table.correct_matched_trials == 0;

%average across first dimension (across trials)
grand_ERP1 = mean(memory_stim_eeg.Pz(correct_trials_I_care_about,:),1);
grand_ERP2 = mean(memory_stim_eeg.Pz(incorrect_trials_I_care_about,:),1);

%figure
fig = figure('color', [1 1 1]);
f_pos = fig.Position;
fig.Position = [f_pos(1:2) 550 350];
hold on

%plot
plot(times, grand_ERP1, 'color', 'k', 'linewidth', 2, 'color', 'g')
hold on
plot(times, grand_ERP2, 'color', 'k', 'linewidth', 2, 'color', 'r')
hold on
%formatting
xlabel('time (ms)')
ylabel('voltage (\muV)')
title('Incorrect trials')
set(gca,'fontsize',12)
legend('Correct', 'Incorrect')
box on
hold off

%% Plot 2: Target trials vs foil trials (two lines on one plot)

% GRAND ERP (experiment-level ERP) %

%(currently ignoring trial type, so this isn't a meaningful ERP)

target_trials_I_care_about = final_table.target_matched_trials == 1;
foil_trials_I_care_about = final_table.target_matched_trials == 0;

%average across first dimension (across trials)
grand_ERP1 = mean(memory_stim_eeg.Pz(target_trials_I_care_about,:),1);
grand_ERP2 = mean(memory_stim_eeg.Pz(foil_trials_I_care_about,:),1);

%figure
fig = figure('color', [1 1 1]);
f_pos = fig.Position;
fig.Position = [f_pos(1:2) 550 350];
hold on

%plot
plot(times, grand_ERP1, 'color', 'k', 'linewidth', 2, 'color', 'g')
hold on
plot(times, grand_ERP2, 'color', 'k', 'linewidth', 2, 'color', 'r')
hold on
%formatting
ylim([-10 10])
xlabel('time (ms)')
ylabel('voltage (\muV)')
title('Target vs Foil trials')
set(gca,'fontsize',12)
legend('Target', 'Foil')
box on
hold off
%%
clearvars xlabel
clearvars ylabel
%% Plot 3: Target trials vs foil trials (two lines on one plot)

% GRAND ERP (experiment-level ERP)

target = final_table.target_matched_trials
N = final_table.load_matched_trials

N1_trials_I_care_about = target == 1 & N == 1;
N2_trials_I_care_about = target == 1 & N == 2;
N3_trials_I_care_about = target == 1 & N == 3;

%average across first dimension (across trials)
grand_ERP1 = mean(memory_stim_eeg.Pz(N1_trials_I_care_about,:),1);
grand_ERP2 = mean(memory_stim_eeg.Pz(N2_trials_I_care_about,:),1);
grand_ERP3 = mean(memory_stim_eeg.Pz(N3_trials_I_care_about,:),1);

%figure
fig = figure('color', [1 1 1]);
f_pos = fig.Position;
fig.Position = [f_pos(1:2) 550 350];
hold on

%plot
plot(times, grand_ERP1, 'color', 'k', 'linewidth', 2, 'color', 'r');
hold on
plot(times, grand_ERP2, 'color', 'k', 'linewidth', 2, 'color', 'g');
hold on
plot(times, grand_ERP3, 'color', 'k', 'linewidth', 2, 'color', 'b');
hold on
%formatting
xlabel('time (ms)');
ylabel('voltage (\muV)');
ylim([-10 10]);
title('N-back difficulty trials');
set(gca,'fontsize',12);
legend('N = 1', 'N = 2', 'N = 3');
box on
hold off

%% ERP analysis --- learning --- FRN ("feedback-related negativity")
data_directory = 'C:\Users\kyleg\OneDrive\Desktop\MATLAB\PRRL_Offline\EEG_DATA\PRRL_i_learning_fdbk';

timeInterval = [-200 1200]; %in MILLIseconds!

subjectIDs = [6 7 10]; %just the first three included participants for now
nSubjects = length(subjectIDs);

%preallocate
maxNTrialsPerSub = 228; %for N-back task
learning_fdbk_eeg.Subject = NaN([nSubjects*maxNTrialsPerSub 1]);    %column vector
learning_fdbk_eeg.SubjectID = NaN([nSubjects*maxNTrialsPerSub 1]);  %column vector
learning_fdbk_eeg.Trial = NaN([nSubjects*maxNTrialsPerSub 1]);      %column vector
learning_fdbk_eeg.Pz = NaN([nSubjects*maxNTrialsPerSub 717]);       %[trial X timepoints] matrix

%compile EEG data at pz,  subject by subject
row = 0;
for k = 1:nSubjects
    %get real subject number
    sub_num = subjectIDs(k);
    fprintf('adding data from subject #%i ... ', sub_num);
    %load this subjects data
    %this load command introduces EEG, extEEG & subject to our workspace)
    learning_fdbk_fileName = '\PRRL_6_learning_fdbk_lowpass_etc';
        %wrote 6 and it loads all 3 so this still works fine
        fprintf('PRRL_%i_learning_fdbk_lowpass_etc.mat ', sub_num);
    load([data_directory learning_fdbk_fileName]);

    %do this part ONLY once
    if row == 0
        %find which time points are in relevant interval (in ms)
        times = EEG.times;
        in_time_interval = timeInterval(1) <= times & times <= timeInterval(2)
        %extract channel name strings & get index of the relevant channels
        channel_names = {EEG.chanlocs.labels};
        FCz = find(ismember(channel_names, 'FCz'));
    end

    %for every file
    %get REAL trial indices for EEG trials
    real_trial_indices = subject.good_trials;
    n_trials = length(real_trial_indices);
    if ~isequal(size(EEG.data, 3), length(subject.good_trials));
        error('mismatch in number of trials,  doofus!');
    end
    %compile EEG data, etc.
    learning_fdbk_eeg.Subject((row + 1) : (row+n_trials)) = k;
    learning_fdbk_eeg.SubjectID((row + 1) : (row + n_trials)) = sub_num;
    learning_fdbk_eeg.Trial((row + 1) : (row + n_trials)) = real_trial_indices;
    %note: EEG.data is an electrodes X timepoints X trials matrix
    learning_fdbk_eeg.FCz((row + 1) : (row + n_trials), :) = squeeze(EEG.data(FCz, in_time_interval, :))';

    %compile corresponding behavioral data for these trials
    memory_stim_beh = memory;
    %must reorganize this so "Nth" row in mem_stim_eeg.Pz corresponds to
    %Nth row in mem_stim_beh

    %increment row counter
    row = row + n_trials;
    fprintf('done.\n');
end

%clean up
times  = times(in_time_interval);
no_data = isnan(learning_fdbk_eeg.Subject);
learning_fdbk_eeg.Subject(no_data) = [];
learning_fdbk_eeg.SubjectID(no_data) = [];
%% Error
learning_fdbk_eeg.FCz(no_data, :) = []; %ERROR: matrix index is out of range for deletion

%% Make a copy of learning
learning_fdbk_beh = learning;
%% matching eeg trials with behavioral trials
[idx, loc] = ismember(learning_fdbk_eeg.Trial, learning_fdbk_beh.trial); %finds index & location of data that's a member of eeg trials & beh trials
out = loc(idx);
out = find(any(abs(bsxfun(@minus,learning_fdbk_eeg.Trial,learning_fdbk_beh.trial.')) < eps(100))); %finds any data where these values match
matched_trials1 = learning(out, :); %table of matched trials

%% matching eeg subject IDs with behavioral subject IDs
[idx1, loc1] = ismember(learning_fdbk_eeg.SubjectID, learning_fdbk_beh.subject); %finds index & location of data that's a member of eeg subjects & beh subjects
out1 = loc1(idx1);
out1 = find(any(abs(bsxfun(@minus,learning_fdbk_eeg.SubjectID, learning_fdbk_beh.subject.')) < eps(100))); %finds any data where these values match
matched_subjects1 = learning(out1, :); %table of matched subjects

%% inner joining two tables to match trials and subjects
final_table = innerjoin(matched_trials1,matched_subjects1, 'keys', [1 3]);
final_table;

%% Plot 1: Correct trials vs incorrect trials (two lines on one plot)

% GRAND ERP (experiment-level ERP) %
%(currently ignoring trial type, so this isn't a meaningful ERP)
correct_trials_I_care_about = final_table.correct_matched_trials1 == 1;
incorrect_trials_I_care_about = final_table.correct_matched_trials1 == 0;

%%
%average across first dimension (across trials)
grand_ERP1 = mean(learning_fdbk_eeg.FCz(correct_trials_I_care_about,:),1);
%THIS IS WHERE ERROR ARISES: The logical indices in position 1 contain a true value outside of the array bounds.
%In previous ERP's with same code structure, I did not get this error

grand_ERP2 = mean(learning_fdbk_eeg.FCz(incorrect_trials_I_care_about,:),1);

%figure
fig = figure('color', [1 1 1]);
f_pos = fig.Position;
fig.Position = [f_pos(1:2) 550 350];
hold on

%plot
plot(times, grand_ERP1, 'color', 'k', 'linewidth', 2, 'color', 'g')
hold on
plot(times, grand_ERP2, 'color', 'k', 'linewidth', 2, 'color', 'r')
hold on
%formatting
xlabel('time (ms)')
ylabel('voltage (\muV)')
ylim([-10 10])
title('Incorrect trials: feedback')
set(gca,'fontsize',12)
legend('Correct', 'Incorrect')
box on
hold off

%% Plot 2: Good vs bad outcomes for REWARD (two lines on one plot)

% GRAND ERP (experiment-level ERP) %
% Haven't proceeded here yet cause I need to clear the error in grand_ERP1
% raised above (line 1047)

correct = final_table.correct_matched_trials1
outcome = final_table.correct_matched_trials1
correct_trials_I_care_about = final_table.correct_matched_trials1 == 1;
incorrect_trials_I_care_about = final_table.correct_matched_trials1 == 0;

%average across first dimension (across trials)
grand_ERP1 = mean(learning_fdbk_eeg.FCz(correct_trials_I_care_about,:),1);
grand_ERP2 = mean(learning_fdbk_eeg.FCz(incorrect_trials_I_care_about,:),1);

%figure
fig = figure('color', [1 1 1]);
f_pos = fig.Position;
fig.Position = [f_pos(1:2) 550 350];
hold on

%plot
plot(times, grand_ERP1, 'color', 'k', 'linewidth', 2, 'color', 'g')
hold on
plot(times, grand_ERP2, 'color', 'k', 'linewidth', 2, 'color', 'r')
hold on
%formatting
xlabel('time (ms)')
ylabel('voltage (\muV)')
ylim([-10 10])
title('Incorrect trials: feedback')
set(gca,'fontsize',12)
legend('Correct', 'Incorrect')
box on
hold off
%%
save
