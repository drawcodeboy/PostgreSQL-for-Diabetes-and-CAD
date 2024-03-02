# Predictive Study on Coronary Artery Disease in Diabetic Patients using Machine Learning

### 머신 러닝을 활용한 당뇨병 환자의 관상 동맥 질환 모델 개발

<div align="center"><b>⭐ 2023년도 한국통신학회 추계종합학술발표회 학부생논문 ⭐</b></div>

- [Paper Link](./PAPER/머신러닝을%20활용한%20당뇨병%20환자의%20관상%20동맥%20질환%20모델%20개발.pdf)
- 해당 Repository는 <b>[머신 러닝을 활용한 당뇨병 환자의
  관상 동맥 질환 모델 개발]</b> 프로젝트를 위해서 필요한 데이터셋을 추출하기 위해 <b>PostgreSQL</b>을 활용하여 <b>MIMIC-IV Database</b>를 엔지니어링한 SQL 쿼리문을 업로드 해둔 Repository입니다.

## 📄 Project Description

<b>[Doby's Lab (BLOG): 머신 러닝을 활용한 당뇨병 환자의 관상 동맥 질환 모델 개발](https://draw-code-boy.tistory.com/578)</b>

## 📄 Query Description

- MIMIC-IV 내에서 **_hosp_** 스키마를 사용하였습니다.

---

### 1️⃣ daiv_1_backbone_query.sql

- **_based on TABLE_**
  - <code>dignoses_icd</code>
  - <code>d_icd_diagnoses</code>
- **당뇨병으로 진단받은 환자 중 CAD(관상 동맥 질환) 발병 유무**를 판단하기 위해 작업한 쿼리
- **첫 입원**에 대해서만 고려하도록 할 것
- 진단명은 MIMIC-IV에 사용된 **ICD-9, ICD-10**을 통해 분류
- **backbone query** 다음으로 작성된 모든 쿼리들은 backbone의 <code>subject_id, hadm_id</code>를 통해 <code>JOIN</code> 되도록하여 전체 데이터셋의 기반이 되기에 <code>backbone query</code>이라 이름을 지었습니다.

---

### 2️⃣ daiv_2_demographic_query.sql

- **_based on TABLE_**
  - <code>admissions</code>
  - <code>patients</code>
- 환자의 **나이, 성별, 인종** 데이터를 가져왔습니다.

---

### 3️⃣ daiv_3_omr_query.sql

- **_based on TABLE_**
  - <code>omr</code>
- 환자의 **BMI, 혈압(BP)** 데이터를 가져왔습니다.
- BP같은 경우에는 해당 프로젝트에서 중요한 feature가 될 것이라 예상하여 <b>수축기 혈압(Systolic BP), 이완기 혈압(Diastolic BP)</b>으로 나누어 추출하였습니다.
- **_Limitation_**
  - 해당 필드들을 측정한 시간들이 모호하기 때문에 <code>min, max, mean</code>으로 추출하였습니다.

---

### 4️⃣ daiv_4_lab_query.sql

- **_based on TABLE_**
  - <code>labevents</code>
  - <code>d_labitems</code>
- 해당 테이블은 <b>표본 검사</b>에 대한 테이블로 아래의 2가지 기준으로 표본 검사를 추출하였습니다.
- 또한, 사이즈가 엄청 크기 때문에 <b>datv_4_lab_temp.query</b>를 통해서 환자들에게 모든 검사 결과를 붙혀둔 뒤에 당뇨병 환자들만 우선적으로 뽑아 테이블을 만들어두고, 그 테이블을 다시 끌어와서 필요한 작업들을 했습니다.

1. 검사 수가 많은가 _(Count가 80,000번 이상)_
2. 관련 논문에서 *p-value*가 상당히 낮으며, 유의미한 값을 도출할 수 있는가

- **_Limitation_**
  - 해당 필드들을 측정한 시간들이 모호하기 때문에 <code>min, max, mean</code>으로 추출하였습니다.

---

### 5️⃣ daiv_5_drug_query.sql

- **_based on TABLE_**
  - <code>pharmacy</code>
- 환자가 <b>어떤 약물을 복용</b>했는가에 대한 데이터를 추출했습니다.
- 관련 논문과 데이터 분석 측면에서 약물을 고려하였습니다.
- 한 번이라도 복용한 경우 Y/N으로 나누어 추출하였습니다.
- <b>Loop Diuretic(이뇨제)</b>의 경우 Database에 존재하지 않았기 때문에 아래의 다른 5가지 이뇨제 약물로 대체하였습니다.
  - <b>Spironolactone</b>
  - <b>Bumetanide</b>
  - <b>Torsemide</b>
  - <b>Furosemide</b>
  - <b>Metolazone</b>

---

### 6️⃣ daiv_6_dataset_query.sql

- 위의 <b>5가지 쿼리</b>로부터 임시 테이블을 만들어 <b>최종적인 데이터셋</b>을 추출하는 쿼리입니다.
- 많은 부분을 고려하기 위해 <code>SELECT</code>에서 모든 feature를 각각 작성하였습니다.
- 최종적인 데이터셋은 Imbalanced Data로 이러한 문제를 해결할 수 있게 언더샘플링 기반 기술들을 사용하였습니다.
- 오버샘플링이 아닌 언더샘플링인 이유는 오버샘플링을 할 경우, 기존에 없는 데이터를 학습시켜 모델링을 하는 것이기 때문에 연구의 의미가 퇴색되기 때문입니다.

---

## ✅ RESULT

- 총 당뇨병 환자: 19,400명
- CAD 환자: 3,929명
- No CAD 환자: 15,471명
- 39개의 feature
- Imbalanced Data
