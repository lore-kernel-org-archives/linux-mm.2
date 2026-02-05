Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4656DE91299
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 08:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75946B0096; Thu,  5 Feb 2026 03:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F406B0098; Thu,  5 Feb 2026 03:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9216D6B0099; Thu,  5 Feb 2026 03:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8F86B0096
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:56:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33C9413AD02
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:56:53 +0000 (UTC)
X-FDA: 84409797906.07.A02F9D0
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 76DCE40006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:56:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PQqg/kep";
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770281811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePJPKwGbZY5Eb95/OlXPN5o4YPM+nBdgDWiBKLLcLus=;
	b=y08T29VA4Oji5EG5uFJFx9TmS3qq+wFtvwxWpI8c4QwZAfaVVhRgs8gwEG81Nz0VBDEj6B
	Mq11UWXf/RmdGV0Mv1THGLAHHJIhWdRxsUj+E2Q67dVVZYl9LEp8mSYPbS4WZqEvZJlk7O
	P+gnvhffvOawndlkRRY+OLGWep8VxEg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PQqg/kep";
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770281811; a=rsa-sha256;
	cv=none;
	b=sBQjhHQzqoKLiHzdWA8VagALr6+V7m0CHHy2NlPU/RmMnrZ8kiOzAPRSgFA7jju0LhMQuG
	Fzr1R3SA4T1AFJEwEIKP8WaF+Dp3BKQw6Wsg62ktEd0q8p3DR7Q1r3SoTgmFhMPOP13VS/
	iyJ8Wx7oFOLvN4PbCP15q7qBOp88hCs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770281809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ePJPKwGbZY5Eb95/OlXPN5o4YPM+nBdgDWiBKLLcLus=;
	b=PQqg/kepkrulz0AapoHwpSjj9QiJxWd4sGacVD6KgiymVlXgQu0ZTQm4ApMiK8+3st79uk
	XLu1AvC1xDsRJdvEFJFnsc4qO7kcMebA3kyosTz03MTnB3ewI57aMgkiOo7KIR7ucrWP8c
	rCfdqA3sYn+aVRw+5zkj/ansmZWBFTQ=
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
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v4 03/31] mm: rename unlock_page_lruvec_irq and its variants
Date: Thu,  5 Feb 2026 16:54:32 +0800
Message-ID: <edcfaf55e476356f104145ad7c35facbfdd7315f.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: 36oq3kypzinuywaz9x6u1s1m9n6nr4qi
X-Rspamd-Queue-Id: 76DCE40006
X-Rspam-User: 
X-HE-Tag: 1770281811-204373
X-HE-Meta: U2FsdGVkX19eNca6WgGiTgbPG3MGldMo6Fy+9j/jJSelA3Qbrgxf8iq+SgQJfzsky/94SSuX0ps8suP4EhI9/qEM1VmvbN8rNVCSd9R/neY3yX9nmhdKQPnZnhJaJ3/fn3eTgJwYUu3ubCtm848KiFOB3JPrAgMu0FkY5xB89O4XHhyngIu9ciYgsUkbB1lYkLgjv1hj1ALt1ogoOvgesw/P6e3e0STxqBL3I9gZRZejt9Ju+E8iHdYWytPGVjf+5tq82oPMMO55Fo2/iB1QmPiBCEoYJQ3EBgSWudzDPzb4BA9/5SB7XibodnPeJCM0pzuNKNQBniIAPuB7riF6wvZV8UnyiqOY41SAZMfUkaMLigD/qgb2w13E4JbQrxnXfYL+1q6+MuBDZ5l9W3ucPQRay0fD1LMAIVy+I55t6eCVNhPZO8LQkj6syI8MUbwZ7QDlB6djyvvah2wmJQUgQVE/RmKL/KSKX9PF/Dn0AzFHStmweIkXsu7C8Oy7VXAyqbtr3KT1GpZi5NIOm2IBGhzfPHjL/Z2RKIHhhk1dr8AUZmldF5Hm7CLsthF4miaI+TueRV4oHJneXMoGMsd7l6ACxs2+SL75DcTCHep/0RLnK+hJ6/KnHAlJOGlG4BW4N1Q7WnTHxkzx8rOe/NCrgrIeawf7Osh4lfjzUDHDWLl+sosxFRZmckDKnrppog7QLqfPEUjC7TuRtD6zxxdVF5+aEvFi+lhNkvrTiYK1ApW3ULDa2irkJkQbRBqkhubTXEVkc8pmt9GApj6gjCY14m48X6AZpVN7iwkV/HTE4WTCEJ7I1KCW1dlGgDE+kVbi76mmFEu1hS+HWEleSkwMAbP5A7I1X2L0MZgVAMYnwvlCCjFe/U2uMdXAplnpQvO+gmUONEn1uBruhmktPFnj0s2s3d2+1qiih0zT6x7rr+T6IBJ+mE2/nymAt1hxwArnl309BLq3f8eCVLehamk
 Ndl/FC6g
 z5MG+ymknludPZ+it3plauQRpPQqdORuju0hhVE07yp0/9bT8RJ7+bdizr0O/Og3JdOgiAi5ao4BRJFjjuqrJMp8ZJ5GeNJXPZUMfdIPDtY0Pyl+VhfJAab/fHB15V8OzYnY9HT4SbdUVEk60mwOpU3OK9FrikboFRaX7gI1/+w+4iymp6gNRii4BnYpfejLgnk8W+CGGa0PyeQ0W88Jczql0erx48fM0hYnHtJu+q41zRuw542lQmE8ECeR4XVUMuL5zgu9AP54HZtTBAWC03GDxejIAe0/7kzYTxKeK6UTSb8kz+zOsWilJT2DHD+i548u/7qOqly9fRFjhvxskfay1gMEf4Ruapk+fPkIYx+w1gBvI0pgh+eoJSBiSuZ+Czp0aZ+mSdv8WO6w=
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
index 0d487649e4ded..580376323124c 100644
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
index 01d3364fe506f..a4892f5e3d347 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1836,7 +1836,7 @@ bool folio_isolate_lru(struct folio *folio)
 		folio_get(folio);
 		lruvec = folio_lruvec_lock_irq(folio);
 		lruvec_del_folio(lruvec, folio);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 		ret = true;
 	}
 
@@ -7878,7 +7878,7 @@ void check_move_unevictable_folios(struct folio_batch *fbatch)
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


