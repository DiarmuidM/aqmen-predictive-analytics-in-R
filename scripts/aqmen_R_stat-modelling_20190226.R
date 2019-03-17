# 
# AQMEN (Data Science for Social Research)
# http://www.aqmen.ac.uk/
#
# 
# Predictive Analytics
# 
# R Workshop (March 2019)
# 
# A three day hands-on workshop led by Dr Diarmuid McDonnell and Professor Vernon Gayle, University of Edinburgh.
# 
# 
# ##############################################
# # IT IS IMPORTANT THAT YOU READ THIS HANDOUT #
# # AND FOLLOW THE R FILE LINE BY LINE! #
# ##############################################
# 
# 
# Topics: 
# 
# This three-day workshop provides a fast-track introduction for researchers wishing 
# to learn how to undertake statistical modelling using data from non-academic research domains.
# These skills are fundamental for successful data analysis and data science in industry and academia.
# 
#
# Rationale: 
# 
# The Industrial Strategy recognises that a major challenge facing UK businesses and industry is how best 
# to utilise big data to improve economic performance and increase productivity. 
#
# A substantial barrier to exploiting the potential offered by emerging forms of big data is the lack of a 
# suitably trained workforce with appropriate analytical skills.
# 
# This course will provide a fast-track introduction for individuals wishing to conduct statistical analyses in R.
#
#
# Advice:
#
# The workshop is intended for people who have little prior experience of R.
#
# The aim of the workshop is to equip you with a proficiency in predictive analytics using R as rapidly and painlessly as possible.
#
# Therefore, be good to yourself: we explore a multitude of useful modelling techniques that often take a semester to cover. 
#
# It will NOT be possible to learn everthing in three days (drinks on us if proven wrong).
#
# Please be patient. Computers often go wrong.
#
# Please asks the instructors for help.
#
# Feel free to work in pairs during the pratical sessions.
#
# Not all of your questions will be answered but we will help as much as we can.
#
# Good luck.
#
##############################################


##############################################

# Outline of Activities #

# The workshop is based around a series of activities that involve the use of R for performing statistical analyses of administrative data:

#	1. Getting Started with R: a quick introduction to the R programming language and various data types [ACT001]

#	2. Fundamental Statistical Concepts: performing rudimentary data analyses e.g. crosstabulations, summary statistics, hypotheses tests [ACT002]

#	3. Statistical Models: how to estimate three "vanilla" regression models - linear, logistic and count [ACT003]

#	4. Longitudinal Data Analysis: how to estimate models that account for data containing repeated obervations or clusters [ACT004]

#	5. Analysing Durations: how to analyse outcomes where the unit of observation is time or a duration [ACT005]

#	6. Hackathon: two blocks of time where participants will tackle a data analysis challenge using administrative data [ACT007] [ACT006]


# If you want to jump to a section: press Ctrl + F and search for the activity code e.g. [ACT001].


##############################################


##############################################
#
#
# We suggest that you make a copy of this file.
#
#
# ##############################################
# # IT IS IMPORTANT THAT YOU READ THIS HANDOUT #
# # AND FOLLOW THE R FILE LINE BY LINE! #
# ##############################################
# 
# The file is sequential. It MUST be run line by line. 
# Many of the commands will NOT run if earlier lines of commands have not been executed.
#
# Anotate your new copy of the file as you work through it with your own notes 
# (use "#" to comment out your notes).
#
#
# Throughout the file there are markers requiring your input:
#	- TASK: a coding task for you to complete (e.g. create new variables)
#	- QUESTION: a question regarding your interpretation of some code or a technique (e.g. what is the above loop doing?)
#	- EXERCISE: a data wrangling challenge for you to complete at the end of an activity
#
# 
# ON WITH THE SHOW!
#
#
##############################################


##############################################


# 0. Software Demonstration #

# 0.1 System Setup #

# Create a R project folder/directory

# Open RStudio and follow these instructions:
# 	- File > New Project
#	- Create project directory

getwd() # tells us the current working directory i.e. workspace
# setwd("C:/Users/mcdonndz-local/Desktop/temp") # set the working directory to a specified directory; however we have no need to
# do this as we have already set up a directory to store all of the components of our R project.

folders = c('data_raw', 'data_clean', 'temp', 'logs') # create a list with folder names
for(f in folders) {
  print(f)
  dir.create(f)
} # take a look at the bottom right-hand panel in RStudio (or the directory on your machine) to check if the folders were created

# Creating and saving files:
data <- file.create("./temp/sampdata.csv")
write.csv(data, "./temp/sampdata_20190321.csv")
# Note the use of "." at the beginning of the file path; this signifies that the current working directory
# should form the first part of the path without needing to be explicitly stated. This is an example of
# using relative file paths and is considered good practice.

# List all files in our working directory:
dir() # list all files in a directory
head(dir(recursive = TRUE)) # list all files in a directory (including its subdirectories); head() restricts the output to the first few results
dir(pattern = "\\.csv$", recursive = TRUE) # find all files that end in ".csv"
# The above command used regular expressions to detect patterns in text.

file.info("./data_raw/sampdata.csv") # displays some basic file information 
# (e.g. size, whether it is a folder, created and modified times)

# That's enough file management for now. There are lots of other tasks we can perform, such as copying, moving, deleting,
# opening, checking if a file exists etc, that we do not cover here: see [http://theautomatic.net/2018/07/11/manipulate-files-r/]

# TASK: move the files from the workshop Dropbox folder to the "data_raw" directory you just created.


# 0.2 Installing Packages #

# The real power of using R for data wrangling and analysis comes from the universe of user-written packages that are available.
# A package bundles together code, data, documentation, and tests and provides an easy method to share with others.

# Packages represent both a blessing and a curse: a blessing because it is unlikely you won't be able to find a function you need for your analysis;
# a curse because it adds a bit of administrative burden to your workflow (i.e. find a package, install it, load it, use it). Also,
# help documentation is wildly inconsistent across packages. 

# A package only needs to be installed once, but you will need to load it in every time you launch an R session.

my_packages <- c("tidyverse", "car", "haven", "broom", "ggplot2", "lubridate",
	"aod", "ResourceSelection", "stringr", "descr", "DescTools", "plm", 
	"magrittr", "survminer", "survival") # create a list of desired packages

install.packages(my_packages, repos = "http://cran.rstudio.com") # install packages from the CRAN repository

installed.packages() # check which packages have been installed

.libPaths() # check which folder the packages are downloaded to


# 0.3 Loading Packages #

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
library(survminer) # load in graphing package for survival plots
library(survival) # load in survival analysis package

library(plm) # package for panel data regression models
?plm # view help documentation for this package

# A final note about packages: you'll see mention of performing functions or tasks using base R. This means drawing on the functions that come
# as standard with your version of R. install.packages() and write.csv() are examples of base R functions.

# For the purposes of data analysis (and most other data related tasks, frankly), we will not use base R functions; the reasons will become clear
# as we progress but it is worth noting that there is more than one way to skin a cat.


##############################################


##############################################


# 1. Getting Started with R #

# R is a programming language. It has rules, packages, syntax, complexities, idiosyncracies...
# It is not particularly easy to learn, nevermind master. It can seem as if you have to learn everything in order
# to do anything!

# Persevere: like any language, once you grasp the building blocks you will begin to feel comfortable. All of the fancy models, code and graphs
# that make it into journal articles, textbooks, presentations etc are just extensions and flourishes added on top of the basic functions and rules.

# The important thing is to expect failure and react accordingly (just like an astronaut).


# 1.1 Comments #

# This is a comment
## This is also a comment
###### ...you get the idea

# Comments are an important means of documenting your workflow and ensuring others (including future-you) can reproduce your work.

# In R studio, you can create multiline comments by highlighting the text and pressing Ctr + Shift + C. For example:

This should be a comment and not code.
Excuse me, did you hear me?
HELLLOOOO!
How rude...


# 1.2 Writing Code #

print("Hello World!") # display a message to the console

# To execute (i.e. run) the above code, highlight it and press Ctrl + Enter, or the Run icon in the top-left panel in RStudio.

# TASK: print your own personalised message to the console.


# 1.3 Data Types #

# Variables are known as 'objects' in R and can store a wide variety of data types:
# - numeric
# - string
# - boolean etc

# Each data type can have different classes i.e. numeric has integer and double (e.g. decimal).

# We assign a value to an object using the "<-" operator. We can also use "=" but this is best avoided as the equals sign has another use
# and "<-" is considered standard practice in R.

# 1.3.1 Numeric #

x <- 5 # Integer
y <- 5.5 # Double or Float

# Notice how RStudio doesn't print the value of x or y. To evaluate the assigment you need to call the object:
x
y

# Assign and evaluate in a single command:
(x <- 5)
# Our advice is to keep assignment and evaluation commands separate (those parentheses can add confusion and lead to errors) but the choice is yours...

print(x + y) # print ensures the result is displayed in the console or output window

# We can compare objects using a set of comparison operators:
x == y
x < y
x > y
x != y
x >= y
x <= y
# TASK: document what each of the comparison operators does.

a <- c(1, 4, 9, 12)
b <- c(4, 4, 9, 13)
a == b # compares each number in the vector to its corresponding number in the other vector

# Note that logical values TRUE and FALSE equate to 1 and 0 respectively, allowing us to perform arithmetic operations using these results:
sum(a == b) # 2 instances where the elements of the vector are equal

# To test if two objects are exactly equal:
identical(x, y)

print(typeof(x))
print(typeof(y)) # R stores numbers as a double by default; we need to be specific when assigning the object's value(s):

rm("x") # remove the objects from R
rm("y") # check the environment pane in the top-right hand corner of RStudio to see what objects remain in the global environment

x <- 5L # rather counterintuitively given that it's a letter, the "L" suffix ensures a number is stored as an integer
y <- 5.5
print(typeof(x)) # Now it is stored explicitly as an integer; in practice you often do not need to worry about this
print(typeof(y)) 

# Another approach is to convert an existing object:
int_var <- 20
int_var <- as.integer(int_var)
print(typeof(int_var))

# Vectors

vec <- 1:10
print(vec) # creates a vector from 1 to 10; a vector is a list of values stored in a single object
vec[1] # return the first element in vec
vec[1:5] # return the first five elements in vec
vec[-2] # return the values of the vector, excluding the second element
vec[-1:-5]
# TASK: describe the results of "vec[-1:-5]".

# The above commands are known as 'slicing' i.e. accessing a particular element(s) in a vector.

# You can also store objects as a vector:
ovec <- c(x, y) # combine the objects "x" and "y" in a vector called "ovec"
ovec

# You can count the number of elements in a vector:
length(vec)

# You can also drop elements:
vec <- vec[-2] # note that we overwrite the existing object; we could just as easily assign a new object to preserve the original
vec2 <- vec[-(4:6)] # drop 4-6 from the vector

# We can perform calculations with vectors:
a <- c(1, 2, 3, 4, 5)
b <- c(6, 7, 8, 9, 10)
c <- c(1, 2, 3)

a + b # adds each element of the vectors together in order (i.e. 1 + 6, 2 + 7 etc)
# This is known as vectorization and is a very useful property of R.

a + c # generates a warning that the vectors are not multiples of each other (i.e. one has 5 elements, the other 4)
# When vectors are of unequal length, the shorter vector is "recycled" i.e. goes back to the start.

# Generate a sequence of numbers

sequence <- seq(from = 1, to = 100, by = 5)
print(sequence) 
# TASK: describe what the seq() function is doing above.
# TASK: create a sequence of numbers that starts at 55, ends at 7000, and increases by 55 each time.

# Create a sequence based on repeating or replicating the numbers
repetition <- rep(1:10, each = 10)
print(repetition)

# Generating sequences of random numbers

# This is a useful function for performing simulations or generating data for testing ideas and techniques

# Generate 100 random numbers between 0 and 25 from a uniform distribution i.e. each number has an equal probability of being selected
runif(100, min = 0, max = 25)

# Generate 100 random numbers between 0 and 25 (with replacement)
sample(0:25, 100, replace = TRUE)

# Generate 100 random numbers between 0 and 25 (without replacement)
sample(0:25, 100, replace = FALSE)

# QUESTION: why can we not sample 100 numbers from this range without replacement?

# Generate 1000 random numbers from a normal distribution with given mean and standard deviation
normdist <- rnorm(1000, mean = 0, sd = 1)
hist(normdist) # approximately normal 
print(summary(normdist))

# Generate CDF probabilities for value(s) in vector q
pnorm(0.5, mean = 0, sd = 1)

# Generate quantile for probabilities in vector p
qnorm(0.5, mean = 0, sd = 1)

# Generate density function probabilites for value(s) in vector x
dnorm(0.5, mean = 0, sd = 1)

# Generate a vector of length n displaying the number of successes from a trial of size = 100 with a probabilty of success = 0.5
rbinom(10, size = 100, prob = 0.5)
# QUESTION: how many successes were there in 10 trials, each with a sample size of 100?

# Generate a vector of length n displaying the random number of events occuring when lambda (mean count) equals 4.
rpois(20, lambda = 4)
# TASK: vary the number of expected events and interpret the results.

# We can reproduce random numbers by setting the seed:
set.seed(1) # name the random sample "1"
rsamp1 <- rnorm(n = 10, mean = 0, sd = 1)
set.seed(1)
rsamp2 <- rnorm(n = 10, mean = 0, sd = 1)
print(rsamp1)
print(rsamp2) # produces the same values in each random sample

# Rounding numbers

x <- c(1, 1.35, 1.7, 2.05, 2.4, 2.75, 3.1, 3.45, 3.8, 4.15, 4.5, 4.85, 5.2, 5.55, 5.9)
print(x)

# Round to the nearest integer
round(x) # note how the original object is not altered - run the command "print(x)" to check

# Round up
ceiling(x)

# Round down
floor(x)

# Round to a specified decimal
round(x, digits = 1)


# 1.3.2 Strings #

# Strings (text) are stored in the character class in R.

a <- "learning to create" # create string a
b <- "character strings" # create string b
paste(a, b) # combine the strings

# Paste character and number strings (converts numbers to character class)
paste("The life of", pi)

# Paste multiple strings
paste("I", "love", "R")

# Paste multiple strings with a separating character
paste("I", "love", "R", sep = "-")

# Converting to strings

a <- "The life of"
b <- pi
is.character(b) # check if b is a string
c <- as.character(b)
is.character(c)

# Printing strings

print(a)
print(a, quote = FALSE) # easier to use the command "noquote(a)"
noquote(a)

cat(a)
cat(a, "Riley") # the cat function is useful for printing multiple objects in a readable format
cat(letters)

x <- "Today I am learning how to print strings."
y <- "Tomorrow I plan to learn about something else."
z <- "The day after that I will take a break and drink a beer."
cat(x, y, z, fill = 1) # the fill option specifies line width

# Substituting strings and numbers

x <- "The R package is great"
sprintf("You know what? %s", x) # think of "%s" as a placeholder for a string stored in an object
# TASK: call the help documentation for the "sprintf()" function.

y <- 0
sprintf("You know what? I had %d beers last night", y)
sprintf("Here are some digits from Pi: %f", pi) # "%f" is a placeholder for a number stored in an object

# Counting string elements and characters

length("How many elements are in this string?")
length(c("How", "many", "elements", "are", "in", "this", "string?"))

nchar("How many characters are in this string?")
nchar(c("How", "many", "characters", "are", "in", "this", "string?"))
# Counting elements and characters becomes very useful when constructing loops.

# Special characters

string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
string3 <- "\""
string4 <- "\'" # if we want to include a single or double quote in our string we use the backslash (\) to escape the character
# TASK: include a backslash in a string.

x <- c("\"", "\\")
x
writeLines(x) # beware that the printed representation of a string is different from the contents of the string itself
# Special characters are very useful in R but they can throw a spanner in the works; we'll deal more with them later in the workshop.

# String manipulation with stringr

# We can perform a lot of the core string manipulation tasks (e.g. removing whitespace, converting to lowercase etc)
# using base R functions. However we will use a package that simplifies the syntax: stringr

help("stringr")

# All functions in stringr start with str_ and take a vector of strings as the first argument:

x <- "Hello, this is a run-of-the-mill string."
str_length(x)
str_c(x, " ", "Not very interesting at all.") # combine strings
str_sub(x, 1, 10) 
# QUESTION: what is the str_sub function doing to the string?

y <- c("Hello", "This", "is a bog standard", "string")
str_subset(y, "[aeiou]") # returns strings matching the pattern i.e. contain a vowel
str_subset(y, "[qrstuvwxyz]")

# Change text to upper, lower or title case
uc <- "DOWN WITH THAT SORT OF THING"
lc <- "careful now"
str_to_upper(lc)
str_to_lower(uc)
str_to_title(uc) 
# QUESTION: what tv show are those strings referencing an iconic moment from?

# String matching

str_detect(y, "[aeiou]") # tells you if there?s any match to the pattern
str_count(y, "[aeiou]") # counts how many vowels are in each string
str_locate(y, "[aeiou]") # gives the position of the first match
str_extract(y, "[aeiou]") # extracts the text of the first match
str_match(y, "(.)[aeiou](.)") # extract the characters on either side of the vowel
str_replace(y, "[aeiou]", "?") # replace first match with a specified character
str_split(x, "") # split a string into individual characters based on a specified separator
str_dup(x, times = 10) # duplicates the string n times

# Removing leading and trailing whitespace

text <- c("Text ", " with", " whitespace ", " on", "both ", " sides ")
print(text)

# Remove whitespaces on both sides
str_trim(text, side = "both") # other options include "right" and "left"
str_pad("beer", width = 10, side = "left") # add whitespace on the left of the string

# Set operations for strings

set_1 <- c("lagunitas", "bells", "dogfish", "summit", "odell")
set_2 <- c("sierra", "bells", "harpoon", "lagunitas", "founders")
union(set_1, set_2) # list all individual elements from the sets
intersect(set_1, set_2) # list all common elements from the sets
setdiff(set_1, set_2) # returns elements in set_1 not in set_2; swap order of sets

# To test if two vectors contain the same elements regardless of order use setequal():

set_3 <- c("woody", "buzz", "rex")
set_4 <- c("woody", "andy", "buzz")
set_5 <- c("andy", "buzz", "woody")
setequal(set_3, set_4)

set_6 <- c("woody", "andy", "buzz")
identical(set_4, set_6) # check if sets are exactly equal (elements and order)

# Identifying if element is in string
good <- "andy"
bad <- "sid"
is.element(good, set_5) # is the word "andy" in set_5?
good %in% set_5 # same as above
# TASK: see if the word "sid" is in set_3.

# Sort a string
sort(set_5)
sort(set_5, decreasing = TRUE)

# That's enough of strings. The information they contain can be of considerable interest for quantitative data analyses and it is worth
# beginning familiar with their storage and manipulation in advance of more sophisticated analyses (e.g. Natural Language Processing).


# 1.3.3 Categorical Variables #

# Known as factor variables in R (and other packages like Stata etc), 
# they group observations into exhaustive and mutually exclusive categories.
# We'll use the forcats package to work with categorical variables in R:
library(forcats) # not part of the core tidyverse package so we need to load it in separately

# Create a factor

x <- c("male", "female", "female", "male", "female") # list of observations for biological sex
sex <- factor(x)
sex
# QUESTION: how many observations and levels are there for this factor variable?

class(sex) # confirm it is a factor variable
unclass(sex) # show the underlying values of this variable: female = 1, male = 2 (numeric values are attached to categories alphabetically by default);

# We can change the order in which numbers are attached to categories by specifying the "levels" option:
sex2 <- factor(x, levels = c("male", "female"))
levels(sex2)  # display the levels (i.e. categories) of this variable
summary(sex2) # summarise the variable i.e. frequency count

# We can convert an existing list of strings to a factor variable:
group <- c("Group1", "Group2", "Group2", "Group1", "Group1")
group2 <- factor(group)
levels(group2)

# Instead of numbering categories alphabetically, we can do so according to when a factor first appears:
las <- c("Glasgow", "Edinburgh", "Aberdeen", "Glasgow", "Orkney", "Edinburgh")
cat_las <- factor(las, unique(las))
attributes(cat_las)
unclass(cat_las)

# Ordering factor variables
ses <- c("low", "middle", "low", "low", "low", "low", "middle", "low", "middle",
         "middle", "middle", "middle", "middle", "high", "high", "low", "middle",
         "middle", "low", "high")
ses <- factor(ses, levels = c("low", "middle", "high"), ordered = TRUE)
print(ses) # categories are ordered from "low" to "high"
factor(ses, levels = rev(levels(ses))) # you can also reverse the order of levels if desired

# Recoding categorical variables

# The "plyr" package is useful for this task:
new_ses <- plyr::revalue(ses, c("low" = "small", "middle" = "medium", "high" = "large"))
print(new_ses)
levels(new_ses)
# Note that using the :: notation allows you to access the revalue() function without having to fully load in the plyr package.
# There are other ways of recoding categorical variables, none of which (in my opinion) are as easy as Stata's approach.

# Dropping categories with no observations

ses_2 <- ses[ses != "middle"] # create a new variable where ses does not equal the value "middle"
summary(ses_2)
droplevels(ses_2)


# 1.4 Saving R Files #

# This is quite simple in R: simply press Ctrl + S or select File > Save from the menu.

# We only need to save R scripts, as the .RProj file does not need updating.


# 1.5 Getting Help #

help.start() # provides general help links
help.search("regression") # searches the help system for documentation matching a given character string

help("strtrim") # finds help documentation on the "strtrim" function
?strtrim # another way of searching for help
example("strtrim") # display example code using this function
# In RStudio, you can also highlight the function in your code and press F1.

help(mean) # let's dissect the help material for the mean() function
vignette("dplyr") # some of the better-documented packages provide detailed examples of how to use its functions

# Can't quite remember the name of an object or function?
apropos("sum") # returns all objects in the global environment that contain the text "sum"

# If you need help from the web then [insert chosen search engine] is your friend.
# Likewise, the Stackoverflow website is an excellent source of help on many programming languages and data wrangling/analysis problems.
# If you experience an error message then follow the above advice by searching for the exact message you receive i.e. don't paraphrase
# your issue.


# 1.6 Keyboard Shortcuts #

# To execute R code: highlight the syntax and press Ctrl + Enter.

# To execute the entire R script (i.e. all of the code in one): press Ctrl + Shift + S.

# To insert the assignment operator (i.e '<-'): press Alt + minus key (-).

# To autocomplete your syntax: start typing the name of an object/function and press TAB.

# To insert the pipe operator (%>%): press Ctrl + Shift + M.


# 1.7 Troubleshooting #

# If you run some code and nothing happens, check the console (bottom-left pane in RStudio): if you see a plus sign (+) then
# R thinks you haven't finished writing the command and expects more code. If this happens then press the ESC key to cancel the
# command.

# R is case sensitive e.g. 'View(data)' displays the data set in a window (similar to the 'browse' function in Stata);
# 'view(data)' does nothing.


# 1.8 Debugging #

# This is the computer science term for dealing with code issues. R likes to tell you when something is not quite right,
# and not always in an intelligble manner. As progress with this workshop, you are likely to encounter the following results:

#	- message: R is communicating a diagnostic message relating to your code; your commands still execute.

#	- warning: R is highlighting an error/issue with your code, your commands still execute but the warnings need addressing.

#	- error: R is telling you there has been a fatal error with your code; your commands do not execute.

# Let's look at a simple example:
log(-1) # take the natural log of -1
# This warning tells you that the output is missing i.e. there is no natural log of a negative number.
warning() # displays the warnings associated with the most recently executed block of code

# You'll encounter plenty of messages, warnings and errors over the course of this workshop. For now, here is some general
# advice from Peng (2015) regarding what questions to ask when debugging:
#	- What was your input? How did you call the function?
#	- What were you expecting? Output, messages, other results?
#	- What did you get?
#	- How does what you get differ from what you were expecting?
#	- Were your expectations correct in the first place?
#	- Can you reproduce the problem (exactly)?



# 1.9 Environment Objects #

# We can remove some of the objects we've created (i.e. delete variables):
ls() # list existing objects

a <- "I am a useless object"
rm("a") # delete the object "a"

exists("x") # check if the object "x" exists
rm(c("x", "y")) # you can remove multiple objects by using the "c()" function

history(Inf) # displays all of the commands executed in this R session


# 1.10 Workspace Options #

help(options)
options() # wide range of options for displaying results etc
options(digits=3) # change a specific option (i.e. number of digits to print on output)
options(max.print = 9999) # set maxmimum number of rows to print to the console as 9999
options(scipen = 999) # surpress display of scientific notation


# 1.11 Predictive Analytics Examples #

# Congratulations on getting through the technical (boring) bit of the activity. To whet your appetite, here are
# some examples of the techniques you will learn over the course of the workshop.

# Import data

auto <- read_csv("./data_raw/auto.csv") # load in the (in)famous Stata "auto" data

# Expore data

View(auto) # browse the data set
head(auto) # view the first few rows of the data set
tail(auto) # view the last few rows of the data set
names(auto) # list of variable names
str(auto) # examine the structure of the data set
attributes(auto) # list the attributes (i.e. metadata) of the data set
ncol(auto) # number of columns
nrow(auto) # number of rows

# Univariate analysis

hist(auto$price) # metric variable
summary(auto$price)

ftable <- table(auto$foreign) # frequency table of categorical variable
barplot(ftable)

# Bivariate analysis

p <- ggplot(data = auto, mapping = aes(x = weight, y = price))
p + geom_point() # association between car price and weight

cor(auto$price, auto$weight) # Pearson correlation coefficient

table(auto$foreign, auto$rep78) # crosstabulation of car status and repair record
CrossTable(auto$foreign, auto$rep78, prop.c = TRUE, prop.r = FALSE, prop.t = FALSE, prop.chisq = FALSE) 

# Multivariate analysis

auto$expensive <- auto$price > 8000
mytable <- table(auto$foreign, auto$rep78, auto$expensive) # three-way table
ftable(mytable) # display the results of the three-way table in a more print-friendly format

aggregate(price ~ foreign + rep78, data = auto, mean) # table of means i.e. average price for each category of foreign and rep78

auto %>% 
  group_by(foreign, rep78) %>% 
  summarise(mean = mean(price), sd = sd(price)) # same way of producing the results of the aggregate() function

# Hypothesis testing

t.test(auto$price, mu = 5000) # one-sample test of means
t.test(price ~ foreign, data = auto) # two-sample independent test of means

cor.test(auto$price, auto$weight) # statistical significance test of Pearson r coefficient

# Don't worry if some of the results and tests are difficult to interpret; this section is just to give you a taste
# of the types of analyses we can conduct in R. Activity Two will shine light on the meaning and use of these statistics
# tests.


### END OF ACTIVITY ONE [ACT001] ###


##############################################


##############################################



# 2. Fundamental Statistical Concepts #

# In this section you will learn how to conduct a range of univariate, bivariate and multivariate analyses, including
# tests of hypotheses and statistical significance.

# A note about the data used in this activity: 
# - The files have been specially created by AQMEN for training and MUST not be used in 'real life'.
# - Do not make copies of these files or distribute them to others.

# We're using these data sets as they are in good shape for analysis, saving us the trouble of getting our data into shape.

# The rest of the activities will employ real, messy data from a variety of open data sources.


# 2.1 Importing and Exploring Data #

aqmen_data <- read_dta("./data_raw/adrc_s_training_data4.dta") # load in the training data using the read_dta() function

# Expore data

View(aqmen_data) # browse the data set
head(aqmen_data) # view the first few rows of the data set
tail(aqmen_data) # view the last few rows of the data set
names(aqmen_data) # list of variable names
str(aqmen_data) # examine the structure of the data set
attributes(aqmen_data) # list the attributes (i.e. metadata) of the data set
ncol(aqmen_data) # number of columns
nrow(aqmen_data) # number of rows


# 2.2 Univariate Analysis #

# 2.2.1 Metric (numeric) variables

summary(aqmen_data$workhours) # summary statistics for the number of hours worked per week
# TASK: make some notes on these results.

mean(aqmen_data$workhours, na.rm = TRUE) # calculate the mean
# QUESTION: why do include the na.rm = TRUE option? What happens if you remove it?

t.test(aqmen_data$workhours, na.rm = TRUE) # calculate 95% confidence intervals for the mean of workhours
# See the help documentation for how you can specify alternative confidence levels.

hist(aqmen_data$workhours) # draw a histogram of workhours
# QUESTION: what is the mode of this distribution (i.e. what is the most common value for workhours)?
# QUESTION: is the distribution positively or negatively skewed?


# 2.2.1 Categorical variables

table(aqmen_data$sex) # frequency table of respondent sex; 1 = female, 2 = male
ftab_sex <- table(aqmen_data$sex) # store the frequency table in an object to make plotting easier
barplot(ftab_sex) # create a basic bar chart

summary(as.factor(aqmen_data$sex)) # summary() function also works as long as we tell R that sex is a factor (categorical) variable

prop.table(ftab_sex) # display a table of proportions instead of frequencies
# TASK: replace 'ftab_sex' with 'aqmen_data$sex'; what happens?

# TASK: produce a frequency table and bar chart of respondent level of education (educ).


# 2.3 Bivariate Analysis #

# 2.3.1 Metric (numeric) variables

# Is there an association between working hours and age?
summary(aqmen_data$workhours)
summary(aqmen_data$age)

p <- ggplot(data = aqmen_data, mapping = aes(x = age, y = workhours)) # use ggplot() function to graph association
p + geom_point() # display the graph

# QUESTION: is there an association between age and working hours per week? Why or why not?

# Let's summarise the strength of the association using an appropriate correlation statistic:
cor(aqmen_data$age, aqmen_data$workhours, use = "complete.obs") # Pearson correlation coefficient
# use = "complete.obs" ensures missing values are overlooked when calculating the correlation coefficient.

# QUESTION: is the correlation weak or strong?

# We can select a different correlation coefficient if we have ranking variables:
hrdata <- read_csv("./data_raw/hrdata.csv")

p <- ggplot(data = hrdata, mapping = aes(x = sick, y = sales)) # use ggplot() function to graph association
p + geom_point() # display the graph
# It appears that individuals with the least sales take the most sick days.

cor(hrdata$sick, hrdata$sales, method = "spearman", use = "complete.obs") # Spearman's rank correlation coefficient
# QUESTION: is the correlation weak or strong? In which direction is the association?

cor(hrdata$sick, hrdata$sales, use = "complete.obs") # Pearson's r correlation coefficient
# QUESTION: are the two correlation estimates similar in this instance?


###
# FINISHED HERE [10/03/2019]
#
###


# 2.5 Exploratory Data Analysis

# It is good practice to quickly and systematically explore your data in order to identify analytical possibilities.

# This process is commonly known as Exploratory Data Analysis (EDA) and involves transforming (summarsing existing
# variables, creating new ones, filtering observations etc), visualising (producing plots) and modelling (building simple statistical 
# models) your data. 

# Grolemund and Wickham (2017) describe EDA as follows:
#	1. Generate questions about your data.
#	2. Search for answers by visualising, transforming, and modelling your data.
#	3. Use what you learn to refine your questions and/or generate new questions.

# EDA is NOT a substitute for employing an appropriate research design (i.e. you are not 'fishing' for research questions or statistical significance).

# Some tips of what to look for when performing EDA:
#	- how are the values of your variables distributed? 
#	- which values are most common? Which are most rare? Are there clusters in your data?
#	- are there gaps in the values of a variable?
#	- how do the values of two variables covary?
#	- what process could generate patterns between two variables? Random chance?
#	- how strong is the association between two variables? In what direction does it point? Does the pattern hold when you look at subpopulations?


### END OF ACTIVITY TWO [ACT002] ###


##############################################


##############################################



# 3. Statistical Models I and II [ACT003] #

# This section demonstrates how to construct, interpret and diagnose three common types of statistical models:
#	- linear (for metric outcomes)
#	- logistic (for binary categorical outcomes)
#	- poisson (for count outcomes)


# 3.0 Preliminaries #

# Load in the libraries necessary for working with the data



# 3.1 Linear Regression #

# 3.1.1 A quick and dirty regression

auto <- read_csv("./data_raw/auto.csv") # load in the (in)famous Stata "auto" data
auto$dom <- as.factor(auto$foreign) == "Domestic"

reg_results <- lm(formula = price ~ mpg + dom + weight + length,
                  data = auto) # regress car price on miles per gallon, domestic make, weight and length
summary(reg_results) # summarise the results of the regression
# Doesn't look as neat as it does in other packages but we'll work on tidying up the formatting later. For now:
#	1. Intercept: predicted value of price when all of the other variables take a value of zero (not substantively meaningful not an important component of the estimation)
# 2. mpg: predicted increase in price for a one-unit increase in miles per gallon
# 3. domTRUE: predicted decrease in price for being a domestic make of car (compared to being a foreign make)
#	4. weight: predicted increase in price for a one-unit increase in weight
#	5. length: predicted decrease in price for a one-unit increase in length
#	6. Pr(>|t|): under the null hypothesis (i.e. true effect size = 0), probability of observing a coefficient at least as large as you have
#	7. Multiple R-squared: proportion of variance in the outcome (price) accounted for by the model
#	8. F-statistic and p-value: under the null hypothesis (i.e. all true effect sizes = 0), probability of observing at least one coefficient at least as large as you have

# There are other model statistics output to the console that we haven't addressed above. Please ask one of the tutors if you are unsure of any of the
# properties of the model. Let's crack on with a more subtantively interesting and consequential example.

# 3.1.2 Charity income #

# RQ: what factors predict a charity's income?
# Data: Scottish Charity Register, which is an open data set provided by the regulator for Scotland (OSCR)
# Why is it of interest?: long-standing policy concern about big charities and their dominance of the sector (see Backus & Clifford, 2013)

# Import the data #

scot_char <- read_csv("./data_raw/oscr_scr_20190226.csv") # import the csv into R
scot_char # get a basic summary of the "scot_char" object

# Examine the data #

View(scot_char) # launch a window for viewing the data set (similar to the 'browse' command in Stata)
str(scot_char) # examine the structure of the object
class(scot_char) # what type of class the object is i.e. is it a vector, string, matrix, data frame etc
names(scot_char) # list of variable names

# Prepare the data #

# Keep relevant variables
scot_char_subset <- select(scot_char, `Charity Number`, `Registered Date`, `Charity Status`, `Constitutional Form`,
                           `Parent charity number`, `Most recent year expenditure`, `Geographical Spread`, 
                           `Most recent year income`)
scot_char_subset
# Note how we needed to enclose the variable names in backticks ("``"). This is because R and other languages have trouble
# parsing variables or objects with spaces in their names. We'll rename the variables in the next block of code.

# Rename variables
scot_char_subset <- rename(scot_char_subset, charnum = `Charity Number`, inc = `Most recent year income`, exp = `Most recent year expenditure`,
                           regd = `Registered Date`, charstatus = `Charity Status`, lform = `Constitutional Form`,
                           aoo = `Geographical Spread`, pchar = `Parent charity number`)
# The first argument of rename() takes an object or data frame, and then a list of variables to rename.
scot_char_subset

# Check values of variables #

# Some variables have the correct data type (i.e. inc is a floating point number) but our categorical variables are stored as strings.
# We also need to check whether there are invalid values for each of the variables.

scot_char_subset$lform # this is the legal form of a charity; let's set this as an unordered categorical variable:
scot_char_subset$lform <- factor(scot_char_subset$lform)

class(scot_char_subset$lform) # check if the variable is now a factor
levels(scot_char_subset$lform) # examine the levels (categories) of the variable
summary(scot_char_subset$lform) # frequency table of legal form
# QUESTION: how many categories of legal form are there? Which legal form is the most/least common?

scot_char_subset$lform <- relevel(as.factor(scot_char_subset$lform), ref = 10) # set the reference category to Unincorporated associations
# Some advice: it is much easier to set the reference category of a variable outside of the model code, as we have
# done above.

scot_char_subset$charstatus # this is the legal form of a charity; let's set this as an unordered categorical variable:
scot_char_subset$charstatus <- factor(scot_char_subset$charstatus)
summary(scot_char_subset$charstatus)
table(unclass(scot_char_subset$charstatus)) # view the underlying codes of the factors

scot_char_subset$aoo <- factor(scot_char_subset$aoo)
summary(scot_char_subset$aoo)
scot_char_subset$aoo # recode values of this variable to produce local, regional, national and overseas categories
scot_char_subset$aoo_r <- factor(recode(as.integer(scot_char_subset$aoo),"c(1,8)=1; c(2,3)=2; c(4,6)=3; c(5,7)=4"))
table(scot_char_subset$aoo_r)

# Drop inactive charities
scot_char_analysis <- scot_char_subset %>%
  filter(charstatus == "Active") # keep all observations where charity status is "Active"

# You may be wondering why we went to the trouble of converting our strings to categories if we still have to refer to its
# values by the string (i.e. "Active"). Well, there is a workaround:
scot_char_analysis <- scot_char_subset %>%
  filter(as.integer(charstatus) == 1) # as.integer() function tells filter() to treat the values of charstatus as numbers
table(scot_char_analysis$charstatus)

# Drop charities with zero income
scot_char_analysis <- scot_char_subset %>%
  filter(inc > 0)

# Derive new variables #

# Charity age
scot_char_analysis$regy <- year(scot_char_analysis$regd) # extract year from date
scot_char_analysis$charage <- 2019 - scot_char_analysis$regy # calculate age
head(scot_char_analysis$charage)
summary(scot_char_analysis$charage) # values look valid

# Natural log of income
scot_char_analysis$linc <- log2(scot_char_analysis$inc)
summary(scot_char_analysis$linc)
ggplot(data = scot_char_analysis) + geom_histogram(mapping = aes(linc)) # histogram of log income


# Estimate a multivariate linear regression #

# We'll specify the following model: estimate income as a function of a charity's legal form (categorical), 
# its area of operation (categorical), and its organisational age (metric).

mod1 <- lm(formula = linc ~ charage + lform + aoo_r,
           data = scot_char_analysis) # regress income on legal form, area of operation, and age
summary(mod1)
# TASK: interpret the model with respect to the following:
#	- the effects of each predictor on the outcome
#	- whether we can reject the null hypothesis relating to each predictor's effect size
#	- how well the model fits the outcome
# Remember: we transformed income using the natural log, so be sure to interpret the effect correctly.

# Graph regression results #

# Let's capture model summary statistics using some of the functions provided by the `broom` package:
?broom
vignette("broom")
# `broom` is a supremely useful package that operates at three levels:
#	- component-level i.e. model coefficients and significance values
#	- observation-level i.e. fitted values for each observation in the data
#	- model-level i.e. model summary statistics (e.g. R-squared, F test)

reg_com <- tidy(mod1, conf.int = TRUE) # use `broom`'s tidy() function to extract model coefficient information
reg_com # now we have a summary table of regression coefficients from our model; let's do some tidying up before graphing

reg_com <- filter(reg_com, term != "(Intercept)") # remove the intercept from the model table
reg_com$term <- str_replace(reg_com$term, "lform", "") # remove the 'lform' prefix from the values of 'term'
reg_com$term <- str_replace(reg_com$term, "aoo_r2", "Regional")
reg_com$term <- str_replace(reg_com$term, "aoo_r3", "National")
reg_com$term <- str_replace(reg_com$term, "aoo_r4", "Overseas") # replace with the proper names of the categories

# Plot the results of the regression
p <- ggplot(reg_com, mapping = aes(x = reorder(term, estimate), y = estimate, ymin = conf.low, ymax = conf.high))
x11()
p + geom_pointrange() + coord_flip()

# Making predictions #

# We can calculate and plot predicted outcomes for individuals and groups in our data:
reg_obs <- augment(mod1, data = scot_char_analysis) # augment collects observation-level model results (e.g. predicted outcomes)
View(reg_obs)
# augment() returns the following additional variables (Healy, 2019):
# .fitted ? The fitted values of the model
# .se.fit ? The standard errors of the fitted values
# .resid ? The residuals
# .hat ? The diagonal of the hat matrix
# .sigma ? An estimate of residual standard deviation when the corresponding observation is dropped from the model
# .cooksd ? Cook?s distance, a common regression diagnostic
# .std.resid ? The standardized residuals

p <- ggplot(data = reg_obs,
            mapping = aes(x = .fitted, y = linc)) # plot predicted vs observed values for log of income
x11()
p + geom_point()
# The predictions don't look to be great e.g. we don't predict low income for many charities. 

# Regression diagnostics #

# We should perform some checks of some of assumptions underpinning the regression model:
p <- ggplot(data = reg_obs,
            mapping = aes(x = .resid)) # check for normality
x11()
p + geom_histogram() # the residuals are slightly negatively skewed, indicating there are some observations where the predicted
# and actual values differ considerably.

p <- ggplot(data = reg_obs,
            mapping = aes(x = .fitted, y = .resid)) # check for homoscedasticity
x11()
p + geom_point() + geom_hline(yintercept = 0, size = 1.4, color = "red")
# There doesn't look to be a strong pattern in the distribution of residuals and fitted values, though the range narrows 
# for large fitted values. Therefore, it is probably worth estimating the regression using robust standard errors.

# EXERCISE: run the linear regression again with the following alterations:
#	- include expenditure as a predictor; is the model a better fit for the data?
# 	- change the reference level of area of operation to regional


##############################################


##############################################


# 3.2 Logistic Regression #

# 3.2.1 A quick and dirty regression

auto <- read_csv("./data_raw/auto.csv") # load in the (in)famous Stata "auto" data
auto$dom <- as.factor(auto$foreign) == "Domestic" # create a binary indicator of whether a car is a domestic make or not
summary(auto$dom)

reg_results <- glm(formula = dom ~ mpg + price,
                   data = auto, family = "binomial") # regress domestic make on miles per gallon and price

summary(reg_results) # summarise the results of the regression
# Doesn't look as neat as it does in other packages but we'll work on tidying up the formatting later. For now:
#	1. Intercept: predicted log odds of car being domestic when all of the other variables take a value of zero (not substantively meaningful not an important component of the estimation)
# 	2. mpg: predicted decrease in log odds of car being domestic for a one-unit increase in miles per gallon
#	3. price: predicted increase in log odds of car being domestic for a one-unit increase in weight
#	4. Pr(>|z|): under the null hypothesis (i.e. true effect size = 0), probability of observing a coefficient at least as large as you have
#	5. AIC: estimates the relative amount of information lost by a given model (useful when comparing models
#	6. Null and Residual deviance: measure of goodness-of-fit i.e. how well the model fits the data (useful when comparing models)
# 7. Deviance Residuals: the distribution of the residuals (i.e. difference between predicted and observed values). Deviance residuals are approximately normally distributed if the model is specified correctly       

# You'll notice a lack of confidence intervals; unfortunately these need to be requested separately:
confint(reg_results)

# There are other model statistics output to the console that we haven't addressed above. Please ask one of the tutors if you are unsure of any of the
# properties of the model. Let's crack on with a more subtantively interesting and consequential example.

# 3.2.2 Charity investigations 

# RQ: what factors predict a charity being investigated by the regulator?
# Data: Linked administrative data on Scottish charities, which is an open data set provided by McDonnell and Rutherford (2017) [http://hdl.handle.net/11667/94]
# Why is it of interest?: intense focus on the behaviour and accountability of charities (especially since Oxfam scandal)

# Import the data

char_inv <- read_dta("./data_raw/charityinvestigations_20170411.dta") # import the .dta file into R as a special type of data frame known as a "tibble"
char_inv # get a basic summary of the "char_inv" object

# Examine the data

View(char_inv) # launch a window for viewing the data set (similar to the 'browse' command in Stata)
str(char_inv) # examine the structure of the object
class(char_inv) # what type of class the object is i.e. is it a vector, string, matrix, data frame etc
names(char_inv) # list of variable names

# Prepare the data

# We won't focus as much on data wrangling for this example, let's just get to estimation quickly:
char_inv$constitutionalform <- factor(char_inv$constitutionalform)
char_inv$constitutionalform <- relevel(char_inv$constitutionalform, ref = 8)

char_inv$lcage <- log2(char_inv$charityage + 1) 

# Estimate a multivariate logistic regression #

# We'll specify the following model: estimate income as a function of a charity's legal form (categorical), 
# its area of operation (categorical), and its organisational age (metric).

mod2 <- glm(formula = investigated ~ constitutionalform + parentcharity + lcage,
            data = char_inv, family = "binomial") # regress investigated on legal form, having a parent charity and organisational age
summary(mod2)
# TASK: interpret the model with respect to the following:
#	- the effects of each predictor on the outcome
#	- whether we can reject the null hypothesis relating to each predictor's effect size

# Regression diagnostics #

# Check if the legal form field is statistically significant overall
wald.test(b = coef(mod2), Sigma = vcov(mod2), Terms = 2:8) 
# Yes it is.
# "2:8" identifies the number of the variable in the model i.e. the intercept is 1, constitutionalform9 is 2...

# Overall goodness-of-it

# There isn't a coefficient of determination (R-squared) statistic for logistic models as there is for OLS (though there
# are pseudo statistics). Therefore we need to employ other tests:
hoslem.test(char_inv$investigated, fitted(mod2))
# There is a statistically significant difference between the observed (char_inv$investigated) and predicted values for investigated;
# this tentatively suggests that the model is not a good fit for the data. However, in large samples small differences
# between observed and predicted values can be significant.


# Graph regression results #

# Let's capture model summary statistics using some of the functions provided by the `broom` package:
mod2_com <- tidy(mod2, conf.int = TRUE) # use `broom`'s tidy() function to extract model coefficient information
mod2_com # now we have a summary table of regression coefficients from our model; let's do some tidying up before graphing

# Calculate odds ratios i.e. exponentiate the coefficients
mod2_com <- mod2_com %>%
  mutate(or = exp(estimate), or_conf.high = exp(conf.high), or_conf.low = exp(conf.low))
# mutate() is the rather funny name for the variable create function. Above, we exponentiate the log odds and 
# confidence intervals in order to generate the odds ratios (i.e. the factor by which the odds change).

mod2_com <- filter(mod2_com, term != "(Intercept)") # remove the intercept from the model table
mod2_com$term <- str_replace(mod2_com$term, "lcage", "Charity age (log)")

# Plot the results of the regression, this time with some graph formatting:
p <- ggplot(mod2_com, mapping = aes(x = reorder(term, estimate), y = estimate, ymin = conf.low, ymax = conf.high))
x11()
p + geom_pointrange() + 
  coord_flip() +
  theme_classic() +
  labs(x = "Predictor", y = "Log Odds", title = "Predicting Regulatory Investigation", subtitle = "Scottish Charities (2006-2014)",
       caption = "Data derived from OSCR")

# TASK: replicate the graph above but for the odds ratios (and respective confidence intervals).

# Making predictions #

# We can calculate and plot predicted outcomes for individuals and groups in our data:
mod2_obs <- augment(mod2, data = char_inv) # augment collects observation-level model results (e.g. predicted outcomes)
View(mod2_obs)
# augment() returns the following additional variables (Healy, 2019):
# .fitted ? The fitted values of the model
# .se.fit ? The standard errors of the fitted values
# .resid ? The residuals
# .hat ? The diagonal of the hat matrix
# .sigma ? An estimate of residual standard deviation when the corresponding observation is dropped from the model
# .cooksd ? Cook?s distance, a common regression diagnostic
# .std.resid ? The standardized residuals

p <- ggplot(data = reg_obs,
            mapping = aes(x = .fitted, y = linc)) # plot predicted vs observed values for log of income
x11()
p + geom_point()
# The predictions don't look to be great e.g. we don't predict low income for many charities.


##############################################


##############################################


# 3.3 Count Regression #

# 3.3.1 A quick and dirty regression

psim <- read_csv("./data_raw/poisson_sim.csv") # simulated data created by Institute for Digital Research and Education at UCLA
psim$prog <- factor(psim$prog, levels=1:3, labels=c("General", "Academic", "Vocational")) # create a factor variable of program
ggplot(data = psim) + geom_histogram(mapping = aes(num_awards)) # histogram of number of awards
summary(mod1 <- glm(num_awards ~ prog + math, family="poisson", data=psim)) # regress number of awards on program and maths score

# An important point to note: the dependent variable in a Poisson model is automatically log transformed.

# Doesn't look as neat as it does in other packages but we'll work on tidying up the formatting later. For now:
#	1. Intercept: predicted number of awards (log) when all of the other variables take a value of zero (not substantively meaningful not an important component of the estimation)
#	2. progAcademic: predicted increase in number of awards (log) for being in an academic program compared to a general program
#	3. progVocational: predicted increase in number of awards (log) for being in a vocational program compared to a general program
#	4. math: predicted increase in number of awards (log) for a one-unit increase in math score
#	5. Pr(>|z|): under the null hypothesis (i.e. true effect size = 0), probability of observing a coefficient at least as large as you have
#	6. AIC: estimates the relative amount of information lost by a given model (useful when comparing models
#	7. Null and Residual deviance: measure of goodness-of-fit i.e. how well the model fits the data (useful when comparing models)
# 8. Deviance Residuals: the distribution of the residuals (i.e. difference between predicted and observed values). Deviance residuals are approximately normally distributed if the model is specified correctly       

# Count vs OLS 
# It is common for a count variable to be estimated using linear regression (OLS) instead of Poisson techniques. However, there are
# a couple of caveats to this approach:
# - linear regression estimates values in the range of minus infinity to plus infinity; count variables only take positive integers
# - count variables often have a skewed, zero-inflated distribution that require alternative approaches to standard OLS
# - count variables have a non-normal error distribution (i.e. Poisson)

# 3.3.2 Land and Buildings Transaction Tax (LBTT) 

# RQ: what factors predict the number of LBBT transactions in Scotland?
# Data: Scottish Government open data on LBBT transactions between April 2015 and January 2019 [https://statistics.gov.scot]
# Why is it of interest?: one of the few tax levers in the control of the Scottish Government and a hot topic (we are a nation of home owners after all...)

# Import the data

lbtt <- read_csv("./data_raw/lbtt_countdata_20190226.csv") # import the csv into R as a special type of data frame known as a "tibble"
lbtt # get a basic summary of the "lbbt" object

# Examine the data

View(lbtt) # launch a window for viewing the data set (similar to the 'browse' command in Stata)
str(lbtt) # examine the structure of the object
class(lbtt) # what type of class the object is i.e. is it a vector, string, matrix, data frame etc
names(lbtt) # list of variable names

# Prepare the data

# Dependent variable
summary(lbtt$Value) # it is possible for an observation to have a count of zero; keep this in mind as it affects what type of count regression is most suitable
lbtt$num_transactions <- lbtt$Value # create a new variable; you could also just rename the existing variable (R is all about choices!)

# Predictors
lbtt$year <- str_sub(lbtt$DateCode, 1, 4) # extract first four characters of the date variable (i.e. the year)

lbtt$tran_type <- as.factor(lbtt$`Type of Transaction`)
levels(lbtt$tran_type) # type of transaction
lbtt <- lbtt %>%
  filter(tran_type != "All") # drop observations listed as "All" for this variable

lbtt$prop_type <- as.factor(lbtt$`Type of Property`)
levels(lbtt$prop_type) # type of property i.e. residential vs non-residential
lbtt <- lbtt %>%
  filter(prop_type != "All") # drop observations listed as "All" for this variable

lbtt$prop_band <- as.factor(lbtt$`Total Consideration`)
levels(lbtt$prop_band) # property valuation band e.g. 0-145,000 pounds
lbtt <- lbtt %>%
  filter(prop_band != "All") # drop observations listed as "All" for this variable

nrow(lbtt) # 460 observations remaining in the data set

# Estimate a multivariate count regression #

# We'll specify the following model: estimate the number of transactions as a function of transaction type (categorical), 
# property type (categorical), property valuation band (categorical) and transaction year (ordinal categorical).

summary(mod3 <- glm(num_transactions ~ tran_type + prop_type + prop_band + year, family="poisson", data=lbtt))
# TASK: 
### FINISHED HERE!



### END OF ACTIVITY THREE [ACT003] ###


##############################################


##############################################


# AND NOW FOR SOMETHING COMPLETELY DIFFERENT

# Making a near-perfect Yorkshire Pudding - a la Vernon Gayle #

# 3 eggs
# 115g plain flour
# 285ml milk
# 12 tablespoons vegetable oil / I prefer beef dripping

# 1. Whisk the eggs, flour, salt, and milk together really well in a bowl 
to make your batter. 

# 2. Pour the batter into a jug, and let it sit for 30 minutes before you use it. 

# 3. Turn your oven up to the highest setting and place the baking tray in the 
oven to heat up for 5 minutes. 

# 4. Place 1 table spoon of oil in each indentation, 
and put the tray back into the oven and heat until oil is very hot.
 
# 5. Open oven door, slide the tray out, and carefully pour the batter in. 

# 6. Close the door and cook for 15 minutes without opening the oven door. 

# Serve immediately with roast beef (or similar) veg and gravy.


### END OF DAY ONE ###


##############################################


##############################################


### BEGINNING OF DAY TWO ###


# REMINDER: this is a new R session and you need to reload (but not reinstall) the packages you need
# for the upcoming activities. E.g. library(tidyverse)


# 4. Longitudinal Data Analysis [ACT004] #

# In this section we estimate predictive models for panel (repeated contacts) data.

# Panel data contain multiple observations per unit e.g. an individual's test results
# from each year of university, a debit card's record of transactions per day.

# Panel data can be modelled as if they were cross-sectional i.e. using the standard 
# linear regression model that we learned in Activity Two [ACT002]. However, this approach
# is often unsuitable as it ignores the fact that observations within a unit are not 
# independent e.g. pupils within a school are more likely to be similar to each other than
# they are to pupils from other schools, on average.


# RQ: what factors predict a charity's income?
# Data: England and Wales charity data, which is an open data set provided by the regulator for England and Wales (CCEW)
# Why is it of interest?: long-standing policy concern about big charities and their dominance of the sector (see Backus & Clifford, 2013)


# 4.1 Exploring panel data

# Let's load in some longitudinal data on charity income - this data set contains multiple
# financial records per charity (2007-2017).

char_fin <- read_csv("./data_raw/charity_finances_lda.csv") # read in the data

View(char_fin) # view the data set
nrow(char_fin) # display the number of observations (rows)
ncol(char_fin) # display the number of variables (columns)

char_fin_subset <- char_fin %>% 
  filter(regno==200002 | regno==205914 | regno==200050 | regno==278892 | regno==295247) # keep a subset of charities for exploratory purposes

# Quick look at income over time for these charities:

p <- ggplot(data = char_fin_subset, mapping = aes(x = year, y = income, colour = as.factor(regno)))

x11()
p + geom_line(aes(group=regno))

# Fit a linear regression line to the distribution of income over time:

p <- ggplot(data = char_fin_subset, mapping = aes(x = year, y = income))

x11()
p + geom_point() + geom_smooth(method = "lm") # fit one regression line

p <- ggplot(data = char_fin_subset, mapping = aes(x = year, y = income, group = as.factor(regno)))

x11()
p + geom_point() + geom_smooth(method = "lm") # fit separate regression lines per charity


# 4.2 Pooled cross-sectional model

# Let's ignore the longitudinal structure of the data set and estimate a standard
# linear regression model:

# Get the variables in shape for inclusion in the model

char_fin$aoo <- as.factor(char_fin$aoo)
levels(char_fin$aoo) # 1 = Local, 2 = Regional, 3 = National
table(char_fin$aoo)

ols <- plm(linc ~ age + comp + aoo, data = char_fin_pd, model= "pooling") # regress income (log) on age, company status and area of operation
summary(ols)

# TASK: interpret the results of the regression model.
# QUESTION: why might a pooled regression be unsuitable for panel data?

# Let's store the results of the model for comparison with other approaches later:

ols_res <- tidy(ols, conf.int = TRUE) # use `broom`'s tidy() function to extract model coefficient information
ols_res # now we have a summary table of regression coefficients from our model

ols_fit <- glance(ols) # use `broom`'s glance() function to extract model fit information
ols_fit # now we have a summary table of regression fit statistics from our model


# 4.3 Fixed effects model

# The pooled cross-sectional model gives us some insight into the relationship between the predictors and the outcome.
# However, it does not allow us to examine variation within units e.g. how has income fluctuated over time for charities?

# To examine and estimate within-unit variation, we need a fixed effects model.


# 4.3.1 Set data as panel data

char_fin_pd <- plm.data(char_fin, index=c("regno","year")) # tell R that an observation is uniquely identified by a combination
# of charity number and financial year

table(char_fin_pd$numobs) # number of observations per charity
hist(char_fin_pd$numobs)

# QUESTION: what is the modal number of observations per charity?

mean(char_fin_pd$linc) # mean income (log)
mean(char_fin_pd$income) # mean income

# QUESTION: why do we transform income using the natural log?


# 4.3.2 Estimate the model

fe <- plm(linc ~ age + comp + aoo, data = char_fin_pd, model= "within")
summary(fe)

# QUESTION: why does the model only include one predictor, even though we specified three in the formula?

# Let's interpret the effect of age on income: for a given charity, as age increases by one unit (i.e. year),
# log income increases by 0.000733 units.

# We can express the effect of age in terms of the original variable (i.e. actual income, not log transformed):

exp(0.000733) - 1 # calculate % decrease in income for a one-unit change in age

# QUESTION: do you think age has a meaningful effect on charity income?

# TIP: fixed effects models do not work well when there is minimal within-unit variation; in our example,
# age only changes by one year per observation and this may be too small a change to influence the outcome.

# Store the results of the model for comparison with other approaches later:

fe_res <- tidy(fe, conf.int = TRUE) # use `broom`'s tidy() function to extract model coefficient information
fe_res # now we have a summary table of regression coefficients from our model

fe_fit <- glance(fe) # use `broom`'s glance() function to extract model fit information
fe_fit # now we have a summary table of regression fit statistics from our model

# Remember how we said that fitting a fixed effects model is like including n-1 dummy (indicator) variables
# for the units in the data set? We can access these fixed effects as follows:

summary(fixef(fe, type="dmean"))


# 4.4 Between effects model

# The fixed model examined within-unit variation but at the expense of between-unit variaton.

# For example, because company status does not vary within charities (i.e. if you are established as a company
# you tend to remain as one), it is not included in the model.
# For our research question this is sub-optimal: we are very much interested in the effect of company status on
# the outcome.

# To examine between-unit variation only, we need a between effects model.

# 4.4.1 Estimate the model

be <- plm(linc ~ age + comp + aoo, data = char_fin_pd, model= "between")
summary(be)

# Let's store the results of the model for comparison with other approaches later:

be_res <- tidy(be, conf.int = TRUE) # use `broom`'s tidy() function to extract model coefficient information
be_res # now we have a summary table of regression coefficients from our model

be_fit <- glance(be) # use `broom`'s glance() function to extract model fit information
be_fit # now we have a summary table of regression fit statistics from our model


# 4.5 Random effects model

# Each of the preceding models have told us something about the variation in the outcome.

# Another approach we can take is called a random effects model: this combines the approaches of the
# fixed and between effects model i.e. it tells us something about both within and between-unit variation.

# 4.5.1 Estimate the model

re <- plm(linc ~ age + comp + aoo, data = char_fin_pd, model= "random")
summary(re)

# The interpretation of the coefficients is slightly trickier: a one-unit change in age
# results, on average, in a decrease in income across time and between charities.

# Let's store the results of the model for comparison with other approaches later:

re_res <- tidy(re, conf.int = TRUE) # use `broom`'s tidy() function to extract model coefficient information
re_res # now we have a summary table of regression coefficients from our model

re_fit <- glance(re) # use `broom`'s glance() function to extract model fit information
re_fit # now we have a summary table of regression fit statistics from our model


# 4.6 Model comparison

# Which model best captures the variation in the outcome, or the essential relationships between
# the predictors and the outcome?

# There is no simple answer and it very much depends on your research question. However, there are
# some statistical tests that can point us in the right direction.


# 4.6.1 Random vs Fixed

# The Hausman test is hypothesis test of whether the fixed or random effects model is a better fit for the data.

# H0: random effects is preferred
# HA: fixed effects is preferred

phtest(fe, re)

# The Hausman test is statistically significant (p-value < .05), indicating we should select fixed over
# random effects.


# 4.6.2 Random vs Pooled

# The Breusch-Pagan Lagrange multiplier (LM) helps you decide between a
# random effects regression and a simple OLS regression. 

# H0: regular ols is preferred
# HA: random effects is preferred

plmtest(ols, type = "bp")

# The LM test is statistically significant (p-value < .05), indicating we should select random effects 
# over a pooled model i.e. the panel component is relevant to the analysis. In our example,
# the unobserved differences between charities should be accounted for when predicting income.


# 4.6.3 Testing for heteroskedasticity

# We need to check if the variance of the error term (i.e. the difference between predicted and actual outcome)
# is constant (homoskedastistic).

# Basically, there should be no correlation between our model's error and the predictors in the model.

# I.e., when the model is 'wrong' (difference between predicted and actual), it should be wrong to roughly
# the same degree across the values of our predictors. For example, our model should not get worse at
# predicting income for very old charities.

# H0: errors are homoskedastistic
# HA: errors are heteroskedastic

library(lmtest)
bptest(re)

# In this instance we reject the null hypothesis and acknowledge that our random effects model suffers
# from the presence of heteroskedasticity.

# This is an intermediate/advanced topic and we refer you to the excellent advice contained here:
# [https://www.princeton.edu/~otorres/Panel101R.pdf]


# 4.6.4 Model fit statistics

# We can compare how well our various models account for the variation in outcome by referring to
# the model summary statistics we saved earlier:

ols_fit
re_fit
fe_fit

# The R-squared statistic is highest for the random effects model.


# 4.6.5 Model coefficients

ols
be
fe
re

# Note the estimates of the coefficients (i.e. the effects of the predictors on the outcome) change
# across the different models.


# EXERCISE:
# - include the variable "year" as a categorical predictor in the fixed and random effects models.
# - graph predicted values for income using the results of the random effects model; HINT:
#   use the augment() function to capture observation-level model statistics.
# - restrict the analysis to charities that are present in every year in the data set.


### END OF ACTIVITY FOUR [ACT004] ###



##############################################


##############################################



# 5. Duration Analysis

# In this section we examine instances where the outcome is a duration.

# We estimate a number of different models appropriate for duration data, and
# focus on interpreting the results sensibly and insightfully.


# 5.1 Charity Survival

# RQ: how long do charities survive? What factors predict organisational demise?
# Data: Linked administrative data on English charities, which is an open data set provided by the Charity Commission [http://data.charitycommission.gov.uk/]
# Why is it of interest?: the impact of the Great Recession on charity sustainability is not well understood (Clifford, 2017)


# 5.1.1 Data Wrangling

# Import data

char_regd <- read_csv("./data_raw/extract_registration.csv", na = "") # load in registration data for charities
# Note: we can tell R which values represent missing data; in this case blank records represent missing data (see data dictionary).

View(char_regd)
str(char_regd) # it looks like regdate and remdate are stored as datetime variables
head(char_regd)

# Calculate charity survival

(cdate <- Sys.Date())
cyear <- year(cdate) # get current year
char_regd$regy <- year(char_regd$regdate) # extract year from registration date
char_regd$remy <- year(char_regd$remdate) # year charity was removed from the Register

char_regd <- char_regd %>% 
  mutate(los = ifelse(!is.na(remy), remy - regy, NA))

# There's a lot to unpack with the code above; let's work from the bottom up:
# 1. We create a new variable called "los" (length of survival) based on a conditional.
# 2. The condition is the first argument (i.e. for observations with no missing data for "remy").
# 3. If the condition is met (i.e. TRUE), then "los" equals "remy - regy"; otherwise it takes the value NA.
# 4. The new variable is added to the existing data set char_regd.

hist(char_regd$los)
char_regd[1:1000,] # view the first 1000 rows

char_regd_merge <- char_regd %>% # keep selected variables, drop duplicates and sort by charity number
  distinct(regno, .keep_all = TRUE) %>% 
  select(regno, los, remy, regy) %>% 
  arrange(regno)

str(char_regd_merge)

write_rds(char_regd_merge, "./temp/ew_los_201903.rds")


# Merge with charity register with registration and area of operation data sets

char_reg <- read_csv("./data_raw/extract_charity.csv", na = "") # load in charity register
nrow(char_reg)
# str(char_reg)

char_reg <- char_reg %>% 
  distinct(regno, .keep_all = TRUE) %>% 
  select(regno:ha_no) %>% 
  arrange(regno) # drop duplicates and unneccesary variables and sort the data set by charity number


char_regd_merge <- read_rds("./temp/ew_los_201903.rds") # load in length of survival data set
char_surv <- merge(char_reg, char_regd_merge, id = "regno")

char_aoo <- read_rds("./data_raw/charity-aoo-reference-list-201902.rds") # load in area of operation data set
View(char_aoo)

table(char_aoo$aootype)
char_aoo$aoo <- ordered(char_aoo$aootype, levels = c("B", "A", "D"), labels = c("Local", "Regional", "National")) # create an ordinal variable
levels(char_aoo$aoo) # view categories of area of operation
table(as.numeric(char_aoo$aoo)) # look at codes representing each category

char_surv <- merge(char_surv, char_aoo, id = "regno") # merge with area of operation data

nrow(char_surv) # we've lost some observations due to only having area of operation information for a subset of charities
View(char_surv) # successful merge


# Create variables necessary for duration model

summary(char_surv$los) # our dependent/outcome variable is already defined

# Covariates/predictors
char_surv$subsid <- as.numeric(char_surv$subno > 0) # charity has subsidiaries

table(char_surv$subsid) # dummy variable
table(char_surv$aoo) # the reference category is "Local"


# 5.1.2 Duration Model

# Let's estimate a simple linear regression model of the length of survival

mod1 <- lm(formula = los ~ aoo + subsid, data = char_surv) # regress income on legal form, area of operation, and age
summary(mod1)

# TASK: interpret the effects of the predictors on the outcome.

# This duration model is hopelessly compromised by right-censored observations i.e. "(165594 observations deleted due to missingness)".
# Basically, the model only refers to charities that have dissolved, not those still around. We could try and impute
# values for how long these organisations survived (i.e. their current age) but this would introduce bias.

# Our data are much better modelled using a survival analysis approach.


# 5.2 Survival Analysis

# Create the variables necessary for the model

# Time
char_surv$year <- char_surv$regy # use registration year as the time variable (this is fine as there are no gaps in this measure)

# Event
char_surv$diss <- as.numeric(char_surv$orgtype == "RM") # a charity is dissolved if its registration status == "RM"
table(char_surv$diss) 

# Survival time
hist(char_surv$los) # currently this is only calculated for charities that have dissolved; let's also included charities that
# are still operating:

char_surv <- char_surv %>% 
  mutate(st = ifelse(is.na(remy), 2019 - regy, remy - regy))

# There's a lot to unpack with the code above:
# 1. We create a new variable called "st" based on a conditional.
# 2. The condition is the first argument (i.e. for observations with missing data for "remy").
# 3. If the condition is met (i.e. TRUE), then "age" equals "2019 - regy"; otherwise remy - regy".
# 4. The new variable is added to the existing data set char_surv.

hist(char_surv$st)


# Let's state some questions in order to focus our analysis:

# 1. What is the probability of surviving to a certain point in time?
# 2. What is the average survival time?

# 1. A Kaplan-Meier (KM) plot summarises the distribution of the survival time variable.

Surv(char_surv$st, char_surv$diss)[1:10] # look at the survival time for the first ten observations
# QUESTION: what do you think the plus sign ("+") signifies?

x11()
plot(survfit(Surv(st, diss) ~ 1, data = char_surv), 
     xlab = "Years", 
     ylab = "Overall survival probability")

# QUESTION: what is the probability of surviving until 20 years old? HINT: trace your finger up from the x-axis...
# REMEMBER: the survival curve is a probability distribution


sest <- survfit(Surv(st, diss) ~ 1, data = char_surv)
names(sest) # the survfit() function returns a number of variables that we can use to estimate survival probabilities:

# What is the probability of surviving until 20 years old?

summary(survfit(Surv(st, diss) ~ 1, data = char_surv), times = 20) # ~77% chance of making it to 20

summary(survfit(Surv(st, diss) ~ 1, data = char_surv)) # for all time periods in the data set
# n.risk = number of charities at risk of dissolution in that period.
# n.event = number of dissolutions in that period.
# survival = probability of dissolution in that period.
# std.err, lower CI, upper C_ = standard error and 95% confidence intervals for the estimate of surivival probability.

# 2. What is the average survival time?

survfit(Surv(st, diss) ~ 1, data = char_surv) # just call this function again, without wrapping it in a summary() function

median(char_surv$st[char_surv$diss==1], na.rm = TRUE)
# The above median() function calculates the average survival time for charities that have dissolved.
# This ia an incorrect estimate as it ignores the fact that censored charities also contribute survival time.


# Comparing survival times between types of charities

# Let's explore whether survival times vary by area of operation:

x11()
ggsurvplot(
  fit = survfit(Surv(st, diss) ~ aoo, data = char_surv), 
  xlab = "Years",
  ylab = "Overall survival probability",
  legend.title = "Area of Operation",
  legend.labs = c("Local", "Regional", "National"),
  break.x.by = 10, 
  censor = FALSE,
  risk.table = TRUE,
  risk.table.y.text = FALSE)

# QUESTION: which type of charity has the best chance of survival? Does this vary over time?

summary(survfit(Surv(st, diss) ~ aoo, data = char_surv), times = 20) # the formatting is a bit rubbish but we can still interpret the numbers

# We can conduct a log-rank test to see if there is a statistically significant difference in overall survival 
# by area of operation:

survdiff(Surv(st, diss) ~ aoo, data = char_surv)

# QUESTION: can we conclude that there are statistically significant differences in overall survival by area of operation?


# Regression Model of Survival Hazard

# The Cox regression model assesses the relative effect of predictors on the variation in an outcome.

# Instead of modelling the duration as the dependent variable, a Cox model estimates the hazard of the event occuring.
# In our example, the dependent variable will be the hazard (i.e. log odds relative to a reference group)
# of dissolution for a charity.

# Some key assumptions of the model:
# - non-informative censoring
# - proportional hazards i.e. the effect of a predictor does not vary over time

cox_mod <- coxph(Surv(st, diss) ~ aoo, data = char_surv) # estimate the model
summary(cox_mod) # Rsquare is extremely low - this model has very little explanatory power
# We see that the log odds of dissolution are higher for Regional charities compared to Local organisations;
# National charities have lower log odds than their Local peers.

# Check if area of operation is statistically significant overall
wald.test(b = coef(cox_mod), Sigma = vcov(cox_mod), Terms = 1:2) 
# Yes it is. "1:2" identifies the number of the variable in the model.

cox_tidy <- tidy(cox_mod) # tidy the results of the Cox regression
cox_tidy$term <- str_replace(cox_tidy$term, "aoo.L", "Regional")
cox_tidy$term <- str_replace(cox_tidy$term, "aoo.Q", "National")

cox_tidy # view the tidied results of the Cox regression

# We can plot the Cox hazard function (analogous to the KM plot)
cox_curve <- survfit(cox_mod)
x11()
plot(cox_curve) # not much difference between the KM and Cox plots (unsurprising given the model only includes one predictor)


# Now let's interpret the log odds as a hazard ratio instead
summary(cox_mod)
# The exp(coef) field displays the hazard ratios: Regional charities have a hazard of dissolution 1.12 times higher than
# Local charities.

# EXERCISE:
# 1. Create a variable measuring which decade a charity was registered in.
# 2. Plot the KM curves for categories of this variable.
# 3. Add this variable to the Cox regression model and interpret its effect on the outcome.

# If you get stuck then scroll to the bottom of this activity for a solution.
#
#
#
#
#
#
#
#
#
#
# Keep going...
#
#
#
#
#
#
#
#
# SOLUTION:

min(char_surv$regy, na.rm = TRUE)
max(char_surv$regy, na.rm = TRUE)

# Create a categorical variable from registered year:
char_surv$decade <- cut(char_surv$regy, seq(1960,2019, 9), 
                        labels = c("1960", "1970", "1980", "1990", "2000", "2010")) 
table(char_surv$decade)

# Plot KM curve
x11()
ggsurvplot(
  fit = survfit(Surv(st, diss) ~ decade, data = char_surv), 
  xlab = "Years",
  ylab = "Overall survival probability",
  legend.title = "Area of Operation",
  legend.labs = c("1960", "1970", "1980", "1990", "2000", "2010"),
  break.x.by = 10, 
  censor = FALSE,
  risk.table = TRUE,
  risk.table.y.text = FALSE)

# Estimate a Cox ph model
cox_mod <- coxph(Surv(st, diss) ~ aoo + decade, data = char_surv) # estimate the model
summary(cox_mod)

cox_curve <- survfit(cox_mod)
x11()
plot(cox_curve)

# Obviously this is a slightly strange example: of course survival time is related to when a charity was founded.
# Still, it highlights some of the many issues you need to grapple with when estimating these types of models.


### END OF ACTIVITY FIVE ###



##############################################


##############################################




# Final Thoughts #

# Congratulations on progressing through the workshop. Our aim was to equip you, as rapidly and painlessly as possible,
# with a proficiency in predictive analytics using R .

# While you have covered a great deal of material and skills, there is a bigger and badder world of R programming and wrangling out there.

# Take a look at some of the suggested resources on workshop Github repository [https://github.com/DiarmuidM/aqmen-data-wrangling-in-R/tree/master/resources].

# Hopefully this workshop has gone some way to convincing you of the value of adopting
# social science approaches and tools for data science work; if not then let us know how we can improve;
# if so then please engage with us on further topics and tools e.g. Social Network Analysis, Reproducible Data Analytics.

# Good luck with future data wrangling and analytics work.


# "Big wheels rolling through fields
# Where sunlight streams
# Meet me in a land of hope and dreams"

# - Bruce Springsteen, Land of Hope and Dreams (2012)


########################################### FIN ##################################################