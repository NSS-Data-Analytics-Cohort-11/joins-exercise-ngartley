-- Question 1 - Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT specs.film_title, specs.release_year, revenue.worldwide_gross
FROM specs
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
ORDER BY revenue.worldwide_gross

-- Answer: Semi-Tough, 1977, 37187139

-- Question 2 - What year has the highest average imdb rating?

SELECT DISTINCT specs.release_year, AVG(rating.imdb_rating) AS avg_imdb_rating
FROM specs
INNER JOIN rating
ON specs.movie_id = rating.movie_id
GROUP BY specs.release_year
ORDER BY avg_imdb_rating DESC

-- Answer: 1991

-- Question 3 - What is the highest grossing G-rated movie? Which company distributed it?

SELECT specs.film_title, specs.mpaa_rating, revenue.worldwide_gross, distributors.company_name
FROM revenue
INNER JOIN specs
	ON revenue.movie_id = specs.movie_id
INNER JOIN distributors
	ON specs.domestic_distributor_id = distributors.distributor_id
WHERE specs.mpaa_rating = 'G'
ORDER BY revenue.worldwide_gross DESC

-- Answer: Toy Story 4 from Walt Disney

-- Question 4 - Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT distributors.company_name, COUNT(specs.film_title) AS film_count
FROM specs
FULL JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
GROUP BY distributors.company_name
ORDER BY film_count DESC

-- Question 5 - Write a query that returns the five distributors with the highest average movie budget.

SELECT distributors.company_name, AVG(revenue.film_budget) AS avg_film_budget
FROM distributors
INNER JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
LEFT JOIN revenue
	ON specs.movie_id = revenue.movie_id
WHERE revenue.film_budget IS NOT NULL
GROUP BY distributors.company_name
ORDER BY avg_film_budget DESC
LIMIT 5;

-- Question 6 - How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT specs.film_title, rating.imdb_rating
FROM distributors
LEFT JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
LEFT JOIN rating
	ON specs.movie_id = rating.movie_id
WHERE distributors.headquarters NOT ilike '%CA'
	AND specs.film_title IS NOT NULL
ORDER BY rating.imdb_rating DESC

-- Answer: 2. Dirty Dancing has the highest IMDB rating of 7.

-- Question 7 - Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT
CASE
	WHEN length_in_min >= 120 THEN '>2 Hours'
	ELSE '<2 Hours'
END AS lengthtext, ROUND(avg(imdb_rating), 2) AS avg_rating
FROM specs
INNER JOIN rating
USING (movie_id)
GROUP BY lengthtext
ORDER BY avg_rating DESC;

