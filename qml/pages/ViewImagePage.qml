/*
 * This file is part of File Browser.
 *
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

import QtQuick 2.2
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page
    allowedOrientations: Orientation.All
    property alias title: titleOverlay.title
    property alias path: image.source
    property bool editMode: false

    onStatusChanged: {
        if (page.status === PageStatus.Inactive && image.status === Image.Ready) {
            image.fitToScreen()
        }
    }

    MediaTitleOverlay { id: titleOverlay }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: imageView.width
        contentHeight: imageView.height
        clip: true
        onHeightChanged: if (image.status === Image.Ready) image.fitToScreen();

        Item {
            id: imageView
            width: Math.max(image.width*image.scale, flickable.width)
            height: Math.max(image.height*image.scale, flickable.height)

            AnimatedImage {
                id: image
                property real prevScale
                property alias imageRotation: imageRotation

                function fitToScreen() {
                    scale = Math.min(flickable.width / width, flickable.height / height)
                    pinchArea.minScale = scale
                    pinchArea.maxScale = 4*Math.max(flickable.width / width, flickable.height / height)
                    prevScale = scale
                }

                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                cache: false
                asynchronous: true
                smooth: !flickable.moving

                onStatusChanged: {
                    if (status === Image.Ready) {
                        fitToScreen()
                        loadedAnimation.start()
                        statusLoader.sourceComponent = undefined
                    } else if (status === Image.Loading) {
                        statusLoader.sourceComponent = loadingIndicator
                    } else if (status === Image.Error) {
                        statusLoader.sourceComponent = failedLoading
                    }
                }

                NumberAnimation {
                    id: loadedAnimation
                    target: image
                    property: "opacity"
                    duration: 250
                    from: 0; to: 1
                    easing.type: Easing.InOutQuad
                }

                onScaleChanged: {
                    if ((width * scale) > flickable.width) {
                        var xoff = (flickable.width / 2 + flickable.contentX) * scale / prevScale;
                        flickable.contentX = xoff - flickable.width / 2
                    }
                    if ((height * scale) > flickable.height) {
                        var yoff = (flickable.height / 2 + flickable.contentY) * scale / prevScale;
                        flickable.contentY = yoff - flickable.height / 2
                    }
                    prevScale = scale
                    flickable.returnToBounds();
                }

                transform: [
                    Rotation {
                        id: imageRotation
                        origin { x: image.width/2; y: image.height/2 }

                        NumberAnimation on angle {
                            id: angleAnim; from: imageRotation.angle
                            onStopped: imageRotation.angle = to % 360
                        }

                        function rotateRight() {
                            angleAnim.to = angle+90;
                            angleAnim.duration = 150;
                            angleAnim.start();
                        }
                        function reset(to) {
                            if (Math.abs(angle-to) > 180) angleAnim.to = to+360;
                            else angleAnim.to = to;
                            angleAnim.duration = 150*(Math.abs((angle-angleAnim.to)/90));
                            angleAnim.start();
                        }
                    }
                ]
            }
        }

        PinchArea {
            id: pinchArea

            property real minScale: 1.0
            property real maxScale: 3.0

            MouseArea {
                anchors.fill: parent
                Timer { id: timer; interval: 200; onTriggered: parent.singleClick() }
                onClicked: timer.start()
                property bool pinchRequested: false
                onDoubleClicked: {
                    pinchRequested = true
                    if (image.status !== Image.Ready) return;

                    var newScale = pinchArea.minScale;
                    if (image.scale === pinchArea.minScale) {
                        if (image.width > image.height) { // wide -> fit height
                            newScale = (flickable.height-5)/image.height;
                        } else { // high -> fit width
                            newScale = (flickable.width-5)/image.width;
                        }
                    } else {
                        newScale = pinchArea.minScale;
                    }
                    pinchArea.zoomToScale(newScale, true);
                }
                function singleClick() {
                    if (pinchRequested) {
                        pinchRequested = false;
                        return;
                    } else if (titleOverlay.visible) {
                        titleOverlay.hide();
                    } else {
                        titleOverlay.show();
                    }
                }
            }

            anchors.fill: parent
            enabled: image.status === Image.Ready
            pinch.target: image
            pinch.minimumScale: minScale * 0.5 // This is to create "bounce back effect"
            pinch.maximumScale: maxScale * 1.5 // when over zoomed

            onPinchFinished: {
                flickable.returnToBounds()
                if (image.scale < pinchArea.minScale) {
                    zoomToScale(pinchArea.minScale, false)
                }
                else if (image.scale > pinchArea.maxScale) {
                    zoomToScale(pinchArea.maxScale, false)
                }
            }

            function zoomToScale(newScale, quick) {
                if (quick === true) bounceBackAnimation.quick = true
                else bounceBackAnimation.quick = false
                bounceBackAnimation.to = newScale;
                bounceBackAnimation.start()
            }

            NumberAnimation {
                id: bounceBackAnimation
                target: image
                property bool quick: false
                duration: quick ? 150 : 250
                property: "scale"
                from: image.scale
            }
        }
    }

    Loader {
        id: statusLoader
        anchors.centerIn: parent
        sourceComponent: undefined
    }

    Component {
        id: loadingIndicator

        Item {
            height: childrenRect.height
            width: page.width

            BusyIndicator {
                id: imageLoadingIndicator
                anchors.horizontalCenter: parent.horizontalCenter
                running: true
            }

            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: imageLoadingIndicator.bottom; topMargin: Theme.paddingLarge
                }
                font.pixelSize: Theme.fontSizeSmall;
                color: Theme.highlightColor;
                text: qsTr("Loading image... %1").arg(Math.round(image.progress*100) + "%")
            }
        }
    }

    Component {
        id: failedLoading
        Text {
            width: page.width - 2*Theme.horizontalPageMargin
            wrapMode: Text.Wrap
            textFormat: Text.PlainText
            font.pixelSize: Theme.fontSizeMedium
            text: qsTr("Error loading image")
            color: Theme.highlightColor
        }
    }
}
