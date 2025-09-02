Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B993CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793748E001F; Tue,  2 Sep 2025 07:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4E88E0001; Tue,  2 Sep 2025 07:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547818E001F; Tue,  2 Sep 2025 07:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3558D8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05D65866A8
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:43 +0000 (UTC)
X-FDA: 83844165846.10.86E7678
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id E186B40015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=zkQNipEQ
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814381; a=rsa-sha256;
	cv=none;
	b=BZy2UuJSicpv2m4nSRELoUuA7HY7s4H46j1PM4qUAf4MFFh8P54idhZCJaMqMjBXBqaWs1
	UdMt/upIQSSGK+AffNh/hrqV3agj4MPo387lIwHi7l3OGmPm0CQflX79TGKhTTSxPks3gq
	wljfiYHh9QAswFTwiwJI4hZHwbesOJU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=zkQNipEQ;
	dmarc=none;
	spf=none (imf01.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.49) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEWsVeKHUC/dAllw2aDUrg7lMLZ7DefoZuk24jUoBho=;
	b=b3/v/vrYGPxL26YCjp04EkikvpuJfP2TxdpbHcBqpNKs9BgmJAXLh/Wp4ewrbvGZWOKbNv
	DtLP0b5KypoB3LY1Ssosu0o2reNULpMgOiBCS4NnxjFldIkY3guI47/EJaDujCJatbeawg
	1fkJ8aF68VF+06cVMN0JFsfhheWESmI=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3d0b6008a8bso2043304f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814379; x=1757419179; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tEWsVeKHUC/dAllw2aDUrg7lMLZ7DefoZuk24jUoBho=;
        b=zkQNipEQvxJACTIp7NgH1z7Ks7WPCpmIbLNAevkitVoOhC+4oBIBQ/hltHpqN2DfxI
         eY+K21AXCIhX0svjskiO2LQINRek4hcXhPpBxC+hV6s7o3mMXNIETncTcC0xiEVdjgJF
         jUmIax4iy5vJtcOU3GGF/0ofMg1bBuMcZm970p1WjY0FVLQspIK37LL4uvAfNxmhu0Af
         b6pwIny+EHZNkKWTuSvXiRECo+Dif+s2YR5tkieOJUn1fa+vf8kxz49h+VxQN325LE+c
         hi81axc1SC0sBOh/huz8ATrYdqfNUQdicBa/c4iJp0I8xs9+UmRN1bBHjOD+bK41jGoG
         lWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814379; x=1757419179;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tEWsVeKHUC/dAllw2aDUrg7lMLZ7DefoZuk24jUoBho=;
        b=wYwmXQQ8bcwVIIyTc/o5BMT/GMAP5zHFEyJ1IuV9ABW+g9bosd4ga9XRa1r3H3zVuk
         a4/0LGqBHmhEuTiUY3pH6AIlrUPbvGtT6LkxRdwWLZHH40yP90g92AeipR7VUEcFoU6b
         HryhTTDzrbv7hFn1ihewcFJ0o5iGQOcrXbk/RD6KnDvxmTPibZt2wzYxxUF+gW7qZfPP
         PIdzMhLDuiUsXYJhWZh2IPJpTWAh7FftMEh2443lXBS3Ta8RSuRPW1A/H/oWalEEIQcu
         HUpFm3yyDGva3Bc5ncW1Ft8jAzsXeiDghJFkA8CeVnYtTUrMzwQS/wZ/4Ne27JJFzQAJ
         ln/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUipLjLuKEAy8HKRx6BmXgxEWxV87AVDXGDTV5FD/yeBjD7fp4+cHIKJnfBhYcYdlXrCVJnrVkPcA==@kvack.org
X-Gm-Message-State: AOJu0YzdKeb3tM1LJeqRWXJ++u92xi4F2zB34seSIjbnHRmsEV4slRVS
	CnAWIdQ1vcM33O+wgjUtb5lmR1GgWGnpnXBOplAsY6oXbvGKevNTwcJolSzYwT2Cm5M=
X-Gm-Gg: ASbGnctFZGyFIQR5v9QnnUjgBPrAM3jVBwso8PWuEg76kq7mB2c3GyR/o0lySR5WLI0
	m9Vd8LMShQ4r4uR2Jrfi5vX3XcteZVnWU8XI88DiLoKwrNzDWZoQVgoV19rH1udghOZKF2Vm76H
	hGGq1VQum+ywNF03pqnaFrkyojf+htHoaCuKDZOdXlc+Flsk0RcP7yDfxiX07xlH224YR5BpCV+
	eX8ZilKD4ndzOtbYzucwqC13IM3UJbBVjs70GJFNxKdxRaPpZhvngEUi5Wb50GM26c8FS5LgU3w
	52QngqbDKuSpATnQyBLkHkYAnvkJt8oZ4SlMgJCWyk2WazDEHm0c6rf7dyUwi5NiqN1xw/ubfoL
	Xmv9kEcBeBOudhVZua7truOquob0=
X-Google-Smtp-Source: AGHT+IFbemdBZVr4cSqFDknoZOXx6G9gv7/Y0ZwIrtmRmycK6XluzE7F7aIjOJthCpOln2BXwIsUdA==
X-Received: by 2002:a5d:5c84:0:b0:3d1:6d7a:ab19 with SMTP id ffacd0b85a97d-3d1de2c6bc9mr8102151f8f.20.1756814379349;
        Tue, 02 Sep 2025 04:59:39 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:38 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:21 +0200
Subject: [PATCH v7 12/16] pinctrl: qcom: use generic pin function helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-12-bb091daedc52@linaro.org>
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
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3806;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=32Zcb9hfB+ZeJyoy3uwQecPB9Xyi4ZVd3B+L7ZvFZiY=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwUCgQZBmoTxlTrj8gjD6XedHkrbIupwH0/A
 aWSRMyfc9OJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcFAAKCRARpy6gFHHX
 ciHxEACSn9uq6GCoE4OW0AyeoZN7IZ7Lwnvcc5CVALJn3LNwLkXQJla95ogJxXNn6INZUSqnzyZ
 sAv2J4r1nBu6cWS1jCNcbRwgOsUxCD7DOij9DTVk8vVeuUiyb3/nBCtlDSiKX+I+EJ6UBXABrJP
 2ulvPkXnmvHPxoFGDEuoV7ZOvRno5o2gmZUIT0hafWB6etSbvtGLzxA4akcilCxSVle3PTU7OoZ
 rJ8ecXISPikzFtKVSa8iwGbopUmzdfdyaqHjdni8ExsDN8TyDcZLKAkiWHxe+Wn+ovT37ULrXwY
 URy0PXM8ZdNugKFa87z/9zRKbtpRbfznmQOJUMdHJRA/3Ws1XTiF3r7m1C3mAvhJJki+yp8n8ns
 eekmGbBOSMUH+0H6ap2CxYRgxlOFFIARsBHSIK1O4ci5efShHfePBz1yk0YTqE0lMMxwIMBS9OW
 2ww1g3NSRKBROCGTk2V6dGLcOIKnRJgSX6OYWcbmQaifc54U1l44/0nmUnQFfIW8yZepxvX5WZr
 TMbqscKrQY9wJyUsRY/9W7iq0Cs9ZRlfqGO/8OWJ8flLXdJXpeZsEkmsdB6GYbixZ1cdyNpfVd7
 6AZzJLar5yCrsfEiPgfaRWSe/izLz5B8B2bE7q4Js+qhiJKPopM8A0/rJP6mJC4aBWYqvqM/qXZ
 qANi8Fe+TNoz+zA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: E186B40015
X-Stat-Signature: 74oq4h6d46q3yurg91snbczu7qdfa4me
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756814380-503774
X-HE-Meta: U2FsdGVkX184vnAVba2248H/vrXMrC1d9LNGXRfmKecnOL6XolkpIp+4leU6HMZYcEb3WjBX3Q2gyfMqULXi99DA9JS4hje2/WyfbuvjnaAjS/9tjHNLQJ/reNuYlSrb3RayOUdgS49TuKsxSDE5vgOHpFkpq0/Zx8xwGcHhFdxpE/arfXRQrb6tKHPlzMY+dvoqcVElupwf/lh9v2eAYR4TFBE6iEJVRdLvPdiqEl8GYdFItc4TumhtuK1XyOdUeN4kvAsHtm4Pk9qijfwaoUp9AHDOkw7j4l7bgFUT5HWXWseL9abwDq1PBbbJVdzwztkMwry1azpr+MsTHAaYHx3hF5Aehb1S1mO4LiD+ybpHWe93yY0pP1VEO/0LBi3g6Ox67IuQ84cFlm33tHJwaUakYVKGRenIHdh3dWEhGjQ2l4z9b9ZO7tMoXNvsim+18grRf1ihUzJ4gn2VDaE3lxzZlF03mP4hmxeTiMn92+Y6V8F2jtf6AaDFmw0/aUsgRwAvjRItiptsMKCMDbGAbX3yWDGdw+MDGd+godCsBlbv4k9LSdmkaOH9fWrGrFtRYBjhl93WAhTFWV4wXAwb42DDO9lVfiO5VuowngslGE9Q7Gf6vGV4ZexpkdS9N52LlWt8D/s1D9cYgmw78FA7aaluSIuWrXTzbmTu84aELkog2dtsLKs+zVfSuUqLgnAe1iZRzYg3whN7J7OoLYt2oFP939Uoz6akQ0MO+mLY/fBpyHMYzDENWkdXd81daBOLqU8BoENlSTcsAOaILcn/D3LoAglutebu5MTCmuqA1caDEEddWztsnnZXqCVKyDe4XjJWVacj584ahP0hk6FYRJHJBzZp3x/n5PBOYu5grtl19+IvcHMxvxAkMT1hgaLZb6TV0P9GPO+7x9ZorY28ali9Px4tLZm4tVfh+RvgSerI+mkxcTusVUg1zX/6H+HrQmNIoDiX0bQA4BSqQx2
 WJJBYxkq
 u19T7JFvLijqMEw9FaxPHiCkwCLmYk5111iAJbtxSEvaQKFiFlNZPuHNKHj6j9fNKzAhVGE0HMuSdTnMvKTW4oeR0ZnTlk9hLeWOxOsGgJgaUZH0CuqlteAIRsmvOtIEhz9UeSPHCe9/hmT3VP42QGZAQv0Ys1mRzYXh9bDlVsuknhAtLUbs+qU67mRSfQNon0jsuMx7M1IyXy9BDMRPF6fL6GjdgCEYs5HoNGWP3epWChhHbe9kWS5E7FHXRee0YJ6gGkxRtZ/GC59SWjeWMNZo3EFsKeS3l9ROMg8GfNL6l3un0zj0AHzVsxhQKFVexHeoJ/8Efq1r41sk/jyb+GbztZKmVoKLwz/SQZcYwsoVc7sRgUufMlxVEkwjzqg4b//NJziJrTp+dTH48luurVb8vXFLf8reJIjIwXZbq35PD94bAJ48f771C68iSsv/9JSb8fq0tbQamshg7dB/lRjoLRwSb2LDOgIFGIl+qM8K0wYpy9cj9uNUAIrGFQOHbFbd5L4DREPurkjSnmZ1VKWbp0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

With the pinmux core no longer duplicating memory used to store the
struct pinfunction objects in .rodata, we can now use the existing
infrastructure for storing and looking up pin functions in qualcomm
drivers. Remove hand-crafted callbacks.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/qcom/Kconfig       |  1 +
 drivers/pinctrl/qcom/pinctrl-msm.c | 43 ++++++++++++--------------------------
 2 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/pinctrl/qcom/Kconfig b/drivers/pinctrl/qcom/Kconfig
index dd9bbe8f3e11c37418d2143b33c21eeea10d456b..f7594de4b1e9b95458c2c817e1158026a8006f64 100644
--- a/drivers/pinctrl/qcom/Kconfig
+++ b/drivers/pinctrl/qcom/Kconfig
@@ -8,6 +8,7 @@ config PINCTRL_MSM
 	depends on OF
 	select QCOM_SCM
 	select PINMUX
+	select GENERIC_PINMUX_FUNCTIONS
 	select PINCONF
 	select GENERIC_PINCONF
 	select GPIOLIB_IRQCHIP
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 83eb075b6bfa1728137e47741740fda78046514b..96e40c2342bdedb8857629e503897f171a80e579 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -31,6 +31,7 @@
 #include "../core.h"
 #include "../pinconf.h"
 #include "../pinctrl-utils.h"
+#include "../pinmux.h"
 
 #include "pinctrl-msm.h"
 
@@ -150,33 +151,6 @@ static int msm_pinmux_request(struct pinctrl_dev *pctldev, unsigned offset)
 	return gpiochip_line_is_valid(chip, offset) ? 0 : -EINVAL;
 }
 
-static int msm_get_functions_count(struct pinctrl_dev *pctldev)
-{
-	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
-
-	return pctrl->soc->nfunctions;
-}
-
-static const char *msm_get_function_name(struct pinctrl_dev *pctldev,
-					 unsigned function)
-{
-	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
-
-	return pctrl->soc->functions[function].name;
-}
-
-static int msm_get_function_groups(struct pinctrl_dev *pctldev,
-				   unsigned function,
-				   const char * const **groups,
-				   unsigned * const num_groups)
-{
-	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
-
-	*groups = pctrl->soc->functions[function].groups;
-	*num_groups = pctrl->soc->functions[function].ngroups;
-	return 0;
-}
-
 static int msm_pinmux_set_mux(struct pinctrl_dev *pctldev,
 			      unsigned function,
 			      unsigned group)
@@ -288,9 +262,9 @@ static int msm_pinmux_request_gpio(struct pinctrl_dev *pctldev,
 
 static const struct pinmux_ops msm_pinmux_ops = {
 	.request		= msm_pinmux_request,
-	.get_functions_count	= msm_get_functions_count,
-	.get_function_name	= msm_get_function_name,
-	.get_function_groups	= msm_get_function_groups,
+	.get_functions_count	= pinmux_generic_get_function_count,
+	.get_function_name	= pinmux_generic_get_function_name,
+	.get_function_groups	= pinmux_generic_get_function_groups,
 	.gpio_request_enable	= msm_pinmux_request_gpio,
 	.set_mux		= msm_pinmux_set_mux,
 };
@@ -1552,6 +1526,7 @@ EXPORT_SYMBOL(msm_pinctrl_dev_pm_ops);
 int msm_pinctrl_probe(struct platform_device *pdev,
 		      const struct msm_pinctrl_soc_data *soc_data)
 {
+	const struct pinfunction *func;
 	struct msm_pinctrl *pctrl;
 	struct resource *res;
 	int ret;
@@ -1606,6 +1581,14 @@ int msm_pinctrl_probe(struct platform_device *pdev,
 		return PTR_ERR(pctrl->pctrl);
 	}
 
+	for (i = 0; i < soc_data->nfunctions; i++) {
+		func = &soc_data->functions[i];
+
+		ret = pinmux_generic_add_pinfunction(pctrl->pctrl, func, NULL);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = msm_gpio_init(pctrl);
 	if (ret)
 		return ret;

-- 
2.48.1


