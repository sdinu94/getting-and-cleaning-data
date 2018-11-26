setwd("C:/Users/Subbadk/Desktop/Personal/02 DS/01 Coursera/01 Data Science/03 Getting and Cleaning Data/Course Project")

filename <- "project.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(URL, destfile =  filename)
}

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

## Explore files and folders after unzipping
list.files(paste0(getwd(),"/UCI HAR Dataset"))
list.files(paste0(getwd(),"/UCI HAR Dataset/train"))
list.files(paste0(getwd(),"/UCI HAR Dataset/test"))

## Load datasets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, x_train)

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, x_test)

## Merge Train and Test datasets
df <- rbind(train, test)

## Get Labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])

## Get Features
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## Keep only mean and sd features
features_mean_sd <- grep(".*mean.*|.*std.*", features[,2]) ##gives row number of features which is about mean and sd. This will be the column number of the corresponding feature in X_train and X_test
features_mean_sd_merged <- features_mean_sd + 2 ## Since we have merged with two columns to the left(Subject and Activity), we need to add 2 to the column number to keep only the required columns

cols_to_keep <- append(c(1, 2), features_mean_sd_merged) ## First 2 columns are Subject and Activities. They should be kept as well

df_final <- df[cols_to_keep]

## Use Descriptive names
features_mean_sd_names <- features[features_mean_sd,2] ## Get all the names of sd and mean features
features_mean_sd_names <- gsub('-mean', '_Mean', features_mean_sd_names) ## Replace '-mean' with '_Mean_'
features_mean_sd_names <- gsub('-std', '_Std', features_mean_sd_names) ## Replace '-std' with '_Std_'
features_mean_sd_names <- gsub('[-()]', '', features_mean_sd_names) ## Remove -()

colnames(df_final) <- c("Subject", "Activity", features_mean_sd_names)

## Subject wise average of feature for each activity
df_final$Activity <- factor(df_final$Activity, levels = activityLabels[,1], labels = activityLabels[,2])
df_final$Subject <- as.factor(df_final$Subject)

library(reshape2)

df_final_melt <- melt(df_final, id = c("Subject", "Activity"))
df_final_avg <- dcast(df_final_melt, Subject + Activity ~ variable, mean)

## Output data
write.table(df_final, "Tidy.txt", row.names = FALSE, quote = FALSE) ## Tidy dataset which is merged and variables properly subsetted and labeled
write.table(df_final_avg, "Subject wise feature average.txt", row.names = FALSE, quote = FALSE) # Subject wise average of features for each activity