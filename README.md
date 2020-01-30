---
title: pandoc 转换 markdown 为 reveal.js 幻灯片
author: zombie110year
date: 2020年1月30日
revealjs-url: https://cdn.jsdelivr.net/npm/reveal.js@3.9.1
theme: serif.custom
header-includes:
  - |
    ```{=html}
    <link rel="stylesheet" href="theme/serif.custom.css">
    ```
controls: false
controlsTutorial: true
slideNumber: true
hash: true
---

本文由 Markdown 编写，并且可以直接转换为 reveal.js 幻灯片：

```sh
pandoc -s -t revealjs --katex -o ./index.html ./README.md
```

建议到 github.com/zombie110year/revealjs-pandoc-tutorial 下载源码转换后阅读。

---

# 转换命令

:::::: {.columns}

:::{.column}
假设我们的 md 文档名为 `slides.md`，那么用以下命令

```sh
pandoc -s -t revealjs -o ./index.html ./slides.md
```
:::

::: {.column}
- `-s`/`--standalone` 表示生成独立文档
- `-t revealjs` 表示生成目标是 reveal.js 幻灯片
- `-o ./index.html` 表示生成到 `./index.html` 文件
- `./slides.md` 表示输入文件
:::

::::::

---

简单来说，就是：

```sh
pandoc -s -t <目标格式> -o <输出文件> <输入文件>
```

并且，需要将 `reveal.js` 的源代码目录放在 `index.html` 文件的同目录下，
因为 `index.html` 将会通过

```html
<script src="reveal.js/js/reveal.js"></script>
```

来加载 reveal.js 脚本。

---

# 编辑 Markdown 文件

Markdown 中的每一页幻灯，都用 `------` 这样的分割线分隔

这样 pandoc 会把它们转换成不同的 `<section>`

---

## 主题样式

我们可以通过修改 pandoc 的参数来选择主题：
在 pandoc 的手册中，提到会使用变量 `theme` 来设置主题。

在 `reveal.js/css/theme/` 下已经提供了许多个 CSS 文件，这些文件
就是不同主题的样式表。

在 markdown 的 YAML 头处添加

```yaml
theme: serif.custom
```

便可以替换为 `serif.custom.css` 主题。

---

## 自定义主题

只要实现了这些类的样式，就可以了。
reveal.js 使用 SASS 为 CSS 预处理器，
如果你希望将新的主题持续维护下去的话，建议也使用 CSS 预处理器。

比如我就觉得标题的文字太大了，将 `serif.css` 复制为 `serif.custom.css` 修改为

---

```css
.reveal h1 {
  font-size: 2em; /* 原本是 3.77 em */
}

.reveal h2 {
  font-size: 1.55em;
}

.reveal h3 {
  font-size: 1.33em;
}

.reveal h4 {
  font-size: 1em;
}
```

---

## 数学公式

pandoc 完成转化，不需要配置 reveal.js 使用 mathjax。

```latex
\begin{cases}
  x &= \cos{t}\\
  y &= \sin{t}
\end{cases}, t \in [0, 2\pi)
```

我们可以简单地在命令行中指定用 $\KaTeX$：

```sh
pandoc -s -t revealjs --katex -o <out> <in>
```

---

$$
\begin{cases}
  x &= \cos{t}\\
  y &= \sin{t}
\end{cases}, t \in [0, 2\pi)
$$

---

# 全局配置

可以在 Markdown 的 YAML 头中添加所有 reveal.js 的可用配置，
见 reveal.js 在 GitHub 上的 [Readme][reveal-options]。

[reveal-options]: https://github.com/hakimel/reveal.js#configuration

---

# 个体配置

可以对每一张幻灯片设置 `data-*` 属性来达到配置的目的。
在 Markdown 中，使用这样的语法：

```markdown
## <!-- 上一页 -->

# {data-background-color="cyan"}

如果没出问题的话，应该是浅蓝色背景

---

<!-- 下一页 -->
```

---

**注意！**

由于 reveal.js 将第一个标题等级作为幻灯片的划分等级，
因此上面的 `{data-background-color="cyan"}` 是挂在 1 级标题后的。
如果是其他级别的标题，则不会生效，属性会挂载到 `h*` 标签上，而不是 `section` 标签。

下一页预览：

---

# {data-background-color="cyan"}

如果没出问题的话，应该是浅蓝色背景

---

## 高亮(失败）

<!-- TODO: 高亮文本 -->

```html
<span class="highlight-red">红色高亮</span>
```

<span class="fregment highlight-red">红色高亮</span>

---

# 视图

缩略视图
: 按 <kdb>ESC</kdb> 进入缩略图模式，再按一次返回。

演讲者视图
: 按 <kbd>S</kbd> 进入演讲模式，可以显示注释、播放时间、下一页内容等。
因为这个功能是通过弹窗实现的，需要用户给予该页面弹窗权限（并且关闭弹窗拦截的插件）

---

# 进阶功能

- 增量模式
- 多列模式
- 注释
- 暂停

---

## 增量模式

```markdown
::: incremental

- 第一条
- 第二条
- 第三条

:::
```

将会转换成三张幻灯片，条目逐条递增。
下一页演示

---

::: incremental

- 第一条
- 第二条
- 第三条

:::

---

```markdown
::: 类名
:::
```

将会被 pandoc 转换为

```html
<div class="类名"></div>
```

---

## 多列模式

需要一个嵌套的 `.columns > .column` 元素

```markdown
:::: columns
::: {.column width=50%}
左侧
:::
::: {.column width=50%}
右侧
:::
::::
```

---

:::: columns
::: {.column width=50%}
左侧
:::
::: {.column width=50%}
右侧
:::
::::

---

## 注释

将注释包裹在 `.notes` 元素中，只有在演讲者视图才会显示：

```markdown
::: notes
这里是一段注释
:::
```

---

按 <kbd>S</kbd> 查看注释：

::: notes
这里是一段注释
:::

---

## 暂停

插入带空格的三个点，就可以在插入两段文字之间做一个停顿，
需要再次点击才触发下一段：

```markdown
第一段

第二段，马上暂停

.🈳️️.🈳️️.

第三段
```

---

### 演示暂停

第一段

第二段，马上暂停

. . .

第三段

---

# 导出

在打开幻灯片时添加 queryString `print-pdf` 则会调用打印样式将幻灯片
重新排版，然后就可以利用浏览器的打印功能了。

```
http://localhost:8080/?print-pdf&showNotes=true
```

- `showNotes` 用于决定是否显示演讲者注释
- 遗憾的是，需要用基于 chromium 的浏览器才能正常排版，FireFox 调用系统打印功能，格式会乱掉。

来试试这个：[?print-pdf&showNotes=ture](?print-pdf&showNotes=true)。

---

# 指定 CDN

通过在 YAML 头中添加 `revealjs-url` 项的值，来指定 revealjs 路径。

```yaml
revealjs-url: https://cdn.jsdelivr.net/npm/reveal.js@3.9.1
```

如果我们使用了自定义的主题的话，那么在 CDN 上是找不到的。
需要用 pandoc 的 header-includes 配置直接插入我们的 CSS 文件。

---

```yaml
header-includes:
  - |
    ```{=html}
    <link rel="stylesheet" href="path/to/serif.custom.css">
    ```
```

---

# 完

（才不感谢你的阅读呢）
