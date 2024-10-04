#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


# Script to insert data from games.csv into worldcup database
PSQL="psql -X --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"
echo $($PSQL "TRUNCATE teams, games")

# Insert teams and games
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOAL OPPONENTGOAL
do
  # Not considering the header
  if [[ $YEAR != "year" ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if winner_id not found
    if [[ -z $WINNER_ID ]]
    then
      # insert winner
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      # get new team_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if opponent_id not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert opponent
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      # get new opponent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # insert into games
    echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNERGOAL, $OPPONENTGOAL)")"
  fi
done