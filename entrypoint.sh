#!/bin/sh

# SPDX-License-Identifier: MIT
# Copyright (c) 2021 iris-GmbH infrared & intelligent sensors

set -e

[ -z "$GITHUB_TOKEN" ] && { echo "Error: No GitHub Token provided. Please set the GITHUB_TOKEN environment variable." >&2; exit 1; }
[ -z "$REBASE_BRANCH" ] && { echo "Error: No rebase branch provided. Please set the REBASE_BRANCH environment variable." >&2; exit 1; }
[ -z "$BASE_BRANCH" ] && { echo "Error: No target branch provided. Please set the BASE_BRANCH environment variable." >&2; exit 1; }

URI=https://api.github.com
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

rebase_branch_resp="$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}/branches/${REBASE_BRANCH}")"
target_branch_resp="$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}/branches/${BASE_BRANCH}")"

PROTECTED=$(echo "$rebase_branch_resp" | jq .protected)
[ -z "$PROTECTED" ] && { echo "Error: Branch $REBASE_BRANCH does not exist." >&2; exit 1; }
[ "$PROTECTED" != "false" ] && { echo "Error: Branch $REBASE_BRANCH  is protected and cannot be rebased." >&2; exit 1; }

[ "$(echo "$target_branch_resp" | jq .message)" = "Branch not found" ] && { echo "Error: Branch $BASE_BRANCH does not exist." >&2; exit 1; }

git remote set-url origin "https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"

git config --global user.email "gh-action-rebase"
git config --global user.name "gh-action-rebase"

git fetch origin "$REBASE_BRANCH"
git fetch origin "$BASE_BRANCH"

git checkout "$REBASE_BRANCH"

git rebase origin/"$BASE_BRANCH"
ret=$?
[ $ret -ne 0 ] && { echo "Error: Could not rebase $REBASE_BRANCH on $BASE_BRANCH"; exit $ret; }

git push origin --force

exit 0
