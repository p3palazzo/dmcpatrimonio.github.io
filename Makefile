# Global variables {{{1
# ================
# Where make should look for things
VPATH = lib
vpath %.csl lib/styles
vpath %.yaml .:spec
vpath default.% lib/pandoc-templates
vpath default.% lib/templates
vpath reference.% lib/templates
# Sets a base directory for project files that reside somewhere else,
# for example in a synced virtual drive.
SHARE = ~/dmcp/arqtrad/arqtrad

# Branch-specific targets and recipes {{{1
# ===================================

# Jekyll {{{2
# ------
SRC           = $(wildcard *.md)
SITE         := $(patsubst %.md,_site/%/index.html, $(DOCS))

serve : $(SITE)
	bundle exec jekyll serve 2>&1 | egrep -v 'deprecated'

build : $(SRC)
	bundle exec jekyll build 2>&1 | egrep -v 'deprecated'


# Install and cleanup {{{1
# ===================
# `make install` copies various config files and hooks to the .git
# directory and sets up standard empty directories:
# - link-template: sets up the template repo in a branch named `template`, for
#   when you want to update local boilerplates across different projects.
# - makedirs: creates standard folders for output (_book), received files
#   (_share), and figures (fig).
# - submodule: initializes the submodules for the CSL styles and for the
#   Reveal.js framework.
# - virtualenv: sets up a virtual environment (but you still need to activate
#   it from the command line).
.PHONY : install link-template makedirs submodule virtualenv clean
install : link-template makedirs submodule virtualenv bundle
	# rm -rf .install
	# The .install folder is quite small and is thus not removed even
	# after a successful run of `make install`. This is useful should
	# you need to reinstall or if you want to reconfigure your
	# submodules (e.g. to checkout other citation styles). If that
	# bothers you, uncomment the line above.

link-template :
	-git remote add template git@github.com:p3palazzo/research_template.git
	git fetch template
	git checkout -B template --track template/master

makedirs :
	-mkdir _share
	-mkdir _book
	-mkdir fig

submodule :
	git submodule update --init
	rsync -aq .install/git/ .git/
	cd lib/styles && git config core.sparsecheckout true && \
		git read-tree -m -u HEAD

submodule : link-template
	git checkout template
	git pull
	-git submodule init
	git submodule update
	git checkout -
	git merge template --allow-unrelated-histories

virtualenv :
	python -m virtualenv .venv && source .venv/bin/activate && \
		pip install -r .install/requirements.txt
	-rm -rf src

bundle : Gemfile
	bundle install --path .vendor/bundle

# `make clean` will clear out a few standard folders where only compiled
# files should be. Anything you might have placed manually in them will
# also be deleted!
clean :
	-rm -r _book/* _site/*

# vim: set foldmethod=marker tw=72 shiftwidth=2 tabstop=2 :
