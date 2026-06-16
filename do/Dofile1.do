*=====================================================================================================*
*======	PROJET D'ANALYSE DE DONNEES 
*====== OBJECTIF: Analyse de la satisfaction des étudiants par rapport aux services universitaires.
*====== AUTEURS: ...
*=====================================================================================================*

clear all
set more off

* Récupération du dossier courant (dossier do)
local dossier_courant "`c(pwd)'"

* Remonter d'un dossier (dossier projet)
cd ..
local dossier_parent "`c(pwd)'"

*=====================================================================================================*
* Création d'une macro globale qui contiendra le chemin d'accès au projet
global PROJET "`dossier_parent'"
*=====================================================================================================*

*=====================================================================================================*
* Création des macros globales qui contiendront les chemins d'accès aux sous-dossiers du projet
global TABLEAUX_QUESTION_1 "$PROJET\output\tableaux\Question_1"
global TABLEAUX_QUESTION_2 "$PROJET\output\tableaux\Question_2"
global TABLEAUX_QUESTION_3 "$PROJET\output\tableaux\Question_3"
global TABLEAUX_QUESTION_4 "$PROJET\output\tableaux\Question_4"
global TABLEAUX_QUESTION_5 "$PROJET\output\tableaux\Question_5"
global TABLEAUX_QUESTION_6 "$PROJET\output\tableaux\Question_6"
global TABLEAUX_QUESTION_7 "$PROJET\output\tableaux\Question_7"

global FIGURES_QUESTION_1 "$PROJET\output\figures\Question_1"
global FIGURES_QUESTION_2 "$PROJET\output\figures\Question_2"
global FIGURES_QUESTION_3 "$PROJET\output\figures\Question_3"
global FIGURES_QUESTION_4 "$PROJET\output\figures\Question_4"
global FIGURES_QUESTION_5 "$PROJET\output\figures\Question_5"
global FIGURES_QUESTION_6 "$PROJET\output\figures\Question_6"
global LOG "$PROJET\log"
*=====================================================================================================*

*=====================================================================================================*
** Ouverture de fichier log
log using "$LOG\Resultats_analyse.log", replace
*=====================================================================================================*

*=====================================================================================================*
** Importation de la base de données
insheet using "data\Base.csv", comma
br
*=====================================================================================================*

*=====================================================================================================*
** Suppression des variables sans intérêt pour l'analyse
drop  conclusion nu_terminal dateauto hd hf x_id x_uuid x_submission_time x_validation_status ///
	x_notes x_status x_submitted_by x__version__ x_tags codeg codee  fil_other note_adm ///
	note_ped note_ped_001 note_inf
*=====================================================================================================*

*=====================================================================================================*=====================================================================================================*
* Convertion de variables en numérique en ometttant celle qui sont de base des chaines de caractères
*=====================================================================================================*

** Identification des variables numeriques
local exclure "sexe etb  niv_etd  adm_p_acceuil adm_p_inscription adm_p_documents adm_p_informations adm_p_securite ped_p_filieres ped_p_formation ped_p_stages ped_p_reclamations ped_p_bibliotheque soc_p_logement soc_p_sante soc_p_restau soc_p_sportcult inf_p_internet inf_p_mobilier inf_p_informatiq inf_p_immobilier commentaires"

** Boucle de conversion des variables numeriques
foreach var of varlist _all {
    if !`:list var in exclure' {
        capture destring `var', replace force
    }
}
*=====================================================================================================*=====================================================================================================*

*=====================================================================================================**=====================================================================================================*
** ------------------------------> Labelisation des variables 
*=====================================================================================================*

* Sociodémographiques
label var site "Le site d'enquete"
label var nat "La nationalité de l'étudiant"
label var age "L'âge de l'étudiant"
label var sexe "Le sexe de l'étudiant"
label var etb "L'établissement de l'étudiant"
label var niv_etd "Le niveau d'étude de l'étudiant"

* Accueil administratif
label variable adm_s_acceuil   "Satisfaction accueil/assistance (score)"
label variable adm_p_acceuil   "Accueil/assistance (ensemble)"
label variable adm_p_acceuila  "Accueil chaleureux"
label variable adm_p_acceuilb  "Indications claires"
label variable adm_p_acceuilc  "Espace bien aménagé"
label variable adm_p_acceuild  "Infos complètes"
label variable adm_p_acceuile  "Suivi des documents"
label variable adm_p_acceuilf  "Personnel assidu"

* Inscriptions
label variable adm_s_inscription   "Satisfaction inscriptions (score)"
label variable adm_p_inscription   "Inscriptions (ensemble)"
label variable adm_p_inscriptiona  "Plateforme fluide"
label variable adm_p_inscriptionb  "Plateforme accessible"
label variable adm_p_inscriptionc  "Sans déplacement physique"
label variable adm_p_inscriptiond  "Frais abordables"
label variable adm_p_inscriptione  "Attestations téléchargeables"
label variable adm_p_inscriptionf  "Paiement électronique simple"

* Documents administratifs
label variable adm_s_documents   "Satisfaction délivrance documents (score)"
label variable adm_p_documents   "Délivrance documents (ensemble)"
label variable adm_p_documentsa  "Processus rapide et efficace"
label variable adm_p_documentsb  "Délais respectés"
label variable adm_p_documentsc  "Communication claire"
label variable adm_p_documentsd  "Processus complexe"
label variable adm_p_documentse  "Pas de suivi numérique"
label variable adm_p_documentsf  "Erreurs fréquentes"

* Informations
label variable adm_s_informations   "Satisfaction communication/infos (score)"
label variable adm_p_informations   "Communication/infos (ensemble)"
label variable adm_p_informationsa  "Site UNB utile"
label variable adm_p_informationsb  "Site Campus Faso utile"
label variable adm_p_informationsc  "Diversité des sources"
label variable adm_p_informationsd  "Infos tardives"
label variable adm_p_informationse  "Campus Faso souvent en panne"
label variable adm_p_informationsf  "Infos activités accessibles"

* Sécurité
label variable adm_s_securite   "Satisfaction sécurité (score)"
label variable adm_p_securite   "Sécurité (ensemble)"
label variable adm_p_securitea  "Voies de secours indiquées"
label variable adm_p_securiteb  "Vols fréquents"
label variable adm_p_securitec  "Pas de prévention épidémies"
label variable adm_p_securited  "Éclairage suffisant"
label variable adm_p_securitee  "Prévention harcèlement/discrimination"
label variable adm_p_securitef  "Pas d'EPI en TP"

* Filières
label variable ped_s_filieres   "Satisfaction filières (score)"
label variable ped_p_filieres   "Filières (ensemble)"
label variable ped_p_filieresa  "Diversité des filières"
label variable ped_p_filieresb  "Adéquation marché du travail"
label variable ped_p_filieresc  "Adéquation réalités de vie"
label variable ped_p_filieresd  "Manque de suivi"
label variable ped_p_filierese  "Formation prof. insuffisante"
label variable ped_p_filieresf  "Diplômes reconnus à l'international"

* Formation
label variable ped_s_formation   "Satisfaction qualité formation (score)"
label variable ped_p_formation   "Qualité formation (ensemble)"
label variable ped_p_formationa  "Enseignants expérimentés"
label variable ped_p_formationb  "Programmes bien structurés"
label variable ped_p_formationc  "Contenu pertinent"
label variable ped_p_formationd  "Conditions d'apprentissage adéquates"
label variable ped_p_formatione  "Cours surchargés"
label variable ped_p_formationf  "Enseignants disponibles"

* Stages
label variable ped_s_stages   "Satisfaction stages (score)"
label variable ped_p_stages   "Stages (ensemble)"
label variable ped_p_stagesa  "Offres insuffisantes"
label variable ped_p_stagesb  "Stages non rémunérés"
label variable ped_p_stagesc  "Démarches complexes"
label variable ped_p_stagesd  "Stages adaptés aux spécialités"
label variable ped_p_stagese  "Bonne info sur les offres"
label variable ped_p_stagesf  "Soutien pour trouver un stage"

* Réclamations
label variable ped_s_reclamations   "Satisfaction réclamations (score)"
label variable ped_p_reclamations   "Réclamations (ensemble)"
label variable ped_p_reclamationsa  "Problèmes résolus rapidement"
label variable ped_p_reclamationsb  "Explications précises"
label variable ped_p_reclamationsc  "Contact facile"
label variable ped_p_reclamationsd  "Réclamations ignorées"
label variable ped_p_reclamationse  "Pas de retour d'info"
label variable ped_p_reclamationsf  "Personnel difficile à joindre"

* Bibliothèque
label variable ped_s_bibliotheque   "Satisfaction bibliothèque (score)"
label variable ped_p_bibliotheque   "Bibliothèque (ensemble)"
label variable ped_p_bibliothequea  "Ressources disponibles"
label variable ped_p_bibliothequeb  "Service accessible"
label variable ped_p_bibliothequec  "Personnel accueillant"
label variable ped_p_bibliothequed  "Documents obsolètes"
label variable ped_p_bibliothequee  "Espaces de travail insuffisants"
label variable ped_p_bibliothequef  "Problèmes technologiques"

* Logement
label variable soc_s_logement   "Satisfaction logement (score)"
label variable soc_p_logement   "Logement (ensemble)"
label variable soc_p_logementa  "Chambres en bon état"
label variable soc_p_logementb  "Nb étudiants/chambre acceptable"
label variable soc_p_logementc  "Hygiène adéquate"
label variable soc_p_logementd  "Logements sécurisés"
label variable soc_p_logemente  "Durée d'occupation suffisante"
label variable soc_p_logementf  "Activités autorisées en cité"

* Santé
label variable soc_s_sante   "Satisfaction santé (score)"
label variable soc_p_sante   "Santé (ensemble)"
label variable soc_p_santea  "Bonne qualité des soins"
label variable soc_p_santeb  "Personnel sanitaire disponible"
label variable soc_p_santec  "Personnel qualifié"
label variable soc_p_santed  "Intervention urgence disponible"
label variable soc_p_santee  "Sensibilisation santé suffisante"
label variable soc_p_santef  "Bon accueil des patients"

* Restauration
label variable soc_s_restau   "Satisfaction restauration (score)"
label variable soc_p_restau   "Restauration (ensemble)"
label variable soc_p_restaua  "Service rapide"
label variable soc_p_restaub  "Quantité suffisante"
label variable soc_p_restauc  "Restaurants propres"
label variable soc_p_restaud  "Places assises suffisantes"
label variable soc_p_restaue  "Menus variés"
label variable soc_p_restauf  "Personnel qualifié"

* Sports et culture
label variable soc_s_sportcult   "Satisfaction sport/culture (score)"
label variable soc_p_sportcult   "Sport/culture (ensemble)"
label variable soc_p_sportculta  "Diversité des activités"
label variable soc_p_sportcultb  "Infrastructures disponibles"
label variable soc_p_sportcultc  "Activités bien communiquées"
label variable soc_p_sportcultd  "Culture valorisée"
label variable soc_p_sportculte  "Équipes et compagnies existantes"
label variable soc_p_sportcultf  "Compétitions organisées régulièrement"

* Internet
label variable inf_s_internet   "Satisfaction internet (score)"
label variable inf_p_internet   "Internet (ensemble)"
label variable inf_p_interneta  "Réseau stable"
label variable inf_p_internetb  "Connexion disponible"
label variable inf_p_internetc  "Accès ressources en ligne facile"
label variable inf_p_internetd  "Connexion lente"
label variable inf_p_internete  "Pannes fréquentes"
label variable inf_p_internetf  "Couverture Wi-Fi insuffisante"

* Mobilier
label variable inf_s_mobilier   "Satisfaction mobilier (score)"
label variable inf_p_mobilier   "Mobilier (ensemble)"
label variable inf_p_mobiliera  "Meubles confortables"
label variable inf_p_mobilierb  "Salles disponibles"
label variable inf_p_mobilierc  "Salles bien éclairées"
label variable inf_p_mobilierd  "Meubles inadaptés"
label variable inf_p_mobiliere  "Mobilier en quantité suffisante"
label variable inf_p_mobilierf  "Matériel de bonne qualité"

* Informatique
label variable inf_s_informatiq   "Satisfaction équipements informatiques (score)"
label variable inf_p_informatiq   "Équip. informatiques (ensemble)"
label variable inf_p_informatiqa  "Ordinateurs modernes"
label variable inf_p_informatiqb  "Ordinateurs accessibles à tous"
label variable inf_p_informatiqc  "Adapté aux étudiants handicapés"
label variable inf_p_informatiqd  "Logiciels disponibles"
label variable inf_p_informatiqe  "Imprimantes souvent en panne"
label variable inf_p_informatiqf  "Équipements en bon état"

* Immobilier
label variable inf_s_immobilier   "Satisfaction infrastructures (score)"
label variable inf_p_immobilier   "Infrastructures (ensemble)"
label variable inf_p_immobiliera  "Salles spacieuses"
label variable inf_p_immobilierb  "Salles modernes"
label variable inf_p_immobilierc  "Infrastructures sportives disponibles"
label variable inf_p_immobilierd  "Pb eau/électricité"
label variable inf_p_immobiliere  "Bâtiments mal entretenus"
label variable inf_p_immobilierf  "Transports efficaces"

* Synthèse
label variable commentaires "Commentaires libres"


*=======================================================================================================
** Labelisation des valuers de site 
label define site 1 "INSSA" 2 "Site du 22" 3 "Nasso" 4 "UBC" 5 "ELOHIM" 6 "MARANATA" 7 "IDR" 8 "Centre de calcu" 9 "Eben Ezer"
label values site site

*=======================================================================================================
** Labelisation des valuers de nationalité
replace nat = 22 if nat==.
label define nat 0 "Burkinabe" 1 "Ivoirien" 2 "Malien" 8 "Other" 22 "Inconnue"
label values nat nat

*=======================================================================================================
** Decoupage de la valriable âge en tranches d'âges et labelisation
gen tranches_age=. , after(age)
replace tranches_age = 0 if inrange(age,17,18) 
replace tranches_age = 1 if inrange(age,19,20) 
replace tranches_age = 2 if inrange(age,21,22) 
replace tranches_age = 3 if inrange(age,23,24) 
replace tranches_age = 4 if inrange(age,25,26) 
replace tranches_age = 5 if inrange(age,27,28)

label var tranches_age "Tranches d'age"
label define tranches_age 0 "17-18" 1 "19-20" 2 "21-22" 3 "23-24" 4 "25-26" 5 "27-28"
label value tranches_age tranches_age

*=======================================================================================================
** Labelisation des variables avec echelle
label define echelle 1 "Très insatisfait" ///
                     2 "Insatisfait" ///
                     3 "Neutre" ///
                     4 "Satisfait" ///
                     5 "Très satisfait"
					 
* Liste des variables à labeliser
local variables " adm_s_acceuil adm_s_inscription adm_s_documents adm_s_informations adm_s_securite ped_s_filieres ped_s_formation ped_s_stages ped_s_reclamations ped_s_bibliotheque soc_s_logement soc_s_sante soc_s_restau soc_s_sportcult inf_s_internet inf_s_mobilier inf_s_informatiq inf_s_immobilier"

* Boucle pour appliquer le label
foreach var of local variables {
	replace `var'=0 if `var'==8
    label values `var' echelle
}

*=======================================================================*=====================================================================================================*	
*				RECODAGE ET LABELISATION DES VARIABLES DE REPONSE
*=======================================================================*=====================================================================================================*

*=====================================================================================================*
** Implémentation de la fonction de recodage des variables
program define recodage_variables_reponses_2
    args variable_de_reference
		
	* Récupérer toutes les variables dans l'ordre
	ds
	local liste_ordonnee_variables `r(varlist)'
	
	* Trouver la position de la variable de référence
	local position : list posof "`variable_de_reference'" in liste_ordonnee_variables
	
	*Creer une liste pour les variables de la section
	local liste_variables_de_section ""
	
	* Récupérer toutes les variables de la section pour le recodage
	forvalues i= 1/7 {
		* Calculer la position suivante
		local position_suiv = `position' + `i'
		* Récupérer la variable suivante
		local variable_suiv : word `position_suiv' of `liste_ordonnee_variables'
		if `i' == 1 {
			* Variable de reference
			local variables_de_section_reference `variable_suiv'
		}
		else {
			* Variables pour les reponses
			local liste_variables_de_section `liste_variables_de_section' `variable_suiv'
		}
    }
	
	foreach var of varlist `liste_variables_de_section' {
		local derniere_lettre = upper(substr("`var'", -1, 1))
		replace `var' = cond(strpos(`variables_de_section_reference', "`derniere_lettre'") > 0, 100, 0)
		replace `var' = . if `variables_de_section_reference' == ""
	}
	
	* Labelisation de chaque question
	foreach var of varlist `liste_variables_de_section' {
		label value `var' choix
	}
	
end	

*=====================================================================================================*
** Recherche des differentes variables concernées et application de la fonction et du label
label define choix 0 "Non" 100 "Oui"
local vars_echelle

foreach var of varlist _all {
    local value_lab : value label `var'
    if "`value_lab'" == "echelle" {
        local vars_echelle `vars_echelle' `var'
    }
}


foreach var of varlist `vars_echelle' {
    recodage_variables_reponses_2 `var'
}	   	
*=====================================================================================================**=====================================================================================================*

*=========================================================================================================
* 									  REPONSES AUX QUESTONS												 =
*=========================================================================================================

*=====================================================================================================*
** 1. Description de la repartition des etudiants selon les caracteristiques socio-demographiques
*=====================================================================================================*

local varlist "nat age sexe etb niv_etd"
foreach var in `varlist' {
	local var_lab : variable  label `var'
	
    estpost summarize `var'
	esttab using "$TABLEAUX_QUESTION_1\stats_`var'.tex", replace cells("mean(fmt(2)) sd(fmt(2)) min max") ///
    nomtitle nonumber booktabs
	
	estpost tab `var'
	esttab using "$TABLEAUX_QUESTION_1\prop_`var'.tex", replace booktabs cells("b(fmt(0)) pct(fmt(1))") ///
    nomtitle nonumber
	
	graph pie, over(`var') plabel(_all percent, format(%4.2f)) plabel(_all name, gap(25))
	graph export "$FIGURES_QUESTION_1\pie_`var'.pdf", replace
	
	graph bar (percent), over(`var') ///
		title("Répartition selon `var_lab'") ///
		ytitle("Pourcentage (%)") ///
		blabel(bar, format(%4.1f))
	graph export "$FIGURES_QUESTION_1\bar_`var'.pdf", replace
}

*=====================================================================================================*
** Reponses aux questions 2, 3, 4 et 5
*=====================================================================================================*

** Programme permettant d'automatiser les analyses basiques par question
program define analyse_par_section_4
    args variable_de_reference numero
    
	* Tableau de proportion de la variable avec echelle
	tab `variable_de_reference'
	local N = r(N)

	estpost tab `variable_de_reference'

	esttab using "${TABLEAUX_QUESTION_`numero'}\prop_`variable_de_reference'.tex", replace ///
		booktabs ///
    cells("b(fmt(0) label(Effectif)) pct(fmt(1) label(Fréquence (\%)))") ///
    nomtitle nonumber noobs ///
    title("`: variable label `variable_de_reference''") ///
    alignment(rr) ///
    substitute("*{1}{rr}" "*{2}{r}") ///
    addnotes("Source : Enquête, 2024. N = `N'")
	
	* Barplot de la variable avec echelle
	local var_lab : variable  label `variable_de_reference'
	graph bar (percent), over(`variable_de_reference') ///
		title(" `var_lab' ") ///
		ytitle("Pourcentage (%)") ///
		blabel(bar, format(%5.2f))
	graph export "${FIGURES_QUESTION_`numero'}\bar_`variable_de_reference'.pdf", replace
	
	* Récupérer toutes les variables dans l'ordre
	ds
	local liste_ordonnee_variables `r(varlist)'
	
	*Creer une liste pour les variables de la section
	local liste_variables_de_section ""
	
	
	* Trouver la position de la variable de référence
	local position : list posof "`variable_de_reference'" in liste_ordonnee_variables
	
	forvalues i= 1/7 {
		* Calculer la position suivante
		local position_suiv = `position' + `i'
		* Récupérer la variable suivante
		local variable_suiv : word `position_suiv' of `liste_ordonnee_variables'
		if `i' == 1 {
			* Variable de reference pour les reponses
			local variables_de_section_reference `variable_suiv'
		}
		else {
			* Variables pour les reponses
			local liste_variables_de_section `liste_variables_de_section' `variable_suiv'
		} 
    }
		
	* Labelisation et Tableau de proportion pour chaque affirmation
	foreach var of varlist `liste_variables_de_section' {
		estpost tab `var'
		esttab using "${TABLEAUX_QUESTION_`numero'}\prop_`var'.tex", replace booktabs cells("b(fmt(0) label(Effectif)) pct(fmt(1) label(Fréquence (%)))") ///
		nomtitle nonumber varlabels(`e(labels)')
	}
	*====================================================================
	* Construire la légende automatiquement
	local legend_options ""
	local k = 1
	foreach var of local liste_variables_de_section {
		local vlab : variable label `var'
		local legend_options `"`legend_options' label(`k' "`vlab'")"'
		local k = `k' + 1
	}

	* Barplot comparatif de toutes les affirmations
	local var_lab : variable  label `variables_de_section_reference'
	graph bar (mean)  `liste_variables_de_section' , title("Accord avec les affirmations sur `var_lab' ") ///
    ytitle("Proportion (%)") ///
	blabel(bar, format(%5.2f)) ///
    legend(`legend_options')
	graph export "${FIGURES_QUESTION_`numero'}\bar_`variables_de_section_reference'.pdf", replace


end
*======================
** Recuperation des variables à analyser dans une macro locale
local vars_echelle
foreach var of varlist _all {
    local value_lab : value label `var'
    if "`value_lab'" == "echelle" {
        local vars_echelle `vars_echelle' `var'
    }
}

** Determination des numeros des questions aux quelles appartiennent chaque variable
** et appel de la fonction sur les differentes variables
local i = 1
foreach var of varlist `vars_echelle' {
	if(`i' <= 5){ 
		local num_question = 2
	}
	else if(`i' >= 6 & `i' <= 10){ 
		local num_question = 3
	}
	if(`i' >= 11 & `i' <= 14){ 
		local num_question = 4
	}
	if(`i' >= 15){ 
		local num_question = 5
	}
	
    analyse_par_section_4 `var' `num_question'
	local ++i
}


*6. Modele de regression logistique en creant la variable satisfaction globale d´ependante
*(qui prend 1 si le score globale de satisfaction est inferieure ou egal a 45 et 0 sinon) avec
*des variables explicatives choisies convenablement.

** Score de satisfaction par section
egen score_admin = rowtotal(adm_s_acceuil adm_s_inscription adm_s_documents adm_s_informations adm_s_securite)
label var score_admin "Score service administratif"
egen score_ped = rowtotal(ped_s_filieres ped_s_formation ped_s_stages ped_s_reclamations ped_s_bibliotheque)
label var score_ped "Score service pédagogique "
egen score_soc = rowtotal(soc_s_logement soc_s_sante soc_s_restau soc_s_sportcult)
label var score_soc "Score service social"
egen score_inf = rowtotal(inf_s_internet inf_s_mobilier inf_s_informatiq inf_s_immobilier)
label var score_inf "Score service infrastructure"

** Score de satisfaction global
gen score_global = score_admin + score_ped + score_soc + score_inf
gen sat_globale  = (score_global <= 45)

gen id_repondant      = _n 

*==============================================================================
* MODÈLE LOGISTIQUE
*==============================================================================

* Definition des modalités de référence
fvset base 1 sexe   // Référence : Féminin (1)
fvset base 2 niv_etd   // Référence : Licence
fvset base 1 etb  // Référence : ESI

** Convertir les string en numérique avec encode
encode sexe, gen(sexe_num)
encode niv_etd, gen(niv_etd_num)
encode etb, gen(etb_num)

** Modelisation proprement dite
logistic sat_globale i.sexe_num i.niv_etd_num i.etb_num i.tranches_age, vce(robust)
estimates store modele_complet

* Stocker les statistiques globales du modèle
scalar N_obs    = e(N)
scalar ll       = e(ll)
scalar chi2_lr  = e(chi2)
scalar df_lr    = e(df_m)
scalar prob_chi = e(p)
scalar pr2      = e(r2_p)

* Test de Hosmer-Lemeshow
estat gof, group(8)
scalar hl_chi2  = r(chi2)
scalar hl_df    = r(df)
scalar hl_prob  = r(p)

* Aire sous la courbe ROC
lroc, nograph
scalar auc = r(area)

*==============================================================================
* GÉNÉRATION DU TABLEAU LATEX
*==============================================================================

capture file close fh
file open fh using "$TABLEAUX_QUESTION_6\tableau_reg_logit.tex", write replace

* ---- Début du tableau ----
file write fh "\begin{table}[htbp]" _newline
file write fh "\centering" _newline
file write fh "\caption{Régression logistique -- Satisfaction globale des \'etudiants de l'UNB}" _newline
file write fh "\label{tab:logit_sat}" _newline
file write fh "\begin{tabular}{lcc}" _newline
file write fh "\toprule" _newline
file write fh "\textbf{Variables} & \textbf{Odds Ratio} & \textbf{p $>$ z} \\" _newline
file write fh "\midrule" _newline

* ========== SEXE ==========
file write fh "\multicolumn{3}{l}{\textbf{Sexe}} \\" _newline
file write fh "\quad Féminin & Référece & -- \\" _newline

* Masculin : coefficient b[1.sexe] vs ref 0.sexe
* Dans notre modèle sexe codé 0=Masculin, 1=Féminin → ref=Féminin => coef pour Masculin = [0.sexe]
* Récupérer OR et p-value pour 0.sexe (Masculin)
local or_val  = exp(_b[2.sexe_num])
local pz_val  = (1-normal(abs(_b[2.sexe_num]/_se[2.sexe_num])))*2
local or_str  = string(round(`or_val', 0.01), "%5.2f")
local etoiles   = cond(`pz_val'<0.01,"***",cond(`pz_val'<0.05,"**",cond(`pz_val'<0.10,"*","NS")))
local pz_str  = string(round(`pz_val', 0.001), "%5.3f")
file write fh "\quad Masculin & `or_str' & `pz_str'`etoiles' \\" _newline

* ========== ÉTABLISSEMENT ==========
file write fh "\midrule" _newline
file write fh "\multicolumn{3}{l}{\textbf{Âge}} \\" _newline
file write fh "\quad 19-20 & R\'ef. & -- \\" _newline

local tranches_age_labels `" "21-22" "23-24" "25-26" "27-28" "'
forvalues k = 2/4 {
    local lab : word `=`k'-1' of `tranches_age_labels'
    local or_val  = exp(_b[`k'.tranches_age])
    local pz_val  = (1-normal(abs(_b[`k'.tranches_age]/_se[`k'.tranches_age])))*2
    local or_str  = string(round(`or_val', 0.01), "%5.2f")
    local stars   = cond(`pz_val'<0.01,"***",cond(`pz_val'<0.05,"**",cond(`pz_val'<0.10,"*","NS")))
    local pz_str  = string(round(`pz_val', 0.001), "%5.3f")
    file write fh "\quad `lab' & `or_str' & `pz_str'`stars' \\" _newline
}

* ========== NIVEAU D'ÉTUDE ==========
file write fh "\midrule" _newline
file write fh "\multicolumn{3}{l}{\textbf{Niveau d'\'etude}} \\" _newline
file write fh "\quad Licence & R\'ef. & -- \\" _newline

local or_val  = exp(_b[3.niv_etd_num])
local pz_val  = (1-normal(abs(_b[3.niv_etd_num]/_se[3.niv_etd_num])))*2
local or_str  = string(round(`or_val', 0.01), "%5.2f")
local stars   = cond(`pz_val'<0.01,"***",cond(`pz_val'<0.05,"**",cond(`pz_val'<0.10,"*","NS")))
local pz_str  = string(round(`pz_val', 0.001), "%5.3f")
file write fh "\quad Master & `or_str' & `pz_str'`stars' \\" _newline

local or_val  = exp(_b[1.niv_etd_num])
local pz_val  = (1-normal(abs(_b[1.niv_etd_num]/_se[1.niv_etd_num])))*2
local or_str  = string(round(`or_val', 0.01), "%5.2f")
local stars   = cond(`pz_val'<0.01,"***",cond(`pz_val'<0.05,"**",cond(`pz_val'<0.10,"*","NS")))
local pz_str  = string(round(`pz_val', 0.001), "%5.3f")
file write fh "\quad Doctorat & `or_str' & `pz_str'`stars' \\" _newline

* ========== ÉTABLISSEMENT ==========
file write fh "\midrule" _newline
file write fh "\multicolumn{3}{l}{\textbf{\'Etablissement}} \\" _newline
file write fh "\quad ESI & R\'ef. & -- \\" _newline

local etab_labels `" "IDR" "INSSA" "IUT" "UFR-SEA" "UFR-SHLAM" "UFR-SJPEG" "UFR-SVT" "'
forvalues k = 2/8 {
    local lab : word `=`k'-1' of `etab_labels'
    local or_val  = exp(_b[`k'.etb_num])
    local pz_val  = (1-normal(abs(_b[`k'.etb_num]/_se[`k'.etb_num])))*2
    local or_str  = string(round(`or_val', 0.01), "%5.2f")
    local stars   = cond(`pz_val'<0.01,"***",cond(`pz_val'<0.05,"**",cond(`pz_val'<0.10,"*","NS")))
    local pz_str  = string(round(`pz_val', 0.001), "%5.3f")
    file write fh "\quad `lab' & `or_str' & `pz_str'`stars' \\" _newline
}

* ========== CONSTANTE ==========
file write fh "\midrule" _newline
local or_val  = exp(_b[_cons])
local pz_val  = (1-normal(abs(_b[_cons]/_se[_cons])))*2
local or_str  = string(round(`or_val', 0.01), "%5.2f")
local stars   = cond(`pz_val'<0.01,"***",cond(`pz_val'<0.05,"**",cond(`pz_val'<0.10,"*","NS")))
local pz_str  = string(round(`pz_val', 0.001), "%5.3f")
file write fh "Constante & `or_str' & `pz_str'`stars' \\" _newline

* ========== STATISTIQUES DU MODÈLE ==========
file write fh "\midrule" _newline
file write fh "\multicolumn{3}{l}{\textbf{Statistiques du mod\`ele}} \\" _newline

local n_str   = string(N_obs, "%6.0f")
local ll_str  = string(round(ll,   0.01), "%10.2f")
local c2_str  = string(round(chi2_lr, 0.01), "%10.2f")
local df_str  = string(df_lr, "%3.0f")
local pc_str  = string(round(prob_chi, 0.001), "%5.3f")
local pr_str  = string(round(pr2,  0.0001), "%6.4f")
local hl_c2s  = string(round(hl_chi2, 0.01), "%6.2f")
local hl_ps   = string(round(hl_prob, 0.4), "%6.4f")
local auc_str = string(round(auc,  0.0001), "%6.4f")

file write fh "Nombre d'observations & \multicolumn{2}{c}{`n_str'} \\" _newline
file write fh "Log likelihood & \multicolumn{2}{c}{`ll_str'} \\" _newline
file write fh "LR chi2(`df_str') & \multicolumn{2}{c}{`c2_str'} \\" _newline
file write fh "Prob $>$ chi2 & \multicolumn{2}{c}{`pc_str'} \\" _newline
file write fh "Pseudo R\textsuperscript{2} & \multicolumn{2}{c}{`pr_str'} \\" _newline

file write fh "\midrule" _newline
file write fh "\multicolumn{3}{l}{\textbf{Test de Hosmer-Lemeshow}} \\" _newline
file write fh "\quad Hosmer-Lemeshow chi2(8) & \multicolumn{2}{c}{`hl_c2s'} \\" _newline
file write fh "\quad Prob $>$ chi2 & \multicolumn{2}{c}{`hl_ps'} \\" _newline

file write fh "\midrule" _newline
file write fh "Aire sous la courbe ROC (AUC) & \multicolumn{2}{c}{`auc_str'} \\" _newline

* ========== FIN DU TABLEAU + NOTES ==========
file write fh "\bottomrule" _newline
file write fh "\multicolumn{3}{l}{\footnotesize \textbf{***} : significativit\'e au seuil de 1\% \quad \textbf{**} : au seuil de 5\% \quad \textbf{*} : au seuil de 10\% \quad \textbf{NS} : non significatif} \\" _newline
file write fh "\multicolumn{3}{l}{\footnotesize \textit{p $>$ z} : la p-value associ\'ee au test de Wald} \\" _newline
file write fh "\end{tabular}" _newline
file write fh "\end{table}"

file close fh

*======================================================================================================
** Analyses supplémentaires pour les differentes sections
*======================================================================================================

*======================================================================================================
* Création du barplot de classement des sous section concernant les infrastructures et equipements
*======================================================================================================

preserve
collapse (mean) inf_s_internet inf_s_mobilier inf_s_informatiq inf_s_immobilier
gen id = 1

reshape long inf_s_, i(id) j(variable) string
replace variable = "Internet" if variable == "internet"
replace variable = "Mobilier" if variable == "mobilier"
replace variable = "Informatique" if variable == "informatiq"
replace variable = "Immobilier" if variable == "immobilier"

graph hbar (mean) inf_s_, over(variable, sort(1) descending) ///
    ytitle("Score de satisfaction moyen") ///
    ylabel(1 "Très insatisfait" ///
                     2 "Insatisfait" ///
                     3 "Neutre" ///
                     4 "Satisfait" ///
                     5 "Très satisfait")
graph export "$FIGURES_QUESTION_5\bar_Comparaison.pdf", replace
restore

*======================================================================================================
* Analyses supplémentaire pour la question 4
*======================================================================================================
*======================================================================================================
* Scores pedagogiques selon l'etablissement
*======================================================================================================
* Graphique : boxplot par établissement
graph box score_ped, over(etb, sort(1)) ///
    title("Scores pédagogiques selon l'établissement") ///
    ytitle("Score moyen (1 à 5)")                     
graph export "$FIGURES_QUESTION_3\box_score_ped_etb.pdf", replace

* Test de Kruskal-Wallis
kwallis score_ped, by(etb)

* Post-hoc ciblé : Top 1er vs top 3 et  Flop 1er vs flop 3
* INSSA vs les autres
ranksum score_ped if inlist(etb,"INSSA","IUT"),   by(etb)
ranksum score_ped if inlist(etb,"INSSA","SEA"),   by(etb)
ranksum score_ped if inlist(etb,"INSSA","SHLAM"),   by(etb)
ranksum score_ped if inlist(etb,"INSSA","SJPEG"),   by(etb)
ranksum score_ped if inlist(etb,"INSSA","SVT"),   by(etb)

* SHLAM vs les autres
ranksum score_ped if inlist(etb,"SHLAM","ESI"),   by(etb)
ranksum score_ped if inlist(etb,"SHLAM","IDR"),   by(etb)
ranksum score_ped if inlist(etb,"SHLAM","IUT"),   by(etb)
ranksum score_ped if inlist(etb,"SHLAM","SVT"),   by(etb)
ranksum score_ped if inlist(etb,"SHLAM","INSSA"),   by(etb)


	
*=========================================================
* Scores pedagogiques selon le niveau d'étude
*=========================================================
 tabstat score_ped, by(niv_etd) stats(mean sd p25 p50 p75 n) format(%6.2f)
 esttab using "${TABLEAUX_QUESTION_3}\score_ped_niv_etd.tex", ///
    replace booktabs  ///
    cells("mean(fmt(2)) sd(fmt(2)) p25(fmt(2)) p50(fmt(2)) p75(fmt(2)) N(fmt(0))") ///
    nomtitle nonumber 

* Graphique : boxplot par établissement
graph box score_ped, over(niv_etd, sort(1)) ///
    title("Scores pédagogiques selon le niveau d'étude") ///
    ytitle("Score moyen (1 à 5)")                     
graph export "$FIGURES_QUESTION_3\box_score_ped_niv_etd.pdf", replace

*=========================================================
* Scores sociaux  par rapport aux établissements d'études 
*=========================================================
* Graphique : boxplot par rapport aux sites de collecte 
graph box score_soc, over(etb, sort(1)) ///
    title("Scores sociaux selon l'établissement d'études") ///
    ytitle("Score moyen (1 à 5)")                     
graph export "$FIGURES_QUESTION_4\box_score_soc_etb.pdf", replace

* Test de Kruskal-Wallis
kwallis score_soc, by(etb)

* Post-hoc ciblé : Top 1er vs top 3 et  Flop 1er vs flop 3
* INSSA vs les autres
ranksum score_soc if inlist(etb,"INSSA","IUT"),   by(etb)
ranksum score_soc if inlist(etb,"INSSA","SEA"),   by(etb)
ranksum score_soc if inlist(etb,"INSSA","SHLAM"),   by(etb)
ranksum score_soc if inlist(etb,"INSSA","IDR"),   by(etb)


* SHLAM vs les autres
ranksum score_soc if inlist(etb,"IUT","IDR"),   by(etb)
ranksum score_soc if inlist(etb,"IUT","SVT"),   by(etb)
ranksum score_soc if inlist(etb,"IUT","INSSA"),   by(etb)
ranksum score_soc if inlist(etb,"IUT","SJPEG"),   by(etb)

*=========================================================
* Scores sociaux selon le sexe
*=========================================================

* Graphique : boxplot par établissement
graph box score_ped, over(sexe, sort(1)) ///
    title("Scores sociaux par rapport au sexe") ///
    ytitle("Score moyen (1 à 5)")                     
graph export "$FIGURES_QUESTION_4\box_score_sociaux_sexe.pdf", replace

*===========================================================================================================================================================

*=========================================================
* Récupérer TOUTES les variables binaires (label "choix")
*=========================================================
local vars_binaires ""

foreach var of varlist _all {
    local value_lab : value label `var'
    if "`value_lab'" == "choix" {
        local vars_binaires `vars_binaires' `var'
    }
}

display "Variables binaires : `vars_binaires'"


*=========================================================
* Tableau synthèse : % "Oui" par affirmation, trié
*=========================================================

* --- Étape 1 : déclarer le tempfile et postfile ---
*
*    par tempname + postfile
tempfile resultats_binaires
tempname memhold

postfile `memhold'        ///
    str40  variable       ///
    str200 label_var      ///
    float  pct_oui        ///
    float  pct_non        ///
    using `resultats_binaires', replace


* --- Étape 2 : boucle sur toutes les variables binaires ---
foreach var of local vars_binaires {

    * Récupérer le label de la variable
    local var_lab : variable label `var'

    * Calculer le % de Oui (=100) et Non (=0)
    quietly count if `var' == 100 & `var' != .
    local n_oui = r(N)
    quietly count if `var' != .
    local n_total = r(N)

    if `n_total' > 0 {
        local pct = round((`n_oui' / `n_total') * 100, 0.1)
    }
    else {
        local pct = .
    }
    local pct_n = round(100 - `pct', 0.1)

    
    *    par une seule ligne post
    post `memhold' ("`var'") ("`var_lab'") (`pct') (`pct_n')
}

* — fermer le postfile avant d'utiliser les résultats
postclose `memhold'


* --- Étape 3 : ouvrir la base résultats, trier et exporter ---
preserve
    use `resultats_binaires', clear

    * Trier du mieux évalué au moins bien évalué
    gsort -pct_oui

    * Numéroter le classement
    gen rang = _n
    label var rang      "Rang"
    label var label_var "Service / Affirmation"
    label var pct_oui   "% Oui"
    label var pct_non   "% Non"

    * Nombre total de variables
    local total = _N

    * Garder uniquement les 2 meilleurs et 2 derniers
    keep if rang <= 2 | rang >= `total' - 1

    * Afficher dans la console
    list rang label_var pct_oui pct_non, sep(5) noobs

    * Exporter en LaTeX
    keep rang label_var pct_oui pct_non

* Ouvrir le fichier EN UTF-8
file open fout using "$TABLEAUX_QUESTION_7\synthese_evaluations.tex", ///
    write replace text

* En-tête
file write fout "\begin{tabular}{clcc}" _n
file write fout "\toprule" _n
file write fout "\rowcolor{couleurPrimaire!20}" _n
file write fout "\textbf{Rang} & \textbf{Service / Affirmation} & " ///
               "\textbf{\% Oui} & \textbf{\% Non} \\" _n
file write fout "\midrule" _n
* Remplir ligne par ligne
forvalues i = 1/`=_N' {
    local r   = rang[`i']
    local lab = label_var[`i']
    local oui = pct_oui[`i']
    local non = pct_non[`i']
    file write fout "`r' & `lab' & `oui' & `non' \\" _n
}

* Pied
file write fout "\bottomrule" _n
file write fout "\end{tabular}" _n

file close fout
display "Export réussi !"
restore

*Sauvegarde la base
save "$PROJET\data\Base.dta", replace

log close
