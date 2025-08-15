Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1A6CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC626900239; Fri, 15 Aug 2025 05:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51158E0002; Fri, 15 Aug 2025 05:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1F5900239; Fri, 15 Aug 2025 05:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3B0C8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FF62160890
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:36 +0000 (UTC)
X-FDA: 83778418752.02.A6012FA
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7850840012
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=gao71I3k
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUmSb9m7Wb2TMLn6U2R44kzyxWVCmDVSA6WZ95LWBOs=;
	b=BFtmckf67lGgZCc7eW1zoN+q6T1S9a/7Zg+zV3mHW0l8WeA2F6NhS7s3Elw0JV7wCAVgTH
	Voba2GIE5WlBTcVTPhUkKdLooEpePRIEbH90i2OkmOv9+phtYMD16nrf3bl75uGOAAUwBm
	RAzbtX2LEm3oNoqm8J3TwEGGGEPoC38=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=gao71I3k;
	spf=none (imf27.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.44) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248974; a=rsa-sha256;
	cv=none;
	b=zwKHvBF0KDVDLQ2NOigSLlPd2kPZXFM8UU0y7tnVCyYKTPVlLYJhLyGIaQMpcfAu4EKA+B
	caPqiJTAyMRsYqf9CFZVKijW7ckcxdgN3T5GiZmi8OwLH5x9AyGEh/qy11mdj4IVQnsuw9
	JLxezohPKSryEmkwQ+euWVQf9UKCZIo=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3b9dc52c430so899541f8f.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248973; x=1755853773; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wUmSb9m7Wb2TMLn6U2R44kzyxWVCmDVSA6WZ95LWBOs=;
        b=gao71I3kJvV1PYeaBZ3LGiYQ46aj6geFbKUKbGwZ6Il8uvEgSAfQQOaQmyInTghuLi
         r8liUxDeobFFj+ihYvIdYom+NpiOs7dmavuB5k9FW+ZufUEB43Sj69lYcykCK23dPaEf
         NAr70byjSsBAouwX9TrqVfJkKxgJGRmytDXEDeKF6hXr2RKExmovhX9R+V7HdK2kPv/y
         +s1X3fdiXIZlxg9JKGEXJ47QPAOEYTqfJL0tmwVA0lN2m+DYHgMykbmNXmOWHqWO4ZWg
         5Z3YJ+2G+SGuw7y9DZOuSH7d6aCV9ccVvzCMzAZ0SOF+PHRUqnRfQYLFFTQJZ39WX26Q
         XtsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248973; x=1755853773;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wUmSb9m7Wb2TMLn6U2R44kzyxWVCmDVSA6WZ95LWBOs=;
        b=ihVzZiRnh8p2Aathllg1JmeZ2fwhDppPJsvFEQ+m1jo4uXsC5rHUb347aTpPFXMTYg
         DszujEEAQXMpYe613xN2csmXLwwTcYIyp5gKMRhWQBwt+8l5+Llb5k30j18FppsE2E6X
         aRxupmqXOuJCwV9OmQ/ym4S0AjHrBjitTgGs1k+L1/r5n0UivO2kusr/YTkQjPlCBZQL
         MaRXnLoVVRzosXuo67iLTdgLBE0zIe6bKd2s5L3rJteQOuy36wAefSS0pSWXF1RAY3Pf
         cf4HT3gapw86vULiS3x7XTernEV25ttCbbVuv15nLNdDnJ+FDBZsBolbKVOjOEHI0bx7
         mk3w==
X-Forwarded-Encrypted: i=1; AJvYcCUHs7+5vzQ4Pf/sq/fEN2tT8PrkcU8aEaFMcg/8yoeygH+nGGjtnTo+Zz2vJpLpTZA5C+7vNG/UYg==@kvack.org
X-Gm-Message-State: AOJu0YxjatZhdJz0UvvDkHCR+hOrg/NSDijfCYqaP4oyS7ghaZX31GCw
	4t1d6w9Xm2D6hoEcLPz8dMg/DDGGK3mNDX+AS17+CO/oR+8Ohi3X5EQ3omDV5OSGa80=
X-Gm-Gg: ASbGnctDcdcYuGKVTFirHxMjpp2VoUbBbhXFpDgtzQTkett5I7FqM8c4pYxlyciX+nB
	2b8l7k2fdnkAQtZ05XA7yOjSTOROIeYbZ4IbLWBPo77zkmKm+AiuwRNov/Ccwo4ogUqPw7WRGUD
	AUAwiQ1qtqogVoHfIHWSm1e2nXN3oPKcL54cacAhMagPd5Y+t9fzNWrcyQlZ3ci2dx7o7IUNN9A
	DKfInY2WlnDNJFtRcVzYxSfNsWkvzzRBAeBdyo3pcMS6zjf31Far+eA+sURKl1q/8Ncl2KarLjV
	qcdhXFEogAJCfGjWZmDmW957emswI1b+SUAVHvYCTe+IP+N1pRjC8s24QOK+mJXCWXvgqlglqc3
	fU+8EItbi2kQOdSbykw==
X-Google-Smtp-Source: AGHT+IEsfSWYzEm27/6hYdWM/oDoGohRgnAYiUKPUf3nioDnbrFIrjHT15QbOHRBbroPOGJoJGn1cw==
X-Received: by 2002:a5d:5d07:0:b0:3b7:9c28:f846 with SMTP id ffacd0b85a97d-3bb68fdd74dmr1040326f8f.44.1755248972964;
        Fri, 15 Aug 2025 02:09:32 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:32 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:12 +0200
Subject: [PATCH v5 10/15] pinctrl: make struct pinfunction a pointer in
 struct function_desc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-10-955de9fd91db@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5244;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=Zm7l0P8J/4Yr+ba9yWziUENeNgwa5VJWf6fQSuqhMVo=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk4VNy+wECbWRHhJLf/n6KmM7k5pMTn+IjYl
 fACs+Y2sDqJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75OAAKCRARpy6gFHHX
 clftEACGI8JVw0+vCqaEtPg8fs5gEye52amqNQ+hqsElotQX4ILlanV/h5UlgtnQXD3SlgDRZXG
 R0ZOxm67YO3xopC0fuXZCActBpEsfw90Im9j7Qfs49iLYZBfhGOmDMQ98UhyTgFj8dn41/hJFTg
 l/GxFa2m2JMeO/w9b4WcGOIqSyrH7YnS2WKF/Jn59zQEL5KyK2ABHvJtGkXGA60p7hLWR9OypY7
 N1vuOde0ZUENG4v9pvrF8pOGJgPkFMPUIXVLldJzBNddhq/oeUIVxQ95Ai7XpFJI8hL72/lDhet
 Ukev4jy2tdjT8P0iokwmmmmqWc2DwdZVS3L0r0XiFmpuNkBzMw4kN/MX8r7h3SwzCQIqcwm+Wq9
 u9XZlYInmGVv8uutXQXAcpfeoAwGX/Z/0TSXXfv3PqBv1OrLhjh5A76+2LP9DDIXQ5f6GbOZSfT
 yBmkcQ55JR3el5kmh6ERA+hNavWreMdGMPlKJz22TveXpEYYNewYTdmEj3UgU9umx/oSNJTc0td
 QsK9hPDHN2Hsy7XOIE3itRPQmpSAsmvqqLtTkPddAw9hDZHGYOIlHrMKGwJ2tRxPXZfx5aW61gb
 K4FYxpa0tFpMifiwQ+/QjF1/DMevhoHp5QxpD6M1fdZCkdqz0ytRi2NPfUIydhyefTZ+vMGzVFf
 vtagIeUSAxzJviQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: 4qa3791jkydjxbqyt6f39qbmzsjyjzxz
X-Rspam-User: 
X-Rspamd-Queue-Id: 7850840012
X-Rspamd-Server: rspam01
X-HE-Tag: 1755248974-688203
X-HE-Meta: U2FsdGVkX1+mH2HgWz9yJa3imT/saREyw+ZJRdU4rvVAFmLdk5tbLT81dl3hkL/Xkj1t9V29NPlY5NHgggBLsKpdRfjjq0WPkGr9CzVKr7jJmLU9e/4vnXKgb8UrCRGxGwR3GM8BfFTCZ5N3laf9vqgkxIdKeBhUsdOb+c6HXJqzzI7030zcTIeqlNKLVEozogeJJyViMgiGH6aG6cB5naSSGBZtN/avsep/eWJIPttND0SqxiAGwezWG+1fDNLNr9mL8YKyplFg8QjAx3ERCrFkrGe9Rai9k31qQ0hcmssqzPtKv4ugpqtSUXBa8x0K9S5s1nRm1j+7ePEI8ImZEzKQznmvHdHcIPP6BGfrwN3ck6C6TIcH8mBZFJLo4Tg44o0iYVlnKxRnqrxziVGbBt+rZBtQNSdXF0YL3z4jQNau81eTRl07pVr41HFRn4v9Dq5AZkbnX5xPWBhbq4HZCD/uJnvJCRRL6Tf995hhchDVCIE0RVvAexOl/IQiiW5ogjd1WzBK4j/rKEUmlfa5xeR9ZExClBvPidtbDsmP/LJWq250HRSsnl6cf38LT1Mz4BA+T839H/aiY4hqt96q3sjSS4l/Wdq3xLkbqHWguhsInQcoNlEIq72UOcUXUxgGEGl0GiDj119iR2B6h/FVNqydXCXpC80/TyBTpijrJE6ECvN7e68/yqksCG5wc6HJ8wfHzIUGqvJz8dQ568xDX3z61Qeo1vdsCWXSU5I+/3DAoVbcG8wTf4GoJ6fxHXO8/04gVJRVREKYmzSVO+0Cl4v6s1JOdVQnUvW0j2JtKu8a+iDb7Hc+sADG6lX8fHLrH2rF5VGD2GOg/MflMCgQXyXql2ecR9cyhgR4F3RNaDTj2mN0Gxgd1Qw8zF2TrtmRiTsvLvt0WmrikVxchAtZDVSMX/2ErJSpOh0Z99r00aevZJ/e64QjA709mYBoRK1mTFUw6ViWSlyhzPTx6I+
 YWZ0JdHM
 vG7p7UFc6KfZDz+NXCa+Z6+zjYEtdOSlghzIVgj4trKnLnjiLuGMku2iElhyTiPzV5jkId5JTZe0cSzkPMh2g7QFaw/MWsCb5kZNZDQCItSzTxK+k+kXfCxHXtZzrnm6EQlfxYAPtxCP1UXs/wbOr4U1dz0JhA3MG4EKjqyTclxC5vmbVdLsHF4VXlLpdshqUfE0TZlbVpbxRqehEqr5qos3Eg4CPUG7fAhI2f/Y4+y2dtmYfUVwvyg0K3k1e76dcndeejYYppFA9WQqdEzeFraTUT+hg9pI8BzBhAMm+fvaNu/+MtLUHSC2fLiKIo3jVA/wHqnJHpSjod9AJiJRehrvoVcGQ9vuPvnRMD8FIHeTPu5xtwhmsbe0B0d61NKT68sZ+cowPzNyRLj64S0MWiLLoss8YNXypMoKpmRJOtf2roIRu+Szf6N4CU/9uE/QyNFAWuIm3VrbWtHWipQ6MyW8C8+eiYpEq7QX0odnuwIcrVu89DRuIY9XFqTsDfNHeo+OcekIH1CJzUaf2PXTp0WEamifs0r8q3kozWv4hy6KuS90=
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


