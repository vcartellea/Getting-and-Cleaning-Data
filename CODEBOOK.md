#Getting and Cleaning Data Course Project (Coursera)

>Codebook for the project of Getting and Cleaning Data Course, available in Coursera.
>This codebook describes the analysis performed by the `run_analysis.R` script, describing the 
>variables, the data and the transformations performed to clean up the raw data in order to create
>a tidy data set. The purpose of the project is to demonstrate the ability to collect, work with,
>and clean a data set. The goal is to prepare a tidy data that can be used for later analysis.

##The data

The raw data set used in the project represent data collected from the accelerometers 
from the Samsung Galaxy S smarthphone. A full description of the raw data set is available
in the [UCI Machine Learning Repository]. The data for the project can be directly downloaded
[here]. Unziping the downloaded file a `UCI HAR Dataset` folder is created, containing all
the files needed for the analysis. This folder must be located in the working directory.

The data set represents a series of experiments carried out with a group of 30 volunteers
within an age bracket of 19-48 years. Each person performed six activities (labelled in the
`activity_labels.txt` file) wearing a smarthphone (Samsung Galaxy S II) on the waist.
Using the embedded accelerometer and gyroscope, a 3-axial linear acceleration and 3-axial angular velocity
at a constant rate of 50 Hz were captured. The dataset has been randomly partitioned into two sets, where 70%
of the volunteers was selected for generating the training data (inside the `./UCI HAR Dataset/train` folder), and 30%
the test data (inside the `./UCI HAR Dataset/test` folder).

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters 
and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window).
The sensor acceleration signal, which has gravitational and body motion components, was separated using a 
Butterworth low-pass filter into body acceleration and gravity. From each window, a vector of 
features was obtained by calculating variables from the time and frequency domain. The last is
expressed in a 561-feature vector (the name of each feature measured is in `features.txt`). 











[UCI Machine Learning Repository]:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
[here]:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 