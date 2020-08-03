# reading data

TestSet <- read.table("./UCI HAR Dataset/test/X_test.txt")#reading from X_test.txt
TestSet_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = " ")#reading from y_test.txt
TestSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = " ")#reading from subject_test.txt

# merging test datasets
TestData <- data.frame(TestSubject,TestSet_activity,TestSet)

# reading and extracting data from features dataset to assign names to complete test dataset
features_data <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, sep = " ")
features_data <- as.character(features_data[, 2])

names_subject_activity <- c("subject","activity")
names(TestData) <- c(names_subject_activity, features_data)

# reading train data
TrainSet <- read.table("./UCI HAR Dataset/train/X_train.txt")#X_train.txt
TrainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = " ")#subject_train.txt
TrainSet_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = " ")#y_train.txt

# merging train datasets
TrainData <- data.frame(TrainSubject,TrainSet_activity,TrainSet)

# assigning appropriate names to the variables in the train dataset
names(TrainData) <- c(names_subject_activity, features_data)

# merging test and train datasets
TotData <- rbind(TestData,TrainData)


# Extracting the measurements of mean and standard deviation
mean_std_index <- grep("mean|std", features_data)

# creating dataset containing only variable names incuding mean and standard deviation in total dataset
subTotData <- TotData[,c(1,2,mean_std_index + 2)]


# reading descriptive activity label names dataset
activity_labelNames <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

# extracting names from second column of activity labels dataset
activity_labelNames <- as.character(activity_labelNames[,2])

# assigning the descriptive activity label names to activity column in subset data set
subTotData$activity <- activity_labelNames[subTotData$activity]


subTotDataNames <- names(subTotData)

# simplifying names of variables
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

# renaming variables
names(subTotData) <- subTotDataNames


# creating a tidy dataset
TidyData <- aggregate(subTotData[,3:81], by = list(activity = subTotData$activity, subject = subTotData$subject),FUN = mean)
write.table(TidyData, file = "TidyData.txt", row.names = FALSE)