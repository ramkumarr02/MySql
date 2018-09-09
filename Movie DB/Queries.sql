select * from movie;
select * from reviewer;
select * from rating; order by rid, mid;

-- Find the titles of all movies directed by Steven Spielberg
select title
from movie
where director = "Steven Spielberg";


-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order*/
select year
from movie
where mid in
  (select mid 
   from rating
   where stars = 4 or stars = 5)
order by year;


-- Find the titles of all movies that have no ratings
select title 
from movie 
where mID not in (select mid from rating);

-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
select name from reviewer 
where rid in (select rid from rating where ratingDate is null);

-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
select 
	name, 
    title, 
    stars, 
    ratingDate
from 
	reviewer, 
    movie, 
    rating
where
	movie.mid = rating.mid and
	rating.rid = reviewer.rid
order by 
	name,
	title,
	stars
; 

-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
select * from rating;

select 
	r1.mid, r1.rid, r1.stars, r2.mid, r2.rid, r2.stars
from 
	rating r1, rating r2
where 
	r1.mid = r2.mid and
    r1.rid = r2.rid and
    r1.stars < r2.stars;
	

select name, title
from reviewer rev, movie mov
where (mov.mid, rev.rid) in
  (select r1.mid, r1.rid
    from rating r1, rating r2
    where 
      r1.mid = r2.mid and
      r1.rid = r2.rid and
      r1.stars < r2.stars);

select name, title
from reviewer, movie
where (mid, rid) in
  (select r1.mid, r1.rid
    from rating r1, rating r2
    where 
      r1.mid = r2.mid and
      r1.rid = r2.rid and
      r1.ratingDate < r2.ratingDate and
      r1.stars < r2.stars);


select name, title
from reviewer rev, movie mov, 
	(select r1.mid, r1.rid
		from rating r1, rating r2
		where 
			r1.mid = r2.mid and
			r1.rid = r2.rid and
			r1.ratingDate < r2.ratingDate and
			r1.stars < r2.stars) a
where 
	mov.mid = a.mid and
    rev.rid = a.rid;

      
SELECT r.name, m.title
FROM movie m, reviewer r,
  (
    SELECT r1.rid, r1.mid
    FROM rating r1, rating r2
    WHERE r1.rid = r2.rid AND r1.mid = r2.mid
    AND r1.stars > r2.stars
    AND r1.ratingdate > r2.ratingdate
  ) AS a
WHERE m.mid = a.mid AND r.rid = a.rid;

-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 

select rid, movie.mid, title, stars
from rating r1, movie
where r1.mid = movie.mid and
r1.stars >=  all (select stars 
from rating, movie
where rating.mid = movie.mid and
rating.mid = r1.mid);

select * from rating join movie on movie.mid = rating.mid order by title;
select * from rating order by mid;
select * from movie;

select 
	distinct movie.mid, title, stars
from 
	rating r1, movie
where 
	r1.mid = movie.mid and 
    r1.stars <=  all (select stars 
						from rating
						where rating.mid = r1.mid)
order by movie.mid;

-------------------------------------------------------------------------------
select 
	distinct mid, title, high.stars, low.stars, (high.stars - low.stars) as Spread
from 
	(select 
		stars, movie.mid as hmid
	from 
		rating r1, movie
	where 
		r1.mid = movie.mid and 
		r1.stars >=  all (select stars 
							from rating
							where rating.mid = r1.mid)
	order by movie.mid) as high,        
	(select 
		stars, movie.mid as lmid
	from 
		rating r1, movie
	where 
		r1.mid = movie.mid and 
		r1.stars <=  all (select stars 
							from rating
							where rating.mid = r1.mid)
	order by movie.mid) as low,
    movie
where 
	movie.mid = hmid and
    hmid = lmid
order by mID
;

-------------------------------------------------------------------------------                       

select 
	distinct title, (high.stars - low.stars) as Spread
from 
	(select 
		stars, movie.mid as hmid
	from 
		rating r1, movie
	where 
		r1.mid = movie.mid and 
		r1.stars >=  all (select stars 
							from rating
							where rating.mid = r1.mid)
	order by movie.mid) as high,        
	(select 
		stars, movie.mid as lmid
	from 
		rating r1, movie
	where 
		r1.mid = movie.mid and 
		r1.stars <=  all (select stars 
							from rating
							where rating.mid = r1.mid)
	order by movie.mid) as low,
    movie
where 
	movie.mid = hmid and
    hmid = lmid
order by Spread desc, title
;


-- For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

select distinct title, stars
from rating, movie
where 
  movie.mid = rating.mid and
  (rating.mid, rid, stars) not in
    (select r2.mid, r2.rid, r2.stars
    from rating r1, rating r2
    where 
      r1.mid = r2.mid and
      r1.stars > r2.stars)
order by title;      


select name from reviewer where 
select distinct r1.rid, r2.rid
	from rating as r1, rating as r2
    where 
		r1.rid < r2.rid and
        r1.mid = r2.mid
;

