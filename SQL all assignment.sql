-- DSQ 2006 Week-1 assignment
-- Question 1) Find the actors who played a role in the movie 'Annie IDENTITY'. and return all the field of actor table.

-- Answer)
SELECT * FROM actor AS a
JOIN film_actor AS fa
ON  a.actor_id=fa.actor_id
JOIN film as f
ON fa.film_id=f.film_id
WHERE title='Annie IDENTITY';

-- Question 2) Find the customer who have the highest CustomerID and first name starts with 'E' and addressID lower than 500

-- Answer)
WITH tb1 AS (SELECT c.customer_id AS customer_id,c.first_name AS first_name,c.last_name AS last_name FROM customer AS c
JOIN address AS a
ON c.address_id=a.address_id
WHERE first_name LIKE 'E%' AND 
      a.address_id <500)
SELECT customer_id,first_name,last_name
FROM tb1
WHERE customer_id IN (SELECT MAX(customer_id)
						FROM tb1);


-- Question 3) Find the films which are rented by both Indian and Pakistani customer.

-- Answer)
WITH tb1 AS(
SELECT r.customer_id AS customer_id,
	   cus.first_name AS first_name,
       cus.last_name AS last_name,
       ad.address_id AS address_id,
       ci.city_id AS city_id,
       ctry.country_id AS country_id,
       ctry.country AS country,
       inv.inventory_id AS inventory_id,
       f.film_id AS film_id,
       f.title AS title
FROM rental AS r
JOIN customer AS cus 
ON cus.customer_id=r.customer_id
JOIN address AS ad 
ON cus.address_id=ad.address_id
JOIN city AS ci 
ON ad.city_id=ci.city_id
JOIN country AS ctry 
ON ci.country_id=ctry.country_id 
JOIN inventory AS inv
ON r.inventory_id=inv.inventory_id
JOIN film AS f
ON inv.film_id=f.film_id),
ind_cust AS (SELECT film_id,title
             FROM tb1
             WHERE country='INDIA'),
pak_cust AS (SELECT film_id,title
             FROM tb1
             WHERE country='pakistan')
 SELECT DISTINCT ind_cust.title 
 FROM ind_cust 
 JOIN pak_cust
 ON ind_cust.film_id=pak_cust.film_id;
 
-- Question 4) Films which are rented by Indian customer and not rented ny pakistan customer.
  
-- Answer
 WITH tb1 AS(
SELECT r.customer_id AS customer_id,
	   cus.first_name AS first_name,
       cus.last_name AS last_name,
       ad.address_id AS address_id,
       ci.city_id AS city_id,
       ctry.country_id AS country_id,
       ctry.country AS country,
       inv.inventory_id AS inventory_id,
       f.film_id AS film_id,
       f.title AS title
FROM rental AS r
JOIN customer AS cus 
ON cus.customer_id=r.customer_id
JOIN address AS ad 
ON cus.address_id=ad.address_id
JOIN city AS ci 
ON ad.city_id=ci.city_id
JOIN country AS ctry 
ON ci.country_id=ctry.country_id 
JOIN inventory AS inv
ON r.inventory_id=inv.inventory_id
JOIN film AS f
ON inv.film_id=f.film_id),
ind_cust AS (SELECT film_id,title
             FROM tb1
             WHERE country='INDIA'),
pak_cust AS (SELECT film_id,title
             FROM tb1
             WHERE country='pakistan')
 SELECT DISTINCT ind_cust.title 
 FROM ind_cust 
 LEFT JOIN pak_cust
 ON ind_cust.film_id=pak_cust.film_id
 WHERE pak_cust.film_id IS NULL;

-- Question 5) Customers who paid a sum of 100 dollars or more, for all the rentals taken by them

--  Answer
SELECT p.customer_id,c.first_name,c.last_name,SUM(p.amount) AS total_amt
FROM payment AS p
JOIN customer AS c
ON p.customer_id=c.customer_id
GROUP BY p.customer_id
HAVING total_amt >=100
ORDER BY total_amt DESC;

-- DSQ 2006 Week-2 assignment
-- Question 1) Define Normalization and its three forms.

-- Answer)
-- Definition
-- 		It is a process of organizing the data in a database.
-- 		It is used to reduce redundancy/repeat values,
-- 		which eliminates insertion,update,deletion anomalies.a
-- Different forms of Normalization
--   1NF: Each attribute should contain one value AND Each attribute contains atomic value which cannot be split further.
--   2NF: Should be 1NF AND no partial dependency
--   3NF: Should be 2NF AND remove unnecessary kind of dependency

-- Question 2) Create a view which group all the films by their rating.
SELECT * FROM film;
CREATE VIEW grp_rtg AS (SELECT rating,COUNT(title)
					    FROM film
                        GROUP BY rating
						);
                        
-- Question 3) Create a view definition which computes the total payment made by all the customers grped by country. print least paid country.


WITH tb1 AS (SELECT ct.country AS country,SUM(p.amount) AS amountpaid
FROM customer AS c
JOIN address AS a
ON c.address_id=a.address_id
JOIN city As ci
ON a.city_id=ci.city_id
JOIN country AS ct
ON ci.country_id=ct.country_id
JOIN payment AS p
ON c.customer_id=p.customer_id
GROUP BY ct.country
ORDER BY SUM(p.amount))
SELECT * FROM tb1
WHERE amountpaid IN (SELECT MIN(amountpaid)
FROM tb1);


-- Question 4) Using Stored procedure, print the series 0,2,4,6,8,1
CALL evennumber(10);

-- Question 5) Using Stored procedure,input film rating which gives number of films with this rating.
CALL film_rating('pg');


-- DSQ 1004 Week-1 assignment

-- Question 1) Find salary of all the employees
SELECT * FROM employees;

-- Question 2) All the job designations of employees and job name.
USE dsq1004_week1; 
SELECT DISTINCT job_title FROM jobs;

-- Question 3(a)) Employees name and increase 15% there salary and add dollar in there salary.
SELECT * FROM employees;
SELECT first_name,last_name,CONCAT('$',' ' ,salary+15%(salary)) AS salary
FROM employees;

-- Question 3(b)) 
SELECT first_name,last_name,CONCAT('$',' ',(salary+15%(salary))*86) AS salary
FROM employees;

-- Question 4)Show employees's name and job id as 'Employees and job'
SELECT CONCAT(first_name,' ',last_name,' & ',job_id) 
FROM employees;

-- DSQ 1004 Week-2 assignment
USE dsq1004_week2;
-- Question 1)
-- Find actor name and role in the movie "Annie Hall"
SELECT a.act_fname,a.act_lname,mc.role
FROM movie AS m
JOIN movie_cast AS mc 
ON m.mov_id=mc.mov_id
JOIN actors AS a
ON a.act_id=mc.act_id
WHERE m.mov_title='Annie Hall';

-- Question 2) Find director who directed a movie and casted a role for 'Eye Wide Shut' needdirectors first and last name and movie name.

SELECT m.mov_title,d.dir_fname,d.dir_lname
FROM movie AS m
JOIN movie_direction AS md
ON m.mov_id=md.mov_id
JOIN director AS d
ON md.dir_id=d.dir_id
WHERE m.mov_title='Eyes wide shut';

-- Question 3) Find who directed the movie 'Sean Maguire'

SELECT m.mov_id,m.mov_title,md.dir_id,md.mov_id,d.dir_id,d.dir_fname,d.dir_lname
FROM movie AS m
JOIN movie_direction AS md
ON m.mov_id=md.mov_id
JOIN movie_cast AS mc
ON md.mov_id=mc.mov_id
JOIN director AS d
ON md.dir_id=d.dir_id
WHERE mc.role='Sean Maguire';

-- Question 4) Actor who have never acted in any movie between 1990 and 2000. return the actors fname,lname,movie title and release year.

SELECT a.act_fname,a.act_lname,m.mov_title,m.mov_year
FROM movie AS m
JOIN movie_cast AS mc
ON m.mov_id=mc.mov_id
JOIN actors AS a
ON mc.act_id=a.act_id
WHERE m.mov_year  NOT BETWEEN 1990 AND 2000;

	 
