/*
 * This file is part of File Browser.
 *
 * SPDX-FileCopyrightText: 2013-2014 Kari Pihkala
 * SPDX-FileCopyrightText: 2013 Michael Faro-Tusino
 * SPDX-FileCopyrightText: 2016 Joona Petrell
 * SPDX-FileCopyrightText: 2019-2020 Mirian Margiani
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * File Browser is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * File Browser is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    readonly property string licenseFile: "license.html"
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.horizontalPageMargin
        VerticalScrollDecorator { }

        Column {
            id: column
            width: parent.width
            PageHeader { title: qsTr("License") }

            Label {
                anchors {
                    left: parent.left; leftMargin: Theme.horizontalPageMargin
                    right: parent.right; rightMargin: Theme.horizontalPageMargin
                }

                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                textFormat: Text.RichText
                color: Theme.highlightColor
                text: licenseText.text
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }

    QtObject {
        id: licenseText
        property string text: ""
        Component.onCompleted: loadText();

        function loadText() {
            if (text !== "") return text;

            var xhr = new XMLHttpRequest;
            xhr.open("GET", licenseFile);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    var response = xhr.responseText;
                    text = '<style type="text/css">' +
                           'A { color: "%1"; }</style>'.arg(Theme.primaryColor) +
                           response
                }
            };
            xhr.send();
        }
    }
}
