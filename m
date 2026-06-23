Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA52CDB46B
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 02:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0965B6B0088; Mon, 22 Jun 2026 22:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046A16B008A; Mon, 22 Jun 2026 22:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E785A6B008C; Mon, 22 Jun 2026 22:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFBC46B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:44:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83DF71A03A2
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:44:34 +0000 (UTC)
X-FDA: 84909634068.09.901A8D5
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id B467220002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:44:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PJaN6uT9;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782182673;
	b=a+xu6z7GoBaizEKdPr8qoOb2r+edmK9oGO/hISb0bpbIdnuU7L3cLwT1unYnkGJdocu0HH
	/E5DK/w/RwGabIzNt0jnIs8J9/X3mCfPCjZyUmiPdmWmmxCSmtA3fPN+I1A95MXwG93SiH
	Io79U8GAox8HM8bXvQv1Ccs0BPVXLWw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782182673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a8+eeytXWCIVLCbNBOynGcBvbUA5M39lvYGkiNnFZO8=;
	b=1BVRtph7zkcvuHFs7u3AFPimysyrXiuphRBEE6dx2+x1dszClg9st2yg/YX8gRfc8EaTEq
	cCSB92oXOZ/JSFp0LCSL9yOFWPTfWGyhHnMGp/5qxCkZarw3qnrM63iN/uDbID/RQpMUSW
	h0AbSE3ziSoqd9CfiPs4UOJV13Nop/Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PJaN6uT9;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782182670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a8+eeytXWCIVLCbNBOynGcBvbUA5M39lvYGkiNnFZO8=;
	b=PJaN6uT9J5NDYZoml3Hbdmj+s929N+ngw8MxLLg7VrG/3KFVLHJ00nBb8oVd4Pevs3i3WX
	DmnWEBkUt16AaqT/66s8Nw9kMBzMCS9/jybeucwFcjVSWTmkVRDi5Q92oib9s2Ma5zrafi
	dFJfp1wUHfx4vfdPehzulUYLwsoDnyQ=
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
Subject: [PATCH v2] mm: mglru: fix stale batch updates after memcg reparenting
Date: Tue, 23 Jun 2026 10:42:37 +0800
Message-ID: <20260623024237.45990-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rskc18wi9yf6ihkqifyrcwtoypfy5mh4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B467220002
X-HE-Tag: 1782182672-285884
X-HE-Meta: U2FsdGVkX1+RCBRdQ0WGBuNz/5O4tPgsIayu225cmh1SBQrBkSl59qRLxghPRo1tE5lg1us3ep+cZpIXs/JwclyoTBfxlVi+ire0viW8+my0ZqxHTGQVLjo3M19eEwX9un1zd2xaFTD9mIzBkMg1ErxvP8ill2pWRnyKIj0SNwZ5nVMl+ZB4vqGts2RIazGZqUbjNz159ZnBfJpdLAIPz6GwbKJhiT59sLIOhhcf7Su16v0pCZVBmOdCUl+LZyKiPNhAtZTpLkab6idfDzU8OAVPQKhtREv8KimeZSPbkF3yj4M7RTqwUAO4MCZx9MhAmsHy8ZHeKOSbhnDGDtGwcyuKFEG1v21tvdqgVjj4Rwf+w7Ing42XJBGhOdhPU1xGlT2qoHdOfxI88rkHqFJuQPnloSnOKlMGbpPBu5C2apk0fWxCfB2NEIkQCbe2DmGFshYKIfU+IbpSO3kjuo3nYQWhCLxCFLDCJmt4KwSKpAB3qVt8etSupwKvsOOwKf2dctROzFceOcJAwOBwTQj+5BovSavLAG6T4nZD47cWXazihGSRA2FJZMrPjXFIuApthNfDT7nCmTgHVJvLFpj2ATe/6Deac+4VWXAllTG70asZ7StVii28nxolDHODgk96IgQ3ghZWZHW2aj+S7EwzLzrRCGS1lagKFyTsinnGfQ6Q7rj3FUwf4ibmlyC8D+z8QIgGgFEZ1s6FKT+04Kc7jpKhs2j6+RtD4ZdKiduejpnTY7/HHgsKlP5TSoYd9OcMlF3r00vXN1WE5ADitK/6e2aKugRBTlJcFridu8fU193Z9LbbT0387+gCXcuE4RdjKqsm+FjLNP2pYInO/F12k25RGmNxLPfwhQ0m7VRfEWUtwgSpZzsizt5VYr3Z+Bo+HGMipj1EXhZRKT/TTLdhUopDLrwKIJ83CQsj8Ok15jeFkxxS5yBUhI9WQGqNu3z67AhtuxA2Tlf4txG5Gl9
 sUlxy2lV
 H9KbIDFLnl9/PaN+VmucJXoHDTQ3qiC0M3z5A8PyROpSpTK7ShFjoRE3wLUQs0uAwbBItDfwaikyqVKHhuua0dFQ9xZQi2EvgySLuB97se5QYULXspAi74wtHp1abT4q+bNCWvgmHQWlChagj7kMqhtUwf7A3MN6TNEXMX0RY/uFoCKkr7Z14QHXPupcWvtTYygFXIGPxzYBaf08/pR18Nw1vuXdzK1R9Q6DCOfxaXF605s/LY2dba+/BUg==
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

To fix it, add lrugen->reparented to remember the new owner of a
reparented lruvec, and make reset_batch_size() charge pending deltas to
that owner.

Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Barry Song <baohua@kernel.org>
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


