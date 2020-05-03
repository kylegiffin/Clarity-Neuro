
## utility functions ##

'''Testing to see if this will push properly'''

import numpy as np
import mne #documentation: https://mne.tools/stable/python_reference.html?highlight=filter#module-mne.filter

#Reading data from a participant of a 64-electrode hour-long EEG study with relatively stable signals and one dead electrode : P1
subject_6_dataset = r'C:\Users\kyleg\OneDrive\Desktop\MATLAB\PRRL_Offline\EEG_DATA\PRRL_6.bdf' #This dataset shows heavy alpha waves. The participant got very sleepy during the study.
raw_data = mne.io.read_raw_bdf(subject_6_dataset, preload=True) #I used read_raw_bdf due to my file type, there are a variety of different file types for EEG data.
raw_data.filter(1., 40., fir_design = 'firwin', n_jobs = 1)

print(raw_data)
