#!/bin/bash

rm -rf haystack-integrations
git clone --filter=tree:0 https://github.com/deepset-ai/haystack-integrations.git
cp ./haystack-integrations/integrations/*.md ./content/integrations

rm -rf haystack-advent
git clone --filter=tree:0 https://$GITHUB_USER_NAME:$GH_HAYSTACK_HOME_PAT@github.com/deepset-ai/advent-of-haystack.git haystack-advent
cp -R ./haystack-advent/challenges/* ./content/advent-of-haystack

npm install

# Use "localhost" if VERCEL_URL is not set
PREVIEW_URL="${VERCEL_URL:-localhost}"
# Use PREVIEW_URL if SITE_URL is not set
DEPLOY_URL="${SITE_URL:-$PREVIEW_URL}"

# Adds the directory to relative image paths in blog posts
if [[ "$DEPLOY_URL" != "localhost" ]]; then
    find ./content/blog -name "index.md" -type f -exec bash -c '
    dir=$(dirname "{}" | sed -e "s,^.*content/blog/,," -e "s,/.*,,");
    sed -i "/\(http\|\/images\)/! s~!\[\([^]]*\)\]([./]*\([^)]*\))~![\1]($dir/\2)~g" "{}"
    ' \;

    find ./content/advent-of-haystack -name "index.md" -type f -exec bash -c '
    dir=$(dirname "{}" | sed -e "s,^.*content/advent-of-haystack/,," -e "s,/.*,,");
    sed -i "/\(http\|\/images\)/! s~!\[\([^]]*\)\]([./]*\([^)]*\))~![\1]($dir/\2)~g" "{}"
    ' \;
fi

echo "Deploy URL: ${DEPLOY_URL}"
hugo -b https://${DEPLOY_URL}
