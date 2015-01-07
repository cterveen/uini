package uIni;

sub new {
  my $class = shift;
  my $self = {};
     $self->{newline} = "\r\n";
     $self->{isChanged} = 0;

  bless($self, $class);
}

# return a value
sub getValue {
  my $self = shift;
  my $heading = shift;
  my $key = shift;
  my $index = shift;

  if (defined($index)) {
    $key .= "[$index]";
  }

  foreach my $setting(@{$self->{ini}->{$heading}}) {
    my ($curkey, @value) = split(/=/, $setting);
    if ($curkey eq $key) {
      return join("=", @value);
    }
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
    }
    elsif ($_ eq "") {
      # empty line, do nothing
    }
    else {
      # a key value pair or comment.
      # I have to use an array to save the complete line rather then a hash
      # so repeating keys are supported
      push(@{$self->{ini}->{$heading}}, $_);
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
    foreach my $setting(@{$self->{ini}->{$heading}}) {
      if (defined($setting)) {
        print SAVEINI "$setting$self->{newline}";
      }
    }

    $i++;
    unless($i == scalar(@{$self->{horder}})) {
      print SAVEINI $self->{newline};
    }
  }
  close(SAVEINI);
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

  if (defined($index)) {
    $key .= "[$index]";
  }
  
  if (!defined($self->{ini}->{$heading})) {
    push(@{$self->{horder}}, $heading);
  }
    
  my $i = 0;
  my $found = 0;
  foreach my $setting(@{$self->{ini}->{$heading}}) {
    my ($curkey, @value) = split(/=/, $setting);
    if ($curkey eq $key) {
      $self->{ini}->{$heading}->[$i] = $curkey . "=" . $value;
      $found = 1;
      last;
    }
    $i++;
  }

  if ($found == 0) {
    $self->{ini}->{$heading}->[$i] = $key . "=" . $value;
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

=head1 BUGS
  There seems to be an issue with newlines from FAT32? :S

=head1 AUTHOR

  This module was written by Christiaan ter Veen.
  Contact via www.rork.nl

=cut
