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

Copyright (c) 2008-2011 Christiaan ter Veen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software within the restrictions of the Unreal(r) Engine End User License Agreement but no restrictions otherwise, including without limitation the rights to use, copy, modify, merge, publish, distribute, and/or sublicense copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The software must be available in source code form (including, but not limited to, any compiler, linker, toolchain, and runtime), and must available to all Unreal Engine Licensees free of charge, on all platforms, in any Product as to comply with the Unreal(r) Engine End User License Agreement.

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
