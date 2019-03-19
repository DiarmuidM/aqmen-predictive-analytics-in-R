## Charity Density: An R Example ##

# This script outlines a basic set of regressions underpinning the unpublished paper:

# McDonnell, D., & Mohan, J. (n.d.) "Charity Density and Material Deprivation: A Longitudinal Perspective"
# (Currently under review)

# Created: 19/03/2019
# Creator: Diarmuid McDonnell, University of Edinburgh

# Install new package #

install.packages("rcompanion")

# Load in packages #

library(rcompanion) # produces r-squared statistics for models
library(tidyverse) # load in the "tidyverse" package of data wrangling functions
library(car) # data wrangling package, particularly good for recoding categorical variables
library(broom) # package for extracting model results
library(ggplot2) # data visualisation package
library(lubridate) # data wrangling package for dates
library(aod) # statistical model diagnostic package
library(haven) # data wrangling package for importing Stata data files into R
library(ResourceSelection) # Hosmer and Lemeshow goodness-of-fit package
library(stringr) # data wrangling package for working with strings (i.e. text)
library(descr) # data analysis package for categorical variables
library(DescTools) # data analysis package for summary statistics
library(magrittr) # package for writing efficient code

# Turn off display of scientific notation

options(scipen = 999)

# Load in data #

char_den <- read_dta("./data_raw/charity_density_2019.dta") # load in the Stata (.dta) data set


# Explore the data set #

View(char_den)
names(char_den)
nrow(char_den)


# Descriptive Statistics #

# Univariate - outcome variable

summary(char_den$charpop)

# TASK: describe the distribution of charity density? 
# i.e. what is the average number of charities per 5000 residents in a local authority.

p <- ggplot(data = char_den, mapping = aes(x = "", y = charpop)) # define the base element of the plot (data + variables)

x11() # open a plot window
p + geom_boxplot() # combine the base element of the plot with a specific plot type (e.g. a boxplot)

# Now let's plot a histogram
p <- ggplot(data = char_den, mapping = aes(x = charpop))

x11()
p + geom_histogram()


# Univariate - key explanatory variable

summary(char_den$town)

p <- ggplot(data = char_den, mapping = aes(x = town))

x11()
p + geom_histogram(binwidth = .5) # adjust the width of the bins


# Bivariate - outcome + key explanatory variable

# Produce a scatterplot to examine the association between the outcome and key explanatory variable

p <- ggplot(data = char_den, mapping = aes(x = town, y = charpop))

x11()
p + geom_point()

x11()
p + geom_point() + geom_smooth(method = "lm") # a linear line does not look the best fit; let's try a curve

x11()
p + geom_point() + geom_smooth(method = "loess") # let's try a curved line of best fit


# Summarise the strength of the association using an appropriate correlation statistic

cor(char_den$charpop, char_den$town, method = "spearman", use = "complete.obs") # Spearman's rank correlation coefficient


# Statistical Models #

# Our outcome is a count, therefore we can choose linear or poisson:

# Linear regression

lin_reg <- lm(formula = charpop ~ town + town2 + pph_cat + lag_charpop,
                  data = char_den) # estimate a linear regression

lin_reg_tidy <- tidy(lin_reg) # tidy up the output of the linear regression
lin_reg_tidy # view the coeffients of the linear regression (tidied)
summary(lin_reg) # view the results of the linear regression

# QUESTION: is the model a good fit for the data i.e. does it have a lot of predictive power?

# What about other measures of fit, like AIC?

extractAIC(lin_reg)
# Returns two results (in order): degrees of freedom, and AIC
# Note the AIC statistic: on its own it doesn't have much meaning but it can be used to compare with other models.
# Essentially, a lower value for AIC indicates a better fitting, more parsimonious model.

lin_reg2 <- lm(formula = charpop ~ town + town2 + lag_charpop,
              data = char_den) # remove a variable and compare model fit to original regression
summary(lin_reg2)
extractAIC(lin_reg2) # AIC has gone up, R-squared is about the same


# Produce predicted values of the outcome using the results of the statistical model:

char_den_prediction <- augment(lin_reg, data = char_den) # augment adds variables to the data set
names(char_den_prediction) # anything variable with the "." prefix is a new variable added to the data set

# .fitted = predicted number of charities per 5000 residents for each local authority

# Create a subset of the data set with a limited number of variables:
char_den_subset <- char_den_prediction %>% 
  select(la_name, charpop, .fitted)

View(char_den_subset) # view the subsetted data set

char_den_subset %>% 
  filter(la_name == "Cambridge") # view the results for a particular local authority

# Plot predicted vs actual values of the outcome:
p <- ggplot(data = char_den_prediction,
            mapping = aes(x = charpop, y = .fitted)) # plot predicted vs observed values for log of income
x11()
p + geom_point()

# QUESTION: what do we think about the association between predicted and actual values?


# Now let's look at predicted vs levels of material deprivation:

p <- ggplot(data = char_den_prediction,
            mapping = aes(x = town, y = .fitted))
x11()
p + geom_point() # pretty good match to the results in the paper

# Summary: linear regression works pretty well for this outcome as charity density is a continuous measure (e.g. 23.5).


# Poisson regression

# Let's round the values of charity density to whole numbers (i.e. a discrete rather than continuous measure):

char_den$charpop <- round(char_den$charpop, 0) # round the outcome to nearest whole number
View(char_den$charpop) # check if the rounding worked

poi_reg <- glm(charpop ~ town + town2 + pph_cat + lag_charpop,
               data = char_den, family="poisson")
summary(poi_reg)

# Note the AIC statistic: on its own it doesn't have much meaning but it can be used to compare with other models.
# Essentially, a lower value for AIC indicates a better fitting, more parsimonious model.

poi_reg2 <- glm(charpop ~ town + pph_cat + lag_charpop,
               data = char_den, family="poisson") # let's remove the variable "town2"
summary(poi_reg2) 

# The AIC goes up, suggesting this model is not as good a fit as the original.

# The glm() function doesn't return r-squared statistics, we need to call on a different function from "rcompanion":

nagelkerke(poi_reg)
nagelkerke(poi_reg2)

# QUESTION: which model is a better fit for the data?



