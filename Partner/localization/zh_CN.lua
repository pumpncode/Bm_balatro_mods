return {
    descriptions = {
        Partner={
            pnr_partner_joker={
                name = "金宝伙伴",
                text = {
                    "每次出牌",
                    "获得{C:chips}+#2#{}筹码",
                    "{C:inactive}（当前{C:chips}+#1#{C:inactive}筹码）",
                },
                unlock={
                    "使用{C:attention}小丑",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_mime={
                name = "哑剧伙伴",
                text = {
                    "令手中{C:attention}第一张{}牌",
                    "额外触发{C:attention}#1#{}次",
                },
                unlock={
                    "使用{C:attention}哑剧演员",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_raised_fist={
                name = "拳头伙伴",
                text = {
                    "打出牌包含{C:attention}对子{}时",
                    "令手中点数{C:attention}最小{}牌",
                    "给予{C:mult}+#1#{}倍率",
                },
                unlock={
                    "使用{C:attention}致胜之拳",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_egg={
                name = "鸡蛋伙伴",
                text = {
                    "回合结束时",
                    "令拥有的所有{C:attention}小丑{}",
                    "{C:attention}售价{}增加{C:money}$#1#{}",
                },
                unlock={
                    "使用{C:attention}鸡蛋",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_burglar={
                name = "窃贼伙伴",
                text = {
                    "选择{C:attention}Boss盲注{}后",
                    "出牌次数{C:blue}+#1#{}",
                },
                unlock={
                    "使用{C:attention}窃贼",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_faceless={
                name = "无面伙伴",
                text = {
                    "每弃掉一张{C:attention}人头牌{}",
                    "获得{C:money}$#1#{}",
                },
                unlock={
                    "使用{C:attention}无面小丑",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_hallucination={
                name = "幻觉伙伴",
                text = {
                    "令{C:attention}补充包{}增加",
                    "额外的{C:planet}星球牌{}选项",
                },
                unlock={
                    "使用{C:attention}幻觉",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_fortune_teller={
                name = "占卜伙伴",
                text = {
                    "每经过{C:attention}#2#{C:inactive}[#1#]{}个回合",
                    "额外上架{C:attention,T:p_arcana_normal_1}秘术包{}",
                },
                unlock={
                    "使用{C:attention}占卜师",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_golden={
                name = "黄金伙伴",
                text = {
                    "回合结束时",
                    "获得{C:money}$#1#{}",
                },
                unlock={
                    "使用{C:attention}黄金小丑",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_baseball={
                name = "棒球伙伴",
                text = {
                    "令所有{C:green}罕见{}小丑",
                    "给予{C:mult}+#1#{}倍率",
                },
                unlock={
                    "使用{C:attention}棒球卡",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_trading={
                name = "交易伙伴",
                text = {
                    "每回合{C:attention}最后一次{}弃牌",
                    "若只有一张牌",
                    "消耗{C:money}$#1#{}将其摧毁",
                },
                unlock={
                    "使用{C:attention}交易卡",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_flash={
                name = "闪示伙伴",
                text = {
                    "令重掷的{C:attention}第一张{}牌",
                    "变为{C:dark_edition,T:e_negative}负片{}",
                },
                unlock={
                    "使用{C:attention}闪示卡",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_throwback={
                name = "回溯伙伴",
                text = {
                    "单次{X:mult,C:white}X#1#{}倍率",
                    "点击消耗{C:money}$#2#{}",
                },
                unlock={
                    "使用{C:attention}回溯",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_hanging_chad={
                name = "选票伙伴",
                text = {
                    "令{C:attention}第一张{}计分牌",
                    "额外触发{C:attention}#1#{}次",
                },
                unlock={
                    "使用{C:attention}未断选票",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_bloodstone={
                name = "血石伙伴",
                text = {
                    "令第一张{C:hearts}红桃{}计分牌",
                    "给予{X:mult,C:white}X#1#{}倍率",
                },
                unlock={
                    "使用{C:attention}血石",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
            pnr_partner_burnt={
                name = "烧焦伙伴",
                text = {
                    "{C:green}#1#/#2#{}几率升级",
                    "弃掉的{C:attention}牌型等级{}",
                },
                unlock={
                    "使用{C:attention}烧焦小丑",
                    "在{C:attention}金注",
                    "难度下获胜",
                },
            },
        },
        Other={
            partner_benefits={
                name="伙伴增益",
                text={
                    "{C:dark_edition,s:0.9}<增益中>",
                },
            },
        },
    },
    misc={
        dictionary={
            b_partners="伙伴",
            b_partner_agree="选择伙伴",
            b_partner_refuse="无伙伴模式",
            k_partner="伙伴",
            k_enable_partner="启用伙伴",
            ml_partner_unique_ability={
                "小丑可能会强化",
                "对应伙伴的能力",
            },
        },
    },
}