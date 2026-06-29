#!/usr/bin/env bash

###############################
# wdmenu                      #
# Menu for writerdeckOS       #
###############################

# Enter a custom path to a custom installed word processor
function customWP ()
	{
	CHOICECUSTOM="$(whiptail --inputbox "Please enter the full path of desired word processor:" 10 30 "/usr/bin/custom" 3>&2 2>&1 1>&3)"
	echo -e "$CHOICECUSTOM" | sudo tee /usr/bin/texteditor.conf
	menu
	}

# Menu to change the word processor
function changeWP () 
	{
	CHOICEWP=$(whiptail --title "Change Default Word Processor" --menu "Select a Word Processor or Text Editor" 25 78 16 \
	"Tilde" " - Tilde Word Processor" \
	"WordGrinder" " - WordGrinder Word Processor (default)" \
	"Word Perfect" " - Word Perfect Word Processor" \
	"emacs" " - Emacs Text Editor" \
	"joe" " - Joe Text Editor" \
	"nano" " - Nano Text Editor" \
	"micro" " - Micro Text Editor" \
	"vi" " - Vi Text Editor" \
	"vim" " - Vim Text Editor" \
	"Custom" " - Enter a custom app that you have installed"  3>&2 2>&1 1>&3
	)
	
	case $CHOICEWP in
		"Tilde")   
			echo -e "/usr/bin/tilde" | sudo tee /usr/bin/texteditor.conf
		;;

		"WordGrinder")   
			echo -e "/usr/bin/wordgrinder" | sudo tee /usr/bin/texteditor.conf
		;;

		"Word Perfect")   
			echo -e "/usr/bin/wp" | sudo tee /usr/bin/texteditor.conf
		;;
	
		"emacs")   
			echo -e "/usr/bin/emacs" | sudo tee /usr/bin/texteditor.conf
		;;

		"joe")   
			echo -e "/usr/bin/joe" | sudo tee /usr/bin/texteditor.conf
		;;

		"nano")   
			echo -e "/usr/bin/nano" | sudo tee /usr/bin/texteditor.conf
		;;

		"micro")   
			echo -e "/usr/bin/micro" | sudo tee /usr/bin/texteditor.conf
		;;

		"vi")   
			echo -e "/usr/bin/vi" | sudo tee /usr/bin/texteditor.conf
		;;

		"vim")   
			echo -e "/usr/bin/vim" | sudo tee /usr/bin/texteditor.conf
		;;

		"Custom")   
			customWP
		;;
	esac
	menu
	}

# Core Menu
function menu ()
	{
	CHOICEMENU=$(
	whiptail --title "writerdeckOS Menu" --menu "Choose an Option:" 25 78 16 \
	"Run WP" " - Run the default word processor" \
	"Change WP" " - Change the default word processor" \
	"Internet" " - Connect to internet or wifi" \
	"Exit" " - Exit Menu" 3>&2 2>&1 1>&3
	)

	case $CHOICEMENU in
		"Run WP")   
		        /usr/bin/texteditor.conf
		        exit
		;;

		"Change WP")
			changeWP
		;;

		"Internet")   
		        nmtui
		        exit
	        ;;
	        
	        "Exit")
	        	exit
	        ;;
	esac
	}

# Run the writerdeckOS Menu
menu
