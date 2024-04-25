#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=guessing_game -t --no-align -c"

#get user name
echo -e "Enter your username:\n"
read USERNAME

PLAYERS_DATA=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")

if [[ -z $PLAYERS_DATA ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo -e "\nGuess the secret number between 1 and 1000:"
  RANDOM_NUMBER=$((RANDOM % 1000 + 1))
  
  while true
  do
    read PLAYER_GUESS
    if ! [[ $PLAYER_GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "That is not an integer, guess again:"
    fi

    TOTAL_GUESSES=$((TOTAL_GUESSES + 1))

    if [[ $PLAYER_GUESS != $RANDOM_NUMBER ]]
    then
      if [[ $PLAYER_GUESS -gt $RANDOM_NUMBER ]]
      then
        echo -e "It's lower than that, guess again:"
      else
        echo -e "It's higher than that, guess again:"
      fi
    else
      echo -e "You guessed it in $TOTAL_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"  
      PLAYER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
      INSERT_NUMBERS=$($PSQL "INSERT INTO games(user_id, attempts) VALUES($PLAYER_ID, $TOTAL_GUESSES)")
      break
    fi
  done
else
    GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM users LEFT JOIN games ON users.user_id = games.user_id WHERE username = '$USERNAME';")
    GUESSES=$($PSQL "SELECT MIN(attempts) FROM users LEFT JOIN games ON users.user_id = games.user_id WHERE username = '$USERNAME';")

    echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $GUESSES guesses."
    echo -e "\nGuess the secret number between 1 and 1000:"
    RANDOM_NUMBER=$((RANDOM % 1000 + 1))
    echo $RANDOM_NUMBER  while true
  while true
  do
    read PLAYER_GUESS
    if ! [[ $PLAYER_GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "That is not an integer, guess again:"
    fi

    TOTAL_GUESSES=$((TOTAL_GUESSES + 1))

    if [[ $PLAYER_GUESS != $RANDOM_NUMBER ]]
    then
      if [[ $PLAYER_GUESS -gt $RANDOM_NUMBER ]]
      then
        echo -e "It's lower than that, guess again:"
      else
        echo -e "It's higher than that, guess again:"
      fi
    else
      echo -e "You guessed it in $TOTAL_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"  
      PLAYER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
      INSERT_NUMBERS=$($PSQL "INSERT INTO games(user_id, attempts) VALUES($PLAYER_ID, $TOTAL_GUESSES)")
      break
    fi
  done
fi
