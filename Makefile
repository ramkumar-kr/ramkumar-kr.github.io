dev:
	bundle exec jekyll serve

prod:
	bundle exec jekyll clean
	bundle exec jekyll build
