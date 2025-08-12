Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95147CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39BC58E00FE; Tue, 12 Aug 2025 04:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326698E00F5; Tue, 12 Aug 2025 04:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6DA8E00FE; Tue, 12 Aug 2025 04:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7E688E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B822A810ED
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:25 +0000 (UTC)
X-FDA: 83767426050.08.A6ECAEF
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id A861B20004
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=kCFpuqmK
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sg6yGo5rWgbm4nmbYQkhIExx2oT2rNxy+gO58coC/aU=;
	b=Yjc2s6QD3rxI9VUM/lxXAIzaWC1JU+EKpxkQrA6eusdUB9AHRDFQknFIgjYq3cmzrBSg+p
	oW7HES3MGmup3U917p6/VqMXs/U/vn3FjVTceJdveE7wmDgA8y93uprujjLhxdUo1ws8ud
	O4k6CKkkDQfZkgJYgqou90J/ERRwiNs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=kCFpuqmK;
	spf=none (imf03.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.53) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987243; a=rsa-sha256;
	cv=none;
	b=DVI8FfM+FFZvUFVocAP9GqFC7g6pMkXVqNfFya9hoTIoU4mdcvZG2HRIqQSBrJF8t8iIZ7
	TI9Sr7jLa75xJUTN6VOW7RKg3L1fVWFKkUvZOvGFdNygwrrtBAYXUtuZqVBUDkBNSDzqzt
	t4ZvJwRefkykmWmEn1nbKQLL7FVhfzg=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b783d851e6so4403585f8f.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987242; x=1755592042; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sg6yGo5rWgbm4nmbYQkhIExx2oT2rNxy+gO58coC/aU=;
        b=kCFpuqmKp+//EqCFE9dougwbbdBotvOl2DPpmwzokv6KiZ/SmjQ+2JeuEc1BLz/98Y
         vKt/DIgJeMc0+0DYdR3x59LgnOoX1Uc91134REyv9Ps1WKuJiC16h8DQqW6HQihConVE
         a0olusOcnIV2acqxOEd+f9YvayiIa/+Mtlt0gfcikYv78/22pQpnG6I2J4wsramA0Qhk
         hbmx4waeI52g/hhl/IfOBlqlzQwutsEuWPd0r2iG8bV3WX/Gs+fB3PpAQvuhS9BSwgt4
         CvPq/ptIPEbbZjuEqGADfc/Qo6Oyi2TtswH5rmXtCOWrqyj2o+D+Xi05YQaGr87CFF87
         +/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987242; x=1755592042;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sg6yGo5rWgbm4nmbYQkhIExx2oT2rNxy+gO58coC/aU=;
        b=TRndf1LdJao6U6zPcDfcd5dd2JcdshYVnnlTTDLM92ZbWGosQeF4zDSHZtyU5/Wk9o
         r2T2FfA0z7Vx2f7RD9ap5xeR+dZEzTqLeL6D3F0vn+FC9lto5nFFJbjY6s5zwNWEGkBZ
         QZ2aElvJ/fNmN4Ir9d8iwLrPwLScT0TMYQ6XJfq8Gtqt7WRO/giLV9uxskHnHs+WM80B
         7eekTE8fIQQkAEn+BP7OKEp0fLiyJVebgyYqZwMW+bybMMoiNIHmrwccO/gxRHq/vVfO
         osoHj9pp7qrizMHTVNisEaGkZQ//Kk2zg8JDsNVkfl1Da5CRw5zUNuI2aV6rcH6FNPW3
         c5mQ==
X-Forwarded-Encrypted: i=1; AJvYcCXe/ulGP2gHvS9OD4fYg5S+XipPbdyEPUNi8VYvxSm8zxypKZmr0offeUlc5qKaw55PDs9EVo5x+g==@kvack.org
X-Gm-Message-State: AOJu0YxiJjypGOlUGsuAF2G7AwGGdqi93E4awDAmmkQ5gaFrNUlKXETq
	C4ROer1DZx1cZeYxH8V5FoX8QjafVFxeW+Ui1JkIWB0QXCkyt5RyiIuF0c22o++xLuc=
X-Gm-Gg: ASbGnctQ1XDqrjyOEF2vnYEi4xtDOQdHNWAg6YIAKhsvNKPMQN+fT6syl32IecZwlwa
	LUbzyPLN6CfmOQTQMCyakv3+YsqGmL0Q5bcQOK1FxjfeQ6dAyu8FDwInEvZblQF+UJZknBhYQQW
	N4Htk1MJhCEA9boIF2Z82SCg1e/6J57SCh9oG/oyT2v+dye+CVQNVeGMDbOOG6+90HTUol8pAXh
	Q+nOxOzwLf01p/q1/oalDdpx0ICZAHhWpIz7kKq/+6q39rtPfhPT2tyOf1SO12nSj7lvajhK7PL
	tR8C27eLKZzBYJnxrBLQERYeCPhuAi2mevSOi70cTdnF1QhT1ViPSsXSjuQ0jOD3m9WSp9JG+BP
	xRBy4VHs+7pVEFuE=
X-Google-Smtp-Source: AGHT+IE7RzdqszohpjnIT7cc2wTKSAeG24gAzL3U1lbvOrOc1qeSqca8LmuxQAuRcX6HqNeYGrkvjg==
X-Received: by 2002:a05:6000:2003:b0:3b8:d69b:93b with SMTP id ffacd0b85a97d-3b900b83ccdmr10680009f8f.52.1754987242087;
        Tue, 12 Aug 2025 01:27:22 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:21 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:07 +0200
Subject: [PATCH v4 08/15] pinctrl: keembay: use a dedicated structure for
 the pinfunction description
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-8-bb3906c55e64@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2974;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=HD9TOJpRmpG6enieox3SLEnzfmanpdaE65mOB6T5MYc=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrY8MuBbR5f3WyoubwUxwTmfyIcSpxQ7Ha5S
 zLVYHlj+CuJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr62AAKCRARpy6gFHHX
 cuHpEADDsPkguck9xZ93DDbHm+dAkW+gxRyBIFKg7MoqDE8bGz/PJcKk/1pqyE282dOw68stYlV
 vWEOPXQXbw6Kn/H8LprolH4tci+fdlUYSuFCVbwEZHEr12487UwAWk0X+B2HpqF5xcBnOdVh3aO
 XhnFfIkuVErPutmqWZP/8HbQNkc5ASjwIqSDD14dJHZf0wFw7eyA4KvYcWH472lCJ/KpQZgrFK1
 oL4rj410zLawPhIN0OT0AIYF1gECMQZsfoW6aXo0YqgMWt4z7/gVDJgbhpgs0nSWqB1/ri5wVg+
 9O17SbdM3avEKfy6ioY37j4RypySOqOaDC2cNt+/8RhGVM77rMBmEvMYESdtX9Sp3nySjpOPaeg
 5kQTLr7RSho6OQIM4GK8qciMCFnF9AcggpTOOw3GFWJKKWHUQOAdfJbiPyF56YUp13+rw2d52Zq
 qcBjz8+t3mIvEpCUr02fqA1yaeFZfjR/CmIlvEpkYCvBxW9o60l+SL7i4LNbQYppZQsZv7V6qwU
 59JLUvYSuDw2Z8OkViH9CzlRqd3PH3Z8ufgkHBFZX/jrwufWqycyN17bhs5PxI7xzO/JMD2q3rE
 Oyh+AdI+WlSwIi+nk/ccSPXY5Ru6x6NE9iJr8R11FGaDLpiRT1xMit6Vk9/CGA3AUU8FVayq/hP
 2n/7CMV5EcQpTVA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: A861B20004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: rm4xk3f6gbixu5dup3uo9uod931b6zwc
X-HE-Tag: 1754987243-867505
X-HE-Meta: U2FsdGVkX18sSfyuXSB+ZKMN+K+BCxs3CzUw+XgyTvS4KF9/EphP3HplBw6febYttRViajrEaNTVU2V4B/DEM+93F1Zq1rwtTwNv6AJX5c5uz+6rT2DXx5qAe5cGLaf3/6qsV6Poqgft7JJ4kaikAUfJXQ0DGr4c5Dr9i25mptEhA0ZhDaOOjVH4CsXuzH0pEzPH884s/2rrDz7+wQHYJtRBdmz19W+sZ7+XDTLgOo9NBmwJ6AN23NftjnIqatbiWNjcTneDfK7Q2k6T2Wu+pbWfhW9ZOuK37qcuZm8/sdk7af7iXBkoHzQ6HCPTWLJkHrihhpYFzKLhivfbjtgUU/2VvxgTsunQOcaJNGFVojdVPg9hRSGbh5bWCnp36pObptJz3RJagQVznKn1SMycRU5wSv0BZ73Bi3LSgqJgTd4ApI3WtCukPeyz5uGOwV7t30qnW3OCAEhv14cqcLliVaEoZzcrueiGstlbsb8HoLDNswVYH92REv469HF5GEe/jj+sYeCgUnbKKs3x4tNLAC6rjLBRU1euCrKEzy1BKCaXRqwNm0InPyhLg2Xax10xB0qCAlGe+J4stLqKWdwYg0HsLSqUjkc4wecQiTGG9dq2s3bawh1225GKIRyppQfa0yPLGvP9Q1C5mwqra1N3y2gaLnNl8va+hd3Kls4+8XZvLyHrdgWvdQ6uF+mmGcBKojNwA1BieR2FwcC8tbeYrQab624jt1SKubi6zxsXxFvXPuYB/OU8eG7xAb5GVf7h7zYyIDPLGGEAtuqUidb8EN8jzNv6Fav9N+Cvg+qkk6tV6WdllelDcVVtcyRBC/LaPNYFV3efOAuE98/kqFxXR79xu9fB5VD1mrzuArAiNj8o5IYdOeaUmg5RWAEzzg4tzstzTNDZKxJ02+s+V2q6jhh+O4d8c43OhxHeZU2dvZYz+wZKxKxcjbRnUJyAaO66EUXrCnbmbUOc/nK4hjQ
 2hxEytqH
 BOLAaEPc+inhtKx7y15qyw6goPqBNqQPjDt7vraXuWjV7z/aLzfbFg33sF7CFRFp/txUxar7u8whVjjkJq2z1s+yoqIBb3ELB/DNf7n/Jdq97GV/6j9KNMxUgNhCxz0c6zweEnq/PcQcqV1WfIffFAPoUjTONziNLw+l+s/RZsVL4lu6bn/ggMqM3I8dOararF9BZwcs9YoffFz0PGtp3QRceHk4XOjypRO4MmaGVFcMaE9RxZdo9yK6FSxAoiDvpreGx4GbHv160jMRkOWa7bv0bMWEo1lywbsGPaV+YQoC8wf7B6n6BNtidEmu4Ic4ofO6dyxMfg7NEX3ImTcoXFWpBo1RXOsCI/lZHgKfj6kJFfu6oKlGsb3BkggDOHlvsEocbybvwxXFPKXq1sTMywIHAWr3BVEqCuIWik3/iDmawlLRK4Go497T/XKGhpYKoWwxL59jkE9fjp0KswIqrmsbzl9igx41rx6sNNZI01C3DAIy4QaRcCuiXC8szrflvCRA+ZpqMNc2iBke1wOeIxUhrEoT3Ec2H3fDQ
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


