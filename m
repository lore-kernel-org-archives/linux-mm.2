Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19271CA1009
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86A68E001E; Tue,  2 Sep 2025 07:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0FE18E0001; Tue,  2 Sep 2025 07:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEE718E001E; Tue,  2 Sep 2025 07:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC7B8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B63C5BB99
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:41 +0000 (UTC)
X-FDA: 83844165762.21.1A99C46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3DB2020005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="inR+/aOw"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPt8gvlEjpDQTK76H3vkguPR1nz45r4YrgyISuAo6sA=;
	b=Mxkr/C828nPOvjp4gb7h3DD+aH3skIblOLqKy78k8rCvPIw/rWXKPtIkXwLRlqxhWOgkCf
	nLo5RFiRWQ68wXtQYH+0r9xv2yXUDT4UZqyJ95kiUHmCSK9UY5nNNqhtKYnuAzTZMAXq37
	29MjcG0vH1bdi50aLtwXFYpfPclGFM4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="inR+/aOw";
	spf=none (imf03.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.46) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814379; a=rsa-sha256;
	cv=none;
	b=S4qFU/WZV++aREkG5NzQMGZLUto4UBHcxkNAKQKqal0FMGmbKwD6Z9q42FqWIVYnWR7XP2
	BVOT+Zu66EGd+T6Vf09puuOWB2R7xgfESGorRd22l8tJutBZI44hrXNntxxmnIZRBhgDxx
	7gRtl0uXv9fGTO4Wt6o4kTrRfPoExB8=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b9c35bc0aso2768685e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814378; x=1757419178; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HPt8gvlEjpDQTK76H3vkguPR1nz45r4YrgyISuAo6sA=;
        b=inR+/aOwL74gabUYk8BxGTVyM6OQPACs0vcfCu3MayfWtJ5pL5NhIL+beewNxkSB37
         PbDOT1cz1Y7inR1gssxGNUBbc2bN2E2QkYQe8nNKSDE+zdjl3ljwibiJSdoy2PPTIKow
         K99s/oIGcRo/sg4Mz5ipTwJT/PtHcSvwxY1GH2GORxSaFEaFds5MCy/2Ui9CWsn19zLu
         jbVY10Rc4sP3Ky3nBRkYA0sdupaWBJGOdSZRIC2tGovpmrz0pg0FeYMCzW6JhNaGzwGX
         zXV+d6lMtx0VHPmV3aiZleNteHwbrqEPxlicRLqoBiUvFcInpvqDzM1YqaW0LOyBX8MB
         hiWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814378; x=1757419178;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HPt8gvlEjpDQTK76H3vkguPR1nz45r4YrgyISuAo6sA=;
        b=PcOwmSKTKbU3R6jqUNBiwKI2qAiQW5WnyK+G3V07Vbqq0XiZymgVElPFAnv6bFbkz9
         Hbs9/F/QI0EhhCOV7SLrd148T37fIghVKFl53MurWl8DrEesOdA2Ooo9OE2w9KI5JjSD
         Sac6EIFQkSbS3XSZdEM5AarfRBrSS8WJTU+TLlKPEHj+AOxDcCzsstDg1cC6YkkiRYiA
         oLLEOipeXSr6CulhLQL3vybiwjrNvgRooSNA0ROtwr3az5srSwnIOu4dQAKtZSuvFwVy
         +9Tm3JCEUo12YUs8RGSs8+9NeHrfgonx1uLn3NjaKhCX4/TJwupGzhY5TXWjHk2nkxbq
         p9gA==
X-Forwarded-Encrypted: i=1; AJvYcCUQojn9u1ywel7Xn0M2GdHJLqTd+JjI4oZLVT7YXeFTc8vNdfPGj2/bRt0pfqild/YqJTJ8x7/StA==@kvack.org
X-Gm-Message-State: AOJu0YxmG5gDL3+FrDAd9uZcPDMpWP77OhpCBSaWrXgkuO9OiYiMwn3z
	ChOBxAO4McmM/dGA2hDVnMCePG7DkoeQQoPWHcZ07oo8p5boqB54/QmwpWJjMAD84/Y=
X-Gm-Gg: ASbGncvzcgc7xzTGi882RdSxpW0mGuyCKy2m24zD08r64IjzAlrKHpjX1jue05uoFRX
	bYtjvRHUhzYj4VXob/YlMV11boFQJTw/CWo7dQGDG3CRIKsPhOndXe4+haQHFB1otseG2v/TRL4
	1cbjrcOiwCWil0wYQVCZ78Jc03nW6SlTZS0GbzZIPkNryQBEo2ltw1xIRsiSIVlVN4I81KsLpDQ
	Mu1uEpK3/ynAmdfuGwhwPRcnIA5kx5g1Smnoo4AUUfKNi7BNIBc3tamyblKdBYlUfkmyVHjg4NG
	aVHBlAAI1QZwCy58/AWJzFcs8m8lRUwgvPuwk6UgGrDKuQb/T6VaG/WGxCit7xJghL56KATkSeV
	god0hb/b7HxBvrE55
X-Google-Smtp-Source: AGHT+IEXxOo4z4yAeoQlkFOtnjlAQNS/tph/UfDFWhMsGtwbVd/rb4cnwy5YUM0kM5fJazYx9xpgkw==
X-Received: by 2002:a05:600c:4687:b0:45b:8e26:5f46 with SMTP id 5b1f17b1804b1-45b8ee17c88mr52018185e9.5.1756814377701;
        Tue, 02 Sep 2025 04:59:37 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:37 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:20 +0200
Subject: [PATCH v7 11/16] pinctrl: make struct pinfunction a pointer in
 struct function_desc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-11-bb091daedc52@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5299;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=7zPuWJKCi3W/APCCISK85dTCZM4XZbn46J4D4451eVE=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwUiKOInObUndgch3MKKYY2s4jaFgidDJSCQ
 h6iRThYRN+JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcFAAKCRARpy6gFHHX
 ciuZEAC4P8XFy/z/dPHBoKdgqbmvJtQw7Hsxiwp7RwIKdmC6w3qd4q+WzFqlyiwDQXnES/qnpC3
 D5cnkNqC7eO8sGZEwg7V4s/DyQn2O5WmTYQiiQ/eGLLoVv+drovg3G4fdjwSCjzJmjatVV51k0R
 bjqrd30zT2cMLegn/Zo1ycMwKRpXHqNJKYs8Ja3yeSJKRxxWCXf8m1jh6c+o4g+eEgJRIJaK/uk
 Z+TOO0HtXrzKa2x8Vmqevg9+6B4FLQRMOuhAgcp59eACh65TASHH9SlG1M1TSHV8t2zoo2Elhr7
 sPdm7j1eJ1paD9KeGRkPOtk1ovdCPAtAY0nHQaaBCyWY4+R7Oi8xZSWsxTWg1OshqP2F104YBay
 leQDYLDVkrnhdU4QJfaJv2+CjoxvbiSk9BQzwSiGB8mCCNd95+b3XbP2jf/BpAKzJMcOMHhVi4N
 H9KleCUWal4+JEQOKMOEtq2Fnxg/0okYVWlJk9jZfRUHBbst4bTrAT2PYz4gW6cq++UCVf7Nsre
 Gky0m4k34pK+ynwTGMGCPLGppT0pqAd8kPU9+VDjpAj0yzC/qt/oyqrYyyCi3yvjzQi0UtGu/EJ
 2D/E3uPP6c7qUebkXHFqc55URWRiYfVvxSTa//SnOFHPX+g0dXooc05xgP88iF+s++rWyHCYUW1
 9d3aGQPVLm4hGGw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: ie4mut47d73cui77eexqgn61pdd3f9hs
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DB2020005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756814379-544305
X-HE-Meta: U2FsdGVkX19wNGLypodyoqj7uHhGg48Di/E9LQDfbabXowuTjF2R8fddAn38XRwZao24TAlyJ2+ByiJpvRRRVs7gam6T34t/mgcOkKYrEYpiGjZMbwl9jbCfCu0G57frTnMF+km4blFJqoTqciPIVqAiGS07Pawt4e5Yx2sJdUi28J47n3cdYdKYTnFZyK+LGDcUSV3w9tbx3dD1FMb1yY/PCCEjrUMT28Z2ZwC1mIDVadFPevVAsO/gmtS+WauBEWf6ep9gjdxtsiGvJFbObo82RUXAfKKWGzX30O+ftyRa2x95ECw8I1ejWRzUv2vgM2YGVuR0P3d+WGDsgvBci158QDs2xuqxLZZodguTXxtcE3DzbPYX5pKwTIP9WR9ij/jmOq1slPjOZ6YYLiK0DVQlC966GV1QqQQDcgZcX+WHl9hpXpzmBeRysah2UDWlyBYEYAGgN1gsnZqR/wCJmRTMEFcfxVh6Xk8z7lR7IkdfmthdpW5BwocJI7EL8pFr90KLqJqfJ5h8yPFSpK6fOx6FgVRiopoiYE4E/tjNKLypAj8hr+nYO2dA15SPspgvikN92Wx5GQ4wJciQfHhZWbLWRysd1hJYZapMhsdtwZ1vnYsuAqaFufiLCQPG5kOBBRd+behWgH4iqYovxOzr9+mhKneQtebb64DVasP1eLhVtBW4O25NnyMnJ/z9oIVxVqPPiLqI+GNRXcbM/0+kXZaDL9NiuJxfmZL5mcTkvFHG6xb7/E5fU6J7buqKBu22WPwhWduMGTa2VWWWnm3TGmHWg+wWakkX4QVuNLTlRSbR8/Raaz4+i0Hhfy8Aa/mKoNP9w7Zdu5cygIjn1YGOlS5y/0W3HUk5FOWWeGjANY0qa3+MqQ/6hJ4hy9SZvBqM2Nn3jjFzWo8Pz4uPbE8h+oWlqVlaUCFU5kbyr4MLJSWVHRVK03DHElm99kN+7vNP9LpkIj3t2vXkmnhC9DS
 G9g6qPIY
 0n/x3R5mqQVZLbeoWfiRy7VJDojkKHNMfiPCFgpH8UnzcFADD+VoH3MpskskaYTCeWp2Y/71Z6ZMT7O3nCdlSXvo6VpUnlKREvEfmv7jJUgKRCG3Cxznm/JZ8JN1vbDk0bW6IlNBYwSz/RDTb4fJTuVv6wMi1NhE/pHvgf47wp2uv6hvLIzWR1BZ3K8EYWhbhVhFQTdFwrctUnP0zdqL2fLIn2NwNsLgPRnJar5mxogzP1SCHmP1vOWiDU6HJZR9ez3GRSjL30eJCUMHsysm1z8sSraIWPUzkwFvdrZOQRXGrJGPx+fkbsHYQuU9XKyVesQKfKVJOnG4y8jY03F9aDmZyQbCDjZ4cEdipeOjUpWcv8NiUzCSwt5hFQc1Jp5alS2k2EVQgG4cowvEt1xyD7WiT3YMs+rdY8cQ/q3qk+HKO8ICD+JIr///kU2SQ2zq6dgfyrBrT7WX9vg0erDfW3VQzAuFavTEFwnWAIls/Xq9MhKZhcx8o3nM59pttgA1iiht369ve8BttaIsIHaypZKc0zV3/GEawCvEz3DgIlIJNEQY=
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

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
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
index 39c582a25d8fe9ff24cc2b7d8b5a4d4e9fe982cb..731c58ad43eea98ba65de5d05755f9d33dd51951 100644
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
index 954435f74f8c128577ef23da8248368e5c145f6e..76639643ed3f2f3582d5402367064684bc5bdac4 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -2456,7 +2456,7 @@ static int airoha_pinmux_set_mux(struct pinctrl_dev *pctrl_dev,
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
index 1529d7b6c6657eed23dd1f3daac1fd7444efd1f7..07ec93f09334f8ba8f8cbde4c54fd6a894025ae6 100644
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


