FROM rhysemmas/multipaper-builder:arm64-1.20.1 as builder

FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=builder /app/MultiPaper/MultiPaper-Master/build/libs/multipaper-master-2.11.0-all.jar multipaper.jar

COPY ./config/* .

RUN useradd -ms /bin/bash multipaper && \
    chown -R multipaper:multipaper /app

USER multipaper

CMD java \
        -Xms2G -Xmx2G \
        -jar multipaper.jar 35353 25565

EXPOSE 35353 25569
