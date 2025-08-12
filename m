Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE9AC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E232B8E00FC; Tue, 12 Aug 2025 04:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4AE8E00F5; Tue, 12 Aug 2025 04:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26338E00FC; Tue, 12 Aug 2025 04:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9CFB8E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7CE7B140248
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:22 +0000 (UTC)
X-FDA: 83767425924.18.BD0B195
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 682DD40007
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=HPUpJVUX
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnhxaXfLWBAe5wxXyN7EB4a4qBStRGqZ5wQqNK1Gqy0=;
	b=OcUTbdgTZWSr1rEKe4mqMKAdfalIH4xOJv7Qlin7ceSu9sBlM0f3ZE5+A/8r95NzcK7IfK
	CgbpDz+dOnhOEA5QlBkls1vRX07MAMluQp5Yol/GCJoxQUHeTLwKyb3lUNt1ZRIikDajf2
	TPVv3iXtPfR+vDzKBe0RVotrtREAVig=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=HPUpJVUX;
	spf=none (imf01.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.50) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987240; a=rsa-sha256;
	cv=none;
	b=Eu6PaLDyQEkFq+0y2S2vVd4zPQrmI2g+NFun+NX2tw3xnoAAd1iR6bXKo69lqKxk9EfCUQ
	lmW6qdAhIkdhj+VumWYE3FeEAennx5gRNwwxCLWMXFC9nuhDZPiENR3+VQfWkpS1rs2/Vf
	oXlpM2BN/HPF/ytJph6I03YAlLHYnM8=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-459fdc391c6so24268115e9.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987239; x=1755592039; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EnhxaXfLWBAe5wxXyN7EB4a4qBStRGqZ5wQqNK1Gqy0=;
        b=HPUpJVUX/3Xuvue4ChmSAU9WMeuCiFBL61bgdqqMcUBlQ0UWiIhz+mLLUlZB1KExMg
         THGW/TjaimHWRU27p5E790RWIT9PkvI7xz+7IPc3PSzzdvMWTRRdbc8i+K7pM9BAF463
         1WJ7VAjvzwUrTIH5C8XMW094iD62rbtNx63sqlLPdm8RSyyyHPf6Dk9NbGiYaEE9AD0/
         MwU5g46mdrwKo9azraif+VNDltEaS9Co4GyglJtzdrgsY1QbE6SJFdKmq0N7A2Dw/6Dj
         U9dq54NnKBDrldC7TvuDAFGtp4GTw7xNRe2yJrjYaEYhkJ8uuXLChs52uKNnSwn6wuCz
         5I3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987239; x=1755592039;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EnhxaXfLWBAe5wxXyN7EB4a4qBStRGqZ5wQqNK1Gqy0=;
        b=OiaEeusjdcAewNVWSm+jzYOGW1Zd2ysPJYbS75ufXMmcKW/laTt1BbsNYP99DhMnft
         9bDpQqFNqf31nTO4gVdahlC7IAVvfYSdSehdYot3WvafwYdOyiT1WtpjW2ZPfILl6WB+
         AFtg3z57mqSSUOlzLK4nt28x8ZmFRNAoY0d7oEAHo3PcxzIixpPTy07l6CR2xLj90Myx
         iDGLrWi5pmew7lTt/+1k/J6JA1uV44Z3OfyO5AI11liTJpThn3x0ryqUOfXhsuzN33Bk
         +v3zWrHAme7bUby7JRgI5y1XbCo4VVVoEwkhXzB3OHFz7zbhl7Lgrp+32xXg0GlAS9I9
         RcHA==
X-Forwarded-Encrypted: i=1; AJvYcCVdw/rAKD1A0fdvQAPNd3xRFKQ5lE8VlIEs+EZCYMf3T91W8gvr6u8h0ihSgWJkPhxQiPaloJL0iA==@kvack.org
X-Gm-Message-State: AOJu0YxpPa5snbdaghk3ozWDbVl4yWoeVhsjrxYBMoLz02kQ4vEGpMhI
	GVczlk1Fbe9AYPnGLL5lQ0MEl8tU6BJA3hx2DI9U1NLD7sw3bG88aEpr11nz2i9p5Fw=
X-Gm-Gg: ASbGncviKT7UBhT2EU/pGLcwKaLU6bnHKDNDGOC2DRgChQvG6DjSDkfX5BBfwYySl9O
	AREVLwplc2bghxSrXy2SwuCy1lJBX4xTgvc0eGQob6SgEFeNEhJb4amxhRNdY+Ii7WAxqwJhnZ2
	iDERR+XD4lTRwRvTHAWVOOYcbos4tUh+b4syocNsGBRElem1WtQIHD+BZdUh62TdEA6HRavMDm7
	k+BelDgXGscAodlffUkZY5Bcu8SYIbJ0bE8qDoqbND2qAjtSgOqnxaQlulJ2COu37PA0v3HY3AN
	9CAEeNjaRyh7nvcc60NQ7E2A+HYaxp0sYZapkh2Y3ezdf5RqcQJ6UR2k2BcJQE71XpWhD4YvJUU
	Ts76U1ySAJzkMzKw=
X-Google-Smtp-Source: AGHT+IHCxxphw0C1ysWW25fo60uK0xUciNoK6/brqWeyF0IqKEcM+9QCTW7mxqYhhnP5CYPiuHCuHA==
X-Received: by 2002:a05:600c:4753:b0:43c:fc04:6d35 with SMTP id 5b1f17b1804b1-45a10b95677mr23101005e9.4.1754987238810;
        Tue, 12 Aug 2025 01:27:18 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:18 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:05 +0200
Subject: [PATCH v4 06/15] pinctrl: imx: don't access the pin function radix
 tree directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-6-bb3906c55e64@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3088;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=FuPiesxsrAA0Rn9DkOactcvX9/BHBoNthgyhyXGEhH0=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrXvfSwc1aR/VkXuzCwVe/jTr/RkVSkQok9/
 6ZfT3vraKiJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr61wAKCRARpy6gFHHX
 crU/D/47WmiHhr1jD4X7MX23IkaKdqa8H3X1+A1yMibQlOZwva+m91uzbA5E1KqKisV1OFMTrwM
 qQw8JodqYSC7dGdkQzBqDTIPr8qzRWzoSvMRK4SEMSkWN6JmzLvQkjkT0QFqmMWrU29Eu7a0K1F
 Dajot6d2+kAVgD6I14MGW8cJyorpzlsoHipAlEw12RWTEeduUUSmBSgSdFriSRaQ59MJPBKp8hZ
 kVe4zp0J0g84ajKZ+DnhXBhaHIQym7fLJR57ngkJWPemTobyqxz2105/iqorzBrO2YC4Y2pX36z
 cuDpKjunZLGwb4w0loqgMygcLK/bV/U5ML167wppqGTE781xJw8gTclK0ECkF06V9mMriWr5qog
 w0Iiq+SbqD84+qFscPmKzsUrqqSX0Ih35IZdHkB2+uOuY9wKhFsFauO5KIiHmPkgPvd1VHClNqm
 ItFa/4pd+kPjurFIxcHWHYyEQ5xM2PYjHpH1qPVzaQNzL0f+rZPoifcD1zBil+ildZtDLwNHbLj
 9bGuk4x45L/2ysZqyTqShL9pN8TnHn3mQrsZpHh+PUIe5e3hgaZi+P7oiTmtPmifDRFb/rJlKSM
 l7mYoB8Nx9U1KflhK7GPr2sCxhy436TecxSTqnjxs3nFe0iqlGJPyQMvKZURsDe/JEiBZVGu0+n
 KZOvfyXmKWunFeA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: f3z1dd547kneuyjze3pixy8gynzmk1pn
X-Rspam-User: 
X-Rspamd-Queue-Id: 682DD40007
X-Rspamd-Server: rspam05
X-HE-Tag: 1754987240-603358
X-HE-Meta: U2FsdGVkX18iTWC6g96G/0Bgr2G40OF9eTKMsqK1jKxv6jFfsaaBUZnRcje1GoERZ5OjvCsyXnF7heotYzfGecVr/+6gvV6g88qYc7sK7bJ6BE44gbm6Khjr2I3m3UUBi7wYsA/LotnG0xXjQFKbr4ieIfZOjZkI5/ax/xlEjidn0Glj04IlddzT1c09CgIoEi9z4ACcFMtmO13h/8sEi/zSi+S6Ks8UphAR6g9UKnaeGUVrz1GuWAiwIAs8wD3C+ufdor7abfFhCCEpBwj4yd0ky4zCQMrVzbapSKkA2RwaLXShJ4pF8Ffm8bH/19lUkAyt3Eb6y6yk351FW8+l0hf18jBrsKZL2j1hmP/zN/Y86FqXEvzpixexEc4RFXKwb+Kmmemnq2gBDDgHcbY8kyToKsxqtvCnIlBtxUp1PO5SdY304v2p8qXm6ePFR1m6QBT9IvbEveC+dZveAMgP+eY0EOYKzMRt+8OsKgsCx2H3hz9RmY/sKsfD/dUkAu25W9kmlwyEKffkV4jM7HoRI39HIqr6gpCTS5yiIT2weI/KJhtyG9HIHr31Ilfs1wffU+CjLVJesD9o4iXgnRb2ffCGXcjh9OnvEvEVbgsX4O49RujQwsGBm3dpM4iWQNvXwOV+RjCmYW5fN/Gzkvpq1OF6U32msJxotb8eBD5Ik9IvLnFXAviLxXYK257hXhhTJp+9IFvkIzmCRkiX3fEHhZLC4pPyRDtmx8SJcA/sT8GgdN0n6xVqBbIuHaLdXoimDDkS1SzfKbWKuMyVflY0C9b89qTaOPy/gFOTIuZfX4m1q5E0K2mR9DFgEbotABGRUXiF76PU7g9FgtVIzLPAabDSFun9ZhPC/ywBpTTJlpvaC0V+Dn9e43QHGVIwr5kzP2t18GCMQ/vIlspQAjOldfp1Y28LAZnQN4BURw4voBZi+rtKJbg6wrU7Mfp0dUruStGArhphp4gpmx4iZJM
 5j0LXZbV
 h4CzTx31u1a6KM+3ymnRV92ftFDJZD26Fjt9eaLxFphS0E4pSyAi1eXNwa4vQU+e9Etf7NcS+FNLSduMMHgu4ho0/4tsRPkd9dXlcG6yOK6Bm6vuk4XL7qOH6s5UAE3jpEvYAj0oUFkd5L5dIkU4D/NqplkjDzD4RXK1ypZeC3YIQgVaufGmvdYAFRCqFohA2N7LdB3+jChibcxWCf/gE/IwiLBBsawa8nDBz7LnS3PlWe3GsCycygIU9wHnGLV11UX9/I4ug1qRlbyVfiqDvLB6qsRnz7FDLiOdYR2C7AcUL68KfA0VAP2sszmlHIwkwC9/1/Jwv0MBY2FPKOTHymHbIa9T/zDS7fHgQgRBYJN7A7+c2QC8rmsZDgQ69xdPJT2BPxSeS3VVnY4OR1mew3aInNq3Awm96xygMwe3/iVegjVTljW65K1+q7AZiwhR5KpmrQFfcXzM+DNSkHBWTSjolV5ehLA9Va9ONOjQzhyLs03H84OBTvEdkJT63ybCmSD7G
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
 drivers/pinctrl/freescale/pinctrl-imx.c | 38 +++++++++++----------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index 18de31328540458b7f7e8e2e539a39d61829deb9..d5d42c9ad5fe9dcf7c25ad393688e714b02db678 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -580,33 +580,34 @@ static int imx_pinctrl_parse_functions(struct device_node *np,
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
 
 	i = 0;
 	for_each_child_of_node_scoped(np, child) {
@@ -614,10 +615,9 @@ static int imx_pinctrl_parse_functions(struct device_node *np,
 		if (!grp)
 			return -ENOMEM;
 
-		mutex_lock(&ipctl->mutex);
-		radix_tree_insert(&pctl->pin_group_tree,
-				  ipctl->group_index++, grp);
-		mutex_unlock(&ipctl->mutex);
+		ret = pinmux_generic_add_pinfunction(pctl, func, NULL);
+		if (ret < 0)
+			return ret;
 
 		imx_pinctrl_parse_groups(child, grp, ipctl, i++);
 	}
@@ -669,18 +669,6 @@ static int imx_pinctrl_probe_dt(struct platform_device *pdev,
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


