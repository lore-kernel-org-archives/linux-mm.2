Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E71CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E515E900237; Fri, 15 Aug 2025 05:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9F48E0002; Fri, 15 Aug 2025 05:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE9C900237; Fri, 15 Aug 2025 05:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F50B8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 614225BB73
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:33 +0000 (UTC)
X-FDA: 83778418626.29.CCD0E92
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 57DCD10000A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=GMAUQzKJ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sg6yGo5rWgbm4nmbYQkhIExx2oT2rNxy+gO58coC/aU=;
	b=mtzrcWyEVDgvDrsFo82QQABljyu1eW+1Ppm9rQcKcWyboC4hscATY631SFkcy+4QI7Bc7o
	Yrw+EZ93OILs3WRWtOR4MfGZJNTjEoL1zjN/kd3Z5KGwO2LPO/dUF9f1dbtXRXZRtLb/Jp
	NYxLb7S0htCbwT/PvYMpjpqT1ykDEns=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=GMAUQzKJ;
	spf=none (imf14.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.44) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248971; a=rsa-sha256;
	cv=none;
	b=pKD2k65sqCRzTLqot/6222tO6l76QhmyOdgnTJZ3sV3NU1c9vhYxPg3UyqKyOVpnq9e3DV
	dkZPEuLhedBDFBAS31ioOIDihHTW3f49icdYT7MqpIVtq7hLpqBdwsi+qBK6+Ow8JeN7nH
	EVIyssjquuDbKSI9x9eTiARLZzRtOVQ=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a1b098f43so11390505e9.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248970; x=1755853770; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sg6yGo5rWgbm4nmbYQkhIExx2oT2rNxy+gO58coC/aU=;
        b=GMAUQzKJi515V07vOlY+8c/EFbP5GByrlpeFViwX1Yik+FJmmkYIqDLt5KhJ/FZ6sX
         DQXWd+4TfAF7nUxL5LXtxXOe+GglYZJTjcxvr88Nvus3qmtSQxIDnw090EyLEn+LyylN
         jJesZHt04fVIuhoZBgCBckXaZNzw2WY2iTNC0JMkTpWYjuXCF7PDAhDZ9hjxfDG8/k0f
         CUj1yxa/AOcYxBM0b/lSVute54aKDnff138QcKRe3ocP6Z9bjHG6m+6fXW+Hmzjh9X8x
         eKZVaNIh4+3hdys/hZahtkAm2t0a/OLmgMvMTs7pYYFiBWvqMhGOx4MLxpuZjCM57feL
         ZBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248970; x=1755853770;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sg6yGo5rWgbm4nmbYQkhIExx2oT2rNxy+gO58coC/aU=;
        b=YHqvaZOsC/9YOQdBpTkMxlUisNiZmgEGXjED67muGrw16QKjpeZveQ0pCnlEv/Fv89
         QT4WfWLO1Z2Q6ErxOG6FjU4hcFabUa/9nLenYEB9c0k6TJHoPSQSghyoSlaO1PGzmuG8
         ujZnAxgYgsuD5CNGFpzkpnjRFQgdCRDBH6rtpooHbdwkNcou27JmgXqVnZjoJU85pei3
         hYSSuzOIwA2Jw+FOw4PmvzRxOeU6no78yAsOb64QEApgZ5Rm8XSWolvtR0KdHi2Df1Df
         Mc0RlDpiPyRDybTM6jeEjqg9YaWc3emzweIA+niWzPEJ1xjboj6VPE1mo4oQAhE1d6tt
         ieWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgDkBWORAAK9nGCzBgTm8Fp/qRyiu0dY/rwXKLbF+rcrreaRZBDCyW9imjyLwsPSfVNTDjrLWKhA==@kvack.org
X-Gm-Message-State: AOJu0YxwVjmP1gCXLdYnPeDbItMUcsKeR9ZACxeO4AfHg2CLLHysGBOX
	9K5FmLqFDSXTbsXLzVSv2ftLQH9iB85lD0kUoh0TnBxshGtGr+vLTa0iA+OHBidh6Uc=
X-Gm-Gg: ASbGncv3XZju5B/+ddTdftStWJZoq5s7ak9KQ0uBE6T1V6BtexHssKic7z6odUesFBn
	fYL8Ugf2Exvkb6Dv1drcQxl0nXLKPz5C7Ml7Zkkki82YTcWnc95g9OwrRh+jASoq4ggAjXme9zB
	5Z9mMfUlqTKEtvmbTM+g4o2Lr2kYKVbQIstwSxVjWDY3EpOOMpZG1RlYtJhefZty73AKIvuHXlv
	3PFOM9jihXfjYuLkzCtpNYaX3WrWHyQc379bL2kCqZEivQWIefkEbGrur3ai3l46+JebvrKZ/7v
	YlHFgMsv6X7ZfCo8txY/95K+XVZa7YtZBKRJcqSIBNW4XuVDddOBlA8g/WCSqKZugtUhppIikI2
	0HWWzQH8AosZI2TebDw==
X-Google-Smtp-Source: AGHT+IEuSRLd3B0h4SE3RR2S2yHycoqFTSLj7jDNuZgFZPq4txV7qE0+ov1t4k8bQpePbvf3meSvDg==
X-Received: by 2002:a05:600c:5286:b0:459:db80:c2ce with SMTP id 5b1f17b1804b1-45a21e7f2e8mr9560235e9.7.1755248969664;
        Fri, 15 Aug 2025 02:09:29 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:29 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:10 +0200
Subject: [PATCH v5 08/15] pinctrl: keembay: use a dedicated structure for
 the pinfunction description
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-8-955de9fd91db@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2974;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=HD9TOJpRmpG6enieox3SLEnzfmanpdaE65mOB6T5MYc=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk4AelBkHWJWZSjBIznNV8JlLBDYLHWXKinX
 +GiHJ5uogmJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75OAAKCRARpy6gFHHX
 codHEACM4UcW4XmQxoTdvJG0sbAVF+QyQHCaGbqkMyiyny6aH7RK2tq8Xl6yZSAoDRX9DIkdLsV
 cjvfs0JZcnSCGBsxTN0eEICrrspOHQJRa0Wz7f9MKd9Mfp7PkVGQBphWEZafv185lvBfoQYn10/
 KMtkOfMe5hOMHj/bH0r2Pc+DV6X5sEMdx/LSX4oRC8+cpTqF3s+mMLqSOrQN1alY6PnM/461gt2
 eI0f1lIQyiWLUH6ciwIJP9DWMIWGmXQP+TPp+em65RkBCAYoqFmoeyXOlz2RCO8St5K6+fuqAFp
 5nFyEPiGfSr/wntSpNNNoZNz0fVOdELEgqJ0275bDqBW5cek9dhFtaO6MFMvPn1FGP7wpac46ie
 ZX0acGHA+eBIISkExKYmPTBWlX4UNY3tLCaHgedPbnTVe/8blQMS+jtcmlT8N0vTDcLPocFUqVm
 m98XIN8qONHj6xwZHnc05CyexQgealE1ZYeYBYHkpC/2FWyUzIpZ0dnN2HiEpj8H2J0+PoZ1l8A
 ZguDBgwMeJJF1j0ZYFn4ZZKDu8zgJoZeGsNcp1BnOb0+ALnGFfMwsfTeOg4e6NiqXThqwizkUXp
 0ln7J9lak+xaWe5YElclyG7HeWIY7RLTvgOSJd+mhwsTItLmpI417ypQDquLMvaUrdEKVlQwWyM
 1H1INlqKY1Feo3g==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: fejjx9x6jtm3yqyfy3m6zjefe8azopsh
X-Rspam-User: 
X-Rspamd-Queue-Id: 57DCD10000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1755248971-572641
X-HE-Meta: U2FsdGVkX1+JqjDmisBW16jNOG3VYAVNezhzafDNwFF4D4GD09H6OHGphJC3VUQiCKwzFCvwRB46NoBfIN+4/x8L5toSnq1ASw3dHFegxGsVxaftCMrufXxO0j6XD4MhVsEnZqmxwIIC+iDEf2+WiUGXBQgFrxddtIHmGBG5HeFidW/eDKdOvFeA6F1yZ0W+hEnz8onMCB2ZFFYcUqaEXv/M05PgpW9DhNq48RaMD4KAeGV11ww8lVriguYee+dMtV5RAhvHXySFFP3l4o+xEAZKqiNF5hHwdsv38yVkPawjiU0aDORFYDDZ9JQudkVVhQR2gq77nBYBnrLM5d07A1LPJzCWuA8ktFZBx7RHYjM9fFetZdLZYD639loWXI6iMIB720UQgj6wIUg3X2Bi8SMGZjiEO0U53/x1ojq7EQGS3ZjTXuIQ0GZ9jEX16PbHANfKLUX5OJlNfhFiuM6m+IZ+icwNWiQaD9rQMtlCHrmiqtrskcVC4xKYeF5/QaxS/9aO+kvJgklDrPu00ok6ywCQ1KhYqSc2Y93W//BETqDx5+x3T/NxvOWvtpnS7vgYc8QMpzfl6RVC9yNO0jb37b6zToQVKJpqPw5WjHxlVJdBK8L2SILs5WNNT2JHjhJcNOKAz6jsHnsotNxbzxqK5MybnbiYuqGKuqaS5yrQ01dnULm61tFIxZ/IY3YJKgjRu7YhFZX3e9ofGvDT7XDPqYilQG62VyT0VUshDTY8XkRlBDMV0Ad6JtJA+RnqyovLFVPfnBchFI9Ba3RQt9tvA2313uckDeGCsHqsX589oRccfcOxKyvmunLHEQs+QcXkCn7hm886ZUDeS6Ko4Hz3vb4XbRCCMaTl6RAFvoeuMOCMFlLRN9jpPeOADvtJxIgydQRyupgDdxQI2piXhDJrykipjY+C361Ljz2gWlqA16LjHarNM3IxScNPAx2ZwTy/w43SD7t0vsWAPoJl2xD
 t6P77qE8
 YbZwh4QM/G80DGUMlDt1EuQsphqDS0TidCSmyRK7nrlkukETr/jZC8Bqd1JuDV90kKKyUAZNL97Bza7JyFkBhJuq1XTV23oi/ffPpAhJ/OYWb4bOGsYmjXVSTMuhCe3tJJN2CJ7VJbOI7HLiQ2Imi5rr1CPVoVaIjqc/06gp1uoOb4f+P8p8GF9iND/g9sJU6HwqKJNI8BTXKVP9EeXztC6BslPTKLuH1Ioe/K1JzaG2/RGpNOtc9e/mNk4JWbw1RvYhUcgdHQRBiA3gd7wxI0bNIVYgRDPYGYAAzow5REiuELd9i6+F5ZJejA9vi8hkXHWZL0V+SqXtKG73zVBibpawCZKxvEIm+mS/NRdn5ABs97gQc6a2jXWsI1laNC5ksDqArc0T53HnHO3WvYFq4h/ktfoHXDBXppA/PtpJHSdX4hYZ0k/z27hf6rqHZfTmglc4n1923ivMLQ3aKENNGQWRGUN880+N6VpCURlsiLgvzE9fLcmjV4owXRYoqQIGJmw2rR50wljP3r4XgGb4aMtCKzsmDZqFBZamd
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


