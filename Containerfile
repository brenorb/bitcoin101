FROM docker.io/bretfisher/jekyll-serve:latest

RUN gem install bundler jekyll

ENTRYPOINT ["scripts/init.sh"]
