%% NOTES: The following code is written in MATLAB script. It should be used
% as a reference point for how to plot, visualize, and model both behavioral data
% to derive insights about cognition. My recommendation is that you download MATLAB
% and run this script, but replace the behavioral data in the first section with
% a free online set of behavioral data. This will also mean that many lines of
% code that pull from specific columns of data (e.g. memory.response_time)
% should be replaced with the corresponding data from your behavioral set to
% make the code execute properly (e.g. table_name.column_name)
% Go to www.mathworks.com to learn proper documentation.

%% Important Note
% In MATLAB, '%' is used as the commenting symbol. '%%' makes a new block of code
% For different sections of code, search for '%%' symbols as indicators


%% load the processed behavioral data

behavioralDataFileName = 'behavioralData.mat';    %(includes meta)
if exist(behavioralDataFileName,'file')
    load(behavioralDataFileName)
else
    resp = '';
    while ~ismember(resp,{
'y','Y','yes','n','N','no'})
        resp = input('would you like to compile the data (y/n)? ','s');
    end
    if ismember(resp,{'y','Y','yes'})
        PRRL_compileBehavior
        clearvars -except behavioralDataFileName
        load(behavioralDataFileName)
        fprintf('\n')
    else
        error(['well, we can''t do any data analyses without ' ...
            'any data, now can we?'])
    end
end
fprintf('successfully loaded the processed behavioral data from %s.\n',...
    behavioralDataFileName)


subjects = metadata.includedIDs;
numSubjects = length(subjects);

rewardProbabilities = sort(unique(learning.LbanditProb),'ascend');


%% Warm-Up MATLAB Practice / Colors

% maxtrials code for later use
maxNtrials = max(learning.subtrial);


%always define variables first
%next define figure F = ____
%next create a plot object h1 = ____
%use hold on to get two lines on the same plot

Color_easy = [0.3010, 0.7450, 0.9330]; %light blue
Color_hard = [0, 0.4470, 0.7410]; %dark blue

Color_reward = [1, 0, 0];    %bright red
Color_goal = [0.6350, 0.0780, 0.1840]; %dark red

Color_easy_reward = [0.9290, 0.6940, 0.1250];   %yellow
Color_hard_reward = [0.8500, 0.3250, 0.0980];   %orange

Color_easy_goal = [0, 0.75, 0.75];     %cyan
Color_hard_goal = [0.75, 0, 0.75];     %purple

x = 1:100;
y1 = rand([100 1]);
y2 = rand([100 1]);
F = figure('color', [1 1 1]); %always start a figure

hold on
h1 = plot(x,y1);
get(h1, 'color');

hold on
h2 = plot(x,y2);
get(h2, 'color');

title('Test plot: ordered x by random y');
xlabel = ('x = ordered list from 1 to 100');
ylabel = ('y = random list from 1 to 100');

set(h1, 'color', Color_easy_reward); %testing colors
set(h2, 'color', Color_hard_reward); %testing colors

set(gca, 'fontsize', 12);
set(gca, 'xtick', 0:20:100);
set(gca, 'ytick', 0:0.5:1);

ylim([0 1]);
xlim([0 100]);

% Press Ctrl + Enter to JUST run a highlighted block
%% fprintf documentation
%fprintf(formatspec, var)
%example: fprintf('figure #%i: random numbers', F.number)

clearvars xlabel
clearvars ylabel



%% FIRST PLOTTING ASSIGNMENT
%% Assignment #2 ~ Memory Plots (Complete)

%Regular  bar plot WITH ERROR BARS (by N)

x = categorical({'N = 1', 'N = 2', 'N = 3'});
x = reordercats(x,{'N = 1', 'N = 2', 'N = 3'});

%NOTE: I could make H1, H2, H3 for each of these cases
%... This would allow me to adjust color for each individual case
%y = [sum(memory.load == 1 & memory.correct == 1);
  %  sum(memory.load == 2 & memory.correct == 1);
  %  sum(memory.load == 3 & memory.correct == 1)];

condition_N1 = (memory.correct(memory.load==1));
condition_N2 = (memory.correct(memory.load==2));
condition_N3 = (memory.correct(memory.load==3));

prop_corr1 = mean(condition_N1);
prop_corr2 = mean(condition_N2);
prop_corr3 = mean(condition_N3);

propCorrSEM1 = std(condition_N1)/sqrt(length(condition_N1))
propCorrSEM2 = std(condition_N2)/sqrt(length(condition_N2))
propCorrSEM3 = std(condition_N3)/sqrt(length(condition_N3))


y = [prop_corr1;
    prop_corr2;
    prop_corr3;];

errY = [propCorrSEM1;
        propCorrSEM2;
        propCorrSEM3;];

er = errorbar(x,y,errY);
er.Color = [0 0 0];
er.LineStyle = 'none';


f = figure('color', [1 1 1]);

hold on
bar(x,y)
title('(N-BACK) proportion correct based on difficulty');
xlabel('N Difficulty');
ylabel('Proportion of correct responses');
hold on
er = errorbar(x,y,errY);
er.Color = [0 0 0];
er.LineStyle = 'none';

%% Testing X's

x1 = categorical({'N = 1', 'N = 2', 'N = 3'});
x2 = categorical({'N = 1', 'N = 2', 'N = 3'});
x3 = categorical({'N = 1', 'N = 2', 'N = 3'});

x1 = reordercats(x,{'N = 1', 'N = 2', 'N = 3'});
x2 = reordercats(x,{'N = 1', 'N = 2', 'N = 3'});
x3 = reordercats(x,{'N = 1', 'N = 2', 'N = 3'});

%% Assignment #2 (Everyone) ~ Grouped memory plot (Complete)

total_all_ns = sum(memory.load ==1 | memory.load == 2 | memory.load == 3);

count_foil_n1 = sum(memory.target == 0 & memory.load == 1); %number of foils where N = 1
count_target_n1 = sum(memory.target == 1 & memory.load ==1); %number of targets where N = 1
total_n1 = sum(memory.target >= 0 & memory.load ==1); %total number of foils or targets where N = 1

prop_n1_foil = count_foil_n1 / total_all_ns ;
prop_n1_target = count_target_n1 / total_all_ns ;

n1_data = [prop_n1_foil, prop_n1_target] ;


count_foil_n2 = sum(memory.target == 0 & memory.load == 2); %number of foils where N = 2
count_target_n2 = sum(memory.target == 1 & memory.load ==2); %number of targets where N = 2
total_n2 = sum(memory.target >= 0 & memory.load ==2); %total number of foils or targets where N = 2

prop_n2_foil = count_foil_n2 / total_all_ns;
prop_n2_target = count_target_n2 / total_all_ns;

n2_data = [prop_n2_foil, prop_n2_target];

count_foil_n3 = sum(memory.target == 0 & memory.load == 3); %number of foils where N = 3
count_target_n3 = sum(memory.target == 1 & memory.load ==3); %number of targets where N = 3
total_n3 = sum(memory.target >= 0 & memory.load ==3); %total number of foils or targets where N = 3

prop_n3_foil = count_foil_n3 / total_all_ns;
prop_n3_target = count_target_n3 / total_all_ns;

n3_data = [prop_n3_foil, prop_n3_target];

y2 = [n1_data; n2_data; n3_data]

x2 = categorical({'N = 1 ~ foil vs target', 'N = 2 ~ foil vs target', 'N = 3 ~ foil vs target'})

F = figure('color', [1 1 1]); %always start a figure
bar(x2, y2);
title('Grouped Bar plot of proportion target vs proportion foil by N');
xlabel('N Difficulty');
ylabel('Proportion');

%% Assignment #2 (Everyone) ~ Response Time Curves | One line each, target vs foil


% axis will be response time in bins
% y axis will be all trials, regardless of whether they are correct
% exclude trials where there is no response using ~ (NOT) isnan

F = figure('color', [1 1 1]); %always start a figure

% Make a logical vector for target trials

%logical index arrays of foil data
LIA = ismember(memory.target, 0); %foil data
foil = memory(LIA, :);

%logical index arrays of foil data

LIA_2 = ismember(memory.target, 1); %target data
target = memory(LIA_2, :);

%2 ~ Use vectors to select response times

x = foil.rt;

y = target.rt;
response_times_x = x(~isnan(x)); %removes all values that are NaN
response_times_y = y(~isnan(y)); %removes all values that are NaN

%3 submit RTs to histcounts

[foil_bins, foil_edges] = histcounts(response_times_x); %partitions foil response times into bins, returns count in each bin as well as edges
[target_bins,target_edges] = histcounts(response_times_y); %partitions target response times into bins, returns count in each bin as well as edges

%use bin midpoints

foil_midpoints = (foil_edges(1:end-1) + foil_edges(2:end))./2;
target_midpoints = (target_edges(1:end-1) + target_edges(2:end))./2;


plot(foil_midpoints, foil_bins, 'linewidth', 1.5, 'color', [0, .5, .5])
hold on;
plot(target_midpoints, target_bins, 'linewidth', 1.5, 'color', [1, .6, 1])
hold on;
set(gca,'fontsize',12);
legend('Foil','Target');
xlabel('Response Times');
ylabel('Count of RTs at each RT');
title('Target vs Foil RT curve');

%% Assignment #2 ~ Response Time Curves | One line each, N = 1,2,3

%NOTE: These plots indicate the amount of time it took for the participant to respond
% after the presentation of a stimuli. This could indicate tiredness, focus, attention, etc.


F = figure('color', [1 1 1]);

%Make a logical vector for N = 1, N = 2, N = 3

LIA_N_1 = ismember(memory.load, 1);
N1 = memory(LIA_N_1,:)

LIA_N_2 = ismember(memory.load, 2);
N2 = memory(LIA_N_2,:)

LIA_N_3 = ismember(memory.load, 3);
N3 = memory(LIA_N_3,:)

x = N1.rt;
y = N2.rt;
z = N3.rt;

response_times_x = x(~isnan(x)); %removes all values that are NaN
response_times_y = y(~isnan(y)); %removes all values that are NaN
response_times_z = z(~isnan(z)); %removes all values that are NaN


[N1_bins, N1_edges] = histcounts(response_times_x); %partitions N1 response times into bins, returns count in each bin as well as edges
[N2_bins, N2_edges] = histcounts(response_times_y); %partitions N2 response times into bins, returns count in each bin as well as edges
[N3_bins, N3_edges] = histcounts(response_times_z); %partitions N3 response times into bins, returns count in each bin as well as edges

N1_midpoints = (N1_edges(1:end-1) + N1_edges(2:end))./2;
N2_midpoints = (N2_edges(1:end-1) + N2_edges(2:end))./2;
N3_midpoints = (N3_edges(1:end-1) + N3_edges(2:end))./2;

plot(N1_midpoints, N1_bins, 'linewidth', 1.5, 'color', [0.9290, 0.6940, 0.1250])
hold on;
plot(N2_midpoints, N2_bins, 'linewidth', 1.5, 'color', [0.75, 0, 0.75])
hold on;
plot(N3_midpoints, N3_bins, 'linewidth', 1.5, 'color', [1, 0, 0])
hold on;
set(gca,'fontsize',12);
legend('N1','N2', 'N3');
xlabel('Response Times');
ylabel('Count of RTs at each RT');
title('Response Times by Difficulty N');

%% 3 X 2 ANOVAs on accuracy data in N-back task
% These are statistical analysis on behavioral data in an N-back memory task
p = anovan(memory.correct, memory.trial);
%% 3 X 2  ANOVAs on the RT data in the N-back task
pp = anovan(memory.rt, memory.trial)
%%
total = size(memory.correct); %total # values in 'correct' column
LIA_incorrect = ismember(memory.correct, 0);
incorrect = memory(LIA_incorrect, :); %number of total incorrect values in 'correct column'

LIA_correct = ismember(memory.correct, 1);
correct = memory(LIA_correct, :); %number of total correct values in 'correct column

percent_correct = size(correct) / total %percent of total correct values
percent_incorrect = size(incorrect) / total %percent of total incorrect values

%% Make a 4-panel plot with the following panels:
%reward/easy, reward/hard, goal/easy, goal/hard
%in each subplot, plot the learning curves for all subjects in light gray
%(no error bars)

%make two plots where X-axis is proportion correct, Y-axis is the subject
%each subject has large marker for mean as well as horizontal SEM bars


bins = maxNtrials / 5;
mean_acc= NaN([bins 2 2]) ;
SEM_acc = NaN([bins 2 2]) ;


trial = 0;
for b = 1:bins
    trial = ismember(learning.subtrial,(trial+1):(trial+bins));
    for fb = 1:2
        %determine feedback condition fb
        feedback = learning.feedback == fb;
        for diff = 1:2
            %determine difficulty condition, diff
            difficulty = learning.difficulty == diff;
            nCorr = learning.correct(trial & feedback & difficulty);
            mean_acc(b,fb,diff) = mean(nCorr)
            SEM_acc(b,fb,diff) = std(nCorr) / sqrt(length(nCorr));
        end
    end
    trial = trial + bins;
end

%These plots model behavioral responses in easy/hard vs reward/goal trials

line([0 maxNtrials+1],[0.5 0.5],'color',0.85*[1 1 1],'linestyle','--')
figure('color',[1 1 1])
hold on
lineNum = 0;
lineNum = lineNum + 1;

subplot(2,2,1); plot(1:bins,mean_acc(:,1,1),'color',[0.7,0.7,0.7],'linewidth',1.5);
title('Reward (Easy)');
xlabel('Bin');
ylabel('Prop Correct');
set(gca,'fontsize',10);
xticks([0:1:bins])
yticks([0:0.2:1])
ylim([0 1]);
xlim([0 bins+1]);

subplot(2,2,2), plot(1:bins,mean_acc(:,1,2),'color',[0.5,0.5,0.5,0.5],'linewidth',1.5);
title('Reward (Hard)');
xlabel('Bin');
ylabel('Prop Correct');
set(gca,'fontsize',10);
xticks([0:1:bins])
yticks([0:0.2:1])
ylim([0 1]);
xlim([0 bins+1]);

subplot(2,2,3), plot(1:bins,mean_acc(:,2,1),'color',[0.5,0.5,0.5,0.5],'linewidth',1.5);
title('Goal (Easy)');
xlabel('Bin');
ylabel('Prop Correct');
set(gca,'fontsize',10);
xticks([0:1:bins])
yticks([0:0.2:1])
ylim([0 1])
xlim([0 bins+1]);

subplot(2,2,4), plot(1:bins,mean_acc(:,2,2),'color',[0.5,0.5,0.5,0.5],'linewidth',1.5);
title('Goal (Hard)');
xlabel('Bin');
ylabel('Prop Correct');
set(gca,'fontsize',10);
xticks([0:1:bins])
yticks([0:0.2:1])
ylim([0 1]);
xlim([0 bins+1]);

%% make two plots where X-axis is proportion correct, Y-axis is subject.
%each subject has a large marker for their mean, and horizontal SEM error bars.

%always start with a figure
figure('color',[1 1 1])
hold on

x = learning.correct;
y = learning.subject;
[unique_y, ia, ic] = unique(y);

mean_correct = accumarray(ic, x, [], @mean);
scatter(mean_correct, unique_y, [], [0 0 0]);

hold on;
error = [std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct)), std(mean_correct)/sqrt(length(mean_correct))];
err_bar = errorbar(mean_correct,unique_y, error, 'horizontal');
err_bar.Color = [0 0 0];
err_bar.LineStyle = 'none';
err_bar.LineWidth = 1

set(gca,'fontsize',10)
xlim([0 1])
xlabel('Prop Correct')
ylabel('Subject number')
title('Prop Correct by Subject Number','fontsize',14)
box on

%% Paragraph about individual differences
% There are individual differences, however the group as a whole lies
% within a relatively similar range in terms of accuracy. The lowest
% accuracy was .6 while the highest was nearly .95. It is clear that the
% majority of participants responded at about .80. In order to identify on
% a deeper level the nature of individual differences, it would help to
% incorporate the conditions of target vs foil, difficulty, or response
% time to see if there are correlations between these values and the
% proportions correct.
%% Scatter plot: 3 panels for N = 1,  N = 2,  N = 3

%% Scatter plot for N=1
%initializing data
n1 = memory.subject >= 1 & memory.rt ~= 0 & memory.load == 1;
n1_data = memory(n1, :);
n1_data.rt;

%organizing data
z = n1_data.rt;
x = n1_data.correct;
y = n1_data.subject;

%sorting unique y
[unique_yy, ia, ic] = unique(y);

%finding means
mean_rt = accumarray(ic, z, [], @mean);
mean_correct = accumarray(ic, x, [], @mean);

mean(mean_correct)

%plotting
figure('color', [1 1 1])
hold on

sz = 40;
scatter(mean_rt, unique_yy, sz, 'd', 'r', 'filled');
hold on
scatter(mean_correct, unique_yy, sz, 's', 'g', 'filled');

title('Response Time vs Proportion Correct for N=1 trials')
ylabel('Subject number')
xlabel('response time & proportion correct')
legend('RT','Proportion Correct');
hold off

%% Scatter Plot for N = 2
%initializing data
n2 = memory.subject >= 1 & memory.rt ~= 0 & memory.load == 2;
n2_data = memory(n2, :);
n2_data.rt;

%organizing data
z = n2_data.rt;
x = n2_data.correct;
y = n2_data.subject;

%sorting unique y
[unique_yy, ia, ic] = unique(y);

%finding means
mean_rt = accumarray(ic, z, [], @mean);
mean_correct = accumarray(ic, x, [], @mean);

mean(mean_correct)

%plotting
figure('color', [1 1 1])
hold on
sz = 40;
scatter(mean_rt, unique_yy, sz, 'd', 'r', 'filled');
hold on
scatter(mean_correct, unique_yy, sz, 's', 'c', 'filled');

title('Response Time vs Proportion Correct for N=2 trials')
ylabel('Subject number')
xlabel('response time & proportion correct')
legend('RT','Proportion Correct');
hold off

%% Scatter plot for N = 3
%initializing data
n3 = memory.subject >= 1 & memory.rt ~= 0 & memory.load == 3;
n3_data = memory(n3, :);
n3_data.rt;

%organizing data
z = n3_data.rt;
x = n3_data.correct;
y = n3_data.subject;

%sorting unique y
[unique_yy, ia, ic] = unique(y);

%finding means
mean_rt = accumarray(ic, z, [], @mean);
mean_correct = accumarray(ic, x, [], @mean);

mean(mean_correct)

%plotting
figure('color', [1 1 1])
hold on

sz = 40;
scatter(mean_rt, unique_yy, sz, 'd', 'r','filled');
hold on
scatter(mean_correct, unique_yy, sz, 's', 'b', 'filled');

title('Response Time vs Proportion Correct for N=3 trials')
ylabel('Subject number')
xlabel('response time & proportion correct')
legend('RT','Proportion Correct');
hold off

%%
% After plotting all three difficulties I definitely notice a pattern. For
% N = 1 trials,  we can see that that there is the majority of subjects
% responded between .4 and .6 seconds (avg of about half a second) and
% their responses were correct 87.71% of the time. For N = 2 trials, the
% response times become more distributed between .4 and .85 and correctness
% of response dropped to 73.54%. For the final and most difficult trial, N
% = 3, response times were highly variant and the correctness of responses
% significantly lowered to 62.67% correct. This pattern implies, as
% expected, that as N increased from 1 to 3, subjects took longer to
% respond on average and also were correct less of the time on average.

%%
%N-back experiment features
subjectIDs = unique(memory.subject);    %IDs for subjects (not consecutive!!)
nSubjects = length(subjectIDs);         %count of subjects
Nconditions = [1 2 3];      %N (1: 1-back; 2: 2-back; 3: 3-back)
TTconditions = [1 0];


%% Make 4 plots where
%the X-axis is accuracy on TARGET TRIALS ONLY,
%    and the Y-axis is the subject.
%    each subject has a large marker for their mean, and horizontal SEM error bars.
%        plot 1: overall
%        plot 2: N = 1 only
%        plot 3: N = 2 only
%        plot 4: N = 3 only

%preallocate
accMeans_sub = NaN([nSubjects 1]); %columns are feedback conditions
accSEM_sub = NaN([nSubjects 1]);

% formatting of n1, n2, and n3 data
n1 = memory.target == 1 & memory.load == 1;
n1_data = memory(n1, :);
n1_final = n1_data.correct;

n2 = memory.target == 1 & memory.load == 2;
n2_data = memory(n2, :);
n2_final = n2_data.correct;

n3 = memory.target == 1 & memory.load == 3;
n3_data = memory(n3, :);
n3_final = n3_data.correct;

%% Plot 1: overall
%getaccuracy means
for k = 1:nSubjects
    subNum = subjectIDs(k);
    thisSubject = memory.subject==subNum;
    accuracyData = memory.correct(thisSubject);
    accMeans_sub(k) = mean(accuracyData);
    accSEM_sub(k) = std(accuracyData)/sqrt(length(accuracyData));
end


fig = figure('color',[1 1 1]);
fpos = fig.Position;
fig.Position = [fpos(1:2) 550 650];
hold on
h = gobjects([2 1]);
%underlay line at chance level
line([0.5 0.5],[0 nSubjects+1],'color',0.5*[1 1 1],'linestyle','--')
%caterpillar by subject
for k = 1:nSubjects
    %learning curve by condition
    errorbar(accMeans_sub(k),k,accSEM_sub(k), ...
        'horizontal','color','b','marker','o','markersize',10, ...
        'markeredgecolor','b','markerfacecolor','w')
end
%format
xlim([0.35 1])
ylim([0 nSubjects+1])
set(gca,'ytick',1:nSubjects)
xlabel('overall accuracy on target trials')
ylabel('subject')
title('subjects target trial accuracy (overall)')
set(gca,'fontsize',10)
box on
%% Plot 2: N = 1

accMeans_sub = NaN([nSubjects 1]); %columns are feedback conditions
accSEM_sub = NaN([nSubjects 1]);

n1 = memory.target == 1 & memory.load == 1;
n1_data = memory(n1, :);
n1_final = n1_data.correct;

for k = 1:nSubjects
    subNum = subjectIDs(k);
    this_subject = n1_data.subject == subNum;
    accuracy_data = n1_final(this_subject);
    accMeans_sub(k) = mean(accuracy_data); %taking mean of this data
    accSEM_sub(k) = std(accuracy_data) / sqrt(length(accuracy_data));
end

fig = figure('color',[1 1 1]);
fpos = fig.Position;
fig.Position = [fpos(1:2) 550 650];
hold on
h = gobjects([2 1]);
%underlay line at chance level
line([0.5 0.5],[0 nSubjects+1],'color',0.5*[1 1 1],'linestyle','--')

for k = 1:nSubjects
    %learning curve by condition
    errorbar(accMeans_sub(k),k,accSEM_sub(k), ...
        'horizontal','color','b','marker','o','markersize',10, ...
        'markeredgecolor','b','markerfacecolor','w')
end
%format
xlim([0.35 1])
ylim([0 nSubjects+1])
set(gca,'ytick',1:nSubjects)
xlabel('overall accuracy on target trials')
ylabel('subject')
title('subjects target trial accuracy (N=1)')
set(gca,'fontsize',10)
box on


%% Plot 3: N = 2
for k = 1:nSubjects
    subNum = subjectIDs(k);
    this_subject = n2_data.subject == subNum;
    accuracy_data = n2_final(this_subject);
    accMeans_sub(k) = mean(accuracy_data); %taking mean of this data
    accSEM_sub(k) = std(accuracy_data) / sqrt(length(accuracy_data));
end

fig = figure('color',[1 1 1]);
fpos = fig.Position;
fig.Position = [fpos(1:2) 550 650];
hold on
h = gobjects([2 1]);
%underlay line at chance level
line([0.5 0.5],[0 nSubjects+1],'color',0.5*[1 1 1],'linestyle','--')

for k = 1:nSubjects
    %learning curve by condition
    errorbar(accMeans_sub(k),k,accSEM_sub(k), ...
        'horizontal','color','b','marker','o','markersize',10, ...
        'markeredgecolor','b','markerfacecolor','w')
end
%format
xlim([0.35 1])
ylim([0 nSubjects+1])
set(gca,'ytick',1:nSubjects)
xlabel('overall accuracy on target trials')
ylabel('subject')
title('subjects target trial accuracy (N=2)')
set(gca,'fontsize',10)
box on

%% Plot 4: N = 3
for k = 1:nSubjects
    subNum = subjectIDs(k);
    this_subject = n3_data.subject == subNum;
    accuracy_data = n3_final(this_subject);
    accMeans_sub(k) = mean(accuracy_data); %taking mean of this data
    accSEM_sub(k) = std(accuracy_data) / sqrt(length(accuracy_data));
end

fig = figure('color',[1 1 1]);
fpos = fig.Position;
fig.Position = [fpos(1:2) 550 650];
hold on
h = gobjects([2 1]);
%underlay line at chance level
line([0.5 0.5],[0 nSubjects+1],'color',0.5*[1 1 1],'linestyle','--')

for k = 1:nSubjects
    %learning curve by condition
    errorbar(accMeans_sub(k),k,accSEM_sub(k), ...
        'horizontal','color','b','marker','o','markersize',10, ...
        'markeredgecolor','b','markerfacecolor','w')
end
%format
xlim([0.35 1])
ylim([0 nSubjects+1])
set(gca,'ytick',1:nSubjects)
xlabel('overall accuracy on target trials')
ylabel('subject')
title('subjects target trial accuracy (N=3)')
set(gca,'fontsize',10)
box on
