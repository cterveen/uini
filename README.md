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
  Sets the value of KEY under HEADING to VALUE. If INDEX is used an index
  will be added to KEY in the form KEY[INDEX], it's also possible to provide
  the index in KEY itself in this form. If the key is not found it is added
  at the end of the heading.

  WARNING:
  Changing the value of identical keys is not supported yet, in this case the
  first occurance will be changed. Both KEY and HEADING are case sensitive.

getValue(HEADING, KEY, ?INDEX?)
  Returns the value of KEY under HEADING. Both KEY and HEADING are case
  sensitive

  WARNING:
  Returning the value of identical keys is not supported yet, in this case the
  first occurance will be returned.

isChanged()
  Returns 1 if the ini has been changed since it's loaded or 0 if it wasn't.

BUGS
  There seems to be an issue with newlines from FAT32? :S

AUTHOR

  This module was written by Christiaan ter Veen.
  Contact via www.rork.nl


