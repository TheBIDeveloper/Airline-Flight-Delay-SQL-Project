USE FlightDelayAnalytics;
GO

-- 11. Running total of delays per airline
SELECT a.airline_name,
       f.flight_date,
       SUM(fd.departure_delay + fd.arrival_delay) OVER(PARTITION BY a.airline_name ORDER BY f.flight_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_delay_minutes
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN flight_delays fd ON f.flight_id = fd.flight_id
ORDER BY a.airline_name, f.flight_date;

-- 12. Rank airlines by total delay
SELECT a.airline_name,
       SUM(fd.departure_delay + fd.arrival_delay) AS total_delay_minutes,
       RANK() OVER(ORDER BY SUM(fd.departure_delay + fd.arrival_delay) DESC) AS airline_rank
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN flight_delays fd ON f.flight_id = fd.flight_id
GROUP BY a.airline_name
ORDER BY airline_rank;

-- 13. Rank routes by average delay
SELECT ap1.airport_name AS origin,
       ap2.airport_name AS destination,
       AVG(fd.departure_delay + fd.arrival_delay) AS avg_total_delay,
       RANK() OVER(ORDER BY AVG(fd.departure_delay + fd.arrival_delay) DESC) AS route_rank
FROM flights f
JOIN airports ap1 ON f.origin_airport_id = ap1.airport_id
JOIN airports ap2 ON f.dest_airport_id = ap2.airport_id
JOIN flight_delays fd ON f.flight_id = fd.flight_id
GROUP BY ap1.airport_name, ap2.airport_name
ORDER BY route_rank;

-- 14. Cumulative delays over time
SELECT f.flight_date,
       SUM(fd.departure_delay + fd.arrival_delay) OVER(ORDER BY f.flight_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_delay_minutes
FROM flights f
JOIN flight_delays fd ON f.flight_id = fd.flight_id
ORDER BY f.flight_date;

-- 15. Top delayed flights
SELECT TOP 5 f.flight_id,
       a.airline_name,
       ap1.airport_name AS origin,
       ap2.airport_name AS destination,
       fd.departure_delay,
       fd.arrival_delay,
       fd.delay_cause
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN airports ap1 ON f.origin_airport_id = ap1.airport_id
JOIN airports ap2 ON f.dest_airport_id = ap2.airport_id
JOIN flight_delays fd ON f.flight_id = fd.flight_id
ORDER BY (fd.departure_delay + fd.arrival_delay) DESC;
