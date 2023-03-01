#!/bin/bash

rm -rf haystack-tutorials
git clone --filter=tree:0 --branch implement-last-commit-new https://github.com/deepset-ai/haystack-tutorials.git 

python3 --version
echo "Install requirements for haystack-tutorials..."
cd haystack-tutorials
pip3 install -r requirements.txt
echo "Generating markdown files into ./content/tutorials..."
python3 scripts/generate_markdowns.py --index index.toml --notebooks all --output ../content/tutorials
echo "Copying markdown files into ./content/tutorials..."
cd ..
ls ./content/tutorials
mkdir ./static/downloads
echo "Copying notebook files into ./static/downloads..."
cp ./haystack-tutorials/tutorials/*.ipynb ./static/downloads
ls ./static/downloads

npm install

# Use "localhost" if VERCEL_URL is not set
PREVIEW_URL="${VERCEL_URL:-localhost}"
# Use PREVIEW_URL if SITE_URL is not set
DEPLOY_URL="${SITE_URL:-$PREVIEW_URL}"

echo "Deploy URL: ${DEPLOY_URL}"
hugo -b https://${DEPLOY_URL}
