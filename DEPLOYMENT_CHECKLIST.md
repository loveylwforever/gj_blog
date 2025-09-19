# Hexo博客部署检查清单

## 1. 仓库检查

### 源码仓库
- [ ] 确认已创建源码仓库：`https://github.com/loveylwforever/gj_blog.git`
- [ ] 确认仓库为私有或公开（根据个人需求）

### GitHub Pages仓库
- [ ] 确认已创建GitHub Pages仓库：`https://github.com/loveylwforever/loveylwforever.github.io.git`
- [ ] 确认仓库为公开（GitHub Pages要求）
- [ ] 确认仓库名称严格遵循格式：`用户名.github.io`
- [ ] 确认创建时没有初始化任何文件（不添加README、.gitignore或license）

## 2. SSH密钥检查

### 本地SSH密钥
- [ ] 确认本地存在SSH密钥：
  ```bash
  ls -la ~/.ssh
  ```
- [ ] 如果没有SSH密钥，生成新的：
  ```bash
  ssh-keygen -t ed25519 -C "your_email@example.com"
  ```

### GitHub SSH密钥
- [ ] 复制公钥内容：
  ```bash
  cat ~/.ssh/id_ed25519.pub
  ```
- [ ] 访问GitHub SSH密钥设置：https://github.com/settings/keys
- [ ] 添加SSH公钥到GitHub账户

### SSH连接测试
- [ ] 测试SSH连接：
  ```bash
  ssh -T git@github.com
  ```
- [ ] 确认返回信息包含成功认证的消息

## 3. 配置文件检查

### _config.yml部署配置
确认 [_config.yml](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/_config.yml) 文件中的部署配置正确：
```yaml
deploy:
  type: git
  repo: git@github.com:loveylwforever/loveylwforever.github.io.git
  branch: main
```

或者使用HTTPS方式：
```yaml
deploy:
  type: git
  repo: https://github.com/loveylwforever/loveylwforever.github.io.git
  branch: main
```

## 4. 部署步骤

### 自动部署
```bash
# 清理、生成并部署
hexo clean && hexo generate && hexo deploy
```

### 手动部署
```bash
# 1. 生成静态文件
hexo generate

# 2. 进入public目录
cd public

# 3. 初始化git仓库（如果尚未初始化）
git init

# 4. 添加所有文件
git add .

# 5. 提交更改
git commit -m "Site updated: $(date)"

# 6. 添加远程仓库
git remote add origin git@github.com:loveylwforever/loveylwforever.github.io.git

# 7. 推送到远程仓库
git branch -M main
git push -u origin main --force
```

## 5. GitHub Pages设置

### 启用GitHub Pages
1. 访问GitHub Pages仓库：https://github.com/loveylwforever/loveylwforever.github.io
2. 点击 "Settings" 选项卡
3. 在左侧菜单中点击 "Pages"
4. 在 "Source" 部分选择：
   - Source: Deploy from a branch
   - Branch: main
5. 点击 "Save"

### 自定义域名（可选）
1. 在仓库根目录创建CNAME文件，内容为你的域名
2. 在域名提供商处设置DNS记录指向GitHub Pages

## 6. 验证部署

### 访问博客
部署完成后，访问以下地址：
```
https://loveylwforever.github.io
```

### 常见问题排查
1. **Permission denied (publickey)**：检查SSH密钥配置
2. **Repository not found**：确认GitHub Pages仓库已创建且名称正确
3. **页面空白**：检查GitHub Pages设置中的分支配置
4. **网络连接问题**：尝试切换网络或使用代理

## 7. 故障排除

### 网络问题
如果遇到网络连接问题：
1. 尝试使用HTTPS而不是SSH
2. 检查防火墙设置
3. 使用代理或VPN

### 权限问题
如果遇到权限问题：
1. 确认SSH密钥已正确添加到GitHub
2. 确认仓库访问权限设置正确
3. 确认仓库名称正确无误

### 配置问题
如果部署配置有问题：
1. 检查 [_config.yml](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/_config.yml) 中的deploy配置
2. 确认仓库URL和分支名称正确
3. 确认hexo-deployer-git插件已安装