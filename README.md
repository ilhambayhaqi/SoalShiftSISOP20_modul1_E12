# SoalShiftSISOP20_modul1_E12
Repository Soal Shift Modul 1

**Soal 1**  
```awk '
BEGIN{
	FS="\t"; 
	RS="\r\n";
}
NR>1{
	arr[$13]+=$21;
}
END{
	for(a in arr) printf("%s|%d\n",a, arr[a]);
}
' Sample-Superstore.tsv > Region.txt &&

sort -n -t '-' -k2 -o Region.txt Region.txt &&

minReg="$(awk -F'|' 'NR==1{ print $1 }' Region.txt)"
echo -n "$minReg" > Region.txt && minReg="$(cat Region.txt)"`

echo "Region :"
echo "$(cat Region.txt)"
echo $'\n'
```

Pada soal 1A, dilakukan grouping terhadap Region berdasarkan profitnya. Kemudian dilakukan sorting menggunakan bash command menurut profit. Untuk mengambil melakukan print profit terkecil dari Region, digunakan kembali AWK dengan menampilkan hasil sorting pada record pertama.

```
awk -v var=$minReg '
BEGIN{
	FS="\t";
	RS="\r\n";
}
NR>1{
	if($13 == var){
		arr[$11]+=$21;
	}
}
END{
	for(a in arr) printf("%s|%d\n",a, arr[a]);
}
' Sample-Superstore.tsv > State.txt  &&

sort -h -t '|' -k2 -o State.txt State.txt &&

minState="$(awk -F'|' 'NR<=2{ print $1 }' State.txt)"
echo "$minState" > State.txt && minState="$(cat State.txt)"

echo "State :"
echo "$(cat State.txt)"
echo $'\n'

```
Untuk problem 1B, dilakukan passing variabel dari problem 1A, kemudian seperti langkah penyelesaian problem 1A, dilakukan grouping untuk tiap State dengan catatan apabila Region merupakan Region hasil output problem 1A. Kemudian dilakukan sorting menggunakan bash command dan langkah terakhir dilakukan filter menggunakan AWK untuk menampilkan 2 State dengan profit terkecil berdasarkan Region pada 1A.

```
awk -v var="$minState" '
BEGIN{
	FS="\t";
	RS="\r\n";
	counter=split(var,list,"\n");
}
NR>1{
	for(i=1; i<=counter; i++){
		if($11 == list[i]){
			arr[$17]+=$21;
		}
	}
}
END{
	for(a in arr) printf("%s|%d\n",a,arr[a]);
}
' Sample-Superstore.tsv > ProductName.txt

sort -h -t '|' -k2 -o ProductName.txt ProductName.txt &&

minProduct="$(awk -F'|' 'NR<=10{ print $1 }' ProductName.txt)"
echo "$minProduct" > ProductName.txt && minProduct="$(cat ProductName.txt)"

echo "ProductName :"
echo "$(cat ProductName.txt)"
echo $'\n'

```
![soal1_a](https://user-images.githubusercontent.com/57692117/75609042-e3b76f80-5b37-11ea-9aac-ec68aad0d1fb.png)

Pada Problem 1C, kami menyertakan dua solusi, solusi diatas merupakan salah satu solusi dengan menganggap mencari 10 produk dengan profit terendah dari gabungan state output problem 1B. Pada kasus ini, cara yang digunakan juga masih sama dengan penyelesaian 1B hanya saja menggunakan filter ```if($11 == list[i])``` dimana list merupakan array yang menyimpan State dari problem 1B. Kemudian dilakukan sort dan diprint 10 nama produk.

```
awk -v var="$minState" '
BEGIN{
	FS="\t";
	RS="\r\n";
	counter=split(var,list,"\n");
}
NR>1{
	for(i=1; i<=counter; i++){
		if($11 == list[i]){
			arr[$17,list[i]]+=$21;
		}
	}
}
END{
	for(i in list){
		for(j in arr){
			split(j, k, SUBSEP);
			if(k[2] == list[i]){
				printf("%s|%d\n", k[1],arr[j]) > "ProductName"list[i]".txt";
			}
		}
	}
	
}
' Sample-Superstore.tsv

while read -r i ; do
	sort -h -t '|' -k2 -o "ProductName${i}.txt" "ProductName${i}.txt"
	minProduct="$(awk -F'|' 'NR<=10{ print $1 }' "ProductName${i}.txt")"
	echo "$minProduct" > "ProductName${i}.txt"
	echo "ProductName ${i} :"
	echo "$(cat ProductName${i}.txt)"
	echo $'\n'
done < State.txt
```
![soal1_b](https://user-images.githubusercontent.com/57692117/75609087-46a90680-5b38-11ea-9744-522eced33861.png)

Cara kedua pada problem 1C adalah bila diasumsikan untuk mencetak 10 nama produk untuk masing-masing state. Pada kasus ini digunakan set array pada awk dengan input parameter variabel dari file output problem 1B. Disini kemudian dilakukan pengecekan untuk tiap member dari list dengan ```if($11 == list[i]``` kemudian untuk dilakukan nested loop dimana setiap loop, akan mencetak hasil filter pada ```ProductName(nama_State).txt```. Dari hasil output tersebut dilakukan sorting dan digunakan awk untuk menampilkan 10 nama produk dengan profit terkecil untuk tiap tiap output file.
Kesulitan pada cara kedua adalah pada penerapan array dikarenakan pada awk tidak mengenal konsep multidimensional array.


**Soal 2** 
```
#!bin/bash

if  [[ $1 =~ ^[A-Za-z]+$".txt" ]]; then
	
	Pass=""

	while [[ !($Pass == *[A-Z]*) || !($Pass == *[a-z]*) || !($Pass == *[0-9]*) ]]; do
		Pass="$(cat /dev/urandom | tr -d -c 'a-zA-Z0-9' | fold -w 28 | head -n 1)"
	done
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
```

Pada problem ini, diminta untuk menyimpan random password dengan length 28 yang mencakup karakter Alphanumeric pada file txt dengan nama file sesuai argument yang dipassing. Untuk mengenerate password kami menggunakan  
```
	Pass=""

	while [[ !($Pass == *[A-Z]*) || !($Pass == *[a-z]*) || !($Pass == *[0-9]*) ]]; do
		Pass="$(cat /dev/urandom | tr -d -c 'a-zA-Z0-9' | fold -w 28 | head -n 1)"
	done
```
Looping while pada code diatas untuk mengatasi password random yang dibuat jika tidak mencakup huruf kapital, kecil, dan angka.

Kemudian untuk problem 2B, dimana input argument harus berekstensi .txt dan hanya terdiri dari Alphabet dilakukan filtering dengan menggunakan percabangan sebagai berikut.
```
if  [[ $1 =~ ^[A-Za-z]+$".txt" ]]; then
...
elif [[ $1 != *".txt" ]]; then
	echo "File extension must be .txt"
else
	echo "Invalid Filename, must be Alphabet name"
fi
```
Kemudian pada poin C dilakukan enkripsi dengan Caesar Cipher dengan key merupakan hasil file tersebut digunakan. Untuk menentukan waktu file di-create, ada dua pendekatan. Pendekatan yang pertama didasarkan dengan latest modified date dengan key sebagai berikut. 
```
key=$(echo "$(ls -l ${1} | cut -d ' ' -f8 | cut -d ':' -f1)")
```
Pendekatan dengan latest modified date lebih mudah dan aman namun file dapat menyebabkan kesalahan pada dekripsi ketika file diubah misalnya file dipindah dan dikembalikan. Sedangkan pendekatan kedua adalah penentuan key menggunakan ```crtime``` sebagai berikut.
```
hehe=$(ls -i ${1} | cut -d ' ' -f1)
	disk=$(df -T ./${1} | cut -d ' ' -f1)
	disk=${disk//Filesystem}

	echo -n "Root Pass : "
	read rootPass

	createDate=$(sudo -S <<< "$rootPass" debugfs -R "stat <$hehe>"  $disk | grep "crtime")
	key=$(echo "$createDate" | cut -d ' ' -f7 | cut -d ':' -f1)
```
Pendekatan ini melakukan handling terhadap perubahan pada file seperti pemindahan file ke direktori lainnya, namun pada metode ini dibutuhkan password root karena perintah harus dijalakan dengan ```sudo```.   
Kemudian script kedua merupakan script decrypt, konsep script ini sama dengan script encrypt dimana hanya melakukan perubahan pada key menjadi ```let "key=26-${key}"```

![soal2](https://user-images.githubusercontent.com/57692117/75609278-cb485480-5b39-11ea-942c-d787c327241a.png)

**Soal 3**
```
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
```
Pada problem 3A ini, kita diminta untuk mendownload gambar sebanyak 28 kali pada link yang telah disediakan dan juga mencatat log nya. Untuk melakukan ini sebagai berikut. 
```
for (( i = 1; i <= 28; i++ )); do
	wget -O "$Filename$i" "https://loremflickr.com/320/240/cat" -a "wget.log"
	grep "Location" wget.log > location.log
	...
done

cp wget.log wget.log.bak
cp location.log location.log.bak
```
Untuk problem 3B, diminta untuk melakukan download otomatis setiap 8 jam dimulai dari pukul 6.05 setiap hari kecuali Sabtu. Untuk melakukannya dibuat command pada crontab sebagai berikut.
```
5 6,14,22 * * 0-5 bash /home/almond/Sisop/Praktikum1/soal3/soal3.sh
```
Dengan menjalankan crontab, masih ada masalah yang didapatkan yaitu script akan dijalankan pada path home, sehingga untuk mengatasinya pada awal script dibuat command ```cd /home/almond/Sisop/Praktikum1/soal3``` untuk berpindah pada path yang diinginkan  
Kemudian untuk problem 3c, kita diminta untuk melakukan identifikasi gambar yang telah didownload dan dimasukkan ke folder kenangan dan duplikat untuk file duplikat yang terdapat pada folder kenangan. Pertama dilakukan pembuatan folder kenangan dan duplikat sebagai berikut.
```
if [[ ! -d ./kenangan ]]; then
	mkdir kenangan
fi
if [[ ! -d ./duplicate ]]; then
	mkdir duplicate
fi
```
Untuk menentukan index terakhir pada masing masing folder dilakukan dengan
```
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
```
Dan terakhir untuk melakukan identifikasi digunakan perbandingan pada location.log. Untuk codenya sebagai berikut.
```
	if [[ countFile -eq 1 ]]; then
		mv $Filename$i ./kenangan/$Kenangan${lastKenangan}
	else
		mv $Filename$i ./duplicate/$Duplicate${lastDuplicate}
	fi
```
Selesai. :)



	
