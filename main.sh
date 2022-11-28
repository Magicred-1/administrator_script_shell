#!/bin/sh
while true
do
echo "================================"
echo "Welcome to Administrator's Shell"
echo "\tBy : Djason G. circa 2022"
echo "================================"
echo "Please enter the option number\nyou want to choose : "
echo "1. Create a new user"
echo "2. Edit a user"
echo "3. Erase a user"
echo "4. Exit"
echo -e "\n"
echo -e "Enter your choice : \c"
read choice

case $choice in
    1) echo -e "Enter the username : \c"
        if [ -z $username ]
        then
            echo "Username cannot be empty"
            exit
        fi
        read username
        echo -e "Enter the user's installation folder path : \c"
        if 
        read userfolder
        echo -e "Enter the user's expiration date : \c"
        read userexpire
        echo -e "Enter the user's password : \c"
        read userpass
        echo -e "Enter the user's shell : \c"
        read usershell
    2) echo -e "Which user do you want to edit? : \c"
        read useredit
        echo -e "Enter the user's new installation folder path : \c"
        read userfolder
    3)
    4) exit ;;
    esac
    echo -e "Press enter to continue ...\c"
    read choice
done



