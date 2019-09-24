FROM erlang:20    

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.9.1" \
  LANG=C.UTF-8

RUN set -xe \
  && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
  && ELIXIR_DOWNLOAD_SHA256="94daa716abbd4493405fb2032514195077ac7bc73dc2999922f13c7d8ea58777" \
  && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
  && echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
  && mkdir -p /usr/local/src/elixir \
  && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
  && rm elixir-src.tar.gz \
  && cd /usr/local/src/elixir \
  && make install clean

# install dumb-init
ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init

# install gitlab-runner
RUN curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | bash && \
    apt-get update -y && \
    apt-get install -y gitlab-ci-multi-runner && \
    apt-get clean && \
    apt-get autoremove -y 

VOLUME ["/etc/gitlab-runner", "/etc/gitlab-runner"]
ADD run.sh /home
RUN chmod +x /home/run.sh

WORKDIR /home/gitlab-runner
CMD /home/run.sh
