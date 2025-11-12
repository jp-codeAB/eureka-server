FROM gradle:8.10.2-jdk21 AS builder
WORKDIR /app

COPY build.gradle settings.gradle ./
COPY gradle gradle
COPY src src

RUN gradle clean build -x test --no-daemon

FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8761

HEALTHCHECK CMD curl -f http://localhost:8761/actuator/health || exit 1

ENV SPRING_PROFILES_ACTIVE=dev \
    EUREKA_SERVER_PORT=8761 \
    EUREKA_INSTANCE_HOSTNAME=eureka-server \
    TZ=America/Bogota

ENTRYPOINT ["java", "-jar", "app.jar"]
