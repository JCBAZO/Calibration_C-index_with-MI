clear
set more off
*findit mvrs /*install this user written command*/
set seed 1827
cd "S:\FPHS_THIN_Projects\JC\Calibration plots for Karan"
dir

/*Data*/
	use "S:\FPHS_THIN_Projects\Karan\BZI_PhD_T2D\PhD_descriptive_data\mice_data\impv2_phddata_111023.dta", clear
	duplicates report
	recode sex 1=0 2=1 /*check this Karan*/	
	sample 1 /*testing sample, then we can run dofile with the full sample*/
	save "S:\FPHS_THIN_Projects\JC\Calibration plots for Karan\data_for_calibration_example.dta", replace

/*Models*/

	use "S:\FPHS_THIN_Projects\JC\Calibration plots for Karan\data_for_calibration_example.dta", clear

	*Model 1: non-linear terms (in just one imputed dataset)*
	local model_1 = "smoking_status2 albumin_0 albumin_1 alp_0 alp_1 alp_2 alp_3 alt_0 alt_1 alt_2 bilirubin_0 bilirubin_1 bilirubin_2 bilirubin_3 totalcholesterol_0 totalcholesterol_1 serumcreatinine_0 serumcreatinine_1 serumcreatinine_2 serumcreatinine_3 hb_0 hb_1 hb_2 hb_3 hdlcholesterol_0 hdlcholesterol_1 hdlcholesterol_2 hdlcholesterol_3 sodium_0 sodium_1 sodium_2 sodium_3 ldlc_0 ldlc_1 totalprotein_0 totalprotein_1 totalprotein_2 totalprotein_3 triglycerides_0 triglycerides_1 triglycerides_2 mcv_0 mcv_1 mcv_2 mcv_3 tsh_0 tsh_1 tsh_2 urea_0 urea_1 urea_2 urea_3 neutrophilcount_0 neutrophilcount_1 neutrophilcount_2 wcc_0 wcc_1 wcc_2 lymphocytecount_0 lymphocytecount_1 lymphocytecount_2 lymphocytecount_3 potassium_0 potassium_1 hba1c_0 hba1c_1 egfr_0 egfr_1 egfr_2 egfr_3 acr_0 acr_1 acr_2 acr_3 bmi_0 bmi_1 bmi_2 bmi_3 diastolicbloodpressure_0 diastolicbloodpressure_1 systolicbloodpressure_0 systolicbloodpressure_1 systolicbloodpressure_2 systolicbloodpressure_3 i.hx_neuro i.acarbose i.insulin i.statins i.hx_resp i.hx_liver i.hx_gi i.hx_severekidney i.hx_autoimmune i.thiazols i.hx_cancer i.hx_proteinuria i.hx_neuropathy  i.hx_retinopathy i.hx_cad i.hx_cerebro i.hx_pvd i.hx_arrhythmia i.hx_heartfailure i.hx_mi i.hx_dvt i.hx_nephropathy i.hx_footlegulcer i.glp1 i.gliptins i.meglitinides i.sex duration_diabetes age i.aceiarb i.ca_blocker i.beta_blocker i.thiazides i.alpha_blocker i.metformin i.sulphonylureas i.hx_comashock duration_diabetes_0 duration_diabetes_1 age_0 age_1"
	
	*Model 2: interaction terms + non-linear terms*
	local model_2 = "age_smoking smoking_status2 age_albumin age_alp age_bilirubin age_sodium age_mcv age_smoking age_bmi albumin_0 albumin_1 alp_0 alp_1 alp_2 alp_3 alt_0 alt_1 alt_2 bilirubin_0 bilirubin_1 bilirubin_2 bilirubin_3 totalcholesterol_0 totalcholesterol_1 serumcreatinine_0 serumcreatinine_1 serumcreatinine_2 serumcreatinine_3 hb_0 hb_1 hb_2 hb_3 hdlcholesterol_0 hdlcholesterol_1 hdlcholesterol_2 hdlcholesterol_3 sodium_0 sodium_1 sodium_2 sodium_3 ldlc_0 ldlc_1 totalprotein_0 totalprotein_1 totalprotein_2 totalprotein_3 triglycerides_0 triglycerides_1 triglycerides_2 mcv_0 mcv_1 mcv_2 mcv_3 tsh_0 tsh_1 tsh_2 urea_0 urea_1 urea_2 urea_3 neutrophilcount_0 neutrophilcount_1 neutrophilcount_2 wcc_0 wcc_1 wcc_2 lymphocytecount_0 lymphocytecount_1 lymphocytecount_2 lymphocytecount_3 potassium_0 potassium_1 hba1c_0 hba1c_1 egfr_0 egfr_1 egfr_2 egfr_3 acr_0 acr_1 acr_2 acr_3 bmi_0 bmi_1 bmi_2 bmi_3 diastolicbloodpressure_0 diastolicbloodpressure_1 systolicbloodpressure_0 systolicbloodpressure_1 systolicbloodpressure_2 systolicbloodpressure_3 sex_neuro sex_thiazides sex_age age_resp age_liver age_severekidney age_cancer age_pvd i.hx_neuro i.acarbose i.insulin i.statins i.hx_resp i.hx_liver i.hx_gi i.hx_severekidney i.hx_autoimmune i.thiazols i.hx_cancer i.hx_proteinuria i.hx_neuropathy  i.hx_retinopathy i.hx_cad i.hx_cerebro i.hx_pvd i.hx_arrhythmia i.hx_heartfailure i.hx_mi i.hx_dvt i.hx_nephropathy i.hx_footlegulcer i.glp1 i.gliptins i.meglitinides i.sex duration_diabetes age i.aceiarb i.ca_blocker i.beta_blocker i.thiazides i.alpha_blocker i.metformin i.sulphonylureas i.hx_comashock duration_diabetes_0 duration_diabetes_1 age_0 age_1" 	
	
/*C-index (after mi estimate)*/	

	*Model 1
	noi mi estimate, saving(m1_estimates, replace): stcox `model_1'
	qui mi query
	local M=r(M)
	scalar cstat=0
	qui mi xeq 1/`M': stcox `model_1'; estat concordance; scalar cstat=cstat+r(C)
	scalar cstat=cstat/`M'
	noi di "C statistic over imputed data (Model 1) = " cstat /*C-index (model-1): 0.83806171*/		

	*Model 2
	noi mi estimate, saving(m1_estimates, replace): stcox `model_2'
	qui mi query
	local M=r(M)
	scalar cstat=0
	qui mi xeq 1/`M': stcox `model_2'; estat concordance; scalar cstat=cstat+r(C)
	scalar cstat=cstat/`M'
	noi di "C statistic over imputed data (Model 2) = " cstat /*C-index (model-2): .84200405*/		
	
/*Calibration plots after mi estimates (Model-1))*/	

	use "S:\FPHS_THIN_Projects\JC\Calibration plots for Karan\data_for_calibration_example.dta", clear
	
	local model_1 = "smoking_status2 albumin_0 albumin_1 alp_0 alp_1 alp_2 alp_3 alt_0 alt_1 alt_2 bilirubin_0 bilirubin_1 bilirubin_2 bilirubin_3 totalcholesterol_0 totalcholesterol_1 serumcreatinine_0 serumcreatinine_1 serumcreatinine_2 serumcreatinine_3 hb_0 hb_1 hb_2 hb_3 hdlcholesterol_0 hdlcholesterol_1 hdlcholesterol_2 hdlcholesterol_3 sodium_0 sodium_1 sodium_2 sodium_3 ldlc_0 ldlc_1 totalprotein_0 totalprotein_1 totalprotein_2 totalprotein_3 triglycerides_0 triglycerides_1 triglycerides_2 mcv_0 mcv_1 mcv_2 mcv_3 tsh_0 tsh_1 tsh_2 urea_0 urea_1 urea_2 urea_3 neutrophilcount_0 neutrophilcount_1 neutrophilcount_2 wcc_0 wcc_1 wcc_2 lymphocytecount_0 lymphocytecount_1 lymphocytecount_2 lymphocytecount_3 potassium_0 potassium_1 hba1c_0 hba1c_1 egfr_0 egfr_1 egfr_2 egfr_3 acr_0 acr_1 acr_2 acr_3 bmi_0 bmi_1 bmi_2 bmi_3 diastolicbloodpressure_0 diastolicbloodpressure_1 systolicbloodpressure_0 systolicbloodpressure_1 systolicbloodpressure_2 systolicbloodpressure_3 i.hx_neuro i.acarbose i.insulin i.statins i.hx_resp i.hx_liver i.hx_gi i.hx_severekidney i.hx_autoimmune i.thiazols i.hx_cancer i.hx_proteinuria i.hx_neuropathy  i.hx_retinopathy i.hx_cad i.hx_cerebro i.hx_pvd i.hx_arrhythmia i.hx_heartfailure i.hx_mi i.hx_dvt i.hx_nephropathy i.hx_footlegulcer i.glp1 i.gliptins i.meglitinides i.sex duration_diabetes age i.aceiarb i.ca_blocker i.beta_blocker i.thiazides i.alpha_blocker i.metformin i.sulphonylureas i.hx_comashock duration_diabetes_0 duration_diabetes_1 age_0 age_1"

	*1. Fit the model
    mi estimate, saving(miest, replace):  stcox `model_1'
    mi predict xb_mi_1 using miest
	codebook xb_mi_1 /*xb stored in m=0*/

	*2. Center the PI on the derivation dataset mean.
	summarize xb_mi_1
	replace xb_mi_1 = xb_mi_1 - r(mean)

	*3. Define 3 prognostic groups from the 25th and 75th centiles of xb in the derivation dataset. (This is done on events because the number of events gets very small in the “Good” prognostic group.)
	centile xb_mi_1 if _d==1, centile(25 75)
	generate byte group = cond(xb_mi_1 <= r(c_1), 1, cond(xb_mi_1 >= r(c_2), 3, 2))

	*4. Get the baseline log cumulative hazard, lnH0, in the derivation data.
	stcox xb_mi_1
	predict H0, basechazard
	generate lnH0 = ln(H0)

	*5. Compute the smoothed baseline log cumulative-hazard function on t.
	fracpoly: regress lnH0 _t

	*6. Compute mean survival probabilities at t = 0(1)10 years.
	range t 0 10 11
	fraceval var t /*fraceval needs to be installed*/
	generate S0 = cond(t==0, 1, exp(-exp(_fp)))
	stcoxgrp xb_mi_1 S0 t, mean(s) km(km) by(group) /*stcoxgrp needs to be installed*/

	*7. Compare observed with predicted survival.
	twoway (scatter km1 km2 km3 t, mcolor(gs5 gs8 gs10)) ///
	(rcap km_lb1 km_ub1 t, lcolor(gs5 ..)) ///
	(rcap km_lb2 km_ub2 t, lcolor(gs8 ..)) ///
	(rcap km_lb3 km_ub3 t, lcolor(gs10 ..)) ///
	(line s1 s2 s3 t, sort lwid(medthick ..) lcolor(gs5 gs8 gs10)), ///
	legend(off) title("Calibration plot - Model 1") ///
	xlabel(0(2)10) ylabel(0(.25)1, angle(h) format(%4.2f)) ytitle("Survival probability") ///
	xtitle("Years of observation") name(g1, replace) 
	
	graph save "S:\FPHS_THIN_Projects\JC\Calibration plots for Karan\calibration_plot_M1.gph", replace
	
/*Calibration plots after mi estimates (Model-2))*/	

	use "S:\FPHS_THIN_Projects\JC\Calibration plots for Karan\data_for_calibration_example.dta", clear
	
	local model_2 = "age_smoking smoking_status2 age_albumin age_alp age_bilirubin age_sodium age_mcv age_smoking age_bmi albumin_0 albumin_1 alp_0 alp_1 alp_2 alp_3 alt_0 alt_1 alt_2 bilirubin_0 bilirubin_1 bilirubin_2 bilirubin_3 totalcholesterol_0 totalcholesterol_1 serumcreatinine_0 serumcreatinine_1 serumcreatinine_2 serumcreatinine_3 hb_0 hb_1 hb_2 hb_3 hdlcholesterol_0 hdlcholesterol_1 hdlcholesterol_2 hdlcholesterol_3 sodium_0 sodium_1 sodium_2 sodium_3 ldlc_0 ldlc_1 totalprotein_0 totalprotein_1 totalprotein_2 totalprotein_3 triglycerides_0 triglycerides_1 triglycerides_2 mcv_0 mcv_1 mcv_2 mcv_3 tsh_0 tsh_1 tsh_2 urea_0 urea_1 urea_2 urea_3 neutrophilcount_0 neutrophilcount_1 neutrophilcount_2 wcc_0 wcc_1 wcc_2 lymphocytecount_0 lymphocytecount_1 lymphocytecount_2 lymphocytecount_3 potassium_0 potassium_1 hba1c_0 hba1c_1 egfr_0 egfr_1 egfr_2 egfr_3 acr_0 acr_1 acr_2 acr_3 bmi_0 bmi_1 bmi_2 bmi_3 diastolicbloodpressure_0 diastolicbloodpressure_1 systolicbloodpressure_0 systolicbloodpressure_1 systolicbloodpressure_2 systolicbloodpressure_3 sex_neuro sex_thiazides sex_age age_resp age_liver age_severekidney age_cancer age_pvd i.hx_neuro i.acarbose i.insulin i.statins i.hx_resp i.hx_liver i.hx_gi i.hx_severekidney i.hx_autoimmune i.thiazols i.hx_cancer i.hx_proteinuria i.hx_neuropathy  i.hx_retinopathy i.hx_cad i.hx_cerebro i.hx_pvd i.hx_arrhythmia i.hx_heartfailure i.hx_mi i.hx_dvt i.hx_nephropathy i.hx_footlegulcer i.glp1 i.gliptins i.meglitinides i.sex duration_diabetes age i.aceiarb i.ca_blocker i.beta_blocker i.thiazides i.alpha_blocker i.metformin i.sulphonylureas i.hx_comashock duration_diabetes_0 duration_diabetes_1 age_0 age_1" 	

	*1. Fit the model
    mi estimate, saving(miest, replace):  stcox `model_2'
    mi predict xb_mi_2 using miest
	codebook xb_mi_2 /*xb stored in m=0*/

	*2. Center the PI on the derivation dataset mean.
	summarize xb_mi_2
	replace xb_mi_2 = xb_mi_2 - r(mean)

	*3. Define 3 prognostic groups from the 25th and 75th centiles of xb in the derivation dataset. (This is done on events because the number of events gets very small in the “Good” prognostic group.)
	centile xb_mi_2 if _d==1, centile(25 75)
	generate byte group = cond(xb_mi_2 <= r(c_1), 1, cond(xb_mi_2 >= r(c_2), 3, 2))

	*4. Get the baseline log cumulative hazard, lnH0, in the derivation data.
	stcox xb_mi_2
	predict H0, basechazard
	generate lnH0 = ln(H0)

	*5. Compute the smoothed baseline log cumulative-hazard function on t.
	fracpoly: regress lnH0 _t

	*6. Compute mean survival probabilities at t = 0(1)10 years.
	range t 0 10 11
	fraceval var t /*fraceval needs to be installed*/
	generate S0 = cond(t==0, 1, exp(-exp(_fp)))
	stcoxgrp xb_mi_2 S0 t, mean(s) km(km) by(group) /*stcoxgrp needs to be installed*/

	*7. Compare observed with predicted survival.
	twoway (scatter km1 km2 km3 t, mcolor(gs5 gs8 gs10)) ///
	(rcap km_lb1 km_ub1 t, lcolor(gs5 ..)) ///
	(rcap km_lb2 km_ub2 t, lcolor(gs8 ..)) ///
	(rcap km_lb3 km_ub3 t, lcolor(gs10 ..)) ///
	(line s1 s2 s3 t, sort lwid(medthick ..) lcolor(gs5 gs8 gs10)), ///
	legend(off) title("Calibration plot - Model 2") ///
	xlabel(0(2)10) ylabel(0(.25)1, angle(h) format(%4.2f)) ytitle("Survival probability") ///
	xtitle("Years of observation") name(g1, replace) 
	
	graph save "S:\FPHS_THIN_Projects\JC\Calibration plots for Karan\calibration_plot_M2.gph", replace	
	
exit	

