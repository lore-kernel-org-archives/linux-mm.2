Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D7EEFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543A46B00BB; Wed, 25 Feb 2026 02:55:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500B76B00BE; Wed, 25 Feb 2026 02:55:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457FA6B00BF; Wed, 25 Feb 2026 02:55:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3B36B00BB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:55:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA8D2C1D37
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:55:21 +0000 (UTC)
X-FDA: 84482218842.13.A8E7F1D
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E48B40003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:55:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CD5nOqQI;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTdOluh/9ylRlwKeMfFMFMRs1I9w1KAVDyJhidoOplQ=;
	b=8N9n7u6LZM1RXblvFNEHFiFX8P9iaAWkSgL2VEkpQV+TCgzlHA15muTtDz88sqmBeg4AZ3
	W2Cu/XcfbpK9YjMbxUO3ixLu/Q43x5a/752x9VEIP46KW6Hbe6yUm8gc/sMsMEMIRpG1e4
	Igg5BnKSMr0pS63gg0sTMY4IIqYmNeU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CD5nOqQI;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006120; a=rsa-sha256;
	cv=none;
	b=H3InTCDC3Nmis/ftl1aDHBwk0Tzv/735kJhYnH1PkEpaPJj/IRK2xF5kanp0TDTmrH+ikz
	961hWEmCC4xoTKLZSwyIuAcUV7uqS2yyFjlCfRFcZpAYWCklf/8ob4Lrud5nxTazyZvG23
	pH9TOWe+/6+SMu0TyJ2y99gAdErTYaY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTdOluh/9ylRlwKeMfFMFMRs1I9w1KAVDyJhidoOplQ=;
	b=CD5nOqQI65WZlCilX9JxR763nIPiLXhMzo181x0A+UZvQG539bn3/Bf1vLd4XjyO648g7r
	pDzAtti5pwfaRYRjt5uJsHPiiierKn4tF0OY8MJyMuV2EVhB4GRHO58I90dncYVAtJLaT5
	uT7NLi8UNeviY7GklvqibH74CI9pARI=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 23/32] mm: do not open-code lruvec lock
Date: Wed, 25 Feb 2026 15:53:06 +0800
Message-ID: <2d0bafe7564e17ece46dfd58197af22ce57017dc.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E48B40003
X-Stat-Signature: w4muc8isodpomzgqarups5r1f4zs4rkb
X-HE-Tag: 1772006120-140660
X-HE-Meta: U2FsdGVkX19ilh7OCfoLq5+SUvVAq3zYCAYtuvoRbYGVh3cCSMtd2C+gMEVSABAMr0PtUQzXsA8dMeVVLhoSZaEM9IDdx+Oc8owfIvYMuT2vyU7EAkq66MMMVANgYVnDd5ajeoOQ/I2/p0T4pmELtTWklzSgL13uOuvMKlrJ+u+eTz5DIuTyi0kMZewaYqf+ibJRQFozdPgvK7tGTs1ZUnXHi72Zriy644yi3CmmXuiiowp0Tw7HkYs0OT4EwcN3QFF5hFm1mYoqmpnkiJ5xA5IVT4JJ360ZXhV3awzFei3yMsv5LmvsR9TBsrTEQdhRx67d26N/cK+VljG1SfnU33LA3m7fw/Yj9pdeiJWYgpGkXStdYX3rIjxO0EmeIWPstVnY8szf32KO5nmE1S8tsYvlH1i3/wjpiqIJUnKkF+HRjES1N5IFP78t5Bwht/yBhyDmEhCCF4Rcwe/m5GLzCpmQjdSEiHoXZV0V/KP/SkS9cSX4Z/tY8Bee5FNqeuL79YZI0BcBe1Ey8CYNgQXbti4CNGgZLXiXwQ0/l3kPs8CNwE4hbqXuOdx7HHBY8Z2feH0v9u/c8zbiiUWO1hlhEYTFjbEefA0maYnGkR6jfPEXaUqGE/XtIT34Gj2vJwGcfKhGuhaPx5F+w8xWdFnpNMJyUflb6mRgWYyiHfgrYz04lo5j6fq8gRMftaP2J4lcFHXpOsPhsVh8PyWoUuq78g82at1xibTfe6rV+jj7whD6qFvOBxD/4eOHnYOI4pz7nU5itx2XQl/wIarJ7inSCiYDihAZnVBO376jJcyYHtdfokqvHx4idalwOfMSu3M413c3jFhuPwvy0jKM8vOdmWQWxz1Om57n5Cvodjx2Tjfy9G9Ev/jvbnkUSre7XQndNioxHYS7Y2KC5xiM5Ogcz1TZDPI53CAst0i3v4xb6zp3/mK5tOiBV+051UB1RjOePlnFFg9i8tTkPrHmWV9
 J4xyFKSm
 fsfLmoXpCVckFOgKBG4PkRWuav6aoB7L1vfWWu1sWhl5fFXuwswXdnkFnEBgkbfRVew/6pqOGo31bCYhRE9gZ6nNJC1j+7tqvuKesaPs6aSgN4kX4uN9+CBgt4sL7vNJ5LgsUsdxXKszv57+yJ58KfscAiZvZ5ORC8/IKO3FFyz4agljnGc/VQvEQXFaHNFGnCPaepM7RpSneNEGmXwnKmjQBjdFtMe84uTWjnmoJmSUEdE4hJkX+r8zjBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Now we have lruvec_unlock(), lruvec_unlock_irq() and
lruvec_unlock_irqrestore(), but no the paired lruvec_lock(),
lruvec_lock_irq() and lruvec_lock_irqsave().

There is currently no use case for lruvec_lock_irqsave(), so only
introduce lruvec_lock_irq(), and change all open-code places to use
this helper function. This looks cleaner and prepares for reparenting
LRU pages, preventing user from missing RCU lock calls due to
open-code lruvec lock.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/memcontrol.h |  5 +++++
 mm/vmscan.c                | 38 +++++++++++++++++++-------------------
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0fdfb8044458e..c7c207a830c50 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1499,6 +1499,11 @@ static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
 }
 
+static inline void lruvec_lock_irq(struct lruvec *lruvec)
+{
+	spin_lock_irq(&lruvec->lru_lock);
+}
+
 static inline void lruvec_unlock(struct lruvec *lruvec)
 {
 	spin_unlock(&lruvec->lru_lock);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 024ff870b1a03..08ed278115f70 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2002,7 +2002,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	lru_add_drain();
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list,
 				     &nr_scanned, sc, lru);
@@ -2012,7 +2012,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	mod_lruvec_state(lruvec, item, nr_scanned);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + file, nr_scanned);
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	if (nr_taken == 0)
 		return 0;
@@ -2029,7 +2029,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
 
@@ -2108,7 +2108,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 	lru_add_drain();
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold,
 				     &nr_scanned, sc, lru);
@@ -2117,7 +2117,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 	mod_lruvec_state(lruvec, PGREFILL, nr_scanned);
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	while (!list_empty(&l_hold)) {
 		struct folio *folio;
@@ -2173,7 +2173,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
@@ -3794,9 +3794,9 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 		}
 
 		if (walk->batched) {
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec_lock_irq(lruvec);
 			reset_batch_size(walk);
-			spin_unlock_irq(&lruvec->lru_lock);
+			lruvec_unlock_irq(lruvec);
 		}
 
 		cond_resched();
@@ -3956,7 +3956,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	if (seq < READ_ONCE(lrugen->max_seq))
 		return false;
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 
@@ -3971,7 +3971,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 		if (inc_min_seq(lruvec, type, swappiness))
 			continue;
 
-		spin_unlock_irq(&lruvec->lru_lock);
+		lruvec_unlock_irq(lruvec);
 		cond_resched();
 		goto restart;
 	}
@@ -4006,7 +4006,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
 unlock:
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	return success;
 }
@@ -4697,7 +4697,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
 
@@ -4706,7 +4706,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
 		scanned = 0;
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	if (list_empty(&list))
 		return scanned;
@@ -4744,9 +4744,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
 		walk->lruvec = lruvec;
-		spin_lock_irq(&lruvec->lru_lock);
+		lruvec_lock_irq(lruvec);
 		reset_batch_size(walk);
-		spin_unlock_irq(&lruvec->lru_lock);
+		lruvec_unlock_irq(lruvec);
 	}
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
@@ -5178,7 +5178,7 @@ static void lru_gen_change_state(bool enabled)
 		for_each_node(nid) {
 			struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec_lock_irq(lruvec);
 
 			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 			VM_WARN_ON_ONCE(!state_is_valid(lruvec));
@@ -5186,12 +5186,12 @@ static void lru_gen_change_state(bool enabled)
 			lruvec->lrugen.enabled = enabled;
 
 			while (!(enabled ? fill_evictable(lruvec) : drain_evictable(lruvec))) {
-				spin_unlock_irq(&lruvec->lru_lock);
+				lruvec_unlock_irq(lruvec);
 				cond_resched();
-				spin_lock_irq(&lruvec->lru_lock);
+				lruvec_lock_irq(lruvec);
 			}
 
-			spin_unlock_irq(&lruvec->lru_lock);
+			lruvec_unlock_irq(lruvec);
 		}
 
 		cond_resched();
-- 
2.20.1


