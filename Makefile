REGION=us-east-1
CLUSTER_NAME=sre-eddy-fargate
CLUSTER_CONFIG=${CLUSTER_NAME}-config
ECS_CLI_PROFILE_NAME=${CLUSTER_NAME}-profile
FARGATE_TASK_EXECUTION_ROLE_NAME=${CLUSTER_NAME}-ter

hal-docker:
	docker run -p 8084:8084 -p 9000:9000 \
		--name halyard --rm \
		-v ~/.hal:/home/spinnaker/.hal \
		-d \
			us-docker.pkg.dev/spinnaker-community/docker/halyard:stable
	
	docker exec -it halyard bash

hal-install-ubuntu:
	curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh
	sudo bash InstallHalyard.sh

hal-install-macos:
	curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/macos/InstallHalyard.sh
	sudo bash InstallHalyard.sh


fargate-cluster-create-ter:
	aws iam create-role \
		--region ${REGION} \
		--role-name ${FARGATE_TASK_EXECUTION_ROLE_NAME} \
		--assume-role-policy-document file://aws/ecs/fargate-cluster-ter.json

fargate-cluster-delete-ter:
	aws iam delete-role \
		--region ${REGION} \
		--role-name ${FARGATE_TASK_EXECUTION_ROLE_NAME}

fargate-cluster-attach-ter:
	aws iam attach-role-policy \
		--region ${REGION} \
		--role-name ${FARGATE_TASK_EXECUTION_ROLE_NAME} \
		--policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

fargate-cluster-detach-ter:
	aws iam detach-role-policy \
		--region ${REGION} \
		--role-name ${FARGATE_TASK_EXECUTION_ROLE_NAME} \
		--policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy		

fargate-cluster-create-ecscli-config:
	ecs-cli configure \
		--cluster ${CLUSTER_NAME} \
		--default-launch-type FARGATE \
		--config-name ${CLUSTER_CONFIG} \
		--region ${REGION}

# NEED TO USE IAM ROLES: https://github.com/aws/amazon-ecs-cli/issues/369
fargate-cluster-create-ecscli-profile:
	ecs-cli configure profile \
		--access-key ${AWS_ACCESS_KEY_ID} \
		--secret-key ${AWS_SECRET_ACCESS_KEY} \
		--session-token ${AWS_SESSION_TOKEN} \
		--profile-name ${ECS_CLI_PROFILE_NAME}


fargate-cluster-create:
	ecs-cli up --cluster-config ${CLUSTER_CONFIG} \
		--ecs-profile ${ECS_CLI_PROFILE_NAME}

fargate-cluster-up: fargate-cluster-create-ter fargate-cluster-attach-ter fargate-cluster-create-ecscli-config fargate-cluster-create-ecscli-profile

fargate-cluster-down: fargate-cluster-detach-ter fargate-cluster-delete-ter

dev: fargate-cluster-create-ter fargate-cluster-attach-ter fargate-cluster-create-ecscli-config fargate-cluster-create-ecscli-profile
