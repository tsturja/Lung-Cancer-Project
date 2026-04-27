# 🫁 Risk Modeling of Lung Cancer Likelihood Based on Lifestyle and Health Factors

> An exploratory data analysis and statistical modeling project in **R**, examining how lifestyle habits and health symptoms influence the likelihood of a lung cancer diagnosis.

![R](https://img.shields.io/badge/R-4.x-276DC3?logo=r&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success)
![Type](https://img.shields.io/badge/Project-Portfolio-blue)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

---

## 📋 Overview

This project investigates the relationship between common lifestyle factors (smoking, alcohol consumption), clinical symptoms (coughing, wheezing, fatigue, chest pain), and the probability of being diagnosed with lung cancer. Using a survey dataset of **309 respondents**, the analysis combines descriptive statistics, conditional probability, sampling, correlation analysis, and **logistic regression** to identify the strongest predictors of the disease.

The goal is twofold:

1. Practice an end-to-end data analysis workflow in R — from raw data to insight.
2. Surface findings that could realistically support **early-screening strategies** and **preventive health interventions**.

---

## 📊 Dataset

- **Source:** [Lung Cancer Dataset — Kaggle](https://www.kaggle.com/datasets/akashnath29/lung-cancer-dataset)
- **Records:** 309 survey responses
- **Features:** 16 variables — demographics (gender, age), behavioral factors (smoking, alcohol consumption, peer pressure), and symptoms (yellow fingers, anxiety, chronic disease, fatigue, allergy, wheezing, coughing, shortness of breath, swallowing difficulty, chest pain)
- **Target variable:** `LUNG_CANCER` (`YES` / `NO`)

In the raw data, binary fields are encoded as `1` (No) and `2` (Yes), which were re-mapped to readable labels during cleaning.

---

## 🎯 Research Questions

This analysis was structured around five guiding questions:

1. What is the overall probability of lung cancer in the surveyed population?
2. How does the probability of lung cancer vary across different age groups?
3. What is the probability of a person being a smoker given that they have lung cancer?
4. Can we estimate the average age of lung cancer diagnosis using a random sample from the dataset?
5. How do various risk factors affect the probability of developing lung cancer?

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **R** | Core language for analysis |
| **tidyverse / dplyr** | Data manipulation and wrangling |
| **ggplot2 / ggthemes / scales** | Data visualization |
| **corrplot / RColorBrewer** | Correlation matrix visualization |
| **readr / lubridate** | Data import and date handling |
| **glm()** | Logistic regression modeling |

---

## 📁 Repository Structure

```
.
├── survey_lung_cancer.csv              # Raw dataset from Kaggle
├── cleaned_lung_cancer_data.csv        # Cleaned dataset (output of the script)
├── Lung_Cancer_Analysis_Tanmoy.R       # Main analysis script
├── Final_Presentation_Tanmoy.pptx      # Final presentation deck
└── README.md
```

---

## 🔬 Methodology

The workflow follows a clean, reproducible pipeline:

**1. Data Cleaning**
Replaced the numeric encoding (`1` / `2`) with the labels `NO` / `YES` to make the dataset readable, recast `AGE` as an integer, and exported a cleaned version for downstream use.

**2. Exploratory Data Analysis**
Computed overall and conditional probabilities (e.g., `P(Smoker | Lung Cancer)`), grouped patients into age buckets (`<50`, `50–60`, `61–70`, `71+`), and visualized lung cancer probability across these groups.

**3. Random Sampling**
Drew a reproducible random sample (`set.seed(42)`, n = 30) from confirmed lung cancer patients to estimate the average age of diagnosis.

**4. Correlation Analysis**
Converted all categorical Yes/No features to binary (1/0), then built a correlation matrix across all numeric features and visualized it with `corrplot`.

**5. Logistic Regression**
Fit a binomial GLM with the most clinically relevant predictors:

```r
model <- glm(LUNG_CANCER ~ SMOKING + COUGHING + WHEEZING + FATIGUE +
               YELLOW_FINGERS + ALCOHOL.CONSUMING + CHRONIC.DISEASE,
             data = data_binary, family = binomial)
```

---

## 📈 Key Findings

- **~87%** of respondents in the dataset were diagnosed with lung cancer — the dataset is heavily skewed toward positive cases, which is important context for interpreting the model.
- **57%** of lung cancer patients in the data were smokers (`P(Smoker | Lung Cancer) ≈ 0.57`).
- The **average age of diagnosis** from the random sample was approximately **63.6 years**, consistent with real-world clinical patterns.
- **Smoking and yellow fingers** showed the strongest pairwise correlation (`r ≈ 0.57`) — a recognizable behavioral-symptom pairing.
- **Coughing, wheezing, fatigue, and alcohol consumption** all showed moderate correlation with a lung cancer diagnosis.
- In the logistic regression, **all selected predictors were statistically significant (p < 0.05)**, with **fatigue, yellow fingers, alcohol consumption, and chronic disease** showing the strongest effects.
- Together, the analysis supports the case that a **combination of symptoms and lifestyle factors** — rather than any single variable — drives lung cancer risk, which has practical implications for screening checklists.

> **Note on bias:** Because ~87% of the sample is `YES`, the model is fit on a strongly imbalanced dataset. Findings should be read as exploratory associations from this sample, not population-level prevalence.

---

## 🚀 How to Run

**Prerequisites:** R (≥ 4.0) and RStudio recommended.

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/<your-repo>.git
   cd <your-repo>
   ```

2. **Install required packages** (only the first time)
   ```r
   install.packages(c("tidyverse", "ggplot2", "readr", "dplyr",
                      "ggthemes", "scales", "lubridate",
                      "corrplot", "RColorBrewer"))
   ```

3. **Run the analysis**
   Open `Lung_Cancer_Analysis_Tanmoy.R` in RStudio and run it section by section, or from the R console:
   ```r
   source("Lung_Cancer_Analysis_Tanmoy.R")
   ```

   Make sure the working directory contains `survey_lung_cancer.csv`, or update the path in the `read.csv()` call at the top of the script.

---

## 📑 Presentation

A summary of the analysis, visualizations, and conclusions is available in `Final_Presentation_Tanmoy.pptx`.

---

## 🔮 Future Work

- Address the class imbalance using techniques like **SMOTE** or **stratified sampling** for more robust modeling.
- Split the data into **train / test sets** and report classification metrics (accuracy, precision, recall, AUC).
- Compare logistic regression with **tree-based models** (random forest, XGBoost) to see if non-linear interactions improve predictive power.
- Build a small **R Shiny app** so a user can input symptoms and get an estimated risk score interactively.

---

## 👤 Author

**Tanmoy Saha Turja**

If you found this project useful or have feedback, feel free to connect or open an issue.

---

## 📜 License

Released under the MIT License — feel free to use, adapt, and build on this work with attribution.

---

## 🙏 Acknowledgments

- Dataset by [Akash Nath](https://www.kaggle.com/akashnath29) on Kaggle.
- The R community for the open-source tooling that made this analysis possible.
