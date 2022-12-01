#!/bin/sh
trap '' 2
# Name: Administrator Shell Script
# Description: This script is used to run the administrator shell script
# Author: Djason G. (Magicred-1 on Github)
while true
do
clear
echo "================================"
echo "\033[31m Welcome to Administrator's Shell 0000\033[0m"
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
    # To create a new user account we first check if the user already exists or if the input is empty
    1) echo -e "Enter the username : \c"
    read username

    if [ -z $username && $username != " "]; 
    then
        echo "Username cannot be empty"
        exit 0
    else
        if [ -d /home/$username ]; 
        then
            echo "User already exists"
            exit 0
        fi
    fi

    # Folder path for the user, we check if the folder exists or if the input is empty
    echo -e "Enter the user's folder path : \c"
    read path
    if [ -z $path && $path != " "]; 
    then
        echo "Path cannot be empty"
        exit 
    else
        if [ -d /home/$path ]; 
        then
            echo "Path already exists"
            exit 0
        fi
    fi

    # Expiration date for the user, we check if the input is empty
    #TODO: check for date format
    echo -e "Enter the user's expiration date (YYYY-MM-DD) : \c"
    read expiration
    if [ -z $expiration && $expiration != " " && $expiration =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$]; 
    then
        echo "Expiration date cannot be empty or the format is invalid"
        exit 0
    fi
    
    echo -e "Enter the user's password : \c"
    read password
    if [-z $password && $password != " " && $password < 8]; 
    then
        echo "Password cannot be empty and must be at least 8 characters long"
        exit 0
    fi

    echo -e "Enter the name of the shell for the user : \c"
    read shell
    if [-z $shell && $shell != " "];
    then
        echo "Shell cannot be empty"
        exit 0
    else
        if [ -d /home/$shell ]; 
        then
            continue
        else
            echo "Shell does not exist"
            exit 0
        fi
    fi

    echo -e "Enter the user's name : \c"
    read username
    if [-z $username && $username != " "]; 
    then
        echo "Username cannot be empty"
        exit 0
    fi
    # We then create the user
    useradd -d $path -e $expiration -s $shell -p $password $username
    echo "User $username created successfully"
    ;;
        
    # Edit a user
    2) echo -e "Which existing user do you want to edit? : \c"
        read useredit
        # if user exists
        if [ -d /home/$useredit ]; 
        then
            echo "What do you want to edit ?"
            echo "1. Username"
            echo "2. Path"
            echo "3. Expiration date"
            echo -e "Enter your choice : \c"
            read user_choice
            # choice options
            case $user_choice in 
                1) echo -e "Enter the new username : \c"
                    read new_username
                    if [ -z $new_username && $new_username != " "]; 
                    then
                        echo "Username cannot be empty"
                        exit 0
                    else
                        if [ -d /home/$new_username ]; 
                        then
                            echo "User already exists"
                            exit 0
                        fi
                    fi
                    # Change the username
                    echo "Changing username..."
                    usermod -l $new_username $useredit
                    echo "Username changed" ;;
                2) echo -e "Enter the new path : \c"
                    read new_path
                    if [ -z $new_path && $new_path != " "]; 
                    then
                        echo "Path cannot be empty"
                        exit 0
                    else
                        if [ -d /home/$new_path ]; 
                        then
                            echo "Path already exists"
                            exit 0
                        fi
                    fi
                    # Change the path
                    echo "Changing path..."
                    usermod -d $new_path $useredit
                    echo "Path changed"
                    ;;
                3) echo -e "Enter the new expiration date (YYYY-MM-DD) : \c"
                    read new_expiration
                    if [ -z $new_expiration && $new_expiration != " " && $new_expiration > ${date +%Y-%m-%d}]; 
                    then
                        echo "Expiration date cannot be empty and must be greater than today's date"
                        exit 0
                    fi
                    # Change the expiration date
                    echo "Changing expiration date..."
                    chage -E $new_expiration $useredit
                    echo "Expiration date changed"
            esac
        fi
    ;;

    # Erase a user
    3);;
    # Exit
    4) exit ;;
    esac
    echo -e "Press enter to continue ...\c"
    read input
done

