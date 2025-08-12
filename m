Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2E6CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B668E00F8; Tue, 12 Aug 2025 04:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86708E00F5; Tue, 12 Aug 2025 04:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8D78E00F8; Tue, 12 Aug 2025 04:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2948E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DC9B1159E1
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:15 +0000 (UTC)
X-FDA: 83767425630.22.646B131
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A335180008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=AAMXhPmG
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTEYsyiptWWjSso4TZTiEeMehJGAEz0s92KPugL0Mwk=;
	b=rERJ3H64QPDhho6yJT3eey1OuJkD2AY9gITn0LnWB8FG9qqn1ycw3HIJItbzHq0YEJl6x5
	LLxVy0TW1IWAm48ybtgAHnxfa8KcEGoJWMRTz9cfF/vKxK0Wrx8b/JnaG9OZJctJ4U+CZq
	EnopukoRhUDflz5AHrH2GcKgURQwS3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987233; a=rsa-sha256;
	cv=none;
	b=gPupblF+LVKXsw5tOxuVzU5qxnmjJRgzG+ANL0nEGWNA4CqeNx1KAwzprjynvpE5Skif0M
	+NYImbd7qufb6LEr2sG2zX16yGcG0eVTxjwohsO4FoH1i6aWr0F1sQPtmY3X99shWH33N3
	XxmsXwvH7OZTo7tG5b45Ew2US8owIS8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=AAMXhPmG;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.46) smtp.mailfrom=brgl@bgdev.pl
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so35370185e9.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987232; x=1755592032; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PTEYsyiptWWjSso4TZTiEeMehJGAEz0s92KPugL0Mwk=;
        b=AAMXhPmGI9aBNXRfN1g/RwhgbUeLDYgxM1aXbpYIzOVaGox428THbnwkkbFXdHRorf
         QibX//d0mU/U9syoxRHV23h3iXHw+TCWss6L3gjA/sMTjEWgVj5Y3vSYIwhDEkCDOCTr
         phuatiuQFefHaXiCk7yAh17rKmw6Pz2JyXADlt2yReiImbaNwtWyhS254bjyd1m38trs
         0ZwERIjl3BY/LpzeKK5LjUMhrWHkVrChE1RcEfO/Q1fNTsac+TIkxj+19J2881ge+Rda
         rcI1i8iZFRNL9hYCyGsZ92Qw9twfylcikazyzC5VkzLt/jhzq7eL7c98odrTHDTrG2yQ
         R3ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987232; x=1755592032;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTEYsyiptWWjSso4TZTiEeMehJGAEz0s92KPugL0Mwk=;
        b=c6PnKq4CaFehg3/sy4ZQjgoTaTFqPP89pxPykr6UBbm8GtX/h539SFlEQh0vWWE/AE
         6uypLCN8qOciXl1/XZMMCdEsKCvCstyZeg27n/SVbaiqTwzlsQPk/F54dBiWu8vIrNtp
         LQUyvCdbBFbryQga5uIaVC6GcVBDwmfAlNCDxgVQARUFN65o/4IF1OTSWnv8JFLnzrEL
         XthnkUXIgNbLLcCUAw/M8iC7q29v8drH6sIA8EsJbMN6dEsa99p0dQqytQA3w57ZXf5D
         CaT1wugRV6PQgv+1eo7cuIdoBI7rvGAFqRy/diTqX9DGzG5jVDKAzqwfI/QZ6+Mb9SU4
         315Q==
X-Forwarded-Encrypted: i=1; AJvYcCWt994QdB/IWbcPCY6j38IvPgwIpZeifPm7IKeV3A2uFbQygOuSBzUf85M/0fBHp3Oxru0BcTH8UA==@kvack.org
X-Gm-Message-State: AOJu0YyZRWQsKyyvKjkX4dsgiVkodoyaoZ5FH09ExkXZsHtqq/kqUgGu
	2IqGDsuTFM3zVn682s79eNdM/ivGOnSC37kom6SgSp3cbUgpH1XNU+1iQmzGxD9e40I=
X-Gm-Gg: ASbGncvoNYrRJWbJyQw1zx76Fcb2yUoF6CIJ+xaUPgFJ8mrqaugSCEr9wjkjLV4vfRE
	NoRQqVVmfbfm22A4hA78DmHl8C/uGnsAhVSoDwhGVfWGaP69Ri+beolNQ6vSyFcrl4WBVi0OQu2
	C2A83KU7MybUI/C5YzKewMDdegFuhy7PhRlHwFo3yz2GHNjcI1DMBHdkOpBH3BWvJne3G9udPMg
	sLS3dRTIgsuBkwg6+19rbPtqGeN9qTGzgdV7tSP8mtlT6qJXP4J3kLs81IJhfxkMotECbv7R3sO
	nY+ys7HUgT0Ol4irFf8CWVXQmM3bhx6WMXd9kO7TyYlX6pMhVD6idoiCg3DxE0Jhkd+h5m6YmTo
	HVW4eDhKo+3AjG/Y=
X-Google-Smtp-Source: AGHT+IG9LeN0OGOpXGyWbmm1lDOX65hlsrf90WSgSnAgOs0kyHwhrmmIpnE1O9UZJd/SZOy1ZHJldQ==
X-Received: by 2002:a05:600c:3547:b0:453:78f:fa9f with SMTP id 5b1f17b1804b1-45a10ba7e5cmr21860695e9.11.1754987231433;
        Tue, 12 Aug 2025 01:27:11 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:11 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:01 +0200
Subject: [PATCH v4 02/15] pinctrl: ingenic: use struct pinfunction instead
 of struct function_desc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-2-bb3906c55e64@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8989;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=ngwvMKiL7WjeArNFSdBs/AB2ylnC/fm8iV0Ni8uhrlY=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrXKwBoZmvE6IqRK/h3ZfdqdJFQZiTnlv70d
 0TzN5CgzNGJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr61wAKCRARpy6gFHHX
 coBFD/4wcnUgTwHXpY/uuZYNyiUo9QpRYkwTT4+3smLqrIAfe1q/XXvhhAoQ+/aQw+BwPHC1Pqe
 URolaN2+0ZqnzObnyMNpniI2IC7VUPkk5J11eX3f/S6mok7czKVmR/i1jreEGRdVkM1yUf/yDt/
 I6Z7CQQa6xH+FdNkk64zWxkgSoAnEYO19mpzTsgmUHqLdEG0ut8b6vBARWjxewlFBF4GnnRx4RY
 mhR0eA8lvQwMEuBZqJDoKgZzAStqpzxWMGfn0e05earrNGZfsqHNhH60bvz+F8vaic4acPFlecE
 4228aQB6xOgjKHtnVdTlKwPqLHFT3+cfo3+TDOCcuyEGcxyAn8z70GU45gECugeUHjgrHp/O+8H
 p9EWkHp3hAuVIrF1hVIgr0QErgg95xVrK1q4GUTSYVfKYXlfsTHd8S02gKZukIoQpExm3vIeQ50
 Al04mUPYQXZBQYHJBkblS18qmlIYbPq6/jrN7A5v1Ggs68G5Qi0oN5oRUf6uQJ0x1z//D2mqpGc
 WYFyPYKktKiMPzV+5AXpocoXbab16ifpTUFPIHL4xf0b8ALn/+2C0lSO529yQXpQvEuRwUH85i1
 y45Arf0XetU0vF5mGd2ZIK0Gvqy94EI2JkmCXh0hBxf7NQSuohuFh8zkJpLykAW66Xt9MNem4kn
 6qeKfVolA8iijvw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: p17n5spftw7hppiqftknobtzjjnqjptc
X-Rspamd-Queue-Id: 3A335180008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754987232-940386
X-HE-Meta: U2FsdGVkX1/2uVvQPtBUu15sMETk4GAKJ3QxupYpTcfuB4KauegwNVpGTbt/JpQZ+yXs8sLCYcoaXwteB/2DaVkpHj28FsWbt+rT92nhQTA7+2E2piaoY1T52qq7ms0ZlEjc4Medjd9dX5fPn6aP11YO9maFEUZGjpYD4CplcViRJVsm+sXq7abeBd2tw9ruWdq5D8fbITQe4Q5c/A7nFBS+9vhTGUdXReX5nqt2Ch8SIDdRibAiO21dR2la3rheyN78qmfuJJPPj2ZG609GPe8jsdHmzSO+LTMxSOnwD21JGBc8ZlONKBI2iXZ6tRhpPGfKnwiUZ40+57QHvK3Ak9V8i0YkOErdcOGNBv94Mc8fQ8ep/68bJffD6HdXxXJAprJqipH24z1u9+2s/1nnlbeqGMlzRfx8ANnWuImrkqsNWhV/BbND1TH804/9sVeQWte0SGz8kzXyMZPeYJTtEqo2+FSETEloISEJAZ7Dsci0mXw3wZP6+GXZsXZBrlFzuZq/YD/2R0ZBSrEtKyNOkVrWzW9BtOUSMZCZzN2z6nokgbeLUKmcL0QoHoI8b6jrdwX0kogLinWaSfBGhDqtv0MMptKwH6VxinkLP4frAk38xwa+X6om+WLOOsA9FZCGTwTqao4/CQyr6hY9slABnIU1PjJiuo0/ALxH2cQVGR7IwwzYd973kUawNUbcyQxIalDxznth7aRNwar4A71ijR8TTssHO0rG3sK/1XzfM/2A9i55+gsdbrfiDgyyIT3yx3xfsvHgW7VTxetFebbz2VVqZf9oUwbMPglDz+iNIHLgj1k2tkwZ1TRhDGwmM6gWksfRaWAH+3EUYEPN2hS7BanOLiOrPleL5v4cx+2GwT8h4JJo1K2QytaAlXbR8XfqpaOkeG+NmjkXqVbJOZnTGCu/lV2B2WJQ4q8kus1UYnFntHwDrfulWgTa7f2ydjmYQY410MKWhk+koIIAnz1
 pHbIsaAN
 6c/1zQJaD0Tdw/luqV72ie0h/M3UgK6/NcRfxN/7Zcr8JBbJ69ALPcFXPEpxrA5NIV7JLVNgAtVleDR6hKbdKjRy9QAiwZS5oSFjXtxXrzrI4surL2XLyNPE+Uno7z/iKsDRA8IiZ2qQ6LkvGFhDCTphqw1H7pzeqfmXxwClIuFqJBWOTJxLWlhnAFcQD1VrfIriK8td8ybj6S5n0RyVP4BbRya908MB4bBvkIucJ6VFbYI8aZs7cUQUzPzC1Kmq3acYBRhkbhDbDn/SOAKRrne2bZSDQf+7aHenwV1RxLpPnluT2qKZAQhgqFaE+DUel4dTWfRN2Ii8uO7VUfa0KYK4S+uqc1ExRV79pJ8f/bjqR8iZ63naX4hQmaGFMoAC4aeocZH8t7P/9vVEEC3WqmYG9kiE14a0iWk3XqbJY40zPsJ+wTDXdwJE+B4z1DDZhoq3EQqiBLE+78SBMWVCdD/PX3wIHgA6cA144AqQKjzrNIHpG6cAKdEM49sCUgAyg89e5zAs37wdOcDo1fDRAFk5CoSt1/us/v0ee4OWqvjm+b5JCMBqdotdFYPsJU20vG9uLyGvaEVsLBVARwQewQdPFMiMTkuPT1GwUET8y8JwYLlk=
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

Acked-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinctrl-ingenic.c | 45 +++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 2900513467fa4e2e9374946fc9c7a30d48aef9eb..af9d2f3081859bc4b22f6820f3b3753eba36f959 100644
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


