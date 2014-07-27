##Script run_analysis.R
##This script:

##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement. 
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names. 
##Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


##Libraries required.
library(plyr)
library(reshape2)

##Load the files that will be used.
x_train <- read.table("train//X_train.txt") ##Train data.
y_train <- read.table("train//y_train.txt") ##Activity carried out by subjects. (train)
x_test <- read.table("test//X_test.txt") ##Test data.
y_test <- read.table("test//y_test.txt") ##Activity carried out by subjects. (test)
subject_train <- read.table("train//subject_train.txt") ##Subject where measurements where taken. (train)
subject_test <- read.table("test/subject_test.txt") ##Subject where measurements where taken. (test)
features <- read.table("features.txt") ##Columns names.
activity_labels <- read.table("activity_labels.txt") ##Description of the activities(names).

##Save and assign columns and rows names.
columns <- features$V2
columns <- as.character(columns) 
rows <- activity_labels$V2
rows <- as.character(rows)
colnames(x_train) <- columns
colnames(x_test) <- columns

##Merge activities and labels(train)
train_activity <- join(y_train, activity_labels)
train_activity$V1 <- NULL ##Remove activity number.
##Merge activities and labels(test)
test_activity <- join(y_test, activity_labels)
test_activity$V1 <- NULL ##Remove activity number.


##Asign columns names.
colnames(test_activity) <- "Activity"
colnames(train_activity) <- "Activity"
colnames(subject_test) <- "Subject"
colnames(subject_train) <- "Subject"

##Create new file with Activity, Subject and train data.
train <- cbind(train_activity, subject_train, x_train)
##Create new file with Activity, Subject and test data.
test <- cbind(test_activity, subject_test, x_test)

##Merge train and test files.
whole_file <- rbind(train, test)

##Create file with only the measurements on the mean and standard deviation for each measurement.
means_and_stds <- whole_file[ , grep('-mean\\(\\)|-std\\(\\)', colnames(whole_file))]
means_and_stds$Activity <- whole_file$Activity
means_and_stds <- cbind(Activity = means_and_stds$Activity, means_and_stds[ , -c(67)])

##Create a independent tidy data set with the average of each variable for each activity and each subject.
melted_file <- melt(whole_file, id.vars=c("Subject", "Activity"))
tidy_data <- dcast(melted_file, Subject+Activity~variable, mean)

##Save tidy Data.
write.table(tidy_data, "tidy_data.txt", row.names=FALSE)

