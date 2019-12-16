go 
create procedure ExportXML
as
begin
	select
	id,
	Deal_Id,
	Byer_Id,
	StepTime,
	StepRate
	from TradingProgress 
	for xml path;
end;

exec ExportXML