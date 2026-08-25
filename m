Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 906A5C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 04:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0C46B009D; Tue, 25 Aug 2026 00:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961D16B009F; Tue, 25 Aug 2026 00:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877646B00A0; Tue, 25 Aug 2026 00:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 634846B009D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:39:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7B0B80302
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:39:35 +0000 (UTC)
X-FDA: 85138538310.09.7DC0C31
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 07D6FC0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:39:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B739YmVT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787632774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPfrun+7l966UjlqQm4w/H3qmkSf5+9NW9rMf6ob2Zo=;
	b=eS6CB8k9TdDPHy9KnGSMyyIAT8AN/kLHrzhN9OviqW7V/DIrDd2zOtF0adwr/EDsGLrlsy
	WA3aXxFPIA9fcFSkzvhMGS74E1DpHGxN4+nETxFxAReIxWDO1RQdj09pdykYgD5GWP6hWM
	NlsyQBL4rjKqdM4anNOCSZh/HugFZdM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B739YmVT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787632774;
	b=AERdsj0DAWmObgZ8RTNpM4+xBXPfbme+auSi3Cr2b0bHvQvqmvbTql4++TaaJW3OUKMCYS
	yiVERHRV0Zr91sFr5CeeoChA8YwM6hw0atcvFXdxw4jT+WySwrwnz+LTHjOocU5UUiqENx
	QgmV3dufU3/ux0H0eeUHXGacKEIZbC0=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cf50c6f235so47246665ad.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787632773; x=1788237573; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HPfrun+7l966UjlqQm4w/H3qmkSf5+9NW9rMf6ob2Zo=;
        b=B739YmVTSNrMRf8YfpCR8+ZtkezsdH1qo7YOTF2hpohDWy8nzBjt16d9QBW5GEugcr
         d3CcXrmsgISNXycRrY8fBts17PeCxvXEK7DOsLrnFmaLH9VqgZYAVXw/21m9IpsCr/5L
         gxFpEVTfz9bBZGlix0nVQHAys99n1sAfemRheaSrJ1cjJCrDrAj7HZcrX0D7zq0nihiA
         FIItbgsrNDGKfUmLbSc3DNNvBYyi570QEGNnaYpjXOz5p4F6DBSZmYQULU6Sfb27w4Kx
         EYqMgZPlWRml/vhx7ZR/hpRIj2gETM2H9YOoGDQ1UeYV7r6EmDFlIllKSkQo2+0tn5aa
         o+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787632773; x=1788237573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HPfrun+7l966UjlqQm4w/H3qmkSf5+9NW9rMf6ob2Zo=;
        b=cL2dBPJQR4SQC8RZmxBULyNfswACDtmtFTZdPfVgwuDhptWv8g/MOAKvh8lM4PGBiF
         UTWR8lv9b7FUG8zJnBxa4vQ//lWXQ4sce9NnvDqJ3QqHBQHCShNBQTJ3pLq5xLKrA46v
         RoerzoOpRd4GBUJE1nzqmLiesum3jpviAwkX+tL4pX16oYn+z1tFq1LLcL0aZf6PQTEF
         hVhsdO60WHYksFBC8WYkWN/tBXH4omC3Xzwm/En9NV+OzqxpG2Php6HTlcGr8jBEfDQn
         o1beWHh0j7i4MveHFmrqIk4hY8bmtjcoeZb61qYFU6zs/x5OdZc02wC19pB1IEPVeJ87
         dLTw==
X-Forwarded-Encrypted: i=1; AHgh+RrxcfCBrGELxpc3GaSp9BZ6mJ76If6T7eToA0SlqVPRk0IYCjdlyYk+fiz9uKZsj8twUS5kQnxgrw==@kvack.org
X-Gm-Message-State: AFuF++l0HDDGAmGVWsfM0tEDYoHwYAAz+cVXr3VTen2/Hqg2JNFGMdZ1
	8xu8Dp/6A2mhQVMXTLWXbjm/+FMlgvZNDekURnm+mkR+KrZFQrbrJyIq
X-Gm-Gg: AR+sD10PmiYfBQaQ+EMXKQs4ADFsxps4miokWkmLnDeDG63ZN91y5WMf/+wqXzYu90C
	wcWshETr/Jh7WkVnuLmAvcdQgJEE0uCi42OglZjivuwfXt6wCp1XQQx46lsmLFE9YSQNa7ibdGL
	lyMS0f86LQvDE4jTnmhHWeAqhk0zwvxyHKGdglTszjvVLKKNErZjF2utalNnkgTtz58bHguMoUl
	RTSbxBMkPWnDmL3GwqLXJRP+/+GJSWLkEkq48OA3GBRIUdqi1iy6E6plb6X4A5dj+iaqOD8EwzR
	skyBTgVDWFtXN1t6wxiJE6WqTTtfHSLvt1aA6vD5EZm3OEfDZuYdLY0s4Pn0e2mWrjvNlQWvc/6
	OuR4MnJyr5QeWMMVE+N3LUPtLHdHq9Vt4JgzRFTzRMYxZmDlY1YOkOG8LF/Nr/SZ2UvvluvtgJ+
	+kn6Ipfv+sPztdnzM3Oxtbc7on1hvJg4h4dCXp5H21pbb/mn8dXqe7Qhwe4l6t27Bk9xg84ycu9
	D5osC51auiR/Uy4
X-Received: by 2002:a17:902:da89:b0:2d3:716e:e2ae with SMTP id d9443c01a7336-2d64ae18c43mr573095945ad.6.1787632772791;
        Mon, 24 Aug 2026 21:39:32 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d6f726e222sm502155ad.19.2026.08.24.21.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 21:39:32 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH 4/4] mm: adjust free_pages to make __zone_watermark_ok() mTHP-aware
Date: Tue, 25 Aug 2026 12:38:33 +0800
Message-Id: <20260825043833.2659350-5-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
References: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 07D6FC0007
X-Rspamd-Server: rspam07
X-Stat-Signature: ccbuun49ighukngpe7k1qro3zjipxq8b
X-HE-Tag: 1787632773-410321
X-HE-Meta: U2FsdGVkX18acZzS19wv9sdLhAgg6Omep5EdAMXnzb/787abkqWXqh7u5wGlTTYDzWji+0MKHoABNiHkzh+SsZUv9cMgGIlpkrR4/7lfWLodYr6V/7t2pBWWXTvf666zPauQB8bnN/sehvmdG0q5AlDgN2HZETp1pyqpJ2lHlLI2weRFrPvRZGlCflsqtdB/Hu0XNDIBDBfQKf2zBsVjKZI8YV3AmcOQmpdmszcN81i2BFI+aUKgoaRWUgSVqsLpLFVNKZBZvc+7R7FUUFV9+4vIeL4+Q3BTV5imZGWm66zO1KWBGsmi8BRYWrt1ZMuZcHO8jS7jnyOjvSfPpgeMYEn6OosIgfnBvGd/cUiod258ZWqzG9HFcyACnqCewRAWsMq0B7oflzYK/CEVFy3JkN4TOt8syG9cyv/Tcy1cl2Uz/mglmBcOA+EsDq0caN6mkSIkXm1PKsEaYlVHeapbeAU1LTC+chxEo8k/ogy2g+EkDepd6hdtdvIPjnIYE9vUfCWJ8xXocCyb0fbVrCAEAuKF+2nz7JZkJciZNOufmI41MvSWPCcGeCxqvw8M8PTjx25i60Hpagz5se3eu4vz5j2dzu8ppvPqDKJaEv8XUIj2W6fUhX+mOPGlecsh/mMDDeKltcrYmGMFQNkMh4m0kkogySeeED8zNN1AdiYmWlGUXnc/qEuvRMC87PiSFilm9hl+IpHAZZt4TQHRDDmqioVC1ekwKdXabgbbTFLNTqsr7+4LCmZ4LZmwd3qOjdMKD5zDJr9v2Y1yNzTomGGQUEFu3nLu5RYoKKQ+HRxhPpmDrMY0HDnaHwIjqnANBv78SYYR5NJAQ7CMSMp/UQRwlKzxQmQejq7YZzgyZD4FTjOWZMMfQwr5X7xWgj7fgJv+NrJ6tTqJxB82yuVJZqBYPvaEtQS8DV7+LppFjA0Pc1A4PoIgIXploVm7+h4Ems++W88+ip/hM/l8ync4RQg
 EGN6GU9D
 WTMxeQ1fD1J1fla1b5wvy8ghEoEsGtSse/Y36mkX2lroVd5hqQ4pcqbYu7D8w+wZp4PKi1BAyU/whgG0sRT36uVMLiiR3YLkSJrChKDE7krB/sTHcaSHN8AGJzuB+9Z25OfYBqZEsGjFv0blYjPuFwNrsgkivcpyOVAAMeVJE61V6PBGDejT/T6aa/dfW+aw7ueX2HEnsEab9oAwR47pvpGAxOMy4BI0grrua+/bQyJQbpl4HedCXaJAF2GFnr93lRtPz9gl1/3RVg3l7wlmu5j7qiwQVyzlW5Awk9egqMGV4uMlleQmGySeYhy7u3YYWs1RQGmukvxh52v54j/CkoK7nxg7/+naR7zHdYy1yBcyRqgSsvOEcsqUmYiHVZNY0Rbq11CRY2WTkWvBz3AE0pocQ/0p7B4eOeq0R6Tnycti210A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To improve the mTHP allocation success rate and reduce
fragmentation over time, introduce
zone_effective_free_pages() for mTHP-aware free page accounting.

Refactor the free page counting logic used by pgdat_balanced() and
compaction_suit_allocation_order() into a shared helper function
zone_effective_free_pages().

The function selects the appropriate free page metric based on context:
- defrag_mode: use NR_FREE_PAGES_BLOCKS (whole pageblock accounting)
- mTHP always-enabled: count only free pages in buddy blocks >= the
  minimum always-enabled mTHP order, since smaller fragments cannot
  satisfy mTHP allocations
- otherwise: use NR_FREE_PAGES

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/compaction.c | 38 ++++++++++++++++++++++++++++++++++----
 mm/internal.h   |  3 +++
 mm/vmscan.c     | 23 +++++------------------
 3 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 15b92475562a..29be72597415 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2528,6 +2528,38 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 	return false;
 }
 
+/**
+ * zone_effective_free_pages - get free pages relevant to allocation order
+ * @zone:       target zone
+ * @order:      allocation order
+ * @use_blocks: if true, use NR_FREE_PAGES_BLOCKS
+ *
+ * In defrag_mode, watermarks must be met in whole blocks to avoid
+ * polluting allocator fallbacks. kswapd usually cannot accomplish
+ * this on its own and needs kcompactd support.
+ *
+ * When mTHP always-enabled orders are configured, count only free pages
+ * in blocks >= min mTHP order, as smaller fragments cannot satisfy mTHP
+ * allocations.
+ */
+unsigned long zone_effective_free_pages(struct zone *zone,
+					unsigned int order,
+					bool use_blocks)
+{
+	if (use_blocks)
+		return zone_page_state(zone, NR_FREE_PAGES_BLOCKS);
+
+	if (READ_ONCE(huge_anon_orders_always) && order == compact_hpage_order()) {
+		unsigned long free_pages = 0;
+
+		for (int o = order; o < NR_PAGE_ORDERS; o++)
+			free_pages += zone->free_area[o].nr_free << o;
+		return free_pages;
+	}
+
+	return zone_page_state(zone, NR_FREE_PAGES);
+}
+
 /*
  * Should we do compaction for target allocation order.
  * Return COMPACT_SUCCESS if allocation for target order can be already
@@ -2543,10 +2575,8 @@ compaction_suit_allocation_order(struct zone *zone, unsigned int order,
 	unsigned long free_pages;
 	unsigned long watermark;
 
-	if (kcompactd && defrag_mode)
-		free_pages = zone_page_state(zone, NR_FREE_PAGES_BLOCKS);
-	else
-		free_pages = zone_page_state(zone, NR_FREE_PAGES);
+	free_pages = zone_effective_free_pages(zone, order,
+					       kcompactd && defrag_mode);
 
 	watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 	if (__zone_watermark_ok(zone, order, watermark, highest_zoneidx,
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..14bb9543879b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1654,4 +1654,7 @@ static inline bool can_spin_trylock(void)
 	return true;
 }
 
+unsigned long zone_effective_free_pages(struct zone *zone,
+					unsigned int order,
+					bool use_blocks);
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c1404a59523d..a419a2c2fca4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6966,7 +6966,6 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 	 * meet watermarks.
 	 */
 	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
-		enum zone_stat_item item;
 		unsigned long free_pages;
 
 		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
@@ -6974,21 +6973,6 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		else
 			mark = high_wmark_pages(zone);
 
-		/*
-		 * In defrag_mode, watermarks must be met in whole
-		 * blocks to avoid polluting allocator fallbacks.
-		 *
-		 * However, kswapd usually cannot accomplish this on
-		 * its own and needs kcompactd support. Once it's
-		 * reclaimed a compaction gap, and kswapd_shrink_node
-		 * has dropped order, simply ensure there are enough
-		 * base pages for compaction, wake kcompactd & sleep.
-		 */
-		if (defrag_mode && order)
-			item = NR_FREE_PAGES_BLOCKS;
-		else
-			item = NR_FREE_PAGES;
-
 		/*
 		 * When there is a high number of CPUs in the system,
 		 * the cumulative error from the vmstat per-cpu cache
@@ -7001,9 +6985,12 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		 * counter won't actually be per-cpu cached. But keep
 		 * things simple for now; revisit when somebody cares.
 		 */
-		free_pages = zone_page_state(zone, item);
+		free_pages = zone_effective_free_pages(zone, order,
+						       defrag_mode & order);
 		if (zone->percpu_drift_mark && free_pages < zone->percpu_drift_mark)
-			free_pages = zone_page_state_snapshot(zone, item);
+			free_pages = zone_page_state_snapshot(zone,
+					defrag_mode & order ?
+					NR_FREE_PAGES_BLOCKS : NR_FREE_PAGES);
 
 		if (__zone_watermark_ok(zone, order, mark, highest_zoneidx,
 					0, free_pages))
-- 
2.34.1


