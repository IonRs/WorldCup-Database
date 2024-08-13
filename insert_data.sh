#! /bin/bash
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
  echo "Test"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
  echo "Prod"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    ID_TEAM_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z "$ID_TEAM_WINNER" ]]
    then
      INSERT_RESULT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_RESULT_GAMES="INSERT 0 1" ]]
      then
        echo "Inserted succesful team $WINNER."
      fi
    fi

    ID_TEAM_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ -z "$ID_TEAM_OPPONENT" ]]
    then
      INSERT_RESULT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_RESULT_GAMES="INSERT 0 1" ]]
      then
        echo "Inserted succesful team $OPPONENT."
      fi
    fi

    ID_TEAM_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    ID_TEAM_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      
    INSERT_RESULT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $ID_TEAM_WINNER, $ID_TEAM_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)")
    

    if [[ $INSERT_RESULT_GAMES="INSERT 0 1" ]]
    then
    echo "Inserted succesful the game between $WINNER and $OPPONENT in the year $YEAR, $ROUND round."
    fi
  fi
done