pipeline {
    agent any

    tools {
        jdk 'java21'
        maven 'maven3'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        DOCKERHUB_USERNAME = 'simbudevops7497'
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/sonarqube-project-simbu:1.0.0"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/simbudevops/SonarQube.git'
            }
        }

        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Sonar Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner                           -Dsonar.projectName=SonarQube-Project-Simbu                           -Dsonar.projectKey=SonarQube-Project-Simbu                           -Dsonar.projectVersion=1.0.0                           -Dsonar.java.binaries=target
                    '''
                }
            }
        }

        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Docker Push to DockerHub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKERHUB_PASSWORD" | docker login                           -u "$DOCKERHUB_USERNAME"                           --password-stdin

                        docker push "$DOCKER_IMAGE"
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                    docker stop sonarqube-project-simbu || true
                    docker rm sonarqube-project-simbu || true

                    docker run -d                       --name sonarqube-project-simbu                       -p 5555:5555                       "$DOCKER_IMAGE"
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}
