# #!/bin/bash

# # Check if an argument (application name) is provided
# if [ -z "$1" ]; then
#   echo "Usage: create-spring-boot-app <name-of-the-app>"
#   exit 1
# fi

# # Assign the first argument as the app name
# APP_NAME=$1

# # Create a new directory for the application
# mkdir $APP_NAME
# cd $APP_NAME

# # Use Maven to generate a Spring Boot project structure
# mvn archetype:generate -DgroupId=com.example -DartifactId=$APP_NAME -Dversion=1.0.0 -Dpackage=com.example -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

# # Change directory to the generated project
# cd $APP_NAME

# # Replace the content of pom.xml to include Spring Boot dependencies
# cat > pom.xml <<EOL
# <project xmlns="http://maven.apache.org/POM/4.0.0" 
#          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
#          xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
#     <modelVersion>4.0.0</modelVersion>
#     <groupId>com.example</groupId>
#     <artifactId>$APP_NAME</artifactId>
#     <version>1.0.0</version>
#     <parent>
#         <groupId>org.springframework.boot</groupId>
#         <artifactId>spring-boot-starter-parent</artifactId>
#         <version>2.6.2</version>
#         <relativePath/> <!-- lookup parent from repository -->
#     </parent>

#     <dependencies>
#         <dependency>
#             <groupId>org.springframework.boot</groupId>
#             <artifactId>spring-boot-starter</artifactId>
#         </dependency>
#         <dependency>
#             <groupId>org.springframework.boot</groupId>
#             <artifactId>spring-boot-starter-test</artifactId>
#             <scope>test</scope>
#         </dependency>
#     </dependencies>

#     <build>
#         <plugins>
#             <plugin>
#                 <groupId>org.springframework.boot</groupId>
#                 <artifactId>spring-boot-maven-plugin</artifactId>
#             </plugin>
#         </plugins>
#     </build>
# </project>
# EOL

# # Create a basic Spring Boot application file
# mkdir -p src/main/java/com/example/$APP_NAME
# cat > src/main/java/com/example/$APP_NAME/Application.java <<EOL
# package com.example.$APP_NAME;

# import org.springframework.boot.SpringApplication;
# import org.springframework.boot.autoconfigure.SpringBootApplication;

# @SpringBootApplication
# public class Application {

#     public static void main(String[] args) {
#         SpringApplication.run(Application.class, args);
#     }

# }
# EOL

# # Create a basic application.properties file
# mkdir -p src/main/resources
# touch src/main/resources/application.properties

# # Create a Dockerfile
# cat > Dockerfile <<EOL
# # Use the official Spring Boot base image
# FROM openjdk:17-jdk-slim

# # Set the working directory
# WORKDIR /app

# # Copy the project files
# COPY . .

# # Package the application
# RUN ./mvnw package

# # Expose the application port
# EXPOSE 8080

# # Run the Spring Boot application
# CMD ["java", "-jar", "target/$APP_NAME-1.0.0.jar"]
# EOL

# # Create a docker-compose.yml file
# cat > docker-compose.yml <<EOL
# version: '3.8'

# services:
#   app:
#     build: .
#     ports:
#       - "8080:8080"
#     environment:
#       - SPRING_PROFILES_ACTIVE=dev
# EOL

# echo "Spring Boot application '$APP_NAME' with Docker support has been created successfully."



#!/bin/bash

# Check if an argument (application name) is provided
if [ -z "$1" ]; then
  echo "Usage: create-spring-boot-app <name-of-the-app>"
  exit 1
fi

# Assign the first argument as the app name
APP_NAME=$1

# Create a new directory for the application
mkdir $APP_NAME
cd $APP_NAME

# Use Maven to generate a Spring Boot project structure
mvn archetype:generate -DgroupId=com.example -DartifactId=$APP_NAME -Dversion=1.0.0 -Dpackage=com.example -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

# Change directory to the generated project
cd $APP_NAME

# Replace the content of pom.xml to include Spring Boot dependencies
cat > pom.xml <<EOL
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>$APP_NAME</artifactId>
    <version>1.0.0</version>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.6.2</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <version>42.3.1</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
EOL

# Create a basic Spring Boot application file
mkdir -p src/main/java/com/example/$APP_NAME
cat > src/main/java/com/example/$APP_NAME/Application.java <<EOL
package com.example.$APP_NAME;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

}
EOL

# Create a basic application.properties file
mkdir -p src/main/resources
cat > src/main/resources/application.properties <<EOL
spring.datasource.url=jdbc:postgresql://db:5432/$APP_NAME
spring.datasource.username=postgres
spring.datasource.password=password
spring.jpa.hibernate.ddl-auto=update
EOL

# Create a Dockerfile
cat > Dockerfile <<EOL
# Use the official Spring Boot base image
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Package the application
RUN ./mvnw package

# Expose the application port
EXPOSE 8080

# Run the Spring Boot application
CMD ["java", "-jar", "target/$APP_NAME-1.0.0.jar"]
EOL

# Create a docker-compose.yml file
cat > docker-compose.yml <<EOL
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=dev
    depends_on:
      - db
      - keycloak

  db:
    image: postgres:13
    environment:
      POSTGRES_DB: $APP_NAME
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"

  keycloak:
    image: quay.io/keycloak/keycloak:latest
    environment:
      KEYCLOAK_USER: admin
      KEYCLOAK_PASSWORD: admin
      DB_VENDOR: POSTGRES
      DB_ADDR: db
      DB_DATABASE: $APP_NAME
      DB_USER: postgres
      DB_PASSWORD: password
    ports:
      - "8081:8080"
EOL

# Initialize a new Git repository
git init
git add .
git commit -m "Initial commit with Spring Boot application setup"

# Add GitHub remote and push (assuming user has setup GitHub CLI and authenticated)
gh repo create $APP_NAME --public --source=. --remote=origin
git push -u origin master

echo "Spring Boot application '$APP_NAME' with PostgreSQL and Keycloak support has been created successfully."

