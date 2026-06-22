Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC122CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 07:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63906B008A; Mon, 22 Jun 2026 03:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3AC46B008C; Mon, 22 Jun 2026 03:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78296B0092; Mon, 22 Jun 2026 03:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3116B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:38:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 036A61C2375
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:38:17 +0000 (UTC)
X-FDA: 84906745476.24.9503E6A
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf05.hostedemail.com (Postfix) with ESMTP id E069910000C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:38:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NPPB11J7;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782113896;
	b=aF+uB2Yh6s9o76LCEkvH7M1jxVjOdSZtYsqZ1Rloq9+IJzN1xXEpimv3fJPkPMEvvllY6V
	zKWfsbbouiQtCs5Yq22ekyMF97b/8xnnXn2wXw8yIhRhePBzUIonImLBnXwbA7t+GzBCAg
	+ADQk/cnj2y9vGrYlZ+As6gQYvXnS1I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NPPB11J7;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782113896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLM3aM+mLYFmhETREr14Ka0E23AHJDu5ydUymIjAn5Q=;
	b=3BtBAOsWh7fh19AC2gYppxpMN/8RA/EcdhzclLvf9jijzbx04mk0SPgPWWbLTISESUuLD9
	+kxAqwCr3uTkQZMQV5f7wLWpK5Ncq4C4WVeFIXbPi8ddqb5RYcgHLT+6pFp36ZFUqTz82y
	p0y6/Ix5pt2CNANNnEIMwUENNi8RBEs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782113893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lLM3aM+mLYFmhETREr14Ka0E23AHJDu5ydUymIjAn5Q=;
	b=NPPB11J7F9becT54g5higyauOsIey4WMdio0Dx3ZA5tmWbnb/bDBqbJKa6OCwPKJj+AcW6
	mI4rbRC5UR/ZUPMw+lj1f16MCj1/BXuoDxD2yVwF6R2oVzCszGVE5rgmc3LTH6ft/aH/ea
	K/TH5p8ot/fvkpI1FSnkMGgbir5vyoc=
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
Subject: [PATCH] mm: mglru: fix stale batch updates after memcg reparenting
Date: Mon, 22 Jun 2026 15:37:03 +0800
Message-ID: <20260622073703.79258-1-qi.zheng@linux.dev>
In-Reply-To: <5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn>
References: <5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 35uw4tdmdeoxcwsu8zkpmuntwk7nu6ps
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E069910000C
X-HE-Tag: 1782113895-39521
X-HE-Meta: U2FsdGVkX18yCUmo1GKQpEGcgDrmnVkWqeGMxSeveliRvSVDjQqfnY0mTV8onc5NGm8TQHEk2uj0WMUDwfagS+crd8i/efHDq+4Nhrw51KOTdkRK8xsMQf8+ojvLJSxF1qF9JI8O4ZzH8mZ/CZzM+Xu/Z1VnPo9sRgocioAHDzc2FpBZpGFfXlKqtJbvRLQ0bw/Ps7AvRKLHjcxX1iaEA1vCGAOBemrnBbYZD7w5Tsm5B8zxN+veiV34Pl+FiCfDpAD5/HIhNuuXyYy7LG8SdzhEH06JDuMgtw3i1eSAHb99B1edoF36lStwuO0kQq2FDaE6xbgtjRkUhu53Q5vmEt/BdW6plsDmY3HL2zr0XBQS01yFuPtkQyR+zn670JzzToXmbm8q/xX85Y3jjo9A+0Dw0S7gf4T/t8wv+4HtleOt0G5gMPt37xtlaG5PY4LJHwtyOLcYK3WMkNr81IwiKBlh5f4Of6W2RAkwTzCZSK4pMTPldu8g0hgyKHWXLVra6YqKWEFNjkXY1N8ZZyy1lblsTPp843JndT1wtE7NuMWT++6b45GQ4x8jlmhQgKDGyjvYnEknUsrSLSH7rQiPvpGHkY51jb6rVamE2GMLitW2nUQJN58PnyLNSfaoGUry7Rn8o8hGmv8q1OGvD3flt3fdFXW481Kk3CShgEbhp0eIKrn74y6jiXhrHTIy24cPuQDE/Vj8LGsXQ1uTOCjHVG6neY+434oL3+KHD77xq5wdCXjcGF7gvLXm834dEdVjaHVYNt+Q0t1AosRE4VVv0HHDSuSk6XH494IpzdXxWvhGYDe+8TxtlhxlndjHMw8DV7jMruplPsL7WcfTNoZnC/HRfp+R31ojcvx6hwQrhBHLIMLL1qW/XD7w5QMECWyjsUavOyfrrBqJ9n7OIXVlHZoCTiOYawcXBYLU+sb9fbg3gDEyhW9mWOohwmThnKwcCaBuc1uIzU97KfakixM
 19vuNuoS
 9RVYgtnSVTQKcTeSKBIlH7MwF4Giv+aKqNdNwSHLi6XFK/4zIvM3W4IZzosnjyNHSl3/TzjRjZeARPNw6CrqeBGjOuDhlMXsLi0on5h8RKQkOs5re8ZrelREvdUcB+oPQzoP33KrN3qMVHxlck0uwIpwNXFgoJ9WGwHTrM1yr8SjLjDvqm67aa6rU0rHaptwd2nX3/cnusyvLDpH+PydlEpz2kCWXaCsQ38y2BDS/gn4h/ADgfpwoDGhx5g==
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

This can trigger the following warning:

WARNING: mm/vmscan.c:5867 at lru_gen_exit_memcg+0x26f/0x300
RIP: 0010:lru_gen_exit_memcg+0x26f/0x300 mm/vmscan.c:5867
Call Trace:
  <TASK>
  mem_cgroup_free mm/memcontrol.c:3972 [inline]
  mem_cgroup_css_free+0x76/0xb0 mm/memcontrol.c:4241
  css_free_rwork_fn+0x125/0x1260 kernel/cgroup/cgroup.c:5575
  process_one_work+0xa0d/0x1c30 kernel/workqueue.c:3314
  process_scheduled_works kernel/workqueue.c:3397 [inline]
  worker_thread+0x645/0xe80 kernel/workqueue.c:3478
  kthread+0x367/0x480 kernel/kthread.c:436
  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
  </TASK>

To fix it, add lrugen->reparented to remember the new owner of a
reparented lruvec, and make reset_batch_size() charge pending deltas to
that owner.

Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/mmzone.h |  4 ++++
 mm/vmscan.c            | 43 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..0d572db2ef64 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -584,6 +584,10 @@ struct lru_gen_folio {
 	u8 gen;
 	/* the list segment this lru_gen_folio belongs to */
 	u8 seg;
+#ifdef CONFIG_MEMCG
+	/* the lruvec this lruvec has been reparented to */
+	struct lruvec *reparented;
+#endif
 	/* per-node lru_gen_folio list for global reclaim */
 	struct hlist_nulls_node list;
 };
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..64362cbed814 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3262,10 +3262,37 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
 	walk->nr_pages[new_gen][type][zone] += delta;
 }
 
+#ifdef CONFIG_MEMCG
+static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
+{
+	struct lruvec *reparented;
+
+	for (;;) {
+		lruvec_lock_irq(lruvec);
+
+		reparented = lruvec->lrugen.reparented;
+		if (!reparented)
+			break;
+
+		lruvec_unlock_irq(lruvec);
+		lruvec = reparented;
+	}
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
@@ -3285,6 +3312,8 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
 			lru += LRU_ACTIVE;
 		__update_lru_size(lruvec, lru, zone, delta);
 	}
+
+	lruvec_unlock_irq(lruvec);
 }
 
 static int should_skip_vma(unsigned long start, unsigned long end, struct mm_walk *args)
@@ -3779,11 +3808,8 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
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
@@ -4563,6 +4589,8 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 			mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
 		}
 	}
+
+	child_lruvec->lrugen.reparented = parent_lruvec;
 }
 
 #endif /* CONFIG_MEMCG */
@@ -4867,9 +4895,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
 		walk->lruvec = lruvec;
-		lruvec_lock_irq(lruvec);
 		reset_batch_size(walk);
-		lruvec_unlock_irq(lruvec);
 	}
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
@@ -5784,6 +5810,9 @@ void lru_gen_init_lruvec(struct lruvec *lruvec)
 
 	lrugen->max_seq = MIN_NR_GENS + 1;
 	lrugen->enabled = lru_gen_enabled();
+#ifdef CONFIG_MEMCG
+	lrugen->reparented = NULL;
+#endif
 
 	for (i = 0; i <= MIN_NR_GENS + 1; i++)
 		lrugen->timestamps[i] = jiffies;
-- 
2.54.0


