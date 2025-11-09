# Stage 1: Build the application JAR
FROM openjdk:21-jdk-slim-bullseye  # CAMBIAR ESTA LÍNEA
WORKDIR /app
COPY build.gradle settings.gradle ./
# Copia solo los archivos que son estrictamente necesarios para la imagen final
COPY src src

# Asume que el JAR se genera en build/libs
RUN gradle clean build -x test

# Stage 2: Create the final image
FROM openjdk:21-jdk-slim
WORKDIR /app

# Nombre del archivo JAR generado por Gradle (ajusta si es diferente)
ARG JAR_FILE=/app/build/libs/eureka-server-0.0.1-SNAPSHOT.jar

# Copia el JAR del stage de construcción
COPY --from=builder ${JAR_FILE} app.jar

# Puerto por defecto de Eureka
EXPOSE 8761

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]