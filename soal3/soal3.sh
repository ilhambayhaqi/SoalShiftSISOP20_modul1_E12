#!bin/bash

Filename="pdkt_kusuma_"
Kenangan="kenangan_"
Duplicate="duplicate_"

cd /home/almond/Sisop/Praktikum1/soal3

for (( i = 1; i <= 28; i++ )); do
	wget -O "$Filename$i" "https://loremflickr.com/320/240/cat" -a "wget.log"
	grep "Location" wget.log > location.log
	

	if [[ ! -d ./kenangan ]]; then
		mkdir kenangan
	fi

	if [[ ! -d ./duplicate ]]; then
		mkdir duplicate
	fi

	if [[ $(ls ./kenangan | wc -l) -eq 0 ]]; then
		lastKenangan=0;
	else
		lastKenangan="$(ls ./kenangan | awk -v var=$kenangan '{gsub("_"," ")}{print $2}' | sort -n | tail -n1 )"
	fi

	if [[ $(ls ./duplicate | wc -l) -eq 0 ]]; then
		lastDuplicate=0;	
	else
		lastDuplicate="$(ls ./duplicate | awk -v var=$duplicate '{gsub("_"," ")}{print $2}' | sort -n | tail -n1 )"
	fi


	thisFile=$(cat location.log | tail -n1 | awk '{print $2}' )
	countFile=$(grep "$thisFile" location.log | wc -l)

	let lastDuplicate=$lastDuplicate+1
	let lastKenangan=$lastKenangan+1

	if [[ countFile -eq 1 ]]; then
		mv $Filename$i ./kenangan/$Kenangan${lastKenangan}
	else
		mv $Filename$i ./duplicate/$Duplicate${lastDuplicate}
	fi
done

cp wget.log wget.log.bak
cp location.log location.log.bak
