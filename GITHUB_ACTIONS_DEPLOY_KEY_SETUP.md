# GitHub Actions部署密钥配置指南

## 重要安全提醒

**注意**：由于之前不小心将SSH密钥提交到了公共仓库，为了安全起见，您需要重新生成SSH密钥对并更新相关配置。

## 问题描述

GitHub Actions部署失败，错误信息：
```
Action failed with "The generated GITHUB_TOKEN (github_token) does not support to push to an external repository. Use deploy_key or personal_token."
```

## 问题原因

当需要将内容部署到外部仓库（与源码仓库不同的仓库）时，默认的`GITHUB_TOKEN`没有权限推送到外部仓库。

## 解决方案

使用部署密钥（Deploy Key）来代替默认的`GITHUB_TOKEN`。

## 配置步骤

### 1. 生成SSH密钥对

在本地生成SSH密钥对：
```bash
ssh-keygen -t rsa -b 4096 -C "github-actions" -f github-actions -N ""
```

这将生成两个文件：
- `github-actions`（私钥）
- `github-actions.pub`（公钥）

### 2. 配置GitHub Pages仓库的部署密钥

1. 访问GitHub Pages仓库的部署密钥设置页面：
   `https://github.com/用户名/用户名.github.io/settings/keys`

2. 点击 "Add deploy key"

3. 填写以下信息：
   - Title: GitHub Actions
   - Key: 粘贴公钥内容（`github-actions.pub`文件的内容）
   - 勾选 "Allow write access"

4. 点击 "Add key"

### 3. 配置源码仓库的Secrets

1. 访问源码仓库的Secrets设置页面：
   `https://github.com/用户名/源码仓库名/settings/secrets/actions`

2. 点击 "New repository secret"

3. 填写以下信息：
   - Name: DEPLOY_KEY
   - Value: 粘贴私钥内容（`github-actions`文件的内容）

4. 点击 "Add secret"

### 4. 更新GitHub Actions工作流文件

修改 [.github/workflows/deploy.yml](file:///Users/gaojian/01-P-Projects/hexo/gj_blog/.github/workflows/deploy.yml) 文件中的部署步骤：

```yaml
- name: Deploy
  uses: peaceiris/actions-gh-pages@v3
  with:
    deploy_key: ${{ secrets.DEPLOY_KEY }}
    publish_dir: ./public
    publish_branch: main
    external_repository: username/username.github.io
```

### 5. 推送更改并验证

推送更改到GitHub，GitHub Actions应该能够正常部署。

## 验证配置

配置完成后，可以通过以下方式验证：

1. 查看GitHub Actions运行状态
2. 检查GitHub Pages仓库是否有新的提交
3. 访问博客网站查看是否更新

## 安全注意事项

1. 私钥只能添加到Secrets中，不能公开分享
2. 部署密钥只应具有必要的最小权限
3. 定期轮换密钥以提高安全性
4. **切勿将私钥文件提交到公共仓库**

## 故障排除

如果仍然遇到问题，请检查：

1. 公钥是否正确添加到GitHub Pages仓库
2. 私钥是否正确添加到源码仓库的Secrets
3. 工作流文件中的仓库名称是否正确
4. 部署密钥是否允许写入权限