* Do - File PS6
* Chad Socha
* November 2017
* Data Management
*----------------------------

//PS6: Streamlined coding/comments- No new datasets added (ie demographics/census stuff; possibly for presentation- depends on data layout. What is here can be built upon heading into next semester and going forward. 
// There will be some more descriptives for project as well. 

// 


/* Based on previous work, made more sense to bring together years of data versus prior ps files of just one year. Now working with NJ state financial data for years of 2008-2013; coincide with available data for adjustment aid under new funding formula. */

clear all

/* Working Directory */

cd "C:\Users\socha\Dropbox\Dataman_project"

/* The first set of files being dealt with are the NCES LEA Universe file- student/teacher numbers/totals 

 These files come from https://nces.ed.gov/ccd/ccddata.asp >>> School District (LEA) link
 
 Will be utilizing the 2008-2013 years as this was when NJ implemented adjustment aid for districts */
 
 /* Loading in first year of data 2008 */

import delimited using "https://www.dropbox.com/s/bkmpx4f4ylz11he/Lea_01.txt?dl=1", clear

/* Drop 08 at end of variables- will do for subsequent years as necessary to have uniform names for appending */

renvars, subs (08 "")

/* Based on checking later files (also this one not containing one, create variable for year */

gen survyear = 2008 

/* Bring to front of dataset */

order survyear

/* Keeping only New Jerey datapoints */

keep if lstate=="NJ"

/* Save file; since appending with others, will append and do dropping/labelling at that point once combined */

save Lea_01.dta, replace



// Loading in 2009 data 

import delimited using "https://www.dropbox.com/s/yhi66xkkrq5ar9c/Lea_02.txt?dl=1", clear


renvars, subs (09 "")


gen survyear = 2009 


order survyear


keep if lstate=="NJ"

save Lea_02.dta, replace



// Loading in  2010 data


/* Changes with datafile going forward. Has variable for year and does not have numeric coding at end of individual variables. Also has added variables that will be dealt with once all data combined */

import delimited using "https://www.dropbox.com/s/wmkuz455jfsr5za/Lea_03.txt?dl=1", clear


keep if lstate=="NJ"

save Lea_03.dta, replace



// Loading in 2011 data 

import delimited using "https://www.dropbox.com/s/fucaq4g3gbm4nlg/Lea_04.txt?dl=1", clear


keep if lstate=="NJ"

save Lea_04.dta, replace


// Loading in 2012 data 

import delimited using "https://www.dropbox.com/s/4p0vifbyabe7egl/Lea_05.txt?dl=1", clear


keep if lstate=="NJ"

save Lea_05.dta, replace


// Loading in 2013 data

import delimited using "https://www.dropbox.com/s/9ahypf5krhmarcy/Lea_06.txt?dl=1", clear


keep if lstate=="NJ"

save Lea_06.dta, replace


// Appending LEA Universe Files

use Lea_01, clear
foreach num of numlist 2/6 {
append using Lea_0`num'
}
                              
/* Drop unneeded Variables */

drop fipst phone mstree mcity mstate mzip mzip4 lstree lcity lstate lzip lzip4 union conum coname csa cbsa metmic cdcode latcod loncod bound gslo gshi

/* Relabeling Variables */

label variable leaid "NCES LEA ID"
label variable stid "State’s own ID"
label variable name "Name"
label variable type "Agency type"
label variable ulocal "NCES urban-centric locale code"
label variable sch "Aggregate number of schools in agency in  CCD universe file"
label variable ug "Total number of students in classes/programs without grade designations"
label variable pk12 "Total number of students in classes from prek - 12th  that are public school"
label variable member "Total - sum of the fields UG and PK12"
label variable speced "Count of all students having a (IEP)"
label variable ell "The number of (ELL) students"
label variable pktch "Prekindergarten teachers. FTE nearest 10th"
label variable kgtch "Kindergarten teachers. FTE nearest 10th"
label variable elmtch "Elementary teachers.FTE nearest 10th"
label variable sectch "Secondary teachers. FTE nearest 10th"
label variable ugtch "Teachers w/out grade designation.FTE nearest 10th"
label variable tottch "Total teachers. FTE nearest 10th"
label variable aides "Instructional aides. FTE nearest 10th"
label variable corsup "Instructional coordinators & supervisors. FTE nearest 10th"  
label variable elmgui "Elementary guidance counselors. FTE nearest 10th"
label variable secgui "Secondary guidance counselors. FTE nearest 10th"
label variable othgui "Other guidance counselors. FTE nearest 10th"
label variable totgui "Total guidance counselors. FTE nearest 10th"
label variable libspe "Librarians/media specialists. FTE nearest 10th"
label variable libsup "Library/media support staff. FTE nearest 10th"
label variable leaadm "LEA administrators. FTE nearest 10th"
label variable leasup "LEA administrative support staff. FTE nearest 10th"
label variable schadm "School administrators. FTE nearest 10th"
label variable schsup "School administrative support staff. FTE nearest 10th"
label variable stusup "Student support services staff. FTE nearest 10th"
label variable othsup "Student support services staff. FTE nearest 10th"


save LEA_combined, replace

*********************************************************************************************************************************************************

// Adding codes for combining datasets between NCES and NJDOE files- neither datasets have the NCES code and the NJ district codes- this info file does

use "https://www.dropbox.com/s/hf5zo7n5yhpufid/codes.dta?dl=1", clear

sort leaid

/* Dropping districts in dataset that are non-public */

drop if leaid==.

// merging with previous Universe file created

merge 1:m leaid using LEA_combined


keep if _merge==3

/* Only want public school systems */

keep if chrtschcode==.


drop _merge

save Lea_code, replace 


****************************************************************************************************************************************************
/*NJDOE files with adjustment aid variable

Taken from http://www.state.nj.us/education/data/  >>> the user friendly budget summary files

Working on files for adjustment aid- first few years utilize lines 260 and 368 but in the middle that changes to 720 and 480 for reshaping purposes */

// 2010 file

import delimited "https://www.dropbox.com/s/3yk56gkx4bgtf9b/rev_2010.CSV?dl=1", clear

/* Drop Variables */

drop obs co coname distname account amt2 amt3

/* keep Line items to contain all individual districts and also adjust aid 8 */

keep if inlist(line, 260, 368)

/* Reshape to have adjustment aid own variable */

reshape wide desc amt1, i(dist) j(line) 

/* Drop to just have adjust aid */

drop desc260 amt1260 desc368 

/* 2010 file has 2008-2009 actual data */

gen survyear=2008

replace amt1368=0 if amt1368==.

/* Rename Variables for appending and merging */

rename amt1368 adjustaid

**Save Final File

save Adjaid_1, replace


// 2011 File

import delimited "https://www.dropbox.com/s/thyknqmyt9ffc7l/rev_2011.CSV?dl=1", clear


drop obs co coname distname account amt2 amt3

keep if inlist(line, 260, 368)


reshape wide desc amt1, i(dist) j(line) 

drop desc260 amt1260 desc368 

/* 2011 file has 2009-2010 actual data */

gen survyear=2009

replace amt1368=0 if amt1368==.

rename amt1368 adjustaid

save Adjaid_2, replace


// 2012 File

import delimited "https://www.dropbox.com/s/rmntie6dea3q7el/rev_2012.CSV?dl=1", clear

drop obs co coname distname account amt2 amt3

keep if inlist(line, 260, 368)

reshape wide desc amt1, i(dist) j(line) 

drop desc260 amt1260 desc368 

/* 2012 file has 2010-2011 actual data */

gen survyear=2010

replace amt1368=0 if amt1368==.


rename amt1368 adjustaid

**Save Final File
save Adjaid_3, replace


// 2013 File

import delimited "https://www.dropbox.com/s/cptbbw5o5sptijw/rev_2013.csv?dl=1", clear

drop county_id coname  distname account amount_2 amount_3

/* keep Line items to contain all individual districts and adjust aid- chnage from previous years: now ue 720 and 480 */

keep if inlist(line_no, 720, 480)

reshape wide line_desc amount_1, i(district_id) j(line_no) 

drop line_desc480 line_desc720 amount_1720

/* 2013 file has 2011-2012 actual data */

gen survyear=2011

replace amount_1480=0 if amount_1480==.

rename amount_1480 adjustaid

rename district_id dist

**Save Final File
save Adjaid_4, replace


// 2014 File

import delimited "https://www.dropbox.com/s/bzt1f9x6s8fpb0h/rev_2014.csv?dl=1", clear

drop county_id coname  distname account amount_2 amount_3

keep if inlist(line_no, 720, 480)

reshape wide line_desc amount_1, i(district_id) j(line_no) 

drop line_desc480 line_desc720 amount_1720

gen survyear=2012

replace amount_1480=0 if amount_1480==.

rename amount_1480 adjustaid

rename district_id dist

**Save Final File
save Adjaid_5, replace


// 2015 File


import delimited "https://www.dropbox.com/s/p3ybqbdq1vpezou/rev_2015.csv?dl=1", clear

drop county_id coname  distname account amount_2 amount_3

keep if inlist(line_no, 720, 480)

reshape wide line_desc amount_1, i(district_id) j(line_no) 

drop line_desc480 line_desc720 amount_1720

/* 2015 file has 2013-2014 actual data */

gen survyear=2013

replace amount_1480=0 if amount_1480==.

rename amount_1480 adjustaid

rename district_id dist

**Save Final File
save Adjaid_6, replace

//Appending all adjustment aid years with each other

use Adjaid_1, clear
foreach num of numlist 2/6 {
append using Adjaid_`num'
}
save Adjaid_combine, replace


// Need to merge this file with previous LEA data file

merge 1:1 dist survyear using Lea_code

/* Drop those which will not appear in all years */

keep if _merge==3

drop _merge 

/* Recoding of adjustment aid to dummy for distinction */

recode adjustaid (0=0) (1/max=1), gen(adjdummy)

/* Encode for County distinction- as variable is strong encoding versus recoding will give distinct values for counties */

encode countyname, gen(county)

/* Instead of using replace, mvdecode decodes values used for missing values and can replace accordingly. 

.m = missing and .n= not applicable */

mvdecode _all, mv(-1=.m \ -2=.n)

// Saving combined file

save Lea_adjustaid, replace


*************************************************************************************************************************************************
/* New Jersey Standardized Test Scores

Taken from http://www.state.nj.us/education/data/ >>> NJ Statewide Assessment Reports

Test Score files: Using 4th grade test scores for all years. Using English and Math as scores are transferrable over all years for these two subjects */



// CSV file of general district 4th Grade testing data for school year 2008-2009 


import delimited "https://www.dropbox.com/s/dr3ap6os43qf73i/scores08a.csv?dl=1", clear

/* Versus prior sets, district variable in these is a string- need to change */

destring dist, replace

drop if dist==.

sort dist

/* Removing Charter schools as they are not a part of the study */

drop if substr(cntyname, 1, 2) == "CH" 

/* Destring of school id variable */

destring sch, replace

//Note--- Keeping these variable names; will change those of subseuqent files accordingly 

keep year co dist sch specneeds totalvalidscalelang totalpplang totalplang totalaplang totalscalelang totalvalidscalemath totalppmath totalpmath totalapmath totalscalemath

//Want to have consistent year variable for merging

rename year survyear

// Only want totals per district

keep if sch==0

/* Saving file */

save test08, replace


/* CSV file of general district 4th Grade testing data for school year 2009-2010 */


import delimited "https://www.dropbox.com/s/b8ir7ygsoioboh6/scores09a.csv?dl=1", clear


drop if districtcode==.

sort districtcode

drop if substr(countyname, 1, 2) == "CH" 

destring schoolcode, replace

// Only want totals per district

keep if schoolcode==.

keep countycode districtcode schoolcode specialneeds totalvalidscalelang totalpplang totalplang totalaplang totalscalelang totalvalidscalemath totalppmath totalpmath totalapmath totalscalemath

rename (countycode districtcode schoolcode specialneeds) (co dist sch specneeds)

gen survyear = 2009 

order survyear

save test09, replace


/* CSV file of general district 4th Grade testing data for school year 2010-2011 */


import delimited "https://www.dropbox.com/s/lgntfm97cf36qsg/scores10a.csv?dl=1", clear

drop if districtcode==.

sort districtcode

drop if substr(countyname, 1, 2) == "CH" 

destring schoolcode, replace

keep if schoolcode==.

keep countycode districtcode schoolcode specialneeds totalvalidscalelang totalpplang totalplang totalaplang totalscalelang totalvalidscalemath totalppmath totalpmath totalapmath totalscalemath

/* Based on checking later files (also this one not containing one, create variable for year */

gen survyear = 2010 

order survyear

rename(countycode districtcode schoolcode specialneeds) (co dist sch specneed)

save test10, replace 


/* CSV file of general district 4th Grade testing data for school year 2011-2012 */

// The next few years have issues reading in the csv files. Variable names of original files don't read in properly. 


import excel "https://www.dropbox.com/s/o42d2s8ceo5fv6h/scores11.xls?dl=1", firstrow clear 

destring DistrictCode, replace

drop if DistrictCode==.

sort DistrictCode

drop if substr(CountyName, 1, 2) == "CH" 

destring SchoolCode, replace

keep if SchoolCode==.

keep CountyCode DistrictCode SchoolCode SpecialNeeds TotalValidScaleLang TotalPPLang TotalPLang TotalAPLang TotalMeanScaleLang TotalValidScaleMath TotalPPMath TotalPMath TotalAPMath TotalMeanScaleMath

// found lower case function after the fact for all files //

rename *, lower

gen survyear = 2011

order survyear

rename(countycode districtcode schoolcode specialneeds totalmeanscalelang totalmeanscalemath) (co dist sch specneed totalscalelang totalscalemath)

save test11, replace 


/* Excel file of general district 4th Grade testing data for school year 2012-2013 */


import excel "https://www.dropbox.com/s/pwqkrlrqdv88x53/scores12.xls?dl=1", firstrow clear

destring DistrictCode, replace

drop if DistrictCode==.

sort DistrictCode

drop if substr(CountyName, 1, 2) == "CH" 

destring SchoolCode, replace

keep if SchoolCode==.

keep CountyCode DistrictCode SchoolCode SpecialNeeds TotalValidScaleLang TotalPPLang TotalPLang TotalAPLang TotalMeanScaleLang TotalValidScaleMath TotalPPMath TotalPMath TotalAPMath TotalMeanScaleMath

rename *, lower

gen survyear = 2012 

order survyear

rename(countycode districtcode schoolcode specialneeds totalmeanscalelang totalmeanscalemath) (co dist sch specneed totalscalelang totalscalemath)

save test12, replace 


/* Excel file of general district 4th Grade testing data for school year 2013-2014 */


import excel "https://www.dropbox.com/s/cme26ge8hyxtmuh/scores13.xls?dl=1", firstrow clear

destring DistrictCode, replace

drop if DistrictCode==.

sort DistrictCode

drop if substr(CountyName, 1, 2) == "CH" 

destring SchoolCode, replace

keep if SchoolCode==.

keep CountyCode DistrictCode SchoolCode SpecialNeeds TotalValidScaleELA TotalPPELA TotalPELA TotalAPELA TotalMeanScaleELA TotalValidScaleMath TotalPPMath TotalPMath TotalAPMath TotalMeanScaleMath
rename *, lower

gen survyear = 2013

order survyear

rename(countycode districtcode schoolcode specialneeds totalvalidscaleela totalppela totalpela totalapela totalmeanscaleela totalmeanscalemath) (co dist sch specneed totalvalidscalelang totalpplang totalplang totalaplang totalscalelang totalscalemath)

save test13, replace 


//Combining test data year files- Append//

clear
local filelist : dir "C:\Users\socha\Dropbox\Dataman_project" files "test*"
foreach file of local filelist {
append using `file'
}
 
 //Save test dataset
 
 save testcombined, replace
 
 //Combine test data with other data- Merge 
 
 merge 1:1 dist survyear using Lea_adjustaid
 
keep if _merge==3

drop _merge 

// Looking over data- dont need sch (school anymore)

drop sch

//To note- For this course will not be utilizing all variables- some in dataset are for years 2010-2013- those are not labelled.

// Making some ratio variables for staff:student ratios

gen teachratio= member/tottch

label variable teachratio "Student to teacher ratio"

gen aidsratio= member/aides

label variable aidsratio "Student to instructional aides ratio"

gen coordratio= member/corsup

label variable coordratio "Student to instructional supervisors ratio"

gen guideratio= member/totgui

label variable guideratio "Student to guidance councelor ratio"

gen mediaratio= member/libspe

label variable mediaratio "Student to media specialist ratio"

gen adminratio= member/leaadm

label variable adminratio "Student to LEA (district) admin ratio"

gen suppratio= member/leasup

label variable suppratio "Student to LEA (district) support staff ratio"

gen schadminratio= member/schadm

label variable schadminratio "Student to school admin ratio"

gen schsuppratio= member/schsup

label variable schsuppratio "Student to school support staff ratio"

gen ellper= ell/member * 100

label variable ellper   "percent english-language learners" 

gen specedper= speced/member * 100

label variable specedper   "percent spec ed students" 

//Making global macro of ratio variables as need to change values now and will use later on with analyses 

global staff teachratio aidsratio guideratio mediaratio adminratio schadminratio

// checking to see it worked

d $staff

// For creating ratios later on, disregard change dataset connotation of missing values being negative. 

foreach var of global staff {
replace `var' = . if `var' < 0
}


// We want to have means by year for test scores of both adjustaid schools and non-adjustaid districts 

/* Had issue need to destring score variables- tried this first- Did not remove all of the "*"

foreach v of var totalvalidscalelang totalpplang totalplang totalaplang totalscalelang totalvalidscalemath totalppmath totalpmath totalapmath totalscalemath {
        	replace `v'="." if `v'=="*"
        }
		
		*/
		
		
		// Destring and ignore>>> specify the * //
		
		
		foreach v of var totalvalidscalelang totalpplang totalplang totalaplang totalscalelang totalvalidscalemath totalppmath totalpmath totalapmath totalscalemath {
        	destring `v', replace ignore("*")
        }

		
bysort survyear adjdummy : egen Mlang=mean(totalscalelang)

bysort survyear adjdummy : egen MMath=mean(totalscalemath)


save allcombined, replace

********************************************************************************************************************************************************
********************************************************************************************************************************************************


/* Now have a dataset which includes LEA variables (items pertaining to student:teacher ratios, admin ratios, and similar staff statistics, adjustment aid for those recieiving extra aid (as aid is based on a formula for different student classifications, and 4th grade test score data.

We can now look at some descriptives, charts, graphs, statistics, etc. pertaining to districts recieiving aid versus those which do not. */

bysort adjdummy: sum $staff 

// General look at student to staff ratios. Very similar with teacher ratios, moe variation with other faculty/staff. Plotted below with graphs.

foreach var of global staff {
graph twoway (scatter `var' survyear if adjdummy==0) (scatter `var' survyear if adjdummy==1), ///
legend(label(1 no adjust aid) label(2 adjust aid)) 
graph save `var', replace	
}


graph combine teachratio.gph aidsratio.gph guideratio.gph mediaratio.gph adminratio.gph schadminratio.gph

// The teacher ratios seem fairly consistent both across aid type and years. With aid, other faculty, and admin ratios we see a greater variation as well as an increased amount of student to faculty ratios for an increasing number of non-adjustment aid schools (perhaps due to lower funding levels.

//  Looking at the scatterplots to see a general range of scores for adjustment aid and non adjustment aid districts.

twoway (scatter totalscalelang survyear  if adjdummy==0) (scatter totalscalelang survyear if adjdummy==1), ///
  legend(label(1 no adjust aid) label(2  adjust aid)) 
  
  // Looking at the English test scores for districts, there is a fairly large range for both district types- we do see some clumping of non-adjustment aid districts near the top in scores. 
  
  twoway (scatter totalscalemath survyear  if adjdummy==0) (scatter totalscalelang survyear if adjdummy==1), ///
  legend(label(1 no adjust aid) label(2 adjust aid)) 
  
  // Looking at the Math scores, we see a greater trend of higher scores being non adjustment aid districts. 

// Bar graph //

// Doing Bar graph for Mean language score and Mean Math Scores by Year for adjustment aid schools and non adjustment aid districts. 

// Later on will get into labelling/formatting aspects of the graphs, i.e. axis titles, etc. 

foreach v of var Mlang MMath {
	graph bar `v', over (adjdummy) over (survyear)
	graph export "`v'.pdf", replace
} 

// Looking at the bar graph for the averages of each year, non-adjust aid districts have slightly higher scores in each year.


/* Regression- We want to look at effects of various faculty/staff ratios on tet scores (both english and math) for score data at the 4th grade level. */

// make some macros for analyses 

global r1 adjdummy

global r2 ellper specedper 

// may want to include county variable--- make dummys

tabulate co, generate(dum)

rename (dum1 - dum21) codummy#, addnumber


foreach yvar in totalscalelang totalscalemath {
reg `yvar' $r1
outreg2 using general.xls, `replace'
local replace
}

foreach yvar in totalscalelang totalscalemath {
reg `yvar'  $r1 $r2, 
outreg2 using general.xls, append`replace'
local replace
}
foreach yvar in totalscalelang totalscalemath {
reg `yvar' $r1 $r2 $staff, 
outreg2 using general.xls, append  `replace'
local replace
}

// on the 2nd and third loops on the output i am getting 2 outputs of totalscalelang with the regression models. its easy enough to delete, but is there a way to not get that?


/* With all models, we see strong significance of adjustment aid districts on average having lower scores than non-adjustment aid districts. This is higher on the math test (-6.64 points less than the english: -4.5 points less).
The percent of ell (enlgish language learners is also statistically significant in regards to test scores with model pending for each extra percent of ell learners, a decreas of .69 to 1.46 points on the test score.
When accounting for percent of special ed students, we find statistical significance only after variou faculty ratios are put into the model (not sure why this would be). In such instances, for each percent increase of special ed students, there is a between a .3 and .4 decrease in test score points.
Even though some of the faculty ratios are found to have statistical significance, in terms of practical significance there is very little (constants are all to 3 decimal places or smaller.

The one thing going forward would be to add in some demographic data on student backgrounds, i.e. such as economic standing (i.e. economically disadvantaged) and perhaps some other district financial info (per student spending in different areas). */

// Previous regression with county dummies- running w/out outreg to get a more general look at this model standalone.

foreach yvar in totalscalelang totalscalemath {
reg `yvar' $r1 $r2 $staff codummy1-codummy20, 
//outreg2 using general.xls, append  `replace'
//local replace
}

/* Accounting for location brings down the strenghth/weight of the adjustment aid dummy- it is now a 3.5 point difference on the math test scores and 2.0 on the english test scores.

There is a mix of county dummies having statistical significance. Looking more into the secific counties and why this may/may not be happening and any possible trends for which counties this is will require further reseearch. 
