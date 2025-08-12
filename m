Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1143CC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941B18E0100; Tue, 12 Aug 2025 04:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA738E00F5; Tue, 12 Aug 2025 04:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71DD08E0100; Tue, 12 Aug 2025 04:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5888E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BA401A022A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:29 +0000 (UTC)
X-FDA: 83767426218.09.E0E4573
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 166F7180005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=hI3Zzqp8
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987247; a=rsa-sha256;
	cv=none;
	b=aE4Jj3ANuW29Td08SQg7ErEb5gEbmYUjE1Ssd0SCGTD7SbftQYOxBmFjp6EnBBFQoBoARA
	x0PmcMubngEK17PVsXjG/P0ryyPpHdJk391oqFR+Ug29BrPawKv4CiaZdw4EbF5l9cR8yP
	iyRZoHv7jIDwyq//NRzXsDEiSHJIDk8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=hI3Zzqp8;
	dmarc=none;
	spf=none (imf16.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.51) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YbWc4IE0U5a+ObdUmLxRXb/F+0HhyYqNMK8nrf3mHI=;
	b=VnqZ86nyxwI6rf3meItcR827qmZUjb2syFbOeRGcJwz9RAsGnC+L/9rvZnUHbyPopJdMuO
	4bcIEvKtoUJM2FPc1eTwPIn+RGPlLEdTWkZ9JEwl1gVtl5oqot5h1dkhxSUrfjQU2dvE8y
	kADmr+yo7y2lts0Xx8nQrb9LAzCKB5g=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-459ddf9019cso16905455e9.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987245; x=1755592045; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+YbWc4IE0U5a+ObdUmLxRXb/F+0HhyYqNMK8nrf3mHI=;
        b=hI3Zzqp8eeHRiPhUFntTZn+LngnLmo2fteFI21C1Ac64unEKuElhtfYjfXZFjlinZE
         2sGWGzxaUL9JVfm0EGe8MqNNxfxnDpMAlfe5DW65hhHGQx3TFY8mOWbOyG1L0focJCAA
         rWeh62Y7OvBGrCgEeFJvVeupw0h7FLNNld5uvqqP0SCXGgbSUcHU5kbTmb91+TKEfDBG
         X2v+vjX0OVI5k11O1tod3qL0RgyyimDmS5f8fO+TwpvySTCE+7bIF8AnDA8gkWvcmygR
         47qB2rrfkpQuDWDlwz/wBkY/LCb/qsA26yWZo6lt38510HgC4tgd+uiP3XMPs/nemTKQ
         pmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987245; x=1755592045;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+YbWc4IE0U5a+ObdUmLxRXb/F+0HhyYqNMK8nrf3mHI=;
        b=ks2rLu63yJspgvr+LT35eGeX7nohh/jjAaKlNQ8TzGiCJ8hnFtRX4nxii7rpIREniP
         Pcskd5KeXbtRz8G7BiujyhePJZxYPmpMd1GlXZV9DrNeDSqrKQBXsqbK0cNq6kY61Xsx
         FbvHm3caYLgVV5Sw4UEkiuT1IMBu5NGsg4FpUnBq6uGy2vUXAh0T43fTH+AlgB1D5FhE
         dx6oUspuOF2m9RlhJBz8tRYOEtC7BRJI6rZMekPR9ZQXWic/8WNAUVzRmpcHfrKq5tU9
         BxMxHxGvSoF1fTA4wr18dKdwMLVJZWV0ZwCruv0bqraNa03qSCRfS4+jO9tRVEiBdXmI
         2Y7w==
X-Forwarded-Encrypted: i=1; AJvYcCUxS87ooPOls08PyFAYy2fjjC9pxJSEYDzVg8yjXvT2eTIHIg7yneIU0f/4WHKKYK6YP7XrCHJoAw==@kvack.org
X-Gm-Message-State: AOJu0YxWC7+7KFv8XoYJuQoD1i18LR6Ktlenx2KjtyKOOCkxY9c9nzT0
	Np0MMvvThXWZXs2ZkxH9El/4tJ2QDATqQexdySa6XXjh0owmN/3yvIDXfgeO5P6Onnw=
X-Gm-Gg: ASbGncusZ5MfkWGuQNHfZ0fsShqDscvN/c0c6bTyiisR28Z/F15UC9MxezOHEya00EN
	l16PSyDHUJj5lR0phIPH2B/VIo7b3PofYmglJuzY4iNnOliVW0cGHsY1YnPEcQGt0brS4DI0CC/
	vY3+7cQd/PwKUJitrQI239OBQNnKrbaS5dT/zO9aHw3a1eyxicxzJHAtZRM4rLBRPFcKUZ0vktP
	iBnCRAmnnixAs0at557ggUBrJdCnxeU5frgj40ruYjuNiR9B4vnnY9jlQMZArvByw0cW9gPMS28
	owXoDQAUmTNbwHWHKSCW89Cm0Jgdbbgmh+TQRJuUcTMKRj6zLKFI9dyqNls1XY0fArnnkte921l
	qsbuUragKmFBQqQ4=
X-Google-Smtp-Source: AGHT+IGi/j7vvT//K1tjjQhALtCZbmyRmQbp5AQVO+ecrZR25VCoPGpFE1cdkaigLNYXu36RBE9/0w==
X-Received: by 2002:a05:6000:2f86:b0:3b8:d79a:6a60 with SMTP id ffacd0b85a97d-3b910fd0192mr2025994f8f.3.1754987245402;
        Tue, 12 Aug 2025 01:27:25 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:24 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:09 +0200
Subject: [PATCH v4 10/15] pinctrl: make struct pinfunction a pointer in
 struct function_desc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-10-bb3906c55e64@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5244;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=eGspcjc2EAjWh0rFUcHzIQ10C9gfQYuw/lhLS4OYQVY=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrYMe2y4vEPLm1kTppjWmg41eG4qsgyU3HfC
 0ktdKcA63iJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr62AAKCRARpy6gFHHX
 cgKuD/wL8IqveDOLws25gTN8uwaorjKGDFIvwi7VZNqVZ/hIyoeWKzjAK50/Voty9yhKi4Ld4Wv
 oWFw87sa48nxfIJnwVS8gzTcvWdSjcaR84jX0VpuIVa+fjyLzgnU0dcOwTV8zQhMg2Jc6lSkycy
 MOiQbuAZkcFQDmWe7xCQsUv0TYotfNPfHAw1HxytCwGs4ye1aDqiWacHAfizNJQT6WYRM8OOFwz
 Q+WtQHuM+3Eo6sGbj6kItR2CNMUg02Oal6VkreWZ8UhJ7lcHwrsGLPw9PCynOHmMo4WxvY3mDPh
 GtriQxOgBOxNLQPICuDdryD40vO8u/Bn1nmchxgo7skPK0/AC2SHreltuLzoaD+lkM/87au5j1h
 pTsqBZQBiGWfsfJYGS6jZWsLms9hmtVfrNyI3jQtX9IYmDBjpf/HcJN0gNyevodIPVMCtcNhycA
 E+MpTrh9F+daADG/PwKcNtDduobVUoJBLy22CdiL4i4+elQlNAdtzTmDFX7TAUODSArn2uLI7is
 uE6vdK4NKaVbHe6vEuZfKxzyf86wy+yuMU1m/rcWIN2Euey0LR197WJkHtSiB4x3fYMJlx6u4U6
 0OR+My49drC5JYj3Ac0HX392d1wUcLysY9U4dsYnqySzLVVuTRHU3oyz6+Oo+csnKugonlolxPw
 00T8opFSZuQHT2Q==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: g9b8wkgid47zmrzuyfit3tgccq4x46j5
X-Rspam-User: 
X-Rspamd-Queue-Id: 166F7180005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754987246-32228
X-HE-Meta: U2FsdGVkX18xuQLIhwsDYQBAwZS6bj0EBx1Bv2WXLzoAfell2Xx3D4VrcDMhh2zFSnAu9/ka+f6OMkwwtRuj4hVIA5sih1kErofHqvP+ma+JM6vLyMZZw5okNhDjbmANRltT7zryNkaAuyBusnpjEPKbeiuITFUt46st6I3+EwK3HrJ0hM0s4VQi+cLskZcwlN2qJyG5JnJF65hxJE+2BB7fKCCcrq8HLu+VG04IEodgBwm3nsh6U4/GxdPndnTMlrgVskxnMqMaQg48FQrhX2tBkyebQobIh18ORvNf8sP7KWGbcFFU+cvsth7ymr7LKZ5Rulwc97tMd8vARV2PU5JY2TlwW2k8D1Ewjl2SBC0iqX8SmwrZvOboXtFstMq490iTCXWhNi9qzRHAxpho/qjUSC5046UkgThe0BzvJT/xfZkL5wacvExLe05rjlrKcjthI2MMMXrwPJKJS0kVEd9x2O5yFGeC4XngkCq7LDaX+Bhhd7KB+Eg9VqR9jZAx12brF8LS/kQUWj4Edfl1pV73mjl0vPGammnR7i09K7LP47C74S4UnN5Eh6PC+NvNmgVci56M0tS3jk005ziJ92oOBn4V3N7afdFcqHVZfbibYtf8VOUNPTtylBU8Xv1HWDJJLvKLG9p/7timR/scrc64bLPPFq+gdznTvxvErNp1r/MhKtDNyCBdAPnMzr50CcHCm5wn6KTsM85FsRnqCzfv7SzMmi9mprG3zAKUaFf6VgyhDHS8icDsHzYRTectCA4yaHTyDA+5a8ylWsn9+B0HD/mL3eOJQrUOzInGBOVeCS1ro99Fzv/qR629DPDOHiptbHp/MTpTwanf+QGv2qtGvH9yYT50RuwbWhknNFmojMeM9CELdvv1csBl05mlRPz4iZ20OLsCDNBuuRepSpETHMEFZ1oat746ojQXjRDBjOMzyrfS/IPTldxmyyXs+b3WBAxsazwla9fV5mX
 B26ICSrF
 JFvgfYV4SjDumPzeZOOwBf7x21RdNb9qmgCXZ6yYitEiQn4wDSrjgt9xcuu08xQBPqCMhWogUBVfLjD84Fktp7Y2aZdypb1NrVR8qoRMyBmu3NVZc0+LMP9YjYttlFlZXxoHdREwogLQxL9hYkOPAAgAOVQqeomjA1RHxP14eaf4niFv0ZvDe/PctjE6Rfcl6c7k1Dt6x0/shIgQLTfo/cLRyKGXAlcUsmwZtlT2dmuIly3PD81rFGmiidOKZ9/vvWHu0cTDrTMd9rT/qJhQ7PZLVEpA9krZwX6OGMAxerD3ZiDFK5393sqtPijtElAsKhvyMyi03V+BpfsayzKnMXwiEnsSVAXyz5GoTwVPRI9SVGC7qzC+6v44iI8faFxLfFEDrOk7rFqhEPcq+ZQp/tQwq/7SGAvOJtGKxSG45aeWl9dj5e1xJOCXh34s/nfFxTheNmw09RY2kXiW4y72J35203TY0an19XF4Wv33Gy0qbu10IfyyDwtx9kO9X6kNp3YMyeNHJ4DNTe9+HF1A7OH4ZSOP+06kFvySr55AcYPzAGm0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

We currently duplicate the entire struct pinfunction object in
pinmux_generic_add_pinfunction(). While this is inevitable when the
arguments come in split through pinmux_generic_add_function(), users of
pinmux_generic_add_pinfunction() will typically pass addresses of
structures in .rodata, meaning we can try to avoid the duplication with
the help from kmemdup_const(). To that end: don't wrap the entire struct
pinfunction in struct function_desc but rather just store the address.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/freescale/pinctrl-imx.c   |  2 +-
 drivers/pinctrl/mediatek/pinctrl-airoha.c |  2 +-
 drivers/pinctrl/mediatek/pinctrl-moore.c  |  2 +-
 drivers/pinctrl/pinctrl-ingenic.c         |  2 +-
 drivers/pinctrl/pinmux.c                  | 18 ++++++++++++++----
 drivers/pinctrl/pinmux.h                  |  2 +-
 6 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index 9ed84479a5b43871861f46fe1326f1dfadc7f63c..0df7eba8ccd3209fbc4b2e67ffdea12b77b90858 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -266,7 +266,7 @@ static int imx_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
 	npins = grp->grp.npins;
 
 	dev_dbg(ipctl->dev, "enable function %s group %s\n",
-		func->func.name, grp->grp.name);
+		func->func->name, grp->grp.name);
 
 	for (i = 0; i < npins; i++) {
 		/*
diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 61aecc3555837ddada3bab9d7f28a6af7afdd3b3..33421dabaaac597382e75c4e5ab009390a2eb1e4 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -2459,7 +2459,7 @@ static int airoha_pinmux_set_mux(struct pinctrl_dev *pctrl_dev,
 		return -EINVAL;
 
 	dev_dbg(pctrl_dev->dev, "enable function %s group %s\n",
-		desc->func.name, grp->grp.name);
+		desc->func->name, grp->grp.name);
 
 	func = desc->data;
 	for (i = 0; i < func->group_size; i++) {
diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.c b/drivers/pinctrl/mediatek/pinctrl-moore.c
index 17a08c73423fd089066e4894d2307c852bbbb661..11dc525eb3a2dc8ceabf2278ee1a2abaa425eec1 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -56,7 +56,7 @@ static int mtk_pinmux_set_mux(struct pinctrl_dev *pctldev,
 		return -EINVAL;
 
 	dev_dbg(pctldev->dev, "enable function %s group %s\n",
-		func->func.name, grp->grp.name);
+		func->func->name, grp->grp.name);
 
 	for (i = 0; i < grp->grp.npins; i++) {
 		const struct mtk_pin_desc *desc;
diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index e13ef07850386e70cffc83011589ceaf70a70a41..e5b24fab12e11e443df25ffeb7b70d7c1a03c6bc 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -4015,7 +4015,7 @@ static int ingenic_pinmux_set_mux(struct pinctrl_dev *pctldev,
 		return -EINVAL;
 
 	dev_dbg(pctldev->dev, "enable function %s group %s\n",
-		func->func.name, grp->grp.name);
+		func->func->name, grp->grp.name);
 
 	mode = (uintptr_t)grp->data;
 	if (mode <= 3) {
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 62bd4aa53b2b22cb09eacfb05398205f2fe391b9..6f5e3ede972bbfa78e279790df359632e2d63485 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -810,7 +810,7 @@ pinmux_generic_get_function_name(struct pinctrl_dev *pctldev,
 	if (!function)
 		return NULL;
 
-	return function->func.name;
+	return function->func->name;
 }
 EXPORT_SYMBOL_GPL(pinmux_generic_get_function_name);
 
@@ -835,8 +835,8 @@ int pinmux_generic_get_function_groups(struct pinctrl_dev *pctldev,
 			__func__, selector);
 		return -EINVAL;
 	}
-	*groups = function->func.groups;
-	*ngroups = function->func.ngroups;
+	*groups = function->func->groups;
+	*ngroups = function->func->ngroups;
 
 	return 0;
 }
@@ -903,7 +903,17 @@ int pinmux_generic_add_pinfunction(struct pinctrl_dev *pctldev,
 	if (!function)
 		return -ENOMEM;
 
-	function->func = *func;
+	/*
+	 * FIXME: It's generally a bad idea to use devres in subsystem core
+	 * code - managed interfaces are aimed at drivers - but pinctrl already
+	 * uses it all over the place so it's a larger piece of technical debt
+	 * to fix.
+	 */
+	function->func = devm_kmemdup_const(pctldev->dev, func,
+					    sizeof(*func), GFP_KERNEL);
+	if (!function->func)
+		return -ENOMEM;
+
 	function->data = data;
 
 	error = radix_tree_insert(&pctldev->pin_function_tree, selector, function);
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index 549ab10f7afbda32fadf4ad151401180bed2064f..653684290666d78fd725febb5f8bc987b66a1afb 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -137,7 +137,7 @@ static inline void pinmux_init_device_debugfs(struct dentry *devroot,
  * @data: pin controller driver specific data
  */
 struct function_desc {
-	struct pinfunction func;
+	const struct pinfunction *func;
 	void *data;
 };
 

-- 
2.48.1


