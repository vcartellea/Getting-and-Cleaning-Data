#Code to read every file.
#I use 'stringsAsFactors=FALSE' to avoid messing up factors

activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
features<-read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test<-read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train<-read.table("./UCI HAR Dataset/train/Y_train.txt")

#Simplification of some data frames

features<-features[,2]
subject_test<-subject_test[,1]
Y_test<-Y_test[,1]
subject_train<-subject_train[,1]
Y_train<-Y_train[,1]
activity_labels<-activity_labels[,2]

#Conversion of activity vectors into factors

Y_test<-as.factor(Y_test)
Y_train<-as.factor(Y_train)

#Assigning to activity factors their respective activity label

levels(Y_test)<-activity_labels
levels(Y_train)<-activity_labels

#Creating data frames for each group of measurements: test and train

test<-data.frame(subject=subject_test,activity=Y_test, X_test)
train<-data.frame(subject=subject_train, activity=Y_train, X_train)

#Creating an unique dataset

dataset<-rbind(test, train)

#Assigning correct names to the columns of the dataset

dataset_column_names<-c("Subject", "Activity", features)
#Names contain not valid characters: '-' and '()'
#gsub is used to eliminate that characters, using '_' intead
dataset_column_names<-gsub("\\(\\)", "" , dataset_column_names)
dataset_column_names<-gsub("-", "_" , dataset_column_names)
#gsub is also used to create sef-descriptive variable names
#changes:
# - prefix t is replaced by time
dataset_column_names<-gsub("^t", "time", dataset_column_names)
# - prefix f is replaced by frequency
dataset_column_names<-gsub("^f", "frequency", dataset_column_names)
# - Acc is replaced by Accelerometer
dataset_column_names<-gsub("Acc", "Accelerometer" , dataset_column_names)
# - Gyro is replaced by Gyroscope
dataset_column_names<-gsub("Gyro", "Gyroscope" , dataset_column_names)
# - Mag is replaced by Magnitude
dataset_column_names<-gsub("Mag", "Magnitude" , dataset_column_names)
# - BodyBody is replaced by Body
dataset_column_names<-gsub("BodyBody", "Body" , dataset_column_names)

#Assigning names
names(dataset)<-dataset_column_names

#Filtering dataset to obtain a new dataset containing only "mean" and "std" values

filter1<-grepl("Subject|Activity|mean|std", names(dataset))
dataset<-dataset[,filter1]
filter2<-grepl("meanFreq", names(dataset))
dataset<-dataset[,!filter2]

#Calculating mean by subject and by activity

library(dplyr)
subset<-dataset %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))

#Saving file

write.table(subset, file="subset.txt", row.name=FALSE)
