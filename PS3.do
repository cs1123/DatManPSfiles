* PS3 Do - File
* Chad Socha
* October 2017
* Data Management
*----------------------------
/*
was great to see you guys at software carpentry! feel free now to add in some python code--eg do most stuff in stata
but also can add some work on your data in python!

again, i'd also consider (only if useful for you!) to use some school district level data; eg googling
'school district data' yields: 'https://www.google.com/search?q=school+district+data&ie=utf-8&oe=utf-8'
and may check out icpsr data maybe esspecially search by variable name/label to find what you need!
https://www.icpsr.umich.edu/icpsrweb/content/RCMD/tools/ssvd.html
*/


/* Previous Items */


/* PS1 

Initial 2008 NCES LEA Universe Data Set and cleaning/organizing */

do PS1



/* PS 2 - Using the PS2_Update file

Merge of PS1 file with "linker data" i.e. contains both NCES and NJDOE ID's for future mergiing of sets between databases

Separate file created for Adjustment Aid data for districts- includes usage of reshapiing data to fit with other sets

File is then saved and merged with previous NCES LEA Universe Data set */

do PS2_Update



/* Current Point with PS3 */

/* Up to this point, there have been 2 merges and the data had been reshaped for combining data sets */



/* CSV file of general district 4th Grade testing data for school year 2008-2009 */


import delimited "https://www.dropbox.com/s/5yeavnnrmilpi0n/test08.csv?dl=1"

/* Versus prior sets, district variable in these is a string- need to change */

destring dist, replace

drop if dist==.

sort dist

/* Removing Charter schools as they are not a part of the study */

drop if substr(cntyname, 1, 2) == "CH" 

/* Destring of school id variable */

destring sch, replace

/* Saving file */

save test08, replace

/* Merging of this file to prior dataset from PS1 and PS2_update files. For now, holding on to school level data, so using a many:1 merge as previous dataset only has one line for each district while this has numerous for individual schools in each district */

merge m:1 dist using Lea_merge01new

/* Drop _merge variable */

drop _merge

/* Saving file for future merging */

save Lea_mergetest1, replace



/* SEE NOTE AT END PERTAINING TO MERGING/ NOT ALL MERGING */



/* File of 4th grade test scores for 2008-2009 schol year based on Economic status */

clear all

import delimited "https://www.dropbox.com/s/dr0jaz61d7apysa/test08a.csv?dl=1", varnames(1) asfloat

/* Have to destring district id */

destring dist, replace

drop if dist==.

sort dist

/* Removing Charter schools as they are not a part of the study */

drop if substr(cntyname, 1, 2) == "CH" 

/* Since dist was string checked and saw school id was string as well. Need to destring for merging purposes. */

destring sch, replace

save test08a, replace

/* Merge with previous data file */

merge 1:1 dist sch  using Lea_mergetest1

/* Drop _merge variable */

drop _merge

save Lea_mergetest2

/* File of 4th grade test scores for 2008-2009 school year by ethnic groups */

clear all

import delimited "https://www.dropbox.com/s/9fcb5b73zvj0n37/test08b.csv?dl=1", varnames(1) asfloat

/* Have to destring district id */

destring dist, replace

drop if dist==.

sort dist

/* Removing Charter schools as they are not a part of the study */

drop if substr(cntyname, 1, 2) == "CH" 

/* Since dist was string checked and saw school id was string as well. Need to destring for merging purposes. */

destring sch, replace

save test08b, replace

/* Merge with previous file */

/* Merge with previous data file */

merge 1:1 dist sch  using Lea_mergetest2

/* Drop _merge variable */

drop _merge

save Lea_mergetest3, replace


/* MERGING NOTE */

/* Not all data points did a merge of both sets. Going through the names of those which did not, these entities are a combination of education commissions, vocational schools, and regional districts which do not serve students at the 4th grade level (i.e. upper level districts) and thus do not have testing data. Each merge had the same 100 points for this. Holding on to these points for now, but will probably split into a separated set to just have "full" i.e. k-12 districts for more homogenous analysis of the "typical" school district. */
