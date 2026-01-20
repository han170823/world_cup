#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
if [[ $year != "year" ]]
then
winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
if [[ -z $winner_id ]]
then
insert_winner=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
echo Inserted team: $winner
fi

opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
if [[ -z $opponent_id ]]
then
insert_opponent=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
echo Inserted team: $opponent
fi

winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

insert_game=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")
echo Inserted game: $year $round $winner vs $opponent
fi
done