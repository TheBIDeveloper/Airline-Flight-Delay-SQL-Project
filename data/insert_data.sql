USE FlightDelayAnalytics;
GO

-- Airlines
INSERT INTO airlines VALUES
(1, 'Air India'),
(2, 'IndiGo'),
(3, 'SpiceJet'),
(4, 'GoAir'),
(5, 'Vistara');

-- Airports
INSERT INTO airports VALUES
(101, 'Chhatrapati Shivaji International', 'Mumbai', 'Maharashtra'),
(102, 'Indira Gandhi International', 'Delhi', 'Delhi'),
(103, 'Kempegowda International', 'Bangalore', 'Karnataka'),
(104, 'Rajiv Gandhi International', 'Hyderabad', 'Telangana'),
(105, 'Chennai International', 'Chennai', 'Tamil Nadu');

-- Flights
INSERT INTO flights VALUES
(1001, 1, 101, 102, '2024-01-01', '06:00', '08:00', '06:15', '08:10', 0),
(1002, 2, 102, 103, '2024-01-02', '09:00', '11:30', '09:05', '11:50', 0),
(1003, 3, 103, 104, '2024-01-03', '12:00', '14:00', '12:30', '14:25', 0),
(1004, 4, 104, 105, '2024-01-04', '15:00', '17:00', '15:00', '17:05', 0),
(1005, 5, 105, 101, '2024-01-05', '18:00', '20:00', '18:45', '20:40', 0);

-- Flight Delays
INSERT INTO flight_delays VALUES
(2001, 1001, 15, 10, 'Weather'),
(2002, 1002, 5, 20, 'Technical'),
(2003, 1003, 30, 25, 'Crew'),
(2004, 1004, 0, 5, 'Operational'),
(2005, 1005, 45, 40, 'Weather');
