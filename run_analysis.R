## Unzip the file

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
data_path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(data_path, recursive=TRUE)
        
## Read Activity test and training files          
dataActTest  <- read.table(file.path(data_path, "test" , "Y_test.txt" ),header = FALSE)
dataActTrain <- read.table(file.path(data_path, "train", "Y_train.txt"),header = FALSE)

## Read Subject test and training files
dataSubjTrain <- read.table(file.path(data_path, "train", "subject_train.txt"),header = FALSE)
dataSubjTest  <- read.table(file.path(data_path, "test" , "subject_test.txt"),header = FALSE)

## Read Feature test and training files
dataFeatTest  <- read.table(file.path(data_path, "test" , "X_test.txt" ),header = FALSE)
dataFeatTrain <- read.table(file.path(data_path, "train", "X_train.txt"),header = FALSE)

## Merge the data of training and test by column bind
dataSubj <- rbind(dataSubjTrain, dataSubjTest)
dataAct<- rbind(dataActTrain, dataActTest)
dataFeat<- rbind(dataFeatTrain, dataFeatTest)

## Add labels to the three files
names(dataSubj)<-c("Subject")
names(dataAct)<- c("Activity")
dataFeatNames <- read.table(file.path(data_path, "features.txt"),head=FALSE)
names(dataFeat)<- dataFeatNames$V2

dataAll <- cbind(dataSubj, dataAct)
dataAll <- cbind(dataFeat, dataAll)

## Get only the columsn which has mean or std
dataFeatNames<-dataFeatNames$V2[grep(".*mean.*|.*std.*", dataFeatNames$V2)]

selectedNames<-c(as.character(dataFeatNames), "Subject", "Activity" )

##subset the data only for the columns wtih mean or std
Data<-subset(Data,select=selectedNames)


activityLabels <- read.table(file.path(data_path, "activity_labels.txt"),header = FALSE)

names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
