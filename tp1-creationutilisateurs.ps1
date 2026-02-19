###############################################################################
## Script pour créer les comptes utilisateurs du TP1 dans le cadre du cours
## 420-4S6-EM Serveurs 3: Administration centralisée
##
## Auteur: Vincent Carrier
## Date:   19 février 2026
###############################################################################

Import-Module ActiveDirectory

$data = ConvertFrom-Csv @"
noEmpl,givenName,initials,sn,sAMAccountName,upnPrefix,description,dept
10001,Alice,,Robert,arobe,alice.robert,Présidente,Haute direction
10002,Bob,,Graton,bgrat,bob.graton,Vice-président finance,Haute direction
10003,Caroline,,Tremblay,ctrem,caroline.tremblay,Directrice TI,TI
10004,Claude,,Gagnon,cgagn,claude.gagnon,Vice-président marketing,Haute direction
10005,Denis,,Denis,ddeni,denis.denis,Vice-président opérations,Haute direction
10006,Patricia,,Larose,plaro,patricia.larose,Vice-présidente RH,Haute direction
10007,Gertrude,,Lamoureux,glamo,gertrude.lamoureux,Comptable,Finances
10010,Claude,,Tremblay,ctrem1,claude.tremblay,Comptable fiscaliste,Finances
10101,Cyrille,,Tremblay,ctrem2,cyrille.tremblay,Admin système,TI
10106,Henri,,Pavoine,hpavo,henri.pavoine,Technicien,TI
10009,Paul,,Meilleur,pmeil,paul.meilleur,Technicien sénior,TI
10010,Pierre,,Laroche,plaro1,pierre.laroche,Analyste,TI
10011,Agnès,,Toutant,atout,agnes.toutant,Analyste trésorerie,Finances
10012,Gilles,,Torieux,gtori,gilles.crepeau,Commis,Opérations
10013,Bill,,Boquet,bboqu,bill.boquet,Commis,Opérations
10014,Jean,B,Nguyen,jnguy,jean.b.nguyen,Analyste RH,RH
10015,Claude,,Claude,cclau,claude.claude,Analyste RH,RH
10016,Gaetan,G,Tanguay,gtang,gaetan.g.tanguay,Opérateur,Opérations
10017,Jules,,Crépeau,jcrep,jules.crepeau,Opérateur,Opérations
10018,Bruno,,Bruneau,bbrun,bruno.bruneau,Chef d'équipe,Opérations
10019,Richard,,Tapon,rtapo,richard.tapon,Analyste,Opérations
10020,Zoë,Z,Zappa,zzapp,zoe.z.zappa,Analyste,Opérations
10021,Gérard,,Girard,ggira,gerard.girard,Analyste,Opérations
10022,Pablo,,Pleau,pplea,pablo.pleau,Admin système,TI
10023,Roch,,Lapierre,rlapi,roch.lapierre,Chef d'équipe,Marketing
10024,Julie,,Joly,jjoly,julie.joly,Graphiste,Marketing
10025,Elena,,Capuzzi,ecapu,elena.capuzzi,Graphiste,Marketing
10026,Jean-Régis,,Lavoie,jlavo,jean-regis.lavoie,Analyste,Marketing
10027,Jos,,Bleau,jblea,jos.bleau,Analyste,Marketing
10221,Carlos,,Rodriguez,crodr,carlos.rodriguez,Chef d'équipe,RH
"@

foreach ($user in $data) {
    try {
        $ADUserSplat = @{
            Path = "OU=Utilisateurs,$((Get-ADDomain).DistinguishedName)"
            Name = $user.givenName + " " + $(if($user.initials){$user.initials + ". "}) + $user.sn
            GivenName = $user.givenName
            Surname = $user.sn
            Initials = $user.initials
            DisplayName = $user.givenName + " " + $(if($user.initials){$user.initials + ". "}) + $user.sn
            Description = $user.description
            Title = $user.description
            SamAccountName = $user.sAMAccountName
            UserPrincipalName = $user.upnPrefix + '@' + $(Get-ADDomain).DNSRoot
            AccountPassword = "Passw0rd" | ConvertTo-SecureString -AsPlainText -Force
            PasswordNeverExpires = $true
            ChangePasswordAtLogon = $false
            EmployeeNumber = $user.noEmpl
            Department = $user.dept
            Enabled = $true
        }
        New-ADUser @ADUserSplat -ErrorAction Stop
        Write-Host "$($User.samAccountName) a été créé."
    }
    catch {
        Write-Warning "$($User.samAccountName) n'a pas pu être créé : $($_.Exception.Message)"
    }
}
