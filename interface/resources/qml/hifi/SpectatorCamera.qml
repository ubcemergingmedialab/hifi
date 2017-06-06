//
//  SpectatorCamera.qml
//  qml/hifi
//
//  Spectator Camera
//
//  Created by Zach Fox on 2017-06-05
//  Copyright 2016 High Fidelity, Inc.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html
//

import QtQuick 2.5
import QtQuick.Controls 1.4
import "../styles-uit"
import "../controls-uit" as HifiControlsUit
import "../controls" as HifiControls

// references HMD, XXX from root context

Rectangle {
    id: spectatorCamera;
    // Size
    // Style
    color: "#FFFFFF";
    // Properties

    HifiConstants { id: hifi; }
    
    //
    // TITLE BAR START
    //
    Item {
        id: titleBarContainer;
        // Size
        width: spectatorCamera.width;
        height: 50;
        // Anchors
        anchors.left: parent.left;
        anchors.top: parent.top;

        // "Spectator" text
        RalewayRegular {
            id: titleBarText;
            text: "Spectator";
            // Text size
            size: hifi.fontSizes.overlayTitle;
            // Anchors
            anchors.fill: parent;
            anchors.leftMargin: 16;
            // Style
            color: hifi.colors.darkGray;
            // Alignment
            horizontalAlignment: Text.AlignHLeft;
            verticalAlignment: Text.AlignVCenter;
        }

        // Separator
        Rectangle {
            // Size
            width: parent.width;
            height: 1;
            // Anchors
            anchors.left: parent.left;
            anchors.bottom: parent.bottom;
            // Style
            color: hifi.colors.faintGray;
        }
    }
    //
    // TITLE BAR END
    //
    
    //
    // SPECTATOR APP DESCRIPTION START
    //
    Item {
        id: spectatorDescriptionContainer;
        // Size
        width: spectatorCamera.width;
        height: childrenRect.height;
        // Anchors
        anchors.left: parent.left;
        anchors.top: titleBarContainer.bottom;

        // (i) Glyph
        HiFiGlyphs {
            id: spectatorDescriptionGlyph;
            text: hifi.glyphs.info;
            // Size
            width: 20;
            height: parent.height;
            size: 48;
            // Anchors
            anchors.left: parent.left;
            anchors.leftMargin: 45;
            anchors.top: parent.top;
            anchors.topMargin: 0;
            // Style
            color: hifi.colors.blueAccent;
            horizontalAlignment: Text.AlignHLeft;
            verticalAlignment: Text.AlignVCenter;
        }

        // "Spectator" app description text
        RalewaySemiBold {
            id: spectatorDescriptionText;
            text: "Spectator lets you switch what your monitor displays while you're using an HMD.";
            // Text size
            size: 14;
            // Size
            width: parent.width - 90 - 60;
            height: paintedHeight;
            // Anchors
            anchors.top: parent.top;
            anchors.topMargin: 10;
            anchors.left: spectatorDescriptionGlyph.right;
            anchors.leftMargin: 30;
            // Style
            color: hifi.colors.darkGray;
            wrapMode: Text.WordWrap;
            // Alignment
            horizontalAlignment: Text.AlignHLeft;
            verticalAlignment: Text.AlignVCenter;
        }

        // "Learn More" text
        RalewayRegular {
            id: spectatorLearnMoreText;
            text: "Learn More About Spectator";
            // Text size
            size: 14;
            // Size
            width: paintedWidth;
            height: paintedHeight;
            // Anchors
            anchors.top: spectatorDescriptionText.bottom;
            anchors.topMargin: 10;
            anchors.left: spectatorDescriptionText.anchors.left;
            anchors.leftMargin: spectatorDescriptionText.anchors.leftMargin;
            // Style
            color: hifi.colors.blueAccent;
            wrapMode: Text.WordWrap;
            font.underline: true;
            // Alignment
            horizontalAlignment: Text.AlignHLeft;
            verticalAlignment: Text.AlignVCenter;
            
            MouseArea {
                anchors.fill: parent;
                hoverEnabled: enabled;
                onClicked: {
                    console.log("FIXME! Add popup pointing to 'Learn More' page");
                }
                onEntered: parent.color = hifi.colors.blueHighlight;
                onExited: parent.color = hifi.colors.blueAccent;
            }
        }

        // Separator
        Rectangle {
            // Size
            width: parent.width;
            height: 1;
            // Anchors
            anchors.left: parent.left;
            anchors.top: spectatorLearnMoreText.bottom;
            anchors.topMargin: spectatorDescriptionText.anchors.topMargin;
            // Style
            color: hifi.colors.faintGray;
        }
    }
    //
    // SPECTATOR APP DESCRIPTION END
    //

    
    //
    // SPECTATOR CONTROLS START
    //
    Item {
        id: spectatorControlsContainer;
        // Size
        height: spectatorCamera.height - spectatorDescriptionContainer.height - titleBarContainer.height;
        // Anchors
        anchors.top: spectatorDescriptionContainer.bottom;
        anchors.topMargin: 20;
        anchors.left: parent.left;
        anchors.leftMargin: 40;
        anchors.right: parent.right;
        anchors.rightMargin: 40;

        // "Camera On" Checkbox
        HifiControlsUit.CheckBox {
            id: cameraToggleCheckBox;
            anchors.left: parent.left;
            anchors.top: parent.top;
            //checked: true; // FIXME
            text: "Camera On";
            boxSize: 30;
            onClicked: {
                sendToScript({method: (checked ? 'enableSpectatorCamera' : 'disableSpectatorCamera')});
            }
        }

        // Preview
        Image {
            id: spectatorCameraPreview;
            height: 300;
            anchors.left: parent.left;
            anchors.top: cameraToggleCheckBox.bottom;
            anchors.topMargin: 20;
            anchors.right: parent.right;
            fillMode: Image.PreserveAspectFit;
            horizontalAlignment: Image.AlignHCenter;
            verticalAlignment: Image.AlignVCenter;
            source: "http://1.bp.blogspot.com/-1GABEq__054/T03B00j_OII/AAAAAAAAAa8/jo55LcvEPHI/s1600/Winning.jpg";
        }
    }    
    //
    // SPECTATOR CONTROLS END
    //

    //
    // FUNCTION DEFINITIONS START
    //
    //
    // Function Name: fromScript()
    //
    // Relevant Variables:
    // None
    // 
    // Arguments:
    // message: The message sent from the SpectatorCamera JavaScript.
    //     Messages are in format "{method, params}", like json-rpc.
    // 
    // Description:
    // Called when a message is received from spectatorCamera.js.
    //
    function fromScript(message) {
        switch (message.method) {
        case 'updateSpectatorCameraCheckbox':
            cameraToggleCheckBox.checked = message.params;
        break;
        default:
            console.log('Unrecognized message from spectatorCamera.js:', JSON.stringify(message));
        }
    }
    signal sendToScript(var message);

    //
    // FUNCTION DEFINITIONS END
    //
}
