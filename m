Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F51DC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338CC8E0063; Thu, 24 Jul 2025 05:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310FD8E0051; Thu, 24 Jul 2025 05:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200778E0063; Thu, 24 Jul 2025 05:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5848E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:24:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB9BA130332
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:58 +0000 (UTC)
X-FDA: 83698623876.29.7B30402
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE167180006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=Hnx+ofOt
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349096; a=rsa-sha256;
	cv=none;
	b=HmgS89+dhLgIpbsCj1ZDRrtKH4fuwewGkU8JaKMU7hSo1QdJH0en8WBlcMgTar9vC+1i/L
	IVYzU4SO57XMDBmdrL3QkKnjc2F/B20bzm0enqU6gAcY32gjv0Q0u6zRLTMd17InQUITJ3
	GRR5UEPs8LQwbG7rmgQ6Y64lQXOZmSI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=Hnx+ofOt;
	dmarc=none;
	spf=none (imf24.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.52) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/B5mqzJPOKnymkKTWWqgRIpNgdkGss9Cl2KKrxouE6o=;
	b=Ui9YVblQZ+Upz/SU6XdCds4kM3P3/FrW6oDMdgwR0yBftiJT9biGLf62m6YOgsn0BKr5cb
	VvQtix/xEPLFwRQ69tQts9V4I789dzWFmVk0jEdbjLIOLJ81XnI/OPWxlKvmwnMW4c2QMr
	IkfzyuSlMjMFVpblj8R9//anENhDGUc=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a5257748e1so556550f8f.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349095; x=1753953895; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/B5mqzJPOKnymkKTWWqgRIpNgdkGss9Cl2KKrxouE6o=;
        b=Hnx+ofOtrh5xyTXxPrwy1sHh4eu4Bpdr+UUSMxJR4R9f5B938y+a3c6wLMGmse+SxB
         I1KY0lXg8VfabME7XU4iyczKCgpWGb51BlZkWSkFr15Vkh8L/grqpK5r1TI7HGMkUZbQ
         nbHxcrWWex93a8G0BxH4eaNraH7Ac7q2CZobFT3Lq9HXMoDvXST+jhV3pSKHgA3GDiuh
         nv6yJwtWf513W7XiVz02RUOwld0i8KjuiQfaY0yFrkCvC9UXwBJvpWa9lTjjurOfTXyC
         OGvqSxyuULhrfDE0yv2CBnhOvYVdtFzub9y3Usgo/O1xdZ5Mw3xTRAWOQNKMRGUK6OOX
         v/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349095; x=1753953895;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/B5mqzJPOKnymkKTWWqgRIpNgdkGss9Cl2KKrxouE6o=;
        b=W69MorHs7DnUrQc+CXZHldQD91qTtIyOR02rvVSpe7jM4314DTydY1AQ0ur/g4R5Kn
         icBWYYk2PKXnQAjhKAeXgDb5ceVB5I3HhVAwXz4B7INDtb7L3/Qq4zrWKinruTpctKng
         stfK1XMRa07PzUDgg+L6XjBS/7f/sDMzxLtOO/u7KzxSHrBCmhlAC6RzxQ1ErH6wY2HN
         3cEVkKpizYvYFb8Up4UfJLpmpeHp2N9q7JUqkUmmM3u7Lm6iHSot6hZQPn7Jn9emBGuj
         AD0Fo9QkSA0QMhx9XqbL9EMQEQVCy5nNsEMWhXozOSUhHM5OGCYMSMPLNhrI4gaklxV4
         Zkyg==
X-Forwarded-Encrypted: i=1; AJvYcCXTw/Z2jAUZJRky0WrQdE/Xk08BVUYM7dHZi+YKeMw7ktF7sapuncc+1SthTzBuI2shZD4rZK9Tkw==@kvack.org
X-Gm-Message-State: AOJu0Yz6kiWa1qH/35zDCChNtOkGz4bvlZSW/tRbFZWKraPwYuVI6uxw
	Vtih9VA8Rky4rTq+TgSCtfiRZY890AvrgXQlpFCXXLeXQ79BpFcFB20pbsxyMlqLVeM=
X-Gm-Gg: ASbGncsXKLRBh7wMT4ChQMb+T7ZULrbhgvVghNfV4VvxyLpNCQb6jmuGiOCNL8FVTtK
	zsXNVFhNZaX6GTyg5O5A8MN9RAyyrqqRbbQpKBKMDq2UWTPKheSjC+HtZu6BWoxhvdyNTrdoaqW
	JbychFmz7cudYJdRFhzq3vLKAoQXeU5METsB0t56I8ThsR0Tp8+1znVou7Jx0mw4ccmuo4D2Mv0
	lGylPnLr4AKJ0dCwJTGJ/QxM6CZ2DMQIrwZ3ru2Ll9NSfO8J4E3eIHHY2KvW8WOy3skaTnlgZMp
	KSpT4Ztuipr5jK4lPecjZLjoreA789CTYY/r1kQFiWuuRt3II4q9YK4L7ryKaKf0YJ/ill4tCiR
	H7UlDzTYekASsooiFkxgXtOOMkAY=
X-Google-Smtp-Source: AGHT+IFFYGzeJ4b/YJmykKhJ4ByKyqeHXAd3kTP4MKkFIfH5T5aehAq/f8O2Wira9xvCFqeB7o4n6w==
X-Received: by 2002:a5d:5f92:0:b0:3a4:f66a:9d31 with SMTP id ffacd0b85a97d-3b768ea0755mr5380456f8f.16.1753349095153;
        Thu, 24 Jul 2025 02:24:55 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:54 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:38 +0200
Subject: [PATCH v3 10/15] pinctrl: make struct pinfunction a pointer in
 struct function_desc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-10-af4db9302de4@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5376;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=ZmuiefgGXXB3FllRDbqQi+J+Hkq37TmiTiEClP1ORcs=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvTNNHWkYm23ctD+yFB8BkOI94T1g5+tu11i
 kTU7G+yUG6JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70wAKCRARpy6gFHHX
 cjGVD/9OXwWkNBcpAmTOjXHlhRrDKtxZJu1qTGLXSjtO0KPkqd5CY7BMFUOCdEi8XlcQanbbL7L
 nvP4K7dN+xr1iL0x/HfeKZEelU9W3C9bNoRmDledoPw393rdRV8doK7SRnqa0O20RjWjxn+Xz/N
 Lwehl5zRQRsMH+nFk8QUjzlnqGbUuQ9TQ0SodhzRdqiAT1GZ2GRFkMVJpPhlI8WtJ9dk1luDtGN
 WV5h6irSxODFsX5L/TrgvODweankE50CEjYLFjnyxR5i78TCH8a1hnsaQB/2Tk21DW+GuJTyz4Q
 Z0deaoQamyFH2VEzh5oSTnAf8wsObNY5E/wKBggsLhhB/qRgiWy376pUMyEci+0hal9AuOu6aJX
 fEVuNV0LGRkANlOKZYvIQ2NU/XmdvaBaFF7QzhuwBRXeE2wK3lKe5pZwe0OdYnC92MawGANseFj
 7C/VuOkNz2W8FIMgJr2JyhJZAh9LOJjklXwJxohtKwiKpUAlGipl5v7wuql1Pv9X3tKlODyqmfO
 FgsgXnUg/EeCpUgKVgMOIgO665Zmt5PwsHtlaVU+AgJzZV+9/sGUHTB3rCOCLcTL7iJwzyG3atU
 oaKrWyF94LGpCqDvWnT2xznL1U3NEqV89eC0mwfnlvlGrGOFuf1fxB/78fjOW+hZj52AJT0UnEM
 FvdC1chVyjxW7zg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE167180006
X-Stat-Signature: utpff7g3x48stue1x9nmjsgx9sk8f8a1
X-Rspam-User: 
X-HE-Tag: 1753349096-675456
X-HE-Meta: U2FsdGVkX18PauJ7fIu8SBCXRBkFJ5Z3WuGlTiZ8K/GJGcC1ktBV4mhnS98mwKmrBCBvPCQmGE7Jbi2+1T4StMxaLFFRmcOxd6MOOGE/wuYksf7Mv+S5dcVGQ8HuWtvDGJWtZcX9HrpXOXrPms3Lvl+qxlfWA9KQzr7mLelxZOVc01Tmx492RYJNnBIPzU/b8Bkrm7+apKe6INhLim3jOpnM24kbtVrBC2q06ufLhRuy+LnugFYAe9TFAcZI/ijxlF3dkNUm+SkhSg6QcB3KIVnmgn6kyNARNzDcsANIohhsRGOSTqvR7NODJnVPbaJjgnAmTmsMZxWwBe8BnvDVpGs49QeuExt+eK0IGT8ZljpC4nXxMN5KHpM+IcVeclDNH+cYg86SYzpcc+o8RmdcqTUVVQZd1aAO2/S+W52nAoQrhzN2Y2IpbrxGz2ZTrgYtTa2JMULJn1/EnMJhpZ/MDvFfUTmRNmFWAPavYmaNv9G5BJZnhYQkpcrQCva1c2pGAdP53+fUm6AR47sxtiARUZkT9WJQn3bVrII6/CeDxAp/TQnSez6weQF9TlDFkhCq8qE09MdXQfOdGxm8ZbsJlJoLxmNuP86q0d/cta2pzTmAcYmlJOCrbO5qUH6n2H+CHyDOrjtMHHQ6rjf8QhslyqDYOkA1DKfBvxAHsztZq9BYunK4aGhsQmm751qrSQ68yGgSf3XH5M1ZJoX9o7re59LY6YKVEC4XsFXtefvcwz7hbl4jlTMS7+q8+G+2WHdXnC3IluEMoA9SZAMY0zX77FmnmHhZgmVrfQ2bzh9Juhe7ToWFgEn9ByyIHxRUA34qnXAP1f5Gswiii2s98HLQlb+aD5y+qYyKx99FaHfLWIi2/S2qcQnBr8b2TSQJBDaELYnz9cEbSC5nUCMTutKdy3X4Fglu81ZjRTikep2780BJElPvQUyoiikVlZv56ecVrBBzjOkOczg+YsJ6B6Z
 aacNWLG7
 t6BHT7pntP0gGTVDPbKVtt1w6U/3flbO64rlRlk0hh2KsUKzIkE4YcsmmUzdUxuhRU8xFTIbVtQ4bP7F5UQFAgG8hcNtzrYhp+hjTuWwl+Vs8pv4Cc0xu22iMPqdG0qUSdMiRQWnBHVlrCa+JbfYMpefNdmgu5uLxTxoeKL9VabCLKDxdaqq31xog7JFZL9678HOCpvR9VIBfM4QFzFWSHixfFMMWkLblP6b4X3GoHXGLitUf65PHRJ3T7/zRqNXqQjcaH1bm7+tqq6OeU0qOdOSvSzt+pJtVlz/F8y2FKrLOF3DiMDi3nFUIImxtw99n0YkgA7bwyRDvl4FBOHBmzoP5sTDgfhV/MDhBxXRf+SLg5ikrG5mGZ/El4DdnxzVRac+lwkAXxln1CDv8k2rQIlA0SpE9qFCL7OQ0WQj1HX7IW0xUqcvtW+1C4ZUW+KnO5JNEaLaaG62pAe/A5czcO7VuGmh7aspN4giV1d474Ww/ddxNOI37L7CYQQuktAFTwvpJUaF25VmpANBNdXGOLssVH63TrBQuytfNU/DtT5tIwz4=
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
 drivers/pinctrl/pinmux.c                  | 23 +++++++++++++++++++----
 drivers/pinctrl/pinmux.h                  |  2 +-
 6 files changed, 24 insertions(+), 9 deletions(-)

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
index 9a95577439a1b50607427756a713c8122c7c4af1..148b6e235db53290c48d717a994d88cd53c3a135 100644
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
index ec0005246c19a156079807acddc93bcb767d1222..8ebd731675f69c8b076a7e7767be8ff7c6d3dd79 100644
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
index f89f8ec06ac63227930a38dbc80f00333cc15b48..d81788aea5cb002a86869e22eaab430f7ad18e77 100644
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
index 62bd4aa53b2b22cb09eacfb05398205f2fe391b9..504dbb3e97cf334e39b49121137c6768081fcd40 100644
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
@@ -903,7 +903,22 @@ int pinmux_generic_add_pinfunction(struct pinctrl_dev *pctldev,
 	if (!function)
 		return -ENOMEM;
 
-	function->func = *func;
+	function->func = kmemdup_const(func, sizeof(*func), GFP_KERNEL);
+	if (!function->func)
+		return -ENOMEM;
+
+	/*
+	 * FIXME: It's generally a bad idea to use devres in subsystem core
+	 * code - managed interfaces are aimed at drivers - but pinctrl already
+	 * uses it all over the place so it's a larger piece of technical debt
+	 * to fix.
+	 */
+	error = devm_add_action_or_reset(pctldev->dev,
+					 (void (*)(void *))kfree_const,
+					 (void *)function->func);
+	if (error)
+		return error;
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


