
GO
/****** Object:  Database [ShopBridge]    Script Date: 09-07-2021 14:24:21 ******/
CREATE DATABASE [ShopBridge]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ShopBridge', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\ShopBridge.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ShopBridge_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\ShopBridge_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ShopBridge] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ShopBridge].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ShopBridge] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ShopBridge] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ShopBridge] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ShopBridge] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ShopBridge] SET ARITHABORT OFF 
GO
ALTER DATABASE [ShopBridge] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ShopBridge] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ShopBridge] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ShopBridge] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ShopBridge] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ShopBridge] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ShopBridge] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ShopBridge] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ShopBridge] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ShopBridge] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ShopBridge] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ShopBridge] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ShopBridge] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ShopBridge] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ShopBridge] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ShopBridge] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ShopBridge] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ShopBridge] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ShopBridge] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ShopBridge] SET  MULTI_USER 
GO
ALTER DATABASE [ShopBridge] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ShopBridge] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ShopBridge] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ShopBridge] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [ShopBridge]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddProduct]    Script Date: 09-07-2021 14:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_AddProduct]
@Name varchar(MAX),
@Description varchar(MAX), 
@Price Int,
@Quantity Int ,
@CategoryName varchar(500),
@UnitName varchar(500),
@Weight int ,
@SellStartDate datetime ,
@SellEndDateDate datetime ,
@ImageURL varchar(MAX) ,
@IsDiscontinued bit

AS 
BEGIN 
BEGIN TRY

DECLARE @CategoryID int , @UnitID int

 SET @CategoryID =  (SELECT CategoryId from tbl_Category where CategoryName = @CategoryName)
 SET @UnitID =      (SELECT UnitId from tbl_UnitMeasure where UnitName = @UnitName)
 
BEGIN TRAN
INSERT into tbl_Product values ( @Name , @Description, @Price , @Quantity, @CategoryID ,@UnitID ,@Weight , @SellStartDate , @SellEndDateDate ,@IsDiscontinued , GETUTCDATE() , 1 , null ,null )

INSERT into tbl_Product_image values (@@IDENTITY , @ImageURL)
 
COMMIT TRAN ;

END TRY

BEGIN CATCH

ROLLBACK TRAN

END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProduct]    Script Date: 09-07-2021 14:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_DeleteProduct]
@ProductId int 
AS 
BEGIN 
BEGIN TRY

DECLARE @CategoryID int , @UnitID int

BEGIN TRAN
IF EXISTS (SELECT TOP 1 1 FROM tbl_Product where id = @ProductId)
BEGIN

DELETE FROM tbl_Product where id = @ProductId

END

 ELSE
 SELECT '300 , Error Product is missing !'
COMMIT TRAN ;

END TRY

BEGIN CATCH

ROLLBACK TRAN

END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetData]    Script Date: 09-07-2021 14:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_GetData]
AS BEGIN 
SELECT P.id,P.Name,P.Description,P.Price,P.Quantity,c.CategoryName,u.UnitName ,P.Weight,P.SellStartDate,P.SellEndDateDate,I.ImageURL,P.IsDiscontinued,
P.RecordCreatedDate,P.RecordCreatedDate ,P.RecordUpdatedBy,P.RecordUpdatedDate from tbl_Product P
INNER JOIN tbl_Category c on c.CategoryId = p.CategoryId
INNER JOIN tbl_UnitMeasure u on u.UnitId = P.MeasureUnitId
INNER JOIN tbl_Product_image I on I.ProductId = P.Id
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetData_Based_on_id]    Script Date: 09-07-2021 14:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_GetData_Based_on_id]
@ProductID int
AS BEGIN 
SELECT P.id,P.Name,P.Description,P.Price,P.Quantity,c.CategoryName,u.UnitName ,P.Weight,P.SellStartDate,P.SellEndDateDate,I.ImageURL,P.IsDiscontinued,
P.RecordCreatedDate,P.RecordCreatedDate ,P.RecordUpdatedBy,P.RecordUpdatedDate from tbl_Product P
INNER JOIN tbl_Category c on c.CategoryId = p.CategoryId
INNER JOIN tbl_UnitMeasure u on u.UnitId = P.MeasureUnitId
INNER JOIN tbl_Product_image I on I.ProductId = P.Id
WHERE P.Id = @ProductID
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProduct]    Script Date: 09-07-2021 14:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_UpdateProduct]
@ProductId int ,
@Name varchar(MAX),
@Description varchar(MAX), 
@Price Int,
@Quantity Int ,
@CategoryName varchar(500),
@UnitName varchar(500),
@Weight int ,
@SellStartDate datetime ,
@SellEndDateDate datetime ,
@ImageURL varchar(MAX) ,
@IsDiscontinued bit,
@UpdateByid int

AS 
BEGIN 
BEGIN TRY

DECLARE @CategoryID int , @UnitID int

 SET @CategoryID =  (SELECT CategoryId from tbl_Category where CategoryName = @CategoryName)
 SET @UnitID =      (SELECT UnitId from tbl_UnitMeasure where UnitName = @UnitName)
 
BEGIN TRAN
IF EXISTS (SELECT TOP 1 1 FROM tbl_Product where id = @ProductId)
BEGIN
UPDATE  tbl_Product  
SET Name  = @Name , Description = @Description, Price = @Price , 
Quantity = @Quantity, CategoryId =  @CategoryID  ,MeasureUnitId = @UnitID ,Weight = @Weight ,SellStartDate = @SellStartDate , 
SellEndDateDate = @SellEndDateDate , IsDiscontinued = @IsDiscontinued , RecordUpdatedBy = @UpdateByid , RecordUpdatedDate = GETUTCDATE()
WHERE id = @ProductId

Update tbl_Product_image SET ImageURL = @ImageURL where ProductId = @ProductId
 
 END

 ELSE
 SELECT '300 , Error Product is missing !'
COMMIT TRAN ;

END TRY

BEGIN CATCH

ROLLBACK TRAN

END CATCH
END
GO
/****** Object:  Table [dbo].[tbl_Category]    Script Date: 09-07-2021 14:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Category](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](1000) NULL,
 CONSTRAINT [PK_tbl_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Product]    Script Date: 09-07-2021 14:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Product](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[Quantity] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[MeasureUnitId] [int] NOT NULL,
	[Weight] [int] NOT NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDateDate] [datetime] NOT NULL,
	[IsDiscontinued] [bit] NOT NULL,
	[RecordCreatedDate] [datetime] NOT NULL,
	[RecordCreatedBy] [int] NOT NULL,
	[RecordUpdatedDate] [datetime] NULL,
	[RecordUpdatedBy] [int] NULL,
 CONSTRAINT [PK_tbl_Product] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_Product_Audit]    Script Date: 09-07-2021 14:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Product_Audit](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[Quantity] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[MeasureUnitId] [int] NOT NULL,
	[Weight] [int] NOT NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDateDate] [datetime] NOT NULL,
	[IsDiscontinued] [bit] NOT NULL,
	[RecordCreatedDate] [datetime] NOT NULL,
	[RecordCreatedBy] [int] NOT NULL,
	[RecordUpdatedDate] [datetime] NULL,
	[RecordUpdatedBy] [int] NULL,
	[RecordDeletedDate] [datetime] NULL,
	[RecordDeletedBy] [int] NULL,
 CONSTRAINT [PK_tbl_Product_Audit] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_Product_image]    Script Date: 09-07-2021 14:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Product_image](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ImageURL] [varchar](max) NOT NULL,
 CONSTRAINT [PK_tbl_Product_image] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_UnitMeasure]    Script Date: 09-07-2021 14:24:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_UnitMeasure](
	[UnitId] [int] IDENTITY(1,1) NOT NULL,
	[UnitName] [varchar](500) NOT NULL,
 CONSTRAINT [PK_tbl_UnitMeasure] PRIMARY KEY CLUSTERED 
(
	[UnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
USE [master]
GO
ALTER DATABASE [ShopBridge] SET  READ_WRITE 
GO
