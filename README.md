---
title: "ReadMe.md"
author: "Giovanni Pavolini"
date: "21 de septiembre de 2015"
output: html_document
---

This is the companion documentatio for the `run_analysis.R` file.

# Data source and Meaning
The script works with data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones with a number of measurements of Samsung motion sensors.
Data was collected and initially analyzed by _Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013._

Two sets exist in the data: _training_ and _test_ sets. Please refer to the *README.txt* file in the root folder to find more detailed explanations.

# How the Script Works
First, it's necessary to read all variables into space. Taking into account that variable names, subjects and activities are separated from measured data, those values need to be loaded too.
```{r}
# Reading the data sets into space
test <- read.table("test/X_test.txt",header = F)
train<- read.table("train/X_train.txt",header = F)

# Reading feature names into space
nm.test<- read.table("features.txt",header = F,stringsAsFactors = F)
nm.test<-nm.test[,2]

# Reading subjects into space
subsubj.test <- read.table("test/subject_test.txt",header = F)
subj.training<-read.table("train/subject_train.txt")


#Reading activities into space
y.test <- read.table("test/y_test.txt")
y.train<-read.table("train/y_train.txt")
# Reading human-readable activities descriptions
act.lab <- read.table("activity_labels.txt")
#Joining activities with their relevant names
y.train2<-merge(y.train,act.lab,by.y = "V1")[,2]
y.test2<-merge(y.test,act.lab,by.y = "V1")[,2]
```
Then, it's time to start merging the data. First, each data set needs to be binded (column-wise) together:
```{r}
#Column-binding each data set
test<- cbind(subj.test,test,y.test2)
train<-cbind(subj.training,train,y.train2)
```
With both sets properly assembled, it's time to bind them together (row-wise), this is what's called "merging" in the assignment description:
```{r}
#Row-binding (merging) both data sets
full.dataset<-rbind(test,train)

# Appropriately naming columns
colnames(full.dataset)<-c("subject",nm.test,"Activity")

```
Next, it's time to determine wich columns we need to keep, per the assignment instruction to keep only those columns with either mean or standard deviation.
```{r}
#Finding which columns to "keep", based in being either "mean" or "standard deviation (std)" of the measurement
colsToKeep<-grep("mean|std",names(full.dataset),perl=T)
```
The use of `grep` here helps us to find the columns whose names have the substrings "std" or "mean".

At this point, we have a fully merged data set and have defined which columns we're interested in, so we can proceed to calculcate the average value of all variables, by _both_ subject and activity:

```{r}
library(data.table)
tidy.dataset <- full.dataset[,lapply(.SD,mean),by=.(Activity,subject),.SDcols=colsToKeep][order(Activity,subject),]
```
which we accomplish with the help of the `data.table` package.

# Variable Code Book
(Taken from features_info.txt)
Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'
