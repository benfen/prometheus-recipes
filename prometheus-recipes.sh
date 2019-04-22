#!/bin/bash

# Created by argbash-init v2.8.0
# ARG_OPTIONAL_BOOLEAN([delete],[],[Deletes all the kubernetes resources generated by a normal run],[off])
# ARG_POSITIONAL_SINGLE([namespaces],[List of comma-separated namespaces for prometheus to listen to.  By default, the default, kube-system, and monitoring namespaces are all monitored.],[""])
# ARG_DEFAULTS_POS()
# ARG_HELP([Initializes a prometheus agent within a kubernetes cluster])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.8.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}


begins_with_short_option()
{
	local first_option all_short_options='h'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_namespaces=""
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_delete="off"


print_help()
{
	printf '%s\n' "Initializes a prometheus agent within a kubernetes cluster"
	printf 'Usage: %s [--(no-)delete] [-h|--help] [<namespaces>]\n' "$0"
	printf '\t%s\n' "<namespaces>: List of comma-separated namespaces for prometheus to listen to.  By default, the default, kube-system, and monitoring namespaces are all monitored. (default: '""')"
	printf '\t%s\n' "--delete, --no-delete: Deletes all the kubernetes resources generated by a normal run (off by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			--no-delete|--delete)
				_arg_delete="on"
				test "${1:0:5}" = "--no-" && _arg_delete="off"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 0 and 1, but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_namespaces "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


printf "'%s' is %s\\n" 'delete' "$_arg_delete"
printf "Value of '%s': %s\\n" 'namespaces' "$_arg_namespaces"


export namespaces=$_arg_namespaces
export delete=$_arg_delete

(
    cd $(dirname $0)
    ./prometheus.sh
)
# ] <-- needed because of Argbash
