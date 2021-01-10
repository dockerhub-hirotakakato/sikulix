FROM debian:stable-slim

RUN apt-get -qy update && \
    mkdir /usr/share/man/man1 && \
    apt-get -qy --no-install-recommends install firefox-esr fluxbox libopencv3.2-java openjdk-11-jre wget wmctrl xdotool xvfb && \
    wget -qP /usr/local/bin \
      $(wget -qO- https://raiman.github.io/SikuliX1/downloads.html | \
        sed -n \
          -e 's/^.*"\([^"]*sikulixide-[0-9.]*\.jar\)".*$/\1/p' \
          -e 's/^.*"\([^"]*jython-standalone-[0-9.]*\.jar\)".*$/\1/p' \
      ) && \
    ( echo '#!/bin/sh' && \
      echo "exec java -jar /usr/local/bin/sikulixide-*.jar \"\$@\"" \
    ) | install /dev/stdin /usr/local/bin/sikulix && \
    rm -r /root/.wget-hsts /var/lib/apt/lists/* && \
    ln -s ../../share/OpenCV/java/opencv-320.jar /usr/lib/jni/opencv.jar && \
    ln -s libopencv_java320.so /usr/lib/jni/libopencv_java.so && \
    ( echo '#!/bin/sh' && \
      echo 'rm -rf /tmp/.??*' && \
      echo 'Xvfb :0 -screen 0 "${GEOMETRY:-640x480x24}" -nolisten tcp &' && \
      echo 'DISPLAY=:0 exec "$@"' \
    ) | install /dev/stdin /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bash"]
