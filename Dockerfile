FROM openjdk:17-jdk-alpine

WORKDIR /app

COPY /target/chatroom-0.0.1-SNAPSHOT.jar app.jar

COPY . .

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
