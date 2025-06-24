
// ---------------------------------------------------------------------------------------
#include "treemodel.h"
#include <QDomDocument>
#include <QFile>
#include <QDebug>

TreeModel::TreeModel(QObject *parent)
    : QAbstractItemModel(parent) {
    rootItem = new TreeItem("Root");
}

TreeModel::~TreeModel() {
    delete rootItem;
}

void TreeModel::addTreeData(const QVariantMap &treeNode) {
    if (!rootItem)
        return;

    beginResetModel();  // Reset for batch change (or use beginInsertRows for finer control)

    addRecursive(treeNode, rootItem);

    endResetModel();
}
void TreeModel::clearAll() {
    beginResetModel();

    // Assuming rootItem is valid and has children
    if (rootItem) {
        rootItem->clearChildren(); // You must implement this in TreeItem
    }

    endResetModel();
}
// void TreeModel::resetWithClassification(const QString &classification) {
//     beginResetModel();

//     rootItem->clearChildren();  // Use your efficient child-clearing method
//     qDebug()<<m_allItems;
//     // Filter and add only matching items (you’ll pass full centralData.Items from QML)
//     for (const QVariant &itemVar : m_allItems) {
//         QVariantMap itemMap = itemVar.toMap();
//         if (itemMap.value("classification").toString() == classification) {
//             addRecursive(itemMap, rootItem);
//         }
//     }


//     endResetModel();
// }
// void TreeModel::setAllItems(const QVariantList &items) {
//     m_allItems = items;
// }
// void TreeModel::resetWithClassification(const QString &classification, const QString &treeCategory) {
//     beginResetModel();
//     rootItem->clearChildren();

//     for (const QVariantMap &item : std::as_const(allItems)) {
//         if (item.value("classification").toString() == classification &&
//             item.value("treeCategory").toString() == treeCategory) {
//             addRecursive(item, rootItem);
//         }
//     }

//     endResetModel();
// }

void TreeModel::resetWithFilter(const QString &classification,
                                const QString &treeCategory,
                                const QString &category)
{
    beginResetModel();
    rootItem->clearChildren();

    for (const QVariantMap &item : std::as_const(allItems)) {
        if (item.value("classification").toString() == classification &&
            item.value("treeCategory").toString() == treeCategory &&
            item.value("category").toString() == category) {
            addRecursive(item, rootItem);
        }
    }

    endResetModel();
}


void TreeModel::setAllItems(const QVariantList &items) {
    allItems.clear();
    for (const QVariant &item : items) {
        allItems.append(item.toMap());
    }
}

// Recursive helper function
// void TreeModel::addRecursive(const QVariantMap &node, TreeItem *parentItem) {
//     QString name = node.value("name").toString();
//     TreeItem *newItem = new TreeItem(name, parentItem);
//     parentItem->appendChild(newItem);

//     if (node.contains("children")) {
//         QVariantList children = node.value("children").toList();
//         for (const QVariant &child : children) {
//             addRecursive(child.toMap(), newItem);
//         }
//     }
// }

// QVariant TreeModel::data(const QModelIndex &index, int role) const {
//     if (!index.isValid() || role != Qt::DisplayRole)
//         return QVariant();

//     TreeItem *item = static_cast<TreeItem *>(index.internalPointer());
//     return item->data(index.column());
// }
// QVariant TreeModel::data(const QModelIndex &index, int role) const {
//     if (!index.isValid())
//         return QVariant();

//     TreeItem *item = static_cast<TreeItem *>(index.internalPointer());

//     switch (role) {
//     case NameRole:
//         return item->name();
//     case ColorRole:
//         return item->color();
//     default:
//         return QVariant();
//     }
// }
QVariant TreeModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid())
        return QVariant();

    TreeItem *item = static_cast<TreeItem *>(index.internalPointer());

    switch (role) {
    case NameRole:
        return item->name();
    case ColorRole:
        return item->color();
    case ParametersRole:
        return item->parameters();  // ← new
    default:
        return QVariant();
    }
}
QHash<int, QByteArray> TreeModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[ColorRole] = "color";
    roles[ParametersRole] = "parameters";  // ← new
    return roles;
}


// QHash<int, QByteArray> TreeModel::roleNames() const {
//     QHash<int, QByteArray> roles;
//     roles[NameRole] = "name";
//     roles[ColorRole] = "color";
//     return roles;
// }
// void TreeModel::addRecursive(const QVariantMap &node, TreeItem *parentItem) {
//     QString name = node.value("name").toString();
//     QString color = node.value("color").toString(); // default color
//     TreeItem *newItem = new TreeItem(name,  parentItem,color);
//     parentItem->appendChild(newItem);

//     if (node.contains("children")) {
//         const QVariantList children = node.value("children").toList();
//         for (const QVariant &child : children) {
//             addRecursive(child.toMap(), newItem);
//         }
//     }
// }
void TreeModel::addRecursive(const QVariantMap &node, TreeItem *parentItem) {
    QString name = node.value("name").toString();
    QString color = node.value("color").toString();
    TreeItem *newItem = new TreeItem(name, parentItem, color);

    if (node.contains("parameters")) {
        newItem->setParameters(node.value("parameters").toList());  // ← set parameters
    }

    parentItem->appendChild(newItem);

    if (node.contains("children")) {
        const QVariantList children = node.value("children").toList();
        for (const QVariant &child : children) {
            addRecursive(child.toMap(), newItem);
        }
    }
}


QModelIndex TreeModel::index(int row, int column, const QModelIndex &parent) const {
    if (!hasIndex(row, column, parent))
        return QModelIndex();

    TreeItem *parentItem = parent.isValid() ? static_cast<TreeItem *>(parent.internalPointer()) : rootItem;
    TreeItem *childItem = parentItem->child(row);
    return childItem ? createIndex(row, column, childItem) : QModelIndex();
}

QModelIndex TreeModel::parent(const QModelIndex &index) const {
    if (!index.isValid())
        return QModelIndex();

    TreeItem *childItem = static_cast<TreeItem *>(index.internalPointer());
    TreeItem *parentItem = childItem->parentItem();

    if (parentItem == rootItem || !parentItem)
        return QModelIndex();

    return createIndex(parentItem->row(), 0, parentItem);
}

int TreeModel::rowCount(const QModelIndex &parent) const {
    TreeItem *parentItem = parent.isValid() ? static_cast<TreeItem *>(parent.internalPointer()) : rootItem;
    return parentItem->childCount();
}

int TreeModel::columnCount(const QModelIndex &parent) const {
    return 1;
}
