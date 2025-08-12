Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00293C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4375E8E00FA; Tue, 12 Aug 2025 04:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1768E00F5; Tue, 12 Aug 2025 04:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EBE98E00FA; Tue, 12 Aug 2025 04:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9CFF8E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4E6FC0234
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:18 +0000 (UTC)
X-FDA: 83767425756.04.BBAEA4D
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 910C240008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=Ju+B2pkd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46QW0ZKTJsCdAnI774T47O1RlPj5t6dUczWWbfa0X0I=;
	b=U9abBhyLT12SLedBQyFSAhXCV/eEKJQK1DFIoLEd5+1T4Mj2EqnlPEryDjzT29P6sbC+vH
	nEs6bgnVi2+sCwPDl1Jo0vhiCfFCEC1quBMnAWHUHXVal26nd4C11LV/oiw8GPLhoYJVqE
	UijyGMtk0F7ikB3F22hXFsNN3afuw6o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=Ju+B2pkd;
	spf=none (imf11.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.41) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987236; a=rsa-sha256;
	cv=none;
	b=V6wSm6oN200t9sAQFfoddH03UufhVR1aZNHtVHuGdRRJdScHmWnpKeA8LgXqwgng2v33TL
	+lJsxzMLPWeZhY5LDGPpGE1WjBZNINMRSsFiCPWiJXRvDNA3jQHMbyljh8j/J6ZcySaFCh
	vds+b12BN2XmlMN6CoMLJIcfiXEx8BE=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-459d62184c9so30570815e9.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987235; x=1755592035; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=46QW0ZKTJsCdAnI774T47O1RlPj5t6dUczWWbfa0X0I=;
        b=Ju+B2pkdG3RpOzBha9xYdXSNWhifHxCGn0lMZfNYY+0DLUsgmQ3oAnSGQaWmk9aWCq
         FbKiccSmDs8WJrNNg1b1h3pCqxsNvsVo19skMOD3zsgjpOkwXCLCF3bDHaBJiz7n59aE
         Hwxmv2twLrpzdm8YCCY6SpL9tEZNjjk6i2hG0E9v/c4FebQYB2lHPkJegTaSMCqG2zjM
         hVjuLO4RSAim021NREu6xsqVCL8+Xkgs6PDvo0p4C7FbU7GlcbM2Bon0ae3VYA9kUMQL
         /nps7mPAFCPHxOBdxivjbmfrEkFSrsqJg7QRMbhRXNrrPRFpvPVg1K+UUEDLCBaQrxu/
         oRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987235; x=1755592035;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=46QW0ZKTJsCdAnI774T47O1RlPj5t6dUczWWbfa0X0I=;
        b=iY4tFUIFx5dn4DMwtKCV0mU2wb7PAniIaQBfPVOuQIlxkOq1cNRAimSbmevfqegfK0
         wHmi87R/KOIuqx0LjKWwdJTzx/JsUw9NfB9Z7vFFqPy3uVHIN3Q0cUSz1ro11PCfSRCe
         nl1Nda41G/e17UqxZ5gSO70mr1aceSWR+KYUqHdQs14Enf9o0lrAbXuTN5V63T+uh0OS
         E0bl6IHjDHPTSoHGFtYbjp73ZGzXnd+Heoh/t5HfvZ5LUwaoM+fUao/L4DTH/mGwmBb8
         ga22ocrGsFRnucdAsfV+bHYo7wyedtELDkdYDIFJSVjG+5GO+yak5uuYMVJaxilIBbF+
         GeYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOpXbhCCBPhBsNs3q4ND+iEJxA3BYd0loxoYclaq+vJhERQsLiR/7qZRlmrZEGeFkcq5jpbcSb0g==@kvack.org
X-Gm-Message-State: AOJu0YzrtTx9NxYfZeHIypOH8+U4s+dTDloEaguQJle8LgJfRdlUFd9H
	G1MybrM9Kd2FpVw2zl3n9YX+lHTGeVotjDQth5pWR2FI1oZQx4w5OQTt58qNL2OSJFM=
X-Gm-Gg: ASbGncuh1XDW4vyUvr83yRcUDVZKcf2kMwG+iXfiii+k+VePQ9khkL6vbR6KG8OWd+g
	8Q0g9FiWJf09FEdgDJMHkasroVpdZjhqt651V5xoIst9PfbP4RI2hapLfrJLAgqCuh+4WmP3UYU
	mdnslKOWuCAU3n2iuBDTMQKUtkL8IHuLcUscI+uga6bFHujpVFMuHk3l/5RZOvjEMdrHiFC6LRr
	3GC6Z++7A/QW/wkK4PUKsaZZXOjK9osaXqQNl4pAPNoMoDTwVcWG7JMECQa4HNtqasQeHbvsvhB
	NmviicYGCjdvefdLfn9lqwWWjyQwXQQNh/vhfYp9kEBR6tUDMXXQiKn0Lo8Md5maL/HuSErQA3D
	koj6A9IUfDb+Bspo=
X-Google-Smtp-Source: AGHT+IFdKvznDMFZVInYZwwYDHVNkoHUkpPZeGPe2WfSJ5pngAh+BKH1PEfINHP8AliGuYpxgpRk9w==
X-Received: by 2002:a05:600c:3d92:b0:459:db80:c29f with SMTP id 5b1f17b1804b1-45a10b9f437mr17532975e9.1.1754987235079;
        Tue, 12 Aug 2025 01:27:15 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:14 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:03 +0200
Subject: [PATCH v4 04/15] pinctrl: mediatek: mt7988: use
 PINCTRL_PIN_FUNCTION()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-4-bb3906c55e64@linaro.org>
References: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org>
In-Reply-To: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2873;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=nunH5KiVSLA9eNaj6eipx8y2OBwu+tjBhQLeBJL1rQM=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrXGC6Gq0nJRiXqaR76dk7/R12B6PvbWm35x
 aNzc3XzxtKJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr61wAKCRARpy6gFHHX
 cvhtEADdNx7DArN5koidQnVfF+xi0aUHcfFGOuW8vpax22Hyr2Scf/VG3fJlaP4c5NFyv03lfv2
 m5QXrrhpqBJRNJre3AS3sTt+5DFtU2x3XQe4g0YTzwVUXtZaMXzozSdl7dUdVAaS3d5bkfVQSoN
 bZqJ8Xn6GewglMBvisZh/eR7hVh7fsiDLRSGwzB0txJXy915USWDYvKaZAzaJrUNqH2DJPDkIdt
 hJvpe1DRASLLubOKWqhS6RZYdoLI1vMKaOeXRLJ+uJHwgaGX7acED/nxlYxNTFvJh1rEv+cvg96
 D09YaOGaUsK3oJcDeWsShWamJbDXg76mz6PFaFOU9pXnO0gGch+wg+Ni4hrDfSOyPHmUTYxSJ5o
 rozzU6iNpaTtSsIbtXjcLDebrclN7xi088hZzvuiBccesTXa1rV37gq6lyqvvTWtHmk3qroaTio
 GTxkp49IaL5d++Z5Cid2pYg6PSQqidLMXqc3eMw/M/lw0tU6769CLGAOIPfmZw8pIQ1aVBEjPiW
 Wh30mUS3iHzRTUZ95x6mwyTgZDpBUKbP3wvI7XwSj2P28ThwZkNHX3iwas386F1Be10JolQ3pZw
 LWKA8cisHe32kL2K0hNad7VOpO51ebJNo5q6uC+jebFgDQrWSmRdS1nalBHRZbyorG+GSy2cb8G
 M4bBijT2vNehGvA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: 910C240008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: offii593k9du3nk3kgekjk5qn41twzjj
X-HE-Tag: 1754987236-444128
X-HE-Meta: U2FsdGVkX1/AGnTBS9y1y7YTNl//9Qdpnkc1CBnRnbF9F6EsHtQQVB4f6Exv7HuTTiKwvDv4yWN1gJ/+w6lIfj8ZEmskjDzR11GUFHlbQvFM6N/TmluRvgoFBPQh9ZAioqIG3OdymLlZqrunDdmrQKQkECCsOhNsiZRy/m8AStGN7d8apNGWbeOmEyvba+8+qcbpRxo5lefWe4wo5GGQW7DMeGnnvs/NHHXipFfDLG5aNnnqhSx5goBJ8+32+RI35t3iOQ59UqdQVs93D5AfLsz16Iw45eNl5P0fdTN71ftyPnKRQ2tzrdTkgG9/RcrpGkheA4BBRR73iM3I5P21F6VUks2y9CHDsIs0kPWyK6A2gM3aEPHa3Xq7XNetat82AnraGk9IaUlg+3xBnv0JK2sNvFPFA7f1G3qYWys8cR3T6I/DHaeqtktpSSXHTXuhx/SlJC5xe4umkNT5FSfNgwRL7ikDiTc+2K9bQXEwkW362QrvAdnXNye9RFe3rIe05emCCukDauVekR23H4O+k8N2tgUiFG8l5UrIWlf06Gu3/zjhb5puj0+EWZDLIDNV+TQuGm5SwfMjSZlDiYcBR7OKo5shjnF2aRPIMS0WwhBFJUZUdQ24iIB0VROHvTbmZScZzJkkMv7UAGguELiy/rs34+ON5zXIML02k0Qmi9bqtZ3T+r4q03LmSCgwadoJEAGB4o+K4IU30pa0IDSvMi6gXEk1kQePGhDZBSERr44hrPHBD0aT2RnW+WQc3HfysiKfHYc+plbY9pyTczUrjQtier6IKmxiN81L3q/l1Wwa+JFgecpkxJn0PNQxPZaPk53tbaDJ97wcEWAlhSLDO+fka044RA4qo8s9bRFcdj3kFZlViMq3+Ut7HeCUuPZ1Lsl9cSwNtOvTRlEzILq07LlsCIi1LyUMnGEEhGTPqGcfG7p1bT7BvWseNNT6nkwQoT/BZBi7Cgrnmg2jf8b
 Z1V2Pr9e
 ZcCcKpGT2zDUjMLYhRWPl+hdMC3WbwI0t3J9VtEGQy5VNrW+p0CPJW7O2nM6/wxRfHij3we8eonY5WGlolAU47gQRCsaRXqQgtkwy0kDdOUk1j6kY8SawTZqND6Su75AyIxXxrI3xIR8P2qnEtAGd9IU5lhAMb3Y9Hsevpt/laTaDXO6U4hvhdNkiLJXcKOk9zCuVkQvcIW8UaApWc6zn+i42n5MXfPRfG06m0WmjwwyQV1Z+M7G+hnxiV1Msei0yla7tSpMeNopkIDFCccaYMHgTE/Weffgp1W1hNP8d3BpAitvr8S3jGYbUNloQsAfNfkvyY+/qH9XIw/JZVif0CgFwrCcfNYmJETkffKJ/eSyXbHl+CNEHkMTqt8tsMTnf0gMydfCB2KMNMtLbiNOu6st2QepnWgXGfQ5Zfmu477k8SGBzeLSd/aiTPIh0BlGWHdqejP7wGvPft45WfXk0dByQM0cO6MHQGtAp4DhtNWkV8yzl+xRE9vVigQM0MO0/zuWhjrvjhKWENlYyZk8QEK85sZ4KoPbvwSU5rZLFbLd2BdQ=
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


