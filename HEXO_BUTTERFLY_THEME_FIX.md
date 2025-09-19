# Hexo Butterfly 主题修复完整过程手册

## 问题描述

在将 Butterfly 主题文件夹放入 Hexo 项目后，启动服务时出现以下问题：
1. 缺少必要的依赖模块导致启动错误
2. 主页显示原始模板代码而不是渲染后的内容
3. 端口冲突导致服务无法正常启动

## 修复过程

### 第一步：安装缺失的依赖模块

Butterfly 主题需要以下依赖模块才能正常工作：

```bash
# 安装 hexo-util 模块
pnpm add hexo-util

# 安装 moment-timezone 模块
pnpm add moment-timezone

# 安装 hexo-renderer-pug 模块（用于渲染 Pug 模板）
pnpm add hexo-renderer-pug
```

### 第二步：清理和重新生成网站

在安装完依赖后，需要清理缓存并重新生成网站：

```bash
# 清理缓存
hexo clean

# 重新生成静态文件
hexo generate
```

### 第三步：启动服务

完成以上步骤后，可以正常启动服务：

```bash
# 启动服务（默认使用 4000 端口）
hexo server

# 或指定其他端口
hexo server -p 4001
```

## 验证修复结果

启动服务后，访问 `http://localhost:4000`（或指定的其他端口），应该能看到正常渲染的博客主页，而不是原始模板代码。

## 常见问题及解决方案

### 1. 依赖模块缺失
**问题**：出现 `Cannot find module 'xxx'` 错误
**解决方案**：使用 `pnpm add` 命令安装缺失的模块

### 2. 模板渲染问题
**问题**：页面显示原始模板代码
**解决方案**：确保安装了正确的模板渲染器（如 `hexo-renderer-pug`）

## 项目依赖说明

当前项目需要以下核心依赖：

- `hexo`: ^7.3.0
- `hexo-renderer-pug`: ^3.0.0（用于渲染 Butterfly 主题的 Pug 模板）
- `hexo-renderer-stylus`: ^3.0.1（用于渲染 Stylus 样式）
- `hexo-util`: ^3.3.0（Butterfly 主题依赖）
- `moment-timezone`: ^0.6.0（Butterfly 主题依赖）

## 备注

建议使用 `pnpm` 作为包管理工具以保持依赖一致性，避免使用 `npm` 或 `yarn` 混合安装。

## 配置热更新选项
你可以在站点配置文件 _config.yml 中配置服务器选项：
```yaml
# Server
server:
  port: 4000
  compress: false
  header: true
```