* PS1 Do - File
* Chad Socha
* September 2017
* Data Management
*----------------------------

Clear

/* Working Directory */

cd "C:\Users\socha\Dropbox"

/* Loading in first year of data 2008 */
/* NCES LEA Universe file- tudent/teacher numbers/totals */

import delimited using "https://www.dropbox.com/s/bkmpx4f4ylz11he/Lea_01.txt?dl=1"

/* Keeping only New Jerey datapoints */

keep if lstate08=="NJ"

/* Drop unneeded Variables */

drop fipst phone08 mstree08 mcity08 mstate08 mzip08 mzip408 lstree08 lcity08 lstate08 lzip08 lzip408 union08 conum08 coname08 csa08 cbsa08 metmic08 cdcode08 latcod08 loncod08 bound08 gslo08 gshi08

/* Relabeling Variables */

label variable leaid "NCES Local Education Agency ID"
label variable stid08 "State’s own ID for the education agency"
label variable name08 "Name of the education agency"
label variable type08 "Agency type code"
label variable ulocal08 "NCES urban-centric locale code"
label variable sch08 "Aggregate number of schools associated with this agency in the CCD school universe file"
label variable ug08 "Total number of students in classes or programs without standard grade designations"
label variable pk1208 "Total number of students in classes from prekindergarten through 12th grade that are part of the public school program"
label variable member08 "Calculated total student membership of the local education agency: the sum of the fields UG and PK12"
label variable speced08 "Count of all students having a written Individualized Education Program (IEP) under the Individuals With Disabilities Education Act (IDEA), Part B"
label variable ell08 "The number of English language learner (ELL) students served in appropriate programs"
label variable pktch08 "Prekindergarten teachers. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable kgtch08 "Kindergarten teachers. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable elmtch08 "Elementary teachers. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable sectch08 "Secondary teachers. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable ugtch08 "Teachers of classes or programs to which students are assigned without standard grade designation. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable tottch08 "Total teachers. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable aides08 "Instructional aides. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable corsup08 "Instructional coordinators & supervisors. Full-time equivalency reported to the nearest tenth; includes one explicit decimal"  
label variable elmgui08 "Elementary guidance counselors. Full-time equivalency reported to the nearest tenth; includes one explicit decimal"
label variable secgui08 "Secondary guidance counselors. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable othgui08 "Other guidance counselors. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable totgui08 "Total guidance counselors. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable libspe08 "Librarians/media specialists. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable libsup08 "Library/media support staff. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable leaadm08 "LEA administrators. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable leasup08 "LEA administrative support staff. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable schadm08 "School administrators. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable schsup08 "School administrative support staff. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable stusup08 "Student support services staff. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"
label variable othsup08 "Student support services staff. Full-time equivalency reported to the nearest tenth; field includes one explicit decimal"

* Some Basic Descriptives & Data Layout 

* Total Students are important for future analyses 

hist member08

* Most districts fall within 0 to couple thousand students; few outliers over 10k, with a few between 20-40k (cities) 

* Total number of teachers are important for future analyses 

hist tottch08

* Most districts fall within having a few hundred teachers or less. A few outliers with over 1k and the most between 2-3k. 

* Scatter Plot for total students and total teachers to show distribution trends 

scatter (member08 tottch08)

* Tight grouping in districts with smaller totall students. Spread of total teachers becomes wider as student-base becomes larger.


* Saving the file- THREE FORMATS

* Stata file

save Lea_01.dta

* Raw File

outfile using Lea_01

* SPSS File

outdat using Lea_01

/* Will eventually do similar management for other LEA files and eventully append */ 
