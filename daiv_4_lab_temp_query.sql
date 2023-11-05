DROP TABLE IF EXISTS mimiciv_hosp.daiv_lab_temp;

CREATE TABLE mimiciv_hosp.daiv_lab_temp AS (

WITH backbone AS(
	SELECT
		*
	FROM
		mimiciv_hosp.daiv_backbone
),

lab_info AS(
	SELECT
		lab_.*,
		d_lab_.label,
		d_lab_.fluid,
		d_lab_.category
	FROM
		mimiciv_hosp.labevents AS lab_
	LEFT OUTER JOIN
		mimiciv_hosp.d_labitems AS d_lab_
	ON
		lab_.itemid = d_lab_.itemid
)

SELECT
	lab.*
FROM
	backbone
LEFT OUTER JOIN
	lab_info AS lab
ON
	backbone.subject_id = lab.subject_id
	AND
	backbone.hadm_id = lab.hadm_id
)