Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7073CA1009
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A30B8E0016; Tue,  2 Sep 2025 07:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8540A8E0001; Tue,  2 Sep 2025 07:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDA78E0016; Tue,  2 Sep 2025 07:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDB88E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E821613B8A9
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:27 +0000 (UTC)
X-FDA: 83844165174.12.23ADA0F
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id C86C3A0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=WtKLdtA5
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgFR4JYzku3DnxtnEcUmOfGy601E4B4cVXuLJg4blgE=;
	b=sEJFYR3dpB+CkdVcNwbm7sZ3rbl4OuWURI1FEpkV5kYp/C/73FtRN4kAZeg5HwGN/RL4wQ
	WoRjrBmSNw/2QMBrcS/h7Etx3bH4wJ/dNdT54dKb7kDv0hzjLUEIbOKIZROfH3xZKajtjP
	iQvWi9N61z/9TTvYbzRvy6mSWxYH47Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=WtKLdtA5;
	spf=none (imf25.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.45) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814365; a=rsa-sha256;
	cv=none;
	b=Z5P8nXEYZa5gSMyxqfRz8VuCQ/zZ6bU5W7bwAEs575XeZOqps1iOvpSp5gsH6MuIlxfSsc
	ROCNSJFJr61VlX/rYpt2WVxKaJczrV8Bsw1Wp9HTyOUJP+LGXleXhZCcZfrPbfnqDrwmNJ
	RfX8dILeplEZWbKPLXXZAmN/4JuifP8=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45b84367affso28070745e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814364; x=1757419164; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lgFR4JYzku3DnxtnEcUmOfGy601E4B4cVXuLJg4blgE=;
        b=WtKLdtA5t7zRJwjjHtXL5j8hW3rMvyQqmAcjqvjTFUOcf82DAJlwCtuAvwyPpoqcYo
         W2vc5s2hsPmhpmi9aadA3FwK0+6aEt641Av+s/FW9TP6KyD7rFV1y1Bs0Be/3lneYhTD
         djB/AdTFXP1/kQVuKtsXE1KzQBZCVXRkdIOBQRe8dl/PoLsHRA9+24C4g9tkNytDyQ4m
         +kth7K/MU62/4D5gnt6lFiAVx0HKJNimkRX6EohgaXTBwjk1kfUqSCWyAQwaiuzZLt9F
         7cjSc/E3TVtssM+4uJ8R9uEhI8H//Ay8TuHinRbagfrjpKnaf2AfEw6AioOYB5nowOxM
         JcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814364; x=1757419164;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lgFR4JYzku3DnxtnEcUmOfGy601E4B4cVXuLJg4blgE=;
        b=nnR5hBNpucoyhqOrVe/1dt5YTP1Z40Y/w3qzoatcotmNNDWtqibPelmc3X+TsFHzHz
         U6GkvJGMBPvlDv27az2Uv+uYgnwi5IXbL4u3zINU4lqb9TvslslrPAC2mkpzqOvzwvVx
         utMsG5RGPm2De5sFN+YRxAKf/7Lo48bFYpOUnmiF54iS3RYp56wtf8SkxXvMj41sRrK3
         25njhfKs09wtnceEbuoAmp71+rZWlZwn0KyLAMi6ZiTfLNCRtul9GNYL/rlrhwc2l2Jj
         KLEQhcvrjz9qQp7mcgYV4j2PVC0ItYv2m18//PGUxl5NSvSTjIu1Z1+QTbewh6Jg9/hP
         qk6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUhzjWUA1+UqN8Q0yMySOVoRwcP9+q+PW5iVLl3i7l5Xuek8hatjT36/E/b16p3cGGUoD9iHsFVPA==@kvack.org
X-Gm-Message-State: AOJu0Yy3VCt6ERpiNcCSDEXn5ADOqn42SfHEar7TbiLslhC+xAQ9kgD5
	5OM3a6FnUAFGH3z46b3WrJ0dV15ooOK8NVAAmg3lZtDCojkdUNHzKpjeBZOjTQ/H3VQ=
X-Gm-Gg: ASbGncv12pnU5ARx+Bol+22IMyCBCRWHjItXtlDZSOBm/Ln/mY0O0W71EBRCTJRGHHJ
	ICvzz4osrFT2kp/hGeGbqRbDrptBpa556O6E6jne11mn7oYl/ageD6Ci1mE5UzhA7TorXodDRPQ
	nvgEk7tTCn8zxUSudIpeWN46Y3P3508R6VSjjXJ+qknyCWIOySGJtp2ay8/Oeg4LcBfLZud1b6/
	jtsqq+1WqgYinBzT9Y7w0RwEpvFAEWos6fcZcbNHbN88QzUooHyD3vaAJqM6qFDl085rgiMc0Qy
	KiYmMoAbiFQVAVQFBAm2Jy6cC36s7+aI+hYfj6FBblCBmokEroTrNu0JDL1KYGuryhezrfHWWzh
	Yan3lKjzRBbxpuD5N
X-Google-Smtp-Source: AGHT+IEKXsHjEUhuH6wRWLK489irD13ITqJD/VynaOuVYt4g+rvkQtR7GAX4bOkX9Wr9zTMFFREQDA==
X-Received: by 2002:a05:600c:524b:b0:45b:84f2:76ff with SMTP id 5b1f17b1804b1-45b8549c809mr92371695e9.0.1756814364206;
        Tue, 02 Sep 2025 04:59:24 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:23 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:12 +0200
Subject: [PATCH v7 03/16] pinctrl: ingenic: use struct pinfunction instead
 of struct function_desc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-3-bb091daedc52@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9044;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=FkLrNkeOzJSHzI/Py7RyDUr6KQps7dFmE2AsFFRpc3M=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwS1UKRgkb9ccIEU3IZ3aW5VjhJjzIWrcLvA
 hZ9ye192huJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcEgAKCRARpy6gFHHX
 ckpiEADcWoZprO9Xud4RwPgcecXpho5pCPR8wMVVtHaWIF3NsJfE2Kjy2nGdi3EpUqADsyOJnnb
 UJYIoAWcyM1Umxp4vDl5gaQelD8e4X3w3aFvpSYpH29Myl8Vw3K/UWIfrgz0CZv9OEJvWDQwXT6
 K664I284sIKrYEtXGYTUZ8H2Ffj7OEF2Ts221vDtkho1puGzJX7qzs7Fdf1Q27mYeVvhL9892gm
 atbQcnqjY/a/8xKwCyJJmaDmrnLnFoReX/tB9MEWiYLKK6KsQXApTqPgAQJ4hyQFwYGZI/UbNUE
 O4RnB5pZ3IbLMWdn733nIeeUbBywAKt92kxjmv/N0Ovl/8cwQwmNMwqJkvhZKdJ/KCmxhr8Xp38
 zYsfy6+sY8+dbnRYqDcXxOlZcWMegK1eKgyUc6OEEktog+JNGoYYeDGsILee2KqX7N4BYCP4a4u
 VuJfCSLrgH3iNwUTINLmcIYULAebuoq+BdjBKhPLlma8tq2jy9DRoM05S9gxvcr6ShCo1X6yiF2
 v10RD0B9g6NqC4oN7ovyMhSdts67P1P0E5cDbF7q9b5XaHWokUaarYXFUCu4O8aMrDGu84GkkUB
 j7GGq0nJrNfm5dsdUSpwJSnQR7bqwb/F23b/cCfFSEe69ge2KLJiQiEl0/teWhWx7WKIr89iWmT
 JyuUv2S5n9ijytQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C86C3A0009
X-Stat-Signature: fiktutyenh5qeumy4hknwdznmma9a7z4
X-Rspam-User: 
X-HE-Tag: 1756814365-380119
X-HE-Meta: U2FsdGVkX1+NAg3+WRZF94VMhTgLdfy/k4i2iwD7Yh+gZB9d2Tbi/pjyaPX7Jbx969PlC9QKHVtGzcw1DwfSK6lK1CTyyPaSzgpgWztTB8GKPSCFmN6Jxa2phbjsuFzlBC6HIszPG2c0Xvn0+4SPxuy2XkLBO9WXWyzxxS8IiSL2LVmTKBByrDIaW13GJe24hz84TPT9MtXCWqnjfPTmcLlBsIMD7KfNK0dSaBHPEe8FQpAm8AjQP5kTqq4cp3VN6Sv5POuIqdNvI/s/w6EOBt2H2PhPZvZtbiF+qJY+CwTKDH9jv/P44yTTnsrcBoNCgVokU8mhN+ISXXHNY6KhItTd4OvrIYJfuAhR+DLhbCAGRM+ccrjccWdXaeK4S6w9/GSeukQQ3ZvsB7bMgVed6ruBK/r2I1JgD8VsVhZoe62FBs89bbp/WRoUPyYIUU+fEc4IP8jowy0bfia3LeBI8uhRuPHDzxulUrrI04fiA1oAKwn/0Lnxd8ACrso1+QXfC/w5YjxfVg4Ifme0H6rC/qW+/e7l8JJUeydNikkLJVcknMuLpOi0aMpfN/ulaO/EwEu/WT4pTSbrJMKGrl2FXPnmzBpnB/X7R9l0yXA3R72p9pF2JiHfIIQwmHrubzQkV8zbK27l+vVZ859qWowPZU575bQmeAHIiDjGsFxcL8pX1+3Pxjjrxl8lWjLg70I/bev2JobKrwn6njciqpZmGfOkqtBExxjOOv42aLN/J1S6qMt7JBPdaUXJknvlYYZ3MZCqUjXXbDhcs/s8BiZ/+m0m++ime//jOySycheTgHripuzjX0Db9hbMyPseB6ZpLKG5ItYXAK45vCzdW+N2so5jG3fNUuEv7Sdl28usLfjZSN6tZ401dNYJLOsg3ZHvcKMjVtnxjnm+VpUiOYu8UPgGNr65R7ETqKVFFnQ2FcKmPZxLiJwSRVX4pTpF/rNV+mDrB78BqPPonMHp9tG
 icDAymof
 dMx74Rywbe8COsRpKg/5XMDpf79xI3Bx+WJPlF9hz0JmyecO0rGS6R5pEinXWdp3Es2dEQiP/s+LGv7Qj1NnwByZxbd8mx855YZqsGWV6lPFvcON8uuKaOZy2+s9AI349pwlGufCw4fIwH9E11Yk9Jfk5gGCm7tm9hcvJpXA8nV7UPQvbif4TuzqMK6pwEVhKVRJS2UXM90GgLyuPGiHg73vutRaAY3WqDyyWhbiTvVas2JR3dNW3GTZiE8DEwNiHsLp04GSFXwF6W8Ofx8JdlWZOAajUm1/Cgtm706VXsdoM+aFEi5BSELNg39eee873N5KR7WihoZegPdE5yLu7UJQ6wU8hgSZc/v9sF65zHIttyThqGUwaeJf+xtJE6/FlnEshvncWzaq4lYKthVDJya5R3mf+UfuRUubouKzowr9yw1dE8ra5CPAfOq2N46yAy2JEdo10alB8S2LJNEqn6JHVheajvcg6javLGSNweyGlswwD/oVQ8w+XKvLtrsd7FH4EMxjFnfMW1xeLHxTfmu8WeVZ6gvRoGtrn95FNBAdHjSKxIBQF96IQX+Kf0+xEYzhaoLn2xtF3c0Cil3OH23XXvS/l/Lsc3MwBVx2rfbRKU1c=
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

Acked-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinctrl-ingenic.c | 45 +++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 2900513467fa4e2e9374946fc9c7a30d48aef9eb..af9d2f3081859bc4b22f6820f3b3753eba36f959 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -96,11 +96,8 @@
 		.data = (void *)func,							\
 	}
 
-#define INGENIC_PIN_FUNCTION(_name_, id)							\
-	{											\
-		.func = PINCTRL_PINFUNCTION(_name_, id##_groups, ARRAY_SIZE(id##_groups)),	\
-		.data = NULL,									\
-	}
+#define INGENIC_PIN_FUNCTION(_name_, id)						\
+	PINCTRL_PINFUNCTION(_name_, id##_groups, ARRAY_SIZE(id##_groups))
 
 enum jz_version {
 	ID_JZ4730,
@@ -128,7 +125,7 @@ struct ingenic_chip_info {
 	const struct group_desc *groups;
 	unsigned int num_groups;
 
-	const struct function_desc *functions;
+	const struct pinfunction *functions;
 	unsigned int num_functions;
 
 	const u32 *pull_ups, *pull_downs;
@@ -263,7 +260,7 @@ static const char *jz4730_pwm1_groups[] = { "pwm1", };
 static const char *jz4730_mii_groups[] = { "mii", };
 static const char *jz4730_i2s_groups[] = { "i2s-data", "i2s-master", "i2s-slave", };
 
-static const struct function_desc jz4730_functions[] = {
+static const struct pinfunction jz4730_functions[] = {
 	INGENIC_PIN_FUNCTION("mmc", jz4730_mmc),
 	INGENIC_PIN_FUNCTION("uart0", jz4730_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4730_uart1),
@@ -370,7 +367,7 @@ static const char *jz4740_pwm5_groups[] = { "pwm5", };
 static const char *jz4740_pwm6_groups[] = { "pwm6", };
 static const char *jz4740_pwm7_groups[] = { "pwm7", };
 
-static const struct function_desc jz4740_functions[] = {
+static const struct pinfunction jz4740_functions[] = {
 	INGENIC_PIN_FUNCTION("mmc", jz4740_mmc),
 	INGENIC_PIN_FUNCTION("uart0", jz4740_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4740_uart1),
@@ -474,7 +471,7 @@ static const char *jz4725b_pwm3_groups[] = { "pwm3", };
 static const char *jz4725b_pwm4_groups[] = { "pwm4", };
 static const char *jz4725b_pwm5_groups[] = { "pwm5", };
 
-static const struct function_desc jz4725b_functions[] = {
+static const struct pinfunction jz4725b_functions[] = {
 	INGENIC_PIN_FUNCTION("mmc0", jz4725b_mmc0),
 	INGENIC_PIN_FUNCTION("mmc1", jz4725b_mmc1),
 	INGENIC_PIN_FUNCTION("uart", jz4725b_uart),
@@ -606,7 +603,7 @@ static const char *jz4750_pwm3_groups[] = { "pwm3", };
 static const char *jz4750_pwm4_groups[] = { "pwm4", };
 static const char *jz4750_pwm5_groups[] = { "pwm5", };
 
-static const struct function_desc jz4750_functions[] = {
+static const struct pinfunction jz4750_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4750_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4750_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4750_uart2),
@@ -771,7 +768,7 @@ static const char *jz4755_pwm3_groups[] = { "pwm3", };
 static const char *jz4755_pwm4_groups[] = { "pwm4", };
 static const char *jz4755_pwm5_groups[] = { "pwm5", };
 
-static const struct function_desc jz4755_functions[] = {
+static const struct pinfunction jz4755_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4755_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4755_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4755_uart2),
@@ -1106,7 +1103,7 @@ static const char *jz4760_pwm6_groups[] = { "pwm6", };
 static const char *jz4760_pwm7_groups[] = { "pwm7", };
 static const char *jz4760_otg_groups[] = { "otg-vbus", };
 
-static const struct function_desc jz4760_functions[] = {
+static const struct pinfunction jz4760_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4760_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4760_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4760_uart2),
@@ -1444,7 +1441,7 @@ static const char *jz4770_pwm6_groups[] = { "pwm6", };
 static const char *jz4770_pwm7_groups[] = { "pwm7", };
 static const char *jz4770_mac_groups[] = { "mac-rmii", "mac-mii", };
 
-static const struct function_desc jz4770_functions[] = {
+static const struct pinfunction jz4770_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4770_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4770_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4770_uart2),
@@ -1723,7 +1720,7 @@ static const char *jz4775_mac_groups[] = {
 };
 static const char *jz4775_otg_groups[] = { "otg-vbus", };
 
-static const struct function_desc jz4775_functions[] = {
+static const struct pinfunction jz4775_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4775_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4775_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4775_uart2),
@@ -1976,7 +1973,7 @@ static const char *jz4780_dmic_groups[] = { "dmic", };
 static const char *jz4780_cim_groups[] = { "cim-data", };
 static const char *jz4780_hdmi_ddc_groups[] = { "hdmi-ddc", };
 
-static const struct function_desc jz4780_functions[] = {
+static const struct pinfunction jz4780_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4770_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4770_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4780_uart2),
@@ -2211,7 +2208,7 @@ static const char *x1000_pwm3_groups[] = { "pwm3", };
 static const char *x1000_pwm4_groups[] = { "pwm4", };
 static const char *x1000_mac_groups[] = { "mac", };
 
-static const struct function_desc x1000_functions[] = {
+static const struct pinfunction x1000_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x1000_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x1000_uart1),
 	INGENIC_PIN_FUNCTION("uart2", x1000_uart2),
@@ -2341,7 +2338,7 @@ static const char *x1500_pwm2_groups[] = { "pwm2", };
 static const char *x1500_pwm3_groups[] = { "pwm3", };
 static const char *x1500_pwm4_groups[] = { "pwm4", };
 
-static const struct function_desc x1500_functions[] = {
+static const struct pinfunction x1500_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x1500_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x1500_uart1),
 	INGENIC_PIN_FUNCTION("uart2", x1500_uart2),
@@ -2562,7 +2559,7 @@ static const char * const x1600_pwm7_groups[] = { "pwm7-b10", "pwm7-b21", };
 
 static const char * const x1600_mac_groups[] = { "mac", };
 
-static const struct function_desc x1600_functions[] = {
+static const struct pinfunction x1600_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x1600_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x1600_uart1),
 	INGENIC_PIN_FUNCTION("uart2", x1600_uart2),
@@ -2779,7 +2776,7 @@ static const char *x1830_pwm6_groups[] = { "pwm6-c-17", "pwm6-c-27", };
 static const char *x1830_pwm7_groups[] = { "pwm7-c-18", "pwm7-c-28", };
 static const char *x1830_mac_groups[] = { "mac", };
 
-static const struct function_desc x1830_functions[] = {
+static const struct pinfunction x1830_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x1830_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x1830_uart1),
 	INGENIC_PIN_FUNCTION("sfc", x1830_sfc),
@@ -3225,7 +3222,7 @@ static const char *x2000_mac0_groups[] = { "mac0-rmii", "mac0-rgmii", };
 static const char *x2000_mac1_groups[] = { "mac1-rmii", "mac1-rgmii", };
 static const char *x2000_otg_groups[] = { "otg-vbus", };
 
-static const struct function_desc x2000_functions[] = {
+static const struct pinfunction x2000_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x2000_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x2000_uart1),
 	INGENIC_PIN_FUNCTION("uart2", x2000_uart2),
@@ -3449,7 +3446,7 @@ static const struct group_desc x2100_groups[] = {
 
 static const char *x2100_mac_groups[] = { "mac", };
 
-static const struct function_desc x2100_functions[] = {
+static const struct pinfunction x2100_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x2000_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x2000_uart1),
 	INGENIC_PIN_FUNCTION("uart2", x2000_uart2),
@@ -4571,11 +4568,9 @@ static int __init ingenic_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < chip_info->num_functions; i++) {
-		const struct function_desc *function = &chip_info->functions[i];
-		const struct pinfunction *func = &function->func;
+		const struct pinfunction *func = &chip_info->functions[i];
 
-		err = pinmux_generic_add_pinfunction(jzpc->pctl, func,
-						     function->data);
+		err = pinmux_generic_add_pinfunction(jzpc->pctl, func, NULL);
 		if (err < 0) {
 			dev_err(dev, "Failed to register function %s\n", func->name);
 			return err;

-- 
2.48.1


