Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DAE3C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468F66B00B9; Thu, 28 Aug 2025 12:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419E06B00BB; Thu, 28 Aug 2025 12:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FD06B00B9; Thu, 28 Aug 2025 12:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C78F6B00B9
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EA0B58269
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:32 +0000 (UTC)
X-FDA: 83826628704.17.6B86536
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A7B3160016
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=TlbN3gGY
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jR/UQSU1rnoJqXet1GHMjYE6RZmBJb0DIB3rVaGeplw=;
	b=xa9pkFItNnPuz+zSa1Pm7/XDaaYxyxiyNj6UHis54WxywO8p5JmUzwpovjWTbUbtoL7sDb
	Wg7ppZyy1CF3csyT6b2a17KNN6sGMnzyeS2iBcWt16Oy8esG/9qNQrMi0oUBiwyP11FuW4
	xO3zyvduZKVDC8SJaAtJ3eseAZ3rKfE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=TlbN3gGY;
	spf=none (imf08.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.53) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396830; a=rsa-sha256;
	cv=none;
	b=WlNtG7OntHgjgKiPTzAqGFyl78Q9B+Gu2myhHuKtOPbDzOCPKiG8FTYqoggrKi//kukJQA
	WytRbrDKYLjMIDTn8f2TQqSEPlPLuuWmwBj//c9AMif1ykH9D7hjzkIPCR4Dtu5FPrJafD
	eCAjeo1oK/omXiyYXUVc4JLDLmYRQ+c=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3c8fe6bd038so590009f8f.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396829; x=1757001629; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jR/UQSU1rnoJqXet1GHMjYE6RZmBJb0DIB3rVaGeplw=;
        b=TlbN3gGYxtNf0FImy/1EFW2ZU87dEqLFKaptAkzrWogVw6LgCpT5AdJm3dtUkGdLMc
         wphB3rSKkR/FQVza21MaDE12ROWnJiejnunwO4Tzwb9P6Jz5DjBr2VpXyKf8J4dXzulK
         sQCWR4zJD/ey/+FI4jRP23Ml04eZODIfS74S5MeZokTe7NIjBkmn7obr/dmREncGxUj6
         Pe+9O+xiaiXmo6hxS1jEPhIcR51hS6eFGF6BAA4GcElh5rhOMAY4As1eVi2W4I1YD1YZ
         egvVXFNic97y3UZYhjx4Q24L+bZ5bt35diaLXZzaJb1uNbWXyArqofm+CBbQFqXtEUiA
         Y4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396829; x=1757001629;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jR/UQSU1rnoJqXet1GHMjYE6RZmBJb0DIB3rVaGeplw=;
        b=H7Cmq3uzz1nBVYcNKmcDBk3kj49ec0tUVvIaaqUpAvQQDfaW6FgjqS3hvj7WMYpj31
         aoEbIilzAReI673b29kbbOXh2kI1WYt66bNOofaUPglgpiGfPpRT/VXQJIhG4BS44xzT
         M8yyeIIRvtfqtW/xSQtxWFEDFxz20jxmPEMc9EJHQqqM5p9VeTyQUG53UhKezPWhDdVW
         wg8unsOScnz7mow9htH3oZ4/h10pKkyYnIsAsktitu8C0KUnOmEb9YzNemEBr+6vsg83
         +z9XuVKzAU/6eEAUuXu+U+H1F1Z+SRh8G0GdLWxN+Gh+IvqF8zMzy/5zKUB3fvS20DIp
         +IOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXosK39fIbY99opNO0AKw0V5XMxqnXAXEQrGp+2jcqLCEOT7j1PZuLwPVjZvZnWl39mU76ewJ0K0g==@kvack.org
X-Gm-Message-State: AOJu0YyHsMMUsFz5AA9HG65lXvJXJ3LJ9pBbfPklqQxejz0pb1/zp6ct
	LUxmFwMTl+sz83hkf1Cjyf988t3aURnGxAde/SS2fjbSSJYBHXdQ5W3t2k8oeZC8H6k=
X-Gm-Gg: ASbGnctlXKhJRjg/qsGIbPELMcy+AT24fqUWEKpx/cq0+Vy01M2g96hRXtgjlB23tEJ
	DOetDUXzBzSgtjCto+kHxmmSDI6HZ2HO2Mv8grDT3S220CIgr1i51BYin4gIX4v98s59cNcOazg
	B4zsSoOzn3uqRiKJhqSnFzzjZKDM6kv6eTVJTWV0ygjfxJQw4M/JokaTA9oXpElM+IkqiNAPJI1
	S8Rd+Cu89IVpIp+dLOAIyZ3LcfQch+J1XgiO7i6HSQvVJ1cc3BUH9oKuORCN5fqp2J+5xIxwFqF
	OA8iQAjNDwTZnZ+BNsJPEY7P+lu060UV9RzGm6VaM5PJDOtpk1DHFQ3EnGY0H6jumu0e6qMUKbq
	jguElYkXnHjJPwv+E8Q==
X-Google-Smtp-Source: AGHT+IHpa7seq9vvwG4pSrNyoWglcHVRKIa3k9MGizj9olBncMjomjsG4dZCZ0gf35TjhrILqQH5rw==
X-Received: by 2002:a05:6000:4029:b0:3c3:806c:b82f with SMTP id ffacd0b85a97d-3c5dd0ecf8amr20776060f8f.58.1756396828557;
        Thu, 28 Aug 2025 09:00:28 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:28 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:14 +0200
Subject: [PATCH v6 06/15] pinctrl: imx: don't access the pin function radix
 tree directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-6-c9abb6bdb689@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3140;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=64CEOM/GWFRZVaWr+uKwrz1KsAW3NNZpIdWvwWCf200=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0NaAPsNFFrpH1CGMcLygHSJdcPneCN6Unyj
 uWMtG9dPUOJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DQAKCRARpy6gFHHX
 csz2D/9MgJP+ectOeSj5tPh3IRoQSIVu4AU0U2BIk9qLJsstYn5YRISv7Lr58AGRakRZh0m8/iL
 nNYJSQ98/gglKMupuS/yKusX9iGKVWnw8cqQtR2qBPGmRcImx2/9e7HLfz7CCVT/iDAjPPeMjUg
 YyeBqbeDoAKR72CednspSFx12VxQ7Ja4n65O2y2fjtejtwiGFuNvud6b8+pa/eKxHeIkigHEh5/
 T71+1u33HaK5IxJVGK5qUbh7pJm+lSgmHzuPOJN9R8CcQO6lPBSWP9VXM63VfHNUfkyoPokJSyz
 Sxf/B6Qkyzd49YG3csk8gtZiCCKGeJeBgbEt5oY7bbuS4sOICYGYc42MEa1akallSWRvGv6LRxt
 VSBbX2tu/t5fI8EdOgROdf0H+VFhKPpz5Nytk6raLEJDU0dwyqO+Gnj8gGhHxOb8i3xBVJAN3+e
 oE6PlAYq1yoX/GSVH5H4ADkWHVGM922imRvR15JI7TpVxnLWaGZ0chIV87cWv3rtvcLtI5mW2Fr
 B+7CeIdbYV9gHFjqLi6dmVbK4CJXBZS8z/5DqhmeKNRvDwYkxvZBUfHoz6MdXw3oLpMfA7kO2Ar
 g9WkATffjdMY9P7gz7AyeDLdWVlb4LSx5uyzu3rOuNrmxYeEg//XgZ5loqLh0eTb8Oth0yRUqaa
 tb3/62Fap1QUnSg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: d74t6ffxbq46sskkbr1uzo5jazz8fxww
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A7B3160016
X-Rspamd-Server: rspam01
X-HE-Tag: 1756396829-119125
X-HE-Meta: U2FsdGVkX18aBg8VMTKi030yI25il1JpcUK1gdO2mBIplR00lJYXo3oMLgXIrnoONVMQBzO0l1HcAwFxUNtejMhqGMOW9Dya+r08xNtOO5nPBSr+c+DsGaHR+37dusvP8rWdkNcWPpxz/K5fASJR6exByo0UkZMHUHXI2vO4s7c+CzLqWfF3KgJcFj6w82Du+VIoMy4VSC+/dJpMVf/ITh05/CSl8M5fUSDMWdxzVBqLAEZ70V/bXq8IBFZOTz6I3jEYMw5KESkh4DFjf18puMzzcs9R+oz6lB/dc/gXwoyj7uIHLhuYR3N6m03cAwl4GCeLHjRk1zPd5YXjV1o7to9ZrsLc1eHZI+hlUCM8SXYvftNdKkXX7dwQPQxebu8elptGSopX9partDHJiW79QvHltXbcqlB/+tyB3f1ud83RxDGsM+ygSfGsi+zgxdVdUWBfCprOnZyyDpM1qH9XLG8bs0i3X06HPzxK8e+B8/KEBOY8z9ibUTdFwRl+0eKTuZQ25DM/tUc+rrXxBwHvnE3qHQDiIVF1iOfg52Lov8V8fLyGQMs0BPcPMtPb+Rzwbd8aqn7UuTZpYS/DiWzHVJcAYWKME+sMLJzxrNDhPOMmHlyjzoEVDo+OG2BzsItknfimami8WwXvwzMDc5osAEo70qFNcYpQbiWbIDqPoVODxbtjTibgcw9eQOeCezXSEj2WDgCNRpJxMJtog9p94kYhA3Wt4/9uKdPCjHdq1o27GVExRHNBBnz/swT40CL/SMSyHK+CiJpfRbxcqP2iamlT1yIn6r1hPxiEBLleR6k5LW7DiLX0GjfI66gXl+e6rsUPedZsTk90lkfLv7tMoNGposR1OOC4Tlph7DP0jpWef55WuxXlPKj3XGrSAquKxbnFqRmGWpwIRueupyo9NVrSAJwYUX3y7Zer9f0ga0uZd8NuPvjyA/EQYNwBGIYL53vVu0SDuiAwrNnGnPB
 VKAEvO7r
 HXf1R7IqGidoh7bTQTGd7z562LDKlHM/ySjidBPSBm4Zh3C3AcKXHEDCo7ZP1ZwBEnJiACrp+eh8eJPRsh+Nxqb2uAPueHcUbZ5dfgdmOGFhhSpv7jIDlD0tjMzZK/y6CQSgTymYTAbTDo1XcJitIl/3tVgUnb/gcUVGnBCHK8Ty5UrqYqQgxuDaFyHY41ENMF+Acu9mr20K+i73A5UGOXIqKYXZLgCr/mQjbiP/v2Z+R2f9DNx4o5wwxHgQdgAD67e5VZ4jdaAqBzuEgrACP/JAezrnNn76AsKANszsl3GcLDWhHGhF7bDkDivmOrOxLu3Q+sQZikvXj/YeLlowituEEs7mV/H9C+KClvF2I42tW6g2moNyZGEEMne+n5JmwBksTC8l4ZK5mSp55xvlHwHRBJSe6tYp3lBg3kqLg/9NLXVRTeDmd7c6r7BBpeWH57baqv8KV3LJT9hikMxh8kM9NsnoXpm53aeGITuwkhcWLUMOwmGjrTCRzXtfzKgjxqEZB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

The radix tree containing pin function descriptors should not be
accessed directly by drivers. There are dedicated functions for it. I
suppose this driver does it so that the memory containing the function
description is not duplicated but we're going to address that shortly so
convert it to using generic pinctrl APIs.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/freescale/pinctrl-imx.c | 39 +++++++++++++++------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index 18de31328540458b7f7e8e2e539a39d61829deb9..3d626d8c9ae9ebd5f7eb76216924c46b34233749 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -580,33 +580,38 @@ static int imx_pinctrl_parse_functions(struct device_node *np,
 				       u32 index)
 {
 	struct pinctrl_dev *pctl = ipctl->pctl;
-	struct function_desc *func;
+	struct pinfunction *func;
 	struct group_desc *grp;
 	const char **group_names;
+	int ret;
 	u32 i;
 
 	dev_dbg(pctl->dev, "parse function(%d): %pOFn\n", index, np);
 
-	func = pinmux_generic_get_function(pctl, index);
+	func = devm_kzalloc(ipctl->dev, sizeof(*func), GFP_KERNEL);
 	if (!func)
-		return -EINVAL;
+		return -ENOMEM;
 
 	/* Initialise function */
-	func->func.name = np->name;
-	func->func.ngroups = of_get_child_count(np);
-	if (func->func.ngroups == 0) {
+	func->name = np->name;
+	func->ngroups = of_get_child_count(np);
+	if (func->ngroups == 0) {
 		dev_info(ipctl->dev, "no groups defined in %pOF\n", np);
 		return -EINVAL;
 	}
 
-	group_names = devm_kcalloc(ipctl->dev, func->func.ngroups,
-				   sizeof(*func->func.groups), GFP_KERNEL);
+	group_names = devm_kcalloc(ipctl->dev, func->ngroups,
+				   sizeof(*func->groups), GFP_KERNEL);
 	if (!group_names)
 		return -ENOMEM;
 	i = 0;
 	for_each_child_of_node_scoped(np, child)
 		group_names[i++] = child->name;
-	func->func.groups = group_names;
+	func->groups = group_names;
+
+	ret = pinmux_generic_add_pinfunction(pctl, func, NULL);
+	if (ret < 0)
+		return ret;
 
 	i = 0;
 	for_each_child_of_node_scoped(np, child) {
@@ -615,6 +620,10 @@ static int imx_pinctrl_parse_functions(struct device_node *np,
 			return -ENOMEM;
 
 		mutex_lock(&ipctl->mutex);
+		/*
+		 * FIXME: This should use pinctrl_generic_add_group() and not
+		 * access the private radix tree directly.
+		 */
 		radix_tree_insert(&pctl->pin_group_tree,
 				  ipctl->group_index++, grp);
 		mutex_unlock(&ipctl->mutex);
@@ -669,18 +678,6 @@ static int imx_pinctrl_probe_dt(struct platform_device *pdev,
 		}
 	}
 
-	for (i = 0; i < nfuncs; i++) {
-		struct function_desc *function;
-
-		function = devm_kzalloc(&pdev->dev, sizeof(*function),
-					GFP_KERNEL);
-		if (!function)
-			return -ENOMEM;
-
-		mutex_lock(&ipctl->mutex);
-		radix_tree_insert(&pctl->pin_function_tree, i, function);
-		mutex_unlock(&ipctl->mutex);
-	}
 	pctl->num_functions = nfuncs;
 
 	ipctl->group_index = 0;

-- 
2.48.1


