#!/bin/sh

#Get list of files names within the policies/ folder
policies_folder="policies"

# get list of files in folder and store in array
cd "$policies_folder"
policies=($(ls *.json))
# policies=("test" "")

existing_policies=$(aws organizations list-policies --filter TAG_POLICY)
echo "List of existing policies that: $existing_policies"
# --query 'Policies[].[Name, Id]'

for policy_file in "${policies[@]}"
do
        # Check if the specified policy exists in the list
        policy_name=$(basename "${policy_file%.*}")

        id=$(echo "$existing_policies" | jq -r ".Policies[] | select(.Name==\"$policy_name\")  | .Id")
        if [ -z "$id" ]; then
                echo "The $policy_name policy does not exist. Creating one now"
                res=$(aws organizations create-policy --name "$policy_name" --description "created through automation" --type TAG_POLICY --content file://"$policy_file")
                id=$(jq -r '.Policy.PolicySummary.Id' <<< $res)
                # id=res["Policy"]["PolicySummary"]["Id"]

        else
                echo "Updating policy: $policy_name"
                res=$(aws organizations update-policy --policy-id "$id" --content file://"$policy_file")

        fi

        #Apply the policy to the OU
        roots=$(aws organizations list-roots)
        root_id=$(jq -r '.Roots[0].Id' <<< $roots)
        # root_id=$roots[0]["Id"]
        echo "Applying $policy_name with id $id to $root_id"
        attachment_res=$(aws organizations attach-policy --policy-id "$id" --target-id "$root_id")

done
