-- Airline Flight Delay Project
-- Table Creation Script (SQL Server)

CREATE DATABASE FlightDelayAnalytics;
GO

USE FlightDelayAnalytics;
GO

-- Airlines table
CREATE TABLE airlines (
    airline_id INT PRIMARY KEY,
    airline_name VARCHAR(100)
);

-- Airports table
CREATE TABLE airports (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50)
);

-- Flights table
CREATE TABLE flights (
    flight_id INT PRIMARY KEY,
    airline_id INT,
    origin_airport_id INT,
    dest_airport_id INT,
    flight_date DATE,
    scheduled_departure TIME,
    scheduled_arrival TIME,
    actual_departure TIME,
    actual_arrival TIME,
    cancelled BIT,
    CONSTRAINT fk_flights_airline FOREIGN KEY (airline_id) REFERENCES airlines(airline_id),
    CONSTRAINT fk_flights_origin FOREIGN KEY (origin_airport_id) REFERENCES airports(airport_id),
    CONSTRAINT fk_flights_dest FOREIGN KEY (dest_airport_id) REFERENCES airports(airport_id)
);

-- Flight delays table
CREATE TABLE flight_delays (
    delay_id INT PRIMARY KEY,
    flight_id INT,
    departure_delay INT, -- in minutes
    arrival_delay INT,   -- in minutes
    delay_cause VARCHAR(50),
    CONSTRAINT fk_delay_flight FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);
