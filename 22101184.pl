% =========================================
% UMRAH KNOWLEDGE BASE
% Topic: Umrah Guide
% =========================================


% =========================================
% SECTION 1: PLACES
% =========================================

% place(Name, Location, Category, Description)
place(masjid_al_haram, makkah, mosque, 'The Grand Mosque, holiest site in Islam').
place(kaaba, inside_masjid_al_haram, structure, 'The cubic structure, Qibla of all Muslims').
place(hateem, inside_masjid_al_haram, area, 'Semicircular area adjacent to Kaaba, part of original Kaaba').
place(zamzam_well, inside_masjid_al_haram, well, 'Sacred well, water blessed by Allah').
place(safa, inside_masjid_al_haram, hill, 'Starting point of Saee, where Hajar (AS) began her search').
place(marwa, inside_masjid_al_haram, hill, 'Ending point of Saee, where Hajar (AS) found water').
place(meeqat, boundary_of_makkah, boundary, 'Designated boundary where pilgrims enter Ihram').
place(masjid_aisha, makkah, mosque, 'Nearest Meeqat for residents of Makkah, used for renewing Ihram').

% Rules
holy_place(X) :- place(X, _, _, _).
inside_haram(X) :- place(X, inside_masjid_al_haram, _, _).
place_description(X, D) :- place(X, _, _, D).
place_category(X, C) :- place(X, _, C, _).


% =========================================
% SECTION 2: RITUALS IN SEQUENCE
% =========================================

% ritual(StepNumber, Name, Description)
ritual(1, enter_ihram, 'Make intention and wear Ihram garments at Meeqat').
ritual(2, talbiyah, 'Recite Talbiyah loudly: Labbayk Allahumma Labbayk').
ritual(3, enter_makkah, 'Enter Makkah with right foot, recite dua of entering').
ritual(4, tawaf, 'Circumambulate the Kaaba 7 times counterclockwise').
ritual(5, two_rakah_prayer, 'Offer 2 rakah prayer near Maqam Ibrahim after Tawaf').
ritual(6, drink_zamzam, 'Drink Zamzam water and make dua').
ritual(7, saee, 'Walk between Safa and Marwa 7 times').
ritual(8, halq_or_taqsir, 'Shave head (halq) or shorten hair (taqsir) to exit Ihram').

% Rules
next_ritual(X, Y) :-
    ritual(N, X, _),
    N1 is N + 1,
    ritual(N1, Y, _).

previous_ritual(X, Y) :-
    ritual(N, X, _),
    N1 is N - 1,
    ritual(N1, Y, _).

ritual_description(X, D) :- ritual(_, X, D).
first_ritual(X) :- ritual(1, X, _).
last_ritual(X) :- ritual(8, X, _).


% =========================================
% SECTION 3: IHRAM RULES ENGINE
% =========================================

% allowed_in_ihram(Action, Reason)
allowed_in_ihram(recite_quran, 'Recitation of Quran is encouraged in Ihram').
allowed_in_ihram(make_dua, 'Supplication to Allah is highly recommended').
allowed_in_ihram(wear_sandals, 'Open sandals are permitted in Ihram').
allowed_in_ihram(use_umbrella, 'Using umbrella for shade is allowed').
allowed_in_ihram(bathe_without_soap, 'Bathing is allowed but without scented soap').
allowed_in_ihram(change_ihram_cloth, 'Changing to clean Ihram garments is permitted').
allowed_in_ihram(wear_ring, 'Wearing a plain ring is allowed').
allowed_in_ihram(use_miswak, 'Using miswak for dental hygiene is permitted').

% forbidden_in_ihram(Action, Reason)
forbidden_in_ihram(use_perfume, 'Perfume or scented products are strictly forbidden').
forbidden_in_ihram(cut_hair, 'Cutting or shaving hair is forbidden until Ihram ends').
forbidden_in_ihram(cut_nails, 'Trimming nails is forbidden in state of Ihram').
forbidden_in_ihram(hunt_animals, 'Hunting or harming animals is strictly forbidden').
forbidden_in_ihram(wear_stitched_clothing, 'Men must not wear stitched clothing in Ihram').
forbidden_in_ihram(cover_head, 'Men must not cover their head in Ihram').
forbidden_in_ihram(engage_in_relations, 'Marital relations are strictly forbidden').
forbidden_in_ihram(argue_or_fight, 'Quarreling and fighting are forbidden in Ihram').
forbidden_in_ihram(uproot_plants, 'Uprooting or cutting plants in Haram is forbidden').

% Rules
is_allowed(X) :- allowed_in_ihram(X, _).
is_forbidden(X) :- forbidden_in_ihram(X, _).

ihram_rule(X, allowed, R) :- allowed_in_ihram(X, R).
ihram_rule(X, forbidden, R) :- forbidden_in_ihram(X, R).

check_action(X) :-
    allowed_in_ihram(X, R),
    write('ALLOWED: '), write(R), nl.
check_action(X) :-
    forbidden_in_ihram(X, R),
    write('FORBIDDEN: '), write(R), nl.
check_action(X) :-
    \+ allowed_in_ihram(X, _),
    \+ forbidden_in_ihram(X, _),
    write('Action not found in knowledge base.'), nl.

% =========================================
% SECTION 4: DUA KNOWLEDGE BASE
% =========================================

% dua(Occasion, Arabic, Meaning)
dua(talbiyah, 'Labbayk Allahumma Labbayk, Labbayk La Sharika Laka Labbayk', 'Here I am O Allah, here I am, You have no partner').
dua(during_tawaf, 'Rabbana atina fid dunya hasanatan', 'Our Lord give us good in this world and good in the hereafter').
dua(at_hateem, 'Allahumma innaka afuwwun tuhibbul afwa fafu anni', 'O Allah You are forgiving and love forgiveness so forgive me').
dua(drinking_zamzam, 'Allahumma inni asaluka ilman nafia', 'O Allah I ask You for beneficial knowledge and wide sustenance').
dua(starting_saee, 'Inna as-Safa wal Marwata min shaairillah', 'Indeed Safa and Marwa are among the symbols of Allah').
dua(on_safa, 'Allahu Akbar, Allahu Akbar, Allahu Akbar', 'Allah is the Greatest, said three times facing Kaaba').
dua(on_marwa, 'Allahu Akbar, Allahu Akbar, Allahu Akbar', 'Allah is the Greatest, said three times facing Kaaba').

% Rules
dua_for(Occasion, Arabic, Meaning) :- dua(Occasion, Arabic, Meaning).

show_dua(Occasion) :-
    dua(Occasion, Arabic, Meaning),
    write('Occasion : '), write(Occasion), nl,
    write('Arabic   : '), write(Arabic), nl,
    write('Meaning  : '), write(Meaning), nl.

show_dua(Occasion) :-
    \+ dua(Occasion, _, _),
    write('No dua found for this occasion.'), nl.

all_dua_occasions(X) :- dua(X, _, _).

% =========================================
% SECTION 5: PILGRIM ADVISOR
% =========================================
% pilgrim(Name, Gender, Condition)
pilgrim(ahmed, male, healthy).
pilgrim(fatima, female, healthy).
pilgrim(ibrahim, male, elderly).
pilgrim(maryam, female, pregnant).
pilgrim(yusuf, male, disabled).
% Rules for guidance based on gender and condition
guidance(Name, 'Perform all rituals in full sequence.') :-
    pilgrim(Name, male, healthy).
guidance(Name, 'Perform all rituals in full sequence. Do not cover hands in Ihram.') :-
    pilgrim(Name, female, healthy).
guidance(Name, 'You may perform Tawaf and Saee by wheelchair. ') :-
    pilgrim(Name, _, elderly).
guidance(Name, 'Consult a doctor before performing Umrah. Tawaf can be done at outer areas. Rest frequently.') :-
    pilgrim(Name, female, pregnant).
guidance(Name, 'Wheelchair Tawaf is fully valid. You may appoint someone to assist with Saee. All rituals count.') :-
    pilgrim(Name, _, disabled).
% Gender specific Ihram rules
ihram_clothing(male, 'Two unstitched white cloths, no head covering, no stitched clothing').
ihram_clothing(female, 'Normal modest clothing, face and hands must remain uncovered').
% Rules
show_guidance(Name) :-
    guidance(Name, G),
    pilgrim(Name, Gender, Condition),
    write('Pilgrim   : '), write(Name), nl,
    write('Gender    : '), write(Gender), nl,
    write('Condition : '), write(Condition), nl,
    write('Guidance  : '), write(G), nl.
show_guidance(Name) :-
    \+ pilgrim(Name, _, _),
    write('Pilgrim not found in knowledge base.'), nl.
show_ihram_clothing(Gender) :-
    ihram_clothing(Gender, Rule),
    write('Gender  : '), write(Gender), nl,
    write('Clothing: '), write(Rule), nl.
all_pilgrims(Name, Gender, Condition) :- pilgrim(Name, Gender, Condition).