# Comment for file
# This R Script will:
#
# 1.  Merges the training and the test sets to create 
#     one data set.
# 2.  Extract only the measurements on the mean and 
#     standard deviation for each measurement.
# 3.  Uses descriptive activity names to name the activities 
#     in the data set
# 4.  Appropriately label the data set with descriptive 
#     variable names.
# 5.  From the data set in step 4, creates a second, 
#     independent tidy data set with the average of each 
#     variable for each activity and each subject.
###############################################################
#load Libraries
library(dplyr)
library(plyr)
library(data.table)
# Download file and identify files
zipped_file <- "zipped_file.zip"
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",zipped_file)
content <- unzip(zipped_file, list = TRUE)

# unzip files 
unzip(zipped_file)
#unlink(zipped_file)  #remove zip file
files <- content[,1]
for (i in 1:length(files)) {
  # Look at only the txt files
   if(grepl("txt", files[i])){
     
  # using the filename, load the appropriate data  
        if(grepl("/X_test.txt", files[i])){
          test_set_filename <- files[i]
          print(paste("loading", test_set_filename, sep =" "))
          test_set <- read.table(test_set_filename)
        }
        if(grepl("/y_test.txt", files[i])){
          test_activities_filename <- files[i]
          print(paste("loading", test_activities_filename, sep =" "))
          test_activities <- read.table(test_activities_filename)
        }
        if(grepl("/X_train.txt", files[i])){
          train_set_filename <- files[i]
          print(paste("loading", train_set_filename, sep =" "))
          train_set <- read.table(train_set_filename)
        }
        if(grepl("/y_train.txt", files[i])){
          train_activities_filename <- files[i]
          print(paste("loading", train_activities_filename, sep =" "))
          train_activities <- read.table(train_activities_filename)
        }
        if(grepl("activity_labels", files[i])){
          activity_labels_filename <- files[i]
          print(paste("loading", activity_labels_filename, sep =" "))
          activity_labels <- read.table(activity_labels_filename)
        }
         if(grepl("features.txt", files[i])){
           features_filename <- files[i]
           print(paste("loading", features_filename, sep =" "))
           features <- read.table(features_filename)
         }
         if(grepl("subject_train.txt", files[i])){
           train_subjects_filename <- files[i]
           print(paste("loading", train_subjects_filename, sep =" "))
           train_subjects <- read.table(train_subjects_filename)
         }
         if(grepl("subject_test.txt", files[i])){
           test_subjects_filename <- files[i]
           print(paste("loading", test_subjects_filename, sep =" "))
           test_subjects <- read.table(test_subjects_filename)
     }
   }
}
# Rename the column names with Descriptive Variable Names
#
#Funking stuff for duplicate Feature names
features <- mutate(features, Activity = paste(V1,V2,sep = "-"))
features <- select(features,V1,Activity)
#Activities
test_activities <- rename(test_activities, Activity_ID = V1)
train_activities <- rename(train_activities, Activity_ID = V1)
activity_labels <- rename(activity_labels, Activity_ID = V1, Activity = V2)
#Subjects
test_subjects <- rename(test_subjects, Subjects = V1)
train_subjects <- rename(train_subjects, Subjects = V1)
#
#Train and Test Sets
feature_list <- features[,2]
train_columns <- names(train_set)
test_columns <- names(test_set)
setnames(train_set, old=train_columns, new= as.character(feature_list))
setnames(test_set, old=test_columns, new= as.character(feature_list))

#Replace Activity Values with Descriptive Activity Values
test_activities <- merge(test_activities, activity_labels)
test_activities <- select(test_activities, Activity)
train_activities <- merge(train_activities, activity_labels)
train_activities <- select(train_activities, Activity)

# Bind the subjects and activities to the data sets
train_act_sub_set <- cbind(train_activities, train_subjects,train_set)
test_act_sub_set <- cbind(test_activities, test_subjects, test_set)

#merge test and train sets
merged_set <- rbind(train_act_sub_set,test_act_sub_set)

# Extract only mean and standard Deviation Variables
mean_std_data_set <- select(merged_set,Activity,Subjects, contains("mean",ignore.case=TRUE), contains("std()"))

#Create my "Tity Data Set" with the average of each 
#     variable for each activity and each subject
tity_data <- ddply(mean_std_data_set, .(Subjects, Activity), numcolwise(mean))
View(tity_data)

