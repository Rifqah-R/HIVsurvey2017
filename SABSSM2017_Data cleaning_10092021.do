*Stata version
15.1
*** 
************************************************************************
* PART 0: TABLE OF CONTENTS
************************************************************************
clear

* start log 
*capture log close
*log using 


* Project: [Multimorbidity in South Africa - SABSSM 2017]
* Creator: [Rifqah Roomaney, rifqah.roomaney@mrc.ac.za, 24/05/2021] 
* Purpose of do-file: Create a subset of all variables of interest
/*
	Outline
	Part 1: Housekeeping & Introduction
	
*/
************************************************************************
* PART 1: HOUSEKEEPING & INTRODUCTION
************************************************************************
*set more off, permanently //This gives all the output at once without having to click "more"

*Setting file path
global BASE "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS"

* SOURCE FILES DIRECTORIES
global SABSSM2017 "SABSSM\Dataset\2017\SABSSM2017_Combined.dta"

use "$BASE/$SABSSM2017", clear

* Keep only adults
drop if age_q<15  //drop children (21 470 observations dropped)
count  // 45 145 adults in sample
drop if fresp >2 // drop respondent if they refused to participate (4,143 observations deleted)
count // (41002 adults)

#delimit ; 
keep 
province districtname sal //Province (strata), district, SAL (PSU)
persno g_person_no persno specimenrefno hh_qnr_no // cluster number ? & household number ? & line number ?
sex_q age_q   age5 age15to49 age50plus // sex & age
ibreal1_sabssm ibreal12_sabssm  //  weight - specimen and questionnaire (ibreal12_sabbsm) 
geotype // geotype
race_q // race
q1_15c // education
q1_10 // income
q1_7 //  employment situation
q7_2 // current pregnancy
hivstat // HIV status
q13_7a_i q13_7a_ii //hypertension
q13_7b_i q13_7b_ii // diabetes
q13_7c_i q13_7c_ii // TB
q13_7d_i q13_7d_ii // Cancer
q13_7e_i q13_7e_ii // HIV
q13_7f_i q13_7f_ii // Heart disease
q11_1 q11_2; // alcohol


****************************
*CLEAN VARIABLES           *
****************************

gen id=_n 					// generate N variable
rename sal psu 			
rename province stratum  		// rename stratum variable
rename ibreal12_sabssm csweight  // questionnaire weight or specimen weight?? - VPvW suggested using the specimen weight
replace csweight = csweight/1000000 	// 

****Renaming variables
* Age
rename  age_q  age 			// rename age

* Gender
rename sex_q gender
label def gender 2 "Female" 1 "Male", replace
label val gender gender

* Urban / rural
recode geotype (1=1) (2=0) (3=0), gen(urban) // generate urban/rural variable
label def urban 1 "Urban" 0 "Rural"
label val urban urban
label variable urban "Rural/urban"
tab urban

* Race
recode race_q (1=1)(2=3)(3=4)(4=2)(5/10000=.), gen(race) //generate and reorder race
label def race 1 "Black" 2 "White" 3 "Coloured" 4 "Asian"
label val race race

* Pregnancy
rename q7_2 pregn

* Education
recode q1_15c(0/7=1)(8/12=2)(13/15=3)(98=.), gen(educat)	// reorder education level
label def educat 1 "None/Primary" 2 "Secondary" 3 "Tertiary"	
label val educat educat
label variable educat "Education category"

* Employment
recode q1_7 (1=0)(2=0)(3=0)(4=1)(5=.), gen(employed) //5=other
label def employed 1 "Employed/Self-employed" 0 "Unemployed/disabled/student" 
label val employed employed


*wealth >>This code is from Sean Jooste at the HSRC, used in a paper
** Assert based SES - I have this code but not the variables so ignore this
 
*rename HH_Q1A HH_Q3 HH_Q4  HH_Q5  HH_Q6_1_ELECTRICITY HH_Q6_2_RADIO HH_Q6_3_TELEVISION HH_Q6_4_TELEPHONE_LANDLINE HH_Q6_5_CELLPHONE HH_Q6_6_REFRIGERATOR HH_Q6_7_PC_LAPTOP_TABLET HH_Q6_8_WASHING_MACHINE HH_Q6_9_SOLAR_PANEL HH_Q6_10_MOTOR_VEHICLE, lower
 *mca hh_q1a hh_q3 hh_q4 hh_q5 hh_q6_1_electricity hh_q6_2_radio hh_q6_3_television hh_q6_4_telephone_landline hh_q6_6_refrigerator hh_q6_7_pc_laptop_tablet hh_q6_8_washing_machine hh_q6_9_solar_panel hh_q6_10_motor_vehicle, norm(standard)
*predict P3, rowscores
*estat coord, stats
*estat summarize
*xtile quintiles3=P3,nq(3)
*label var quintiles3 "Asset based SES"
*label define quintiles3 1 "Low SES" 2 "Middle SES" 3 "HIGH SES"  
*label values quintiles3 quintiles3
*tab quintiles3
 
*mca hh_q1a hh_q3 hh_q4 hh_q5 hh_q6_1_electricity hh_q6_2_radio hh_q6_3_television hh_q6_4_telephone_landline hh_q6_6_refrigerator hh_q6_7_pc_laptop_tablet hh_q6_8_washing_machine hh_q6_9_solar_panel hh_q6_10_motor_vehicle, norm(standard)
*predict P2, rowscores
*estat coord, stats
*estat summarize
*xtile quintiles2=P2,nq(2)
*label var quintiles2 "Asset SES"
*label define quintiles2 1 "Low SES" 2 "HIGH SES"  
*label values quintiles2 quintiles2


* Selfreport diagnosis for variables of interest
label def yesno 1 "Yes" 0 "No", replace

recode hivstat (2=0)(1=1), gen(hiv) // Biological HIV status
label values hiv yesno
label variable hiv "HIV status (biomarker)"

recode q13_7a_i (2=0)(1=1)(3=.), gen(SELFHYPERTENSION) // Current hypertension
label values SELFHYPERTENSION yesno
label variable SELFHYPERTENSION "Self-reported current hypertension"

recode q13_7b_i(2=0)(1=1)(3=.), gen(SELFDIAB) // diabetes
label values SELFDIAB yesno
label variable SELFDIAB "Self-reported current diabetes"

recode q13_7c_i(2=0)(1=1)(3=.), gen(SELFTB) // TB
label values SELFTB yesno
label variable SELFTB "Self-reported TB"

recode q13_7d_i(2=0)(1=1)(3=.), gen(SELFCANCER) // Cancer
label values SELFCANCER yesno
label variable SELFCANCER "Self-reported Cancer"

recode q13_7e_i(2=0)(1=1)(3=.), gen(SELFHIV) // HIV
label values SELFHIV yesno
label variable SELFHIV "Self-reported HIV"

recode q13_7f_i(2=0)(1=1)(3=.), gen(SELFHEART) // Heart disease
label values SELFHEART yesno
label variable SELFHEART "Self-reported Heart disease"


* Smoking - this dataset does not have smoking data


* Alcohol
recode q11_2 (1=0)(2=1) (3=1) (4=1) (5=1), gen(CURRALC) //Alcohol drinking in last 12 months
recode q11_1 (2=0)(1=1), gen(EVERALC)
replace CURRALC=0 if EVERALC==0
label values CURRALC yesno
label variable CURRALC "Currently drinks"

**Generate 10 year age group
recode age (15/19= 1 "15-19") (20/29=2 "20-29") (30/39=3 "30-39") (40/49=4 "40-49") (50/59=5 "50-59") (60/69=6 "60-69") (70/79=7 "70-79") (80/200=8 "80+") ,generate(age_10)
tabstat age, stat (n, mean, median, sd, p25, p75, min, max)
tab age_10

**age categories
recode age(15/24= 1 "15-24") (25/34=2 "25-34") (35/44=3 "35-44") (45/54=4 "45-54") (55/64=5 "55-64") (65/200=6 "65+"), generate(age_cat)
tabstat age, stat (n, mean, median, sd, p25, p75, min, max)
tab age_cat

* Labels
label var psu "Primary sampling unit"
label var csweight "Sampling weight - individual"		   
label var stratum "Stratum"  
label var gender "Gender"
label var race "Race" 
label var urban "geotype"
label var age "Age"	 
label var pregn "Current pregnancy"
label var educat "Education"
label var CURRALC "Current alcohol use"
label var EVERALC "Ever alcohol use"

drop q13_7f_ii q13_7f_i q13_7e_ii q13_7e_i q13_7d_ii q13_7d_i q13_7c_ii q13_7c_i q13_7b_ii q13_7b_i q13_7a_ii q13_7a_i q11_2 q11_1 q1_15c q1_10 q1_7 hivstat race_q geotype

save "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2017_cleaned_10092021.dta", replace
