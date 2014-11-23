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

The following features were selected (86 variables/features):
V1  V2
1	tBodyAcc-mean()-X
2	tBodyAcc-mean()-Y
3	tBodyAcc-mean()-Z
4	tBodyAcc-std()-X
5	tBodyAcc-std()-Y
6	tBodyAcc-std()-Z
41	tGravityAcc-mean()-X
42	tGravityAcc-mean()-Y
43	tGravityAcc-mean()-Z
44	tGravityAcc-std()-X
45	tGravityAcc-std()-Y
46	tGravityAcc-std()-Z
81	tBodyAccJerk-mean()-X
82	tBodyAccJerk-mean()-Y
83	tBodyAccJerk-mean()-Z
84	tBodyAccJerk-std()-X
85	tBodyAccJerk-std()-Y
86	tBodyAccJerk-std()-Z
121	tBodyGyro-mean()-X
122	tBodyGyro-mean()-Y
123	tBodyGyro-mean()-Z
124	tBodyGyro-std()-X
125	tBodyGyro-std()-Y
126	tBodyGyro-std()-Z
161	tBodyGyroJerk-mean()-X
162	tBodyGyroJerk-mean()-Y
163	tBodyGyroJerk-mean()-Z
164	tBodyGyroJerk-std()-X
165	tBodyGyroJerk-std()-Y
166	tBodyGyroJerk-std()-Z
201	tBodyAccMag-mean()
202	tBodyAccMag-std()
214	tGravityAccMag-mean()
215	tGravityAccMag-std()
227	tBodyAccJerkMag-mean()
228	tBodyAccJerkMag-std()
240	tBodyGyroMag-mean()
241	tBodyGyroMag-std()
253	tBodyGyroJerkMag-mean()
254	tBodyGyroJerkMag-std()
266	fBodyAcc-mean()-X
267	fBodyAcc-mean()-Y
268	fBodyAcc-mean()-Z
269	fBodyAcc-std()-X
270	fBodyAcc-std()-Y
271	fBodyAcc-std()-Z
294	fBodyAcc-meanFreq()-X
295	fBodyAcc-meanFreq()-Y
296	fBodyAcc-meanFreq()-Z
345	fBodyAccJerk-mean()-X
346	fBodyAccJerk-mean()-Y
347	fBodyAccJerk-mean()-Z
348	fBodyAccJerk-std()-X
349	fBodyAccJerk-std()-Y
350	fBodyAccJerk-std()-Z
373	fBodyAccJerk-meanFreq()-X
374	fBodyAccJerk-meanFreq()-Y
375	fBodyAccJerk-meanFreq()-Z
424	fBodyGyro-mean()-X
425	fBodyGyro-mean()-Y
426	fBodyGyro-mean()-Z
427	fBodyGyro-std()-X
428	fBodyGyro-std()-Y
429	fBodyGyro-std()-Z
452	fBodyGyro-meanFreq()-X
453	fBodyGyro-meanFreq()-Y
454	fBodyGyro-meanFreq()-Z
503	fBodyAccMag-mean()
504	fBodyAccMag-std()
513	fBodyAccMag-meanFreq()
516	fBodyBodyAccJerkMag-mean()
517	fBodyBodyAccJerkMag-std()
526	fBodyBodyAccJerkMag-meanFreq()
529	fBodyBodyGyroMag-mean()
530	fBodyBodyGyroMag-std()
539	fBodyBodyGyroMag-meanFreq()
542	fBodyBodyGyroJerkMag-mean()
543	fBodyBodyGyroJerkMag-std()
552	fBodyBodyGyroJerkMag-meanFreq()
555	angle(tBodyAccMean,gravity)
556	angle(tBodyAccJerkMean),gravityMean)
557	angle(tBodyGyroMean,gravityMean)
558	angle(tBodyGyroJerkMean,gravityMean)
559	angle(X,gravityMean)
560	angle(Y,gravityMean)
561	angle(Z,gravityMean)

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

The produced data set contains:
- mean of 86 features previously selected, grouped by subjectID, activityID/label;
- subjectID, ranging from 1 to 30;
- activityID, ranging from 1 to 6;
- label, related or same as activityID, but with a more meaningful description: LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS.

Below, we have the relation between label and activityID (and total of occurrences):
**V1  LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRS**
  1      0       0        0    1722                  0                0
  2      0       0        0       0                  0             1544
  3      0       0        0       0               1406                0
  4      0    1777        0       0                  0                0
  5      0       0     1906       0                  0                0
  6   1944       0        0       0                  0                0


Below, we have the frequency count of the combination between label and subjectID:

  **subjectID            1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16**
  LAYING               0   0   0   0   0   0   0   0   0 198   0 320 327   0   0   0
  SITTING              0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
  STANDING             0 302   0 317   0   0   0   0 288  96   0   0   0   0   0   0
  WALKING            347   0 341   0 302 325 308  99   0   0   0   0   0   0   0   0
  WALKING_DOWNSTAIRS   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
  WALKING_UPSTAIRS     0   0   0   0   0   0   0 182   0   0 316   0   0 323 328 366
                    
  **subjectID           17  18  19  20  21  22  23  24  25  26  27  28  29  30**
  LAYING               0 364   0 354   0   0   0 381   0   0   0   0   0   0
  SITTING              0   0   0   0   0  22 372   0 409 392 376 206   0   0
  STANDING             0   0   0   0   0   0   0   0   0   0   0 176 344 383
  WALKING              0   0   0   0   0   0   0   0   0   0   0   0   0   0
  WALKING_DOWNSTAIRS 339   0 360   0 408 299   0   0   0   0   0   0   0   0
  WALKING_UPSTAIRS    29   0   0   0   0   0   0   0   0   0   0   0   0   0
> 
