SELECT
	backbone.subject_id,
	backbone.hadm_id,
	backbone.diabetes_icd_code,
	backbone.diabetes_seq_num,
	backbone.hp_icd_code,
	backbone.hp_seq_num,
	backbone.cad_icd_code,
	backbone.cad_seq_num,
	
	demographic.age,
	demographic.gender,
	demographic.race,
	
	omr.bmi_min,
	omr.bmi_max,
	omr.bmi_mean,
	omr.systolic_bp_min,
	omr.systolic_bp_max,
	omr.systolic_bp_mean,
	omr.diastolic_bp_min,
	omr.diastolic_bp_max,
	omr.diastolic_bp_mean,
	
	lab.glucose_min,
	lab.glucose_max,
	lab.glucose_mean,
	lab.potassium_min,
	lab.potassium_max,
	lab.potassium_mean,
	lab.sodium_min,
	lab.sodium_max,
	lab.sodium_mean,
	lab.chloride_min,
	lab.chloride_max,
	lab.chloride_mean,
	lab.creatinine_min,
	lab.creatinine_max,
	lab.creatinine_mean,
	lab.urea_nitrogen_min,
	lab.urea_nitrogen_max,
	lab.urea_nitrogen_mean,
	lab.bicarbonate_min,
	lab.bicarbonate_max,
	lab.bicarbonate_mean,
	lab.anion_gap_min,
	lab.anion_gap_max,
	lab.anion_gap_mean,
	lab.hematocrit_min,
	lab.hematocrit_max,
	lab.hematocrit_mean,
	lab.hemoglobin_min,
	lab.hemoglobin_max,
	lab.hemoglobin_mean,
	lab.platelet_count_min,
	lab.platelet_count_max,
	lab.platelet_count_mean,
	lab.white_blood_cells_min,
	lab.white_blood_cells_max,
	lab.white_blood_cells_mean,
	lab.magnesium_min,
	lab.magnesium_max,
	lab.magnesium_mean,
	lab.mchc_min,
	lab.mchc_max,
	lab.mchc_mean,
	lab.mch_min,
	lab.mch_max,
	lab.mch_mean,
	lab.mcv_min,
	lab.mcv_max,
	lab.mcv_mean,
	lab.red_blood_cells_min,
	lab.red_blood_cells_max,
	lab.red_blood_cells_mean,
	lab.rdw_min,
	lab.rdw_max,
	lab.rdw_mean,
	lab.phosphate_min,
	lab.phosphate_max,
	lab.phosphate_mean,
	lab.calcium_total_min,
	lab.calcium_total_max,
	lab.calcium_total_mean,
	lab.lactate_min,
	lab.lactate_max,
	lab.lactate_mean,
	lab.monocytes_min,
	lab.monocytes_max,
	lab.monocytes_mean,
	lab.eosinophils_min,
	lab.eosinophils_max,
	lab.eosinophils_mean,
	lab.basophils_min,
	lab.basophils_max,
	lab.basophils_mean,
	lab.neutrophils_min,
	lab.neutrophils_max,
	lab.neutrophils_mean,
	
	pharmacy.heparin,
	pharmacy.clopidogrel,
	pharmacy.insulin,
	pharmacy.digoxin,
	pharmacy.sprionolactone,
	pharmacy.bumetanide,
	pharmacy.torsemide,
	pharmacy.furosemide,
	pharmacy.metolazone,
	pharmacy.simvastatin,
	pharmacy.allopurinol
FROM -- BACKBONE
	mimiciv_hosp.daiv_backbone AS backbone
LEFT OUTER JOIN -- DEMOGRAPHIC (AGE, GENDER, RACE)
	mimiciv_hosp.daiv_demographic AS demographic
ON
	backbone.subject_id = demographic.subject_id
	AND
	backbone.hadm_id = demographic.hadm_id
LEFT OUTER JOIN -- OMR (BMI, SYSTOLIC BP, DIASTOLIC BP)
	mimiciv_hosp.daiv_bmi_bp AS omr
ON
	backbone.subject_id = omr.subject_id
	AND
	backbone.hadm_id = omr.hadm_id
LEFT OUTER JOIN -- LAB
	mimiciv_hosp.daiv_lab AS lab
ON
	backbone.subject_id = lab.subject_id
	AND
	backbone.hadm_id = lab.hadm_id
LEFT OUTER JOIN -- PHARMACY
	mimiciv_hosp.daiv_pharmacy AS pharmacy
ON
	backbone.subject_id = pharmacy.subject_id
	AND
	backbone.hadm_id = pharmacy.hadm_id