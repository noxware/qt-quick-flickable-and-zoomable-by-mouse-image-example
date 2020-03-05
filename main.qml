import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.2


Window {
    // Just some window configuration
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Qt Quick Flickable And Zoomable By Mouse Image Example")
    color: "grey"

    // Just a simple file dialog to choose an image
    FileDialog {
        id: openDialog
        folder: shortcuts.home

        Component.onCompleted: visible = true
    }

    // Important things!
    Flickable {
        anchors.fill: parent

        contentWidth: Math.max(image.width * image.scale, root.width)
        contentHeight: Math.max(image.height * image.scale, root.height)
        clip: true

        Image {
            id: image

            property real zoom: 0.0
            property real zoomStep: 0.1

            asynchronous: true
            cache: false
            smooth: true
            antialiasing: true
            mipmap: true

            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            transformOrigin: Item.Center
            scale: Math.min(root.width / width, root.height / height, 1) + zoom

            source: openDialog.fileUrl
        }
    }

    // Mouse zoom
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton

        onWheel: {
            if (wheel.angleDelta.y > 0)
                image.zoom = Number((image.zoom + image.zoomStep).toFixed(1))
            else
                if (image.zoom > 0) image.zoom = Number((image.zoom - image.zoomStep).toFixed(1))

            wheel.accepted=true
        }
    }
}
