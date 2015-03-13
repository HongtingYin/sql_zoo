-- Using Null


-- 1. List the teachers who have NULL for their department.

SELECT teacher.name
FROM teacher
WHERE dept IS NULL


-- 2. Note the INNER JOIN misses the teacher with no department and the department with no teacher.

SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id)


-- 3. Use a different JOIN so that all teachers are listed.

SELECT teacher.name, dept.name
FROM teacher LEFT JOIN dept ON teacher.dept = dept.id


-- 4. Use a different JOIN so that all departments are listed.

SELECT teacher.name, dept.name
FROM teacher RIGHT JOIN dept ON teacher.dept = dept.id


-- 5. Show teacher name and mobile number or '07986 444 2266'

SELECT teacher.name, COALESCE(teacher.mobile, '07986 444 2266')
FROM teacher


-- 6. Use the COALESCE function and a LEFT JOIN to print the name and department name. Use the string 'None' where there is no department.

SELECT teacher.name, COALESCE(dept.name, 'None')
FROM teacher LEFT JOIN dept ON teacher.dept = dept.id


-- 7. Use COUNT to show the number of teachers and the number of mobile phones.

SELECT COUNT(name), COUNT(mobile)
FROM teacher


-- 8. Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed.

SELECT dept.name, COUNT(teacher.name)
FROM teacher RIGHT JOIN dept ON teacher.dept = dept.id
GROUP BY dept.name


-- 9. Use CASE to show the name of each teacher followed by 'Sci' if the the teacher is in dept 1 or 2 and 'Art' otherwise.

SELECT teacher.name, CASE WHEN dept = 1 or dept = 2 THEN 'Sci' ELSE 'Art' END
FROM teacher


-- 10. Use CASE to show the name of each teacher followed by 'Sci' if the the teacher is in dept 1 or 2 show 'Art' if the dept is 3 and 'None' otherwise.

SELECT teacher.name,
  CASE
    WHEN dept = 1 OR dept = 2 THEN 'Sci'
    WHEN dept = 3 THEN 'Art'
    ELSE 'None'
  END
FROM teacher


-- Scottish Parliament


-- 1. One MSP was kicked out of the Labour party and has no party. Find him.

SELECT name
FROM msp
WHERE party IS NULL


-- 2. Obtain a list of all parties and leaders.

SELECT name, leader
FROM party


-- 3. Give the party and the leader for the parties which have leaders.

SELECT name, leader
FROM party
WHERE leader IS NOT NULL


-- 4. Obtain a list of all parties which have at least one MSP.

SELECT party.name
FROM party JOIN msp ON party.code = msp.party
GROUP BY party.name
HAVING COUNT(msp.name) >= 1


-- 5. Obtain a list of all MSPs by name, give the name of the MSP and the name of the party where available.

SELECT msp.name, party.name
FROM msp LEFT JOIN party ON msp.party = party.code
ORDER BY msp.name


-- 6. Obtain a list of parties which have MSPs, include the number of MSPs.

SELECT party.name, COUNT(*)
FROM msp JOIN party ON msp.party = party.code
GROUP BY party.name


-- 7. A list of parties with the number of MSPs; include parties with no MSPs.

SELECT party.name, COUNT(msp.name)
FROM party LEFT JOIN msp ON msp.party = party.code
GROUP BY party.name


-- NSS Tutorial


-- 1. Show the the percentage who STRONGLY AGREE

SELECT A_STRONGLY_AGREE
  FROM nss
 WHERE question='Q01'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'


-- 2. Show the institution and subject where the score is at least 100 for question 15.

SELECT institution, subject
  FROM nss
 WHERE question='Q15'
   AND score >= 100


-- 3. Show the institution and score where the score for '(8) Computer Science' is less than 50 for question 'Q15'

SELECT institution, score
  FROM nss
 WHERE question='Q15'
   AND score < 50
   AND subject='(8) Computer Science'


-- 4. Show the subject and total number of students who responded to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.

SELECT subject, SUM(response)
  FROM nss
 WHERE question='Q22'
   AND (subject='(8) Computer Science' OR subject='(H) Creative Arts and Design')
GROUP BY subject


-- 5. Show the subject and total number of students who A_STRONGLY_AGREE to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.

SELECT subject, SUM(response * A_STRONGLY_AGREE / 100)
  FROM nss
 WHERE question='Q22'
   AND (subject='(8) Computer Science' OR subject='(H) Creative Arts and Design')
GROUP BY subject


-- 6. Show the percentage of students who A_STRONGLY_AGREE to question 22 for the subject '(8) Computer Science' show the same figure for the subject '(H) Creative Arts and Design'.

SELECT subject, ROUND(SUM(response * A_STRONGLY_AGREE) / SUM(response))
  FROM nss
 WHERE question='Q22'
   AND (subject='(8) Computer Science' OR subject = '(H) Creative Arts and Design')
GROUP BY subject


-- 7. Show the average scores for question 'Q22' for each institution that include 'Manchester' in the name.

SELECT institution, ROUND(SUM(score * response) / SUM(response))
  FROM nss
 WHERE question='Q22'
   AND (institution LIKE '%Manchester%')
GROUP BY institution
ORDER BY institution


-- 8. Show the institution, the total sample size and the number of computing students for institutions in Manchester for 'Q01'.

SELECT institution, SUM(sample), SUM(CASE WHEN subject = '(8) Computer Science' THEN sample ELSE 0 END)
  FROM nss
 WHERE question='Q01'
   AND (institution LIKE '%Manchester%')
GROUP BY institution
