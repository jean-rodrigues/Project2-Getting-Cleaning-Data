---
title: "CodeBook"
author: "Jean Rodrigues"
date: "Sunday, November 23, 2014"
---

In order to achieve the objective of producing the request tidy data, the following steps were executed:

- Read contents from *train/X_train.txt*;
- Read contents from *test/X_test.txt*;
- Both of these files were merged together with the function *rbind*: (rows were merged together creating **one_train_test** variable);

- Read contents from *train/y_train.txt*;
- Read contents from *test/y_test.txt*;
- Both of these files were merged together with the function *rbind*: (rows were merged together creaing **one_train_test_label** variable);

- Read contents from *train/subject_train.txt*;
- Read contents from *test/subject_test.txt*;
- Both of these files were merged together with the function *rbind*: (rows were merged together creating **one_train_test_subject** variable);

Now it is necessary to read the features and select only those that were related to the mean or std metrics of the variables collected. In order to accomplish this task, the function grepl was applied (producing a logical vector of the item that contained the strings **std** and **mean**)

```{r tidy=FALSE}
features <- read.table("UCI HAR Dataset/features.txt")
selectedFeatures <-  features[grepl("mean|std", features$V2, ignore.case = TRUE),]
tidy_data <- one_train_test[,selectedFeatures$V1]
```

**tidy_data** will contain only the selected features from **one_train_test**.

- Read activities labels *activity_labels.txt*:

Now we need to merge together the labels of the activities with the files *y_train.txt* and *y_test.txt* (that are already merged in the variable named **one_train_test_label**).

```{r}
labels <- merge(x=activities, y=one_train_test_label, by="V1", all.y=TRUE)
```


Now we bind all the columns together of the previous merged variables:

```{r tidy=FALSE}
tidy_data <- cbind(tidy_data, one_train_test_subject)
tidy_data <- cbind(tidy_data, label=labels)
```


Define appropriate names for the columns in the data set:

```{r}
colnames(tidy_data) <- c(as.character(selectedFeatures$V2), "subjectID", "activityID", "label") 
```

Transform some variables into factors in order to summarize the mean for subject and labels (as requested for the new independent tidy data set):

```{r tidy=FALSE}
tidy_data_final <- transform(tidy_data, subjectID=factor(subjectID), activityID=factor(activityID), label=factor(label))
colnames(tidy_data_final) <- c(as.character(selectedFeatures$V2), "subjectID", "activityID", "label") 
```

We reapplied the previous column names to this data set as well.


Then we just aggregate on the data and produce the tidy data file:

```{r tidy=FALSE}
tidy_data_final <-  aggregate(. ~ subjectID + activityID + label, FUN = mean, data=tidy_data_final)
write.table(tidy_data_final, "final_data.txt", row.names=F)
```






