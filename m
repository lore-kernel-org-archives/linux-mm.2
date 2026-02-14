Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B0A5EDF15A
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 15:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7AE6B0005; Sat, 14 Feb 2026 10:14:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8E06B0088; Sat, 14 Feb 2026 10:14:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB3D6B008A; Sat, 14 Feb 2026 10:14:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABCF56B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 10:14:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCF0BC2A75
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 15:14:05 +0000 (UTC)
X-FDA: 84443407650.30.1B2D155
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	by imf22.hostedemail.com (Postfix) with ESMTP id 12878C000E
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 15:14:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a54Q2cpN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771082044; a=rsa-sha256;
	cv=none;
	b=FDD2F5hOo7lqtx5UtLKUe5L2r2Cuu6CUjng5ToXV+be46EYn04TQOZ0CUpFUNkSrJB7buV
	U16O0+ONVJwDxDTjdI9JIPmF6wE5yRIZbgbP3hU+7blkCSvWDywa4soecoi4GesI+7gaV4
	mIgX7xjtR2TjeuVuQBG8aWPChlGrbPI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a54Q2cpN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771082044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ty94LJlt9E6E68NvDEAdqXn4Y6wDb1z0/BuIy6B4NTA=;
	b=loBIfOYeTtADbS6l4IVFCwKA2VtCvYg3c+YA9Oj4mrzB8+l/dONMjuujt5GsoIDKSS7iy7
	8R2U+C7NCJgGEtDhYw+u1J3xDf7wcgQgznMsXdscEAQWBSdlBOv7JwGSZjj8Hzo2cfAm6b
	A36IiOI5r0QhbMVWal6XRwCYwNsnsEk=
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2ba895adfeaso1739762eec.0
        for <linux-mm@kvack.org>; Sat, 14 Feb 2026 07:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771082042; x=1771686842; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ty94LJlt9E6E68NvDEAdqXn4Y6wDb1z0/BuIy6B4NTA=;
        b=a54Q2cpNrpKDH/vRFpMvv0uTitaReBVcVEgcDDbiW8DVhm0rQId43YbgHPW5rVnfr+
         7S+t/Qy53Cor5exIwu3/SeLDGt1LyGeiJ6y0bOth+8whrj4ttfI3I351dbJjX3hl5O1y
         I8Yr1RCyVNLQgUScVaYCBlaaNlSAmPpXaR3vmaxzV7tGo7N5zN3TYFd2OS6pUfaIr7J+
         T2wITH4oa8VOU7Kzs0JCqeFiSyhr18/V3iATPGU1tEma+r0DfMnZUTiftcxF2Fu0xlLU
         sssY2bPPWOo05jL+PNx0N+0YH99p6nh2tp3NLFSAIn0z10PyDztDp57CAI/0XoKk3gY/
         iCIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771082042; x=1771686842;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ty94LJlt9E6E68NvDEAdqXn4Y6wDb1z0/BuIy6B4NTA=;
        b=tBM+j2405kPSQDqcszJeL21rShdOtBlhmZ+g5ucGhsDvDh6sJ7H8DaToObv2HVhhd3
         iQpijF4LtUWINH4P85J16qlBfVD+ZFTdfUQAQtTJq8eS0wDYRDdtBot6stpsVruIpbUf
         p1rix9Qqg2a1aNWm5aV9MGRAQhpKozUgcDGTbULK95gZXYhF2mfi13UIwrw4Sqb8UKpv
         GNdqZU9OMDpLnvMOlmGprpMrNS0atqrZ/0gdiPPny2XnrvwDBTcyvLYHbUslmWgGlqYa
         +ht53NWSEyoo8p2Z33OY+xZPU1V0tTpCSmRW0w4LTOXGi9QNS6T3aNrksPkOfczbrKjj
         csew==
X-Gm-Message-State: AOJu0YzCDa/0rNYiVLGC6dw8u+NOrvWTupA+bSv5Oxk+/5Am6R3axzMJ
	xuSIrytsMNbG3VXkiQsGv7f3jA8Xbp+uph9SNtvXx0kXZOM0mdJqU47pjoBA8DMV
X-Gm-Gg: AZuq6aKmUhEpTaIHSeiK0iYT2koqwdE9XOIraAC5+L0iVwnbdKdvBNrD/E1Z+amQ/6T
	DyLoWeIpmStA7YrRS8CQBgPnNrXxIkoGKEzOdxAKPQlyDMsjssfiYzr9Kl73YZJhTW8TYwq7+73
	QyQDnKxfptUVwklNe6UxeBG6bOTpmTH9LmhgnRZ1xDwNMIuciBOc4BgAlXNZDG3F8E5J2IkuhQ1
	auqscBIltBbSUlfmk8OD3TYCKPpsEPvAchhAiUPyHtYoFKA/zNM3FPuX7P6uQreFUmp7KAu9G63
	byUYAOGZRAPGxUyTEx4uE7+Vt/r4rWzQzRAxnq7fw7X5gEWXLo8of7XEImcJdust6waWRWHPYlY
	ZZeuggYYbzsHsIapNtSG/gYcbug1/221ZIk3fUAXPPhPApoABiU2KejFTbEzeAVXu1hL15OMhUS
	re4A0YEPB3uXHX8sFj
X-Received: by 2002:a05:7300:e60d:b0:2ba:a075:540f with SMTP id 5a478bee46e88-2babc59bdbamr1962735eec.41.1771082042340;
        Sat, 14 Feb 2026 07:14:02 -0800 (PST)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bacb658544sm2667339eec.17.2026.02.14.07.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 07:14:02 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Sat, 14 Feb 2026 23:13:50 +0800
Subject: [PATCH v10] mm/page_alloc: boost watermarks on atomic allocation
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260214-wujing-mm-page_alloc-v8-v10-1-bdfea431fd97@gmail.com>
X-B4-Tracking: v=1; b=H4sIAC2RkGkC/3XNSwrCMBQF0K1IxkbygbRx5D5EJP9GmqYkGpXSv
 ZsWB50U3uReuOdNIJvkTQbnwwSSKT77ONSA0fEAVCcGZ6DXtQAEEYYIYvD9evjBwRDgKJy5i76
 PCpYWWol5w6VQzBpQ12My1n9W+nqrufP5GdN3/VTapf2bmOya9TDUQgraco6UphcXhO9PKgawm
 IVvHbrv8OoozbmlginZoK0zz/MPfPDI1gcBAAA=
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 12878C000E
X-Stat-Signature: edew1bbobuez9credt8syiumttfb8fsu
X-HE-Tag: 1771082043-297076
X-HE-Meta: U2FsdGVkX1+/2vX07gESVRBebx5qA+8uTtaK0/81IwXOrVi+Wd8X7M/jmSGJq05/lLMsyamHWJMNYsa3CaOANow5H1hQWR07h1hlI8t0RTRhOl8RWXBATThy0TpSPhTIZswgstYxD9PudA+dPxjnfPVUPNNohu4LFI0yTng69kqQXgTjuQlDStgehGjsMD9lhpnnba+Wg7yO/Ytaxsjmg8/D2FYrgzrYLo97P9pHQR48pJP+5moeGUtPq5Ie04/JBedp0jOAMb3/SxWjLWTvPst/fqCz5sh+hVPuEHKQwuCbRyJGL4nG2zUcYAedUqfxvVNIEbeDvoIBwv7AzyN7enGyVV6KBmY2SwyS7KTHAPPyPpfiDRQGnfDXkD/QH5HdcWJX31+DevtkjaAlGr/G8qvOt5XuM3knQZJAUMCCM7eQR7QKNGrGnM+7+XrjwE+CSuFXu6nqSyXbUbDmEKGm3Pfw0W1ZB4hKZ/1gYu+xQuKxx3Hita3LUmE3daAvXV/oBaGqfVKIIv9i4piGk32Kjg0VsStK3wERs0dakXsujVYwHYc/pLke82P0tdAYVeMPg950ezqFuzxexHj8RoJxvLtuy8FoSdVl5ChPJXPFTXb6j6lvYsKQYn1VMnGiv/ynTIKfn3piL0Gt/LMVx7DRvXPqkPuSeH7ugEwMEiD6MjrhUyQbkQ7C1R2TsN5+4RCVjeqbEtWLgN0QBImfjJ997Of75PBI0jF6lmk6jEuHl/7X5yglfczdeQxShj+6Xp792jyRg6UyTwBU92o3zDm3mp5oPeBGRxgL06GXcZPAUXk/sBbq5pCbIi3mGdGavbD3lOynqYBsQaXQ/EI7RkLZicgdl8JVPZ97+H/h+pL38/V6nEZokJobfnoEf7cq3Ks3m6CzAHr11xpR0w1Hpsf1KNlQp3w2DLdUyXgooE+lyexT0KwWcPeMJyzHZ1hnC+G2mNf4Z/H7kNd5gjO6/4d
 07mBB8kW
 NkXn+UFRWde6sjSVkJL2aiDDYA97m2ZzPphIAvxZawQL0eCv5INhbxjeu4BKEMFqhlziQNrs+a1xYoSfBYDhqZHxzgZBFj3vYDNtfLyXeE/YGM3IFFYd+BivclXqCPgkMxnHOGFv4IN68//7SGUJRxip9XLqbefdnHzf9JhqCWzKs/yrU0S/CC9hkqylA6b6Hi+JUkrylmt2f16gKGGX7lZJq+/Opub2sphuPKeT64Rd5gro9iI3UxDBH04eMi/OdcVlpHG2XtUO30KRhzQZt8Ti5aNfU7k/d/3ieIfvCGRSpdnzFmideAQb9yXeqJXdFqPeMWv0DlyaxRXYVGClXZ1QceuNRdJC0KyOWmPNer3v66W28a2Bk50dyGb0W728v75k1yE+zFHS80kRd0s8dLtatMbBuz/EenhK1SQQRaZ9otXae/3LOqFK7QnNFKeSFNPcHDrfX2ITHMWCAx82DxmZhP5OU2FkjeYMh+3ugBMN8byuBX8yoD62wVKmxJWozprS84DBMEgzTrqwLjw2AaUlwPIHskeNQsIUP4cBdw0llI9xVuZEQ1CvW04mQ9XhBfTvZe9P6CrULPw0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
pressure as they cannot enter direct reclaim.

Handle these failures by introducing a watermark boost mechanism for
atomic requests. Refactor boost_watermark() using an internal helper to
support both fragmentation and atomic paths. Apply zone-proportional
boosts (~0.1% of managed pages) for atomic allocations, while
decoupling it from watermark_boost_factor.

Implement boost_zones_for_atomic() to iterate through and boost all
eligible zones in the zonelist, respecting nodemasks. Use a per-zone
1-second debounce timer via last_boost_jiffies to prevent excessive
boosting. Protect modifications with zone->lock and verify with
lockdep. Integrate the mechanism into the page allocation slowpath
specifically for order-0 GFP_ATOMIC requests.

This approach reuses existing infrastructure and ensures emergency
reserves even if fragmentation boosting is disabled.

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

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
v10:
- Refactor watermark boosting into mechanism (__boost_watermark) and policy logic.
- Decouple Atomic boost from watermark_boost_factor to ensure emergency reserves.
- Simplify Atomic boost calculation to ~0.1% of managed pages with a 10% high-WM cap.
- Boost all eligible zones in the zonelist while respecting nodemasks.

v9:
- Use mult_frac() for boost calculation.
- Add !can_direct_reclaim check.
- Code cleanup: naming, scope, and line limits.
- Update tags: Add Vlastimil's Acked-by.
- Link: https://lore.kernel.org/r/20260213-wujing-mm-page_alloc-v8-v9-1-cd99f3a6cb70@gmail.com

v8:
- Use spin_lock_irqsave() to prevent inconsistent lock state.

v7:
- Use local variable for boost_amount.
- Add zone->lock protection.
- Add lockdep assertion.

v6:
- Use ATOMIC_BOOST_SCALE_SHIFT define.
- Add documentation for 0.1% rationale.

v5:
- Use native boost_watermark().

v4:
- Add watermark_scale_boost and gradual decay.

v3:
- Per-zone debounce timer.

v2:
- Debounce logic and zone-proportional boosting.

v1:
- Initial version.
---
 include/linux/mmzone.h |  1 +
 mm/page_alloc.c        | 77 ++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 69 insertions(+), 9 deletions(-)

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
index c380f063e8b7..9219bfca806b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2158,12 +2158,15 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
 
 #endif /* CONFIG_MEMORY_ISOLATION */
 
-static inline bool boost_watermark(struct zone *zone)
+/*
+ * Helper for boosting watermarks. Called with zone->lock held.
+ * Use max_boost to limit the boost to a percentage of the high watermark.
+ */
+static inline bool __boost_watermark(struct zone *zone, unsigned long amount,
+				     unsigned long max_boost)
 {
-	unsigned long max_boost;
+	lockdep_assert_held(&zone->lock);
 
-	if (!watermark_boost_factor)
-		return false;
 	/*
 	 * Don't bother in zones that are unlikely to produce results.
 	 * On small machines, including kdump capture kernels running
@@ -2173,9 +2176,6 @@ static inline bool boost_watermark(struct zone *zone)
 	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
 		return false;
 
-	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
-			watermark_boost_factor, 10000);
-
 	/*
 	 * high watermark may be uninitialised if fragmentation occurs
 	 * very early in boot so do not boost. We do not fall
@@ -2189,12 +2189,67 @@ static inline bool boost_watermark(struct zone *zone)
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
-		max_boost);
+	zone->watermark_boost = min(zone->watermark_boost + amount,
+				    max_boost);
 
 	return true;
 }
 
+/*
+ * Boost watermarks to increase reclaim pressure when fragmentation occurs
+ * and we fall back to other migratetypes.
+ */
+static inline bool boost_watermark(struct zone *zone)
+{
+	if (!watermark_boost_factor)
+		return false;
+
+	return __boost_watermark(zone, pageblock_nr_pages,
+			mult_frac(zone->_watermark[WMARK_HIGH],
+				  watermark_boost_factor, 10000));
+}
+
+/*
+ * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
+ * This provides zone-proportional safety buffers: ~1MB per 1GB of zone
+ * size. Max boost ceiling is fixed at ~10% of high watermark.
+ *
+ * This emergency reserve is independent of watermark_boost_factor.
+ */
+static inline bool boost_watermark_atomic(struct zone *zone)
+{
+	return __boost_watermark(zone,
+			max(pageblock_nr_pages, zone_managed_pages(zone) / 1000),
+			zone->_watermark[WMARK_HIGH] / 10);
+}
+
+static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	unsigned long now = jiffies;
+
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
+					ac->highest_zoneidx, ac->nodemask) {
+		/* Rate-limit boosts to once per second per zone */
+		if (time_after(now, zone->last_boost_jiffies + HZ)) {
+			unsigned long flags;
+			bool should_wake;
+
+			zone->last_boost_jiffies = now;
+
+			/* Modify watermark under lock, wake kswapd outside */
+			spin_lock_irqsave(&zone->lock, flags);
+			should_wake = boost_watermark_atomic(zone);
+			spin_unlock_irqrestore(&zone->lock, flags);
+
+			if (should_wake)
+				wakeup_kswapd(zone, gfp_mask, 0,
+					      ac->highest_zoneidx);
+		}
+	}
+}
+
 /*
  * When we are falling back to another migratetype during allocation, should we
  * try to claim an entire block to satisfy further allocations, instead of
@@ -4742,6 +4797,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	/* Boost watermarks for atomic requests entering slowpath */
+	if (((gfp_mask & GFP_ATOMIC) == GFP_ATOMIC) && order == 0 && !can_direct_reclaim)
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-

---
base-commit: b54345928fa1dbde534e32ecaa138678fd5d2135
change-id: 20260206-wujing-mm-page_alloc-v8-fb1979bac6fe

Best regards,
-- 
Qiliang Yuan <realwujing@gmail.com>


