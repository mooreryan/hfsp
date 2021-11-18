open Base
open Hfsp

let abort ?(exit_code = 1) msg =
  let () = Stdio.eprintf "%s\n" msg in
  Caml.exit exit_code

let version = "0.1.0"

let usage_msg =
  {eof|usage: hfsp <method: overall|pair> <search_out.tsv> > out.tsv

"Best" means hit with highest bit score.  HFSP is only calculated on
  "best" hits.  overall|pair controls which "best" hits to report.

overall -- Only one score is printed per query.  It is the score to
  the best target.

pair -- One score is printed for each query-target pair.  It is the
  best score for each query-target pair.

Don't forget to run mmseqs2 with
  --format-output query,target,fident,bits,cigar
|eof}

let help_msg = [%string "hfsp version %{version}\n\n%{usage_msg}"]

let parse_args () =
  let open Or_error.Let_syntax in
  let args = Sys.get_argv () in
  (* First arg is program name. *)
  if Array.length args < 3 then
    let msg = "You need at least 2 command line arguments!\n\n" ^ help_msg in
    Or_error.error_string msg
  else
    let%bind method_ = Lib.method_of_string args.(1) in
    let infile = args.(2) in
    if Caml.Sys.file_exists infile then Or_error.return (method_, infile)
    else Or_error.error_string "Input file does not exist!"

let main () =
  let method_, infile =
    match parse_args () with
    | Ok (m, i) -> (m, i)
    | Error err -> abort ("ERROR: " ^ Error.to_string_hum err)
  in
  Lib.run method_ infile

let () = main ()
