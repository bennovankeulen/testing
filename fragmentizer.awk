# In:  textfile with sentences on seperate lines without a dot
# Out: short sentence fragments in random order

# Inspired by David Bowie's verbasizer

# Usage: awk -f fragmentizer.awk textfile.txt

BEGIN {
# aantalzinnen is index voor beide arrays
# titel van savetofile
title = ""

# create empty fragment-arrays
split("", plaatsarray)
split("", tijdarray)
split("", zelfstnmwarray)
split("", werkwoordarray)
split("", beginarray)
split("", middenarray)
split("", eindarray)

# en arrays voor zinanalyse
#split("", startpuntarray)
#split("", woordsoortarray)
#split("", fragarray)
#split("", fragsoortarray)

# cliffseed voor random nr generator
#cliffseed = 0.1
srand()
cliffseed = rand()

# starters woordenlijsten
starterszondercode = " after although and as as because before but ether even if if inasmuch just lest long much no nor not now now once only or order provided provided rather since so so soon such supposing than that then though til unless until when whenever where whereas wherever whether which while who whoever why yet about according account addition against because behalf board by case concerning considering contrary counting depending despite due except excepting excluding face favor for given including instead irrespective less like means minus next notwithstanding of off on other owing per plus preparatory re reference regard regarding regardless respecting save spite than thanks to touching unlike up versus via with worth you anybody anyone anything each either everybody everyone everything neither nobody no nothing one somebody someone something I we she he they it "
startersplaats = " aboard above across after against ahead along alongside amid amidst among amongst apart around aside astride at atop away before behind below beneath beside besides between beyond close down following for forward from front further in between inside into near of on opposite out outside over round through throughout to together top towards under underneath up upon view with within without "
starterstijd = " circa during past pending prior pro since than till until again already always annually before constantly daily earlier early eventually ever finally first formerly fortnightly frequently generally hourly infrequently just last late lately later monthly never next nightly normally now occasionally often previously quarterly rarely recently regularly seldom since sometimes soon still then today tomorrow tonight usually weekly yearly yesterday yet "
startersz = " a all an another any both certain each either enough every few half her his its little lot many most much my neither none one other our several some such ten that the their these this those your two "
geenstartw = " am are aren't be been being can can't could couln't did do does doesn't don't had hadn't has hasn't have haven't isn't may might must mustn't shall shant should shouldn't were will won't would wouldn't "
startersw = " is was "


} #BEGIN


{
# arrays voor zinanalyse
split("", startpuntarray)
split("", woordsoortarray)
split("", fragarray)
split("", fragsoortarray)
# splits zin op / 1ste element van een splitarray is niet [0] maar [1]
#split($0, zinarr, "0") # dit is misschien niet nodig

# process sentence
for (t = 1; t<=NF; t++) {
#print "NF = " NF
# lees huidig woord in en zet alles naar onderkast om
  woordin = tolower($t)
  
	# haal bepaalde leestekens eruit
  gsub(/[?!]/, "", woordin)
  
	# evt. komma weghalen
  woordlengte = length(woordin)
  laatstekar = substr(woordin,woordlengte,1)
  if (laatstekar == ",")
    woordin = substr(woordin,1,woordlengte-1)
  
	# zoek inwoord op in woordenlijsten
  startpuntarray[t] = "0"
  woordsoortarray[t] = ""
  test = ""
  
	# voeg spaties toe aan woordin
  woordin = " " woordin " "
  
	# zoek woord op in woordenlijst starterszondercode
  test = index(starterszondercode, woordin)
  
	#print "test starterszondercode = " test
  if (test != 0) {
	  startpuntarray[t] = "1"
	  woordsoortarray[t] = ""
  }
  
	# zoek woord op in woordenlijst startersplaats
  test = index(startersplaats, woordin)
  
	#print "test startersplaats = " test
  if (test != 0) {
	  startpuntarray[t] = "1"
	  woordsoortarray[t] = "p"
  }
  
	# zoek woord op in woordenlijst starterstijd
  test = index(starterstijd, woordin)
  
	#print "test starterstijd = " test
  if (test != 0) {
	  startpuntarray[t] = "1"
	  woordsoortarray[t] = "t"
  }
  
	# zoek woord op in woordenlijst startersz
  test = index(startersz, woordin)
  #print "test startersz = " test
  if (test != 0) {
	  startpuntarray[t] = "1"
	  woordsoortarray[t] = "z"
  }
  
	# zoek woord op in woordenlijst geenstartw
  test = index(geenstartw, woordin)
  #print "test geenstartw = " test
  if (test != 0) {
	  startpuntarray[t] = "0"
	  woordsoortarray[t] = "w"

  }
  
	# zoek woord op in woordenlijst startersw
  test = index(startersw, woordin)
  #print "test startersw = " test
  if (test != 0) {
	  startpuntarray[t] = "1"
	  woordsoortarray[t] = "w"
  }
  
	# het eerste woord is natuurlijk een starter
	 if (t == 1) {
	  startpuntarray[t] = "1"
	  }
  } # end for

# DEBUG
#print "startpuntarray"
#eindwaarde = length(startpuntarray)
#print "length startpuntarray" length(startpuntarray)
#for (j = 1; j<=eindwaarde; j++) {
#print j " = " startpuntarray[j]
#}

#print "woordsoortarray"
#eindwaarde = length(woordsoortarray)
#for (j = 1; j<=eindwaarde; j++) {
#print j " = " woordsoortarray[j]
#}


# als het vorige en huidige woord een fragment-starter is betrekken we het bij het huidige fragment
vorigevlag = 0
for (t = 1; t<=NF; t++) {
	if (vorigevlag == 2 && startpuntarray[t] == 1) {
		vorigevlag = 2
		startpuntarray[t] = 0
	} else if (vorigevlag == 0 && startpuntarray[t] == 1) {
		vorigevlag = 2
		startpuntarray[t] = 1
		} else {
		vorigevlag = 0
	}
}
# DEBUG
#print "startpuntarray na herverdelen"
#eindwaarde = length(startpuntarray)
#print "length startpuntarray" length(startpuntarray)
#for (j = 1; j<=eindwaarde; j++) {
#print j " = " startpuntarray[j]
#}


# deel ingangszin op in fragmenten 
fragnr = 0
for (t = 1; t<=NF; t++) {
	if (startpuntarray[t] == 1) {
		fragnr += 1
		fragarray[fragnr] = $t
		} else {
		tussenstring = fragarray[fragnr]  #haal fragment uit array en voeg huidig woord toe
		tussenstring = tussenstring " " $t
		fragarray[fragnr] = tussenstring
	}
		if (woordsoortarray[t] != "") {
			fragsoortarray[fragnr] = woordsoortarray[t] # de laatste woordsoortcode blijft
	}
} #for

# DEBUG
#print "fragarray"
#eindwaarde = length(fragarray)
#print "length fragarray" length(fragarray)
#for (j = 1; j<=eindwaarde; j++) {
#print j " = " fragarray[j]
#}
#
#print "fragsoortarray"
#for (j = 1; j<=eindwaarde; j++) {
#print j " = " fragsoortarray[j]
#}

# behandel onbekende fragmenten zonder fragmentsoort / b = beginfrag m = middenfragment e = eindfragment
for (i = 1; i<=fragnr ; i++) {
	if (fragsoortarray[i] == "" && i == 1) {
		fragsoortarray[i] = "b"
	}
	else if (fragsoortarray[i] == "" && i == fragnr) {
		fragsoortarray[fragnr] = "e" }
	else if (fragsoortarray[i] == "" ) {
		fragsoortarray[fragnr] = "m" }
	}

	# plaats de fragmenten in de juiste array 
# plaatsarray tijdarray zelfstnwmarray werkwoordarray beginarray middenarray eindarray
for (i = 1; i<=fragnr ; i++) {
	if (fragsoortarray[i] == "p") {
		plaatsarray[length(plaatsarray)+1] = fragarray[i] }
	if (fragsoortarray[i] == "t") {
		tijdarray[length(tijdarray)+1] = fragarray[i] }
	if (fragsoortarray[i] == "z") {
		zelfstnmwarray[length(zelfstnmwarray)+1] = fragarray[i] }
	if (fragsoortarray[i] == "w") {
		werkwoordarray[length(werkwoordarray)+1] = fragarray[i] }
	if (fragsoortarray[i] == "b") {
		beginarray[length(beginarray)+1] = fragarray[i] }
	if (fragsoortarray[i] == "m") {
		middenarray[length(middenarray)+1] = fragarray[i] }
	if (fragsoortarray[i] == "e") {
		eindarray[length(eindarray)+1] = fragarray[i] }
}

} # proces

# FUNCTIES
# plaatsarray tijdarray zelfstnmwarray werkwoordarray beginarray middenarray eindarray
# random numbers with cliff algoritme
#tussen 1 en n
function random(n)
{
 cliffseed = (100 * log(cliffseed)) % 1
 if (cliffseed < 0)
     cliffseed = - cliffseed
 return 1 + int(cliffseed * n)
}


function rp()
{
lengte = length(plaatsarray)
k = random(lengte)
uitwoord = plaatsarray[k]
return uitwoord }

function rt()
{
lengte = length(tijdarray)
k = random(lengte)
uitwoord = tijdarray[k]
return uitwoord }

function rz()
{
lengte = length(zelfstnmwarray)
k = random(lengte)
tussen = random(10)
uitwoord = zelfstnmwarray[k]
return uitwoord }

function rw()
{
lengte = length(werkwoordarray)
k = random(lengte)
uitwoord = werkwoordarray[k]
return uitwoord }

function rb()
{
lengte = length(beginarray)
k = random(lengte)
uitwoord = beginarray[k]
return uitwoord }

function rm()
{
lengte = length(middenarray)
k = random(lengte)
uitwoord = middenarray[k]
return uitwoord }

function re()
{
lengte = length(eindarray)
k = random(lengte)
uitwoord = eindarray[k]
return uitwoord }

END {

# BEGIN van het EIND
# init
aantalzinnen = 4
aantalfrags = 3
aantalarrays = 7
vorig1 = 0
vorig2 = 0
vorig3 = 0
choice = ""

while (choice != "q") {
#getline choice < "-"
# plaatsarray tijdarray zelfstnmwarray werkwoordarray beginarray middenarray eindarray
# overzicht van de mogelijke fragmenten per deel:
#   1  2  3  < deel
#1  w  w  w
#2  z  z  z
#3  p  m  p
#4  t     t
#5  b     e


for (t = 1; t<=aantalzinnen; t++) {
# 1 begindeel
j = random(5)
if (j == vorig3) {j = random(5)} #begin moet niet gelijk zijn aan vorig eind

if (j == 1) {
print rw()
} else if (j == 2) {
print rz()
} else if (j == 3) {
print rp()
} else if (j == 4) {
print rt()
} else if (j == 5) {
print rb()
}
vorig1 = j
if (vorig1 > 2) {vorig1 = 0} # alleen de eerste 2 moeten niet gelijk zijn
# 2 middendeel
j = random(3)
# check of random niet gelijk is aan de keuze van deel 1
do {
j = random(3)
} while (j == vorig1)

if (j == 1) {
print rw()
} else if (j == 2) {
print rz()
} else if (j == 3) {
print rm()
}
vorig2 = j
if (vorig2 > 2) {vorig2 = 0} # alleen de eerste 2 moeten niet gelijk zijn

# 3 laatste deel
do {
j = random(5)
} while (j == vorig2)
if (j == 1) {
print rw()
} else if (j == 2) {
print rz()
} else if (j == 3) {
print rp()
} else if (j == 4) {
print rt()
} else if (j == 5) {
print re()
}
vorig3 = j
if (vorig3 > 4) {vorig3 = 0} # alleen de eerste 4 moeten niet gelijk zijn

} # for t
print ""
getline choice < "-"


} # while
} # END

