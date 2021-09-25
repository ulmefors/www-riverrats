
all: build deploy

build:
	rm -rf public
	hugo

deploy:
	aws s3 sync public/ s3://${DOMAIN}
	aws cloudfront create-invalidation --distribution-id $(shell aws cloudfront list-distributions |jq -c '.DistributionList.Items[] | select(.Origins.Items[0].Id=="${DOMAIN}") | .Id') --paths "/*"

