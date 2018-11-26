# Getting and Cleaning data in R
This is a project for the "Getting and Cleaning data in R" course in Coursera. The following steps were performed in the code to fulfill the requirements and create a tidy dataset.

## Steps followed
1. Download the raw dataset from the websote using the link provided
2. Unzip the folder and explore the files and and folders inside it
3. Load the datasets in test and train folders using read.table()
4. Use cbind to combine x_train, y_train and subject_train datasets to create a complete train dataset
5. Follow the previous step for test dataset as well
6. Use rbind to merge both test and train datasets
7. Since we need to limit only to Mean and STD measure, use features dataset to extract the required features
8. Subset the merged dataset only for the features extracted in the above step
9. Rename the variables to give a proper descriptive name
10. Use Melt and Cast technique to create a secondary dataset with average of each variable for each activity for each subject
