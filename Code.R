library(dplyr)


if(!file.exists("./data")){dir.create("./data")}

url <- 
  "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/UIC.zip", method = "curl")
UICfolder <- unzip("./data/UIC.zip")

#figuring out what files to read using regular expression
trainingRows <- grep("(.)*train(.)*", UICfolder, ignore.case = TRUE)
testRows <- grep("(.)*test(.)*", UICfolder, ignore.case = TRUE)

subjectTrain <- UICfolder[trainingRows[10]]
Xtrain <- UICfolder[trainingRows[11]]
Ytrain <- UICfolder[trainingRows[12]]
subjecttest <- UICfolder[testRows[10]]
Xtest <- UICfolder[testRows[11]]
Ytest <- UICfolder[testRows[12]]

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                              col.names = c("activityId","activityType"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
subject_test <- read.table(subjecttest, col.names = "subId")
subject_train <- read.table(subjectTrain, col.names = "subId")
x_test <- read.table(Xtest, col.names = features$functions)
x_train <- read.table(Xtrain, col.names = features$functions)
y_test <- read.table(Ytest, col.names = "activityId")
y_train <- read.table(Ytrain, col.names = "activityId")

subjectdata <- rbind(subject_train,subject_test)
x_data <- rbind(x_train,x_test)
y_data <- rbind(y_test,y_train)
finaldata <- cbind(subjectdata,x_data,y_data)

preTidyData <- finaldata %>% select(subId, activityId, contains("mean"), contains("std"))

names(preTidyData) <- gsub("\\(|\\)", "", names(preTidyData), perl  = TRUE)

names(preTidyData) <- gsub("Acc", "acceleration", names(preTidyData))
names(preTidyData) <- gsub("^t", "time", names(preTidyData))
names(preTidyData) <- gsub("^f", "frequency", names(preTidyData))
names(preTidyData) <- gsub("BodyBody", "body", names(preTidyData))
names(preTidyData) <- gsub("mean", "mean", names(preTidyData))
names(preTidyData) <- gsub("Freq", "frequency", names(preTidyData))
names(preTidyData) <- gsub("Mag", "magnitude", names(preTidyData))

TidyData <- preTidyData %>%
  group_by(subId, activityId) %>%
  summarise_all(funs(mean))

write.table(TidyData, "TidyData.txt", row.name=FALSE)