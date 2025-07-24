Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5F5C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8688D8E005E; Thu, 24 Jul 2025 05:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8406D8E0051; Thu, 24 Jul 2025 05:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708668E005E; Thu, 24 Jul 2025 05:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6618E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:24:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C301C11257C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:50 +0000 (UTC)
X-FDA: 83698623540.09.CC8C74A
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id BE4CA16000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="EY839Sr/"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJUZjVtlIKo3B1UMbkxv5VOoofbThhtZUIOmMWEwvGI=;
	b=bCZLXDJM5DAZZ2yO+1vPen7J6Yjoro8w/EHhgIRmz72hcpqHXRWq2rI+n5nQTsZYGyiyht
	DqZsuG85p5j1L0e5ZPgemb27wY1TcM+t9J8yriMHLbs9I5wk1Q0zuMKe8GtmVVo51+XtJh
	JcMjggVbihSp/FJy3HBmoxSbiO4c9UQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349088; a=rsa-sha256;
	cv=none;
	b=uD3cTpIryDZuSlSI39N2nrHE4fDAvkpBg+yc8efXBCZO7vGjgQQKs7vsnD/9VoErJRrWKH
	n8O6p5T06otESbRHd+vQ0R2LGk013I8rNeer6LEpGsdMX5xN33nzsHFD5uK2KM6W+q7tFk
	Ofqf4TpYTFpNWbDj0CLKivyZMghIHjY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="EY839Sr/";
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.54) smtp.mailfrom=brgl@bgdev.pl
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ab112dea41so424486f8f.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349087; x=1753953887; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nJUZjVtlIKo3B1UMbkxv5VOoofbThhtZUIOmMWEwvGI=;
        b=EY839Sr/HQ+am1bLc2D2YlY79AGEcSXP0tLdKo3AdgMGppJ1Oq2sCCkGCatRtmeu84
         g5O0/y2EBTAh2eHvDexrv/hqjlsZB3MVm3wm6dbtYgq0fu9LY9qYoITiLP2lLcapPfZr
         WAw/n9kfINqQ0HkMDU8lYKMoKe09EV0xzZj06GSb/n842CA+u66RDfXe0mYxMJX7O/pT
         8AoEjfG0L3uCBrQFsCJL8J9aX/ZuInwUXJWWHmpKSviwlhA0ctLwcHITZtStMgQAciG5
         8GruEZcQgAz39jSxYmXJFNUujGuqfc0apf0nJQJjGn26jp3UB97cyigazAvf7AWcMGLJ
         LzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349087; x=1753953887;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nJUZjVtlIKo3B1UMbkxv5VOoofbThhtZUIOmMWEwvGI=;
        b=V408IY2AgaQZOzJtemQh0p+7ezWNfucTB+BnKzQPfl4TzFwukaolGosiqb0pJaNGOj
         fYyUqJga9UXQS29MYUugBvUQhUOuAnVIE2nB/DIVYQEbhljC3W7qGn9g1+dVPPDUA0ZC
         elHkxwmUsEJ/zgj8/369WAwrBcBhqxh9nNhbUPAMJQOTLa1eS2O2MwXQB4AM9OLSL2hG
         aWT76zCwiBFWedO6lGhLNnGfIFYR7ghzFa0y8t54X6dp9JECbgBQfHLQO55xnvEZLXG8
         Eh4rOsSDjzWgAkF8Y4c6TQmSgK7YATDQ4QGARmM6Opb6UP+iRQxijn9+gLT0tyqapjRz
         MldA==
X-Forwarded-Encrypted: i=1; AJvYcCVu8b5n4Wurh2ug3/ing2AzUSurzj4UeRpmqg+NtwGc+Q6MdBE8jCFo5VYtgqWjroLxHAZJqqDg8Q==@kvack.org
X-Gm-Message-State: AOJu0YxMWwy/N0MzAfKMLNSuJ2euQ1ETnbc1MTsVMOTjwwQTpUC0daD/
	dTG5sXZjqimDZdVjtM9ljyMegwRrvIEbvX60eW2r/PdUPgjTIo7yBI1dA4dNks4mUrk=
X-Gm-Gg: ASbGncsOiz8+mgQkRv4eRbYcf4HNJ9mDE4M+9xWubATfWwDfIThJ7omTvE+QBmDi4uM
	I3YwwanmIyMb3ZhiqYMuwhEF3h7fYaBhgPCBi2+aE3ToRZsiCMTtHjYMgvWwxoP0yu2TQxsaE2E
	ppsIras08qCwjK+LtWAIU01hRyTB47mgqoC+7iwS6xmLdILTQBJ8zJlCyPAIeWsIZllXwH+dVGY
	D2gw2BcKiIvDmp+sAx8NlzV/iUwcujG+2iTI9ju2T1d+vJRudyscEaD/92iqeyqMh6KR2midWpM
	uPyyLPQbbGSvfwoG7mRH1k924Pur53FLelebWa/om64W6LOYF3pbFhii1R/0kSC0uqXWqzvgtHU
	wYcc/nP17tKC67eje
X-Google-Smtp-Source: AGHT+IE53C3ZwxTWCy0TzW8WAToX0t33JVkFXudIOsDbWzszG6HPyeb+GkOh17Tazek3rt5YOgN4yQ==
X-Received: by 2002:a05:6000:4383:b0:3b6:489:b7e5 with SMTP id ffacd0b85a97d-3b768f08603mr5368799f8f.49.1753349087190;
        Thu, 24 Jul 2025 02:24:47 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:46 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:33 +0200
Subject: [PATCH v3 05/15] pinctrl: mediatek: moore: replace struct
 function_desc with struct pinfunction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-5-af4db9302de4@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7802;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=EZIgErVhj1wZDlH4X45aC1xxqNkDVTV7tJ4bBOmmtzQ=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvSz4bpJOIdhBRRBcwsNvnV8byaB772P3NJR
 kA8YJBCg/KJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70gAKCRARpy6gFHHX
 cphgD/99gJP6Lz0s0LogT9JdKXnCkyd9BGI3EtfctM6MCJmzcnGoMMSl45mG8ptut3lqE+5eB6t
 0nfTGTib9DlX0avALjMU/KZiJ6JPZZ6KTiG6O1Gh1n/aviWSVZGWBFF0FXk4on8WqByC9oVOZjD
 7+mbUkam6YkYGNEF9Tljh1u/bkZcmLrgE5BNT9oslhICDyx/v99UeOhmHaeSmH1+YolGrITU2C5
 oxcqurNGAUU65VMgdOmjPEnV7kmjXl9Y8xHDvaNvGbJtPcDnC2fYFWcBMA3D3kvPh0brC1/6LL5
 bwn5iEm6swUujo4AwWA/3c8OGjMi6krzuUDtQVzRqEAPBJPfzdkme42uTWAd5VWmYR0aPr7g+2C
 99hJiIxKvhfPD+lAn5qvB64TKqbTLnup55g/1/jrPjYvvSBdUspBFlnoi8I2lvZhgt8zVldfcis
 zhUE0iUwdaGJbBtPfcgV5XnLAKo3k+0R2RrFCokDrTY0wOPLAV5wBF0o3rRtLNFyNnN0T+vzMFb
 uqttmd9IOAtQj6pg2xfR81T0tdaGWtYvxBNIv4aO4Tl+5YIAkTKlrPejYd7tyiFvYyDpC8RC6mJ
 53bY/6mZv7o5xkrj99RzPOID+42ZQTahW1gpyvO7aG84OGMR3FL9I4cwD4Fvl5tNMpT8B4GTJkz
 gSizp8RmgX6w/NA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: BE4CA16000B
X-Stat-Signature: t7uh85om9e891r5enb4gmio9ywj93xgc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753349088-350307
X-HE-Meta: U2FsdGVkX1+hN5or+mnchWwTXJsB+WfMfyxGxmrEUyAT+Fj9eusFa2fM/qRROF8vBRnuUsxORI6H/ZiLjIdzPHWuk7WvzLeDldWw2mnmilxDjkqigd21YKG+jblkRNbaS6XV4lnSg74/8AsSjwe13pnWpPPS/PqOfTqwj2Z7PdXxeP1Axg2bmfkmBOYfXFqrVTewoED5rnpVgXZxghIXaiIHdv3ydwysZ+vqc9cgMUL1Z62zYzTcbR+v9wB/FH5SkdAxpPqKaIPXFerCeubHLkzEJVZYayWelSjaDw/VgwiLLY+XFifXq8NdSMxwpKJ645U5P8nR0CmpQVh934xnEhhWqJTNN0kdBuwFsgbPfDpAlK0bzg7we9cEHIZRmBOCSV/qe62g12oSEuTNGSlxFt/bz5KeBJgmgldWebo3wOVBfgHC4AIQgZebzFHbx4EXK07qCtJsYc70tOC/NsKPPlUHpb324+2OKlFVjUeqmrV2kEyDapZtWbO2M94MnmZ0Iaos9a4iIUCrAb+oFcgkg96Tvw0q25XFft1JsHKCX+4GMsbNO4dWT31W61UsF8LT6gOeTO7ThQMmBZ9JJ0hlYeuO6cEI3660Rjmxuk3R/lwjInxII0EEZbCgcxDcHA73hDnV2dEZGsZgdFANQ3WQ5TOvw9GbELA4AtP6a+I24regJG06vCZdGzqXRTipvirrcHAhozvN0i9cTwNCwiF00/BzXcJc5jUvce7rYRmBelN+mnPS3i4JrxSRDL9+alODM/Dmq1Jkh1Fsdf9+VwkgK1PISvgdIq0aao6enHTC40SNVT0TlCHBmlbc2WYhpx9XOTRZA4MYzis9VKOKdjLtOHFBtWvkSjVPmJkkMGC3pcMlT03cAsO87+Jt67EgAt+RDWsXGqYMx6klUbVvtOxxguJm5vg+FqcA2aRC94rUgH4TFksoBtYdp/39Hmvb1+Mi4FwkeFaBQxFg8kSBknm
 JtJsDFx2
 Nj+PlFiLbUZUkeJxCqodwY4n/NRlQ0g8lVrCbZ3qRLbGF3PxWwl+cM/LIAk3PX/o1s0dOTnvroMX1GILHEqKM2IQI/G7u2tMmWnNBDkupwCm0FmNsx2rKJR7RsTSIv0ukrgXe3FrGdsoLdcck5Zp/uzH7+ZnSqxpOf5JNQ4n0SEnmBDsYsG2RGmh9F+WFwEbQkQ+HYrhhMFfGf9YPddHoUJgl+TOhfROvqj17WuxTN18lhD9dFNuW5aiU4yUfX0O4qeEh1+quhWwaC8ldbU4NZ8Wb3vEpBaJ7e3CGk3O/OrIONPSKeCV/mdkVECmN2LoOzjp6nHhphbMyovSGg68sP9JZbXm+BTyBNeo0j3FI7u+5wjUBjWQCbhgoeUhAfOoihPY1mPreLBgu6uKj4yOM5VssoFYz01V/sMOB/Wwmndgp5LmbwymTfJgLmS43c0AS4BRfRa+bW9X6NBe5c9Xfgy2VCyoPTo1pKbWqlQ+FcpKG+mTAsBDFFPjzKpDUMKDVzJ32s0+2OIUY5SPeDeHzNopCscY4LK+TiKOFNgl6pEkvnvk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

struct function_desc is a wrapper around struct pinfunction with an
additional void *data pointer. This driver doesn't use the data pointer.
We're also working towards reducing the usage of struct function_desc in
pinctrl drivers - they should only be created by pinmux core and
accessed by drivers using pinmux_generic_get_function(). Replace the
struct function_desc objects in this driver with smaller struct
pinfunction instances.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/mediatek/pinctrl-moore.c         | 6 ++----
 drivers/pinctrl/mediatek/pinctrl-moore.h         | 7 ++-----
 drivers/pinctrl/mediatek/pinctrl-mt7622.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7623.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7629.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7981.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7986.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7988.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h | 2 +-
 9 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.c b/drivers/pinctrl/mediatek/pinctrl-moore.c
index ba0d6f880c6e1624720f0ed8e7b36e4734dda004..68710dab2aa3ff649bb0cf579122ecaa0c257fdf 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -622,11 +622,9 @@ static int mtk_build_functions(struct mtk_pinctrl *hw)
 	int i, err;
 
 	for (i = 0; i < hw->soc->nfuncs ; i++) {
-		const struct function_desc *function = hw->soc->funcs + i;
-		const struct pinfunction *func = &function->func;
+		const struct pinfunction *func = hw->soc->funcs + i;
 
-		err = pinmux_generic_add_pinfunction(hw->pctrl, func,
-						     function->data);
+		err = pinmux_generic_add_pinfunction(hw->pctrl, func, NULL);
 		if (err < 0) {
 			dev_err(hw->dev, "Failed to register function %s\n",
 				func->name);
diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.h b/drivers/pinctrl/mediatek/pinctrl-moore.h
index 229d19561e229c77714e5fccb3d4fb68eacc77fd..fe1f087cacd0446e40628cb4fa35a135496ca848 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.h
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.h
@@ -43,11 +43,8 @@
 		.data = id##_funcs,							\
 	}
 
-#define PINCTRL_PIN_FUNCTION(_name_, id)							\
-	{											\
-		.func = PINCTRL_PINFUNCTION(_name_, id##_groups, ARRAY_SIZE(id##_groups)),	\
-		.data = NULL,									\
-	}
+#define PINCTRL_PIN_FUNCTION(_name_, id)						\
+	PINCTRL_PINFUNCTION(_name_, id##_groups, ARRAY_SIZE(id##_groups))
 
 int mtk_moore_pinctrl_probe(struct platform_device *pdev,
 			    const struct mtk_pin_soc *soc);
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7622.c b/drivers/pinctrl/mediatek/pinctrl-mt7622.c
index 2dc1019910662a2a52e81f277a10a32bd83b33d4..d5777889448aab86e82fa6821fdea0d30a5a7246 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7622.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7622.c
@@ -822,7 +822,7 @@ static const char *mt7622_uart_groups[] = { "uart0_0_tx_rx",
 					    "uart4_2_rts_cts",};
 static const char *mt7622_wdt_groups[] = { "watchdog", };
 
-static const struct function_desc mt7622_functions[] = {
+static const struct pinfunction mt7622_functions[] = {
 	PINCTRL_PIN_FUNCTION("antsel", mt7622_antsel),
 	PINCTRL_PIN_FUNCTION("emmc", mt7622_emmc),
 	PINCTRL_PIN_FUNCTION("eth", mt7622_ethernet),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7623.c b/drivers/pinctrl/mediatek/pinctrl-mt7623.c
index 3e59eada2825277b3d7500cb1f2cf740242a4a8b..69c06c2c0e21e4ce785f65539254eb070bff9a0d 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7623.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7623.c
@@ -1340,7 +1340,7 @@ static const char *mt7623_uart_groups[] = { "uart0_0_txd_rxd",
 					    "uart3_rts_cts", };
 static const char *mt7623_wdt_groups[] = { "watchdog_0", "watchdog_1", };
 
-static const struct function_desc mt7623_functions[] = {
+static const struct pinfunction mt7623_functions[] = {
 	PINCTRL_PIN_FUNCTION("audck", mt7623_aud_clk),
 	PINCTRL_PIN_FUNCTION("disp", mt7623_disp_pwm),
 	PINCTRL_PIN_FUNCTION("eth", mt7623_ethernet),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7629.c b/drivers/pinctrl/mediatek/pinctrl-mt7629.c
index 98142e8c98011d17339da74f61d6f917372dfcd5..cc0694881ac9dc536db0e46eefe5eb7359735a60 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7629.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7629.c
@@ -384,7 +384,7 @@ static const char *mt7629_wdt_groups[] = { "watchdog", };
 static const char *mt7629_wifi_groups[] = { "wf0_5g", "wf0_2g", };
 static const char *mt7629_flash_groups[] = { "snfi", "spi_nor" };
 
-static const struct function_desc mt7629_functions[] = {
+static const struct pinfunction mt7629_functions[] = {
 	PINCTRL_PIN_FUNCTION("eth", mt7629_ethernet),
 	PINCTRL_PIN_FUNCTION("i2c", mt7629_i2c),
 	PINCTRL_PIN_FUNCTION("led", mt7629_led),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7981.c b/drivers/pinctrl/mediatek/pinctrl-mt7981.c
index 83092be5b614cc164590fe5ec2b756fe6579b263..6216c2e057f6499b32741b6bd3a4854878c061c9 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7981.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7981.c
@@ -977,7 +977,7 @@ static const char *mt7981_ethernet_groups[] = { "smi_mdc_mdio", "gbe_ext_mdc_mdi
 	"wf0_mode1", "wf0_mode3", "mt7531_int", };
 static const char *mt7981_ant_groups[] = { "ant_sel", };
 
-static const struct function_desc mt7981_functions[] = {
+static const struct pinfunction mt7981_functions[] = {
 	PINCTRL_PIN_FUNCTION("wa_aice", mt7981_wa_aice),
 	PINCTRL_PIN_FUNCTION("dfd", mt7981_dfd),
 	PINCTRL_PIN_FUNCTION("jtag", mt7981_jtag),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7986.c b/drivers/pinctrl/mediatek/pinctrl-mt7986.c
index 5816b5fdb7ca918486f57a890f73543b3198c728..2a762ade9c35505505c932b6fea75fa0cf77d961 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7986.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7986.c
@@ -878,7 +878,7 @@ static const char *mt7986_uart_groups[] = {
 static const char *mt7986_wdt_groups[] = { "watchdog", };
 static const char *mt7986_wf_groups[] = { "wf_2g", "wf_5g", "wf_dbdc", };
 
-static const struct function_desc mt7986_functions[] = {
+static const struct pinfunction mt7986_functions[] = {
 	PINCTRL_PIN_FUNCTION("audio", mt7986_audio),
 	PINCTRL_PIN_FUNCTION("emmc", mt7986_emmc),
 	PINCTRL_PIN_FUNCTION("eth", mt7986_ethernet),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7988.c b/drivers/pinctrl/mediatek/pinctrl-mt7988.c
index 55c8674d8d66f12d2f2246c215056d4e51296a9b..9569e8c0cec15fb6a4a8e359d6483fa163487b0c 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7988.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7988.c
@@ -1464,7 +1464,7 @@ static const char * const mt7988_usb_groups[] = {
 	"drv_vbus_p1",
 };
 
-static const struct function_desc mt7988_functions[] = {
+static const struct pinfunction mt7988_functions[] = {
 	PINCTRL_PIN_FUNCTION("audio", mt7988_audio),
 	PINCTRL_PIN_FUNCTION("jtag", mt7988_jtag),
 	PINCTRL_PIN_FUNCTION("int_usxgmii", mt7988_int_usxgmii),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
index 36d2898037dd041ebc7e06526ebc085eb42f2828..fa7c0ed49346486ba32ec615aa2b3483217f5077 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
@@ -238,7 +238,7 @@ struct mtk_pin_soc {
 	unsigned int			npins;
 	const struct group_desc		*grps;
 	unsigned int			ngrps;
-	const struct function_desc	*funcs;
+	const struct pinfunction	*funcs;
 	unsigned int			nfuncs;
 	const struct mtk_eint_regs	*eint_regs;
 	const struct mtk_eint_hw	*eint_hw;

-- 
2.48.1


