# Hexo博客部署到GitHub Pages完整指南

## 前期准备

### 1. 安装GitHub部署依赖

在部署之前，需要先安装Hexo的GitHub部署插件：

```bash
cd /Users/gaojian/01-P-Projects/hexo/gj_blog
pnpm add hexo-deployer-git
```

### 2. 创建GitHub仓库

你已经创建了源码仓库：`https://github.com/loveylwforever/gj_blog.git`

现在还需要创建一个用于GitHub Pages的公开仓库：
1. 访问 https://github.com/new
2. 创建一个名为 `loveylwforever.github.io` 的公开仓库
3. 不要初始化仓库（不要添加README、.gitignore或license）

### 3. 配置SSH密钥

确保你的SSH密钥已配置好：

```bash
# 检查是否存在SSH密钥
ls -la ~/.ssh

# 如果没有SSH密钥，生成一个新的
ssh-keygen -t ed25519 -C "your_email@example.com"

# 启动ssh-agent
eval "$(ssh-agent -s)"

# 添加SSH私钥
ssh-add ~/.ssh/id_ed25519
```

将SSH公钥添加到GitHub：
1. 复制公钥内容：`cat ~/.ssh/id_ed25519.pub`
2. 访问 https://github.com/settings/keys
3. 点击 "New SSH key"
4. 将公钥内容粘贴到 "Key" 字段中
5. 给密钥起一个名字（例如："My MacBook"）
6. 点击 "Add SSH key"

## 配置Hexo部署

### 1. 配置文件

确保你的 [_config.yml](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/_config.yml) 文件已经配置好部署设置：
```yaml
# Deployment
deploy:
  type: git
  repo: git@github.com:loveylwforever/loveylwforever.github.io.git
  branch: main
```

### 2. 初始化源码仓库

```bash
cd /Users/gaojian/01-P-Projects/hexo/gj_blog

# 初始化git仓库（如果尚未初始化）
git init

# 添加所有文件
git add .

# 提交更改
git commit -m "Initial commit"

# 添加远程仓库
git remote add origin git@github.com:loveylwforever/gj_blog.git

# 推送到远程仓库
git branch -M main
git push -u origin main
```

## 部署博客

### 部署到GitHub Pages

```bash
# 生成静态文件并部署
hexo clean && hexo generate && hexo deploy
```

或者使用简写命令：
```bash
# 一键部署（清理、生成、部署）
hexo d -g
```

### 手动部署方式

如果自动部署遇到问题，可以手动部署：

```bash
# 生成静态文件
hexo generate

# 进入生成目录
cd public

# 初始化git仓库
git init

# 添加所有文件
git add .

# 提交更改
git commit -m "Site updated: $(date)"

# 添加远程仓库
git remote add origin git@github.com:loveylwforever/loveylwforever.github.io.git

# 推送到远程仓库
git branch -M main
git push -u origin main --force

# 返回到项目根目录
cd ..
```

## 配置GitHub Pages

1. 访问你的GitHub Pages仓库（`loveylwforever.github.io`）
2. 点击 "Settings" 选项卡
3. 在左侧菜单中点击 "Pages"
4. 在 "Source" 部分选择：
   - Source: Deploy from a branch
   - Branch: main
5. 点击 "Save"

## 访问你的博客

配置完成后，你的博客将在以下地址可用：
```
https://loveylwforever.github.io
```

首次部署可能需要几分钟时间才能生效，请耐心等待。

## 常见问题及解决方案

### 1. Permission denied (publickey)

确保SSH密钥已正确配置并添加到GitHub。

### 2. Repository not found

确保GitHub Pages仓库（`loveylwforever.github.io`）已创建。

### 3. 部署后页面空白

检查GitHub Pages设置中的分支配置是否正确。

### 4. 网络连接问题

如果遇到网络连接问题，可以尝试：
- 使用HTTPS而不是SSH
- 检查防火墙设置
- 使用代理或VPN

### 5. 自定义域名

如果需要使用自定义域名：
1. 在仓库根目录创建CNAME文件，内容为你的域名
2. 在域名提供商处设置DNS记录指向GitHub Pages

## 故障排除

如果部署过程中遇到问题，可以尝试以下步骤：

1. 检查所有配置是否正确
2. 确认GitHub Pages仓库已创建
3. 验证SSH密钥配置
4. 清理缓存并重新生成：
   ```bash
   hexo clean && hexo generate
   ```
5. 手动部署：
   ```bash
   cd public
   git init
   git add .
   git commit -m "Site updated"
   git remote add origin git@github.com:loveylwforever/loveylwforever.github.io.git
   git push -u origin main --force
   ```

## 自动化部署（可选）

### 使用GitHub Actions自动部署

在你的源码仓库中创建 `.github/workflows/deploy.yml` 文件：

```yaml
name: Deploy Hexo

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
      with:
        submodules: false
        fetch-depth: 0

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '16'
        
    - name: Setup pnpm
      uses: pnpm/action-setup@v2
      with:
        version: 8

    - name: Install dependencies
      run: pnpm install

    - name: Generate
      run: pnpm run build

    - name: Deploy
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./public
        publish_branch: main
        external_repository: loveylwforever/loveylwforever.github.io
```

然后在GitHub仓库设置中添加以下secrets：
1. 访问仓库的Settings > Secrets and variables > Actions
2. 点击 "New repository secret"
3. 添加以下secret：
   - Name: `GH_PAGES_TOKEN`
   - Value: 你的GitHub个人访问令牌（需要repo权限）

这样配置后，每次推送到main分支时都会自动部署到GitHub Pages.