USE blockbeats_v2;

-- Query 1: Select all Artists over 25
SELECT * FROM Artist
WHERE Age > 25;

-- Query 2: Which 5 countries has the most users and generates the most revenue?

SELECT u.Country, COUNT(u.UserID) AS UserCount, SUM(r.Amount) AS TotalRevenue
FROM User u
INNER JOIN Revenue r ON u.UserID = r.UserID
GROUP BY u.Country
ORDER BY UserCount DESC, TotalRevenue DESC
LIMIT 5;

-- Query 3: Identify artists with the highest earnings from blockchain transactions

SELECT a.Name AS ArtistName, SUM(ae.Amount) AS TotalEarnings
FROM ArtistEarnings ae
JOIN Artist a ON ae.ArtistID = a.ArtistID
GROUP BY a.ArtistID, a.Name
ORDER BY TotalEarnings DESC;

-- Query 4: Find artist with the highest total earnings

WITH ArtistTotalEarnings AS (
    SELECT a.ArtistID, a.Name, SUM(ae.Amount) AS TotalEarnings
    FROM Artist a
    JOIN ArtistEarnings ae ON a.ArtistID = ae.ArtistID
    GROUP BY a.ArtistID, a.Name
)
SELECT ArtistID, Name, TotalEarnings
FROM ArtistTotalEarnings
WHERE TotalEarnings = (SELECT MAX(TotalEarnings) FROM ArtistTotalEarnings);


-- Query 5: List the top 10 most listened-to songs along with their artists

SELECT s.Title AS SongTitle, 
       a.Name AS ArtistName, 
       (SELECT COUNT(*) 
        FROM ListeningHistory lh 
        WHERE s.SongID = lh.SongID) AS ListenCount
FROM Song s
JOIN Artist a ON s.ArtistID = a.ArtistID
ORDER BY ListenCount DESC
LIMIT 10;

-- Query 6: Calculate the total revenue generated each month from each source of revenue

SELECT Source, EXTRACT(MONTH FROM Date) AS MonthNumber, 
       MONTHNAME(Date) AS MonthName, 
       SUM(Amount) AS TotalRevenue
FROM Revenue
WHERE Source IN ('Subscription', 'Advertising', 'Blockchain')
GROUP BY Source, EXTRACT(MONTH FROM Date), MONTHNAME(Date)
ORDER BY TotalRevenue DESC;

-- Query 7: Find users who have revenue transactions exceeding the average revenue amount

SELECT DISTINCT UserID, Name
FROM User
WHERE UserID = ANY (
    SELECT UserID
    FROM Revenue
    GROUP BY UserID
    HAVING AVG(Amount) > (SELECT AVG(Amount) FROM Revenue)
);

-- Query 8: Find artists that have recorded songs but not albums

SELECT DISTINCT a.Name AS ArtistName
FROM Artist a
JOIN Song s ON a.ArtistID = s.ArtistID
WHERE NOT EXISTS (
    SELECT 1
    FROM Album al
    WHERE al.ArtistID = a.ArtistID
);

-- Query 9: Select all songs that have duration of higher than 120 seconds with their along with their corresponding playlist name and playlist ID 

SELECT s.*, p.Title AS PlaylistName, p.PlaylistID
FROM Song s
LEFT JOIN PlaylistSongs ps ON s.SongID = ps.SongID
LEFT JOIN Playlist p ON ps.PlaylistID = p.PlaylistID
LEFT JOIN Artist a ON s.ArtistID = a.ArtistID
WHERE s.Duration > 120;

-- Query 10: To combine songs from the playlist with the most songs and playlist 122

-- Songs from the playlist with the most songs
SELECT ps.SongID, s.Title
FROM PlaylistSongs ps
JOIN (
    SELECT PlaylistID
    FROM PlaylistSongs
    GROUP BY PlaylistID
    ORDER BY COUNT(SongID) DESC
    LIMIT 1
) AS max_playlist ON ps.PlaylistID = max_playlist.PlaylistID
JOIN Song s ON ps.SongID = s.SongID

UNION

-- Songs from playlist 122
SELECT s.SongID, s.Title
FROM Song s
JOIN PlaylistSongs ps ON s.SongID = ps.SongID
WHERE ps.PlaylistID = 122;
