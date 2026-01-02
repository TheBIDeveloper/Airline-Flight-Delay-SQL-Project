USE FlightDelayAnalytics;
GO

-- 16. Average delay per day of week
SELECT DATENAME(WEEKDAY, f.flight_date) AS day_of_week,
       AVG(fd.departure_delay + fd.arrival_delay) AS avg_total_delay
FROM flights f
JOIN flight_delays fd ON f.flight_id = fd.flight_id
GROUP BY DATENAME(WEEKDAY, f.flight_date)
ORDER BY avg_total_delay DESC;

-- 17. Flights with delay above average
WITH avg_delay AS (
    SELECT AVG(departure_delay + arrival_delay) AS overall_avg_delay
    FROM flight_delays
)
SELECT f.flight_id,
       a.airline_name,
       fd.departure_delay,
       fd.arrival_delay,
       fd.delay_cause
FROM flights f
JOIN flight_delays fd ON f.flight_id = fd.flight_id
JOIN airlines a ON f.airline_id = a.airline_id
CROSS JOIN avg_delay
WHERE (fd.departure_delay + fd.arrival_delay) > overall_avg_delay
ORDER BY (fd.departure_delay + fd.arrival_delay) DESC;

-- 18. Top 3 airports by total delays
SELECT TOP 3 ap.airport_name,
       SUM(fd.departure_delay + fd.arrival_delay) AS total_delay
FROM flights f
JOIN airports ap ON f.origin_airport_id = ap.airport_id
JOIN flight_delays fd ON f.flight_id = fd.flight_id
GROUP BY ap.airport_name
ORDER BY total_delay DESC;

-- 19. Delay distribution by cause
SELECT delay_cause,
       COUNT(*) AS total_delays,
       SUM(departure_delay + arrival_delay) AS total_delay_minutes
FROM flight_delays
GROUP BY delay_cause
ORDER BY total_delay_minutes DESC;

-- 20. Flights with maximum cumulative delay per airline
WITH airline_flight_delay AS (
    SELECT f.flight_id,
           a.airline_name,
           (fd.departure_delay + fd.arrival_delay) AS total_delay
    FROM flights f
    JOIN airlines a ON f.airline_id = a.airline_id
    JOIN flight_delays fd ON f.flight_id = fd.flight_id
)
SELECT airline_name, flight_id, total_delay
FROM airline_flight_delay afd
WHERE total_delay = (SELECT MAX(total_delay) FROM airline_flight_delay afd2 WHERE afd2.airline_name = afd.airline_name)
ORDER BY airline_name;
