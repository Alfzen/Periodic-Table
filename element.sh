#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ $1 ]]
then
#ENCUENTRO EL ATOMIC_NUMBER
FIND_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;" 2>/dev/null) 

#SI NO EXISTE PRUEBO CON EL SYMBOL
FIND_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1';")
#SI NO EXISTE PRUEBO CON 
FIND_NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1';")
if [[ -n $FIND_ATOMIC_NUMBER || -n $FIND_SYMBOL || -n $FIND_NAME ]]
then
if [[ -z $FIND_ATOMIC_NUMBER ]]
then
FIND_ATOMIC_NUMBER=0
fi
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $FIND_ATOMIC_NUMBER OR symbol = '$FIND_SYMBOL' OR name = '$FIND_NAME'")
NAME=$($PSQL "SELECT name FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $FIND_ATOMIC_NUMBER OR symbol = '$FIND_SYMBOL' OR name = '$FIND_NAME'")
SYMBOL=$($PSQL "SELECT symbol FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $FIND_ATOMIC_NUMBER OR symbol = '$FIND_SYMBOL' OR name = '$FIND_NAME'")
TYPE=$($PSQL "SELECT type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $FIND_ATOMIC_NUMBER OR symbol = '$FIND_SYMBOL' OR name = '$FIND_NAME'")
ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $FIND_ATOMIC_NUMBER OR symbol = '$FIND_SYMBOL' OR name = '$FIND_NAME'")
BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $FIND_ATOMIC_NUMBER OR symbol = '$FIND_SYMBOL' OR name = '$FIND_NAME'")
MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $FIND_ATOMIC_NUMBER OR symbol = '$FIND_SYMBOL' OR name = '$FIND_NAME'")
echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
else
echo I could not find that element in the database.
fi
else
echo Please provide an element as an argument.
fi