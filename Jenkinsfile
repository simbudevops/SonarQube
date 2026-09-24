pipeline {
agent any

```
tools {
    jdk 'Java21'
    maven 'Maven3'
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
            sh 'mvn clean package -DskipTests'
        }
    }

    stage('Docker Build') {
        steps {
            sh 'docker build -t simbudevops7497/sonarqube-project-simbu:1.0.0 .'
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
                    docker push simbudevops7497/sonarqube-project-simbu:1.0.0
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
                    -p 8080:8080 \
                    simbudevops7497/sonarqube-project-simbu:1.0.0
            '''
        }
    }
}

post {
    always {
        cleanWs()
    }
}
```

}
