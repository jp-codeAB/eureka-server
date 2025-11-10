FROM gradle:8.10.2-jdk21 AS builder
WORKDIR /app

COPY build.gradle settings.gradle ./
COPY gradle gradle
COPY src src

RUN gradle clean build -x test --no-daemon

FROM eclipse-temurin:21-jdk
WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8761

ENV SPRING_PROFILES_ACTIVE=dev
ENV EUREKA_SERVER_PORT=8761

ENTRYPOINT ["java", "-jar", "app.jar"]
