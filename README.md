# SonarQube Project - SimbuDevOps

A Maven Spring Boot application integrated with Jenkins, SonarQube and Docker.

## GitHub Repository

https://github.com/simbudevops/SonarQube-Project-Simbu.git

## Jenkins Tools

Configure these exact names in Jenkins:

- JDK: `java21`
- Maven: `maven3`
- SonarQube Scanner: `sonar-scanner`

## SonarQube Configuration

Jenkins → Manage Jenkins → System → SonarQube servers

Configure:

- Name: `sonar-server`
- Server URL: `http://<SONARQUBE-SERVER>:9000`
- Authentication token: your SonarQube token

Do not commit SonarQube tokens to GitHub.

## Jenkins Credentials

Create Docker Hub credentials:

- ID: `dockerhub-credentials`
- Type: Username with password

## Pipeline

1. Git checkout
2. Maven compile
3. Maven test
4. SonarQube analysis
5. Maven package
6. Docker build
7. Docker Hub push
8. Docker container run

## Application

The application listens on port `5555`.
