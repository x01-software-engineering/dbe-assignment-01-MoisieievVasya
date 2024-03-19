use football_league_v2;

-- SELECT 
    
-- корельована subquery та EXIST 
SELECT DISTINCT t.id, t.name
FROM teams t
WHERE EXISTS(
    SELECT 1
    FROM goals g
             JOIN matches m ON g.match_id = m.id
    WHERE g.team_id = t.id
);

-- не корельована subquery, IN та UNION 

SELECT DISTINCT t.id, t.name
FROM teams t
WHERE t.id IN (
    SELECT DISTINCT home_team_id
    FROM matches
    UNION
    SELECT DISTINCT away_team_id
    FROM matches
);

-- корельований підзапит та = 
SELECT *
FROM goals
WHERE match_id IN (
    SELECT id
    FROM matches
    WHERE date(date_time) = '2024-03-19'
    );


-- не корельований підзапит та = 
SELECT *
FROM goals
WHERE match_id = (
    SELECT id
    FROM matches
    WHERE date(date_time) = '2024-03-19'
    );


-- корельований підзапит та NOT IN 
SELECT *
FROM goals
WHERE match_id NOT IN (
    SELECT id
    FROM matches
    WHERE date(date_time) = '2024-03-19'
    );


-- не корельований підзапит та NOT IN 

SELECT *
FROM players
WHERE id NOT IN (
    SELECT DISTINCT player_id
    FROM goals
    WHERE team_id = (
        SELECT id
        FROM teams
        WHERE name = 'FC Barcelona'
    )
);

-- не корельований підзапит з NOT IN 
SELECT id, name
FROM players
WHERE id NOT IN (
    SELECT player_id
    FROM team_squads
    WHERE team_id IN (
        SELECT home_team_id
        FROM matches
        WHERE id = 1
        UNION
        SELECT away_team_id
        FROM matches
        WHERE id = 1
    )
);

-- корельований підзапит з EXISTS 

SELECT id, name
FROM players p
WHERE NOT EXISTS (
    SELECT 1
    FROM team_squads ts
             JOIN matches m ON m.id = 1
             JOIN teams t ON t.id = ts.team_id
    WHERE ts.player_id = p.id
      AND (t.id = m.home_team_id OR t.id = m.away_team_id)
);

-- не корельований запит з NOT EXISTS 
SELECT id, name
FROM players p
WHERE NOT EXISTS (
    SELECT 1
    FROM team_squads ts
             JOIN matches m ON m.id = 1
             JOIN teams t ON t.id = ts.team_id
    WHERE ts.player_id = p.id
      AND (t.id = m.home_team_id OR t.id = m.away_team_id)
);

-- корельований запит з NOT EXISTS 
SELECT id, name
FROM players p
WHERE NOT EXISTS (
    SELECT 1
    FROM team_squads ts
             JOIN matches m ON m.id = 1
             JOIN teams t ON (t.id = m.home_team_id AND ts.team_id = t.id) OR (t.id = m.away_team_id AND ts.team_id = t.id)
    WHERE ts.player_id = p.id
);

-- UPDATE 

-- не корельований запит з = 

UPDATE players
SET position = 'Substitute'
WHERE id NOT IN (
    SELECT player_id
    FROM team_squads
);

-- корельований запит з = 
UPDATE players
SET position = 'Substitute'
WHERE EXISTS (
    SELECT 1
    FROM team_squads
             JOIN matches ON matches.id = 1
    WHERE team_squads.player_id = players.id
      AND (matches.home_team_id = team_squads.team_id OR matches.away_team_id = team_squads.team_id)
);

-- не корельований запит з IN
UPDATE matches
SET venue = 'Emirates Stadium'
WHERE venue = 'Old Trafford'
  AND id IN (SELECT id FROM matches WHERE venue = 'Old Trafford');


-- корельований запит з IN 
UPDATE players
SET position = 'Substitute'
WHERE id IN (
    SELECT ts.player_id
    FROM team_squads ts
             INNER JOIN matches m ON ts.team_id = m.home_team_id OR ts.team_id = m.away_team_id
    WHERE m.id = 1
);

-- не корельований запит з NOT IN 
UPDATE matches
SET venue = 'DK'
WHERE id NOT IN (SELECT match_id FROM goals);

-- корельований запит з NOT IN 
UPDATE matches
SET venue = 'DK'
WHERE id NOT IN (
    SELECT match_id
    FROM goals
    WHERE goals.match_id = matches.id
);

-- корельований з EXISTS 

UPDATE players AS p
SET p.nationality = 'British'
WHERE EXISTS (
    SELECT 1
    FROM teams AS t
    WHERE t.maanger = p.name
      AND t.city = 'London'
);


-- не корельований з EXISTS

UPDATE players
SET position = 'Captain'
WHERE EXISTS (
    SELECT 1
    FROM matches m , teams t
    WHERE m.home_team_id = t.id
      AND m.home_score > away_score
);

-- не корельований запит та NOT EXISTS 
SELECT *
FROM teams
WHERE NOT EXISTS (
    SELECT 1
    FROM matches
             INNER JOIN match_days ON matches.match_day_id = match_days.id
             INNER JOIN leagues ON match_days.league_id = leagues.id
    WHERE leagues.name = 'Champions League'
      AND (matches.home_team_id = teams.id OR matches.away_team_id = teams.id)
);

-- корельований запит та NOT EXISTS 
SELECT *
FROM teams t
WHERE NOT EXISTS (
    SELECT 1
    FROM matches m
    WHERE m.home_team_id = t.id OR m.away_team_id = t.id
);

-- DELETE

-- не корельований запит та = 
DELETE FROM goals
WHERE team_id = (
    SELECT CASE
               WHEN home_team_id = (SELECT home_team_id FROM matches WHERE id = match_id) THEN home_team_id
               ELSE away_team_id
               END
    FROM matches
    WHERE id = match_id
);

-- корельований запит та = 
DELETE FROM goals
WHERE player_id = (SELECT id FROM players WHERE name = 'Lionel Messi');


-- не корельований запит та IN 
DELETE FROM goals
WHERE team_id IN (
    SELECT home_team_id
    FROM matches
    WHERE id = match_id

    UNION ALL

    SELECT away_team_id
    FROM matches
    WHERE id = match_id
);


-- корельований запит та IN 
DELETE FROM players
WHERE id IN (
    SELECT player_id
    FROM team_squads
    WHERE team_id IN (
        SELECT id
        FROM teams
        WHERE maanger = 'Xavi Hernandez'
    )
);


-- не корельований запит та NOT IN 
DELETE FROM goals
WHERE id NOT IN (
    SELECT id
    FROM goals
    WHERE match_id = '2' AND goal_time >= '00:35:00'
);


-- корельований запит та NOT IN 
DELETE FROM goals
WHERE team_id NOT IN (
    SELECT away_team_id
    FROM matches
);

-- не корельований запит та EXISTS 
DELETE FROM players
WHERE EXISTS (
    SELECT 1
    FROM players AS p
    WHERE p.nationality = 'Portugal'
);


-- корельований запит та EXISTS 
DELETE FROM players p
WHERE NOT EXISTS (
    SELECT 1
    FROM goals AS g
    WHERE g.player_id = p.id
      AND g.match_id = '2024-03-08 21:00:00'
);

-- не корельований запит та NOT EXISTS  
DELETE FROM teams
WHERE NOT EXISTS (
    SELECT 1
    FROM match_days
             INNER JOIN matches ON match_days.id = matches.match_day_id
    WHERE matches.home_team_id = teams.id OR matches.away_team_id = teams.id
);


-- корельований запит та NOT EXISTS
DELETE FROM teams
WHERE NOT EXISTS (
    SELECT 1
    FROM goals
             INNER JOIN matches ON goals.match_id = matches.id
    WHERE goals.team_id = teams.id
      AND matches.venue != teams.city
);




-- TASK 2 SELECT 

-- UNION 

SELECT p.id, p.name, p.birthday, p.nationality, p.position, p.number, t.name , t.city, t.stadium, t.maanger
FROM players AS p
         INNER JOIN team_squads AS ts ON p.id = ts.player_id
         INNER JOIN teams AS t ON ts.team_id = t.id
UNION

SELECT p.id, p.name , p.birthday, p.nationality, p.position, p.number, t.name, t.city AS team_city, t.stadium, t.maanger
FROM players AS p
         RIGHT JOIN team_squads AS ts ON p.id = ts.player_id
         RIGHT JOIN teams AS t ON ts.team_id = t.id;


-- UNOIN ALL 

SELECT g.id AS goal_id, g.match_id, g.player_id, g.team_id, g.goal_time, p.name
FROM goals AS g
         INNER JOIN players AS p ON g.player_id = p.id
UNION ALL

SELECT NULL AS goal_id, NULL AS match_id, p.id , NULL AS team_id, NULL AS goal_time, p.name
FROM players AS p
         LEFT JOIN goals AS g ON p.id = g.player_id
WHERE g.id IS NULL;

-- INTERSECT

SELECT p.id, p.name, p.nationality
FROM players p
         JOIN team_squads ts ON p.id = ts.player_id
         JOIN teams t ON ts.team_id = t.id
WHERE t.name = 'Barcelona'

INTERSECT

SELECT id, name, nationality
FROM players
WHERE nationality = 'Spain';

-- EXCEPT 

SELECT id, name
FROM teams
WHERE id IN (SELECT DISTINCT team_id FROM team_squads)

EXCEPT

SELECT DISTINCT t.id, t.name
FROM teams t
         JOIN team_squads ts ON t.id = ts.team_id
         JOIN matches m ON t.id = m.home_team_id OR t.id = m.away_team_id
         JOIN match_days md ON m.match_day_id = md.id
         JOIN leagues l ON md.league_id = l.id``
WHERE l.name = 'Premier League';



