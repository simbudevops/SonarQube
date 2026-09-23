FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

COPY target/sonarqube-project-simbu-1.0.0.jar /app/sonarqube-project-simbu.jar

EXPOSE 5555

ENTRYPOINT ["java", "-jar", "sonarqube-project-simbu.jar"]
