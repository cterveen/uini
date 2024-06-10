## Project title

uIni

## Description

uIni is a Perl module that handles Unreal Tournament ini files. It was written to read and modify with Unreal Tournament (UT99) by Perl scripts but was also used to handle ini style settings by other scripts.

The module can be considered beta and has had it's fair used on Linux systems. There seems to be a bug with FAT32 formatted drives that should be looked into. POD documentation is available. The module is not on CPAN.

Further development is intended.

## Installation

Save uIni.pm in any Perl module directory.

## Use

    use uIni;
    my $ini = uIni->new;
       $ini->load("UnrealTournament.ini");
       $ini->setValue("Botpack.Assault", "MinPlayers", "8");
       $ini->save("UnrealTournament.ini");

See POD documentation for details.

## Credits

Written by Christiaan ter Veen <https://www.rork.nl/>

## License

To be decided, but consider it free to use, modify and distribute.
