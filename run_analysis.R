##link zip folder into temp file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(url,temp)
##extract zipped files then unlink
##(change "exdir" value to an appropriate directory for your computer)
unzip(temp, list = T)
unzip(temp, exdir = "~/R/RFiles/3GettingCleaning/project")
unlink(temp)


##read test data
subject_test<- read.table(
        file ="~/R/RFiles/3GettingCleaning/project/UCI HAR Dataset/test/subject_test.txt",
        header=F, sep=" ", stringsAsFactors = F)
set_test <- read.table(
        "~/R/RFiles/3GettingCleaning/project/UCI HAR Dataset/test/X_test.txt",
        comment.char = "",colClasses="numeric")
label_test <- read.table(
        "~/R/RFiles/3GettingCleaning/project/UCI HAR Dataset/test/Y_test.txt",
        header=F, sep=" ", stringsAsFactors = F)

##read train data
subject_train<- read.table(
        file ="~/R/RFiles/3GettingCleaning/project/UCI HAR Dataset/train/subject_train.txt",
        header=F, sep=" ", stringsAsFactors = F)
set_train <- read.table(
        "~/R/RFiles/3GettingCleaning/project/UCI HAR Dataset/train/X_train.txt",
        comment.char = "",colClasses="numeric")
label_train <- read.table(
        "~/R/RFiles/3GettingCleaning/project/UCI HAR Dataset/train/Y_train.txt",
        header=F, sep=" ", stringsAsFactors = F)

#merge test and training vectors
subject <- c(subject_train, subject_test, recursive=T)
set <- rbind(set_train, set_test)
label <- c(label_train, label_test, recursive=T)
#bind vectors into a single table
merged <- cbind(data.frame(subject=subject, condition=label), movement.data=set)

##read features.txt data
features <- read.table(
        "~/R/RFiles/3GettingCleaning/project/UCI HAR Dataset/features.txt",
        header=F, sep=" ", colClasses="character")

##grep to find mean and sum values in "features"
##list their column number
##shift their column number by 2 (makes "features" col#'s = "merged" col#'s)
greplist<- grep("mean[(]|std[(]", features[,2], ignore.case=F, value=F)
listshift <- greplist + 2
##subset columns (#1 & #2 are subject and activity labels)
merged_cut <- merged[, c(1, 2, listshift)]

##re-label condition according to activity_labels.txt
merged_cut$condition[merged_cut$condition == "1"] <- "Walking"
merged_cut$condition[merged_cut$condition == "2"] <- "Walking Upstairs"
merged_cut$condition[merged_cut$condition == "3"] <- "Walking Downstairs"
merged_cut$condition[merged_cut$condition == "4"] <- "Sitting"
merged_cut$condition[merged_cut$condition == "5"] <- "Standing"
merged_cut$condition[merged_cut$condition == "6"] <- "Laying"

##grep again, this time with val=T, to find variable names
varnames<- grep("mean[(]|std[(]", features[,2], ignore.case=F, value=T)
##transform to a comma separated list of characters with paste()
##use colnames() to set variable names
varlist <- paste(varnames, sep=",")
colnames(merged_cut) <- c("subject", "condition", varlist)

##melt data frame
library(reshape2)
mergecutmelt <- melt(merged_cut, id=c("subject", "condition"), measure.vars=c(varlist))
##cast by subject and condition for variable mean
mergecutcast <- dcast(mergecutmelt, subject + condition ~ variable, mean)

##save merged_cut and mergecutcast as txt files
write.table(merged_cut, file="tidydata1.txt")
write.table(mergecutcast, file="tidydata2.txt")
##print tables
merged_cut
mergecutcast