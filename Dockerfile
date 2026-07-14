FROM python:3.11-slim

WORKDIR /app

# 安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制 Bot 代码
COPY . .

# 启动你的机器人主程序（根据你实际的文件名修改，如 bot.py 或 main.py）
CMD ["python", "main.py"]
