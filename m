Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69590CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01B3900231; Fri, 15 Aug 2025 05:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D158E8E0002; Fri, 15 Aug 2025 05:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5A2900231; Fri, 15 Aug 2025 05:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0758E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CCE7160708
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:23 +0000 (UTC)
X-FDA: 83778418206.25.D2C289D
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4E4D0140004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=AYA5KEtA
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248961; a=rsa-sha256;
	cv=none;
	b=WdWuR4BGUUK5UAttvYY3yplm4XgIeLCNJMPM9pLLchEe/BRWjzqElKqFRqJkLx0/yJC3pG
	yu2SlA/Nd1TCeNilaSxhV3hMSjL0GcjTIZoeHCtze2REH1qXruozNXvBE3OsxIzv05WARa
	NtdYjJLUk9N6Iki2CdamDmm05RKmVNc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=AYA5KEtA;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.53) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTEYsyiptWWjSso4TZTiEeMehJGAEz0s92KPugL0Mwk=;
	b=qr4eIpo3ZRHWjhNG/SM5U5xwInHjqOw2NIc2C7wkKVKdWM4l5m0XXpWZcblitRcSX/DkNY
	upk7T0m5cVl3QEcArOZpzeMbqVTPP48fHqbFAtVrYN4QEWQlGujIeKX/1kjWsXd+qiHEU1
	b8zkehe/2HTTRvuRzLcBjcWDfmCQ0Lg=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b0bd237so13467835e9.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248960; x=1755853760; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PTEYsyiptWWjSso4TZTiEeMehJGAEz0s92KPugL0Mwk=;
        b=AYA5KEtAXsWbzrl7BNA4DSsEAmwPx5DSTO/MIIMLrNlLaEEmV1qHLNqFHnzqzNJlwz
         3oxKRn8knDCUDIhdFO4rS/BQRg/vyTxiX3axW0KfI3tkdXSYrBVAMGDlNW9L3H3I0541
         k4KbnNS54FAEQIY7ENXkt3rTDIubFb3XFPKcoFEgVjSrMtXslS+nWY5FrvX3Cyq89kSq
         gJokJ+QrsM3MGMSPNf0fPLDKyjW0nYqYEllWK8dUXzkwWBIWheMW9jurIUXfeyNCDqmN
         u9wBWjCKB4FFRIEAhHcTqDhjIPWEHOPu+3hERJQ5PIKTvDfarLm2SGySWYHfFCrQ51tg
         HLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248960; x=1755853760;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTEYsyiptWWjSso4TZTiEeMehJGAEz0s92KPugL0Mwk=;
        b=lzFKKOZJQoZKdrl/xPSq6Ywuo3ypAugsPRbMMwzcUJZTd/JdEvfWsQLsOPgfZxQ3hO
         9KJchHbDJWKxFA9McdGMa7JDlhaW58RtN3+7LXrAuKzjstC0uw2+cyxvg7z7WRTYXkVy
         CXhcBLnikdUAVhWv41uRZY1m4ci25xVwxJ1tK4jhtzC7BlDG3V2ll/4SIJPaUw5lmdQ0
         q0Wbt9zEF9MLqlTnP5VvUWkt+ujZsv4YYmzcNfQTi8QaTKQ1VPE5ZwBxYpwVyb4Bklgi
         e/C+BRzVXRrQbfc43DmK6Vv3tNNBk+a5uc7X0qd+SgdW0gg4fEYM81yzG2Io4ZsdToiO
         WBuw==
X-Forwarded-Encrypted: i=1; AJvYcCVG2MlAyL2trpUZSF+VBn6DkJ3dd+AY1/fSiOQzzYik1hq1wa1fFKD/x+kHAMJTswqer0Fx/0CpIg==@kvack.org
X-Gm-Message-State: AOJu0Yxm39pHDFdH1D0SQKh7VTbvNMBkzzAmGJb0fy+5ErTL6JCQPLbI
	Rj+bN/8wZ4cgroGnlih6Bj2ifZ/EbAfNqItXKYiXkUSg4z6bVLWnTLYkOdsZ9U12jjM=
X-Gm-Gg: ASbGncvg0QTjkU+EfeUpUSejV2L785zKjALOdSd0Bk1vyZUdHDzuFFEeljGtpBpj8F/
	J50ueijprzOu9n7Emr/r7cvd2D6M7CZ9y2rUZBjpj2ZOrbErby4FfsaQNsrbJ6YxDwc7Rft8jvl
	5Hz8DQR33fTmAdshzpKim018dROMqgeEaaHjevMn3j+P1V+57uoRCLSHDYzDeGyYUDFNWm3h5HP
	R43s/yY4CkJiDaabzmFnJJfDUiG8B6G5bUiWIYWW0scPsDl1HRWTqxZCCc0rL9GI2e50jZ+2AWs
	x3sF61OLMrkwW8t2V//YgF64Z+EghhJkft7xQw7QO2mEyOm6nRMl4Qhp45wwpQqFXcRB2DHGij9
	yqxG6f5+r3nH+tsLCkA==
X-Google-Smtp-Source: AGHT+IGuafEDk2fUEQZW8KQxsUxoxuS3rrKRRLnSrxZzWpectV45Eo45G/o23FjXP2Wlz7Hukpjj7g==
X-Received: by 2002:a05:600c:458d:b0:453:8bc7:5cbb with SMTP id 5b1f17b1804b1-45a218575cdmr12294135e9.25.1755248959721;
        Fri, 15 Aug 2025 02:09:19 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:19 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:04 +0200
Subject: [PATCH v5 02/15] pinctrl: ingenic: use struct pinfunction instead
 of struct function_desc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-2-955de9fd91db@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8989;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=ngwvMKiL7WjeArNFSdBs/AB2ylnC/fm8iV0Ni8uhrlY=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk2tcCKZ9S8bHWzstarqLTKTQ1YHnUbV92qt
 Qb2VsamRP2JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75NgAKCRARpy6gFHHX
 ck8UD/0SuZ1lRn709uM94ELQ72NHYzpEjQtAM1QFRsNdAYuKoJOvHR364Fj3HhkJd+zCrUp2Fry
 +ZhqLaNDtcJRXi1guJPKFuBw4hvA89fdoQ//Ji5sBF53l09eteQmfQkSZ9cThUuqb2ppQNrYg44
 Uw4SQi59wIEjNkFcCYmIyGi41ZLTjWLkTqEEaHYAvXtnckyS4dLq0u9JmxGlvZAqO2gzhZSJj9v
 H4jgBrzkSytyTLgC7Aoy1Ju/+fjgpvCvtJexa+QgAUk48BQQ+zS8k3FlS3nZrKbeXo2J22IX9I/
 x9hgdRao6lACMKXTsVVsLyzt2kQTPya2dr+NWOvuvJJgoK84111q5NYsNGvC25tGN3Ndj4XECpx
 zaMsN9OT7tWOAF6oQbtQs+tOg3FdD7BmW3CjFvi/r/j4/JJAdC0zp7S80TP+yWQJyR12NJxhgRl
 bNkFazTTH376z0uBVticwi6kKpfaQ17JYnYGH/op9YKw8yUgnv7rJc+HIsXz+AJS8U3sWSBXLyU
 vRLs/hlpZVM7nClvIR/bjL4h4xKl/dFzH7xUq5WB8Mu7zgllTIg2XPgznTS4I91Y9Iq3J7IGzRq
 DRr9xrWrp2X0YEM1881AG9tbg22WDeuvO+aPGY7m6KSFgNR3+mLQCq0KBikOArR7KN0yRdAm7dz
 fywtlYsuxDVymgw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: 4E4D0140004
X-Stat-Signature: y9izxss696kxiqz3tju159nnpzstbb98
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755248961-39425
X-HE-Meta: U2FsdGVkX1/KqmeGAc2fbITx7ijNZfSddiiObE5skK1sgFx4i07tI9vNB+GN4ar9E3y+9D6853QjF5TFutMgW9Oebbjf+Vr0X+XsC/LRNdIBL1qq1oDc9gLV7r1gl+gR2pzn8MXa9N5SZAN8bRJgIIAqjTmBOCzfi/FaKnRHNZ0YoHK9i0fdKNvHlHh2Ayf0qtH6Xt3TdYyjJ0Xz9EzcjAt/9oAXUG9yGEP0lmUwIzKwQkMn5mQ7zVrOiFnoBZAhsdsEAzph7g2Jiut3dGE0R11ym9DGqWW5MO3ZsisOhyr9c7ToSidfeH3EzutnMb+N4WSmVYqt7zB93npTwOs3KmxDaR7FzGLkIlLokGCIK4pT8AnFLgvdTiujEj4Fmxb0vo4690vDD4lBERmcY68/nT5uYwAPtjHJQngVjfXul11bydA9jXBEPBEnn5GSR1ox0eNqFddvWS5kmD7q0C4UxEBI2FMGwlbpOEWOBnlKuX/V8nQDEuX0bp45lDRLtEFJNENFss9brLkUjtQclMMbsGS6Se9qUad/OVy3AmgHYUqVwoDLcLKRa/nCXl9+clTGho+CtGlu8INGX3rDD6VaquNJ02b9dTjFCS4dfK7uaphpaveXFYbGxKZygS3rl1PSt5HM1F+RwXv0ZIR8xCsOzW3CZwktV69ZtyhvzPSG47mJeP6q5nKmsbNjzbQHYGy3rR2M1eqjIurd9bQ/XK+j1WfG1ujVUgIfAPG+spYTYnz16eblzH7KgToQkOsslU9z/lP8NFDihzD/PpOaPIh08dwtX/DdNF0Zt2lO3jgSOsmqgFazEqH+EPu+J933bhhR7veAJZnbhJdBf3Hqp9kq/NbOoOc7HMQ5tyTUD2nzQsSTS6orh4pLx+gbCnpmoNO2jEbNQydQ2gcKBLOdYPLBfHKIu0p7OfLcos7rvOEdgIBmHRLyB988pSscafRJi64wJZpIjgD6nfKtDj/94iB
 voyu0R2V
 nsU8dWVrD4GL588TgTuG6OdBNfnm2pdUpuz0ESw2VH5AcWgzgLaGcpNkiKHn5D1GbOSbVi6aFp9wp3no=
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


