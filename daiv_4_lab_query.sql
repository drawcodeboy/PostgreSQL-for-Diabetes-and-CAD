DROP TABLE IF EXISTS mimiciv_hosp.daiv_lab;

CREATE TABLE mimiciv_hosp.daiv_lab AS (

WITH backbone AS(
	SELECT
		*
	FROM
		mimiciv_hosp.daiv_backbone
),

lab AS(
	SELECT
		*
	FROM
		mimiciv_hosp.daiv_lab_temp
),

glucose AS(
	SELECT
		subject_id,
		MIN(valuenum) AS glucose_min,
		MAX(valuenum) AS glucose_max,
		ROUND(AVG(valuenum)::numeric, 1) AS glucose_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Glucose'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

potassium AS(
	SELECT
		subject_id,
		MIN(valuenum) AS potassium_min,
		MAX(valuenum) AS potassium_max,
		ROUND(AVG(valuenum)::numeric, 1) AS potassium_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Potassium'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

sodium AS(
	SELECT
		subject_id,
		MIN(valuenum) AS sodium_min,
		MAX(valuenum) AS sodium_max,
		ROUND(AVG(valuenum)::numeric, 1) AS sodium_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Sodium'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

chloride AS(
SELECT
	subject_id,
	MIN(valuenum) AS chloride_min,
	MAX(valuenum) AS chloride_max,
	ROUND(AVG(valuenum)::numeric, 1) AS chloride_mean
FROM
	lab
WHERE
	lab.label LIKE 'Chloride'
	AND
	lab.fluid LIKE 'Blood'
GROUP BY
	subject_id
),

creatinine AS(
	SELECT
		subject_id,
		MIN(valuenum) AS creatinine_min,
		MAX(valuenum) AS creatinine_max,
		ROUND(AVG(valuenum)::numeric, 4) AS creatinine_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Creatinine'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

urea_nitrogen AS(
	SELECT
		subject_id,
		MIN(valuenum) AS urea_nitrogen_min,
		MAX(valuenum) AS urea_nitrogen_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS urea_nitrogen_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Urea Nitrogen'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

bicarbonate AS(
	SELECT
		subject_id,
		MIN(valuenum) AS bicarbonate_min,
		MAX(valuenum) AS bicarbonate_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS bicarbonate_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Bicarbonate'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

anion_gap AS(
	SELECT
		subject_id,
		MIN(valuenum) AS anion_gap_min,
		MAX(valuenum) AS anion_gap_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS anion_gap_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Anion Gap'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

hematocrit AS(
	SELECT
		subject_id,
		MIN(valuenum) AS hematocrit_min,
		MAX(valuenum) AS hematocrit_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS hematocrit_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Hematocrit'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

hemoglobin AS (
	SELECT
		subject_id,
		MIN(valuenum) AS hemoglobin_min,
		MAX(valuenum) AS hemoglobin_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS hemoglobin_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Hemoglobin'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

platelet_count AS (
	SELECT
		subject_id,
		MIN(valuenum) AS platelet_count_min,
		MAX(valuenum) AS platelet_count_max,
		ROUND(AVG(valuenum)::numeric, 0) AS platelet_count_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Platelet Count'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

white_blood_cells AS(
	SELECT
		subject_id,
		MIN(valuenum) AS white_blood_cells_min,
		MAX(valuenum) AS white_blood_cells_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS white_blood_cells_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'White Blood Cells'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

magnesium AS(
	SELECT
		subject_id,
		MIN(valuenum) AS magnesium_min,
		MAX(valuenum) AS magnesium_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS magnesium_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Magnesium'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

mchc AS(
	SELECT
		subject_id,
		MIN(valuenum) AS mchc_min,
		MAX(valuenum) AS mchc_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS mchc_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'MCHC'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

mch AS(
	SELECT
		subject_id,
		MIN(valuenum) AS mch_min,
		MAX(valuenum) AS mch_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS mch_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'MCH'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

mcv AS(
	SELECT
		subject_id,
		MIN(valuenum) AS mcv_min,
		MAX(valuenum) AS mcv_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS mcv_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'MCV'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

red_blood_cells AS(
	SELECT
		subject_id,
		MIN(valuenum) AS red_blood_cells_min,
		MAX(valuenum) AS red_blood_cells_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS red_blood_cells_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Red Blood Cells'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

rdw AS(
	SELECT
		subject_id,
		MIN(valuenum) AS rdw_min,
		MAX(valuenum) AS rdw_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS rdw_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'RDW'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

phosphate AS(
	SELECT
		subject_id,
		MIN(valuenum) AS phosphate_min,
		MAX(valuenum) AS phosphate_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS phosphate_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Phosphate'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

calcium_total AS(
	SELECT
		subject_id,
		MIN(valuenum) AS calcium_total_min,
		MAX(valuenum) AS calcium_total_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS calcium_total_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Calcium, Total'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

lactate AS (
	SELECT
		subject_id,
		MIN(valuenum) AS lactate_min,
		MAX(valuenum) AS lactate_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS lactate_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Lactate'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

monocytes AS (
	SELECT
		subject_id,
		MIN(valuenum) AS monocytes_min,
		MAX(valuenum) AS monocytes_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS monocytes_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Monocytes'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

eosinophils AS (
	SELECT
		subject_id,
		MIN(valuenum) AS eosinophils_min,
		MAX(valuenum) AS eosinophils_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS eosinophils_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Eosinophils'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

basophils AS (
	SELECT
		subject_id,
		MIN(valuenum) AS basophils_min,
		MAX(valuenum) AS basophils_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS basophils_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Basophils'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
),

neutrophils AS (
	SELECT
		subject_id,
		MIN(valuenum) AS neutrophils_min,
		MAX(valuenum) AS neutrophils_max,
		-- 꽤 작은 수치라 4자리 수까지 표현
		ROUND(AVG(valuenum)::numeric, 4) AS neutrophils_mean
	FROM
		lab
	WHERE
		lab.label LIKE 'Neutrophils'
		AND
		lab.fluid LIKE 'Blood'
	GROUP BY
		subject_id
)

SELECT
	backbone.subject_id,
	backbone.hadm_id,
	
	glucose.glucose_min,
	glucose.glucose_max,
	glucose.glucose_mean,
	
	potassium.potassium_min,
	potassium.potassium_max,
	potassium.potassium_mean,
	
	sodium.sodium_min,
	sodium.sodium_max,
	sodium.sodium_mean,
	
	chloride.chloride_min,
	chloride.chloride_max,
	chloride.chloride_mean,
	
	creatinine.creatinine_min,
	creatinine.creatinine_max,
	creatinine.creatinine_mean,
	
	urea_nitrogen.urea_nitrogen_min,
	urea_nitrogen.urea_nitrogen_max,
	urea_nitrogen.urea_nitrogen_mean,
	
	bicarbonate.bicarbonate_min,
	bicarbonate.bicarbonate_max,
	bicarbonate.bicarbonate_mean,
	
	anion_gap.anion_gap_min,
	anion_gap.anion_gap_max,
	anion_gap.anion_gap_mean,
	
	hematocrit.hematocrit_min,
	hematocrit.hematocrit_max,
	hematocrit.hematocrit_mean,
	
	hemoglobin.hemoglobin_min,
	hemoglobin.hemoglobin_max,
	hemoglobin.hemoglobin_mean,
	
	platelet_count.platelet_count_min,
	platelet_count.platelet_count_max,
	platelet_count.platelet_count_mean,
	
	white_blood_cells.white_blood_cells_min,
	white_blood_cells.white_blood_cells_max,
	white_blood_cells.white_blood_cells_mean,
	
	magnesium.magnesium_min,
	magnesium.magnesium_max,
	magnesium.magnesium_mean,
	
	mchc.mchc_min,
	mchc.mchc_max,
	mchc.mchc_mean,
	
	mch.mch_min,
	mch.mch_max,
	mch.mch_mean,
	
	mcv.mcv_min,
	mcv.mcv_max,
	mcv.mcv_mean,
	
	red_blood_cells.red_blood_cells_min,
	red_blood_cells.red_blood_cells_max,
	red_blood_cells.red_blood_cells_mean,
	
	rdw.rdw_min,
	rdw.rdw_max,
	rdw.rdw_mean,
	
	phosphate.phosphate_min,
	phosphate.phosphate_max,
	phosphate.phosphate_mean,
	
	calcium_total.calcium_total_min,
	calcium_total.calcium_total_max,
	calcium_total.calcium_total_mean,
	
	lactate.lactate_min,
	lactate.lactate_max,
	lactate.lactate_mean,
	
	monocytes.monocytes_min,
	monocytes.monocytes_max,
	monocytes.monocytes_mean,
	
	eosinophils.eosinophils_min,
	eosinophils.eosinophils_max,
	eosinophils.eosinophils_mean,
	
	basophils.basophils_min,
	basophils.basophils_max,
	basophils.basophils_mean,
	
	neutrophils.neutrophils_min,
	neutrophils.neutrophils_max,
	neutrophils.neutrophils_mean
FROM
	backbone
LEFT OUTER JOIN
	glucose
ON
	backbone.subject_id = glucose.subject_id
LEFT OUTER JOIN
	potassium
ON
	backbone.subject_id = potassium.subject_id
LEFT OUTER JOIN
	sodium
ON
	backbone.subject_id = sodium.subject_id
LEFT OUTER JOIN
	chloride
ON
	backbone.subject_id = chloride.subject_id
LEFT OUTER JOIN
	creatinine
ON
	backbone.subject_id = creatinine.subject_id
LEFT OUTER JOIN
	urea_nitrogen
ON
	backbone.subject_id = urea_nitrogen.subject_id
LEFT OUTER JOIN
	bicarbonate
ON
	backbone.subject_id = bicarbonate.subject_id
LEFT OUTER JOIN
	anion_gap
ON
	backbone.subject_id = anion_gap.subject_id
LEFT OUTER JOIN
	hematocrit
ON
	backbone.subject_id = hematocrit.subject_id
LEFT OUTER JOIN
	hemoglobin
ON
	backbone.subject_id = hemoglobin.subject_id
LEFT OUTER JOIN
	platelet_count
ON
	backbone.subject_id = platelet_count.subject_id
LEFT OUTER JOIN
	white_blood_cells
ON
	backbone.subject_id = white_blood_cells.subject_id
LEFT OUTER JOIN
	magnesium
ON
	backbone.subject_id = magnesium.subject_id
LEFT OUTER JOIN
	mchc
ON
	backbone.subject_id = mchc.subject_id
LEFT OUTER JOIN
	mch
ON
	backbone.subject_id = mch.subject_id
LEFT OUTER JOIN
	mcv
ON
	backbone.subject_id = mcv.subject_id
LEFT OUTER JOIN
	red_blood_cells
ON
	backbone.subject_id = red_blood_cells.subject_id
LEFT OUTER JOIN
	rdw
ON
	backbone.subject_id = rdw.subject_id
LEFT OUTER JOIN
	phosphate
ON
	backbone.subject_id = phosphate.subject_id
LEFT OUTER JOIN
	calcium_total
ON
	backbone.subject_id = calcium_total.subject_id
LEFT OUTER JOIN
	lactate
ON
	backbone.subject_id = lactate.subject_id
LEFT OUTER JOIN
	monocytes
ON
	backbone.subject_id = monocytes.subject_id
LEFT OUTER JOIN
	eosinophils
ON
	backbone.subject_id = eosinophils.subject_id
LEFT OUTER JOIN
	basophils
ON
	backbone.subject_id = basophils.subject_id
LEFT OUTER JOIN
	neutrophils
ON
	backbone.subject_id = neutrophils.subject_id
)