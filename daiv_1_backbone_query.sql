DROP TABLE IF EXISTS mimiciv_hosp.daiv_backbone;

CREATE TABLE mimiciv_hosp.daiv_backbone AS (

-- 같은 환자에 대해 제일 빠르게 진단 받은 케이스만 고려하기 위해 사용
-- 재입원의 케이스도 고려하지 않음 (첫 진단만)
-- 가능한 이유 = 이미 아래의 ORDER BY 절을 통해 subject_id, hadm_id, seq_num 순서로
-- 이미 정렬이 되어있기 때문에 가능 -> row_num이 1인 레코드만 가져오면 됨.
-- ROW_NUMBER() OVER (PARTITION BY DIAG.subject_id ORDER BY DIAG.hadm_id) AS row_num

-- Diabetes Patients
WITH DIAG_DIABETES AS (
	SELECT /*+materialize */
		DIAG.subject_id,
		DIAG.hadm_id,
		DIAG.seq_num,
		DIAG.icd_code,
		DIAG.icd_version,
		D_DIAG.long_title,
		ROW_NUMBER() OVER (PARTITION BY DIAG.subject_id ORDER BY DIAG.hadm_id) AS row_num
	FROM 
		mimiciv_hosp.diagnoses_icd AS DIAG
	LEFT OUTER JOIN
		mimiciv_hosp.d_icd_diagnoses AS D_DIAG
	ON
		DIAG.icd_code = D_DIAG.icd_code
	WHERE 
		-- ICD-9 (ICD-10 없음)
		DIAG.icd_code LIKE '250%'
	ORDER BY
		DIAG.subject_id,
		DIAG.hadm_id,
		DIAG.seq_num
),

-- CAD Patients
DIAG_CAD AS (
	SELECT /*+materialize */
		DIAG.subject_id,
		DIAG.hadm_id,
		DIAG.seq_num,
		DIAG.icd_code,
		DIAG.icd_version,
		D_DIAG.long_title,
		ROW_NUMBER() OVER (PARTITION BY DIAG.subject_id ORDER BY DIAG.hadm_id) AS row_num
	FROM 
		mimiciv_hosp.diagnoses_icd AS DIAG
	LEFT OUTER JOIN
		mimiciv_hosp.d_icd_diagnoses AS D_DIAG
	ON
		DIAG.icd_code = D_DIAG.icd_code
	WHERE 
		-- ICD-9
		-- Unstable angina
		DIAG.icd_code IN ('4111', '41181', '41189', '4130', '4131', '4139')
		OR
		-- CV - coronary artery ds
		DIAG.icd_code IN ('412', '41400', '41401', '4142', '4143', '4148', '4149', '4292')
		OR
		-- Previous CABG, PCI
		DIAG.icd_code IN ('41402', '41403', '41404', '41405', 'V4581', 'V4582')
		OR
		-- ICD-10, 당뇨병 환자가 CAD 환자가 될 수 있는 케이스 4 건 정도 나옴
		DIAG.icd_code LIKE 'I25%'
	ORDER BY
		DIAG.subject_id,
		DIAG.hadm_id,
		DIAG.seq_num
),

-- Hyper Tension Patients
DIAG_HP AS (
	SELECT /*+materialize */
		DIAG.subject_id,
		DIAG.hadm_id,
		DIAG.seq_num,
		DIAG.icd_code,
		DIAG.icd_version,
		D_DIAG.long_title,
		ROW_NUMBER() OVER (PARTITION BY DIAG.subject_id ORDER BY DIAG.hadm_id) AS row_num
	FROM 
		mimiciv_hosp.diagnoses_icd AS DIAG
	LEFT OUTER JOIN
		mimiciv_hosp.d_icd_diagnoses AS D_DIAG
	ON
		DIAG.icd_code = D_DIAG.icd_code
	WHERE 
		-- ICD-9
		-- CV - essential ht
		DIAG.icd_code IN ('4011', '4019')
		OR
		-- Hypertensive Heart Disease
		DIAG.icd_code IN ('40210', '40290')
		OR
		-- Renovascular and other secondary hypertension
		DIAG.icd_code IN ('40511', '40519', '40591', '40599')
		OR
		-- ICD-10
		DIAG.icd_code IN ('I10', 'I11', 'I12', 'I13', 'I15', 'I16')
	ORDER BY
		DIAG.subject_id,
		DIAG.hadm_id,
		DIAG.seq_num
),

-- final table
DIAG_TOTAL AS (
	SELECT /*+materialize */
		-- 환자 ID, 입원 ID
		DIAG_DIABETES.subject_id AS subject_id,
		DIAG_DIABETES.hadm_id AS hadm_id,

		-- 당뇨병 진단 순서 및 ICD CODE
		DIAG_DIABETES.seq_num AS diabetes_seq_num,
		DIAG_DIABETES.icd_code AS diabetes_icd_code,
		DIAG_DIABETES.long_title AS diabetes_title,
	
		-- Hypertension 진단 순서 및 ICD CODE
		DIAG_HP.seq_num AS hp_seq_num,
		DIAG_HP.icd_code AS hp_icd_code,
		DIAG_HP.long_title AS hp_long_title,

		-- CAD 진단 순서 및 ICD CODE
		DIAG_CAD.seq_num AS cad_seq_num,
		DIAG_CAD.icd_code AS CAD_icd_code,
		DIAG_CAD.long_title AS cad_title
	FROM
		DIAG_DIABETES
	LEFT OUTER JOIN
		DIAG_CAD
	ON
		DIAG_DIABETES.subject_id = DIAG_CAD.subject_id
		AND
		DIAG_DIABETES.hadm_id = DIAG_CAD.hadm_id
	LEFT OUTER JOIN
		DIAG_HP
	ON
		DIAG_DIABETES.subject_id = DIAG_HP.subject_id
		AND
		DIAG_DIABETES.hadm_id = DIAG_HP.hadm_id
	WHERE
		(
			DIAG_DIABETES.row_num = 1 -- 당뇨병으로 처음 입원한 사람
		)
		AND
		(
			(
				DIAG_DIABETES.seq_num < DIAG_CAD.seq_num -- 당뇨병 진단 후, CAD 진단 환자
				AND
				DIAG_CAD.row_num = 1 -- CAD로 진단 받은 케이스 또한 처음 CAD 관련 질환을 진단 받은 케이스로 가져와야 함.
			)
			OR
				DIAG_CAD IS NULL -- 당뇨병만 걸린 환자
		)
		
	ORDER BY
		DIAG_DIABETES.subject_id,
		DIAG_DIABETES.hadm_id,
		diabetes_seq_num,
		diabetes_title,
		cad_seq_num,
		cad_title
)

SELECT
	subject_id,
	hadm_id,
	diabetes_seq_num,
	diabetes_icd_code,
	hp_seq_num,
	hp_icd_code,
	cad_seq_num,
	cad_icd_code
FROM
	DIAG_TOTAL
)