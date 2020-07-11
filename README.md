# chisel3-docker
![Docker](https://github.com/rizaudo/chisel3-docker/workflows/Docker/badge.svg?branch=v1.0.0)


This project enables CI/CD of Chisel3(even if needed verilator) project using Docker.

## How to use interactively
`docker run -it -v $(pwd):/chisel rizaudo/chisel3-docker /bin/bash`
and then `sbt test` or something you wants.
