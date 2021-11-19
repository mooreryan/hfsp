(lang dune 2.8)

(generate_opam_files true)

(cram enable)

(package
 (name hfsp)
 (version 0.1.1)
 (license "MIT")
 (maintainers "Ryan M. Moore")
 (authors "Ryan M. Moore")
 (homepage "https://github.com/mooreryan/hfsp")
 (source (github mooreryan/hfsp))
 (documentation "https://github.com/mooreryan/hfsp")
 (bug_reports "https://github.com/mooreryan/hfsp/issues")
 (synopsis "Calculate homology-derived functional similarity of protein (HFSP) scores.")  
 (depends
  ;; Note: these versions can be lowered
  (base (>= v0.14))
  (bio_io (>= 0.3))
  (ppx_jane (>= v0.14))
  (re2 (>= v0.14))
  (stdio (>= v0.14))
  ;; Test deps
  (ppx_inline_test (and (>= v0.14) :with-test))
  (ppx_expect (and (>= v0.14) :with-test))
  ;; Dev deps
  (bisect_ppx (and (>= 2.6) :dev))))
