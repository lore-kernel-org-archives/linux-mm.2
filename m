Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76701CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53598E000F; Mon, 10 Nov 2025 03:19:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B458E0002; Mon, 10 Nov 2025 03:19:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A683C8E000F; Mon, 10 Nov 2025 03:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9B98E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:19:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BD5D12D21D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:19:18 +0000 (UTC)
X-FDA: 84093997596.17.D45FB0D
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id A9CD61C0007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:19:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZlhZIakE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762762756; a=rsa-sha256;
	cv=none;
	b=uyakLdl8ASzLmwiTXibgntxluRqAr3dhsWkDU8jEeCWIStn6eKgVvEzrjqnKW5cQnfiIcX
	suDjySDG3X0EP+QiFqHuOClvAGxIrOHUkg5zpUAWSY+imRX9pAGN6xuIR/6GmPtNa9t2Oa
	k4QoaULRDdfsoTD4G89kGua0BAIj+e8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZlhZIakE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762762756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjvkTkMH4PVeKNg6xAikpsOHdhkcAGa/caRUR5cogZA=;
	b=eTuX9Xg3YwCK1k04RBCVzPxvmvnBb6sfylXN5f3200mt7WikZwVQ+wWSAzzd553aZztFZ4
	M+pP7z6Xsdc6mF9f35Lwib6xCQgMX6ebeFB9uTb0r881IPGiKDvzXEvfb+c14ZU6SRWPVV
	lHOatlRY65BF1AioIIC/KRpvkiTgGtQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762762753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mjvkTkMH4PVeKNg6xAikpsOHdhkcAGa/caRUR5cogZA=;
	b=ZlhZIakECaE76khHLoCDpjv9cJxRoDJbeisr3LsVwTUY2bL8Fn2C/OMaUDm6Wmmz5KB7MP
	ApTAprOi55R926TmFGs08CxXVbmgcVlWdz1wt1c7Uy3v6zI/7s1AINqFACty0hUYknmaw2
	ILHMwMH1pdjxc0h4JsXfOyDqxi0UxOk=
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
	akpm@linux-foundation.org,
	richard.weiyang@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 2/4] mm: thp: introduce folio_split_queue_lock and its variants
Date: Mon, 10 Nov 2025 16:17:56 +0800
Message-ID: <a31a90bcac04dc754f775e87ae3205be3170b571.1762762324.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1762762324.git.zhengqi.arch@bytedance.com>
References: <cover.1762762324.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A9CD61C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: eoi1h1xkscc9z3pwi9km9wdnzfmu5jt6
X-Rspam-User: 
X-HE-Tag: 1762762756-885465
X-HE-Meta: U2FsdGVkX19jlC/ThIND6AcL/10FBtgvKGY3eV304uGnuBODMt0SfS4A3KXs3yRwb+ZDp6UeulMw+jczmHSWYPSlYaboAxP4CbQCZGnaAeykGxi1beU/Y91WzV2ycReFoQkxMVxStBxajLd4r2/SsvUI0KFY58oCxaXspv/QcDgEnxfdNzz3qhcoHZ7BdQ8Xyl518J3f0pPL/IovoJ6stXmz7poVNmDC6Pk+et/xv5TVtFeGTZPh6k1smegvOOSdPQc8XG3CrX18CZjnDA+QACfJNrhyzemLxRtxTba2yGNUBISIelBLndj3rUyIUvCn5bKhH7wN+bHNyH2apy571pJ+ebSoLxYP/Jjmqbf0okMg/4R4drx7PZcStt9fIsv+w/Q8eBXDg4ob1Imigd81DccltDEQ6gqK0ye1Q5ZxZKEJFAEEJc8QQx3uUBxreVyCR44okaZOKj2qrOmerFYpRrwf1G+NbQwQN5hvVsThalufeOAN32nv9mz6qNTY5H0CAwIDqerydY4zU3BhjYcDzrILXTyOo/SGjcKuf5bWxDdpEyWacUG0eutYdkmyasSiL4c+sGdc+cYBUVIW/jqEZL0OdY5XnUyd3rl2XbzOhcw/LJ/bxshLHf+mRn2CMjnaIES6h+tIXFjIe/riZpAYqAChDOMHzWcWDJItL+GQABaj2JaMcNyZQ2bKBSqvhbRyXkphIAaXsPjEb4QNsgLZZqYJx4AmgW1NijAahPTzNSjwDWsdqh6FPeFC9VCL2SQZCXbRNMERFntvSIyEbzYeNiczDFPUHt/dIuVxPmgLokOm89lpOeBzrrtIe3ABOQQK2ks3eFRBW6F+ZBmIqDWLaMPv/GXx43x2Y7Bqs0LZ0xSgXMf1Jja/lG1H0j/79jCP6HfWtT+LsS/cvh284mHMzvK8nxUd7+cUg9x/QbmqEh/r3eA2EXp/9AxBuHQMNHgx5S3LxPGaYgN02g3UXfk
 RvJVlCe5
 K2/Z5hHhseDE2thgITxyBP+VnilEsLihmXr1SogiLncagb6XWrYb99hFH9agyOzRrf5Yaf/nOyag2z5WDIkf4UXfNcXh6dnXZm6t4sKALfJAtTm3OBGe3HscEyUup/k2ZyMobIoQ2M4SmyV9gqmKRh/w6KPnpF/rVXSXu98GEmUA51VGsCNqO1XCb9yt+Uj2ts0tBFMG8U4mWJEfHgRjayfg/4+NG8StleOIIaDNquYAjj0xQ96kbBfIzU9eGxwIrb3Tgsi40fTdSN2ZIwaMFvoJlyQxZpJnzA2vbHRAztomEt5xqhyfhPR5S2YXMxFpKRx9R1q1YqmwGlyi4B3JxAZ+sB3RU4ABqXSG/JDysYIDVW9XtOOHzgo7UcofbvCZSVn7pzNMpkDpna9d3xDEu4V9pnb8/JP62QKkWMcDkTX4/MlWtr82zKJ9cO4TWrNMIGyNaxoSFj3Ut0JJ/GE54VY6W8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In future memcg removal, the binding between a folio and a memcg may
change, making the split lock within the memcg unstable when held.

A new approach is required to reparent the split queue to its parent. This
patch starts introducing a unified way to acquire the split lock for
future work.

It's a code-only refactoring with no functional changes.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/memcontrol.h |  10 ++++
 mm/huge_memory.c           | 119 ++++++++++++++++++++++++++-----------
 2 files changed, 94 insertions(+), 35 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8c0f15e5978fa..fad2661ca55d8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1647,6 +1647,11 @@ int alloc_shrinker_info(struct mem_cgroup *memcg);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return shrinker->id;
+}
 #else
 #define mem_cgroup_sockets_enabled 0
 
@@ -1678,6 +1683,11 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 				    int nid, int shrinker_id)
 {
 }
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return -1;
+}
 #endif
 
 #ifdef CONFIG_MEMCG
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 84ef014b2c11f..858f896ef3bf3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1077,28 +1077,86 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 	return pmd;
 }
 
+static struct deferred_split *split_queue_node(int nid)
+{
+	struct pglist_data *pgdata = NODE_DATA(nid);
+
+	return &pgdata->deferred_split_queue;
+}
+
 #ifdef CONFIG_MEMCG
 static inline
-struct deferred_split *get_deferred_split_queue(struct folio *folio)
+struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+					   struct deferred_split *queue)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
-	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
+	if (mem_cgroup_disabled())
+		return NULL;
+	if (split_queue_node(folio_nid(folio)) == queue)
+		return NULL;
+	return container_of(queue, struct mem_cgroup, deferred_split_queue);
+}
 
-	if (memcg)
-		return &memcg->deferred_split_queue;
-	else
-		return &pgdat->deferred_split_queue;
+static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memcg)
+{
+	return memcg ? &memcg->deferred_split_queue : split_queue_node(nid);
 }
 #else
 static inline
-struct deferred_split *get_deferred_split_queue(struct folio *folio)
+struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+					   struct deferred_split *queue)
 {
-	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
+	return NULL;
+}
 
-	return &pgdat->deferred_split_queue;
+static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memcg)
+{
+	return split_queue_node(nid);
 }
 #endif
 
+static struct deferred_split *split_queue_lock(int nid, struct mem_cgroup *memcg)
+{
+	struct deferred_split *queue;
+
+	queue = memcg_split_queue(nid, memcg);
+	spin_lock(&queue->split_queue_lock);
+
+	return queue;
+}
+
+static struct deferred_split *
+split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags)
+{
+	struct deferred_split *queue;
+
+	queue = memcg_split_queue(nid, memcg);
+	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+
+	return queue;
+}
+
+static struct deferred_split *folio_split_queue_lock(struct folio *folio)
+{
+	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
+}
+
+static struct deferred_split *
+folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
+{
+	return split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+}
+
+static inline void split_queue_unlock(struct deferred_split *queue)
+{
+	spin_unlock(&queue->split_queue_lock);
+}
+
+static inline void split_queue_unlock_irqrestore(struct deferred_split *queue,
+						 unsigned long flags)
+{
+	spin_unlock_irqrestore(&queue->split_queue_lock, flags);
+}
+
 static inline bool is_transparent_hugepage(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
@@ -3697,7 +3755,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, bool uniform_split, bool unmapped)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
+	struct deferred_split *ds_queue;
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
@@ -3837,7 +3895,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	spin_lock(&ds_queue->split_queue_lock);
+	ds_queue = folio_split_queue_lock(folio);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
@@ -3859,7 +3917,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			 */
 			list_del_init(&folio->_deferred_list);
 		}
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
 
@@ -3959,7 +4017,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		ret = -EAGAIN;
 	}
 fail:
@@ -4142,8 +4200,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	WARN_ON_ONCE(folio_ref_count(folio));
 	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
-	ds_queue = get_deferred_split_queue(folio);
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
 		if (folio_test_partially_mapped(folio)) {
@@ -4154,7 +4211,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 		list_del_init(&folio->_deferred_list);
 		unqueued = true;
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 
 	return unqueued;	/* useful for debug warnings */
 }
@@ -4162,10 +4219,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
-#ifdef CONFIG_MEMCG
-	struct mem_cgroup *memcg = folio_memcg(folio);
-#endif
+	struct deferred_split *ds_queue;
 	unsigned long flags;
 
 	/*
@@ -4188,7 +4242,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_test_swapcache(folio))
 		return;
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
 			folio_set_partially_mapped(folio);
@@ -4203,15 +4257,16 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
 	}
 	if (list_empty(&folio->_deferred_list)) {
+		struct mem_cgroup *memcg;
+
+		memcg = folio_split_queue_memcg(folio, ds_queue);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
-#ifdef CONFIG_MEMCG
 		if (memcg)
 			set_shrinker_bit(memcg, folio_nid(folio),
-					 deferred_split_shrinker->id);
-#endif
+					 shrinker_id(deferred_split_shrinker));
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 }
 
 static unsigned long deferred_split_count(struct shrinker *shrink,
@@ -4257,19 +4312,13 @@ static bool thp_underused(struct folio *folio)
 static unsigned long deferred_split_scan(struct shrinker *shrink,
 		struct shrink_control *sc)
 {
-	struct pglist_data *pgdata = NODE_DATA(sc->nid);
-	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
+	struct deferred_split *ds_queue;
 	unsigned long flags;
 	LIST_HEAD(list);
 	struct folio *folio, *next, *prev = NULL;
 	int split = 0, removed = 0;
 
-#ifdef CONFIG_MEMCG
-	if (sc->memcg)
-		ds_queue = &sc->memcg->deferred_split_queue;
-#endif
-
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = split_queue_lock_irqsave(sc->nid, sc->memcg, &flags);
 	/* Take pin on all head pages to avoid freeing them under us */
 	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
 							_deferred_list) {
@@ -4288,7 +4337,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		if (!--sc->nr_to_scan)
 			break;
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 
 	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
 		bool did_split = false;
-- 
2.20.1


