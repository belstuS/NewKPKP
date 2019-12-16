use KP_2019

go

--delete Users

CREATE FUNCTION GetPasswordHash(@password nvarchar(50))
RETURNS nvarchar(50)
BEGIN
    declare @hashedPassword varbinary(500) = HASHBYTES('SHA2_512', @password);
	declare @hashToReturn nvarchar(50) = convert(nvarchar(50), @hashedPassword, 2);

	return @hashToReturn;
END;

go
--drop function GetPasswordHash
CREATE procedure HashUserPasswords
as
begin
	DECLARE @userId int
	Declare @password nvarchar(50)

   DECLARE my_cur CURSOR FOR 
     SELECT id
     FROM Users
   
   OPEN my_cur

   FETCH NEXT FROM my_cur INTO @userId

   WHILE @@FETCH_STATUS = 0
   BEGIN
        select top(1) 
			@password = [password]
		from Users
		where Users.Id = @userId;

		set @password = dbo.GetPasswordHash(@password);

        update Users
		set Password = @password
		where Users.Id = @userId;

        FETCH NEXT FROM my_cur INTO @userId
   END
   
   CLOSE my_cur
   DEALLOCATE my_cur

end;

exec HashUserPasswords;
go

go
create procedure IsPasswordValid
as
declare @Password nvarchar(50)
declare @UserName nvarchar(50) 

begin
  declare @hashedPassword nvarchar(50);

  select 
    @hashedPassword = Users.Password
  from Users
  where Users.Login = @UserName;


  set @Password = dbo.GetPasswordHash(@Password);

  if(@hashedPassword = @Password)
  return 1;
  else
  return 0;
end;


--drop procedure IsPasswordValid
/*go

CREATE procedure HashTmpPass
as
begin
	DECLARE @TMPId int
	Declare @password nvarchar(50)

   DECLARE my_cur CURSOR FOR 
     SELECT id
     FROM TMP
   
   OPEN my_cur

   FETCH NEXT FROM my_cur INTO @TMPId

   WHILE @@FETCH_STATUS = 0
   BEGIN
        select top(1) 
			@password = [tmpPass]
		from TMP
		where TMP.Id = @TMPId;

		set @password = dbo.GetPasswordHash(@password);

        update TMP
		set tmpPass = @password
		where TMP.Id = @TMPId;

        FETCH NEXT FROM my_cur INTO @TMPId
   END
   
   CLOSE my_cur
   DEALLOCATE my_cur

   --exec isValidPassword;
end;
--drop procedure HashTmpPass;
--exec HashTmpPass;
go
-- drop procedure AddTmpPass
go
create procedure AddTmpPass(
@Pass nvarchar(50))
as
begin 
insert into TMP(tmpPass) values(@Pass);
exec HashTmpPass;
	end;
go
*/



go
declare @id int
set @id=5
while @id >=5 and @id <= 100000
begin
insert into Users(Login,Password,Role) values ('user'+ convert(varchar(5), @id), 'pass'+ convert(varchar(5), @id), 'User')
set @id=@id+1
end