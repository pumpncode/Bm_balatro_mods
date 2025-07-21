--- STEAMODDED HEADER
--- MOD_NAME: Bmportable_misprint
--- MOD_ID: Bmportable_misprint
--- MOD_AUTHOR: [BaiMao Brookling]
--- MOD_DESCRIPTION: More convenient to view misprinted information
--- BADGE_COLOUR: 366999
--- VERSION: 1.0.1c
----------------------------------------------
------------MOD CODE -------------------------

function SMODS.current_mod.process_loc_text()
    G.localization.misc.dictionary = G.localization.misc.dictionary or {}
end

local Game_update_ref = Game.update
function Game:update(dt)
    Game_update_ref(self, dt)
    G.GAME.misprint_rank = G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.value or nil
    G.GAME.misprint_suit = G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit or nil
end

local G_UIDEF_deck_preview_ref = G.UIDEF.deck_preview
function G.UIDEF.deck_preview(args)
    local _minh, _minw = 0.35, 0.5
    local _colour = ((G.GAME.misprint_suit == 'Spades' or G.GAME.misprint_suit == 'Clubs') and G.C.WHITE or G.C.RED)
    local t = G_UIDEF_deck_preview_ref(args)
    local suit_labels = t.nodes[1].nodes[1].nodes[1].nodes
    local tt = {n=G.UIT.R, config={align = "cm", r = 0.1, padding = 0.04, minw = _minw, minh = 2*_minh+0.25}, nodes={
        G.GAME.misprint_rank and {n=G.UIT.T, config={text = localize('b_next')..': ', colour = G.C.WHITE, scale = 0.25, shadow = true}} or nil,
        G.GAME.misprint_suit and {n=G.UIT.T, config={text = localize(G.GAME.misprint_suit, 'suits_singular')..' '..localize(G.GAME.misprint_rank, 'ranks'), colour = _colour, scale = 0.25, shadow = true}} or nil,
    }}
    suit_labels[1] = tt
    return t
end

function G.UIDEF.current_stake()
    local rows_per_page = 1
    local cols_per_page = 1
    local bosses_options = {}
    local deck_tables = {}
    G.GAME.history_hands = G.GAME.history_hands or {}
    G.GAME.history_hands_long = next(G.GAME.history_hands) and #G.GAME.history_hands+0.9
    G.your_collection = {}
    G.your_boss = {}
    for k, v in pairs(G.P_BLINDS) do
        if v.boss and G.GAME.bosses_used[k] and G.GAME.bosses_used[k] > 0 then
            table.insert(G.your_boss, k)
        end
    end
    table.sort(G.your_boss, function (a, b) return G.GAME.bosses_used[a] > G.GAME.bosses_used[b] end)
    if next(G.your_boss) then
        if #G.your_boss >= 6 then cols_per_page = 6
        else cols_per_page = #G.your_boss end
    end
    for j = 1, rows_per_page do
        local row = {n=G.UIT.R, config={colour = G.C.LIGHT}, nodes={}}
        for i = 1, cols_per_page do
            G.your_collection[i+(j-1)*4] = CardArea(G.ROOM.T.x, G.ROOM.T.h, G.CARD_W/1.3, G.CARD_W/1.3, {card_limit = 2, type = "title", highlight_limit = 0})
            table.insert(row.nodes, {n=G.UIT.O, config={object = G.your_collection[i+(j-1)*4]}})
        end
        table.insert(deck_tables, row)
    end
    for i = 1, math.ceil(#G.your_boss/(#G.your_collection)) do
        table.insert(bosses_options, localize("k_page").." "..tostring(i).."/"..tostring(math.ceil(#G.your_boss/(#G.your_collection))))
    end
    for j = 1, #G.your_collection do
        local center = G.P_BLINDS[G.your_boss[j]]
        if not center then break end
        local temp_blind = AnimatedSprite(G.your_collection[j].T.x, G.your_collection[j].T.y, G.CARD_W/1.5, G.CARD_W/1.5, G.ANIMATION_ATLAS[center.atlas or 'blind_chips'], center.pos)
        local card = Card(G.your_collection[j].T.x, G.your_collection[j].T.y, G.CARD_W/1.5, G.CARD_W/1.5, G.P_CARDS.empty, G.P_CENTERS.c_base)
        card.children.center = temp_blind
        card.config.blind = center
        temp_blind:set_role({major = card, role_type = 'Glued', draw_major = card})
        temp_blind:define_draw_steps({{shader = 'dissolve', shadow_height = 0.05}, {shader = 'dissolve'}})
        temp_blind.float = true
        card.set_sprites = function(...)
            local c = card.children.center
            Card.set_sprites(...)
            card.children.center = c
        end
        card.hover = function()
            if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
                if not card.hovering and card.states.visible then
                    card.hovering = true
                    card.hover_tilt = 3
                    card:juice_up(0.05, 0.02)
                    play_sound('chips1', math.random() * 0.1 + 0.55, 1.2)
                    card.config.h_popup = create_UIBox_blind_popup(center, true)
                    card.config.h_popup_config = card:align_h_popup()
                    Node.hover(card)
                end
            end
            card.stop_hover = function()
                card.hovering = false
                Node.stop_hover(card)
                card.hover_tilt = 0
            end
        end
        if G.GAME.bosses_used[G.your_boss[j]] >= 5 then
            card:set_edition({negative = true}, true)
        elseif G.GAME.bosses_used[G.your_boss[j]] >= 4 then
            card:set_edition({polychrome = true}, true)
        elseif G.GAME.bosses_used[G.your_boss[j]] >= 3 then
            card:set_edition({holo = true}, true)
        elseif G.GAME.bosses_used[G.your_boss[j]] >= 2 then
            card:set_edition({foil = true}, true)
        end
        G.your_collection[j]:emplace(card)
    end
    G.current_history = {}
    local rows_per_page_2 = 0
    local minus = 0
    if next(G.GAME.history_hands) then
        if #G.GAME.history_hands >= 4 then rows_per_page_2 = 4
        else rows_per_page_2 = #G.GAME.history_hands end
    end
    for j = 1, rows_per_page_2 do
        table.insert(G.current_history, create_UIBox_history_hand_row(G.GAME.history_hands[#G.GAME.history_hands-minus]))
        minus = minus + 1
    end
    INIT_COLLECTION_CARD_ALERTS()
    local t = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.O, config={object = DynaText({string = {localize('ph_boss_hands')}, colours = {G.C.UI.TEXT_LIGHT}, bump = true, scale = 0.6})}}
        }},
        {n=G.UIT.R, config={align = "cm", minh = 0.5}, nodes={}},
        {n=G.UIT.R, config={align = "cm", colour = G.C.BLACK, r = 0.1, padding = 0.1, emboss = 0.05}, nodes={
            {n=G.UIT.R, config={align = "cm"}, nodes=deck_tables},
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
            create_option_cycle({options = bosses_options, w = 3, cycle_shoulders = true, opt_callback = 'used_boss_page', focus_args = {snap_to = true, nav = 'wide'}, current_option = 1, colour = G.C.RED, no_pips = true})
        }},
        next(G.GAME.history_hands) and {n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes={
            {n=G.UIT.O, config={id = math.floor(G.GAME.history_hands_long), func = "ROLL_history_hands", object = UIBox{definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes=G.current_history}}}, config = {offset = {x=0,y=0}}}}}
        }} or nil,
        next(G.GAME.history_hands) and #G.GAME.history_hands > 4 and {n=G.UIT.R, config={align = "cm"}, nodes={
            create_history_slider({w = 6, h = 0.4, ref_table = G.GAME, ref_value = 'history_hands_long', min = 4, max = #G.GAME.history_hands+0.9})
        }} or nil
    }}
    return t
end

G.FUNCS.used_boss_page = function(args)
    if not args or not args.cycle_config then return end
    for j = 1, #G.your_collection do
        for i = #G.your_collection[j].cards, 1, -1 do
            local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
            c:remove()
            c = nil
        end
    end
    for j = 1, #G.your_collection do
        local center = G.P_BLINDS[G.your_boss[j+(#G.your_collection*(args.cycle_config.current_option-1))]]
        if not center then break end
        local temp_blind = AnimatedSprite(G.ROOM.T.x+G.ROOM.T.w/2.5, G.your_collection[j].T.y, G.CARD_W/1.5, G.CARD_W/1.5, G.ANIMATION_ATLAS[center.atlas or 'blind_chips'], center.pos)
        local card = Card(G.ROOM.T.x+G.ROOM.T.w/2.5, G.your_collection[j].T.y, G.CARD_W/1.5, G.CARD_W/1.5, G.P_CARDS.empty, G.P_CENTERS.c_base)
        card.children.center = temp_blind
        card.config.blind = center
        temp_blind:set_role({major = card, role_type = 'Glued', draw_major = card})
        temp_blind:define_draw_steps({{shader = 'dissolve', shadow_height = 0.05}, {shader = 'dissolve'}})
        temp_blind.float = true
        card.set_sprites = function(...)
            local c = card.children.center
            Card.set_sprites(...)
            card.children.center = c
        end
        card.hover = function()
            if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
                if not card.hovering and card.states.visible then
                    card.hovering = true
                    card.hover_tilt = 3
                    card:juice_up(0.05, 0.02)
                    play_sound('chips1', math.random() * 0.1 + 0.55, 1.2)
                    card.config.h_popup = create_UIBox_blind_popup(center, true)
                    card.config.h_popup_config = card:align_h_popup()
                    Node.hover(card)
                end
            end
            card.stop_hover = function()
                card.hovering = false
                Node.stop_hover(card)
                card.hover_tilt = 0
            end
        end
        if G.GAME.bosses_used[G.your_boss[j+(#G.your_collection*(args.cycle_config.current_option-1))]] >= 5 then
            card:set_edition({negative = true}, true)
        elseif G.GAME.bosses_used[G.your_boss[j+(#G.your_collection*(args.cycle_config.current_option-1))]] >= 4 then
            card:set_edition({polychrome = true}, true)
        elseif G.GAME.bosses_used[G.your_boss[j+(#G.your_collection*(args.cycle_config.current_option-1))]] >= 3 then
            card:set_edition({holo = true}, true)
        elseif G.GAME.bosses_used[G.your_boss[j+(#G.your_collection*(args.cycle_config.current_option-1))]] >= 2 then
            card:set_edition({foil = true}, true)
        end
        G.your_collection[j]:emplace(card)
    end
    INIT_COLLECTION_CARD_ALERTS()
end

function create_UIBox_history_hand_row(args)
    local t = {n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.1, colour = darken(G.C.JOKER_GREY, 0.1), emboss = 0.05, hover = true, force_focus = true, on_demand_tooltip = {filler = {func = create_UIBox_history_hand_tip, args = args}}}, nodes={
        {n=G.UIT.C, config={align = "cl", padding = 0, minw = 4.5}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.HAND_LEVELS[math.min(7, args.level)], minw = 1.5, outline = 0.8, outline_colour = G.C.WHITE}, nodes={
                {n=G.UIT.T, config={text = localize('k_level_prefix')..args.level, scale = 0.5, colour = G.C.UI.TEXT_DARK}}
            }},
            {n=G.UIT.C, config={align = "cm", minw = 3}, nodes={
                {n=G.UIT.T, config={text = ' '..args.disp_handname, scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
            }}
        }},
        {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.BLACK, r = 0.1}, nodes={
            {n=G.UIT.C, config={align = "cr", padding = 0.01, r = 0.1, colour = G.C.CHIPS, minw = 1.5, maxw = 1.5}, nodes={
                {n=G.UIT.T, config={text = number_format(args.chips, 1000000), lang = G.LANGUAGES['en-us'], scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
                {n=G.UIT.B, config={w = 0.08, h = 0.01}}
            }},
            {n=G.UIT.T, config={text = "X", scale = 0.45, colour = G.C.MULT}},
            {n=G.UIT.C, config={align = "cl", padding = 0.01, r = 0.1, colour = G.C.MULT, minw = 1.5, maxw = 1.5}, nodes={
                {n=G.UIT.B, config={w = 0.08, h = 0.01}},
                {n=G.UIT.T, config={text = number_format(args.mult, 1000000), lang = G.LANGUAGES['en-us'], scale = 0.45, colour = G.C.UI.TEXT_LIGHT}}
            }}
        }},
        {n=G.UIT.C, config={align = "cm"}, nodes={{n=G.UIT.B, config = {w = 0.1, h = 0.1}}}},
        {n=G.UIT.C, config={align = "cm", minw = 2.5, maxw = 2.5, r = 0.1, colour = G.C.DYN_UI.BOSS_DARK}, nodes={
            {n=G.UIT.O, config={w = 0.4, h = 0.4, object = get_stake_sprite(G.GAME.stake or 1, 0.5), hover = true, can_collide = false}},
            {n=G.UIT.B, config={w = 0.08, h = 0.01}},
            {n=G.UIT.T, config={text = number_format(args.chip_total, 10000000), lang = G.LANGUAGES['en-us'], scale = 0.5, colour = args.filter and G.C.FILTER or G.C.WHITE, shadow = true}}
        }}
    }}
    return t
end

function create_UIBox_history_hand_tip(args)
    local cardarea = CardArea(2, 2, 3.5*G.CARD_W, 0.75*G.CARD_H, {card_limit = 5, type = 'title', highlight_limit = 0})
    for k, v in ipairs(args.cards) do
        local card = Card(0, 0, 0.5*G.CARD_W, 0.5*G.CARD_H, G.P_CARDS[v.suit_rank], G.P_CENTERS[v.enhancement or 'c_base'])
        if v.edition then card:set_edition(v.edition, true, true) end
        if v.seal then card:set_seal(v.seal, true, true) end
        if v.score then card:juice_up(0.3, 0.2) end
        if k == 1 then play_sound('paper1',0.95 + math.random()*0.1, 0.3) end
        ease_value(card.T, 'scale', v.score and 0.25 or -0.15, nil, 'REAL', true, 0.2)
        cardarea:emplace(card)
    end
    return {n=G.UIT.R, config={align = "cm", colour = G.C.WHITE, r = 0.1}, nodes={
        {n=G.UIT.C, config={align = "cm"}, nodes={
            {n=G.UIT.O, config={object = cardarea}}
        }}
    }}
end

function create_history_slider(args)
    args = args or {}
    args.colour = args.colour or G.C.BLUE
    args.w = args.w or 1
    args.h = args.h or 0.5
    args.min = args.min or 0
    args.max = args.max or 1
    args.decimal_places = args.decimal_places or 0
    args.text = string.format("%."..tostring(args.decimal_places).."f", args.ref_table[args.ref_value])
    local startval = args.w*(args.ref_table[args.ref_value] - args.min)/(args.max - args.min)
    local t = {n=G.UIT.C, config={align = "cm", minw = args.w, min_h = args.h, padding = 0.1, r = 0.1, colour = G.C.CLEAR, focus_args = {type = 'slider'}}, nodes={
        {n=G.UIT.C, config={align = "cl", minw = args.w, r = 0.1, min_h = args.h, collideable = true, hover = true, colour = G.C.BLACK, emboss = 0.05, func = 'slider', refresh_movement = true}, nodes={
            {n=G.UIT.B, config={w = startval, h = args.h, r = 0.1, colour = args.colour, ref_table = args, refresh_movement = true}},
        }},
    }}
    return t
end

G.FUNCS.ROLL_history_hands = function(e)
    if e.config.object and math.floor(G.GAME.history_hands_long) ~= e.config.id then
        G.current_history = {}
        local minus = 0
        for j = 1, 4 do
            table.insert(G.current_history, create_UIBox_history_hand_row(G.GAME.history_hands[math.floor(G.GAME.history_hands_long)-minus]))
            minus = minus + 1
        end
        e.config.object:remove()
        e.config.object = UIBox{definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes=G.current_history}}}, config = {offset = {x=0,y=0}, parent = e}}
        e.config.id = math.floor(G.GAME.history_hands_long)
    end
end

----------------------------------------------
------------MOD CODE END----------------------