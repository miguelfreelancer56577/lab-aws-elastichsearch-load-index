#!/bin/bash

domainName=comments
isDomainPresent=true
isTableActive=false
errorFlag=false
timeout=10
CARD_TRUE='true'
CARD_FALSE='false'
CARD_ACTIVE='"ACTIVE"'
rs=''

#1.- Check if table already exist
    aws es list-domain-names --query DomainNames[*] | grep $domainName || isDomainPresent=false

#2.- If it doesn't exist then create the domain
    if [ $isDomainPresent == $CARD_FALSE ]
        then
            aws es create-elasticsearch-domain \
            --domain-name $domainName \
            --elasticsearch-version 7.10 \
            --elasticsearch-cluster-config InstanceType=t3.small.elasticsearch,InstanceCount=1 \
            --ebs-options EBSEnabled=true,VolumeType=gp2,VolumeSize=10 \
            --access-policies '{ "Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Principal": { "AWS": [ "arn:aws:iam::941855257042:user/mtr_dev_usr" ] }, "Action": [ "es:*" ], "Resource": "*" } ] }' || errorFlag=true
            
            if [ $errorFlag == $CARD_FALSE ]
                then
                    echo "Domain $domainName was created successfully"
                else
                    #2.3.- If not then send a mmessage telling there was an error to create the table
                    echo 'there was an error to create the domain'
            fi
        else
            #3.- Else send a message telling the table already exist
            echo "Domain $domainName already exists"
    fi

#aws es describe-elasticsearch-domain --domain-name comments