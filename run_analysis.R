##Get the data
#1.**Download the file and put the file  in the 'Project' folder**

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
setwd("C:\CourseProject")
download.file(fileUrl,destfile="./Dataset.zip")

#2. Unzip the file
unzip(zipfile = "Dataset.zip")

#3.unzipped files are in the folder`UCI HAR Dataset`. List the files

path_ref <- file.path("./" , "UCI HAR Dataset")
files<-list.files(path_ref, recursive=TRUE)

#Read data from target files - The folder has 28 files
# "features.txt" - Names of Varibles of `Features`
# "activity_labels.txt" - level labels of Activity
# "Y_train.txt" and  "Y_test.txt" - Values of Activity variable
# "subject_train.txt" and  subject_test.txt"  - values of Subject variable
# "X_train.txt" and  "X_test.txt" - values of Features variable

#Activity Files
ActivityDataTest <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ActivityDataTrain <- read.table(file.path(path_rf, "train" , "Y_train.txt" ),header = FALSE)

#Subject Files
SubDataTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
SubDataTest <- read.table(file.path(path_rf, "test", "subject_test.txt"),header = FALSE)

# Features Files
FeaturesTest <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#1# Merges the training and the test sets to create one data set.

#join tables by rows
SubData <- rbind(SubDataTrain, SubDataTest)
ActData <- rbind(ActivityDataTrain, ActivityDataTest)
FeaData <- rbind(FeaturesTrain, FeaturesTest)

#Set names to variables
names(SubData)<-c("subject")
names(ActData) <- c("activity")
FeaDataNames <- read.table(file.path(path_ref, "features.txt"),head=FALSE)
names(FeaData)<- FeaDataNames$V2

#Merge all columns to get a Data Frame
Combine1 <- cbind(SubData, ActData)
AllData<-subset(Data,select=selectedNames)
Data <- cbind(FeaData, Combine1)

#2# Extracts only the measurements on the mean and standard deviation for each measurement.
#Extract a subset of data with Feature names of Mean (mean()) and Standard Deviation (std())

SubsetFeaturesNames<-FeaDataNames$V2[grep("mean\\(\\)|std\\(\\)", FeaDataNames$V2)]

#selected names of Feature
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
AllData<-subset(AllData,select=selectedNames)

#3# Uses descriptive activity names to name the activities in the data set
#Read activity names from "activity_labels.txt"

activityLabels <- read.table(file.path(path_ref, "activity_labels.txt"),header = FALSE)

#Descriptive activity name assignment
AllData$activity<-factor(AllData$activity);
AllData$activity<- factor(AllData$activity,labels=as.character(activityLabels$V2))

#4# Appropriately labels the data set with descriptive variable names.
# t by Time
# Acc by "Accelerometer"
# Gyro by "Gyroscope"
# Mag by "Magnitude"
# f by "Frequency"
# BodyBody by "Body"

names(AllData) <- gsub("^t","Time",names(AllData))
names(AllData) <- gsub("^f","Frequency",names(AllData))
names(AllData) <- gsub("Acc","Accelerometer",names(AllData))
names(AllData) <- gsub("Gyro","Gyroscope",names(AllData))
names(AllData) <- gsub("Mag","Magnitude",names(AllData))
names(AllData) <- gsub("BodyBody", "Body", names(AllData))

#5# From the data set in step 4, creates a second, independent tidy data set with the 
##  average of each variable for each activity and each subject.

install.packages("plyr")
library(plyr);
AllData2 <- aggregate(. ~subject + activity, AllData, mean)
AllData2 <- AllData2[order(AllData2$subject,AllData2$activity),]
write.table(AllData2, file = "tidydata.txt",row.name=FALSE)

