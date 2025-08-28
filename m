Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D53CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5047F6B0096; Thu, 28 Aug 2025 12:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4D16B00BD; Thu, 28 Aug 2025 12:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA7E6B00BE; Thu, 28 Aug 2025 12:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 152716B0096
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 407DCB7B33
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:41 +0000 (UTC)
X-FDA: 83826629082.19.8DAFB85
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0C4B94000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=uxqgjsEr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyDGhfJgrh4J6gn9SuBfsKVPoVuurUg4MDMRSiTssr0=;
	b=2sTK4/6WakW4lj3VHw0dHkT8Erda0D7eiI2ripylZbAoE6P1/1hYWGeFSGR98m+0Liptn9
	ZVYDgwZBMh5cxfF2x4zun4CXxvJEQCcU6Q9ddE8wSTex3wCjasOMQ8rvEXiuwyXJ3i6Lt5
	Ef+mE6fGdehI9xTKqQGAiEzsDvzKLeY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=uxqgjsEr;
	spf=none (imf07.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.47) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396839; a=rsa-sha256;
	cv=none;
	b=YX0Yk7CoN4SH1lLMR0TLRnF42oRbM60uhuT5vmv9ujpgZfjq1JCoZhJEeFDXE4nHRC0sSX
	wXvMoMruzUHIzHGYAKFZSePl5u3Na5Sd27QgzFLoPcZFUtTAh01LQmnct+2fLQqb25NWP5
	8F1+VISpUykhpkTRdKloB+7FETQHWN0=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3c79f0a606eso725912f8f.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396837; x=1757001637; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kyDGhfJgrh4J6gn9SuBfsKVPoVuurUg4MDMRSiTssr0=;
        b=uxqgjsEror30Xe3Y1CQQWakj4zUpWJFnJu4V355OezZfTJeC6txhYAncP0IDDNWkwd
         C7Og5zfrPsfke8KGVe1OtwxX3mjHtDq4LHyd9+W0LgzDT6he+9e7tMM4Y3auEEMHaweT
         bA0bx2qoLS4s0Tdb3Zg7ipfIPx/hpulLIZKJReuyv0qfCa3H2LwNFWO2fhmBWtBZhbJq
         hWWtEDY0or9JvH6oMykAzsSy6KTSWN0YJbNGv1eZiJcIG3Z/7lxhqTIQQ5dURcF7SG39
         KsSBrtyMfBo4vUjlzW4Xyh5O7grWPAiwOvRTapNSqHD3sj5BeV54/neFW/55ywoi2OwH
         jzQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396837; x=1757001637;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kyDGhfJgrh4J6gn9SuBfsKVPoVuurUg4MDMRSiTssr0=;
        b=ZkkUgdcG2Omj9aa2UtR6uMAwmgNVFUj04W/q45mxH7/CVfPsn17arGbx6EftbH4iJT
         MWc9ssbcA4/gfvh4eZwyM5qPNww2GlxE/IVV+/3uThXXsFUiQLjs82PmJbeD4fhuD6u1
         oOjSFQ9UtnDbnXvVDY57rfjupftNwdBlvMBC3obcO0H3KzZjJeHfucrPsLkTbwQAhwa1
         hjLx8J0zysOpx8G34HF3/2Ig7CakjSPd1cw1V7nGgV8hpnZgBcM0S4HREFz/KyvJAN3W
         hkpjS2YNHsZ4hjHa0nrW8HH4QFcSQl2lSa0YCC0TDypS9OA94R2Vk5ViRAVxJjq1+WKc
         6B1g==
X-Forwarded-Encrypted: i=1; AJvYcCVVHCV6GYRazHQbDO3lkE/u7ayZVLA6idVy1IiKR6c4OExJEbcSLV6IGVuHtmSguMDwM+R7QphxXw==@kvack.org
X-Gm-Message-State: AOJu0YwVub+0+LbzQkpvOKP76SRQhE4zeRRDr9rw063gdwa4CAeRlXXv
	rYH4G44odiIEudnCgaOA1Hx26HRnH7OiZ3ZYhJX121PzlGAe6rStFr/BR3InuwxzMXc=
X-Gm-Gg: ASbGnctcj91tv7Q/o/LAA9fHlA6/hatTddpGDvqKda+9B2sjrld3ni+0LmlP/1pgwue
	n3ksUZs/5L/XS0n/TVJj0drxS8KQfEoL0tsmp2tMm082Kfr9yIBoC7pKa9jJ7uG1u4fCHuSBOoX
	Tf0DST6emRyNisBc2aFesAKDi9MZh0lBcp/XCDqtBOGEvtD5YCBuGknRQH5N8L3qmtEfLnERVVR
	WAMpehiiTBx+e8qdWQeA9UnkAmpw19yPIxnRN23Mj/v9Z42+2T6FmU4Qa9IdQXjesemcdWyKRPJ
	6Oq4HzknSxctCMgW9w0U25ix7koiolibo70ami8n8ZvElLzBxPIuqDNHYA3O5lR77BGHmNlbd4R
	kIbWemYQAtgAITnEoZQ==
X-Google-Smtp-Source: AGHT+IGRb2IFrJR7/1J+rjeNU8GkVEAEf5qNguD6R0jJVoV6aqw9N3uve9t0ub2p/g9PXQeEWnV+2Q==
X-Received: by 2002:a05:6000:2403:b0:3c9:1433:f8c0 with SMTP id ffacd0b85a97d-3c91433ff3fmr12100077f8f.7.1756396837431;
        Thu, 28 Aug 2025 09:00:37 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:37 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:19 +0200
Subject: [PATCH v6 11/15] pinctrl: qcom: use generic pin function helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-11-c9abb6bdb689@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3751;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=qmbs27ufzmC16v+sdcPEY4dDQY3iNSX16sXKxiePlDE=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0PnC9WMdqFML1hS6pX4Ax7d8FKU/1NETcnI
 wejv8+DrUOJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DwAKCRARpy6gFHHX
 cgUlD/9h+MbAVo/wpsAgGFq0gzUJAW9nwwGnh2UUoj3Kqv10EutSXw2RS8/j2v+ITd4A7ABEv04
 3e7T9KxIfgTGIQNStI/av47LGaFQoanqW1bbicRWetgfw4ov9Kg8DBWxmiM38ucKX0TH0B1V0DZ
 1ickY8HG8BK6FO+qam8qf//7NJ03enn6xAFDsdu8gsOOiGGf/TaB+M09CpUjTROpxx4kOdwoyRd
 7KEgzKdp5nr/aTr/5ymPx+D4YvdV3g8g7zKgpOv7sNzlh6q4eHpIyRXfSLTNFfMEK27gs3RfQiu
 nFjbrmBC/Cm0Dx3PtrZoiuGFLIynOHFozfI8W1nxeIcTH2drbiUpQM+PMyzn6QwdQLyuYsWIIp4
 P97TifYj25rmdWejAC7ce0M/MUr6ym5k13HkeDFMueER//pdQh2BB6H45PG9So0YrhSESCqN3TL
 0rgOdRqufzPjxELShQhA8C5ca/bWsVuYWVY2lPBJxS7oqgJQ7yO0V9lityx55QhQweeXFlkDOCa
 odj5YLA2Ua9lK5nhrpJl4Pm++PVW/VroLuBJuEtg8pEYp5QOywE1m2GdXhZxMn4fOMb71Iy8Ye/
 YCmOhCxdeaxT35vIe0apm4cT9JEQFY8JhotGnkxa3p+cTEYqk4BreR/mYrEtQrZJAOXNvDQXIeL
 AWgGjt+UZOIungg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: 0C4B94000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bzajyning3giw451tctjoage5k7fn51j
X-HE-Tag: 1756396838-612842
X-HE-Meta: U2FsdGVkX1//BXV+WV86sb3Uaiw95g7uVrAztvNtqAJZyiWv4gWtYrqHZAFJpeWiHlefWbzSii58eXKI1glolebirUl+AYXWX48R88RFqC89W+1szFQ8v+9N2XSGsrwUCjhvFcQMWJWsRY23qJ/dPFMX46FnK/R46Yf92VfEUhEc9C3V8f89PODwOvkUSGf8wlEs/OB6QxsU+TN/HjosnuCvk/Us3HSqV/E9bdxxvWer35QDK6XHBjcCd2VVAFlUvlsqswxo5wA1KX/fK8Op8mCOZgDzO03OjL4QV6BPWAEu4stM/lwdeYb0l1EUOKkuajy0Xo9bdVrsjx3p9930bSqONoUS5xUG/y2gi0Ex1lWih7WS4SUbEGZ50C4EPEhS6735Zy1ixwxdSNo0wj30T9WT9yvrJwr3bRPgXnvlohJmyNPlO/U7uijiEm3Ul4WtxlHuh5ng7wwCgG/XbnCu1rERJSbN825ir/spEwZ0AoZ7V9lrHKlmwf8r4ZFdOwqqyRO6E/Dt8f2fcY4ZPaYzMMk1fummL+g/ijz+BuAQ6eRVdHnt1fcoZfzQJxUnnIhiIEiyGJAyS8vymP+ayEZ8/KV/fRqz7o67dZx0EYHhBmoXBUvrVvRs9N5T2OLXwselT944lt0cHO8znha0s4tepSYnRHaj67qCv5iolv67hL1NEE5/HkA/CQtNDUrTztEeVaoYneK61BRcFNkuqRq6gGvNvCAz5ZnHU7/sEF8I5kwamNGPjzydh7De1ah2RAH78jDRW+PLaUx0fFDvalvBpgxbvdvDcaNbcWfSP+fpQKR4y5xL96cZSpupYz9jxSUvJNtIbG9/73yAsxei3CnQVHrY2MSbpznnfnw22NEH/WwhrzpZ7chom0sgmhyCa8TbzFDu+waQDXors8XTReOU6BGVYzRSiMmnC4hz77fF7SPXXId6NGnX7TpUKYBTuSnZAyHeMlFYaPvCisSbRhx
 r8rS3oTV
 y1KuF6GudDDIeDVX7UNdeNygYRMGem7u9OtiUAMOUrGwDMICVr1tktQjBs0D6eVj4Y16TAyTEg5QrgjvjGwcyMYLwQiedmiE8bMC4yX5YI1AcFsqXl1VPK81+MyCRfYSc/2CHIfXvMY35RdyBAwVYKk+YyVqhqAg6fudtuthKGyPbuXdxS5JLxjLtnWf6QZDvcO37YCJMQO5IhqF0Mt20YC+xVzQs+GZUFvtiao8duPNVd3t7sYest6DyD/Q6UBL2vg2ZsDsCYl54Nk4XbxePsJZEYqdHl9LDIH9c9/Ex8L0xMw1lRZgPDWNIuLHVXS8oIw1K6EAcWTDb5MpYmeqSSN8sfxG3G64YUmjoi+cMqPcH+zTCm41lozqWchHkZSPjuac94A9Hu8Bhq4G1Mijv74cNgScharBZLZh5KPdaOSaxxcqYBJ/SQo6PDuIYS1Rp1x+V1WKuptbRltFVzekMbyX3A8L+vMQ7g+SYs9Vt8OavO1xh9E0nEodYoFVQVzUHgAVLTW9Y++uOGCtoBg7XEvQj6g==
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


