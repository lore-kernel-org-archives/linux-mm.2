Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCACFC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 02:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C8B6B00AA; Wed, 21 Jan 2026 21:07:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA3D6B00AB; Wed, 21 Jan 2026 21:07:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6576B00AC; Wed, 21 Jan 2026 21:07:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B45C6B00AA
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:07:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F9335F7F4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:07:56 +0000 (UTC)
X-FDA: 84357964152.30.248C31C
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf18.hostedemail.com (Postfix) with ESMTP id A5E551C000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:07:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=abvZNHO3;
	spf=pass (imf18.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769047674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBQb1uczQpL5GIk29gYfa4oCHjDRy2kNRGngnJTqEfM=;
	b=jGaS8VYK/jvQjS1qvASk2HvmRmUwiwE9sDYwJnDJVJN296k89iTP/1GWf5VyBm6L6gggz6
	YbDluT6Ixd8GsXbrwIujWzYvTaif7BJha7fYbtyoOFEm7vbtiH/xh8ZDlX6OvmyUb34u7B
	A+1qhE2T67cDcrO/AOPlVEMzcbib3eU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=abvZNHO3;
	spf=pass (imf18.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769047674; a=rsa-sha256;
	cv=none;
	b=UxTbtaZSvlZD6uyiXWoECL4lTEW10zZ9v0LsK+D3JXX+zHjn/6FgXlAwyqL1VLjVzbW62Q
	no7pyr80PDJK3o1MT+PkIOWtO2R9DxkcKeoeR67VS4N8QP2eT1mmwvVLF4WIiA6Uajyzqt
	UrRmGvbeCYA4dRX8tBc9cVBOt3UD0EA=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-1233b953bebso1158787c88.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769047673; x=1769652473; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uBQb1uczQpL5GIk29gYfa4oCHjDRy2kNRGngnJTqEfM=;
        b=abvZNHO3wfpb1lfp/sRaxwfJ7lftrwliQR5dspOlzkGPRRKE/dwKtJzqr/bF54u1cV
         izKfqNQWCWpniv4Z6zm49XmCHEXkh8STJWYH6EUR4SvfYRe9w6EgyYdfchXxLcyJJvEl
         pQQGBNuDIiCbzpwUMjyoGxd6mM/HqwxvbQJFQwhIclvg5XUctlPTclgTLXD39l3f8KAo
         Peu4jIL9F84QPhUXt36GYcrygmIygQK8/nLtXXgsx85y5TMsllHo7+qsHptEF2XGIaIn
         259JTzWtKHEOxc5OK8j68VyHooylYzwuck+K6IIo4eR7GBdavXrU8cDi6b6OB1W/EuKF
         wc2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769047673; x=1769652473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uBQb1uczQpL5GIk29gYfa4oCHjDRy2kNRGngnJTqEfM=;
        b=bkQ2l8azFIGH71jzF1EnDTTw/3Wbmx84wGxeulWIsqg9fgJPfy33HruIw+qLJ5tt6D
         rf0GiPLr0oDgOTHCISd62lSm5v17RDGHDlebj9dgQAomSLsD8zW7U6beDU1a8nHkey/q
         Yp1n210/E8msvCaXUXgGzU1jKU9/JP0CQH69SxgUhuqu9knlIehlCpzHRq1Ei/EVn4uD
         iLF89YFkv6ICzkX/4Dwru/UJb7htpvHsLXgU/6YgzkUkUxt2nZu+aIA2wrJDE4jRyo7D
         rWug2GmVLDQyjCAGrVAD2O5XEt+gQksmQPfAYM7nvV/IZ4GdYuzuqKOnsJUhipzaKv9s
         nb/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXk26TDGau0t8Rfy0A/OF0UkEPmhDiC4gdtCrBpnhI4/EibEis7USq5ckawLL1mGS/1BNBcXPUBdQ==@kvack.org
X-Gm-Message-State: AOJu0YyWxbXL1t091DPOkeAd1BX8LbU9chN0iiU52htrvlA5nrK4OsQu
	UPc76PP4xIx37gnwtsgOqpMeI4BrJ0dvU80XFxjuDLd7Ilvmp1r6vYn3
X-Gm-Gg: AZuq6aId0+vHRJvwxoqEJJSKC0QE2qpNche8K6kPh1HB3HbOv/6bA8z70ykkgKtYZv5
	y6LwAFTxOwEsG9bsr3PgmZ7nXEHy/hVU21QgkTKYmqwOilV+WBFoc8yboVoA9SrKBmG9peTLGCO
	/K9spp/pvJ1SAhyW4bRIw3VTMPW4PDhyynr11BwwgqteAAHZqArySB4+3RtVSj13AX3r970iu7Z
	SGGskqJAmTDve43WspVDoK7ZE16qz+TLdm2OPZbfDYtk2orcZvnwBZwbO21crIiHux5s6ADdBOh
	DJNjF5af0ZNh3bZgeH1zn0RWsBnhP5wmVzBM+tO5fRj3uO7aHMtOBWhC5WliCmETJaofqMOtaAM
	Fc7dk1ASo0qnTmMQeLXP/7pKUoe9oqaCzb4ZZ9BUsblOi9Lbl33QM/bMYLij7HjUG3tkDKIZa7+
	8kuGQ=
X-Received: by 2002:a05:7022:608b:b0:11b:9386:7ed0 with SMTP id a92af1059eb24-1246aaf0f17mr4977855c88.45.1769047672743;
        Wed, 21 Jan 2026 18:07:52 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6c2de1f29sm21740486eec.15.2026.01.21.18.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 18:07:52 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	mhocko@suse.com,
	vbabka@suse.cz,
	willy@infradead.org,
	lance.yang@linux.dev,
	hannes@cmpxchg.org,
	surenb@google.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	weixugc@google.com,
	rppt@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	jis1@chinatelecom.cn,
	wangh13@chinatelecom.cn,
	liyi1@chinatelecom.cn,
	sunshx@chinatelecom.cn,
	zhangzq20@chinatelecom.cn,
	zhangjn11@chinatelecom.cn,
	Qiliang Yuan <realwujing@gmail.com>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: [PATCH v6] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Wed, 21 Jan 2026 21:07:42 -0500
Message-ID: <20260122020742.230219-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260121125603.47b204cc8fbe9466b25cce16@linux-foundation.org>
References: <20260121125603.47b204cc8fbe9466b25cce16@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: uri9bsa4ncuirghnzsq7ee5gee8tsbn1
X-Rspam-User: 
X-Rspamd-Queue-Id: A5E551C000A
X-HE-Tag: 1769047674-714467
X-HE-Meta: U2FsdGVkX18ck6VeHOYUCcAdyO5YMkQPEgXOC8cv7go5vAiGGhHH4EwJSmowD1m3QpXKdcRINWWVSoE7f11UxFcmU00pg6w1LwTRlwiKnIbae7sneHd+6E8rxv/Ij0ox5PeKopIqhRthAHjMWXrrdozUwStgUi7Llz4U7KCJRnxosy4CS5Im8JXRrN8HuJQvBYWtllB+1eiC7mYPORExpYoSqOnKkPfBkkgvXmQ999fd+LTSIwewK9wBu4Ge7lG7HaIMG7UoKT89P3O3QhBR3nFqDA9h9/ox6zsVJAXlqsFFZlgUD7mLIcXCAIAN8wJSZQNexCAs53raWOGmvCdUzv5VE9yTRuO5p2DNCknz4Fb1p1kZ69y2sS96xPMucl7JxhTt+FcdPLe3v1m/+EbK5f44ryr4olgEhqcfRf4QACw2IphGgpPTggNS+VsVXbuujyWh3SLHpecnm7YVknOhx+MYBMekNVbQ7sfC98MklbYFzM9CH+JAC/xNHSY0Zpq2GGYjCcsgZSBGk1tX9T+OiPrrbszUv5Syo0mnPqidLs6/GKL7J15/T0RKtEc+ozHTBPKA5YVW0otd4/JYW6JIsNd2JzcQe4YwC6SUmFsVvFtJlnm4krDcewQJ624IR2Vt5lIIf90fhIRP7TeIIiWezyqPQbOc4g4HsfgotGScbU13LyN02+QM5rhAIE/4VODYPr0YI94HhtREGxZgiVbLfJSVzaGtuPNKu/tWmPTt7dg/ni3xx4mPDpeY84XB9mr7ijEfrFIrsh6YkThge+npGSjONK6/liPBCmIJcK5/BJMEGYeDWpBnBHNofNJv/A7U3ibJWD4nT3eqggHm8uDzpYDfzyBNbPpmw1oO9VtiXITVwW80689Dq9EA0VazOCrzculsGrUf6/LQJ3rXqgC/tplspOTnhEPq3p791qY44eyxHwXJF3WuqjhPtOldNpGATLRTtirCrFs6C8zXt5g
 XJ1j7I2s
 s/WACY7WwHPryiJ9JGSzBZu15KTb9RrFRahdmXZyLklYiMqCuQhQiUA3Trgb1X9RhCBIgi0987bJOm/8mT1KlEHnubBg8Jn44d8WaYqiqbTiNicpo0z051BHmsQ5b9/EWYel6rPKkiWy2IeYpvXwgNn+j0xCCoh5lCdyvR8kLE9lVrS7MhD015OGkOSVwZqm68tF8/cjv8a6gcefHuyaKxswwcISFRFFynTXptHXZmoRDPnWr1Po3yC3rfjfxPbnQzIiDPM8rCu01e6DnLfi/ox3pSHPiCcA0Ht/krVdwOyNji6n9FLHZPe3BGN16TKSESgTHy1s1EPwJDF+OW/IUCSieF3kpmCTMK2n2FomaTZnhNTwKgPDNu6XMcwouvGT08h96NDlkl0eWKmDttvstKHDdVWeXQCLZn7nlqqNr4XbWNtyLKiRmPzSSSc5NbkhEBSFX+IjOdnTtCbtAjxzR9g7t1w2nvwS95yP5cpNqkRLK4BRLm+J0KLFoO20zU28Jv/PPcC1aP/KNL3M7mdpcJotukVGiiMyRk4Jb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
pressure as they cannot enter direct reclaim. This patch introduces a
'Soft Boost' mechanism to mitigate this.

When a GFP_ATOMIC request fails or enters the slowpath, the preferred
zone's watermark_boost is increased. This triggers kswapd to proactively
reclaim memory, creating a safety buffer for future atomic bursts.

To prevent excessive reclaim during packet storms, a 1-second debounce
timer (last_boost_jiffies) is added to each zone to rate-limit boosts.

This approach reuses existing watermark_boost infrastructure, ensuring
minimal overhead and asynchronous background reclaim via kswapd.

Allocation failure logs:
[38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
[38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
[38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
[38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
[38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535649.655523] warn_alloc: 59 callbacks suppressed
[38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
[38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
v6:
  - Replace magic number ">> 10" with ATOMIC_BOOST_SCALE_SHIFT define
  - Add documentation explaining 0.1% zone size boost rationale
v5:
  - Simplify to use native boost_watermark() instead of custom logic
v4:
  - Add watermark_scale_boost and gradual decay via balance_pgdat
v3:
  - Move debounce timer to per-zone; optimize zone selection
v2:
  - Add debounce logic and zone-proportional boosting
v1:
  - Initial: boost min_free_kbytes on GFP_ATOMIC failure
---
 include/linux/mmzone.h |  1 +
 mm/page_alloc.c        | 36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)
---
 include/linux/mmzone.h |  1 +
 mm/page_alloc.c        | 36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..8e37e4e6765b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -882,6 +882,7 @@ struct zone {
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long _watermark[NR_WMARK];
 	unsigned long watermark_boost;
+	unsigned long last_boost_jiffies;
 
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..8ea2435125d5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -218,6 +218,13 @@ unsigned int pageblock_order __read_mostly;
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
 
+/*
+ * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
+ * This provides zone-proportional safety buffers: ~1MB per 1GB of zone size.
+ * Larger zones under GFP_ATOMIC pressure need proportionally larger reserves.
+ */
+#define ATOMIC_BOOST_SCALE_SHIFT 10
+
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
  *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
@@ -2189,12 +2196,31 @@ static inline bool boost_watermark(struct zone *zone)
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
+	zone->watermark_boost = min(zone->watermark_boost +
+		max(pageblock_nr_pages, zone_managed_pages(zone) >> ATOMIC_BOOST_SCALE_SHIFT),
 		max_boost);
 
 	return true;
 }
 
+static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	unsigned long now = jiffies;
+
+	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
+		/* 1 second debounce to avoid spamming boosts in a burst */
+		if (time_after(now, zone->last_boost_jiffies + HZ)) {
+			zone->last_boost_jiffies = now;
+			if (boost_watermark(zone))
+				wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
+			/* Only boost the preferred zone to be precise */
+			break;
+		}
+	}
+}
+
 /*
  * When we are falling back to another migratetype during allocation, should we
  * try to claim an entire block to satisfy further allocations, instead of
@@ -4742,6 +4768,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	/* Proactively boost for atomic requests entering slowpath */
+	if ((gfp_mask & GFP_ATOMIC) && order == 0)
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-
@@ -4947,6 +4977,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto retry;
 	}
 fail:
+	/* Boost watermarks on atomic allocation failure to trigger kswapd */
+	if (unlikely(page == NULL && (gfp_mask & GFP_ATOMIC) && order == 0))
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
-- 
2.51.0


