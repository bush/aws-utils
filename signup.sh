#!/bin/bash
PROFILE="cta-dev"
USERNAME="admin@example.com"
PASSWORD="Passw0rd!"

. ./env

help ()
{
  echo "Usage: $0 [-h] [-a aws-profile] [-u username] [-p password]"
  echo "$0 -a p2c-prod -u admin@example.com -p Passw0rd!"
}

while getopts ":ha:u:p:" option; do
  case "$option" in
    h)
        help
        exit 0
        ;;
    a)
        PROFILE="$OPTARG"
        ;;
    u)
        USERNAME="$OPTARG"
        ;;
    p)
        PASSWORD="$OPTARG"
        ;;
    :)
        echo "Error: -$OPTARG requires an argument" 
        help
        exit 0
        ;;
    ?)
        echo "Error: unknown option -$OPTARG" 
        help
        exit 0
        ;;
  esac
done

echo "Profile: $PROFILE"
echo "User pool region: $USER_POOL_REGION"
echo "Client ID: $APP_CLIENT_ID"
echo "Username: $USERNAME"
echo "Password: $PASSWORD"

aws --profile $PROFILE cognito-idp sign-up \
  --region $USER_POOL_REGION \
  --client-id $APP_CLIENT_ID \
  --username $USERNAME \
  --password $PASSWORD

aws --profile $PROFILE cognito-idp admin-confirm-sign-up \
  --region $USER_POOL_REGION \
  --user-pool-id $USER_POOL_ID \
  --username $USERNAME 
