# set working directory
setwd("/Users/anna/OneDrive/Coursera/JHU - Data Science/3. Getting and Cleaning Data/Course Project")

# functions I will use
pkgTest <- function(x)
{
      if (!require(x,character.only = TRUE))
      {
            install.packages(x,dep=TRUE)
            if(!require(x,character.only = TRUE)) stop("Package not found")
      }
}

readFile <- function (fileName)
{
      str1 <- paste(parentDirName, dirName, fileName, sep = "/")
      str2 <- paste(str1, dirName, sep = "_")
      fName <- paste(str2, ".txt", sep = "")
      df <- read.table(fName)
}
# load required packages
pkgTest("dplyr")
library(dplyr)

# set some variables to read the files
parentDirName <- "UCI HAR Dataset"
dirName <- "test"
subject_test_df <- readFile("subject")
x_test_df <- readFile("X")
y_test_df <- readFile("y")
dirName <- "train"
subject_train_df <- readFile("subject")
x_train_df <- readFile("X")
y_train_df <- readFile("y")

# check dimensions for all data frames that we just read
dim(subject_test_df)
dim(x_test_df)
dim(y_test_df)
dim(subject_train_df)
dim(x_train_df)
dim(y_train_df)

# let's get column names in order
colnames(subject_test_df) <- "subjectId"
colnames(subject_train_df) <- "subjectId"
colnames(y_test_df) <- "activityId"
colnames(y_train_df) <- "activityId"
featuresNamesDf <- read.table(paste(parentDirName, "/features.txt", sep = ""))
featuresNamesDf <- mutate(featuresNamesDf, betterName = gsub("-", "", V2))
featuresNamesDf <- mutate(featuresNamesDf, betterName = sub("std..", "Std", betterName))
featuresNamesDf <- mutate(featuresNamesDf, betterName = sub("meanFreq..", "MeanFreq", betterName))
featuresNamesDf <- mutate(featuresNamesDf, betterName = sub("mean..", "Mean", betterName))
featuresNamesDf <- mutate(featuresNamesDf, betterName = sub("angle.tBody", "angleTBody", betterName))
featuresNamesDf <- mutate(featuresNamesDf, betterName = sub("angle.X", "angleX", betterName))
featuresNamesDf <- mutate(featuresNamesDf, betterName = sub("angle.Y", "angleY", betterName))
featuresNamesDf <- mutate(featuresNamesDf, betterName = sub("angle.Z", "angleZ", betterName))
featuresNamesDf <- mutate(featuresNamesDf, betterName = sub(",gravityMean.", "GravityMean", betterName))
featuresNamesDf <- mutate(featuresNamesDf, betterName = sub(",gravity.", "Gravity", betterName))
featuresNamesDf <- mutate(featuresNamesDf, betterName = sub("angleTBodyAccJerkMean.GravityMean", "angleTBodyAccJerkMeanGravityMean", betterName))
colnames(x_train_df) <- featuresNamesDf$betterName
colnames(x_test_df) <- featuresNamesDf$betterName

# let's get only mean and std columns from x_test_df and x_train_df
subset_test_df <- x_test_df[,grepl("Std|Mean", featuresNamesDf$betterName)]
subset_train_df <- x_train_df[,grepl("Std|Mean", featuresNamesDf$betterName)]
# check that dimensions and column names still make sense
dim(subset_train_df)
dim(subset_test_df)
colnames(subset_train_df)
colnames(subset_test_df)

# combine test and train data into one data frame
test_df <- bind_cols(subset_test_df, subject_test_df, y_test_df)
train_df <- bind_cols(subset_train_df, subject_train_df, y_train_df)
df <- bind_rows(test_df, train_df)
# check that dimensions and column names still make sense
dim(df)      
colnames(df)

# need to replace activityId with activity name, first read activity Id and 
# Name from the file. Than substitute activityId with activityName in the df
activitiesDf <- read.table(paste(parentDirName, "/activity_labels.txt", sep = ""), col.names = c("id","activityName"))
activityName <- activitiesDf[match(df$activityId, activitiesDf$id), "activityName"]
df <- bind_cols(df, as.data.frame(activityName))
df$activityId <- NULL
# check that dimensions and column names still make sense
dim(df)      
colnames(df)

# Let's create a tidy dataset with the average of each variable 
# for each activity and each subject and write it into output file
tidyData <- df %>%
      group_by(subjectId, activityName) %>%
      summarise_each(funs(mean(., na.rm=TRUE)))
dim(tidyData)
write.table(tidyData, file = "tidyDataSet.txt", row.names = FALSE)

