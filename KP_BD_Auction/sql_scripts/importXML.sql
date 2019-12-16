/*
declare @xml xml

select @xml = P
from openrowset (bulk 'C:\XML_TradibgProgress.xml', single_blob) 
as TradingProgress(P)

declare @hdoc int

exec sp_xml_preparedocument @hdoc output, @xml

select * into NewTradingProgress
from openxml (@hdoc,'',1)
with(
	id int,
	Deal_id int,
	Byer_id int,
	StepTime time,
	StepRate money
	)*/

	--import from xml to server 
go
Create Procedure ImProdfromXml
AS
Begin
INSERT INTO TradingProgress(Id,Deal_Id,Byer_Id,StepTime,StepRate)
SELECT
MY_XML.NewTradingProgress.query('id').value('.', 'int'),
MY_XML.NewTradingProgress.query('Deal_Id').value('.', 'int'),
MY_XML.NewTradingProgress.query('Byer_Id').value('.', 'int'),
MY_XML.NewTradingProgress.query('StepTime').value('.', 'time'),
MY_XML.NewTradingProgress.query('StepRate').value('.', 'money')
FROM (SELECT CAST(MY_XML AS xml)
FROM OPENROWSET(BULK 'C:\XML_TradibgProgress.xml', SINGLE_BLOB) AS T(MY_XML)) AS T(MY_XML)
CROSS APPLY MY_XML.nodes('TradingProgress/NewTradingProgress') AS MY_XML (NewTradingProgress);
End;