library(reshape2)


#Load Data
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test<-read.table("./UCI HAR Dataset/test/Y_test.txt")
Y_train<-read.table("./UCI HAR Dataset/train/Y_train.txt")
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
features<-read.table("./UCI HAR Dataset/features.txt")
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")


#Extract only the mean and Standard deviation columns
features[,2]<-as.character(features[,2])
activity_labels[,2]<-as.character(activity_labels[,2])
col_needed<-grep(".*std.*|.*mean.*",features[,2])
col_names<-features[col_needed,2]
col_names<-gsub("-mean","Mean",col_names)
col_names<-gsub("-std","Std",col_names)
col_names<-gsub("[-()]","",col_names)


#Bind the data together
X_data<-rbind(X_train,X_test)
Y_data<-rbind(Y_train,Y_test)
subject_data<-rbind(subject_train,subject_test)
X_data<-X_data[col_needed]
data<-cbind(subject_data,Y_data,X_data)


#adding better column names
colnames(data)<-c("Subject","Activity",col_names)
data$Activity<-factor(data$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
data$Subject<-as.factor(data$Subject)


#tidying and writing data
melted_data<-melt(data,id = c("Subject","Activity"))
final_data<-dcast(melted_data,Subject + Activity ~ variable, mean)
write.table(final_data, "./tidy.txt", row.names = FALSE, quote = FALSE)
