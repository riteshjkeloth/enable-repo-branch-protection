#!/bin/bash

orgName=$1
token=$2
fromDate=${3:-"2022-02-18"}
currDir=${4:-"."}
branchName=${5:-"main"}
githubApiUrl=${6:-"https://api.github.com"}

echo "$currDir"

if [[ ($# -eq 0) || ($# -eq 1) ]]
  then
    echo "ERROR: Invalid number of arguments supplied. Expected organization-name and token"
    echo "     e.g."
    echo "       enable-repo-branch.protection.sh abcorg.inc token123"
    exit 1
fi

  # fetch the list of repos in the Github organization
  echo "Fetching the list of repos for organization: $orgName"
  listresponse=$(curl -sw '%{http_code}' \
    -X GET \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization:token $token" \
    $githubApiUrl/orgs/$orgName/repos -o $currDir/working/repoList.json)

    if [ "$listresponse" -eq 200 ]; then
      echo "Fetched list of repos successfully!"
    else
      echo "ERROR: Something went wrong while fetching repo details for organization"
      echo "ERROR: HTTP response code received:$listresponse"
      exit 1
    fi;

  #fetch project urls created after the input date
#  repoFullNames=$(jq -r '.[].full_name' $currDir/working/repoList.json)
  repoFullNames=$(jq --arg s "$fromDate" -r '.[] | select(.created_at > (($s| strptime("%Y-%m-%d")) | strftime("%Y-%m-%d"))) | .full_name' $currDir/working/repoList.json)

  # initialize status file
  header="%40s\t|\t%5s\n"
  sep="=========================================="
  format="%40s\t|\t%5d\n"
  width=65
  printf "$header" "REPO-NAME(Full)" "STATUS" > $currDir/working/status.file
  printf "%$width.${width}s\n" "$sep$sep" >> $currDir/working/status.file

  # loop through project list to set the protection rules
  for repoFullName in ${repoFullNames[@]}; do
    response=$(curl -sw '%{http_code}' \
                -X PUT \
                -H "Accept: application/vnd.github.v3+json" \
                -H "Authorization:token $token" \
                -o /dev/null \
                $githubApiUrl/repos/$repoFullName/branches/$branchName/protection \
                -d "@${currDir}/rules/branch-protection-rule.json")

    # update status file
    printf "$format" \
    "$repoFullName" "$response" >> $currDir/working/status.file
  done

  # print statuses
  echo "Status Report:"
  cat $currDir/working/status.file
