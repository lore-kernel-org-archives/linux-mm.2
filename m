Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D77C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D712C8E005F; Thu, 24 Jul 2025 05:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC008E0051; Thu, 24 Jul 2025 05:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26BD8E005F; Thu, 24 Jul 2025 05:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC168E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:24:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6950916032C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:53 +0000 (UTC)
X-FDA: 83698623666.19.7E71CEB
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 592F34000C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=CLD1mJDQ
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349090; a=rsa-sha256;
	cv=none;
	b=bQVFphZNvDcvGzgDdKU1pHcZeKh13OkoXxvOZr36jj5b7Ie0iM74QC5DV1bURVsbhhDEkb
	k85+/ZaG/4wbiNBSBxVUtnlhXUfKwgz+h8zjxDsvnq6KVNNfWuCacFAj974NsVx4LQySJj
	rYTmm0ELnCDkFqE1PZX0RY7yIJk66N4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=CLD1mJDQ;
	spf=none (imf27.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.49) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnhxaXfLWBAe5wxXyN7EB4a4qBStRGqZ5wQqNK1Gqy0=;
	b=tbFMFRcmxikEIO6fJom6zlbqBreWCGQn69VxiFljd/mzEy57cc1npd13RHsYAfKJJuCCqV
	fSrnIwCdyZEfHtPe86a2KyeH5u4lrCqVIqltXJLYIZfN3M0y/Ip8uTPWQSqRvIPh52Bano
	Xewz9oEw0BybAN4hUNJB4GJKNrZhsNY=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a507e88b0aso474219f8f.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349089; x=1753953889; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EnhxaXfLWBAe5wxXyN7EB4a4qBStRGqZ5wQqNK1Gqy0=;
        b=CLD1mJDQpQbHJFlPLrq1HSxJ1+y6mvxu4bmbSoPITLxmE0g2j19MYbP9PqcEvQByjN
         qBCE5+ySRDw8sBpR10C6aZkqFrbsdeov6HqSazkhI5+5TTxiDf8fPDB7Tb+t4S2yAZ7T
         lcE0DXCnFdwOC87gI1pF8x3fPWHDC1+YN9p+pJn4lZktkM7Xndu0PQmrJ4JeNSs/Zbrs
         859p+Di8jnkIfXlqVz3ZmI0EV5iD5MnkswHtj0Db/6FFZS5EUQPBMyxRQd8ibeIq99oY
         Vqe0gJlMyEjC4AMOiT78/q7BPpmVOn9CvKPxr896auHuhCOKGw07WbMGrd/QSGAKQpCL
         08iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349089; x=1753953889;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EnhxaXfLWBAe5wxXyN7EB4a4qBStRGqZ5wQqNK1Gqy0=;
        b=fnu/1rT6ZRYWnEghvBjHmZtVyh8RblqgWgP7z9u+dv2RRsy5Gzo0GqBLPuPcrnv0Yu
         NZknEll+mR5y7gpcGAdAWMFJcI1ss7CLcI9gs8hikWeqUA+v1UTGATYfy2oFzVwMR0Jh
         hSYGUvIhd2mfgfjLCJMiWrCA0GErSufuxe7VvyvVEzd+8P3GL0W8yQGt5Wk0BloQJG50
         v3mZpRnW0IlH+oxo3h5+m7v45uPz19KL3PQ0SD8uI1PIwHdf9BAHarzipImqD4vYBFe1
         NloVwECpWMWU8gqIsmIVQMJcujouYjbFIyz10Hqus954XobGRL3XxvOghYBrIoCijpMR
         jAJA==
X-Forwarded-Encrypted: i=1; AJvYcCWKC6ELOJkBoGPiSj4dhqzK5PyWH8dsIqKWH8f9jvk46QD3Hgrw9uRo2R7oCzEkBymz+sj46QNj5g==@kvack.org
X-Gm-Message-State: AOJu0YzzxdJVodFHfSJU3BGxCTO+IPgd9uTwxivqrPZay4fCUZsLm+8I
	oPgOSYdB2CrxGICSrXDZU9LdiokbbY3y296JviOIWKCzxvItUY5W6qA/OSRDN6xVAaE=
X-Gm-Gg: ASbGncuVNLIA+QUqYckWnhyu8klXbBI5OfY7MQr8SE8jBz1X/sdEKsnvtXLZOKWAVYr
	rfNzGX+M6jqKEf5AqT+ACkPnCA8mUg8W5qfv/I9dXdnMlTxCZ2pszxebhyI5LJ5h88SNg6hU0Gu
	ZM3cI9XjYYLKtsmA8S8b6JitGadeKrrcxUYrjbGGuTylPSOFzowpadg4wTb4Q/UHyJMUJib6kaz
	a/vABVa0QUHorvkMge3S6O1yZYLnMIT4gxYWiANcLDXp8qWhzAovYG09ynCh3kJS9zYh3xnb10B
	zqfoVOxtrbETeQOGeDLwvQfEMm1jJHNCV3+bVZ7MyLYHKKEt6srX0XEFhP8UA8/HDzTndkW+Iad
	i+/Z/cFCl5MzUJQnS
X-Google-Smtp-Source: AGHT+IGnhvfYcdLRXAtdaLRr5gD7VJr0sJOuUbMg0+qJlR1rhLS/+bKPH6E6yrPyHszr9XJ/HYT2Sw==
X-Received: by 2002:a05:6000:4305:b0:3b4:58ff:ed1 with SMTP id ffacd0b85a97d-3b768f1647dmr5410021f8f.52.1753349088691;
        Thu, 24 Jul 2025 02:24:48 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:48 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:34 +0200
Subject: [PATCH v3 06/15] pinctrl: imx: don't access the pin function radix
 tree directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-6-af4db9302de4@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3088;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=FuPiesxsrAA0Rn9DkOactcvX9/BHBoNthgyhyXGEhH0=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvSXtvqkFaYJUjTRAJPRVMAk5wNil2YXVMOw
 MxVCTuRo8OJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70gAKCRARpy6gFHHX
 cshfD/9SbpCGJDJ/Jk0sGpayxa0FhLlGvR6oERWTvgMhtUeHxUCFxBx6YMGv+BXEHcewihGh1jq
 BgX/VsRjvw6EKMEblPXX7xIezXGlJ1it6QRIJhD67eBZiCBfyPtBPG9wS5We7w//N3dzb7oZt23
 53GJbPsWFtg7q1VUNLX3nRrR9lnlbsEnSqSKbkHNbMJIoV9rji1HhGAgBmaT0ORciNHfcNGGFOM
 KVacjCtlplbn6eJG8vSzpRvU0cb7YHFFsvIt3ywpH+IOMdo3ZSw/Wzmf7YD7iS1WQr7Rsp7zxf1
 Bn6qiN7lKO4IVxgFPuQhiiUXjAt9OCjbJYlb8MVwCbTkLMFXcVVBQYHi/53LnDO9HvjWzsIdJ2z
 YumdZy8EhIhf3NCj7jIrdAyFYnm3sQqVn1h8YAvAXS1T2OS3QRcnjueogYTfGXBNCMutApRK/BB
 8kVNdJGs1FH2+2s1u2ZHJSTAdXTyuEtC0ZtlsPTZK8qnU4tIzC+eHoHw/59LtMzbTqMOdhc7kP6
 2mFiCpXau57p6nMR9D58vlXLXZ7hPCvcyk+otcV+5SypG0Z1wj6aCWzj9cpO8AnBNWF5hDbXS7E
 ygjMSNH5srKmYTV5/cOFe/eEPNtS6qromALeW2LQN/kc2GWO2J3B/x2YuLPBSsaK85Rbu8N5Cl2
 64ZSUQ7l7oryaNQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 592F34000C
X-Stat-Signature: qpbeg3tacaxyubsdeyhd7qj8u4e5o19b
X-HE-Tag: 1753349090-36361
X-HE-Meta: U2FsdGVkX1+8qpTFnBYPooE+XVShZJ9WYzMNlTb95fqB5J/gs2CxI/wnp6my6KjWUeFUfFQoqIIyAK6N8kJ5NwAE3pPsHCM9S2KIvvX0G+jF9amM/gsnB+RdZaKpSnti9iA94j4OTBaQq54Mb/l60qiz0h8GGvN4FIDpwWPpO64rqwpT7fu7AzDq10s9PBVciLlsCoFQfYzX31FIIVEcxfUhPwM9F6V5OrpKhWONXub/oTy8xxGDKSs0DxCovLY9616HTdXa/S0nVTUMdAWBt9NUGVoA4IkGUavW/+WFUvD1jzZ0IhP5aHuFUEe+sQ1ekv3NZ5/sogrUtQnO4W7EeoX/lgRDmg84cSozusR/i97m5dCBB2cCIF3Rz9ZbsCCUnnzqWjKW/dhF9VguzvrR0KG7KllUMENbBG+pD20Dk5ZYW1g7A7WzHBzyUFSqkSxCNcuc09woBKdJszRLzNqLEUnyFWrOnQL0hrFFnxV9HF4fWU6TCZzohvcf2Z7N/VXR0zowobSpOOQHZlUKR4ztn1V0nPHwltr4DxyJN8dxx0DlqKVa2G+g+kE1cfCMxfTPY5EORl/1XMNoeSFphiUimPbAQ0VHAkr6/xGOy+/0bI4xzNV8BQmem3MpMY6EYWs3f52MVRBKhaoLBC3hnz/vcM4n1rCMUr/qbPsFoYNGbnc13gh0uScMCUYDEql3bvxxzjwr9cYELGO4EHfbqFvCvdUNJoCoQ+SH83Cl17v1MfErwWSSn2coGwJibSwt8L2aiEWiUWwo+OHHdIeC8ZoujwxAPquNtNogUIdkSCJ3DXBJ9T9wwndCVRPPkF7pGJwLmGktuI0WpMWehFSo8EIuwxqrk5B28RODVJFh6m5AYSDVvkZF7OVYbZgSMY+vGBCeg8VXeFl8XZxf/0Fr0h2edlxt5h7NIkeFKZkTOARItCb5bTbTnt7o6vDLXVHDt3gdwED+ENdiZAiIJrjheQh
 FPBkePX2
 VnU+UKGABqm4axzlz77l219kWQbDpJ45aiVuFkv5WgUR/5yvT269pxwzO4oD/3cL6T+GU9bSHTxbuqv3g/qxxT0WhKcWGz4Ujg28gwDcLxPQTl2b80+htdO9mtdeBLjiceMyrzlKl9FMkyIX0qAHIjXldAjncCHaCQMo7ETJlDAA6PGZi91DO9kmaBPFssKtSCGfjXPS3Zz3bTla3ucIPmBLHn0waQnUXCFHt/J0jJVYABQG5DgaJf1MAcLW728ZyycWvtT15IzwT40fTh2OxtBDRlbh2AF6Ke3f4jJglN1mKo9S+CGPc269lm44J5Vda0KwazXJ4zQpQbiuJ1Lc0i8cMDJdqsL/uAJUnX78OIUzh4q80fXx2JJZT5gvQtRi2QCq2teE2RxZmdVr4HoHrpgNpUvjkUVb8E3iY4kgIa2Odo9YGC/L/i4ouZlwV4LbMADREtskQWofR5Jl0L8NiLEbJODZcKYchXJnarA3XfyRFOxNNHizFdm2mrnLcqw6rsjKX
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


