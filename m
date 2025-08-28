Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6DCCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EAF46B00B7; Thu, 28 Aug 2025 12:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C2C6B00B8; Thu, 28 Aug 2025 12:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED786B00B9; Thu, 28 Aug 2025 12:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1C66B00B7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F144D1397A3
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:30 +0000 (UTC)
X-FDA: 83826628620.16.F7D61AC
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7F5A414001C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=vAXpeylt
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396828; a=rsa-sha256;
	cv=none;
	b=8T/ABq7yNRl1KEyiq5oCqpFqsw7sYKOkmMVfYn1Qb+xjeEEl2iVKqSNUuTJlg6XpTBFtCr
	cjQkb2Pmd+WFvED+RxyfVzUU047NoCnu/1DoLINttccKjtKqepWTRSAoia95r1/2QtZl0U
	MpN5MsulKC0zTXLDcFAe9TbdpTUZ+8w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=vAXpeylt;
	dmarc=none;
	spf=none (imf09.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.52) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lc0/t4Iv6hjqG5kcGiM2/0kFYGiYqDN1ZHyY/21Fkb0=;
	b=vzFsjtItwcJfcPH9BsQWzCUXVqw0YPD1a2giMv20W79d+FPH7+WkNW+how6eTvbW/kjoVZ
	3I3tNhmYBK9Hm7PjbBiHp+aKK4Il4cKE52dXzGWVXNZdcFscmEfEsccNedm9H3HedLJoKa
	ACrfEkzNcpYCxFRSW7D2t65aLYxhOnc=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3c79f0a606fso714366f8f.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396827; x=1757001627; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lc0/t4Iv6hjqG5kcGiM2/0kFYGiYqDN1ZHyY/21Fkb0=;
        b=vAXpeyltpRextguubhwOZqD/uW204Ut5ynjtM0jvX40I8SvzavNHfsOE+rww7nqqFH
         QX3UGMosq+eUy00Y3l6EGMhbffnnaRjsxYH3gLnO+RsWJt3Zl/mqzx4VrfedHPp5hvB0
         d5U7uRBjtBZh2oa9SU9/og4Bc68BouclZuJKN9RARg+k1CYHcNabaQqen++GKPnWwVVU
         Wi73OHG1qtMig2XMO71w+gGlubKG+UV3Y7QI8GxDgVjYOnGOV7FNuStmBsF4B2fDuOJp
         cbJXZ3xuBDw4vElALOJ8Qpyvnv5bOKTf5m77F2v7VGQMiDsjeEHZDDsAM9u4+4HEZoyI
         ZwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396827; x=1757001627;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lc0/t4Iv6hjqG5kcGiM2/0kFYGiYqDN1ZHyY/21Fkb0=;
        b=mlZqJuwO/cbFjDVaySYToTrdbp0wBzzwCgv7JBPC+CmkiDdRyUOSOWS+dMphBQkwHz
         AxLT07Dd7oNfmO7P1dJqQnK0NeM3RJEyUVV66shlzHkyMDfpmiQiCGkLZ+ZygB363502
         pBnAtoiksngeHwGeb0g0SGwePpv4wJjLefZ0p2tEy8UHPmSh19JGDv5ssdGUOmlkTHNw
         tDCFQxVA3mWPRSUYX0mbeTDaZ75hluZPRfcoea65wSWZEftPNu2kQKaMuq8+CKYKkoF0
         6q/hG1NuQcSgj+HF15ZO9NLk50WQL1wcW/vaWBp3Jt9hw9UntXKjuzmE/Miy4mw9VM1H
         Wp3g==
X-Forwarded-Encrypted: i=1; AJvYcCVYInZtoMo+df8ywrDHEgECky1E6mh3irNTydj++mPmTHMNAsrc8AEtqbnxudbSb6n0/Yb2caBlvg==@kvack.org
X-Gm-Message-State: AOJu0YykqEc0gC2OPm7PftCQbmEsJBcq8v2fXeBXe1ko+kVF8R2BsyUB
	70izQosk/I7ui147ue9pPFKT3YzdPAZG4aZCg/r3axuFhF83QNR+/wdkfI3H3c+e8y4=
X-Gm-Gg: ASbGncsGAJd6h+FE7CzOL334C3l47nM6uD/DbANV9e2U1/A4/nl8codnGd7dprv1uab
	HsTGFzMDvUfeVakcuDwhH5At5vxZIMylsf5EfVhV556MBkchfzyWW3vrOHjv/HFSDucxsxbYyY5
	cYyjpUFw1J/ss7Hn0UHkGYN+Ka+hIregjt+EumVIciyideYwqtUdCY/IEnp1rRPcIIKc8B7qoNR
	/6WxhWGbV3XHkjNyxtlykKruO/QLvbqJ1Z6BDufcG8BeLRaNEvIfEndZwJ33T9mnUWLahQeq3Vw
	wop+G6UY9BjQpmDNUH6lRtN2KT1MXuIcxMSjk84DRNoVAByoxK6wDXFKoMKXUmQHvqrsehAU+Ww
	IkZGfC3IqQbXYL7D75rv4mVq3evb3
X-Google-Smtp-Source: AGHT+IFw6qjlDrmse6RIf8UYoO4kDt63oBcAlQpSlQsPEor2cX/h2xD8mZ55YTiA8r3CiuSEB2FkQQ==
X-Received: by 2002:a05:6000:18a8:b0:3c8:e9d3:c392 with SMTP id ffacd0b85a97d-3c8e9d3cfefmr13313662f8f.19.1756396826703;
        Thu, 28 Aug 2025 09:00:26 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:26 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:13 +0200
Subject: [PATCH v6 05/15] pinctrl: mediatek: moore: replace struct
 function_desc with struct pinfunction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-5-c9abb6bdb689@linaro.org>
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
 Chen-Yu Tsai <wenst@chromium.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7850;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=9BKGEvZq/gbYunbAXK1ZCTf6DpFoadfRkbzoE0vKzXo=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0NGnR/oaN0Wnl61ZnHBstpsOmWiljwo2l0c
 m+BpaVFx3GJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DQAKCRARpy6gFHHX
 ctZDD/9arpiDD6mR+QK7mS35XxuNAxcWS+ucQzkDk60d4EWb3psp4VvaVeZ1/IUU630zQgfjTV+
 t8aXJb1zZTpyRic7GCOOuf1+bIBvDH8W7iOX/fgOfp6ekoa4e2r9SG1TAKkLlNtWiRSD7kTvPll
 hqZ/DVYo6WsZSaEJWD7S1YQX8spONqMCw27NzpYs0/GCrRRu3wKcemsEEtsZTfGnqOs5PyLOhOr
 mJzF7oEgPL8Z+Tjz0VbSghib7drK1N2+Nv6vXAxMf2B/Y6yfQHldQrgh+Ck7L/ILDzHNwh0qR4n
 LmfSVoUXKYOkpqH37fE2kXKTqGkaD8XksLO6dLEyMLpwhAEc4dmcAJ5XqVN8eUjuruuAmn4a98Q
 1w+kacPImscDwDmEDXZmZIOLzC3JctbrU6im1b83JR4sW2+is22ir/s/gD4Z91esiFPnvy7kKdH
 SaDnpou2t0/PngZP5d9dZntxi/1FvyJj0OlX2yDxfS5QzrkewdS8kGOkStkdNt27UVqWnNb2yCM
 ZlBarFULOF621HTFSzpty70XsCw7I9ez21QupBpDOUmv2KDTcbcm8iijkGyxtFqeHpy+HJv9XD4
 do4x5A6LTUDY+JBK10h9X3tLsDc69G6w4vnGcuSQ2XD8mNJHPeK+YpFObvarI8Rht67YImonRX3
 sKIK4iijqJ/NJaw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: 7F5A414001C
X-Stat-Signature: tgf3egdoxqwpay1msf5d7awrtcbbrmj5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756396828-998651
X-HE-Meta: U2FsdGVkX1/RWOJHav9K3Fgnuee3/g00tNW5TFotbNvILs+0F+ZWgqf4WyyNLfJnzd2n9DVmJ7Iwh144aVLYx5oMJju5A8dr9UsnGsdeLQqRUulnBgwJtBGZVyXrwhbJqr8CkDO+L5Ja+tGfzCgN3arTGL3QFE2/FWcphOvj0ZQ8KDd7o85uFGVzO+NJIBqb2gMNXTa7/YiiTt5/sxpHohz1+MLpQTqOGe5Japx0bWekC9AFjAQc8eFkQpjuvyzkXfpYgDBBlkiei6i9GQ8F8557TNo6m/TzlKdh8IULmMXs9Kz/XVNCkoAdR/2Wgmz09wW9MGA5+Xy8F4QD+bdwtZTHk5xzk6dDAldux0KwaOYV9fotsEVVWnFfeOjwX/+W/qU7G0M5wro/otDKakxrwB0a4W1SJGxOM9b1Xc3ozt/zGtfZ6pQReniTItzmbfNWOwkT+0MwPd5AyRLMF/v2ZkjeSsdEjw3VHD0xb79HVy2sniUvn6dRR74rcMSUNBQXEzH93mTVMc85sYieLCUwIdWxZEGRfEroOUlTZWY6uj5mIPdqhdAv7AohyNpJ6x1xbgqvtDl7Sh7Wz06+/1CjkTBnfN2comajkkgmxmNnN7yO/zgNjBfmTLJn94k6GPNlDX3xZZy0cjIw8kPy+aEcDVHQyAiPb93BwGSHnmEDo5g9t4XMsK3FfCRQcq6Y85mmVrJaM42xcKobDuSRmnGaHPzU7xMHven/hNgN/XKRulukdCyXwCb1mz5Tmnw7CR/XCqkqH6+Bb/ucT3vn3M7tyqvRnVSvSTnC/UvRddVRJTnAMPCgX1tGskn0P+/M5YUxxl0VI+arxeSzvC6SvbuTxzRQs1NRWczHQn0DgLvPFpoynRNzh/9b7c2zaHaIwxEPVoCv0wMeO5tuLt6/aGvF3CMrfVv12SIS5gLCPkbLAArsttWfruJpGKKppQ4YVxRyX/WNTeq06LPk0UBXMVX
 kc3TF6B+
 eRwGTovGE87awN+EeGivD03gfYZmEZ8Uzfw/c2vacpL0kGkBwdyHED/VW9UFXEs2GRSoSEcekj1U4TAP9lVtGp3eTRz0uQB4u8BFht69UfsSIU+6h4jx9MP4Li0kG7e4OfM5ctZmbxCSVJiqZOxab2MzPlK/FHwJHXTfsiHK6+gzYL5nfhPxjBayXQmrVWB9mKi4eYTkHygGe1og0FLtKz08phC1QWDjHLjxSHV2aetb9Zo+riFcKnCW9BbAq+co16yD9H2DqxmWwbipCt3xJ2Zwhp0/LGlNA6WuH6SYKuAILowMA2uDTT+WlF9LUtbt9js14XpuDtbTYlrC3UDAnda/qBQ+OIRZqlHZ9CCx3UCbB8sA4mYpV3rYihyajQvhPxYJVGFJreUrdz259LXnB9d0kGDX3RlZH8rGa8oyEu07qxHJdl0nD+cSrUEMw7Xs9gkqJf8WUNMqVYf4fEo6liMTIhQ88ZpFZu+rgvHX6QGgzodIEbO+hYaKmpSs3C3/p3J9Oc+NGa5bRRlN/VdXIlKNVKMOM0hZ84+ipJWZm9YsGP6w9dHiBuhYnBZPbATAlCqWp
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

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/mediatek/pinctrl-moore.c         | 6 ++----
 drivers/pinctrl/mediatek/pinctrl-moore.h         | 7 ++-----
 drivers/pinctrl/mediatek/pinctrl-mt7622.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7623.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7629.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7981.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7986.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt7988.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h | 2 +-
 9 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.c b/drivers/pinctrl/mediatek/pinctrl-moore.c
index 6e4f6c07a509326a8a7e88b2dc32635b22e7b965..982b9887521d036538f67e9919de444693c458c0 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -622,11 +622,9 @@ static int mtk_build_functions(struct mtk_pinctrl *hw)
 	int i, err;
 
 	for (i = 0; i < hw->soc->nfuncs ; i++) {
-		const struct function_desc *function = hw->soc->funcs + i;
-		const struct pinfunction *func = &function->func;
+		const struct pinfunction *func = hw->soc->funcs + i;
 
-		err = pinmux_generic_add_pinfunction(hw->pctrl, func,
-						     function->data);
+		err = pinmux_generic_add_pinfunction(hw->pctrl, func, NULL);
 		if (err < 0) {
 			dev_err(hw->dev, "Failed to register function %s\n",
 				func->name);
diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.h b/drivers/pinctrl/mediatek/pinctrl-moore.h
index 229d19561e229c77714e5fccb3d4fb68eacc77fd..fe1f087cacd0446e40628cb4fa35a135496ca848 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.h
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.h
@@ -43,11 +43,8 @@
 		.data = id##_funcs,							\
 	}
 
-#define PINCTRL_PIN_FUNCTION(_name_, id)							\
-	{											\
-		.func = PINCTRL_PINFUNCTION(_name_, id##_groups, ARRAY_SIZE(id##_groups)),	\
-		.data = NULL,									\
-	}
+#define PINCTRL_PIN_FUNCTION(_name_, id)						\
+	PINCTRL_PINFUNCTION(_name_, id##_groups, ARRAY_SIZE(id##_groups))
 
 int mtk_moore_pinctrl_probe(struct platform_device *pdev,
 			    const struct mtk_pin_soc *soc);
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7622.c b/drivers/pinctrl/mediatek/pinctrl-mt7622.c
index 2dc1019910662a2a52e81f277a10a32bd83b33d4..d5777889448aab86e82fa6821fdea0d30a5a7246 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7622.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7622.c
@@ -822,7 +822,7 @@ static const char *mt7622_uart_groups[] = { "uart0_0_tx_rx",
 					    "uart4_2_rts_cts",};
 static const char *mt7622_wdt_groups[] = { "watchdog", };
 
-static const struct function_desc mt7622_functions[] = {
+static const struct pinfunction mt7622_functions[] = {
 	PINCTRL_PIN_FUNCTION("antsel", mt7622_antsel),
 	PINCTRL_PIN_FUNCTION("emmc", mt7622_emmc),
 	PINCTRL_PIN_FUNCTION("eth", mt7622_ethernet),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7623.c b/drivers/pinctrl/mediatek/pinctrl-mt7623.c
index 3e59eada2825277b3d7500cb1f2cf740242a4a8b..69c06c2c0e21e4ce785f65539254eb070bff9a0d 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7623.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7623.c
@@ -1340,7 +1340,7 @@ static const char *mt7623_uart_groups[] = { "uart0_0_txd_rxd",
 					    "uart3_rts_cts", };
 static const char *mt7623_wdt_groups[] = { "watchdog_0", "watchdog_1", };
 
-static const struct function_desc mt7623_functions[] = {
+static const struct pinfunction mt7623_functions[] = {
 	PINCTRL_PIN_FUNCTION("audck", mt7623_aud_clk),
 	PINCTRL_PIN_FUNCTION("disp", mt7623_disp_pwm),
 	PINCTRL_PIN_FUNCTION("eth", mt7623_ethernet),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7629.c b/drivers/pinctrl/mediatek/pinctrl-mt7629.c
index 98142e8c98011d17339da74f61d6f917372dfcd5..cc0694881ac9dc536db0e46eefe5eb7359735a60 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7629.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7629.c
@@ -384,7 +384,7 @@ static const char *mt7629_wdt_groups[] = { "watchdog", };
 static const char *mt7629_wifi_groups[] = { "wf0_5g", "wf0_2g", };
 static const char *mt7629_flash_groups[] = { "snfi", "spi_nor" };
 
-static const struct function_desc mt7629_functions[] = {
+static const struct pinfunction mt7629_functions[] = {
 	PINCTRL_PIN_FUNCTION("eth", mt7629_ethernet),
 	PINCTRL_PIN_FUNCTION("i2c", mt7629_i2c),
 	PINCTRL_PIN_FUNCTION("led", mt7629_led),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7981.c b/drivers/pinctrl/mediatek/pinctrl-mt7981.c
index 83092be5b614cc164590fe5ec2b756fe6579b263..6216c2e057f6499b32741b6bd3a4854878c061c9 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7981.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7981.c
@@ -977,7 +977,7 @@ static const char *mt7981_ethernet_groups[] = { "smi_mdc_mdio", "gbe_ext_mdc_mdi
 	"wf0_mode1", "wf0_mode3", "mt7531_int", };
 static const char *mt7981_ant_groups[] = { "ant_sel", };
 
-static const struct function_desc mt7981_functions[] = {
+static const struct pinfunction mt7981_functions[] = {
 	PINCTRL_PIN_FUNCTION("wa_aice", mt7981_wa_aice),
 	PINCTRL_PIN_FUNCTION("dfd", mt7981_dfd),
 	PINCTRL_PIN_FUNCTION("jtag", mt7981_jtag),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7986.c b/drivers/pinctrl/mediatek/pinctrl-mt7986.c
index 5816b5fdb7ca918486f57a890f73543b3198c728..2a762ade9c35505505c932b6fea75fa0cf77d961 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7986.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7986.c
@@ -878,7 +878,7 @@ static const char *mt7986_uart_groups[] = {
 static const char *mt7986_wdt_groups[] = { "watchdog", };
 static const char *mt7986_wf_groups[] = { "wf_2g", "wf_5g", "wf_dbdc", };
 
-static const struct function_desc mt7986_functions[] = {
+static const struct pinfunction mt7986_functions[] = {
 	PINCTRL_PIN_FUNCTION("audio", mt7986_audio),
 	PINCTRL_PIN_FUNCTION("emmc", mt7986_emmc),
 	PINCTRL_PIN_FUNCTION("eth", mt7986_ethernet),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7988.c b/drivers/pinctrl/mediatek/pinctrl-mt7988.c
index 55c8674d8d66f12d2f2246c215056d4e51296a9b..9569e8c0cec15fb6a4a8e359d6483fa163487b0c 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7988.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7988.c
@@ -1464,7 +1464,7 @@ static const char * const mt7988_usb_groups[] = {
 	"drv_vbus_p1",
 };
 
-static const struct function_desc mt7988_functions[] = {
+static const struct pinfunction mt7988_functions[] = {
 	PINCTRL_PIN_FUNCTION("audio", mt7988_audio),
 	PINCTRL_PIN_FUNCTION("jtag", mt7988_jtag),
 	PINCTRL_PIN_FUNCTION("int_usxgmii", mt7988_int_usxgmii),
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
index 36d2898037dd041ebc7e06526ebc085eb42f2828..fa7c0ed49346486ba32ec615aa2b3483217f5077 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
@@ -238,7 +238,7 @@ struct mtk_pin_soc {
 	unsigned int			npins;
 	const struct group_desc		*grps;
 	unsigned int			ngrps;
-	const struct function_desc	*funcs;
+	const struct pinfunction	*funcs;
 	unsigned int			nfuncs;
 	const struct mtk_eint_regs	*eint_regs;
 	const struct mtk_eint_hw	*eint_hw;

-- 
2.48.1


