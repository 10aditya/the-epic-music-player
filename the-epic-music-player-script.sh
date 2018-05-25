#!/bin/bash
maindirectory=$HOME

if [ -e songs.txt ]; then
	rm songs.txt
else
 	echo >> songs.txt
fi


OIFS="$IFS"
IFS=$'\n'

for file in `find /home -type f -name "*.mp3" 2>&1 | grep -v "Permission denied"`  
	do
	     	echo "$file" >> songs.txt
	done

IFS="$OIFS"

echo "************************************" 
echo "*** Welcome to Epic Music Player ***"
echo "************************************"
echo
echo "Here is the list of songs available in your PC:"
echo

aa="a"
i=1;

while read -r line
	do
		name="$line"
		echo -n "$i. "	
    		echo "$name" | sed -r "s/.+\/(.+)\..+/\1/"
    		i=$[ $i +1 ]
 
	done < "songs.txt"

pfList(){
	cd $maindirectory
	
	echo -n "Enter song number to play: "
	read sn
	
	i=1
	
	while read -r line
		do
    			name="$line"
    			if [ $sn -eq $i ]; then 
       				aa=$name
       				cd "$( dirname "${aa}" )"
				echo "Press CTRL+C to stop playing a song."    			    	    
				mpg123 -C "$aa" | sed -r "s/.+\/(.+)\..+/\1/"	
    				break
			fi    
    
    			i=$[ $i +1 ]
		done < $1
}

searchSongByName(){
	cd $maindirectory
	
	if [ -e sresults.txt ]; then	
		rm sresults.txt
	else
 		echo >> sresults.txt
	fi
	
	echo -n "Enter song name to search: "
	read sn

	echo $sn
	
	i=1

	OIFS="$IFS"
	IFS=$'\n'

	for file in ` find /home -type f -iname "*.mp3" -a -iname "*$sn*" 2>&1 | grep -v "Permission denied"`  
	do
	     	echo "$file" >> sresults.txt
	done

	IFS="$OIFS"

	i=1;

	while read -r line
		do
			name="$line"
			echo -n "$i. "	
    			echo "$name" | sed -r "s/.+\/(.+)\..+/\1/"
    			i=$[ $i +1 ]
 
		done < "sresults.txt"

	pfList "sresults.txt"
			 
}
while true
	do
		echo
		echo "MENU:"
		echo "1. Play a song from above list"
		echo "2. Search a song by name"
		echo "3. Exit"
		echo
		echo -n "Enter choice: "
		read choice
		case $choice in
			1) pfList "songs.txt";;
			2) searchSongByName;;
			3) exit;;
			*) exit;;
		esac
		echo
	done
