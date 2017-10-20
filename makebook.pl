#!/usr/bin/env perl

use 5.26.0;
use warnings;

#my $image_git = 'https://imgs.xkcd.com/comics/git_2x.png';
#my $image_commit = 'https://imgs.xkcd.com/comics/git_commit_2x.png';
my $image_git = 'git_2x.png';
my $image_commit = 'git_commit_2x.png';

my $outfile = 'xkcdbook.html';
my $infile = 'gitcontent.txt';
open my $in, "<:encoding(utf8)", $infile or die "$infile: $!";
my @book = ();
while (my $line = <$in>) {
    chomp $line;
    my ($chapter, $heading) = split(' ', $line, 2);
    my $tag = ($chapter =~ /\.$/) ? 'h2' : 'h3';
    my $image = ($chapter eq '2.3') ? $image_commit : $image_git;

    my %section = (
        chapter => $chapter,
        heading => $heading,
        tag => $tag,
        image => $image,
    );
    push @book, \%section;
}
close $in;

# Output HTML page
open my $out, ">:encoding(utf8)", $outfile or die "$outfile: $!";
print $out <<HTML;
<!DOCTYPE html>
<html>
<head>
    <title>XKCD Git Primer</title>
    <style>
    \@page {
        size: 6in 9in;
    }
    .pagebreak {
        page-break-after: always;
        clear: both;
    }
    h1 {
        text-align: center;
    }
    body {
        font-family: garamond;
        font-size: x-large;
    }
    li {
        list-style: none;
    }
    img {
        max-width: 400pt;
    }
    </style>
</head>
<body>
    <header class="pagebreak">
        <h1>XKCD Git Primer</h1>
    </header>

    <main>
        <h2>Table of Contents</h2>
        <ul class="pagebreak">
HTML

foreach my $section (@book) {
    print $out <<HTML;
            <!-- <li><a href="#chapter-$section->{chapter}">$section->{chapter} $section->{heading}</a></li> -->
            <li><strong>$section->{chapter}</strong> $section->{heading}</li>
HTML
}

print $out <<HTML;
        </ul>
HTML

# Pages
foreach my $section (@book) {
    print $out <<HTML;
        <div class="pagebreak">
            <a name="chapter-$section->{chapter}"></a>
            <$section->{tag}>$section->{chapter} $section->{heading}</$section->{tag}>
            <img src="$section->{image}">
        </div>
HTML
}
print $out <<HTML;
    </main>

    <footer>
        <small>
            <h4>Copyright</h4>
            <h5>Images</h5>
            <p>Images are &copy; Randall Munroe from XKCD.</p>
            <p>Released under Creative Commons Attribution-NonCommercial 2.5 License:<br>
            http://creativecommons.org/licenses/by-nc/2.5/</p>
            <p>Visit homepage at http://xkcd.com</p>

            <h5>Text</h5>
            <p>Headings are from the Pro Git book,
            written by Scott Chacon and Ben Straub and published by Apress.</p>
            <p>Licensed under the Creative Commons Attribution Non Commercial Share Alike 3.0 license:<br>
            https://creativecommons.org/licenses/by-nc-sa/3.0/</p>
            <p>Online version is available at https://git-scm.com/book/en/v2</p>
            <p>Print versions of the book are available on Amazon.com.</p>

            <h5>Cover image</h5>
            <p>Cover image by Evren (wu chen yeh)</p>
            <p>https://www.flickr.com/photos/wuchenyeh/</p>
            <p>Attribution-ShareAlike 2.0 Generic (CC BY-SA 2.0):
            https://creativecommons.org/licenses/by-sa/2.0/</p>

            <h5>Compilation</h5>
            <p>This book was compiled by Olle Johansson, xkcdgit (AT) ollej.com</p>
        </small>
    </footer>
</body>
</html>
HTML
close $out;
