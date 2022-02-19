#!/bin/bash

orgName=$1
TOKEN=$2
branchName=${3:-"main"}
githubApiUrl=${4:-"https://api.github.com"}

if [[ ($# -eq 0) || ($# -eq 1) ]]
  then
    echo "ERROR: Invalid number of arguments supplied. Expected organization-name and token"
    echo "       e.g."
    echo "       enable-repo-branch.protection.sh abcorg.inc token123"
    exit 1
fi

  # fetch the list of repos in the Github organization
  echo "Fetching the list of repos for organization: $orgName"
  listresponse=$(curl -sw '%{http_code}' \
    -X GET \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization:token $TOKEN" \
    $githubApiUrl/orgs/$orgName/repos -o working/repoList.json)

    if [ "$listresponse" -eq 200 ]; then
      echo "Fetched list of repos successfully!"
    else
      echo "********* Something went wrong while fetching repo details for organization"
      echo "HTTP response code received:$listresponse"
      exit 1
    fi;

  #fetch project urls
  repoFullNames=`jq -r '.[].full_name' working/repoList.json`

  # initialize status file
  header="%40s\t|\t%5s\n"
  sep="=========================================="
  format="%40s\t|\t%5d\n"
  width=65
  printf "$header" "REPO-NAME(Full)" "STATUS" > working/status.file
  printf "%$width.${width}s\n" "$sep$sep" >> working/status.file

  # loop through project list to set the protection rules
  for repoFullName in ${repoFullNames[@]}; do
    response=$(curl -sw '%{http_code}' \
                -X PUT \
                -H "Accept: application/vnd.github.v3+json" \
                -H "Authorization:token $TOKEN" \
                -o /dev/null \
                $githubApiUrl/repos/$repoFullName/branches/$branchName/protection \
                -d '@rules/branch-protection-rule.json')

    # update status file
    printf "$format" \
    "$repoFullName" "$response" >> working/status.file
  done

  # print statuses
  echo "Status Report:"
  cat working/status.file