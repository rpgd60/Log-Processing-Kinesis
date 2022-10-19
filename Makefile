.DEFAULT_GOAL ?= help
.PHONY: help

help:
	@echo "${Project}"
	@echo "${Description}"
	@echo ""
	@echo "	deploy - deploy fake web for log analysis"
	@echo "	---"
	@echo "	tear-down - destroy CloudFormation stacks"
	@echo "	clean - clean temp folders"

###################### Parameters ######################
AlarmRecipient ?= "rpgd60@yahoo.com"
Project ?= log-proc
Description ?= Apache Log Processing with Kinesis and OpenSearch
LocalAWSRegion ?= eu-west-1
AwsCliProfile ?= course
#######################################################

deploy:
	aws cloudformation deploy \
		--template-file ./fake-web-server.yml \
		--region ${LocalAWSRegion} \
		--stack-name "${Project}-fake-web" \
		--parameter-overrides \
			Project=${Project} \
		--no-fail-on-empty-changeset \
		--capabilities CAPABILITY_NAMED_IAM \
		--profile "${AwsCliProfile}" 

tear-down:
	@read -p "Are you sure that you want to destroy stack '${Project}-fake-web'? [y/N]: " sure && [ $${sure:-N} = 'y' ]
	aws cloudformation delete-stack --region ${LocalAWSRegion} --stack-name "${Project}-fake-web" --profile "${AwsCliProfile}"
