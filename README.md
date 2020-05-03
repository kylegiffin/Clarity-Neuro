# Clarity Neuro: Code for EEG Reading & Analysis

**Version 1.0.0**

Our mission is to provide psychiatrists the ability to better assess their subjects using a wireless, easily portable Electroencephalogram (EEG) headset to place on their subject during evaluation. Any commercial headset available will connect wirelessly to our proprietary software, NeuroClarity, and generate instantaneous live data on the patient, allowing the psychiatrist to perform tests and make additional evaluations. This software will not only display a live feed of EEG data, but will empower the user to instantaneously run analyses that will provide neural, cognitive, and psychological insights as to the mental state of their patient (figure1). These indicators, in conjunction with the professional training and medical intuition of the psychiatrist, will lead to more accurate diagnoses [2][3], reduction of unwanted side effects, and significantly fewer accidental overdoses.

This vision will require variety of computational methods for handling EEG data. Therefore, the goal at present is to write code which can effectively read, analyze, manipulate, interpolate, reject, and smooth out EEG data. These actions are the absolute essentials before we begin machine learning analysis. This means our code should be able to open an EEG data file, interpolate electrodes that do not represent neural activity, reject noisy epochs of data, and smooth out signals so we achieve the first step of any EEG preprocessing analysis, which is to reduce noise.

Once noise has been dealt with, we will move to more complicated methods of analysis. Below are few methods of non-linear feature extraction that I think are essential to include in analysis:

## 1) Higuchi's Fractal Dimension (HFD)
    # Can be used on left brain, right brain, or individual electrodes to gauge complexity
    # Very fast computation, minimal CPU requirement
    # Indicates overall signal complexity
    # Useful in diagnosing Alzheimer's Disease & other applications

## 2) Fourier Transforms (FT)
    # This actually can be a linear method
    # Allows to take a complex signal and decompose it into pure frequencies that make it up
    # By identifying individual frequencies, we can see common activity patterns (alpha, beta, gamma, etc.)
    # Very fast computation, minimal CPU requirement
    # Useful in diagnosis of all kinds

## 3) Approximate Entropy (AE)
     # It is often the case that more chaotic EEG data is indicative of neurological conditions (e.g. ADHD)
     # One of the features discussed in quantifying chaos is entropy
     # AE is a method for approximating the amount of the entropy or randomness in a signal
     # This paper has equations for coding approximate entropy:
     (https://translateyar.ir/wp-content/uploads/2018/12/375-English.pdf)

## 4) Largest Lyapunov Exponent (LLE)
    # Lyapunov exponent is also a measure to understand the chaotic behavior of a system
    # If the LLE is positive, then the system has a chaotic behavior.
    # LLE of a time series is defined based on the expansion rate of the differences between consecutive samples


While initially we are concerned solely with back-end development, over time this project will manifest into a comprehensive software package that includes both front and back end.
