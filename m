Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E33ECCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9FF78E000D; Wed, 15 Oct 2025 02:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78018E0003; Wed, 15 Oct 2025 02:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98DF48E000D; Wed, 15 Oct 2025 02:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 888608E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:36:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E0BB8844A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:36:25 +0000 (UTC)
X-FDA: 83999389530.13.FB34645
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD6EC80002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:36:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLjwMgo4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760510183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=66XQX47BSKL9mBR0Fp3aBPYpv621vB9nH6Q1VhDu8U4=;
	b=dfN92z2CmIMXYmc8xObLv3WWJuMFhiLtZ7Z8RvjC5xKpjYb0tuz6fXvD7jpVFFlx5hxNHz
	Q8uvprSagQhWQUA8gi2S45bfN/3N40qGiys9BLGyiO/yANr8Axz5+c9DQkhImJn6RxRGsr
	MQqCJJnCKU1o9MMIqcSWSGjraSD3Hio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760510183; a=rsa-sha256;
	cv=none;
	b=fTkgSBcY4Qlu7jRm+0BTpOhzu6SubvS0u8+DpU4AcHUyb4/FBCmiM47rPBx8CLK+agXG0Y
	aE4B9hUI6VooAnAu86ZYwew6Be0tqy4iHLMrVYvMzpJsidoq8BlMCVsqoJJMIWiSMp0WCc
	JsgtXaau6/qYs40DsGC+p/lWOuXTfmE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLjwMgo4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760510182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=66XQX47BSKL9mBR0Fp3aBPYpv621vB9nH6Q1VhDu8U4=;
	b=WLjwMgo4unnSxXHoNcMgGJD4dFK0SK1lhE+zM1EmkcvhsJK8Uqr919IA9+lrfmeBDiGDZN
	NUdyKJRqAG9A45jDoqwRlwoK/XJZoEALRyzFTqmiBun07Kuj2S5NbNBNNvg2097fgwsMqM
	PlHnXWX3H8fDLWks5HxSV8d9tv356Hk=
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
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 3/4] mm: thp: use folio_batch to handle THP splitting in deferred_split_scan()
Date: Wed, 15 Oct 2025 14:35:32 +0800
Message-ID: <4f5d7a321c72dfe65e0e19a3f89180d5988eae2e.1760509767.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1760509767.git.zhengqi.arch@bytedance.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: 1yihk6fgdzfd64ixq5mtgneeu5idkakw
X-Rspam-User: 
X-Rspamd-Queue-Id: AD6EC80002
X-HE-Tag: 1760510183-935981
X-HE-Meta: U2FsdGVkX1+6KJLIbDNbYQPivgmAD48HjteN7Sb+V6WtNPseZ+OykTrCnhw0boU5nFvpz6SZOHp32uRcxrO0oP+H80+D+v7xgS9lBtSrzNvphOdEqzwIcnalgXokspzV0Ng+vmj89dgm5zJqbWPr7+0Jw5qa1BC9FzUrneO8+iUZAHfKIUqE8HOGeI5S0RcZULbZRg6p0VGSUR5rrIq9dD9ad9BEx6bPqklXkrHCCOy92O2zCbgByzTVuHEQcbvWcSfUDub8dzYyWBcZLrd+bmz+lipytXwWS8R34vkqpqZOo+H6o+cCf1rliN2UmHIMrbCfjEao4JL5kI1+3C6FGn+TriC6Pm8tYqllSovX2TyLnumQfi4p1gLyt850JTo1QqduyIGPcfS094W0J5P821cD5HDy4JVStosB0sBQUb7HNhGksoGkEi6PC/9tT/vl9v0epkhhCMnxehQ2aAfrcBo3yCMSCr5gVTzeyOiP+chLWWZkua7Yz06mmkP2VDmmwf9ZFp93/TeJnR1EIBvI/4Tr7nd33Wc/2EDje/O6pJMfDBRWKR8UzLwtB2VlrpQvUQXZrsfjDDqQdHISxOjTopPZXTX5jYoQEc2WCdrCovi2ySFaaKVTlLaA6XwMVLwS5wWXBijavzjstzw9KkbaEFdDVxMFcXjnAkeeFk6h9wOnD2c6PcUtEq6N8ZMpHW2Z0pzFPDsh/gbrCrDawwHQ+Q3ds8tx8WZ/rZq2hvaLVl6eGZjiwsUYdZfisOL1jgFHo7tzX0a1V5gGLC+iCzcLp0fCW5TdMQ41I3e22ou3XNo/xbNZcNDod0scxuaQqqMTKRiByC9sQUh+y5iVvbUrHtyjLKkg1S+l37TMYVYGOdgNeHaOvzcpte+ztIJzNq18
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

The maintenance of the folio->_deferred_list is intricate because it's
reused in a local list.

Here are some peculiarities:

   1) When a folio is removed from its split queue and added to a local
      on-stack list in deferred_split_scan(), the ->split_queue_len isn't
      updated, leading to an inconsistency between it and the actual
      number of folios in the split queue.

   2) When the folio is split via split_folio() later, it's removed from
      the local list while holding the split queue lock. At this time,
      the lock is not needed as it is not protecting anything.

   3) To handle the race condition with a third-party freeing or migrating
      the preceding folio, we must ensure there's always one safe (with
      raised refcount) folio before by delaying its folio_put(). More
      details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
      split queue not partially_mapped"). It's rather tricky.

We can use the folio_batch infrastructure to handle this clearly. In this
case, ->split_queue_len will be consistent with the real number of folios
in the split queue. If list_empty(&folio->_deferred_list) returns false,
it's clear the folio must be in its split queue (not in a local list
anymore).

In the future, we will reparent LRU folios during memcg offline to
eliminate dying memory cgroups, which requires reparenting the split queue
to its parent first. So this patch prepares for using
folio_split_queue_lock_irqsave() as the memcg may change then.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/huge_memory.c | 87 +++++++++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 46 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a68f26547cd99..e850bc10da3e2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3782,21 +3782,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct lruvec *lruvec;
 		int expected_refs;
 
-		if (folio_order(folio) > 1 &&
-		    !list_empty(&folio->_deferred_list)) {
-			ds_queue->split_queue_len--;
+		if (folio_order(folio) > 1) {
+			if (!list_empty(&folio->_deferred_list)) {
+				ds_queue->split_queue_len--;
+				/*
+				 * Reinitialize page_deferred_list after removing the
+				 * page from the split_queue, otherwise a subsequent
+				 * split will see list corruption when checking the
+				 * page_deferred_list.
+				 */
+				list_del_init(&folio->_deferred_list);
+			}
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(folio_order(folio),
 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
-			/*
-			 * Reinitialize page_deferred_list after removing the
-			 * page from the split_queue, otherwise a subsequent
-			 * split will see list corruption when checking the
-			 * page_deferred_list.
-			 */
-			list_del_init(&folio->_deferred_list);
 		}
 		split_queue_unlock(ds_queue);
 		if (mapping) {
@@ -4188,35 +4189,40 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 {
 	struct deferred_split *ds_queue;
 	unsigned long flags;
-	LIST_HEAD(list);
-	struct folio *folio, *next, *prev = NULL;
-	int split = 0, removed = 0;
+	struct folio *folio, *next;
+	int split = 0, i;
+	struct folio_batch fbatch;
+
+	folio_batch_init(&fbatch);
 
+retry:
 	ds_queue = split_queue_lock_irqsave(sc->nid, sc->memcg, &flags);
 	/* Take pin on all head pages to avoid freeing them under us */
 	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
 							_deferred_list) {
 		if (folio_try_get(folio)) {
-			list_move(&folio->_deferred_list, &list);
-		} else {
+			folio_batch_add(&fbatch, folio);
+		} else if (folio_test_partially_mapped(folio)) {
 			/* We lost race with folio_put() */
-			if (folio_test_partially_mapped(folio)) {
-				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(folio_order(folio),
-					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-			}
-			list_del_init(&folio->_deferred_list);
-			ds_queue->split_queue_len--;
+			folio_clear_partially_mapped(folio);
+			mod_mthp_stat(folio_order(folio),
+				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
+		list_del_init(&folio->_deferred_list);
+		ds_queue->split_queue_len--;
 		if (!--sc->nr_to_scan)
 			break;
+		if (!folio_batch_space(&fbatch))
+			break;
 	}
 	split_queue_unlock_irqrestore(ds_queue, flags);
 
-	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
+	for (i = 0; i < folio_batch_count(&fbatch); i++) {
 		bool did_split = false;
 		bool underused = false;
+		struct deferred_split *fqueue;
 
+		folio = fbatch.folios[i];
 		if (!folio_test_partially_mapped(folio)) {
 			/*
 			 * See try_to_map_unused_to_zeropage(): we cannot
@@ -4239,38 +4245,27 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		}
 		folio_unlock(folio);
 next:
+		if (did_split || !folio_test_partially_mapped(folio))
+			continue;
 		/*
-		 * split_folio() removes folio from list on success.
 		 * Only add back to the queue if folio is partially mapped.
 		 * If thp_underused returns false, or if split_folio fails
 		 * in the case it was underused, then consider it used and
 		 * don't add it back to split_queue.
 		 */
-		if (did_split) {
-			; /* folio already removed from list */
-		} else if (!folio_test_partially_mapped(folio)) {
-			list_del_init(&folio->_deferred_list);
-			removed++;
-		} else {
-			/*
-			 * That unlocked list_del_init() above would be unsafe,
-			 * unless its folio is separated from any earlier folios
-			 * left on the list (which may be concurrently unqueued)
-			 * by one safe folio with refcount still raised.
-			 */
-			swap(folio, prev);
+		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
+		if (list_empty(&folio->_deferred_list)) {
+			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
+			fqueue->split_queue_len++;
 		}
-		if (folio)
-			folio_put(folio);
+		split_queue_unlock_irqrestore(fqueue, flags);
 	}
+	folios_put(&fbatch);
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	list_splice_tail(&list, &ds_queue->split_queue);
-	ds_queue->split_queue_len -= removed;
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
-
-	if (prev)
-		folio_put(prev);
+	if (sc->nr_to_scan && !list_empty(&ds_queue->split_queue)) {
+		cond_resched();
+		goto retry;
+	}
 
 	/*
 	 * Stop shrinker if we didn't split any page, but the queue is empty.
-- 
2.20.1


