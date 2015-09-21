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

#Column-binding each data set
test<- cbind(subj.test,test,y.test2)
train<-cbind(subj.training,train,y.train2)

#Row-binding (merging) both data sets
full.dataset<-rbind(test,train)

# Appropriately naming columns
colnames(full.dataset)<-c("subject",nm.test,"Activity")

#Finding which columns to "keep", based in being either "mean" or "standard deviation (std)" of the measurement
colsToKeep<-grep("mean|std",names(full.dataset),perl=T)

#Producing a tidy data set
library(data.table)
tidy.dataset <- full.dataset[,lapply(.SD,mean),by=.(Activity,subject),.SDcols=colsToKeep][order(Activity,subject),]

