# !/bin/sh -e

AUTORECONF=`which autoreconf 2>/dev/null`
if test $? -ne 0; then
  echo "No 'autoreconf' found. You must install the autoconf package."
  exit 1
fi

GIT=$(which git 2>/dev/null)
if test $? -ne 0; then
  echo "No 'git' found. You must install the git package."
  exit 1
fi

# create m4 before gtkdocize
mkdir m4 2>/dev/null

GTKDOCIZE=`which gtkdocize 2>/dev/null`
if test $? -ne 0; then
  echo "No gtk-doc support found. You can't build the docs."
  # rm because gtk-doc.make might be a link to a protected file
  rm -f gtk-doc.make 2>/dev/null
  echo "EXTRA_DIST =" >gtk-doc.make
  echo "CLEANFILES =" >>gtk-doc.make
  GTKDOCIZE=""
else
  $GTKDOCIZE || exit $?
fi

$GIT submodule init
$GIT submodule update

gnulib_modules="
accept
bind
c-strcase
c-ctype
clock-time
close
connect
dup2
errno
fcntl
flock
fnmatch
futimens
getaddrinfo
getsockname
gettext-h
glob
iconv
inttypes
listen
nanosleep
netdb
netinet_in
nl_langinfo
open
poll
pwrite
qsort_r
read
send
sendto
servent
setsockopt
socket
stdarg
stddef
stdint
strcase
strdup-posix
strndup
sys_file
sys_socket
sys_stat
sys_time
sys_types
write
"

gnulib/gnulib-tool --import $gnulib_modules

$AUTORECONF --install --force --symlink || exit $?

echo
echo "----------------------------------------------------------------"
echo "Initialized build system. For a common configuration please run:"
echo "----------------------------------------------------------------"
echo
if test -z $GTKDOCIZE; then
  echo "./configure"
else
  echo "./configure --enable-gtk-doc"
fi
echo
