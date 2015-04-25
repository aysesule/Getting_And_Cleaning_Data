# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)

setwd("D:/coursera/Getting_And_Cleaning_Data")


# get test data
message("Getting the test data")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# get train data
message("Getting the training data")

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


# merge test and train data
message("Mergin the training and test data")

x_merged <- rbind(X_train, X_test)
y_merged <- rbind(y_train, y_test)
subject_merged <- rbind(subject_train, subject_test)
merged <- list(x=x_merged, y=y_merged, subject=subject_merged)

# get the mean and std columns
features <- read.table("./UCI HAR Dataset/features.txt")

means <- sapply(features[,2], function(x) grepl("mean", x, fixed=T))
stds <- sapply(features[,2], function(x) grepl("std", x, fixed=T))

message("Setting Measurment data")

# Set 1: cx measurment
df <- merged$x[, (means | stds)]
colnames(df) <- features[(means | stds), 2]
cx <- df

message("Getting Activities ")

# Set 2: cy activities 
ydf <- merged$y
names(ydf) <- "activity"
ydf$activity[ydf$activity == 1] = "WALKING"
ydf$activity[ydf$activity == 2] = "WALKING_UPSTAIRS"
ydf$activity[ydf$activity == 3] = "WALKING_DOWNSTAIRS"
ydf$activity[ydf$activity == 4] = "SITTING"
ydf$activity[ydf$activity == 5] = "STANDING"
ydf$activity[ydf$activity == 6] = "LAYING"
cy <- ydf

# Set 3: Subject
colnames(merged$subject) <- c("subject")

# combine all sets: cx, cy and subject
comb <- cbind(cx, cy, merged$subject)

result <- ddply(comb, .(subject, activity), function(x) colMeans(x[,1:60]))
write.table(result, "./W2Project/UCI_HAR_tidy.txt", row.names=FALSE)

message("Finished, output file is: ./UCI_HAR_tidy.txt ")


  