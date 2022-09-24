# Wprowadzenie do Infrastruktury Klucza Publicznego (PKI)

Repozytorium zawiera materiały z warsztatu [Stacja.IT](https://stacja.it/).

**UWAGA** Klucze, certyfikaty i skrypty w poniższym repozytorium są wyłącznie
testowe, **nie wolno** używać ich do innych zastosowań poza warsztatem 💣!

## Przygotowanie do warsztatu

Środowisko najlepiej przygotować i sprawdzić **przed** warsztatem, nie będzie to
elementem spotkania.

Do wykonania ćwiczeń będzie potrzebna przeglądarka, XCA i OpenSSL. Będę pracował
[w systemie Windows](https://www.statista.com/statistics/268237/global-market-share-held-by-operating-systems-since-2009/),
ale narzędzia są dostępne w wielu dystrybucjach Linux i dla macOS.

Podczas warsztatu będę używał przeglądarki [Firefox](https://www.mozilla.org/),
ponieważ ma wydzielone repozytorium certyfikatów (dotyczy to w szczególności
systemu Windows) dlatego zachęcam, aby również używać właśnie jej. Czasem
trzeba będzie ją zrestartować. Jeśli ktoś bierze udział w warsztacie poprzez
przeglądarkę to najwygodniej będzie użyć innej do tego celu.

**Użytkownicy Windows**: gotowa paczka z narzędziami i skryptami z tego
repozytorium (bez przeglądarki) używanymi podczas warsztatu jest udostępniona
[tutaj](https://drive.google.com/drive/folders/1DDI8bwX0IW32K90wSJr22Pmt4R0oHm0a?usp=sharing).
Wystarczy ją pobrać i rozpakować w dowolne miejsce, najlepiej takie, aby
katalogi nie zawierały spacji w nazwie. To wszystko, można jeszcze wykonać test
z punktu poniżej. Jeśli OpenSSL nie będzie działał należy zainstalować Microsoft
Visual C++ Redistributable. Instalator jest w paczce w katalogu `vc` lub na
stronach Microsoftu (link poniżej).

Jeśli ktoś korzysta z innego systemu lub chce pobrać aplikacje samodzielnie to
podczas warsztatu będziemy używać:

- XCA: <https://hohnstaedt.de/xca/index.php/download>, będę używał wersji 2.4.0;
  dla Windows można pobrać  wersję typu *portable*; XCA jest również dostępna
  jako paczka dla wielu dystrybucji Linuxa i w Homebrew (najczęściej pod nazwą
  `xca`)
- OpenSSL: <https://www.openssl.org/>, będę używał wersji 1.1.1q, jest obecnie
  najbardziej dostępna w dystrybucjach Linuxa (najczęściej jako `openssl`);
  wersję binarną dla Windows można znaleźć pod
  <https://kb.firedaemon.com/support/solutions/articles/4000121705>, wymaga ona
  zainstalowanych pakietów Microsoft Visual C++ Redistributable (instalator jest
  zawarty w archiwum lub dostępny tutaj
  <https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist>)
- skrypty z tego repozytorium: są to polecenia OpenSSL do uruchomienia np.
  testowego serwera; można je sklonować lub pobrać jako archiwum pod przyciskiem
  `Code`

### Test

XCA jest aplikacją graficzną. Można sprawdzić czy bez problemu się uruchamia
poleceniem `xca`.

Działanie OpenSSL można sprawdzić wywołując komendę w linii komend (w środowisku
warsztatowym Windows linię komend można uruchomić skryptem `workspace.cmd`)

    $ openssl version

wynikiem będzie

    OpenSSL 1.1.1q  5 Jul 2022

oraz uruchamiając testowy serwer (pewnie wyskoczy okienko firewall, ponieważ
serwer otwiera port 8443)

    $ openssl s_server -cert localhost.crt -key localhost.pem -www -port 8443
    Using default temp DH parameters
    ACCEPT

W przeglądarce pod adresem <https://localhost:8443> powinna pokazać się strona
ostrzegająca o zagrożeniu bezpieczeństwa. Oczywiście **nie kontynuujemy** 😉

Jeśli wynik jest inny to niewykluczone, że jakaś aplikacja działa już na porcie
8443 i na czas warsztatu można ją zatrzymać lub zmienić port w poleceniu.

Działanie serwera przerywamy za pomocą `Ctrl+C` lub `Ctrl+Break/Pause` lub
`Ctrl+Fn+P` lub innej kombinacji do przerwania działania polecenia w konsoli.

## Warsztat

Za pomocą XCA przygotowujemy CA oraz klucze (obecnie zalecane w kontekście TLS
i przeglądarek to ECDSA z krzywymi P-256 lub P-384 oraz RSA z kluczem co
najmniej 3072 bit) i certyfikaty dla:

- serwera TLS
- klienta TLS
- serwera OCSP

Przeznaczenie skryptów (z rozszerzeniem `bat` lub `sh`) jest następujące:

- `tls-server`, `tls-server-8443`, `tls-server-1_2`, `tls-server-8443-1_2` -
  serwer TLS w domyślnej wersji (najczęściej 1.3) na porcie 443 lub 8443
  i analogicznie serwer TLS 1.2 na wymienionych portach
- `tls-server-client-auth`, `tls-server-client-auth-8443` -
  serwer TLS w domyślnej wersji (najczęściej 1.3) na porcie 443 lub 8443
  z uwierzytelnieniem klienta
- `ocsp-responder-valid` - serwer OCSP na porcie 8888 z plikiem `index-valid.txt`
- `ocsp-responder` - serwer OCSP na porcie 8888 z plikiem `index.txt`

