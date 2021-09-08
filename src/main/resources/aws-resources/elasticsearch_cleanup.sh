#!/bin/bash

domainName=comments
isDomainPresent=true
errorFlag=false
CARD_TRUE='true'
CARD_FALSE='false'

#1.- Check if domain already exists
    aws es list-domain-names --query DomainNames[*] | grep $domainName || isDomainPresent=false

#2.- If not then creates domain
    if [ $isDomainPresent == $CARD_TRUE ]
        then
            aws es delete-elasticsearch-domain --domain-name $domainName
            echo "Domain $domainName deleted successfully."
        else
            #3.- Else send a message telling the domain already exists
            echo "Domain $domainName doesn't exist."
    fi
