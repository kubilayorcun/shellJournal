#!/bin/bash
dialog --title "Decryption !" --backtitle "Password protection process.." --msgbox "***Next screen enter your password to keep using the diary*** \n If this is your first time with me don't panic, there won't be a password since you didn't give any before." 10 40
cd /home/$(whoami)/
unzip -u encFabDiary.zip
rm encFabDiary.zip
dialog --title "Password Confirmation" --backtitle "Fab_diary is loading.." --msgbox "Password Accepted !!" 10 35
name=$(dialog --no-cancel --title "Welcome !" --inputbox "Let's meet,my name is Jarvis. What is yours?" 10 40 --stdout)
	if [ $name = 'ultron' ]; then
		dialog --title "GET OUT !" --msgbox "I know your evil plan, i won't let it happen you MONSTER ! \n TERMINATING THE PROCESS.." 10 40
		exit;
	fi


	if [ -z "$name" ]; then
		dialog --title "Welcome to the jungle !" --msgbox "I see you like to be anonymous, so let's have it your way !" 10 40
		name="anonymous"
	else	
dialog --title "Welcome to the jungle !" --msgbox "Nice meeting you $name! Hope you like what i have done for you." 10 40	
	fi

mkdir /home/$(whoami)/fab_diary
while true
do
date=$(date +%d-%m-%Y)
	WIDTH=50
	HEIGHT=15
	CHOICE_HEIGHT=7
	TITLE="Welcome to FabDiary"
	BACKTITLE="FAB_DIARY PROUDLY AND HAPPILY PRESENTS !"
	MENU="Choose one and let me make it happen"

	OPTIONS=(1 "CREATE NEW ENTRY"
		 2 "EDIT AN ENTRY"
		 3 "DELETE AN ENTRY"
		 4 "SEARCH ENTRY CONTENT WITH KEYWORD"
		 5 "SEARCH ENTRY TITLE WITH KEYWORD"
		 6 "SEARCH ENTRIES WITH DATE STAMP"
		 7 "QUIT"
	)

	CHOICE=$(dialog --clear \
			--no-cancel \
			--title "$TITLE" \
		 	--backtitle "$BACKTITLE" \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty
		)
	clear

	if [ $CHOICE -eq 1 ]; then
		mkdir -m 777  /home/$(whoami)/fab_diary/$date
		cd /home/$(whoami)/fab_diary/$date
		dialog --title "Creation Manual" --backtitle "Manual pages.." --msgbox "For the following steps: \n 1-Enter the title \n 2-Enter the content \n 3-Then automatically a new entry under the directory with the time stamp of that day will be created." 10 50 
		tempTitle=$(dialog --no-cancel --title "Entry's title:" --inputbox "Give the title for this new entry below" 10 40 --stdout)
		if [ -z "$tempTitle" ]; then
			tempTitle="NULL_TITLE"
		fi
		tempTitle=$(echo "$tempTitle""(""$name"")")
		dialog --no-cancel --title "Adding new note" --editbox $tempTitle 40 40 2>/home/$(whoami)/fab_diary/$date/$tempTitle
		dialog  --title "New Entry Creation" --msgbox  "New entry is created under /home/$(whoami)/fab_diary/$date" 10 40
	fi




	if [ $CHOICE -eq 2 ]; then
		dialog --no-cancel --title "Manual" --backtitle "Know How Part.." --msgbox "You can navigate through the files by using [SPACE] , [TAB] , [ARROW_KEYS]"
		fte=$(dialog --no-cancel --stdout --title "Choose a file to edit" --fselect /home/$(whoami)/fab_diary 10 10)
		dialog --no-cancel --editbox $fte 20 40 2>f
		cat f > $fte
		rm f

		dialog --title "Warning !" --msgbox "You have successfully edited $fte" 10 40
		
	fi




	if [ $CHOICE -eq 3 ]; then
		ftd=$(dialog --stdout --title "Choose a file to delete" --fselect /home/$(whoami)/fab_diary 10 10)
	        fileSelectionResult=$?

		if [ $fileSelectionResult -eq 1 ]; then
			dialog --title "Warning !" --infobox "Gave up on deletion at the time of file selection !"
		fi
		

		dialog --title "Confirmation" \
		       	--yesno "You are about to delete a file, do you want to continue ?" 10 30
	
		delResponse=$?
		case $delResponse in
			0)dialog --title "Warning !" \
			       	--msgbox "$ftd successfully deleted." 10 30;
		       	rm -r -f $ftd;;
			1)dialog --title "Warning !" \
			       	--msgbox "You have terminated deletion !" 10 30;;
			255)echo "Pressed [ESC], nothing happens."
		esac
		
	fi	

	if [ $CHOICE -eq 4 ]; then 
		keyword=$(dialog --title "Search Engine" --backtitle "Search with the keyword" --inputbox "Give the keyword to search through journal below:" 30 30 --output-fd 1) 
		export GREP_OPTIONS='--color=auto'
		cd /home/$(whoami)/fab_diary/
		grep -rni --color "$keyword"  > searchRes.txt
		dialog --title "Search results:" \
		       --msgbox "Here is your results listing with file names and line numbers after: \n $(cat searchRes.txt) \n " 50 70
		rm searchRes.txt
	fi
	if [ $CHOICE -eq 5 ]; then
		titleKeyword=$(dialog --title "Search Engine" --backtitle "Search through titles with keyword" --inputbox "Give the keyword:" 30 30 --output-fd 1 )
		export GREP_OPTIONS='--color=auto'
		cd /home/$(whoami)/fab_diary
		# find -name *$titleKeyword* > titleRes.txt
		dialog --title "Title search results:" --msgbox "Info:Paths are relative to /home/$(whoami)/fab_diary \n Search result: $(find -name *$titleKeyword*)" 25 40
		#rm /home/$(whoami)/fab_diary/titleRes.txt
	fi

	if [ $CHOICE -eq 6 ]; then
		dialog --no-cancel --title "Search Engine" --calendar "Search between date stamps of entries:" 0 0 2> search.txt
		
		
		find -name *$(sed "s/\//-/g" search.txt)* > dateRes.txt
		if [ -s dateRes.txt ]; then
			dialog --no-cancel --title "Date search result" --msgbox "Someone has created entries that day.\n And here is the listing of that date's entries:\n $(ls -1 /home/$(whoami)/fab_diary/$(sed "s/\//-/g" search.txt))" 15 40
		else
			dialog --no-cancel --title "Date search result, none !" --msgbox "There is no entry for the date you have entered !" 10 30
		fi
		
		rm dateRes.txt search.txt
		
	
		
		
		
	fi
	if [ $CHOICE -eq 7 ]; then

		dialog --title "Termination" --backtitle "About to Terminate the script..." --yesno "Are you sure you want to QUIT? This amazing and fabolous app?" 10 40 
		response=$?


	
		case $response in 
			0) dialog --title "Encryption !" --backtitle "Retrieving user's password for diary.." --msgbox "For the next screen please give a password to protect the directory with a password for your privacy !" 10 40;cd /home/$(whoami)/ ;zip -e -r encFabDiary.zip fab_diary; dialog --title "Protected !" --msgbox "Now, your diary is safe ! No sniffing around ;)" 10 40 ;rm -r /home/$(whoami)/fab_diary; clear; exit;;
			1) dialog --title "Quit" --msgbox "You chose to stay !" 5 40;;
			255) dialog --title "ESC_press" \ 
			            --msgbox "You panicked and hit ESC i think." 20 20

		esac
	fi

done		
	





