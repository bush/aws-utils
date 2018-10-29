#defaults
STAGE="dev"
PROFILE="p2c-dev"
DEFAULT_REGION="us-east-1"

help ()
{
  echo "Usage: $0 [-h] [-a aws-profile]"
  echo "$0 -p p2c-dev"
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

USER_POOL_ID=$(aws --profile $PROFILE cognito-idp  list-user-pools --max-results 1 | jq -r .UserPools[0].Id)
USER_POOL_REGION=$(echo $USER_POOL_ID | cut -d'_' -f 1 )
APP_CLIENT_ID=$(aws --profile p2c-dev cognito-idp list-user-pool-clients --user-pool-id $USER_POOL_ID --max-results 1 | jq -r .UserPoolClients[0].ClientId)
IDENTITY_POOL_ID=$(aws --profile p2c-dev cognito-identity list-identity-pools --max-results 1 | jq -r .IdentityPools[0].IdentityPoolId)
REST_API_ID=$(aws --profile p2c-dev apigateway get-rest-apis | jq -r .items[0].id)

echo "STAGE=$STAGE"
echo "PROFILE=$PROFILE"
echo "DEFAULT_REGION=$DEFAULT_REGION"
echo "USER_POOL_ID=$USER_POOL_ID"
echo "USER_POOL_REGION=$USER_POOL_REGION"
echo "APP_CLIENT_ID=$APP_CLIENT_ID"
echo "IDENTITY_POOL_ID=$IDENTITY_POOL_ID"
echo "REST_API_ID=$REST_API_ID"
