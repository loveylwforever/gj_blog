# gj_blog

这是一个基于Hexo框架搭建的静态博客网站，使用Butterfly主题。

## 项目结构

```
.
├── scaffolds           # 文章模板
├── source              # 博客源文件
│   └── _posts          # 文章内容
├── themes              # 主题文件
│   └── butterfly       # Butterfly主题
├── _config.yml         # 站点配置
└── package.json        # 项目依赖和脚本
```

## 开发环境搭建

```bash
# 安装依赖
pnpm install

# 启动本地服务器
pnpm run server
```

## 部署

### 自动部署（推荐）

使用GitHub Actions自动部署到GitHub Pages：

1. 每次推送到main分支时会自动触发部署
2. 查看GitHub仓库的Actions选项卡监控部署状态

### 手动部署

```bash
# 清理、生成并部署
pnpm run deploy
```

## 实用脚本

### 检查GitHub Actions状态

```bash
./scripts/check-github-actions.sh
```

## 相关文档

- [GitHub Actions部署指南](GITHUB_ACTIONS_DEPLOYMENT_GUIDE.md)
- [GitHub Pages部署指南](GITHUB_PAGES_DEPLOYMENT_GUIDE.md)
- [部署检查清单](DEPLOYMENT_CHECKLIST.md)
- [Hexo主题修复记录](HEXO_BUTTERFLY_THEME_FIX.md)
- [pnpm workspace修复记录](PNPM_WORKSPACE_FIX.md)