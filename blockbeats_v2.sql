USE blockbeats_v2;

-- User table
CREATE TABLE User (
    UserID INT PRIMARY KEY,
    Name VARCHAR(255),
    Username VARCHAR(255),
    Email VARCHAR(255),
    RegistrationDate DATE,
    Country VARCHAR(255),
    Age INT
);

-- Artist table
CREATE TABLE Artist (
    ArtistID INT PRIMARY KEY,
    Name VARCHAR(255),
    Genre VARCHAR(255),
    Country VARCHAR(255),
    Age INT,
    UserID INT,
    Username VARCHAR(255),
    Email VARCHAR(255),
    RegistrationDate DATE
);

-- Non-Artist table
CREATE TABLE NonArtist (
    NonArtistID INT PRIMARY KEY,
    Name VARCHAR(255),
    Country VARCHAR(255),
    Age INT,
    UserID INT,
    Username VARCHAR(255),
    Email VARCHAR(255),
    RegistrationDate DATE
);

-- Album table
CREATE TABLE Album (
    AlbumID INT PRIMARY KEY,
    Title VARCHAR(255),
    ReleaseDate DATE,
    Genre VARCHAR(255),
    ArtistID INT
);

-- Song table
CREATE TABLE Song (
    SongID INT PRIMARY KEY,
    Title VARCHAR(255),
    Duration INT,
    ReleaseDate DATE,
    ArtistID INT,
    AlbumID INT
);

-- Playlist table
CREATE TABLE Playlist (
    PlaylistID INT PRIMARY KEY,
    Title VARCHAR(255),
    Description TEXT,
    CreationDate DATE,
    UserID INT
);

-- PlaylistSongs table
CREATE TABLE PlaylistSongs (
    PlaylistID INT,
    SongID INT,
    PRIMARY KEY (PlaylistID, SongID)
);

-- ListeningHistory table
CREATE TABLE ListeningHistory (
    HistoryID INT PRIMARY KEY,
    UserID INT,
    SongID INT,
    Timestamp DATETIME
);

-- Revenue table
CREATE TABLE Revenue (
    TransactionID INT PRIMARY KEY,
    Source VARCHAR(255),
    Date DATE,
    Amount DECIMAL(10, 2),
    UserID INT
);

-- BlockchainTransactions table
CREATE TABLE BlockchainTransactions (
    TransactionID INT PRIMARY KEY,
    Amount DECIMAL(10, 2),
    Timestamp DATETIME,
    UserID INT,
    ArtistID INT
);

-- ArtistEarnings table
CREATE TABLE ArtistEarnings (
    ArtistID INT,
    TransactionID INT,
    Amount DECIMAL(10, 2),
    Timestamp DATETIME,
    PRIMARY KEY (ArtistID, TransactionID)
);

-- Adding foreign keys

ALTER TABLE Artist ADD CONSTRAINT FK_Artist_User FOREIGN KEY (UserID) REFERENCES User(UserID);
ALTER TABLE NonArtist ADD CONSTRAINT FK_NonArtist_User FOREIGN KEY (UserID) REFERENCES User(UserID);
ALTER TABLE Album ADD CONSTRAINT FK_Album_Artist FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID);
ALTER TABLE Song ADD CONSTRAINT FK_Song_Artist FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID);
ALTER TABLE Song ADD CONSTRAINT FK_Song_Album FOREIGN KEY (AlbumID) REFERENCES Album(AlbumID);
ALTER TABLE Playlist ADD CONSTRAINT FK_Playlist_User FOREIGN KEY (UserID) REFERENCES User(UserID);
ALTER TABLE PlaylistSongs ADD CONSTRAINT FK_PlaylistSongs_Playlist FOREIGN KEY (PlaylistID) REFERENCES Playlist(PlaylistID);
ALTER TABLE PlaylistSongs ADD CONSTRAINT FK_PlaylistSongs_Song FOREIGN KEY (SongID) REFERENCES Song(SongID);
ALTER TABLE ListeningHistory ADD CONSTRAINT FK_ListeningHistory_User FOREIGN KEY (UserID) REFERENCES User(UserID);
ALTER TABLE ListeningHistory ADD CONSTRAINT FK_ListeningHistory_Song FOREIGN KEY (SongID) REFERENCES Song(SongID);
ALTER TABLE Revenue ADD CONSTRAINT FK_Revenue_User FOREIGN KEY (UserID) REFERENCES User(UserID);
ALTER TABLE BlockchainTransactions ADD CONSTRAINT FK_BlockchainTransactions_User FOREIGN KEY (UserID) REFERENCES User(UserID);
ALTER TABLE BlockchainTransactions ADD CONSTRAINT FK_BlockchainTransactions_Artist FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID);
ALTER TABLE ArtistEarnings ADD CONSTRAINT FK_ArtistEarnings_Artist FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID);
ALTER TABLE ArtistEarnings ADD CONSTRAINT FK_ArtistEarnings_Transaction FOREIGN KEY (TransactionID) REFERENCES BlockchainTransactions(TransactionID);