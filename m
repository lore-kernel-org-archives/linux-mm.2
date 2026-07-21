Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0B7C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA986B00AE; Tue, 21 Jul 2026 05:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3036B00AF; Tue, 21 Jul 2026 05:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFFEB6B00B0; Tue, 21 Jul 2026 05:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88A126B00AE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:20:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AD46A0AAC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:20:15 +0000 (UTC)
X-FDA: 85012237590.10.1AFA3E3
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf11.hostedemail.com (Postfix) with ESMTP id 787044000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:20:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Rf/Qkx49";
	spf=pass (imf11.hostedemail.com: domain of 3yzlfagUKCBY07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3yzlfagUKCBY07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784625613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mNzxuyo7zY8DBbMGXllxmPQe9PiD3EoZmPKiPpb3nLo=;
	b=hQbRhv1wuhZ884h5KEZu4nrB+KA99eyx9nX0HClNtMiW4RGjiQhddhV2JYHCTSmc1TaRFU
	bUI8rY5sc3+0k06kyBRagHPPmZHN2e/hLFWIhVKIcpEmPmHRw1oBZ8HabdpSLMMgkV08SQ
	/8DK6iHxsRB74pEHM/awajT7hc5+4aw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Rf/Qkx49";
	spf=pass (imf11.hostedemail.com: domain of 3yzlfagUKCBY07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3yzlfagUKCBY07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784625613;
	b=gf5guTH5Iw/e7SnoqnAH/NsluscCU5vrG0BRFBUI4/HFfPXyhlrn1IN7qXOSsiGehgMgGg
	HawYfgBGMxQQwzBLsGuznQpMoC0q/5YLltnlCOkX1kbFQdOdA4Yd9NKM6gbMKtLBk3M3EJ
	mso5G4Cv/ThwMysmoDE0uRUDt51N+hM=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49553d98911so21430615e9.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784625612; x=1785230412; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mNzxuyo7zY8DBbMGXllxmPQe9PiD3EoZmPKiPpb3nLo=;
        b=Rf/Qkx49EkP1399W8Hb3o0reqAj7p+qrbzeb7Kv7ujtAMwi50AllTf5O2cSe+d6ocz
         8hHr+1fVFvW6Dg1DXDStEbhghQq0NK1pPhKmiGAUecMzUoROpTlt+0lJyi/DJKDYeGku
         5QCrcKZWAisyWZXjITle79/bSzsG7MDVOHb102rxyhwjBG/Do1l7gM8teeBxkcu8x4xN
         ihplOz2O2VhgaLKCiU5D1jAP098nZuQrBGPzvrfJXBYFot6NTYaFElnKFds4y7paXBvx
         QOxpHDyyzZ0g7g6G6YXhoVPyt4OmSIVdib7Iuc5M+MFS+ORzO2yUC1CkL4P7dA2q2/Zn
         85IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784625612; x=1785230412;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mNzxuyo7zY8DBbMGXllxmPQe9PiD3EoZmPKiPpb3nLo=;
        b=Hsig2A2lOzUNnf30KDDlRZ0tNsPfiNZvpqo6QlWUqI7RsLpV04IZpfBGuxfAxRpNFv
         Fx1CmZPrkjos4xrCoEOflqO5QlOcGlzmAiu50h2dWkU2GB+VYJB5Xn8eRxOWUTGTAUP7
         EPTM3ihMyMumwoWhv4zd0zkoNx0YkMS/u0RQJH3zny5NB6Qql7E1k6ZaymqEiQRImr5E
         zCappfVs5SbJwkkdHNCX49t4BqR06Qz1dJ0Pc85lU1LzDwMlFIHRjAroC9NlZseyyXy5
         RUwBeMFvMZzwYqIgdvlJ1/E4UHuuwQGAxMG5ky857BkHd8hx8p6YJNYI93qDezwGKJJ1
         IHrg==
X-Forwarded-Encrypted: i=1; AHgh+RqaS7nNz6DpHrFPYAFQHi7fC3kOSTa52AQAe/0EbDHgzdl9aogXGmWiPb7LZb0p9hjMxagT+NmL7Q==@kvack.org
X-Gm-Message-State: AOJu0Yxf68NrPLTIQc71tGsYD5/9kH4poR1lKmp8QQ7OmLCPpUGaEl+e
	+x1XfuSIVtXITSVBRRLRSrq1GLBg5Q6yWUS6RownyOS8XI6piillhXr3FWbm0pJrDhFn5FyHGF5
	9qg==
X-Received: from wmnu26.prod.google.com ([2002:a05:600c:441a:b0:495:4b05:6e35])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:64c8:b0:495:6934:4146
 with SMTP id 5b1f17b1804b1-495693442d3mr558735e9.11.1784625611424; Tue, 21
 Jul 2026 02:20:11 -0700 (PDT)
Date: Tue, 21 Jul 2026 11:19:21 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260721092005.1986693-1-elver@google.com>
Subject: [PATCH] slab: silence sparse warning with type-based partitioning
From: Marco Elver <elver@google.com>
To: elver@google.com, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 787044000D
X-Rspam-User: 
X-Stat-Signature: wkg916jqfgqbxpxk11jxa5y5meffewej
X-Rspamd-Server: rspam04
X-HE-Tag: 1784625613-91940
X-HE-Meta: U2FsdGVkX19R1w/I812rqcucOqbOVYwXDuEKEa2/xd1e0enV+4/51fzW0GlAtc019pzWA12Prk90W4qGCCno3Ut1j071O3syb5s2ErqxHpTXDc98gNZqmSTaVZoZJcIrQDWGejoG+m8SU/lirQXZNfIbGSwzJ1P89QhWsc+kYO//RMfcLHigYVvxQQhfAwsFWPIOHgBwYCJlvTjociX2LiuekPq3iWjBZsXPivmcdGb0f/9igeQUjvXa8Q5C26fidzMWO6zRqiAMJM1K1D0cPLoq8Ux5UU4RbueLZHy7uVffu5nW3rmNFI6jAqhWiSaUM/iC3p68yTHCen+kdKvDg6mxNyWCqYSxayg5nRz1tGUxrGDbsaqiIGmiIZrCa2DUs8+8eNCEPXPHWVbzrVSsbJ882msjiL0EboWorzHF9roKukV8+cTeq0DLbIAtv4bp78WxLNHzjX/V7mJgn/JqF6L2VR4JqLrWB8F3L90S0Xxge5/Wy6TWuSqeV5SXD08+Lpeuky3rBYufisw8x+q1x3W3MospBHLCUnu96vf2iiZqdLfiKSipNDjtRqqmQfoIy6OSYUKbrHRk0lf/SsojkRTFlnstPaNTrp967pKSxHO/HQKpIKBGBzrkTwlerQKxHHr9dvWsoMp6Mz2bww/7G8QYach2XDqV22JWIoBsU70D2GFPMVcwzYzda9/ZfwLyasBwuqsFVb+T3O2nWgLnVk7+A8q+8AlqMRmv8r0+Z3G0+V8gYpAdeqzOg3giyIflZOYwWn7JAz9IGI9idSlYbDjBifGF6t8H1OIPZB5h6uHWVFGIUSJqFGKE0tXvl8FzUCaqrVBLPt6x0niq++KM1kEH7cPt2uq7UAvXPd6k+r4bp2DhbN6ooWwY+7GELdwe1i6EZ/Js0AIXzk+6Ac1zK0cr3xwGbT5Ty2H5S3Qf/PiDfFllDoVygQamis1eeyo6tj5B2rwZwMzNtkJyEL0
 k9ZszF3C
 jA4HdOrpMSRm2NuBweZQQwnBOLm3EcLRbQH2zyEgZ4Vqky3gT1cR01UQ2SNblYiezKI6hpTX8GwbpGoaTpaslWEsDGNrP+6w1FM4ya6ukOvkoaaONrlZM3xjGKkm9BEwzEn/SgicPsU6t+c1VKfvKVLJFggBOgifkNXIzdhWiJzvsEtH12YN+JlOHFZk3995XDZf2ZzEhnSDHEZG36PCFzoiA8BYechSXjt2ghGndLW5uF4W/mGQXOLwlsLE1mzx5pG4zol8PQVCX2t264rseHfcSnCCE/y5BI7nB5LqAe80bsBI3+Wz3OKvniZvpBseExJjFM66JsdaKyZggLSy/RFNeg7ADY2qoVCgtZ1WmxOzT0Bc7I5zLw5goAOUVbIQtCm+lTn7R/mgT8dxElOdF8KImw8VEcd6p6Ub+DfdNYJeWNUtL8EioGoKcL6DVoa5USbmhzdqz6KgkmnwM0mZp73Zs4a0fckkRW+ghBMim5vwfkxpwd8YjutQ1Q9EsbkoYi9dxIBTbfR5mbZ42exPbYV68oHnIuB+gicdUW0Uf9T3VQWcTFSvxlZdZBX18LAT0k1nGCj5nM8Sppl/YMn0pRNhafqiL2EnkRgWlBpww29a3jts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sparse does not know __builtin_infer_alloc_token() and complains:

	sparse: sparse: undefined identifier '__builtin_infer_alloc_token'

Fix it by using a dummy variant of __kmalloc_token() if __CHECKER__ is
defined.

Fixes: feb662d9168b ("slab: support for compiler-assisted type-based slab cache partitioning")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607110912.nZTqfCrH-lkp@intel.com/
Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/slab.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 51f03f18c9a7..7ffe152ce483 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -505,8 +505,12 @@ typedef struct { unsigned long v; } kmalloc_token_t;
 extern unsigned long random_kmalloc_seed;
 #define __kmalloc_token(...) ((kmalloc_token_t){ .v = _CODE_LOCATION_ })
 #elif defined(CONFIG_KMALLOC_PARTITION_TYPED)
+#ifdef __CHECKER__
+#define __kmalloc_token(...) ((kmalloc_token_t){ .v = 0 })
+#else /* !__CHECKER__ */
 #define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_infer_alloc_token(__VA_ARGS__) })
-#endif
+#endif /* __CHECKER__ */
+#endif /* CONFIG_KMALLOC_PARTITION_TYPED */
 #define DECL_TOKEN_PARAM(_token)	, kmalloc_token_t (_token)
 #define _PASS_TOKEN_PARAM(_token)	, (_token)
 #define PASS_TOKEN_PARAM(_token)	(_token)
-- 
2.55.0.229.g6434b31f56-goog


