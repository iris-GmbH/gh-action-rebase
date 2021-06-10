# SPDX-License-Identifier: MIT
# Copyright (c) 2021 iris-GmbH infrared & intelligent sensors

FROM alpine:latest

LABEL version="1.0.0"
LABEL repository="https://github.com/iris-GmbH/gh-action-rebase"
LABEL homepage="https://github.com/iris-GmbH/gh-action-rebase"
LABEL maintainer="Jasper Ben Orschulko <Jasper.Orschulko@iris-sensing.com"
LABEL "com.github.actions.name"="Branch Rebase"
LABEL "com.github.actions.description"="Tries to rebase a given branch on another branch"
LABEL "com.github.actions.icon"="git-pull-request"
LABEL "com.github.actions.color"="purple"

RUN set -ex \
    && apk add --no-cache \
        git \
        curl \
        jq
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
