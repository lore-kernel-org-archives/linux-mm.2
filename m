Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE940D29FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631856B0092; Wed, 14 Jan 2026 06:28:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC1E6B0093; Wed, 14 Jan 2026 06:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532706B0095; Wed, 14 Jan 2026 06:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42F036B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:28:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8D7858895
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:28:03 +0000 (UTC)
X-FDA: 84330345246.25.12ED32C
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 384C14000C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:28:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HMvCQTfP;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQrRXafbki8ZMcy8z2Hcjb2BRtf8xkeE1S/3l2uCAgI=;
	b=D18hN6p2xzVcf44CNtEZqbVfyWcQk1uE8krmcIV5dA9QYYROE3pp/kyAbexojw+fmmNE0z
	MoA4zAr+sxdgLfl+7xiU/c+xiaZo1SjEH++Ie+Z9Utxx/y3QP3fMfQNst1uApNYcZI6hvy
	r6VrUzMwsEg+00pfkgVbB3gslhb+bq4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390082; a=rsa-sha256;
	cv=none;
	b=IWvqWoKlRDHei6dRSMS9UDKDCBLiuBNJZ7CqcgSYKi2VYh6BdXi4gI/mplVsbZiN2ji9qk
	WvmMgbkneZox7Mcr5/RB0x1qPXFgY+484qoAg7jTtKZNkb+oXHG8meV+MlJNqwD4CuyNXq
	xJjiGACuuwbTYx8Ze6RyaWQ4owmkXNQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HMvCQTfP;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LQrRXafbki8ZMcy8z2Hcjb2BRtf8xkeE1S/3l2uCAgI=;
	b=HMvCQTfPUcekymPpBdbp5V9W6D2Pm+rNcZqnIuWTXhOu8yiEhf6g7L8nXHK5JBtysXwxT+
	EzlkmMiPmUaMOef9ymcM1XdVKhkGr4gCdbG3JJJkv3K1jricXhwYNizUX3U9nljcSq5jDr
	6tVFk0Ja3GQw49oYp3EKlAcMWrn0bCc=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v3 03/30] mm: rename unlock_page_lruvec_irq and its variants
Date: Wed, 14 Jan 2026 19:26:46 +0800
Message-ID: <7693cdd509da466c06b59f704cfb8360d804e5fa.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 384C14000C
X-Rspam-User: 
X-Stat-Signature: jec5bshink5rxgfk39imukzuqqzh7gxg
X-HE-Tag: 1768390082-884871
X-HE-Meta: U2FsdGVkX1/J3zd9ZNo3cWVlAqj5zzoks/rhh/n3LViuWhvxGpSw4xG/s8m/TWQCD4HaKq7YDxEzSfUE75nrlDIhWk0cv4EwWkJb/xRHNiTfgc2V0WNwbR5ApdkAh/Ul1MOUG1hdxC2u2VNEXyUrBHFlqsxnuvg8vlZJzVSBGmkUU5Nk1VJVo5zfEkjAZmzIPbzjdDNL+UsRVr2PscGGUbOezgyb9Mt8Wuu0gAZwr69mYq6V4mUNDUiUgpcFP8drQcvXgj36Q3tPti35XDOmHWGfWVAe+LgL2RriL8BLBdVTzyVSoK9RTqcQmYBHF7m8SdASaEHKGd7Pkqfk3xhUzpLwnGF36sDubCuZm3oEs2hQntiBILiCpHMW80Y0k6qOuU5y7DZ6iYSy/SKyeqoim414pcXzsp0fuO3KM3+xEE90CqmKCX7Sl94hxFk3q6ts2PLBit8JtTDowqNjWzx7H2RycXUl4FeBfJoUrvxmklKTjmNlEhYPJCmDy02zgPeuCpabvaNl/71wKWXNQYveHUZnBWKjJfGH9XqwzY5num2yO2xJIgu6qmgTFApEbnnGnpDpavaWV68zjTv2NDV2gxoyfUD/xhnacsWTCoEWYyOniXw+MS+fnHf1a1cxrMtsWo9Mr6DVgoZBYQtTAdR/nNz+JsUtP/KXJKtX9wzE++jo6nLXuZY34n3tIvX+609Ct/7Yj6ZZMXAClZ6yT3kamJ18hKC5pRg14BBHxAPnlCX05J+PMrsd2HWraFPIA3RbVkCqK5ut48fQpJKcwLoApf9c3gafiboX3Yh8laZ3pvR/clV8romQA7HRUDMFCAsWggqIuYcBL1pakhOvvvwyWBK/A6arzzO5NjYRySumeSVDsXKx9iWAu2Tf/VkYvPqBQ6hbS4Ie68oZYeLXWnjMzbmmnlHiOr7qxx3hD79uiEsBE5X1eU8bafIeZ0qKaIqOUU74ltNzsWoMCMxTHSo
 KZLyPosZ
 z6kApCaatZpbVc/iEplU8F2lDDsAJQrSCZC+cC7t3lKXBFoEAFPPtScUM1cnxF9NGXXAURfHS4YLcv2nr8qfpQi2xJS9/055/iKjjzyQds5ssCp8zEY0D7brIEKgs01cY6nEGq9ki5Oq5x/T+nSetkq26AWlmNXYNY2X0kmxrPrFdnxanPhF3/8Wx1OiszPQswqcu2zDQVkHl6GEiKEpUVUrP7Nvvw5NoaAVT5N+8cZ7mdSQYtcdyk9dXd593mSvVoPNdHTx2HRXiVafA8LehYy1fFMtnnLBpDgJTqDf1zH50lRIP1VdIIgLU9utNtqClCVQbXQiuufvjsExp5XCcEnkkNS8uSbG9FA48ixRFS0ki0aJOJZtnB6EQytGUkhlJaCB/csB/8lQf8EI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index af352cabedbae..6a44e79a8bd23 100644
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
index a6d37902b73d2..99515838faa51 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3899,7 +3899,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
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
index a0e3f51de749e..1ede4f23b9a6f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1853,7 +1853,7 @@ bool folio_isolate_lru(struct folio *folio)
 		folio_get(folio);
 		lruvec = folio_lruvec_lock_irq(folio);
 		lruvec_del_folio(lruvec, folio);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 		ret = true;
 	}
 
@@ -7871,7 +7871,7 @@ void check_move_unevictable_folios(struct folio_batch *fbatch)
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


