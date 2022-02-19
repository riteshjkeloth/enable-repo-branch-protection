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
 - Open /rules/protection-rule.json

### Contact
 - Ritesh Keloth
