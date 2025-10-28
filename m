Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C76CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE1680150; Tue, 28 Oct 2025 10:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56DF78013F; Tue, 28 Oct 2025 10:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40EDA80150; Tue, 28 Oct 2025 10:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAF48013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:02:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1796494E1
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:36 +0000 (UTC)
X-FDA: 84047688312.30.02845E7
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1720BA0011
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H0fYw4BX;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntWKOV2hOWEVTZd0bqYk35Hl6SiE01TplnI2Iu5V7Ko=;
	b=ltP/ERw5eZtWp/iBBjCIw9kQhUHZZbtkV75JI+es0MpURbAOFOFZ1HJyvDFbXeFws758hL
	A6zK23Ogyi5dLFP6SgkhYE80XM4OtP6etRGCc1SyyOf8OrqeBooShJHY2m15B2tJMs2bl3
	CgjuSMzhT6rTJDeEC9Ml67xaqJ21/b8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H0fYw4BX;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660155; a=rsa-sha256;
	cv=none;
	b=lqQt0gL/3CX6NuWEIw1cBMzcOCr76tlmSogdxk0VjZjBasutsCuI6oyNOaMyDfEcGM7Ad9
	WMZNhXQlO5dQ5iZpzN8fqZLSnH0x5cY+f1VQwWVwBua4EA463INIu782v4Rj0lf7IwxxV9
	cZgvCj1RzzOsb4ZxRR53AhM0UiuTqUE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ntWKOV2hOWEVTZd0bqYk35Hl6SiE01TplnI2Iu5V7Ko=;
	b=H0fYw4BXk1abzFkAD8aOuO/0MEMAlxU4Zi57/TcvC5lcwzDJ73q7T9goIpkkuqerxDtSXj
	L4qeo01kT+DpjjamzfU89mOClsDIxQp73RCYYVP0wkee21XV1YT7hvzVEiB/cszAa6v4pG
	Bid7SYhHQLk5xyqHLJtLqLWzCcPnEK4=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
Date: Tue, 28 Oct 2025 21:58:17 +0800
Message-ID: <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 981yfpao57fjt5of8a8zzxspxap8f9ra
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1720BA0011
X-HE-Tag: 1761660154-115662
X-HE-Meta: U2FsdGVkX18A32eopxjdJqLIQoQeUMSASr8Jti4jErUbgHtKJLOc8uKBfNRJaE0geqn53WXBEE9CEUIBbyBUZsCk94okqhCdcMjxGSW3UvPxqpymnTaONp+kXqdoI/Jj22tjTH8hjVIfxo+WNUj/Tg+JfOVympV3SGCnQJrgBgBTzJC43flbwpIzkd61tk+ATJLnLapizmgLTn8rixfIdOv1+GmrRGCZ32DRsfL5y7HrF5HnlR8eK8ZYAkqFvgQmcNpQ6ODuWX6jNwoIFT9l1mJct2nKEm41WN8jF1pp5EtMnNFa/Q8Pr7gUdOEwn3RFTCc/DhpBAboK0LaFqdeuJfImLD0COGci2Gs2O/MalILY6Sr2gVlQKVYtZtPfvaF+Jqs8KTBHUUlNRDJn1WR24ICUDc3f/k9MwRYeQscUsYRS52PPoCQmfS9DKQmg7oQT2yzjTf5xcZYH7v+xY1a5o5kRPl8wwrkfLLM2jk8x+05nqbYSUk1ViqjNlOBFKQ7sqOvFioTX72nT70a3fpnFsadjwyGVHhbGDgnKjg8pgZlzrloYIjlI3yu0BjS0Gr5QdUNrVZ82BfEvmTEAMIRBsXG4J7rk5JihCtkCDPEB/2360ziZxNq76Qz2AXCcbW0HWLGitz4liJflDRwUuk1o/qQP+OB4Fysi5WG7BsqD/zXY7AZUaYsSibh4X2Q6yW8SxJo7keE2lAed5BcWBQY/ADmu7CWWDDwXZkz99v1gNtP9nNfUE4JPw5/OzI++Z5BBBSoD1Z9tsR0Q2bCsZYo5y5GWAIF+o4f+f54r2MG9ycCMZOo07Oa3vTiAoY3qZtmJ2WCYz+pMm/u02nrJiWVVhPDrXO1eQVskOfuHmIKuYtdZEXXcn9ZlBwnDrO8w8E6X1ZcPnaVUrZWDyUR17YF+S67IzYvU+yoC
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
---
 mm/vmscan.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3a1044ce30f1e..660cd40cfddd4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1883,24 +1883,27 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
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
 
@@ -1922,19 +1925,15 @@ static unsigned int move_folios_to_lru(struct lruvec *lruvec,
 
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
@@ -1943,11 +1942,12 @@ static unsigned int move_folios_to_lru(struct lruvec *lruvec,
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
@@ -2016,9 +2016,9 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	spin_lock_irq(&lruvec->lru_lock);
-	move_folios_to_lru(lruvec, &folio_list);
+	move_folios_to_lru(&folio_list);
 
+	spin_lock_irq(&lruvec->lru_lock);
 	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
@@ -2166,11 +2166,10 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	spin_lock_irq(&lruvec->lru_lock);
-
-	nr_activate = move_folios_to_lru(lruvec, &l_active);
-	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
+	nr_activate = move_folios_to_lru(&l_active);
+	nr_deactivate = move_folios_to_lru(&l_inactive);
 
+	spin_lock_irq(&lruvec->lru_lock);
 	__count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 
@@ -4735,14 +4734,15 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
 	}
 
-	spin_lock_irq(&lruvec->lru_lock);
-
-	move_folios_to_lru(lruvec, &list);
+	move_folios_to_lru(&list);
 
+	local_irq_disable();
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
 		walk->lruvec = lruvec;
+		spin_lock(&lruvec->lru_lock);
 		reset_batch_size(walk);
+		spin_unlock(&lruvec->lru_lock);
 	}
 
 	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
@@ -4754,7 +4754,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	count_memcg_events(memcg, item, reclaimed);
 	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	local_irq_enable();
 
 	list_splice_init(&clean, &list);
 
-- 
2.20.1


