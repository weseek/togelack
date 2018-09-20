FROM ruby:2.4.1

ENV APP_ROOT /usr/src/togelack

WORKDIR $APP_ROOT

RUN apt-get update && \
    apt-get install -y git nodejs \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY . $APP_ROOT

RUN \
    echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod uog+r /etc/gemrc && \
    bundle config --global jobs 4 && \
    bundle install && \
    rm -rf ~/.gem

RUN rake assets:precompile

EXPOSE  3000
ENTRYPOINT ["rails", "server"]
CMD ["-b", "0.0.0.0"]
