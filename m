Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885ADCA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5809900235; Fri, 15 Aug 2025 05:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0ADF8E0002; Fri, 15 Aug 2025 05:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AAA4900235; Fri, 15 Aug 2025 05:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D49A8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33A6283948
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:30 +0000 (UTC)
X-FDA: 83778418500.04.74720E5
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id CC9E820007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=zjSthDbi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnhxaXfLWBAe5wxXyN7EB4a4qBStRGqZ5wQqNK1Gqy0=;
	b=PP0bKB77ipuVo/7IE81qdmmLc1xqwgw5CL8JJUcLJydwEdQO7alwFNqCTq2e9u0I4CABqE
	R0UDN6YsbcsxUWNU68qn6sSr6jghVn2Y2/SmKi3GkbiuOQUAlbs/EOSyEekIXscODhkf73
	dHZLJI/vD2qpuC1gzyo4H7/rdwtAhJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248967; a=rsa-sha256;
	cv=none;
	b=YfixBvTK7zVyeJednCqsxGJBtQRWzaubXi0HHxonLuZHgAZ332ASwQXjtbm0gY8Jc4hI9c
	HzT0sUh3a4fMwXADAr/GLkKCraH64Fa1IIaVbMluT4HrKRIHA7NIAsvqiaE7ahcp9lm7ZC
	ac4BqHDu7qNfxlGiMy41jOivQyqzOQ4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=zjSthDbi;
	spf=none (imf13.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.50) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45a1b0b42d5so12670325e9.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248966; x=1755853766; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EnhxaXfLWBAe5wxXyN7EB4a4qBStRGqZ5wQqNK1Gqy0=;
        b=zjSthDbijzvUwvTyAuLT3l9uH35DwX7dxOnKoZNZOixWcl/lH7DtZBh9/ELjmbn6Sm
         bMN3IawyONYSEV3VKkgtRxWWSgMQs84ls9ynun2BSJlACcY9hX2lIEaG9u71ruV6V0GN
         RdICCVdcNGc4Mx24AmhN07gSw69LC775A6RlP5nPRUg3Ckc0aUoYx1rhNKakoWRL/KP3
         YwiVdnHN+fNVOoywLNUswXxe1HGksDeuYbDxy9LuNNcR9c+yMMxjZt5sfqswyf/arbtR
         XOi6cR7dJ/vQgTB+xPODj9WoRQUKF7GY3svSx2kbTrgB3tLd83prw3XNYer9ayEkW/DS
         beTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248966; x=1755853766;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EnhxaXfLWBAe5wxXyN7EB4a4qBStRGqZ5wQqNK1Gqy0=;
        b=DAPHICz1QB8MZL86Gf/MkNM1NZRfdKiqqrrdLV9H6oyE8b6LCIaZIJX904PyU04KM0
         D06ZjPoohA44YwsKTjeYTY1+PxbD8Z1MAIpgi99+pExcU1rXM1TCXLBg8VzEjRS3hgSq
         qN6dD4177st4dmiUgAQbxULwTcELqSFYb3YGUl/0jDEbukIu6iu6aQiaHAkTmJh6/shu
         YWsw9sQq/h3gTAt4N9jFcCNWLnaWByJJLCr92Bl2k5ms9cdC3ustZiIrYJnBYSYG82zW
         3bMC4wsoMGK1pvNLrvLEV0A/LMWwb5OKjL+cOY2PtjLiC951J413oNcO+gQNKlVDbPzt
         ObpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcTPI9PIiUbqHhj/eWbH0hE2LAAJQY/V4bOca87cSlGRscDcpOGbHtVTs0ffE7CtSLoOWTfX6pag==@kvack.org
X-Gm-Message-State: AOJu0YxCHBKEDL2a4HvSA/5o+ZJPQbKu1tG07Rm2RLH5JVsg59osB1gR
	Hkis3wGb2gJUEULuO0k8oJz7aAUOshM6CvX61Lbp3eYuqxyNPhDEbxpTawspBDY6xcY=
X-Gm-Gg: ASbGncui/jHaZJD16epwXicDlZ1F5x+WUYJs15+aUkJXrUxf+h7f4eiHbajNTyz8hBj
	Q3Tb9DUwJ2s+1zKsbOaoh7UCWfBfnWV796rMoOFaKxUPdXvqNWTJWf7Q/6/5fOqjgETmObvjgmZ
	tyB1AhnCmQrc3ZCeNhLkeSk//am2PX2dLtAEOQxsE07k33FC+rDZwDhh5/ZHn+C2Oj+jcFEWYLn
	kJ1caWKxp47bO7z0kYd4b2654Ruhxw3/89vKS1gkU7HJyD4o183WQW++Eda1R7K/N8Ln8W8Mhpa
	VLPGZ+zm4WrZ/P5VxyRTtlzgLkeAkEUI1S7XXy1PbXo4p6XVy+R9qtufFgKZ/55CslY5+GHQ8tv
	gwf+XAKe+niixnl0d5w==
X-Google-Smtp-Source: AGHT+IGrKalxRH2emMVFhJl/BSNAcO1PZ0/C3WQ9SuFSJDnEC4sffp01HAuXZ7aewRxm96m4CMiqDw==
X-Received: by 2002:a05:600c:45c8:b0:459:d667:1842 with SMTP id 5b1f17b1804b1-45a2180461fmr14807625e9.12.1755248966340;
        Fri, 15 Aug 2025 02:09:26 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:25 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:08 +0200
Subject: [PATCH v5 06/15] pinctrl: imx: don't access the pin function radix
 tree directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-6-955de9fd91db@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3088;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=FuPiesxsrAA0Rn9DkOactcvX9/BHBoNthgyhyXGEhH0=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk3rpCdQt6oBLFE3JhUek7wpG6X1F3lNHhRD
 1xBSnpghMSJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75NwAKCRARpy6gFHHX
 crmbEADXui3pd5txQPs5OswgHt+SSwhRPgY5VgbCuLzFGwr/2pud+3IwLJwQv32sg5biLycFPIS
 tgqKV2jg1ezhF3AuxuIS6nCEBUC25Q4ocf7Z5bIG1PaVNj4kx8CSRz3xaBNqzSIggrfzcGSDKRV
 vkfdoThbQz1qBjCZIGDtAxHee64mmlelkG9kaF77q9JSRcOTZX6A/dACXHIDwKOuyzV2Uvm1CQZ
 ElBeUIRyu4lx9a7VMF/jP6aewEJE2p1wugJvkvSI91B+YhvnkPrqA/QqGzYrxlHqflJy98WygLu
 VlPXlUsXqP5POoIbK6S3GDkQCnr22v9vHBTmkOmJ1H1flKtn+0JuYy8JwUFHe3h22Dl0ChZU1LS
 95/YKWnICS0nBiAFltHYmCDB1oIqxpBTQ16DUA5SSIcy+8aUUVJbvJafN7qVlBjOxUFIujaietr
 CGqK52H8fm5AmTAOmZ3WaCns5oKr+XuL+/h5SpO+GfhHrfeOF3DNb/EI2Y1jpV8t7GGsBzWu6W/
 Uo2gOtnoUPeWQEEW8J0qn9wdPXQc6uep1CXJVXcOOOZYG5XCIWOs+2CQm9FXoxOvfTaYa85+cwq
 t19ujQgkGk9zToTdGziHLee8zGBTKfXUwoa2g5obhZ0lJVJ7RLtUYDhq9oSn1tU9lVBWfPBWx/H
 CIIk4Htmm9oBG1A==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC9E820007
X-Stat-Signature: ajpzxmr7g4gz61oghqwsxrjei65r13kx
X-HE-Tag: 1755248967-633717
X-HE-Meta: U2FsdGVkX1/GuIyb04IIS936/5Xgp8mNgn+awVanl0a3xqtbiZEg5a5pqUD31baXDmQrEL59vpb5pD4uR3N6bbQvcd8XsXj69cK6DFVdzfOQKD/1sF/RQGxR4EpBTCi5lhCMsC767CHO6+ltByIaqQZJxe+Xs4Kr+Jg951EQqGq6fL97/oq28AiT4EdyUMY5GjOvnRVJ6yXfU7Eb3CTxdw3iRW+mtP4Iu9HAlCA5bw8lXldxFJSMQ/leZB33diWxcRhZLH6AFVC2a2KP5KeRIt5JCbGWb0dXxei8ZNAiM1zNNdiIvEgFApK9iJdQNYkfBU1rGv4wOpYYukYc9ivxsCnmuVEL5iwxSlKzI0UBaGw1SJaRhmUDMQbAtw9Wzk+IyDzV6DD0v/5ynQ+25whkkJ0EUFvyCQLRYal0DfG/VZTBBJSaVAVMM5oq99mygArrKbyj82bCCvMMVdmrhkD/I3ihzDa1qosVHhMKbcVYEgu5ZWKI5yxH5ZD6raAUecYSZxm47qDR60oI1uzJiVP9WCWRlRokbp6SNOqPTmyPxmk9xB2U/le0Bybe5rsZE6/O3phcGrFCZDXoVlDH4hYlx3EwW8UwwIyNYMPxuhLz0QjZtLecaqhgBl1GUu9BsmVDmdbaYx4FmvygCz1WkTSZIKhoQimrEk2SOPLyMFuM7c0bxiSXtg7OHT4Kt7a1ZKBIxvT9n78OWAKjlDug0v8j3puZpINNXNr1dTt8ptV6e8bL1U2zPEAVMvNsb3Zl0fJAkK24hXkctpWijgj1MICfElfk/dE4c6qxS+IXnJkEa/8urh3KGd3c1q2QzrQSpmHGh4PM0sCBr093gdZ6gXxsqh4Gh4L1GwowTXStia41DylVuKzmCtR0qtnAFJxuCznwcHJWmIMEGdsbVHJSXueUW4RGT0Gj6DB3drzTpqom7LrI7S+zbZ0APmy0SKpxlDQyzXSUrJiX40bTE+P3Hi2
 RJ4XEv8J
 a1ufmtbcj/X+SwXmIzLwjkp2V8iDMU1pt6IlV3o828Oae13FsI568AVyW78WBzui2tjUgdAvILAiIjG0f6uJzUJ0Wdsau/2W8ItoS+EOiBMMg0DCrt78UQesHW1z3QhgxBd4ZfYa3ZZwj7pDCRxfIlclswZRpPwIlKinpsEtiXTm0EDkqwtPAz2ELXC4ATZV5oA2FxhdiATJSRQy4jtDWxWN5IAFhYwk/fEXB6gxLcwwcNQq4FQ3LhsMa6Z1j5bJLl4LFe5AEUEy54BdP39bZDm1+DvEJbyY0Oysvv3evlGtbg4zT+JmM/DqzAyP9iBXMfjWN1MlGBx1omxabm1Gw+zJ/oIcizfnFHwTYiM1nf1HObVLx85z1UedMBp+2VjaYT0GRsIbvbip8lL1+T8vkieZrrhQtlBbsZiDqREJruTfdUtWFxxaoJPgZ0/5g7tnUntCThh4V94PnI2wT+Rsi7kDSjsG9JB4UKQR6ooLDPA3rUu05m/gz+ySKLTElU+ucxh7j
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


