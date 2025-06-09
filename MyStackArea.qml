import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: stackArea
    // anchors.centerIn: parent
    // Notification count bubble
    property var notificationModel:[]
    property bool notificationExpandedX:false
    property bool expanded: notificationExpandedX
    property int visibleCount: expanded ? 3 : 1
    Connections{
        target:notificationExpandedX
        onNotificationExpandedXChanged:{
            expanded=false
        }
    }

    Rectangle {
        id: noOfNotifications
        width: 30
        height: 30
        radius: width / 2
        color: "#f00"
        border.width: 2
        border.color: "white"
        anchors.top: stackArea.top
        anchors.right: stackArea.right
        anchors.topMargin: -15
        anchors.rightMargin: -15
        z: 1
        
        Text {
            anchors.centerIn: parent
            text: noticeModel.count
            color: "white"
            font.pixelSize: 12
            font.bold: true
        }
    }

    
    ColumnLayout {
        id: notificationColumn
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        Repeater {
            // model: noticeModel
            model:notificationModel
            
            Rectangle {
                property int myIndex: index
                
                visible: myIndex < visibleCount  // Only show if within limit
                
                width: parent.width
                height: 80
                color: "#444"
                radius: 10
                border.color: "#888"
                Layout.alignment: Qt.AlignTop
                
                // ✅ Add this ghost stack only inside the first item
                Item {
                    anchors.top: parent.top
                    anchors.topMargin: 80  // Place just below the main rectangle
                    visible: myIndex === 0 && visibleCount === 1
                    width: parent.width
                    height: 30
                    
                    Repeater {
                        model: 3
                        Rectangle {
                            width: parent.width - (index * 10)
                            height: 10
                            // radius: 6
                            color: "#88888844"
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: index * 6
                            z: -index - 1
                            border.color: "#66666666"
                        }
                    }
                }
                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 5
                    
                    Row {
                        spacing: 10
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 0
                        
                        Text {
                            id: noticeTitle
                            // text: noticeModel.get(myIndex).title
                            text:model.title
                            font.pixelSize: 16
                            font.bold: true
                            color: "#fff"
                            Layout.fillWidth: true
                        }
                        
                        Rectangle {
                            id: crossIcon
                            width: 20
                            height: 20
                            radius: width / 2
                            color: "#555"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "x"
                                font.pixelSize: 12
                                color: "white"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                preventStealing: true
                                propagateComposedEvents: false
                                onClicked: {
                                    mouse.accepted = true
                                    console.log("Deleting index", myIndex)
                                    noticeModel.remove(myIndex)
                                }
                            }
                        }
                    }
                    
                    Text {
                        // text: noticeModel.get(myIndex).time
                        text:model.time
                        font.pixelSize: 12
                        color: "#bbb"
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    z: -1
                    onClicked: {
                        expanded = !expanded
                        console.log("Expanded:", expanded)
                    }
                }
            }
        }
        
    }
}
