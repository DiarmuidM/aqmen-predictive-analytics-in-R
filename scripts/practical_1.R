############################################################
#   R program  practical1.R
#   written by Gillian Raab
#   if you are usung R studio  ^ctrl (carriage retur will submit each line
#setwd("Z:/training/survival/data")
setwd("M:/survival")
rm(list=ls()) ######################to remove any junk you have in your workspace
dir()
#
#    Change to the directory where you are saving course 
#    stuff. To do this click on Console and go to file menu
#
#   Now load the data set for the course by clicking on 
#    the .Rdata file or by the following coomand
#
load("false_data_teachingdataset_synthetic_data.Rdata")
#   The data are in a data frame called data to see its
#   dimensions and the first 5 rows type 

dim(data)
data[1:5,]
#
# and to see variable names type
names(data)
#
#  NA in R means missing data so you need to look down a 
#  bit further to find someone who died or exited
data[1:30,8:11]
#
#  get dead and exit variables
#
data$dead <- 1 - is.na(data$year_death)  ##  not missing year_deth
data$time_to_death <- 12*(data$year_death - 1991) + (data$month_death - 4) + 0.5
table(data$time_to_death)



data$exit <- 1-is.na(data$year_exit)
data$time_to_exit <- 12*(data$year_exit - 1991) + (data$month_exit - 4) + 0.5
with(data,table(dead,exit))
#
#  check for any cases both exited and dead
#
dim(data[data$dead & data$exit,])
#
# check year difference between exit and death
#
with(data[data$dead & data$exit,],table(year_death-year_exit))
#
#  check those who died same year they exited
#
data[data$dead & data$exit &data$year_death==data$year_exit,9:12]
#
# now set the dates of death to missing and dead to 0 for those who exited
#  since we will be counting them as censored at their exit time
#
data$dead[data$exit==1]<-0
data$year_death[data$exit==1]<-NA
data$month_death[data$exit==1]<-NA
#
#  now calculate months survival from census date (April 1991)
#   add 0.5 to indicate that they survived a bit of April 1991
#
data$dead<-1-is.na(data$year_death)
data$exit<-1-is.na(data$year_exit)
table(data$dead,data$exit)
#
data$years_follow_up<-data$year_death-1991+(data$month_death-4+0.5)/12
head(data)
#
# calculate follow-up time for those censored mid april 1991 to end 2008
#
data$years_follow_up[data$dead==0]<-2008-1991+(12-3.5)/12
#
# and replace with shorter time for those exiting before
#
data$years_follow_up[data$exit==1]<-data$year_exit[data$exit==1]-1991+
    ( data$month_exit[data$exit==1]-4+0.5)/12

range(data$years_follow_up)

#######################################################################
# now ready for survival analyses but first save your syntax file
# and perhaps your workspace
#
save.image("data_with_times.Rdata")
#
#  you may have to install the survival package if it is not done
#
??survival
install.packages("survival")
library(survival)

###################################################################################

