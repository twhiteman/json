all:

node_modules/.bin/ronn:
	npm install
node_modules/.bin/nodeunit:
	npm install
node_modules/.bin/uglifyjs:
	npm install
deps/JSON-js/json_parse.js:
	git submodule update --init


# Ensure jsontool.js and package.json have the same version.
versioncheck:
	[[ `cat package.json | bin/json version` == `grep '^var VERSION' lib/jsontool.js | awk -F'"' '{print $$2}'` ]]

docs: node_modules/.bin/ronn
	mkdir -p man/man1
	node_modules/.bin/ronn -r json.1.ronn > man/man1/json.1
	@echo "# test with 'man man/man1/json.1'"

test: node_modules/.bin/nodeunit
	(cd test && make test)
testall:
	(cd test && make testall)

cutarelease: versioncheck
	./support/cutarelease.py -f package.json -f lib/jsontool.js

# Update the embedded minified "function json_parse" in lib/jsontool.js.
update_json_parse: deps/JSON-js/json_parse.js node_modules/.bin/uglifyjs
	@./support/update_json_parse.js

.PHONY: test cutarelease update_json_parse
