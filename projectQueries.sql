
-- query 1 
SELECT fi.title film_title, ca.name category_name, COUNT(*) 
FROM film fi
JOIN film_category fc
ON  fi.film_id = fc.film_id 
JOIN category ca
ON   fc.category_id = ca.category_id
JOIN inventory i
ON fi.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id
WHERE ca.name IN ('Animation','Children','Classics','Comedy','Family','Music')
GROUP BY 1,2 
ORDER BY 2,1 


-- query 2 
SELECT t1.name , t1.standard_quartile, COUNT(*)
FROM
  (SELECT fi.title, ca.name , 
   NTILE (4) OVER (ORDER BY fi.rental_duration) AS standard_quartile
   FROM film fi
   JOIN film_category fc
   ON  fi.film_id = fc.film_id 
   JOIN category ca
   ON   fc.category_id = ca.category_id
   WHERE ca.name IN ('Animation','Children','Classics','Comedy','Family','Music') )t1
GROUP BY 1,2
ORDER BY 1,2 ;


--query 3
SELECT DATE_PART('month',r.rental_date) AS rental_month, 
       DATE_PART('year',r.rental_date) AS rental_year,
	   s.store_id, 
	   COUNT (*) AS count_rentals
FROM store s
JOIN staff sf
ON s.store_id = sf.store_id
JOIN rental r
ON sf.staff_id = r.staff_id
GROUP BY 1,2,3
ORDER BY 4 DESC


-- query 4
 WITH top10 AS
 ( SELECT c.customer_id , SUM(p.amount) AS total 
    FROM customer c
	JOIN payment p 
	ON c.customer_id = p.customer_id 
    GROUP BY 1
	ORDER BY 2 DESC 
	LIMIT 10 
 )
 
SELECT DATE_TRUNC('month',payment_date) AS pay_mon, 
        (c.first_name ||' '|| c.last_name) AS full_name,
		COUNT(p.amount) AS pay_countpermon, 
		SUM(p.amount) pay_amount
FROM top10 t
JOIN customer c
ON t.customer_id = c.customer_id 
JOIN payment p
ON c.customer_id = p.customer_id 
WHERE payment_date BETWEEN '2007-01-01' AND '2007-12-31'
GROUP BY 1,2 
ORDER BY 2,1 









