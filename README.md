---
title: "README"
author: "Vladislav Mozgovoy"
date: "8/3/2020"
output: 
  html_document:
    keep_md: true
---

## Task 1
Reading data

```r
TestSet <- read.table("./UCI HAR Dataset/test/X_test.txt")#reading from X_test.txt
TestSet_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = " ")#reading from y_test.txt
TestSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = " ")#reading from subject_test.txt
```

Merging test datasets


```r
TestData <- data.frame(TestSubject,TestSet_activity,TestSet)
```

Reading and extracting data from features dataset to assign names to complete test dataset


```r
features_data <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, sep = " ")
features_data <- as.character(features_data[, 2])
names_subject_activity <- c("subject","activity")
names(TestData) <- c(names_subject_activity, features_data)
```

Reading train data

```r
TrainSet <- read.table("./UCI HAR Dataset/train/X_train.txt")#X_train.txt
TrainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = " ")#subject_train.txt
TrainSet_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = " ")#y_train.txt
```

Merging train datasets

```r
TrainData <- data.frame(TrainSubject,TrainSet_activity,TrainSet)
```

Assigning appropriate names to the variables in the train dataset

```r
names(TrainData) <- c(names_subject_activity, features_data)
```

Merging test and train datasets

```r
TotData <- rbind(TestData,TrainData)
```

## Task 2
Extracting the measurements of mean and standard deviation

```r
mean_std_index <- grep("mean|std", features_data)
```

Creating dataset containing only variable names incuding mean and standard deviation in total dataset

```r
subTotData <- TotData[,c(1,2,mean_std_index + 2)]
```


## Task 3
Reading descriptive activity label names dataset

```r
activity_labelNames <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
```

Extracting names from second column of activity labels dataset

```r
activity_labelNames <- as.character(activity_labelNames[,2])
```

Assigning the descriptive activity label names to activity column in subset data set

```r
subTotData$activity <- activity_labelNames[subTotData$activity]
```


## Task 4

```r
subTotDataNames <- names(subTotData)
```

Simplifying names of variables

```r
subTotDataNames <- gsub("^t","T",subTotDataNames)
subTotDataNames <- gsub("^f","F",subTotDataNames)
subTotDataNames <- gsub("Gravity","Grav",subTotDataNames)
subTotDataNames <- gsub("mean","Mean",subTotDataNames)
subTotDataNames <- gsub("std","Std",subTotDataNames)
subTotDataNames <- gsub("[(][)]","",subTotDataNames)
subTotDataNames <- gsub("-","",subTotDataNames)
subTotDataNames <- gsub("X","-X",subTotDataNames)
subTotDataNames <- gsub("Y","-Y",subTotDataNames)
subTotDataNames <- gsub("Z","-Z",subTotDataNames)
```

Renaming variables

```r
names(subTotData) <- subTotDataNames
```


## Task 5
Creating a tidy dataset

```r
TidyData <- aggregate(subTotData[,3:81], by = list(activity = subTotData$activity, subject = subTotData$subject),FUN = mean)
write.table(TidyData, file = "TidyData.txt", row.names = FALSE)
```
