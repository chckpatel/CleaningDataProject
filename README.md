---
title: "README"
output: html_document
---

This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

#Download and unzip zip file
# 1. Merge the training and the test sets to create one data set.
*  1.0 Read metadata files
*  1.1 Read the train sets
*  1.2 Read the test sets
*  1.3 Using rbind and cbind Concatenate the data tables
*    1.3.1 Merge subject
*    1.3.2 Merge Activity
*    1.3.3 Merge Features
*    1.3.4 Assign names to column
*    1.3.5 Merge subject, activity and Feature

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
* 2.1 add two more for  activity and subject

# 3 Label Activities

# 4. Appropriately label the data set with descriptive activity names.
* 4.1 As labels are abbreviated, substitute  the  label name 


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

* 5.1 Converts the subject columns into factors
* 5.2 Create a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair

