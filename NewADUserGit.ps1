# Departments: Accounting, Administrators, CSR, Managers, Sales, Specialized Accounts
 
#Collects information needed to Create new AD user.
$firstname= Read-Host "Enter New User First Name"

$lastname= Read-Host "Enter New User last Name"

$fullname= $firstname +" " + $lastname

$username = Read-Host "Enter New user 'username'"

$password_1 = Read-Host "Enter New user 'password'"

$password = ConvertTo-SecureString $password_1 -AsPlainText -Force

#Asks for department that new user will be in.

$OU = Read-Host "Enter Department"

$SourceOU = "OU=$OU, OU=Git, DC=GitHub, DC=com"

#Copies the first user in the department to use as a template for our new user.

$source_user = Get-ADUser -Filter * -SearchBase $SourceOU | Select-Object -First 1

#Creating New User based on data provided

New-ADUser -Name $fullname -SamAccountName $username -UserPrincipalName "$username@ABC-HOUSTON.local" -AccountPassword $password -Enabled $true -Path $SourceOU -Instance $source_user

$UserSID = (Get-ADUser $username).SID.Value

Set-ADUser -Identity $username -SamAccountName $username -DisplayName $fullname -UserPrincipalName "$username@ABC-HOUSTON.local" -GivenName $firstname -Surname $lastname -Description $OU 

Set-ADAccountPassword -Identity $UserSID -NewPassword $password -Reset

Set-ADUser -Identity $UserSID -CannotChangePassword $true
