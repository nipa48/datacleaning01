## Description of the data processing

The data were collected to study human activity using smartphones from [website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). It consists of 10299 observations divided into trainind and testing data sets and 563 variables. To obtain the cleaning data set, I performed the following steps:
* Merge training and testing data sets
* Assign meaningfull names to the different activities
* Extract variables related to mean and standard deviation measurements
* Generate a cleaned data set consisting of the mean per subject and per activity for the reduced number of variables.