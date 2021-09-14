Grad students: tired of manually fixing up your professors' Word documents so you can incorporate them into your LaTeX papers?  Professors: tired of reading students' LaTeX drafts and wish you could just edit them in Word?

If you use Emacs, the below customizations can help. 

[buy propecia generic](http://familycareintl.org/blog/2014/12/25/buy-propecia-generic/ "buy propecia generic")

 Place them in your .emacs file somewhere, and run:

-   `M-x texify-region` to convert content pasted from Word into TeX-friendly content (It does the right thing for characters outside TeX's input set such as curly quotes, em- and en-dashes, and so on)

-   `M-x wordify-region` to go the other way

-   `M-x empty-region` to convert TeX paragraphs in the region (newline after each line, blank lines separate paragraphs) into Word-friendly text (one paragraph == one newline)

-   `M-x copy-region-as-empty` to do the above nondestructively, i.e. leaving your original TeX markup intact but copying a Word-friendly version to the kill ring (which doubles as the clipboard on non-broken PC & Mac implementations of Emacs)

-   `M-x word-outline-to-latex`  to convert a **numbered headings** outline (e.g. pasted from Word's outline mode view) into \section and \subsection hierarchy for LaTeX use

Have fun.
