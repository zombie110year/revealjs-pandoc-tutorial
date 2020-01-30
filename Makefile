index.html: README.md
	pandoc -s -t revealjs --katex -o $@ $<
common.html: README.md
	pandoc -s -t html --katex -o $@ $<
