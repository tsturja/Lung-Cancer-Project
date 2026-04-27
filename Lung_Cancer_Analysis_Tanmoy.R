# Load data
data <- read.csv("survey lung cancer.csv")

str(data)
View(data)

## Install Packages
install.packages(c("tidyverse", "ggplot2", "readr", "dplyr", "ggthemes", "scales", "lubridate", "RColorBrewer"))
# Load the libraries
library(tidyverse)
library(ggplot2)
library(readr)
library(dplyr)
library(ggthemes)
library(scales)
library(lubridate)
library(corrplot)
library(RColorBrewer)

## Data Cleaning

## Replace the values of 2 and 1 with Yes and No
data_cleaned <- as.data.frame(lapply(data, function(x) {
  if (is.numeric(x)) {
    x[x == 2] <- "YES"
    x[x == 1] <- "NO"
  }
  return(x)
}))

View(data_cleaned)

# The AGE field is not be numeric yet
data_cleaned$AGE <- as.integer(as.character(data$AGE))
str(data_cleaned)

## Export Clean Dataset
write.csv(data_cleaned, "cleaned_lung_cancer_data.csv", row.names = FALSE)

## Research Questions

## 1. What is the overall probability of lung cancer in the surveyed population?

lung_cancer_table <- table(data_cleaned$LUNG_CANCER)
lung_cancer_prob <- prop.table(lung_cancer_table)
print(lung_cancer_prob) 
## This gives us the overall probability of lung cancer in the surveyed population- 87%

## 2. How does the probability of lung cancer vary across different age groups?

## Create age groups
data_cleaned$AGE_GROUP <- cut(data_cleaned$AGE,
                      breaks = c(0, 50, 60, 70, Inf),
                      labels = c("<50", "50-60", "61-70", "71+"),
                      right = FALSE)

View(data_cleaned)
## Calculate average (probability) of lung cancer in each age group
age_group_prob <- data_cleaned %>%
  group_by(AGE_GROUP) %>%
  summarise(Probability = sum(LUNG_CANCER == "YES") / n())

View(age_group_prob) 

## Visual representation
ggplot(age_group_prob, aes(x = AGE_GROUP, y = Probability,
                           fill = AGE_GROUP)) +
  geom_bar(stat = "identity", width = 0.6) +
  geom_text(aes(label = percent(Probability, accuracy = 0.1)),
            vjust = -0.5, size = 4) +
  labs(title = "Probability of Lung Cancer by Age Group",
       x = "Age Group",
       y = "Probability") +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  theme_clean() +
  theme(legend.position = "none")

## Findings: It does not add up to 100% because I am Calculating the probability of lung cancer within each age group — not the percentage of lung cancer cases distributed among age groups.

## Follow up question: Among all people with lung cancer, how many are from each age group?

age_grp_percentage <- data_cleaned %>%
  filter(LUNG_CANCER == "YES") %>%
  count(AGE_GROUP) %>%
  mutate(Percentage = n / sum(n) * 100)
View(age_grp_percentage)

##This result adds up to 100

## 3. What is the probability of a person being a smoker given that they have lung cancer?

# Filter only the people who have lung cancer
lung_cancer_patients <- data_cleaned %>%
  filter(LUNG_CANCER == "YES")
View(lung_cancer_patients) 

# Create a table of smoking status among lung cancer patients
table_smoking <- table(lung_cancer_patients$SMOKING) 

# Calculate the probability of being a smoker among them
prob_smoking_given_cancer <- prop.table(table_smoking) 

print(prob_smoking_given_cancer) 

## Finding: 57% of the Lung cancer patients were smokers

## 4. Can we estimate the average age of lung cancer diagnosis using a random sample from the dataset?

# Take a random sample (e.g., 30 people)
set.seed(42)  # for reproducibility
sample_patients <- sample_n(lung_cancer_patients, size = 30)
View(sample_patients)

# Calculate the average age from the sample
average_age_sample <- mean(sample_patients$AGE)

# Print the result
print(average_age_sample) 

## Shows the average age of lung cancer diagnosis using random sample from the data is 63.6.

## 5. How does the uncertainty in risk factors affect the probability of developing lung cancer?

# Convert all "YES"/"NO" columns to binary (1/0)
data_binary <- data_cleaned
data_binary[] <- lapply(data_binary, function(x) {
  if (is.character(x) || is.factor(x)) {
    if (all(unique(x) %in% c("YES", "NO"))) {
      return(ifelse(x == "YES", 1, 0))
    }
  }
  return(x)
})

# Keep only numeric columns
numeric_data <- data_binary[sapply(data_binary, is.numeric)]

# Create the correlation matrix
cor_matrix <- cor(numeric_data, use = "complete.obs")

# Plot with correlation coefficient labels
corrplot(cor_matrix, 
         method = "color",                      # Color shading
         type = "upper",                        # Show upper triangle only
         tl.col = "red",                        # Label color
         tl.srt = 45,                           # Rotate labels vertically
         tl.cex = 0.6,                          # Font size of variable labels
         addCoef.col = "black",                # Add correlation numbers
         number.cex = 0.7,                      # Size of numbers
         col = brewer.pal(n = 9, name = "Set3"), # Use Set3 palette
         title = "Correlation Matrix of Lung Cancer Risk Factors",
         mar = c(0, 0, 2, 0),                   # Adjust top margin for title
         cl.pos = "r",                          # Show color legend on the right
         cl.cex = 0.7                           # Font size of the legend
)

# This is a correlation matrix showing how different risk factors are related to each other and to lung cancer diagnosis.
# Each cell in the upper triangle of the matrix shows a correlation coefficient — a number between -1 and +1 — that measures the strength and direction of a relationship.

# Key Findings from Correlation Matrix:
# Smoking is strongly correlated with yellow fingers (r = 0.57).
# Coughing, wheezing, fatigue, and alcohol use show moderate correlation with lung cancer.
# Anxiety and alcohol consumption are moderately related (r = 0.49).
# Age, peer pressure, and shortness of breath show weak correlation with lung cancer.
# Results support using key symptoms and behaviors as predictors.

# Fits a logistic regression model

# Including risk factors like SMOKING, ANXIETY, COUGHING, etc.
model <- glm(LUNG_CANCER ~ SMOKING + COUGHING + WHEEZING + FATIGUE + 
               YELLOW_FINGERS + ALCOHOL.CONSUMING + CHRONIC.DISEASE,
             data = data_binary, family = binomial)

# See the model results

## Key Findings:
# All variables included in the model were found to be statistically significant predictors of lung cancer (p < 0.05), indicating strong associations between each factor and the likelihood of developing the disease.
# Fatigue, yellow fingers, alcohol consumption, and chronic disease showed particularly strong effects, suggesting they are critical indicators to monitor for early detection.
# Coughing, wheezing, and smoking also contributed significantly, aligning with known clinical symptoms and behavioral risks.
# This model confirms that a combination of symptoms (like coughing and fatigue) and lifestyle choices (such as smoking and alcohol use) significantly increase the probability of lung cancer. These insights can support data-driven screening strategies and preventive health interventions.
