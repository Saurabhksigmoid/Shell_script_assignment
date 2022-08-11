#!/bin/bash

echo  "Enter Component (INGESTOR/JOINER/WRANGLER/VALIDATOR?) in caps"
read input1
if [[ $input1 == "INGESTOR" || $input1 == "JOINER" || $input1 == "WRANGLER" || $input1 == "VALIDATOR" ]]
	then
        echo "Component:" $input1
else
	echo "Enter valid input"
	exit
fi

echo "Enter Scale (LOW/MID/HIGH) in caps"
read input2
if  [[ $input2 == "LOW" || $input2 == "MID" || $input2 == "HIGH"  ]]
	then
        echo "Scale:" $input2
else
    echo "Enter valid input"
	exit
fi

echo "AUCTION or BID"
read input3
if  [[ $input3 == "BID" || $input3 == "AUCTION"  ]] 
	then
		echo "You want to "$input3
else
    echo "Enter valid input"
	exit
fi

if [[ $input3 == "BID" ]]
	then
		input3="vdopiasample-bid"
else
	input3="vdopiasample"
fi


echo "Enter count (0-9)"
read input4
if  [[ "$input4" == [1-9] ]] 
	then
       	echo "Count is:" $input4
	
else
    echo "Please enter valid input"
	exit
fi

#creating temp file to store user input

> temp

# reading sig.conf file to be edited

error=0
for x in $(cat sig.conf) 
	do
		if [[ $(echo $x | awk -F';' '{print $1}') == "$input3" && $(echo $x | awk -F';' '{print $3}') == "$input1" ]]
			then
	       		echo "$x" | sed  "s/[0-9]/$input4/g; s/LOW/$input2/g; s/MID/$input2/g; s/HIGH/$input2/g" >> temp
				error=1
		else 
			echo "$x" >> temp
		fi	
done

if [[ $error == 0 ]]
	then
		echo "Error: Input not found"
		exit
fi

#replacing temp input with sig.conf

mv temp sig.conf