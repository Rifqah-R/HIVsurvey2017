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
* Creator: [Rifqah Roomaney, rifqah.roomaney@mrc.ac.za, 10/09/2021] 
* Purpose of do-file: Latent class analysis for SABSSM 2017
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
* PART 2: Latent class analysis
************************************************************************

use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2017_mm_10092021.dta"


****LCA
*Data cleaing to prepare the file
set matsize 800   //Enlarge matrix


tab index
drop if mm_index==0  //drop people with 0 or 1 diseases 

label def yesno1 2 "Yes" 1 "No", replace  //recode as the ado doesnt seem to work with 0 code

tab hiv
tab hiv, nol
recode hiv 0=1 1=2
label val hiv yesno1
tab hiv

recode SELFHYPERTENSION 0=1 1=2
recode SELFDIAB 0=1 1=2
recode SELFTB 0=1 1=2
recode SELFCANCER 0=1 1=2
recode SELFHEART 0=1 1=2

label val SELFHYPERTENSION SELFDIAB SELFTB SELFCANCER SELFHEART yesno1

save "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2016_LCA_10092021.dta", replace

****Check for how many classes are appropriate without covariates***

*2 class model
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2016_LCA_10092021.dta", replace

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv SELFHYPERTENSION SELFDIAB SELFTB SELFCANCER SELFHEART,  ///
      nclass(2)					///
	  id(id)                	///
	  maxiter(5000)  			///
	  weight(csweight)			///
	  clusters(psu)				///
	  seed(123456789) 			///
	  seeddraws(100000) 		///
	  categories(2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0)               
return list
matrix list r(gamma)
matrix list r(gammaSTD)	

* 3 class model

drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2016_LCA_10092021.dta", replace

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv SELFHYPERTENSION SELFDIAB SELFTB SELFCANCER SELFHEART,  ///
      nclass(3)					///
	  id(id)                	///
	  maxiter(5000)  			///
	  weight(csweight)			///
	  clusters(psu)				///
	  seed(123456789) 			///
	  seeddraws(100000) 		///
	  categories(2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0)               
return list
matrix list r(gamma)
matrix list r(gammaSTD)
matrix list r(rho)
matrix list r(rhoSTD)	

* 4 class model

drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2016_LCA_10092021.dta", replace

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv SELFHYPERTENSION SELFDIAB SELFTB SELFCANCER SELFHEART,  ///
      nclass(4)					///
	  id(id)                	///
	  maxiter(5000)  			///
	  weight(csweight)			///
	  clusters(psu)				///
	  seed(123456789) 			///
	  seeddraws(100000) 		///
	  categories(2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0)               
return list
matrix list r(gamma)
matrix list r(gammaSTD)	
matrix list r(rho)
matrix list r(rhoSTD)


* 5 class model

drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2016_LCA_10092021.dta", replace

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv SELFHYPERTENSION SELFDIAB SELFTB SELFCANCER SELFHEART,  ///
      nclass(5)					///
	  id(id)                	///
	  maxiter(5000)  			///
	  weight(csweight)			///
	  clusters(psu)				///
	  seed(123456789) 			///
	  seeddraws(100000) 		///
	  categories(2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0)               
return list
matrix list r(gamma)
matrix list r(gammaSTD)	
matrix list r(rho)
matrix list r(rhoSTD)

* 6 class model

drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2016_LCA_10092021.dta", replace

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv SELFHYPERTENSION SELFDIAB SELFTB SELFCANCER SELFHEART,  ///
      nclass(6)					///
	  id(id)                	///
	  maxiter(5000)  			///
	  weight(csweight)			///
	  clusters(psu)				///
	  seed(123456789) 			///
	  seeddraws(100000) 		///
	  categories(2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0)               
return list
matrix list r(gamma)
matrix list r(gammaSTD)
matrix list r(rho)
matrix list r(rhoSTD)


* 7 class model

drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\SABSSM2016_LCA_10092021.dta", replace

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv SELFHYPERTENSION SELFDIAB SELFTB SELFCANCER SELFHEART,  ///
      nclass(7)					///
	  id(id)                	///
	  maxiter(5000)  			///
	  weight(csweight)			///
	  clusters(psu)				///
	  seed(123456789) 			///
	  seeddraws(100000) 		///
	  categories(2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0)               
return list
matrix list r(gamma)
matrix list r(gammaSTD)
matrix list r(rho)
matrix list r(rhoSTD)


****Part 3: MM explore
svyset psu[pweight=csweight], strata(stratum) vce(linearized) singleunit(certainty) 

count
svy linearized : mean age
svy linearized : proportion gender

svy linearized : proportion SELFHYPERTENSION
svy linearized : proportion SELFDIAB
svy linearized : proportion SELFTB
svy linearized : proportion SELFCANCER
svy linearized : proportion SELFHIV
svy linearized : proportion SELFHEART
svy linearized : proportion hiv


