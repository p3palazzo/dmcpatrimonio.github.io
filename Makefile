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

serve: build
	bundle exec jekyll serve

build: bundle
	bundle exec jekyll build


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
install : link-template makedirs submodule lib virtualenv bundle license
	# rm -rf .install
	# The .install folder is quite small and is thus not removed even
	# after a successful run of `make install`. This is useful should
	# you need to reinstall or if you want to reconfigure your
	# submodules (e.g. to checkout other citation styles). If that
	# bothers you, uncomment the line above.

makedirs :
	# -mkdir -p _share && mkdir -p _book && mkdir -p fig
	# if you prefer to keep binary files somewhere else (for
	# example, in a synced Dropbox), uncomment the lines below.
	ln -s $(SHARE)/_book _book
	ln -s $(SHARE)/_share _share
	ln -s $(SHARE)/fig fig
	ln -s $(SHARE)/assets assets

link-template :
	# Generating a repo from a GitHub template breaks the
	# submodules. As a workaround, we create a branch that clones
	# directly from the template repo, activate the submodules
	# there, then merge it into whatever branch was previously
	# active (the master branch if your repo has just been
	# initialized).
	-git remote add template git@github.com:p3palazzo/research_template.git
	git fetch template
	git checkout -B template --track template/master

lib :   .install/git/modules/lib/styles/info/sparse-checkout \
	.install/git/modules/lib/pandoc-templates/info/sparse-checkout
	rsync -aq .install/git/ .git/
	cd lib/styles && git config core.sparsecheckout true && \
		git checkout master && git pull && \
		git read-tree -m -u HEAD
	cd lib/pandoc-templates && git config core.sparsecheckout true \
		&& git checkout master && git pull && \
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
