import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 200
    color:"gray"

    ListModel {
        id: comboModel

        ListElement {
            name: "Combo1"
            expanded: false
            additionalExpanded: false
            checked:false
            hasAdditional: true
            parameters:[
                ListElement { name: "Parameter A";min:0;max:0 },
                ListElement { name: "Parameter B" ;min:0;max:0}
            ]
        }

        ListElement {
            name: "Combo2"
            expanded: false
            additionalExpanded: false
            checked:false
            hasAdditional: true
            parameters:[
                ListElement { name: "Parameter A" },
                ListElement { name: "Parameter B" }
            ]
        }

        ListElement {
            name: "Combo3"
            expanded: false
            additionalExpanded: false
            checked:false
            hasAdditional: false
            parameters: [
                ListElement { name: "nothing" }
            ]
        }
    }
    ListModel {
        id: comboModel2

        ListElement {
            name: "Combo12"
            expanded: false
            checked:false
            additionalExpanded: false
            hasAdditional: false
            parameters:[
                ListElement { name: "nothing" }
            ]
        }

        ListElement {
            name: "Combo22"
            expanded: false
            checked:false
            additionalExpanded: false
            hasAdditional: false
            parameters:[
                ListElement { name: "nothing" }
            ]
        }

        ListElement {
            name: "Combo3"
            expanded: false
            checked:false
            additionalExpanded: false
            hasAdditional: false
            parameters: [
                ListElement { name: "nothing" }
            ]
        }
    }

    ListModel {
        id: comboModel3

        ListElement {
            name: "Combo13"
            expanded: false
            additionalExpanded: false
            hasAdditional: false
            checked:false
            parameters:[
                ListElement { name: "Parameter A3" },
                ListElement { name: "Parameter B3" }
            ]
        }

        ListElement {
            name: "Combo23"
            expanded: false
            additionalExpanded: false
            hasAdditional: false
            checked:false
            parameters:[
                ListElement { name: "Parameter A33" },
                ListElement { name: "Parameter B33" }
            ]
        }

        ListElement {
            name: "Combo3"
            expanded: false
            additionalExpanded: false
            hasAdditional: false
            checked:false
            parameters: [
                ListElement { name: "nothing" }
            ]
        }
    }
    property var filterData: [
        { title: "Tag 1", model: comboModel },
        { title: "Tag 2", model: comboModel2 },
        { title: "Tag 3", model: comboModel3 }
    ]


    Row {
        anchors.fill: parent
        spacing: 20

        // LEFT: DIAL PANEL
        Column {
            id: dialPanel
            width: 140
            spacing: 10
            anchors.margins: 10

            Rectangle {
                width: 100
                height: 100
                radius: 50
                color: "#444"
                anchors.horizontalCenter: parent.horizontalCenter

                Dial {
                    id: dial
                    from: 0
                    to: 100
                    value: 50
                    anchors.fill: parent
                    anchors.margins: 10
                }
            }

            ComboBox {
                id: dialModeSelector
                model: ["Set Min", "Set Max"]
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: `Dial Value: ${Math.round(dial.value)}`
                color: "white"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                text: "Apply"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    // Assume selectedSection is the currently expanded or active section
                    if (dialModeSelector.currentText === "Set Min") {
                        selectedSection.minSpin.value = Math.min(dial.value, selectedSection.maxSpin.value - 1)
                    } else {
                        selectedSection.maxSpin.value = Math.max(dial.value, selectedSection.minSpin.value + 1)
                    }
                }
            }
        }
    }
    // This property holds reference to currently selected section
    property var selectedSection: null
    Rectangle{
        // width:400
        width:columnExpandable.implicitWidth
        height:parent.height
        color:"transparent"
        anchors.right:parent.right
        border.width:1
        Column{
            id:columnExpandable
            // anchors.fill:parent
            spacing:10

            Repeater {
                model: filterData

                delegate: Component {
                    MyExpandableSection {
                        id: section
                        title: modelData.title
                        comboModel: modelData.model
                        // MouseArea {
                        //     z:-100
                        //     anchors.fill: parent
                        //     onClicked: {
                        //         selectedSection = parent
                        //     }
                        // }
                    }
                }

            }

        }
    }
}

// ------------------------notifications-------------------------
// import QtQuick 2.15
// import QtQuick.Window 2.15
// import QtQuick.Controls 2.15
// import QtQuick 2.15
// import QtQuick.Window 2.15
// import QtQuick.Controls 2.15

// import QtQuick 2.15
// import QtQuick.Window 2.15
// import QtQuick.Controls 2.15
// import QtQuick.Layouts 1.15

// ApplicationWindow {
//     id: window
//     visible: true
//     width: 360
//     height: 640
//     title: "Notification Stack"
//     color: "#222"



//     ListModel {
//         id: noticeModel
//         ListElement { title: "System notice"; time: "10:00 AM" }
//         ListElement { title: "New notice"; time: "10:05 AM" }
//         ListElement { title: "Battery notice"; time: "10:15 AM" }
//         ListElement { title: "Download notice"; time: "10:20 AM" }
//         ListElement { title: "Meeting notice"; time: "10:30 AM" }
//         ListElement { title: "Weather notice"; time: "10:35 AM" }
//         ListElement { title: "Flight notice"; time: "10:45 AM" }
//         ListElement { title: "New update"; time: "11:00 AM" }
//     }


//     property var notifications: {
//         "notice":noticeModel,
//         "warnings":warningModel,
//         "alert":aleartModel
//     }


//     ListModel {
//         id: warningModel

//         ListElement{ title: "System warnings"; time: "10:00 AM" }
//         ListElement{ title: "New warnings"; time: "10:05 AM" }
//         ListElement{ title: "Battery warnings"; time: "10:15 AM" }
//         ListElement{ title: "Download warnings"; time: "10:20 AM" }
//         ListElement{ title: "Meeting warnings"; time: "10:30 AM" }
//         ListElement{ title: "Weather warnings"; time: "10:35 AM" }
//         ListElement{ title: "Flight warnings"; time: "10:45 AM" }
//         ListElement{ title: "New warnings"; time: "11:00 AM" }
//         ListElement{ title: "Missed warnings"; time: "11:10 AM" }

//     }

//     ListModel {
//         id: aleartModel

//         ListElement{ title: "System Update"; time: "10:00 AM" }
//         ListElement{ title: "New Message"; time: "10:05 AM" }
//         ListElement{ title: "Battery Low"; time: "10:15 AM" }
//         ListElement{ title: "Download Complete"; time: "10:20 AM" }
//         ListElement{ title: "Meeting Reminder"; time: "10:30 AM" }
//         ListElement{ title: "Weather Alert"; time: "10:35 AM" }
//         ListElement{ title: "Flight Delay"; time: "10:45 AM" }
//         ListElement{ title: "New Offer"; time: "11:00 AM" }
//         ListElement{ title: "Missed Call"; time: "11:10 AM" }

//     }
//     property bool notificationExpanded :false
//     Connections{
//         target:notice
//         onExpandedChanged:{
//             notificationExpanded=!notificationExpanded
//         }
//     }

// Column{
//  spacing:20
//  Row {
//      id: topButtons
//      spacing: 10
//      // anchors.top: parent.top
//      // anchors.right: parent.right
//      // anchors.topMargin: -40
//      // anchors.rightMargin: 0

//      Rectangle {
//          width: 70
//          height: 28
//          radius: 14
//          color: "#555"
//          border.color: "#888"
//          Text {
//              anchors.centerIn: parent
//              text: notificationExpanded ? "Collapse" : "View All"
//              font.pixelSize: 12
//              color: "white"
//          }
//          MouseArea {
//              anchors.fill: parent
//              onClicked: {
//                  notificationExpanded = !notificationExpanded
//              }
//          }
//      }


//      Rectangle {
//          width: 70
//          height: 28
//          radius: 14
//          color: "#c00"
//          border.color: "#888"
//          Text {
//              anchors.centerIn: parent
//              text: "Clear All"
//              font.pixelSize: 12
//              color: "white"
//          }
//          MouseArea {
//              anchors.fill: parent
//              onClicked: {
//                  notifications.notice.clear()
//                  notifications.warnings.clear()
//              }
//          }
//      }
//  }

//  MyStackArea {
//      id: notice
//      height: 320
//      width: 300
//      notificationModel:notifications.notice
//      notificationExpandedX:notificationExpanded
//  }

//  MyStackArea {
//      // id: stackArea
//         id:warnings
//      height: 320
//      width: 300
//      notificationModel:notifications.warnings

//      notificationExpandedX:notificationExpanded
//  }
// }
// }
