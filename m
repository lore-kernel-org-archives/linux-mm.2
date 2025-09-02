Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D59C2CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374948E001A; Tue,  2 Sep 2025 07:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2610F8E0001; Tue,  2 Sep 2025 07:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DACD8E001A; Tue,  2 Sep 2025 07:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6D208E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BF5B1A0C2E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:34 +0000 (UTC)
X-FDA: 83844165468.27.2E72175
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7F6E64000B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=fJmFNg+Z
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FaCre2GzdHbdQSV0ImBvBUo9sM3J8CdQV8vbp4R8HMY=;
	b=ACnOUnf7MVMML/BLJrZmhVrJrhDN8Jx77l2aBLJA1m1IHwFr/+B+x/wzmohTkr3piDuBkC
	v5/v4CK8DHahYtD3K7ApHTDZEoLDcjW/6zYxfgC4e6nEi9/qlLgUlMVgx4FgGjA3M/0vZ3
	G0t8ueQrWHN+SNb0F66d6ocneliA0b8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814372; a=rsa-sha256;
	cv=none;
	b=swb5fQ3Zjh8mVx8GaxEYrOuYXwYON80h8qOgAMX8ilu+DtQZR/lMh5vvPoJ/QrLPyeP2LU
	gH56VNnlj+j5ZRoUk7ZJ3HZoiLkM3hy0U/fuI3X3gZ/x9UoYoQIyKngX5WrHa5pWc0weFZ
	vlXW94Prbiv4y3rorLG8wNDwQ+T73w0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=fJmFNg+Z;
	spf=none (imf07.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.47) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45b869d3571so6400815e9.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814371; x=1757419171; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FaCre2GzdHbdQSV0ImBvBUo9sM3J8CdQV8vbp4R8HMY=;
        b=fJmFNg+ZYxjyYxdoaeqAE3SRLqyY/IY5Bkj5PrUMs8DbPUDPcFTDzuEE69Sfn+r0Y3
         PDiR0URZHlcV/jVNVZURgIUUIUrrcFv6b8FvCHa/ip6VeaZoPDTsP/aAtatB9dp7hzfl
         BRlaGRcEzgTAWa6zivbprTPY7uwMQqNyovJQfhUublTOy81h8vgMsetKHkhs/jYAOX39
         lGKLK5XYFtIYvmKw/3nRcCkSsldIrXExu7j7Y4Z3NdKYjtuihWkBB9WCUwM+mQTIH3ol
         Vc/9nLLZSZULSLhG6QqXUS36HLNJV5sert/arheTZZay7YZW2sGeHaGVc1muVMYDz+eL
         wIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814371; x=1757419171;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FaCre2GzdHbdQSV0ImBvBUo9sM3J8CdQV8vbp4R8HMY=;
        b=h081xolOVX0/g57ZSYpDRCkfmFpUgRO7kwdXazJcj595ueHQLxaT5BLiKoJ6oZdhqm
         By8Y72cLeaNpOB/N8feCVd/XETdTKJTO/cSRd31b8lG+Um1y5gCrpbY1NbcFvGcq8nmJ
         wAlTj1AWGAGSZB2VVyRF5SCkQxTQAlGIpmJkfXxw1Fpnc68wsS23D/lo337v0o2JF5+B
         +ZP/sOakoONpiP7NgwnIBpwzozcPQ4yK4DFIgJ6iSd7WJp/TUkwaiBujbIQzAeU2LdVo
         LfbaD74cEoQ/6VegJSY6V5LxeE7CbsNpqQDP6LojpieSVd/kif1796PoQjRWWcuHJkvM
         uidA==
X-Forwarded-Encrypted: i=1; AJvYcCVLIM+GHquizXp7VFoSP62fVvsXRh2wTvjKFxWQbMWWPB9LW/wtQ9BNMg4pSo9axAyUndM/2h1pjg==@kvack.org
X-Gm-Message-State: AOJu0YyHAkU7W2fd7CceoMHbcPB9cDpm4G3fEbNKj92gXNCiM2iqeBp5
	PONu0jMwC11eVs5kgVBrnzB2rjyXtofcPtw0gyw8HejGaQefCid1wvho7QxjWKKjNJY=
X-Gm-Gg: ASbGnctlCNoM1zekhWK3TAYBpFu5AWI81mUwHZOJFTdW0quxw3q3R2U6fxCZYW1RuNj
	A4McXOCCfmkUzNCh32ZljNx37cHqAx6pUJrXaNLyCJMMS1C3baZjpg/uVBk8cyjE/SYsrfXsEOH
	p/ZdBzJ29YhlcHTIcxADW29+PETDVkm2bRprx+o+RjvQ5gu84hdtilrIVrXnEzYF15UKyiHkRY3
	UJqtdc52wXi5zmZu3EDUDxER284PST4dQQ+llM+BOUW724htMV9VO/LT2JD0ZpUwYJwHi8Q75vt
	zOAB1pIFyMmSP/3ok+1VORFtM5KYyiuvRtSl7rNWkGANER3ezWPM5iPho8OX5p30uLh0sCIYC0T
	1IHh+uANO4ccQk7Af
X-Google-Smtp-Source: AGHT+IEly0vxxEclpdvYe6RqlF5Qq+Fgr46eky8ZTTtYsSRx7+N3oq1XDfjPTJar+7PHSisK+6uKbg==
X-Received: by 2002:a05:600c:8b42:b0:45b:7e86:7378 with SMTP id 5b1f17b1804b1-45b8558be6emr82490175e9.34.1756814370975;
        Tue, 02 Sep 2025 04:59:30 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:30 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:16 +0200
Subject: [PATCH v7 07/16] pinctrl: imx: don't access the pin function radix
 tree directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-7-bb091daedc52@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3263;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=UHL45bU3ycpBbK/9v0T/s+H5JbIm9uq6QUqV6dCnaD4=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwTg2jeHg7MNqyFVpB53OT3hBDpMLMqtzNww
 Mda9A73U02JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcEwAKCRARpy6gFHHX
 chIjD/9z/2COMvLdzt0sZZcC2v2YMaEH7j/ovLMC4xkic7o5czvRo1n7/S6B6mXDm90zT8g9iqO
 sKmPGq1jec9ahZ/sG7AjV6HIK9GMa6Jm/RZJWIakFs9QpzxgwQmqzQ4XG1z/zSW8jp5CD5tqC7K
 tYF18u3wvifVH3S9+DbzsNBWeifEDHRCxQ3pVUz/u1q8gk8FmjiUeRFXLOj1T4ibMLkU2jsD2ZV
 CAksogKfbUZoxCPgosTITDGYDwe3BROXhrBlm7OV1ZQsgJKkBwQgTSG18KV/KJuWLirWxPj/Tjk
 4ey1rb0m9dbIpYGtOoGuGXeaZYsejj1HciGAjPItW63hafjF8OFhYALR6ujBpAxC+xDXy6eVTTy
 NNfK6tvT/ZVzY1SiVxzkyYDg+q8ntrQu/x4CF7rc35jomHHsLis0VGtkedibJ2aMszPzSO2U+Gp
 5zzmGNkKITiSdLPojpJQZj0laaPjQi+t4ehqxXw6r6ViTzAk12e+QMSWPYJbypz4HMmPxYLqHek
 qPCtTOGtwHdg7eqSe3upVSYpcTwVZPBYORfF6Wo7oPN33vEhKtL/UZxCOFjUD4maqIH3MpD8Snr
 nfGpdqkEfAAOQrs64YvtHt6UTCTkOCcy3/CxRO/fDciQ30/X5DgLQ5ZT/FoySFzYiKZNiA+++6S
 z+eUAM19e+0hQxw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7F6E64000B
X-Stat-Signature: emwshw14r8dhx1p7bjjpurdqjhu6wats
X-HE-Tag: 1756814372-951756
X-HE-Meta: U2FsdGVkX1/LPxoVAjaxxbrLajRf3qZkWaCvfHn5CLbQ+krzVJGxZbI9eIloBiBkQYkuNJsIuQ4ELnbuSEBymJOzrdHIkSKZAXXfE8e/o4/SA9KJHe4+mV7RO2CztYrQHj987o2kRmZQsq1f7F1LOezVv936nsEjz2ZSC7J9uUKFAheNbZoMWDvrp5xM2f1Pp8RDtIRQzhZRwOR5nOWmOd27506568yO3Suc1cPf1F1fm+5ii4n2+EL4tO9wbE8rzZzmjd5jLHo07Rs//6LsSL8zgiKbes97FfMApt23ZZycIUPbBaU+1Q/KCLQFuUobI8pSfHyBjE56HZSynYhN0diiBYvmrE8rcj8Z+d+5f3A1mglKDFp75cvcEBB6dNqd193UrXev7Og8gkswE94wjvurpmJTt5GIvRBHl0gExm3PqzEly1bpkr8C3ftn1zoXCpl1OvOSwyanIU/W86JyXSMK3rF9IwEx4sAeP5+6nMmFa+uDVokSWVDg72WDd3eeo+UOV18ryxuow6U9VyrWwjgJU/Gzk/6o1zGjn8u86XHPu6xlVkmPeG0fvoV9z/8NqbPE8vvNDKEheDY5M3dtZwFlZuUa6hrXq40xWE6CYfwDuAZgdag82f6xx0AeD58BOGhtP2ODI1g9KE6rxcI7UaMmu18PZ9/qBe1k16IRnuYEiNdtC2RMDIdbPLPnjDF4HWAlhZu8QBzVkzxeNLV2klNvOvVmyi0zHFgvPQ+rRYtkQnp4+zlWVqYIIMLRiCO7mOjhZDAX6t3urjQXxXVWgWbVxCcL/Y7RlgJYCS6uqsbrBG3LliObyNsLxF2Eo2ssHMJb17BqlAoScuulGvnu6YgVr9bfQmVD73nAtVVznypqYwVnBiJQvqBc8tYv4rzb6k0lQsAKeYyBgPo7ABuokr6NgbnyWZSctgIoqfvAZ+ZMWAEkC2SxfVkQweawtwSzycTudEsU30mOUpyQgdC
 VtzQgJsR
 zUX2yQp81eOlDBYiwtxfXJlOHxCKxWKkqZhnsUQkK4GpP8eWz0D1XETCUpJrS4Uia679gV8DHVM2wlYQlG8WujHg+d5/U9a1kuCAo0JdsX64rnov9cC0MxBGJ0SFdV0w/MQmJhx/kWPHgr7bsT42+EaWaGLj0MGiuDpDIKfN9Sj8zqIYRZbGWM67DtpDUbYO5aVCAY8uiInTx6z6EPRZTrdKczWZmCZRpZihPHcFr+Jww+LzYW0MQLfLCbxOEWE/8zQsSIZHZOJO67r6orf4Z1exvrl3oOPRBlPZJv8DYlue4U4DcWfm+tYCJ22R7IhnqbZfIweKPnNgEPKPZghtsL8/vU7rsETeolAJTOA91XrFE6DmD647Fr7HMhVYVM+S8mKUXWCAzWgZun9zkw73/3ZjioN/gnccMkdX9ZfMxXTFx8dgjb65i2RY1uPAIlV0px+E3v3d1aO9bfgGg0B97VcLwUo6Cp0fNo7R+LyXChy/YVap3LD4coyWOGHoi1BYL7FQo
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

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/freescale/pinctrl-imx.c | 41 +++++++++++++++------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index 18de31328540458b7f7e8e2e539a39d61829deb9..c5b17c5ecfb5ee7856bc499de218c288099f334b 100644
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
@@ -669,20 +678,6 @@ static int imx_pinctrl_probe_dt(struct platform_device *pdev,
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
-	pctl->num_functions = nfuncs;
-
 	ipctl->group_index = 0;
 	if (flat_funcs) {
 		pctl->num_groups = of_get_child_count(np);

-- 
2.48.1


