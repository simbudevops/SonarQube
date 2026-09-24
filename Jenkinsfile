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
                    sh 'mvn sonar:sonar -Dsonar.projectKey=sonarqube-project-simbu -Dsonar.projectName=sonarqube-project-simbu'
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn
