
#This R script anlyzes in the activity data sets

# first loading dplyr

library(dplyr)

# step 1: reading the files (This scripts assumes that the data folder is in the folder that the script is running)

x_test <- read.table("./UCI\ HAR\ Dataset/test/X_test.txt")
y_test <- read.table("./UCI\ HAR\ Dataset/test/y_test.txt")
sbj_test <- read.table("./UCI\ HAR\ Dataset/test/subject_test.txt")


x_train <- read.table("./UCI\ HAR\ Dataset/train/X_train.txt")
y_train <- read.table("./UCI\ HAR\ Dataset/train/y_train.txt")
sbj_train <- read.table("./UCI\ HAR\ Dataset/train/subject_train.txt")

# and for future references, I need the activity labels:

activities <- read.table("./UCI\ HAR\ Dataset/activity_labels.txt")

features <- read.table("./UCI\ HAR\ Dataset/features.txt")


#step 2: merging the data frames: 
#   step 2-1: addind subjet and activity code to main data fram:
      
train <- cbind(sbj_train, y_train, x_train)
test <- cbind(sbj_test, y_test, x_test)

#    step 2-2: now we can merge the train and test dataframes

train_and_test <- rbind(train, test)


#step 3: get the mean and std variables from the feature data frame:

mean_std_vars <- grep("mean|std", features$V2, ignore.case = TRUE)

# to be used later in task 4 of the project, we need to have the names

var_names <- features[grepl("mean()$|std()$",features$V2, ignore.case = TRUE),2 ]


#later on, we want to select the columns by the value of the mean_std_vars,
#but in the step 2-1 we added 2 more columns to the train and test DF, so what we actually need is: mean_std_vars+2:

mean_std_vars_p2 <-mean_std_vars +2

# now that we have found the column number of the desired variables, we can select them 
#(Hint! the first and the second cols are subject id and activity ids, and we need them):

all_cols <- train_and_test[, c(1,2,mean_std_vars_p2)]

# step 4: now, we go to the task 4 of the project.
# so far we have been working on the data frames with no column names, but we need these names. 
# The first column is the subject id, the second column is the activity id, 
# and the rest of columns have the names that we select in var_names vector

col.names<- c("sbj_ID", "Activity.Code", as.character(var_names) ) 

# now, just giving names to the date_frame

names(all_cols) <- col.names

# Ok, now we have a data frame which everything is included. The real cleaning fata starts here:

# first, to fulfil task 4 of the project, we need to convert activity code to activity names:
# the activity column can be our factor

xfactors <- as.factor(all_cols$Activity)

# now that we have the factor, we can transform the activity:

# the activity names are:
act_names <- activities$V2 

# and we can transform and add the column:

complete <- mutate(all_cols, activity.name=act_names[xfactors]) 

# the DF "complete" has all columns that we need

# Finally, to do the final task, we need to reshape data, so that ev very line is for one subject and one activity and one variable


comp2 <- melt(complete, id=c("sbj_ID","activity.name"), measure.vars = c(3:88)   )

write.table(comp2, file = "final_humanActivity.txt", row.names = FALSE)
