## Overview
The CI/CD pipeline automates the build, test, and deployment process of a Dockerized application. It utilizes Jenkins for CI/CD, Maven for building and testing, SonarQube for code analysis, and Docker for containerization. Helm manages deployment to the Kubernetes cluster, enabling easy versioning and rollback.


## Prerequisites:

- Jenkins CI/CD tool installed
- Maven installed
- Docker installed
- Kubernetes cluster set up
- Helm installed


## Setup Instructions:

1. Clone this repository to your local machine.
2. Set up your Jenkins pipeline and configure the necessary credentials for Docker registry and  Kubernetes cluster access.
4. Update the Jenkinsfile with your Docker registry and Kubernetes cluster details.
5. Ensure that your Jenkins master-slave configuration is properly set up to run Helm commands on the designated slave.
6. Run the Jenkins pipeline to build, test, and deploy your application.


## Usage:

1. Commit your changes to the repository.
2. Jenkins will automatically trigger the pipeline.
3. Monitor the pipeline progress in Jenkins console.
4. Once the pipeline is successful, access your application deployed on the Kubernetes cluster.

## Important Notes:

- Ensure that your Kubernetes cluster is properly configured and accessible from Jenkins.
- Make sure to update the Docker registry and Kubernetes cluster details in the Jenkinsfile according to your environment.
- Test the pipeline in a non-production environment before deploying to production.
