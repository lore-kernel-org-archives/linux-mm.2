Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F7C4D29FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9486B0096; Wed, 14 Jan 2026 06:28:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873C66B0098; Wed, 14 Jan 2026 06:28:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4226B0099; Wed, 14 Jan 2026 06:28:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 669186B0096
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:28:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33DF0160485
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:28:18 +0000 (UTC)
X-FDA: 84330345876.01.2C90699
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F2B414000E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:28:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iWyRwRTf;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fqf2u5ZK9TbNxRs3O+Rqeoi9UhdgEPpKbaiGOFyWK9U=;
	b=JVwNAg9DCNGWduY5p3MddGsn30wU3e3i2qOTONCVNzzwLQcN1SF58UaA8uvKpn6U2b/hXS
	cSpS9KLAvwb6SNv97M8KChNqszG3gq2hfO4AygaHLHcGfcPy/2LUS5hZ1NOhNMVot34suj
	7buHYfCHoeZoumc5Cw+J996JLZttcig=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iWyRwRTf;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390096; a=rsa-sha256;
	cv=none;
	b=ItfK6/Fld7/6rSEt/LqlwUaJEYEVuPxGxT47Upsx4nTwjDuGkOBpSTZZ40x8/w4tNgmst9
	XiarogGuoSK5qKCHTeoR9H2DZnIGb1EY3L53eH0pStq37B1XDV03d3AnnDqPGEElvuMjqX
	R652EFn71Oj44a6X3X04qPIU1T5FvGg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fqf2u5ZK9TbNxRs3O+Rqeoi9UhdgEPpKbaiGOFyWK9U=;
	b=iWyRwRTf/CCNDbnqYGLKgmrp4CVEaO7Yh2WwcsmYJyyXAPu0vPljA4IzXR8PLJwO08gJlO
	2FTk9r8DM2W6Q3gVlq67/2BZnr3ucmT1duasU1KhRd5v+q9xWUrVllB58P9c/COXrJrVQO
	thwloIHSlmop53RtoHp9OI7DxHbHt4M=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 05/30] mm: vmscan: refactor move_folios_to_lru()
Date: Wed, 14 Jan 2026 19:26:48 +0800
Message-ID: <52b3d175b0860bbf728feaf16d832e022afd171b.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: f56tbaax19rstxzigineymxik4r1wodp
X-Rspamd-Queue-Id: 7F2B414000E
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768390096-291346
X-HE-Meta: U2FsdGVkX1/OpdI+IHU2rFde5XWVfmYEXjhVvtLzsFAjOCvUCKG/06YwZ9oc7r2pzei5cf3IE/tftymmlM3Ewd8SV5cQU1Y3/b+rDqla3CiM2kKg8heEe0scmqYjW2Qingc/Z0k/jGknUt+PDwiYnt8go4q4N9XsnXFjEbUjWCq1WaaXHUMpquYFMczNG94X8/6IvKEbiqDvpzAky7jgbXWOab048wBfzj3r+Y3bMa72s9hJM9a9GiTi5ZFObKg6gVX2uF2CquirzbbJaZN4Zb1vkk0RFcrFXVu9/H3ED0sVrXYVR1H78KWjcku7WuHksfXAtjNDHjeHdGtfJcV+gB9raJGSgbPhyFIS/hWnhTLhjKMoM9mM0pZmzY8N1DehA/fV8ZvRO3LHA0GvhheW8selz/ROM0D4dGtwN4S3zatS5BuGpHBEBUE+acxlUooKK+t4nf2C8fcM7tcjU11iTf17XU6i7TNLXq1cZfFmO7qu18UkKvmmOSndx3HtZ0JBjGEp0RtnFodXYdG0HbSrnW37yJW1BmGwnw2He2d73PnDnAa4JQOJg5rmx0flggP6zNVfDfQrLwoIXOhy6iwtXWeDK5Y9GSkkoDnLGmSFr46oZo7C5rpkDeTLkVA+Ks97Y0lg+IqfrpUs9lMlkchPWS0Z/rfhRzFCa231QHcZDAbWXriPENAgW5HbOuE6VqQJ+RB5fcoKZyE9FZuOAkGI4NHOObFGwKeitAJMgS55Z9qDaQyI/abb9lyLpoh5VA25qWDpV8OTSo1kixSxCTvCdeZ29TnS4RwSFFKC3iot5qeeIQz6SKJeea31Q06zvzG1DrSI77f18a97AQXzbbHw1k1k/PC3dxfBwXG8Fn8uRJT6sA5bvlHwJomuroexGG52PId+GbmKL7ZbUqkDrRroSCljfZFCmg1RqQjDxA4zrRLiNBg+BCuQI/POiLK7z2K1l7nn7rFjwwIH8i12pNd
 j3mwuO6N
 xrN9IQOwkBDZFTtpt3wBPc5ppBLGIEwxphgkhfFLG1oZdELwVxw69KVJ0DgESNh8LyCSFC1InxscRXJ7DxDXE5C0utMUrOFEdaOToVsL/4Q15pxcCfPc3TkB8zLGnbCsTZuYiXC9jCm9ZPfD3fCQmEt1Qiv5jcrxFRkQ0ozduXrI2F8Y3MVXMFNJx6vVy74uR1Q8nNAeGo9eStD7qKkSQV3B8V19hZBJCPUjdnZyDg67ujtEsIB6TXgK8KEj6c+f8zaiUGKyttR3pGknH7mMGV7ni2j5q0e7PxyS7
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
---
 mm/vmscan.c | 46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5c59c275c4463..20cd54c5cbc79 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1907,24 +1907,27 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
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
 
@@ -1946,19 +1949,15 @@ static unsigned int move_folios_to_lru(struct lruvec *lruvec,
 
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
@@ -1967,11 +1966,12 @@ static unsigned int move_folios_to_lru(struct lruvec *lruvec,
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
@@ -2040,8 +2040,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	spin_lock_irq(&lruvec->lru_lock);
-	move_folios_to_lru(lruvec, &folio_list);
+	move_folios_to_lru(&folio_list);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2052,6 +2051,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 
+	spin_lock_irq(&lruvec->lru_lock);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
 
@@ -2190,16 +2190,14 @@ static void shrink_active_list(unsigned long nr_to_scan,
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
@@ -4773,14 +4771,14 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4792,8 +4790,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	count_memcg_events(memcg, item, reclaimed);
 	count_vm_events(PGSTEAL_ANON + type, reclaimed);
 
-	spin_unlock_irq(&lruvec->lru_lock);
-
 	list_splice_init(&clean, &list);
 
 	if (!list_empty(&list)) {
-- 
2.20.1


