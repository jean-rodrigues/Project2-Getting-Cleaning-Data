## download file

## combine train and test data
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
one_train_test_data <- rbind(train_data, test_data)

## combine train and test labels
train_label <- read.table("UCI HAR Dataset/train/y_train.txt")
test_label <- read.table("UCI HAR Dataset/test/y_test.txt")
one_train_test_label <- rbind(train_label, test_label)

## combine train and test subjects
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
one_train_test_subject <- rbind(train_subject, test_subject)

## obtain features
features <- read.table("UCI HAR Dataset/features.txt")
selectedFeatures <-  features[grepl("mean|std", features$V2, ignore.case = TRUE),]

## obtain activies
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

## merged labels
labels <- merge(x=activities, y=one_train_test_label, by="V1", all.y=TRUE)
## combine all data together
tidy_data <- one_train_test[,selectedFeatures$V1]

tidy_data <- cbind(tidy_data, one_train_test_subject)
tidy_data <- cbind(tidy_data, label=labels)
## only the features we need
colnames(tidy_data) <- c(as.character(selectedFeatures$V2), "subjectID", "activityID", "label") 


tidy_data_final <- transform(tidy_data, subjectID=factor(subjectID), activityID=factor(activityID), label=factor(label))
colnames(tidy_data_final) <- c(as.character(selectedFeatures$V2), "subjectID", "activityID", "label") 

tidy_data_final <-  aggregate(. ~ subjectID + activityID + label, FUN = mean, data=tidy_data_final)
write.table(tidy_data_final, "final_data.txt", row.names=F)


