#!/bin/bash

# 指定PID文件所在的文件夹
pid_folder="/home/qianlong/workspace/sample-efficient-mbrl/modem/logs/nohup_out/20241209_143357"

# 遍历文件夹中的PID文件
for pid_file in "$pid_folder"/*.pid; do
  if [ -f "$pid_file" ]; then
    # 从PID文件中读取PID值
    content=$(cat "$pid_file")

    # 使用":"分割内容并获取PID
    IFS=':' read -ra parts <<< "$content"
    pid="${parts[1]}"

    # 杀死对应的进程
    echo "Killing process with PID: $pid"
    kill -9 "$pid"

    # 删除PID文件
#    rm "$pid_file"
  fi
done
echo "Removing PID folder: $pid_folder"
rm -r "$pid_folder"
