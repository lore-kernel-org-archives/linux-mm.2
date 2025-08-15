Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33598CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06A390023A; Fri, 15 Aug 2025 05:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8368E0002; Fri, 15 Aug 2025 05:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5DEA90023A; Fri, 15 Aug 2025 05:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC498E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 390E3BC04F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:38 +0000 (UTC)
X-FDA: 83778418836.26.BF63380
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 28ABC180003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=OmI3Lqut
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248976; a=rsa-sha256;
	cv=none;
	b=obP1ArzbS6X+D77uRv9ngzYFQlbhxg9hqXilMlsK+sgb9yqH7et0BW3oYRwBZHvseaxMEM
	+heFwRNyVHzn7+8QD/HgaTKy2JX3KoF0txPB/LAlCLFfFpZg2gNmT1N7OKp7wRhtImuKyC
	YA2J/6pgjKmC0jw7sNTMASXnU36gTu4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=OmI3Lqut;
	dmarc=none;
	spf=none (imf24.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.42) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkIrT982nu0l7atioMtbVH3OTcGWcWH7NZxVXh73dLg=;
	b=h8m2ESAWWokspxuOjVz8G3sND7FUB9UxwlkjVmHOub0JC45P51p3mwHfFqcdixBhtMcAdM
	ydcZSxt8wUn+bTRcR0n9s9EornckvqLzDFnG0w/wLb8q8cQ7p3bl40/HEsvHqUxLdvWXJG
	MCZFjsq39/qzJXeWuD7mpqjw8/3AnMg=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b9ba300cb9so1199903f8f.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248975; x=1755853775; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fkIrT982nu0l7atioMtbVH3OTcGWcWH7NZxVXh73dLg=;
        b=OmI3Lqut4U0UcVyksaW/erRwNjdmp1+OBmWSlrz0KQB3ixdm+RRU9guWCJzg1lzjlT
         rHRHYGsp17TYLMh1nWXddRahkkJpCHGMm8Z1pRgWaCSHonWLA+mmQx8LGndCaHhTo/2R
         aum3DvgnA7wDrY/Vo1+c4M5jJlpDmwQ6PWGMACjIn3PSOTA3slPpRyJo7qNWbpdBK57Q
         bjG8uyk6rxzLliSphU4LS38Tktteg9kK2bGavMGDmK1FWIwYVqEQxAltTt6BxZd2O2gl
         cZqUvVKNXczA0hDyie0ppID90NnnNLN2+hWtnI26YEK6rot7Um+NiARWJ9UaqhOhQjrl
         vHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248975; x=1755853775;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fkIrT982nu0l7atioMtbVH3OTcGWcWH7NZxVXh73dLg=;
        b=t7Yo5MQZKZrKSN5gIPUYDhMKpG1jdltGUseEepvOPfhIuZW30NAeKnVEnkmWBK4jbc
         2qjGnpTIHVYWiWwFTJEPs9WyFQQzJGEiUjub9OzJIpOFfZKGl3aCtaXWHjlG+1sP8D7+
         wQzfUw3dxvfLPFoT0aEYDpSoPc+xOpslL+EDqF8S2eg3BeC4EJLFmrr95EbeH7us9eqT
         VKYCm5sPcB6Cplqk7vgHOvcw/9Cnj1+dI4dwdAe5P8Aychf5nZx86wZhpvDpL6gAYebo
         ZrrY5i8qwFnO5t2MiyC6d99nU4iuVzU/gqpKdoF0XbZDzrSVCAMEhpE+spbeyG6LPC8X
         Xnkg==
X-Forwarded-Encrypted: i=1; AJvYcCVZbWKIxW7yT7pbHzrZtitgDhvda98aEu0iD2t6lNxSwJcQOs2X2jHMp9a8dlaGKvcmdE7hi2+CJw==@kvack.org
X-Gm-Message-State: AOJu0YwuRXkF3t8yUQGG7Zz8A+e+VWfxQU+3YafFvOW70oUu9PAg+kRq
	u1MOTM5lmOr5eMhKe4Y5iirUOoEhckbj6ktGVmbX3PDAIcVkgNR2Ar8bDNmCkvRAWx0=
X-Gm-Gg: ASbGncu9MfjfxV0CrP2PhOdd8MlICUXThFGkzMEJEUlIuwASQwGUbLPr8gja3X+CC4U
	i20D2knJiuwhbsVfa6mUuK85K1opK8R44a08bp/mvUZ9vTtbN2fNnaqB3aOR7Wv3wvWrYslN9uf
	9DJqh1eQyWoDaP5+OKDpI8Z04MjAe0onRWuLYb0cP5+/RkBU/kG5sA0JPLEpKbRxXOkIdO0fv8Z
	9stVu8RyRZJegjLQCCMec+ROjRWnd5nNYphe9I7TZyNDKZkti9/YEm2EJ/MvHraJbkYeDjDSwow
	UVSkqMDPyccLp7vTv+PVbZ5/YRdlfCH5da/jbStGUQ/SoSzyW1ueqLisI4aeonBJvblgysWKU05
	HPKDXJk+7vp45lLMrxw==
X-Google-Smtp-Source: AGHT+IGsDrB/9NqsFs+GTJUXDyUWG89PIW79ggF9quCSnVgyfof3rlZDBIwDgG3UDAmjbKhep2/pmA==
X-Received: by 2002:a5d:5d0d:0:b0:3b9:13a4:722 with SMTP id ffacd0b85a97d-3bb4a1fa03cmr1100448f8f.6.1755248974639;
        Fri, 15 Aug 2025 02:09:34 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:34 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:13 +0200
Subject: [PATCH v5 11/15] pinctrl: qcom: use generic pin function helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-11-955de9fd91db@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3269;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=chxUZAtCU37mhXCr4qzhIIkekcZb+5ZpnLwzXbUTM0A=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk5lnBQ3Etsml5iw/SH8qzvKnyGoC4Hly5o3
 tnIDLJk12OJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75OQAKCRARpy6gFHHX
 csfPEADBEB0r5l4OpTTIJK9i5AuM4M/cyu/QvJFZPvHsnoQ9OThLsPCT7jshbC2wt9Pv2puSVX5
 T1Af8wLRGMDrEZDP79F4hdOml7iB4kmRVSgBGYOIXs9akwp0viAFXXfUTf0qk512LjP/Zeha8Qu
 2vBQJXCtlrnBVyrLAxCt7iywj/o0HrURUraqC1V/kL1ejTK5U51gBYfoAoeWQ5TUVJopb0tjbOA
 mkIQDFpPVtuvRc6JP3wWSfTDUEvSR/B8uIGUkyIDsqVTRzObzIFflNGPvWoIQj41zXagR0xgWTC
 tamCDJq4dBqsNR7YUMWTCgpLB9UMbZimR9r+Z5QhPEb1uEToQmLmIKQSH55KMosoRsheikmbyMj
 n/YfwJPK16Q1aEpo0CPIsJHHJDhsrEB4xWpq2w71ggoiJnPXLGtapH4altn+YIiCtNE2DsogjY4
 z1J5MTqicg8N2Wk959AZ2U0iqc7pHTgnC+caKBq76Wqv8S1/m+npVHP6elyJa3brBbDRDwVuFdr
 tJZsQOOHOmp0WRxh5N/07ZwrriHVtfhX1KD02OHuaiQrGtEyrp1/6LksZu/5fvUVpj92ttmQ1JL
 A+VFk+sgzNoH7ZCc3rGLtCq4/o+8RzkaRpoUSMtxA10w30Z31P8SZPwIDmMqECTzGYpEsEPiMNh
 4fdjFWUp2iXksfQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 28ABC180003
X-Stat-Signature: wag6q67tic9ijzhjbhyr7hrr9x6fpdgo
X-HE-Tag: 1755248975-243905
X-HE-Meta: U2FsdGVkX1+VhKuZkUqLNya01EiQTd+6xtQIa//Vr2PBpPWRKv+vCWBTTlA514mFOK/QBF+Ok43uXGmpYI+1NskDajQ37JzPuESlXUQBI1dkkhFXEmWSuegW7d1hjCczxU2RojWQdffLraMaUmHS9dexYUdFnoWr+h2Ihn6ZGYQZng0d8dpjzX2KCdGreg8nh51/knRCx/s3M47ao0kk4Rwgj2UxlX+4/ucdqRexG4Y31V5ZXeXlGxGREL/W0rg1yVul2uEpVA9atKg+aqfRNsAxS0kYHgQy0phdxrR593xFHPFyGrKH/XBnb7wOGXCf8MH6HZ4A27vSSXaRH/43FuvJwtyHejYYmWxI8ha+TXeU9LrBIxTjD4lYNRKyJwgZ1yvPtK9USsQTF9xF49uPouyaDKEtYk3iNbmw5jL090BOStBDLi5oGTOpGaYsDvCSxXD7yiCdr/HGtYKXPOuYAOeEt8FbGL3FV8YZHzAhAazHReo/LcjshoJIR6dapBaEahCldPt+QVy4l/LqJP4E7B/NyKVSV489sk/ylPqCid5GVWp6d5GmP/54GlEFCR8R01re6EB/uz5VnkVU9rsqVVrK3RjVwz/fs/NGoj4GfnekC8wfBx03TcdC5pOQyM+wmFIpKjMSqK7BwfbKj88P2dTvXYB2Vm4Df5HMbgthGtyGAtrAheEBQUXtcZxCJhwEbajyRNkn70TZDQWTewlK49HcwJl8upAwc3Vi4/3dzWsh6SOnEGZ/or7aezCe59Bk0k9IwgG6WUPDsH/SZow3KdgRZttgpiYYgS+k5Ji2MqV46rUIswVdenpbCDFXSLqlFBYGtzAOPy97sCICBuHRvvfdgoqIV06P5/Eb0Lqy8lIGYxFwC0YsnsIAj7tBa+KWT3h76oKKbri/QpMDuU8hiMcQ2nx0DbRRmMzD9HBNUftUsAiVNaYU0U0EVoqMMNY7iNTJzkftwMUbrpkVpEc
 gTIU+Igv
 O4uLU3u66aXqXtZsOYP/kNDik6RCHQsie/mqLBSeYjt3vgVNftiGSFn35fPMkFBuf7RsLDBKYS0OWyYRqlQIfYTKG1m+PRntoNY6KapefY3VC7TuE3pEC4If3xX1hWhoqXq+/UMmgbpJypngWFI7WzTIP+5y4rDg4WeDxMmIMOlD2FZzMUTHmWNVTR32b2STRqlKLGos4lHtJm0flrDc87gaWc2QpiiBw0Tyt6r2S39YmJOg77oH3Kkim13AMbRgDmTvtAHPtq6kzSRaUKxXuMhiDGESfpnuGwN2sUjQuAZjZq8XGG0lyFs/Gu0Ev6uQBrdPwh5XAm5xYL/QQUHvUn99X+5x4lGsm/+x2Ow8IO2Uhqhw70LeXbjBU7qaTD6CZlgYJk0KVlydx64zcYeEVyMkmmE9yKNjjvqQ9IieEOz8MeX6xkPvWLaWLTxIy8r4tP+1rm5qSHvQKUnbk8rKNEjdp+m9hxpft9OCzcqTFHUCymnx19q5iTHP11J6R8qAmM0/ZCyvShSeLkQQgUVtw+qm8fg==
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


