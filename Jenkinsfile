pipeline {

````
agent any

tools {
    jdk 'Java21'
    maven 'Maven3'
}

environment {
    DOCKER_IMAGE = 'simbudevops7497/sonarqube-project-simbu'
    IMAGE_TAG = '1.0.0'
    DOCKER_CREDENTIALS = 'dockerhub'
}

stages {

    stage('Checkout') {
        steps {
            checkout scm
        }
    }

    stage('Verify POM') {
        steps {
            sh '''
                echo "===== Java ====="
                java -version

                echo "===== Maven ====="
                mvn -version

                echo "===== Git Branch ====="
                git branch --show-current

                echo "===== Checking pom.xml ====="
                if grep -n '```' pom.xml; then
                    echo "ERROR: Markdown backticks found in pom.xml"
                    exit 1
                fi

                echo "POM is valid."
            '''
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

    stage('Sonar Analysis') {
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

    stage('Build') {
        steps {
            sh 'mvn clean package -DskipTests'
        }
    }

    stage('Check Docker') {
        steps {
            sh '''
                echo "===== Docker Version ====="
                docker version

                echo "===== Docker Access ====="
                docker ps
            '''
        }
    }

    stage('Docker Build') {
        steps {
            sh '''
                docker build \
                -t ${DOCKER_IMAGE}:${IMAGE_TAG} \
                .
            '''
        }
    }

    stage('Docker Push to DockerHub') {
        steps {
            withCredentials([
                usernamePassword(
                    credentialsId: "${DOCKER_CREDENTIALS}",
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )
            ]) {
                sh '''
                    echo "$DOCKER_PASSWORD" | docker login \
                    -u "$DOCKER_USERNAME" \
                    --password-stdin

                    docker push ${DOCKER_IMAGE}:${IMAGE_TAG}

                    docker logout
                '''
            }
        }
    }

    stage('Run Docker Container') {
        steps {
            sh '''
                docker rm -f sonarqube-project-simbu 2>/dev/null || true

                docker run -d \
                --name sonarqube-project-simbu \
                -p 8080:8080 \
                ${DOCKER_IMAGE}:${IMAGE_TAG}

                docker ps
            '''
        }
    }
}

post {
    success {
        echo 'Pipeline completed successfully.'
    }

    failure {
        echo 'Pipeline failed.'
    }

    always {
        echo 'Cleaning workspace...'
        cleanWs()
    }
}
````

}
