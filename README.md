# HFSP: homology-derived functional similarity of proteins

[![Build and test](https://github.com/mooreryan/hfsp/actions/workflows/build_and_test.yml/badge.svg?branch=main)](https://github.com/mooreryan/hfsp/actions/workflows/build_and_test.yml) [![Coverage Status](https://coveralls.io/repos/github/mooreryan/hfsp/badge.svg?branch=main)](https://coveralls.io/github/mooreryan/hfsp?branch=main)

Calculate the HFSP score from the [Mahlich et al., 2018](https://doi.org/10.1093/bioinformatics/bty262) paper *HFSP: high speed homology-driven function annotation of proteins*.

For theory and details see the manuscript.

## Install

### Precompiled binaries

If you have MacOS or Linux, the easiest way is to download one of the precompiled binaries on the [release](https://github.com/mooreryan/hfsp/releases/) page.

### From source

If you are brave (or if you are an OCaml programmer), you can install from source.

* First you need to [set up](https://dev.realworldocaml.org/install.html) OCaml.
* Then you need to [set up](https://opam.ocaml.org/doc/Install.html#Using-your-distribution-39-s-package-system) Opam, the OCaml package manager.
* Finally, clone this repository and install.

```
$ git clone https://github.com/mooreryan/hfsp.git
$ cd hfsp
$ opam install . --deps-only --with-doc --with-test
$ make test && make build_release && make install
```

If all is well, you should be able to run the program:

```
$ hfsp
... help screen should appear ...
```

## Run

To get HFSP scores, you first need to run [mmseqs](TODO), then run the `hfsp` script on the output.  According to the [manuscript], you should run MMseqs2 with some particular options.  I have a helper script you can use for this in `_scripts/run_mmseqs.sh`.

```
$ sh _scripts/run_mmseqs.sh queries.faa targets.faa search.tsv tmpdir 4
```

Note, that 4 is the number of threads.

One important thing about that script is it has a special output format: `--format-output query,target,fident,bits,cigar`.  This is key for the `hfsp` program to work properly.

Now, you can run the `hfsp` program.

```
$ hfsp overall search.tsv > hfsp_scores.tsv
```

### "Best" hits

If you read the [hfsp] help screen you'll see something like this:

```
"Best" means hit with highest bit score.  HFSP is only calculated on 
  "best" hits.  overall|pair controls which "best" hits to report.

overall -- Only one score is printed per query.  It is the score to 
  the best target. 

pair -- One score is printed for each query-target pair.  It is the 
  best score for each query-target pair.
```

Basically, you can pick if you want the overall best score for each query, or if you want the best score for each query-target pair.

Note that if you pick `pair` rather than overall, your output file will be *much* larger.  For example, in a run of ~3000 queries versus ~2500 targets, the `overall` file was a couple hundred *kilobytes*, whereas the `pair` output files was a couple hundred *megabytes*.
