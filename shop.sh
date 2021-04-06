#!/bin/bash

# add to card function
function add_product_to_cart() {
	COUNT=`expr $1 - 1`
	echo $COUNT >> cart
}

# delete all products from the card
function clean_cart() {
	cat /dev/null > cart
}

# select a product
function select_product() {
	echo "These are the toppings available: "
	echo "-------------------------"
	counter=1
	for topping in ${toppings[@]}
	do
	echo "$counter.$topping"
	((counter++))
	done
	echo "-------------------------"
	read -p "Choose one toppings [1 - 8] >> " selection	
	add_product_to_cart $selection	
	echo "Product added"
}

#show card function
function show_cart() {
	echo ""
	declare -A cart_map
	echo "Card content:"
	while read -r line;
	do	
		if [ ${cart_map[$line,0]+abc} ]
		then			
			cardItem=${cart_map[$line,1]}
			newCount=`expr $cardItem + 1`
			cart_map[$line,1]=$newCount;
		else	
			cart_map[$line,0]=$line;
			cart_map[$line,1]=1;
		fi
		
	sequence=0
	productString=''
	done < cart
	for i in "${!cart_map[@]}"
	do		
	  	if [[ $i == *,0 ]]
		  then
			productString="${toppings[${cart_map[$i]}]}"
			productPrice="${prices[${cart_map[$i]}]}"
		  else		
			
			productQuantity=${cart_map[$i]}					
		fi

		if [ $sequence -eq 0 ]
		then
			sequence=1
		else
			calcString="$productQuantity * $productPrice"
			price=$(bc <<< $calcString)
			productString="${productString}"" X${productQuantity} ""Price: $price"
			echo $productString
			sequence=0
		fi
	done
	
}

# deletes product from the cart by ID
function delete_product_from_cart() {
	echo "These are the toppings available: "
	echo "-------------------------"
	counter=1
	for topping in ${toppings[@]}
	do
	echo "$counter.$topping"
	((counter++))
	done
	echo "-------------------------"
	show_cart	
	read -p "Enter product id >> " input	
	echo $input
	product_id=`expr $input - 1`	

	while read -r line;	
	do
				
		if [ $line -eq $product_id ]
		then			
			product_id=-1
		else	
			echo $line >> tmp_cart
		fi
	done < cart

	rm -rf cart
	mv tmp_cart cart
}


array=(2 5 7 2 8 7)

toppings=(Pepperoni Ham Tomatoes Onions Jalapeno Cheese Res_Pepper Black_Olives)
prices=(0.50 0.35 0.40 0.35 0.55 0.60 0.75 0.80)

cartMode=false
select_product
while :
do
	
	echo "continue shopping or view cart?"
	echo ""
	echo "Actions list"
	echo "1 continue shopping"
	echo "2 view the cart"	
	echo "3 delete product from cart"
	echo "4 clean cart"
	echo "5 exit"
	read -p "Select option >> " action

	case $action in 
	1) select_product;;
	2) show_cart;;
	3) delete_product_from_cart;;
	4) clean_cart;;
	5) exit;;
	esac
	
done

case $selection in 
1) echo "${toppings[0]} - \$${prices[0]}, great selection";;
2) echo "${toppings[1]}, great selection";;
3) echo "${toppings[2]}, great selection";;
esac



