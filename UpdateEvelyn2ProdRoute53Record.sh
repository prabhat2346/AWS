#!/bin/bash 

#EC2 INSTANCE IDS FOR WHICH, WE NEED TO UPDATE THE ROUTE53 RECORDS WITH THEIR PUBLIC IPS 
EC2_INSTANCE_IDs=" 
i-0051050688f56fd33 
i-01a73900a81955da9 
i-0223a28edb48be4e4 
i-027f4bffaf1b772c9 
i-03ca819f949b29dae 
i-0405cfd6b155814ad 
i-048d41fc346a16fb8 
i-04b8d36784c5bba94 
i-0505450edd073142d 
i-08759b3a8fce6525e 
i-093dbf06fc6af1583 
i-09458c6f9b151e67a 
i-0aba7708eb0a69fe8 
i-0ad5df6ace6491b09 
i-0c8ca4f1021fa1a89 
i-0c94221b0119da7d6 
i-0d02836947d004021 
i-0f0afa89dc4e6c66b 
i-0fae95459cb64de90 
" 
# Extract tags (AUTO_DNS_ZONE and AUTO_DNS_NAME) associated with instance & Extract information (PublicIpAddress) about the Instance 
for INSTANCE_ID in $EC2_INSTANCE_IDs 
do 

       ZONE_TAG=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=AUTO_DNS_ZONE" | grep Value | grep -o
P '(?<="Value": ")[^"]*') 
       NAME_TAG=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=AUTO_DNS_NAME" | grep Value | grep -o
P '(?<="Value": ")[^"]*') 
       MY_IP=$(aws ec2 describe-instances --filters "Name=instance-id,Values=$INSTANCE_ID" | grep PublicIpAddress | grep -oP '(?<="PublicIpAddr
ess": ")[^"]*') 

#CHECKING THE STATS IN THE LOOP 
echo $ZONE_TAG 
echo $NAME_TAG 
echo $MY_IP 
echo "----------" 

# Update Route 53 Record Set based on the Name tag to the current Public IP address of the Instance 
#aws route53 change-resource-record-sets --hosted-zone-id $ZONE_TAG --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"'$NAME_TAG'","Type":"A","TTL":0,"ResourceRecords":[{"Value":"'$MY_IP'"}]}}]}' 
done
