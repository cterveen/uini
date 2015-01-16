package uIni;

sub new {
  my $class = shift;
  my $self = {};
     $self->{newline} = "\r\n";
     $self->{isChanged} = 0;
     $self->{ini} = {};
     $self->{horder} = [];
     $self->{sorder} = {};

  bless($self, $class);
}

sub getArrayLength {
  my $self = shift;
  my $header = shift;
  my $key = shift;
  
  my $i = 0;
  
  foreach (keys %{$self->{ini}->{$header}}) {
    if (m/$key[{\[]?/) {
      $i++;
    }
  }
  
  return $i;
}

sub getValue {
  my $self = shift;
  my $heading = shift;
  my $key = shift;
  my $index = shift;

  if (defined($index)) {
    if (defined($self->{ini}->{$heading}->{$key . "[$index]"})) {
      $key .= "[$index]";
    }
    elsif ($index != 0) {
      $key .= "{$index}";
    }
  }
  
  if (defined($self->{ini}->{$heading}->{$key})) {
    return $self->{ini}->{$heading}->{$key};
  }
  
  return undef;
}

sub isChanged {
  my $self = shift;
  return $self->{isChanged};
}

# load an ini file
sub load {
  my $self = shift;
  my $filename = shift;

  unless (-e $filename) {
    $! = "File doesn't exist\n";
    return undef;
  }

  $self->{filename} = $filename;
  open(LOADINI, "<", $filename) or die "Can't open LOADINI: $!";
  my $heading = "";
  # (re)set the variables that hold the information
     $self->{horder} = []; # store the order of headings, used to keep the order while saving the file
     $self->{sorder} = {}; # store the order of settings, used to keep the order while saving the file
     $self->{ini} = {}; # store the settings, key = header, value = arrayref of settings

  while(<LOADINI>) {
    # remove the newline
    s/([\r\n]+)//;
    # $self->{newline} = $1;

    # get the head or key/value pairs;
    if ($_ =~ m/^\[([^\]]+)\]$/) {
      # it's a header.
      $heading = $1;
      push(@{$self->{horder}}, $heading);
      $self->{sorder}->{$heading} = [];
    }
    elsif ($_ eq "") {
      # empty line, do nothing
    }
    else {
      # a key value pair or comment.
      
      my ($key, $value) = split(/=/, $_, 2);
      
      # check if the key exists
      if (defined($self->{ini}->{$heading}->{$key})) {
        my $num = $self->getArrayLength($heading, $key);
        $key .= "{$num}";
      }
      
      $self->{ini}->{$heading}->{$key} = $value;
      push(@{$self->{sorder}->{$heading}}, $key);
    }
  }
  close(LOADINI);
  $self->{isChanged} = 0;
  return 1;
}

sub save {
  my $self = shift;
  my $filename = shift;

  $filename = $self->{filename} unless defined $filename;

  open(SAVEINI, ">", $filename) or die "Can't open SAVEINI: $!";

  my $i = 0;
  foreach my $heading(@{$self->{horder}}) {
    print SAVEINI "[$heading]$self->{newline}";
    foreach (@{$self->{sorder}->{$heading}}) {
      my $key = ${\$_};
      my $value = $self->{ini}->{$heading}->{$key};
      $key =~ s/\{\d+\}//;
      
      if (defined($key)) {
        print SAVEINI "$key=$value$self->{newline}";
      }
    }

    $i++;
    unless($i == scalar(@{$self->{horder}})) {
      print SAVEINI $self->{newline};
    }
  }
  close(SAVEINI);
}

sub setPosition {
  my $self = shift;
  my $heading = shift;
  my $key = shift;
  my $index = shift;
  my $to = shift;
  
  # index may be omitted
  unless (defined($to)) {
    $to = $index;
    undef $index;
  }
  
  if (defined($index)) {
    if (defined($self->{ini}->{$heading}->{$key . "[$index]"})) {
      $key .= "[$index]";
    }
    elsif ($index != 0) {
      $key .= "{$index}";
    }
  }
  
  my $curpos;
  my $newpos;
  my $relpos;
  my $relto;
  
  # special before or after
  if ($to =~ m/(after|before)\s(\S+)/i) {
    $relto = $2;
  }
  
  # get current
  for (my $i = 0; $i <= $#{$self->{sorder}->{$heading}}; $i++) {
    if ($self->{sorder}->{$heading}->[$i] eq $key) {
      $curpos = $i;
    }
    if (defined($relto) and ($self->{sorder}->{$heading}->[$i] eq $relto)) {
      $relpos = $i;
    }
  }
  
  # get new position
  
  if ($to =~ m/(after|before)\s(\S+)/i) {
    if (!defined($relpos)) {
      return undef;
    }
    if ($1 eq "after") {
      $newpos = $relpos + 1;
    }
    else {
      $newpos = $relpos;
    }
    if ($newpos > $curpos) {
      $newpos -= 1;
    }
  }
  elsif ($to eq "first") {
    $newpos = 0;
  }
  elsif ($to eq "last") {
    $newpos = $#{$self->{sorder}->{$heading}}
  }
  elsif ($to =~ m/^(\+|-)\d+/) {
    $newpos = $curpos + $to;
  }
  elsif ($to =~ m/^\d+$/) {
    $newpos = $to;
  }
  
  if (defined($newpos)) {
    splice(@{$self->{sorder}->{$heading}}, $curpos, 1);
    splice(@{$self->{sorder}->{$heading}}, $newpos, 0, $key);
    return $newpos;
  }
  else {
    return undef;
  }
}

sub setValue {
  my $self = shift;
  my $heading = shift;
  my $key = shift;
  my $index = shift;
  my $value = shift;

  # index may be omitted
  unless (defined($value)) {
    $value = $index;
    undef $index;
  }
  
  if (!defined($self->{ini}->{$heading})) {
    # new heading, create a new heading and setting
    push(@{$self->{horder}}, $heading);
    
    if (defined($index) and ($index != 0)) {
      $key .= "{$index}";
    }
    
    $self->{sorder}->{$heading} = [$key];
    $self->{ini}->{$heading}->{$key} = $value;
  }
  else {
    if (defined($index)) {
      if (defined($self->{ini}->{$heading}->{$key . "[0]"})) {
	$key .= "[$index]";
      }
      elsif ($index != 0) {
	$key .= "{$index}";
      }
    }  

    if (defined($self->{ini}->{$heading}->{$key})) {
      # key exists, replace
      $self->{ini}->{$heading}->{$key} = $value;
    }
    else {
      #key doesn't exist, create
      push(@{$self->{sorder}->{$heading}}, $key);
      $self->{ini}->{$heading}->{$key} = $value;
    }
  }
  
  $self->{isChanged} = 1;
}

1;

=head1 NAME

uIni.pm - interface for UT styled ini's

=head1 SYNOPSIS

use uIni;
my $ini = uIni->new;
   $ini->load("UnrealTournament.ini");
   $ini->setValue("Botpack.Assault", "MinPlayers", "8");
   $ini->save("UnrealTournament.ini");

=head1 DESCRIPTION

uIni is a module that provides an easy interface for Unreal Tournament
style ini's. The ini contains a number of headings, followed by a number
of settings. The headings have the format [heading], one heading can have
multiple identical keys.

The module is written for use with Unreal Tournament ini's but could be used
for other ini's with the same synopsis.

=head1 METHODS

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

getValue(HEADING, KEY, ?INDEX?)
  Returns the value of KEY under HEADING. Both KEY and HEADING are case
  sensitive. Returns undef if key is not found.
  
getArrayLength(HEADING, KEY)
  Returns the length of an array, can both be indexed and non-indexed arrays

setPosition(HEADING, KEY, ?INDEX?, TO)
  Moves the order of the keys, sets key to the position defined by TO. TO can
  be first, last, +#, -#, #, after KEY2 or before KEY2; Returns the new
  position or undef if the key is not found.

isChanged()
  Returns 1 if the ini has been changed since it's loaded or 0 if it wasn't.

=head1 BUGS
  There seems to be an issue with newlines from FAT32? :S

=head1 AUTHOR

  This module was written by Christiaan ter Veen.
  Contact via www.rork.nl

=cut
