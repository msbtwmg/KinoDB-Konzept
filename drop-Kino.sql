DROP TABLE Kauft CASCADE CONSTRAINTS;

DROP TABLE Snack CASCADE CONSTRAINTS;

DROP TABLE Platz CASCADE CONSTRAINTS;

DROP TABLE GezeigtIn CASCADE CONSTRAINTS;

DROP TABLE Ticket CASCADE CONSTRAINTS;

DROP TABLE Saal CASCADE CONSTRAINTS;

DROP TABLE Film CASCADE CONSTRAINTS;

DROP TABLE Mitarbeiter CASCADE CONSTRAINTS;

DROP TABLE Besucher CASCADE CONSTRAINTS;

-- delete Sequenz
DROP SEQUENCE Mitarbeiter_seq;

--   triggers
DROP TRIGGER Mitarbeiter_before;
--  views 
DROP VIEW TicketVerkaufen;
DROP VIEW BesucherKaeufe;
--drop procedures

--drop getfilmtitle if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE GetFilmTitle';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -4043 THEN
            RAISE;
        END IF;
END;
/


DROP TRIGGER LogGehaltChange;

DROP TABLE MitarbeiterGehaltLog;

