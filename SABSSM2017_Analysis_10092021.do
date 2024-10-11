*Stata version 15.1
*** 
************************************************************************
* PART 0: TABLE OF CONTENTS
************************************************************************
clear

* start log 
*capture log close
*log using 


* Project: [Multimorbidity in South Africa - SABSSM 2017]
* Creator: [Rifqah Roomaney, rifqah.roomaney@mrc.ac.za, 10/09/2021] 
* Purpose of do-file: Data analysis of SABSSM 2017
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

************************************************************************
* PART 2: MAIN ANALYSIS - CREATE MULTIMORBIDITY VARIABLES
************************************************************************
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2017_cleaned_10092021.dta"

***Generate disease index count
egen index = rowtotal(SELFHYPERTENSION SELFDIAB hiv SELFTB SELFCANCER SELFHEART ) //Doesn't exclude missing data. Adds up "yes" responses for these diseases //try rowmean*9 / rowmissing to see how many missing
label define Indexlabel 0 "No disease" 1 "1 disease" 2 "2 diseases" 3 "3 diseases" 4 "4 diseases" 5 "5 diseases" 6 "6 diseases" 7 "7 diseases" 8 "8 diseases" 9 "9 diseases"
label values index Indexlabel
label variable index "Number of diseases"
tab index
tab index gender, col chi

***Generate multimorbidity index
generate mm_index= index // Generating a multimorbidity variable that puts <2 diseases and >=2 diseases into categories
tab mm_index
recode mm_index 0/1=0 2/9=1
tab mm_index
label define Multimorbidity 0 "No multimorbidity" 1 "Multimorbidity", replace
label values mm_index Multimorbidity
label variable mm_index "Multimorbidity "
tab mm_index gender, col chi
tab mm_index age_cat, col chi
graph box age, over(gender)

***************************************
* SURVEY set
*****************************************
svyset psu[pweight=csweight], strata(stratum) vce(linearized) singleunit(certainty) 
svydescribe

save "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2017_mm_10092021.dta", replace

************************************************************************
*Part 2.1: Tabulations demographics and diseases
************************************************************************

use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2017_mm_10092021.dta"
svyset psu[pweight=csweight], strata(stratum) vce(linearized) singleunit(certainty) 


tab age
summarize age, detail
by gender, sort : summarize age, detail  //summarize age by gender
histogram age, normal
swilk age //not normally distributed
graph box age, over(gender)
ranksum age, by(gender) porder  //test for difference in age between males and females - wilcoxon rank
kwallis age, by(gender)

tab gender
graph pie, over(gender)

tab race

tab urban
tab urban gender, col chi 
svy linearized : proportion urban
svy linearized : proportion urban, over(gender)

tab stratum
tab stratum gender, col chi
svy linearized : proportion stratum
svy linearized : proportion stratum, over(gender)

tab educat
tab educat gender, col chi
svy linearized : proportion educat
svy linearized : proportion educat, over(gender)

*tab wealthindex
*tab wealthindex  gender, col exp chi
*svy linearized : proportion wealthindex
*svy linearized : proportion wealthindex, over(gender)

tab employed
tab employed gender, col chi


tabstat age, statistics( p50 p25 p75 ) by(SELFHEART ) //Median age of people who have heart disease

** Self reported disease tabulations 
*svyset psu[pweight=ibreal1_sabssm], strata(stratum) vce(linearized) singleunit(certainty) 

svy linearized, subpop(if gender==1) : proportion HIV, over(age15to49)
svy linearized, subpop(if gender==1) : proportion HIV, over(age50plus)

svy linearized : proportion hiv, over(race)


tab hiv
tab hiv gender, col chi
logistic HIV gender
svy linearized : proportion hiv
svy linearized : proportion hiv, over(gender)

tabulate SELFHYPERTENSION
tab SELFHYPERTENSION gender, col  chi
logistic SELFHYPERTENSION gender
svy linearized : proportion SELFHYPERTENSION
svy linearized : proportion SELFHYPERTENSION, over(gender)
svy linearized : proportion SELFHYPERTENSION, over(age_10)


tab SELFDIAB
tab SELFDIAB gender, col chi
logistic SELFDIAB gender
svy linearized : proportion SELFDIAB
svy linearized : proportion SELFDIAB, over(gender)
svy linearized : proportion SELFDIAB, over(age_10)




tabulate SELFTB
tab SELFTB gender, col  chi
logistic SELFTB gender
svy linearized : proportion SELFTB
svy linearized : proportion SELFTB, over(gender)
svy linearized : proportion SELFTB, over(age_10)



tabulate SELFCANCER
tab SELFCANCER gender, col  chi
logistic SELFCANCER gender
svy linearized : proportion SELFCANCER
svy linearized : proportion SELFCANCER, over(gender)
svy linearized : proportion SELFCANCER, over(age_10)


tabulate SELFHIV
tab SELFHIV gender, col chi
logistic SELFHIV gender
svy linearized : proportion SELFHIV
svy linearized : proportion SELFHIV, over(gender)

tabulate SELFHEART
tab SELFHEART gender, col  chi
logistic SELFHEART gender
svy linearized : proportion SELFHEART
svy linearized : proportion SELFHEART, over(gender)
svy linearized : proportion SELFHEART, over(age_10)

svy linearized : proportion hiv, over(age_10)


tab mm_index
svy: tabulate mm_index  

************************************************************************
* Part 2.2: Multimorbidity index explore
************************************************************************
tab index
tab index gender, col chi
svy: tabulate index
svy linearized : proportion index 
svy linearized : proportion index , over(gender)

egen index1 = rowtotal(SELFHYPERTENSION SELFDIAB hiv SELFTB SELFCANCER SELFHEART ) //Doesn't exclude missing data. Adds up "yes" responses for these diseases //try rowmean*9 / rowmissing to see how many missing
label define Indexlabel1 0 "No disease" 1 "1 disease" 2 "2 diseases" 3 "3 diseases" 4 "4 diseases" 5 "5 diseases" 6 "5 diseases" 7 "5 diseases" 8 "8 diseases" 9 "9 diseases", replace
label values index1 Indexlabel1
label variable index1 "Number of diseases"
recode index1 (6=5)
label define Indexlabel1 0 "No disease" 1 "1 disease" 2 "2 diseases" 3 "3 diseases" 4 "4 diseases" 5 "5+ diseases" , replace
tab index1
tab index1 gender, col chi
svy linearized : proportion index1 
svy linearized : proportion index1 , over(gender)

tab mm_index
tab mm_index gender, col chi
svy: tabulate mm_index
svy linearized : proportion mm_index 
svy linearized : proportion mm_index , over(gender)

svy linearized : proportion mm_index , over(age_10)
svy linearized, subpop(if gender==1) : proportion mm_index, over(age_10)
svy linearized, subpop(if gender==2) : proportion mm_index, over(age_10)
tab age_10
tab age_10, nol
recode age_10 (8=7)




graph box age, over(index)
graph box age, over(mm_index)
graph box age [pw = csweight ], by(mm_index)

by mm_index, sort : summarize age, detail

tabulate age_10 mm_index, row chi
tabulate mm_index gender, row chi

tabulate age_10 mm_index if gender ==1, row col
tabulate age_10 mm_index if gender ==2, row col
tabulate age_10 mm_index

***Logistic regression 
*unadjusted odds
svy: logistic mm_index i.age_cat 
svy: logistic mm_index gender
svy: logistic mm_index urban
svy: logistic mm_index i.educat
svy: logistic mm_index employed

svy: logistic mm_index CURRALC


*Model 1A
logistic mm_index age gender
estat gof, table group(10)
*Model 1B
svy: logistic mm_index i.age_cat gender
linktest
svylogitgof

*Model 2a
logistic mm_index age gender urban i.educat employed 
estat gof, table group(10)
*Model 2B
svy: logistic mm_index i.age_cat gender urban i.educat  employed 
svylogitgof

*Model 3a
logistic mm_index i.age_cat gender urban i.educat employed  CURRALC 
estat gof, table group(10)
*Model 3B
svy: logistic mm_index i.age_cat gender urban i.educat  employed CURRALC 
linktest
boxtid logistic mm_index age gender urban i.educat i.wealthindex employed i.bmi_cat CURRALC CURRSMOK 
svylogitgof


svy: logistic mm_index i.age_cat gender urban i.educat i.wealthindex employed i.bmi_cat CURRALC CURRSMOK  


*Model checking
logistic mm_index i.age_cat gender urban i.educat  employed  CURRALC 

predict p
predict stdres, rstand
scatter stdres p, mlabel(id) ylab(-4(2) 16) yline(0)
scatter stdres id, mlab(id) ylab(-4(2) 16) yline(0)
predict dv, dev
scatter dv p, mlab(id) yline(0)
scatter dv id, mlab(id)
predict hat, hat
scatter hat p, mlab(id)  yline(0)
scatter hat id, mlab(id)
qnorm stdres
list id mm_index age_cat gender urban educat employed  CURRALC   if (stdres >4 & stdres <.)

svy: logistic mm_index i.age_cat gender i.age_cat#gender urban i.educat  employed CURRALC  

*testparm i.age_cat#gender        // p = 0.0001 -> the mdoel with intercation fist significantly better than the model without
*svylogitgof                      // p = 0.836 -> confirma the good fit 

predict dx2, dx2
predict dd, dd
scatter dx2 id, mlab(id)
scatter dd id, mlab(id)

predict dbeta, dbeta
scatter dbeta id, mlab(id)
