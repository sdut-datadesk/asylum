# Asylum data analysis and findings
By: [Lauryn Schroeder](https://www.sandiegouniontribune.com/sdut-lauryn-schroeder-staff.html) and [Kate Morrissey](https://www.sandiegouniontribune.com/sdut-kate-morrissey-staff.html)

This repository contains data and code for the analysis [reported and published](https://www.sandiegouniontribune.com/news/immigration/story/2020-08-23/who-gets-asylum-even-before-trump-system-was-riddled-with-bias-and-disparities) by *The San Diego Union-Tribune* on Aug. 23, 2020. The article is Part II, of "Returned," a multi-part series that aims to help readers understand what the U.S. asylum system was meant to do, how it previously functioned and what it has become.

[Read Part I of the "Returned" series](https://www.sandiegouniontribune.com/news/immigration/story/2020-02-24/protecting-the-worlds-most-vulnerable-what-it-takes-to-make-a-case-under-us-asylum-system#nt=00000170-75a7-d4fb-a17d-7de7f56b0001-liS0promoButtonnt=00000170-75a7-d4fb-a17d-7de7f56b0001-liS0promoButton), published on Feb. 24, 2020.

### Methodology

Immigration court records are collected, tracked and released monthly by the Executive Office for Immigration Review (EOIR) within the Department of Justice. The Union-Tribune used the June 2019 release of [EOIR case data](https://www.justice.gov/eoir/foia-library-0) in its analysis.

Since case information is entered manually, various columns throughout the more than 50 million rows of data in the various tables contained slight inconsistencies, and the Union-Tribune cleaned these entries when necessary.

The analysis includes any cases with asylum applications that were completed from fiscal 2009 through fiscal 2018. Cases flagged as legal permanent residents, rider cases, cases originating with U.S. Citizenship and Immigration Services, and cases that did not include either a charge of being present without admission or arriving without a valid entry document were excluded from the analysis. Cases with incomplete information on these distinctions remained in the analysis.

Judges who heard less than 50 cases in a particular location and nationalities with less than 100 cases during the 10-year period were excluded to prevent skewed results.

Judge work histories were gathered by the Union-Tribune based on summaries released by EOIR when the judge was hired. When necessary, histories were confirmed or clarified using news clippings, court records, law firm biographies, law school newsletters, and in some cases, contacting individuals directly.

With guidance from statisticians, the Union-Tribune performed various statistical tests, including logistic and multivariate regressions, to determine the significance of findings.

### The SDUT-asylum repository contains the following:

- `asylum-cases.csv` - Cases with asylum applications filed that received initial decisions from FY 2009 through FY 2018.
- `asylum-cases-dictionary.csv` - A data dictionary of column and column entry descriptions. See [EOIR data key](https://www.justice.gov/eoir/page/file/eoir-case-data-code-key/download) for additional code descriptions.
- `narrative-analysis.R` - R script documenting findings used in the interactive narrative graphic that walks readers through the asylum system.
- `outcomes-analysis.R` - R script for analysis on asylum outcomes and interactive bubble graphic published in Part 2.
- `statistical-analysis.R` - R script for statistical analysis factors that impact asylum outcomes.

### Sourcing
Please link and source [*The San Diego Union-Tribune*](https://www.sandiegouniontribune.com/) when referencing any analysis or findings in published work.

### Questions / Feedback

Email Lauryn Schroeder at [lauryn.schroeder@sduniontribune.com](mailto:lauryn.schroeder@sduniontribune.com) or Kate Morrissey at [kate.morrissey@sduniontribune.com](mailto:kate.morrissey@sduniontribune.com).
