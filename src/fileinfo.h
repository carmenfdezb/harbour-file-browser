#ifndef FILEINFO_H
#define FILEINFO_H

#include <QObject>
#include <QDir>
#include <QVariantList>

/**
 * @brief The FileInfo class provides access to one file.
 */
class FileInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString file READ file() WRITE setFile(QString) NOTIFY fileChanged())
    Q_PROPERTY(bool isDir READ isDir() NOTIFY isDirChanged())
    Q_PROPERTY(QString kind READ kind() NOTIFY kindChanged())
    Q_PROPERTY(QString icon READ icon() NOTIFY iconChanged())
    Q_PROPERTY(QString permissions READ permissions() NOTIFY permissionsChanged())
    Q_PROPERTY(QString owner READ owner() NOTIFY ownerChanged())
    Q_PROPERTY(QString group READ group() NOTIFY groupChanged())
    Q_PROPERTY(QString size READ size() NOTIFY sizeChanged())
    Q_PROPERTY(QString modified READ modified() NOTIFY modifiedChanged())
    Q_PROPERTY(QString created READ created() NOTIFY createdChanged())
    Q_PROPERTY(QString absolutePath READ absolutePath() NOTIFY absolutePathChanged())
    Q_PROPERTY(QString name READ name() NOTIFY nameChanged())
    Q_PROPERTY(QString suffix READ suffix() NOTIFY suffixChanged())
    Q_PROPERTY(QString symLinkTarget READ symLinkTarget() NOTIFY symLinkTargetChanged())
    Q_PROPERTY(QString errorMessage READ errorMessage() NOTIFY errorMessageChanged())

public:
    explicit FileInfo(QObject *parent = 0);
    ~FileInfo();

    // property accessors
    QString file() const { return m_file; }
    void setFile(QString file);

    bool isDir() const;
    QString kind() const;
    QString icon() const;
    QString permissions() const;
    QString owner() const;
    QString group() const;
    QString size() const;
    QString modified() const;
    QString created() const;
    QString absolutePath() const;
    QString name() const;
    QString suffix() const;
    QString symLinkTarget() const;
    QString errorMessage() const;

    // methods accessible from QML
    Q_INVOKABLE void refresh();

signals:
    void fileChanged();
    void isDirChanged();
    void kindChanged();
    void iconChanged();
    void permissionsChanged();
    void ownerChanged();
    void groupChanged();
    void sizeChanged();
    void modifiedChanged();
    void createdChanged();
    void nameChanged();
    void suffixChanged();
    void absolutePathChanged();
    void symLinkTargetChanged();
    void errorMessageChanged();

private:
    void readFile();

    QString m_file;
    QFileInfo m_fileInfo;
    QString m_errorMessage;
};

#endif // FILEINFO_H
