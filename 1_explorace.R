library(czso)
library(statnipokladna)
library(dplyr)
library(ggplot2)
library(tidyr)
library(forcats)
library(ggiraph)
library(nanoparquet)

# Nastavení ---------------------------------------------------------------

# Kam se ukládají stažené soubory
options(czso.dest_dir = "data-input/czso")
options(statnipokladna.dest_dir = "data-input/statnipokladna")

# nepoužívat exponenciální zobrazení čísel
options(scipen = 99)

# Prozkoumat katalog ČSÚ --------------------------------------------------

# Otevřená data v katalogu ČSÚ:
# https://csu.gov.cz/otevrena-data-v-katalogu-produktu-csu?pocet=10&start=0&vlastnostiVystupu=22&pouzeVydane=true&razeni=-datumVydani

czso_kat <- czso_get_catalogue()
czso_kat |>
  czso_filter_catalogue(c("vazba", "obec", "orp")) |>
  select(description, dataset_id, title)

czso_get_catalogue(c("skot")) |> select(title, dataset_id, description)
czso_get_catalogue(c("hrubý domácí")) |> select(title, dataset_id, description)
czso_get_catalogue(c("pohyb obyv")) |> select(title, dataset_id, description)

czso_kat |>
  czso_filter_catalogue(c("struktura", "území")) |>
  select(description, dataset_id, title)

czso_obce_poctyobyv <- czso_get_table("130141r24")

# Číselníky a další metainformace v databázi ČSÚ
# https://apl2.czso.cz/iSMS/

obce_cis <- czso_get_codelist("cis43")
obce_cis
obce_vaz_kraj <- czso_get_codelist("cis108vaz43")
obce_vaz_kraj
orp_vaz_kraj <- czso_get_codelist("cis108vaz65")
orp_vaz_kraj

obce_vaz_orp_centrum <- czso_get_codelist("cis43vaz65")
obce_vaz_orp_centrum
obce_vaz_orp <- czso_get_codelist("cis65vaz43")
obce_vaz_orp

# Katalog státní pokladny

statnipokladna::sp_codelists
statnipokladna::sp_datasets
statnipokladna::sp_tables

rozp_praha <- sp_get_table("budget-local", year = 2023, month = 12, ico = "00064581")
rozp_msmt <- sp_get_table("budget-central", year = 2023, month = 12, ico = "00022985")

rozp_msmt |>
  sp_add_codelist("polozka") |>
  filter(seskupeni == "Výdaje na platy a obdobné a související výdaje") |>
  count(podseskupeni, wt = budget_spending)
