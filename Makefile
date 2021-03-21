# Global variables {{{1
# ================
# Where make should look for things
VPATH = _lib
vpath %.csl _csl
vpath %.yaml .:_spec
vpath default.% _lib

# Branch-specific targets and recipes {{{1
# ===================================

# Jekyll {{{2
# ------
ANYTHING     := $(filter_out _site,$(wildcard *))
JEKYLL       := palazzo/jekyll-pandoc:4.2.0-2.12

build : $(ANYTHING) | _csl
	docker run --rm -v "`pwd`:/srv/jekyll" \
		-v "`pwd`/.vendor/bundle:/usr/local/bundle" \
		$(JEKYLL) jekyll build --future

serve :
	docker run --rm -it -v "`pwd`:/srv/jekyll" \
		-v "`pwd`/.vendor/bundle:/usr/local/bundle" \
		-p 4000:4000 -h 0.0.0.0:127.0.0.1 \
		$(JEKYLL) jekyll serve --incremental

# Install and cleanup {{{1
# ===================

_csl :
	git clone --depth=1 \
		https://github.com/citation-style-language/styles \
		_csl


Gemfile.lock : Gemfile
	docker run --rm -v "`pwd`:/srv/jekyll" \
		-v "`pwd`/.vendor/bundle:/usr/local/bundle" \
		$(JEKYLL) bundle update

# `make clean` will clear out a few standard folders where only compiled
# files should be. Anything you might have placed manually in them will
# also be deleted!
clean :
	-rm -r _book/* _site/* _csl

# vim: set foldmethod=marker :
