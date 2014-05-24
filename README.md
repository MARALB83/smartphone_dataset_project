smartphone_dataset_project
==========================

Getting and Cleaning Data: Project submission

* Start with the run_analysis.R script

* Load script into R

* The script starts by checking if the folder 'UCI HAR Dataset' is available in the working directory. 

If it is, then it continues.
If it isn't, then the zipped folder containg the data is downloaded to a temporary file and it is unzipped, creating the 'UCI HAR Dataset' folder.

* Variable Assignment

The script proceeds by getting all the paths within the dataset folder 'UCI HAR Dataset', as well as the file names without the extensions. The files 'README.txt' and 'features_info.txt' are descriptive files and do not have data, so they were excluded.
This helps to perform an automatic variable assignment by using the file names (without extensions) as the variable names, and the paths as the destinations of where the datasets are. This is all performed within one loop.

* Train and Test datasets merge

The script first checks if the 2 datasets are aligned in terms of the number and name of the columns.
Then, it appends the Test dataset below the Train dataset. This structure will be preserved in future concatenations (activity and subject).

* Extraction of relevant measures

The selection of the features was made such that they had either 'mean' or 'std' in their name.
This selection excludes angle() variables which I interpret as not being a direct mean or a standard deviation measure, but rather an angle between 2 vectors (1 of which being a direct mean measurement).
This means that I didn't consider the angle to be neither a mean nor a standard deviation measurement of the underlying data.

* Manipulation of features labels, activity labels, and subject labels

Features Labels: Extra index column is deleted from both the activity_labels dataset as well as the features dataset.
The script then proceeds by changing the name of the features: Extend names and include spaces so that they can be read more easily. Also got rid of parethesis and duplicated names on the title ('BodyBody').

Activity Labels: The script tests if the package 'Hmisc' is present. If it is, it continues. If it isn't, the script installs and loads it. Change activity names so that only the first letter is capitalized for better readability.

Finally, the test dataset is appended below the train dataset for the subject and activity variables. This structure is coherent with the merge performed on the measurements train and test data.

* Manipulation of filtered merged Train and Test datasets

Activities and subjects are concatenated to the main dataframe that contains the measurements. Also, the variable names of the measurements are assigned to the changed features labels created on the previous point.

* Tidy Dataset

First, the script checks if the 'reshape2' package is present. If it is, then it continues. If it isn't it installs and loads it.
Second, the main measurements dataset is converted to a long format by expanding measurements to every Activity-Subject pair existent.
Third, the tidy dataset is created by aggregating measurements data for each Activity-Subject pair across all variables measured. The aggregation is made using the mean.
Finally, the tidy dataset is exported to a .txt file.



