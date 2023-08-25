-- How many rentals and how much money does each store bring in?   --
SELECT s.store_id, 
COUNT(r.rental_id) AS number_of_rentals,
SUM(p.amount) AS total_payment_amount
FROM payment AS p
LEFT JOIN rental AS r
ON p.rental_id = r.rental_id
LEFT JOIN inventory AS i
ON r.inventory_id = i.inventory_id
LEFT JOIN store AS s
ON i.store_id = s.store_id
WHERE s.store_id IS NOT NULL
GROUP BY s.store_id
ORDER BY total_payment_amount DESC
LIMIT 10;

-- What are the summary statistics on our payments? -- 
SELECT MIN(amount) AS lowest_payment,
       AVG(amount) AS average_payment,
       MAX(amount) AS highest_payment,
       stddev(amount) AS standard_deviation
FROM payment;

-- Who are the customers who spend the most? --
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS full_name,
       a.postal_code,
       SUM(p.amount) AS amount_spent
FROM customer AS c
LEFT JOIN payment AS p
ON c.customer_id = p.customer_id
LEFT JOIN address AS a
ON c.address_id=a.address_id
GROUP BY customer_id
ORDER BY amount_spent DESC
LIMIT 20;

-- Which postal codes have the most rentals and payements? -- 
SELECT a.postal_code, c.create_date,
sum(p.amount) AS total_payments_collected,
count(*) AS total_rentals
FROM address AS a
LEFT JOIN customer AS c 
ON a.address_id = c.address_id
LEFT JOIN payment AS p
ON c.customer_id=p.customer_id
WHERE a.postal_code IS NOT NULL
      AND c.create_date IS NOT NULL
GROUP BY a.postal_code
ORDER BY total_payments_collected DESC
LIMIT 15;

-- What districts have the most payments and rentals? --
SELECT a.district, c.create_date,
sum(p.amount) AS total_payments_collected,
count(*) AS total_rentals
FROM address AS a
LEFT JOIN customer AS c 
ON a.address_id = c.address_id
LEFT JOIN payment AS p
ON c.customer_id=p.customer_id
WHERE a.postal_code IS NOT NULL
      AND c.create_date IS NOT NULL
GROUP BY a.district
ORDER BY total_payments_collected DESC
LIMIT 15;

-- Which districts did the first customers come from and are they still active--
SELECT a.district, c.create_date, c.active
FROM address AS a
LEFT JOIN store AS s
ON a.address_id = s.address_id
LEFT JOIN customer as c 
ON s.store_id = c.store_id
WHERE create_date IS NOT NULL
GROUP BY a.district
ORDER BY c.create_date
LIMIT 20;

-- What are the most popular movies to rent --
SELECT f.title, 
       SUM(r.rental_id) AS number_of_rentals,
       f.rental_rate
FROM film AS f
LEFT JOIN inventory AS i
ON f.film_id = i.film_id
LEFT JOIN rental AS r
ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NOT NULL
GROUP BY f.title
ORDER BY number_of_rentals DESC
LIMIT 10;

-- What are the most popular genres in rentals --

SELECT c.name AS genre,
       COUNT(r.rental_id) AS number_of_rentals,
       ROUND(AVG(f.rental_rate), 2) AS average_rental_rate
FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
LEFT JOIN category AS c
ON fc.category_id = c.category_id 
LEFT JOIN inventory AS i
ON f.film_id = i.film_id
LEFT JOIN rental AS r
ON i.inventory_id = r.inventory_id 
WHERE c.name IS NOT NULL
GROUP BY genre
ORDER BY number_of_rentals DESC
LIMIT 20;

-- How many rentals does each rating have and how much have they made in payments --
SELECT f.rating,
       SUM(p.amount) AS payments_made,
       COUNT(r.rental_id) AS number_of_rentals
FROM film AS f
LEFT JOIN inventory AS i
ON f.film_id = i.film_id
LEFT JOIN rental AS r
ON i.inventory_id = r.inventory_id
LEFT JOIN payment AS p
ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY number_of_rentals DESC
LIMIT 10;

-- 
       

