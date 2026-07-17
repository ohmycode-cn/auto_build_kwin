# auto_build_kwin

在 Arch Linux 上自动构建安装 [KDE-Rounded-Corners](https://github.com/matinlotfali/KDE-Rounded-Corners) KWin 圆角窗口效果插件。

## 友情提示

- 执行这个脚本不需要脑子 ！
- 这是一个懒人脚本 ！

## 前提条件

- Arch Linux 或基于 Arch 的发行版
- `pacman` 包管理器
- Root 权限（用于 `pacman` 和 `cmake --install`）

### 依赖项

运行构建脚本前需安装以下依赖：

| 包名                   | 用途                |
|------------------------|---------------------|
| `git`                  | 克隆源码仓库        |
| `cmake`                | 构建系统            |
| `extra-cmake-modules`  | KDE CMake 模块      |
| `qt6-tools`            | Qt 6 开发工具       |
| `kwin`                 | KWin 窗口管理器头文件|
| `libepoxy`             | OpenGL 函数管理     |
| `vulkan-headers`       | Vulkan API 头文件   |
| `clang`                | C/C++ 编译器        |
| `wget`                 | 下载工具            |

一键安装所有依赖：

```bash
sudo pacman -S --noconfirm git cmake extra-cmake-modules qt6-tools kwin libepoxy vulkan-headers clang wget
```

## 使用方法

1. 克隆本仓库：

```bash
git clone <仓库地址>
cd auto_build_kwin
```

2. 运行构建脚本：

```bash
bash build.sh
```

脚本将依次执行：
1. 验证 `repo.url.config` 文件是否存在且有效
2. 检查所有依赖是否已安装
3. 克隆 KDE-Rounded-Corners 源码
4. 使用 CMake 构建插件
5. 全局安装插件（需要 root 权限）

## 配置

克隆 URL 从 `repo.url.config` 文件读取，默认指向：

```
https://github.com/matinlotfali/KDE-Rounded-Corners.git
```

如需使用其他源（如个人 Fork），修改 `repo.url.config`：

```bash
echo "https://github.com/你的用户名/KDE-Rounded-Corners.git" > repo.url.config
```

## 项目结构

```
auto_build_kwin/
├── build.sh          # 主构建脚本
├── repo.url.config   # Git 克隆 URL 配置
├── README.md         # 本文件
└── .gitignore
```

## 常见问题

### 依赖缺失

脚本会退出并提示未安装的依赖：

```
[ERROR] <包名> is not installed, please exec cmd: sudo pacman -S --noconfirm <包名>
```

### 构建失败

如果 CMake 构建失败，请检查：
- 所有依赖已安装且为最新版本
- 有充足的磁盘空间
- KWin 版本与当前 KDE Plasma 版本匹配

### 权限不足

安装步骤需要 root 权限，请使用 `sudo` 运行或以 root 身份执行。

## 致谢

本项目的开发参考并引用了以下开源仓库，在此表示感谢：

| 仓库 | 作者 | 说明 |
|------|------|------|
| [KDE-Rounded-Corners](https://github.com/matinlotfali/KDE-Rounded-Corners) | [matinlotfali](https://github.com/matinlotfali) | 本项目的核心构建目标，为 KDE Plasma 窗口管理器添加圆角窗口效果 |

本项目仅封装了自动化构建流程，KDE-Rounded-Corners 的版权与许可证归原作者所有。

## 许可证

本项目采用 [MIT 许可证](LICENSE)。[KDE-Rounded-Corners](https://github.com/matinlotfali/KDE-Rounded-Corners) 插件有其独立的许可证。
