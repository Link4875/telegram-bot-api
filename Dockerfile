# 阶段 1: 编译环境
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# 安装编译 Telegram Bot API 所需的依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    gperf \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

# 编译代码
RUN mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build . --target telegram-bot-api -j$(nproc)

# 阶段 2: 运行环境
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    zlib1g \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /src/build/telegram-bot-api /usr/local/bin/telegram-bot-api

# 创建保存数据和日志的目录
RUN mkdir -p /var/lib/telegram-bot-api

EXPOSE 8081 8082

ENTRYPOINT ["telegram-bot-api"]
