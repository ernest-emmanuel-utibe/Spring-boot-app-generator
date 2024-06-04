@echo off

REM Check if an argument (application name) is provided
IF "%~1"=="" (
    echo Usage: create-spring-boot-app ^<name-of-the-app^>
    exit /B 1
)

REM Assign the first argument as the app name
SET APP_NAME=%~1

REM Create a new directory for the application
mkdir %APP_NAME%
cd %APP_NAME%

REM Use Maven to generate a Spring Boot project structure
mvn archetype:generate -DgroupId=com.example -DartifactId=%APP_NAME% -Dversion=1.0.0 -Dpackage=com.example -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

REM Change directory to the generated project
cd %APP_NAME%

REM Replace the content of pom.xml to include Spring Boot dependencies
echo ^<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"^> > pom.xml
echo     ^<modelVersion^>4.0.0^</modelVersion^> >> pom.xml
echo     ^<groupId^>com.example^</groupId^> >> pom.xml
echo     ^<artifactId^>%APP_NAME%^</artifactId^> >> pom.xml
echo     ^<version^>1.0.0^</version^> >> pom.xml
echo     ^<parent^> >> pom.xml
echo         ^<groupId^>org.springframework.boot^</groupId^> >> pom.xml
echo         ^<artifactId^>spring-boot-starter-parent^</artifactId^> >> pom.xml
echo         ^<version^>2.6.2^</version^> >> pom.xml
echo         ^<relativePath/^>^</relativePath^> >> pom.xml
echo     ^</parent^> >> pom.xml
echo     ^<dependencies^> >> pom.xml
echo         ^<dependency^> >> pom.xml
echo             ^<groupId^>org.springframework.boot^</groupId^> >> pom.xml
echo             ^<artifactId^>spring-boot-starter^</artifactId^> >> pom.xml
echo         ^</dependency^> >> pom.xml
echo         ^<dependency^> >> pom.xml
echo             ^<groupId^>org.springframework.boot^</groupId^> >> pom.xml
echo             ^<artifactId^>spring-boot-starter-data-jpa^</artifactId^> >> pom.xml
echo         ^</dependency^> >> pom.xml
echo         ^<dependency^> >> pom.xml
echo             ^<groupId^>org.springframework.boot^</groupId^> >> pom.xml
echo             ^<artifactId^>spring-boot-starter-test^</artifactId^> >> pom.xml
echo             ^<scope^>test^</scope^> >> pom.xml
echo         ^</dependency^> >> pom.xml
echo         ^<dependency^> >> pom.xml
echo             ^<groupId^>org.postgresql^</groupId^> >> pom.xml
echo             ^<artifactId^>postgresql^</artifactId^> >> pom.xml
echo             ^<version^>42.3.1^</version^> >> pom.xml
echo         ^</dependency^> >> pom.xml
echo     ^</dependencies^> >> pom.xml
echo     ^<build^> >> pom.xml
echo         ^<plugins^> >> pom.xml
echo             ^<plugin^> >> pom.xml
echo                 ^<groupId^>org.springframework.boot^</groupId^> >> pom.xml
echo                 ^<artifactId^>spring-boot-maven-plugin^</artifactId^> >> pom.xml
echo             ^</plugin^> >> pom.xml
echo         ^</plugins^> >> pom.xml
echo     ^</build^> >> pom.xml
echo ^</project^> >> pom.xml

REM Create a basic Spring Boot application file
mkdir src\main\java\com\example\%APP_NAME%
echo package com.example.%APP_NAME%; > src\main\java\com\example\%APP_NAME%\Application.java
echo. >> src\main\java\com\example\%APP_NAME%\Application.java
echo import org.springframework.boot.SpringApplication; >> src\main\java\com\example\%APP_NAME%\Application.java
echo import org.springframework.boot.autoconfigure.SpringBootApplication; >> src\main\java\com\example\%APP_NAME%\Application.java
echo. >> src\main\java\com\example\%APP_NAME%\Application.java
echo @SpringBootApplication >> src\main\java\com\example\%APP_NAME%\Application.java
echo public class Application { >> src\main\java\com\example\%APP_NAME%\Application.java
echo. >> src\main\java\com\example\%APP_NAME%\Application.java
echo     public static void main(String[] args) { >> src\main\java\com\example\%APP_NAME%\Application.java
echo         SpringApplication.run(Application.class, args); >> src\main\java\com\example\%APP_NAME%\Application.java
echo     } >> src\main\java\com\example\%APP_NAME%\Application.java
echo } >> src\main\java\com\example\%APP_NAME%\Application.java

REM Create a basic application.properties file
mkdir src\main\resources
echo spring.datasource.url=jdbc:postgresql://db:5432/%APP_NAME% > src\main\resources\application.properties
echo spring.datasource.username=postgres >> src\main\resources\application.properties
echo spring.datasource.password=password >> src\main\resources\application.properties
echo spring.jpa.hibernate.ddl-auto=update >> src\main\resources\application.properties

REM Create a Dockerfile
echo FROM openjdk:17-jdk-slim > Dockerfile
echo WORKDIR /app >> Dockerfile
echo COPY . . >> Dockerfile
echo RUN ./mvnw package >> Dockerfile
echo EXPOSE 8080 >> Dockerfile
echo CMD ["java", "-jar", "target/%APP_NAME%-1.0.0.jar"] >> Dockerfile

REM Create a docker-compose.yml file
echo version: '3.8' > docker-compose.yml
echo. >> docker-compose.yml
echo services: >> docker-compose.yml
echo   app: >> docker-compose.yml
echo     build: . >> docker-compose.yml
echo     ports: >> docker-compose.yml
echo       - "8080:8080" >> docker-compose.yml
echo     environment: >> docker-compose.yml
echo       - SPRING_PROFILES_ACTIVE=dev >> docker-compose.yml
echo     depends_on: >> docker-compose.yml
echo       - db >> docker-compose.yml
echo       - keycloak >> docker-compose.yml
echo. >> docker-compose.yml
echo   db: >> docker-compose.yml
echo     image: postgres:13 >> docker-compose.yml
echo     environment: >> docker-compose.yml
echo       POSTGRES_DB: %APP_NAME% >> docker-compose.yml
echo       POSTGRES_USER: postgres >> docker-compose.yml
echo       POSTGRES_PASSWORD: password >> docker-compose.yml
echo     ports: >> docker-compose.yml
echo       - "5432:5432" >> docker-compose.yml
echo. >> docker-compose.yml
echo   keycloak: >> docker-compose.yml
echo     image: quay.io/keycloak/keycloak:latest >> docker-compose.yml
echo     environment: >> docker-compose.yml
echo       KEYCLOAK_USER: admin >> docker-compose.yml
echo       KEYCLOAK_PASSWORD: admin >> docker-compose.yml
echo       DB_VENDOR: POSTGRES >> docker-compose.yml
echo       DB_ADDR: db >> docker-compose.yml
echo       DB_DATABASE: %APP_NAME% >> docker-compose.yml
echo       DB_USER: postgres >> docker-compose.yml
echo       DB_PASSWORD: password >> docker-compose.yml
echo     ports: >> docker-compose.yml
echo       - "8081:8080" >> docker-compose.yml

echo Spring Boot application '%APP_NAME%' with PostgreSQL and Keycloak support has been created successfully.
