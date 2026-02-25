Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258F0EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89CA16B0092; Wed, 25 Feb 2026 02:50:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E5A6B0093; Wed, 25 Feb 2026 02:50:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D546B0095; Wed, 25 Feb 2026 02:50:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 646866B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:50:09 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17301B981E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:09 +0000 (UTC)
X-FDA: 84482205738.20.846F533
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5D5002000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xBf7msBm;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNsfxtSYWj7yZaRzbGFekqdNorCiiJBwbG2lhydHM1Q=;
	b=7TiFFACDwfg8kEXutdR+PyYXaMAtFSuWuZYu+RAr4c69wwxhznNN7Q0D8TJXQ3Y48QzB3F
	u9ZDKZNZoIDuoI0j3ZOpf6fazz7hbG9gY4PEDmurCCP8TLQfJggHx4z16Wjy91KN7B2zkS
	RbJGxXTUQ4+2zuxpJyTEbDGTfxdPd6U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xBf7msBm;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005807; a=rsa-sha256;
	cv=none;
	b=kjUInWt6NGNF55/FlBqDsjog2C5HyfUhTM+p/YVNMiaVsIx3Yra7YZaOigo0h9NvwPMCXv
	e8FT+VpsJ/0Do8hbD3frKlwV9zad6XyQXSx8tZk3O0O7U1/KRPVZkGydZtujTVhMWMw1P3
	SuEm29wSTpB1M5y+IMDWCCXWkdW1yB8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LNsfxtSYWj7yZaRzbGFekqdNorCiiJBwbG2lhydHM1Q=;
	b=xBf7msBmNWxTp76EkezuwP3yOmREVcS+mBZ3Otp3RVdH6h95vc8o1Q3RGrYvy45Pcl6Qbq
	RIy+DO2Ry2v1Aorx2f0DEqGMtD8Xesk99CCX7BiTKEfo8sMm4WCOslg5DYWlAnvnWWEWh3
	3UYHHZEjZbUWcZnfEWo+2USixoNM/J0=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v5 03/32] mm: rename unlock_page_lruvec_irq and its variants
Date: Wed, 25 Feb 2026 15:48:36 +0800
Message-ID: <4e5e05271a250df4d1812e1832be65636a78c957.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D5002000F
X-Rspamd-Server: rspam02
X-Stat-Signature: f1mtuwge4snhf8cbe7z18g3quaigj81d
X-HE-Tag: 1772005807-959476
X-HE-Meta: U2FsdGVkX18Ut4+z0nrIvxj1X6BaU8KmHdcVGjoiohOTexuunRXCfyaQzzv7fymFneAHIs2BVLYn/oHT5Qs0LZrngp2WZBGj6lVgAUIqhjDq9Rr3jRNffJ0sRbp0ymQEwR58LwrlNGlRWIS5+P6Cw2AyHtrcOjp0DlHDrY5eE4/qoH3u5cab0FT7iQnKDXiwST6ql5f5ifc0vU4mVycGRmOaUBXvr5LCFjXIS7bjHmHfVHkwoqcQOQBNJ7nC7gmFikiqmuArG9wkFRSTfabItqB7wj9uLBDHvv3uSTZiujqKjH7/lkbUPlkMRYY7/jcRtyyOc8myyutPSDDCVDfBUyFexu+tdrYrel3iED2XiLCZutVtnRsysIhexo9y87oygIJR61+j8qoOzyJupgJ4eFIX7fslBtFlJSQHfYjEzINVdHzBiuIRIhtyXnci+5v9/2XQcgBWd0LlzJVjzdt7pbcPT6QNwpkPSiu5plCJUT/Oe9VqQyleWTvDBty73MprBYVeC+NKq3Bl1Bb+byeub6tM7BVy/kuIyX0tCqFn346othfPqe2eHac6BMvca9K2YUNQHULEOGRJ955yah4C05xeklYzJwXn9sAuvjsHKPD/oCka3nOLYRf1w7ZUYVvP9cdj0RWHl5xEHhqOp8szzou3pAFwcbutFG2rNjPCo7WOPGbij4gkV077YMldMOeXaAIUiPCQtuiL1MBLLu9pUjFBlTMR0CWn+NVCHn3Rjtd2RcHrBwr3GU5veFGSpq+LVDSQ2QcsUv6FCiotn7tYlKwYjJBlt+UABN2XJNuSiCuVagSMRbfzPt3Rs3z8ZvcJO3pCQNSfwWD6xi+h09jWlnZO05mNhCawrd8i7X5bF3l3ON6IX072lpGaAw0UBDWo8CZ/26JzTxR81ssb2g68hc5DyyVG+r/0QMVGlHi48nqkTcQWTaUBY847jhmnQp/mhRaXIwnoGlEtkFcJ6Yt
 kd4iFXog
 eDP/VFKOm0jce7fCrEQc5YznQyQTQTXC3bYWRQignldh2XidI9tUb8heKJF6BORgtyPQFIb+siPbCcq8TiKW2gWA5gL3FE4netBBh/Wg+vBIQgE7/UTg2l5RP3LRhOTB0e8liN9/DtIvDD8IH7k6p7eVTwebRa5TO6ifgU+H5VwIDbZmNTxGV1kxp0TpTuAfD0x80RWAL06n3bpIIuzByO9uH75xwyUsmgHYXzgDDJPcZnjCd0x3q3DaKk7odstcdfseFdg55WZ3UecfvmIk+qFpamrio4uJOZvRuvNMxV+V8ouKM2eFCePsqNs8RUVYghjqxyvvWYa9XYrJV3mhXr6koJN/xwVG4h1dBGOb/M29qgOHAmgA5yMf/HxgjOcXYjPR+ypQiyIXYMZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

It is inappropriate to use folio_lruvec_lock() variants in conjunction
with unlock_page_lruvec() variants, as this involves the inconsistent
operation of locking a folio while unlocking a page. To rectify this, the
functions unlock_page_lruvec{_irq, _irqrestore} are renamed to
lruvec_unlock{_irq,_irqrestore}.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 10 +++++-----
 mm/compaction.c            | 14 +++++++-------
 mm/huge_memory.c           |  2 +-
 mm/mlock.c                 |  2 +-
 mm/swap.c                  | 12 ++++++------
 mm/vmscan.c                |  4 ++--
 6 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5695776f32c83..52b1d8f3942e1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1480,17 +1480,17 @@ static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
 }
 
-static inline void unlock_page_lruvec(struct lruvec *lruvec)
+static inline void lruvec_unlock(struct lruvec *lruvec)
 {
 	spin_unlock(&lruvec->lru_lock);
 }
 
-static inline void unlock_page_lruvec_irq(struct lruvec *lruvec)
+static inline void lruvec_unlock_irq(struct lruvec *lruvec)
 {
 	spin_unlock_irq(&lruvec->lru_lock);
 }
 
-static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
+static inline void lruvec_unlock_irqrestore(struct lruvec *lruvec,
 		unsigned long flags)
 {
 	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
@@ -1512,7 +1512,7 @@ static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
 		if (folio_matches_lruvec(folio, locked_lruvec))
 			return locked_lruvec;
 
-		unlock_page_lruvec_irq(locked_lruvec);
+		lruvec_unlock_irq(locked_lruvec);
 	}
 
 	return folio_lruvec_lock_irq(folio);
@@ -1526,7 +1526,7 @@ static inline void folio_lruvec_relock_irqsave(struct folio *folio,
 		if (folio_matches_lruvec(folio, *lruvecp))
 			return;
 
-		unlock_page_lruvec_irqrestore(*lruvecp, *flags);
+		lruvec_unlock_irqrestore(*lruvecp, *flags);
 	}
 
 	*lruvecp = folio_lruvec_lock_irqsave(folio, flags);
diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c6..c3e338aaa0ffb 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -913,7 +913,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 */
 		if (!(low_pfn % COMPACT_CLUSTER_MAX)) {
 			if (locked) {
-				unlock_page_lruvec_irqrestore(locked, flags);
+				lruvec_unlock_irqrestore(locked, flags);
 				locked = NULL;
 			}
 
@@ -964,7 +964,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			}
 			/* for alloc_contig case */
 			if (locked) {
-				unlock_page_lruvec_irqrestore(locked, flags);
+				lruvec_unlock_irqrestore(locked, flags);
 				locked = NULL;
 			}
 
@@ -1053,7 +1053,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			if (unlikely(page_has_movable_ops(page)) &&
 			    !PageMovableOpsIsolated(page)) {
 				if (locked) {
-					unlock_page_lruvec_irqrestore(locked, flags);
+					lruvec_unlock_irqrestore(locked, flags);
 					locked = NULL;
 				}
 
@@ -1158,7 +1158,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		/* If we already hold the lock, we can skip some rechecking */
 		if (lruvec != locked) {
 			if (locked)
-				unlock_page_lruvec_irqrestore(locked, flags);
+				lruvec_unlock_irqrestore(locked, flags);
 
 			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
 			locked = lruvec;
@@ -1226,7 +1226,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 isolate_fail_put:
 		/* Avoid potential deadlock in freeing page under lru_lock */
 		if (locked) {
-			unlock_page_lruvec_irqrestore(locked, flags);
+			lruvec_unlock_irqrestore(locked, flags);
 			locked = NULL;
 		}
 		folio_put(folio);
@@ -1242,7 +1242,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 */
 		if (nr_isolated) {
 			if (locked) {
-				unlock_page_lruvec_irqrestore(locked, flags);
+				lruvec_unlock_irqrestore(locked, flags);
 				locked = NULL;
 			}
 			putback_movable_pages(&cc->migratepages);
@@ -1274,7 +1274,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 isolate_abort:
 	if (locked)
-		unlock_page_lruvec_irqrestore(locked, flags);
+		lruvec_unlock_irqrestore(locked, flags);
 	if (folio) {
 		folio_set_lru(folio);
 		folio_put(folio);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8003d3a498220..f6c0a86055bdc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3902,7 +3902,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
 
 		if (do_lru)
-			unlock_page_lruvec(lruvec);
+			lruvec_unlock(lruvec);
 
 		if (ci)
 			swap_cluster_unlock(ci);
diff --git a/mm/mlock.c b/mm/mlock.c
index 2f699c3497a57..66740e16679c3 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -205,7 +205,7 @@ static void mlock_folio_batch(struct folio_batch *fbatch)
 	}
 
 	if (lruvec)
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 	folios_put(fbatch);
 }
 
diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece464..245ba159e01d7 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -91,7 +91,7 @@ static void page_cache_release(struct folio *folio)
 
 	__page_cache_release(folio, &lruvec, &flags);
 	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore(lruvec, flags);
 }
 
 void __folio_put(struct folio *folio)
@@ -175,7 +175,7 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	}
 
 	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore(lruvec, flags);
 	folios_put(fbatch);
 }
 
@@ -349,7 +349,7 @@ void folio_activate(struct folio *folio)
 
 	lruvec = folio_lruvec_lock_irq(folio);
 	lru_activate(lruvec, folio);
-	unlock_page_lruvec_irq(lruvec);
+	lruvec_unlock_irq(lruvec);
 	folio_set_lru(folio);
 }
 #endif
@@ -963,7 +963,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 
 		if (folio_is_zone_device(folio)) {
 			if (lruvec) {
-				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
 			if (folio_ref_sub_and_test(folio, nr_refs))
@@ -977,7 +977,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		/* hugetlb has its own memcg */
 		if (folio_test_hugetlb(folio)) {
 			if (lruvec) {
-				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
 			free_huge_folio(folio);
@@ -991,7 +991,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		j++;
 	}
 	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore(lruvec, flags);
 	if (!j) {
 		folio_batch_reinit(folios);
 		return;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7effd01a78287..223d584421a9e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1835,7 +1835,7 @@ bool folio_isolate_lru(struct folio *folio)
 		folio_get(folio);
 		lruvec = folio_lruvec_lock_irq(folio);
 		lruvec_del_folio(lruvec, folio);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 		ret = true;
 	}
 
@@ -7861,7 +7861,7 @@ void check_move_unevictable_folios(struct folio_batch *fbatch)
 	if (lruvec) {
 		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 	} else if (pgscanned) {
 		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 	}
-- 
2.20.1


