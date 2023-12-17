ebook-convert --version || sudo apt install -y calibre #here I try to install ebook-convert if you don't have it. I only really try for ubuntu, however.
#zip --version >/dev/null || sudo apt install -y zip #ditto
tree --version || sudo apt install -y tree #you actually don't need tree for anything here tbh.
cp -r ../mirror/www.terrorisland.net/ site/ # This step might take about a minute cold (on a HDD; on an SSD it should be shorter), but it's important to make sure we don't mess up the mirror by accident.

#pandoc foreword.md -o _foreword.md.html #technically you need pandoc to generate this file
ebook-convert foreword.md tmp-foreword >/dev/null #make it into an "open ebook" with ebook-convert and then steal the file, but I haven't required the user to download that, to minimize deps.)
cp tmp-foreword/index.html _foreword.md.html
rm -r tmp-foreword/

cp cover.html cover.pdn.png _foreword.md.html title_page.html site/
#zip -r site site/*
rm site/index.html #this deliberately deletes the old index.html, as it's just the final strip, anyway. (And therefore the resulting book is just a useless first page, frontmatter, and random strips you can reach from this first starting point.
tree site/strips -H . >site/strips/index.html 
ebook-convert site/strips/index.html books/out.pdf --no-chapters-in-toc --paper-size a5 --pdf-page-margin-bottom 0 --pdf-page-margin-left 0 --pdf-page-margin-right 0 --pdf-page-margin-top 0 --margin-bottom 0 --margin-left 0 --margin-right 0 --margin-top 0  --language en --search-replace replacements.txt
#disable only for development purposes, sometimes
rm -r site/
