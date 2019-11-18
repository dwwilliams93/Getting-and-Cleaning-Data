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

````{r}
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



# fhodksh


