#!/bin/bash
# element bash script

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Query a database with one of 3 args: atomic_number, symbol, name
  # if is a string (not a number)
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE symbol='$1' OR name='$1'")
    # if RESULT doesn't not exist in db
    if [[ -z $RESULT ]]
    then
      echo "I could not find that element in the database."
    else # RESULT is exist in db
      echo $RESULT | while IFS="|" read ATOM_NUM SYMBOL NAME TYPE MASS MELT BOIL
      do
      echo "The element with atomic number $ATOM_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
  else # else it is a number
    RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number=$1")
    if [[ -z $RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      echo $RESULT | while IFS="|" read AT_NUM SYMBOL NAME TYPE MASS MELT BOIL
      do
      echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
  fi

fi
