# Global variables {{{1
# ================
# Where make should look for things
VPATH = _lib
vpath %.csl _csl
vpath %.yaml .:_spec
vpath default.% _lib/pandoc-templates

# Branch-specific targets and recipes {{{1
# ===================================

# Jekyll {{{2
# ------
SRC           = $(wildcard *.md)
SITE         := $(patsubst %.md,_site/%/index.html, $(DOCS))

serve : $(SITE)
	bundle exec jekyll serve 2>&1 | egrep -v 'deprecated'

build : $(SRC)
	docker run \
	-v "`pwd`:/srv/jekyll" -v "`pwd`/_site:/srv/jekyll/_site" \
	jekyll/builder:3.8.5 /bin/bash -c "chmod 777 /srv/jekyll && jekyll build --future"


# Install and cleanup {{{1
# ===================

# `make clean` will clear out a few standard folders where only compiled
# files should be. Anything you might have placed manually in them will
# also be deleted!
clean :
	-rm -r _book/* _site/*

# vim: set foldmethod=marker :
