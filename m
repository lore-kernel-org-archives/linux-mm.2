Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 150BCCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E94F8E0013; Tue,  2 Sep 2025 07:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A3B8E0001; Tue,  2 Sep 2025 07:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB7E8E0013; Tue,  2 Sep 2025 07:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 057778E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC47F13B8A7
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:24 +0000 (UTC)
X-FDA: 83844165048.13.B497515
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id B2E2620008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=SwZ3c5S8
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xw0DbvJpbtjbSqzP3tTQeRts0DWSDSnK+T4azKoEMMA=;
	b=7DMNObY05NwDrOfDsGxJMROxsorJIvxAndATDue86+JlmBhoOWj88dRqZxYuRTrslvFacs
	DDZagnqTlv7Mu5+lOz9JPGEVcHFbnzfl87cUUg7cV7wIHVtdQuQdpCgmGrXEtEJVV80F31
	reYsl9G6jNCmpgGkoofXYgkXOw/YAhc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814362; a=rsa-sha256;
	cv=none;
	b=EBdJleTLtubwcycBHaqKyfifwEY4IBLJGyAtXwtiZEwQ1QghiI9/HtDYinL1vwYe4LfR1r
	NkXB68ww0xeJyaezAhgzwth90G+Z65nexAS6qkTxNK6R0bpz6jbnkyD4+KSl/hd6m9ejGe
	CQLs/I8vTnNb819yuzYwqJmK+dO4YBM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=SwZ3c5S8;
	spf=none (imf03.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.45) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45b7d485173so33118185e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814361; x=1757419161; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xw0DbvJpbtjbSqzP3tTQeRts0DWSDSnK+T4azKoEMMA=;
        b=SwZ3c5S8h8BIEudHcLX8aZVUoVHaihbsgczhAIg2aNgYnaTyEBTPIc+iF0Nxc2lvTT
         I1ljmNDBVmn5qFm8do8lKEZzDWVVKDXUCD237T+ZYP6CQsbDKOBChbpaxweI6PsiF2sI
         6AFYEc7HDpbKKH/XWSNKxaChW7tXppIAjMeVaYzVD9G+LJoOS53B2CMLHun7yfTDWLY1
         qNkl+eQvBc/LUOX3IvvCuHS2hCw6v7xHpvYsGLAktUZlWmMo6+/sIuBvGTwu9EpHTo7X
         BQxxJdv8iY9MJ0RvSDjHoUVVyW7r+qpmzVPXPav8/PZwgK3dKOk5nVGyhatTgKKZnxD0
         HeOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814361; x=1757419161;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xw0DbvJpbtjbSqzP3tTQeRts0DWSDSnK+T4azKoEMMA=;
        b=KYrc1UE+AdlRIW0JA66oXdE2770fzLOxynf5JqIRP19wTiK/v8AL8moaHKKoU8xh8T
         q5kCU3I8OxT2P7Z4cq3XZvMl7vxWXei8FcfjhhCkexcAkx/PSBBnQfMWZLQB2xdQFd84
         kLIT26JrCZHEgS5DYW2AaHQbEj8/MdG/NFoe0VdGu0grNgQVLCnOTda5yfgg8FGmBhx0
         l4IYDcHaajUhMAv/D7WknE7ylVzQswawu63JAr/VcAa8C8GharB61AFoK4LSKL9NrvHr
         Sbi97L8uPK44GagunLzVkzU20YYCYWPAjkz8gMcyK4kvOxDicSFQv6wrRz3o2PVXqyG6
         NSsQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/UQXHlCs+35Om1iXfuzMLVxM7fBHnUXqYYvzA8kbfhx3SDVVKUFoOMMU8eHl30MseqDTArhe33w==@kvack.org
X-Gm-Message-State: AOJu0YxEsAM6qsHSF+7fW9JhcEJK2lhqs0u6qgKyssEmrCWizS1DyjI0
	KTUDWi1jh/5xFKbVMl+S3prX5sNqtYz+6EUnfTNmVY0I25E+tssI0PmgG6ZHKPaNjPY=
X-Gm-Gg: ASbGnct4UySVWz+PTo3fN7pIgKl6XzdsE+BrwhmaXqa3g7X2qoCgx+OBAxg9B41xpOH
	GZ19upvIU4p5b2eBwIL9/0bBnrbfq52KX43XVx/xhAHm/VRx24smb2fjGX9pF/rg+h3jyh6+5EJ
	bVJ9jBWj2qkHuT+LGGFH01mDEhCpk7nq7kEgeK23q3zWd9dEys8x9TiECZ49e/+KCycoDz9uhrj
	X1nbi5zj0Ou/wo6X/Rvw6urDJ6Di6t/LF4QpRFMm9LetOC4KW5Fu9ckCRWzvyJ+LuurNWJugNX2
	lVrNo2APugdopdYYq4NH1FV8Ifp365OKuVvzHFpfZj9DdXZVprzcVZ1Av2Z4HFyR5grxG8+tgti
	jED4ZsCVMJivmDYHLQvXsJyT5FQIV/nHe9kUC3g==
X-Google-Smtp-Source: AGHT+IFig5+i8G3N69JEt/+fNxuJuAd6gRiFC1wmQxBVMkPWwXoGHVbuGh4GiKPX8+ZwNKQptgTe0Q==
X-Received: by 2002:a05:600c:358c:b0:45b:9a3b:34aa with SMTP id 5b1f17b1804b1-45b9a3b36d5mr16360915e9.16.1756814360865;
        Tue, 02 Sep 2025 04:59:20 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:20 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:10 +0200
Subject: [PATCH v7 01/16] pinctrl: check the return value of
 pinmux_ops::get_function_name()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-1-bb091daedc52@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1272;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=D54IdY1jZZ8ZVjEEMBAjgBQa9W3AU+ENLut7Z954Gtw=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwRpfc5+ADDPAejjZOjTlM10dVKuuNC16B4U
 swa+RJih4qJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcEQAKCRARpy6gFHHX
 cvXpEADI6jEEX7IdUfYs7XEPZ54xMxDol/HqLYMKjzn1pd17gzZ6pMm489HJP8zxM8j2mK8WlMY
 iT8dv7GBCK7tnrD5rM7OlWLIxCHEgcGarIfQ57UN2+VpxxsBfBGJxT5xHQSPmO2/IuZDM4v7xrr
 JyfM56zeQWTLPe/1M25q4LQwah6Oqo80g3y/jAAg0Bc4NLVqbMRln4z3jzJnCxS4CfmCXVtD6lD
 ciPMgjSGGIOUmzZX5d3tPLZe8yjiEew2QQFX9+T2MRbl0+ohghrRAch+lwm/4sQTJ7GKOW1qk2i
 wwl7NFzrR9h5QQbB/nZZAP6tlNUbhFRh1w6y8WrY2zKhMwBwVkK73ahZ01ffpeWhg3NNobSNNWU
 pbfVXe3SwtMqwmifizSPEwqqxk1ic1ptmSRSLy7cK0O05upywue8PqE2slVh+TLY92uuX2KNjrN
 q9rl5LbEk8az7wY0eSXYE8hfRZcGcBst47/HbNFlIQxtMl3uuNlgmdLUthI/vOpeQ18Z1qXRQyG
 lpxPT6gBF9yUuuckVmcnrAASFTjSTBAq7653xlPLzOr0JPQwkykh9GfOyH/cj8cI7vpb6HUhjLy
 JBUfD5NOkVzL1VPrttUEGa0NyZG0lOBbQ4/NUG98mYZWTltQYpqLJ2URVbtPWAU/CoaZ1AF4/tv
 onN7mO4K/5AiBcg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B2E2620008
X-Stat-Signature: m6fdq6tc4wn9zchwbsqg15izm6zhym3t
X-HE-Tag: 1756814362-93119
X-HE-Meta: U2FsdGVkX18QbLwEux+3Lw2+A01Aux6xFJriBt+/u1fNBTTm+Qn/qOTUTdgTBXQaX9qHcGDrk6lfr0TTAQT3dH20cPJvvwO8nOSb4pyA+fuZkW6u06TpUP2qBNWt+XXP2R5t7lYxOt9aDZqXk2bVkuaXfV3jlbnF5/UFApECqerS3WZ4+NWQ6Obt1cZxcpES35zmfrrJA6qE0p4gVQ+QqqBMblwcflTphBPnIaaXvEWdngA8bknxGtz45E1Uqv6FcIXJ7srAkq9puvJTOXpTFk7pCks7CFNVXvvQ4VgxUTZ/tHJ02gYa6tDV/xsD6bTPT9c3hETUgKZ+O20IjWO2zyzubzIWP4ka5mII1FL1Iv01dHTCUCgXvd8PJbEHvjr8mKdJhhpkGprTUfs4k8XGpJ3iG0Cck6TX5g9MtjBVAzu2QC2zUTJjtwH28YIxBZlOQwXyStlltiwnlvj0pQFudsbw58YTTbCihXvPBZ6Vd+jJ3EYdfS4g9BWe18kldnHyYZUkTSguwrMFE6nqqjY+lHf0jeZ6cnRATLbm5kyNDc12rD3eIUgoZpZqVbG2LmOiRfsuHgMhClZYxvcGFBZcisSYyA2PJ8flcO/8/TCJ73vRR2DZ/3xSf416Ioy29Wp+XDLWC0sS9cuNXJYeMU9haIWoYxPxiwCMf3H0Wns9NorDb/TYlKXSKU1ETrN3henEXbEIs+jXnJbek0Ll/rxSxCV5uUketfOdawjfvZPBTjClD9c9WIXCbUdtJxss+//UhporXtepc5Lhjif3c32HpDwsKw+k277jA0XO9pZ3hcVMbKFK8tr+C0qTM4e0Zp1shPM0VxDyiGScbyNLCk9YwtlXi7RPRAkNw4C6rXl2olsnC6w3pcCfkNo++/Z49Paf8ExsfaObX01gpCdyNJT4Ibtfid7f1tNf35T4eHhrKvl3L5dEc5lYDPI23nnCImHil+U9K52BwDCOmj3rgWz
 xFRcCW2B
 2VCG0cdwHM1ejlrKBVexjDEG+mBXOM7m4PicQyHu24ZKFc2nSn0KtSFkZL5qWD7dZ5SacPwlhiHEp047B4H0QIOjNkwwOzN9GKKe9/mXYyIUDMcypFO6AKXePcyzNbc95a65bsLH4SxtAXGo6ig/2rVl08S8GkAahsT1AEnkj8WcQPf7ye03rA6jx/uCV5QODSPivZTalGu0c3jpC13fj64FkBHhYKBgqfPr7IXafGgSUK2Fu39O+Dc79XgOo7RprLTkNYPXgxtj2V0mZookMjJcwxz11HYvrQZ1hvfG1fqlNKQ/X2/7xwziKx+TRMsI4ziRYl4u3OSqGW3gRf2WEkY5SVi557cD1gbPgBmsb543f4r+3st7ob9Ai7Tu8mI/DE8KeXhXOrEjlyYTWsnTXU8Lgvc2bwqg9YVv/9x7RTI6aFfjgfCNdDYAUyvpUYYw3rDkYZuRQDIN7FtBV5KLSZBQ6lz1HhlIyl+psW0IIYPl0YlW0O7uCx3ZUqGcnRFJxwNLULyL9JNOOEz8Z8QCe2kXjpdE+Q7zkTeoUCyCAhbFxFd1uM2MNKMU9iJ/5HVBbHCZu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

While the API contract in docs doesn't specify it explicitly, the
generic implementation of the get_function_name() callback from struct
pinmux_ops - pinmux_generic_get_function_name() - can fail and return
NULL. This is already checked in pinmux_check_ops() so add a similar
check in pinmux_func_name_to_selector() instead of passing the returned
pointer right down to strcmp() where the NULL can get dereferenced. This
is normal operation when adding new pinfunctions.

Cc: stable@vger.kernel.org
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinmux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 79814758a084570adea0ea1a3151d186f65d1d1f..07a478b2c48740c24a32e6ac8f10df4876e718e3 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -337,7 +337,7 @@ static int pinmux_func_name_to_selector(struct pinctrl_dev *pctldev,
 	while (selector < nfuncs) {
 		const char *fname = ops->get_function_name(pctldev, selector);
 
-		if (!strcmp(function, fname))
+		if (fname && !strcmp(function, fname))
 			return selector;
 
 		selector++;

-- 
2.48.1


