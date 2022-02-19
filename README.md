# enable-repo-branch-protection

## Introduction
  This script can be used to enable branch protection rule for all the public repositories in your organization

### Pre-requisites
 - bash
 - curl
 - jq
 
### Input parameters
 - OrganizationName
 - API token having owner/admin permissions on the target repositories
 - branchName(optional). defaults to 'main'
 - githubApiUrl(optional). defaults to 'https://api.github.com'
 
### What does the script do?
 - Fetches the list of repositories for the organization
 - Sets the branch protection rules for the specified branch

### Benefits:
 - Ensures the changes being pushed to the repositories goes through a right review/approval process
 - Better control of changes being pushed
 - Improved code quality and reliability

### Steps to follow
#### Option A: Run locally(tested on Mac)
 1. Clone the repo in your local
 2. Open /rules/protection-rule.json and make required changes to the rules. More details can be found in Github documentation [here](https://docs.github.com/en/rest/reference/branches#update-branch-protection)
 3. Execute the shell script as below \
    `enable-repo-branch-protection.sh <OrganizationName> <Token>`

#### Option B: Run using Github Actions
 1. ***Work in progress
### Contact
 - Ritesh Keloth
