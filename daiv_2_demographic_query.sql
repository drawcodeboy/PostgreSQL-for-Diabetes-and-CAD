DROP TABLE IF EXISTS mimiciv_hosp.daiv_demographic;

CREATE TABLE mimiciv_hosp.daiv_demographic AS (

WITH backbone AS(
	SELECT
		*
	FROM
		mimiciv_hosp.daiv_backbone
),

patient_info AS(
	-- the age of a patient = admission time - anchor_year + anchor_age
	-- from github
	SELECT
		ad.subject_id
		, ad.hadm_id
		, ad.admittime
		, pa.anchor_age
		, pa.anchor_year
		, pa.anchor_age + EXTRACT(YEAR FROM AGE(ad.admittime, make_timestamp(pa.anchor_year, 1, 1, 0, 0, 0)))::smallint AS age
		, pa.gender
		, ad.race
	FROM mimiciv_hosp.admissions ad
	INNER JOIN mimiciv_hosp.patients pa
		ON ad.subject_id = pa.subject_id
)

SELECT
	backbone.subject_id,
	backbone.hadm_id,
	patient_info.age,
	patient_info.gender,
	patient_info.race
FROM
	backbone
INNER JOIN
	patient_info
ON
	backbone.subject_id = patient_info.subject_id
	AND
	backbone.hadm_id = patient_info.hadm_id
)