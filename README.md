# gh-action-rebase

This GitHub action can be used to automatically rebase one branch onto another.

## Necessary environment variables
- **GITHUB_TOKEN** the name of the github secret token used for this action
- **REBASE_BRANCH** the name of the branch you wish to rebase
- **BASE_BRANCH** the name of the branch you wish to rebase onto

## Example Usage

This example uses the gh-action-rebase action for automatically rebasing
multiple branches onto the master branch on push events to master.

```
name: Rebase Release Branches

# Controls when the action will run.
on:
  push:
    branches: [ master ]

  # Allows running this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  rebase-release-branches:
    if: github.event.comment.author_association == 'MEMBER'
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0

      - name: rebase dunfell
        uses: iris-GmbH/gh-action-rebase@1.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          REBASE_BRANCH: dunfell
          BASE_BRANCH: master

      - name: rebase gatesgarth
        uses: iris-GmbH/gh-action-rebase@1.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          REBASE_BRANCH: gatesgarth
          BASE_BRANCH: master

      - name: rebase hardknott
        uses: iris-GmbH/gh-action-rebase@1.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          REBASE_BRANCH: hardknott
          BASE_BRANCH: master
```
