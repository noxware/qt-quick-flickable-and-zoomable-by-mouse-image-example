import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.15


Window {
    // Just some window configuration
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Qt Quick Flickable And Zoomable By Mouse Image Example")
    color: "black"

    // Just a simple file dialog to choose an image
    FileDialog {
        id: openDialog
        folder: shortcuts.home
        visible: true
    }

    // any container
    Rectangle {
        anchors.fill: parent
        color: "lightgray"
        clip: true


        Image {
            id: cam1

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
            property real dx:0
            property real dy:0
            property real scale:1

            property real ox:width/2
            property real oy:height/2

            transform: [
                Scale{
                    origin.x : cam1.ox
                    origin.y : cam1.oy
                    xScale: cam1.scale
                    yScale: cam1.scale
                },
                Translate{
                    x:cam1.dx
                    y:cam1.dy
                }

            ]
            source: openDialog.fileUrl
        }
    }

    // Mouse zoom
    MouseArea {
        anchors.fill: parent

        property bool dragging :false
        property real startX :0
        property real startY :0

        onPressed: {
            dragging = true
            startX = mouse.x
            startY = mouse.y
        }
        onReleased:  dragging = false

        onPositionChanged: {
            if (dragging)
            {
                cam1.dx += mouse.x - startX
                cam1.dy += mouse.y - startY
                startX = mouse.x
                startY = mouse.y
            }
        }

        onWheel: {
            if (wheel.angleDelta.y > 0)
            {
                var p = mapToItem(cam1,wheel.x,wheel.y)
                var pre_ox = cam1.ox
                var pre_oy = cam1.oy
                var pre_scale = cam1.scale
                cam1.ox = p.x
                cam1.oy = p.y
                cam1.scale +=0.1
                cam1.dx -= (p.x - pre_ox )* (1 - pre_scale) //为了解决qt的bug，我创造了这个我也看不懂的偏移计算式，它工作了
                cam1.dy -= (p.y - pre_oy) * (1 - pre_scale)
            }
            else
            {
                if(cam1.scale <0.105)
                    return
                p = mapToItem(cam1,wheel.x,wheel.y)
                pre_ox = cam1.ox
                pre_oy = cam1.oy
                pre_scale = cam1.scale
                cam1.ox = p.x
                cam1.oy = p.y
                cam1.scale -=0.1
                cam1.dx -= (p.x - pre_ox) * (1 - pre_scale)
                cam1.dy -= (p.y - pre_oy) * (1 - pre_scale)
            }

            wheel.accepted=true
        }
    }
    Button{
        text: "reset zoom"
        onClicked: {
            cam1.ox = cam1.width/2
            cam1.oy = cam1.height/2
            cam1.dx = 0
            cam1.dy = 0
            cam1.scale = 1
        }
    }
}
