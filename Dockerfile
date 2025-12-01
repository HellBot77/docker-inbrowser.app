FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/inbrowser.app.git && \
    cd inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:lts-alpine AS build

WORKDIR /inbrowser.app
COPY --from=base /git/inbrowser.app .
RUN npm install --global pnpm && \
    pnpm install --frozen-lockfile && \
    pnpm build

FROM joseluisq/static-web-server

COPY --from=build /inbrowser.app/apps/web/dist ./public
