-- Index_query.sql
set statistics io on
set statistics time on
select * from TaxPayer where FirstName = '50AD7AC3' and LastName = 'D5C557B6'

set statistics io on
set statistics time on
select * from Taxpayer  where FirstName like '%A77%' 