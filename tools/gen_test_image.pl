#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 4;

use Imager;
use Imager::Color;
use Image::ExifTool;
use Image::ExifTool::Exif;

my $path = 't/images/original';


my $image = Imager->new( xsize => 30, ysize => 40 );

$image->box(
    xmin => 0, ymin => 0,
    xmax => 19, ymax => 9,
    filled => 1,
    color => '#ff0000',
);

$image->box(
    xmin => 20, ymin => 0,
    xmax => 29, ymax => 29,
    filled => 1,
    color => '#00ff00',
);

$image->box(
    xmin => 10, ymin => 30,
    xmax => 29, ymax => 39,
    filled => 1,
    color => '#0000ff',
);

$image->box(
    xmin => 0, ymin => 10,
    xmax => 9, ymax => 39,
    filled => 1,
    color => '#ffff00',
);

$image->write( file => "$path/base.bmp" );
$image->write( file => "$path/base.jpg", jpegquality => 100 );


sub set_orient {
    my $orient = shift;

    my $et = Image::ExifTool->new;
    $et->SetNewValue('Orientation', $Image::ExifTool::Exif::orientation{$orient});

    my $to = "$path/${orient}.jpg";
    `cp $path/base.jpg $to`;
    $et->WriteInfo($to);
}
set_orient($_) for (1..8);


sub run_test {
    my($x, $y, $color) = @_;
    ok(
        $image->getpixel( x => $x, y => $y )->equals( other => Imager::Color->new($color), ignore_alpha => 1 ),
        "$x, $y => $color",
    );
}
run_test(0, 0, '#ff0000');
run_test(29, 0, '#00ff00');
run_test(29, 39, '#0000ff');
run_test(0, 39, '#ffff00');


$image->flip(dir=>"v");
$image->write( file => "/tmp/hoge.jpg" );
