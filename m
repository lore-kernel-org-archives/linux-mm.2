Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1905CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 15:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3A86B00AE; Thu, 25 Jun 2026 11:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B856B00AF; Thu, 25 Jun 2026 11:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88A6A6B00B0; Thu, 25 Jun 2026 11:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61BB56B00AE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:18:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E00AD165D7C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:18:00 +0000 (UTC)
X-FDA: 84918790320.01.550B778
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id E7C6FA0007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:17:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=araeRisd;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782400679;
	b=osp4haeo+73P53Q31cLnNvWhaxKpEhoZSkldaDCKig6weGfc2szcihr0pJ9NHJ5Ym8y3fU
	BnluLeXYUVb+ybm0m0jpfWwhTAdwLQmdIvvABaBaZPqvYyhvm7ia5vyJbKhftjqgsttPJY
	rFrNaBapyloYtTBjGNVf8PBrnufK44A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782400679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0abFjDD7MeWR8jXMZ2j0zCKAbj5uTG1W2qlcF8YqFc4=;
	b=N7N5y+vyHH7YX4X4jV71+ztt5xkmFrZN10xvxcAiPwjrsN32iMRXs95WgvtGjJ6FWH8b4q
	mZRio8+Fk4Gmn4diWYr9oi9v+VKzYWmK68TS0EmRaLvihxJHRxRG9IlLX/vbN1TXprR5RC
	xWy8VrSDJOCFiyJvLiui3f8Jw/A1fA4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=araeRisd;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782400676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0abFjDD7MeWR8jXMZ2j0zCKAbj5uTG1W2qlcF8YqFc4=;
	b=araeRisdZjkkXDB5B5YHuyjgxiM3QgILhTA3HYQM2YO4riqCwXB16muACRB18zccxmj6HB
	uk5sdyKDreRF+CYXqUsePISuTN1byrhnIsvTqYnq8CpyfVWyZlNIte2FgGzk+V6kjepyj3
	1MUTcDj9eg6EsdVDrA1sykzJH9DqGZo=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	harry@kernel.org,
	muchun.song@linux.dev,
	peiyang_he@smail.nju.edu.cn,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	ljs@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm: mglru: fix stale batch updates after memcg reparenting
Date: Thu, 25 Jun 2026 23:15:54 +0800
Message-ID: <20260625151554.55105-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6y43nwxykj1hsn16eyejgfrds4r5h99g
X-Rspamd-Queue-Id: E7C6FA0007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782400678-67344
X-HE-Meta: U2FsdGVkX18CnIFCWJgX6//aw/a/mAYCZwgygEG9BzgOsIq7psNP7ScF7L2D+01022mkOWi7QLBIhmPXroTaMIYC0YlVH9l3+KPvS+q6xQ3PiHBPXD6NgmV6HnVuWL04GxkTxp6am+B8f/GRGDe16NCzrSWBD1LRvu6Pj807C1/Mkr1qKKkyQnmeX5f85yI+DZUHRSpyI/A+zL1lXG2HFEVHyw+tP7NAzVhjhf4dfYBcKfv/4ThVvx1pg0GiaX/YnTiFrzy6WjHcKx7CvLycLcmBM8sljZcTmXp330l0DEm6E6xLqntsXEiVOO16gWCSkjbRB76xpmc4nYq5TyF0YbHPE+ikkfZOASdZJSa+LOn9IkY9y6Xi6lQszGm802lw2ptuoiUP/h4HNpw3uWLwN4ywhdi3Qhl0KtLg45N8mSZ+COwrnXlQn0oH4r2yqHL3pGJo4RyKKbdA+yPKnDWruVobXmM1DH2ABUOP1GfgxTuffEvY5pEHEBUAmCI+cjCrpcEL7BZ0p9GYWBYLNMCHY5+BoNqjmioQxF6Ch3XIYXJIwrp1slt9HnE2huQ7qDVUGdGXQ13gTTBBOEypGdGhOuTTSSU6eVqQLwniuMzJvWFns5sJ6X94Vpv+O5fGklBNLfcHMOKciidtC/RSrNaK+J5dabNj0ogiSurpfj3RFUgyIfJY8PlLU36P47xzdhP0LmRYWVKa6gUVFOZ1rt/kxZQw3egQ8pdtGy/k5gCjXV/0q82a7qg5Jnh7ikvgdirUOtY6X5a8Qt1UCzlFsQX1lPBQ/i9V3kkNDp7NUAR929LT3TmNV8rVfsiiksgpRTzKoy4StFixEeV32dXSUDVbmPRY6pcnal2FLPGTuk0xZbVNXgrndOEW2c0n7Ji7PG63yzqmfHtnKOSN1cM537avEQRB9Si3yw5zsUNbHTaCmkQkLGPkkUbq84g8ZJct6f0mlbEmTf0/CmuNTPQ42QA
 JZivLN12
 iYEmK/3SowGWjdOaxHmEGrXKz1evTKigFoUFoijWk2nGAhmkvYzoUGLdSzP6GnQxet7ejcuOVRet0No2Kv51goyQ+AyZrlyH5YyFf66/9bYFWEC1JilLw8455X8KfM2CBXYxi71Vb7P0/iiCHX8UQGnoHEH1EviiGofB2axv0nxscuHFlE/veTbWGBuo8pdgO1SLkTt2lo5QrrG5Jk0h+1hEbIEWBhyachu3UfX0ZKREj1KMKZqMIrEfbsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The mglru page table walker batches per-generation size deltas in
walk->nr_pages while walking page tables without holding the lruvec lock.
The reset_batch_size() later folds those deltas into walk->lruvec under
the lruvec lock.

The page table walker can run concurrently with the memcg reparenting path
as follows:

CPU0                           CPU1
====                           ====

walk_mm
--> walk_page_range
    --> update_batch_size
        --> walk->nr_pages += delta

                              mem_cgroup_css_offline
                              --> memcg_reparent_objcgs
                                  --> lock lruvec
                                      lru_gen_reparent_memcg
                                      --> reparent child folios to parent
                                      unlock lruvec

    lock lruvec
    reset_batch_size
    --> child lrugen->nr_pages += delta

This will trigger the following warning in lru_gen_exit_memcg():

	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
				   sizeof(lruvec->lrugen.nr_pages)));

And the user-visible impact of underestimated nr_pages in MGLRU was
premature OOMs because MGLRU does not try to reclaim memory when nr_pages
reaches zero, but there are still more pages.

To fix it, make reset_batch_size() check CSS_DYING under RCU before
flushing the pending batch. A non-dying memcg keeps the original lruvec
stable against RCU-delayed offlining; a dying memcg redirects the deltas
to the first non-dying ancestor.

Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
Changes in v3:
 - re-implement lock_batch_lruvec() by checking CSS_DYING under the RCU lock
   (suggested by Harry)
 - update the commit message (suggested by Harry)
 - temporarily drop the previous Reviewed-by tags
   (since the sync method has changed)
 - rebase onto the next-20260624

Changes in v2:
 - update the commit message (pointed by Barry)
 - collect Reviewed-by

 mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..1ec8c23c72b9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3262,10 +3262,44 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
 	walk->nr_pages[new_gen][type][zone] += delta;
 }
 
+#ifdef CONFIG_MEMCG
+static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
+{
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+
+	rcu_read_lock();
+
+	/*
+	 * The memcg can be NULL when the memory controller is disabled.
+	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
+	 */
+	if (!memcg || !css_is_dying(&memcg->css))
+		goto lock;
+
+	do {
+		memcg = parent_mem_cgroup(memcg);
+	} while (memcg && css_is_dying(&memcg->css));
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+
+lock:
+	spin_lock_irq(&lruvec->lru_lock);
+
+	return lruvec;
+}
+#else
+static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
+{
+	lruvec_lock_irq(lruvec);
+
+	return lruvec;
+}
+#endif
+
 static void reset_batch_size(struct lru_gen_mm_walk *walk)
 {
 	int gen, type, zone;
-	struct lruvec *lruvec = walk->lruvec;
+	struct lruvec *lruvec = lock_batch_lruvec(walk->lruvec);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	walk->batched = 0;
@@ -3285,6 +3319,8 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
 			lru += LRU_ACTIVE;
 		__update_lru_size(lruvec, lru, zone, delta);
 	}
+
+	lruvec_unlock_irq(lruvec);
 }
 
 static int should_skip_vma(unsigned long start, unsigned long end, struct mm_walk *args)
@@ -3779,11 +3815,8 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 			mmap_read_unlock(mm);
 		}
 
-		if (walk->batched) {
-			lruvec_lock_irq(lruvec);
+		if (walk->batched)
 			reset_batch_size(walk);
-			lruvec_unlock_irq(lruvec);
-		}
 
 		cond_resched();
 	} while (err == -EAGAIN);
@@ -4867,9 +4900,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
 		walk->lruvec = lruvec;
-		lruvec_lock_irq(lruvec);
 		reset_batch_size(walk);
-		lruvec_unlock_irq(lruvec);
 	}
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
-- 
2.54.0


