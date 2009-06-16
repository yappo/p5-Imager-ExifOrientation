use inc::Module::Install;
name 'Imager-ExifOrientation';
all_from 'lib/Imager/ExifOrientation.pm';

requires 'Imager';
requires 'Image::ExifTool';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
#use_test_base;
auto_include;
auto_set_repository;
WriteAll;
