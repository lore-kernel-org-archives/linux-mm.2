Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25EDACA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1566B0088; Thu, 28 Aug 2025 12:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28FAF6B00B6; Thu, 28 Aug 2025 12:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C786B00B7; Thu, 28 Aug 2025 12:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD7886B0088
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89160160292
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:28 +0000 (UTC)
X-FDA: 83826628536.02.0FDB166
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 67E8E120006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=qtBozrMz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxPihWEE9okM75l8p7+ohG5rL5D7+pdcAJ7iXomcZQ8=;
	b=FEyzLTMwyAIT9biAlPMEk/fLivyytPVo0xBu9+ucQRDHo1ItbDFGnBpb/IAgGERXfJk7uL
	1istgIqsBiAENNQtSHy1ZVTGq4MyBeXztNu+DSEvS/xC2LN7wKsPZ8Sv75Yg+03XWHv1rt
	JHO1g1V9o8tlmaiFAtmoXRZpdmR/prY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=qtBozrMz;
	dmarc=none;
	spf=none (imf29.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.43) smtp.mailfrom=brgl@bgdev.pl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396826; a=rsa-sha256;
	cv=none;
	b=cS3iI+GIK4I6Vh010ZXU5i+lmgQaZ7mxOysQ50y9lLvjup5gL8rRncnQcZNb8/NKDsvHEh
	hPQeBfFWSh6yGBKChB29Q1VB6sCMuXj1H9YMHey9FjRyKEGbzjC7l1kdStubqE2ZrJhaOZ
	J4kMIICUcqnJyWfjCA+np1a42diStRM=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45b7d497ab9so4436485e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396825; x=1757001625; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AxPihWEE9okM75l8p7+ohG5rL5D7+pdcAJ7iXomcZQ8=;
        b=qtBozrMzWvXngYaoqL9EAqA8ldG3k5sfBQyxC1Vh84zxXEusd9CZNe9LUe37Zl1X8Y
         LYmohms4DXw+JYNMWWqeL6xsi1h+YlerfRwgvKvavIU8SzC5g6d3m4J/PSOpRLZBZKLY
         cZtpdBmzOKW9Z98QzhnyoKXE0FQkp/8JpjHmfGXSu05RDe453YKX6zPOiBAUnmIhFxFm
         /O3ZBhCMlxxfunfk3xvUxN6bQcSHQp6O08QwiwsWV5UBPW4DEiiulvnFW0WjkST24fGI
         LrL1u0Fb1f41SgozytLkOe/YNUkaVJ826gdb2BUwlKyhJrvwOog2NrCAljQaPsZPTOXb
         d6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396825; x=1757001625;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AxPihWEE9okM75l8p7+ohG5rL5D7+pdcAJ7iXomcZQ8=;
        b=JCKALkZv8yBx8z0fxN4ZE7wDdM2SDC9cgUkQUDvJ5z1rfbjjM6jfJ398AoWkDpiCnF
         77Xi2W62cezg1tkSXe5dYZksrgnrKLCsa/IHn03zfEaPyeSUXli4pPIcKeRLSDYOluk7
         /pMzWZ+XYmDPbi86ArbqMtCGx+5qivqfXEEMV5j+vO8B8ITJwC2cJvZliYsW/gZytYI+
         nPhZ3wbYh+e2uNI5fkZgb2e8/aeXA1dq6D4CHwNvPMpp/HRf5WiQjgumUW/wgrbCUgMH
         rGDgKcjxZNjW/2VnppMJeNwZ2grpfscq8kvxo1GT7yd6Ra7gytgJ3bSdZqxrHduqpQ+b
         Iipg==
X-Forwarded-Encrypted: i=1; AJvYcCX4U1ZeCoJPAV0xZw2jgaW4S++eBtopeVZmrEdtGF86n0vJ6Q0e3X1WTTZfm4xVSc8+HRbxWP3RuQ==@kvack.org
X-Gm-Message-State: AOJu0YxlG3ontU2RhK7+n/sBr/jS/PMKDg9konB75ddbrnpCTJNyMv1t
	r4lDDC/WrQgoErCkx9/UsFmfuwC97OoTts5ionqW0SMb7vMDJybceFUF0TA3LgFxBQw=
X-Gm-Gg: ASbGncvZCzvT3kHc5aaqD153wD880Tsqtvwuk1hUcZ84RDf9fCWABAyCQf4yaQpy8R3
	YKQRA4GK23q0wMIk1gUz4izOutnB2iE1gJl7YuixXCCsqH7uScC9Z73a2sy7s84MQwIxXSnmE/7
	bDHjiA83HdZ+mYBJvgW0na8FSCLsyLgjynA7IP9VmjgdFQ092MgIpK6PjXld0d+o6xF4nU2qjEV
	h0hAqdcfHaEZdBYeISvQEd02IdRcOaFjs/kpb2+PGYfa23IR4J2Abh32EN37d2BHnTsQIVcjGo/
	XHZfg6Mwm+jR8D/qdHOB9Ap/FJ4u6tZv38qUj9O647vNkVcx0cswMUsN17UaO5rQ3MeUxtsy1CG
	Cy4gCe8Q2GwFMFLzMiSPLU1LTFMQA
X-Google-Smtp-Source: AGHT+IGRMyHayDmkLGW7+TAO1iROYIwKh5FOICjdfcZ0105VGTYnJRy0SkhUfojn9IN8Mk3CuNpnVQ==
X-Received: by 2002:a05:600c:35c4:b0:45b:7bba:c7b1 with SMTP id 5b1f17b1804b1-45b7bbacbc1mr17635415e9.32.1756396824905;
        Thu, 28 Aug 2025 09:00:24 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:24 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:12 +0200
Subject: [PATCH v6 04/15] pinctrl: mediatek: mt7988: use
 PINCTRL_PIN_FUNCTION()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-4-c9abb6bdb689@linaro.org>
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
In-Reply-To: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2921;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=79i9CgDBpTwy0KAMS4vozziB177zSWYhoWrySFXqKM4=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0Nb2Lfmw6OgPTm+UKi/evxFaUCjOaMgc4KJ
 G/Jl7qtg3uJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DQAKCRARpy6gFHHX
 cmd1D/9O9r1DDeMjfZpJc7L4WQYFg4NpL4bsKIEQD/4HTfJtY0F0AbCzTUVX8wvtO6G7Oz7Ckl1
 JGsGL2ePPaPSOhC4u0K4c6e8AGfOLuS65Aup1ZPjk9dByafrLUoaeoI1SM2rk0Ff93R5dCbWAhV
 O+zwBzL4wpnwF6q8j7vEmnrERbfUK4DJyPUYU8dEMlQpCvM2xq3vX+6M9aRECpcDSDIgjXsJaiC
 3SEQGGSpuSWLH4vgWbPAhYTv2uA//5mK/J93r57YZIjbfUe7EN+xvbqFhkUX8sFPTTQ1K5nSV3I
 1xJamJF6MUu1lz6b7z/ZIRwkLcp9NWTEKBcIA5UbweTZFziTMjOdWQ+wncqGqm/jw3vitwXbUp/
 DaSwfS6lcv7zefvLHYddAx3HLAixXjkS/XVFAC9VZW2ZtNpqJXBMl8S9+hfVpwXFc3OlVI+764g
 v9EF9SWddtxMvleCD6Cw2vOD0URS5JtaEfX8/draXvRAklHRp8xnNS6tXVnx/pQWNt/SKMcxHfi
 EuioUyf3YE+ywH7kBFazoYHGSt5+i0XaiWxZPkvXjk1A/9V/nJyroGXDVvC6IJKNSYJSkbmxsm5
 6AQHNTKZD1aoqjMJa0hcJdLtcBCZCHyZup13Wvn6cJC7D3MAy+LWRbAi9MJMBS4G00bSg2oJCqw
 6ccAd8cQ8L3Zydg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 67E8E120006
X-Stat-Signature: n1a5fhnqbo61b3s5afepfpkqdjz3haa1
X-Rspam-User: 
X-HE-Tag: 1756396826-488912
X-HE-Meta: U2FsdGVkX1/i5SvZq6ewT7+SvsLCx+oB9oLZ5Gj/p7k/ehq6f+QhZ1cNaE+Yo9W8ForUkZkKs3a146ESQH6Ld4cVl8LrxgYseFssJDfIXh4eb3X0ePOMpAMgc9kU1DO5299wK0JLJbZpwqB1FirHhbg12+yHrT5eEZNvs0DN7JEYjUngUGPavNNBm8eb3lZbSr//4s3EVWHrv/RDuBPE6x/H8iRooXHTLkICjEar0wIvxng7vyQ4Pb1hPJDx9HeMqOY6oKZ2ZUxOVcJIEkSvs2PujBu3d6hA/w1rR4n7c+3qR1ur1rlEPySnLP0EcGCCdCFDNe1Ou2bHN3Xc68Nipc1nWSsgZVr0rSgcDRckhJIR4s82h8SlmIMy7ymidTsh/56sVEViP+VbvV/hHMblRil6Co1FcuQlA5dIailYmAQBfmdOTX7rl/q1iRK8ak/XXCBZXsFvcS7US81N7TRtayw+4ms4a5aGfclvLlvQe3Y65VZbNX56XbovNjZw0lt7L6Umcvr9s9tUrRfZ1U8kMeIJP8dWyJ4XW8/2P/HJJQ/rOwQjv+zQWsbTVDRExXq1plgN4QfBLg/dEJh9zUcZ8iekEnY2RaBqS50/Kickm9qMM8ua/G+aFhWFOxWhMJqteFr31mTEjEip7DEG+rI9uj94VOZ8Let2aoVPY8ll4bvTiJBUbtuGQUpim2L07B62SucCUkECCmFLIo23aKSsBIu0AiaDEG3U398kHM5v3MhamXT0ygKyMOGXiPLqgSy5FcBOUc5kbY6yX71kla2J4u/NNV7IWgNv+ZiRbd7rvFpben4COHgPp5/mKQHUWR2q1fFT92CpsIRsuPfnNeEmleZYcR5kIuCOOvBSTLtIIGpW7s3AkQ0sOfyw5YYNMefnwqKm5DkyRyc86UG8W/kAwBzUvDSorqB5mkMSVoBV0bCndLKl0ol/9otg5YlG8u6Tc5pYY/q3sla90PcFR6w
 bCf3c2Yl
 XkAo28kE/w+6GhOQp68yDs79IfLUIYM2LPKu8/5CW1q69rIC1Cqcc1HJVbfu2EkQa7eoMXhWUzA0ngemHNUZZetu47VzREFA+rkdlchwTq4lKeCF0NMdVzdxz8XlajSo+134Yp8Xhux2MPZbll3pAbCpXnwH45T2MfK5kT/gjzBWwHR49BA8dwjYV2Ox59eeY+nphLZ7K7/Lg5pHng3g0Azma5v8xOZj0NOy+OhSrvgS02b2cX7HWIq2QKiBuTr4/i/4kZ9hGOCT17yM4iS4K3YO4P4e/x5AFyz6u5Bbb5cqBYL5iB2qhALTSZxiSJtV+FX5WdTK1TMURbe7BsZAQqjUsKhnSDp0zlVrKsjx0+0hM4fwR3gcQpC9/5taqIIJn6PUCLTIAJ/cP94wq1RwRl0I7j0kjW6291XUHgeVN54bp9x7j2Tn0IAlNNGZnl+hzjpXh3ChMGhnqIAXtrJwEyUJtKqQav3mhoSHyzeOFzCiNOLVuKsVoWSa8LKDkjNLyAuHb8JnTNmYZbDgW2WCuJGQoxGcG0cx9ZbUYIN7hSYkSYkKtEra8NHzz0c3NZjaSKfBi
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


