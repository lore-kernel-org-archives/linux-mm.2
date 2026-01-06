Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACFDCD043D
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 06:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAAAE6B0093; Tue,  6 Jan 2026 01:20:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6CC06B0095; Tue,  6 Jan 2026 01:20:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32E46B0096; Tue,  6 Jan 2026 01:20:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A08966B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:20:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B41BB9675
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:20:09 +0000 (UTC)
X-FDA: 84300538938.10.34DF788
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	by imf17.hostedemail.com (Postfix) with ESMTP id D40B340004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:20:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=b0Lv9T0F;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf17.hostedemail.com: domain of realwujing@qq.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=realwujing@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767680407; a=rsa-sha256;
	cv=none;
	b=hY9N32VOlW+AoXxD1486Uy7PmDCLl82lJzCfggKSx3wPew7gmBp4HVIkFB/FybkfZgJaLB
	BDm0tFXYSZP86pLa49vmZFCzkFMICv4MF2ECb5Uj5k7/p/OZnpRezNnFjulcw2C4NTpwTQ
	0b7iOayspQkouYuFXga3ws3XbGUttXo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=b0Lv9T0F;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf17.hostedemail.com: domain of realwujing@qq.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=realwujing@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767680407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFSN+SdCs/qhH1mWp1W8skDGAS1NgxyCffI3h2S0VGQ=;
	b=FYSaPiI+PiRExSXXQe/N2nwaWfzvKqu7f4yrOXOxaJ7iWOdj+84dbTkAxy0x0PGy/hDuSY
	MmICExtFyi5lbDrl2HEcV0sIgOlLILPXWeHuGFspsX8/MRQjdFIR41tkDlMHv17Megaf9l
	cfmXN38/4+VV0e8ZmWocnE1dNq01dng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767680401; bh=UFSN+SdCs/qhH1mWp1W8skDGAS1NgxyCffI3h2S0VGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0Lv9T0Fmd5M0HeyZfFRH7n+orwc8criBnJXHCtDs/skJs1jt6RdBU3vZgQei3C33
	 7/l9n8ESJcit8z3jedleejNqTo1tRhmcUGig6/dHvMB2y2c6M5OYC3zDGEIp3axnsj
	 ABvoMvQqqyv7xNvbAbIINEly7/F4GjN/I0nyeda4=
Received: from localhost.localdomain ([61.144.111.35])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 4FA1EED5; Tue, 06 Jan 2026 14:19:58 +0800
X-QQ-mid: xmsmtpt1767680398t5ye8pvf8
Message-ID: <tencent_D23BFCB69EA088C55AFAF89F926036743E0A@qq.com>
X-QQ-XMAILINFO: NU1WwRH9AHfm7TOlxfRiKreig6ZSDjwrNmcEADPbn7zOLp/TKopybhBXKK0J+U
	 bMo3BTx4UUVXUVnTAfnkG7Yc9d30IRD9XSC3jscZ1kD6taHi/0RBuiaVX+x2IDfTUoBP9SG4uHEf
	 wEqc6i0zORQy5lrLCi2r6D5vKz+kFVwKgd+ATiNvnS4eyW8HpLW3QCfSxxxlrGmMRS+/3mZwIISb
	 sqCPfvX7JhyBSyub5e2J42AemqaFjpN3qI2Df/cTc8g04pTcNE+q0+eVB/L+GDRLiSSd2lB+LBrP
	 6/OLCxh8ePZ4mlLvOxXew89eB/iK1m5D5+fwZqbC7NGqhGMDG4Xl6EFFeRBrsRnHvRleVeQRlqfZ
	 EBwJsZvDr27lf+kwg2LkFMpj7OhkHic1209ChF+3KRSo9Tey4Vwu5bdYS/1xHjl5quke9jthSYRa
	 qsxrSVda5ZdERns5DUZ91S7bOb6/qDe2ZQcFElnlig6OVGfstnlkGIS9liyiqlEA8b1pjWgPIkxd
	 TVlEd6ECfzX2Iu7J5yB+PtriSfKS1EOnH5HStHBCyuAZmqXU7Bysr2MlCj8SOjbttj/dkcrH/NdR
	 4KAivzRgxOMizIcGcJL4Hsd/uWws3Qt7Z9afoQeHTvNteZpDSqhrOnICazmc4ZtMDvxuCESyKmn+
	 TUmb03sDrDr9+Y7FcrgUqNmY9Q2sEtnjNihyKENpUwtuvhnZXIwzy86brGC8eEeiqkEZWCyT6Gyb
	 itkBL3FxVS3SQTHek3pqpu62S8W+51nmDKx1kbOLowf7RjTzv2JOthdKZHUZO2tqrUjP2MDzwk9h
	 zfgon7tmLgNPMy1W06fxGVQ8tEIwdiDt3cPTbC+g9cp5mw6fR378aad6/0eZ5AYWAWQFTT3Y1gme
	 tqbLdFtMtSq79NIhxSQ9ZbWquRu7ykapl5UPcSHZoOeJqGJUhPFgorvPVb3H1a05OWDFylbMhRYe
	 El09ph7hRJkDQVjSitXxCPPHET/AYYDuac1B3G/mRuBbC0y1NJez9OjWv5nLKyanZ9vz3lh3YdXJ
	 Xi0Gh8hOHCp8FOV8klY/GkliHhFh10fmcuKR8K0w==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: wujing <realwujing@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lance Yang <lance.yang@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <jackmanb@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wujing <realwujing@qq.com>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: [PATCH v4 1/1] mm/page_alloc: auto-tune watermarks on atomic allocation failure
Date: Tue,  6 Jan 2026 14:19:50 +0800
X-OQ-MSGID: <20260106061950.1498914-2-realwujing@qq.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260106061950.1498914-1-realwujing@qq.com>
References: <20260106061950.1498914-1-realwujing@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D40B340004
X-Stat-Signature: o9wt5sfy9eidgu9zjt3mti955qrfz9ej
X-Rspam-User: 
X-HE-Tag: 1767680406-609278
X-HE-Meta: U2FsdGVkX19kwZZuQH3nCfE2P5DX8Pm7YhH9Kp5qBiazo5U9WW5KMpEx+UqDOiST4YMVhzPjP4MCDxl0HrW6o4XVsIDBETRmkV80LVs8y3ySlb581pgeOOix9WO/9gGxbYNzZEAXX9hCkSbVZaHivJUf9QoLjyD23z/TPFr+AuiIP/mvdHKcUNCuxeTst/xZMvKPCJTq15FzlIpZll7jdqkfMohlwGOE+5zjQjg6GCVd+ja1eqyGkce2gY7iHeP6JGIz1Uzv9a3rJpSwwJLoilQV18YhaaconJCoNGuU9iAbcVw3X1x2Ago84hULx+b4P4y3Z0F1C23rVCvcpU5wNCmrWImNODIFH2W7kzVOMOFok0WHj9/pAB57bS9c9Mm8bZ1EwUECWQaaRmCT1fvKU+0vr1UjCcZrxnZFhIOFendbPrEzJRw+cUKF44zHk6GtICnn0WQEsAdfeJbPrurQSi4USorFOXjdAMpsroCgqhvuf3f05EBk4QExLVY2Brpdka/+IyD8fK/O2Lk0ub90BHQZTfe8JbUUTSqpD/W8OUjzbP90DmihM1429DpxpT3NWYZkZ80elXocAhxEPwl+gLtECCkbFxU7DND83KIh9rS4w7pUeD4T4el7l00SvNguV2VSFqu5WBEUMV7s6KbZNZ4bKDAWR3c6NKbaI+VQnas3q+/Ecc0gYAyBFu2w6hqCur/RKnp6XLJlXmt5KMmCwzBCfXImfIO/+rrWe9mffucslHn0xUDqoZlCHMaoA/9azKXsiFl8TjgoYfgytHFOhXyf/SzU5K53NtXd8sOtAuHlpDX6GnuDzZNVo07Gt0+OfVVNEV0pKfjCf8jJJezNS1RNwJhr4zofsbzH1Of36NL2RgLTr61z5lyr83Q8jFpA6+Oe7BpZc5SowHr/FT7QE7wQV0cVFqSnF2ZqJu2X7xDtOtqeQ18tNPzjcdynz8H+HKNfLqnMvDkNneWEGUG
 VfRfnWR6
 MlPzBvomMnrQhuw3qZyez9uQ0ICj2YAsF6mPM2glb0IlusQdnEuZtxhfoIglK/C/a4v5ovDkQIX4d5qB3lF1nx9C5ybC8MLz/CHQtxq9DCutD39ewaMfHihpFh5vgmKAJSNgZyW9fYAYljRRY6HJMT1/D87dbBSkGm5Vb122KCGKEGeFBLxkucVcRVsN+cL76oTQERPIzfCanzwNxhomcyZiLFSgz62CYtqlnTMo0+xX1qtAk3vpf3L/NTuOEonnGSFE4Lcuqg5OuItXt41LKKNwo2KcvekQfkFVVyRiYRHBNs/DzU8I8lRNhpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During high-concurrency network traffic bursts, GFP_ATOMIC order-0
allocations can fail due to rapid exhaustion of the atomic reserve.
The current kernel lacks a reactive mechanism to refill these
reserves quickly enough to prevent packet drops and performance
degradation.

This patch introduces a multi-tier, reactive auto-tuning mechanism
using the watermark_boost infrastructure with the following
optimizations for robustness and horizontal precision:

1. Per-Zone Debounce: Move the boost debounce timer from a global
   variable to struct zone. This ensures that memory pressure is handled
   independently per node/zone, preventing one node from inadvertently
   stifling the response of another.

2. Scaled Boosting Strength: Replace the fixed pageblock_nr_pages
   increment with a dynamic value scaled by zone_managed_pages (approx.
   0.1%). This ensures sufficient reclaim pressure on large-memory
   systems where a single pageblock might be insufficient.

3. Precision Path: Optimize the slowpath failure logic to only boost
   the candidate zones that are actually under pressure, avoiding
   unnecessary reclaim overhead on distant or unrelated nodes.

4. Proactive Soft-Boosting: Trigger a smaller, half-strength (pageblock >> 1)
   boost when an atomic request enters the slowpath but has not yet failed.
   This proactive approach aims to prevent the reserve exhaustion before
   it leads to allocation failure.

5. Hybrid Tuning & Gradual Decay: Introduce watermark_scale_boost in
   struct zone. When failure occurs, we not only boost the watermark level
   but also temporarily increase the watermark_scale_factor. To ensure
   stability, the scale boost is decayed gradually (-5 per kswapd cycle)
   in balance_pgdat() rather than reset instantly, with watermarks
   recalculated at each step via setup_per_zone_wmarks().

Additionally, the patch implements a strict (gfp_mask & GFP_ATOMIC) ==
GFP_ATOMIC check to ensure that only true mission-critical atomic
requests trigger the tuning, excluding less sensitive non-blocking
allocations.

Together, these changes provide a robust, scalable, and precise
defense-in-depth for critical atomic allocations.

Observed failure logs:
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

Signed-off-by: wujing <realwujing@qq.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 include/linux/mmzone.h |  2 ++
 mm/page_alloc.c        | 55 +++++++++++++++++++++++++++++++++++++++---
 mm/vmscan.c            | 10 ++++++++
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..4d06b041f318 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -882,6 +882,8 @@ struct zone {
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long _watermark[NR_WMARK];
 	unsigned long watermark_boost;
+	unsigned long last_boost_jiffies;
+	unsigned int watermark_scale_boost;
 
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..4a8243abfb17 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -217,6 +217,7 @@ unsigned int pageblock_order __read_mostly;
 
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
+static void __setup_per_zone_wmarks(void);
 
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
@@ -2189,7 +2190,7 @@ static inline bool boost_watermark(struct zone *zone)
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
+	zone->watermark_boost = min(zone->watermark_boost + max(pageblock_nr_pages, zone_managed_pages(zone) >> 10),
 		max_boost);
 
 	return true;
@@ -3975,6 +3976,9 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
 	mem_cgroup_show_protected_memory(NULL);
 }
 
+/* Auto-tuning watermarks on atomic allocation failures */
+#define BOOST_DEBOUNCE_MS 10000  /* 10 seconds debounce */
+
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -4742,6 +4746,27 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	/* Proactively boost watermarks when atomic request enters slowpath */
+	if (((gfp_mask & GFP_ATOMIC) == GFP_ATOMIC) && order == 0) {
+		struct zoneref *z;
+		struct zone *zone;
+
+		for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
+			if (time_after(jiffies, zone->last_boost_jiffies + msecs_to_jiffies(BOOST_DEBOUNCE_MS))) {
+				zone->last_boost_jiffies = jiffies;
+				/* Smaller boost than the failure path */
+				zone->watermark_boost = min(zone->watermark_boost + (pageblock_nr_pages >> 1),
+					high_wmark_pages(zone) >> 1);
+				wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
+				/*
+				 * Precision: only boost the preferred zone(s) to avoid 
+				 * overallocation across all nodes if one is sufficient.
+				 */
+				break;
+			}
+		}
+	}
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-
@@ -4947,6 +4972,30 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto retry;
 	}
 fail:
+	/* Auto-tuning: boost watermarks on atomic allocation failure */
+	if (((gfp_mask & GFP_ATOMIC) == GFP_ATOMIC) && order == 0) {
+		unsigned long now = jiffies;
+		struct zoneref *z;
+		struct zone *zone;
+
+		for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
+			if (time_after(now, zone->last_boost_jiffies + msecs_to_jiffies(BOOST_DEBOUNCE_MS))) {
+				zone->last_boost_jiffies = now;
+				if (boost_watermark(zone)) {
+					/* Temporarily increase scale factor to accelerate reclaim */
+					zone->watermark_scale_boost = min(zone->watermark_scale_boost + 5, 100U);
+					__setup_per_zone_wmarks();
+					wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
+				}
+				/*
+				 * Precision: only boost the preferred zone(s) to avoid 
+				 * overallocation across all nodes if one is sufficient.
+				 */
+				break; 
+			}
+		}
+	}
+
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
@@ -6296,6 +6345,7 @@ void __init page_alloc_init_cpuhp(void)
  * calculate_totalreserve_pages - called when sysctl_lowmem_reserve_ratio
  *	or min_free_kbytes changes.
  */
+static void __setup_per_zone_wmarks(void);
 static void calculate_totalreserve_pages(void)
 {
 	struct pglist_data *pgdat;
@@ -6440,9 +6490,8 @@ static void __setup_per_zone_wmarks(void)
 		 */
 		tmp = max_t(u64, tmp >> 2,
 			    mult_frac(zone_managed_pages(zone),
-				      watermark_scale_factor, 10000));
+				      watermark_scale_factor + zone->watermark_scale_boost, 10000));
 
-		zone->watermark_boost = 0;
 		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_HIGH] = low_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_PROMO] = high_wmark_pages(zone) + tmp;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..7fca44bdbfe5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7143,6 +7143,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	/* If reclaim was boosted, account for the reclaim done in this pass */
 	if (boosted) {
 		unsigned long flags;
+		bool scale_decayed = false;
 
 		for (i = 0; i <= highest_zoneidx; i++) {
 			if (!zone_boosts[i])
@@ -7152,9 +7153,18 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 			zone = pgdat->node_zones + i;
 			spin_lock_irqsave(&zone->lock, flags);
 			zone->watermark_boost -= min(zone->watermark_boost, zone_boosts[i]);
+			/* Decay scale boost gradually after kswapd completes work */
+			if (zone->watermark_scale_boost) {
+				zone->watermark_scale_boost = (zone->watermark_scale_boost > 5) ?
+								(zone->watermark_scale_boost - 5) : 0;
+				scale_decayed = true;
+			}
 			spin_unlock_irqrestore(&zone->lock, flags);
 		}
 
+		if (scale_decayed)
+			setup_per_zone_wmarks();
+
 		/*
 		 * As there is now likely space, wakeup kcompact to defragment
 		 * pageblocks.
-- 
2.39.5


