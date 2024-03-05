CREATE SCHEMA football_league_v2;

USE football_league_v2;


CREATE TABLE players (
                         id INT PRIMARY KEY,
                         name VARCHAR(255) NOT NULL,
                         birthday DATE NOT NULL,
                         nationality VARCHAR(255) NOT NULL,
                         position VARCHAR(255) NOT NULL,
                         number INT NOT NULL
);

CREATE TABLE teams (
                       id INT PRIMARY KEY,
                       name VARCHAR(255) NOT NULL,
                       city VARCHAR(255) NOT NULL,
                       stadium VARCHAR(255) NOT NULL,
                       maanger VARCHAR(255) NOT NULL
);

CREATE TABLE team_squads (
                             team_id INT,
                             player_id INT,
                             PRIMARY KEY (team_id, player_id),
                             FOREIGN KEY (team_id) REFERENCES teams(id),
                             FOREIGN KEY (player_id) REFERENCES players(id)
);

CREATE TABLE seasons (
                         id INT PRIMARY KEY,
                         name VARCHAR(255)
);

CREATE TABLE leagues (
                         id INT PRIMARY KEY,
                         name VARCHAR(255) NOT NULL
);

CREATE TABLE match_days (
                            id INT PRIMARY KEY,
                            season_id INT NOT NULL,
                            league_id INT NOT NULL,
                            day_number INT NOT NULL CHECK (day_number > 0),
                            CONSTRAINT season2league2day_unique UNIQUE (season_id, league_id, day_number),
                            FOREIGN KEY (season_id) REFERENCES seasons(id),
                            FOREIGN KEY (league_id) REFERENCES leagues(id)
);

CREATE TABLE matches (
                         id INT PRIMARY KEY,
                         date_time DATETIME NOT NULL,
                         venue VARCHAR(255) NOT NULL,
                         home_team_id INT,
                         away_team_id INT,
                         home_score INT NOT NULL,
                         away_score INT NOT NULL,
                         match_day_id INT,

                         FOREIGN KEY (home_team_id) REFERENCES teams(id),
                         FOREIGN KEY (away_team_id) REFERENCES teams(id),
                         FOREIGN KEY (match_day_id) REFERENCES match_days(id)
);

CREATE TABLE standings (
                           match_day_id INT NOT NULL,
                           team_id INT NOT NULL,
                           points INT NOT NULL,
                           played INT NOT NULL,
                           won INT NOT NULL,
                           drawn INT NOT NULL,
                           lost INT NOT NULL,
                           goals_for INT NOT NULL,
                           goals_against INT NOT NULL,

                           PRIMARY KEY (match_day_id, team_id),
                           FOREIGN KEY (team_id) REFERENCES teams(id)
);

CREATE TABLE goals(
                      id INT UNIQUE,
                      match_id INT NOT NULL,
                      player_id INT NOT NULL,
                      team_id INT NOT NULL,

                      goal_time TIME NOT NULL,

                      PRIMARY KEY(id),
                      FOREIGN KEY (team_id) REFERENCES teams(id),
                      FOREIGN KEY (player_id) REFERENCES players(id),
                      FOREIGN KEY (match_id) REFERENCES matches(id)
);

USE football_league_v2;


-- Players table
INSERT INTO players (id, name, birthday, nationality, position, number)
VALUES
    (1, 'Lionel Messi', '1987-06-24', 'Argentina', 'Forward', 10),
    (2, 'Cristiano Ronaldo', '1985-02-05', 'Portugal', 'Forward', 7),
    (3, 'Neymar Jr.', '1992-02-05', 'Brazil', 'Forward', 10),
    (4, 'Kevin De Bruyne', '1991-06-28', 'Belgium', 'Midfielder', 17),
    (5, 'Virgil van Dijk', '1991-07-08', 'Netherlands', 'Defender', 4),
    (6, 'Robert Lewandowski', '1988-08-21', 'Poland', 'Forward', 9),
    (7, 'Sergio Ramos', '1986-03-30', 'Spain', 'Defender', 4),
    (8, 'Kylian Mbappe', '1998-12-20', 'France', 'Forward', 7),
    (9, 'Mohamed Salah', '1992-06-15', 'Egypt', 'Forward', 11),
    (10, 'Luka Modric', '1985-09-09', 'Croatia', 'Midfielder', 10);

-- Teams table
INSERT INTO teams (id, name, city, stadium, maanger)
VALUES
    (1, 'FC Barcelona', 'Barcelona', 'Camp Nou', 'Xavi Hernandez'),
    (2, 'Real Madrid', 'Madrid', 'Santiago Bernabeu', 'Carlo Ancelotti'),
    (3, 'Manchester City', 'Manchester', 'Etihad Stadium', 'Pep Guardiola'),
    (4, 'Liverpool FC', 'Liverpool', 'Anfield', 'Jurgen Klopp'),
    (5, 'Paris Saint-Germain', 'Paris', 'Parc des Princes', 'Mauricio Pochettino'),
    (6, 'Bayern Munich', 'Munich', 'Allianz Arena', 'Julian Nagelsmann'),
    (7, 'Manchester United', 'Manchester', 'Old Trafford', 'Ralf Rangnick'),
    (8, 'Chelsea FC', 'London', 'Stamford Bridge', 'Thomas Tuchel'),
    (9, 'Juventus', 'Turin', 'Allianz Stadium', 'Massimiliano Allegri'),
    (10, 'AC Milan', 'Milan', 'San Siro', 'Stefano Pioli');

-- Team Squads table (random assignment of players to teams)
INSERT INTO team_squads (team_id, player_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 4),
    (4, 5),
    (5, 3),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10);

-- Seasons table
INSERT INTO seasons (id, name)
VALUES
    (1, '2023/2024'),
    (2, '2022/2023'),
    (3, '2021/2022'),
    (4, '2020/2021'),
    (5, '2019/2020'),
    (6, '2018/2019'),
    (7, '2017/2018'),
    (8, '2016/2017'),
    (9, '2015/2016'),
    (10, '2014/2015');

-- Leagues table
INSERT INTO leagues (id, name)
VALUES
    (1, 'La Liga'),
    (2, 'Premier League'),
    (3, 'Bundesliga'),
    (4, 'Serie A'),
    (5, 'Ligue 1'),
    (6, 'UEFA Champions League'),
    (7, 'UEFA Europa League'),
    (8, 'FIFA World Cup'),
    (9, 'Copa America'),
    (10, 'UEFA European Championship');

-- Match Days table
INSERT INTO match_days (id, season_id, league_id, day_number)
VALUES
    (1, 1, 1, 1),
    (2, 1, 1, 2),
    (3, 1, 1, 3),
    (4, 1, 1, 4),
    (5, 1, 1, 5),
    (6, 1, 1, 6),
    (7, 1, 1, 7),
    (8, 1, 1, 8),
    (9, 1, 1, 9),
    (10, 1, 1, 10);

-- Matches table (random data)
INSERT INTO matches (id, date_time, venue, home_team_id, away_team_id, home_score, away_score, match_day_id)
VALUES
    (1, '2024-03-05 19:00:00', 'Camp Nou', 1, 2, 2, 1, 1),
    (2, '2024-03-05 19:00:00', 'Santiago Bernabeu', 2, 1, 1, 3, 1),
    (3, '2024-03-06 18:30:00', 'Etihad Stadium', 3, 4, 2, 2, 1),
    (4, '2024-03-06 18:30:00', 'Anfield', 4, 3, 1, 1, 1),
    (5, '2024-03-07 20:00:00', 'Parc des Princes', 5, 6, 3, 2, 1),
    (6, '2024-03-07 20:00:00', 'Allianz Arena', 6, 5, 2, 2, 1),
    (7, '2024-03-08 21:00:00', 'Old Trafford', 7, 8, 0, 1, 1),
    (8, '2024-03-08 21:00:00', 'Stamford Bridge', 8, 7, 1, 1, 1),
    (9, '2024-03-09 20:30:00', 'Allianz Stadium', 9, 10, 3, 0, 1),
    (10, '2024-03-09 20:30:00', 'San Siro', 10, 9, 2, 2, 1);

-- Standings table (dummy data)
INSERT INTO standings (match_day_id, team_id, points, played, won, drawn, lost, goals_for, goals_against)
VALUES
    (1, 1, 6, 3, 2, 0, 1, 8, 5),
    (1, 2, 3, 3, 1, 0, 2, 5, 6),
    (1, 3, 7, 4, 2, 1, 1, 10, 7),
    (1, 4, 4, 3, 1, 1, 1, 4, 4),
    (1, 5, 6, 3, 2, 0, 1, 8, 7),
    (1, 6, 4, 3, 1, 1, 1, 7, 6),
    (1, 7, 1, 3, 0, 1, 2, 2, 5),
    (1, 8, 4, 3, 1, 1, 1, 5, 4),
    (1, 9, 4, 3, 1, 1, 1, 6, 2),
    (1, 10, 1, 3, 0, 1, 2, 2, 7);

-- Goals table (random data)
INSERT INTO goals (id, match_id, player_id, team_id, goal_time)
VALUES
    (1, 1, 1, 1, '00:10:00'),
    (2, 1, 2, 2, '00:25:00'),
    (3, 1, 4, 3, '00:30:00'),
    (4, 1, 3, 2, '00:40:00'),
    (5, 1, 6, 1, '01:15:00'),
    (6, 2, 2, 2, '00:20:00'),
    (7, 2, 1, 1, '00:35:00'),
    (8, 2, 5, 4, '00:55:00'),
    (9, 3, 4, 3, '00:05:00'),
    (10, 3, 9, 4, '00:45:00');

USE football_league_v2;

-- виводить всі голи, які були забиті у сезоні '2023/2024' від 'away_team_id'  по 60 хвилини матчу
SELECT g.id, g.match_id, g.player_id, g.team_id, g.goal_time
FROM goals g
         JOIN matches m ON g.match_id = m.id
         JOIN match_days md ON m.match_day_id = md.id
         JOIN seasons s ON md.season_id = s.id
WHERE s.name = '2023/2024'
  AND g.goal_time <= '01:00:00'
  AND m.away_team_id = g.team_id;

-- виводить дві найуспішніші команди сезону '2020/2021' та ігрока, який забив найбільше голів за кожен з цих клубів
SELECT t.name AS team_name,
       p.name AS top_scorer,
       COUNT(*) AS goals_scored
FROM goals g
         JOIN teams t ON g.team_id = t.id
         JOIN players p ON g.player_id = p.id
         JOIN matches m ON g.match_id = m.id
         JOIN match_days md ON m.match_day_id = md.id
         JOIN seasons s ON md.season_id = s.id
WHERE s.name = '2020/2021'
GROUP BY t.name, p.name
ORDER BY goals_scored DESC
LIMIT 2;

-- виводить всі матчі, які відбувалися у 'Ligue 1', у яких грали футболісти від 1991 року народження та забили хоча б один гол

SELECT DISTINCT m.*
FROM matches m
         JOIN goals g ON m.id = g.match_id
         JOIN players p ON g.player_id = p.id
         JOIN teams t ON m.home_team_id = t.id OR m.away_team_id = t.id
         JOIN match_days md ON m.match_day_id = md.id
         JOIN seasons s ON md.season_id = s.id
         JOIN leagues l ON md.league_id = l.id
WHERE l.name = 'Ligue 1'
  AND YEAR(p.birthday) = 1991;
