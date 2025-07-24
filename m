Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02860C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6808E005A; Thu, 24 Jul 2025 05:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E518E0051; Thu, 24 Jul 2025 05:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3CB8E005A; Thu, 24 Jul 2025 05:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68E3C8E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:24:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09ADDC02BF
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:44 +0000 (UTC)
X-FDA: 83698623288.13.282D73A
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id F31C01C000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=oIFwtj7V
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349082; a=rsa-sha256;
	cv=none;
	b=f+w3AOazc+kloXL3CRprLuWcAKL6ZurEZphQ5u2p6Hna/3JdIGLMGarwbTWe4nrxYVvtjE
	bilid8ET5K5nb7QgUUpEqgMi23iRFJK1veyBquW1RewkhloDLl6M+gsghBIpn5AHuc5weW
	Nwoke8e2BKU1Wx73gFe3s8+s4kBOSqA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=oIFwtj7V;
	dmarc=none;
	spf=none (imf21.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.53) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enHFJE6UQ4MedDyqBD+KXxRCiT2/woFdp52jlXH8+kI=;
	b=djx5lNYS0Amc0KBJ3LhX92E/glskN1hD4BO+LkQd5Q34DdgmGgfWV/SSP0M5mHH0jEmATs
	FSv7cBVMnuar2kloxOv8NUBViEoY9KooWekVaA6TkzvGGjIDyVMQZaQdz6PRZtn6EtG/vJ
	xCrvYvOGffto40BdueXfDJnl5OjEuu0=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4560d176f97so7988955e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349080; x=1753953880; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=enHFJE6UQ4MedDyqBD+KXxRCiT2/woFdp52jlXH8+kI=;
        b=oIFwtj7VqhHQFurA0piFqpJHZJai0xPRFMQ3c+yz8Ov67oMyUnsdTjkgcBt2r9Nczr
         iOqjNYcuKCb0QtuyRJ846kh1wDTYrqToDjvYIHq4W5Tj1aTy7BDOwLY93EslYEn8ZTJj
         x1UQPnZz+btoMVuSmEnE0l5XMGHH7asYp9TXW4SCHBGAD16xUzVKSr7yrHd/VNS/0caG
         CmSBK/uDTvW8aPnJgwRCxGGP76cZI37Vb/fZzfJ5o/xb+JL+/kFlh5alwN9s1VjK1EZz
         jU+F6ah+WpvGFe8zFw0OKORwMdXytY/sBklKcEN3Fa6e9btGUdkY8t0vxqq7QvET2UbC
         B6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349080; x=1753953880;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=enHFJE6UQ4MedDyqBD+KXxRCiT2/woFdp52jlXH8+kI=;
        b=Vq76IaPXxOppOLcKYats4gh8CUfzyeMEkapTf2QKnlXVTPGxzrtbzt37eMTMJeIPHx
         TUI+7p93tKM65hfqUpI8gceoPGPd5YLk2RQrauRpdI3NQraSiOpeSqrFiitN3nyGu1nf
         YfR7TwFaz68jeulBO5tLetbPIb6czOUVl3Yy7jEhYHYHb7Nc2dzCaLNUbnfNDkm5t6cZ
         ihIjZ/IgjsH7Tg4cFP2sL4baV9RsUe2/Hk45w2xCiYep8eDyZrAJ5ubF2EpsBzIsUJ3g
         TQPvvUwJxYirjJODd24bahAyqQULANlyOt752OxTiTFZtzxwU5jlpq6VNJRm2YngK4vj
         Ig8A==
X-Forwarded-Encrypted: i=1; AJvYcCUJaBN7Dz+kGtGLQAFc676eKqu3I/4DFcN9y0ZXuKviEEgHzxh6Ne7RxcmjA4rtrcP8BvDooxPlJw==@kvack.org
X-Gm-Message-State: AOJu0YyZicHJ5ItZRch6AW/dVYEI6wqwyAWmpcmZVUTKO2ceDW8aU5Xx
	flusTFUO2bcSU9FKX9ZvqHiyykMYJ4f1cx/B1yv1Ig0qlq8dSxgE/zkN/4a8SLjqUJA=
X-Gm-Gg: ASbGncty7zSzGJQBf0Mbc5vl1VxdNSN4PczdBe6w6LKUxNbUf6Yfcb3qVmByST0pkIe
	MyarNyhm2NHG0A9Vt0d/uZHICmsJ0j1Nul8adZi6FPt0qIGSDDuyS+Wysq1ceO0rkaVlME3mYIa
	hqv/xohhcgDa94c3USOdLSmZJ1l5r35rQI2towYdCXmbFFd3fmpKvF20MEnqXbJ8B9lucEnFrdC
	WIJLbuMKnaueK+RFmSCMA5efCXMIIOz7yM7ZMahQ9DtdaTJi9pRY8+c5qH9bK06phfhWw+rS7JS
	QtiTMc3v0lCNdW63tVM3tn9QEJidUmSOlZQ8zUa9cdz3SijnhDG3uLUORWp/yciLA622RQ14YYk
	zzm871vEUlAPL7MLV
X-Google-Smtp-Source: AGHT+IFLTaYRX3oZKktSwmTl5BxHaXO7YP006jDq4+wHGsPABKDqUOqQk5SOHVzh8IhrpobqFVAPGA==
X-Received: by 2002:a05:6000:248a:b0:3a3:5f36:33ee with SMTP id ffacd0b85a97d-3b768ef3913mr4552377f8f.32.1753349080240;
        Thu, 24 Jul 2025 02:24:40 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:39 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:29 +0200
Subject: [PATCH v3 01/15] lib: provide kmemdup_const()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-1-af4db9302de4@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2062;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=4C1RHZTMKgGSo3gXRAvPeC6y45wc3aHImSFGh2Fz1QE=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvRcDL9XPXeHv8dyMY2ypjsvbwhNFFTJNmoy
 2AX+ZslnGaJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70QAKCRARpy6gFHHX
 ch0XD/9I+1OijkQL+cye+ZruBlaR1Ib2UfMF0QEOwEw0hfteX9fTl34LlB1334pIq4xxhDMyq4m
 FZH5qMf22U1fVmLVGDs7Py/y1aFeIly97+9z4U2zlOSQ6KH68lmB8I8pmA79F94Ls0nxwl9MXi9
 A2WDTXvSoAA2nloXBT8D/2nv/HDVzSpY55mNCZn0QeI+lQwBhC02oOwDN3xg+aXfkSCzERHNLUX
 6ccd3tZpTYjYcyaEzdS3Pr8xvrq/CKlcGx/7UWQO0XPKWcYr7NDzBhcuZ/Xnciwnmf+4bHDTfsj
 N+QXyPhCYpNecz+o9HYMzcZ49hkbaDDcHRzqJ1QAqMopPXRH2Y+uuN5IlTCvLCP0CxYJrSNK1Ir
 +t/tUQDIsNKH0oe60hktWfTdSPocCQ+A/e6joTSg7q7rwlh3PeajuYoz9tdr1v4bN3ZCgNI5NSy
 vb6WLdiiC8zV317SlA2fotQFgGqmCmNXHZ1MxIG8WdADW1csMF44skaq6TtMIu6B0JzqQVnJSCL
 4ZhGqhYsud6CNJbYGa9BIZ+m3Kq6EysSbLmBPCEpH0cgs5Pui2X2PUIf6BHelaLNyHV0ckYn+Vx
 XUDG95SjgAiMT6Kq5zHT8VPY91QJwnLtOaPEAM/z3cF8qGMdmWR5fJT0BUlU6e7t3nqhfPtV96G
 w8wHIy7JPNlWP+w==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: kbzxandeebjtkba7m4zy1xykh1y19z9o
X-Rspam-User: 
X-Rspamd-Queue-Id: F31C01C000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1753349081-305460
X-HE-Meta: U2FsdGVkX197YUL0mnarbrqenFaDhMPbSW14GmAdADmgtnVr1HGBmYsUkG2I1P1aW3j745ZrR8QIb0FjxWSK0x+AUFdm5SyoNBt6V66R/ne2OFAvKs+IXmGmX7/lt7/FPbiKuWoXij0m6vStoAXGvO9IDUl9aBX3wk0bDFh1aMXjPWHJSF6kCwBc4C25k1Ok3z0LFtsiFf2kUlbJ0YzIo05Td3dgGlYTDNBbG1WFNqsCnxageaUeorQ0pFfZMjbh+lgvkCNhkVBnTtX/mJ4crm60qz4t4zvPaXyfCYFLQ/km+6J+06WJElEsv7kKMEATv+c30orMkTtk7+Wugfx3rkQav5IPv0d1uIMwFVk41quOMPck1JpryAqcVMvna/NbG41XhG86+9v3WE1WF0nPi2rki8TBfv6ndJ16YO1mKlMEDnMWfeUh4ffby+nLJhXeFiR8Ebmt3XV4/qavFYt+il/3PdXHub5VtYo2msl9EjXlHVPj/TtIKOtna9OkcOBT8ljwvHc53KsDH6gBGXAeMv1sAUFtZ8jP74/7pSOB4Vd3G3BOVGjsmWK4g83yrydcN2DiqZkgvvslZyqewAbzcqBuI0n1300mY6IAzvzgXOs4BZLJybmHRlESxv0vpIhK+ZTQBdx+qUHWhfM82kIsULGUSqy9CffB1yf63fZx5CU0DBqsQKdc9DByQAAQzwtR2JRL3p53UpZlSbsH8t6PykOVZLcov0UKX4zjVyABvLEzHK60pT/Dn2+NWeL/EpoFzEEOS3so5ncsXgK1Cnx4lYMpoTr4BA4QZVEvRvpIupmo+eIvIYHw1IUUGqDtbYKq8El/IeQnSkaiJAQQsYZ8fnXvTOhtczwy+uM/p7yPONVPpHr2wc4OCWDNn/85kCVpMmr5/2jJuZGGPdGp9jlTglI1p+hN00+HwK5KnlaYWM4XYo/u72RdXDzdnsW6/ATMFap2jateNfkS4nej3C6
 SSSmNFOW
 eYEgGwQiF4Oh4Do7SEITifjI6JCo16jIlZ4dpvoYANOiE0VI7nL9WbKW4QjtPPXGmVYLGjfF7tbjVFIDbAj8fGqqhNPHiYWdcr7o9kTPoR+7N/m+OweVatBhTxE3W8USjNx+cCQXBun/PqC6Pc4OOUTufB3tOsxi6i3TFQBOfKcOPMqa4UhgXMox8XTjFbzTQuHEAQ3H5OGNS009ttkZaXBNlD6dlvWBiuaYIHDGW9QVv92KUl+nuKjZoxc1F1fN6CC+fm+LFyqwWC6JFEIi/Ttzu/reWEmKq4b/wU8DL1CEphgBnndAcAA5JMZqn4dk3k2d+g4nUE1Lgzx+wQZmR0z9o+IFKNw6cK3xbcrsAoNIGF74eqDU2e1GYVC5N20nFkSSj6WQNS6UU1lP5AQizvWCKFDKKRMJ1F454dIV1VJaPWO/M4ckf7Es7qmcYainjQwWdI/zD5WPmoIY7OBapq77flIxWNf0+XDfKy4nQJ1I2fd/a5L118iHXkfMEOtgBxh8LT6e5pwlwlhQKS96IB9Nbvf2GZNx2aOMDhjpP2WTLiJk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Provide a function similar to strdup_const() but for copying blocks of
memory that are likely to be placed in .rodata.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 include/linux/string.h |  1 +
 mm/util.c              | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index fdd3442c6bcbd786e177b6e87358e1065a0ffafc..1a86d61de91204563e4179938c4dfc77108e03aa 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -304,6 +304,7 @@ extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup_noprof(const void *src, size_t len, gfp_t gfp) __realloc_size(2);
 #define kmemdup(...)	alloc_hooks(kmemdup_noprof(__VA_ARGS__))
 
+extern const void *kmemdup_const(const void *src, size_t len, gfp_t gfp);
 extern void *kvmemdup(const void *src, size_t len, gfp_t gfp) __realloc_size(2);
 extern char *kmemdup_nul(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup_array(const void *src, size_t count, size_t element_size, gfp_t gfp)
diff --git a/mm/util.c b/mm/util.c
index f814e6a59ab1d354b8cd04ebf3903626f6b23a6c..f4df9194b0c69c27ff06e6ba1d1137c559035470 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -142,6 +142,27 @@ void *kmemdup_noprof(const void *src, size_t len, gfp_t gfp)
 }
 EXPORT_SYMBOL(kmemdup_noprof);
 
+/**
+ * kmemdup_const - conditionally duplicate a region of memory
+ *
+ * @src: memory region to duplicate
+ * @len: memory region length,
+ * @gfp: GFP mask to use
+ *
+ * Return: source address if it is in .rodata or the return value of kmemdup()
+ * to which the function falls back otherwise.
+ *
+ * Note: the returned address must not be passed to kfree(), the caller must
+ * use kfree_const() instead.
+ */
+const void *kmemdup_const(const void *src, size_t len, gfp_t gfp)
+{
+	if (is_kernel_rodata((unsigned long)src))
+		return src;
+
+	return kmemdup(src, len, gfp);
+}
+
 /**
  * kmemdup_array - duplicate a given array.
  *

-- 
2.48.1


