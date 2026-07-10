Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F8D4C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 15:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AEC86B0098; Fri, 10 Jul 2026 11:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F9F6B0099; Fri, 10 Jul 2026 11:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475B96B009B; Fri, 10 Jul 2026 11:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 133546B0098
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:43:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C0EA1C3945
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:43:55 +0000 (UTC)
X-FDA: 84973287630.01.EE4065E
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id A0ABC20016
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:43:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cDeQqpyd;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783698234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/60L6Gw7LaN6NkHAg/NT5Zrh/O6NlqQ8F4DkibQxuFk=;
	b=KuFZkHFOshGkkHwts8LaeVno1I7qVzYBRmLNoirP9p7Gj1njNcVGJrXRMiZ3uPu2R8eOlK
	rkdIe3HuwAiDX5LdJqkqn6sEIGMSyTrySCRLL0Ir36rqnpNYF5etbw8ZbgdwTu/a9KEkIa
	JwkYsuk2+L0zxMEofnhPS0GgAdF8ATg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cDeQqpyd;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783698234;
	b=nkS+JhcUtB8iTofWglac1SX85Si1UErYtkps6m9jvS+FNp60QNR46bxpRvb9OSwkZzv+7c
	CnqTvzWT9/Ajb5F5byt64Lo4e+cLYLrGeM2hiKsbH22uVG4Sr0iQMZ+2GXWQXS2WjrVk+z
	ux6U8Qx6Adgivt+KB8P9W69dgwMfApo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783698231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/60L6Gw7LaN6NkHAg/NT5Zrh/O6NlqQ8F4DkibQxuFk=;
	b=cDeQqpydjIuRjVm7QrrG8tYD4fmABjnIWojxi26sfQ6ogWR+27YgI1RC1Djgt55UpXsodx
	R/poROmIofG4314ypP+lOm1nQ5seu5a3JlyBg225TeR2wh8zDKM7xPdbH1GoAvTYtHJLLs
	CdIxtvMDSyNySfxhJt0G6kp8xJkWv0c=
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
Subject: [PATCH v5] mm: mglru: fix stale batch updates after memcg reparenting
Date: Fri, 10 Jul 2026 23:43:18 +0800
Message-ID: <20260710154318.75388-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A0ABC20016
X-Stat-Signature: 8rjn4mghhcfhrybfkqcex6xrabnj3rk6
X-HE-Tag: 1783698233-722150
X-HE-Meta: U2FsdGVkX1/4ord5fqhMJ1rx9BHKTpaO6fOzBFLyXO51WF2PkVcD6KhRIKl8Xge6O44TtIFfId+UVCUGi7iqlSEPlW22w6yUjTG2tPFssv4N8tZKqjrDD6WQPxy9JyIzDN6w68iiPHVKLOupc/xnMBxMwo3sF8ZH9j5i/tudFbIRMSyp+o+2wns4ge0I9eHYRyFoRoTIlxjzhPxoWI+cGuv0O0hUocSQDiuOJdD0/G3mrhDGCfg172DVHfpQDyvVFuQTbTQOTKSVDcBw5ynIpBFlhphgS+94HvpYaDVuzaRLk8xg6Q54zhZG+T3Hp8hpw/gEx8kUkEl4AyK6idoof0uO1Xi3HHNbaDVuCrggXi8uLsy7iIeB8+mmlMl4ajp6qJZsfkAZk3iZnf31VR9+07iSEZ1L05BRQYilgxxLzoQauOnR/yL9xNihp2huIHkxL1JmC6D3ue+cZk4t/7I0Tm4iVf81dLQkGUP1Nb1V3R+QnddsVFQHsqr4YBtyx2XoLAuL6ZTEUqIpNuuNlKfPMBEXjdXuaJ81MW1qIOzGprGGdTNSNDUjocpH2wuxfV7CQmFTfDwzgBSxCltM8bPT+HQhHPYb4dRYmW+AGhceDDQUS0eFNIfQ7B9HM63vjHmt9Mpl83eAQ0Cxb61o/1n6pDIndLr9UIo8dDsNnqZOFACrnpkwaDXKz+QOS2vMKmV/X7j84DMQLsKaxIxWJvAN+wyFwdOD1P2/yHghbwUOpLB7ALGIb/tgtlJj94qqdHJ+0OYsFhS9suaP97gd0mBfW6MaSg64s/cT/2qgvOy3hk/6Zs9D/zZicicJKFBq1rOWfJoExWGjvulbqx9gC0wQlvFrMlNUtRk6p5nfOiB3LsuA0XLa5H8qSSCtyJQUrQ+nfn5xgDQjv0gOxKbS/vTdWdRWj+8Ysou3JSRRkHh5aPsmKSqY3my0lDISh2XoXy3o6EOnhb7um2unTZtcFbt
 ZBVv0cvY
 tS6z/ithuMd2ATqhyXpOiB/alq1+LzN+yRLuLlN8fI5DckGTlk96lnqSXlUKi1P4Q1Iipj+eUDGcgbGdligsFdD7L6B+aMjPNXMe4ncfS17hGj7+w/lF6DeJvBEoBOVuyJcYWU/kP4OKqolR5uTJIzwzygxtTjYBJgVcp1DzQ7pUr5pl6wVeYIVnX+qC1M9kksWBbfJNMuz5cWUxy21ACIwPgciEFyZHfDXaBbRyEq+J22/j0Y6m3eHfATw==
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
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
---
Changes in v5:
 - rename lock_batch_lruvec() to lruvec_live_lock_irq(), and move it to
   include/linux/memcontrol.h
   (suggested by Johannes and Shakeel)

Changes in v4:
 - re-implement lock_batch_lruvec() in a simpler way
   (suggested by Johannes and Harry)
 - collect Reviewed-by
 - rebase onto the next-20260630

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

 include/linux/memcontrol.h | 25 +++++++++++++++++++++++++
 mm/vmscan.c                | 11 ++++-------
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fcf..9572606776781 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1472,6 +1472,31 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
 	spin_lock_irq(&lruvec->lru_lock);
 }
 
+static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
+{
+#ifdef CONFIG_MEMCG
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+
+	rcu_read_lock();
+
+	/*
+	 * The memcg can be NULL when the memory controller is disabled.
+	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
+	 */
+	while (unlikely(memcg && css_is_dying(&memcg->css))) {
+		memcg = parent_mem_cgroup(memcg);
+		lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	}
+
+	spin_lock_irq(&lruvec->lru_lock);
+#else
+	lruvec_lock_irq(lruvec);
+#endif
+
+	return lruvec;
+}
+
 static inline void lruvec_unlock(struct lruvec *lruvec)
 {
 	spin_unlock(&lruvec->lru_lock);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96a..1a142c58700d0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3265,7 +3265,7 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
 static void reset_batch_size(struct lru_gen_mm_walk *walk)
 {
 	int gen, type, zone;
-	struct lruvec *lruvec = walk->lruvec;
+	struct lruvec *lruvec = lruvec_live_lock_irq(walk->lruvec);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	walk->batched = 0;
@@ -3285,6 +3285,8 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
 			lru += LRU_ACTIVE;
 		__update_lru_size(lruvec, lru, zone, delta);
 	}
+
+	lruvec_unlock_irq(lruvec);
 }
 
 static int should_skip_vma(unsigned long start, unsigned long end, struct mm_walk *args)
@@ -3779,11 +3781,8 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
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
@@ -4867,9 +4866,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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


