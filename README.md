# SoalShiftSISOP20_modul1_E12
Repository Soal Shift Modul 1

**Soal 1**
Whits adalah seorang mahasiswa teknik informatika. Dia mendapatkan tugas praktikum
untuk membuat laporan berdasarkan data yang ada pada file “Sample-Superstore.tsv”.
Namun dia tidak dapat menyelesaikan tugas tersebut. Laporan yang diminta berupa :
 
- Tentukan wilayah bagian (region) mana yang memiliki keuntungan (profit) paling
sedikit.  
- Tampilkan 2 negara bagian (state) yang memiliki keuntungan (profit) paling
sedikit berdasarkan hasil poin a.  
- Tampilkan 10 produk (product name) yang memiliki keuntungan (profit) paling
sedikit berdasarkan 2 negara bagian (state) hasil poin b.

Whits memohon kepada kalian yang sudah jago mengolah data untuk mengerjakan
laporan tersebut.

Penyelesaian
- soal 1
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
```
Pada Problem 1C, kami menyertakan dua solusi, solusi diatas merupakan salah satu solusi dengan menganggap mencari 10 produk dengan profit terendah dari gabungan state output problem 1B. Pada kasus ini, cara yang digunakan juga masih sama dengan penyelesaian 1B hanya saja menggunakan filter ```if($11 == list[i])``` dimana list merupakan array yang menyimpan State dari problem 1B. Kemudian dilakukan sort dan diprint 10 nama produk.


