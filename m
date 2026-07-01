Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBFEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92F496B00AE; Wed,  1 Jul 2026 03:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0556B00AF; Wed,  1 Jul 2026 03:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1576B00B0; Wed,  1 Jul 2026 03:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 501F96B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:54:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA39C1A0295
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:54:06 +0000 (UTC)
X-FDA: 84939444492.20.13000D6
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id 801B38000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:54:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gtC108Cj;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782892445;
	b=hlTzD2Rtwn41+9gBziYykHUrEU1HjAB3UeCqU1SDfreqXh+MHripzOtb60yyZkfUGGWluk
	RTPfNHR9tIJV+7xiq3EPraiHUQv1lzXY9HU5dZvaM+Xmz7AqQ1wrrwc6G07HYGbSqoUdYn
	p7IK6/8l3TadmpWYeJ09Nh7Ww8EGx3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782892445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3h7CGvVoalB/WWwlHPJ/8L12bWTkcsodPzdppqEOSlE=;
	b=iToHM+h1FwOSH9GzkKGI5aVuau2vUhTZixqPBTuQA3agCnULnyadS18UADUJVC7b1bymBj
	wTqq7MVRAWMw6kUdm3krEWJ4ZNDO0uUQpQZMvxvPcjK/lvBGp8KpFOuVzKvcgt70NTPaNr
	ONMhuhXQVGUO47gFxMkvTd6wloztHe0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gtC108Cj;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782892442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3h7CGvVoalB/WWwlHPJ/8L12bWTkcsodPzdppqEOSlE=;
	b=gtC108CjJNVRGfhHG3RKkQAts4kg9aEW1C4fta5PvdlcJFWdsxKhyc5MDoAVC+TJsvhYq9
	el42sk6fHOI4mNYDlHkVyL1NPiZXzMgltpKb+XA0Fnr/UfLwbQebwz4eHsSXR9JBV1fNf1
	kBHcR2u4vhCRr6IG8Tqm59CGsZDDkQA=
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
Subject: [PATCH v4] mm: mglru: fix stale batch updates after memcg reparenting
Date: Wed,  1 Jul 2026 15:52:51 +0800
Message-ID: <20260701075251.56413-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ytzwr4kmk5n7x4pwyrme1zw1iku78ezk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 801B38000A
X-HE-Tag: 1782892444-357803
X-HE-Meta: U2FsdGVkX1/sOck6by0w3Yc/4I9Rd5yKk4s/Fax/dt5qG0jGWR8bRAauwSGTLjBezP/3lD95dqVDog7pXoQve8BDru4sIPLBsoeqOB1xOwRrWRcLuiik9HRS0zWPPVASYlNyqyWMN+d+Cqigj15NP9e2FqcZ6veKN1Rqr+lC51tAaW2A6j95t7T8ZAU0KxTRiXdAU9Zu0ezrULtX+S25kkPZr6Vy5etmSgqbAldfxuI/ctj8CuIS1xaF3TJpoqcG49yIxdWna07pJQorPAGR+1z96Tugx69Ap25j0uaNvc/KGacxC/mSbde90t9pdWlmVTkIhCpra64RzcJbbNIfdXO5I2ruVG2RqSaV3JdcZ52LZwusO1qrBYRmgAHchsW+T/hu4P9OWc5fjEe/bs/Lub33MNwZp3u24jAQqSN/k/pFLKRFDWid4mnRSFZRhZiIgdALA7cWRx9y+Gacey+Tcud4D11q073lX92qzEmVlUhHd5juFnbKRDz5Z3Gjc7Ak4Xozrvlb224dT1tFw+IwCNMMJm6+JqklDbmlZWy9pvA+vcdFM9TohZBe1dVa06VSsW2fguUcoN/5BUC1h6MWVeriFYLCyueirC21HhcjTawrHPGIpGSbBbzhrTZKLsNRyzrGntdO7sJ8TmgDURUWd2KzO9/jxQQYKQs4bxxQzUNBe0I3xezp6q38qqz4lmWwRM3aocTYLe3R81pm6Sr337YfvBoL9YqdYv2UxDTJ5FIcwzXld7xIn5bDAUNFRVU7J5xB20sdnrfjZDrzyoPf5nR1krypr/lp0yU2FI2BPsDTuqdSVZ/mht3xdxCpjTkvusnzdeWb2GxLYVz9ltcsV+CKjHrY99TOb7A1JB8uPvmqzq7Oppg35f5crzBjOEdgZWTSpn7MpMhhqvEK17SsgX4l1STS8N1RfifDw65XMGULpN/TWCyFUNyzgWqEuZ3LZh5NS2U3nkluoVmLsgS
 H3/vr9oI
 sjGWhbIplCvFEIN1fPwNXlmEHlhQpkGX+0tcyDh/dN6gelsku4mlWKzQPLXR/J1YqJYIZ5AqHAyIqta0EphjCbDdZb+wqxreaXLZEWaY+PFcJlFNLNNS06T3ureUGHD3VJnL9w7Wn7TcWmr0QJqPRvTPfA2aS/V4FcTsquSuiyajsbBonDvNqy8kqXYKWZHwN++E8JEIMXVckT/h6aNTP7mqJ2JVwKj983jtbZ/6aG8Vbhy626SSDt2mXbw==
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

 mm/vmscan.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..ca1e2a870d51 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3262,10 +3262,40 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
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
+	while (unlikely(memcg && css_is_dying(&memcg->css))) {
+		memcg = parent_mem_cgroup(memcg);
+		lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	}
+
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
@@ -3285,6 +3315,8 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
 			lru += LRU_ACTIVE;
 		__update_lru_size(lruvec, lru, zone, delta);
 	}
+
+	lruvec_unlock_irq(lruvec);
 }
 
 static int should_skip_vma(unsigned long start, unsigned long end, struct mm_walk *args)
@@ -3779,11 +3811,8 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
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
@@ -4867,9 +4896,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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


