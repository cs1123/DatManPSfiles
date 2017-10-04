* PS2 Do - File
* Chad Socha
* September 2017
* Data Management
*----------------------------

/* This PS will be for the 2008 school year. It is a part of a larger range that will be used but vrious  years for different files need different cleaning and manipulation done to them. */

clear all

cd "C:\Users\socha\Dropbox\NewJersey_District"

use codes

sort leaid

/* Dropping districts in dataset that are non-public */

drop if leaid==.

merge 1:1 leaid using Lea_01

/* Drop those which will not appear in all years */

keep if _merge==3

/* Only want public school systems */

keep if chrtschcode==.

/* Drop merge variable so othe rmerging can occur */

drop _merge

save Lea_merge01, replace

***************************************************************************************************

/* This file has a specific variable of adjustment aid being looked at as part of a public school funding/expenditure study. */

clear all

cd "C:\Users\socha\Dropbox\NewJersey_District"

import delimited "https://www.dropbox.com/s/3yk56gkx4bgtf9b/rev_2010.CSV?dl=1"

/* Drop Variables */

drop obs co coname distname account amt2 amt3

/* keep Line items to contain all individual districts and also adjust aid 8 */

keep if inlist(line, 260, 368)

/* Reshape to have adjustment aid own variable */

reshape wide desc amt1, i(dist) j(line) 

/* Drop to just have adjust aid */

drop desc260 amt1260 desc368 

/* 2010 file has 2008-2009 actual data */

gen YEAR=2008

replace amt1368=0 if amt1368==.

/* Rename Variables for appending and merging */

rename amt1368 adjustaid

sort dist

**Save Final File

save "C:\Users\socha\Dropbox\NewJersey_District\fy_1.dta", replace


/* Merging of two previous files */

clear all

cd "C:\Users\socha\Dropbox\NewJersey_District"

use Lea_merge01

sort dist

merge 1:1 dist using fy_1

/* unmerged districts are defunct or merged into other districts- saving for now */

/* Want to drop merge variable for future merging */

drop _merge


/* Recoding of adjustment aid to dummy for distinction */

recode adjustaid (0=0) (1/max=1), gen(adjdummy)

/* Encode for County distinction- as variable is strong encoding versus recoding will give distinct values for counties */

encode countyname, gen(county)

/* Codebook county to make sure encoding worked properly) */

codebook county

/* Looking at mean number of schools per district */

egen avgsch= mean(sch08)

/* Looking at mean number of schools for those with adjustment aid and those without */

bys adjdummy: egen avgmsch=mean(sch08)

/* We see by looking at overall number of schools per district and the distinction of those recieving adjustment aid and those do not are all very similar, i.e. approx. 4/district */

/* Instead of using replace, mvdecode decodes values used for missing values and can replace accordingly. 

.m = missing and .n= not applicable */

mvdecode _all, mv(-1=.m \ -2=.n)

/* Collapse to look at number of districts per county */

collapse (count) dist, by(county)	

/* We see a big dispersion of districts/county with a low of 11 in Mercer County and a max of 76 districts in Bergen */

/* Collapse to look at mean number of students/district by County */

collapse (mean) avgmember08=member08, by(county)

/* We see a min mean of 767 students per district in Warren county and a max mean of 5879/district in Essex county. */

/* Looking at adjustment aid per county */

bys county: egen sumadjaid=sum(adjustaid)

/* When we look at the total adjustment aid by county we see a range from just over 71k  in Middlesex county to a max of 145 million in Essex.
Down the line we can break this into context with number of kids, types of students (i.e. SpecEd and ELL), and other breakdowns. */
