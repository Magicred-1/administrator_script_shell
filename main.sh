#!/bin/sh
trap '' 2
# Name: Administrator Shell Script
# Description: This script is used to run the administrator shell script
# Author: Djason G. (Magicred-1 on Github)
while true
do
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
clear
echo "=========================================="
echo "\033[31m Welcome to Administrator's Shell \033[0m"
echo "\tBy : Djason G. circa 2022"
echo "=========================================="
echo "Please enter the option number\nyou want to choose : "
echo "1. Create a new user"
echo "2. Edit a user"
echo "3. Erase a user"
echo "4. Exit"
echo "\n"
echo "Enter your choice : "
read choice

case $choice in
    # To create a new user account we first check if the user already exists or if the input is empty
    1) echo "How many account(s) do you want to be created ? : "
    read numberOfAccounts
    for i in $(seq 1 "$numberOfAccounts")
    do
        echo "Enter the username of the user number $i : "
        read username

        if [ -z "$username" ] && ! [ "$username" = " " ] || [ -d /home/"$username" ]; 
        then
            echo "Username cannot be empty or the user already exists"
            
        else
            if [ -d /home/"$username" ]; 
            then
                echo "User already exists"
                
            fi
        fi

        # Folder path for the user, we check if the folder exists or if the input is empty
        echo "Enter the user's folder name (ex: user -> /home/user) : "
        read path
        if [ -z "$path" ] && [ "$path" != " " ]; 
        then
            echo "Path cannot be empty"
            exit 
        else
            if [ -d /home/"$path" ]; 
            then
                echo "Path already exists"
                
            fi
        fi

        # Expiration date for the user, we check if the input is empty
        #TODO: check for date format
        echo "Enter the user's expiration date (YYYY-MM-DD) : "
        read -r expiration
        if [ -z "$expiration" ] && [ "$expiration" != " " ] && [ echo "$expiration" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' ]; 
        then
            echo "Expiration date cannot be empty or the format is invalid"
            
        fi
        
        echo "Enter the user's password : "
        ssty -echo
        read -r password
        ssty echo
        if [ -z "$password"  ] && [ "$password" != " " ] && [ ${#password} -lt 8 ]; 
        then
            echo "Password cannot be empty and must be at least 8 characters long"
            
        fi

        echo "Enter the name of the shell for the user : "
        read -r shell
        if [ -z "$shell" ] && [ "$shell" != " " ];
        then
            echo "Shell cannot be empty"
            
        else
            # check if the shell exists
            if [ $(command -v "$shell") ]
            then
                echo "Enter the username : "
                read username
                if [ -z "$username" ] && [ "$username" != " " ]; 
                then
                    echo "Username cannot be empty"
                    
                fi
                # We then create the user with a encrypted password
                encrypted_password = $(openssl passwd -1 "$password")

                sudo useradd -d "$path" -n "$expiration" -s "/home/$shell" -p "$encrypted_password" "$username"
                echo "User $username created successfully"
                sleep 2
            else
                echo "Shell does not exist\n"
                echo "Do you want to install the shell ? (y/n)"
                read install
                case $install in
                    y) echo "Installing shell..."
                    sudo apt install "$shell"
                    echo "Shell installed"

                    if [ $(command -v "$shell") ]; 
                    then
                        echo "Shell installed successfully"
                    else
                        echo "Shell installation failed"
                        
                    fi
                    sleep 2
                    ;;
                    n) echo "Exiting..."
                    
                    ;;
                    *) echo "Invalid input"
                    
                    ;;
                esac
            fi
        fi
    done;;

    # Edit a user
    2) echo "Which existing user do you want to edit ? : "
        read useredit
        # if user exists
        if [ -d /home/"$useredit" ]; 
        then
            echo "What do you want to edit ?"
            echo "1. Username"
            echo "2. Path"
            echo "3. Expiration date"
            echo "4. Password"
            echo "5. Shell"
            echo "6. userID"
            echo "7. Get back to the main menu"
            echo "Enter your choice : "
            read user_choice
            # choice options
            case $user_choice in 
                1) echo "Enter the new username : "
                    read new_username
                    if [ -z "$new_username" ] && [ "$new_username" != " " ]; 
                    then
                        echo "Username cannot be empty"
                        
                    else
                        if [ -d /home/"$new_username" ]; 
                        then
                            echo "User already exists"
                            
                        fi
                    fi
                    # Change the username
                    echo "Changing username..."
                    usermod -l "$new_username" "$useredit"
                    echo "Username changed"
                    sleep 2
                    ;;
                2) echo "Enter the new path : "
                    read new_path
                    if [ -z "$new_path" ] && [ "$new_path" != " " ]; 
                    then
                        echo "Path cannot be empty"
                        
                    else
                        if [ -d /home/"$new_path" ]; 
                        then
                            echo "Path already exists"
                            
                        fi
                    fi
                    # Change the path
                    echo "Changing path..."
                    usermod -d "$new_path" "$useredit"
                    echo "Path changed"
                    sleep 2
                    ;;
                3) echo "Enter the new expiration date (YYYY-MM-DD) : "
                    read new_expiration
                    if [ -z "$new_expiration" ] && [ "$new_expiration" != " " ] &&  [ "$new_expiration" > "${date +%Y-%m-%d}" ]; 
                    then
                        echo "Expiration date cannot be empty and must be greater than today's date"
                        
                    fi
                    # Change the expiration date
                    echo "Changing expiration date..."
                    chage -n "$new_expiration" "$useredit"
                    echo "Expiration date changed"
                    sleep 2
                    ;;
                4) echo "Enter the new password : "
                    stty -echo
                    read new_password
                    stty echo
                    if [ -z "$new_password" ] && [ "$new_password" != " " ] && [ ${#new_password} -lt 8 ]; 
                    then
                        echo "Password cannot be empty and must be at least 8 characters long"
                        
                    fi
                    # Change the password
                    echo "Changing password..."
                    new_encrypted_password=$(openssl passwd -1 "$password")
                    usermod -p "$new_encrypted_password" "$useredit"
                    echo "Password changed"
                    sleep 2
                    ;;
                5) echo -r "Enter the new shell : "
                    read new_shell
                    if [ -z "$new_shell" ] && [ "$new_shell" != " " ]; 
                    then
                        echo "Shell cannot be empty."
                        
                    else
                        if [ "${command -v $new_shell}" ]; 
                        then
                            continue
                        else
                            echo "Shell does not exist\n"
                            echo "Do you want to install the shell ? (y/n) : "
                            read install
                            if [ "$install" == "y" ] || [ "$install" == "Y" ];
                            then
                                # we install the shell from the content of the 
                                # shell variable
                                sudo apt-get install "$new_shell"

                                echo "Installing $new_shell ..."
                                sleep 2
                                if [ "${command -v $new_shell}" ]; 
                                then
                                    echo "Shell installed successfully"
                                else
                                    echo "Shell installation failed"
                                    
                                fi
                            fi
                        fi
                    fi
                    # Change the shell
                    echo "Changing shell..."
                    usermod -s "$new_shell" "$useredit"
                    echo "Shell changed"
                    sleep 2
                    ;;
                6) echo "Enter the new userID : "
                    read new_userID
                    if [ -z "$new_userID" ] && [ "$new_userID" != " " ]; 
                    then
                        echo "userID cannot be empty"
                        
                    fi
                    # Change the userID
                    echo "Changing userID..."
                    usermod -u "$new_userID" "$useredit"
                    echo "userID changed"
                    sleep 2
                    ;;
                7) echo "Returning to the main menu..."
                    sleep 2
                    
                    ;;
            esac
        else
            echo "User does not exist"
            
        fi
    ;;

    # Erase a user
    3) echo "Which existing user do you want to erase ? : "
        read -r user_erase
        # if user exists
        if [ -d /home/"$user_erase" ]; 
        then
            echo "Are you sure you want to erase $erase_choice ? (y/n) :"
            read erase_choice
            case $erase_choice in
                #we check if the user is logged in or if the user exist
                y)  if [ -n $(who | grep q "$user_erase") ] || [ -e /home/"$user_erase" ];
                        # ask the user if he wants to delete the user folder
                        then echo "Do you want to delete the user folder ? (y/n) : "
                            read -r folder_choice
                            case $folder_choice in
                                y) echo "Deleting $user_erase folder..."
                                    rm -rf /home/"$user_erase"
                                    echo "User folder deleted"
                                    sleep 2
                                    ;;
                                n) echo "User folder not deleted"
                                    sleep 2
                                    ;;
                            esac
                            # delete the user
                            echo "Deleting user..."
                            userdel -r "$user_erase"
                            echo "User deleted"
                            sleep 2
                        else echo "$erase_choice is logged in"
                            # we force delete the user if he is logged in
                            echo "Force deleting $erase_choice ..."
                            userdel -r -f "$user_erase"
                            echo "User deleted"
                            sleep 2
                    fi
                    ;;

                n) echo "Cancelling the user deletion .."
                    sleep 2
                    
                    ;;
            esac
        else
            echo "User does not exist"
            sleep 2
            
        fi
    ;;
    # Exit
    4) exit ;;
    esac
    echo "Press enter to continue ..."
    read -r input
done
