#defaults
STAGE="dev"
PROFILE="cta-dev"
DEFAULT_REGION="us-east-1"

help ()
{
  echo "Usage: $0 [-h] [-a aws-profile]"
  echo "$0 -p p2c-dev"
}

search_json_array () { 

  JSON_ARRAY=$1
  STAGE=$2
  KEY='.'$3
  VALUE='.'$4

  for row in $(echo $1 | jq -r '.[] | @base64'); do
    _jq() {
      echo ${row} | base64 --decode | jq -r ${1}
    }


    if echo "$(_jq $KEY)" | grep -q "$STAGE"; then
      echo $(_jq $VALUE)
    fi
  done
}

while getopts ":hr:p:" option; do
  case "$option" in
    h)
        help
        exit 0
        ;;
    a)
        PROFILE="$OPTARG"
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

#USER_POOL_ID=$(aws --profile $PROFILE --region $DEFAULT_REGION cognito-idp  list-user-pools --max-results 1 | jq -r .UserPools[0].Id)
#USER_POOL_REGION=$(echo $USER_POOL_ID | cut -d'_' -f 1 )
USERPOOLS=$(aws --profile $PROFILE --region $DEFAULT_REGION cognito-idp  list-user-pools --max-results 60 | jq -r .UserPools)
USER_POOL_ID=$(search_json_array "$USERPOOLS" $STAGE Name Id)
USERPOOL_CLIENTS=$(aws --profile $PROFILE --region $DEFAULT_REGION cognito-idp list-user-pool-clients --user-pool-id $USER_POOL_ID --max-results 60 | jq -r .UserPoolClients)
USERPOOL_CLIENT_ID=$(search_json_array "$USERPOOL_CLIENTS" $STAGE ClientName ClientId)
#IDENTITY_POOL_ID=$(aws --profile $PROFILE --region $DEFAULT_REGION cognito-identity list-identity-pools --max-results 1 | jq -r .IdentityPools[0].IdentityPoolId)
IDENTITY_POOLS=$(aws --profile $PROFILE --region $DEFAULT_REGION cognito-identity list-identity-pools --max-results 60 | jq -r .IdentityPools)
IDENTITY_POOL_ID=$(search_json_array "$IDENTITY_POOLS" $STAGE IdentityPoolName IdentityPoolId)
#echo $IDENTITY_POOLS
REST_API_ID=$(aws --profile $PROFILE --region $DEFAULT_REGION apigateway get-rest-apis | jq -r .items[0].id)

echo "STAGE=$STAGE"
echo "PROFILE=$PROFILE"
echo "DEFAULT_REGION=$DEFAULT_REGION"
echo "USER_POOL_ID=$USER_POOL_ID"
echo "USER_POOL_REGION=$DEFAULT_REGION"
echo "USERPOOL_CLIENT_ID=$USERPOOL_CLIENT_ID"
echo "IDENTITY_POOL_ID=$IDENTITY_POOL_ID"
echo "REST_API_ID=$REST_API_ID"
