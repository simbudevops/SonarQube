pipeline {
    agent any

    tools {
        jdk 'Java21'
        maven 'Maven3'
    }

    environment {
        IMAGE_NAME = 'simbudevops7497/sonarqube-project-simbu'
        IMAGE_TAG  = '1.0.0'
    }

    stages {

        stage('Check') {
            steps {
                sh 'java -version'
                sh 'mvn -version'
                sh 'docker --version'
            }
        }

        stage('Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn sonar:sonar \
                          -Dsonar.projectKey=sonarqube-project-simbu \
                          -Dsonar.projectName=sonarqube-project-simbu
                    '''
                }
            }
        }

        stage('Package') {
            steps {
                sh '''
                    mvn clean package -DskipTests
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t $IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push $IMAGE_NAME:$IMAGE_TAG
                        docker logout
                    '''
                }
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    docker rm -f sonarqube-project-simbu || true
                    docker run -d \
                        --name sonarqube-project-simbu \
                        -p 8081:8080 \
                        $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
        always {
            cleanWs()
        }
    }
}
