Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C07BCA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B11900233; Fri, 15 Aug 2025 05:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEAA38E0002; Fri, 15 Aug 2025 05:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64BB900233; Fri, 15 Aug 2025 05:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC1568E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 829891A092B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:26 +0000 (UTC)
X-FDA: 83778418332.24.0140F45
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id 967FA40002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=MUCgJvv4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxPihWEE9okM75l8p7+ohG5rL5D7+pdcAJ7iXomcZQ8=;
	b=m1o9jaUZya+DmvJ/KJlZ+Ia2Ugv3YJyL28aVJ8mMYjNc3yUc5r10I3LdGq/Ym+MRgj7iA4
	82Jzn9NGhsWjZ7dLX8hPmQLxJUq/IldG1L8tBi9ijXqgcgC4jIjvcwh3repKUMtI9FdbI/
	eOz5GddZusOJ7kdNEkBrzmhWid8CAOU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248964; a=rsa-sha256;
	cv=none;
	b=RL+ktQMxphrprava8tXx2FwjqdILNF6UTOYrYgtpVw2LsAhD3Y2EkzZXM/B17lvgaKxbl0
	Zz/ozp4x7azFC9RxW3ZNwJ3c6DnR4XtGfYsOcjdyqTNykbfHOOK4dgpxsg/t9ikN83n6TL
	pa/trigb6NatA0pA0Nj5Gv/5I/5WB5Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=MUCgJvv4;
	spf=none (imf01.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.41) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b9e414252dso907170f8f.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248963; x=1755853763; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AxPihWEE9okM75l8p7+ohG5rL5D7+pdcAJ7iXomcZQ8=;
        b=MUCgJvv4I6wMuh6+B1Jm6bOqGjUqt1rKltlTBocaUQz3/v8upjnwvr+ktmISHOL7nl
         5ZrB3Xz1SoK5bcR0SO0bhlhx9j8z82wnYUDx9IaD2oFjr4f6lVtIOtRr9Qi+J2R6Z7Pl
         XB8xunyt6zVcTzGzbXMgiYaoKeSZKHxQKJfi5+sgLTYaC0obDp37rTGuJHRT+cpz6eZ8
         buJfe2dueJrwIWz0f3udvPY3mk/7/DnLEtrr3R+Yx/RducXQaC4C/oLQolpNC9wRgRFn
         dZfu94dXbTi9QJ/35H2iRHfjgyIYcNb5ZeDrxqxkbZwx17FBSnvR3GSoBFmsomIN+Zjw
         sY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248963; x=1755853763;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AxPihWEE9okM75l8p7+ohG5rL5D7+pdcAJ7iXomcZQ8=;
        b=tVuELMGhu+ZT4lYyRKDpkJWME6r82FX+gepRANueBMDpnitDE4t8+OWZ0g29VYHqnD
         ELLImRU0zuWl92/5gNK7jvaUeKIlfsyRrSASWVHc99bcZHASPkatN76oFL+qHMj3LpMX
         QcM0XnC//PgqqRmYtoVhjBMxWmmhOKCe7Xhv+5QXBYSKXkDZOTIkdcOyKSbK9BsIXJyK
         xItnLo6KFfpWTj05TWfETfZbBN6mhuA19JHKbyk+zJFh58pRO55ZQi9ZHWnYvRHjracf
         z1OAThDopEwUnl50QgOts4TTD+fZiEsIHSsYlJrQ54/zLs0C+a2igb7X8h2OGM6u6sVu
         6BUA==
X-Forwarded-Encrypted: i=1; AJvYcCVqED5L+igPwsjh3AH3jGSGQZdGG33YOcRuiihq/3dnemt7u3jbwYn/zxnbe/x6rIjBikKjX47CfQ==@kvack.org
X-Gm-Message-State: AOJu0YwUaoLxA7oSKn1hn17d6Hn7glc8Ny2Hw2a8OvNHtCv8QhyDnwzm
	qa2h7E6mjENxLP2iqhOhz+p6SDLbH0UZgeATZQAJqoOKsz/F7025fBcLEN4X5n+hsXk=
X-Gm-Gg: ASbGncuWXc2YdvM3BNbIwr9gAB2nudAMLFYm5RGmjqWdJEydiGRrIWSZjhdnK9sNnZD
	IXlPL2OJ2JoIUy0eo6BpqCzGpAI4Hkgzoxyw9o9CH1n/Tl8DkPUPAm5aqvznkHcychKc9eF+vMg
	3MnNEaXYTzoOHMITVgJ2lOSTJXOUGr/UzWpRbfO79AZ9+5gc4OeuSJCZ3ai+n38Ags0VlNFy9Mi
	ou6S6CZuCOryb7u3L2DJFkACZg5nVmuc85rLUGTmhcB5Pfes4+mkUcz037Cmqlxxplakqr6/zNy
	d59APP3GMpy+TIHeBpGuzJ6Qw8Z6VIooVJkNOWhQzXwFZPu4TyGh30XQmk8ZsCTxpkcfBe/cV2F
	hveXgq9l4uKlLJO/QDw==
X-Google-Smtp-Source: AGHT+IGUAXDLykutIpMPqR2CWw0jGljeultUDjNsFBqLcnpk3VzMMU1IX8ETkYGEQbzDEFH8gkziRw==
X-Received: by 2002:a05:6000:18ac:b0:3b7:fbe3:66bb with SMTP id ffacd0b85a97d-3bb694ae9cdmr917909f8f.50.1755248963081;
        Fri, 15 Aug 2025 02:09:23 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:22 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:06 +0200
Subject: [PATCH v5 04/15] pinctrl: mediatek: mt7988: use
 PINCTRL_PIN_FUNCTION()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-4-955de9fd91db@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2921;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=79i9CgDBpTwy0KAMS4vozziB177zSWYhoWrySFXqKM4=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk3DYcWcJpYjc33UdaGFLmDUkrwfiB7Cee3H
 F0qycSGYn2JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75NwAKCRARpy6gFHHX
 co6kEACQTpYK55/OPgc7yEK07WFy41u732QgiT+adm0VgMyxXTaDg3lfMIGivUSairqhrEA9JW+
 09eDY5n36AeV+A12kqPw8HD35KZbHbtTuoMuHMk8P+d8gMiFVuEMv3adO2lTScoCulcZlBDOtv0
 CE5E0kuD2RYWyiaDmsg4aMFCmrfKpA9uME09G9HtIMoR8quMRxZlpfvhLiOzU9tzn295FegYp+z
 eivL1my4FBTBszxeaQACTxWk9EcZm02fWxThXV78fuTHu5KcO9JBMiBhjp0IU1IMHsAuCU6KjjA
 PbZPnhp8foSt884XPFcFoF8Im2Pb3mFU7ej/3rozL+EoeYzM0mpAHCgurzi069Z/BCt61kpOM4v
 DLmQtREGwtgi1VHfLgTDVr+I2+6lyeAdtS70adO8lUvhssi+8nePshV7zWw/cE+sq86eQdx7ppk
 T4tfE5W0K8ZxeEEl+X3tM/O/wsnyN9fRU5QqfwC2Rr/nC3+sEjeazf3tjn3xBN/pDul6IJpRo2W
 5Ser3RMdQd1a1WxD3wSOdrJdQWXgvjC3+ZEUGE8kQg8lh71EdKNPagZZ4a5H9cDHZfe4o8ZlFjl
 v4E2HQ2i4+hiRfpZlEG24sQIZhSOFo9nfY9riA6rOJSMosbGFdQfJHPUtUCSC2EazYpbBXD/YJv
 Xoc8bWRKcVnJQ2w==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 967FA40002
X-Stat-Signature: mk3s34nojky19uswddjanb9hq1s3z4tt
X-Rspam-User: 
X-HE-Tag: 1755248964-778713
X-HE-Meta: U2FsdGVkX1/JOYLKYMGHuojQwbj8msEUv1AQS9dykzk9648wO6nRlqxWGVtpWNZTkaLQheD5vQlGpJhFEDQ9LX7vBoWvovfjfyZ4izuYb7XU+699bPZi5Se+z4HhBTKya8ld4pAAC/MDxsX48nsSqeeZ99LYYl18+9MZN/9oWE71GJhq8m6Te6stfsev/N0xMoLsfWBycQe08gbCbO1ffbAYiDtk4MNCHBwY4qlwGiRe4aJ6YeNZJZ9C+TKK8MFrZkSgsCh2gKzcaNQ5+5BbFDZlb4gdu4b2ixh7H2Tq+XISWmEr9fzJd8fjN8uaETY9CmJiXF2RaA9bBQE+/kFdqG2tFZGyWYbQkY28hkseEgJIw/PJas4h7hFyW5kdjNMdjBDixcY7RJLx8zy1KpieyrIrftDkeEG0OUzshdW5UpseP1ceap4s8K+SelqUqIezha9etVCUQ/hi8fH7KwhloCgAkqfvoEtALQlo+7ICHQygKdmHc+h2Ul6cabeaDXIkcFKjybge7zbxKlZaf0A4tP/IBbEf/gP19AbLSBFFw1wJRg0oar4c37WjX6tzI1aziTSSHAmuk3ICKeNKHTiWRvHGV/FM7NZTii2n8ZvusmjbdHH4ZcX+zisU7MdF3mf+xaTI5zjjcUP+OdN9eA0DmfcHfWB8fU3ETEIQcSrixeGAqHLdBsoVEnmedRRw1tK0l4VpboR7d9l6MsbDmX4dpTGe1abTS6pXopFZSLejcOK03X85ZzSklDmugyaOhugwb0g9Scl16DKZEh+EdQlPN6xYD6sUwBIzJ6i6c/76ZJXmYRnhjTKURaYFKNkqZZZdeyQEw37Wh8iigi/gqs2wv8z3MCWJan0a6BL/tpklY78ylbaMjXi04Mr4KgOxUavG5aRkFO7lef/Igp0NLR04CIU1FE8qaT/MmEMG675CADZGkgQfB11JjT0bgTAKulimLiq9uyLc4J/A3G2O6D+
 /3dPk9WO
 lsxA7Z4t9yLJ5B+CArr66qKAJcfNznshyYWunv0+thOOOEEvwhOv6+ofZb7u+joaAe4mRAyhi2Hmutxw=
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


