#!bin/bash

if  [[ $1 =~ ^[A-Za-z]+$".txt" ]]; then
	Pass="$(cat /dev/urandom | tr -d -c 'a-zA-Z0-9' | fold -w 28 | head -n 1)"

	echo "$Pass" > "${1}"

	#Using Last modified Date
	#key=$(echo "$(ls -l ${1} | cut -d ' ' -f8 | cut -d ':' -f1)")

	# Using created Date
	hehe=$(ls -i ${1} | cut -d ' ' -f1)
	disk=$(df -T ./${1} | cut -d ' ' -f1)
	disk=${disk//Filesystem}

	echo -n "Root Pass : "
	read rootPass

	createDate=$(sudo -S <<< "$rootPass" debugfs -R "stat <$hehe>"  $disk | grep "crtime")
	key=$(echo "$createDate" | cut -d ' ' -f7 | cut -d ':' -f1)

	Filename=$(echo "${1}" | cut -d '.' -f1)

	a=({a..z})
	b=({A..Z})

	shift=()
	shift+=("${a[@]:(-(26-$key))}")
	shift+=("${a[@]:0:$(($key+1))}")

	SHIFT=()
	SHIFT+=("${b[@]:(-(26-$key))}")
	SHIFT+=("${b[@]:0:$(($key+1))}")

	Filename=$(echo $Filename | tr "${a[*]}" "${shift[*]}" | tr "${b[*]}" "${SHIFT[*]}")
	Filename="$Filename".txt
	
	mv ${1} ${Filename}

elif [[ $1 != *".txt" ]]; then
	echo "File extension must be .txt"
else
	echo "Invalid Filename, must be Alphabet name"
fi