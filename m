Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE10BCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A8B8E0019; Tue,  2 Sep 2025 07:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1DC8E0001; Tue,  2 Sep 2025 07:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437138E0019; Tue,  2 Sep 2025 07:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 276BC8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEC2411A831
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:32 +0000 (UTC)
X-FDA: 83844165384.09.DB8D787
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id D823140008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=T8hPuetc
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814371; a=rsa-sha256;
	cv=none;
	b=3HMulLM1c4zU37/GCf0IFOk4ARdCFs7tfDVVVkQ+iRRHQcdhRyVcMKupbO4BWuWuIPPRk+
	sY2QJrQHJI7u1RGGDFGEipqxlMachRBrFpou/FIh0sbm1gjIhpbPzrtxraBwVexnnLasDM
	ayzhT0oc3tsN4TTrlqdtfcPkObmJxuQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=T8hPuetc;
	spf=none (imf12.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.53) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vb0Wiqevsqa8WkDdGC0D/fzhQe9xghTxObZ99u7DKgU=;
	b=wbL/isaZT/0rPbSmUeuhPk06CGbHPb/29c7czfw7IzcsQp8FbePEnUG+XBipR479NeS98p
	pfEvunvoD8ZHdZmZZRI+NjnWJfEH+/Mvn0Oq5ux4yfOPJ4daFrktqgnMr1KzvyszbyhkWN
	VDd0AWgn76grhwpc0tjm0MQhAlMdh74=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b873a2092so24456755e9.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814369; x=1757419169; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vb0Wiqevsqa8WkDdGC0D/fzhQe9xghTxObZ99u7DKgU=;
        b=T8hPuetcKFUu6OZZYEg+lSXlqwgT+rQadAaY6G9w4ZGBaeh1bz5tcVAZ2J8qwMvY8n
         Lf9068pCx2ApR4uKdTe5rCMUHCLzfv+2HO0DTKDNZiiVVYo2l10AHu2xUvx4Z/m2f6/3
         P+1FiNf1YriUDPTCcH54WJeIFUeaeM5cIFQquTPM0NaDw+EaZKI9uo2sOFk3Mzo3nzIE
         /Z1oLq3ikMBo28ou1bCsHVLR2vlUrsLOJjTpYHx04bVItygJKFmnsDoqs4sk0uJUj7iN
         GoVepJNWAkC+ocrlB5QJZRaLc4dY/sN3hXLATjg0NZFWhMlu4iXFG+WxAkMzIqKRaIKj
         1dew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814369; x=1757419169;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vb0Wiqevsqa8WkDdGC0D/fzhQe9xghTxObZ99u7DKgU=;
        b=OYhbe1os6eIguVySWqr61F8tbtB0OAtp0q7fy5IaH4hfSajH/4jzTw2Ew23fMYiML4
         0uHO6z1Hw/Z8W6eqK7BcnHlUkrzpsMCg1zgoNGNKdFksk3h5Zse/J13OhSNXEf+E08Ea
         NSET4ojbYPeUk53YiJtv29I+egRg09V0ieJtxRkTBggT+UaE3rWx7TElzF/MKP1YbsJL
         t+I/+2yNanALUjTK739NCjrqtqrJcZslO+fHJp0kOEZYRQwxlnH5FuDFBOhlHWTxPFUM
         DTXieggGboiZ8oIV7w/aK7KmFnJokRzzhsigddgzQaUi9yUpXGF17zeRsCrWfB6nCzJ/
         0ehg==
X-Forwarded-Encrypted: i=1; AJvYcCW5/lBVfvifzaB4smBagfrIXCPxsepwIXU1sIMk56C8q4HCU/qD/qTMRFeXtgk+c8Ikwp78pSLr8A==@kvack.org
X-Gm-Message-State: AOJu0YxjA6xGZSMPrpA1xS0htn8OwDhcio+3gkE3SkkQqro7rtg0efr5
	bGRvyZuWfYJW2QIxfkniMcj92P328+k/l/+KpFtk+Gyu94q0brC3gPiZ6vCXxivRht4=
X-Gm-Gg: ASbGncscP90+5WoaxjwfUVtAdKWYBoPbPXMp+jqeXQJ50eN03h5SI5qweWgDpz5mJaI
	pwYvwt4VBonFP/Sas6Q/tlytjmnknKNHGrI0Y7C0jTcGu1MR8TYFKCLkDSTS1HmuG9Q+KjVqq5u
	wS+d2qm01AzfLlw5J45CEvUJLZ9uW9UWtN3FwY79hd27SYMYl3AbvemukOCSYcbpfxoI2/SS7Bs
	qd1Y3BH9JrHc3uyF3DSAMW3oQY+WjVaqrqbOd1UowlzDHx8sWiYWrOeFA3S0GBGo+nxAAYW9tf3
	rMI8rXob64uA1JcO7mi8iQCkn3V8F62WC8iKFTqBq1lXHoOIW4PNXaOJKIFfmu8QaVs7mHfp3VP
	rbW04oh/991PBhCd1
X-Google-Smtp-Source: AGHT+IGqVPHm+CLmCWjDWIMwfD3yDb2aOG/ha9M5DiHwXSWdOPv57ls1L2plWUVpkb4U4xzMsBIF9w==
X-Received: by 2002:a05:600c:4e07:b0:45b:8795:4caa with SMTP id 5b1f17b1804b1-45b87954e09mr79113935e9.36.1756814369289;
        Tue, 02 Sep 2025 04:59:29 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:28 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:15 +0200
Subject: [PATCH v7 06/16] pinctrl: mediatek: moore: replace struct
 function_desc with struct pinfunction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-6-bb091daedc52@linaro.org>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
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
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Chen-Yu Tsai <wenst@chromium.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7905;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=EpTogw9AYamkr07CTHiJSmlHCa4fP6PJjItMvrYOmL4=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwSePhiAI04z5GFeFadhwAcEnFgvTGwedFKd
 gLkslJmObWJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcEgAKCRARpy6gFHHX
 coHID/wKzeIrsev5zmuRg2+6QQhA/2x5h0AN7sx5CSnBHV6WofCQWrg14rXuVAKkOtzpp9mIAe2
 FLfU9PrJvokxpPpz8GQpLLqKi0ppqNVjXbrh9HrV4xLA5H/0KCA2V23K5Stk1AmRLwsFl4Ry/8L
 WL6adK99ntZeJBQCiSr3NN6rqY+xXMVK1H50c1a/2mZzOzr0mkAeXuD7Swp/NB1jPwLPuUV5dke
 IpYNI3NbEBOR3PSwOXvr1x8JomrsI4My7WBYWn3e1x8smdGeHWLwscEi0etykq1AQR+lTQF4phd
 ct4qth3i6b/mmOoWFIdoL4OPnYYE2cD7puPVwCpLRKOaAdn39RlcE743D/kSBWKhtgkgQONvqPt
 /pNippaEaT7sQqMBNEbik4JBGlkOvDYXygLYiHOYCZ8eRwNlke4C8HjQRgmjq7R88ewKPixrnR+
 M5FbiH/a2w/ewqoTwS3LaTAYBrIw7qIxjN7WIewBqhBp7fGXrX2L/j7BGpP7atr6wHHn9v4DpPG
 XImlgfrRL/784C2X7A+h12vs6mCUwcUByfM97Svka56vlJ9Z+mlcoJwVQv9gAf+EJ5SXdrs2EKJ
 AXbGAgZPoUmRtD/BoguTy3oruS3jLK+bZJluB4Iw+6ZSLShA2HRC/npItXbtOtqyxU8xytLLmdZ
 Hzyg4ZzXRpokQLA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D823140008
X-Stat-Signature: mbh1uou1sjt8uwb8cpaxsb7fp8pykh7a
X-Rspam-User: 
X-HE-Tag: 1756814370-272382
X-HE-Meta: U2FsdGVkX18A2Q+8AqmZh5NHflrYSpEAqDGuUoL8DXAmJeXS6XgehQAbRYqBwekbQd4Ic4s98W60TEuica73uEf2psMTo/2KqnOgFfNz+QZsQsNJkOqDGKfu/TCdTgdIW8ZRonZhxKp7kf/C9ke5xzeV5fEd6dlmr/Wo08rXobbFS2eHLJC50mSX9A3oKOnbaIIF7G4fevxpCcc2u4sSxj23V2DN03X30mU0rUT7c1+oO07uLMVjmJNSLlW9U5BmEwH/rKy74kRyfY4dgVPWiHjFLqLi1V6o8pJE1ztmzcIVwMO0l7FD5Y2GJCfDmct9dBo/6BWzUOVMaKgGm13IWWAOkDVHQwjVGThCIUL1RWzfX5/OSUg82/IOOj/RIs6nQZ2ZvlXzHrhHChg7azPo6R2hXw+9GOZLBf0TzAvMLKEy5MEOeQwUfO65zdMEXk0XKDuuO+iTnvzIPSTftIqEe3ik2tcZ1hB/pXo2c+X/OBc3n5vVxYajY3ZM3ZS8alpz5BRNIQZMqscLwN1Xr5bgel4sGYxmhOPgw60YGFDZWojz2HdkLxoT+7fsCwktbP3F9XC/453M7DyZha4/R2n2kYan7+PRMBAufPPHW98pJX1zTc8mCbdUFbBJ9jN05O3avou4tdwUWy+mWBvzPej8z4ittqmdwRcKWQmtfhe6/22M+QytUuGkYo5x7lm0PY/QucjDPhkr/2XsD2tuWDqMdY+rIs3LsqqLvv+bKc/lkqggeQL8fyyAOpHZeh6sUxBjdiGIjm1eBHOQLqCRiNKjF8gy9xHrG0oyry2k3NEZ5xs8jxHclJEYrQxZfRRq0W8uDJh9IgU7wvN84WdLPhS1pSNTI5x4R7n2cnSSYWJM7yhAXK1t21idPB8+P2iM7MwNRQHYn/LHIrvUx7sruckBYo8yzusyrvn33xJK3tmjH7zj6AWbYfubSxtX6As8edabuG/uudEwWo13xdlLSqQ
 im+vR8Jg
 lHf51pFk4EcaP7iVg60PokXz05w7yDbdYb4VPDdwagBisIGqS7Fj/01w2iyxTPaXQfXHgN8fkyCXCtPip2GXk4R6H20WpWA4IAsqGR26lUyzkqvU5CLE6OYDYS3hUw8n78wao2GbwrKuzc+/BTtOaY2UHuaM7kh19ff5L0lY9WX0RWXYBQQfnFZ2rXdNCQPG2yF+AXWS0jQZyuPXn9KJQmZeyxx0XS5VI/Ok7wo5blUsq2OQCCdOHyGhXqP4TzN+euu6y0oZQ9q6/gIsyJi9IaanLM0t8CVgvOlowviuywt0kq8dPF+yBrgG1fowIbFhApO/cT1fLiRdZLm5EGeiipIuwxqtFimaMVR4ZH866cjswG8x9ND5CzU10BI3JUZLlWCod+wVNQ0vdquX9gDRa/jyk1SyhERC3l+/ATH4zcJEpX2qGD+rXHwj2xKo28MoY0BOjRWAwuug1f89ZdqHEAX0pDhXXXqLM4s2ibGhnqDKAYov3pEf1DXeo535gFg2MaRW3/IzdR2h/eF8q5CU8IYPUAUIL234/qVoLf1dl8g9CyF42nEg87Q9xB9eukwbEXlCh
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
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
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


