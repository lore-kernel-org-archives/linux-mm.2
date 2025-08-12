Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A55CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99418E0101; Tue, 12 Aug 2025 04:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC8C8E00F5; Tue, 12 Aug 2025 04:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C198E0101; Tue, 12 Aug 2025 04:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2B448E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C1D61A022B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:30 +0000 (UTC)
X-FDA: 83767426260.26.82699CD
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9B4B3A0003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=gaBaZv6I
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkIrT982nu0l7atioMtbVH3OTcGWcWH7NZxVXh73dLg=;
	b=HthYwrdWV8hDjTXc+/M3p5xR3AaBFw7bszxANJlkqb6mIlS33GZEWXKnHhYDFngU8VBfRJ
	V+qgMRB/yZplwXownw5zY30mVCnC7+iZ9BizHuTtmB4tH9QnlvUQ+GFFLYRzjA7L6oIpQP
	iu0s/3qhEy4DyLr7LWm42XnXaaOkRAA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=gaBaZv6I;
	spf=none (imf15.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.54) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987248; a=rsa-sha256;
	cv=none;
	b=Zi6/Fw/B8A9gf99d6ebqDso8r0pHgT89Ee582KOz7leFmypUXd92t4OrzomkkAbpMlUS78
	meJyZAuM0cv8l6DKRfufyYSInqJvibIo5txEDqHMrpcraQ6UmCV8hJ9vbwvwk37vbGEIq0
	W64DYUwTR5dryEGCeYJip48H8ZrpjyY=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3b78b2c6ecfso2796171f8f.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987247; x=1755592047; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fkIrT982nu0l7atioMtbVH3OTcGWcWH7NZxVXh73dLg=;
        b=gaBaZv6I8lG3vLhUhElKFira71/LfoPSsRIemi9UnVS55gD/gA+dpFuX5OEJUa2gHd
         CVPk0zEjwJBe0WRSBLdQvpGA9RZSjwrZabvHi/II0PMIIUmSsyO4WKe99NUmrF70hcv5
         VqqUqsDmZ+4aLQPMKk4ZASl0yuxQO6xxpXFqFPv86qz1tltu/w9hs8RHIs1Cm84tg5G3
         wuEueAdC6t9E6XIfSVSQj/BhiiMB+WfxXRH13PIooPAnAyipX9n+bnmDBALgO+8+ZNbg
         Dx7piGnRD03ttybY2yMmBdE1/IDJXSWQfQxc0enV4Vzhr9RcLHmf2vJU1rROW8A5JJ5p
         KgFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987247; x=1755592047;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fkIrT982nu0l7atioMtbVH3OTcGWcWH7NZxVXh73dLg=;
        b=cJ69O5NmLhkLfsTYqh4aELShKeFw4RDyZZbXVhT14peqJKAS4i7sKS+oOorqrfCux3
         Vm92ykT2zi9MfcloN8p8RolmZkxdWhmlYOl2GwyNDkH45nvw4y+1Iaci88Xn2yFFiJsI
         4MhG9fJKJHuKcSK6OJ8bZipj3PIM1OEk885v787QFF1+BOtoQrAtfsT0IUUWniU6TvLM
         ZpaUVM5kgajD0qEB+VmkGfT6ascnWZEZgs9ZYnSrwQkfZs17W0UEZnTrqRQ3l+Y2HIi0
         Q8BEMgHSi94+ZIpjv24XxZMSEcc9a6FFFa0FImr021Qmu3O5nAfF8UniEJcvfBZyInXM
         j0IA==
X-Forwarded-Encrypted: i=1; AJvYcCUmFJ8nD4ec2OAKaqx8vXVcztSsNkvi40KmMlaae4A6WaoTX+zE+WJoV2OJknHCmFaZW2DvSjOAZA==@kvack.org
X-Gm-Message-State: AOJu0YxomFjGoDmdP9t/ZQgViuX0BmBNxaXrVn/ta4x4Uy4VT24Gq8A1
	PzZ8FUOGyZCbP/Wj/3viytwIRrKBXPdlYkL7JIydLn415C+lJrn3Hro8W4tczChw8/8=
X-Gm-Gg: ASbGncswOey7G20IYKAQivrA682m2uE/C++kIAQMrkCsYoFoz8nClGGLn4LTzIUoaQU
	ARtDJYRQUyBaODTfXul7cPiFd0Idw1wCsXgXLsn0XfQ/oIoSjCpmfidMw5h7pbRtYNRAU2ZBQDh
	Le11EMiMmHTC9ZpOm2Gb0HCBkLQ11mJse/kxPAQnKBjWygwz0FTpR2e+BK8S0dw2Fl5iDcoXK2V
	+KAlt+pRkkDY+dPo6cRMcybi1h6Fq2sHbntVJOhGrCOB9xq1X7Rx2DOMSlJtO+iEplX399Hn0Tg
	HEW5baUIpPR/JDAH6r5B17gGj+vKddaBbptM/9Y+dbGQshRFCExE62M1GVswkAKsTapMZykwcLO
	0KtKwc5Zb0kRYO7c=
X-Google-Smtp-Source: AGHT+IFwsqbb1rEd24wsckY1+KDaOixyeJmTQXPivaE2uZXRqBDhR+NeTCmIev7yq9yZGKWaYyUBJA==
X-Received: by 2002:a05:6000:310f:b0:3b7:7c3b:1073 with SMTP id ffacd0b85a97d-3b911014a84mr1715986f8f.52.1754987247118;
        Tue, 12 Aug 2025 01:27:27 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:26 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:10 +0200
Subject: [PATCH v4 11/15] pinctrl: qcom: use generic pin function helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-11-bb3906c55e64@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3269;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=chxUZAtCU37mhXCr4qzhIIkekcZb+5ZpnLwzXbUTM0A=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrZTBy24+EiQ0I9n9YAoAtc9GJc+mIbjLJ4c
 dVv83dQyiCJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr62QAKCRARpy6gFHHX
 cnS7D/42s+kq9cudWSpcHFuc0USVQTKWUm9m7Hr3iADyqxdii9U6wnmYgtkZeD/gBnn6eZBEVM8
 936OPO+6JoHACjR+Mrib1JBKvn+2EAhtvOxa2y8krmNl8HTrOwK24miaRuyQryIP2PDaUu9a/0v
 CCXeG9pcuY0VlCVndCfLAIvMBtoaf435NUcJbfRAUA1pqIBnAMgYNXixlJA8FtQj1cHIXYnoz12
 NRcDaJrJJQBNezG7RIxA0m4pc7nknsJMic4H6VJuhEEDURLIX11SZosiXspOqRzpyjWrifX9JKM
 Ir+XQCb4e9wFmhsQb0WJyDW4DxOxxVHaxO9vl7HLgXd9OcX+TbJm6dmibj6OQY3tPabfLIv5t5b
 91zGUu5y6bJ4d6/+OO0qmV6kzCOFxZBaFnx2uqKVn+ubzX7Vb20TGm0ArDrHQT8cG/W3iKRJf7D
 j/tojt9LnoVrmeBXBoFp75tWYfAtotKruu+kgi2o90mx5CL3RgXe+BHu8kcgoLmyby/jSygW3ei
 uD4SzRu96+iIJLTUjRzqRbv6WujNxkKHdcXIXO1VNvLuJ/rY5DhvLN9VFlnYGI0Pi1b4vN3ZwtG
 ZqR5bOzeHuNC/KkCJphUX/v8hHAqRSHlvHv1oCenO2VC8TSwJ/RtpstfLf8KL5mLGj+tYmim+md
 2lrEOwVF6POBJpQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: k68pm7d6wqwibmywtn5t4qakrrj6aifr
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B4B3A0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1754987248-415645
X-HE-Meta: U2FsdGVkX1+mVSJSr/mKfajbbJr5Z1NzTZIFhuiWFSeItD1gDwKWua1VQMpoP0UADbU8kIPkFvoMJF/Jx6+8kZHXIt9AW1tzRgmXZVrp0j1uqaMJ641gCYmElBVl5ywsrWGJR9LAeKpnvLOpCu3lGMHcdtmsNWMbAhVJevtFse9yGvGmHgqidGJV7A1YoGzZg75o8uOiUlcxk3RhR8HjFE+4iHVzAp6zZeOniMOwN7+HXaDohVjaAFj7UuQbEYfI2Rv/DIHYzIB7hm1uYWZXRwG5j3xZqP89jdmVpuFcKZOOeQFfdWyLvkhRsU0XkGdsh30XUrywBVIGVGnLmQVAKrA6VTI9K/tjJV8RAYlxpbZ7/SszE6z1WDNdcNI4Ga0GoK1+EvWySR6r4fBK9oSuoQFXyIdh7h86EQaXQwp6cpO8fFINLqdmmUbFyQYfj2JeQD6MrxTTS0tDAqYmXSVeoCSiMlMYmDJlkWz/rxs+om4TmiMPGXJGikhGlBXPZD2AQH2c1TgtS+O7aOFR2Z744Jk+ZnocADIV+LgpeegkmnugwjFfwAXq6PZDi5LIn7ptQnhI+5s713dCWFNgutT03uW2YDzWjiXmL9VgiTmqTNyfECZjToxN5FjyUg2XE+zBfq7zRDRRVi5/TCd54Pj1uvOJR9ZOhnQVJ2ZVRk/sgoCqL9c9fS/DsEUGzqFAJwDM2qmXN0YbZkhd+ShTdblHcIOobEs7Ahm5dJ3UFHQt7J5uCi0Ar/SyH97X+azcnbvKYWE8IMxOGwzQ5e+fe8uf/0NQb+bfapQVhzbhRUxeieomvcaHSZP68rVrCknZekcbbdnB9wBFwo3ss2fRkfcEXVO7t+qTcvtGiJP10M8PcK5M+heFG4d/IN8YNisu7eXLE6nftpHtx2QOPG3aga4l69azhuvw9KRCmvO36RxN7mDjUwFUyuJJqmRMzJ/ygVuBvGXD72ZSCd/I9O5hliy
 OD6dt4u6
 /jAflBYKJo+TkH0BJnwf21mJgYcbwlVp2f2Zk
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
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 43 ++++++++++++--------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

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


