#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -q -t --no-align -c"

# assign secret number
SECRET_NUMBER=$(( ( RANDOM % 1000 ) + 1 ))

# prompt user for username
echo "Enter your username:" 
read USERNAME
 USERNAME=$(echo "$USERNAME" | xargs)

# verify if username exists
EXISTUSER=$($PSQL "SELECT username FROM usernames WHERE username='$USERNAME';")
 EXISTUSER=$(echo "$EXISTUSER" | xargs)

 if [[ -n "$EXISTUSER" ]]; then
  USER_ID=$($PSQL "SELECT user_id FROM usernames WHERE username = '$USERNAME';")
   USER_ID=$(echo "$USER_ID" | xargs) 
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID;")
   GAMES_PLAYED=$(echo "$GAMES_PLAYED" | xargs)
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID;")
   BEST_GAME=$(echo "$BEST_GAME" | xargs)
     if [[ "$GAMES_PLAYED" -eq 0 ]]; then
    BEST_GAME=0
     fi
 echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  else
   echo "Welcome, $USERNAME! It looks like this is your first time here."
    $PSQL "INSERT INTO usernames(username) VALUES ('$USERNAME');"
    USER_ID=$($PSQL "SELECT user_id FROM usernames WHERE username = '$USERNAME';")
     USER_ID=$(echo "$USER_ID" | xargs) 
fi

# guess secret number
echo "Guess the secret number between 1 and 1000:"
NUMBER_OF_GUESSES=0
while true; do
 read GUESS
  if [[ ! "$GUESS" =~ ^[0-9]+$ ]]; then
   echo "That is not an integer, guess again:"
   continue
  fi

((NUMBER_OF_GUESSES++))
   
  if [[ "$GUESS" -lt "$SECRET_NUMBER" ]]; then
   echo "It's higher than that, guess again:"
  elif [[ "$GUESS" -gt "$SECRET_NUMBER" ]]; then
    echo "It's lower than that, guess again:"
  else
   echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
   $PSQL "INSERT INTO games(user_id, number_of_guesses, secret_number) VALUES ($USER_ID, $NUMBER_OF_GUESSES, $SECRET_NUMBER);"
   break
  fi
done