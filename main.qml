import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Effects
import MyApp.Models 1.0
import QtQuick.Shapes

// import QtQuick.Controls.Styles

ApplicationWindow {
    width: 800
    height: 600
    visible: true

    property var centralData: ({
                                   "classification":["Air","Land","Unknown"],
                                   Items:[
                                       {
                                           name: "Item1",color: "red",category:"category2",classification:"Air",treeCategory:"Home",
                                           parameters:[
                                               {"name":"param1","value":"0.2"},
                                               {"name":"param2","value":"0.1"},
                                               {"name":"param3","value":"0.3"},
                                               {"name":"param4","value":"0.4"},
                                           ],
                                           children: [
                                               { name: "Item1.1", color: "green",
                                                   parameters:[
                                                       {"name":"param1","value":"0.2"},
                                                       {"name":"param2","value":"0.1"},
                                                       {"name":"param3","value":"0.3"},
                                                       {"name":"param4","value":"0.4"},
                                                   ],
                                               },
                                               { name: "Item1.2" , color: "pink",
                                                   parameters:[
                                                       {"name":"param1","value":"0.2"},
                                                       {"name":"param2","value":"0.1"},
                                                       {"name":"param3","value":"0.3"},
                                                       {"name":"param4","value":"0.4"},
                                                   ],
                                               }
                                           ]
                                       },
                                       {
                                           name: "Item2",color: "yellow",category:"category3",classification:"Land",treeCategory:"Home",
                                           parameters:[
                                               {"name":"param1","value":"0.2"},
                                               {"name":"param2","value":"0.1"},
                                               {"name":"param3","value":"0.3"},
                                               {"name":"param4","value":"0.4"},
                                           ],
                                           children: [
                                               { name: "Item2.1", color: "gray",
                                                   parameters:[
                                                       {"name":"param1","value":"0.2"},
                                                       {"name":"param2","value":"0.1"},
                                                       {"name":"param3","value":"0.3"},
                                                       {"name":"param4","value":"0.4"},
                                                   ],
                                               }
                                           ]
                                       },
                                       {
                                           name: "Item3",color: "yellow",category:"category3",classification:"Unknown",treeCategory:"Activity",
                                           parameters:[
                                               {"name":"param1","value":"0.2"},
                                               {"name":"param2","value":"0.1"},
                                               {"name":"param3","value":"0.3"},
                                               {"name":"param4","value":"0.4"},
                                           ],
                                           children: [
                                               { name: "Item3.1", color: "gray",
                                                   parameters:[
                                                       {"name":"param1","value":"0.2"},
                                                       {"name":"param2","value":"0.1"},
                                                       {"name":"param3","value":"0.3"},
                                                       {"name":"param4","value":"0.4"},
                                                   ],
                                               }
                                           ]
                                       },
                                       {
                                           name: "Item4",color: "pink",category:"category3",classification:"Unknown",treeCategory:"Activity",
                                           parameters:[
                                               {"name":"param1","value":"0.2"},
                                               {"name":"param2","value":"0.1"},
                                               {"name":"param3","value":"0.3"},
                                               {"name":"param4","value":"0.4"},
                                           ],
                                           children: [
                                               { name: "Item4.1", color: "gray",
                                                   parameters:[
                                                       {"name":"param1","value":"0.2"},
                                                       {"name":"param2","value":"0.1"},
                                                       {"name":"param3","value":"0.3"},
                                                       {"name":"param4","value":"0.4"},
                                                   ],
                                               }
                                           ]
                                       }
                                   ],
                                   treeCategoryData: [
                                       {
                                           name:"Home",
                                           category: ["category1", "category2", "category3", "category4","category5","category6"],
                                           classification:["Unknown","Land","Air"]
                                       },
                                       {

                                           name:"Activity",
                                           category: ["category1", "category1", "category1", "category1"],
                                           classification:["Unknown","Land","Air"]
                                       },

                                   ]
                               }
                               )
    function updateTreeModelForClassification(classification) {
        TreeModel.clearAll()  // You must implement this in your TreeModel C++ class

        for (let i = 0; i < centralData.Items.length; ++i) {
            let item = centralData.Items[i]
            if (item.classification === classification) {
                TreeModel.addtreeCategoryData(item)
            }
        }
    }

   Component.onCompleted: {
        TreeModel.setAllItems(centralData.Items)
        // TreeModel.resetWithClassification("Air")  // default load
    }
    Rectangle{
        color:"gray"
        height:drawer.implicitHeight
        width:drawer.implicitWidth

        Column {
            id: drawer
            // width: parent.width
            spacing: 20


            // Top-level tab bar
            TabBar {
                id: mainTabBar
                spacing: 8
                width:mainStack.implicitWidth


                Repeater {
                    // model:centralData.tabs
                    model: centralData.treeCategoryData
                    TabButton {
                        id: tabBtn
                        text: modelData.name
                        height: 50
                        checkable: true
                        font.bold: checked  // Optional: make text bold if selected

                        background: Item {
                            anchors.fill: parent

                            // Main background rectangle with gradient
                            Rectangle {
                                anchors.fill: parent
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "#109175" }
                                    GradientStop { position: 1.0; color: "#1fcfa1" }
                                }
                                radius: 6
                            }

                            // Bottom border when selected
                            Rectangle {
                                width: parent.width
                                height: 4
                                color: "white" // change as needed
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                visible: tabBtn.checked  // Only show when selected
                                opacity: 0.9

                                Behavior on visible {
                                    PropertyAnimation { duration: 150 }
                                }
                            }
                        }
                    }
                }
            }

            StackLayout {
                id: mainStack
                currentIndex: mainTabBar.currentIndex
                property int maxInnerTabBarWidth: 0
                property string currentCategory: ""


                Repeater {
                    model: centralData.treeCategoryData[mainTabBar.currentIndex].category

                    Column {
                            id: expandContainer
                            property int lastExpandedIndex: -1

                        TabBar {
                            id: innerTabBar
                            height: 50
                            spacing: 4
                            width: mainStack.maxInnerTabBarWidth > 0 ? mainStack.maxInnerTabBarWidth : implicitWidth
                            property var currentcategory: centralData.treeCategoryData[mainTabBar.currentIndex].category || []




                            Component.onCompleted: {
                                // Delay to let implicitWidth calculate
                                Qt.callLater(() => {
                                                 const w = innerTabBar.implicitWidth;
                                                 if (w > mainStack.maxInnerTabBarWidth) {
                                                     mainStack.maxInnerTabBarWidth = w;
                                                 }
                                             });
                            }
                            Repeater {
                                model: innerTabBar.currentcategory
                                TabButton {
                                    text: modelData
                                    height: 40
                                    checked: modelData === innerTabBar.currentcategory
                                    // MouseArea{
                                    //     anchors.fill: parent
                                    //     onClicked: {
                                    //         mainStack.currentCategory = modelData
                                    //     }
                                    // }
                                    onCheckedChanged:{
                                        if(checked){
                                        mainStack.currentCategory = modelData
                                        }
                                        }

                                    background: Rectangle {
                                        anchors.fill: parent
                                        gradient: RadialGradient {
                                            centerX: 0.5; centerY: 0.5; centerRadius: 0.9
                                            GradientStop { position: 0.0; color: "#ffffff" }
                                            GradientStop { position: 1.0; color: checked?"lightblue":"#dddddd" }
                                        }
                                    }
                                }
                            }
                        }

                        Repeater {
                            model: centralData.treeCategoryData[mainTabBar.currentIndex].classification

                            Component.onCompleted: console.log("Rendering classification:", modelData)

                            ExpandableSection {
                                width: parent.width
                                title: modelData
                                tabColor: "lightsteelblue"

                                // Declare local model for this section
                                TreeModel {
                                    id: localModel
                                }

                                // Set the model inside the section
                                treeModel: localModel

                                expanded: index === expandContainer.lastExpandedIndex

                                onExpandedChanged: {
                                    if (expanded) {
                                        const classification = modelData
                                        const treeCategory = centralData.treeCategoryData[mainTabBar.currentIndex].name
                                        const category = mainStack.currentCategory

                                        // Build a filtered model for this section
                                        localModel.setAllItems(centralData.Items)
                                        localModel.resetWithFilter(classification, treeCategory, category)
                                        expandContainer.lastExpandedIndex = index
                                    }
                                }
                            }
                        }

                        /*
                        // Create one ExpandableSection per classification
                        Repeater {
                            // id:expand
                            // property int lastExpandedIndex: -1

                            model: centralData.treeCategoryData[mainTabBar.currentIndex].classification

                            // Item {



                            ExpandableSection {
                                width: parent.width
                                title: modelData  // The classification title
                                // expanded: false
                                 expanded: index === expandContainer.lastExpandedIndex
                                // expanded:
                                tabColor: "lightsteelblue"

                                onExpandedChanged: {
                                    // if (expanded) {
                                    //     // updateTreeModelForClassification(modelData)
                                    //     TreeModel.resetWithClassification(modelData)
                                    //     expandContainer.lastExpandedIndex = index  // collapse all others except this
                                    // }
                                    // if (expanded) {
                                    //                    TreeModel.resetWithClassification(modelData)
                                    //                    expandContainer.lastExpandedIndex = index
                                    //                } else if (expandContainer.lastExpandedIndex === index) {
                                    //                    expandContainer.lastExpandedIndex = -1
                                    //                }
                                    // if (expanded) {
                                    //      const classification = modelData
                                    //      const treeCategory = centralData.treeCategoryData[mainTabBar.currentIndex].name
                                    //      TreeModel.resetWithClassification(classification, treeCategory)
                                    //      expandContainer.lastExpandedIndex = index
                                    //  } else if (expandContainer.lastExpandedIndex === index) {
                                    //      expandContainer.lastExpandedIndex = -1
                                    //  }
                                    if (expanded) {
                                            const classification = modelData
                                            const treeCategory = centralData.treeCategoryData[mainTabBar.currentIndex].name
                                            const category = mainStack.currentCategory
                                        console.log("classification --- "+classification+"treeCategory ---- "+treeCategory+"category --- "+category)
                                            TreeModel.resetWithFilter(classification, treeCategory, category)
                                            expandContainer.lastExpandedIndex = index
                                        } else if (expandContainer.lastExpandedIndex === index) {
                                            expandContainer.lastExpandedIndex = -1
                                        }
                                }

                            }
                            // }
                        }
                        */

                    }

                }
            }
        }
    }
}

