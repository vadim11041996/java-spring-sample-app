FROM maven:3.6.2-jdk-11-slim AS build  
WORKDIR /usr/src/app  

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src  

RUN mvn package spring-boot:repackage -DskipTests

FROM openjdk:11.0.4-jre-slim

WORKDIR /usr/src

COPY --from=build /usr/src/app/target/zoo-rest-service-0.0.1-SNAPSHOT.jar app.jar

RUN chmod +x app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]

EXPOSE 8081