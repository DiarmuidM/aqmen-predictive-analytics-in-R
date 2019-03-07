############################################################
#   R program  practical2.R
#   written by Gillian Raab
#  if you logged off after the last practical then
#  load your saved data with censoring variables and
#  survival times

load("data_with_times.Rdata")
head(data)
#
#  calculate age groups
#
data$agegroup<-10*floor(data$ageten9/10)
table(data$agegroup)
data$agegroup<-factor(data$agegroup,labels=c("20-29","30-39","40-49","50-59","60-69","70-74"))
table(data$agegroup)
###########################################################################
# now survival analysis
#
library(survival)
#
# first get table of survival times for whole group
#
print(survfit(Surv(years_follow_up,dead)~1,data))
#
# to get restricted mean
#
help(print.survfit)
print(survfit(Surv(years_follow_up,dead)~1,data),rmean="common")
#
summary(survfit(Surv(years_follow_up,dead)~1,data))#########  gives full table
#
# to get just selected times
#
help(summary.survfit)
summary(survfit(Surv(years_follow_up,dead)~1,data),times=1:17)#########  gives full table
#
#  and to get estimated survival to end of follow up
#  you need extend=T because the ;ast time did not have a death
#
summary(survfit(Surv(years_follow_up,dead)~1,data), extend=TRUE,
times=max(data$years_follow_up))#########  gives full table
#

########################################################################
#
plot survival curves 
#
# first whol;e group
#
plot(survfit(Surv(years_follow_up,dead)~1,data))
#
# now by agegroup
#
plot(survfit(Surv(years_follow_up,dead)~agegroup,data),lwd=2,col=1:6,lty=1:6,main="S(t)")
legend(2,.6,levels(data$agegroup),col=1:6,lty=1:6,lwd=2,bty="n")
#
# now summarise by age group
#
#print(survfit(Surv(years_follow_up,dead)~agegroup,data),rmean="individual")
#
# and now get 5 year survival probabilities by age group
#
summary(survfit(Surv(years_follow_up,dead)~agegroup,data),times=5)
#
# now plots by other factors - you can add legends and change y limits to see  more 
# clearly
#
#
plot(survfit(Surv(years_follow_up,dead)~sexten9,data),lwd=2,col=1:2,lty=1:2.main="sex")
#
plot(survfit(Surv(years_follow_up,dead)~hed,data),lwd=2,col=1:2,lty=1:2,main="higher ed")
#
plot(survfit(Surv(years_follow_up,dead)~econpo9,data),lwd=2,col=1:7,lty=1:7,main="economic position")
#
plot(survfit(Surv(years_follow_up,dead)~sclas9,data),lwd=2,col=1:7,lty=1:7,main="social class")
#
plot(survfit(Surv(years_follow_up,dead)~urbgro9,data),lwd=2,col=1:7,lty=1:7,main="urban rural")

##########################################
#  now save file to use for next practical
save(data,file="for_practical_3.Rdata")
#######################################################################

