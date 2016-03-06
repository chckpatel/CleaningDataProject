## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library("data.table")
library("reshape2")

#Download and unzip zip file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- file.path(getwd(), "UCI HAR Dataset.zip")
download.file(url, f)
unzip(f, exdir=getwd())

# 1. Merges the training and the test sets to create one data set.
# 1.0 Read metadata files
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

#features

# 1.1 Read the train sets
trainXDataFeature <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainYDataActivity <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainSubjectData <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

#1.2 Read the test sets
testXDataFeature <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testYDataActivity <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testSubjectData <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)

#1.3 Using rbind and cbind Concatenate the data tables
#1.3.1 Merge subject
MergedSubject <- rbind(trainSubjectData, testSubjectData)
#head(MergedSubject,10)
#1.3.2 Merge Activity
MergedActivity <- rbind(trainYDataActivity, testYDataActivity)
#tail(MergedActivity,10)
#1.3.3 Merge Features
MergedDataFeature <- rbind(trainXDataFeature, testXDataFeature)
#head(MergedDataFeature)

#1.3.4 Assign names to column
colnames(MergedDataFeature) <- t(features[2])
colnames(MergedActivity) <- "Activity"
colnames(MergedSubject) <- "Subject"
#1.3.5 Merge subject, activity and Feature
FinalMergedData <- cbind(MergedDataFeature,MergedActivity,MergedSubject )

#head(FinalMergedData,10)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
DataWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(FinalMergedData), ignore.case=TRUE)
#head(columnsWithMeanSTD)

#2.1 add two more for  activity and subject
DataWithMeanSTDFeatureActivity <- c(DataWithMeanSTD, 562, 563)
FinalData <- FinalMergedData[,DataWithMeanSTDFeatureActivity]

#head(FinalData)

#3 Label Activities

FinalData$Activity <- factor(FinalData$Activity,levels=activities$V1,labels=activities$V2)

#FinalData$Activity
#head(FinalData)

#4. Appropriately labels the data set with descriptive activity names.
#4.1 As labels are abbreviated, substitute  the  label name 
names(FinalData)<-gsub("^t", "Time", names(FinalData))
names(FinalData)<-gsub("^f", "Frequency", names(FinalData))
names(FinalData)<-gsub("-mean()", "Mean", names(FinalData), ignore.case = TRUE)
names(FinalData)<-gsub("-std()", "STD", names(FinalData), ignore.case = TRUE)
names(FinalData)<-gsub("-freq()", "Frequency", names(FinalData), ignore.case = TRUE)
names(FinalData) <- gsub('[-()]', '', names(FinalData))

#5. From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

# 5.1 Converts the subject columns into factors
FinalData$Subject <- as.factor(FinalData$Subject)
FinalData <- data.table(FinalData)

# 5.2 Create a tidy dataset that consists of the average (mean) value of each 
#variable for each subject and activity pair
tidyData <- aggregate(. ~Subject + Activity, FinalData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)

