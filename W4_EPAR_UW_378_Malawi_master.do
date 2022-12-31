//TO BE UPDATED TO W4
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Malawi National Panel Survey (TNPS) LSMS-ISA Wave 4 (2014-15)
*Author(s)		: Anu Sidhu, C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 21 January 2018

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*-----------
*The Malawi National Panel Survey was collected by the National Statistical Office in Zomba 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period April 2019 - March 2020.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*https://microdata.worldbank.org/index.php/catalog/3818

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Malawi National Panel Survey.

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Malawi LSMS data set.
*Using data files from within the "378 - LSMS Burkina Faso, Malawi, Uganda" folder within the "raw_data" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\code 
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. // update when done

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Tanzania_NPS_LSMS_ISA_W4_summary_stats.xlsx" in the "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. //update when done
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file

*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						Malawi_IHS_LSMS_ISA_W4_hhids.dta
*INDIVIDUAL IDS						Malawi_IHS_LSMS_ISA_W4_person_ids.dta
*HOUSEHOLD SIZE						Malawi_IHS_LSMS_ISA_W4_hhsize.dta
*PARCEL AREAS						Malawi_IHS_LSMS_ISA_W4_plot_areas.dta
*PLOT-CROP DECISION MAKERS			Malawi_IHS_LSMS_ISA_W4_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		Malawi_IHS_LSMS_ISA_W4_TLU_Coefficients.dta

*GROSS CROP REVENUE					Malawi_IHS_LSMS_ISA_W4_tempcrop_harvest.dta
									Malawi_IHS_LSMS_ISA_W4_tempcrop_sales.dta
									Malawi_IHS_LSMS_ISA_W4_permcrop_harvest.dta
									Malawi_IHS_LSMS_ISA_W4_permcrop_sales.dta
									Malawi_IHS_LSMS_ISA_W4_hh_crop_production.dta
									Malawi_IHS_LSMS_ISA_W4_plot_cropvalue.dta
									Malawi_IHS_LSMS_ISA_W4_parcel_cropvalue.dta
									Malawi_IHS_LSMS_ISA_W4_crop_residues.dta
									Malawi_IHS_LSMS_ISA_W4_hh_crop_prices.dta
									Malawi_IHS_LSMS_ISA_W4_crop_losses.dta
*CROP EXPENSES						Malawi_IHS_LSMS_ISA_W4_wages_mainseason.dta
									Malawi_IHS_LSMS_ISA_W4_wages_shortseason.dta
									
									Malawi_IHS_LSMS_ISA_W4_fertilizer_costs.dta
									Malawi_IHS_LSMS_ISA_W4_seed_costs.dta
									Malawi_IHS_LSMS_ISA_W4_land_rental_costs.dta
									Malawi_IHS_LSMS_ISA_W4_asset_rental_costs.dta
									Malawi_IHS_LSMS_ISA_W4_transportation_cropsales.dta
									
*CROP INCOME						Malawi_IHS_LSMS_ISA_W4_crop_income.dta
									
*LIVESTOCK INCOME					Malawi_IHS_LSMS_ISA_W4_livestock_products.dta
									Malawi_IHS_LSMS_ISA_W4_livestock_expenses.dta
									Malawi_IHS_LSMS_ISA_W4_hh_livestock_products.dta
									Malawi_IHS_LSMS_ISA_W4_livestock_sales.dta
									Malawi_IHS_LSMS_ISA_W4_TLU.dta
									Malawi_IHS_LSMS_ISA_W4_livestock_income.dta

*FISH INCOME						Malawi_IHS_LSMS_ISA_W4_fishing_expenses_1.dta
									Malawi_IHS_LSMS_ISA_W4_fishing_expenses_2.dta
									Malawi_IHS_LSMS_ISA_W4_fish_income.dta
																	
*SELF-EMPLOYMENT INCOME				Malawi_IHS_LSMS_ISA_W4_self_employment_income.dta
									Malawi_IHS_LSMS_ISA_W4_agproducts_profits.dta
									Malawi_IHS_LSMS_ISA_W4_fish_trading_revenue.dta
									Malawi_IHS_LSMS_ISA_W4_fish_trading_other_costs.dta
									Malawi_IHS_LSMS_ISA_W4_fish_trading_income.dta
									
*WAGE INCOME						Malawi_IHS_LSMS_ISA_W4_wage_income.dta
									Malawi_IHS_LSMS_ISA_W4_agwage_income.dta
*OTHER INCOME						Malawi_IHS_LSMS_ISA_W4_other_income.dta
									Malawi_IHS_LSMS_ISA_W4_land_rental_income.dta

*FARM SIZE / LAND SIZE				Malawi_IHS_LSMS_ISA_W4_land_size.dta
									Malawi_IHS_LSMS_ISA_W4_farmsize_all_agland.dta
									Malawi_IHS_LSMS_ISA_W4_land_size_all.dta
*FARM LABOR							Malawi_IHS_LSMS_ISA_W4_farmlabor_mainseason.dta
									Malawi_IHS_LSMS_ISA_W4_farmlabor_shortseason.dta
									Malawi_IHS_LSMS_ISA_W4_family_hired_labor.dta
*VACCINE USAGE						Malawi_IHS_LSMS_ISA_W4_vaccine.dta
*USE OF INORGANIC FERTILIZER		Malawi_IHS_LSMS_ISA_W4_fert_use.dta
*USE OF IMPROVED SEED				Malawi_IHS_LSMS_ISA_W4_improvedseed_use.dta

*REACHED BY AG EXTENSION			Malawi_IHS_LSMS_ISA_W4_any_ext.dta
*MOBILE OWNERSHIP                   Malawi_IHS_LSMS_ISA_W2_mobile_own.dta
*USE OF FORMAL FINANACIAL SERVICES	Malawi_IHS_LSMS_ISA_W4_fin_serv.dta

*GENDER PRODUCTIVITY GAP 			Malawi_IHS_LSMS_ISA_W4_gender_productivity_gap.dta
*MILK PRODUCTIVITY					Malawi_IHS_LSMS_ISA_W4_milk_animals.dta
*EGG PRODUCTIVITY					Malawi_IHS_LSMS_ISA_W4_eggs_animals.dta

*CROP PRODUCTION COSTS PER HECTARE	Malawi_IHS_LSMS_ISA_W4_hh_cost_land.dta
									Malawi_IHS_LSMS_ISA_W4_hh_cost_inputs_lrs.dta
									Malawi_IHS_LSMS_ISA_W4_hh_cost_inputs_srs.dta
									Malawi_IHS_LSMS_ISA_W4_hh_cost_seed_lrs.dta
									Malawi_IHS_LSMS_ISA_W4_hh_cost_seed_srs.dta		
									Malawi_IHS_LSMS_ISA_W4_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		Malawi_IHS_LSMS_ISA_W4_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	Malawi_IHS_LSMS_ISA_W4_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		Malawi_IHS_LSMS_ISA_W4_control_income.dta
*WOMEN'S AG DECISION-MAKING			Malawi_IHS_LSMS_ISA_W4_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			Malawi_IHS_LSMS_ISA_W4_ownasset.dta
*AGRICULTURAL WAGES					Malawi_IHS_LSMS_ISA_W4_ag_wage.dta
*CROP YIELDS						Malawi_IHS_LSMS_ISA_W4_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				Malawi_IHS_LSMS_ISA_W4_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			Malawi_IHS_LSMS_ISA_W4_individual_variables.dta	
*PLOT-LEVEL VARIABLES				Malawi_IHS_LSMS_ISA_W4_gender_productivity_gap.dta
*SUMMARY STATISTICS					Malawi_IHS_LSMS_ISA_W4_summary_stats.xlsx
*/


clear
set more off

clear matrix	
clear mata	
set maxvar 8000		
ssc install findname      //need this user-written ado file for some commands to work_TH
//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global MLW_W4_raw_data 			"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\raw_data"
global MLW_W4_created_data 		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\temp"
global MLW_W4_final_data  		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave4-2019\outputs"

//Conventions: After section title, add initials; "IP" for in Progress/ "Complete [date] without check" if code is drafted but not checked; "Complete [date] + [Reviewer initials] checked [date]"

************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS  
************************
global IHS_LSMS_ISA_W4_exchange_rate 2158
global IHS_LSMS_ISA_W4_gdp_ppp_dollar 205.61    // https://data.worldbank.org/indicator/PA.NUS.PPP -2017
global IHS_LSMS_ISA_W4_cons_ppp_dollar 207.24	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP - Only 2016 data available 
//global IHS_LSMS_ISA_W4_inflation  // inflation rate 2015-2016. Data was collected during oct2014-2015. We want to adjust the monetary values to 2016

********************************************************************************
*THRESHOLDS FOR WINSORIZATION -- RH, Complete 7/15/21 - not checked
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables


********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************
*Enter the 12 priority crops here (maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana)
*plus any crop in the top ten crops by area planted that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize rice wheat sorgum pmill cowpea grdnt beans yam swtptt cassav banana cotton sunflr pigpea"
global topcrop_area "11 12 16 13 14 32 43 31 24 22 21 71 50 41 34"
global comma_topcrop_area "11, 12, 16, 13, 14, 32, 43, 31, 24, 22, 21, 71, 50, 41, 34"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display "$nb_topcrops"


************************
*HOUSEHOLD IDS - RH complete 7/15/21, not checked
************************
use "${MLW_W4_raw_data}\hh_mod_a_filt.dta", clear
ren hh_a02a TA 
rename ea_id ea
rename hh_wgt weight
rename region region
lab var region "1=North, 2=Central, 3=South"
gen rural = (reside==2)
keep HHID region district TA ea weight rural  
lab var rural "1=Household lives in a rural area"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta", replace


************************
*INDIVIDUAL IDS - RH complete 7/15/21, not checked
************************
use "${MLW_W4_raw_data}\hh_mod_b", clear
ren PID personid			//At the individual-level, the IHPS data from 2010, 2013, and 2016, and 2019 can be merged using the variable PID - will be used later in data
keep HHID personid hh_b03 hh_b05a hh_b04
gen female=hh_b03==2 
lab var female "1= indivdual is female"
gen age=hh_b05a
lab var age "Indivdual age"
gen hh_head=hh_b04 if hh_b04==1
lab var hh_head "1= individual is household head"
drop hh_b03 hh_b05 hh_b04
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_person_ids.dta", replace

************************
*HOUSEHOLD SIZE - RH complete 7/15/21, not checked
************************
//To know the number of hh members and the number of females heads of household
use "${MLW_W4_raw_data}\hh_mod_b", clear
gen hh_members = 1					//Generate this so we can sum later and identify the # of hh members (each member gets a HHID so summing will help collapse this to see hh #)
rename hh_b04 relhead 
rename hh_b03 gender
gen fhh = (relhead==1 & gender==2)	//Female heads of households

collapse (sum) hh_members (max) fhh, by (HHID)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhsize.dta", replace

************************
*PLOT AREAS - RH complete 7/15/21, not checked
************************
//To know the areas of the plots that were surveyed
use "${MLW_W4_raw_data}\ag_mod_c.dta", clear 
append using "${MLW_W4_raw_data}\ag_mod_j.dta"	
gen area_acres_est = ag_c04a if ag_c04b == 1 										//Self-report in acres - rainy season
replace area_acres_est = (ag_c04a*2.47105) if ag_c04b == 2 & area_acres_est ==.		//Self-report in hectares
replace area_acres_est = (ag_c04a*0.000247105) if ag_c04b == 3 & area_acres_est ==.	//Self-report in square meters
replace area_acres_est = ag_j05a if ag_j05b==1										//Replace with dry season measures if rainy season is not available
replace area_acres_est = (ag_j05a*2.47105) if ag_j05b == 2 & area_acres_est ==.		
replace area_acres_est = (ag_j05a*0.000247105) if ag_j05b == 3 & area_acres_est ==.	
gen area_acres_meas = ag_c04c														//GPS measure - rainy
replace area_acres_meas = ag_j05c if area_acres_meas==. 							//GPS measure - replace with dry if no rainy season measure
* SAK NOTE 20190910: Should also keep if area_acres_meas is not missing (not 
* your mistake, it was that way in Tanzania because there wasn't a difference)
keep if area_acres_est !=. /*SAK START*/ | area_acres_meas !=. /*SAK END*/

keep HHID plotid gardenid area_acres_est area_acres_meas 							//Keeping gardenid to uniquely identify observations later
collapse (sum) area_acres_est area_acres_meas, by (HHID plotid gardenid) 
lab var area_acres_meas "Plot are in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_plot_areas.dta", replace 


************************
*PLOT DECISION MAKERS - RH complete 9/2, not checked
************************
//Individual gender - complete RH 7/15/21, not checked
use "${MLW_W4_raw_data}/hh_mod_b.dta", clear  	//No plot or garden id in this dta
ren PID personid	 							//PID is unique person identifier  
drop if personid==.
gen female =hh_b03==2
gen age = hh_b05a
gen head = hh_b04==1 if hh_b04!=.
keep female age HHID head personid
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
save "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_gender_merge.dta", replace 

//RH (9/2/21) - CODE NOTES TO REMOVE RG AND DG
*AG_MOD_K = dry, AG_MOD_D = rainy
*subinstr to remove "dg" from garden id and "d" from plotids (dry)
*save this as plot managers
*use rainy, repeat with removing "rg" and "r" respectively
*merge in plot managers by HHID plot_id gardenid

//First creating rainy season & cleaning plot and garden id for merge
use "${MLW_W4_raw_data}/ag_mod_d.dta", clear 	//Rainy season
drop if ag_d14==. 
gen cultivated = 1 if ag_d14==1 	//ag_d57 is previous season. using d14 for current
drop if plotid==""	
gen dry = strpos(plotid, "D") > 0 				 	//To code for dry season as a variable used later, 0 = rainy, 1 = dry (plot level)
gen dry_garden = strpos(gardenid, "D") > 0  // "dry" is plot level, "dry_garden" is garden level (plot and garden can be different)

//Removing RG and R (rainy) from gardenid and plotid for merge later
replace gardenid = subinstr(gardenid, "RG", "", .)
replace plotid = subinstr(plotid, "R", "", .)
replace gardenid = subinstr(gardenid, "DG", "", .)
replace plotid = subinstr(plotid, "D", "", .)
save "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_rainy_season_plot_manager.dta", replace

//cleaning dry season
use "${MLW_W4_raw_data}/ag_mod_k.dta", clear 	//Dry season
drop if plotid==""
gen dry = strpos(plotid, "D") > 0   // 0=rainy, 1=dry (plot level)
gen dry_garden = strpos(gardenid, "D") > 0 // "dry" is plot level, "dry_garden" is garden level (plot and garden can be different)
drop if ag_k36==.
gen cultivated = ag_k36==1 	
//removing dry and rainy designations on gardenid/plotid for merge
replace gardenid = subinstr(gardenid, "DG", "", .)
replace plotid = subinstr(plotid, "D", "", .)
replace gardenid = subinstr(gardenid, "RG", "", .)
replace plotid = subinstr(plotid, "R", "", .)
save "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_dry_season_plot_manager.dta", replace

//merging dry and rainy
merge 1:1 HHID gardenid plotid using "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_rainy_season_plot_manager.dta" //keeping all, 539 merged, 17142 unique to dry 1820 unique to rainy
recode cultivated (.=0)
*duplicates report HHID plotid gardenid // no dups

*Gender/age variables - decision makers
gen personid = ag_d01 // RH note - the decision-maker concerning crops, not respondent id
replace personid = ag_k02 if personid==. &  ag_k02!=.	// ag_k02 is "Who in the household makes the decisions concerning crops to be planted..." 152 obs missing both plot 

merge m:1 HHID personid using  "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_gender_merge.dta", gen(dm1_merge) keep (1 3)	// Dropping unmatched from using // RH Confirm request: can PIDs be mapped onto ag_d01? (Ag_d01 is the id of the plot decision maker, not the respondent, where the gender merge uses PID as personid)

*First decision-maker variables
gen dm1_female = female // replace females for first manager with new variable so we can add new identifiers for later managers below. 
drop female personid	// in order to do next two manager variables. 

*Second owner
gen personid = ag_d01_2a // check question - ag_d01_1, should this be used?
replace personid =ag_k02_2a if personid==. &  ag_k02_2a!=.
merge m:1 HHID personid using "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_gender_merge.dta", gen(dm2_merge) keep(1 3)		// Dropping unmatched from using (n=6,409)
gen dm2_female = female
drop female personid

*Third
gen personid = ag_d01_2b
replace personid =ag_k02_2b if personid==. &  ag_k02_2b!=.
merge m:1 HHID personid using "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_gender_merge.dta", gen(dm3_merge) keep(1 3)		// Dropping unmatched from using
gen dm3_female = female
drop female personid 

*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & (dm3_female==0 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & (dm3_female==1 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==. & dm3_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var  dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhsize.dta", nogen keep (1 3)								
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
ren plotid plot_id
*drop if  plot_id==""

keep HHID plot_id dm_gender cultivated gardenid /*dry dry_garden*/ // RH note: not including dry variables to match TZA files, including gardenid for MWI
lab var cultivated "1=Plot has been cultivated"
lab var dry "1 = dry, 0 = rainy (plot level)"
lab var dry_garden "1 = dry, 0 = rainy (garden level)"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_plot_decision_makers.dta", replace 

//draft notes for plot decision makers in RH file

************************
*CROP UNIT CONVERSION FACTORS
************************
use "${MLW_W4_raw_data}/Agricultural Conversion Factor Database.dta", clear
ren crop_code crop_code_full
save "${MLW_W4_created_data}/MLW_W4_cf.dta", replace


************************
*MONOCROPPED PLOTS
************************

//BMGF 12 priority crops//
*maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana
**NOTE: Malawi has a Rainy Season and Dry Season - no long/short seasons like in TZ**

//List of crops for this instrument - rainy and dry season and *=BMGF priority; In (crop code)//
/*
							Rainy Season	Dry Season 
maize* (1) 						*				*
tobacco							*
groundnut* (11)					*
rice* (17)						*				
ground bean 					*				
sweet potato* (28) 				*				*
irish potato					*				*
finger millet* (29)     		*
sorghum* (32)					*
pearl millet* (33)				*
beans* (34)						*				*
soyabean						*
pigeon pea						*
sugar cane						*
tanaposi						*				*
nkhwani							*				*
okra							*				*
tomato							*
peas							*				*
onion											*
cabbage											*
Cotton							*
Sunflower						*
Paprika							*
other							*				*

*/

*Enter the 12 Gates priority crops here, plus any crop in the top ten that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the BMGF 12 crops in order first, then the additional top ten crops
use "${MLW_W4_raw_data}/ag_mod_g.dta", clear 	 				//Rainy season
ren crop_code crop_code_full									//Renaming to match dry season variables
ren crop_code_collapsed crop_code								//crop_code now indicates the collapsed crop code that the globals will refer to below. 
append using  "${MLW_W4_raw_data}/ag_mod_m.dta", gen(dry) 		//Append Dry season - no sorghum, fmillet, pmillet, or groundnut 

global topcropname_area "maize rice sorgum pmillet fmill grdnt beans swtptt" // Only included BMGF 12 priority crops (of which there are 7 in MLW). Have not yet added top 10 crops. AKS 5.9.19
global topcrop_area "1 17 32 33 31 11 34 28" 
global comma_topcrop_area "1, 17, 32, 33, 31, 11, 34, 28" // added 33 TH 1.25.21

**check back to see if need to manually collapse crop codes or add top 10 crops TH 1.25.21

*Rename variables to match conversion file 
// harvests are reported in different units not just KG so this dta file is meant to make them all be measured in KG
ren ag_g13b unit
replace unit = ag_g04b if unit==.
replace unit = ag_m11b if unit==.
ren ag_g13c condition	//No condition measure for dry 

//set trace on - use to identify specific problems in loop 

*Merge in region from hhids file and conversion factors keep(1 3) discards 
* data which does not 
merge m:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta", nogen keep(1 3)	
merge m:1 region crop_code_full unit condition using "${MLW_W4_created_data}/MLW_W4_cf.dta", keep(match master)	//20,254 matched, 7,851 not matched in master 
save "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_collapsed_crops_w_cf.dta", replace 

*Generating area harvested and kilograms harvested
forvalues k=1(1)8  {		
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	use "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_collapsed_crops_w_cf.dta", clear 	//Rainy & dry season
	append using "${MLW_W4_raw_data}/ag_mod_p.dta", gen(perm)
	recode dry (.=0)
	drop if plotid=="" 																		//141 observations
	
	gen kgs_harv_mono_`cn' = ag_g13a*conversion if crop_code == `c'					//KG harvested in rainy season first 
	replace kgs_harv_mono_`cn' = ag_m11a*conversion if crop_code==`c' & dry==1 		//If nothing in rainy, replace with harvest in dry

	replace kgs_harv_mono_`cn' = ag_p09a*conversion if crop_code==`c' & kgs_harv_mono==.	//If nothing in either of those, replace with perm crops
	recode kgs_harv_mono_`cn' (.=0)

	*First, get percent of plot planted with crop
	replace ag_g02 = ag_m02 if ag_g02==.
	replace ag_g03 = ag_m03 if ag_g03==.

	//replace ag6a_05 = ag6b_05 if ag6a_05==.		//DMC - including permanent and tree crops //AKS - MLW does not provide % area planted of perm crops
	gen percent_`cn' = 1 if ag_g02==1 & crop_code==`c'
	replace percent_`cn' = 1 if ag_m02==1 & crop_code_full==`c' & ag_g02==. 
	replace percent_`cn' = 0.125*(ag_g03==1) + 0.25*(ag_g03==2) + 0.5*(ag_g03==3) + 0.75*(ag_g03==4) + 0.875*(ag_g03==5)  if percent_`cn'==. & crop_code==`c'	//for when area harvested is not 100% of one crop

	xi i.crop_code, noomit							//xi= separates out categories "i.[variable]" "noomit" don't skip even if there are no observation for category
	collapse (sum) kgs_harv_mono_`cn' (max) _Icrop_code_* percent_`cn', by(HHID plotid gardenid dry)	//* captures every crop [placeholder]
	egen crop_count = rowtotal(_Icrop_code_*)	
	keep if crop_count==1 & _Icrop_code_`c'==1  	//only keeping monocropped option for relevant crop  


	merge m:1 HHID gardenid plotid using "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_plot_areas.dta", nogen keep(3) 
	replace area_meas_hectares=. if area_meas_hectares==0 					
	replace area_meas_hectares = area_est_hectares if area_meas_hectares==. 	// Replacing missing with estimated
	gen `cn'_monocrop_ha = area_meas_hectares*percent_`cn'			
	drop if `cn'_monocrop_ha==0 

	save "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_`cn'_monocrop.dta", replace  
}

*Adding in gender of plot manager
forvalues k=1(1)8  {		
local c : word `k' of $topcrop_area
local cn : word `k' of $topcropname_area
use "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_`cn'_monocrop.dta", clear		

merge m:1 HHID plotid gardenid dry using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_plot_decision_makers.dta" 
foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' { 
	gen `i'_male = `i' if dm_gender==1
	gen `i'_female = `i' if dm_gender==2
	gen `i'_mixed = `i' if dm_gender==3
	replace `i'_male = . if dm_gender!=1
	replace `i'_female = . if dm_gender!=2
	replace `i'_mixed = . if dm_gender!=3
}

gen `cn'_monocrop_male = 0 
replace `cn'_monocrop_male=1 if dm_gender==1
gen `cn'_monocrop_female = 0 
replace `cn'_monocrop_female=1 if dm_gender==2
gen `cn'_monocrop_mixed = 0 
replace `cn'_monocrop_mixed=1 if dm_gender==3

*And now this code will indicate whether the HOUSEHOLD has at least one of these plots and the total area of monocropped maize plots
collapse (sum) `cn'_monocrop_ha* kgs_harv_mono_`cn'* (max) `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed `cn'_monocrop = _Icrop_code_`c', by(HHID) //AKS Help- variable "_Icropcode_1" is not found here but I see it exists in the variable list... 11.22.19
gen monocrop_`cn'=1 //ihs 1.29.19 //Does the code break - code does not break here 11.22.19

foreach i in male female mixed {
	replace `cn'_monocrop_ha = . if `cn'_monocrop!=1
	replace `cn'_monocrop_ha_`i' =. if  `cn'_monocrop!=1
	replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_`i'==0
	replace `cn'_monocrop_ha_`i' =. if `cn'_monocrop_ha_`i'==0
	replace kgs_harv_mono_`cn' = . if `cn'_monocrop!=1 
	replace kgs_harv_mono_`cn'_`i' =. if  `cn'_monocrop!=1 
	replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_`i'==0 
	replace kgs_harv_mono_`cn'_`i' =. if `cn'_monocrop_ha_`i'==0 
}

save "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_`cn'_monocrop_hh_area.dta", replace
}

             


************************
*TLU (Tropical Livestock Units)
************************
use "${MLW_W4_raw_data}/ag_mod_r1.dta", clear		//EEE 10.1.19 even though this runs, I would try to always match the dta file exactly in terms of capitalization
gen tlu_coefficient=0.5 if (ag_r0a==304|ag_r0a==303|ag_r0a==302|ag_r0a==301) //bull, cow, steer & heifer, calf [for Malawi]
replace tlu_coefficient=0.1 if (ag_r0a==307|ag_r0a==308) //goat, sheep
replace tlu_coefficient=0.2 if (ag_r0a==309) //pig
replace tlu_coefficient=0.01 if (ag_r0a==3310|ag_r0a==315) //lvstckid==12|lvstckid==13) //chicken (layer & broiler), duck, other poultry (MLW has "other"?), hare (not in MLW but have hen?) AKS 5.15		
//EEE 10.1 From looking at other instruments/waves, I would include 311 LOCAL-HEN, 313-LOCAL-COCK, 3314 TURKEY/GUINEA FOWL, and 319 DOVE/PIGEON in the line above
replace tlu_coefficient=0.3 if ag_r0a==3305 // donkey
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

*Livestock categories
gen cattle=inrange(ag_r0a,301,304)
gen smallrum=inlist(ag_r0a,307,308,309) //inlcudes sheep, goat			//EEE 10.1 inrange vs. inlist
gen poultry=inlist(ag_r0a,311,313,315,319,3310,3314)  //includes pigeon (319)		//EEE 10.1 changed to reflect list above
gen other_ls=ag_r0a==318 | 3305 | 3304 // inlcludes other, donkey/horse, ox		//EEE 10.1 must include ag_r0a= with every single or clause
gen cows=ag_r0a==303
gen chickens= ag_r0a==313 | 311 | 3310 | 3314 // includes local cock (313), local hen (311),  chicken layer (3310), and turkey (3314)		//EEE 10.1 same problem here
ren ag_r0a livestock_code

*Number of livestock owned, present-day
ren ag_r02 nb_ls_today
gen nb_cattle_today=nb_ls_today if cattle==1
gen nb_smallrum_today=nb_ls_today if smallrum==1
gen nb_poultry_today=nb_ls_today if poultry==1
gen nb_other_ls_today=nb_ls_today if other==1 
gen nb_cows_today=nb_ls_today if cows==1
gen nb_chickens_today=nb_ls_today if chickens==1
gen tlu_today = nb_ls_today * tlu_coefficient

lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_poultry_today "Number of cattle poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (horse, donkey, and other) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_today "Number of livestock owned as of today" 

*Number of livestock owned, 1 year ago
//ren ag_r07 nb_ls_1yearago // Help - number of different livestock 1 year ago - wasn't working when I renamed the variable for some reason AKS 6.12.19 //VAP 08/16/2019: move this line after line 503 or rename ag_r07 as nb_ls_1yearago in lines 496-503. 		//EEE 10.1 fixed this down below
gen nb_cattle_1yearago = ag_r07 if cattle==1
gen nb_smallrum_1yearago=ag_r07 if smallrum==1
gen nb_poultry_1yearago=ag_r07 if poultry==1
gen nb_other_1yearago=ag_r07 if other==1
gen nb_cows_1yearago=ag_r07 if cows==1
gen nb_chickens_1yearago=ag_r07 if chickens==1
gen nb_ls_1yearago = ag_r07
gen tlu_1yearago = ag_r07 * tlu_coefficient

lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminants owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of poultry as of 12 months ago"
lab var nb_other_1yearago "Number of other livestock (horse, donkey, and other) owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"
lab var nb_ls_1yearago "Number of livestock owned 12 months ago"

recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (HHID)
drop tlu_coefficient
save "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_TLU_Coefficients.dta", replace

************************
*GROSS CROP REVENUE
************************
use "${MLW_W4_raw_data}/ag_mod_g.dta", clear		
append using "${MLW_W4_raw_data}/ag_mod_m.dta", gen(dry)

*Rename variables so they match in merged files
ren plotid plot_id
ren crop_code crop_code_full		//To match the conversion file variable name for merging later
replace crop_code_full = crop_code_collapsed if crop_code_full==.
ren ag_g13b unit 
replace unit = ag_m11b if unit==.
ren ag_g13c condition
replace condition = ag_m11c if condition==.
drop if plot_id==""

*Merge in region from hhids file and conversion factors
merge m:1 HHID using  "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta", nogen keep(1 3)	//6,739 matched 0 unmatched
merge m:1 region crop_code_full unit condition using  "${MLW_W4_created_data}/MLW_W4_cf.dta"		//5,109 matched 2,415 unmatched
//ren crop_code_full crop_code_collapsed 	//rename for consistency across files

*Temporary crops (both seasons) 
gen harvest_yesno=.
replace harvest_yesno = 1 if ag_g13a > 0 & ag_g13a !=.		//Yes harvested
replace harvest_yesno = 2 if ag_g13a == 0					//No harvested "maize rice sorgum pmillet fmill grdnt beans swtptt" //
gen kgs_harvest = ag_g13a*conversion if crop_code_full== 1 | crop_code_full== 17 | crop_code_full==32 |  crop_code_full==33 | crop_code_full==31 | crop_code_full==11 |  crop_code_full==34 |  crop_code_full==28 	
replace kgs_harvest = ag_m11a*conversion if crop_code_full== 1 | crop_code_full== 17 | crop_code_full==32 |  crop_code_full==33 | crop_code_full==31 | crop_code_full==11 |  crop_code_full==34 |  crop_code_full==28 & kgs_harvest==.
//rename ag4a_29 value_harvest																		//Not possible to construct value_harvest, used value_sold below instead
//replace value_harvest = ag4b_29 if value_harvest==.
replace kgs_harvest = 0 if harvest_yesno==2					//If no harvest, then 0 KG
collapse (sum) kgs_harvest /*value_harvest*/, by (HHID crop_code_collapsed plot_id)
ren crop_code_collapsed crop_code							//For consistency 
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_tempcrop_harvest.dta", replace

*Value of harvest by quantity sold - in Module I of LSMS (no value of harvest question in Malawi) 
use "${MLW_W4_raw_data}/ag_mod_i.dta", clear
append using "${MLW_W4_raw_data}/ag_mod_o.dta", gen(dry)		//Neither of these files have the crop_code_collapsed; only extenstive crop code

gen crop_code_collapsed=.
replace crop_code_collapsed=1 if crop_code==1 | crop_code==2 | crop_code==3 | crop_code==4											//MAIZE
replace crop_code_collapsed=17 if crop_code==17 | crop_code==18 | crop_code==19 | crop_code==21 | crop_code==23 | crop_code==25		//RICE
//replace crop_code=30 //No wheat in this dta file Help - ask Emma
replace crop_code_collapsed=32 if crop_code==32																						//SORGUM
replace crop_code_collapsed=33 if crop_code==33																						//PMILL
replace crop_code_collapsed=11 if crop_code==11 | crop_code==12 | crop_code==13 | crop_code==14 | crop_code==15 | crop_code==16
replace crop_code_collapsed=34 if crop_code==34 | crop_code==34
replace crop_code_collapsed=28 if crop_code==28
la def crop_code_collapsed 1 "Maize" 17 "Rice" /*30 "Wheat"*/ 32 "Sorgum" 33 "Pearl Millet" 11 "Ground Nut" 34 "Beans" 28 "Sweet Potato" 
//la val crop_code crop_code_collapsed 	
//lab var crop_code_collapsed "Crop Code Collapsed" 

*Rename variables so they match in merged files
ren crop_code crop_code_full
ren ag_i02b unit 
replace unit = ag_o02b if unit==. 
ren ag_i02c condition
replace condition = ag_o02c if condition==.

*Merge in region from hhids file and conversion factors
merge m:1 HHID using  "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta", nogen keep(1 3)		//0 unmatched 23,918 matched
merge m:1 region crop_code_full unit condition using  "${MLW_W4_created_data}/MLW_W4_cf.dta"			//18,671 unmatched from master 651 unmatched from using 5,247 matched


*Temporary crop sales 
drop if crop_code_full==.
rename ag_i01 sell_yesno
replace sell_yesno = ag_o01 if sell_yesno==.
gen quantity_sold = ag_i02a*conversion if crop_code_full==1 | 11 | 17 | 28 | 30 | 32 | 33 | 34  //`c' //Help invalid syntax if I use `c'
replace quantity_sold = ag_o02a*conversion if crop_code_full==1 | 11 | 17 | 28 | 30 | 32 | 33 | 34  & quantity_sold==. //same issue for crop code as above
rename ag_i03 value_sold
replace value_sold = ag_o03 if value_sold==.
keep if sell_yesno==1
collapse (sum) quantity_sold value_sold, by (HHID crop_code_full)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_tempcrop_sales.dta", replace

*Permanent and tree crops
*fodder trees, fuel wood trees and fertiliser trees include as perm crops, but they are for purposes of soil improvement and not harvest so are excluded. 
use "${MLW_W4_raw_data}/ag_mod_p.dta", clear //Rainy season
ren ag_p0c crop_code
drop if crop_code==.						//Need to add new perm crops from world bank update e.g., coffee
replace crop_code = 100 if crop_code==4		//Mango - renaming all permanent crops due to overlap of codes with temporary crops
replace crop_code = 150 if crop_code==5		//Orange
replace crop_code = 200 if crop_code==6		//Papaya
replace crop_code = 250 if crop_code==7		//Banana
replace crop_code = 300 if crop_code==8		//Avocado
replace crop_code = 350 if crop_code==9		//Guava
replace crop_code = 400 if crop_code==10	//Lemon
replace crop_code = 450 if crop_code==11	//Tangerine
replace crop_code = 500 if crop_code==12	//Peach 
replace crop_code = 550 if crop_code==13	//Poza 
replace crop_code = 600 if crop_code==14	//Masuku
replace crop_code = 650 if crop_code==15	//Masau 
replace crop_code = 700 if crop_code==21	//Other - q=36
replace crop_code = 750 if crop_code==100	//Cassava - q=982 - use sweet potato 
replace crop_code = 800 if crop_code==16	//Pineapple //Treaing "piece" of pineapple as 1 KG. 
replace crop_code = 850 if crop_code==3		//Coffee 
replace crop_code = 900 if crop_code==17	//Macadamia
la def crop_code 100 "Mango" 150 "Orange" 200 "Papaya" 250 "Banana" 300 "Avocado" 350 "Guava" 400 "Lemon" 450 "Tangerine" 500 "Peach" 550 "Poza" /*
*/ 600 "Masuku" 650 Masau 700 "Other" 750 "Cassava" 800 "Pineapple" 850 "Coffee"

*Rename to match conversion file
ren ag_p09b unit	

*Created conversion file from resources PDF provided by World Bank -  missing crops include peach, poza, cassava, and masuku (no conversion for these)
merge m:1 HHID using  "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta", nogen keep(1 3)		//0 unmatched 3,959 matched - adding in region
merge m:1 region crop_code unit using  "${MLW_W4_raw_data}/Conversion_factors_perm.dta"					//3,503 unmatched (3,439 from master & 64 from using) 520 matched 

gen kgs_harvest = ag_p09a*Conversion		//AKS 8.9.19: using conversions from created file but missing some converstion codes for units such as "basket"

collapse (sum) kgs_harvest, by (HHID crop_code plotid)
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
ren plotid plot_id							//For consistent coding
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_permcrop_harvest.dta", replace

use "${MLW_W4_raw_data}/ag_mod_q.dta", clear //Dry season 
*units include kilogram, 50 kg bag, small pail, large pail, bunch, piece, ox-cart -- created perm conversion file to convert all to kg units. 
drop if crop_code==.
replace crop_code = 100 if crop_code==4		//Mango - renaming all permanent crops due to overlap of codes with temporary crops
replace crop_code = 150 if crop_code==5		//Orange
replace crop_code = 200 if crop_code==6		//Papaya
replace crop_code = 250 if crop_code==7		//Banana
replace crop_code = 300 if crop_code==8		//Avocado
replace crop_code = 350 if crop_code==9		//Guava
replace crop_code = 400 if crop_code==10	//Lemon
replace crop_code = 450 if crop_code==11	//Tangerine
replace crop_code = 500 if crop_code==12	//Peach  		
replace crop_code = 550 if crop_code==13	//Poza 	
replace crop_code = 600 if crop_code==14	//Masuku
replace crop_code = 650 if crop_code==15	//Masau
replace crop_code = 700 if crop_code==18	//Other 
replace crop_code = 750 if crop_code==1		//Cassava = q=867 - use Zambia code; oxcart measure is taken from 
replace crop_code = 800 if crop_code==16	//Pineapple //Treaing "piece" of pineapple as 1 KG. 
replace crop_code = 850 if crop_code==3		//Coffee
la def crop_code 100 "Mango" 150 "Orange" 200 "Papaya" 250 "Banana" 300 "Avocado" 350 "Guava" 400 "Lemon" 450 "Tangerine" 500 "Peach" 550 "Poza" /*
*/ 600 "Masuku" 650 "Masau" 700 "Other" 750 "Cassava"

*Rename to match conversion file
ren ag_q02b unit

*Checked this decision with Ayala. Created conversion file from resources PDF provided by World Bank 
	//Peach, Poza, Cassava, and Masuku do not have conversion codes in Malawi reference doc. Instead, I use the following conversions for each of these crops:
		/*Peach = Orange, Poza = Tangerine, Masuku = Tangerine,  and Cassava = I used "Raw cassava" conversion from Zambia LSMS; I use raw because most cassava is sold raw in Malawi (http://citeseerx.ist.psu.edu
		/viewdoc/download?doi=10.1.1.480.7549&rep=rep1&type=pdf*/
	*Ox-cart also does not have a conversion, instead I use the conversion factor for "extra large wheelbarrow" from Nigeria (https://microdata.worldbank.org/index.php/catalog/1002/datafile/F75/V1961)
	
merge m:1 HHID using  "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta", nogen keep(1 3)				//0 unmatched 3,833 matched - adding in region
merge m:1 region crop_code unit using  "${MLW_W4_raw_data}/Conversion_factors_perm.dta", nogen keep(1 3)		//3,690 unmatched (3,617 from master & 73 from using) 216 matched 

rename ag_q01 sell_yesno
gen quantity_sold = ag_q02a*Conversion			//AKS 8.9.19: using conversions from created file but missing some conversion codes for units such as "basket"
replace quantity_sold = ag_q02a*1 if unit==1	//If quantity is measured in KG just multiply by 1 to get KG quantity_sold (don't have this variable in conversion file)
rename ag_q03 value_sold
keep if sell_yesno==1
recode quantity_sold value_sold (.=0)
collapse (sum) quantity_sold value_sold, by (HHID crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_permcrop_sales.dta", replace


*Prices of permanent and tree crops need to be imputed from sales
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_permcrop_sales.dta", clear
append using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_tempcrop_sales.dta"


recode price_kg (0=.)
merge m:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales.dta", replace	//AKS Help - stata says that this file cannot be opened?

use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales.dta", clear	//Measure by EA (Note this wave does not have TA measure)
gen observation = 1
bys region district ea crop_code: egen obs_ea = count(observation)			
collapse (median) price_kg [aw=weight], by (region district ea crop_code obs_ea)
rename price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_ea.dta", replace

use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales.dta", clear	//Now measure by District 
gen observation = 1
bys region district crop_code: egen obs_district = count(observation) 
collapse (median) price_kg [aw=weight], by (region district crop_code obs_district)
rename price_kg price_kg_median_district
lab var price_kg_median_district "Median price per kg for this crop in the district"
lab var obs_district "Number of sales observations for this crop in the district"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_district.dta", replace

use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales.dta", clear	//Now by Region
gen observation = 1 
bys crop_code: egen obs_region = count(observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
rename price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_region.dta", replace

use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales.dta", clear	//Now by country
gen observation = 1
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
rename price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_country.dta", replace

*Pull prices into harvest estimates
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales.dta", clear
replace crop_code_full = -_n if crop_code_full==.
drop crop_code
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales_temp.dta", replace

use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_tempcrop_harvest.dta", clear		//Uniquely identify by HHID, plot_id, and crop_code_collapsed
append using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_permcrop_harvest.dta"
merge m:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta"	//2,563 unmatched (9 from master, 2,554 from using) & 27,547 matched
drop if _merge==2
drop _merge

rename crop_code crop_code_full
merge m:1 HHID crop_code_full using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales_temp.dta" //AKS help won't merge due to not uniquely idenifying but I don't see the problem. //TH 5.18.21 fixed

replace crop_code_full=. if crop_code_full<0
rename crop_code_full crop_code

drop _merge
merge m:1 region district ea crop_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_ea.dta"
drop _merge
//merge m:1 region district crop_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_ta.dta" //TH 5.18.21 no TA in w3
//drop _merge
merge m:1 region district crop_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_district.dta"
drop _merge
merge m:1 region crop_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_region.dta"
drop _merge
merge m:1 crop_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_country.dta"
drop _merge
gen price_kg_hh = price_kg
lab var price_kg_hh "Price per kg, with missing values imputed using local median values"
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=21 &crop_code!=48 //TH 5.17.21: changed crop code to match "other" on W4 tempcrop/permacrop_harvest /* Don't impute prices for "other" permanent or temporary crops */
//replace price_kg = price_kg_median_ta if price_kg==. & obs_ta >= 10 & crop_code!=21 & crop_code!=48 // TH 5.17.21: no TA in w3
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=21 & crop_code!=48
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=21 & crop_code!=48
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=21 & crop_code!=48
lab var price_kg "Price per kg, with missing values imputed using local median values"

//AKS: Following MMH 6.21.19 (Malawi W1): This instrument doesn't ask about value harvest, just value sold, EFW 05.02.2019 (Uganda W1): Since we don't have value harvest for this instrument computing value harvest as price_kg * kgs_harvest for everything. This is what was done in Ethiopia baseline
gen value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
lab var value_harvest_imputed "Imputed value of crop production"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_values_tempfile.dta", replace 

preserve 		
recode value_harvest_imputed value_sold kgs_harvest quantity_sold (.=0)
collapse (sum) value_harvest_imputed value_sold kgs_harvest quantity_sold , by (HHID crop_code)
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production, summed over rainy and dry season"
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far, summed over rainy and dry season"
lab var kgs_harvest "Kgs harvested of this crop, summed over rainy and dry  season"
ren quantity_sold kgs_sold
lab var kgs_sold "Kgs sold of this crop, summed over rainy and dry season"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_crop_values_production.dta", replace
restore
*The file above will be used as the estimation intermediate variables : Gross value of crop production, Total value of crop sold, Total quantity harvested.  

collapse (sum) value_harvest_imputed value_sold, by (HHID)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. /* In a few cases, the kgs sold exceeds the kgs harvested */
rename value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household value estimated for temporary crop production plus observed sales prices for permanent/tree crops.
*Prices are imputed using local median values when there are no sales.
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_crop_production.dta", replace

*Plot value of crop production
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_values_tempfile.dta", clear
collapse (sum) value_harvest_imputed, by (HHID plot_id)
rename value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_plot_cropvalue.dta", replace

*Crop residues (captured only in Tanzania) 		// AKS 08.23/.2019: Malawi W4 doesn't ask about crop residues // TH 5.18.21 Malawi W4**

*Crop values for inputs in agricultural product processing (self-employment)
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales.dta", clear //TH 5.18.21 recoding crop_code_full here so observations can be uniquely identified
replace crop_code_full = -_n if crop_code_full==.
drop crop_code
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales_temp.dta", replace

use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_tempcrop_harvest.dta", clear		
append using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_permcrop_harvest.dta"
merge m:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta", nogen keep(1 3)

rename crop_code crop_code_full //TH 5.18.21 restoring to original 
merge m:1 HHID crop_code_full using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_sales_temp.dta" 

replace crop_code_full=. if crop_code_full<0
rename crop_code_full crop_code
drop _merge

merge m:1 region district ea crop_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_ea.dta", nogen // TH 5.18.21 no TA in W4
//merge m:1 region district crop_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_ta.dta", nogen // TH 5.18.21 no TA in W4
merge m:1 region district crop_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_region.dta", nogen
merge m:1 crop_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_crop_prices_country.dta", nogen
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!= 48 & crop_code!=21 & crop_code!=18/* Don't impute prices for "other" crops. VAP: Check code 1800 for other. TH 5.17.21: Other crop ==18|21|48*/ 
//replace price_kg = price_kg_median_ta if price_kg==. & obs_ta >= 10 & crop_code!=18 // TH 5.18.21 no TA in w3
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!= 48 & crop_code!=21 & crop_code!=18
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!= 48 & crop_code!=21 & crop_code!=18
replace price_kg = price_kg_median_country if price_kg==. & crop_code!= 48 & crop_code!=21 & crop_code!=18
lab var price_kg "Price per kg, with missing values imputed using local median values"

gen value_harvest_imputed = kgs_harvest * price_kg if price_kg!=.  //MW W2 doesn't ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
keep HHID crop_code price_kg 
duplicates drop
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_crop_prices.dta", replace

//AKS CHECK FOR W4 *Crops lost post-harvest: VAP: MW W2 Questionnaire only asks about qty lost, not value. Cannot create Malawi_IHS_LSMS_ISA_W2_crop_losses.dta similar to TZ. 
// TH 5.18.21 ag module 036 "How much of the the harvested [CROP] during the [REFERENCE DIMBA SEASON] was lost to rotting, insects, rodents, theft, etc. in the post-harvest period?" p.73 but measured in quantity, not in monetary values

************************
*CROP EXPENSES 
************************
//The purpose of this section is to analyze how much money is spent into growing & harvesting crops. This includes inputs used in growing crops. 

*Expenses: Hired labor: Module D of Agriculture Survey
use "${MLW_W4_raw_data}/ag_mod_d.dta", clear // Rainy season 

rename ag_d47a1 no_days_men_nharv 		// non harvest activities: land preparation, planting, ridging, weeding, fertilizing
rename ag_d47b1 avg_dlywg_men_nharv		// men daily wage 
rename ag_d47a2 no_days_women_nharv 
rename ag_d47b2 avg_dlywg_women_nharv
rename ag_d47a3 no_days_chldrn_nharv
rename ag_d47b3 avg_dlywg_chldrn_nharv
recode no_days_men_nharv avg_dlywg_men_nharv no_days_women_nharv avg_dlywg_women_nharv no_days_chldrn_nharv avg_dlywg_chldrn_nharv (.=0)

rename ag_d48a1 no_days_men_harv 		// Harvesting wages
rename ag_d48b1 avg_dlywg_men_harv
rename ag_d48a2 no_days_women_harv
rename ag_d48b2 avg_dlywg_women_harv
rename ag_d48a3 no_days_chldrn_harv
rename ag_d48b3 avg_dlywg_chldrn_harv
recode no_days_men_harv avg_dlywg_men_harv no_days_women_harv avg_dlywg_women_harv no_days_chldrn_harv avg_dlywg_chldrn_harv (.=0)

gen tot_wg_men_nharv = no_days_men_nharv*avg_dlywg_men_nharv 			//wages: rainy season male non-harvest activities 
gen tot_wg_women_nharv = no_days_women_nharv*avg_dlywg_women_nharv 		//wages: rainy season female non-harvest activities
gen tot_wg_chldrn_nharv = no_days_chldrn_nharv*avg_dlywg_chldrn_nharv 	//wages: rainy season children non-harvest activities
gen tot_wg_men_harv = no_days_men_harv*avg_dlywg_men_harv 				//wages: rainy season male harvest activities 
gen tot_wg_women_harv = no_days_women_harv*avg_dlywg_women_harv 		//wages: rainy season female harvest activities
gen tot_wg_chldrn_harv = no_days_chldrn_harv*avg_dlywg_chldrn_harv 		//wages: rainy season children harvest activities

*TOTAL WAGES PAID IN RAINY SEASON (add them all up)
gen wages_paid_rainy = tot_wg_men_nharv + tot_wg_women_nharv + tot_wg_chldrn_nharv + tot_wg_men_harv + tot_wg_women_harv + tot_wg_chldrn_harv //VAP: This does not include in-kind payments, which are separate in Qs [D50-D53]. 
// I tried merging the hh_crop_prices.dta file to calculate value of in-kind(crop)payments, but ag_mod_13 is at the plot level, while hh_crop_prices.dta is at the hh-crop level.
//Same issue with MLW W4 AKS 8.30

*Monocropped plots - Rainy Season 
*renaming list of topcrops for hired labor. 
global topcropname_annual "maize rice pmill grdnt beans swtptt sunflr" //VAP: not including sorgum, cotton, pigpea, as 0 obsns for monocropping. Not sure if the following comment is applicable to Malawi: Labor for permanent crops is all recorded in the SRS 

foreach cn in $topcropname_annual {		
preserve

	gen dry=0							
	*disaggregate by gender of plot manager
	merge m:1 HHID plotid gardenid using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_plot_decision_makers.dta"	//Do not uniquely identify - see line 250 for issue. If I sue 1:, it work but otherwise m:1 does not. // TH 5.20.21 fixed

	foreach i in wages_paid_rainy{
		gen `i'_`cn' = `i'
		gen `i'_`cn'_male = `i' if dm_gender==1 
		gen `i'_`cn'_female = `i' if dm_gender==2 
		gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}

*Merge in monocropped plots
	merge 1:1 HHID gardenid plotid using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_`cn'_monocrop.dta", nogen keep(3)	//TH 5.20.18 deleted "assert (1 3)" command because 7 gardenid's start with "DG" instead of "RG" causing error//

	collapse (sum) wages_paid_rainy_`cn'*, by(HHID)		
	lab var wages_paid_rainy_`cn' "Wages for hired labor in rainy  season - Monocropped `cn' plots"
	foreach g in male female mixed {
		lab var wages_paid_rainy_`cn'_`g' "Wages for hired labor in rainy season - Monocropped `g' `cn' plots"
	}
	save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_wages_rainyseason_`cn'.dta", replace

restore
}

collapse (sum) wages_paid_rainy, by (HHID) 
lab var wages_paid_rainy "Wages paid for hired labor (crops) in rainyseason"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_wages_rainyseason.dta", replace  //TH 5.18.21 error msg “merge:  after merge, not all observations from master or matched(merged result left in memory)”


use "${MLW_W4_raw_data}/ag_mod_k.dta", clear 		// For dry season: All types of activities, no split between harvest and non-harvest like rainy. Check dta: survey says all activites but dta reads for all non-harvest acitivites.  
rename ag_k46a1 no_days_men_all
rename ag_k46b1 avg_dlywg_men_all
rename ag_k46a2 no_days_women_all
rename ag_k46b2 avg_dlywg_women_all
rename ag_k46a3 no_days_chldrn_all
rename ag_k46b3 avg_dlywg_chldrn_all
recode no_days_men_all avg_dlywg_men_all no_days_women_all avg_dlywg_women_all no_days_chldrn_all avg_dlywg_chldrn_all (.=0)

gen tot_wg_men_all = no_days_men_all*avg_dlywg_men_all 			//wages: dry season male
gen tot_wg_women_all = no_days_women_all*avg_dlywg_women_all 	//wages: dry season female 
gen tot_wg_chldrn_all = no_days_chldrn_all*avg_dlywg_chldrn_all //wages:  dry season children 

gen wages_paid_dry = tot_wg_men_all + tot_wg_women_all + tot_wg_chldrn_all //This does not include in-kind payments, which are separate in Qs. 
set trace on
*Monocropped plots- Dry Season
*renaming list of topcrops for hired labor. 
global topcropname_dry "maize rice beans swtptt sunflr"  
foreach cn in $topcropname_annual {		
preserve
	gen dry =1
	*disaggregate by gender of plot manager
	merge m:1 HHID plotid using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_plot_decision_makers.dta"
	foreach i in wages_paid_dry{
	gen `i'_`cn' = `i'
	gen `i'_`cn'_male = `i' if dm_gender==1 
	gen `i'_`cn'_female = `i' if dm_gender==2 
	gen `i'_`cn'_mixed = `i' if dm_gender==3 
	}
*Merge in monocropped plots
	merge m:1 HHID plotid dry using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_`cn'_monocrop.dta", nogen assert(1 3) keep(3)		//AKS help not merging due to lack of unique id but can't troubleshoot. 
	collapse (sum) wages_paid_dry_`cn'*, by(HHID)		
	lab var wages_paid_dry_`cn' "Wages for hired labor in rainy  season - Monocropped `cn' plots"
	foreach g in male female mixed {
		lab var wages_paid_dry_`cn'_`g' "Wages for hired labor in rainy season - Monocropped `g' `cn' plots"
	}
	save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_wages_dryseason_`cn'.dta", replace

restore
} 
collapse (sum) wages_paid_dry, by (HHID) 
lab var wages_paid_dry  "Wages paid for hired labor (crops) in rainyseason"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_wages_dryseason.dta", replace


*Expenses: Inputs
**Module D provides inputs such as fertilizer and pesticides with quantity amounts but no money value; do we want to include this quantity and calculate a value?
use "${MLW_W4_raw_data}/ag_mod_b2.dta", clear				//Rainy season
append using "${MLW_W4_raw_data}/ag_mod_i2.dta", gen(dry)	//Dry season

*formalized land rights
gen formal_land_rights = inrange(ag_b204_1,1,4) | inrange(ag_i204_1,1,4) //if any one has formal land rights in household

*individual level (for women)
replace ag_b204a__0 = ag_i204_2a_1 if ag_b204a__0==.		//If rainy season info is missing replace with dry season
replace ag_b204a__1 = ag_i204_2a_2 if ag_b204a__1==.
replace ag_b204a__2 = ag_i204_2a_3 if ag_b204a__2==.
replace ag_b204a__3 = ag_i204_2a_4 if ag_b204a__3==.

*Starting with first owner (out of four in this wave)
preserve
	ren ag_b204a_0 personid
	merge m:1 HHID personid using "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_gender_merge.dta", nogen keep(3)	//keep only matched 
		keep HHID personid female formal_land_rights 
		tempfile p1
		save `p1', replace
restore

*Now second owner
preserve	
	ren ag_b204a_1 personid
	merge m:1 HHID personid using "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_gender_merge.dta", nogen keep(3)	//keep only matched 
	keep HHID personid female formal_land_rights 
	append using `p1'
	tempfile p2
	save `p2', replace
restore

*Now third owner 
preserve	
	ren ag_b204a_2 personid
	merge m:1 HHID personid using "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_gender_merge.dta", nogen keep(3)	//keep only matched 
	keep HHID personid female formal_land_rights
	append using `p2'
	tempfile p3
	save `p3', replace
restore

*Now fourth owner
preserve	
	ren ag_b204a_3 personid
	merge m:1 HHID personid using "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_gender_merge.dta", nogen keep(3)	//keep only matched 
	keep HHID personid female formal_land_rights 
	append using `p3'
	gen formal_land_rights_f=formal_land_rights==1 if female==1			//formal land rights for females 
	collapse (max) formal_land_rights_f, by(HHID personid)				//taking max female land rights at HH and person level
	save "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_land_rights_ind.dta", replace 
restore

preserve
	collpase (max) formal_land_rights_hh=formal_land_rights, by(HHID)	//taking max land rights at household level; equals one if they have official documentation for at least one plot 
	save "${MLW_W4_created_data}/MLW_IHS_LSMS_ISA_W4_land_rights_hh.dta", replace
restore

*Fertilizer - has to be a sum of up-front payments and credit payments overtime; no absolute question asking about value of fertilizer. 
use "${MLW_W4_raw_data}/ag_mod_f.dta", clear
append using "${MLW_W4_raw_data}/ag_mod_l", gen(dry)	
gen value_fertilizer_1 = ag_f12 + ag_f13 if ag_f0c==0 					//Organic fertilizer value is a sum of upfront payments and purchases via credit
replace value_fertilizer_1 = ag_l12 + ag_l13 if value_fertilizer==. & ag_l0c==0				//If missing from rainy season, take from dry season

gen value_fertilizer_2 = ag_f12 + ag_f13 if inrange(ag_f0c,1,6)			//Non-organic fertilzier [Chitowe, DAP, CAN UREA, D Compound] 
replace value_fertilizer_2 = ag_l12 + ag_l13 if value_fertilizer==. & inrange(ag_l0c,1,6)	//If missing from rainy season, take from dry season

gen value_fertilizer= value_fertilizer_1 + value_fertilizer_2			//Combined organic and non-organic fertilizers
recode value_fertilizer (.=0)

gen value_herbicide = ag_f12 + ag_f13 if ag_f0c==8 | ag_f0c==9
replace value_herbicide = ag_l12 + ag_l13 if value_herbicide==. & ag_l0c==8 or ag_l0c==9
gen value_pesticide = ag_f12 + ag_f13 if ag_f0c==7 | ag_f0c==10
replace value_pesticide = ag_l12 + ag_l13 if value_pesticide==. & ag_l0c==7 | ag_l0c==10
recode value_herbicide value_pesticide (.=0)

*There is also an "other" category that can be either herbicide or pesticides
gen_value_herbicide_pesticide= ag_f12 + ag_f13 if ag_f0c==11
replace value_herbicide_pesticide= ag_f12 + ag_f12 if ag_f0c==. & ag_l0c==11
recode value_herbicide_pesticide (.=0)

/*Monocropped plots - AKS Cannot capture this info because fertilizer info does not offer plot level observations, only household level 
for each cn in $topcropname_area {
preserve
	*disaggreage by gender plot manager/decision
	merge m:1 HHID plotid using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_plot_decision_makers.dta"
	*Merge in monocropped plost
	merge m:1 HHID plotid using "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_`cn'_monocrop.dta", keep(3)
	for each i in value_fertilizer value_herbicide value_pesticide value_herbicide_pesticide {
	gen `i'_`cn' =`i'
	gen `i'_`cn'_male = `i' if dm_gender==1
	gen `i'_`cn'_female = `i' if dm_gender==2
	gen `i'_`cn'_mixed = `i' if dm_gender==3} 
}
	collapse (sum) value_fertilizer_`cn'* value_herbicide_`cn'* value_pesticide_`cn'* value_herbicide_pesticide_`cn'*, by(HHID)
	lab var value_fertilizer_`cn "Value of fertilizer purchased (not necessarily same as used) in rainy and dry growing seasons - Monocropped `cn' plots only"
	lab var value_herbicide_`cn	"Value of herbicide purchased (not necessarily used) in rainy and dry growing seasons - Monocropped `cn' plots only"
	lab var value_pesticide_`cn "Value of pesticide purchased (not necessarily used) in rainy and dry growing seasons - Monocropped `cn' plots only"
	lab var value_herbicide_pesticide_`cn "Value of herbicide and pesticide (not necessarily used) in rainy and dry growing seasons - Monocropped `cn' plots only"
	save "${Malawi_W4_created_data}/Malawi_IHS_W4_fertilizer_costs_`cn'.dta", replace																						//AKS note 10.8.19 - started reformatting saved files here
	restore
}
*/

*Questions in Malawi instrument ask "How much did you pay up front for ___ purchase" AND "How much did you repay/will you repay for __ purchase"; Combined I assume total value of input below
collapse (sum) value_fertilizer_`cn'* value_herbicide_`cn'* value_pesticide_`cn'* value_herbicide_pesticide_`cn'*, by(HHID)
lab var value_fertilizer_`cn "Value of fertilizer purchased (not necessarily same as used) in rainy and dry growing seasons - Monocropped `cn' plots only"
lab var value_herbicide_`cn	"Value of herbicide purchased (not necessarily used) in rainy and dry growing seasons - Monocropped `cn' plots only"
lab var value_pesticide_`cn "Value of pesticide purchased (not necessarily used) in rainy and dry growing seasons - Monocropped `cn' plots only"
lab var value_herbicide_pesticide_`cn "Value of herbicide and pesticide (not necessarily used) in rainy and dry growing seasons - Monocropped `cn' plots only"
save "{$Malawi_W4_created_data}/Malawi_IHS_W4_fertilizer_costs.dta", replace																						//AKS note 10.8.19 - started reformatting saved files here
	

*Seed 
use "${MLW_W4_raw_data}/AG_MOD_H.dta", clear
append using "${MLW_W4_raw_data}/AG_MOD_N.dta", gen(dry)
gen cost_seed = ag_h10  //Value of all seeds purchased WITHOUT coupons/vouchers, only with cash or credit 
replace cost_seed = ag_n10 if cost_seed==.
recode cost_seed (.=0)

/*Monocropped plots - AKS same as above; no plot level observations in seeds, only household level
foreach cn in$topcropname_annual {  
*seed costs for monocropped plots
	preserve	
	*disaggregate by gender of plot manager
	merge m:1 HHID plotid /*gardenid*/ using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_plot_decision_makers.dta"
	gen cost_seed_male = cost_seed if dm_gender==1
	gen cost_seed_female = cost_seed if dm_gender==2
	gen cost_seed_mixed=cost_seed if dm_gender==3
	*Merge in monocropped plots
	merge m:1 HHID plotid using "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_`cn'_monocrop.dta", nogen keep(3)
	collpase (sum) cost_seed_`cn' = cost_seed cost_seed_`cn'_male = cost_seed_male cost_seed_`cn'_female = cost_seed_female cost_seed_`cn'_mixed = cost_seed_mixed, by(HHID)
	lab var cost_seed_`cn' "Expenditures on seed for temporary crops - Monocropped `cn' plots only"
	save "${Malawi_IHS_W4_created_data}/Malawi_IHS_W4_seed_costs_`cn'.dta", replace
	restore
}
*/

*Land rental
use "${MLW_W4_raw_data}/AG_MOD_B2.dta", clear
append using "${MLW_W4_raw_data}/AG_MOD_I2.dta", gen(dry)
gen rental_cost_land_cshpd = ag_b209a 								//Cash payments
replace rental_cost_land_cshpd = ag_i209a if rental_cost_land==.		//replace with dry if missing
gen rental_cost_land_kindpd = ag_b209b								//In-kind payments
replace rental_cost_land_kindpd = ag_i209b if rental_cost_land_kindpd==.	//replace with dry if missing
gen rental_cost_land = rental_cost_land_cshpd + rental_cost_land_kindpd 	//COMBIND CASH AND IN-KIND
recode rental_cost_land (.=0)

*Monocropped plots AKS same as above; no plot level observations in land rental costs, only household and garden level so can try and merge. 
**Zero observations for pearl millets; to remove with next line
global tropcropname_land "maize rice sorgum pmill grdnt beans swtptt"
foreach cn in $topcropname_land {
	preserve
	*disaggreage by gender of plot manager
	merge m:1 HHID gardenid using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_plot_decision_makers.dta"
	*Merge in monocropped plots
	merge 1:1 HHID gardenid dry using "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_`cn'_monocrop.dta", keep(3)
	gen rental_cost_land_`cn' = rental_cost land
	gen rental_cost_land_`cn'_male = rental_cost_land if dm_gender==1
	gen rental_cost_land_`cn'_female = rental_cost_land if dm_gender==2
	gen rental_cost_land_`cn'_mixed = rental_cost_land if dm_gender==3
	collapse (sum) rental_cost_land_`cn'*, by(HHID)
	lab var rental_cost_land_`cn' "Rental costs paid for land - Monocropped `cn' plots only"
	save "${Malawi_IHS_W4_created_data}/Malawi_IHS_W4_land_rental_costs_`cn'.dta", replace 
	restore
}

collapse (sum) rental_cost_land, by (HHID)
lab var rental_cost_land "Rental costs paid for land"
save "${Malawi_IHS_W4_created_data}/Malawi_IHS_W4_land_rental_costs.dta", replace 

*Rental of agricultural tools, machines, animal traction
use "${MLW_W4_created_data}/HH_MOD_M.dta", clear
rename hh_m0b itemid
gen animal_traction = (itemid>=609 & itemid<=610) // MW4: Ox Plough, Ox Cart, same as MW1/2 // TZ: Ox Plough, Ox Cart, Ox Seed Planter
gen ag_asset = (itemid>=601 & itemid<= 608 | itemid>=613 & itemid <=625) 
// TZ: Hand Hoe, Hand powered Sprayer, SHELLER/THRESHER; HAND MILL/GRINDER; WATERING CAN; FARM BUILDINGS/STORAGE FACILITIES; 
// GERI CANS/DRUMS; POWER TILLER ; OTHER 
// MW4=MW1=MW2: Hand hoe, slasher, axe, sprayer, panga knife, sickle, treadle pump, watering can, ridger, cultivator, generator, motor pump, 
// grain mill, other, chicken house, livestock and poultry kraal, storage house, granary, barn, pig sty
gen tractor = (itemid>=611 & itemid<=612) //MW4=MW1=MW2: Tractor, Tractor Plough. // TZ: tractor, tractor plough, tractor harrow
rename hh_m14 rental_cost // VAP: Both MW2 and TZ: "how much did hh pay to rent or borrow [item] in last 12 months"
gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)

collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor, by (HHID)
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items" // VAP: Do we want to split ag_assets further into implements and storage for Malawi? 
lab var rental_cost_tractor "Costs for renting a tractor"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_asset_rental_costs.dta", replace


*Transport costs for crop sales 
use "${MLW_IHS_W4_raw_data}/AG_MOD_I.dta", clear	//rainy season
append using "${MLW)IHS_W4_raw_data}/ AG_MOD_O.dta"	//dry season
append using "${MLW_IHS_W4_raw_data}/AG_MOD_Q.dta"	//perm crops

ren ag_i10 transport_costs_cropsales1
replace transport_costs_cropsales1 = ag_o10 if transport_costs_cropsales==.	//TOT COST OF TRANSPORTATION FOR ALL CROP SALES IN RAINY/DRY
	ren ag_i18 transport_costs_cropsales2 			//tot cost of transporation associated with largest buyer - subset of above total
	replace transport_costs_cropsales2=ag_018 if transport_costs_cropsales1==.
	ren ag_i27 transport_costs_cropsales3			//tot cost of transporation associated with second largest buyer - subset of above total
	replace transport_costs_cropsales3=ag_027 if transport_costs_cropsales2==.
ren ag_q10 transport_costs_cropsales_perm1									//TOT COST OF TRANSPORTATION FOR ALL CROP SALES PERM
	ren ag_q18 transport_costs_cropsales_perm2		//tot cost for perm crops, largest buyer - subset of above total
	ren ag_q26 transport_costs_cropsales_perm3		//tot cost for perm crops, second largest buyer	- subset of above total

gen transport_costs_cropsales=transport_costs_cropsales1+transport_costs_cropsales_perm1	//Total transporation costs for crop sales in rainy/dry seasons and for permanent crops
collpase (sum) transport_costs_cropsales, by (HHID)
save "${Malawi_W4_created_data}/Malawi_IHS_W4_transportation_cropsales.dta", replace

*Crop costs
use "${Malawi_IHS_W4_created_data}/Malawi_IHS_W4_land_rental_costs.dta", clear
merge 1:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_wages_rainyseason.dta", nogen
merge 1:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_wages_dryseason.dta", nogen
merge 1:1 HHID using "${Malawi_W4_created_data}/Malawi_IHS_W4_transportation_cropsales.dta", nogen
merge 1:! HHID using "{$Malawi_W4_created_data}/Malawi_IHS_W4_fertilizer_costs.dta", nogen
recode rental_cost_land cost_seed value_fertilizer value_herbicide value_pesticide wages_paid_rainy /*
*/ wages_paid_dry transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_land cost_seed value_fertilizer value_herbicide /* 
*/ value_pesticide wages_paid_dry wages_paid_rainy transport_costs_cropsales)
lab var crop_production_expenses "Total crop production expenses"
save "${Malawi_IHS_W4_created_data}Malawi_IHS_LSMS_ISA_W4_crop_income.dta", replace


*****************
*LIVESTOCK INCOME - RH complete 7/29 - not checked
*****************
*Expenses - RH complete 7/20
//can't do disaggregated expenses (no lrum or animal expenses)

use "${MLW_W4_raw_data}\ag_mod_r2.dta", clear
rename ag_r26 cost_fodder_livestock       /* VAP: MW2 has no separate cost_water_livestock - same with W4*/
rename ag_r27 cost_vaccines_livestock     /* Includes medicines */
rename ag_r28 cost_othervet_livestock     /* VAP: TZ didn't have this. Includes dipping, deworming, AI */
gen cost_medical_livestock = cost_vaccines_livestock + cost_othervet_livestock /* VAP: Combining the two categories for later. */
rename ag_r25 cost_hired_labor_livestock 
rename ag_r29 cost_input_livestock        /* VAP: TZ didn't have this. Includes housing equipment, feeding utensils */
recode cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_medical_livestock cost_hired_labor_livestock cost_input_livestock(.=0)

collapse (sum) cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock  cost_hired_labor_livestock cost_input_livestock, by (HHID)
lab var cost_fodder_livestock "Cost for fodder for <livestock>"
lab var cost_vaccines_livestock "Cost for vaccines and veterinary treatment for <livestock>"
lab var cost_othervet_livestock "Cost for other veterinary treatments for <livestock> (incl. dipping, deworming, AI)"
*lab var cost_medical_livestock "Cost for all veterinary services (total vaccine plus othervet)"
lab var cost_hired_labor_livestock "Cost for hired labor for <livestock>"
lab var cost_input_livestock "Cost for livestock inputs (incl. housing, equipment, feeding utensils)"
save "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_livestock_expenses.dta", replace

*Livestock products 
* Milk - RH complete 7/21 (question)
use "${MLW_W4_raw_data}\ag_mod_s.dta", clear
rename ag_s0a livestock_code
keep if livestock_code==401
rename ag_s02 no_of_months_milk // VAP: During the last 12 months, for how many months did your household produce any [PRODUCT]?
rename ag_s03a qty_milk_per_month // VAP: During these months, what was the average quantity of [PRODUCT] produced PER MONTH?. 
gen milk_liters_produced = no_of_months_milk * qty_milk_per_month if ag_s03b==1 // VAP: Only including liters, not including 2 obsns in "buckets". 
lab var milk_liters_produced "Liters of milk produced in past 12 months"

gen liters_sold_12m = ag_s05a if ag_s05b==1 // VAP: Keeping only units in liters
rename ag_s06 earnings_milk_year
gen price_per_liter = earnings_milk_year/liters_sold_12m if liters_sold_12m > 0
gen price_per_unit = price_per_liter // RH: why do we need per liter and per unit if the same?
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) //RH Question: is turning 0s to missing on purpose? Or is this backwards? 
keep HHID livestock_code milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_milk_year //why do we need both per liter and per unit if the same?
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold" 
lab var quantity_produced "Quantity of milk produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_milk", replace

* Other livestock products  // VAP: Includes milk, eggs, meat, hides/skins and manure. No honey in MW2. TZ does not have meat and manure. - RH complete 7/29
use "${MLW_W4_raw_data}\AG_MOD_S.dta", clear
rename ag_s0a livestock_code
rename ag_s02 months_produced
rename ag_s03a quantity_month
rename ag_s03b quantity_month_unit

drop if livestock_code == 401 //RH edit. Removing milk from "other" dta, will be added back in for all livestock products file
replace quantity_month = round(quantity_month/0.06) if livestock_code==402 & quantity_month_unit==2 // VAP: converting obsns in kgs to pieces for eggs 
// using MW IHS Food Conversion factors.pdf. Cannot convert ox-cart & ltrs. 
replace quantity_month_unit = 3 if livestock_code== 402 & quantity_month_unit==2
replace quantity_month_unit =. if livestock_code==402 & quantity_month_unit!=3        // VAP: chicken eggs, pieces
replace quantity_month_unit =. if livestock_code== 403 & quantity_month_unit!=3      // guinea fowl eggs, pieces
replace quantity_month = quantity_month*1.5 if livestock_code==404 & quantity_month_unit==3 // VAP: converting pieces to kgs for meat, 
// using conversion for chicken. Cannot convert ltrs & buckets.  
replace quantity_month_unit = 2 if livestock_code== 404 & quantity_month_unit==3
replace quantity_month_unit =. if livestock_code==404 & quantity_month_unit!=2     // VAP: now, only keeping kgs for meat
replace quantity_month_unit =. if livestock_code== 406 & quantity_month_unit!=3   // VAP: skin and hide, pieces. Not converting kg and bucket.
replace quantity_month_unit =. if livestock_code== 407 & quantity_month_unit!=2 // VAP: manure, using only obsns in kgs. 
// This is a bigger problem, as there are many obsns in bucket, wheelbarrow & ox-cart but no conversion factors.
recode months_produced quantity_month (.=0) 
gen quantity_produced = months_produced * quantity_month // Units are liters for milk, pieces for eggs & skin, kg for meat and manure. 
lab var quantity_produced "Quantity of this product produced in past year"

rename ag_s05a sales_quantity
rename ag_s05b sales_unit
*replace sales_unit =. if livestock_code==401 & sales_unit!=1 // milk, liters only
replace sales_unit =. if livestock_code==402 & sales_unit!=3  // chicken eggs, pieces only
replace sales_unit =. if livestock_code== 403 & sales_unit!=3   // guinea fowl eggs, pieces only
replace sales_quantity = sales_quantity*1.5 if livestock_code==404 & sales_unit==3 // VAP: converting obsns in pieces to kgs for meat. Using conversion for chicken. 
replace sales_unit = 2 if livestock_code== 404 & sales_unit==3 // VAP: kgs for meat
replace sales_unit =. if livestock_code== 406 & sales_unit!=3   // VAP: pieces for skin and hide, not converting kg.
replace sales_unit =. if livestock_code== 407 & quantity_month_unit!=2  // VAP: kgs for manure, not converting liters(1 obsn), bucket, wheelbarrow & oxcart

rename ag_s06 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep HHID livestock_code quantity_produced price_per_unit earnings_sales

label define livestock_code_label 402 "Chicken Eggs" 403 "Guinea Fowl Eggs" 404 "Meat" 406 "Skin/Hide" 407 "Manure" 408 "Other" //RH - added "other" lbl to 408, removed 401 "Milk"
label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price per unit sold"
lab var price_per_unit_hh "Price per unit sold at household level"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_other", replace

*All Livestock Products
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_milk", clear
append using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_other"
recode price_per_unit (0=.)
merge m:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta" //no stratum in hhids
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
lab var price_per_unit "Price per unit sold"
lab var quantity_produced "Quantity of product produced"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products", replace

* EA Level
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district TA ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district TA ea livestock_code obs_ea)
rename price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_prices_ea.dta", replace

* TA Level
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district TA livestock_code: egen obs_TA = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district TA livestock_code obs_TA)
rename price_per_unit price_median_TA
lab var price_median_TA "Median price per unit for this livestock product in the TA"
lab var obs_TA "Number of sales observations for this livestock product in the TA"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_prices_TA.dta", replace 

* District Level
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
rename price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_prices_district.dta", replace

* Region Level
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_prices_region.dta", replace

* Country Level
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_prices_country.dta", replace

use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products", clear
merge m:1 region district TA ea livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_prices_ea.dta", nogen
merge m:1 region district TA livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_prices_TA.dta", nogen
merge m:1 region district livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_TA if price_per_unit==. & obs_TA >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values" 

gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==402|livestock_code==403
gen value_other_produced = quantity_produced * price_per_unit if livestock_code== 404|livestock_code==406|livestock_code==407|livestock_code==408
egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		
collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (HHID)

*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
lab var value_livestock_products "value of livestock prodcuts produced (milk, eggs, other)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of skins, meat and manure produced"
recode value_milk_produced value_eggs_produced value_other_produced (0=.)
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_livestock_products", replace

* Manure (Dung in TZ)
use "${MLW_W4_raw_data}\AG_MOD_S.dta", clear
rename ag_s0a livestock_code
rename ag_s06 earnings_sales
gen sales_manure=earnings_sales if livestock_code==407 
recode sales_manure (.=0)
collapse (sum) sales_manure, by (HHID)
lab var sales_manure "Value of manure sold" 
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_manure.dta", replace 

*Sales (live animals) //w4 has no slaughter questions
use "${MLW_W4_raw_data}\ag_mod_r1.dta", clear
rename ag_r0a livestock_code
rename ag_r17 income_live_sales     // total value of sales of [livestock] live animals last 12m -- RH note, w3 label doesn't include "during last 12m"
rename ag_r16 number_sold          // # animals sold alive last 12 m
*rename ag_r19 number_slaughtered  // # animals slaughtered last 12 m - Not available in w4
/* VAP: not available in MW2 or w3 - no slaughter questions in w4
rename lf02_32 number_slaughtered_sold  // # of slaughtered animals sold
replace number_slaughtered = number_slaughtered_sold if number_slaughtered < number_slaughtered_sold  
rename lf02_33 income_slaughtered // # total value of sales of slaughtered animals last 12m
*/
rename ag_r11 value_livestock_purchases // tot. value of purchase of live animals last 12m
recode income_live_sales number_sold /*number_slaughtered*/ /*number_slaughtered_sold income_slaughtered*/ value_livestock_purchases (.=0)
gen price_per_animal = income_live_sales / number_sold
lab var price_per_animal "Price of live animals sold"
recode price_per_animal (0=.) 
merge m:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
keep HHID weight region district TA ea livestock_code number_sold income_live_sales /*number_slaughtered*/ /*number_slaughtered_sold income_slaughtered*/ price_per_animal value_livestock_purchases
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_livestock_sales", replace // RH complete - no slaughter questions in w4
 
*Implicit prices  // VAP: MW2, w3, w4 do not have value of slaughtered livestock
		
* EA Level
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district TA ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district TA ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_ea.dta", replace 

* TA Level
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district TA livestock_code: egen obs_TA = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district TA livestock_code obs_TA)
rename price_per_animal price_median_TA
lab var price_median_TA "Median price per unit for this livestock in the TA"
lab var obs_TA "Number of sales observations for this livestock in the TA"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_TA.dta", replace 

* District Level
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
rename price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_district.dta", replace

* Region Level
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_region.dta", replace

* Country Level
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_country.dta", replace //RH note - check TA code? different from ws 2 & 3

use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_livestock_sales", clear
merge m:1 region district TA ea livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_ea.dta", nogen
merge m:1 region district TA livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_TA.dta", nogen
merge m:1 region district livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_TA if price_per_animal==. & obs_TA >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
*gen value_slaughtered = price_per_animal * number_slaughtered //RH: no slaughter questions in w4
{
/* VAP: Not available for MW2, w3, w4
gen value_slaughtered_sold = price_per_animal * number_slaughtered_sold 
*gen value_slaughtered_sold = income_slaughtered 
replace value_slaughtered_sold = income_slaughtered if (value_slaughtered_sold < income_slaughtered) & number_slaughtered!=0 /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
replace value_slaughtered = value_slaughtered_sold if (value_slaughtered_sold > value_slaughtered) & (number_slaughtered > number_slaughtered_sold) //replace value of slaughtered with value of slaughtered sold if value sold is larger
*gen value_livestock_sales = value_lvstck_sold  + value_slaughtered_sold 
*/
}

collapse (sum) /*value_livestock_sales*/ value_livestock_purchases value_lvstck_sold /*value_slaughtered*/, by (HHID)
drop if HHID==""
*lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
lab var value_livestock_purchases "Value of livestock purchases"
*lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_sales", replace //RH complete

*TLU (Tropical Livestock Units)
use "${MLW_W4_raw_data}\ag_mod_r1.dta", clear
rename ag_r0a livestock_code 
gen tlu_coefficient=0.5 if (livestock_code==301|livestock_code==302|livestock_code==303|livestock_code==304|livestock_code==3304) // calf, steer/heifer, cow, bull, ox
replace tlu_coefficient=0.1 if (livestock_code==307|livestock_code==308) //goats, sheep
replace tlu_coefficient=0.2 if (livestock_code==309) // pigs
replace tlu_coefficient=0.01 if (livestock_code==311|livestock_code==313|livestock_code==315|livestock_code==319|livestock_code==3310|livestock_code==3314) // local hen, cock, duck, dove/pigeon, chicken layer/broiler, turkey/guinea fowl
replace tlu_coefficient=0.3 if (livestock_code==3305) // donkey/mule/horse
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

rename ag_r07 number_1yearago
rename ag_r02 number_today_total
rename ag_r03 number_today_exotic
gen number_today_indigenous = number_today_total - number_today_exotic
recode number_today_total number_today_indigenous number_today_exotic (.=0)
*gen number_today = number_today_indigenous + number_today_exotic // already exists (number_today_total)
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today_total * tlu_coefficient
rename ag_r17 income_live_sales 
rename ag_r16 number_sold

rename ag_r21b lost_disease // VAP: Includes lost to injury in MW2
*rename lf02_22 lost_injury 
rename ag_r19 lost_stolen // # of livestock lost or stolen in last 12m
egen mean_12months = rowmean(number_today_total number_1yearago)
egen animals_lost12months = rowtotal(lost_disease lost_stolen)	
gen share_imp_herd_cows = number_today_exotic/(number_today_total) if livestock_code==303 // VAP: only cows, not including calves, steer/heifer, ox and bull
gen species = (inlist(livestock_code,301,302,202,204,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code,311,313,315,319,3310,3314))
recode species (0=.)
la def species 1 "Large ruminants (calves, steer/heifer, cows, bulls, oxen)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys, mules)" 5 "Poultry"
la val species species

preserve
	*Now to household level
	*First, generating these values by species
	collapse (firstnm) share_imp_herd_cows (sum) number_today_total number_1yearago animals_lost12months lost_disease /*ihs*/ number_today_exotic lvstck_holding=number_today_total, by(HHID species)
	egen mean_12months = rowmean(number_today_total number_1yearago)
	gen any_imp_herd = number_today_exotic!=0 if number_today_total!=. & number_today_total!=0
	
foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding lost_disease /*ihs*/{
		gen `i'_lrum = `i' if species==1
		gen `i'_srum = `i' if species==2
		gen `i'_pigs = `i' if species==3
		gen `i'_equine = `i' if species==4
		gen `i'_poultry = `i' if species==5
	}
	*Now we can collapse to household (taking firstnm because these variables are only defined once per household)
	collapse (sum) number_today_total number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(HHID)
	*Overall any improved herd
	gen any_imp_herd = number_today_exotic!=0 if number_today_total!=0
	drop number_today_exotic number_today_total
	
	foreach i in lvstck_holding animals_lost12months mean_12months lost_disease /*ihs*/{
		gen `i' = .
	}
	la var lvstck_holding "Total number of livestock holdings (# of animals)"
	la var any_imp_herd "At least one improved animal in herd"
	la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
	lab var animals_lost12months  "Total number of livestock  lost in last 12 months"
	lab var  mean_12months  "Average number of livestock  today and 1  year ago"
	lab var lost_disease "Total number of livestock lost to disease or injury" //ihs
	
	foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months lost_disease /*ihs*/{
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}	
	la var any_imp_herd "At least one improved animal in herd - all animals" 
	*Now dropping these missing variables, which I only used to construct the labels above
	
	*Total livestock holding for large ruminants, small ruminants, and poultry
	gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
	la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
	
	*any improved large ruminants, small ruminants, or poultry
	gen any_imp_herd_all = 0 if any_imp_herd_lrum==0 | any_imp_herd_srum==0 | any_imp_herd_poultry==0
	replace any_imp_herd_all = 1 if  any_imp_herd_lrum==1 | any_imp_herd_srum==1 | any_imp_herd_poultry==1
	lab var any_imp_herd_all "1=hh has any improved lrum, srum, or poultry"
	
	recode lvstck_holding* (.=0)
	drop lvstck_holding animals_lost12months mean_12months lost_disease /*ihs*/
	save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_herd_characteristics", replace
restore
	
gen price_per_animal = income_live_sales / number_sold
merge m:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region district TA ea livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_ea.dta", nogen
merge m:1 region district TA livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_TA.dta", nogen
merge m:1 region district livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_prices_country.dta", nogen		
recode price_per_animal (0=.)
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_TA if price_per_animal==. & obs_TA >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today_total * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (HHID)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if HHID==""
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_TLU.dta", replace

*Livestock income
use "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_sales", clear
merge 1:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_livestock_products", nogen
merge 1:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_manure.dta", nogen
merge 1:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_expenses", nogen
merge 1:1 HHID using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_TLU.dta", nogen

gen livestock_income = value_lvstck_sold + /*value_slaughtered*/ - value_livestock_purchases /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_manure) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_othervet_livestock + cost_input_livestock)

lab var livestock_income "Net livestock income"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_livestock_income", replace

************
*FISH INCOME - not on grouping sheet?
************

************
*SELF-EMPLOYMENT INCOME
************

************
*NON-AG WAGE INCOME - RH complete 8/2 - not checked
************
use "${MLW_W4_raw_data}\HH_MOD_E.dta", clear
rename hh_e06_4 wage_yesno // MW2: In last 12m,  work as an employee for a wage, salary, commission, or any payment in kind: incl. paid apprenticeship, domestic work or paid farm work, excluding ganyu
rename hh_e22 number_months  //MW2:# of months worked at main wage job in last 12m. 
rename hh_e23 number_weeks  // MW2:# of weeks/month worked at main wage job in last 12m. 
rename hh_e24 number_hours  // MW2:# of hours/week worked at main wage job in last 12m. 
rename hh_e25 most_recent_payment // amount of last payment
replace most_recent_payment=. if inlist(hh_e19b,62 63 64) // VAP: main wage job 
**** 
* VAP: For MW2, above codes are in .dta. 62:Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers   
* For TZ: TASCO codes from TZ Basic Info Document http://siteresources.worldbank.org/INTLSMS/Resources/3358986-1233781970982/5800988-1286190918867/TZNPS_2014_2015_BID_06_27_2017.pdf
	* 921: Agricultural, Forestry, and Fishery Labourers
	* 611: Farmers and Crop Skilled Workers
	* 612: Animal Producers and Skilled Workers
	* 613: Forestry and Related Skilled Workers
	* 614: Fishery Workers, Hunters, and Trappers
	* 621: Subsistence Agricultural, Forestry, Fishery, and Related Workers
***
rename hh_e26b payment_period // What period of time did this payment cover?
rename hh_e27 most_recent_payment_other // What is the value of those (apart from salary) payments? 
replace most_recent_payment_other =. if inlist(hh_e19b,62,63,64) // code of main wage job 
rename hh_e28b payment_period_other // Over what time interval?
rename hh_e32 secondary_wage_yesno // In last 12m, employment in second wage job outside own hh, incl. casual/part-time labour, for a wage, salary, commission or any payment in kind, excluding ganyu
rename hh_e39 secwage_most_recent_payment // amount of last payment
replace secwage_most_recent_payment = . if hh_e33_code== 62 // code of secondary wage job; 
rename hh_e40b secwage_payment_period // What period of time did this payment cover?
rename hh_e41 secwage_recent_payment_other //  value of in-kind payments
rename hh_e42b secwage_payment_period_other // Over what time interval?
rename hh_e38_1 secwage_hours_pastweek // In the last 7 days, how many hours did you work in this job?
gen annual_salary_cash=.
replace annual_salary_cash = (number_months*most_recent_payment) if payment_period==5  // month
replace annual_salary_cash = (number_months*number_weeks*most_recent_payment) if payment_period== 4 // week
replace annual_salary_cash = (number_months*number_weeks*(number_hours/8)*most_recent_payment) if payment_period==3  // day
gen wage_salary_other=.
replace wage_salary_other = (number_months*most_recent_payment_other) if payment_period_other==5 // month
replace wage_salary_other = (number_months*number_weeks*most_recent_payment_other) if payment_period_other==4 //week
replace wage_salary_other = (number_months*number_weeks*(number_hours/8)*most_recent_payment_other) if payment_period_other==3 //day
recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
tab secwage_payment_period
collapse (sum) annual_salary, by (HHID)
lab var annual_salary "Annual earnings from non-agricultural wage"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_wage_income.dta", replace


************
*AG WAGE INCOME - RH IP
************
use "${MLW_W4_raw_data}\HH_MOD_E.dta", clear
rename hh_e06_4 wage_yesno // MW3: last 12m,  work as an employee for a wage, salary, commission, or any payment in kind: incl. paid apprenticeship, domestic work or paid farm work, excluding ganyu
* TZ: last 12m, work as an unpaid apprentice OR employee for a wage, salary, commission or any payment in kind; incl. paid apprenticeship, domestic work or paid farm work 
rename hh_e22 number_months  //MW2:# of months worked at main wage job in last 12m. TZ: During the last 12 months, for how many months did [NAME] work in this job?
rename hh_e23 number_weeks  // MW2:# of weeks/month worked at main wage job in last 12m. TZ: During the last 12 months, how many weeks per month did [NAME] usually work in this job?
rename hh_e24 number_hours  // MW2:# of hours/week worked at main wage job in last 12m. TZ: During the last 12 months, how many hours per week did [NAME] usually work in this job?
rename hh_e25 most_recent_payment // amount of last payment

gen agwage = 1 if inlist(hh_e19b,62,63,64) // 62: Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers - RH note: occupation codes not in dta file for w3, see BID "Occupation Codes", pg 36

gen secagwage = 1 if inlist(hh_e33_code, 62,63,64) // 62: Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers - RH note: occupation codes not in dta file for w3, see BID "Occupation Codes", pg 36

*gen secagwage = 1 if hh_e33_code==62 //62: Agriculture and animal husbandry worker // double check this. Do we actually only want animal husbandry? - VAP code, RH changed to match secagwage codes to agwage codes.

replace most_recent_payment = . if agwage!=1
rename hh_e26b payment_period // What period of time did this payment cover?
rename hh_e27 most_recent_payment_other // What is the value of those (apart from salary) payments? 
replace most_recent_payment_other =. if agwage!=1 
rename hh_e28b payment_period_other // Over what time interval?
rename hh_e32 secondary_wage_yesno // In last 12m, employment in second wage job outside own hh, incl. casual/part-time labour, for a wage, salary, commission or any payment in kind, excluding ganyu
rename hh_e39 secwage_most_recent_payment // amount of last payment
replace secwage_most_recent_payment = . if secagwage!=1  // code of secondary wage job
rename hh_e40b secwage_payment_period // What period of time did this payment cover?
rename hh_e41 secwage_recent_payment_other //  value of in-kind payments
rename hh_e42b secwage_payment_period_other // Over what time interval?
rename hh_e38_1 secwage_hours_pastweek // In the last 7 days, how many hours did you work in this job?

gen annual_salary_cash=.
replace annual_salary_cash = (number_months*most_recent_payment) if payment_period==5  // month
replace annual_salary_cash = (number_months*number_weeks*most_recent_payment) if payment_period== 4 // week
replace annual_salary_cash = (number_months*number_weeks*(number_hours/8)*most_recent_payment) if payment_period==3  // day
gen wage_salary_other=.
replace wage_salary_other = (number_months*most_recent_payment_other) if payment_period_other==5 // month
replace wage_salary_other = (number_months*number_weeks*most_recent_payment_other) if payment_period_other==4 //week
replace wage_salary_other = (number_months*number_weeks*(number_hours/8)*most_recent_payment_other) if payment_period_other==3 //day
recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse (sum) annual_salary, by (HHID)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_agwage_income.dta", replace  // 0 annual earnings, 3907 obsns

************
*OTHER INCOME
************
	
***************
*VACCINE USAGE - RH complete 8/3, rerun after confirming gender_merge
***************
use "${MLW_W4_raw_data}\ag_mod_r1.dta", clear
gen vac_animal=ag_r22>0
* MW4: How many of your[Livestock] are currently vaccinated? 
* TZ: Did you vaccinate your[ANIMAL] in the past 12 months? 
replace vac_animal = 0 if ag_r22==0  
replace vac_animal = . if ag_r22==. // VAP: 4092 observations on a hh-animal level

*Disagregating vaccine usage by animal type 
rename ag_r0a livestock_code
gen species = (inlist(livestock_code, 301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code, 311,313,315,319,3310,3314))
recode species (0=.)
la def species 1 "Large ruminants (calf, steer/heifer, cow, bull, ox)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species


*A loop to create species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}

collapse (max) vac_animal*, by (HHID)
// VAP: After collapsing, the data is on hh level, vac_animal now has only 1883 observations
lab var vac_animal "1=Household has an animal vaccinated"
	foreach i in vac_animal {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_vaccine.dta", replace

 
*vaccine use livestock keeper  
use "${MLW_W4_raw_data}\ag_mod_r1.dta", clear
gen all_vac_animal=ag_r22>0
* MW4: How many of your[Livestock] are currently vaccinated? 
* TZ: Did you vaccinate your[ANIMAL] in the past 12 months? 
replace all_vac_animal = 0 if ag_r22==0  
replace all_vac_animal = . if ag_r22==. // VAP: 4092 observations on a hh-animal level
keep HHID ag_r06a ag_r06b all_vac_animal

ren ag_r06a farmerid1
ren ag_r06b farmerid2
gen t=1
gen patid=sum(t)
reshape long farmerid, i(patid) j(idnum)
drop t patid

collapse (max) all_vac_animal , by(HHID farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 HHID personid using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_gender_merge.dta", nogen //RH NOTE: not yet created, run code after gender_merge
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
ren personid indidy4 //renamed from indidy3
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_farmer_vaccine.dta", replace	

***************
*ANIMAL HEALTH - DISEASES - RH IP
***************
		
***************
*LIVESTOCK WATER, FEEDING, AND HOUSING - Cannot replicate for MWI
***************
/* Cannot replicate this section as MW2 Qs. does not ask about livestock water, feeding, housing. */


***************
*USE OF INORGANIC FERTILIZER - RH complete 8/6/21
***************
use "${MLW_W4_raw_data}/AG_MOD_D.dta", clear
append using "${MLW_W4_raw_data}/AG_MOD_K.dta" 
gen all_use_inorg_fert=.
replace all_use_inorg_fert=0 if ag_d38==2| ag_k39==2
replace all_use_inorg_fert=1 if ag_d38==1| ag_k39==1
recode all_use_inorg_fert (.=0)
lab var all_use_inorg_fert "1 = Household uses inorganic fertilizer"

keep HHID ag_d01 ag_d01_2a ag_d01_2b ag_k02 ag_k02_2a ag_k02_2b all_use_inorg_fert
ren ag_d01 farmerid1
replace farmerid1= ag_k02 if farmerid1==.
ren ag_d01_2a farmerid2
replace farmerid2= ag_k02_2a if farmerid2==.
ren ag_d01_2b farmerid3
replace farmerid2= ag_k02_2b if farmerid3==.	

//reshape long
gen t = 1
gen patid = sum(t)

reshape long farmerid, i(patid) j(decisionmakerid)
drop t patid

collapse (max) all_use_inorg_fert , by(HHID farmerid)
gen personid=farmerid
drop if personid==.
merge 1:1 HHID personid using "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_gender_merge.dta", nogen

lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
ren personid indidy4
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Individual is listed as a manager for at least one plot" 
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_farmer_fert_use.dta", replace		

*********************
*USE OF IMPROVED SEED - VAP: cannot be replicated       
*********************
/* VAP: Cannot replicate for MWI w2. Seed type is not broken down into improved and traditional in MW2. */

*********************
*REACHED BY AG EXTENSION - RH complete 8/26/21, not checked  
*********************
use "${MLW_W4_raw_data}/AG_MOD_T1.dta", clear
ren ag_t01 receive_advice
ren ag_t02 sourceids

**Government Extension
gen advice_gov = (sourceid==1|sourceid==3 & receive_advice==1) // govt ag extension & govt. fishery extension. 
**NGO
gen advice_ngo = (sourceid==4 & receive_advice==1)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==5 & receive_advice==1) // ag coop/farmers association
**Large Scale Farmer
gen advice_farmer =(sourceid== 10 & receive_advice==1) // lead farmers
**Radio/TV
gen advice_electronicmedia = (sourceid==12|sourceid==15|sourceid==16 & receive_advice==1) // electronic media:Radio -- MWI w4 has additional electronic media sources (phone/SMS, other electronic media (TV,etc))
**Publication
gen advice_pub = (sourceid==13 & receive_advice==1) // handouts, flyers
**Neighbor
gen advice_neigh = (sourceid==11 & receive_advice==1) // Other farmers: neighbors, relatives
** Farmer Field Days
gen advice_ffd = (sourceid==7 & receive_advice==1)
** Village Ag Extension Meeting
gen advice_village = (sourceid==8 & receive_advice==1)
** Ag Ext. Course
gen advice_course= (sourceid==9 & receive_advice==1)
** Private Ag. Extension 
gen advice_pvt= (sourceid==2 & receive_advice==1)
**Other
gen advice_other = (sourceid== 14 & receive_advice==1)

**advice on prices from extension
*Five new variables  ext_reach_all, ext_reach_public, ext_reach_private, ext_reach_unspecified, ext_reach_ict  // QUESTION - ffd and course in unspecified?
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_pvt) //advice_pvt new addition
gen ext_reach_unspecified=(advice_neigh==1 | advice_pub==1 | advice_other==1 | advice_farmer==1 | advice_ffd==1 | advice_course==1 | advice_village==1) //RH - Re: VAP's check request - Farmer field days and courses incl. here - seems correct since we don't know who put those on, but flagging
gen ext_reach_ict=(advice_electronicmedia==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1 | ext_reach_ict==1)

collapse (max) ext_reach_* , by (HHID)
lab var ext_reach_all "1 = Household reached by extension services - all sources"
lab var ext_reach_public "1 = Household reached by extension services - public sources"
lab var ext_reach_private "1 = Household reached by extension services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extension services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extension services through ICT"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_any_ext.dta", replace

********************************************************************************
* MOBILE OWNERSHIP * //RH complete 8/26/21 - not checked
********************************************************************************
//Added based on TZA w5 code

use "${MLW_W4_raw_data}\HH_MOD_F.dta", clear
//recode missing to 0 in hh_g301 (0 mobile owned if missing)
recode hh_f34 (.=0)
ren hh_f34 hh_number_mobile_owned
*recode hh_number_mobile_owned (.=0) 
gen mobile_owned = 1 if hh_number_mobile_owned>0 
recode mobile_owned (.=0) // recode missing to 0
collapse (max) mobile_owned, by(HHID)
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_mobile_own.dta", replace 
 	
*********************
*USE OF FORMAL FINANCIAL SERVICES - RH complete 8/10/21, not checked
*********************
use "${MLW_W4_raw_data}\HH_MOD_F.dta", clear
append using "${MLW_W4_raw_data}\HH_MOD_S1.dta"
gen borrow_bank= hh_s04==10 // VAP: Code source of loan. No microfinance or mortgage loan in Malawi W2 unlike TZ. 
gen borrow_relative=hh_s04==1|hh_s04==12 //RH Check request: w3 has village bank [12]. Confirm including under "Borrow_bank"?
gen borrow_moneylender=hh_s04==4 // NA in TZ
gen borrow_grocer=hh_s04==3 // local grocery/merchant
gen borrow_relig=hh_s04==6 // religious institution
gen borrow_other_fin=hh_s04==7|hh_s04==8|hh_s04==9 // VAP: MARDEF, MRFC, SACCO
gen borrow_neigh=hh_s04==2
gen borrow_employer=hh_s04==5
gen borrow_ngo=hh_s04==11
gen borrow_other=hh_s04==13

gen use_bank_acount=hh_f52==1
// VAP: No MM for MWI.  
// gen use_MM=hh_q01_1==1 | hh_q01_2==1 | hh_q01_3==1 | hh_q01_4==1 // use any MM services - MPESA ZPESA AIRTEL TIGO PESA. 
gen use_fin_serv_bank = use_bank_acount==1
gen use_fin_serv_credit= borrow_bank==1  | borrow_other_fin==1 // VAP: Include religious institution in this definition? No mortgage.  
// VAP: No digital and insurance in MWI
// gen use_fin_serv_insur= borrow_insurance==1
// gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= borrow_other_fin==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 |  use_fin_serv_others==1 /*use_fin_serv_insur==1 | use_fin_serv_digital==1 */ 
recode use_fin_serv* (.=0)

collapse (max) use_fin_serv_*, by (HHID)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank account"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
// lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
// lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_fin_serv.dta", replace	

************
*MILK PRODUCTIVITY - RH complete 8/10/21 - not checked
************
//RH: only cow milk in MWI, not including large ruminant variables

*Total production
use "${MLW_W4_raw_data}\AG_MOD_S.dta", clear
rename ag_s0a product_code
keep if product_code==401
rename ag_s02 months_milked // VAP: During the last 12 months, for how many months did your household produce any [PRODUCT]? (rh edited)
rename ag_s03a liters_month // VAP: During these months, what was the average quantity of [PRODUCT] produced PER MONTH?. (RH renamed to be more consistent with TZA (from qty_milk_per_month to liters_month))
gen milk_liters_produced = months_milked * liters_month if ag_s03b==1 // VAP: Only including liters, not including 2 obsns in "buckets". 
lab var milk_liters_produced "Liters of milk produced in past 12 months"

* lab var milk_animals "Number of large ruminants that was milk (household)": Not available in MW2 (only cow milk) 
lab var months_milked "Average months milked in last year (household)"
drop if milk_liters_produced==.
keep HHID product_code months_milked liters_month milk_liters_produced
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_milk_animals.dta", replace

************
*EGG PRODUCTIVITY - RH complete, not checked 
************
use "${MLW_W4_raw_data}\AG_MOD_R1.dta", clear
rename ag_r0a lvstckid
gen poultry_owned = ag_r02 if inlist(lvstckid, 311, 313, 315, 318, 319, 3310, 3314) // For MW2: local hen, local cock, duck, other, dove/pigeon, chicken layer/chicken-broiler and turkey/guinea fowl - RH include other?
collapse (sum) poultry_owned, by(HHID)
tempfile eggs_animals_hh 
save `eggs_animals_hh'

use "${MLW_W4_raw_data}\AG_MOD_S.dta", clear
rename ag_s0a product_code
keep if product_code==402 | product_code==403
rename ag_s02 eggs_months // # of months in past year that hh. produced eggs
rename ag_s03a eggs_per_month  // avg. qty of eggs per month in past year
rename ag_s03b quantity_month_unit
replace quantity_month = round(quantity_month/0.06) if product_code==402 & quantity_month_unit==2 // VAP: converting obsns in kgs to pieces for eggs 
// using MW IHS Food Conversion factors.pdf. Cannot convert ox-cart & ltrs for eggs 
replace quantity_month_unit = 3 if product_code== 402 & quantity_month_unit==2    
replace quantity_month_unit =. if product_code==402 & quantity_month_unit!=3        // VAP: chicken eggs, pieces
replace quantity_month_unit =. if product_code== 403 & quantity_month_unit!=3      // guinea fowl eggs, pieces
recode eggs_months eggs_per_month (.=0)
collapse (sum) eggs_per_month (max) eggs_months, by (HHID) // VAP: Collapsing chicken & guinea fowl eggs
gen eggs_total_year = eggs_months* eggs_per_month // Units are pieces for eggs 
merge 1:1 HHID using  `eggs_animals_hh', nogen keep(1 3)			
keep HHID eggs_months eggs_per_month eggs_total_year poultry_owned 

lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced in a year (household)"
lab var poultry_owned "Total number of poultry owned (household)"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_eggs_animals.dta", replace

********************************************************************************
*CONSUMPTION -- RH complete 10/25/21
******************************************************************************** 
use "${MLW_W4_raw_data}/ihs5_consumption_aggregate.dta", clear 

ren expagg total_cons // using real consumption-adjusted for region price disparities -- this is nominal (but other option was per capita vs hh-level). Confirm?
gen peraeq_cons = (total_cons / adulteq)
gen percapita_cons = (total_cons / hhsize)
gen daily_peraeq_cons = peraeq_cons/365 
gen daily_percap_cons = percapita_cons/365
lab var total_cons "Total HH consumption"
lab var peraeq_cons "Consumption per adult equivalent"
lab var percapita_cons "Consumption per capita"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var daily_percap_cons "Daily consumption per capita" 
keep HHID total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq 
save "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_consumption.dta", replace
		
********************************************************************************
*HOUSEHOLD FOOD PROVISION* -- RH complete (7/15/21) - not checked
********************************************************************************
use "${MLW_W4_raw_data}\HH_MOD_H.dta", clear
numlist "1/25"
forvalues k=1/25 {
    local num: word `k' of `r(numlist)'
	local alph: word `k' of `c(alpha)'
	ren hh_h05`alph' hh_h05_`num'
}
forvalues k = 1/25 {
    gen food_insecurity_`k' = (hh_h05_`k'=="X")
}
egen months_food_insec = rowtotal(food_insecurity_*) 
* replacing those that report over 12 months
replace months_food_insec = 12 if months_food_insec>12
keep HHID months_food_insec
lab var months_food_insec "Number of months of inadequate food provision"
save "${MLW_W4_created_data}/Malawi_IHS_LSMS_ISA_W4_food_insecurity.dta", replace				
		
		
***************************************************************************
*HOUSEHOLD ASSETS* - RH complete 8/24/21
***************************************************************************
use "${MLW_W4_raw_data}\HH_MOD_L.dta", clear
*ren hh_m03 price_purch  // RH: No price purchased, only total spent on item
ren hh_l05 value_today
ren hh_l04 age_item
ren hh_l03 num_items

collapse (sum) value_assets=value_today, by(HHID)
la var value_assets "Value of household assets"
save "${MLW_W4_created_data}\Malawi_IHS_LSMS_ISA_W4_hh_assets.dta", replace 
				
		
		
		
		
		
		
		
		
		
		
		
		
		
		



