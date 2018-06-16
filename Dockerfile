FROM ubuntu:14.04
MAINTAINER jaikumarg91@gmail.com
RUN apt-get -y update; apt-get -y install curl git
COPY ./github_stats.sh /github_stats.sh
CMD ["/bin/bash", "github_stats.sh"]
