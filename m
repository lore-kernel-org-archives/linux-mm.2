Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AA3C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49E0F8E0060; Thu, 24 Jul 2025 05:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420E18E0051; Thu, 24 Jul 2025 05:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBEF8E0060; Thu, 24 Jul 2025 05:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 199318E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:24:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA8EDB8394
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:54 +0000 (UTC)
X-FDA: 83698623708.07.EB352C8
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id CE7B88000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=xlaWJxo0
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/MsMdfp1xLANBZ9zZyNzSawqjnpLS694AVKVdRY29N0=;
	b=v79e7oiDXF1VDl3BynrkK8QfgqXek/CmlVPX1/RBI9fC85G02CNQc+cRzmaG6w9REVMJk7
	QLN3DVCsavls1BWJxSb5/u4Yb9gSHIFml7o+OxRor7rzQ5I0Z84h0j6O7i9gnV1uOu2AK3
	T0s2f1O+TCP0h3Jk7ZGpW2KcC4/ZngY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349092; a=rsa-sha256;
	cv=none;
	b=qNI/7CGUNtdCsE/JgWmiTblcwoSJsQJwm7TR4e2fOdI7WGX3YyR/xx0K/q3Ce82bqxVFZG
	C2ijw/LRRdjAuUnzokn6emYEOVbLPJJQJsLT/4vwy4DtqbDrezV/NoZkdRNpKfET6RBgwD
	dkT5Q+M8/IUrfEJcv0Hqp+l4J/QM1Nc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=xlaWJxo0;
	spf=none (imf02.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.45) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4560d176f97so7991265e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349091; x=1753953891; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/MsMdfp1xLANBZ9zZyNzSawqjnpLS694AVKVdRY29N0=;
        b=xlaWJxo0boTTDke4tZVCjq5UPKCReOGqVbryyBMjtpo0LYKrHDR3gXnCoP9798c2qu
         cMpINla8EPQjiuILu1Jrv99MR/vo47SSAm0kt1NCJ2lTLr6YOmvr/pL8+POYs3W9HsOW
         5n7+3UXwB5+RSWst3k7taGv/D2hXUdGQtTKIKNNhHE9jdj4pj29PNWtPkf+4Mtp5OGtG
         NxK0S7Vt9a9NZ7O9VciSvuOdCRu6GAMVrNFkD8g2qFheqpEz3QmYsPPlRzvE74wYb/HG
         PoNLy53hlrEikrgGadP/HrcF91CaHmbA6ZcEIBvT2icOzchg7k4XwrMTozww583/9ISx
         tIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349091; x=1753953891;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/MsMdfp1xLANBZ9zZyNzSawqjnpLS694AVKVdRY29N0=;
        b=oZQ58yVlIwG9OQ02KAncizS5HekxTO/KkvXA05BdGPcEilVIc+byVy/umaAG7Mkgu7
         GVx2NeCEFtqAJ5tdIJymajSo+r3XYInV0QGKEUKyh8ve5Ggz7hSzRW041hydfRR6Lwqs
         TARQON037qfsBWG7FgWFs0y27h6K43xFf+rp+iTLG9s4+5cmdvh3LrQItu83fWaqEIHD
         Fz0fBVH9kpVTqoXjThTbRdyvxo5I3IjepuKanrlm36cIIq7W+UE0LSB8z48PHMSMHkxM
         ah7PBWFXm33Hf6dU83UOPC69Rg+IT/oT3JpnIKyV9Bu35emyNUYWENPpQZdaI6WRoW+3
         4uxA==
X-Forwarded-Encrypted: i=1; AJvYcCXnB07mWtASzvz01Zg0ivHmZzE6CpL3TXe5ClEuI6MgkisY9ZNKCg2NJdYd8E9WHC38tzJAJxuIbw==@kvack.org
X-Gm-Message-State: AOJu0YxddZSRc/UYTyAfz2ratlG5ujYqzrUbeOm6UPind6dR9Rn5vK6Z
	7b34jbh/yt59AUMosZPANGUREnRwHf3t1Gsk216kTQcEB7Hcu3HyK3jI85cMbgK+CPg=
X-Gm-Gg: ASbGncs0WmzMsfUTS38+aK56hvzHxDqIsCTedPitutGnKrHeX0fUDl5cq8BSipypo4L
	r2kkS/+IJIiKvJlg3KAUTX8iwCbFMPi2bLgp9GmzsexRX95PXUSMUgYpE4cliR3iYv+kmJuhoG2
	cznEyLMzYqbte++w+plIrNUvhAQe6Y1tR9rNdo0b0IubVoPG5zbQ7AghGTLfwlkqy/EI0wmGyyB
	KoVKk8ot2cz5O2pS7qaqqu/JBOjkUOH50gFk33suIGvZneXe+CLzAmIfv3IBjdk0S9ElgYajpzo
	BgBgceOQ5M7f0P3oIVYK78RtMxsmFrhSHgQX/gDlKoKExfUb8E+Foqns4CelIZvwCPGZiK6E2ip
	5fsv0b+DrEtci/pFT
X-Google-Smtp-Source: AGHT+IHqZ4KWF33bsWYC2NW13yLlFkOEfEwZMRqVsz0fuagNkHT/q0mO1E6+Gg7Jfa3lxSFmodfKew==
X-Received: by 2002:a05:600c:35ca:b0:453:81a:2f3f with SMTP id 5b1f17b1804b1-45868d4f48bmr61519195e9.30.1753349090293;
        Thu, 24 Jul 2025 02:24:50 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:49 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:35 +0200
Subject: [PATCH v3 07/15] pinctrl: keembay: release allocated memory in
 detach path
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-7-af4db9302de4@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1780;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=LKTpseRfAo7ye04iddOGWjUFjvvauRYDbdYlMpOMyLY=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvSbjubxQ38F8ud5iCpNZ72Jm7IAoCj4lWgs
 6LniCl93ieJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70gAKCRARpy6gFHHX
 ch2CEADZjtdeLp35/fl14l9PQNJfmIbBfcUfYvyfA8t1LHfkmxLnRbErjq5eCVle+l5pe5R1BIn
 +X7gAAsSmm4v45lpL1ifrTXzAR7JcqsNbP0LtwqYSS4T7QPIPf7CtoZVhbHNjtKwLxhGF3P2JUT
 AdjounHFm3XKuKN29lK8QJ+FG0/OLUKPNc9HitRMm3XzO2nU8ilJ70+JnwJQZflutclz3OSvBxw
 WqkTLsIrsAiQB2n5Qpl5NDbIKMakIsw2cCfwyDfVPgUM9DTEbj8g9OjCakwq20up2vaVR2NwSvC
 ZUtq3k8Y6wWhqFR27KGwVPwfv8HIaqFEGGne/Tgpdz9o2yYU43x2jurLX0I7211S+r4oMERgXum
 fFMpJLG5QrteGGsb5MWK59iQtPyEgVfHlIaQ3KQbLi/DdqbqrMSorxafyVr+zb0dThp5gxoicfu
 h117nhV3u3ekRyFApUHBpQfA+qfmNBltfqn+M40vyVVFXVOa2tESEAtfwLmSloO/dbveOYt8RLI
 Bj1dwxB84ZzCL2A3uU8R8UZwWHLaGeHi7RG+LKGo5qu/P+loVUEwBcx+DPiWi1wI2VU1bscLdUr
 2Q5DBSjVjYTXTfG4AJcen4wRUeC4rTi2BsDO70f2fHyhfmt1IEfYz/A322grH6bledRd46/o8vI
 JGEI+5r6wD3CF8Q==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE7B88000D
X-Stat-Signature: e8shw5upsokp3tbiyudwnd6k8j9c671w
X-Rspam-User: 
X-HE-Tag: 1753349092-819489
X-HE-Meta: U2FsdGVkX19D+9AfN6O6cdti+JsX61AKuMKBzGHy7I4IddCPJ/uZppVObcKJtDxY9LKfx8GI8B8jOxfGE2tisr1mP1TrpkI0w0KzgCHmUluyzdyAe9p3u2xr1TE8nM8pDZywoF+3iFVXLdrmlqDzaZIsCCL3STzG87B+fODCGVba0xgT8tKe86bnZgxi04fOtbkXktI5WgTRVeZt1DsntIhc654CGbshu6Ut8clKLLfNa6eDJRR88plAPYzKJYnn8yfQQb23G7oloBOXh4CItJgg7EO/B6PjQcTg5cCFalp9PCC7muPoVw0mORH4AibSbXEidVLWMqLxIYZbB4JrckxKbcC6LLms0I+/saZctJ9kmxI51o4JIs1KW0TrQbi9U5Gd2Kvo/txiQytBUGIyFnW18r8PugIUPzc3FEjKfRn9iyMTqsEtMvFBO7B2/Ev97z9xzu2NfNwR9aLxUQFRKUGbxzVTwSHHDCZ/6dyjSv89VO0Pwi4mLXBA2GBtuP4VFUIEQfl8QMXdH/aRVR5FHDMeQDJPZjpviIdyIYCKEafEuF/GP64a6TVamgNq2EdwhJZHz4GDyYQId002fxCPDNmanbGbto5MXhILWELst9uBAqbUVX+qtW8R6J7JvXK3IkSGVbio+Hka9MoAahSadP8z4jopuoZwFpDL7Mn8D8IaYaHrhBfokyHya9IUx0PkQln6AVuBVqpnyRbPWPQ8MWhEhf5vUZWenX+PEcc1v4wubhLSjEG7l+i/h6pv/9tQ+AajZ/37f+AM2B1oOWuRmkHUbKiPeHO4SFgUrN2K1ztNyieZPqYRJDNlNhw1qe/3Y69Uk2O9XyZ/QNN3v69s48YhjxYnoncEcW0LtUq+y/D30tbnVjrUoaoKLEt3Q2SkTRxOcPTHT30tW7U6nb+DF3zRf+I2fFkTI9o1NDQRPwyrdFoQSZPZG31cohua3hxSXsP2GK+LWETSfyRRV8X
 Qomei9kr
 /rnpMPgvd3Wbg9yCKHYZ4Q57+oocbdNwO1uypzKZOjMuTbAbyCp6t4BVryXWlqPT1ru1U6uk2eECFeO0LzCQhzGHhEzArjbS65KiGfnqqBKHvBxLThQXOw7ApbXt8O4Mh23ZGiqf5dQgJlfv+NGIemzC0Pjlodo0pZM0KrxBNcyDLOb/tpSlyqVi4ecGxqpBjZMsxcGY3m4lioo2taYfrCGPhx7lMfjwmiQO+HWYsK9SmNOzSNfdOrshAahNNhfj2g4C/9YzQwgTrthc/wXCN4aQ4jI2pp+6dHeMd5gB0SbgFRbDSjaEE4yW0jTavwxo02wLuKxVSITt17BhSHb2LlujS8jH9BY3T7RnFHECxURs7Zs1iyYjuvIF3gTdtbx3PeZVTNL1rSehftlNumXRO+t9XOngkaT63OaLfZ/CVOFrhb29ABzzT982xllV2u1ieATGdM4IEmADJx+kdZaQBCUpPDQu0IiqW0tGUjE0gnx9eCgxfPIyFbXY0f2mWDDVGR+rp
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
that.

Note: the logic in this module is pretty convoluted and could probably
use some revisiting, we should probably be able to calculate the exact
amount of memory needed in advance or even skip the allocation
alltogether and just add each function to the radix tree separately.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinctrl-keembay.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-keembay.c b/drivers/pinctrl/pinctrl-keembay.c
index 30e641571cfe5396075cb28febd2d0776326365d..b4c7b3ef79e0a34111f46f23adfee4c269e5be6e 100644
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
 
@@ -1634,7 +1635,8 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 	}
 
 	/* Reallocate memory based on actual number of functions */
-	new_funcs = krealloc(keembay_funcs, kpc->nfuncs * sizeof(*new_funcs), GFP_KERNEL);
+	new_funcs = devm_krealloc(kpc->dev, keembay_funcs,
+				  kpc->nfuncs * sizeof(*new_funcs), GFP_KERNEL);
 	if (!new_funcs) {
 		kfree(keembay_funcs);
 		return -ENOMEM;

-- 
2.48.1


