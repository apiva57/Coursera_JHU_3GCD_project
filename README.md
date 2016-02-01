---
title: "README"
author: "Anna Shapiro-Mackler"
date: "January 31, 2016"
output:
  html_document:
    keep_md: yes
---

## Project Description
The goal of this project is to process data for Human Activity Recognition Using Smartphones Data Set  from UCI Machine Learning Repository as described in JHU Getting and Cleaning Data class project assignment.

##Files being submitted for the project
1. run_analysis.R - R source code file that contains script for reading, processing and creating tidy data set.
2. tidyDataSet.txt - tidy data set produced by run_analysis.R
3. README.md - high level documentation for the project
4. Codebook.md - variable description in tidySet.txt


##Steps to create required tidy dataset:

### Initial prep:
1. Set working directory into the folder where dataset was downloaded and unzipped. In my case it is: "/Users/anna/OneDrive/Coursera/JHU - Data Science/3. Getting and Cleaning Data/Course Project"
2. Declare functions that I will be using
3. Load package dplyr

### Read data and validate dimensions
1. Data are stored in two different forms: as a train set and test set.
2. Each set has 3 files: subject data has only one column with subject Id, X file has bulk of the data, Y file has activity identification.
3. All 3 files in test/train folder should have the same number of rows. Subject and Y file for test/train should have only one column. Subject files for test and train should have the same number of columns. 
4. After I loaded all files into the data frame I verified that all conditions described in #3 are satisfied.

### Column names cleanup
1. Give proper column names to the subject and activity data
2. Column names in X data frames are described in the features.txt file that is part of original data set. Let's read this file and do some cleanup of the column names: remove all punctuation marks, capitalize Mean and Std so it will be easier to read later ( I decided to use Capitalization in the column names as they are very long and will be very difficult to read if I'll convert all names to lower case ), since later we will be selecting only columns that represent data for mean and standard deviation I ignored all other column names and didn't clean those.
3. Apply cleaned up column names to the test and train data

### Combine test, train, activity and subject data into one data frame
1.  Drop non Mean and non Standard Deviation data from test and train data frames
2.  Combine train data with activityId and subjectId by columns
3.  Combine test data with activityId and subjectId by columns
4.  Combine test and train data by rows.
5.  Replace ActivityId with Activity Name for the entire data frame ( i.e. both train and test data )

### Create a tidy data set and write it to file
1. Group data by subject Id and activity Name and calculate mean for each group
2. Verify dimensions of tidy data set
3. Write tidy data set into the file.