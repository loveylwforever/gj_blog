#!/bin/bash

# 检查GitHub Actions状态的脚本

echo "检查GitHub Actions工作流状态..."

# 检查最近的工作流运行
echo "最近的工作流运行状态："
curl -s https://api.github.com/repos/loveylwforever/gj_blog/actions/runs | grep -E '"status"|"conclusion"|"created_at"' | head -15

echo ""
echo "如果状态显示为failure，请查看GitHub仓库的Actions选项卡获取详细错误信息。"
echo "修复问题后，可以通过以下命令触发新的工作流运行："
echo "  git commit --allow-empty -m \"Trigger GitHub Actions\""
echo "  git push origin main"