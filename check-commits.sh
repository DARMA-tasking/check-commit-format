#!/usr/bin/env bash

set -e
set -u

base="HEAD^"
if test $# -gt 0
then
  base="$1"
fi

bad_commits=""

repository=$(mktemp)
if git rev-parse --git-dir 2> "$repository"; then
  #set -x
  shalist=$(git rev-list $base..HEAD)
  for sha in $shalist
  do
      commit=$(git cat-file commit $sha | sed '1,/^$/d' | head -1)
      #echo "SHA: $sha $commit"

      ## Allow commit messages that start with "Merge..."
      if echo "$commit" | grep -q '^Merge'
      then
          test 1;#echo "Found merge $commit"
      elif echo "$commit" | grep -q '^#[0-9]\+[: ]'
      then
          test 1;#echo "Found issue $commit"
      else
          bad_commits+=$([[ -z "$bad_commits" ]] && echo "$sha $commit" || echo $'\n'"$sha $commit")
      fi
  done
else
  cat "$repository" >> /dev/stderr
fi

code=0

if test ! -z "$bad_commits"
then
    echo -e "Every commit must match these patterns: 'Merge*' OR '^#[0-9]+[: ]'\n"
    echo -e "\n***** Failing Commits that don't match the style  *****\n"
    echo -e "${bad_commits[@]}"
    echo -e "\nFailed.\n"
     code=1
fi

exit $code
