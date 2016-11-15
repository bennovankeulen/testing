#!/bin/bash - 
#===============================================================================
#          FILE:  bsfm.sh
#         USAGE:  ./bsfm.sh 
#   DESCRIPTION: simple bash file management with aliasses and functions
#       VERSION: 3.0
#===============================================================================
# set -o nounset                              # Treat unset variables as an error

# cd into directory variables without the $
shopt -s cdable_vars


# location of helpfile
h () {
	more $HOME/Dropbox/Scripts/bsfm_help.txt
}

#d safe delete
d () {
		mv -i "$1" ~/Desktop/TRASH
}

# mark target directory
alias mt='export t="$PWD"'
# MARKS 
alias m1='alias g1="cd `pwd` && ls -lhp"'
alias m2='alias g2="cd `pwd` && ls -lhp"'
alias m3='alias g3="cd `pwd` && ls -lhp"'
alias m4='alias g4="cd `pwd` && ls -lhp"'


# navigation
alias ..='cd .. && ls -lhp'
alias ...='cd ../.. && ls -lhp'
alias ....='cd ../../.. && ls -lhp'


# cd and ls
c(){ cd "$@" && ls -lhp ;}

# o if directory: cd into it, if file: open with default application
# TODO o without arguments open current directory in finder "open ." or "gnome-open ."
#      ^ dit werkt in de mac al automatisch, alleen voor ubuntu programmeren dus
o () {
	if [ -d "$1" ] ; then
		cd "$@" && ls -lhp
	else
		if [[ $OSTYPE == "darwin"* ]] ; then
		open "$1"
		else
		gnome-open "$1"
	#xdg-open "$1"
		fi
	fi
}

# find directory with string and cd into it
fd () {
cd `find . -maxdepth 1 -type d -iname "*${1}*"`
echo $PWD
ls -lhp
}

# find file with string in name
ff () {
find . -iname "*${1}*"
}

# copy files with extension to targetdir
cpe () {
find . -maxdepth 1 -iname "*.$1" -exec cp -i {} $t \;
}

# move files with extension to targetdir
mve () {
find . -maxdepth 1 -iname "*.$1" -exec mv -i {} $t \;
}

# find file containing string
fs () {
grep -ir "${1}" *
}

# LISTINGS
# ========
#standard listing
alias l='ls -lhp'

#listing by modification time
alias lt='ls -clthp'

#list files only (alfabetisch)
alias lf='ls -lh | grep -v ^d'

#list files only (by size) 
alias lfs='ls -Slh | grep -v ^d'

#list files only by time
alias lft='ls -clth | grep -v ^d'

# list only dotfiles
alias lh='find . -maxdepth 1 -type f -name ".*" | more'

# last modified file TODO dit werkt niet in lubuntu ll wordt waarschijnlijk ergens anders gedef
#ll ()
#{
#lastmod=`ls -tr | tail -1`
#echo $lastmod
#}

# files edited less then 1 day TODO werkt niet in  lubuntu
alias ltd='find . ! \( -name ".*" \) -maxdepth 1 -mtime -1'


# BASKET
# ======
# path to basketfile
if [[ $OSTYPE == "darwin"* ]] ; then
	basket="/Users/benno/.basket"
	else
	basket="/home/.basket"
	fi

# bs = show (~/.basket)
alias bs='more $basket'

# bo = open de basket-file in vim
alias bo='vim $basket'

# ba = add file or directory to the basket
ba ()
{
echo "${PWD}/$1" >> $basket
}

# br string = basket - regex: add all files and directories with string 
br ()
{
find $PWD -maxdepth 1 -iname "*$1*" >> $basket	
more $basket
}

# be = empty basket
alias be='> $basket'


# cbt = copy basket to targetdir
cbt ()
{
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
	for i in $(cat $basket) ; do
		NAME=`basename $i`
		cp -iR $i "$t/$NAME"
		# i overwrite?
		# R copy directory
	done
IFS=$SAVEIFS
cd $t
ls -lhp
}

# mbt = move basket to targetdir
mbt ()
{
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
	for i in $(cat $basket) ; do
		NAME=`basename $i`
		mv -i $i "$t/$NAME"
		# i overwrite?
		# R copy directory
	done
IFS=$SAVEIFS
cd $t
ls -lhp
}


# cbh = copy basket here
cbh ()
{
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
	for i in $(cat $basket) ; do
		NAME=`basename $i`
		cp -iR $i "$PWD/$NAME"
		# i overwrite?
		# R copy directory
	done
IFS=$SAVEIFS
ls -lhp
}


# mbh = move basket to here
mbh ()
{
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
	for i in $(cat $basket) ; do
		NAME=`basename $i`
		mv -i $i "$PWD/$NAME"
		# i overwrite?
	done
IFS=$SAVEIFS
ls -lhp
}


