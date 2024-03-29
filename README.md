## Coursera Final Project guidelines

1. The submitted data set is tidy.
2. The Github repo contains the required scripts.
3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
5. The README that explains the analysis files is clear and understandable.
6. The work submitted for this project is the work of the student who submitted it.


## Downloading appropriate packages
```{r cars}
library(dplyr)
```

`dplyr` will be used later on in the cleaning process.

## Designating working directory
```{r pressure, echo=FALSE}
if(!file.exists("./data")){dir.create("./data")}
```

Determining if the folder desitnation exists and if not to create one.

## Data download and unzip 
```{r}
# String variables for file download
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/UIC.zip", method = "curl")
UICfolder <- unzip("./data/UIC.zip")
```

`UICfolder` <- `unzip("./data/UIC.zip")` had 1 column and 28 rows of .txt file, i.e. the `UICfoler` contained 28 different flat text files.

```{r}
#figuring out what files to read using regular expression
trainingRows <- grep("(.)*train(.)*", UICfolder, ignore.case = TRUE)
testRows <- grep("(.)*test(.)*", UICfolder, ignore.case = TRUE)
```

Both the `trainingRows` and `testingRows` search with regular expression resulted in 12 hits. Whereas, output from the above mentioned datasets lead to the understanding that only the last 3 (10-12) were important for this analysis.

## Saving values for to plug into the `read.table` function
```{r}
# Update test and training data based on text file description
subjectTrain <- UICfolder[trainingRows[10]]
Xtrain <- UICfolder[trainingRows[11]]
Ytrain <- UICfolder[trainingRows[12]]
subjecttest <- UICfolder[testRows[10]]
Xtest <- UICfolder[testRows[11]]
Ytest <- UICfolder[testRows[12]]
```

Using the finding from the regular expression to prepare for reading the text file while minimizing the chances for typos.

# Reading text files of designated dataset and renaming column names

```{r}
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
    col.names = c("activityId","activityType"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
subject_test <- read.table(subjecttest, col.names = "subId")
subject_train <- read.table(subjectTrain, col.names = "subId")
x_test <- read.table(Xtest, col.names = features$functions)
x_train <- read.table(Xtrain, col.names = features$functions)
y_test <- read.table(Ytest, col.names = "activityId")
y_train <- read.table(Ytrain, col.names = "activityId")
```


## Table 1: size of tables from cooresponding text files

File Name          | # of obs. | # of variables
-------------------|:---------:|----------------:
`activity_labels`  |   6       |      2
`features`         |  561      |      2
`subject_test`     |  2947     |      1
`subject_train`    |  7352     |      1
`x_test`           |  2947     |     561
`x_train`          |  7352     |     561
`y_test`           |  2947     |      1
`y_train`          |  7352     |      1


## Merging Data
```{r}
subjectdata <- rbind(subject_train,subject_test)
x_data <- rbind(x_train,x_test)
y_data <- rbind(y_test,y_train)
finaldata <- cbind(subjectdata,x_data,y_data)
```

`rbind` was used to combine `subject_train` with `subject_test`, `x_train` with `x_test`, and `y_test` with `y_train` while `cbind` was used to combine the priviously merged datasets `subjectdata` , `x_data`, and `y_data`.


Table 2: size of tables after merging the files

File Name          | # of obs. | # of variables
-------------------|-----------|----------------
`subjectdata`      |  10299    |      1
`x_data`           |  10299    |     561
`y_data`           |  10299    |      1
`finaldata`        |  10299    |     563

## Selecting appropriate columns with `dplyr`
```{r}
preTidyData <- finaldata %>% select(subId, activityId, contains("mean"), contains("std"))
```

`preTidyData` was derived from selecting the column names that contained "mean" and "std", which resulted in a dataset with 10299 obs. and 88 variables

## Cleaning up the column names
```{r}
names(preTidyData) <- gsub("\\(|\\)", "", names(preTidyData), perl  = TRUE)
```

## Changing column names to more descriptive titles
```{r}
names(preTidyData) <- gsub("Acc", "acceleration", names(preTidyData))
names(preTidyData) <- gsub("^t", "time", names(preTidyData))
names(preTidyData) <- gsub("^f", "frequency", names(preTidyData))
names(preTidyData) <- gsub("BodyBody", "body", names(preTidyData))
names(preTidyData) <- gsub("mean", "mean", names(preTidyData))
names(preTidyData) <- gsub("Freq", "frequency", names(preTidyData))
names(preTidyData) <- gsub("Mag", "magnitude", names(preTidyData))
```

## Grouping and sumarizing the data 
```{r}
TidyData <- preTidyData %>%
  group_by(subId, activityId) %>%
  summarise_all(funs(mean))
```

This two step procedure lead to `Tidydata` having 180 obs. and 88 variables

## Checking structure of the data
```{r}
names(TidyData)
```

## Writing text file
```{r}
write.table(TidyData, "TidyData.txt", row.name=FALSE)
```
