
#!/bin/bash -ex

###  Add all the proxy related settings 
PROXY_HOST="$1"
PROXY_PORT="$2"
NON_PROXY_HOSTS="$3"

### Choose the environment which you want the config to be updated
STAGE="$3"

### Vault related configuration
VAULT_URL="$4"
VAULT_TOKEN="$5"

###############################################
echo "Updating vault for ${STAGE}"
###############################################

### cd to the directory where the configuration are stored in json files
cd source-master

### Further cd to the staging environment 
cd $STAGE

### echo the current working directory to cross check 
### we are in the right environment folder
pwd

ls

### Core of the script begins here  
for filename in *.json; do
   echo "File Name is ${filename}"
   content=$(cat ${filename}) ## Fetch the content of the json file
   VAULT_NAME=$(echo $filename | cut -f 1 -d '.') ## Get the vault name for which configuration needs to be updated
   echo "Updating ${VAULT_NAME}" 
   echo "Updating ${VAULT_URL}"
   curl -d "${content}" -H "X-Vault-Token:${VAULT_TOKEN}" \
                        -H "Content-Type: application/json" \
                        -X POST --noproxy '*' \
                        -f --connect-timeout 60 \
                        -m 300 ${VAULT_URL}/v1/secret/${VAULT_NAME}
   sleep 10 # Wait for some time for the curl output to be visually displayed over console 
   echo "Update vault with new content : ${content}"
done

