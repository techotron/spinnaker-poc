# spinnaker-poc
## Installation
Using the instructions found [here](https://spinnaker.io/setup/install/)

### Halyard
[Install Halyard](https://spinnaker.io/setup/install/halyard/) - a command line admin tool that manages the lifecycle of the Spinnaker deployment
```bash
make hal-install-ubuntu
```

Alternatively, run using docker:
```bash
make hal-docker
```

### Add Cloud Providers
[Add cloud provider](https://spinnaker.io/setup/install/providers/) - can add multiple providers. I'll be using the [AWS provider](https://spinnaker.io/setup/install/providers/aws/) for this:
* [ECS](https://spinnaker.io/setup/install/providers/aws/aws-ecs/)
* [Lambda](https://aws.amazon.com/blogs/opensource/how-to-integrate-aws-lambda-with-spinnaker/)
* [EKS](https://spinnaker.io/setup/install/providers/kubernetes-v2/aws-eks/)

#### ECS
1. Add ECS cluster
