Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D32E91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 08:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85076B0099; Thu,  5 Feb 2026 03:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F586B009B; Thu,  5 Feb 2026 03:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95CEB6B009D; Thu,  5 Feb 2026 03:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84F726B0099
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:57:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AFEE1AF5DF
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:57:08 +0000 (UTC)
X-FDA: 84409798536.20.F414CEC
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf12.hostedemail.com (Postfix) with ESMTP id 89CA440008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:57:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=btx3r6Zb;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770281826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kYWdecweNVdy62l88gzC/d5kL1h2rjrD7L5cIrVZsM=;
	b=ItQxifmAwvA25i10NQ4w49scyMwdNQJY2ZMftrHkGXpMI+pYMfNOxeQaWr+Cb/LbX6laco
	fLwtkrY7Z55hSPkdjUERO6wufhEeOOf167sjjnGb2q+8VCAvOQyS2ipBxwIoEsqNXs1ioY
	xk+LaazuxmbEje24kYKyQceXwlWD/Qk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=btx3r6Zb;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770281826; a=rsa-sha256;
	cv=none;
	b=y42HdSVPPfNXqT/MCCeeloKnj42IBbeDa/t0kLDXqQQHM5li8QZ0CzOgHpAg1H+sazc69L
	p6SfPYsi6a2E+kV3IhyLy3Tf2bTD30HrmPPW/xn0RQUGqPytewSfrHh588X4vhsf7vI2eU
	RWcXD/WCD0aewigAHLJ0D+ccy9X0ULM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770281824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7kYWdecweNVdy62l88gzC/d5kL1h2rjrD7L5cIrVZsM=;
	b=btx3r6Zbg1g9TyoYVnhmPKbyNgi99vzU2udEzEfPF9dvk3oU8I2761ldR19Fn3O4IEw7iM
	PZes3KsuFVBpDua3lLAUW2iz43zCmQM0Iq992oMPVwRNiMDeDC6emoXMtfPn3msCtA/VZV
	tyJtHK7jfkf7qXxAz76FU6PmdYBAIXw=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 05/31] mm: vmscan: refactor move_folios_to_lru()
Date: Thu,  5 Feb 2026 16:54:34 +0800
Message-ID: <0f2eaf61f08b708a1b3725dc5b68b6dde13121b7.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: yn1f7oew4ien7pigi7ffdanksqe8hkhn
X-Rspamd-Queue-Id: 89CA440008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770281826-784861
X-HE-Meta: U2FsdGVkX1+55N3zpVQkE7v2nJFTwQYY+SULDknWpGTPKdMBBuGa8k4SiIBfHHehdc4rIJs5TIn188Bzz6dQvd87SM5YWqnw+7IvxYpuLWoVR68AfSejXw8sL+dK6WVel3IAM2VKoigJOQoSTkX+lxh01GDJXxjqASLptGiSnnlpxVCdBm41zdCMjliQN3ikiFHc7ogCCvNoBaauPQZ4BNiJFuso7pPLT5G9Km1KR2AZiVSCXXOJp7SfoF7N73Zi2x2QI5j6LT+LedJ/nwYPFMfj6G7W2FAi4UkGgyoGIOLOwxJ8MhI0cxIIi37o2Ax8KpXzw5lOrdEgEyWwHcLTeWHImj7Audi0RvA6Lrys3tGfIofe5pMmYxzXWV+AqS+xPbPao37LgqBwafID4u+1FCk/mJXAe3h4IVdKH6eCfMqZGZ6IoPBKe5AQbLdmV1Amzebgw3xBsGcBccgb/4dAKN9Y+ZtA9SPrx30R2bVsBFkWm3dPjZG4pHxkFARbykl4vz1BXLMDJP9VsXlbDu6Hm/oLQQzYmo0f0vg5d0PPPkCImP2C2/HN1JVp7LQJY1daaF/nlqV4iJEXFjg+yl4TkBkSkMG3PxV5ntNjfersZXlBPF1PrE4zbuL6Fg04g6btZJ6bGTVeS7pScLprqInkDmp/0Txx1MVUvPuNlCts8uBiGvEZVHyFFgTHl1aRE2sPiA3iLf4b3n9RdqQZQbqfQW3PE2yALzOwlhAaQq8fCuDbW0VsNyQGOmewFMTrJpwPfuI3khYk9Aow8J+plAn132vjoDpP3hM11yilvKM5qvP82jD/I4opY5t8eHRvZxYPXWU5J7ZrqexoRCYzayHQ2tdGFWINbECqkFK7HUVj+7tKtvwNtwKbmMqCoCswvEj/gAaKafo9kDr9YPJtRdq0WA/oicbiybp1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In a subsequent patch, we'll reparent the LRU folios. The folios that are
moved to the appropriate LRU list can undergo reparenting during the
move_folios_to_lru() process. Hence, it's incorrect for the caller to hold
a lruvec lock. Instead, we should utilize the more general interface of
folio_lruvec_relock_irq() to obtain the correct lruvec lock.

This patch involves only code refactoring and doesn't introduce any
functional changes.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/vmscan.c | 46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f595e063faeec..8039df1c9fca5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1890,24 +1890,27 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
 /*
  * move_folios_to_lru() moves folios from private @list to appropriate LRU list.
  *
- * Returns the number of pages moved to the given lruvec.
+ * Returns the number of pages moved to the appropriate lruvec.
+ *
+ * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_folios_to_lru(struct lruvec *lruvec,
-		struct list_head *list)
+static unsigned int move_folios_to_lru(struct list_head *list)
 {
 	int nr_pages, nr_moved = 0;
+	struct lruvec *lruvec = NULL;
 	struct folio_batch free_folios;
 
 	folio_batch_init(&free_folios);
 	while (!list_empty(list)) {
 		struct folio *folio = lru_to_folio(list);
 
+		lruvec = folio_lruvec_relock_irq(folio, lruvec);
 		VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 		list_del(&folio->lru);
 		if (unlikely(!folio_evictable(folio))) {
-			spin_unlock_irq(&lruvec->lru_lock);
+			lruvec_unlock_irq(lruvec);
 			folio_putback_lru(folio);
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec = NULL;
 			continue;
 		}
 
@@ -1929,19 +1932,15 @@ static unsigned int move_folios_to_lru(struct lruvec *lruvec,
 
 			folio_unqueue_deferred_split(folio);
 			if (folio_batch_add(&free_folios, folio) == 0) {
-				spin_unlock_irq(&lruvec->lru_lock);
+				lruvec_unlock_irq(lruvec);
 				mem_cgroup_uncharge_folios(&free_folios);
 				free_unref_folios(&free_folios);
-				spin_lock_irq(&lruvec->lru_lock);
+				lruvec = NULL;
 			}
 
 			continue;
 		}
 
-		/*
-		 * All pages were isolated from the same lruvec (and isolation
-		 * inhibits memcg migration).
-		 */
 		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
@@ -1950,11 +1949,12 @@ static unsigned int move_folios_to_lru(struct lruvec *lruvec,
 			workingset_age_nonresident(lruvec, nr_pages);
 	}
 
+	if (lruvec)
+		lruvec_unlock_irq(lruvec);
+
 	if (free_folios.nr) {
-		spin_unlock_irq(&lruvec->lru_lock);
 		mem_cgroup_uncharge_folios(&free_folios);
 		free_unref_folios(&free_folios);
-		spin_lock_irq(&lruvec->lru_lock);
 	}
 
 	return nr_moved;
@@ -2023,8 +2023,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	spin_lock_irq(&lruvec->lru_lock);
-	move_folios_to_lru(lruvec, &folio_list);
+	move_folios_to_lru(&folio_list);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2035,6 +2034,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 
+	spin_lock_irq(&lruvec->lru_lock);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
 
@@ -2173,16 +2173,14 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	spin_lock_irq(&lruvec->lru_lock);
-
-	nr_activate = move_folios_to_lru(lruvec, &l_active);
-	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
+	nr_activate = move_folios_to_lru(&l_active);
+	nr_deactivate = move_folios_to_lru(&l_inactive);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
-
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
+	spin_lock_irq(&lruvec->lru_lock);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
@@ -4742,14 +4740,14 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
 	}
 
-	spin_lock_irq(&lruvec->lru_lock);
-
-	move_folios_to_lru(lruvec, &list);
+	move_folios_to_lru(&list);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
 		walk->lruvec = lruvec;
+		spin_lock_irq(&lruvec->lru_lock);
 		reset_batch_size(walk);
+		spin_unlock_irq(&lruvec->lru_lock);
 	}
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
@@ -4761,8 +4759,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	count_memcg_events(memcg, item, reclaimed);
 	count_vm_events(PGSTEAL_ANON + type, reclaimed);
 
-	spin_unlock_irq(&lruvec->lru_lock);
-
 	list_splice_init(&clean, &list);
 
 	if (!list_empty(&list)) {
-- 
2.20.1


