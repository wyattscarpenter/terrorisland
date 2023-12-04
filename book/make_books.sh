cp -r ../mirror/www.terrorisland.net/ site/ # This step might take about a minute (on a HDD; on an SSD it should be shorter), but it's important to make sure we don't mess up the mirror on accident.
ebook-convert || sudo apt install -y calibre #here I try to install ebook-convert if you don't have it.
ebook-convert foreword.md -o foreword.md.html
#pandoc foreword.md -o foreword.md.html
cp cover.html cover.pdn.png foreword.md.html site/
cd site
ls
#TODO: use ebook-convert because pandoc doesn't really work here
#pandoc -s -V geometry:a5paper --epub-cover-image=cover.pdn.png cover.html foreword.md.html *.html -o ../books/terror_island_unofficial-wyattscarpenter-2023.pdf # ../cover_back.pdn.png
cd ..
rm -r site/