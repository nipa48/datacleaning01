## Data cleaning R code

library(plyr)

## Fonction to read the data and store it in appropriate data object
#- input : directory that contains the data
#- output: data frame formed by training and testing data

read_data <- function(directory) {
  # Reading training and related data
  activities <- read.table(paste(c(directory, "/activity_labels.txt"), collapse=""), 
                          col.names=c("activityID", "activity"))
  features <- read.table(paste(c(directory, "/features.txt"), collapse=""), 
                        col.names=c("colID", "variables"))
  train.subject <- read.table(paste(c(directory, "/train/subject_train.txt"), collapse=""), 
                             col.names=c("subjectID"))
  train.xdat <- read.table(paste(c(directory, "/train/X_train.txt"), collapse=""), 
                          col.names=features$variables, check.names=FALSE)
  train.ydat <- read.table(paste(c(directory, "/train/y_train.txt"), collapse=""), 
                          col.names=c("activityID"))
  # Replace activity ids by comprehensible names
  train.ydat$activity <- as.vector(activities[match(train.ydat$activityID, 
                                                   activities$activityID),]$activity)
  # Build the training data frame
  train.dat <- cbind(train.subject, activity=train.ydat$activity, train.xdat)
  
  # Reiterate fo the testing data
  test.subject <- read.table(paste(c(directory, "/test/subject_test.txt"), collapse=""), 
                            col.names=c("subjectID"))
  test.xdat <- read.table(paste(c(directory, "/test/X_test.txt"), collapse=""), 
                         col.names=features$variables, check.names=FALSE)
  test.ydat <- read.table(paste(c(directory, "/test/y_test.txt"), collapse=""), 
                         col.names=c("activityID"))
  test.ydat$activity <- as.vector(activities[match(test.ydat$activityID, 
                                                  activities$activityID),]$activity)
  test.dat <- cbind(test.subject, activity=test.ydat$activity, test.xdat)
  # Merge training and testing data
  return(rbind(train.dat, test.dat))
}

## Calulate average of each variable for each activity and one subject
#- input : data frame that contains one subject id and activities, measurements for that subject
#- output: data frame that contains the subject id and activities, average measurements
#-                   per activity for that subject
get_average_per_subject <- function(x) {
  idx1 <- which(names(x)=="subjectID")
  idx2 <- which(names(x)=="activity")
  icol <- ncol(x)-2    # exclude subject id and activities in average calculation
  cols <- names(x)[-c(idx1, idx2)] # extract variable names
  y0 <- unique(x[, c("subjectID", "activity")]) # get subject id, activity pair
  y1 <- split(x, x$activity)   # split the data by activity
  y2 <- lapply(y1, function(x) {round(colMeans(x[, -c(idx1, idx2)]), 6)})  # calculate average per activity
  y2 <- as.data.frame(matrix(unlist(y2), ncol=icol, byrow=T)) # build a data frame from the list
  names(y2) <- cols
  return(cbind(y0, y2)) # return the data frame
}

## Caculate average per activity per subject
#- input : directory that contains the data
#- output: data.frame that contains average measurements per subject per activity
get_cleaned_data <- function(dirdata) {
  dat <- read_data(dirdata) 
  meanVars <- names(dat)[grep("mean", names(dat))] # extract only mean variables
  stdVars <- names(dat)[grep("std", names(dat))]   # extract only std variables
  dat <- dat[, c("subjectID", "activity", meanVars, stdVars)] # build new data set with restricted variables
  ldat <- split(dat, dat$subjectID) # split data by subject id
  clean.dat <- ldply(lapply(ldat, get_average_per_subject), data.frame, check.names=FALSE) # extract clean data
  return(clean.dat)
}

