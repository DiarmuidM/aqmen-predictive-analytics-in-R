############################################################
#   R program  practical2.R
#   written by Gillian Raab
#  if you logged off after the last practical then
#  load your saved data with censoring variables and
#  survival times

###########################################################################
# now survival analysis
#
setwd("M:/survival")
rm(list=ls()) ######################to remove any junk you have in your workspace
dir()

load("for_practical_3.Rdata")
library(survival)
#
# plot survival curves  by agegroup
#
help(plot.survfit)
plot(survfit(Surv(years_follow_up,dead)~agegroup,data),lwd=2,col=1:6,lty=1:6,main="S(t)")
legend(1,.6,levels(data$agegroup),col=1:6,lty=1:6,lwd=2,bty="n")
#
#  now cumulative hazard
#
plot(survfit(Surv(years_follow_up,dead)~agegroup,data),lwd=2,col=1:6,lty=1:6,fun="cumhaz",main="cum hazard")
legend(3,1.5,levels(data$agegroup),col=1:6,lwd=2,lty=1:6,bty="n")
#
# now cumulative hazard with log y scale you need to change ylimits to see plots
#
plot(survfit(Surv(years_follow_up,dead)~agegroup,data),lwd=2,lty=1:6,col=1:6,ylim=c(0.00001,2),
fun="cumhaz",log=T,main="log cum hazard",mark.time=FALSE)
legend(75,5e-3,levels(data$agegroup),col=1:6,lwd=2,lty=1:6,bty="n")
#
# now with x and y as logs
#
plot(survfit(Surv(years_follow_up,dead)~agegroup,data),lwd=2,col=1:6,lty=1:6,fun="cloglog",main="complimentary log log",mark.time=FALSE)
legend(1,2,levels(data$agegroup),col=1:6,lwd=2,lty=1:6,bty="n")
##
# plot baseline hazard (smoothed)
#
###################################################################################
#  now fit Cox models
#
coxph(Surv(years_follow_up,dead)~agegroup,data)
#
# now hed by itself and then adjusted for age
#
coxph(Surv(years_follow_up,dead)~hed,data)
#
# now adjusted
#
coxph(Surv(years_follow_up,dead)~hed+agegroup,data)
#
#  now econpo9
#
#
coxph(Surv(years_follow_up,dead)~econpo9,data)
coxph(Surv(years_follow_up,dead)~econpo9 + agegroup,data)
#
#  now everything
#
coxph(Surv(years_follow_up,dead)~hed+econpo9+sclas9+urbgro9+agegroup,data)
anova(coxph(Surv(years_follow_up,dead)~agegroup+hed+econpo9+sclas9+urbgro9,data))
#
#
#  experiment with more models yourself
#
#
####################################################

####################################################
#
# now delayed entry models calculations to nearest year
#
############################################################
#  get age at death
#
data$ageatdeath <-  data$year_death-1991+data$ageten9+0.5
#
# set to age at exit for censored cases who have left Scotland
#
data$ageatdeath[data$exit==1] <- data$year_exit[data$exit==1]-1991+data$ageten9[data$exit==1]+0.5
#
# and to age at 2009 if not dead or exited
#
data$ageatdeath[is.na(data$ageatdeath)] <-  2009-1991+data$ageten9[is.na(data$ageatdeath)]

data$yearbirth <- 1991-data$ageten9
#
#  and look at table
#
table(data$ageatdeath,data$dead,exclude=NULL)
#
# plot fit counting process model by sex
#
plot(survfit(Surv(ageten9,ageatdeath,dead,type="counting")~sexten9,data),lwd=2,
     col=1:2,lty=1:2,mark.time=FALSE,main="survival", xlim = c(20,95))
legend("bottomleft",c("Male","Female"),lwd=2,lty=1:2,col=1:2, cex =2)

plot(survfit(Surv(ageten9,ageatdeath,dead,type="counting")~sexten9,data),lwd=2,
     col=1:2,lty=1:2,fun="cumhaz",mark.time=FALSE,main="cumulative hazard")

plot(survfit(Surv(ageten9,ageatdeath,dead,type="counting")~sexten9,data),lwd=2,
     col=1:2,lty=1:2,fun="cloglog", mark.time=FALSE,main="cumulative hazard")
#
#   now fit a Cox model for this check the help for Surv
#   to see what the three parameters mean when type="counting"
#
coxph(Surv(ageten9,ageatdeath,dead,type="counting")~sexten9,data,method="breslow")
#
# now calculate a variable for birth cohort
#
data$cohort<-factor(floor(data$yearbirth/10)*10)
table(data$cohort)
#
# look at deaths by year and age at death and 10 year birth cohort
#
table(data$cohort[data$dead==1],data$year_death[data$dead==1])
table(data$cohort[data$dead==1],data$ageatdeath[data$dead==1])
#
# fit delayed entry Cox model
#
coxph(Surv(ageten9,ageatdeath,dead,type="counting")~cohort,data,method="breslow")
#
# now take latest year as baseline
#
contrasts(data$cohort) <- contr.treatment(7,base=7)
coxph(Surv(ageten9,ageatdeath,dead,type="counting")~cohort,data,method="breslow")
####################################################################################################
#
#  now time dependent analyses
#
# using the delayed entry model
#
# need to split follow up period into two bits at 10 years
#####################################################################################################
#
# make the data frame have 2 records for people who span age 50
#
help(survSplit)

newdata<-survSplit(data=data,cut=50,start="ageten9", end="ageatdeath", event="dead",episode="period")
dim(newdata)
names(newdata)
newdata<-newdata[order(newdata$id),]
newdata[1:20,c("id","ageten9","ageatdeath","dead","period")]
table(newdata$id)
###################################################################
#  now time dependent analysis
#
# get 3 new variables for being in rural area and for being rural before and after age 50
#
newdata$rural<-1*(newdata$urbgro9=="not_in_locality")
head(newdata)
newdata$oldrural<-newdata$rural*newdata$period
newdata$youngrural<-newdata$rural*(1-newdata$period)
#
#  rural lower hazard of death in rural areas (note this is age adjusted)
#
coxph(Surv(ageten9,ageatdeath,dead,type="counting")~rural,newdata,method="breslow")
#
# now time dependent
#
coxph(Surv(ageten9,ageatdeath,dead,type="counting")~rural+oldrural,newdata,method="breslow")
#
# effect is smaller for those 50+ marginally significant only at .1
#
# and with different parameters
#
coxph(Surv(ageten9,ageatdeath,dead,type="counting")~youngrural+oldrural,newdata,method="breslow")
#
#  both young and old benefit from rural life, but yooung people more so
#
##############################################################################################

