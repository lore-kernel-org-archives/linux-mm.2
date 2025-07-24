Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86398C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5238E005B; Thu, 24 Jul 2025 05:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3862A8E0051; Thu, 24 Jul 2025 05:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29B568E005B; Thu, 24 Jul 2025 05:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17BF78E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:24:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDFAC1A0294
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:45 +0000 (UTC)
X-FDA: 83698623330.30.4A7E58F
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id B1735180007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=nnztjdS2
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6sWU8YnHnVcNKleX9UPC0U7m/znD19p5mBB92tT1cEw=;
	b=Lp/c0joupeWd99g0HoUGxOfb6sv6K4ZtTcFFtlbaTYNJ2NekDzcaiyOuiD4cIbJpTelUhu
	7f2PhNriSnbfMU/lakUIwW1Ikt37hMsbbCo+PhtIoEwLAY3L1uHYdubBmuSsjv+opjm76y
	s+16z167++ltdhhy/hTtNi806n5JBO0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=nnztjdS2;
	spf=none (imf24.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.49) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349083; a=rsa-sha256;
	cv=none;
	b=FAoOC0nGwvtJCfFmgpGFGk5PJ5PwTPWvIhWDTe2sPHBMekWkLisEnvUV6TBoul6VYQ8IRl
	Z+88iJn2T8C4uujmQkyOtkQ6LWOgu3C5EFeyelRnhFDL4SUjkEoVcFmU7KcP8BC9AzU0hu
	PSAPX1LX9M/kkDjr7BgRbIINYzPuuXg=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a575a988f9so427565f8f.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349082; x=1753953882; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6sWU8YnHnVcNKleX9UPC0U7m/znD19p5mBB92tT1cEw=;
        b=nnztjdS2GKvMED7ncNgbp0l8d3usagRekK8cqI/jOAwwi2O7FOGWOPNE6sMa/ip5xW
         QNtBEhzMBwf+GqMeVKBJWDyEkVuhm7tpULxmuny6odbh1kIAP8KwHfo3TVLAN28r3Ejz
         aIfwnARtColiyNHGma6rdwe1bG0oiqLgMUtZGmgkTzSZ05mx1XbTDNP/Qc0nfngfA0/H
         5EmpDZoT80WjauBvQkb3+5x9d57/tGAOVIrv/16ia88rUvhHPURVx7mM90vB2NA20RL+
         wj1l66AdblRhL0NVQMqGSb/YDIHJcBs2PzFCKCmhgorSavj+VU7qQgG7bxpfxZiDgNuJ
         /psw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349082; x=1753953882;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6sWU8YnHnVcNKleX9UPC0U7m/znD19p5mBB92tT1cEw=;
        b=QHhcacsXwZVBcBWh6Q8ei88w5WdHZ8QrVUNUOOobVZEUqVu1hp93I8rJexmwturtWa
         0TY+22xDHp5vm1rP1uyHYUy1b11MfsV5LAcgwDg6oQSQ1/UmiEv3tREXV6br461z5yxr
         XhSZb9nFeVgBTS/lEAWhNwzGxRRTqj/U305avuBch3pzNmhG0d43G3Mr+OWPQUcTTJLS
         t8sG9Yhlt9vY3CRx7PNwSPkAUwOBBk2GhX8iFyDWihXEp7zLs5xyLuD7ncaH42STEc6E
         phCiCo+LOAnoFw6TSmrkZXUTmiNG5mDsZvh1hhGkJQGvc1kU8B2FUpCF0efTse2HrR6X
         gAlw==
X-Forwarded-Encrypted: i=1; AJvYcCUM5wSoOiREit5SJ26qGphDgm5/eSd39VoxAbeSDW0AAvxnBq/AlJUdp+PNdL35hUwe23zLZWS3+A==@kvack.org
X-Gm-Message-State: AOJu0YzPZyLbePTe++K9hJCr+NQKA9CJKAr9gNujfVqI8v1MbyIbKnaB
	PgEPmfIRJ9b0w/g9BPR/U2FGgGax4GInkcHErClVI2WXlgWOqjAys+Zqoy0c3s/wLZA=
X-Gm-Gg: ASbGncvNA2BBtBduO3YNqMSrrEpPPFPqUjSz53onq+Me3aJ6LVG4c0KKBeBh65OTIek
	Ri4fhBR3odg27yhMdFxr18FcQBLjqB0OFZBR9/kRcKQ8OMdtcTufFndyJd1YFV35hMDgliG2+3Y
	vBsntTbWTj4bO1dr/dXqMMpg6fqEwf4UlxKP97lkPAfV9BOvFNTkqd2FEhpeNhk7v9f7/yad+KK
	VTod+gzMZ9F4KX6dRNS+ETfSO7EueLcd4w5NUUvrFCO46/FB4V8AN2sjW4rnZDRkQdUIbR8vHM3
	SMEifKIbHtlgQ2f08nVXY0GGg8lxMUV//4a8NmddVmvc8snYFxvu5bOng6d2eKoWFG/4+8QC0c6
	+sUjytW1PE4O9+NRP
X-Google-Smtp-Source: AGHT+IGMyfQFwRSUScMLQ1YgB3xGO6vkFfceEq9X6R6C5JVDgXu14hMmMVx33EvpeqC/XAGK3OQrjg==
X-Received: by 2002:a5d:584a:0:b0:3b5:def6:4b2 with SMTP id ffacd0b85a97d-3b768f23098mr4879213f8f.45.1753349081822;
        Thu, 24 Jul 2025 02:24:41 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:41 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:30 +0200
Subject: [PATCH v3 02/15] pinctrl: ingenic: use struct pinfunction instead
 of struct function_desc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-2-af4db9302de4@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8941;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=S3LPf6/S0r20zm07Ruj/L9k5jPgsB6qXfKeVOQNigLQ=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvRMNHJ5sLTDCzKpi8eFKB+zwspPdEBBd2zi
 DHYFafrz+aJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70QAKCRARpy6gFHHX
 cgbCD/94rwbdfRbZRWA8TKDslgE8cW4ybdhDITP3UJekzOJ1VCgzHafcAL+dwtFmdxRuJn9FF7K
 c8H27m2RXYjVjiXTC6hKoXHeXeNaJFj5D6skY837ukiMKmr3Ybu4Ee4F9UtjZm/q+NHaaCsA2yY
 pQbMcFV7vAjx23rWnRY9Eu0h1wY010YOL497FFxKDrx/rf6iBQ0pFZmf2QJkfxH40KDIzJowYc0
 TUEzNU3nDuiaeGJT7rEfsQeD6DDXbJjQs54pJvAsbf+M17WZIg/5FrBHVRxnTbBJ4JEC68JestI
 5UQcb9D3wvr9/m2R/hyPiMcEqYuyHWQjFUMLsA4/H3DkCpgV980beUFMHEnIY3n8lm5a39Wh6xA
 Bk6ynTkkMv4jvjdizB5QkXzko0dVhO7CWVvxTHHmXbC06J9z6t2G92TCDWvYUCwSov+0MWd1uLK
 vZX782LSn4xj36U6re+K6cDJOOrGUE1qOewD3bKngg0Leq8rtYfd2gkKD58qzpoFYiqyY2h2aGo
 8oqj+qR2AjHWkUQyTtTDU2BtrppIwcWF/6QT81U5q/oyeDtlo457qwxBrPE0qnzfBsv/d56zp+n
 Pj/DUNN3+ZkOb6e9clL9e7GZBDJklALeJTGi76TmvGF69BS41Qk2mD/dguTlrkOt2cHPBbJOQO6
 6aWcAaUfSX5CP9w==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: ef4cy4zghogbroy89uq7wiy86s4m3cs1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B1735180007
X-Rspam-User: 
X-HE-Tag: 1753349083-324119
X-HE-Meta: U2FsdGVkX18SzpSvglPAj/5PllYFT0Yxj0h00nA+MNMgFfNmOSa2T+e2TnMCbE6Oa+S17XbEHHUnK7B3x5rF2KIvWkuWixjE4MTcSOznedploH0VTLW9LbH5/SXHHQRc713wwE3PcH3DUIuoqA97zU2Nooaa2CY7P2OddKKlh+m0U7aGSYBymIV5bfuljFfwSY1D+7BoAcRuZ/gZhU4UcGBkmLr8rU9Irl8RbuTI9mcaMkcCdJ9AlCUj5kq+NBWQg/1WwwuKXfOMN3trHiBD3BUCOZeCXzmreT+LtvhLUlmCV4PTVXb+Bz+x3yySNNVsJ/3lhnaJAX4sd7VglHw8OIxIrEosBfMsYBqGwarkb2UBPJ9wNrxDku6riTI8imrsxeM+E2r+if8b0uTfaeEWWu8V2V1PbxTbsC5g7kXuoZbsH5PZma7vnxKbKG3YQWH5pQQ1oZekKp8dpjWufIEV4F9e7VFD9KLaIbR9eZl8IUJzpYKsNZ+GuXR0NeGxerbgMdtqESfn+pZCWH/im6rPIqED/ySHqgcK7NBt5wgw3z3wVyM/ZGVJ3uIfSlhkudQmiPMk7I8S1od4HNKKUpBjF3kR/PEtzFaXb9c8E3ei9qCl7z+NuGSbKXKIjWRQHhN9jE8hlv4G9B3s+3CPo4Pt2/AUec6S/Rwmy/zMNXdYSlgRZiaNif3MYttCLFSfMky0d/Rr4LQzwEHmBxS2VUuejpmkfaltfgmV9Y9jiOZrHpPmdIawvfHNS4mjcn2ACdUTBF5HoWb2GtL4dUSmRPUi0t3wbd/Nxw6HmYKoXYYYLPPv8xWyxrmDE0W7tA8/yOgRFYu+au8kIOxeiB1z3T/WWlSpeRAb4UklnlqrqGveKWj/AKqLUNPXPOawHRKT/FTGkgUUjyvLYShe1HhOx7GQYKGD6U2DdOZuicz/4STawyHQ0a+lX3+V3zNJ2D2nIP4LhbkC7Im0CZsRvSH0hP6
 vMa7Ru18
 Q2O0wCMI6xG5OIvbTDfSaZPeURGnFb24/6C+pPh74I78zbfvXYoTid+DhCAM6ZieSBnDbr3Jm2ICakYS5x4jHTOj5FioX1ACsGfA5Q7U0BTJ/nUT2bXogmnhDp4dZlx4+0b8nMLwjPeVK6EAlo+m2sP2+PonEpBpQzwEjlyo6RPKAxydgdg6ZMuvx6UlIvgzHFWbcImEpXoyKRwskqfi9ZVwN0U5MbW2uonGBaHISySh+ZrzGi9Tpd/vaaL1x3yjrRGvgwD4PvwGgNTLAvKep63soDxGPW97WxxLbiwnsaKSch5ywgbKMP/UnSQn0KOdsbeWMfoounTOXrQA93u40XpLMjZxX4/B5v2CasF8UDFZyas2Vhy04r2PA6vNVfHUjS5aBgV2qcnbMGRfye3Xv7p5g1JTkxmMJHG0AHbctVKJxw2GR/7aF8KlDRcakExvxNQgjBUOCxRsFrZ6H9ZadcHwtDiSbpZ2qdFW8E6j82JExpw1Ez6gFsQs0mOFasJSue8W6sLKhnTl3nEkOyU4vdl2TaH6E2hvNO3zkAMmvf0x+CN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

struct function_desc is a wrapper around struct pinfunction with an
additional void *data pointer. This driver doesn't use the data pointer.
We're also working towards reducing the usage of struct function_desc in
pinctrl drivers - they should only be created by pinmux core and
accessed by drivers using pinmux_generic_get_function(). Replace the
struct function_desc objects in this driver with smaller struct
pinfunction instances.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinctrl-ingenic.c | 45 +++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 79119cf20efcf8cc701647d9ff979c2b71bf7589..0ee8554c5446c4167c9b0e6b9397a2507ca57419 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -96,11 +96,8 @@
 		.data = (void *)func,							\
 	}
 
-#define INGENIC_PIN_FUNCTION(_name_, id)							\
-	{											\
-		.func = PINCTRL_PINFUNCTION(_name_, id##_groups, ARRAY_SIZE(id##_groups)),	\
-		.data = NULL,									\
-	}
+#define INGENIC_PIN_FUNCTION(_name_, id)						\
+	PINCTRL_PINFUNCTION(_name_, id##_groups, ARRAY_SIZE(id##_groups))
 
 enum jz_version {
 	ID_JZ4730,
@@ -128,7 +125,7 @@ struct ingenic_chip_info {
 	const struct group_desc *groups;
 	unsigned int num_groups;
 
-	const struct function_desc *functions;
+	const struct pinfunction *functions;
 	unsigned int num_functions;
 
 	const u32 *pull_ups, *pull_downs;
@@ -263,7 +260,7 @@ static const char *jz4730_pwm1_groups[] = { "pwm1", };
 static const char *jz4730_mii_groups[] = { "mii", };
 static const char *jz4730_i2s_groups[] = { "i2s-data", "i2s-master", "i2s-slave", };
 
-static const struct function_desc jz4730_functions[] = {
+static const struct pinfunction jz4730_functions[] = {
 	INGENIC_PIN_FUNCTION("mmc", jz4730_mmc),
 	INGENIC_PIN_FUNCTION("uart0", jz4730_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4730_uart1),
@@ -370,7 +367,7 @@ static const char *jz4740_pwm5_groups[] = { "pwm5", };
 static const char *jz4740_pwm6_groups[] = { "pwm6", };
 static const char *jz4740_pwm7_groups[] = { "pwm7", };
 
-static const struct function_desc jz4740_functions[] = {
+static const struct pinfunction jz4740_functions[] = {
 	INGENIC_PIN_FUNCTION("mmc", jz4740_mmc),
 	INGENIC_PIN_FUNCTION("uart0", jz4740_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4740_uart1),
@@ -474,7 +471,7 @@ static const char *jz4725b_pwm3_groups[] = { "pwm3", };
 static const char *jz4725b_pwm4_groups[] = { "pwm4", };
 static const char *jz4725b_pwm5_groups[] = { "pwm5", };
 
-static const struct function_desc jz4725b_functions[] = {
+static const struct pinfunction jz4725b_functions[] = {
 	INGENIC_PIN_FUNCTION("mmc0", jz4725b_mmc0),
 	INGENIC_PIN_FUNCTION("mmc1", jz4725b_mmc1),
 	INGENIC_PIN_FUNCTION("uart", jz4725b_uart),
@@ -606,7 +603,7 @@ static const char *jz4750_pwm3_groups[] = { "pwm3", };
 static const char *jz4750_pwm4_groups[] = { "pwm4", };
 static const char *jz4750_pwm5_groups[] = { "pwm5", };
 
-static const struct function_desc jz4750_functions[] = {
+static const struct pinfunction jz4750_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4750_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4750_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4750_uart2),
@@ -771,7 +768,7 @@ static const char *jz4755_pwm3_groups[] = { "pwm3", };
 static const char *jz4755_pwm4_groups[] = { "pwm4", };
 static const char *jz4755_pwm5_groups[] = { "pwm5", };
 
-static const struct function_desc jz4755_functions[] = {
+static const struct pinfunction jz4755_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4755_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4755_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4755_uart2),
@@ -1106,7 +1103,7 @@ static const char *jz4760_pwm6_groups[] = { "pwm6", };
 static const char *jz4760_pwm7_groups[] = { "pwm7", };
 static const char *jz4760_otg_groups[] = { "otg-vbus", };
 
-static const struct function_desc jz4760_functions[] = {
+static const struct pinfunction jz4760_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4760_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4760_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4760_uart2),
@@ -1444,7 +1441,7 @@ static const char *jz4770_pwm6_groups[] = { "pwm6", };
 static const char *jz4770_pwm7_groups[] = { "pwm7", };
 static const char *jz4770_mac_groups[] = { "mac-rmii", "mac-mii", };
 
-static const struct function_desc jz4770_functions[] = {
+static const struct pinfunction jz4770_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4770_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4770_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4770_uart2),
@@ -1723,7 +1720,7 @@ static const char *jz4775_mac_groups[] = {
 };
 static const char *jz4775_otg_groups[] = { "otg-vbus", };
 
-static const struct function_desc jz4775_functions[] = {
+static const struct pinfunction jz4775_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4775_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4775_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4775_uart2),
@@ -1976,7 +1973,7 @@ static const char *jz4780_dmic_groups[] = { "dmic", };
 static const char *jz4780_cim_groups[] = { "cim-data", };
 static const char *jz4780_hdmi_ddc_groups[] = { "hdmi-ddc", };
 
-static const struct function_desc jz4780_functions[] = {
+static const struct pinfunction jz4780_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", jz4770_uart0),
 	INGENIC_PIN_FUNCTION("uart1", jz4770_uart1),
 	INGENIC_PIN_FUNCTION("uart2", jz4780_uart2),
@@ -2211,7 +2208,7 @@ static const char *x1000_pwm3_groups[] = { "pwm3", };
 static const char *x1000_pwm4_groups[] = { "pwm4", };
 static const char *x1000_mac_groups[] = { "mac", };
 
-static const struct function_desc x1000_functions[] = {
+static const struct pinfunction x1000_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x1000_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x1000_uart1),
 	INGENIC_PIN_FUNCTION("uart2", x1000_uart2),
@@ -2341,7 +2338,7 @@ static const char *x1500_pwm2_groups[] = { "pwm2", };
 static const char *x1500_pwm3_groups[] = { "pwm3", };
 static const char *x1500_pwm4_groups[] = { "pwm4", };
 
-static const struct function_desc x1500_functions[] = {
+static const struct pinfunction x1500_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x1500_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x1500_uart1),
 	INGENIC_PIN_FUNCTION("uart2", x1500_uart2),
@@ -2562,7 +2559,7 @@ static const char * const x1600_pwm7_groups[] = { "pwm7-b10", "pwm7-b21", };
 
 static const char * const x1600_mac_groups[] = { "mac", };
 
-static const struct function_desc x1600_functions[] = {
+static const struct pinfunction x1600_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x1600_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x1600_uart1),
 	INGENIC_PIN_FUNCTION("uart2", x1600_uart2),
@@ -2779,7 +2776,7 @@ static const char *x1830_pwm6_groups[] = { "pwm6-c-17", "pwm6-c-27", };
 static const char *x1830_pwm7_groups[] = { "pwm7-c-18", "pwm7-c-28", };
 static const char *x1830_mac_groups[] = { "mac", };
 
-static const struct function_desc x1830_functions[] = {
+static const struct pinfunction x1830_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x1830_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x1830_uart1),
 	INGENIC_PIN_FUNCTION("sfc", x1830_sfc),
@@ -3225,7 +3222,7 @@ static const char *x2000_mac0_groups[] = { "mac0-rmii", "mac0-rgmii", };
 static const char *x2000_mac1_groups[] = { "mac1-rmii", "mac1-rgmii", };
 static const char *x2000_otg_groups[] = { "otg-vbus", };
 
-static const struct function_desc x2000_functions[] = {
+static const struct pinfunction x2000_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x2000_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x2000_uart1),
 	INGENIC_PIN_FUNCTION("uart2", x2000_uart2),
@@ -3449,7 +3446,7 @@ static const struct group_desc x2100_groups[] = {
 
 static const char *x2100_mac_groups[] = { "mac", };
 
-static const struct function_desc x2100_functions[] = {
+static const struct pinfunction x2100_functions[] = {
 	INGENIC_PIN_FUNCTION("uart0", x2000_uart0),
 	INGENIC_PIN_FUNCTION("uart1", x2000_uart1),
 	INGENIC_PIN_FUNCTION("uart2", x2000_uart2),
@@ -4571,11 +4568,9 @@ static int __init ingenic_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < chip_info->num_functions; i++) {
-		const struct function_desc *function = &chip_info->functions[i];
-		const struct pinfunction *func = &function->func;
+		const struct pinfunction *func = &chip_info->functions[i];
 
-		err = pinmux_generic_add_pinfunction(jzpc->pctl, func,
-						     function->data);
+		err = pinmux_generic_add_pinfunction(jzpc->pctl, func, NULL);
 		if (err < 0) {
 			dev_err(dev, "Failed to register function %s\n", func->name);
 			return err;

-- 
2.48.1


