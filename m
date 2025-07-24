Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC93C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868F48E0064; Thu, 24 Jul 2025 05:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840048E0051; Thu, 24 Jul 2025 05:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756308E0064; Thu, 24 Jul 2025 05:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CAA18E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:25:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BCB11DA2A7
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:25:00 +0000 (UTC)
X-FDA: 83698623960.22.A520444
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 24BC82000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=lMfFSaow
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zi2TjXbns/ZB5tY+tLJCSU3ZnVzRbewv2i116bdMct4=;
	b=rUgc+QYhGXLuorlKiaxnobLjzD/mOIzW9VKmzpHssub/Qwnw2CVSo7KpXudMvpNGGA2/jm
	Ci1PrQd1PhL69yFhBORyITTs6Cxq6gUAEgwjcENBczKu1OoDzYPkPvfuL0DGS1MNP3tm69
	xqrprx1cUQvrMpyV6rhOlhShq0fwSSQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=lMfFSaow;
	spf=none (imf13.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.42) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349098; a=rsa-sha256;
	cv=none;
	b=E0H6hPDLvFI9xiCbtUWgle7hsKzoOHaSoGP2zBB11c+6p+p8rWR5YvFUvMaBZjU/oSEzr3
	NePYA9NI8kOr1R78/OQkT6TKtXIRwHbo2barjWcusXx6+evJm8WBY8F3fh3eahwEiT3pyg
	UW3LJMxxqJrGwanVuep+vvYBWr/cjEA=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a50fc7ac4dso356972f8f.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349097; x=1753953897; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zi2TjXbns/ZB5tY+tLJCSU3ZnVzRbewv2i116bdMct4=;
        b=lMfFSaowsF53W7NKtL2bS1RFHrd7jDa3RV8lW3YHVyTOzV5IMnF8rH3m3OHYh1drZk
         SHFV+IlX2edWP8r/VIjG8FOvBKn3kGWu+dW3aq+IMXeSW/VwWB0zKJVGapOAQUOwDF4Y
         rRk5OaLoIK6CecDGGEhSQAcV3dAsXNDLb7ZaQkNWH2bQvUle6yRRcWvKiyNmgFafkFLZ
         PGaft3AWQFTWf+FMZCsvzYHZgLKfUskeDhouoFSIzwtjrESQpHUkbdKk+W96JGdia/Zj
         Out2etEM7ZD7elxMKmjvjhEegFJjvjRuZfB8aez0rHdf7Ihqvi6T17HPpyD7sJNalmrR
         Tn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349097; x=1753953897;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zi2TjXbns/ZB5tY+tLJCSU3ZnVzRbewv2i116bdMct4=;
        b=nk5gOeSQwSOx/YrKZ5XoeOVxjz1g4AvYwi+fCAOSpWKLWKweIcqcfS71DUlUr8awoZ
         xFHOzhLHci49PD3umWRXuKLSYeCzJiv67bgEuIt8mrQZBQX6jIwSREu3NmeSBR6rtjMC
         9203Yo4D9wqDAWhEyYYn1SUVR37AYa+ztSvHzXKUrXx3aKk3Sk14i9IoY5yntOL1sCU2
         Z7NqigZA3gNVVHJKVnh2UQArjgu7uzsdYaVPgwq0DkbhRQREtBzWp4cgkWmiE1XgsUhG
         MV923xJTPT4n9jsVNTexoDBmZFOxda6NzJmgLSKw5Z4kQphfja1SEo/8o1svYDwH8FVl
         x9JQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCT9pgS57Qs1t9Hnmb2a7hK6cV63KtWFhiYn5MT7VBFmdy93AejXZgYlEzUjNvOpvBQBYUN2F2nQ==@kvack.org
X-Gm-Message-State: AOJu0YyitTRtIhs+iFQUtdzxNL9VROXDS0OKQjiod/j7F2ZLM0Og1Bwp
	ucCVkwknnqjXMA0PXcxDa+WQDfHctJgNg7w+uEwX84qoUPTrA67AWa/wPKEbHECwwhw=
X-Gm-Gg: ASbGncsz1hQh6WM2hazF+8lSFfPNNCHpdxNltSUeubsAP0+ybienmj/p2ToktQtzy26
	nEorT4JkWYUxx9lAN06QiKGTQukEOryOgz05jRxBAjtCPGtyFSVakjYhuf2hK7IYio6FVOxmhyA
	Dky0Lw9vJeXYdmXRJqcp7QiGspq6e3Uj3QhYLQjmk1XSuowYJZRayZq9lnDPXSGfaTejg0sd1vW
	3bM4dZcj+Lwa0J74S39ev6L60bCsPWpAct2WIWcOawWJeEvmoGvk1Jxzkn9iDGsfxx5M0gO+awf
	xKLbob4qJGMH5acz+fAetx8wSotlA7ae53/AK6nY3LvoI+gAd5rvnYqR/u8UCuub+1NxBu4GHWD
	LJAAyo9bzH2YpScpy
X-Google-Smtp-Source: AGHT+IFjtwksIDz+7DSsBWeS97i1ZBqpIGTXCOjdZdeq4tlTrWHKVCP+IvRPyXYuhcRL3QY2eNIWHQ==
X-Received: by 2002:a05:6000:208a:b0:3a5:25e0:1851 with SMTP id ffacd0b85a97d-3b768eb077emr5529569f8f.7.1753349096652;
        Thu, 24 Jul 2025 02:24:56 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:56 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:39 +0200
Subject: [PATCH v3 11/15] pinctrl: qcom: use generic pin function helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-11-af4db9302de4@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3208;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=j23TQRNjGh0BJR8XFxZqqg+wPRm63XTzB00GHcaNVhk=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvTk7yHYlcFQMyWoiWjPshDZZtgzQDFYrODV
 Z1WZPc/WEyJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70wAKCRARpy6gFHHX
 chVRD/9eeVGld+ATTL9+JqtQxPOrIZwlqhXFRCYZlyZazFTQwwHsY0fRCWqUY8zJDUpWJ58dICF
 jGX8CnvpX/qLEAuVRoRHPDvawkmoIZ7VML54qi6pmuB0YMtGcgUNj2YkriHA+g6fdE7LK+D3e78
 QQofwNaGv1MFuYFQE+hOnDOirVK6VIc8XhYsyL07YDN1qnaEDHtLkBZHefcIJryYxC6wlNBcz1p
 Cd3S05INSHpxvJstk5w7pofJEtTs0jl8bbzR8F2pN4QRtW6JfIKpD1otUHL+T6Ny7Qg0vUXNtW/
 Ibk72PLoLyTo/yGUQS0qBtRGzIeVRaxeAlbL3TC+oIXA8n8knMwcZsLnfQ8WJiygL6jWKA/bLkd
 XXXexkgPtnZPj/2q+WJTsC2+aVYV6F9bXeUOGEZG1tPatCwGN5qcsd9Fpdx+lRDxEmecZasPxgO
 IyNyAkCsvk2nERY1KT1vAZeJ+dgl63R3L79Rte7IK4nvIFxQeIP1p1hbSc7vOUV8Y8MTZg9RNKW
 pWMHGEJJmNENd2gZl/1mIBxCkfmnlDE8ymlKk6Rd+DK+e6X0sWBgvjj4so9LtIKeO8CmRsTNYoo
 4keB8r+QC7KS0dwAvoSEOFiNm3p4pkvhVsR7Oy+hpgrltAAF7eE9GT1MfhLfdxNVC0w1dagDftW
 5csm15vDv1NWXdw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: i7ddbx4sbtt9tzm6w5oyk8bwicjbgjgk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 24BC82000B
X-Rspam-User: 
X-HE-Tag: 1753349097-314495
X-HE-Meta: U2FsdGVkX18cxoTJXsH+MVFHmlywNoTjCxmFTp3jVyRYPo7bB/2jJ1l1Ghamq88LdyUoyIlMG2mnIETaLp1W3LisHVAyTshoUrMqutzh8g+PQnyPFo6jw9Uwqvn0N25c0chiF1Waf86gORqXYN7IxZ7FJACh87bZARXzIDHHapQ6bVJKmhW4AOJ+jb0LH0hblwO6XEM8AaO3CGh0dZPeoG0bZAHEM8/1DXlW8dxSwYkmPye3DWJ1pJn9Gjdv70+2nmyd3yb3IbcsclbJaAsI2ixY9GQ7iux0IQBFF1GXehNDOv7RKqc/b9F2PJmbVieH7tcgAZThTYN0aM9LJ9BTVaO+er8GA5g1XOuIFkBR55K6fekHmyUwQ94A0P8CGLggMcLlhxcGIc3i5coEVjDphcd7VBwf1/HEF7loj23NKTgVZM7ZSskaEeOmRjG+8m41Z8oPqR7FrKPK0VWgAqGMCdeg1Cl7/g/XeqOVrYwggxvKR80fsqEZ587TbwKRr8BBFixdePZUqbbb5VB3bF+GSG413K1jUnS866j9MFeyihv+n6fFGBRuz34FuAoSEgKNzx3UmQS4hpOl8b9V5HlJ4dqD7ZvebF2VzJPj7dg6Rdhz0+0+KMYvpqkFimlCKAcQHL4YeET5eV7UaJel3+o9g/hYs1ARCyp5mDM5vnHe8I1l0Qp6kSlkIJ0TJ0gLEIf4Ziif+nh8mgNvGrFflfvpBZLYFIiq6B9W1kZuDhwkoEHtvBxRDuBwagH79e0iFzWa6UFjn3ZYFx6vz4TVTZ0SFuz80HSrkYKeds2aZeIuE4RkwUJ4XFvTbv9mG1pLTBlS7y0ioC7mBntRzpmn8RzKJxKqfOPDLaV2s26yPpEvoSwkUr/QfeJDy5KBJDeTQQJleV5oUfIkdZhhuZdPJPMJDT6DhayDUbMw5EyJNAxc/3+IPJdzZAlIssxOtPisNtqTc0HUS+LmjLZYeEG40ya
 OfMoNBvX
 hi7ykO6j+cais9ADwj6/5sDIsPeHoQcyDS/T9xS47Gno/sstWAY8OFQ1tisSr1+wLS4qc6GVZ+UcTVUrKksN3qU9UhBT5BOzQ4v4Bg2jUve3Y/n3B6dREEDVHn8Bz9ru/smiAyuYBavFgg5dx4PicgHsxNZN5ftNMJYfZV9+Y9HmyRmjTHjtzimbDAHTdA5BjVwj/57Wb4vrOWxtemGLtaGdTJhODyE/ZKPnWn2yk9sgU7EeshzCYzqtHirEcB9ZtnVO9O0D4N6v59VzXvbR5wCQJIdnlIMIHOsoCK5m2dF1uE+C1UyAeHCshDAn/W0Hcelp1e/T2toqELe8BoZWyGBVALLeo4XmJqiGipE08yvCFrrHb9D11MmpuKSaqtRsTTxvMF1x5Pq5eQn8Nlebf9ek4+MNZSPy2bN6W8KUsLVUiz07z+sqzOlCO9wgkMdPEB1Vr3dnPKUO911DpK2Ys9j4FpiZsKbL1L+DvP4E0ynaECaVWSRfG/cB0B3HUPL+tEUNS
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

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 43 ++++++++++++--------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index f713c80d7f3eda06de027cd539e8decd4412876a..965f0cceac56697bc4cdb851c8201db7508c042e 100644
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


