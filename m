Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56322D64086
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42B56B008C; Wed, 17 Dec 2025 02:29:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CE16B0092; Wed, 17 Dec 2025 02:29:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956CF6B0093; Wed, 17 Dec 2025 02:29:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 812CA6B008C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:29:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54B291A0935
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:29:19 +0000 (UTC)
X-FDA: 84228137238.10.37DD456
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9C5F9A000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:29:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b8lGVFMU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956557; a=rsa-sha256;
	cv=none;
	b=5pC7ioaTRXnqi0zxhInaogUEMfide5cpdgnSRaUwD6pTGvIPQzUKRvUFUkhGnzPvIPSAXo
	6IfnsfjOHkyLVcEdcgIscdV/2Ejpkb38hG4y0VfjX5vU9Yc0ToMgkQchFdO1H7yQvHqOAF
	Bw3oFc7e4ZkDCsLB7Vk3NAQmu6d6PHc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b8lGVFMU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4L3YNXkehnIUzmA6CqnAEojCUbAuuP/FY++XgJVDs2Q=;
	b=eiyCHRBRLm0I3JCpRb+8h5o8XQ08cE7V0WCmAyGKx5Uu51fPXovpYQ8fIEnfGQ8LYWlesD
	Ky23GVXL3JftG/ANLsaghymcntXq7ftUbWghk36o3vr2XpeRyLlbVuusgQMWHf0sGL6DWT
	kB/oHCcjyO2PdrmtUx0mGBGSsrM5ODE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4L3YNXkehnIUzmA6CqnAEojCUbAuuP/FY++XgJVDs2Q=;
	b=b8lGVFMUdp31z3ViKZO9ump0anJKy72LA/L/JhZ57uNsA6yNNyApzS7YROJV21E4UwWLmI
	b4dAJfey+LBXc3d7gLEIlKJc+YLaxUhW+zi+6ERo3nQQ0imO8Hc0plH3kE/UAKciz786CR
	9hGDSdlAMoSLd6IADJTjF6eif5Bppxw=
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
Subject: [PATCH v2 03/28] mm: rename unlock_page_lruvec_irq and its variants
Date: Wed, 17 Dec 2025 15:27:27 +0800
Message-ID: <a11ca717ddd52fd83e1fff9942fc49c9c5c5b78c.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9C5F9A000C
X-Stat-Signature: fhgbhs1nx9xqxppy4bgs3hu6z4jprxbg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765956557-210170
X-HE-Meta: U2FsdGVkX1+eML5hpBElf3FrbqPw/Zc+YKzrfz7b7PsKO2E76G1/2t82kYweu3SUHjCCh6oiOfAlhdHqCgmTAM6CdK0rxrdT3z8CykdFkjCYsf7nmRwFxYqCCzippfBV3lNNicaE4zKpLWexuouzqOw7ni26soKJ8mddGmzRktMtUtG+D5NIwCGCDJgrneOe4IXSqv7I7r3qMrCcrJIqEQnvyf2G+FA8TXxf3NswHpkBc6TpqfOvzs0WbdquPwq/Jp93OVcT6SduOWv5rzichnDsuYpcg4F+bzAKOJ0lE2CzPwKzt5AhXzldTl8ZZsihyqYkda5huJ9wxho5gX9OpcdDDL6pRsozbq8FaApkz8W2uFt+NWK6V2Hiks/nhuo+shb1SMeipj+XysN59+Q8Zqqtj86CpPxwrs1aYEeKLOwwcWiUwjoIaAaUHiXVEdmj1M+2+piyplqy8ApyaW6PVjcAFDVmNGEl5sQ9R6a9+4JIH7pzmV42A4XEYrDNr1ZkY7fEJVzXCYoxevNpvWy+hSOJ4Veo8rCUJiyuT/0CT6CYNePji78HLe5vIsIKd5/KbG6aHW088O5QC9AuD61LLKOcn0Srsdj+++OijNJ4vAwwj72vFbGWavJn4cnbmdDl/r08EgocfTJRhKRUGm1w65cHxigifBaJp05rZHnKYP87yW8Pcc56f8Ikqx0SdlkiARTyRovuORumo0IUgz5jrtYgv48o0Mi9E3PKmHNKT6oxBtVixv3WYJf0krJQLOU+cPliuwbHrin7ilQnEGj8gk8Z71i3jdp8aQ39hUPsF0pzHtQzjI7mZ9tPQweU3sNNnKEjLCDqzUE+hs0qtEZWnyqqxypXMXy/c0QoygGibJcv0O9eW8O29eJMzqjppnkXqgH1tj7NPSWLYlca/anKglfqPzFHy1FvsSEwQCkPiY4fgplzm496tO2DuGT8VZn/pD1YIrQh6nEkLiIuFpC
 2W/20bY3
 aY7NPKwR0VHmfPdp8WKxVd1PhRuUWxEYcZFOyBDCRbrySJDxvYVS2iwft+57M5XlRqFlGqyUPI0kCphAavbdv6+0igcSypy/WKYqoIb6pKQ5AW+Rm1fx8Vubf86+kqWg7DdYwaCbn4ou+HO3Uv6V/o/ezPkPZoAhaxlaL+sUackYMXrRB6PI5ABX8nduX56v7Z4PEOKTWN77AGBA8QztPZk2tN6GUV8ES53I1Fm1rJhAYdXJss9j6Ft7aY6ESDQ2rGHCSJM9+Fv5T7dWTN5v/6/acMfk4obvR+aJRjg8n8PawXldeei2kBzsLJkvWXZ8gZno3919HNmu7XFE88ov5g8jMnlBhB5PNkN0iVk41Dr6KRrxhbP0qNyvTZw==
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
---
 include/linux/memcontrol.h | 10 +++++-----
 mm/compaction.c            | 14 +++++++-------
 mm/huge_memory.c           |  2 +-
 mm/mlock.c                 |  2 +-
 mm/swap.c                  | 12 ++++++------
 mm/vmscan.c                |  4 ++--
 6 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6a48398a1f4e7..288dd6337f80f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1465,17 +1465,17 @@ static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
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
@@ -1497,7 +1497,7 @@ static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
 		if (folio_matches_lruvec(folio, locked_lruvec))
 			return locked_lruvec;
 
-		unlock_page_lruvec_irq(locked_lruvec);
+		lruvec_unlock_irq(locked_lruvec);
 	}
 
 	return folio_lruvec_lock_irq(folio);
@@ -1511,7 +1511,7 @@ static inline void folio_lruvec_relock_irqsave(struct folio *folio,
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
index 40cf59301c21a..12b46215b30c1 100644
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
index 2260dcd2775e7..ec0c654e128dc 100644
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
index 670fe9fae5baa..28d9b3af47130 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1829,7 +1829,7 @@ bool folio_isolate_lru(struct folio *folio)
 		folio_get(folio);
 		lruvec = folio_lruvec_lock_irq(folio);
 		lruvec_del_folio(lruvec, folio);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 		ret = true;
 	}
 
@@ -7855,7 +7855,7 @@ void check_move_unevictable_folios(struct folio_batch *fbatch)
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


