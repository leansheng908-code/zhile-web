#!/bin/bash
# 知乐 Ubuntu 一键环境配置脚本 v1.0
# 自动配置: 系统更新 + Docker + AstrBot + NapCat + 仓库克隆

set -e

echo "=========================================="
echo "  知乐 Ubuntu 环境一键配置"
echo "=========================================="
echo ""

# 1. 更新系统
echo "[1/6] 更新系统..."
sudo apt update && sudo apt upgrade -y

# 2. 安装基础工具
echo "[2/6] 安装基础工具..."
sudo apt install -y git curl wget python3 python3-pip vim

# 3. 安装Docker
echo "[3/6] 安装Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sudo sh
    sudo usermod -aG docker $USER
    echo "Docker安装完成"
else
    echo "Docker已安装，跳过"
fi

# 4. 克隆公开仓库
echo "[4/6] 克隆GitHub仓库..."
mkdir -p ~/zhile
cd ~/zhile
[ ! -d "zhile-web" ] && git clone https://github.com/leansheng908-code/zhile-web.git
[ ! -d "zhile-data" ] && git clone https://github.com/leansheng908-code/zhile-data.git
echo "公开仓库克隆完成"

# 5. 部署AstrBot
echo "[5/6] 部署AstrBot..."
mkdir -p ~/astrbot/data ~/astrbot/config
if ! sudo docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q '^astrbot$'; then
    sudo docker run -d \
        --name astrbot \
        --restart always \
        -p 6185:6185 \
        -v ~/astrbot/data:/AstrBot/data \
        -v ~/astrbot/config:/AstrBot/config \
        songxingguo/astrbot:latest
    echo "AstrBot部署完成"
else
    echo "AstrBot已存在，跳过"
fi

# 6. 部署NapCat
echo "[6/6] 部署NapCat..."
if ! sudo docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q '^napcat$'; then
    sudo docker run -d \
        --name napcat \
        --restart always \
        -p 6099:6099 \
        -p 3000:3000 \
        -p 3001:3001 \
        mlikiowa/napcat-docker:latest
    echo "NapCat部署完成"
else
    echo "NapCat已存在，跳过"
fi

echo ""
echo "=========================================="
echo "  安装完成！"
echo "=========================================="
echo ""
echo "接下来手动完成："
echo ""
echo "1. 注销重新登录（让docker免sudo生效）"
echo "2. 浏览器打开 AstrBot: http://localhost:6185"
echo "   账号 astrbot / 密码 u27DetNhWFmkRaFMv1y0VRlh"
echo "3. 浏览器打开 NapCat: http://localhost:6099"
echo "   Token: 08ca8acd77eb"
echo ""
echo "=========================================="
