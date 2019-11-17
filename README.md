# Getting-and-Cleaning-Data
library(plyr)
library(dplyr)
#Dermining file destination
if(!file.exists("./data")){dir.create("./data")}

## Data download and unzip 
# String variables for file download
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/UIC.zip", method = "curl")
UICfolder <- unzip("./data/UIC.zip")
trainingRows <- grep("(.)*train(.)*", UICfolder, ignore.case = TRUE)
testRows <- grep("(.)*test(.)*", UICfolder, ignore.case = TRUE)

# Update test and training data based on text file description
subjectTrain<- UICfolder[trainingRows[10]]
Xtrain <- UICfolder[trainingRows[11]]
Ytrain <- UICfolder[trainingRows[12]]
subjecttest <- UICfolder[testRows[10]]
Xtest <- UICfolder[testRows[11]]
Ytest <- UICfolder[testRows[12]]

#  Reading text files for training and test data
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityId","activityType"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
subject_test <- read.table(subjecttest, col.names = "subId")
subject_train <- read.table(subjectTrain, col.names = "subId")
x_test <- read.table(Xtest, col.names = features$functions)
x_train <- read.table(Xtrain, col.names = features$functions)
y_test <- read.table(Ytest, col.names = "activityId")
y_train <- read.table(Ytrain, col.names = "activityId")

# Merging Data
subjectdata <- rbind(subject_train,subject_test)
x_data <- rbind(x_train,x_test)
y_data <- rbind(y_test,y_train)
finaldata <- cbind(subjectdata,x_data,y_data)

preTidyData <- finaldata %>% select(subId, activityId, contains("mean"), contains("std"))

names(preTidyData) <- gsub("\\(|\\)", "", names(preTidyData), perl  = TRUE)

names(preTidyData) <- gsub("Acc", "Acceleration", names(preTidyData))
names(preTidyData) <- gsub("^t", "Time", names(preTidyData))
names(preTidyData) <- gsub("^f", "Frequency", names(preTidyData))
names(preTidyData) <- gsub("BodyBody", "Body", names(preTidyData))
names(preTidyData) <- gsub("mean", "Mean", names(preTidyData))
names(preTidyData) <- gsub("std", "Std", names(preTidyData))
names(preTidyData) <- gsub("Freq", "Frequency", names(preTidyData))
names(preTidyData) <- gsub("Mag", "Magnitude", names(preTidyData))

names(preTidyData)

TidyData <- preTidyData %>%
  group_by(subId, activityId) %>%
  summarise_all(funs(mean))

names(TidyData)
