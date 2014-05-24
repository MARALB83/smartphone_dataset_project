##Coursera Data Science Specialization
##Getting and Cleaning Data
##Human Activity Recognition Using Smartphones Dataset
##Course Project: Load data
##Student: Mario Albuquerque

##DATA EXTRACTION
#Check if data is present
if(!file.exists('UCI HAR Dataset'))
#Create temporary file, download .zip and unzip all files to the working directory
  {temp<-tempfile()
   download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',temp)
   unzip(temp)
   unlink(temp)}

##VARIABLE ASSIGNMENT
#Get all data pahts
all_paths<-list.files('.//UCI HAR Dataset',full.names=TRUE,recursive=TRUE)
#Get all data files
all_files<-basename(all_paths)
#Clean up the file names
variable_names<-substr(x=all_files,start=1,stop=nchar(all_files)-4)
#Define files that do not contain data (features_info.txt and README.txt)
drop1<-variable_names[c(3,4)]
drop2<-all_paths[c(3,4)]
#Remove files without data
variable_names<-variable_names[!variable_names %in% drop1]
all_paths<-all_paths[!all_paths %in% drop2]
#Assign data to dataframes
for(i in 1:length(all_paths)){assign(variable_names[i],read.table(all_paths[i]))}

##TRAIN AND TEST DATASETS MERGE
#Check structure of train and test datasets
if(sum(names(X_test)==names(X_train)))
{print('Test and Train datasets have same variables (as columns). It is possible to append one of them below the other while still preserving data structure.')}
#Merge train and test datasets
merged_Data<-rbind(X_train,X_test)

##EXTRACTION OF RELEVANT MEASUREMENTS
#NOTE: Subset based on 'features' vector having either 'mean' or 'std' on the feature name
#This subsetting excludes angle() variables which I interpret as not being a direct mean or a standard deviation measure, but rather an angle between 2 vectors (1 of which being a direct mean measurement).
#I didn't consider the angle to be neither a mean nor a standard deviation measurement of the underlying data
measurement_index=grepl(pattern='mean|std',x=features$V2)
#Subset merged Train and Test dataset based on the mean and standard deviation measurements
filtered_merged_Data<-merged_Data[,measurement_index]

##MANIPULATION OF FEATURES LABELS, ACTIVITY LABELS, and SUBJECT LABELS
#Eliminate extra index column from raw activity_labels and features data. Also subset features with respect to relevant measurements.
activity_labels<-as.character(activity_labels$V2)
features<-as.character(features$V2[measurement_index])
#Change name of features. Logic: Extend names to be read more easily. Get rid of parethesis and duplicated names on the title ('BodyBody')
#1-Substitute 't' with 'Time-'
features<-sub(pattern='^t',replacement='Time-',x=features)
#2-Substitute 'f' with 'Frequency-'
features<-sub(pattern='^f',replacement='Frequency-',x=features)
#Get rid of repeated 'Body' string in labels
features<-sub(pattern='BodyBody',replacement='Body',x=features)
#Make titles clearer
features<-sub(pattern='Body',replacement='Body ',x=features)
features<-sub(pattern='Gravity',replacement='Gravity ',x=features)
features<-sub(pattern='Acc',replacement='Acceleration',x=features)
features<-sub(pattern='Gyro',replacement='Gyroscopic',x=features)
features<-sub(pattern='Jerk',replacement=' Jerk',x=features)
features<-sub(pattern='Mag',replacement=' Magnitude',x=features)
features<-sub(pattern='mean',replacement=' Average',x=features)
features<-sub(pattern='std',replacement=' Standard Deviation',x=features)
features<-sub(pattern='\\(',replacement='',x=features)
features<-sub(pattern='\\)',replacement='',x=features)
features<-sub(pattern='eFreq',replacement='e Frequency',x=features)
#Change activity labels so they are lowercase. 
activity_labels<-tolower(activity_labels)
#Check if package 'Hmisc' is installed. If not, install it.
if(!require('Hmisc')){install.packages('Hmisc')}
library(Hmisc)
#Capitalize first letter of the activity
activity_labels<-capitalize(activity_labels)
#Merge Test and Train Activity labels
activity<-rbind(y_train,y_test)
#Merge Test and Train Subject labels
subject<-rbind(subject_train,subject_test)

##MANIPULATION OF filtered merged Train and Test datasets
#Add activity labels with appropriate names
filtered_merged_Data['Activity']<-'placeholder'
for(i in 1:nrow(activity)){filtered_merged_Data$Activity[i]<-activity_labels[activity[i,]]}
#Add features name to train and test datasets
names(filtered_merged_Data)[1:length(features)]<-features
#Add subject to train and test datasets
filtered_merged_Data['Subject']<-subject

##CREATE TIDY DATASET
#Check if package 'reshape2' is installed. If not, install it.
if(!require('reshape2')){install.packages('reshape2')}
library(reshape2)
#Transform filtered Train and Test dataset into a long format using melt. Define 'Activity' and 'Subject' as the ID variables
melted_dataset<-melt(filtered_merged_Data,id.vars=c('Activity','Subject'))
#Aggregate long format data into tidy data, by taking the average within each Activity and Subject pair
tidy_dataset<-dcast(data=melted_dataset,Subject + Activity ~ variable,fun.aggregate=mean)
#Create txt file to hold tidy dataset
write.table(tidy_dataset,'tidy_dataset.txt')
