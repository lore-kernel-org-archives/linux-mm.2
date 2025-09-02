Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE611CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855C38E001C; Tue,  2 Sep 2025 07:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806A28E0001; Tue,  2 Sep 2025 07:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6833E8E001C; Tue,  2 Sep 2025 07:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39B9F8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9D86BDFF3
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:37 +0000 (UTC)
X-FDA: 83844165594.25.99E0147
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id B93BC10000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=c0HJHZdF
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2G59MubZTeiU7liQ7BG00dmfAPEuJzh2uMSB42Di6Tc=;
	b=XRGUWbHh5npBwmgIDlhBgnrwP9AkgGfCYp/qoeEgiQ3lGHcCx95JzVv9dVTmbeD6pGML4J
	FSctQ0BikwUNQX7AzcnSMbHRGTxM5LTmuPIfeCcyPXI5AXYrQU6ZTx8pYHzAZPcKvTUgB5
	ocONNGtQLNEY4v1dv/TXSqmobWqAzFo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=c0HJHZdF;
	spf=none (imf14.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.44) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814375; a=rsa-sha256;
	cv=none;
	b=RZWHb9DvhXWG1RhXsLkfq7BAJHEQV4WMAzDUpQXXCelATENFklYm/P0WBy4dlilOT7MPrP
	HDgEhbt9Rn45i4dr2FL4ZUG7XZ+RZeXocdlpIKj4M8q6iJI/qsWyTi+zlyVvwE491f+6jW
	PqIrAotAmL1YPM4NEmIZG5TAopZ1c5c=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45b9a856dc2so2864695e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814374; x=1757419174; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2G59MubZTeiU7liQ7BG00dmfAPEuJzh2uMSB42Di6Tc=;
        b=c0HJHZdFBbmPsECuDVQdge8SeV6Xag0cJIRxFql1256VRj+g/R+f+Op4s160pdH0tE
         16qtacGE9L+FTcRGRTQ1oOFzT02lqLh1MzXyDyye8FAQxJLwIhF2CRd+ScYu2zbt8zS9
         yRHIzyHDyK7Snlw6LVO0yTDgaJTfMFr8KhAFTWEsl4dK35ay9PGLvnloIEtw8Sm3b+3p
         zAW6nomnDn0YPs3HaM57vVnWOrgBI3xEfPYSGxOu6FVXW4qd+WPDViTmi4wKkH6QEamr
         W0pKAbUiKYCBWnBrB11GonGJkcptAgTFs7g2r56x6NqEB03kDCZpgnWdw07EHgn2zp/+
         /tlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814374; x=1757419174;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2G59MubZTeiU7liQ7BG00dmfAPEuJzh2uMSB42Di6Tc=;
        b=fRwdSCc/O5Kja9wYD5t4V858MTJKvq3KL53J/vGEleXf1ZWtmmNgs1jKI3Pfd29J95
         YGz7e7jyEiSn1Z2xVeX8dFLA/nQtRcgwfYDRKx712GGFSHsWRBk3CQbbLVwLrURzkWs6
         07npII2vJ/sdXj0fNhF3OKO6P9ptjyXTeA6YAiGSbsynBvg/oKwD0EnhS09RGwB0ZA+0
         AnUJQ0Axq49xYPfjg2Nc4YRyV/P5D32DsV+jDBtlKzu/jvHhzpsjB6AURmUOECw3b8tU
         JOb/Jy85/c+1UELQR+vpCvn4x1Y6QjCK5diO3n2hHo2xGel1buxjN3qj5rRmP+p9wgtb
         14ig==
X-Forwarded-Encrypted: i=1; AJvYcCWiOIrEQ2fRlY7aqEhb1Xwwj5o4c+2Wtmawa7kyD2uckcG6k5ctq1OThFNAwDGI6BfjerCZiu/r5g==@kvack.org
X-Gm-Message-State: AOJu0YwjUvNx28TZUkOuuGLNS6XmNw1vs1vFk1IXyagHKpbCwyTTtkTm
	xyU/G7EC89b5moY1tbT8/zUFGOHk/6AQHf1o4OctEZ/lPaaRX7X5jVzvik2+0UxstOs=
X-Gm-Gg: ASbGncu1/NzOcd8IpjvZ3hSabMgJetk53NuRpp3mXKNRAR9t+44aM02hLZsZfZB1Ouv
	uNuw2cx86v6MNfxsrsUUnM2WBxDfiAhyn1NHS7tT7ks64if1wTnWFFT7RCrFheCkeHIM5k9jGiC
	QWdXXIdxFh1am0+eadGi6K+IclfIy+8DEbN7mmXzCsEHI3b9Dr2cP2CBLWUcP/Fq3Jf5hFhtqsm
	bjoo29XWlfhyvgEbBWMuSO6v1hc66jN+mjWx30bXMjTidroLQV0+TZ9mLcD5fikphvOFm4relEz
	S4RqrxtPHFOl5DI5DESIQ3boSuYCFrXHG/t++QvIkUxfdV2gVISnS7Mqw9TMhIL7v6YgvzFHOCj
	L15Y58pVT7OJsa7Nr
X-Google-Smtp-Source: AGHT+IFLYpm7MHCoBbrYA9yPFwTU4Oi261s/PzucYOvn9j2GG1ZzAR8wL2RYvG0trkoc4GH+jx5MDg==
X-Received: by 2002:a05:600c:1d07:b0:453:2066:4a26 with SMTP id 5b1f17b1804b1-45b8553417fmr112095205e9.16.1756814374299;
        Tue, 02 Sep 2025 04:59:34 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:33 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:18 +0200
Subject: [PATCH v7 09/16] pinctrl: keembay: use a dedicated structure for
 the pinfunction description
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-9-bb091daedc52@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3029;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=ow80ySNnxG4YPhFZmsqjHWDVkfwZ7d2knu+v5a2fm7Y=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwTalJ9xEimLer/4deaUbuj2xh0hSCbfKp6h
 mSFLsj8wZaJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcEwAKCRARpy6gFHHX
 chHMD/9qieRrB7kLN2tVVNwNzCXwCyEqCxacgLrSqioX/qG8i5nUPX7EHz277hj9w0PidEZ1ntG
 zmHYDlqsFEPXAuTkXZgG9SopO1HVkY71LVr0hPzCGA3VBpWobmAQSKm/9IMrJPw7ZA2XtQhX32p
 kda1warDySg74DriEQwkfYimyMZ3TQ7pHNBxj/YXFrUqHE2bOWZH7roy8l5AF5dB9oc6S8PQ+Zx
 iS/JncN6wC6U5Ah+lX+mMsuTa6M5HJoJ+Rn00ffY3hUzSpJvZncDxwqdY5oYbRIUnhm31mZ3u+b
 rK9QwspUrOmf2xLBv8KmvqFUo1tNgbKyH8bEe2ODS40J1m4xfAyT81CicpoTkW4hTRN/LoWDmRH
 RUnueU/QhNGG0LtvDy3EesY1kCD0PHgPfvs0eknqOYCNnbgVchgt+WJFs8yWWN/Uh9jHUfgspnL
 GXaBzcEcN+KMnMuO1WjghdXpJcpBfPZK53ftw/blY6FQc3I9OrH6wBgTL7SWFN6WKIrNt6xs3u9
 a62AdwWvXg2t1O7dAJlzT2n25b2Gw+nGqFBM6MI0xKBrxIiV0fCxwFjWnVp0y7jsPy+6f43Jma3
 oTrvmRfRyonsRPxFZ6I3JXqC+NUq2IfQ7hgKvO6WZzeEHpqX0fiqO1ASQcW9zStc6L0O7YQzAEi
 yx6zfFbIqCxZOpQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: th4hhi6mpwinjoxq3p6oqnrayxwuyko6
X-Rspam-User: 
X-Rspamd-Queue-Id: B93BC10000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756814375-216844
X-HE-Meta: U2FsdGVkX192FuJpw3fWX1imnfWR1IReRE/ciYOaXj/m/NeSDd4XtDEvYPTjJmJA4vic+pzuiDcC+wiSqNVWIarqF7lAC9J8t3gI3WY0UHH1b/o0vAF7/W89Grcc2k7H2h4TXGQFdvcJ9pQfgvwxmIjlOOeF238jOFKeJI9Fa0pY1fIC9VM+ifZVDhkbavRfRXblm6TorfWapfijRwRNkCbWG9+PYylhOlHm5Vbk0cV8DVXrU+I4OmoKoPDbx0QrXOo96R+OSPntjqxRJw2JHK7vtNHzZ+W2xJFO+i5VNIaXHR65KRGU//BcwkKwhxWGItw+5Dhk8S4Fp/KoGHN6PmxkDTmsouWXvm5T8Ad342EzoS3AueZF7ubXzQ4rweVkNtVlXPwVjGosOm7WbNZdO0wU3rtQjNULq2ypDs3a5STfSX5OquVIJS06AexCfydrA2Dv1Brub9r4uDQ0Kfd6OQQsBGF8KbAAx3XiRoHEzh823LWH62B2vUAOVLrqohn2ZPjtoOd+ZGUPkTlD4gnsCr38HyOeu8v8VNapxMtWdzSgj4fBwWYQu64k/Bx3eaqeuPxGEc9P6ePSCozOAq22tTI74ho7XiwcnxKKd5f02ew19aFf+emaEiHEKOEWLZVKxJzQVoykWCZ9a3XRySSX27eMqVEpdZgZvxgYPSgU9DWu3McAekgAtIqVF/2jwT72tQ4hvovprUC9IpUNx/tHiG0E5A6HPwvxZujtrpVNzGadK3u3I1TfoW9b4stWuq2J5q7SkvrAStAoVucDVp1JQzayhUchEQluVVMq6lvrTS9MqD8MXAAYsdeARd67uCc+AlF3RKJEa8DDZUaFevlYGY5rJFq2O57Yl7qR+aI5xL3V6YfCA35BVuJJDBiYvL6j8VYZbU8dNNHgMsYFx/QfSOHZq3Sm5bYpEw47Izu5V9IwO+5/kQjv9d93n6UwmTVYQOJzhyLlSftTgZzj6QN
 zXIZeKW0
 jGbMv8I2um4kZS664JcPDnTT7phjPigcuE6sfNaviodFeEzLuPlfQKJebs8GXnwtI4RgOoslP8dt6KsNcB0ANSNIGpuFnxaoYE64RptWFGbJOWgsaV3fl40TdzUTVpBy1xbW1WU49k+00qEh4yjy517SWa0K/AZchiHPQN1k7kr/GiRFQ3f/HwnFHP+sBM7MK879lb5N8jMFVrJr5BUqLPlvHMSV3wXt53USVgT1ktAio9l63HoDwx457owyJHle0P2G3vSRtgqIMEh4tX711+zJohMrgp0uAXmp92lQCueob8tw8io/l8uyrV8+9+KOJ6KMeO90e7t42cubrZcwPb5od5bKXII+jaXj+493Dn1IWJObOZT190waJJDf53vDIakYhXijK2qdTQ9mOlZE7BrTH8HdNlL9TNwrjGDSdkIa1wnSIKMFw8tvOXfpzM1FNhCn/vxtPnC29n13fSHGAfPG+e2RDbMcVwUCCiSa9ov4GQ0IV7J3V2wu/1Iy+RE+kKYFvTcYr5yuu7hJu/eXjPfKUbS+MMs22pY2j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

struct function_desc is a wrapper around struct pinfunction with an
additional void *data pointer. We're working towards reducing the usage
of struct function_desc in pinctrl drivers - they should only be created
by pinmux core and accessed by drivers using
pinmux_generic_get_function(). This driver uses the data pointer so in
order to stop using struct function_desc, we need to provide an
alternative that also wraps the mux mode which is passed to pinctrl core
as user data.

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinctrl-keembay.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-keembay.c b/drivers/pinctrl/pinctrl-keembay.c
index 6aefcbc31309995ec1e235416b40aab3e4a073a9..e78c8b3ec245aad56e3e74a26d27c41ba4a98281 100644
--- a/drivers/pinctrl/pinctrl-keembay.c
+++ b/drivers/pinctrl/pinctrl-keembay.c
@@ -135,6 +135,11 @@ struct keembay_pin_soc {
 	const struct pinctrl_pin_desc *pins;
 };
 
+struct keembay_pinfunction {
+	struct pinfunction func;
+	u8 mux_mode;
+};
+
 static const struct pinctrl_pin_desc keembay_pins[] = {
 	KEEMBAY_PIN_DESC(0, "GPIO0",
 			 KEEMBAY_MUX(0x0, "I2S0_M0"),
@@ -1556,13 +1561,13 @@ static int keembay_pinctrl_reg(struct keembay_pinctrl *kpc,  struct device *dev)
 }
 
 static int keembay_add_functions(struct keembay_pinctrl *kpc,
-				 struct function_desc *functions)
+				 struct keembay_pinfunction *functions)
 {
 	unsigned int i;
 
 	/* Assign the groups for each function */
 	for (i = 0; i < kpc->nfuncs; i++) {
-		struct function_desc *func = &functions[i];
+		struct keembay_pinfunction *func = &functions[i];
 		const char **group_names;
 		unsigned int grp_idx = 0;
 		int j;
@@ -1588,14 +1593,14 @@ static int keembay_add_functions(struct keembay_pinctrl *kpc,
 	/* Add all functions */
 	for (i = 0; i < kpc->nfuncs; i++)
 		pinmux_generic_add_pinfunction(kpc->pctrl, &functions[i].func,
-					       functions[i].data);
+					       &functions[i].mux_mode);
 
 	return 0;
 }
 
 static int keembay_build_functions(struct keembay_pinctrl *kpc)
 {
-	struct function_desc *keembay_funcs, *new_funcs;
+	struct keembay_pinfunction *keembay_funcs, *new_funcs;
 	int i;
 
 	/*
@@ -1614,7 +1619,7 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 		struct keembay_mux_desc *mux;
 
 		for (mux = pdesc->drv_data; mux->name; mux++) {
-			struct function_desc *fdesc;
+			struct keembay_pinfunction *fdesc;
 
 			/* Check if we already have function for this mux */
 			for (fdesc = keembay_funcs; fdesc->func.name; fdesc++) {
@@ -1628,7 +1633,7 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 			if (!fdesc->func.name) {
 				fdesc->func.name = mux->name;
 				fdesc->func.ngroups = 1;
-				fdesc->data = &mux->mode;
+				fdesc->mux_mode = mux->mode;
 				kpc->nfuncs++;
 			}
 		}

-- 
2.48.1


