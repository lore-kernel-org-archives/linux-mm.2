Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5543BC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB76A6B002F; Thu, 28 Aug 2025 12:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40216B0062; Thu, 28 Aug 2025 12:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0076B00B5; Thu, 28 Aug 2025 12:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94E686B0062
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37EE284522
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:25 +0000 (UTC)
X-FDA: 83826628410.25.E103F57
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id 18743C0022
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=a96QC3gj
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTEYsyiptWWjSso4TZTiEeMehJGAEz0s92KPugL0Mwk=;
	b=r2pw2zqIeK6pTXs1Dgejp3LPWshjjrfioh0cEvpFPe2bZd0q/xPYIuof/wx5v5wi7ANqiN
	NciqFOmbfoCjt6fGWmLv5xG5mZ94WBDh2MQnGjSLjeUD/Wse1gqA3u60gzEffdOi6f6jyH
	6ZwzTBoC5vg0q+bkrPjKIy7P6jDJHNc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=a96QC3gj;
	dmarc=none;
	spf=none (imf22.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.46) smtp.mailfrom=brgl@bgdev.pl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396823; a=rsa-sha256;
	cv=none;
	b=jQxIzd0ey7UglKvmfzmDrWlhOA6XpJq+h91YUd85DwcnAAupUvs71qUd0eT8icGAlo0Gpy
	1MvGnJUkIfcwftiIh6kM8dXK+OJ8ZKlJBdFUmOKUaUCYFg1N2ATAcm5K3k7nLFY5louELy
	QdY+iUg+f1s+jXqkXUEy2vY/uHEUW5o=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b618e067eso15722345e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396822; x=1757001622; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PTEYsyiptWWjSso4TZTiEeMehJGAEz0s92KPugL0Mwk=;
        b=a96QC3gjjYt5eX1WR3A+c3kuLkQe4h+bdpTZ9xlOFzT0B3DIfiHIqFVnKV2NdFLPmG
         +EdHWC5+xR7Ut5DYlxMRaJ/Clj7RNVq7qYmFzbdYT80gZxzF+v8JjdScxdcS+tdZ5uLu
         2SB7y1fTyApX2slxv6MQD/GpjK3omTJM6zvzvrM+LpfO7rAo+uEWnKAd8VvCvtM8XDo1
         eSoiE9+sj92pClWAQgi4Gt3fQwUj1OsFTeJ2NYN+Sap2PvKIo+kLswSenpxfB6zlL3oV
         vpHxGYCauw9Re5F+1kDngf5FbgH+GpikpTMhnFVg/xfpR5yRxkzUyw82iktRTz9PmO9h
         HFcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396822; x=1757001622;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTEYsyiptWWjSso4TZTiEeMehJGAEz0s92KPugL0Mwk=;
        b=HwQ2g489APMMRRBKDlUTC+9qTJHFI0As70l5CvlDDL73OO4jCWbs/4le653aDdfSd1
         LtkTH6e69FKW82p8BA0dxfPIUa7pfe4NZcr00cQpGiGCsy91h1T3a+8VWQkuehtHLZcW
         br6f0hRsyXgRug9YOZ6wHh7gcjyLRmLiNbfqztNh90mPoKsPc+n6em4JBq9SOij+F/MB
         XXGHHTAFCw90OI+kB1gWlzliAgLASide43Iv+sH+BGdfshYtSfwTp42WESgoazQRNuPw
         TQLp7FLcUPW4U1mc/1ZJvooRwO/evRK+/Dj941Z5TrrOPoxoyZ7T4qPQyGarOKjTyukI
         10EA==
X-Forwarded-Encrypted: i=1; AJvYcCVezi+2IiM0EugoiXU06G88cumD+SbMg7eYRneKo9G+UCTHIpM8T4tK+1rtKSJE6TOpXbXDv2zBBQ==@kvack.org
X-Gm-Message-State: AOJu0Ywkk/5wmdiFhv71wS+l2ZwjU9yQqPGgFcq6boL3AsW22etbwb4i
	5xu2KwcJsPVSxgASIQU9c6aDnmWRkE+KwBsiKTqY710iFAFG9Mr61sBPymxapgVBrqs=
X-Gm-Gg: ASbGnct3aZfKHkX9DQM68yTw9IBeG71zJYU7dBt+ua8dtvBdXXoTMuN62MJhpJUBzHX
	yicvYlFcav1U/uR7YJ1Xeo5EUu7CBpHsI41qWu/VPsz8aSCJgKXdd/I6TcKS+31b47MZBl7SyNy
	CSsASjBz33MyC+S1N3rg92cTMcS3GtixN9B2y84gtp/uq08BHXGATfqtqyr7S83XQ54G3WPIqbG
	xOdCBnQB3ztLd3Agful8O1KP0nZjG3RxlC3JcS05FGDzxTmFvXH2r87cUDA6IcGAl+P0afJjhZ1
	AM4JsTufS8asvUrudySXbV6soFY+AnEjZS8NYMJcZjsjX5/QCD5qZ4bWHyASXycpfaFJI5EsEOj
	5HSl4XDyQ5mPJYFdq2A==
X-Google-Smtp-Source: AGHT+IEEUPRPX0qtnpnUdpRPcym4sDI7d+C9JSDMifnYxhzBDzH4zw2E/VX9R94WuI/zU63SZA4k+Q==
X-Received: by 2002:a05:600c:a315:b0:458:b4a9:b024 with SMTP id 5b1f17b1804b1-45b6870e72emr69147895e9.11.1756396821499;
        Thu, 28 Aug 2025 09:00:21 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:21 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:10 +0200
Subject: [PATCH v6 02/15] pinctrl: ingenic: use struct pinfunction instead
 of struct function_desc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-2-c9abb6bdb689@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8989;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=ngwvMKiL7WjeArNFSdBs/AB2ylnC/fm8iV0Ni8uhrlY=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0NSAuiaNKCszwfqmTlAGx4ApsdMbxmLPawo
 UWl+2+lOcuJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DQAKCRARpy6gFHHX
 cmppD/9QVDsKLZ5cJkcwxRoOidED6l4/SCMEMSp8Lz79t2BiBAthAsaNoZNilSYxuuaxILx/fTM
 yR5RFfD5iHwpJL+XJyqOMrilhdWzrSn6jR/ZAyGEi2Mf+5E6mJ5EmmBGq/GX+HqxrzFyb/8aIXi
 3DJmYcsL7aPNY8wHUcbVX6Q5RjExlCttzH3Eecy3Yfg842/UHFfRGOqDZ+UEluH1z5cCPfon4d4
 dU5xUL0WJrCIt+89wjQpcqpsWGzV/YaIZ0gDc7R4W7ITIArNF2FL67I5ouMxu+UMd8g+P3+p6Lp
 MV+xGzbc8rI/kOofT+7sZADnunYHZExzvxE01EQLJ1bLtQh8zdLDiGqCLhtAvr1Ddj1olfbytcZ
 lVeZ4bVQX/NTpopnWZX+5mJB3ebcajVkfiaq42SOhF+yIEYur+VwvAUAPsTz2qE88WNtg5Rq9nv
 hJfdcqstYL3cQ4xe4dlr7IL3X73c3dRNYprnGJIT6quDhcS+ZrXWAm+IdXuBYP7UHONSJMRYmlF
 drYKCzhFEMcKY9nrHR26cdnwikB0Tad1Lbj3snUDWTpVlVUTPvWgDk9Wo2fCj36gzkCZ42ChQmj
 5nNCRqx91t8O4tyZUxF8U/EjKiHh+zObQu+2SQAtIRZ3x+nYD+8hX2B0NSmX3XZO8dSffzmfyvM
 xSccc+sRT2SAjXw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18743C0022
X-Stat-Signature: ngkewn5roo9rgcf4kxq5k67tpfsekfc1
X-Rspam-User: 
X-HE-Tag: 1756396822-308896
X-HE-Meta: U2FsdGVkX18wahqLn4zIMWpu+ANsAQ+D3gFi0UnBIVIx18nTJu6R9qgNi/7SSh2F82S8X5S1vVbmfaW+UInRZ42ChJHDX7QPvmmebwRqCHKdLd//YKZBE6miB07jDn1f5KUu1AKKDB9WlK1E+4DBRvr9A2XGpRQGTs08tQEmovu1Knj4KU/4qiihN0Ck0DpMjYY/vx1UQNYLsa+7UVr/WzDOhIzlEg2COn8RyLQLzrRwlJnHWeDvaJ67065giqOW19bYDKqEdNnS5Ie837L2xrKggIfMy1kw4luhUP/3pktKJxB7lWPkys38KTVYi7Yg1rIl78/n+ZswNc51S575pZbHou5wyADgz5SRm03VTfvK8SF5TO9/ZtzizxEpsKJpJRcf4BblrZ+7ffq7GGqxGBoh94jzs4+OIEnL8fTm8/PBTC7DJvVLMb43bUp4Nwf0wrW22m7qiOuMst8mAH6ENpXcECaH2Q+DwmdoFT93nL5RLhS/+wOf52VXjUo/mvzT7JoZnPeVAoxeYiOyWBLAlwPHQwWvaBvkysktXzgAwYqVXG8G3ey2coBvt4E1OrvY92y6Htk886vdUGgKoEz4Q9z+1RNaiPcK0xxF6BZjhzBrRZHYCD+xuxn5MapMvmqp+wnKuoLrTMkODYzk2rA2BAGOTYzSgFQRvMAN09yoZZvG8o4bB2jFa7h3YSG4ue8887jHXKM/vD8yePoU1DDqNS6nVuDJnH/JRPD1ki2rPbbG9Ros4dVez+YpTSGT+btqt2ERKfiNJvXwWT+EZnlrP/obxiBKwe2j+hgQb08zmbldy8bC0r0oAmU1pfmWsrkzsDV7TWH5Puqo1VfQCm4IVhoYYKZ/Dhy3uWf+seq9dYUjs65z6IHsSUTmBWl0gIARrBoESFsTG8zZRhujpCIPnyiVXiHlP6bkDKCkMNKR5MZpq/Dq4YUTFAJ+TJjMqjEF9H7YPdHS/yYWpTazoQQ
 rMa9i7Th
 eGlG/1t2BdkIkyS+6qsIHQAhAcfAMM0I7sXmzK/1KQ+6mkhQGPI5Wn3dR6omPUePz6fEoJx9UHJWkHC4sUJcsPwl682jo09ODbntFimZUDpc0cHWiMF34orJXnYioVDMVjuclTJOIz+LA7MZOlp2bq8KHLInIgT5f8G2vEYShThRnwKSkH7qgdzs+OILohza6YmDEVrXZtYoMgEUzsvRuvKvPdy0bb/Xp25epvZyphMjlU2yBrj8nmo65B281qZLGuZfjKrRMHjPnPBJlayqdzZX2n/X4xMvd4b1abfHEMCnwABC6Rlmm2XeHL7DLOBgWdbJn/S41yu6a37r+/A66fgrCo029aDEa8yU4KfeUljC3358xtw8U4yJdWYvL4gWOimn+qXI4ugqVqMM+7zoZ8m52N0WhLzLcYLvt8RAHyIeNLkllvF/FprD7jQrDydO1INpDawX7hYvSlRE7ksopQMPNnIOisA6Tg9Pl6kx2ajM8b9IQNpSLFdlA7Jy9li8xuESRNytga7i1UaQqyFAH/UOFqBxq0P0ej2KoEyUAeFdjPBvw+79a7WCAGg5HwefVLYZKfWGZHS6dmvQgC6ZXY4ORUrvqyDt7DOTHSBu5Aat52+Y=
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


