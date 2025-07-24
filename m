Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CA4C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BB108E0061; Thu, 24 Jul 2025 05:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6931E8E0051; Thu, 24 Jul 2025 05:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C758E0061; Thu, 24 Jul 2025 05:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8C48E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:24:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E095D1A02DE
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:55 +0000 (UTC)
X-FDA: 83698623750.02.5E4B8C9
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id ADFB64000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=smF8aeq5
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349093; a=rsa-sha256;
	cv=none;
	b=DE3wcEAyfhtQ9pjVby659+Kvq20TBBSXDuqOMhGWUsBbcrfLeOA1AO42gbeYLTLGxNlnES
	HN5MNFpXizGKd30QLQ3hnXAvNXkBbxk+0T2sGcvMv6JKAdSBx/+Hd3EJ02vQwGskQ/ofe4
	+5ZqcI4rfpn6SkF1bepfL1t0AMCaqK4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=smF8aeq5;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.49) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKjrihfR5UlU8kWog9NeCNGGbmct3fE4f6uM9NGLS/8=;
	b=VwulQZWVJPIklbYTFnDS062OX5rNFomHMg1LjcgsyuhtGjHsSoNQVDnGVwrvOTI5usWzN6
	u45LMvjCWDw284IUBUkSaDqVIOcbJF4d27c3R+U2e/Te4qlhV1SKEC4XYFF6ltDz9kZtNs
	N1GjF0iLxcyMbmy6xPGFvG6fgwCIgms=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a6d77b43c9so797085f8f.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349092; x=1753953892; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jKjrihfR5UlU8kWog9NeCNGGbmct3fE4f6uM9NGLS/8=;
        b=smF8aeq5S3y3VGhcKQ879QL+zW8lOLlg1piSzAHysAFeosJNhSzSbpEJBa+NZgI/1i
         z0bxM9JjN4xOlcD24BnqhQ9B9UqaVYHjWU8PTWnQ8QkqSgtlgAZ15XdLuQ74X7LcwR4j
         K7WBn3RxtQPv6IZ0wuC2cIi/Qs80img+lep7EGQXcGTskcefuZxQImKWgHNifrKkFju1
         K9Ala1UAZMw6PWKjj/hsvz5HrY6JBP2YiaxYTHOhg+zQLukOG/ZWCJH66nzdj62lPJ7E
         +S4jwLHkm05gCg9/ZNNFNWEZn9QRoedzB16QeyTFY9lgNiki2C66n8LiMU8vkj1vASeo
         M3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349092; x=1753953892;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jKjrihfR5UlU8kWog9NeCNGGbmct3fE4f6uM9NGLS/8=;
        b=lRiz3PUP1Gfzyp8+3FkaHUyPFkJBiCnidWwFsb4SNNZ1zTvL3YqhuRdmY47Bbf13QG
         ymHn+QRNU8MK3NG0MWmDVg6RL2GcrbdluuR1RERy5bTeRkjIPYC/o45nSDMD+ZqY0RKD
         59s9mQXh88jegzeg6GtpRwNlSiMYcZc8TWJpm09Kwlvr8pYW1f3CgCBYEKBtXl03tdX9
         MlBqGW8wrlL4Y7m7hH5TflZnS9miedKLDUv+oRBASLN2uVPwjLSh+FkFObgkG5Za53nB
         bZP89RiUSW6JOtn4zbaGIgbkZ7ebnqbC3mqIBEUvlK58jrfJ2pXpYeWxr+md00BRTN7F
         Nr3g==
X-Forwarded-Encrypted: i=1; AJvYcCWCkrW6/wwOOSkaMQqWGK4TnMPYt5nD30tCdDw6UXvwoT1qNBcy+XydqSD25PJ/oxCCCLaPNgMxcQ==@kvack.org
X-Gm-Message-State: AOJu0YyiNwpsofjDXbyxaIto2HczgbqY7OYvlikcphjbGBEYf9uBJy5l
	7d76+Z7uybDiI4V9SyvQVvrann20V/+3MnR1uDJNokYjBeGj5vizCEJDF6UjOYPLonI=
X-Gm-Gg: ASbGncuhb9F0Zt2bO3G5VK5jj7A6rYsUZosE+gilWvb4QNb1q20wMhqJtyZlCamP4fH
	hc1m2V3P20RvfgxwikIveNgOxsQpjCR44QQdgHDZvcMcFypl26LakG1i20Lq+eud31Rp0WYGWM9
	0UB3QH4imydPH2Tyo02Drq3aBE6a+ow4ifS1bPZvouoKZHaebJGDYy+cw583Pi3TihPEEdahUHc
	9QiWV+htLX4QLftDOoZU6djaIebwMCm6b91g+WlXwoSOpkZU0kvwtz4WnKfHjFD751xgx5Ljo6H
	mNY8bkPWKRSjgLA2hwVNxvwKemZRJSkUYARO42IAn0Aw2u3Nj/Fov/R5GKIP84k09i0kVQqO6g8
	n6nrtNGmyu9qpx2ey
X-Google-Smtp-Source: AGHT+IEew+Sp6i4Ubvb4XcJSx1ljbxjsNF3zWCFZCTjc0gm39mQLURSOD2KwaMMXuMVDrNvP/L44lQ==
X-Received: by 2002:a5d:5d0e:0:b0:3a4:e1e1:7779 with SMTP id ffacd0b85a97d-3b768ef8e49mr4370503f8f.32.1753349092060;
        Thu, 24 Jul 2025 02:24:52 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:51 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:36 +0200
Subject: [PATCH v3 08/15] pinctrl: keembay: use a dedicated structure for
 the pinfunction description
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-8-af4db9302de4@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2974;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=F6LdqVWEdZj3r0RjhnhQHFPIp/g37mzkevNQE3gBMmo=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvTVpmOt4llz/Wm2IBwGqzmLiabzjvGkJwgW
 9xjEp8YqIeJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70wAKCRARpy6gFHHX
 chw1EADi1Cwma2fZbyAAR08OmSEvcij1RMAppSgkXsomjoqmNxyiDsx/Czg2kRyC22gO9vwQqkT
 Uf/mb5otj++jYRqhZyvV7MclKnpF4WwzdBXRBa/WHPlSYG07T4/L1hGfsvls07EILfhNwIL+RPM
 /BUWIYNe0zfbRm2xmCJtmf70uzw8rin45jOPKTrMJnSO5HNsOg5RraEPuEddueRGcFbej7oVsGa
 ElSq0O8joGSLsQKHwmLLyGg9FmyG1OrfkGdzcGW3WxAYqAyYGWiz4IP75vvmPP6Rah9aJVV182n
 x6nLwVmRbj/a+snxdIZyIHA9DirbuUWpqoDun3Yhi8UNTJK4/AsV2qWTaiFV/iPMkKc1Q5W5uej
 2p4P77moT4hVppn+wdj8WyzOnCAozcG9fsb7yyo9f///qd584AZtQy3UuZoQdGlH5BMZEBDRVqr
 UsfF9FOpTq8wcoxRwm+rG0j6Zz5DwVaGlApq2J6uGGvSEXcNBgjYPPJATtkjx6DiPzUM9szzMxC
 PRu8c4ZcRcemfjr/JMdUW03WNHm/BNiHcLF2SLd0Kh87tiUTRC4cq1hT7OF99/ZU2Fshy+5NK6G
 Brszu+Qp0v/qKUnyO4BlTlEZBbGUIYaN2H2+DwVoaNGBQQ5RPl6WhcYO4E244k9qEQzG2Etk5E2
 j0z9HYEHrL6J6qg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ADFB64000B
X-Stat-Signature: hnurxos645njd5dxej9ekqkw84h3dck8
X-Rspam-User: 
X-HE-Tag: 1753349093-923306
X-HE-Meta: U2FsdGVkX18lkn2ihb4mKvPGr4G/hA398D/fP75HfkF8ac1jF4re5opQDD4cxRuALC7fbPamzZmdF2WWAx6zvTV70KaJN98tHOF8m7fgiLMMjYfIFXJngEoy6dtyhROKjmDlFY2DoklnWjZVqVR9GbNQ7w0fRIbS7Kswf9ras0X312LfjzVI4mpSN2XffdosDXyJRlVV2q4cWtuyC0NduI81y3DzsB64wxRSc6+lERjZU/3L1ElmKfdO3iPSl3TQNRr2D+GJYBBqX1tRzexzjA+W2mC+QYK39vDLYDKqGvYiBxwqwz/pEtIEfu1Uj+blW+58ljOIck3crQejbN9i7LU1mTrs6Y8Ymt1x1ejq9qGH7N+DRNW1lu3+RKyg5R2Qa8xN8+TO0Ou3Te4SM23/UALHecJZdfPyTCkdghpUuKgbEX4G1FMsjZZAkrlfB0jsLQlQxBUC/PjpHW11dSdyIJQm7L/nfZB1/s/x3g/cFDvI8LpqYRWB2DBkGEjNVrlCLjM07FNr2XVBXUGEKMAqBFBQ+uC2O/F3BWlSem6wsrm1xCPqzDh5hkHlv4tpRfpywOnbuNcKrznCgcXU2lVphP8vfNWr/rR0IdvLsnHAmenmQOxxoRn0tkTArCHA0nt2BKgQjY9kF1QhFmE2gi9PArFH6yoDpK5n64JbEyr134zFhRX9GuaYEa9ap9yL4Cxc87Kykj/XKU45TC1KCmnsaAafDT5oUjOs0YCOgfFFhdUcJy/I3oUSQyURVRyu5UtdVXBaMZ405t3biDIKLUgRHuyPLj5XN7jxGyTr9ZxH8Zns5RTj6D/tYez8Gf54Iia5T3hJtr00rHPYNAtQulR11evrmXIMspcBkotoyjtaOyKNl5TfKVjdPO1AxAvbC4xcIb1ZJAESt2p4rPtc2NaLLv4X2rhXaKdKGcbeKV5xauQAOqHJIc+IagfgLtqi6VU0FVlzP8gL5ens5y7gFFg
 gf0nRx5o
 DjtvhZdDxBUcZ+Lc6GXwdyl0clJYmeQpvn//au9tuFSWlVVCpIctmmj4RdLSokr9TISllldPzF6qG84NojGw1D4piwAG1GWFGL7M0WuGhVAQ/qgDjW38F11M+3aRoibl6hJRUmuLX/WOeHgBHNl65/8tGMjRbC3FJVq0SWYlIyEUnemKoF9ji9nosqyqBLdfmQudLJxSOjKQEhD/QBffdd/8YYtodkg1hd0Daka7PCxEvvQNjn2fvF8YHLG8yO1HLFahWFvBG0cq2UBYF4QlOH5SuUW7hmNB5X8dysi6PVY8AzjWeSjlQDRQPy04Iv5da6guHx6t5HlYLZTNbwC/9h8yN3V4r6QteeYft/wafCrTYJl5if1GQnMClUiPGTCwbPzsFne6IQ+CATUPxQjMqMzMO8HHqXzkzU5a/V3wRaCcBInCc4sP/10X/etmN+g1ol2G4EYE8g0EnGuXupHrImxgNdo9tECJ6lLmdKA29tCeQj6LdIkBUw++YwsX7P7SGDSv679Ziqqgf5VV5o5gzVX5cXrF+ZbFfSP5J
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
index b4c7b3ef79e0a34111f46f23adfee4c269e5be6e..060d64ff3d9f01ecd3374935af66b55c38f60d67 100644
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


