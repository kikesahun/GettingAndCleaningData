library(plyr)
if(!file.exists("./data")){dir.create("./data")}
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

##### 1.Merges the training and the test sets to create one data set

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
single <- rbind(merge_train, merge_test)

##### 2.Extracts only the measurements on the mean and standard deviation for each measurement

colNames <- colnames(single)
mean_y_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames))

setMeanYdStd <- single[ , mean_y_std == TRUE]

##### 3.Uses descriptive activity names to name the activities in the data set

setActivityNames <- merge(setMeanYStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

##### 4.Appropriately labels the data set with descriptive variable names (already done previously)

##### 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

newSet <- aggregate(. ~subjectId + activityId, setActivityNames, mean)
newSet <- newSet[order(newSet$subjectId, newSet$activityId),]

write.table(newSet, "newSet.txt", row.name=FALSE)

