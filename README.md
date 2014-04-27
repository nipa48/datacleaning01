## Code description

The code is organized into tree functions:

* **get_cleaned_data** is the top level function that uses get_average_per_subject and read_data. 
  It takes as in input the directory that contains the training, testing and related data to 
  return a data frame with the cleaned data.

* **get_average_per_subject** calculates average statistics per activity for a specific subject.

* **read_data** is used for collecting all the training and testing data and organize them into a 
  single data frame which is next used by get_cleaned_data for calculating statistics per
  subject and per activity.

