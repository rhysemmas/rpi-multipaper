FROM rhysemmas/multipaper-builder:arm64-1.20.1 as builder

FROM eclipse-temurin:17-jre

RUN apt-get update && apt-get install -y curl

WORKDIR /app/cache

RUN curl 'https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar' --output 'mojang_1.20.1.jar'

WORKDIR /app

COPY --from=builder /app/MultiPaper/build/libs/* .

COPY ./config/* .

RUN useradd -ms /bin/bash multipaper && \
    chown -R multipaper:multipaper /app

USER multipaper

CMD java \
        -Xms2G -Xmx2G \
        -DbungeecordName=${HOSTNAME} \
        -DmultipaperMasterAddress=multipaper-leader.minecraft.svc.cluster.local:35353 \
        -Dproperties.view-distance=16 \
        -Dpaper.settings.proxy-protocol=true \
        -Dspigot.world-settings.default.entity-tracking-range.players=128 \
        -XX:+UseG1GC \
        -XX:+ParallelRefProcEnabled \
        -XX:MaxGCPauseMillis=200 \
        -XX:+UnlockExperimentalVMOptions \
        -XX:+DisableExplicitGC \
        -XX:+AlwaysPreTouch \
        -XX:G1NewSizePercent=30 \
        -XX:G1MaxNewSizePercent=40 \
        -XX:G1HeapRegionSize=8M \
        -XX:G1ReservePercent=20 \
        -XX:G1HeapWastePercent=5 \
        -XX:G1MixedGCCountTarget=4 \
        -XX:InitiatingHeapOccupancyPercent=15 \
        -XX:G1MixedGCLiveThresholdPercent=90 \
        -XX:G1RSetUpdatingPauseTimePercent=5 \
        -XX:SurvivorRatio=32 \
        -XX:+PerfDisableSharedMem \
        -XX:MaxTenuringThreshold=1 \
        -Dusing.aikars.flags=https://mcflags.emc.gs \
        -Daikars.new.flags=true \
        -jar multipaper-paperclip-1.20.1-R0.1-SNAPSHOT-reobf.jar

EXPOSE 25565
