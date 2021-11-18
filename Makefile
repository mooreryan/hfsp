BROWSER = firefox
TEST_COV_D = /tmp/hfsp

.PHONY: all
all: clean build_release install

.PHONY: build
build:
	GIT_COMMIT_HASH=`git describe --always --dirty` \
	  dune build

.PHONY: build_release
build_release:
	GIT_COMMIT_HASH=`git describe --always --dirty` \
	  dune build --profile=release

.PHONY: check
check:
	dune build @check

.PHONY: clean
clean:
	dune clean

.PHONY: install
install:
	GIT_COMMIT_HASH=`git describe --always --dirty` \
	  dune install --profile=release

.PHONY: test
test:
	dune test

.PHONY: test_coverage
test_coverage:
	if [ -d $(TEST_COV_D) ]; then rm -r $(TEST_COV_D); fi
	mkdir -p $(TEST_COV_D)
	BISECT_FILE=$(TEST_COV_D)/hfsp dune runtest --no-print-directory \
	  --instrument-with bisect_ppx --force
	bisect-ppx-report html --coverage-path $(TEST_COV_D)
	bisect-ppx-report summary --coverage-path $(TEST_COV_D)

.PHONY: test_coverage_open
test_coverage_open: test_coverage
	$(BROWSER) _coverage/index.html
