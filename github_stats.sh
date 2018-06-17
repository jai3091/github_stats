#!/bin/bash
#/************************************************************************************************************
#*       Author       : G JAIKUMAR, jaikumarg91@gmail.com
#*       Purpose      : Take  $orgname/$repo, as input and print name, clone URL, date of latest commit and name of latest author for each one of all repositories
#*       Version      : V-1.0
#*************************************************************************************************************
##Setting Environment Variables required for the script
set_env(){
  . ~/.profile
  #set -x
  get_repo_name
}

#Gets repository details as an input and check if it is in the right format
get_repo_name (){
  echo -e "\e[34mINFO :$LINENO: Please enter the git repo name in this format kubernetes/charts \e[0m";
  read git_repo_name;
  if [[ $git_repo_name =~ ([A-Za-z0-9]+)(/)([A-Za-z0-9]) ]]; then
    find_repo_details
  else
    echo -e "\e[31mERROR :$LINENO: Please enter the git repo name in this format kubernetes/charts \e[0m";
    exit 1;
  fi
}

##Finds Repository and fetches the required details
find_repo_details(){
  if [[ "$(curl -I -s https://github.com/${git_repo_name} | awk NR==1 | awk '{print $2}')" == "200" ]]; then
    echo -e "\e[34mINFO :$LINENO: Valid Git Repository \e[0m";
    #echo -e "\e[34mINFO :$LINENO: Finding repository name \e[0m";
    repo_name="$(echo $git_repo_name | awk -F'/' '{print $2}')"
    git clone --depth=1 -n https://github.com/${git_repo_name}.git
    cd ${repo_name}
    repo_commit_date="$(git log -1 --format=%cd)"
    repo_commit_name="$(git log -1 | grep "Author" | awk -F ':' '{print $2}')"
    repo_clone_url=https://github.com/${git_repo_name}.git
    echo -e "\e[34mINFO :$LINENO: Name of Repository,Clone URL,Last Commit Date,Latest Author \e[0m";
    echo -e "\e[32mINFO :$LINENO: ${repo_name},${repo_clone_url},${repo_commit_date},${repo_commit_name}
    rm -rf ../${repo_name}
  else
    echo -e "\e[31mERROR :$LINENO:  https://github.com/${repo_name} repository is not available. Please enter a valid repository!! \e[0m \n";
  fi
}
set_env
