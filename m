Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CABACA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1B8900234; Fri, 15 Aug 2025 05:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B758E0002; Fri, 15 Aug 2025 05:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF35A900234; Fri, 15 Aug 2025 05:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95BF78E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64953C0919
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:28 +0000 (UTC)
X-FDA: 83778418416.07.54BF5A3
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5219F180003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=o8JnpGYo
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lc0/t4Iv6hjqG5kcGiM2/0kFYGiYqDN1ZHyY/21Fkb0=;
	b=IzWOocTSOmrm7za/7LZztGL/BfeilWMHXC7kp0WZ0Ko64jGjHnA99XjJnzjC8Ezx62dA06
	HaQYHhKBCpCODtjOZYw/Rvgobj8vwFYLn2At8j6QUCsLKaRjjIJXj4eYpRYK9jcSNj9qfu
	SuNkm7fX0MXNWGJtASYYOQjxlGM66l4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=o8JnpGYo;
	dmarc=none;
	spf=none (imf16.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.51) smtp.mailfrom=brgl@bgdev.pl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248966; a=rsa-sha256;
	cv=none;
	b=Y/exxRmJKXdaj5abyol5v1RoXflpMapLxlQb4E/Yom+2/dEbN945rPOK1h5VYrQBlEQuoT
	dHOFd0mRDYZwZ72X8x2f/F8ps2ry+6OVtF6C4B6EoRUtNQttHU59If08yT6xXD7lE/Ke+U
	2bJEHI6/ALdptywdl4lb57pM0UuN31I=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3b9d41bfa35so1462381f8f.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248965; x=1755853765; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lc0/t4Iv6hjqG5kcGiM2/0kFYGiYqDN1ZHyY/21Fkb0=;
        b=o8JnpGYo9CLdoYZRcubz+o8JpxPtmiPB+bcLe0JV66eIRT6+DWR0oDfH6jXEBfEQs7
         DDVOKci2TS3MpQmoBRbPrv6SCZZkxm04LUnUg5Wa7h8tnEJbborEiJR5236dOdJOoQ0t
         qRy+0d+mS2gTktj916ljlqwgo5fysO+4LmCyoeScbahtOleouULcweoHAOVqSKaRtqzj
         7cwPE3wjQ+D904afvD7JSc+pYahV8WyTf8vQLz72P7Levzmi8gdNKksIrk6wJSUmTD7Z
         r6CWoMavqk9xBEzylqzUjN3AIXIjJo9Z4p3UJiF7LUPehZiXYLCL72+K3mg7a6k5qliw
         hqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248965; x=1755853765;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lc0/t4Iv6hjqG5kcGiM2/0kFYGiYqDN1ZHyY/21Fkb0=;
        b=Adw5/7qhynaZMYOaJhZW3z/hZX+N3J/CueX38D7bQcAPt56ndrj2M3SgK1GqInJ1D/
         xJk9oFxdKBUiB/ZaCVS4Ymehwo6QtAfdvZtTy2hlJisYaxM/ZSVexEO3kEgz252N681O
         4vJ6ONsU6uo9yUC2roayUd7wE3MXAbgh9vPN3EoCPQeZ+vlDlfaQaz7zt6fZiLJySFCU
         343cIMvk38dYEevsu4kJvHA0UgzaKYH4DH+Sf2I0H9l9zGUzwPuc7sMgWxd/zZw1T9fQ
         0nk+AxULt1EotVkKHAHje5i7XdMdlXoZxkJXFQ+RVIMY0D/udXU5GFh7pPWMrEzfbUon
         wVHw==
X-Forwarded-Encrypted: i=1; AJvYcCVtzsQFJfzeIQekD07drIlgk68+11KDc0yi3KfsSXLaf/JTGqgjfF6DMguBzX565GtC53/f45jK1A==@kvack.org
X-Gm-Message-State: AOJu0Yzmjir2xw510KAvFI4xk5usJ7OtBPxl0lp634+vsT8/dBoroaJu
	qgAuTVrWrNrbyrMabzMBU9BdeMhruEpu2lBoDGydY0YSQXf3Vmod+nmo+3LYjqQ5Od0=
X-Gm-Gg: ASbGnct5yFnquR2h7iqjZGVvN6FET+kvh2QJh4eIdUHfVmeQDPENBd9WqI7IMo2tIVH
	+bbCnlcDkd1o0DUQ1zHf0lVdGzHVYjlnlOOS/X0EkUXgiX0BMT0JjIXhP5yq9Ernlh6CkS7hQb+
	apDZFao0snAYEInMalRRmHBvHPISpqMwdz1GpoeFTBRk9KJb9c9col/SSMS117oyWcyu1V8PX7C
	k/NjY2FF/DAJtYyQ9qhJexiD61eIzhSE1F97evqdPPvL9vaNoG5zUUjRNRFT8IhKMZjsbIsUVtd
	2ODzjXVv4T/cwrq99pYSircElE75vP3g0eqQDEJtnyWxK0+a/uk3Mu61Qq5S87RmOjRNk7Wyhee
	0aMGJbWiMhsVl+L1alA==
X-Google-Smtp-Source: AGHT+IH+JR178EPgAqIUUl1evmTTr1x2K4MvNmipyWtFLoqUSeH9zZZUWgL1QLgHWs1/dDUsekziEw==
X-Received: by 2002:a05:6000:4383:b0:3b8:dabe:bd8b with SMTP id ffacd0b85a97d-3bb68a185bdmr1038820f8f.27.1755248964740;
        Fri, 15 Aug 2025 02:09:24 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:24 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:07 +0200
Subject: [PATCH v5 05/15] pinctrl: mediatek: moore: replace struct
 function_desc with struct pinfunction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-5-955de9fd91db@linaro.org>
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
In-Reply-To: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Alexey Klimov <alexey.klimov@linaro.org>, 
 Lorenzo Bianconi <lorenzo@kernel.org>, Sean Wang <sean.wang@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>, 
 Andy Shevchenko <andy@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Dong Aisheng <aisheng.dong@nxp.com>, Fabio Estevam <festevam@gmail.com>, 
 Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 NXP S32 Linux Team <s32@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>, 
 Tony Lindgren <tony@atomide.com>, 
 Haojian Zhuang <haojian.zhuang@linaro.org>, 
 Geert Uytterhoeven <geert+renesas@glider.be>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Chen-Yu Tsai <wenst@chromium.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7850;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=9BKGEvZq/gbYunbAXK1ZCTf6DpFoadfRkbzoE0vKzXo=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk3Pz4bZWLjCq9OyRjq8qSpMxa5kXSom7+Nn
 9lVVbxSSICJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75NwAKCRARpy6gFHHX
 cgEEEADAOXrKLcmzOeYsONGvgBthO2HBAzQ+lHZSBTn2F4QfTiqTjYSCWNaboTo5PtgNThVrvQh
 q03BXKYFwL/7IMjsYlfsEvqd1EOZoAIZ4Jl4C+aPyR+gR+R6PiEP11HwNQqR1YYfYeebhhwZFnV
 PGUV3D1w79KrlhgzsufjmSW+c+YQ5WJZDMLqeF2ZEIexXPNTd4PX1GEQ/BItpda3fLlt9jdHGIn
 w/jhWZRzo0GJ7s96NhRyV935oS+cUacE8lQc4dU+mr3QHDktqexVN8WK9jUWelV84TnQ+urZSSU
 /G3E3j4GoUHaVtTJ/PdG2S+zWzrkeG++Qb/2lj7zaGKCEB9cftBmPP0atTegNaETtXqvMOvMkuo
 6SyVCsGKxrPp6ee1wWtdEE7ferKv3Dn+lsozfP6rY0I66SoAdKGwsTNH4lFNo7FbZW/eal1TAE4
 U1YWk3ZKnzLVI9f9dr4gebddux/zek7590VjrED7EbsHk08bxR5uKGYwzqpP7UcnMM4oTCpaD/+
 +woGV9bb+PXmDDOzculdAJhPzGNlUSmRO9yqDjCbL3dcWPPjEO6TdXmZWI/0vg8dZ7OBAzI+1Ej
 9QoidEbK+PWSuHQ1Oqt+9XFZODd2wRU2JiJ+s/PxtwTBjJdnr+XNmcem/7B6LbT5baypfHI3KPX
 MeYcfhyRNgbpsow==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5219F180003
X-Stat-Signature: puw95kstxje8hftj4ut6y9z1pwdnxqcz
X-Rspam-User: 
X-HE-Tag: 1755248966-719995
X-HE-Meta: U2FsdGVkX19n/05fhJLaxKA355+l+NQzyp9G9vx64kF6Lm+ak7dPfWq/uHoopvLJz9AkBc9Ux/Bq3gNXrJGFEpO3c9c8gjlGkGXWMAt6HMu6vY7DPtNkmLvNV4p6CVCvot3O2s9FOD3bYgr77y30iEXPP0uAo5ReEXUFIOYe8Gfsb8wv51auAdprhSNKbB1k3Vx0I4rZY9W+K7WaZn4ts0wopQLemlheVsdnXbWBFxzu+5TscCzljNsBwgKwOkQAQ8R6oV8TOB8SMfmDnivhxIwxI+VvSG4sbJz8SG0qjWKqdRv2vVfiCYTT3IO6lg4HvLJEo4X2liXdMFVv6KOc3an0JuCZhzmwq5fTVyDOTFn2PBGjHQvmMafIgtt6shJORmdEJ3Piv5NDk/QlnZ2so2wPPrmU+iDeBbTJjL516gjR8nT/cf/1KvTAJx9jZNl3XW5RbSj3P6KOqe+ilmk5jnQeNpa0M59j6MfEwSinaoNmIZltJWyUS7fJ+3POl8wk8Qv5FVO5VUo5jGzMR8INDvjs/CJsQbScQQhi9vbPwUMzABMay+Xi+j6hGF67/ErX2Y3E/pFtZhtqw9wLNu9XydEJvBuIKvHrn1vkdb0G3qXWG8HNVGD39vG6z8H1JLrjA9JYvpa3x5WT5u539dWfP79B9AdyJVWNJqO5s0PzsnJduLSV1ookd6jyL+xoWjMwCerh14AAQVHdP55hH8viSldZBlCFhh4syHVsqR0hlyLG012n09/RdowbhGXy+rAIDVw4l9yV1hzPILE/EcBv+SQmrSkdKaVSaZxZ/glWkQ8h513lBG9bkY9CKRlBamao2lYfo7+OjEABl7Ss5Gt9rDzbgzneq317Vd3Bit2u7cOThRICh4144BO6LCRcjMIveUGTHs+ZlinDeKBzBrbQPsGqKNS8g2iguzt4QyoQCKYa/G1kkdixwg5nY74BpRoallJhfDIl8F+6qhr69VG
 dOgZSbYC
 lBYHVRbxRiED/sUTNJWr2SaqeHtYbQK+5L9Ilr0Sj1/JxouAX9kfV0Q/Du5P4KO/VRtjfF/zkkeRlk1x2jjRxgSa+yA5y8mDip4bR2Hv34wmskLu4DgkAPB1UhFK0iN030ollgX4vWXBtDGqvsx+WNxcfqeqdFCdshvr5neYd7snIKpHp7ovOn3tgtjEQvSSYR8jDQooPwBl1fxRzjZ8PhGLw4TjSNylJ9ZiHVGF9AeDnAsjcbl3m4nGVlgWnHf59hAfqOTVEcm/S37mCfm9LTNrc+aDEHH4BsFYTRM2eXBL0WPa+2+U9P2TjKMrLGNsMMmZvKEc8YA3vgCiiDhHM0xMOTs0NQyBNRz7H7Z7bmMoKifMyqIJN0g+b2I1iqa94raJJbcqq5mNX1KIqyCg3Yg4LlQFpVipE8KfE3gXUATiZWnldgERUEw1saYcG3oFFbwoNfRftld5sTmM1KIPsblD350eKMeX0MDrXYlhP+/xW1RulQwh7FDp6SOULnN0iwpgHzwAHdAcPvBPxnBz0m+e/V7IZo/9lEYurqmhKixXerVxSS3sWqb0Y8toOcb2NeETq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

struct function_desc is a wrapper around struct pinfunction with an
additional void *data pointer. This driver doesn't use the data pointer.
We're also working towards reducing the usage of struct function_desc in
pinctrl drivers - they should only be created by pinmux core and
accessed by drivers using pinmux_generic_get_function(). Replace the
struct function_desc objects in this driver with smaller struct
pinfunction instances.

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/mediatek/pinctrl-moore.c         | 6 ++----
 drivers/pinctrl/mediatek/pinctrl-moore.h         | 7 ++-----
 drivers/pinctrl/mediatek/pinctrl-mt7622.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7623.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7629.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7981.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7986.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7988.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h | 2 +-
 9 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.c b/drivers/pinctrl/mediatek/pinctrl-moore.c
index 6e4f6c07a509326a8a7e88b2dc32635b22e7b965..982b9887521d036538f67e9919de444693c458c0 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -622,11 +622,9 @@ static int mtk_build_functions(struct mtk_pinctrl *hw)
 	int i, err;
 
 	for (i = 0; i < hw->soc->nfuncs ; i++) {
-		const struct function_desc *function = hw->soc->funcs + i;
-		const struct pinfunction *func = &function->func;
+		const struct pinfunction *func = hw->soc->funcs + i;
 
-		err = pinmux_generic_add_pinfunction(hw->pctrl, func,
-						     function->data);
+		err = pinmux_generic_add_pinfunction(hw->pctrl, func, NULL);
 		if (err < 0) {
 			dev_err(hw->dev, "Failed to register function %s\n",
 				func->name);
diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.h b/drivers/pinctrl/mediatek/pinctrl-moore.h
index 229d19561e229c77714e5fccb3d4fb68eacc77fd..fe1f087cacd0446e40628cb4fa35a135496ca848 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.h
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.h
@@ -43,11 +43,8 @@
 		.data = id##_funcs,							\
 	}
 
-#define PINCTRL_PIN_FUNCTION(_name_, id)							\
-	{											\
-		.func = PINCTRL_PINFUNCTION(_name_, id##_groups, ARRAY_SIZE(id##_groups)),	\
-		.data = NULL,									\
-	}
+#define PINCTRL_PIN_FUNCTION(_name_, id)						\
+	PINCTRL_PINFUNCTION(_name_, id##_groups, ARRAY_SIZE(id##_groups))
 
 int mtk_moore_pinctrl_probe(struct platform_device *pdev,
 			    const struct mtk_pin_soc *soc);
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7622.c b/drivers/pinctrl/mediatek/pinctrl-mt7622.c
index 2dc1019910662a2a52e81f277a10a32bd83b33d4..d5777889448aab86e82fa6821fdea0d30a5a7246 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7622.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7622.c
@@ -822,7 +822,7 @@ static const char *mt7622_uart_groups[] = { "uart0_0_tx_rx",
 					    "uart4_2_rts_cts",};
 static const char *mt7622_wdt_groups[] = { "watchdog", };
 
-static const struct function_desc mt7622_functions[] = {
+static const struct pinfunction mt7622_functions[] = {
 	PINCTRL_PIN_FUNCTION("antsel", mt7622_antsel),
 	PINCTRL_PIN_FUNCTION("emmc", mt7622_emmc),
 	PINCTRL_PIN_FUNCTION("eth", mt7622_ethernet),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7623.c b/drivers/pinctrl/mediatek/pinctrl-mt7623.c
index 3e59eada2825277b3d7500cb1f2cf740242a4a8b..69c06c2c0e21e4ce785f65539254eb070bff9a0d 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7623.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7623.c
@@ -1340,7 +1340,7 @@ static const char *mt7623_uart_groups[] = { "uart0_0_txd_rxd",
 					    "uart3_rts_cts", };
 static const char *mt7623_wdt_groups[] = { "watchdog_0", "watchdog_1", };
 
-static const struct function_desc mt7623_functions[] = {
+static const struct pinfunction mt7623_functions[] = {
 	PINCTRL_PIN_FUNCTION("audck", mt7623_aud_clk),
 	PINCTRL_PIN_FUNCTION("disp", mt7623_disp_pwm),
 	PINCTRL_PIN_FUNCTION("eth", mt7623_ethernet),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7629.c b/drivers/pinctrl/mediatek/pinctrl-mt7629.c
index 98142e8c98011d17339da74f61d6f917372dfcd5..cc0694881ac9dc536db0e46eefe5eb7359735a60 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7629.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7629.c
@@ -384,7 +384,7 @@ static const char *mt7629_wdt_groups[] = { "watchdog", };
 static const char *mt7629_wifi_groups[] = { "wf0_5g", "wf0_2g", };
 static const char *mt7629_flash_groups[] = { "snfi", "spi_nor" };
 
-static const struct function_desc mt7629_functions[] = {
+static const struct pinfunction mt7629_functions[] = {
 	PINCTRL_PIN_FUNCTION("eth", mt7629_ethernet),
 	PINCTRL_PIN_FUNCTION("i2c", mt7629_i2c),
 	PINCTRL_PIN_FUNCTION("led", mt7629_led),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7981.c b/drivers/pinctrl/mediatek/pinctrl-mt7981.c
index 83092be5b614cc164590fe5ec2b756fe6579b263..6216c2e057f6499b32741b6bd3a4854878c061c9 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7981.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7981.c
@@ -977,7 +977,7 @@ static const char *mt7981_ethernet_groups[] = { "smi_mdc_mdio", "gbe_ext_mdc_mdi
 	"wf0_mode1", "wf0_mode3", "mt7531_int", };
 static const char *mt7981_ant_groups[] = { "ant_sel", };
 
-static const struct function_desc mt7981_functions[] = {
+static const struct pinfunction mt7981_functions[] = {
 	PINCTRL_PIN_FUNCTION("wa_aice", mt7981_wa_aice),
 	PINCTRL_PIN_FUNCTION("dfd", mt7981_dfd),
 	PINCTRL_PIN_FUNCTION("jtag", mt7981_jtag),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7986.c b/drivers/pinctrl/mediatek/pinctrl-mt7986.c
index 5816b5fdb7ca918486f57a890f73543b3198c728..2a762ade9c35505505c932b6fea75fa0cf77d961 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7986.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7986.c
@@ -878,7 +878,7 @@ static const char *mt7986_uart_groups[] = {
 static const char *mt7986_wdt_groups[] = { "watchdog", };
 static const char *mt7986_wf_groups[] = { "wf_2g", "wf_5g", "wf_dbdc", };
 
-static const struct function_desc mt7986_functions[] = {
+static const struct pinfunction mt7986_functions[] = {
 	PINCTRL_PIN_FUNCTION("audio", mt7986_audio),
 	PINCTRL_PIN_FUNCTION("emmc", mt7986_emmc),
 	PINCTRL_PIN_FUNCTION("eth", mt7986_ethernet),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7988.c b/drivers/pinctrl/mediatek/pinctrl-mt7988.c
index 55c8674d8d66f12d2f2246c215056d4e51296a9b..9569e8c0cec15fb6a4a8e359d6483fa163487b0c 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7988.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7988.c
@@ -1464,7 +1464,7 @@ static const char * const mt7988_usb_groups[] = {
 	"drv_vbus_p1",
 };
 
-static const struct function_desc mt7988_functions[] = {
+static const struct pinfunction mt7988_functions[] = {
 	PINCTRL_PIN_FUNCTION("audio", mt7988_audio),
 	PINCTRL_PIN_FUNCTION("jtag", mt7988_jtag),
 	PINCTRL_PIN_FUNCTION("int_usxgmii", mt7988_int_usxgmii),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
index 36d2898037dd041ebc7e06526ebc085eb42f2828..fa7c0ed49346486ba32ec615aa2b3483217f5077 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
@@ -238,7 +238,7 @@ struct mtk_pin_soc {
 	unsigned int			npins;
 	const struct group_desc		*grps;
 	unsigned int			ngrps;
-	const struct function_desc	*funcs;
+	const struct pinfunction	*funcs;
 	unsigned int			nfuncs;
 	const struct mtk_eint_regs	*eint_regs;
 	const struct mtk_eint_hw	*eint_hw;

-- 
2.48.1


