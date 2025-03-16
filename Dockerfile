# Use an official Maven image as a build environment
FROM maven:3.8.5-openjdk-11 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file
COPY pom.xml .

# Resolve all dependencies (this will cache them in the Docker layer)
RUN mvn dependency:go-offline -B

# Copy the rest of the application source code
COPY src /app/src

# Build the application
RUN mvn package -DskipTests

# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 9000

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]