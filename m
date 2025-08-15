Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176A6CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B17900236; Fri, 15 Aug 2025 05:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBBC8E0002; Fri, 15 Aug 2025 05:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C67900236; Fri, 15 Aug 2025 05:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3BFEA8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8828136F35
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:31 +0000 (UTC)
X-FDA: 83778418542.19.E2B9FE3
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9B5E120013
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=MR6Ndyw6
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcnhHIb6eNEwdjxZYrigpF4SQxNgYqLi3t6s+DqhmIc=;
	b=eDLeKXXJpqGT3WTiulF6Go1ISX6c0LfxYRqx/RdYQDOIS9oV8sNZYwoV+mKumF0L6cNEsQ
	WUng5/+QYvR4dydf3clNM32NSVOtbXTQwNIVqBl+83OeCUZzmxx/Jofi+Zf4HCFivtyP2m
	soMFA13GnyCmdO13LIFweKI+szKO2zQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248969; a=rsa-sha256;
	cv=none;
	b=iKb8+MHIsmGXKydgCHUcXR5S3jIlgsNPmCbUutKolc3sfgnU2IT/F2dkUcu8L/XQbQsXiE
	sH95iBorlycWlARjmScTp5glaeqouxP4Jd7PJtPJ3K+5pC5jib+QxtjNfJiUN6TwN7Lndv
	8bimrqPllFVVZSAqc63pWGmcmpWCFlY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=MR6Ndyw6;
	spf=none (imf03.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.54) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3b9d41bea3cso1562876f8f.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248968; x=1755853768; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rcnhHIb6eNEwdjxZYrigpF4SQxNgYqLi3t6s+DqhmIc=;
        b=MR6Ndyw6GE6UJkZVflieqfMmBeM4Q9bU3jB56GIdhtG+PiItdXlOvrez3Vgz0mcQ9J
         Je31p80EoSwzhAgSyJvwj78Y6sarepcJ+6D8OJMpXlKrAikiqA1fBJYIm5hpg1xp28AS
         Qq0ik46PSr3uzounTHYshyam1OsAlYl+KIH8+akd5UM/2PJHxiESFpO3q5iIAPY5U8mn
         YNFX8FdUgVQLvExctH4tS8XgE+OVYiNmXwR9n47RrJDsX/QC3iVaBCp5lDH/z1k8a2B/
         d6xZOUkBoJilSABe/52W678q12fKdrZiCRHyqpSsXjxyg4w7/LC0n8451m1A+Yr4xOfP
         WLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248968; x=1755853768;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rcnhHIb6eNEwdjxZYrigpF4SQxNgYqLi3t6s+DqhmIc=;
        b=UAfec8jqJc+d+pyhVyXQNhfLQZQOOBixHX1vI5oqAmT+fl/L+Pe5gvNC4H5hM2WdT1
         K4e0llBv3JQZOM5M/8zOhkOLYiUF6tFy77u+FLskYPn+mgXPVcQ86zR8G/pqWjG1VFqN
         tnvVLDT2CYbf6XmLF4sEcaKxE6D5QZ5JjUP+WEVnOoQIyvE3vjeD/6Gsx+WQgltTZgf1
         pmcKvglq7e2OU4pojl49NZjYDMuQT0rJQhp8xsSB9qmUW/3WBpEzpFk2ZvX3o2ANMwTL
         rxufHFzMX9JBCRWE69vja7HJz1bZ0NWyqfBBj5QQAAU6gwIA1PQjWNFO5EXqYD2TBVc0
         nSjw==
X-Forwarded-Encrypted: i=1; AJvYcCXxNPK3L4ZwYAc4VEv5LSmynFIUCp3MuAGg027oV1Us2176tcjr/frP12Hor2Nx/2Qq1P0dEs6NQQ==@kvack.org
X-Gm-Message-State: AOJu0YxSdK0tNgjPFj2mhr1eVJe3WvAkV+5miDk24d76rpVG+lrnM/MG
	v+rXWJ099EbBDppM+mqzZUrKQsS3URqpJfHBAQ7nLsg25Snihp2b3cO8PC80s1RLRhY=
X-Gm-Gg: ASbGncsrB9mEO2osV05LtkQHxrEWDJYGXPPhURw6lc2uvZC3Cnt8vW7Mxp+NDeqoUtT
	QbZrggbyT6dNJ9+BBmgCZBBFZZAmTX2tNxrp6WJq3Iqxm+hNvWOf3cS0xFlLAL77tixFl6/fN4f
	ow2PDYeFNBXSC0D2DzBVOmBLV6P3CevL12i5AIHL4YCTNvl4i7hkZyMKKg9CrkBs0tdI6M5qgOX
	0QmVooHjuVagSmLXR5Z7LhdH/zMVVReloZDoYTWnKdSOjguqXZXQsuFU5WvXvgx/8KilaKstwrW
	JFrblRZBS8m1rKTfVQp4GWkrwydoMr5yN5jby5A9YF6Ivw82rNuzSiK8PVSQV9ZU7fluf+MZXOu
	VcPVVxE8okAGOoIFq0w==
X-Google-Smtp-Source: AGHT+IECk334T6DAR4a8TS6EmWlh7UZ1cAoTGRWibGBdabTMKZmowz1e9Ft1rEqZaj0/xx+92lKCEg==
X-Received: by 2002:a05:600c:3596:b0:458:add2:d4b4 with SMTP id 5b1f17b1804b1-45a21803ebdmr13438335e9.12.1755248968009;
        Fri, 15 Aug 2025 02:09:28 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:27 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:09 +0200
Subject: [PATCH v5 07/15] pinctrl: keembay: release allocated memory in
 detach path
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-7-955de9fd91db@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1867;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=qPaUa8oAewMMgl8vCYU8JU6h4WrDoK89nonD2PTBKh4=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk49vTvI4Yqki2vhfowvJ8itgBed07OfvWWP
 1IW0D/2sAiJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75OAAKCRARpy6gFHHX
 co8/D/9RViTI69yJDAM4EMnxpBHjTbkjgLCo5+12MdD6irQvlPH7WAMDEHdgXHTfPuZCBslRHDn
 F681CDNXek0ARfTKOVwzdElXzOuvo5lfXVhpGWSo6l/hIEvn/8FvOQKWjbblDOQBRaPA4kW/SsT
 PX0h2zSSKtBSPAgqPlNsj3Hrjk02z5swiKfVNby/Rf75Gmt3jrn1gicqYNy4XvAdvk8MfssoZ67
 ILV1I34DYFex70AWKbHeILC0np2n1j0JNkhqPrZW98Pb8Fs0D2ZBVUAWwSBYZHOTEJvcetF0ptk
 hgBOxHPAlBP1/ZOqzemRwR6dI9QFVOBr7WXCBrHngAGalo4je2J0NXKdLUKMdxskRm4eC4yalT9
 vRvVjU/79HbKWhgGWCMMx5Yqu4cn8xAgkTtnpB382uQCJA33DiwPkovDMv+sdXi6PT3XORi6b2C
 dw4oNnImVUmuboHfeuZ2yL1MBZjfbpanOwrJp9ctvS1yWQHZG5n42OosyJncBXExsKHd+EdepP7
 UdKsNk5KwjnxNWyAi4y2GVvTE9N8ZJNJlbjNuGv2CIE2tr7kd/JRzZaj8hvlYwXIdp0un3ZUhX8
 ut8bcXSn36AAFe5iXHWX0OLQHgarcKs4M1EDx+6cfYjBM8lnOjLezxbetYfeTZSYpZEZMac2O3I
 zIs9a+PBsdnaHXg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B5E120013
X-Stat-Signature: r5x8chom38kze55himb9kq9588p8y336
X-HE-Tag: 1755248969-441486
X-HE-Meta: U2FsdGVkX18k1uCsfG3a3L2btExHKCpOg7Tl8OBq2/DQo1fgpSCa+Kv51sWjHy7ZClSnQaKF98bvGHeG/tpu2/ePufiCH66NrnV5oKyzCmCU/ZdKkVrbh73nAgWIFJ+3MHj0I6QfMEO1u7kiQywg4DvbKAJeGeK5q6tGvQy2RuwgkJMjc3x1FubrTOo6FfXwn6T/8izOe69/HL0bwFllc/YxWwLuvN0J2A6Ka/DDGIE1w24slrBB4w66rmmVHqDui6eoYg7B2Z4PBQfzenU4gvzCc3cAunxlDBuZsXcWCG1jLwgz1mlTZuYl2fuIWQ+mBzulLVcE5dYwDgRzMhlr1aQPKn9eIlTfiPCtkeXSDHsjCokaGGvOJg49a7kXZc+8EGyusdRJFhxmdOCUGSd/4hPu3HpTOBfSY5rBywKR2SnRFWu9fSovzYsiHGFe4cgP4gpKD6Nv1XwcF4wabLZ1/oeuQrIONyA6gc06JQVi9wFn17S497lkgUCa930JT+EjdaJ+mKRT0iZC+cD8AEIuai6l7tFUZaEnfxBEV8kfWL8GccOjulKYo0IGCsv7ftfW/fm5TDFqf9232/UdOFkuet+B2cvm2weA2aQjkM2fDtfDtJyoatc4s29KG8Fa2V3BTIJY0gMizngj+XMcF+uXf3haxT1onbkVfyYzKjWaVSqRXbdopL17pA3u1HlPy8KQ/VlxgvzuSS81JzDlgPRonF8LFHdc3LzmzaZRlVax8orGWTkHDD2lc/u1r/JOyYQmEbfbyAWfTJ5GyuE8LV/2VACR93rmMJCiFwp2G0oxJJBVLvpXk7H9keSjYJx4luRVL2YMp/rfJGDa/jidqnM9pI3XQ/4xWU6c+a/+a0lTUoG+sdW7u+HTpd+7QzX6Ug5pSG8fEX6aAM2NawKph9BpUBSTVpoxcOL9Rl9b3bfLM7/Es3d7UrDmMqr2U02W4b+oqgixCXlvK8Uf+vkijZc
 11V1pKRo
 8DB41TjWk2eWT+QP4JaHKaNqW/b8hhqQpXNy795EwY44KMJZeFQYW4ejY0+nbQ+GFbOu0Wbb7zqkfXXi299Lfekgnr6VyyfuENwcp+ggsyOTEsbdGDDlPDFBB8/aBCKt+HkVQaRgLPjAXR/+Jk47AvlkGUSLehWqUDwatNlsrtRs0QtN/C6LiUGIXm84ca2nKEJrkzfHezkX22WwQ94CXUVy4T/ut+xUG0xzdbcxit+XZLNY/h7JhshBLoLqWu9F1XZbrm430cp9mfVWVZy39jq7/8JhButTw7tWGqlkT4WVNRy2hzWqoIxagfdhH18HTFt1vEqiZUc8Sgy+SvI2H1ydw7Y5WVTk+lCmNutG/8MGHvrWzzodJo0neLRQV8kg53zTstBpAgh1uxymgYUOsfq40SJI11cNRJI9GZXU+Ynn4c3x3Ov8vlnxpIQ0LnPS09RD28uUvKweb78GHNCfaxURDJDW6Yj82L/2tUXT+I3ttOgAKtY3qkMfzpUzP3IAMw/8S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Unlike all the other allocations in this driver, the memory for storing
the pin function descriptions allocated with kcalloc() and later resized
with krealloc() is never freed. Use devres like elsewhere to handle
that. While at it - replace krealloc() with more suitable
devm_krealloc_array().

Note: the logic in this module is pretty convoluted and could probably
use some revisiting, we should probably be able to calculate the exact
amount of memory needed in advance or even skip the allocation
altogether and just add each function to the radix tree separately.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinctrl-keembay.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-keembay.c b/drivers/pinctrl/pinctrl-keembay.c
index 60cf017498b32a9f36a1f8608e372951c2b8f12a..6aefcbc31309995ec1e235416b40aab3e4a073a9 100644
--- a/drivers/pinctrl/pinctrl-keembay.c
+++ b/drivers/pinctrl/pinctrl-keembay.c
@@ -1603,7 +1603,8 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 	 * being part of 8 (hw maximum) globally unique muxes.
 	 */
 	kpc->nfuncs = 0;
-	keembay_funcs = kcalloc(kpc->npins * 8, sizeof(*keembay_funcs), GFP_KERNEL);
+	keembay_funcs = devm_kcalloc(kpc->dev, kpc->npins * 8,
+				     sizeof(*keembay_funcs), GFP_KERNEL);
 	if (!keembay_funcs)
 		return -ENOMEM;
 
@@ -1634,7 +1635,9 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 	}
 
 	/* Reallocate memory based on actual number of functions */
-	new_funcs = krealloc(keembay_funcs, kpc->nfuncs * sizeof(*new_funcs), GFP_KERNEL);
+	new_funcs = devm_krealloc_array(kpc->dev, keembay_funcs,
+					kpc->nfuncs, sizeof(*new_funcs),
+					GFP_KERNEL);
 	if (!new_funcs) {
 		kfree(keembay_funcs);
 		return -ENOMEM;

-- 
2.48.1


