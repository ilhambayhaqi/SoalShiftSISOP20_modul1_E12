#!bin/bash

#bagian A
awk '
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
echo -n "$minReg" > Region.txt && minReg="$(cat Region.txt)"

echo "Region :"
echo "$(cat Region.txt)"
echo $'\n'

#bagian B
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

#Bagian C Versi 1 (10 Product dari State bagian B dicampur)
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

#Bagian C Versi 2(10 Product dari masing masing State bagian B)
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