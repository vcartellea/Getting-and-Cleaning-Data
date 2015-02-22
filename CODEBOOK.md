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

The test and train datasets (in `./UCI HAR Dataset/test` and `./UCI HAR Dataset/train` folders) comprises three types 
of text files that are used in the analysis:
 - A file referring the volunteer identification of each measurement: `subject_test.txt` and `subject_train.txt`.
 - A file with the activity performed during each measurement (codified as numbers): `Y_test.txt` and `Y_train.txt`. 
 - A bigger file with the 561-feature vector: `X_test.txt` and `X_train.txt`.
 
 ##The R script
 
 The course project says:
 
> You should create one R script called run_analysis.R that does the following 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive variable names. 
> 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
 The R script named `run_analysis.R` prepares a tidy dataset from the raw dataset. 
 The raw dataset must be in a unzip folder named `UCI HAR Dataset` in the working directory. The procedure
 follows a different order from the one specified in the list above in order to simplify some steps like filtering.
 
 1. The first section of the code reads the text files containing the data using the `read.table()` function.
 This data is assigned to a variable with the same name as the text file. To avoid messing up the data with factors, the
 argument 'stringsAsFactors=FALSE' is used.
 
>>activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
>>features<-read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
>>subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
>>X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
>>Y_test<-read.table("./UCI HAR Dataset/test/Y_test.txt")
>>subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
>>X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
>>Y_train<-read.table("./UCI HAR Dataset/train/Y_train.txt")
 
 2. The data.frames containing activity labels, subjects and features labels (corresponding to features.txt, activity_labels.txt, Y_test.txt and Y_train.txt),
 are converted to vectors by subsetting (using `[]`).
 
 >>features<-features[,2]
subject_test<-subject_test[,1]
Y_test<-Y_test[,1]
subject_train<-subject_train[,1]
Y_train<-Y_train[,1]
activity_labels<-activity_labels[,2]
 
 3. Activity data is converted to factors to assign self-descriptive labels, using `as.factor()` and `levels()` functions.
 
 >>Y_test<-as.factor(Y_test)
Y_train<-as.factor(Y_train)
levels(Y_test)<-activity_labels
levels(Y_train)<-activity_labels
 
 4. Two data frames are created joining subject, activity and measurements for each group (test and train), using `data.frame()` function. Using this data.frames, a unique dataset for both groups is created using `cbind()` function.
 
 >>test<-data.frame(subject=subject_test,activity=Y_test, X_test)
train<-data.frame(subject=subject_train, activity=Y_train, X_train)
dataset<-rbind(test, train)

 5. Before filtering data to maintain only the measurements relative to mean() and std() values, 
 an appropriate label is assigned to the columns of the dataset (to make filtering easy). The labels are included in 'features.txt' file, however, this
 includes characters that can`t be used as names in R (the characters "-" and "()"). This characters are replaced by a more addecuated ones
 using the function `gsub()`. A vector with the features names is created to perform corrections.
 
 >>dataset_column_names<-c("Subject", "Activity", features)
 dataset_column_names<-gsub("\\(\\)", "" , dataset_column_names)
dataset_column_names<-gsub("-", "_" , dataset_column_names)

 6. Using the same `gsub()` function, self-descriptive names for features are generated, replacing the following characters:
 * t prefix is replaced by time
 * f prefix is replaced by frequency
 * Acc is replaced by Accelerometer
 * Gyro is replaced by Gyroscope
 * Mag is replaced by Magnitude
 * BodyBody is replaced by Body
 
 >>dataset_column_names<-gsub("^t", "time", dataset_column_names)
dataset_column_names<-gsub("^f", "frequency", dataset_column_names)
dataset_column_names<-gsub("Acc", "Accelerometer" , dataset_column_names)
dataset_column_names<-gsub("Gyro", "Gyroscope" , dataset_column_names)
dataset_column_names<-gsub("Mag", "Magnitude" , dataset_column_names)
dataset_column_names<-gsub("BodyBody", "Body" , dataset_column_names)

 7. Names are assigned to each column of the dataset using `names()` function.
 
 >>names(dataset)<-dataset_column_names
 
 8. Using the column names, de dataset is filtered to maintain only the measurements relative
 to mean() and std(). The function `grepl()` is used to generate the filters. A 'filter1' is used to
 select only the columns with "Subject", "Activity", "mean" of "std" in the column name. A 'filter2' is 
 again used to eliminate from the generated subset the columns relative to "meanFreq".
 
 >>filter1<-grepl("Subject|Activity|mean|std", names(dataset))
dataset<-dataset[,filter1]
filter2<-grepl("meanFreq", names(dataset))
dataset<-dataset[,!filter2]

 9. 
 
 
 
 
 ##The variables
 
 
 tBodyAcc-mean-X <- timeBodyAccelerometer-mean-X
 
 
 
 
 
 
[UCI Machine Learning Repository]:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
[here]:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 