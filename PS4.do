* Do-File 4
* Chad Socha
* November 2017
* Data Management
*----------------------------

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



/* Loading in 2nd year of data 2009 */

/* NCES LEA Universe file- student/teacher numbers/totals */

import delimited using "https://www.dropbox.com/s/yhi66xkkrq5ar9c/Lea_02.txt?dl=1", clear

/* Drop 09 at end of variables- will do for subsequent years as necessary to have uniform names for appending */

renvars, subs (09 "")

/* Based on checking later files (also this one not containing one, create variable for year */

gen survyear = 2009 

/* Bring to front of dataset */

order survyear

/* Keeping only New Jerey datapoints */

keep if lstate=="NJ"

/* Save file; since appending with others, will append and do dropping/labelling at that point once combined */

save Lea_02.dta, replace



/* Loading in 3rd year of data 2010 */

/* NCES LEA Universe file- student/teacher numbers/totals */

/* Changes with datafile going forward. Has variable for year and does not have numeric coding at end of individual variables. Also has added variables that will be dealt with once all data combined */

import delimited using "https://www.dropbox.com/s/wmkuz455jfsr5za/Lea_03.txt?dl=1", clear

/* Keeping only New Jerey datapoints */

keep if lstate=="NJ"

/* Save file; since appending with others, will append and do dropping/labelling at that point once combined */

save Lea_03.dta, replace



/* Loading in 4th year of data 2011 */

/* NCES LEA Universe file- student/teacher numbers/totals */

import delimited using "https://www.dropbox.com/s/fucaq4g3gbm4nlg/Lea_04.txt?dl=1", clear

/* Keeping only New Jerey datapoints */

keep if lstate=="NJ"

/* Save file; since appending with others, will append and do dropping/labelling at that point once combined */
//no need to repeat same cinnebt over and over again
save Lea_04.dta, replace


/* Loading in 5th year of data 2012 */
//could make it much more concise--these comments dont seem helpful
/* NCES LEA Universe file- student/teacher numbers/totals */

import delimited using "https://www.dropbox.com/s/4p0vifbyabe7egl/Lea_05.txt?dl=1", clear

/* Keeping only New Jerey datapoints */

keep if lstate=="NJ"

/* Save file; since appending with others, will append and do dropping/labelling at that point once combined */

save Lea_05.dta, replace


/* Loading in 6th year of data 2013 */

/* NCES LEA Universe file- student/teacher numbers/totals */

import delimited using "https://www.dropbox.com/s/9ahypf5krhmarcy/Lea_06.txt?dl=1", clear

/* Keeping only New Jerey datapoints */

keep if lstate=="NJ"

/* Save file; since appending with others, will append and do dropping/labelling at that point once combined */

save Lea_06.dta, replace


// Appending LEA Universe Files

//this shouldnt break!
use Lea_01, clear
foreach num of numlist 2/6 {
append using Lea_0`num', force
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
//good

save LEA_combined, replace

******************************************************************************************************************************

// Adding codes for combining datasets between NCES and NJDOE files- neither datasets have the NCES code and the NJ district codes- this info file does

use "https://www.dropbox.com/s/hf5zo7n5yhpufid/codes.dta?dl=1", clear

sort leaid

/* Dropping districts in dataset that are non-public */

drop if leaid==.

// merging with previous Universe file created

merge 1:m leaid using LEA_combined

/* Drop those which will not appear in all years */

keep if _merge==3

/* Only want public school systems */

keep if chrtschcode==.

/* Drop merge variable so other merging can occur */

drop _merge

save Lea_code, replace 


****************************************************************************************************************************************************
/*NJDOE files with adjustment aid variable

Taken from http://www.state.nj.us/education/data/  >>> the user friendly budget summary files

Working on files for adjustment aid- first few years utilize lines 260 and 368 but in the middle that changes to 720 and 480 for reshaping purposes */


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


/* 2011 */


import delimited "https://www.dropbox.com/s/thyknqmyt9ffc7l/rev_2011.CSV?dl=1", clear

/* Drop Variables */

drop obs co coname distname account amt2 amt3

/* keep Line items to contain all individual districts and also adjust aid 8 */

keep if inlist(line, 260, 368)

/* Reshape to have adjustment aid own variable */

reshape wide desc amt1, i(dist) j(line) 

/* Drop to just have adjust aid */

drop desc260 amt1260 desc368 

/* 2011 file has 2009-2010 actual data */

gen survyear=2009

replace amt1368=0 if amt1368==.

/* Rename Variables for appending and merging */

rename amt1368 adjustaid

**Save Final File
save Adjaid_2, replace



/* 2012 */

import delimited "https://www.dropbox.com/s/rmntie6dea3q7el/rev_2012.CSV?dl=1", clear

/* Drop Variables */

drop obs co coname distname account amt2 amt3

/* keep Line items to contain all individual districts and also adjust aid 8 */

keep if inlist(line, 260, 368)

/* Reshape to have adjustment aid own variable */

reshape wide desc amt1, i(dist) j(line) 

/* Drop to just have adjust aid */

drop desc260 amt1260 desc368 

/* 2012 file has 2010-2011 actual data */

gen survyear=2010

replace amt1368=0 if amt1368==.

/* Rename Variables for appending and merging */

rename amt1368 adjustaid

**Save Final File
save Adjaid_3, replace


/* 2013 */ 

import delimited "https://www.dropbox.com/s/cptbbw5o5sptijw/rev_2013.csv?dl=1", clear

/* Drop Variables */

drop county_id coname  distname account amount_2 amount_3

/* keep Line items to contain all individual districts and also adjust aid 8 */

keep if inlist(line_no, 720, 480)

/* Reshape to have adjustment aid own variable */

reshape wide line_desc amount_1, i(district_id) j(line_no) 

/* Drop to just have adjust aid */

drop line_desc480 line_desc720 amount_1720

/* 2013 file has 2011-2012 actual data */

gen survyear=2011

replace amount_1480=0 if amount_1480==.

/* Rename Variables for appending and merging */

rename amount_1480 adjustaid

rename district_id dist

**Save Final File
save Adjaid_4, replace


/* 2014 */

import delimited "https://www.dropbox.com/s/bzt1f9x6s8fpb0h/rev_2014.csv?dl=1", clear

/* Drop Variables */

drop county_id coname  distname account amount_2 amount_3

/* keep Line items to contain all individual districts and also adjust aid  */

keep if inlist(line_no, 720, 480)

/* Reshape to have adjustment aid own variable */

reshape wide line_desc amount_1, i(district_id) j(line_no) 

/* Drop to just have adjust aid */

drop line_desc480 line_desc720 amount_1720

/* 2014 file has 2012-2013 actual data */

gen survyear=2012

replace amount_1480=0 if amount_1480==.

/* Rename Variables for appending and merging */

rename amount_1480 adjustaid

rename district_id dist

**Save Final File
save Adjaid_5, replace



/* 2015 */


import delimited "https://www.dropbox.com/s/p3ybqbdq1vpezou/rev_2015.csv?dl=1", clear

/* Drop Variables */

drop county_id coname  distname account amount_2 amount_3

/* keep Line items to contain all individual districts and also adjust aid  */

keep if inlist(line_no, 720, 480)

/* Reshape to have adjustment aid own variable */

reshape wide line_desc amount_1, i(district_id) j(line_no) 

/* Drop to just have adjust aid */

drop line_desc480 line_desc720 amount_1720

/* 2015 file has 2013-2014 actual data */

gen survyear=2013

replace amount_1480=0 if amount_1480==.

/* Rename Variables for appending and merging */

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

// Will need to do future merging: drop _merge variable

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

//Note--- Keeping these variable names will change those of subseuqent files accordingly 

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

/* Removing Charter schools as they are not a part of the study */

drop if substr(countyname, 1, 2) == "CH" 

/* Destring of school id variable */

destring schoolcode, replace

// Only want totals per district

keep if schoolcode==.

keep countycode districtcode schoolcode specialneeds totalvalidscalelang totalpplang totalplang totalaplang totalscalelang totalvalidscalemath totalppmath totalpmath totalapmath totalscalemath

//rename variables

rename (countycode districtcode schoolcode specialneeds) (co dist sch specneeds)

gen survyear = 2009 

/* Bring to front of dataset */

order survyear

//renaming some variables to fit with first year data

/* Saving file */

save test09, replace




/* CSV file of general district 4th Grade testing data for school year 2010-2011 */


import delimited "https://www.dropbox.com/s/lgntfm97cf36qsg/scores10a.csv?dl=1", clear

drop if districtcode==.

sort districtcode

/* Removing Charter schools as they are not a part of the study */

drop if substr(countyname, 1, 2) == "CH" 

/* Destring of school id variable */

destring schoolcode, replace

// Only want totals per district

keep if schoolcode==.

keep countycode districtcode schoolcode specialneeds totalvalidscalelang totalpplang totalplang totalaplang totalscalelang totalvalidscalemath totalppmath totalpmath totalapmath totalscalemath

/* Based on checking later files (also this one not containing one, create variable for year */

gen survyear = 2010 

/* Bring to front of dataset */

order survyear

//renaming some variables to fit with first year data

rename(countycode districtcode schoolcode specialneeds) (co dist sch specneed)

/* Saving file */

save test10, replace 



/* CSV file of general district 4th Grade testing data for school year 2011-2012 */

// The next few years have issues reading in the csv files. Variable names of original files don't read in properly. 


import excel "https://www.dropbox.com/s/o42d2s8ceo5fv6h/scores11.xls?dl=1", firstrow clear 

//Destring DistrictCode

destring DistrictCode, replace

drop if DistrictCode==.

sort DistrictCode

/* Removing Charter schools as they are not a part of the study */

drop if substr(CountyName, 1, 2) == "CH" 

/* Destring of school id variable */

destring SchoolCode, replace

// Only want totals per district

keep if SchoolCode==.

//Only keep necessary variables

keep CountyCode DistrictCode SchoolCode SpecialNeeds TotalValidScaleLang TotalPPLang TotalPLang TotalAPLang TotalMeanScaleLang TotalValidScaleMath TotalPPMath TotalPMath TotalAPMath TotalMeanScaleMath

// found lower case function after the fact for all files //

rename *, lower

/* Based on checking later files (also this one not containing one, create variable for year */

gen survyear = 2011

/* Bring to front of dataset */

order survyear

//renaming some variables to fit with first year data

rename(countycode districtcode schoolcode specialneeds totalmeanscalelang totalmeanscalemath) (co dist sch specneed totalscalelang totalscalemath)

/* Saving file */

save test11, replace 



/* Excel file of general district 4th Grade testing data for school year 2012-2013 */

// The next few years have issues reading in the csv files. Variable names of original files don't read in properly. 


import excel "https://www.dropbox.com/s/pwqkrlrqdv88x53/scores12.xls?dl=1", firstrow clear

//Destring DistrictCode

destring DistrictCode, replace

drop if DistrictCode==.

sort DistrictCode

/* Removing Charter schools as they are not a part of the study */

drop if substr(CountyName, 1, 2) == "CH" 

/* Destring of school id variable */

destring SchoolCode, replace

// Only want totals per district

keep if SchoolCode==.

//Only keep necessary variables

keep CountyCode DistrictCode SchoolCode SpecialNeeds TotalValidScaleLang TotalPPLang TotalPLang TotalAPLang TotalMeanScaleLang TotalValidScaleMath TotalPPMath TotalPMath TotalAPMath TotalMeanScaleMath

rename *, lower

/* Based on checking later files (also this one not containing one, create variable for year */

gen survyear = 2012 

/* Bring to front of dataset */

order survyear

//renaming some variables to fit with first year data

rename(countycode districtcode schoolcode specialneeds totalmeanscalelang totalmeanscalemath) (co dist sch specneed totalscalelang totalscalemath)

/* Saving file */

save test12, replace 



/* Excel file of general district 4th Grade testing data for school year 2013-2014 */


import excel "https://www.dropbox.com/s/cme26ge8hyxtmuh/scores13.xls?dl=1", firstrow clear

//Destring DistrictCode

destring DistrictCode, replace

drop if DistrictCode==.

sort DistrictCode

/* Removing Charter schools as they are not a part of the study */

drop if substr(CountyName, 1, 2) == "CH" 

/* Destring of school id variable */

destring SchoolCode, replace

// Only want totals per district

keep if SchoolCode==.

//Only keep necessary variables

keep CountyCode DistrictCode SchoolCode SpecialNeeds TotalValidScaleELA TotalPPELA TotalPELA TotalAPELA TotalMeanScaleELA TotalValidScaleMath TotalPPMath TotalPMath TotalAPMath TotalMeanScaleMath
rename *, lower

/* Based on checking later files (also this one not containing one, create variable for year */

gen survyear = 2013

/* Bring to front of dataset */

order survyear

//renaming some variables to fit with first year data

rename(countycode districtcode schoolcode specialneeds totalvalidscaleela totalppela totalpela totalapela totalmeanscaleela totalmeanscalemath) (co dist sch specneed totalvalidscalelang totalpplang totalplang totalaplang totalscalelang totalscalemath)

/* Saving file */

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
 
 /* Drop those which will not appear in all years */

keep if _merge==3

// Will need to do future merging: drop _merge variable

drop _merge 

// Looking over data- dont need sch (school anymore)

drop sch

//To note- For this course will not be utilizing all variables- some in dataset are for years 2010-2013- those are not labelled.

// Making some ratio variables for staff:student ratios

// student:teacher

gen teachratio= member/tottch

// student: instructional aides
//could be more efficient--just make these commentys into var labels!!!
gen aidsratio= member/aides

// student: instructionall supervisors

gen coordratio= member/corsup

// student: guidance councelors

gen guideratio= member/totgui

// student: media specialists

gen mediaratio= member/libspe

// student: LEA administrators

gen adminratio= member/leaadm

// student: LEA support

gen suppratio= member/leasup

// student:school admin

gen schadminratio= member/schadm

// student: school support

gen schsuppratio= member/schsup

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

//a lot of code! great!! now the fun part! lookinhg forward to some descriptibe stats
//and especially regressions!
