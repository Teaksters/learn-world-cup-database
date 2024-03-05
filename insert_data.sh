#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

# Loop through csv
cat games.csv | while IFS=',' read -r  YR RND WNR OPNT WNR_G OPNT_G
do
  # Skip headers
  if [[ $YR != 'year' ]]
  then

    # Get winner team id
    WNR_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WNR'")
    # If not found
    if [[ -z $WNR_TEAM_ID ]]
    then
      # Insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WNR')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WNR"
      fi
    fi
    # Get winner team id
    WNR_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WNR'")

    # Get opponent team id
    OPNT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPNT'")
    # If not found
    if [[ -z $OPNT_TEAM_ID ]]
    then
      # Insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPNT')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $OPNT"
      fi
    fi
    # Get opponent team id
    OPNT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPNT'")

    # Insert game
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YR, '$RND', $WNR_TEAM_ID, $OPNT_TEAM_ID, $WNR_G, $OPNT_G)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into games, $YR $RND $WNR_TEAM_ID $OPNT_TEAM_ID $WNR_G $OPNT_G"
    fi

  fi
done