Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87457CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84F58E0015; Tue,  2 Sep 2025 07:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0EDF8E0001; Tue,  2 Sep 2025 07:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89668E0015; Tue,  2 Sep 2025 07:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A4C088E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A46111A9F9
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:26 +0000 (UTC)
X-FDA: 83844165132.14.1A473E0
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3A7D61A0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=GD11qz1u
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frWO1MUM1iHp10hYQSMpeWUCufaMLUNxXxOHMSOr6+E=;
	b=R9tc/7lfUdKlZHWJbkt9PjBL6Q0sgqPoGRDz9BW/H5Wc8GPpIxspFr70eC6ph3s8KLrD1i
	5bYuqL0grH+qZlgHD99uRlArNeOFSEqkykuaXU5NnuzS6phDRjgzqSSeTGVTQql1LXIgLN
	D2oSzasDwk6LTh3PvI1I/hep2oiHbtA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=GD11qz1u;
	spf=none (imf19.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.41) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814364; a=rsa-sha256;
	cv=none;
	b=Q/BAMoO4SqtR0j9u6fyFh3Gj/MgXpwWCfFX4EHt6MFlge+4oZJIklQONbjKZVMhWNH4jCN
	1OETzrV/hZRSTd4uSaZZWWwQNSxafYaE8m7ALoHi75pXNF9B//VieXgKnpDc10g42TK24/
	tjMuk8oZg6vFAu/SPbRDPlHfSCNCv6o=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45b79ec2fbeso35719935e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814363; x=1757419163; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=frWO1MUM1iHp10hYQSMpeWUCufaMLUNxXxOHMSOr6+E=;
        b=GD11qz1ufeC0ux13Lm2NeSlJ9ljqBdDyRi6m48aBho/kWG9klw7/dZoCgSn5OzTmNb
         BDmYABrU/4b03adbRl4s/91h6uoDBHnZOg4DdeP6xg9A+QMbL8HEJ0d2rNeJWXULQo3j
         j28u0JtCbEqYb1VOoEFBptWJAC+O3hUfKaRZZAxyc3Yl0HN4KX8NgTFtmPnxyP8iVex+
         LMTTHMZxvhl2hULKJA9A7fQBJth8sWiMjWLoJyF05DR6f4/6Dj4Mysn16yLhyujBOx5i
         mxXc+clM/aZo8abWmxdnsBVnq2gHxekcnYa3DaYK0uuq4Aun/DSLW8ZyDUhXxfrSCnm0
         jF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814363; x=1757419163;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=frWO1MUM1iHp10hYQSMpeWUCufaMLUNxXxOHMSOr6+E=;
        b=Sv7HjOL/GQZeSyqL51m1ErN9x8qDFmBwa+IIBS9aWKYSqLUdI74dr0v+1yFVW38ALh
         k/ZWwJKfxUA32Tldkw0LniuYaStDnBkKw8gKUMwWZsK7X8DCWvMsAis3KLg7KSVM//SY
         JNHfgez75LCjBiu0NSxz/CZqixzvLgZRyGmG1w3h27i6x0TAYlFj3V3oCvmV/4LqCrML
         P8P61KskKH5XJcUAcB13FzCxxon6xWuA5zjMsUktmnPHYyxWAAvr4H4Mw1OejZVQiJmV
         GwWU6ydQuHRyLLGSUMWta4nW2K/4Oq5EmBX4tUosdBSeskJ45KGz7s2duKgNkqJ3Mx8W
         vUMA==
X-Forwarded-Encrypted: i=1; AJvYcCV1QwHu7+KdfxyUzADeoIFj2L+MbW+WIXoBwsUaueXUVzLxoe9UBSHqMpjKGh6jjmJ0hrEvdYR5Sg==@kvack.org
X-Gm-Message-State: AOJu0Yyn7JU/AyiEUtlvz1Gt41V8pWEsKa7KdRh5VWeCd2cqywJCCL6K
	VlODyo8qqCXv7YWu6hReeQPK/FiEbcxYWqbPuh987dPnxH5zAredpdwKx3GRgpxeKzo=
X-Gm-Gg: ASbGncvrCQ40iqygrRgduTzL26l7Yo0gM2YfcPFh+Fi2zvS1AZUKO/0puQhAwBv/i8h
	du9p5kRz+/kj76Vh04jDYwpDoMFNijPSpPm/Qy5HjdQyKNs2Cdw5FP6jVctUyEzIpNMGeZq0sFN
	3zFwTIl8h53hGorV3GXGkdMTMycjIdS6XQq4rBzlhHnbQcTETaLNqr8FEZvwesTmEZgXyFHOL4H
	HG10BczlxZw36LW2Agc6svEnS59Mf9W8vQjZVlgpwXotb5c9gBb5DrV7Zq/kkUy30K7O5tVe7CC
	P0T/u5mBUBpJ0SH+dNg4PLBod67AUYSk6siT4/vD+7qcT5G03ei0F2PneMrG70kCG1dKtneD73C
	ZUAV5T1odkFZB7cvyOslQ2UnsB5s=
X-Google-Smtp-Source: AGHT+IH0xKJNlyv4ZyEJNfQNwTyZdVQINH+cdoHboUNYQ9kgUCTDaVU74ZUCabwWO02Je54HFp0TUA==
X-Received: by 2002:a05:600c:3541:b0:45b:8adf:cf2c with SMTP id 5b1f17b1804b1-45b8adfd08cmr65485875e9.26.1756814362526;
        Tue, 02 Sep 2025 04:59:22 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:22 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:11 +0200
Subject: [PATCH v7 02/16] devres: provide devm_kmemdup_const()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-2-bb091daedc52@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2225;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=/fPVmazhQjlUCOZ/s2UWyZhfkrmgQ0oqqeO6j82ecPA=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwSqkj5THulrOPioeZfQvwHNm2obXZdlx73n
 rLgQ+gp18SJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcEgAKCRARpy6gFHHX
 cicBEACBSsEN+zHGYUqQzH0L1fVuUR4Uyab1CeLWPuBlfFDOeIdpOAiAwQMbodQXN0tUpDtsdfE
 td+XDUygwggIWKTi8v2mOwA6u592fDxYytsIYAIKlwnxlylnU1dq0YsxtPM2jn0E12ksyZRhxRZ
 fUAmR0hg5A/YXoadpFnbYagOSaf2hU+jiUmL4f4K+ypadqW1bAlVSzT6gI1r0pMJYfh7/3yX0PY
 YG5m0U1+PTJ7m3EfG8+corSJRAS78Sh2FtPt6tkxA7SvyTZCtkF+9hE6cIDbwl+EePrpvN350H7
 EFf+SVimrXeowCmoBm3yNNB1NmuPdUpEfzD5NZKO5RNzpC43CqCeDbSGBcJ0mJbKZ25CxZfucRO
 qSqYqC705VQLTtzvva16XMEqe9r+MoAoLj8CRWuiZqQ9X6/Q5UsCNHlK1x3nPumfgoDNaUvz45z
 Ag5VkkTMHChrka1WySas247IzRPM0u0mdh6XwAooEFp1tu73+eXbgiljzYdlNrgwFRfTawxE8Yj
 leay7ODBWo8jv5tzc2mdo2FJx7d3gfD7s0sqbn6ynztvSoE77DkPLxqZJOW+LO43En0NrOYz7w0
 5QL1qvQD9C/lNGCMdrGAQxAR68tpaPC8h6+FTYhcH0YAaO+EbJVergnm02z7RlL4YUSmUYKfxPq
 1bB7j/qtQY97tcg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: zqdj5ki33mt5x186bq1d8itnagfxh6g5
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A7D61A0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756814363-7289
X-HE-Meta: U2FsdGVkX1/K7y4BQacLT2vKbekGBi9R/DcRr0ouxNWaoj9uG8n9rGCg9BaEEVdLhuoGtvslu+bVbhCp37fEEiIAsMg3CpCr0yRroONE+KjMsQvbPUX+fvmh/dqo4Cp/vmUK6OIZW0jMj8ANdiJRd9WDh+srkPn+MR6Ep67zzjRTBZTaljm2Jl0GOcLMmfL855XPsQjqt6N+ewirmsunZC5adWXoqfJrslRyhlrst59igPdNqbhUhdKw0b7RW7x/pwjqeGnrRHZFs8xA9lY5YtSQ7f9rG+Of9XxE52FPBi39p/+Q369/suRecrpKkdmlZ6ldZtQFJ/Z8KKZGZQX09VN7lTSwy4gWvIjgf6PmcAh5LeXI9YDqNoVKDfkzm2kSHRLWJ36thoxnmjDLjQXo/p9UZFNmCn/iOxcBGUHEcq4i+9dRqVlw5+rtJL0gHBkXvLikM5k0VP2RmiOYftgMZ57kS+R4EX9pPG0Cx436l4P+wOvb/6/P05GDWVaAB3nKo7u/I2Pmu/T3rfx/dVtCspkJvEW2Oh2TLac4s8I9d/gVB9Ln+05+ZYJ5Aris4J0U7Rd030XEkCkATbNOkjQhHuW4e7AcevdXkn5PXyE19ylMfBId613bVuUkStNR8Fry0w7Wusb5SVRcbc0bmFBM+zSDiB84R/yw9DbRSr3ZvXEvVRecmPwTx4e1Pnb2A9Py7n7c72K8SJrcIG2a+5ZnMy4xgYi3pPBtIyutnfa2HuqEaueJWrK6Jii1pG4ThlJPta6ZTq9rQGjjfqVdl5kSLOc7ZMYJuy3e38tidohxtcNnRax+lv9VF6amgypCWYQ3+7Ibcux+1OVy8XPESFfEVudA3qy8lNQL+mswFrbq5xmptJT6+LHHUgPySgK1eX98NU2sPmaDt2numulwKRNeFYpEoWwVc9aRlHsD65tmPeb5bEQ8ENXpEHxU0bjCuB8uQQasJZSPoxu563QuigK
 avSvs0Wr
 IWSi1eZNjEEhyLIEql1QXAvJcMp1bG5cidrfI4Yibxs5zYandyqlRjqUJ+Ip4mFjPG2qZ7rBBlh3/uWQDboq17GAFzXETmYkOTM+I4leYznfqae4X4m1o2RhtGfBI/2C4d87w+ZN+Ot01L2uFE30AlXFz5XsGSzZ7Srnf1MWST8WL3WltBdhqLdwuNGKeZkkDnZryHjCUjL6L938LqMCzMPDt5ve+tVGlTQJUDPjvOARwS1BqAFAt2YBUdyVYL6FsZlA9FI7pNWA5JFn5NHEXp2bd/0Hu1NHdhAnDU/M8024gMYKkBU410iY9nqC9CmnnN7Drhd2oTsadmtCZFCXWsz579lYVogwlO7nMpB2GcSGmAQDrynbGwszTe3X2+3jebv75UI/OGS/F2QHP8Dy2o/gTzLdK9WWwDR1GQshztY1IxJ2IMVkwrYhM3+N4inz8XOMm2sY6Zqj57pmXnjpr4M4LGOWpyUz+dIDpWFiHqqIbAoQvQgFJGGuGPyKqzTUkk5D1xVGPAW1dUD8+UZzYod3LuNcX3H1bTpl1bKYixYyR8vu7lZUIzraYBLMUodcZIXtDhRuPwiYfDo2FbV93a9Ap259euF4Gl4sfRpl/gojx+H7zc9owKjL7TOHMsbCl3XWL
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
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
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


