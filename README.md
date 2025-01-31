# KinoDB-Konzept

Das Ziel dieses Projekts ist es ein Datenbankkonzept für ein Kino zu erstellen. 

Bei den Filmen werden Eigenschaften wie Titel, Film-ID, Laufzeit, Altersfreigabe, Sprache und Genre erfasst. 
Zu den Tickets gehören Ticketnummer, Zeitpunkt, Anzahl und Preis. 
Die Säle sind durch Saalnummer, Kapazität und Ausstattung charakterisiert. Die Plätze sind durch Reihe, Sitz und Reservierungsstatus gekennzeichnet. 
Besucher werden anhand ihres Vornamens, Nachnamens, ihrer Kundennummer und E-Mail-Adresse identifiziert. 
![image](https://github.com/user-attachments/assets/21625ac6-77bf-4ea1-8439-e8f5fce37be6)


 Besucher(Kundennummer, E-Mail, Vorname, Nachname)

•	PK: Kundennummer

Mitarbeiter(Personalnummer, Position, Arbeitsplan, Gehalt, Vorname, Nachname)
•	PK: Personalnummer

Ticket(Belegnummer, Ticketanzahl, Zeitpunkt, Preis, Personalnummer (FK), FilmID (FK) )
•	PK: Belegnummer
•	FK: Personalnummer ◊ Mitarbeiter.Personalnummer
•	FK: FilmID ◊ Film.FilmID

Film(FilmID, Genre, Titel, Laufzeit, Sprache, Altersfreigabe)
•	PK: FilmID

Saal(Saalnummer, Ausstattung, Kapazität) 
•	PK: Saalnummer

GezeigtIn(FilmID,  Saalnummer)
•	PK: FilmID
•	PK: Saalnummer
•	FK: FilmID ◊ Film.FilmID
•	FK: Saalnummer ◊ Saal.Saalnummer

Platz(Reihe, Sitz, Saalnummer, Reservierungsstatus) 
•	PK: Reihe, Sitz, Saalnummer
•	FK: Saalnummer ◊ Saal.Saalnummer

Snack(SnackID, Preis) 
•	PK: SnackID

Kauft(SnackID (FK) , Belegnummer (FK), Kundennummer (FK))
•	PK: SnackID, Belegnummer
•	FK: SnackID ◊ Snack.SnackID
•	FK: Belegnummer ◊ Ticket.Belegnummer
•	FK: Kundennummer ◊ Besucher.Kundennummer
