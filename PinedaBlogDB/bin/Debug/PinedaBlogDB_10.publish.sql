﻿/*
Deployment script for BlogDB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "BlogDB"
:setvar DefaultFilePrefix "BlogDB"
:setvar DefaultDataPath "C:\Users\ammpi\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"
:setvar DefaultLogPath "C:\Users\ammpi\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Rename refactoring operation with key b03572f7-bb1a-435c-a131-81721baac807 is skipped, element [dbo].[Posts].[Date Created] (SqlSimpleColumn) will not be renamed to DateCreated';


GO
PRINT N'Creating Table [dbo].[Posts]...';


GO
CREATE TABLE [dbo].[Posts] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [UserId]      INT            NOT NULL,
    [Title]       NVARCHAR (150) NOT NULL,
    [Body]        TEXT           NOT NULL,
    [DateCreated] DATETIME2 (7)  NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[Users]...';


GO
CREATE TABLE [dbo].[Users] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [UserName]  NVARCHAR (16) NOT NULL,
    [FirstName] NVARCHAR (50) NOT NULL,
    [LastName]  NVARCHAR (50) NOT NULL,
    [Password]  NVARCHAR (16) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Foreign Key [dbo].[FK_Posts_Users]...';


GO
ALTER TABLE [dbo].[Posts] WITH NOCHECK
    ADD CONSTRAINT [FK_Posts_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]);


GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b03572f7-bb1a-435c-a131-81721baac807')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b03572f7-bb1a-435c-a131-81721baac807')

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Posts] WITH CHECK CHECK CONSTRAINT [FK_Posts_Users];


GO
PRINT N'Update complete.';


GO
