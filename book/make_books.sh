ebook-convert --version || sudo apt install -y calibre #here I try to install ebook-convert if you don't have it. I only really try for ubuntu, however.

if [ "$1" = "-inplace" -o "$1" = "--inplace" ] && [ -e site/ ] ; then #sometimes disable, for development testing purposes
  echo "I see --inplace has been passed, and the dir exists, so I won't copy the new dir in again."
else
  rm -r -f site/ #make sure we have a clean slate
  cp -r ../mirror/www.terrorisland.net/ site/ # This step might take about a minute cold (on a HDD; on an SSD it should be shorter), but it's important to make sure we don't mess up the mirror by accident.
fi

echo 'Making Foreword into an "open ebook" with ebook-convert and then stealing the file...'
  ebook-convert foreword.md tmp-foreword --title "Foreword" >/dev/null
  cp tmp-foreword/index.html site/2-foreword.md.html
rm -r -f tmp-foreword/

echo 'Making Buzzsaw Review into an "open ebook" with ebook-convert and then stealing the files...'
  ebook-convert site/etcetera/buzzsaw_review.pdf tmp-review --title "Buzzsaw Review" >/dev/null #make it into an "open ebook" with ebook-convert and then steal the files
  cp tmp-review/index.html site/3-buzzsaw_review.pdf.html
  cp tmp-review/index-1_1.jpg site/
rm -r -f tmp-review/

cp title_page.html site/1-title_page.html
cp cover_back.html site/Z-cover_back.html
cp cover_back.pdn.png site/
mv site/strips/index.html site/strips/000-index.html # This is the strip index, the incomplete "Year One Archives"; not to be confused with the website index, which is just the home page.
rm -f site/index.html # This deliberately deletes the old website index.html, as it's just the final strip, anyway. (And therefore the resulting book from it is jus a useless first page, frontmatter, and random strips you can reach from this first starting point.
#tree site/strips --noreport -H . -T "Terror Island" >site/index.html #tree is a worse way to do it...
cd site/
  find -name '*.html' -exec sh -c 'echo "<a href=\"{}\">`basename -s .html {}`</a>" ' \; >0-index.html
cd ..
typeset_book () {
  # $1: file extension for desired file type, including the leading . (empty by default, which makes an OEB, mostly useful for debug)
  # $2: additional ebook-convert options to pass in at the end to facilitate your chosen format.
  #ebook-convert site/strips/063.html books/terror_island_unofficial-wyattscarpenter-2023"$1"  --max-levels 0 #TODO: there is a blank page after #63 that defies reason. Also after the end page, but maybe that's just to get up to an even number of pages? Or maybe it just thinks the back cover is too big.
  echo "Making ebook with following extension: $1"
  ebook-convert site/0-index.html books/terror_island_unofficial-wyattscarpenter-2023"$1" \
    --no-chapters-in-toc --max-toc-links 0 --breadth-first \
    --search-replace replacements.txt \
    --language en --cover cover.pdn.png \
    --authors "Ben Heaton&Lewis Powell" --book-producer "Wyatt S Carpenter" --pubdate 2023 --title "Terror Island" --rating 5 \
    --base-font-size 10 --smarten-punctuation --extra-css "* {box-sizing: border-box; font-size: normal;} p { text-indent: 1.5em; margin: 0em !important; padding-left: 0em !important; } h4 {margin-bottom: 0em; margin-top: 0.3em;} body {margin-left: 0em; margin-right: 0em;} div.title /* this is just styling from the original page that we wiped out by removing the CSS, and want to get back. */ { background:#eeeeee; color:#000000; padding:2px; border-left:15px solid #333333; border-bottom:1px solid #333333; font-size:small; font-weight:bold; } /*here we unsuccessfully try to correct nonsense it otherwise does*/ .calibre1 {margin: 0em !important} .strip1 {padding: 0em !important}" \
    $2 #&>/dev/null

}

typeset_book ".pdf" '--custom-size 5.245x8.5  --pdf-page-margin-bottom 0 --pdf-page-margin-left 0 --pdf-page-margin-right 0 --pdf-page-margin-top 0 --margin-bottom 0 --margin-top 0 --margin-left 0 --margin-right 0 ' & # pdf options #interestingly, --pdf-footer-template <center>_PAGENUM_</center> gets an out-of-range error (calibre 6.11) #--paper-size a5 is closest to US trade paperback (6x9in) of the default options, but none are close enough, nor close enough to what we want...
rm -r books/terror_island_unofficial-wyattscarpenter-2023
typeset_book & # This will create the OEB format
wait

#disable only for development purposes, sometimes
if [ "$1" = "-inplace" -o "$1" = "--inplace" ] ; then
  echo "I see --inplace has been passed, so I won't remove the content dir to clean up."
else
  rm -r site/
fi
