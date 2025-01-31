-- create alle tabellen

create table Besucher ( 
    Kundennr INTEGER generated by default as identity PRIMARY KEY, --auto incr
    Email VARCHAR(225) NOT NULL UNIQUE,
    Vorname VARCHAR(50) NOT NULL,
    Nachname VARCHAR(50) NOT NULL
);

create SEQUENCE Mitarbeiter_seq START WITH 1 INCREMENT BY 1;

create table Mitarbeiter ( 
    Personalnr INTEGER PRIMARY KEY, 
    MitarbeiterPosition VARCHAR(50) NOT NULL, 
    Arbeitsplan VARCHAR(225), 
    Gehalt NUMERIC(10, 2) CHECK (Gehalt >= 0) , 
    Vorname VARCHAR(50) NOT NULL,
    Nachname VARCHAR(50) NOT NULL
);
-- trigger vor neuer reihe
create TRIGGER Mitarbeiter_before
BEFORE INSERT ON Mitarbeiter 
FOR EACH ROW
WHEN (new.Personalnr IS NULL) 
BEGIN
    SELECT Mitarbeiter_seq.nextval INTO :New.Personalnr FROM dual; 
END; 
/ 

create table Film (
    FilmID INTEGER PRIMARY KEY,
    Genre VARCHAR(50),
    Titel VARCHAR(100) NOT NULL,
    Laufzeit INTEGER,
    Jahr INTEGER
);

create table Saal ( 
    Saalnr  INTEGER PRIMARY KEY,
    Ausstattung VARCHAR(225),
    Kapazitaet INTEGER NOT NULL CHECK (Kapazitaet > 0)
);

create table Ticket ( 
    Belegnr INTEGER PRIMARY KEY, 
    Ticketanzahl INTEGER NOT NULL CHECK (Ticketanzahl > 0),
    Zeitpunkt TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    Preis NUMERIC(10, 2) NOT NULL CHECK (Preis >= 0),
    Personalnr INTEGER,
    FilmID INTEGER,
    FOREIGN KEY (Personalnr) REFERENCES Mitarbeiter(Personalnr) ON DELETE SET NULL,
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID) ON DELETE CASCADE
);

create table GezeigtIn (
    FilmID INTEGER,
    Saalnr INTEGER,
    PRIMARY KEY (FilmID, Saalnr),
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID) ON DELETE CASCADE,
    FOREIGN KEY (Saalnr) REFERENCES Saal(Saalnr) ON DELETE CASCADE
);

create table Platz (
    Reihe CHAR(1),
    Sitz INTEGER,
    Saalnr INTEGER,
    Reservierungsstatus VARCHAR(50) DEFAULT 'frei',
    PRIMARY KEY (Reihe, Sitz, Saalnr),
    FOREIGN KEY (Saalnr) REFERENCES Saal(Saalnr) ON DELETE CASCADE
);

create table Snack (
    SnackID INTEGER PRIMARY KEY,
    Preis NUMERIC(5, 2) NOT NULL CHECK (Preis >= 0)
);

create table Kauft (
    SnackID INTEGER,
    Belegnr INTEGER,
    Kundennr INTEGER,
    PRIMARY KEY (SnackID, Belegnr),
    FOREIGN KEY (SnackID) REFERENCES Snack(SnackID) ON DELETE CASCADE,
    FOREIGN KEY (Belegnr) REFERENCES Ticket(Belegnr) ON DELETE CASCADE,
    FOREIGN KEY (Kundennr) REFERENCES Besucher(Kundennr) ON DELETE CASCADE
);

-- views 

--tickets + personalnr und anzahl verkaufter tickets 
create view TicketVerkaufen AS
SELECT
    Personalnr,
    COUNT (*) AS AnzahlTicketVerkauft,
    SUM(Preis) AS GesamtEinnahmen
FROM Ticket
GROUP BY Personalnr
HAVING COUNT(*) > 1; 

-- inner join von besucher und kauft
create view BesucherKaeufe AS 
SELECT 
    B.Kundennr,
    B.Vorname,
    B.Nachname, 
    K.SnackID, 
    S.Preis AS SnackPreis 
FROM 
    Besucher B
INNER JOIN
    Kauft K ON B.Kundennr = K.Kundennr
INNER JOIN 
    Snack S ON K.SnackID = S.SnackID; 
    
--neuer procedure mit input film ID und output Film Titel

CREATE OR REPLACE PROCEDURE GetFilmTitle (
    p_FilmID IN INTEGER,
    p_Titel OUT VARCHAR
) AS
BEGIN
    SELECT Titel
    INTO p_Titel
    FROM Film
    WHERE FilmID = p_FilmID;
EXCEPTION
    WHEN NO_DATA_FOUND 
    THEN
        p_Titel := 'FILM TITEL NICHT GEFUNDEN!';
    WHEN OTHERS 
    THEN
        p_Titel := 'FEHLER!';
END;
/ 
-- neuer table um gehalt aenderung zu loggen

CREATE TABLE MitarbeiterGehaltLog (
    LogID INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Personalnr INTEGER,
    OldGehalt NUMERIC(10, 2),
    NewGehalt NUMERIC(10, 2),
    ChangeDate TIMESTAMP DEFAULT SYSTIMESTAMP,
    FOREIGN KEY (Personalnr) REFERENCES Mitarbeiter(Personalnr)
);


-- neuer trigger f�r log gehalt update 
CREATE OR REPLACE TRIGGER LogGehaltChange
AFTER UPDATE OF Gehalt ON Mitarbeiter
FOR EACH ROW
BEGIN
    INSERT INTO MitarbeiterGehaltLog (Personalnr, OldGehalt, NewGehalt, ChangeDate)
    VALUES (:OLD.Personalnr, :OLD.Gehalt, :NEW.Gehalt, SYSTIMESTAMP);
END;
/



