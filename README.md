# Clarity Neuro: Original Code for EEG Reading & Analysis

** Version 1.0.0 **

The goal at present is to write code which can effectively read, analyze, manipulate, interpolate, reject, and smooth out EEG data. These actions are the absolute essentials required for proper handling of EEG data. This means are code should be able to open an EEG data file, interpolate electrodes that do not represent neural activity, reject noisy epochs of data, and smooth out signals so we achieve the first step of any EEG preprocessing analysis, which is to reduce noise.

Once noise has been dealt with, we will move to more complicated methods of analysis. Below are few methods of non-linear feature extraction that I think are essential to include :

##1) Higuchi's Fractal Dimension (HFD)
    ###### Can be used on left brain, right brain, or individual electrodes to gauge complexity
    ###### Very fast computation, minimal CPU requirement
    ###### Indicates overall signal complexity
    ###### Useful in diagnosing Alzheimer's Disease & other applications

##2) Fourier Transforms
    ###### This actually can be a linear method
    ###### Allows to take a complex signal and decompose it into pure frequencies that make it up
    ###### By identifying individual frequencies, we can see common activity patterns (alpha, beta, gamma, etc.)
    ###### Very fast computation, minimal CPU requirement
    ###### Useful in diagnosis of all kinds

##3) Approximate Entropy (AE)
    ###### It is often the case that more chaotic EEG data is indicative of neurological conditions (e.g. ADHD)
    ###### One of the features discussed in quantifying chaos is entropy
    ###### AE is a method for approximating the amount of the entropy or randomness in a signal
    ###### This paper has equations for coding approximate entropy:
       [non-linear feature extraction for ADHD](https://translateyar.ir/wp-content/uploads/2018/12/375-English.pdf)

##4) Largest Lyapunov Exponent (LLE)
    # Lyapunov exponent is also a measure to understand the chaotic behavior of a system
    # If the LLE is positive, then the system has a chaotic behavior.
    # LLE of a time series is defined based on the expansion rate of the differences between consecutive samples
