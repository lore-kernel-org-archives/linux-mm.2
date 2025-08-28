Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C95C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922836B002D; Thu, 28 Aug 2025 12:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3D66B002F; Thu, 28 Aug 2025 12:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C676B0062; Thu, 28 Aug 2025 12:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2796B002D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9649C140295
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:23 +0000 (UTC)
X-FDA: 83826628326.09.5460A14
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7E607C0012
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=cdHI9ucp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWxB7D3jJyBkITTYt/u8P0qX4HLXnEbcjEWeuCzP8c8=;
	b=DkY2tP390EPS/8JFdk8b9QyjK1RhjRHyQ353BOGCjw2DoLrzQJHWzyIgzZmD3wy3evUean
	kuF/mmZ1uEXktYW9DDcKd1/bhSx1/P8aSHfJ3taIGrjV0HRPjy4/5AamzEQTCv36msJe2T
	UUFOutbnxfRV3cDVGsSwofizPIanX2k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=cdHI9ucp;
	dmarc=none;
	spf=none (imf10.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.50) smtp.mailfrom=brgl@bgdev.pl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396821; a=rsa-sha256;
	cv=none;
	b=LpMM2JY/GO+aBgkTfeiRaW2wsXZi+1dqTmLHGHTjALZfWzDUyV+7B/B1sPhReUziMBecmn
	Wrz2nUqlpGLwUNuUDe4jHYWJMrDO4iTZC/ls8Wpgps0UliaeRfFuG4B1RnNzeAjx313zdX
	Dz5q/CV+JhVMuURo/WqJPUF1vfSTi7k=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3cdfb1ff7aeso556132f8f.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396820; x=1757001620; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jWxB7D3jJyBkITTYt/u8P0qX4HLXnEbcjEWeuCzP8c8=;
        b=cdHI9ucpD+fYmvj5lzshsX7LrpMSUvv8NIgWrQS/f0sGBdTHwRk1FKrw0Y59t/EJpw
         IAycMFgx6tqEhG4rVIQW55+iAMS3CzN5dGA9UI9qDigCnwBnKn29jGXDA94yQkBbrUde
         fE/SjjkPr+c0hx7i/Hg8+3zQdULOdBMS5qFq7GtWkxZhNfjMLp2urrqyrtBD9hjMRb32
         bs3704Aq1jhG48qLfqXkMPyF6dNszeLwu6vZli/ENfqY8+Vom0nMCT/4vGSPfJryrdV8
         zbVn+moJeaRii3pF//igNl9TpuD6GmRcQKkXnLMfSVV3lUnEqm3OMR19lp4GEOqyVPnw
         7zxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396820; x=1757001620;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jWxB7D3jJyBkITTYt/u8P0qX4HLXnEbcjEWeuCzP8c8=;
        b=B2+UgOh5E+yPnVWYSkiC21E+tL9FgTUwHqnlP6mICwd6bn/IcaJ4d61qObR8eNf7W1
         /SeCWt5JzbRcrdu2nnESWNz51he+tC46J2SpcK8DunQuuVUl3GNu3lWPxyrlpoInge+N
         WaUC0ycJ/NgwBv0TUgmAtXUwoSgZxcs0MneuW1LV3a7RjQV3akR3uVNtsqSDHducvBHt
         7AJkKJsaZlRdBvH77e6oBaqJG3NZ2G/Y9zrrueu3NA4luoxKKfA0orOCCNIEUJAJMIpF
         RnjmWz+1eAIiXC84pvmy3l9cUPz4sa86glB+mio5y6qraDIHf7ypbAV+fMkOQEI+KigL
         pCxg==
X-Forwarded-Encrypted: i=1; AJvYcCW9P0LJ/Eo4M2bBEY1TEZXmchysI17GQ45t/Zqd1vUnW0fv0HLFjKKT7JcVTGbkAUiKqRG7kEEvWQ==@kvack.org
X-Gm-Message-State: AOJu0YzyeTOq3afCW95Ahyinid4gZFuXgoG7IudEzLQjuTD3pKuLKLoq
	5k4Uo92WlnGTqEHmSh251Oy4Q5bn3oBmZHjz5PN03HzCQhBZKM4Qb0Srk+jAPDCVRX0=
X-Gm-Gg: ASbGnctkrsXdmEVhm6Rq2/5NrJ/diklq2J0U9qzdTYN3iuv3llptX88M2xaetz5gmqw
	uokD9DUOGz2ZK24TT1FZnEpdxW4gBcu3y2wcHyaQCrvj9HdWR26sPSJ7VL6ieLAz0gDvM38zTWL
	Lyw80yjYjFgKhcuydNMhfgWpuOgAZ2RQEteAs8EuQL6sfyt3Ahv3xoIzfXVxZxyZaUqDedRvCGy
	Givlhh0Vl1QuTunGvwcvkcUZwE9MA2H2tCl2OYmpSx63Zz8m65pqoDWjh2xyFze1UEL/l5c9f4v
	q7KhYSFoSLF0izdklBePo0vra5UbWpJQC2KLHBmLlH+oO4o/gkotMat33GtcWMO0piGQm23fma2
	9wDIUPEi6gI5rJkQA+ctCdpUtV9+O
X-Google-Smtp-Source: AGHT+IGxgL+toNcQZblo3toDDSWKpb6dbnh0R937eyOGP2RNV3U+4rRZ/V56bRaM+9Yqm9EW7dA7Gw==
X-Received: by 2002:a05:6000:178d:b0:3b8:d360:336f with SMTP id ffacd0b85a97d-3cc22e34cb4mr6129720f8f.28.1756396819645;
        Thu, 28 Aug 2025 09:00:19 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:19 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:09 +0200
Subject: [PATCH v6 01/15] devres: provide devm_kmemdup_const()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-1-c9abb6bdb689@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2111;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=yGM1a+aC0va5PQYzRl7VigwSABEcy8VUGQM8wt+k8EA=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0M6t7kDqohITUHpArt8wxM4j/l0nGheDDz/
 lBgFuEny5+JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DAAKCRARpy6gFHHX
 crcbD/96BbYP4iAKgagx1b/SaoRaFXAC/EdEogLQkCvckdWVvEIEZ8Tcr1z720z6HyB9Ba31VkK
 eV5egMTpHafq/h0riC+6rAxWG3Yb1N/W+bFOh4kMVYLEP4i6IAEsBd9d9XUucbCaHWNolzNAw82
 KKUmo7USlAk0HC27fCTmsZZnqVRo1e8oWsvdTBS1A1+6PVPpCUSvm8ucDBKt8GmuW/iEtFk+zVu
 b+E6wZwWpt/ugBke2tciQKiYcaYz+BmGjgcg/giMss8x6aCa9LvzL/lM+jf0Hyci1OQ/2DEGscb
 XmSsXN1ycObeXq3vKKy+Ea9IqGk80HW/jaOM38tf8YRVVWwPk34YZuNAqtJb46r7OOTSfPm14/6
 2cW7KPby1U2qNtkIA6h33Dpoe+sVrnKNdSv3GL5K+/UYB9FJRAjQ5KwjtDLN4mgzhSMN0Tlg/mR
 7gu+PUHHkiTRA32ftkWqtc99guGN5R3eXkDZesJ6GxqMxW9BzbtLDo/EYtmtBSUyF2GwKSoNY4N
 ncnsxtMEjMPpqpcblxpETio3cmc/R16fhYa6nyINj58teXPUV+yzA3zyK4zNHhFsQJD5m+I1Yv8
 kObDI+zPGcSSuBJ8TtNtSrQsJjKKYZ68meo80Zv7c2jEmrvZbjqJqin3Iuc+Bew/4ZuXumx0Oak
 S/KoHAtfm3cEDcQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E607C0012
X-Stat-Signature: k6a66fwpj4tm4ge6oag1cmw37dt7ot4h
X-Rspam-User: 
X-HE-Tag: 1756396821-17693
X-HE-Meta: U2FsdGVkX18GpVz79bULOIsRnfo5ftAZNlofEqxPaTvvmquMJiuW1lHnrotjsEIHgMlDolfbc8T2tSJs7/Duj5FAx6ghqYYG0c9dVH4bzOZkdU0R06c5zpCPVpqeRECU1EPDM2ch3Pu+Q1YgAWhBSf0XmPEE11YxXlIbEHYsnJE5ifE1lT6MPtVt9BfmAkvfABI6iK+ZEb/APbURydpKWsBNSJ2/Rzh0Idho0z2YZjVtb7NT4YgZIgf07bhOECg1XZckOMfo/YG+jeDZEtywEOPcvIMAB2KkwVgvv8G7J0UTlva3KqySI7/PmwIuF5TTwbBvQZqX4KfWskbqisQChBShxh36cDnJ0Mv9NUsi2Yujf8xHqTZN15jiCpsyfzVAv6l94hm8AqBYAJNQzNLzlL3GAFsPA4L5RhOk1EgeXOWsHjogNdtzSyc9o45euHi1E2aqva4Q5Gk7H/cFTYwY/0Nad3FWzqe5mIkcRarz3fvqOORAYEePH3Ffp8RIWQ776buJRBlqNxZDG/gIdMfDxjTCcqa5515LqfMw7HoqssOtFjr3Cdc7Xjdy0/4Wr2Z5to1Azw/jt9hV31EsEXrkXFVut9QPLrtW5U2BYBWhwzV2lXFHi3t5UMkeuEtia58MYABOXcbl/3rXcFLvDJkk2WYrMURwMy1KbPPUjRAzVgf732022ul6UOvDJ8DT4I+CAgVM+uXyb0EBTkVpYAo+JrUcQsc+rwW583z9xNW1or5l01Ndws6bk8XyIYIEe0UhkOjZQWF6W7PjGHX16T2rLlGhBclJA3OIndVmgMT8wQcnePF3r/DpAX9RxuPbZXoJgk91fe01bHmW48jIdhupDAZgvob/NdJ172t+/QKKtLt3dqYK89Srjd0TSW6qxX0Z4ouOaD8skvmLY7wa4AO7++6rh+9i+zieLGkjpllT2fzzqd1gDKDveId0DQSBKYuNmlmoCR02453i2UsYJIF
 5aFjIr+m
 acm5w7iD5AZUf0cXa13+NLGofoxe9alP9pMWIVDMy2soObjIrMEVqj+W6JBckBPY/q2f39yNZxgFjXkI3J7arfukycfeapqgZ2tiLf0Ph4YR7laSTXMHbq1ouykz2A95a9gpTA2PODLvQ5/nuoY1A5edjW9E7YvfxNgBzOEyTLHgOzRN6Iif5few+J+5zxg2lB5bF0AykQZwe7AoOUkwvyAesEJpSRDq3rJfu3AfsJi6F3a1mkCw4JdxVKOqDFtTJdL6wOmymq8Nt7ceDknNQ7cr97H4apQX3X4z88AVqAyfbWHv0B90UMH4U8ISV84jNFL8aU5xcJXjPSYaMuhIncNcTHQkvlbWTeKTnn0qVoxhruapwPCSs+doBN3pIxOxyyH5SntQgvFxYAEkiwZGQF60aOWJx5e2+BLSVQFY9H0DfJpxuyj1H/hkeI4N65XgzQ9yd/nushaRrwWo20rNpXdvK2SYSSHVss/cYqTVld6Rp/zmwZ4nY7KBIiOANn0t5vFT4hPpDp8wCEYaOAWyX6vxFZQTuWsfNdQOjzFpadxqZ1pO8xJTLOSaCeKWLgV6KC57i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Provide a function similar to devm_strdup_const() but for copying blocks
of memory that are likely to be placed in .rodata.

Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/base/devres.c         | 21 +++++++++++++++++++++
 include/linux/device/devres.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index ff55e1bcfa30057849a352c577bd32f1aa196532..c948c88d395607ff511ffa6eb0a75b7847ab9239 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1117,6 +1117,27 @@ void *devm_kmemdup(struct device *dev, const void *src, size_t len, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(devm_kmemdup);
 
+/**
+ * devm_kmemdup_const - conditionally duplicate and manage a region of memory
+ *
+ * @dev: Device this memory belongs to
+ * @src: memory region to duplicate
+ * @len: memory region length,
+ * @gfp: GFP mask to use
+ *
+ * Return: source address if it is in .rodata or the return value of kmemdup()
+ * to which the function falls back otherwise.
+ */
+const void *
+devm_kmemdup_const(struct device *dev, const void *src, size_t len, gfp_t gfp)
+{
+	if (is_kernel_rodata((unsigned long)src))
+		return src;
+
+	return devm_kmemdup(dev, src, len, gfp);
+}
+EXPORT_SYMBOL_GPL(devm_kmemdup_const);
+
 struct pages_devres {
 	unsigned long addr;
 	unsigned int order;
diff --git a/include/linux/device/devres.h b/include/linux/device/devres.h
index ae696d10faff4468a41f37b5d5fd679d4ff11997..8c5f57e0d613492fd0b2ec97dd384181608192fc 100644
--- a/include/linux/device/devres.h
+++ b/include/linux/device/devres.h
@@ -80,6 +80,8 @@ void devm_kfree(struct device *dev, const void *p);
 
 void * __realloc_size(3)
 devm_kmemdup(struct device *dev, const void *src, size_t len, gfp_t gfp);
+const void *
+devm_kmemdup_const(struct device *dev, const void *src, size_t len, gfp_t gfp);
 static inline void *devm_kmemdup_array(struct device *dev, const void *src,
 				       size_t n, size_t size, gfp_t flags)
 {

-- 
2.48.1


