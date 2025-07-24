Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0772CC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C598E005D; Thu, 24 Jul 2025 05:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16178E0051; Thu, 24 Jul 2025 05:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866418E005D; Thu, 24 Jul 2025 05:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75C0D8E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:24:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43124C02F5
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:49 +0000 (UTC)
X-FDA: 83698623498.04.727CD79
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A96240006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=rbSFR1mw
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46QW0ZKTJsCdAnI774T47O1RlPj5t6dUczWWbfa0X0I=;
	b=iyVkYnmX6GTKjsAILmj+jBDJ4OvTz2Nk/r8HnLGhz0AAkL5iXGkZlS3JrIEN+4QQktHCAN
	KszVt5VUnWq12irnaXXn6XhBYk14iwiX/HgzlOo5XvcgO3FCc6pf40y/0mssBa0DoTsf8k
	5aufhwWuna7Spwa/tRff+vCJ6H+mAYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349087; a=rsa-sha256;
	cv=none;
	b=7JYJolZvuo1ka4g+kYnZijDMo/cJF9H3EZXgJe1XpniAAgXh4Ybm7s5qo7IIAHVxS6+37z
	qnHw0gXMkWIDIi/YOjaNuTwseTu30SgwRm2LCedPmGYrRc+9GrfxjBJyuSdBGnyDoX1/ac
	+VCd0Ax+nHbQ5zkzS2rnDbbdztQAJm8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=rbSFR1mw;
	spf=none (imf11.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.53) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-455b00283a5so4552255e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349086; x=1753953886; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=46QW0ZKTJsCdAnI774T47O1RlPj5t6dUczWWbfa0X0I=;
        b=rbSFR1mwv2HhGk04Umtqh13/BqyGduqTuCjBCjqjL/aYMgJ9re3i2yfYKMqbnTd1zV
         EFUlveVfXCYBKr04z1grvUy4tn7W6GG8xTfVwckU8FmWuXmIbWJoEHJDjrG1eUzJm0Yu
         B1us1daDroWEm68S0UFHxJEqDwftde5grnEkUTtCrJhRUxRcnfapqmwrM0G3yM/VQZ+r
         y+YIkYwRJZLTGLFzPy2JioREloGCjsz7YRGnFP98qncAkhlqd0GpEHqH8pFvMtdXxQsg
         WqWwMAgKlwCOi8mtJA5KR3g410Cxr1Wr27o8CTWNfJyB8nRjMEayRYAaHcpsTG9O9Aoz
         43ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349086; x=1753953886;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=46QW0ZKTJsCdAnI774T47O1RlPj5t6dUczWWbfa0X0I=;
        b=IIuLlUWfWLBTefg2/qM83DD/KesaERlFvZU3mPEbPkgfgffwWfuJxLGta4wXcADkw+
         CkkUtH5EuvsoYvkxtBPz0xVPgMLTwZn0/AFHZx/Nz/WkoS/h0M/yuiZVo8Gf1T+BBzmI
         AbBqIWvM/i7VtinPYO3fe5t0drJhy5oGtfMEJAe5v4SywoquPWbS3iLwEUQCN70Cwmri
         0m1dnGiwOpG4Pu9dgqxpF6sCqix8fC6xSoOq500p+lh0wWyWkZOQJbVwy9srck049Kkb
         8vcw6cT28x2dJCmAgFR+gDkAPC+Epx8O+WuhOnPYhTv6QSDF4E+MgTL/B+lVdYqBkj1s
         j2JA==
X-Forwarded-Encrypted: i=1; AJvYcCU2EHF3Zi37Cr8ozpg8muSof13UklRgiTsO9UeoC+yu/UKAchzy3VGzNtTC4tOUIopYYgb7OJVD7A==@kvack.org
X-Gm-Message-State: AOJu0YxQd3LISIWmtpFDbeFDSMMnrWGFbdkfJAtDTH/Ul+ET9Zr0kyRc
	6DSf7NtYVK9mcR6mfGYHTUwGttDycde8IL2wea1soybM+p1cbKeHkTHqZnxMJ9L9MTM=
X-Gm-Gg: ASbGncvAboTcRba1wXlAmPoGNdepx9mZzAvI7uIcKLO7JKJpc1Dyksvdo9lL3kqlKa4
	GAFrFhc++QQDy36kGdCxQGN855XpGW8pogDMitX1hKaPm3hedM0Vakg7l0dPLa8CTMGQCmX2Czz
	Gih7zNr3ou/8Rvc/YO3qWibFBFQjbtmrJ/x+tH8/YfN8ogajEQa6BriFf1OO3ijQ7z14YUTkRGC
	cYbKyT1lKwFta/Df7n5mIBwU298mlYqs6Hn1ScK6ACnLrcE459Hw4dG4IyPUjy/OtZPtJUIpzx1
	mMtspyloquoU0+q38VQY9jfCK79B8B5Coo5m7GyljltZJ5W9EGYrKhkFs7rh6H7kPSCU0TCtDFa
	U214ONj5L/bAFOkLHRfsZSjDXaxI=
X-Google-Smtp-Source: AGHT+IFOeuH5zAlzFgvpD4Uz1Y06PKqXYxEckZmMDNMfNM7DLyHZBB1RdoHcgvW8waqnzfrmwOQl3w==
X-Received: by 2002:a05:600c:524b:b0:456:1d4e:c14f with SMTP id 5b1f17b1804b1-45868d69f9bmr48489405e9.28.1753349085686;
        Thu, 24 Jul 2025 02:24:45 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:44 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:32 +0200
Subject: [PATCH v3 04/15] pinctrl: mediatek: mt7988: use
 PINCTRL_PIN_FUNCTION()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-4-af4db9302de4@linaro.org>
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
In-Reply-To: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
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
 Geert Uytterhoeven <geert+renesas@glider.be>
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
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvSq96zx0eWj6bB9Wtc62trZyDHOOqVEGsjt
 IdJru9X576JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70gAKCRARpy6gFHHX
 ciU7D/9ufNSr0xAVjM3jLOYmhiZYTdSmu9d5m+WcEwts4F/wCHyNf8esGOZyhn5wUjORYdUjIo7
 eZFKz74xSLCU+omhJ1JyntwjO/u19pUr3cA16S53VWhQ8i8DyudgfzMCynaEO+AnlG8W6VDdloD
 sjo/e3GaNpK6UIS4gfqVhDkQhxARxrFqHhSAQfpQcImogDC4D25D6WNHBCJ/Oo6cCCRTR/4axFR
 5fcvSZA2dU9/5y5djCi2V6yQjYVC5XxZag/q8vTGMaAcJjUmVLBnVtBFhjIotVORY0DFi89nEJL
 y29d2wQbwZAOrDZPY9B07IB7CI52j77LdHf2SL2NvSselkHKMJKP02SNXEVQK7F/y3mXIHsbkK0
 6WgTHe/owJNiV3POTwFKWsLJOysiyDATr9qIvSJlM3/3ime6HlRo+lNLFtzONrpRFlkPeSRhiu0
 iJL3dlJh7FlYdAqI3NxP0sv5V/OFNyZqhCCNgEQwxbCWnuXPUftsK8TO0Pgrg/d32RYhOzUXKTp
 jt4cHWwTDpHenhDSF+VIkqTzNlyQ4S9TZbS5MACS9G87yVokvxr0o4q6us3KHaO5AVE1oqlDCdX
 ooIVrJFsCF7yvuldW8SymXwAJYAFkarNAtra2A7hv7HoAO0kE1XOl/gDenndsNED8XaEQSmOW1C
 uxnZKJm9mzswndw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A96240006
X-Stat-Signature: tq1bk83iuc1t4bxeeajjfkmetkaqq7a9
X-Rspam-User: 
X-HE-Tag: 1753349086-208478
X-HE-Meta: U2FsdGVkX19e8Z4fiyYnohy1AvgI6pTaXCM73qb3BtA0d51+LfyFSCoMe60LjqUtknII58qvbyC+u+TJDRDIpc+y/yTec6W4avUBmvImvSNRI0meDrdLT6p3gS+uyZu4DJ+W5JbDlsW9/TXRHFKvKE9nBsU5nYlWQUDEJmympOxlP32K489MjNQZ41habiO/Q4Eku9K0axxsLRSxxKabOVubMNbr80ixf/F+vR3WhGV7hNrpWDFwST+mQTIgn6Uw4KrqT5+f6vJoT/H/cfm9I7az5tQSplroqdR7u45FhmQTPhZwyVmW7Rxn5gijxRn+mZXsA827DnV/xXZiNwPIjteQhIAEu6C/+rYGHSepZxOEbRMugA+UuaTOjiyWkygm+ThRHLWXwJ5iFPDdJEaDnXirqqju7ntTXaPYJ/uX9ELnugZMlNsV/HdGEbn/iME2BCbmE5zoRs1k3kfSiUz5WFcYnPMbz00Vfj/2AuWYRxjaRPp9LDkXtcx9OX7B/izqT+TakajcEMR1HigSsxyQNLr9Hbu+44sN5eyxQE6G7rN6u6BF+Rtc6eq141zaGaurH69nfjqG4GWSsUtpHF4lXjkckLl+Y8ATND2jQUiK8aI1dAtsc1kvSFMnvGbTju/3jT60SlOJxr8Xr2Q8oeGmbE1PhrF9DnWotNLORuT5xh3mK3A8cf7x1+zY5v/XjLrQFVl23bUf6HGACNjdfPriEYIXhQOhO84D8iH6GlOSs8Xz0+J+je+f5GuwPJV4AKO3ksmkK/wA2uDYd7+hVYFZTwMgr38sExvvVP1AIWOflAQbB1gk27I1BwZIkh9KC70BqA8kTS41mMP8gzTf5yPZMsn/8SFyW/iBexYY9V8yxYXhHOw25rArU/zoptILfavWvROkaIZVgiLXn0wRJ/ATs/I8a+r29ufgXKs4Tfjo4MwmAnBE3Kl7+bMH2rrBVkb+cFVNDG0Iib2+o5pTtsZ
 c25wUfiD
 lgYXVbpzyssbmfJ9nlt8HmmDv1OXWL5YUu19tgcFuuNCyMsfmKYCOSGAeJGHUm5lG3FqzhCYvg41pVKnt4wQK9e9PziJ6CTyisrZ8TOuvDeGJhuVN7b7RZ4GsnYC3AyKxlcT5UQ2CJc6prN4C8NZuW/GSj8AT2siYxWz0iIfqNkocRNR59J70XjHG/0/maA5VRy8vJUHOqYEw7AA5z4+PXDY43cLZMFVGWvEpERDmgODcp6DIlfZqSv+1XMTlmh+e2E1SgG54f3R38SvTtRo6DQtMWwIOP9i2TiDRHy3M2dMbgH7geZZZ6XVFDhiQyJW7R3jvolkcg6X7wScHjrk5e6mshS+/XqjagPttXEdTbjiE5ZUdY59FW3i9wDd2w/r6rDyP0ePgLpKHWJUVPaKbHSp8V3Gbaox6Om3iEv6Z4IVwklHLrjfqeeHmeHuwDKtw0taq/YAXGM6RQI6ma2rNXkBwQ31vGOCOqZ7YNobqDrtTaSJXLNB03Ea4yOedt8ixLcrxphRxRZYka5WwVISynXUz8UhzXqQ9VnGQ7QNtgAXuZy8=
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


