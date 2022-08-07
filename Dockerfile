FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev 
RUN git clone https://github.com/json-parser/json-parser.git
WORKDIR /json-parser
RUN CC=afl-clang CXX=afl-clang++ ./configure
RUN make 
RUN cp ./examples/test_json.c .
RUN afl-clang test_json.c -o /fuzzer libjsonparser.a -lm
RUN mkdir /jsonCorpus
RUN cp ./tests/*.json /jsonCorpus/

ENTRYPOINT ["afl-fuzz", "-i", "/jsonCorpus", "-o", "/jsonparserOut"]
CMD ["/fuzzer", "@@"]
