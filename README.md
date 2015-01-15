NAME

uIni.pm - interface for UT styled ini's

SYNOPSIS

use uIni;
my $ini = uIni->new;
   $ini->load("UnrealTournament.ini");
   $ini->setValue("Botpack.Assault", "MinPlayers", "8");
   $ini->save("UnrealTournament.ini");

DESCRIPTION

uIni is a module that provides an easy interface for Unreal Tournament
style ini's. The ini contains a number of headings, followed by a number
of settings. The headings have the format [heading], one heading can have
multiple identical keys.

The module is written for use with Unreal Tournament ini's but could be used
for other ini's with the same synopsis.

METHODS

new
  Declares the function

load(FILENAME)
  Loads an ini file

save(?FILENAME?)
  Saves the ini file to the given filename or the filename stored from the
  load function if no filename is given.

setValue(HEADING, KEY, ?INDEX?, VALUE)
  Sets the value of KEY under HEADING to VALUE. If INDEX is used that possition
  in the array will be changed. If the key is not found it is added at the end
  of the heading. If a KEY with INDEX is not found assumes it's an unindexed
  array, use KEY[INDEX] to add an indexed array element
  
setPosition(HEADING, KEY, ?INDEX?, TO)
  Moves the order of the keys, sets key to the position defined by TO. TO can
  be first, last, +#, -#, #, after KEY2 or before KEY2;

getValue(HEADING, KEY, ?INDEX?)
  Returns the value of KEY under HEADING. Both KEY and HEADING are case
  sensitive
  
getArrayLength(HEADING, KEY)
  Returns the length of an array, can both be indexed and non-indexed arrays  

isChanged()
  Returns 1 if the ini has been changed since it's loaded or 0 if it wasn't.

BUGS
  There seems to be an issue with newlines from FAT32? :S

AUTHOR

  This module was written by Christiaan ter Veen.
  Contact via www.rork.nl
