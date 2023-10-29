DROP TABLE IF EXISTS mimiciv_hosp.daiv_bmi_bp;

CREATE TABLE mimiciv_hosp.daiv_bmi_bp AS (

WITH backbone AS(
	SELECT
		*
	FROM
		mimiciv_hosp.daiv_backbone
),

-- 당뇨병 환자들(backbone)의 BMI 추출
bmi AS(
	SELECT
		omr.*,
		-- BMI가 text라서 CAST로 FLOAT type으로 변경
		CAST(result_value AS FLOAT) AS bmi_num
	FROM
		backbone
	LEFT OUTER JOIN
		mimiciv_hosp.omr AS omr
	ON
		backbone.subject_id = omr.subject_id
	WHERE
		omr.result_name LIKE 'BMI (kg/m2)'
	ORDER BY
		backbone.subject_id ASC,
		omr.chartdate ASC
),

-- BMI min, max, mean 형태로 추출
bmi_data AS(
	SELECT
		subject_id,
		MIN(bmi_num) AS bmi_min,
		MAX(bmi_num) AS bmi_max,
		-- ROUND를 쓰려면 인자가 numeric이어야 하는데, double precision인 경우
		-- 에러가 발생해서 형변환을 해주어야 한다.
		ROUND(AVG(bmi_num)::numeric, 1) AS bmi_mean
	FROM
		bmi
	GROUP BY
		bmi.subject_id
),

-- 당뇨병 환자들의 BP 추출
bp AS(
	SELECT
		omr.*,
		CAST(SPLIT_PART(result_value, '/', 1) AS smallint) AS systolic_bp,
		CAST(SPLIT_PART(result_value, '/', 2) AS smallint) AS diastolic_bp
	FROM
		backbone
	LEFT OUTER JOIN
		mimiciv_hosp.omr AS omr
	ON
		backbone.subject_id = omr.subject_id
	WHERE
		omr.result_name LIKE 'Blood Pressure'
	ORDER BY
		backbone.subject_id ASC,
		omr.chartdate ASC
),

-- systolic bp min, max, mean, diastolic bp min, max, mean 추출
bp_data AS(
	SELECT
		subject_id,
		MIN(systolic_bp) AS systolic_bp_min,
		MAX(systolic_bp) AS systolic_bp_max,
		ROUND(AVG(systolic_bp)::numeric, 1) AS systolic_bp_mean,
		MIN(diastolic_bp) AS diastolic_bp_min,
		MAX(diastolic_bp) AS diastolic_bp_max,
		ROUND(AVG(diastolic_bp)::numeric, 1) AS diastolic_bp_mean
	FROM
		bp
	GROUP BY
		bp.subject_id
),

backbone_w_bmi AS(
	SELECT
		backbone.subject_id,
		backbone.hadm_id,
		bmi_data.bmi_min,
		bmi_data.bmi_max,
		bmi_data.bmi_mean
	FROM
		backbone
	LEFT OUTER JOIN
		bmi_data
	ON
		backbone.subject_id = bmi_data.subject_id
)

SELECT
	backbone_w_bmi.*,
	bp_data.systolic_bp_min,
	bp_data.systolic_bp_max,
	bp_data.systolic_bp_mean,
	bp_data.diastolic_bp_min,
	bp_data.diastolic_bp_max,
	bp_data.diastolic_bp_mean
FROM
	backbone_w_bmi
LEFT OUTER JOIN
	bp_data
ON
	backbone_w_bmi.subject_id = bp_data.subject_id
)