open Base
open Hfsp
open Stdio

let print_line_parse_result x =
  print_endline
  @@ Sexp.to_string_hum ~indent:1 ([%sexp_of: Lib.search_record Or_error.t] x)

let%expect_test _ =
  print_line_parse_result @@ Lib.parse_search_line "a\tb\t1\t2\t1M2D3I";
  [%expect
    {|
    (Ok
     ((query a) (target b) (pident 100) (bit_score 2)
      (cigar ((1 Match) (2 Deletion) (3 Insertion))))) |}]

let%expect_test "fractions get turned to percents" =
  print_line_parse_result @@ Lib.parse_search_line "a\tb\t0.5\t2\t1M2D3I";
  [%expect
    {|
    (Ok
     ((query a) (target b) (pident 50) (bit_score 2)
      (cigar ((1 Match) (2 Deletion) (3 Insertion))))) |}]

let%expect_test _ =
  print_line_parse_result @@ Lib.parse_search_line "a b 1 2 1M2D3I";
  [%expect
    {| (Error "Wrong number of tokens when parsing line: 'a b 1 2 1M2D3I'") |}]

let%expect_test _ =
  print_line_parse_result @@ Lib.parse_search_line "";
  [%expect {| (Error "Wrong number of tokens when parsing line: ''") |}]

let%expect_test _ =
  print_line_parse_result @@ Lib.parse_search_line "a\tb\tc\td\te";
  [%expect
    {| (Error "Failed to parse float") |}]

let%expect_test _ =
  print_line_parse_result @@ Lib.parse_search_line "a\tb\t1\td\te";
  [%expect
    {| (Error "Failed to parse float") |}]

let%expect_test _ =
  let redact s =
    Re2.replace_exn (Re2.create_exn "\\(.*cigar.ml.Exn") s ~f:(fun _ ->
        "(REDACTED cigar exn")
  in
  let print_it x =
    print_endline @@ redact
    @@ Sexp.to_string_hum ~indent:1 ([%sexp_of: Lib.search_record Or_error.t] x)
  in
  print_it @@ Lib.parse_search_line "a\tb\t1\t2\tpie";
  [%expect
    {|
    (Error
     ("Error parsing cigar string"
      (REDACTED cigar exn "Expected int or operation. Got p")))

    |}]

let%expect_test "fident too low" =
  print_line_parse_result @@ Lib.parse_search_line "a\tb\t-0.5\t2\tM";
  [%expect {| (Error "fident should be between 0 and 1.  Got -0.500000.") |}]

let%expect_test "fident too high" =
  print_line_parse_result @@ Lib.parse_search_line "a\tb\t1.5\t2\tM";
  [%expect {| (Error "fident should be between 0 and 1.  Got 1.500000.") |}]
