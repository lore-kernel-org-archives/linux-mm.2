Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40381CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DD2A8E000B; Wed, 15 Oct 2025 02:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5998E0003; Wed, 15 Oct 2025 02:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB0F8E000B; Wed, 15 Oct 2025 02:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79B908E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:36:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B95D160399
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:36:18 +0000 (UTC)
X-FDA: 83999389236.17.B213629
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C718120009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:36:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GyYWBIT9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760510176; a=rsa-sha256;
	cv=none;
	b=Xax/O6t/XiCE5hSx9nYacmelKRS255gWp+jyuggqYPU7gWypaVKOhSQYHq8D9vsFaANdDU
	lsdM5sabWmVFWYYAb/xBEb5Nc0d+3zx1EQbP71kznUf0BnGZA0pXpz4+IH21OpP/f5tGVv
	RIfkqkq5cswy3dH5VaKpAjEWMFxJfds=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GyYWBIT9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760510176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jVxxvv0jAfrCjVpcMAlY+eF8c/RsGObyYFnhK7c/s8=;
	b=x6GkJrUALdNAOuBlArUNLBjNbNAqBVgniABkMMN8lWzRfx+0Jb/MbMYfq/XpmL5KtFvRNE
	f2aYG6ms0/2dqcYDz8YxZS/lbEssacFxcyAKV5dxDQ2l7WotElt6n8XPzLE85WQ+kscl9C
	jsWhlRRzlwO/EDDReOzHJK/nsr0x4GI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760510174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8jVxxvv0jAfrCjVpcMAlY+eF8c/RsGObyYFnhK7c/s8=;
	b=GyYWBIT9MgxdU+8PYA8lLcYm0HHvYNE2c6mjaiP7dMMM8KlrInHmI19RBRb6ChYSBu5+lR
	rPzHNlZHOTP2gMW0A2Q3/B76RlUK6s+HLNDflxEqliUdIQf6HpK1RF2XhPATWddX6k9iE1
	GbH0jHlqHETd/NH075m4XyV6UEiuPhI=
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
Subject: [PATCH v5 2/4] mm: thp: introduce folio_split_queue_lock and its variants
Date: Wed, 15 Oct 2025 14:35:31 +0800
Message-ID: <77069514656ea81a82969369f24da25ea1304e9c.1760509767.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1760509767.git.zhengqi.arch@bytedance.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6C718120009
X-Stat-Signature: me1nra91wiqe5zsd51g69j875aumaujg
X-HE-Tag: 1760510176-807695
X-HE-Meta: U2FsdGVkX1/0N2A10WIxlJ7nV3X5CVUOICEpki+zPvnVK56rINOhUmLNezxcZIoxFXHMKgxzAji7JFwxISmonDbOaWB0w37ThxEaOziX7w5lvp0XFZxQ56qayKlF1Jm4xv9QEHKFkxCHOj8wWGVMGqUet9NszXWQ/tDRyFELXkTfAnsrbWGNe54sEVLFBqRXv7JMCaEEHdHVFhn0+ZULCGmBeOD7d814QOY3tptOIcpXzKNz0Kn4mZ0QpnTmkDZ7bpTXbka+2Ri4zxDYBBrExjyA0tEPu6zjylVhPJJxUwH+fj86FCC+QhTegkt+DMPihYXWYsdOp0OjBG/FnnUNlNGwW0o2ziKbrIUwODKcYCjrchhHDvAheIujgLIAmfp0Fu3cLmiMbgfl58AIH4SrUGKoSMzkRBofRIAQ8w7nIs2rmuL6umYEbnb3mIt3wAFXWo9NMc9jVok9bUkkg77HAr8M44OvLM8/hwCZKW9qlvqZYoo0Xp6SEjnC+kBxKccEhywWFr1xaiQ/J4lPntZDm/YmfdBttF3/w4Nm7Jc75fm5JkUhAwzVj/wQJbFMTDuZhbrpmHh/eEaw/Vp097Jhz4qNF2ywxg/EgBhii0VYbIR1saITcXk5ggUQb7q6+/ocemmnDisMWleJA6OQlQJ5w/yxwVWnBzCRIy9SXibU5hlcLHgufGmYkW4cZI1KWypJDMv8fntEjgrEHc0qbrnTfRbh9O0HRorz+uqArDf0h5ub8MRg06EYLDruSbJiSnFli8jvFBpSbVvMvJAjdTbk4dzUZKJp7qxIxxxTWJ0jkNNrgNNQ0bY0wohYfFrad5HsSEqWFbbR4F1zpJT9ss0nz7CfEpYW0oTFHJRoTuQpfhL25CdlIBMv3CyDTETvh011OOf48G67quWmtqUUFFpoX65xLHQVK97iyrxiVcupjE/1tQCyD4ZAi9YgfrD5OZ/ZJx/vsJwD73+0wxjzm3U
 dfH8AmoK
 mUiJUs6YKws/i/6L000rbdoBck7Tk+OAStl7b9mQN2qafZHIi05Fuj9Qnxb3nQH9N7rMDa/kxlHqofRaBVrFSKmmP4943WznHiiGmu3r0pudbuRtHtSRKVTcWizkOK2op7Gk0o7zD3/RfpBwgH1njdWu5lVoEfGfYyrLdS4LNxBgOaG+5T/ssFXqkQyf/CRqeQ2l36xsaH40VRIQn7mEfBfAgtt98tmggrP/9fMwkAF+sL1C/sWAu0Lb4SJfarcZdHpPE9qK6rybDdEK/1O3nYoguXzsqkC2GZ7F0zTpfSzM4FEes1JTV/uMe9cJDPAfB0/QZRd3rPoNTXIKxsN7MdYkvW7nhan/GCKfwnsefSpFPTisp/qzPZ/ccLmy3GbJacvIY0chifqeSeww=
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
index 873e510d6f8d9..0b2d4ec79adfe 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1674,6 +1674,11 @@ int alloc_shrinker_info(struct mem_cgroup *memcg);
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
 
@@ -1705,6 +1710,11 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
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
index 3c42db542b1b9..a68f26547cd99 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1076,28 +1076,86 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
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
@@ -3579,7 +3637,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, bool uniform_split)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
+	struct deferred_split *ds_queue;
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
@@ -3718,7 +3776,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	spin_lock(&ds_queue->split_queue_lock);
+	ds_queue = folio_split_queue_lock(folio);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
@@ -3740,7 +3798,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			 */
 			list_del_init(&folio->_deferred_list);
 		}
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
 
@@ -3835,7 +3893,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		ret = -EAGAIN;
 	}
 fail:
@@ -4016,8 +4074,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	WARN_ON_ONCE(folio_ref_count(folio));
 	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
-	ds_queue = get_deferred_split_queue(folio);
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
 		if (folio_test_partially_mapped(folio)) {
@@ -4028,7 +4085,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 		list_del_init(&folio->_deferred_list);
 		unqueued = true;
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 
 	return unqueued;	/* useful for debug warnings */
 }
@@ -4036,10 +4093,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
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
@@ -4062,7 +4116,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_test_swapcache(folio))
 		return;
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
 			folio_set_partially_mapped(folio);
@@ -4077,15 +4131,16 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
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
@@ -4131,19 +4186,13 @@ static bool thp_underused(struct folio *folio)
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
@@ -4162,7 +4211,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		if (!--sc->nr_to_scan)
 			break;
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 
 	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
 		bool did_split = false;
-- 
2.20.1


