#!/bin/bash


# Possible colors
red="\e[1;31m"
green="\e[1;32m"
blue="\e[1;34m"


git_bin=`whereis -b git | awk '{print $2}'`

if [ ! -x $git_bin ]; then 
    exit 1
fi


function gitBranchName {
    echo `git branch 2> /dev/null | grep '^\*' | sed 's/^\*\ //'`;
}


function gitPrompt {
    branch=`gitBranchName`
    if [ "$branch" != "" ]; then
        color=$blue
        wc_status=""
        
        gstatus=$(git status 2> /dev/null)
        
        dirty=$(echo $gstatus | sed 's/^#.*$//' | tail -2 | grep 'nothing to commit (working directory clean)';)

	# dirty ??
        if [ "$dirty" = "" ]; then
            color=$green
        fi

	#
        need_push=$(echo $gstatus | grep 'Your branch is ahead' 2> /dev/null)
        if [ "$need_push" != "" ]; then
            wc_status=" A"
        fi

	#
        need_pull=$(echo $gstatus | grep 'Your branch is behind' 2> /dev/null) 
        if [ "$need_pull" != "" ]; then
            wc_status=" B"
        fi

        diverged=$(echo $gstatus | grep 'have diverged,' 2> /dev/null) 
        if [ "$diverged" != "" ]; then
            wc_status=" D"
            color=$red
        fi

        echo -e "$color$branch$wc_status"
    fi
}

function git-scoreboard {
    git log | grep Author | sort | uniq -ci | sort -r
}

function git-track {
    branch=$(git-branch-name)
    git config branch.$branch.remote origin
    git config branch.$branch.merge refs/heads/$branch
    echo "tracking origin/$tracking"
}

function github-init {
    git config branch.$(git-branch-name).remote origin
    git config branch.$(git-branch-name).merge refs/heads/$(git-branch-name)
}


# Check: are we inside repository?
result=`git status 2> /dev/null`;


if [ "$?" = "0" ]; then
    echo -ne " `gitPrompt`";
    tput sgr0
else 
    echo ""
fi
