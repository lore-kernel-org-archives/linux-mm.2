Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73C8CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613D4900238; Fri, 15 Aug 2025 05:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575968E0002; Fri, 15 Aug 2025 05:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355A9900238; Fri, 15 Aug 2025 05:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 198028E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DACC01A092E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:34 +0000 (UTC)
X-FDA: 83778418668.16.E4CB55F
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id CF19C140009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=FDX6YdiU
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248972; a=rsa-sha256;
	cv=none;
	b=A9rKeKk2jGaZgIK4/JybqfDkP22VKdoLFH8DRaEVpw/FgMSjUgkwS/0JVlP2e16qdh8rGv
	b88j9ZoeO4USZyi82FlcJB2CNeVq7ZIMrBt7VnnatqYq2lpQmaKEHW8MeU3dcwuOpR5s3m
	TWY14M/F8bWQ+p2tArBd/oZj1fioTWU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=FDX6YdiU;
	spf=none (imf26.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.45) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QW8G5G1H2ybez9wrKQXFpVaePk3UVjXlh/KwL+gB2lw=;
	b=v2OYJoaLjks8FxVZO4X6nTxlNz+TO6ZmNRR2oM4XSNTGY54IAdwvtolNHhQNTOgTM1bS8W
	Vj3h+FWJQ+4bjvQIG2nKLCGn+wBnFXxKeecHvq11flV3aGWPvlGlyrJBgdR/6lXi/oi2z1
	pWhom4Ssp/tOIhC3/SqChcau7ZXV92o=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b9e415a68fso1580973f8f.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248971; x=1755853771; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QW8G5G1H2ybez9wrKQXFpVaePk3UVjXlh/KwL+gB2lw=;
        b=FDX6YdiUuBb4+lXwOJjAqlw6aIaCeZcbkStiPy2hacucc4UmdyZmpy7osKIU/iLPv2
         VUVoh1D6JiYBvAmQEeczhtW4mu9dxWA3NWhmgVQloX+i60uSFPTFMohoAoXyFq1JBmwA
         BfrSJEUeCPf/dpz1GcBeKNbgTxFUR4nITluM4F1K5VxLD85TSgt09JXOjenkPMc245iW
         HaSAvfm++D6+/Wa/wIcEKr+dyhP1z57hrct/FIRKmpTltQzrK9G6F+2ISWltVnF/EcKT
         cJwkN2jAf1ixxa+m0JGyvfO/zX5ts0FjFVYAUAeUw8Y2faMj4DaZjt9jwk3hfE08mVco
         gsXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248971; x=1755853771;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QW8G5G1H2ybez9wrKQXFpVaePk3UVjXlh/KwL+gB2lw=;
        b=lJQNhXOsYfcj2CUkTt+MT5ZE4/Ehz9ihwH6bEX0V1t8hGk4DfowHrM/K5u81zI8XTI
         J0g//eGw8dUlZQnmPvO4cvW9OAu8bkV+1EUdaCdjyt6T2GFkZ2u4WAzy9tsjQbO4faQG
         oAK/UFsTy/kUfWuMnhVTfx7I1nYuY6uMukL5JQaicrqljcXDJcnmvYMNW/SBQitHZTjj
         15VHnggEYV7MCB2FlVCgIfFA7ElurRRIV1fgR9ikvgbiHnAqXAm3h3IqIQGAHMmdqB2o
         NHO1730F6vL9CTH/QN2ySLPMGOU1kS2D2VjF3KraygExeo02Faky19hMzjfd3Wa8ODxs
         uiEg==
X-Forwarded-Encrypted: i=1; AJvYcCV61A4YWRIXuNTz5MvakauaDag3rf81763vx6syHioxtiy+8YrUXZ7oL7xn8zT5zStyMXrtG9plrA==@kvack.org
X-Gm-Message-State: AOJu0Yy3NI0chJRxG2qmSRkcFwA6hiH/eiYFnSMgMYEcRWyktF4yubbY
	XHNpKiGxK+4ac0J5nYxRzit8gMZ0ktBSnxGkPLUiAgdwlQ96hIWDx9a8MPR2sRzKyk8=
X-Gm-Gg: ASbGncv/2LIkU1w+t5H3TzpRa3Bat3/vtb4KAuT4SQZZDxeebYZyEEv1aBcyRH9kM3f
	m985TxkhcTMc/a7PWsEVJsm3DgRU8hJj49fxGByg1w8cTKq+z4pC7zd3A7nq9gbsODBMffyPJ3T
	n/Chtk122x20YkZbhc8a3xcMPEiDvR6vNKqMA2OaEASgg5zmbA560I1nQqFLr+8O19Vb5dl3TKI
	2gSmP9+uiJsB1F929DVbipVVsm/OgToTsmL16eQRrKIJyo2R7SUsGXhNQo8vSDvZi3IJCOfy+uQ
	U+WHdO6hn2dE4K1TH4TbfQOPrV8Jl+CwJcjSsgr7U3uoBqRMLgHLkXBT9cNC6AZZqzHw6bfWHpn
	he+i8Yvcu5sJo/XlDp71nUaTHMNIV
X-Google-Smtp-Source: AGHT+IFQGbRD7fG0xjh2XOA4+EesumD3/X4bl3aQfW+iqbi4ghnXZs2pTYkzxux1uUzECfDu9aBSYA==
X-Received: by 2002:a05:6000:4210:b0:3a3:65b5:51d7 with SMTP id ffacd0b85a97d-3bb674dc785mr974491f8f.26.1755248971296;
        Fri, 15 Aug 2025 02:09:31 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:30 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:11 +0200
Subject: [PATCH v5 09/15] pinctrl: constify pinmux_generic_get_function()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-9-955de9fd91db@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9697;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=UByWc+6pSbPCWlljoVLrx6QfiZfsvHjFY4UzBR5pADI=;
 b=kA0DAAoBEacuoBRx13IByyZiAGie+TiiFA5/OJCugzJFOrsxs1/xaWeeHAbTT6hLabdeMNTK7
 4kCMwQAAQoAHRYhBBad62wLw8RgE9LHnxGnLqAUcddyBQJonvk4AAoJEBGnLqAUcddy5vwQAMVk
 Raphx6lRZtMwLk8PBZZiutIWdZD/etJKVPxsFTW/C0QOe4YvZPQnzgANdxTzmirkZ7w6kNcM5Bs
 nXsXQ/NqipaZtdBEpaxeegDx0/Qj8awBgbOy1QYqKDHhISdiM8Q58HO9oczSlcmgWVhmEyycmyO
 0Xq/3RGp2M+PVPvUEl4TwdKbK04WcGdLY/WaKOGXxGiBr5L9crPOc4/ReId/YEU3We9pQdcWqFu
 tpw589vsmdHpHSETzm6MetSL9Aq28hT7x4xRjb05vIes3mNG72gRAJoNpjaKY2fhIpyNj8dsiOY
 H9kcfygNMqFKCqleCB7d3iF+9OarB8ChpWtNb4f0tIMKYyuaLlEiVlpjPXlfOF3DUMSDsdsVVZI
 hzLfPlBLzWG8dhOOPMOnQqK+0G8M2CRV11PmDywsFQuGjLWAS9qj19Lgq7dUu+hHc0WpUXz4S/o
 H+WBLejtgFnbCaWiKjVL3AhflItbG66K8dUeRv2UBvqB9csKWDp1IhHlDpQvXRz/GMRLqBAzuOD
 6iPD0hPIds1aHc55iHwDpaNUDwQzjZiz3OVrmjCeo6fzO8n9KyXWfPzrOs0QEMABelsZ4ZmBNSu
 obUfZJUy7EGiwXwXsdgncdtUDvhR845cg7rkuNf6ZFIDAazHWRkbMt/veOyKccTCLCyAB8j/z1A
 wD1AN
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF19C140009
X-Stat-Signature: 8bk6h7jrta3bcskhre6i41ee6uiwdju6
X-Rspam-User: 
X-HE-Tag: 1755248972-269285
X-HE-Meta: U2FsdGVkX18cN2PzEcIf9YiOK2Lt4+QdOfWQpv4D2tigl9ief5WT+L9y0TS7H3HTiWa5XdrEqN16phyEWjI5eecY6ZcDBwxlTnV0p0AMmZiAZXGrMB9IjCyyanxr0ESFGWJDSNu1eb/k/iLq3Hh6QepVqy50JHAe57i/dDzWRvwF227eNnSXQLQipJPBG+Md2x3z2EXd2F9VxB6Vn8b/BrGXN34ZBf5LFlDBmOrhNouchPp26Bc0dsP0IPNlHmfSsELbvvo4r2MFLsJ9pWwn6BQf37QNzh5s6x5FPwaNIP2fbAyPCGKnp40HZjJwc7YcXccL6QLZ7FoCkSnVHwUWUNao41tAbd9lUeYTTfW6Jb6mR0hmmr2LZLgwQs+OtaPZ7Qskh4P+SPhwIhD6l9ZRF4w1nyjqE7HFm85Q47xQh1hOwuY3eBa4EHyfF6LOJRFWcRplqM191fenDP+z6XjMJpcaJ88tfyGbJD1myuHT3RLxBfBkUe6yjjzqNvxmPSfHodMhess84IqYueJzxoScJWmPvtXwwogDw4JWGzUSvi9f6lzttpsUuw2tsmlp9EJh9JYbawQ9OP7gbUwansAhODUNk61Uh60jktGBC/l2gbtzZH/Y42mZRlUrlhXHsaA2A3gSMlZesE8vj1qgRzxS19U4lpm7iXIwDIsJR1nWISm2Vnh/3CbJOIL6d4/o6qCOhDjcG4NzIAsmgL8Ukk7HkIkdwDtbYVVlHJ2952oLrqIsrtVQ5svBpPm+kjwhHjwgtJcNl7WIvN78fSKNQia6xeOj8kd+RwWRYAAOKDm8DLBIY8HBSUQe0tbwj4r4cB+U4IEE+Q3VLH39oEW8IVIwtHlZe8RdTObDYr5J8a9IaLlulmsBdgLuQIUbnXUr5Q2BdEifJ++jfyJ71ZVbVVpvLURnyfg7vaC0r1k5gsCBSNieZqkEdKaAm5XduKXIjY7ac6tQ2WH6krkJ8bDEVB5
 rrrU8yjt
 5rteBntRI+VDZlk4LOCl9rE+TrrwcbRJaZCrIgyVoO9Ae4bC41IFngRrA7GBDVueDyUNLAqp7+ymqXXOGNO9cNO0RRM6G1BIaaLszZv7HErfBxNVXrVEM/p6/vWA8jiT9nKRPFNrtdgJ2wSd/1C3GQ1haepx4eHzcXLKimCtC7/3bdSxEaXVaXuKTnGgpAnEzpphFFgoS8nri9JNTg1trPHTZwATkDKnOHeE/EjsOYTt1UWgmlThIJstYNCe7xAVpELJOX0P2zELuw0wMUif/T2CKGBu6AHj2cUJkU+4dwc7wJPUuXD1ncYXoqucSwxGTthxqfOjdJBhrVekkfLF57w0qsNGUs1rieTZlrlJpNalG6qXFXsp4EBJqtvJYTxPzySV4F8GVQzeUq4XCE1yqvsR/18qPDcoXo11on1DMUc90YPAKwZuge4f7Z+QgfiNQUAC7D5bfGqMtBWRzX3Uc7nqXZ56lnZMj/NcjwLAwc/mr3y4mRAp4lhQiz3StIsN/4jeHLiltRCQKCB6AL+524s4djVh4DHb288R/ovp9zu/uRD/lBfCuoQOz/7y11At8xt3k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

With all users of struct function_desc limited to only accessing it using
the dedicated function and never modifying it, we can now constify the
return value of pinmux_generic_get_function() treewide.

Reviewed-by: Andy Shevchenko <andy@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be> # renesas
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be> # renesas
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/freescale/pinctrl-imx.c   | 2 +-
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 +-
 drivers/pinctrl/mediatek/pinctrl-moore.c  | 2 +-
 drivers/pinctrl/pinctrl-equilibrium.c     | 2 +-
 drivers/pinctrl/pinctrl-ingenic.c         | 2 +-
 drivers/pinctrl/pinctrl-keembay.c         | 2 +-
 drivers/pinctrl/pinctrl-single.c          | 4 ++--
 drivers/pinctrl/pinmux.c                  | 4 ++--
 drivers/pinctrl/pinmux.h                  | 4 ++--
 drivers/pinctrl/renesas/pinctrl-rza1.c    | 2 +-
 drivers/pinctrl/renesas/pinctrl-rza2.c    | 2 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c   | 2 +-
 drivers/pinctrl/renesas/pinctrl-rzv2m.c   | 2 +-
 13 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index d5d42c9ad5fe9dcf7c25ad393688e714b02db678..9ed84479a5b43871861f46fe1326f1dfadc7f63c 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -245,7 +245,7 @@ static int imx_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
 {
 	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
 	const struct imx_pinctrl_soc_info *info = ipctl->info;
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	struct imx_pin *pin;
 	unsigned int npins;
diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index eb6cd27955fbe462f479fbe92c785588caee5ebd..2eed83f9f209cad79580082c274d4056231bd421 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -2443,7 +2443,7 @@ static int airoha_pinmux_set_mux(struct pinctrl_dev *pctrl_dev,
 {
 	struct airoha_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctrl_dev);
 	const struct airoha_pinctrl_func *func;
-	struct function_desc *desc;
+	const struct function_desc *desc;
 	struct group_desc *grp;
 	int i;
 
diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.c b/drivers/pinctrl/mediatek/pinctrl-moore.c
index 982b9887521d036538f67e9919de444693c458c0..17a08c73423fd089066e4894d2307c852bbbb661 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -43,7 +43,7 @@ static int mtk_pinmux_set_mux(struct pinctrl_dev *pctldev,
 			      unsigned int selector, unsigned int group)
 {
 	struct mtk_pinctrl *hw = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	int i, err;
 
diff --git a/drivers/pinctrl/pinctrl-equilibrium.c b/drivers/pinctrl/pinctrl-equilibrium.c
index fce804d42e7d7f9233b2da0fb26e482170629424..18f0da58c96d4f0fad6535fd88e69fc8acf96a94 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -319,7 +319,7 @@ static int eqbr_pinmux_set_mux(struct pinctrl_dev *pctldev,
 			       unsigned int selector, unsigned int group)
 {
 	struct eqbr_pinctrl_drv_data *pctl = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	unsigned int *pinmux;
 	int i;
diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index af9d2f3081859bc4b22f6820f3b3753eba36f959..e13ef07850386e70cffc83011589ceaf70a70a41 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -4000,7 +4000,7 @@ static int ingenic_pinmux_set_mux(struct pinctrl_dev *pctldev,
 		unsigned int selector, unsigned int group)
 {
 	struct ingenic_pinctrl *jzpc = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	unsigned int i;
 	uintptr_t mode;
diff --git a/drivers/pinctrl/pinctrl-keembay.c b/drivers/pinctrl/pinctrl-keembay.c
index e78c8b3ec245aad56e3e74a26d27c41ba4a98281..30122ca90cbef141ec456ca39ab4eb6f8bc334c5 100644
--- a/drivers/pinctrl/pinctrl-keembay.c
+++ b/drivers/pinctrl/pinctrl-keembay.c
@@ -935,7 +935,7 @@ static int keembay_set_mux(struct pinctrl_dev *pctldev, unsigned int fun_sel,
 			   unsigned int grp_sel)
 {
 	struct keembay_pinctrl *kpc = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	unsigned int val;
 	u8 pin_mode;
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 5cda6201b60f53e62f3f50b8641ec894106111e0..c9adf5fcb1c76445d4812de449edf09878771a46 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -336,7 +336,7 @@ static int pcs_get_function(struct pinctrl_dev *pctldev, unsigned pin,
 	struct pcs_device *pcs = pinctrl_dev_get_drvdata(pctldev);
 	struct pin_desc *pdesc = pin_desc_get(pctldev, pin);
 	const struct pinctrl_setting_mux *setting;
-	struct function_desc *function;
+	const struct function_desc *function;
 	unsigned fselector;
 
 	/* If pin is not described in DTS & enabled, mux_setting is NULL. */
@@ -360,7 +360,7 @@ static int pcs_set_mux(struct pinctrl_dev *pctldev, unsigned fselector,
 	unsigned group)
 {
 	struct pcs_device *pcs;
-	struct function_desc *function;
+	const struct function_desc *function;
 	struct pcs_function *func;
 	int i;
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 79814758a084570adea0ea1a3151d186f65d1d1f..62bd4aa53b2b22cb09eacfb05398205f2fe391b9 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -847,8 +847,8 @@ EXPORT_SYMBOL_GPL(pinmux_generic_get_function_groups);
  * @pctldev: pin controller device
  * @selector: function number
  */
-struct function_desc *pinmux_generic_get_function(struct pinctrl_dev *pctldev,
-						  unsigned int selector)
+const struct function_desc *
+pinmux_generic_get_function(struct pinctrl_dev *pctldev, unsigned int selector)
 {
 	struct function_desc *function;
 
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index bdb5be1a636ead9695410824b5557937c5baa89a..549ab10f7afbda32fadf4ad151401180bed2064f 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -152,8 +152,8 @@ int pinmux_generic_get_function_groups(struct pinctrl_dev *pctldev,
 				       const char * const **groups,
 				       unsigned int * const ngroups);
 
-struct function_desc *pinmux_generic_get_function(struct pinctrl_dev *pctldev,
-						  unsigned int selector);
+const struct function_desc *
+pinmux_generic_get_function(struct pinctrl_dev *pctldev, unsigned int selector);
 
 int pinmux_generic_add_function(struct pinctrl_dev *pctldev,
 				const char *name,
diff --git a/drivers/pinctrl/renesas/pinctrl-rza1.c b/drivers/pinctrl/renesas/pinctrl-rza1.c
index 23812116ef42682d8ef667525d4f4486c286b46a..70f22e0ef307a02d5b11d6626d297a619f5b82e9 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza1.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza1.c
@@ -1120,7 +1120,7 @@ static int rza1_set_mux(struct pinctrl_dev *pctldev, unsigned int selector,
 {
 	struct rza1_pinctrl *rza1_pctl = pinctrl_dev_get_drvdata(pctldev);
 	struct rza1_mux_conf *mux_confs;
-	struct function_desc *func;
+	const struct function_desc *func;
 	struct group_desc *grp;
 	int i;
 
diff --git a/drivers/pinctrl/renesas/pinctrl-rza2.c b/drivers/pinctrl/renesas/pinctrl-rza2.c
index b78b5b4ec5afd9879373b406e0b8c391912a200d..29a9db19759906598ac55694439cff8a5ec2c8aa 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza2.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza2.c
@@ -442,7 +442,7 @@ static int rza2_set_mux(struct pinctrl_dev *pctldev, unsigned int selector,
 			unsigned int group)
 {
 	struct rza2_pinctrl_priv *priv = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	unsigned int i, *psel_val;
 	struct group_desc *grp;
 
diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index c52263c2a7b093fccdb38e44ff3fbba0a86d4def..a9bcb3d7c45c269046df0a7d0088a1f48d089fd0 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -549,7 +549,7 @@ static int rzg2l_pinctrl_set_mux(struct pinctrl_dev *pctldev,
 {
 	struct rzg2l_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 	const struct rzg2l_hwcfg *hwcfg = pctrl->data->hwcfg;
-	struct function_desc *func;
+	const struct function_desc *func;
 	unsigned int i, *psel_val;
 	struct group_desc *group;
 	const unsigned int *pins;
diff --git a/drivers/pinctrl/renesas/pinctrl-rzv2m.c b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
index daaa986d994dac15860d328c81e28e2c9e678120..dce68f93d2d57f6a6c9b1bf9e1db27393ece8e44 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzv2m.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
@@ -162,7 +162,7 @@ static int rzv2m_pinctrl_set_mux(struct pinctrl_dev *pctldev,
 				 unsigned int group_selector)
 {
 	struct rzv2m_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
-	struct function_desc *func;
+	const struct function_desc *func;
 	unsigned int i, *psel_val;
 	struct group_desc *group;
 	const unsigned int *pins;

-- 
2.48.1


