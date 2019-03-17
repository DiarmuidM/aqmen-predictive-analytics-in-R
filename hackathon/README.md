# Predictive Analytics

## Hackathon

### Challenge 1

The [Consumer Data Research Centre](https://data.cdrc.ac.uk) hosts a number of open data sets for public use. One such data set relates to estimates of population density and urban/rural classification for U.K. small geographies.

_Your mission, should you choose to accept it..._

1. Download the [data set](https://data.cdrc.ac.uk/dataset/population-density-and-urban-rural-classification) from the CDRC website and load it into RStudio.
2. Produce a count regression model of population density (```density_ppha```) that contains one predictor (```unified_classif```).
3. Interpret the results and make a statement about the effect of urban/rural classification on population density.
4. Adjust the model by replacing the predictor with the more granular version of urban/rural classification (```source_classif```).
5. Test the sensitivity of your results by estimating linear regressions with the same variables; are the results comparable to the count models?

<br>

### Challenge 2

The [Consumer Data Research Centre](https://data.cdrc.ac.uk) hosts a number of open data sets for public use. One such data set relates to measures of material deprivation for Scottish small-area geographies.

_Your mission, should you choose to accept it..._

1. Download the [data set](https://data.cdrc.ac.uk/dataset/simd2016) from the CDRC website and load it into RStudio. There may be some data cleaning to perform at this stage, so make sure to open the raw data before loading it into RStudio.
2. Produce a linear regression model of deprivation rank (```SIMD_2016_Percentile```) that contains the following predictors (```Working_age_population_Revised, Council_area, Income_rate, and NEET```).
3. Interpret the results and make a statement about the effect of each of the predictors on the outcome.
4. Create a binary outcome variable indicating whether an area is in the lowest deprivation decile and estimate a logistic regression using the same predictors.
