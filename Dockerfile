FROM senggen/centos-elixir

# install dumb-init
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init

# Gitlab Runner
RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | bash && \
    yum -y install gitlab-runner rsync wget && \
    yum clean all

WORKDIR /home/gitlab-runner

ENTRYPOINT ["/usr/bin/dumb-init", "gitlab-runner"]
CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
