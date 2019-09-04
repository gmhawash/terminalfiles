#!/usr/bin/env bash
#
echo Executing $BASH_ARGV

source ~/.bash_tff

#######################################################################################
# Description: Notes commands
#
n() { $EDITOR ~/GoogleDrive/notes/"$*".txt ;}
nls() { tree ~/GoogleDrive/notes/"$*" ;}
nmkdir() { mkdir -p ~/GoogleDrive/notes/"$*" ;}
nrm() { rm  ~/GoogleDrive/notes/"$*".txt ;}
nopen() { open  ~/GoogleDrive/notes;}
ncat() { cat ~/GoogleDrive/notes/"$*".txt ;}

run() {
 echo "EXEC: $1"
 eval $1
}

debug() {
  echo "Executing: $@"
  $@
}

copy() {
  echo -ne "$@" | pbcopy -Prefer txt
}

PROJECTS=( core beehive reports services cockpit vortex meedan.admin meedan.client meedan.api patron.admin patron.client )
BRANCHES=( master production preview staging )

#######################################################################################
# Description: Rebases branches on top of branch
#
rebase_branches() {
  echo "Usage: OPT=-f rebase_branches master beta production"
  echo $OPT

  for branch in $@
  do
    if [ "$1" != "$branch" ]
    then
      git rebase $1 $branch
      git push $OPT
      git checkout $1
    fi
  done
}

repoint_branches() {
  echo "Usage: OPT=-f rebase_branches master beta production"
  echo $OPT
  CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

 for branch in "${@:2}"
  do
    if [ "$1" != "$branch" ] && [ "$CURRENT_BRANCH" != "$branch" ]
    then
      git branch -f $branch $1
      git push -f origin $branch:$branch
    else
      echo "Branch: ‘$branch’: WILL NOT DO IT, either CURRENT_BRANCH is same as target, or target and source are the same"
    fi
  done
}

repoint_here() {
  if [ "$1" == "" ]
  then
    echo "You must specify a stage prod|beta|perview|staging"
  else
    repoint_branches HEAD $1
  fi
}

repoint_staging_here() {
  repoint_here staging
}

list_branch_info() {
  pushd `pwd`
  for project in "${PROJECTS[@]}"
  do
    printf "\n\e[33;31m Processing $project \e[0m"
    cd ~/src/dlm/$project
    git fetch
    master_sha=`git rev-parse origin/master`
    for branch in "${BRANCHES[@]}"
    do
      sha=`git rev-parse origin/${branch}`
      if [ "$sha" == "$master_sha" ]
      then
        printf "%-10s %s\n" $branch $sha
      else
        printf "\e[33;31m%-10s %s \e[0m\n" $branch $sha
      fi
    done
  done
  popd
}

repoint_to_master() {
  ARGS=$@
  pushd `pwd`
  for project in "${PROJECTS[@]}"
  do
    printf "\e[33;31m Processing $project \e[0m\n"
    cd ~/src/dlm/$project
    repoint_branches master ${ARGS:=production preview}
  done
  popd
}

terminate_db_conection() {
  if [ "$1" != "" ]
  then
    run "psql -c \"SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$1' AND pid <> pg_backend_pid();\" -d $1"
  else
    printf "Usage: terminate_db_conection {database_name}"
  fi
}

tag_release() {
  if [ "$1" != "" ]
  then
    RELEASE="release/$1"
    run "git tag $RELEASE"
    run "git push --tags"
  else
    echo "Usage: tag_release 201608011244"
  fi
}

# Delete tags that has the pattern specified in $1
tag_delete() {
  if [ "$1" != "" ]
  then
    # git list, keep last 10 tags in this list
    TAGS=`git tag --list $1* | sort -r | tail -n +10`
    for tag in ${TAGS[@]}
    do
      printf "Deleting tag: $tag\n"
      git push --delete origin $tag
      git tag --delete $tag
    done

    printf "Remaining Tags: \n"
    git tag --list $1*
  fi
}

maintenance_on() {
  printf "maintenance_on prod|preview|staging"
  if [ "$1" != "" ]
  then
    ssh aws.$1 -t "sudo touch /var/www/dlm-core/system/maintenance.lock"
  fi
}

maintenance_off() {
  printf "maintenance_off prod|preview|staging\n"
  if [ "$1" != "" ]
  then
    ssh aws.$1 -t "sudo rm /var/www/dlm-core/system/maintenance.lock"
  fi
}

shh() {
  run "ssh aws.deployer -t \"ssh aws.$1\""
}

start_beehives() {
  itermocil beehive-batches
  itermocil beehive-reports
  itermocil beehive-notifiers
  itermocil beehive-others
  itermocil beehive-admin
}

start_all_apps() {
  select mode in "Standalone" "External Monitor"; do
      case $mode in
          Standalone ) PROFILE=Standalone; break;;
          "External Monitor" ) PROFILE=default; exit;;
      esac
  done

  itermocil servers
  itermocil servers2
  #itermocil servers3
  itermocil patrons
  start_beehives
}

start_loan_manager() {
  itermocil servers4
}

kill_all_apps() {
  pkill -f puma
  pkill -f runner
}


function profile() {
  echo "Usage: profile x for external monitor"
  if [ "$1" = 'x' ]; then
    echo -e "\033]50;SetProfile=External Monitor\a"
  else
    echo -e "\033]50;SetProfile=Standalone\a"
  fi
}

pull_request() {
echo $@
  if [ -z "$1"  ]
  then
    echo "Provide a message please...."
  else
    hub pull-request -o -b master -m "$@"
  fi
}
