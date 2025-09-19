# 使用GitHub Actions自动部署Hexo博客

## 概述

GitHub Actions可以帮助你实现Hexo博客的自动化部署。每次向main分支推送代码时，GitHub Actions会自动构建并部署你的博客到GitHub Pages。

## 配置步骤

### 1. 创建GitHub Actions工作流文件

我们已经创建了工作流文件 [.github/workflows/deploy.yml](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/.github/workflows/deploy.yml)，内容如下：

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
        node-version: '18'

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
        deploy_key: ${{ secrets.DEPLOY_KEY }}
        publish_dir: ./public
        publish_branch: main
        external_repository: loveylwforever/loveylwforever.github.io
```

注意：我们使用`deploy_key`而不是`github_token`，因为我们需要推送到外部仓库。

### 2. 配置部署密钥

由于我们需要推送到外部仓库（GitHub Pages仓库），必须配置部署密钥：

1. 生成SSH密钥对：
   ```bash
   ssh-keygen -t rsa -b 4096 -C "github-actions" -f github-actions -N ""
   ```

2. 将公钥添加到GitHub Pages仓库的部署密钥中：
   - 访问 `https://github.com/loveylwforever/loveylwforever.github.io/settings/keys`
   - 点击 "Add deploy key"
   - Title: GitHub Actions
   - Key: 粘贴公钥内容
   - 勾选 "Allow write access"
   - 点击 "Add key"

3. 将私钥添加到源码仓库的Secrets中：
   - 访问 `https://github.com/loveylwforever/gj_blog/settings/secrets/actions`
   - 点击 "New repository secret"
   - Name: DEPLOY_KEY
   - Value: 粘贴私钥内容
   - 点击 "Add secret"

详细配置说明请参考 [GITHUB_ACTIONS_DEPLOY_KEY_SETUP.md](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/GITHUB_ACTIONS_DEPLOY_KEY_SETUP.md)。

### 3. 配置pnpm workspace

确保[pnpm-workspace.yaml](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/pnpm-workspace.yaml)文件配置正确：

```yaml
packages:
  - '.'
  - 'themes/*'
```

这个配置告诉pnpm将当前目录和themes目录下的所有子目录作为workspace的一部分。

### 4. 配置package.json脚本

确保你的 [package.json](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/package.json) 文件包含构建脚本：

```json
{
  "scripts": {
    "build": "hexo generate",
    "clean": "hexo clean",
    "deploy": "hexo deploy",
    "server": "hexo server"
  }
}
```

### 5. 推送代码到GitHub

将所有更改推送到你的源码仓库：

```bash
# 添加所有文件
git add .

# 提交更改
git commit -m "Add GitHub Actions workflow"

# 推送到远程仓库
git push origin main
```

## 工作流说明

### 触发条件
- 当向`main`分支推送代码时自动触发

### 工作步骤
1. **检出代码**：获取仓库代码
2. **设置Node.js环境**：使用Node.js 18
3. **设置pnpm**：安装并配置pnpm包管理器
4. **安装依赖**：安装项目所需的所有依赖
5. **生成静态文件**：运行`hexo generate`命令生成静态文件
6. **部署到GitHub Pages**：使用peaceiris/actions-gh-pages动作部署到GitHub Pages

## 配置GitHub Pages

1. 访问你的GitHub Pages仓库（`loveylwforever.github.io`）
2. 点击 "Settings" 选项卡
3. 在左侧菜单中点击 "Pages"
4. 在 "Source" 部分选择：
   - Source: Deploy from a branch
   - Branch: main
5. 点击 "Save"

## 查看部署状态

1. 在你的源码仓库中，点击 "Actions" 选项卡
2. 查看工作流运行状态
3. 部署成功后，可以在 "Settings" → "Pages" 中查看部署信息

## 常见问题及解决方案

### 1. 权限问题
如果部署失败，可能需要配置仓库权限：
1. 访问仓库的 "Settings" → "Actions" → "General"
2. 在 "Workflow permissions" 部分选择 "Read and write permissions"

### 2. 构建失败
如果构建失败，请检查：
1. [package.json](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/package.json) 中是否有正确的构建脚本
2. [_config.yml](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/_config.yml) 配置是否正确
3. 依赖是否完整

### 3. 部署失败
如果部署失败，请检查：
1. GitHub Pages仓库是否存在且名称正确
2. 工作流文件中的仓库名称是否正确
3. 是否有足够的权限

## 自定义配置

### 使用自定义域名
如果需要使用自定义域名，可以在部署步骤中添加：

```yaml
- name: Deploy
  uses: peaceiris/actions-gh-pages@v3
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    publish_dir: ./public
    publish_branch: main
    external_repository: loveylwforever/loveylwforever.github.io
    cname: your-domain.com
```

### 环境变量
如果需要使用环境变量，可以在工作流中添加：

```yaml
env:
  NODE_VERSION: 18
  PNPM_VERSION: 8

jobs:
  deploy:
    # ...
```

## 故障排除

### 查看构建日志
1. 在仓库的 "Actions" 选项卡中找到失败的工作流
2. 点击具体的运行记录
3. 查看每个步骤的详细日志

### 重新运行工作流
如果工作流失败，可以点击 "Re-run jobs" 重新运行。

### 常见错误及解决方案

#### 1. ERR_PNPM_INVALID_WORKSPACE_CONFIGURATION
**错误信息**：
```
 ERR_PNPM_INVALID_WORKSPACE_CONFIGURATION  packages field missing or empty
```
**解决方案**：
确保[pnpm-workspace.yaml](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/pnpm-workspace.yaml)文件配置正确：
```yaml
packages:
  - '.'
  - 'themes/*'
```

#### 2. 权限问题
**错误信息**：
```
ERROR: Repository not found.
fatal: Could not read from remote repository.
```
**解决方案**：
1. 确保GitHub Pages仓库已创建
2. 检查工作流文件中的仓库名称是否正确
3. 确保有足够权限访问仓库

#### 3. Node.js版本问题
**错误信息**：
```
Error: The engine "node" is incompatible with this module.
```
**解决方案**：
在工作流中指定兼容的Node.js版本：
```yaml
- name: Setup Node.js
  uses: actions/setup-node@v3
  with:
    node-version: '18'
```

#### 4. 依赖安装问题
**错误信息**：
```
npm ERR! missing script: build
```
**解决方案**：
确保[package.json](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/package.json)中包含正确的脚本：
```json
{
  "scripts": {
    "build": "hexo generate"
  }
}
```

### 调试技巧

1. **本地测试**：在推送之前，先在本地测试构建过程
2. **简化工作流**：创建一个简化版本的工作流进行测试
3. **使用GitHub CLI**：使用GitHub CLI查看工作流状态
4. **启用详细日志**：在工作流中添加调试步骤

### 联系支持
如果问题持续存在，可以：
1. 查看GitHub Actions文档
2. 在相关社区寻求帮助
3. 联系GitHub支持

## 监控和通知

你可以在工作流中添加通知步骤，例如Slack通知：

```
- name: Notify Slack
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    channel: '#notifications'
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## 最佳实践

1. **保持依赖更新**：定期更新依赖以获得最新功能和安全修复
2. **测试本地构建**：在推送之前，先在本地测试构建
3. **使用分支策略**：考虑使用分支策略，例如在main分支上进行部署，在其他分支上进行开发
4. **监控构建时间**：注意构建时间，过长的构建时间可能影响体验
5. **备份重要数据**：定期备份博客源码和重要配置
