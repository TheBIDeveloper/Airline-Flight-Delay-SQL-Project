USE FlightDelayAnalytics;
GO

--------------------------------------------------
-- 1. Total flights
--------------------------------------------------
SELECT COUNT(*) AS total_flights
FROM flights;

--------------------------------------------------
-- 2. Total delayed flights (departure or arrival > 0)
--------------------------------------------------
SELECT COUNT(*) AS delayed_flights
FROM flight_delays
WHERE departure_delay > 0 OR arrival_delay > 0;

--------------------------------------------------
-- 3. Average departure and arrival delay
--------------------------------------------------
SELECT AVG(departure_delay) AS avg_departure_delay,
       AVG(arrival_delay) AS avg_arrival_delay
FROM flight_delays;

--------------------------------------------------
-- 4. Delays by airline
--------------------------------------------------
SELECT a.airline_name,
       COUNT(f.flight_id) AS total_flights,
       SUM(fd.departure_delay + fd.arrival_delay) AS total_delay_minutes,
       AVG(fd.departure_delay + fd.arrival_delay) AS avg_delay_per_flight
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN flight_delays fd ON f.flight_id = fd.flight_id
GROUP BY a.airline_name
ORDER BY total_delay_minutes DESC;

--------------------------------------------------
-- 5. Delays by origin airport
--------------------------------------------------
SELECT ap.airport_name,
       COUNT(f.flight_id) AS total_flights,
       SUM(fd.departure_delay) AS total_departure_delay,
       AVG(fd.departure_delay) AS avg_departure_delay
FROM flights f
JOIN airports ap ON f.origin_airport_id = ap.airport_id
JOIN flight_delays fd ON f.flight_id = fd.flight_id
GROUP BY ap.airport_name
ORDER BY total_departure_delay DESC;

--------------------------------------------------
-- 6. Delays by destination airport
--------------------------------------------------
SELECT ap.airport_name,
       COUNT(f.flight_id) AS total_flights,
       SUM(fd.arrival_delay) AS total_arrival_delay,
       AVG(fd.arrival_delay) AS avg_arrival_delay
FROM flights f
JOIN airports ap ON f.dest_airport_id = ap.airport_id
JOIN flight_delays fd ON f.flight_id = fd.flight_id
GROUP BY ap.airport_name
ORDER BY total_arrival_delay DESC;

--------------------------------------------------
-- 7. Delays by day of week
--------------------------------------------------
SELECT DATENAME(WEEKDAY, f.flight_date) AS day_of_week,
       COUNT(f.flight_id) AS total_flights,
       SUM(fd.departure_delay + fd.arrival_delay) AS total_delay
FROM flights f
JOIN flight_delays fd ON f.flight_id = fd.flight_id
GROUP BY DATENAME(WEEKDAY, f.flight_date)
ORDER BY total_delay DESC;

--------------------------------------------------
-- 8. Flights with highest delays
--------------------------------------------------
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

--------------------------------------------------
-- 9. Total cancellations
--------------------------------------------------
SELECT COUNT(*) AS total_cancellations
FROM flights
WHERE cancelled = 1;

--------------------------------------------------
-- 10. Average delay per route (origin → destination)
--------------------------------------------------
SELECT ap1.airport_name AS origin,
       ap2.airport_name AS destination,
       AVG(fd.departure_delay + fd.arrival_delay) AS avg_total_delay
FROM flights f
JOIN airports ap1 ON f.origin_airport_id = ap1.airport_id
JOIN airports ap2 ON f.dest_airport_id = ap2.airport_id
JOIN flight_delays fd ON f.flight_id = fd.flight_id
GROUP BY ap1.airport_name, ap2.airport_name
ORDER BY avg_total_delay DESC;
