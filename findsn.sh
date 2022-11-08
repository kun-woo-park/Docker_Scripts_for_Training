IP=$(ip route get 8.8.8.8 | awk -F"via " 'NR==1{split($2,a," ");print a[1]}' | awk 'NR==1{split($1,a,".");print a[1] "."a[2]"."a[3]}').0/24
echo "$IP"
