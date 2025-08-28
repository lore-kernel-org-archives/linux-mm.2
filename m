Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BFFEC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16846B00BC; Thu, 28 Aug 2025 12:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B3A6B00BD; Thu, 28 Aug 2025 12:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3276B00BE; Thu, 28 Aug 2025 12:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB77D6B00BC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6EC23583AC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:39 +0000 (UTC)
X-FDA: 83826628998.21.B4E8C4D
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 514EA180028
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=RiNodkJK
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396837; a=rsa-sha256;
	cv=none;
	b=0XXaiROQQ+9WVYc/BT25WQ42aiV76XHKfhqZ5hYgttZzAdUpAHo39u3HSghUCZJJiI88e1
	oxo68UoVw+6d1+V+chOLPlppwlpN9vnltj/sqdDjm3ODWg5ZKePe69flJK8TAbeSPGYVCH
	zdoHBhcKJTR04Idt5nk8rLHvxsF0v0Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=RiNodkJK;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.42) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4V6wSNUy+49WdVnDeUhgFQb5Ab581+KZPYX/SdZG0hY=;
	b=Le/6Ul0ocppkbAere6mtnjGdvDQeHpm08a7VuTFTDBPxds3vNZy0/Xf7OogQLjZMN/y76Q
	8rik2sJOJ4HFyRQLR35MDGauyy4V0gEpCIJU8My39Htik7/cC23d6991c0odseusrRM4SM
	cxQqGtMm1ncX4xTNs22Ikj1RhHjOzIQ=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45a1b0bde14so7052005e9.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396836; x=1757001636; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4V6wSNUy+49WdVnDeUhgFQb5Ab581+KZPYX/SdZG0hY=;
        b=RiNodkJKyjl3huCKVCfzEP27tryhprr/fZn9UKl1+sMU92NmYppYLdmqdGkJjg7SQu
         5inlxADyc+z3ZFSQzB+WMuDI0cgL6RX3JnKAR0Pl3Oj4MsUDwjG9gOTAcz3kL6LgY4pX
         0L2A4YLPEo2lhLhecVSuO5cpMjQjjGxcNtmTV1BolBKn4qDOUnS2Fsgl/kiv7vvoU6Lc
         Nge11B7FqVTdTbNsdZpNAKIO6JJJFulhLkNuvrHmFsSsB6qZgsWnaRJCy0DYQW8Zwu5w
         NLoVEo901JrMJWADfUZfpYndwoihpbsr9iHiHQWBLzFr93L7qKFi5NA8G2WvyNdk7a86
         bw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396836; x=1757001636;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4V6wSNUy+49WdVnDeUhgFQb5Ab581+KZPYX/SdZG0hY=;
        b=n2UJ1sCitWEG/lY4S9+y3q6RE+8H2r1CFhs48AR/R1yXzcO7+hrAHWKGJCqzv6KlsX
         1OLLSJZk0Zl3ng3ik94boIe3zOfjvsIDx25OS2NhGAw8N6pCKkyBXcG8Awa56BkVui0n
         oeHNTgJvFjdrhZF5SCV3tH2ds1/HVI7uGc4cGFWX46wqxZs0xIRyDAtHLqOOa0NQ4GiH
         xKMBYDjWbfeYDp6MI3Mi9y3+C1UJzLXaOO+qzQ3i91v1CroaCfPD189WB/KOWRr6/+cD
         L5uZiXS1iyFEdWigTD8jFtwPrDgVTrUlZooKQjHM3A0JUgiVB2TkwAaiXqm/QhpwH1Mw
         wzIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDboGvD4X+30VvJUL3w0mi9V0aPLpBsSYw4xNfy5n0Sgn0nkQFKE2P+T2KSPCoqiy5CEfj6jvhgA==@kvack.org
X-Gm-Message-State: AOJu0YxNgoqY3Vp9IlpQX2+pVlctu561KPFl7DCKY1FORSraBbdRDFPn
	Vai0B5a4KWriK9Pbyj2oDvWgYA2eAPBrzg4FH5mldrxOLifW/FFJ1Ga761jPHni+d+Q=
X-Gm-Gg: ASbGncuUST8gcvbyDvq8mn2kQ9L1W8FkZfVDooABq1+kdxzWFRNuAn2Ih2b3oKWvQAl
	VOMJXGF9T6jr0i43GDQBtxyYjA1I1Lohxz48hmCofuAOBJYlYpuvVXdptDMPY0P3R2dZ3Xop8Vr
	BahqTT98+OFwWUlAuhhxFenwqcrBDrRX54s0LkK0UePqwAfjyB3mUjAdDyc0M135iyZNEnOh+/c
	imUplpt+VCOCSAhcMHfCbA9eKp/GyDDhuloXHb6dWV9Tv6pT2R7Z80ooak5JUdd9/N3CJ+ZzNUP
	hnJz5LPEvxLb/R89WWqqG7/sZjYFUUtTOKS0HFMfZHD6Jgz7+Ia65OWCFdcQpflMpNkqW3f6sHd
	o5DBqq7+Ihrh8wS3mirPX38Y7Ofl/
X-Google-Smtp-Source: AGHT+IHZut1Ju+wLWOCu27g3oxlfbHJTRITLE2zpN7kI0OEVcWhxgfQH7OJfj9RiKp9cCo2WNd5OvQ==
X-Received: by 2002:a05:600c:4451:b0:45b:43cc:e558 with SMTP id 5b1f17b1804b1-45b517cba3bmr203142095e9.35.1756396835751;
        Thu, 28 Aug 2025 09:00:35 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:35 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:18 +0200
Subject: [PATCH v6 10/15] pinctrl: make struct pinfunction a pointer in
 struct function_desc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-10-c9abb6bdb689@linaro.org>
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
In-Reply-To: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5244;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=igWDVQ1i3GNsSU9QCM7MdJ/ZXZhmiW6JQ7gs50oMzMA=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0OShRzzi/YdGvFptLEfy7s0tzHayMhd9IJr
 CgF9D6e71aJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DgAKCRARpy6gFHHX
 cmVED/9Q9pYZVO4h155fVXACsckZla46oeZ3SlqT+JLQkCr+sa3X74JqYGKATTim7Rw/256QGDE
 UsdtaqVKnvRWtNWRyAJOeDAiiQPlbb41DBHtaTf0thIPguu1czlk5YkMZsmyVrIfJoNl8sNKGum
 ptdDmj/ALJIL4u0sfh+jBCnArShidwSMfTM/CPNJVYDWNaIA0Dlbs6HCiBiFRH5KnR3JEDkPJji
 AwABByFBhrCDmOzAtgqm6bEM6pv+huWJR4v6dtuJCu+mALZYiXGzSBy2evcJooioUE1gjc469ab
 pj6GkhP1syujJ9WallzCnoFeasP30aEFKqpZLTv9saXaiecZ/IZd2DAzONow948O8he4tnFdBvx
 ze/phxq3+CZC9IusFa/Cj3dY/GwwVIa8UCraq5poM+av8PzrrdG/Tib4Akj8LEmYo07FtAzbi93
 uCxAfgccQ3wGTH6uedp1QjlKh/01q2kDQ6OrMt5aUKhEnSZKHfXjPJpm+ugFW3JA6HuRGt1QEVn
 o6s7TXD23ucx79L5J9DaEA+RhegqRSr242wmdbQPPZLxiMDbbur2keLH9zjrKxt/hS9k+6x888d
 9nCqr6XPvnaEOssyKEX+Fk5PXIjFLtWcYfD8hEPiozd2D25jPIdZh/mybWD9lAuNZtITpXYeZ5S
 DdHAOotTsdOPNzg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 514EA180028
X-Stat-Signature: c4npwbtpdgz7ne5ta3o3io8rqpf1paer
X-HE-Tag: 1756396837-602247
X-HE-Meta: U2FsdGVkX1+zmJqYfqYWBy1pLqms9Dc3seZHQvtqdZbLNEt30PhcCqj0L27oW9lJvxhjss00yHOwmUjZStPuxAwaWBhAq5S3JatSkuryFYLHyLVHx/yMQe6bWpqNKbIyfSLNJT1CRA9/i354VMzemA4X/uGZGoWgssjSPpUl2OJE536kPKZ41cv8RIE3edkRKqIzW3vYGWi0WTbJTxTQuXEwfrVRe9eVBhtrRH4tFji9vY4fupBDikbqGBkTNcrWT3UUy+fGSCAruI2EABlhGzEXKtAy/I4itBsJI3okMs1vXep4AnvYqp9dzv71iX2um7syAYJfYg2pdCOJL8S9F4arPI8AKTgVohHlWtLLuoapr8VanvwUYcg+cmbyc7+vkUoqeoDGzSWs0sl4sm3VcQ4g792QPiH+yw1qMRn5kLmdZhE5YDm0xuFTejImze1gSQpZKXSdnjpGYxwfQMW4EQNee2IBqGFloZ4QmKeHFBcjxrNW92z5oxx6H5//xe54cOYLHik35+QtF+pWg+lGNjNcobpdD5Vps8ZlQ8ifZ1SJ21PL5cUBfrgyK/xhTWahfxRW/0RN90igIR9/7rqltP/V1kFq3C+6Lxg8Rbu4za9KMGAMu8AT5srm+Iw0MhDTQZq79LTeMUe0dhO+eZXZ7ccUd1t1FbDTNbEzM+pAaL6cWqYaNPmjem6qti8HKouphAfwDkLclYGVix7wPIp0mf/9UuXTX7ZvEIu1/9/POiE1Ev9qqYUTeeH1G/UrPzzYarPLnxC0hA3x0KaO2meNBVbH//Aqv8Q3SkvwDzpm24n/r/r1CiNlQ6dZ4FhC18rUNqiceHzngCIIkB3ZRe9bC58CMDrKf1vl3OGnLIHXuQjjBf5bejWIhj6tzhT/CRZcnpV8xJtm5K7wUQTTurAzDnNsV7PchtqunKbLcLBmcRnN8TkEbjD1Jyy0hcndjBLvIASEIcZyTsqnUHk4++w
 fnNrKuCR
 p/rsbJVdjBKVY5OXz9hKu/9VqFLtN1iYN0V0VKrkinmwL/nDGs4RMkR7UXx/7WTsbXmpdr2MLdrzcNynHi4ds6erNQT+iIIWsi6gYVWxUnCB3tMv7Hp7hu/m4kzJEmKYzEPdY50+6ESF+ZJ+mo3J8TrsKaD9fy17ul3CKEC6k3yjNYHUUkk4SCqouq6hme+YjCA6jILdrmdDURDPI0eKRSWDEcW94GaT9NbfQ4DyNNC/6TIWyMn1ZnPPpjy5W0F5cSs8nFG8JAiAIqLZvyg223Tuorpy2NpUmtdA5FgxgGHUQJ1B/T26Uc12oZJb2PD68Ecq4pRfgxNnuOOFFrHekRsSI7nPzRegkszBtbNUG58uutFbVmJugsOWdwOp2NHJRBfTvljoQk/UU09YY6hIEc3B1VKrGr3fyf0Kvam4BoC9ZOFmzgTy1l9XhXBUoamT/XABHekF7mFvzUaqBwRCLv6Lap7VHYejEQXp1RFuRGmXmk6v1ox/lcxZIvxlPX+s+y/PgfXpeC1kUkg5NJ03SFAut7RDRSDVPVpvd0Pw8+fwk1+M=
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
index 56bfbf4c3575355bdda59cf7471bbf5b9babff4a..ad3bb8475c0c29e15dfc7a8e4afdeadf5ec8aaed 100644
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
index 2eed83f9f209cad79580082c274d4056231bd421..8fb3b65a1b775cf078d3c926af59480e9e09ab30 100644
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


