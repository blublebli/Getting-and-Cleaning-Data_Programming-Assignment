## setting the wd, downloading and unzipping the data
coursera3 <- "Coursera_DS3_Final.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "C:/Users/Standard/OneDrive/Desktop/coursera3/Dataset.zip")

if (!file.exists("UCI HAR Dataset")) { 
        unzip(coursera3) 
}

data <- unzip("Dataset.zip")


##assigning the data frames
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## merging specified data
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
mergeddata <- cbind(Subject, X, Y)

## extracting means and standard deviations for each measurement
tidydata <- mergeddata %>% select(subject, code, contains("mean"), contains("std"))

## descriptively naming the activities in the data set
tidydata$code <- activities[tidydata$code, 2]

## labeling the dataset with descriptive variable names
names(tidydata)[2] = "activity"
names(tidydata)<-gsub("Acc", "Accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))

## crating a second tidy dataset from the dataset in step 4 - with the average of each variable, activity and subject

secondtidy <- tidydata %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(secondtidy, "secondtidy.txt", row.names = FALSE)
str(secondtidy)
