Hello, this file will take you through the process I used in "run_analysis.R". In my opinion the process is easier to understand if you just read the code file (I left plenty of comments), but if you have questions looking here might help. 

Part 1
======

First, I linked to the provided zip folder and extracted the files to my working directory

*Anyone using run_analysis.R should set the "exdir" argument in unzip() to an appropriate location on their computer before running the code.*

Then, I read in the test data using read.table() on each of the following files:
        subject_test.txt, X_test.txt, Y_test.txt.

Then, I read in the train data using read.table() on these files:
        subject_train.txt, X_train.txt, Y_train.txt.

All files were read in as data frames.

I used the c() function to merge subject_test and subject_train to a data frame called "subject"
and to merge Y_test and Y_train to a data frame called "label".
I used rbind() to merge set_test/set_train to a data frame called "set".

I used the following code to merge these three data frames into a single data frame called "merge":
merged <- cbind(data.frame(subject=subject, condition=label), movement.data=set)

Part 2
======

First, I read the features.txt data with read.table()

Then, I used grep to find the measurements involving mean() and sum() in the "features" data frame

I used grep again to create a list of the column numbers for these measurements
I increased each column number by 2 to make these column values match the column values in "merged" (adding the "subject"" and "label" variables increased the column values in "merged"
 by 2)

Then I subset "merged" to include only column 1 ("subject"),  column 2("label"), and the columns
listed by grep() with the +2 increase

Then I changed the name of the "label"" column to "condition" to make it more descriptive

Part 3
======

I editted the "label" column values using the character strings listed in activity_labels.txt. The following is an example of the code used:

merged_cut$condition[merged_cut$condition == "1"] <- "Walking"

All "label" values (1,2,3,4,5,and 6) were changed in this fashion to create a more descriptive data set. 

Part 4
======
I used grep again, this time with val=T, to find variable names for the mean() and sum() measurments. I put these values in a list called "varlist".

Then I used the colnames() function to set variable names:

colnames(merged_cut) <- c("subject", "activity", varlist)

*I made a last minute change here - the "condition" variable name was changed to "activity"

Part 5
======
I used the melt() function from the reshape2 package to melt to data set 

Then I used the cast() function to create a new table with the average of each variable for each subject and condition

Then I saved and printed both of the tables I created.