Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64ABBCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20F08E0018; Tue,  2 Sep 2025 07:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83BB8E0001; Tue,  2 Sep 2025 07:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BA48E0018; Tue,  2 Sep 2025 07:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD0C8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B5B25BB99
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:31 +0000 (UTC)
X-FDA: 83844165342.09.E62B620
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 266B61C0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=cOFdCV8R
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hmF0qpL5oboyNo2+RmqzBhbIr3GiIG0yX04mHf79OJ4=;
	b=nyCdYPfv3t6lWabugwxIEpTTiu2sD9/vBaC7TMvE5I1JZd2PsPd+aYmMjtgeM2aGg2fCY+
	G5xnRUx8RpOMRA2bzTzSEA53MGUwnJmYNT9jjfgCSlYrDy6muHCBbQ3jF82by8puQtAUeP
	iD3JG3i5jp/gxHcX571YO8As2JKFbcs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=cOFdCV8R;
	spf=none (imf20.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.51) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814369; a=rsa-sha256;
	cv=none;
	b=EySXmxwt+E5oIeG8I7XKH2L1N/La9KJbI0xGeWyYVeUL8qpdZsluXIcWYX14IAEl71I0aM
	AeePz91QFlFre57DWkgQQyLeCqemapxfuSd24LhC+FO1dPQsKLGfUMfsoMnkh2Y+vgJos/
	hqBprLqtWWMzt12Wq6bonKA2ZIXA3U0=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3cbb3ff70a0so3313705f8f.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814368; x=1757419168; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hmF0qpL5oboyNo2+RmqzBhbIr3GiIG0yX04mHf79OJ4=;
        b=cOFdCV8Rzk+iIjRMYohp9v/lRiowpJeoI227XaI/q5iWWZdxXJAB+A3nIJbgUP1qb/
         8pXbgNZvjLPJMd0SDcCyQas85jZ0EyF+3pgMiiGWZj3rAgCtYZohtJqASrxGbZw1hqtb
         9HG7oC2eRbx4/2UovlUwb+ci/jgE/UXpR1A6FdxiAfQ4rwsVwULUPJPnYW/DtGrrjyy0
         XASvHy+ytA4GEogpXxjPUn3D7EiAJckICgHMxE3TLb/iMMBvw7sUtoD1fEmMIzFDePK3
         fogwJE/6JhaQ2lnXZFBCi+kTFVWaq9h7zOsIvGzuKAy1gLIzI5sO20D57j/MZW4ft+H+
         c+bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814368; x=1757419168;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hmF0qpL5oboyNo2+RmqzBhbIr3GiIG0yX04mHf79OJ4=;
        b=wi7NHg+6/QGdKh3u7zmRY9HLfk0WPGTOebhf6cgp+KwAE/AegDApyxe/9lAKCc9RuN
         SUquYVjGjVsiBiGkpMTM9bO3dIJ0sZ3fcMzal8aBI2/Xt3CBwVQULSGZAJVC4+5Z1HrJ
         4Dbvm/9wXR6rn8V3dUzpJIIVg0jUELwyg/rKvZNhdQl2q63t+EO+XsKMzsh5jJPtdtnq
         gNC6iySf1wtE4GmvIVpUx9IuFnxmb5ZhE93JHlE7n2ZtSz+dEF36HJ/AUVmHP1EGEeby
         N6kqjGIRnoB68L8gmekmhFlGMvB/1Z4/5YTZZz6JOmS2jT/FhU6fqGrlIZnWhBRpfWmw
         xvNw==
X-Forwarded-Encrypted: i=1; AJvYcCW0VuGlHi06Ft8s8k8gPk8NBEtAxjUF54+PIlSfbbGzaoi+2/Oakjf3aI7iVZae0cicHP2DbE4hBg==@kvack.org
X-Gm-Message-State: AOJu0YwHz1LU0JQbUv8/VwKlUvqbgZ9v5+CoO6IrQuyg2yzaaxnlyXoO
	wlbs6D6HhoVjADOjvgru1NThN8/PXrCd2r0jftYJ8aOFgtpjDFnECxs/xCkZcomaUrw=
X-Gm-Gg: ASbGncvjC74D4Ck+yGHMVHUj0b5IsGDgKCSbhTjyWAZxdlf7cylsvYO36gxj/itzChS
	xTtsoZqe34+4gQqk21qNsAHPZyXkHcyMKpBCZ7htyOg509mKsbUX13cbM7yNfCTZt5OephBPgKd
	NAc9yp8ccP/oeLIU7bTkHeAYqgoM3q2+i0nlQSmLlTuQf3KIKRJvX1toKPGrOvxrrN09my5zkTy
	K9fY4pmOoyR1qsXfuVd7FGwhT5/l3ZrCeBTWcnnx/YIorg4wTb3nL5rOWHElfBIqHj0FIECYALW
	246yaeZuWae0Lxn6OE13+Pq5m3RPT/o/CkmpSu6+E5taduauXXofxTDNymg7td0wGTX+XBLsLXO
	/K++WBlGtUMlhmm9WrNfGWourGRA=
X-Google-Smtp-Source: AGHT+IFZ7E4qbu9GejC27onbw6mbXjiRANVPMdB54XgewR8O68DakFlPRZsFccnnckZXTOfFslbDVg==
X-Received: by 2002:a05:6000:22ca:b0:3d0:64c1:1a40 with SMTP id ffacd0b85a97d-3d1e01d67bemr9364150f8f.46.1756814367522;
        Tue, 02 Sep 2025 04:59:27 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:27 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:14 +0200
Subject: [PATCH v7 05/16] pinctrl: mediatek: mt7988: use
 PINCTRL_PIN_FUNCTION()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-5-bb091daedc52@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3024;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=8RlOPiRQytIjx4Cw4oHKC1GB2mrKTE7YNwjd+43Fzro=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwSF8whOHOZFyDolz0PilXXDCaAKXuSMNm60
 NzxyV+0c/yJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcEgAKCRARpy6gFHHX
 cvhOD/0doe9DrmFXc7kS6/vcFyVXmEZSMqBFgmLcg4AZiHNYSGgE6MREhSdt5aBNKA7+rTuFQSi
 Y/nixATKCNYzUBUbmWqID2G2AlCMLLQF+VWSCfX96j9ieWw3V3tRY45UwvKNYSEI5W7wMZpg2ZL
 fGGgah3dEUWiT2yUVsG+X1PwKZUR+ocw23x6qt2tkI9gdKNBYBM6bbVnBdoob0hyIWU1FWq/ysj
 yu8gwxPTG6/t7oEbmaG0azFzobwcBLlkzhmh2ogg10CIoW1biAP1md+rFvJr8gkJ6AEMCn1KTea
 WxXvATAgG0gcYNkyN3NERiEgy2JVZeIYRuv0K7EBHjdLOQpdK4giSrbqvTT24ukwhxk3VA6jl4H
 ejWypun21rg7T47OE46nHQCqtQ2yXtCJm1igGFiO2iisi3fTz//i+JWB3HFjnENnD481g4p8Zia
 l0YU3rQjP6ZF5hhPoatjaPN3JFdOjiNef99swA2bw56a2SlzEhj942caTD93krzqPAB5YJtsEU1
 C5BK073g6ZsIuQS7ZTy5mT5vEJ/wMHxuEEoMlKMOVayopJtGpV+QRvurnIVM1XST8tvP9kO/7Rb
 xRGlJWaE3kTp+D03w1FSXjJl9hi41w95tXiebDHXYqVg5NOe1p3i352a2x6yvwfMSAsYY62sRx9
 sPSneWtt5XmEl7A==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: 266B61C0005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: m5myrxik8ngdcsjqm3sqhe7efpxpwt5r
X-HE-Tag: 1756814368-611138
X-HE-Meta: U2FsdGVkX1/BuENBxmPdT36DN9VlJlvqWmShhnbvZphA0Lm4M6XvngunbmdV3/wnDZLx/9ev+5fW9BunPVuA9q6XwKEF/p6ESmHADddgWngugGaej9kzVS+2EsTPfzryz47a8+BwOQc1d5U9ttt45eChdT0g/LhrE18EKUG7nX5UrDcXl+OTezT4hJgBAr7P6ktAd50osgnAayqDPn78T1iQDS+edonpJXceJ8JGHgOqhK+NoXLwgUQmAC8AG2aD40NZJtn8qiAJCvf4OSr6ggt1YcncIuHPJBw+DEbRVDhTLOjKMVwLdzEdtb+wZ4mXlo7fj3ArpwtKJgbx/HZgzN9TT48UtMurtbm9cu9u4WzOzVMiNGxRF3nkFK0tmx60g55ZzmYzbbDNjlMZl1nXNnudYJjQIMVjrd59kaCXeMKDmd4pabb/ZkSvrS/OATXnMIbEOGuSTRMBjQ/oxm4YPK1fA0zs5KpLlwVl45WXxmUUBRvPipsjF2ov1j9DicQU9+9Tt1qP6Or6mI2YRg1cc1oSzi/FwVqMyfdSkEqqLpmmpOdqfBf30EMTIXVF4qk4RHPJiLOS8NzKOeJQdcGq+KSdYuieDH5ckEID8PL/Bm6xoR/4yHGHiaf/2o2nFYo5QuMuI9kWSq2abFYvH38jSZjf9gg2fsWiWCoQlPH+xcbiyGu8NJ1Vb2uD4tqi8tkvpWdn4zDWqz/GH0LKsTuttVgsD0b+zVl3RR00rAcOhpZ7fCIfyuoDyBmQmPsnzZ4OOXgzeEKbp2rO02Z7yiGYD0kh4AT4ZIMO/fGQOHOcAABuPmrREjBTV4cCYJ5pNSjaUQ1b2kU+WnQhX/wGdxHCSkEBCOX5K/ztlCV5atdsj5swKgFz5kQebBE2o5fZ4SYRmDjMQDQyEMdv8Cfao5rPumUCPYmBeipklJi/sc3eBoY7rvvb48/jce2JtfPn2tDJh4qau055Q4Hjan9Wv8+
 vGGIqbJ5
 M+tyjTySlBgevEqQTyIXfKuTZheKP5m2YuDzZ6NbhE0GseqMTkOl99/W1SdV8VDZ2RmUhv5BpFL3X2W05gtcQKyWfgDqJoY4HfcFL0TDo453YvffS59wSwgeRdWJ7KfUdspyj6fQeUl7/e5T0XSJc+j54M7JpUHePajGd74TvF6yzuystj3E9f5fpM+EsESPAXTIZmcg/wtFTYYShbtLkisGnmU0jQB5x8Fd1BmNPbAB9cMNev5v8SeVp3Db4wZoiDKU3zK5snxmWNwnQqMQ7Qu3sRmDR5klIyE7eE6TkXpsbyKF0dwhp1cI/0WJdeDu0b5YsAKPc5ZYOKumnLWpey+utNV/WfdnCPcYNs2lN3wSesvQr57xcri504vM7AnDgJMjyyHRfD7UzLp9nMQTbryrOgKBhac3VnLCt4wwBTQdiH6tlNzxIPzp2lYDvwRrR5WHw2R7Ji/KfOh8xc3JWVc+rtfsKF6UtvP+4mewe8WSTMLqIxSmY+hmnhZr9XN+MEmhRiuk9GlNTuj7bpmS1CzKni+Ob/ihgFYUAEl+j+HWoTnKXTJOJY+tnEN4kMo2Vg9n/J6UDuCYQ92Y09yutZ5kdoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

We have a dedicated initializer macro for defining pin functions for
mediatek drivers so use it here.

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt7988.c | 42 ++++++++++++-------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7988.c b/drivers/pinctrl/mediatek/pinctrl-mt7988.c
index 68b4097792b88356babe4368db7d0f60194e7309..55c8674d8d66f12d2f2246c215056d4e51296a9b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7988.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7988.c
@@ -1465,32 +1465,22 @@ static const char * const mt7988_usb_groups[] = {
 };
 
 static const struct function_desc mt7988_functions[] = {
-	{ { "audio", mt7988_audio_groups, ARRAY_SIZE(mt7988_audio_groups) },
-	  NULL },
-	{ { "jtag", mt7988_jtag_groups, ARRAY_SIZE(mt7988_jtag_groups) },
-	  NULL },
-	{ { "int_usxgmii", mt7988_int_usxgmii_groups,
-	    ARRAY_SIZE(mt7988_int_usxgmii_groups) },
-	  NULL },
-	{ { "pwm", mt7988_pwm_groups, ARRAY_SIZE(mt7988_pwm_groups) }, NULL },
-	{ { "dfd", mt7988_dfd_groups, ARRAY_SIZE(mt7988_dfd_groups) }, NULL },
-	{ { "i2c", mt7988_i2c_groups, ARRAY_SIZE(mt7988_i2c_groups) }, NULL },
-	{ { "eth", mt7988_ethernet_groups, ARRAY_SIZE(mt7988_ethernet_groups) },
-	  NULL },
-	{ { "pcie", mt7988_pcie_groups, ARRAY_SIZE(mt7988_pcie_groups) },
-	  NULL },
-	{ { "pmic", mt7988_pmic_groups, ARRAY_SIZE(mt7988_pmic_groups) },
-	  NULL },
-	{ { "watchdog", mt7988_wdt_groups, ARRAY_SIZE(mt7988_wdt_groups) },
-	  NULL },
-	{ { "spi", mt7988_spi_groups, ARRAY_SIZE(mt7988_spi_groups) }, NULL },
-	{ { "flash", mt7988_flash_groups, ARRAY_SIZE(mt7988_flash_groups) },
-	  NULL },
-	{ { "uart", mt7988_uart_groups, ARRAY_SIZE(mt7988_uart_groups) },
-	  NULL },
-	{ { "udi", mt7988_udi_groups, ARRAY_SIZE(mt7988_udi_groups) }, NULL },
-	{ { "usb", mt7988_usb_groups, ARRAY_SIZE(mt7988_usb_groups) }, NULL },
-	{ { "led", mt7988_led_groups, ARRAY_SIZE(mt7988_led_groups) }, NULL },
+	PINCTRL_PIN_FUNCTION("audio", mt7988_audio),
+	PINCTRL_PIN_FUNCTION("jtag", mt7988_jtag),
+	PINCTRL_PIN_FUNCTION("int_usxgmii", mt7988_int_usxgmii),
+	PINCTRL_PIN_FUNCTION("pwm", mt7988_pwm),
+	PINCTRL_PIN_FUNCTION("dfd", mt7988_dfd),
+	PINCTRL_PIN_FUNCTION("i2c", mt7988_i2c),
+	PINCTRL_PIN_FUNCTION("eth", mt7988_ethernet),
+	PINCTRL_PIN_FUNCTION("pcie", mt7988_pcie),
+	PINCTRL_PIN_FUNCTION("pmic", mt7988_pmic),
+	PINCTRL_PIN_FUNCTION("watchdog", mt7988_wdt),
+	PINCTRL_PIN_FUNCTION("spi", mt7988_spi),
+	PINCTRL_PIN_FUNCTION("flash", mt7988_flash),
+	PINCTRL_PIN_FUNCTION("uart", mt7988_uart),
+	PINCTRL_PIN_FUNCTION("udi", mt7988_udi),
+	PINCTRL_PIN_FUNCTION("usb", mt7988_usb),
+	PINCTRL_PIN_FUNCTION("led", mt7988_led),
 };
 
 static const struct mtk_eint_hw mt7988_eint_hw = {

-- 
2.48.1


