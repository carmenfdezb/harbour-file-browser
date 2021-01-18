<!--
SPDX-FileCopyrightText: 2020-2021 Mirian Margiani

SPDX-License-Identifier: GFDL-1.3-or-later
-->

# Contributing

*Bug reports, and pull requests for translations, bug fixes, or new features are always welcome!*


## Translations

It would be wonderful if the app could be translated in as many languages as possible!

Translations are managed using [Weblate](https://hosted.weblate.org/projects/harbour-file-browser/).

If you just found a typo, you can also [open an issue](https://github.com/ichthyosaurus/harbour-file-browser/issues/new).
Include the following details:

1. the language you were using
2. where you found the error
3. the wrong text
4. the correct translation

You can easily update translations and even add new languages online. You can
also create a new pull request with contributions or you can send us an email
with an updated translation catalog attached.

To manually add or update a translation, please follow these steps:

1. *If it did not exists before*, create a new catalog for your language by copying the
   base file [translations/harbour-file-browser.ts](translations/harbour-file-browser.ts).
   Then add the new translation to [harbour-file-browser.pro](harbour-file-browser.pro). You will
   find instructions at the top of the file.
2. Add yourself to the list of contributors in [qml/pages/ContributorsPage.qml](qml/pages/ContributorsPage.qml).
   You will find instructions in the file.
3. Translate the app's name in [harbour-file-browser.desktop](harbour-file-browser.desktop).
   You will find instructions in the file.
4. Translate everything else...

Please do not forget to translate the date formats to your local format. You can
find details on the available fields [in the Qt documentation](https://doc.qt.io/qt-5/qml-qtqml-date.html#details).
Also, if there is a (short) native term for "file manager" or "file browser"
in your language, please translate the app's name.


### Other contributions

Please do not forget to add yourself to the list of contributors in
[qml/pages/ContributorsPage.qml](qml/pages/ContributorsPage.qml)!
