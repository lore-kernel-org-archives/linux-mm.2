Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 580A3CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC9D8E0015; Fri,  3 Oct 2025 12:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AACC08E0005; Fri,  3 Oct 2025 12:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DAE8E0015; Fri,  3 Oct 2025 12:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 828F78E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:54:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D969BBB1D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:54:18 +0000 (UTC)
X-FDA: 83957400996.19.0325DA4
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A81F18000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:54:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tq0jMNoj;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759510456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIAGnjxyrTRHrbY4KyDza4y0q1kfWlGPnByEN+/gev4=;
	b=00CGX/DP4L+O3CHFAkQnDGKHtGrDlg/oGj60dvLVgqPIaTLMCKFf9mQMUF7vvmxBOrANSa
	IE/SQkxG9kQw/S5hqtMICQePgNMFaDJo1qINf+1spJlRq+FmNDYql7Fn9WfnYoJu99o0UT
	Ds07YQFZVVSUtPtYKL89FtWzeUhlbMM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tq0jMNoj;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759510456; a=rsa-sha256;
	cv=none;
	b=YPHSu9FFWAxS5vCU6K+XxUz/8HyVLfFOuPuQPQRcGFLSR6fV0B2ReghMOokjj3aytTp08K
	6f/kovJdy8CO69SAwCjpFjWZUnHiB7YzEna0AcD08xM052JjASZm/ObbNsBohGjl4SJi3a
	SMc7hZKmtm2GOnEc6U3ZHfR3CzYjEcI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759510455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OIAGnjxyrTRHrbY4KyDza4y0q1kfWlGPnByEN+/gev4=;
	b=Tq0jMNojAj2xLt8CgeV1L/1a4UzS+xJMEDaUOrxUVG1+/AE5lXxMZnA/TN83Z7KY++tCq3
	o/2pxY0JMfO/3ubdqevBQcyaMJ0TO3fY7zsFHiXzPllyqGlFyO/KqLRtujLuJOXS+KXr3S
	pF0zpQfpp1tg+yrHZDH7fbt1TxwHV1c=
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
Subject: [PATCH v4 3/4] mm: thp: use folio_batch to handle THP splitting in deferred_split_scan()
Date: Sat,  4 Oct 2025 00:53:17 +0800
Message-ID: <304df1ad1e8180e102c4d6931733bcc77774eb9e.1759510072.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1759510072.git.zhengqi.arch@bytedance.com>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: y5b8gp7hpunuqrjh9w58as5o7n9ubqs5
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A81F18000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1759510456-790415
X-HE-Meta: U2FsdGVkX18+mic+0eUlJgVmsGrQ94+hoUiCZTd5B1KfPKFab2r15w03r/N/E6LYXUXM+yOS+ee9Pqjc/XvUO+qWNq/3ccEzOUqtC5e8wCyAOUQ9QZTvCERi3uxO9tybGBuan9j4qSRrWsPaGrHihOAbJ7KrVmozmgAkgB0ClzLVrncr3OdQPQ/oDGd5ERIABV9wGvQHVDr2yByUK/DXR61kFkeC/kW6sASDrHxngewMGxECFl0w8ePrXBjpCQALja/V3JXWs1WBNBySdA8+avElhLYmbBogcUWwPM50i261doFjn1MK9CLh1BT6WEYf4lJm60IuVXObg6mx/x+k0BDz7bKPGICAzLWI3vuaKi3+crmKjhMUVOQP7jWdp9VlahOEEP7qc7VrKTbf4c8stcIQNf8Jht4W9jThtmfvFlUR87bPwIm46veWx1a2Y9bJhXF9QuQCQXtmLMDo+xXSVjCq1Lg4OaYx46zyDPfb9gw8qYYKVtG+t4xIIR99GLDplAvl5LVH06aUVAS2EqfsT1tRpmXOHZPP6AE0hCgVbDLEtkHMJR/4dJSsZAoaWx26/LPUl7+2vn0F6W8IdRN/XIfQH883sEAppcqwqxguyucQiuV73VdhLaWBdCqNhX2dsQT+rp3trEdnTFiPCiOsYeA+vGstqRYR14wvP7aqE5HJC05RLJ9uIJfemfFoW8YbgZFOX91n6MJPdoDLVs7osOvo7zfjoU3H7YBpcxfeUJCqc4ollDTPQiSi7erms05k8evc1sFQGvFbh1tFHUhWZV8C4gpkBH3NMEapasjhuOSSy+mkfKgQGl9tklQ5aVxjpHk1lVKTfSW/y6oCWZxrUE2NQ89dR5lyBCJYgbXnpDsI4phDm3pnj+vTt62vh1O9
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
      this lock protects the local list, not the split queue.

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
---
 mm/huge_memory.c | 85 ++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 46 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 134666503440d..59ddebc9f3232 100644
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
@@ -4185,35 +4186,40 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 {
 	struct deferred_split *ds_queue;
 	unsigned long flags;
-	LIST_HEAD(list);
-	struct folio *folio, *next, *prev = NULL;
-	int split = 0, removed = 0;
+	struct folio *folio, *next;
+	int split = 0, i;
+	struct folio_batch fbatch;
 
+	folio_batch_init(&fbatch);
+
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
@@ -4236,38 +4242,25 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
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
+	if (sc->nr_to_scan)
+		goto retry;
 
 	/*
 	 * Stop shrinker if we didn't split any page, but the queue is empty.
-- 
2.20.1


