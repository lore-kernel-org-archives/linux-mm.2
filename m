Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D3CCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD688E0018; Mon, 10 Nov 2025 03:19:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4FA8E0002; Mon, 10 Nov 2025 03:19:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEAD78E0018; Mon, 10 Nov 2025 03:19:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC8E38E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:19:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A088D5CAF4
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:19:32 +0000 (UTC)
X-FDA: 84093998184.01.8F05655
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id DA5B140005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:19:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oHpboN7r;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762762771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZBuBE3QWFYp7uE2iHbl7AwFCBW3XwNIvR3EZWHHVV4=;
	b=mJ6K2QOiBWn1l2RlqPPBYVdAfqI1T7xYf6EZ5bMeBs2ms5WVd9DmgYDZ0Q+Lp9OiJ2Mcra
	dWX+s3f/UkAbbFsQV7EyWeQlUFyrAWwGCY9KUMKRiY9b7MgjxdvDjJ45Gi8qhoV8lsmItI
	1ag6MdXjRu7l2i1EJcE2sCVUJ21ywKc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762762771; a=rsa-sha256;
	cv=none;
	b=3l8QxQGvcFJurmdg75IyRWeEBBod02EtYF1GWBAB/AvSOYw8uFdmITRUwZA4uWGwkVwiEz
	kWES2R5tMNNnE8UJwRaHIdM0H7jk2vkMLALgC3d+HPjWkXBa0cCNmsD6CjrD1oCm5rQnSh
	R+quLsAXOQ/U3gXhY0faEWp7T39fUy4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oHpboN7r;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762762769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YZBuBE3QWFYp7uE2iHbl7AwFCBW3XwNIvR3EZWHHVV4=;
	b=oHpboN7raQaq3heBBKwf64VuXGAjGZj8U6vaCmv4rAbusmntps11N3dfZKkAZGz+JHjIRo
	NYqR8InlX0YLgDhBMWBKHXvRAI51ckuNCNxLhQMgCtp5Ewj2fxheB0sGh/zf3LbABflqL2
	3HIcUX9vAaS1xvtsVyaJrf6neuUrjNU=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 4/4] mm: thp: reparent the split queue during memcg offline
Date: Mon, 10 Nov 2025 16:17:58 +0800
Message-ID: <8703f907c4d1f7e8a2ef2bfed3036a84fa53028b.1762762324.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1762762324.git.zhengqi.arch@bytedance.com>
References: <cover.1762762324.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: s4y9r6d1dey1ziiuzucuz9s4bd4zo5c4
X-Rspam-User: 
X-Rspamd-Queue-Id: DA5B140005
X-Rspamd-Server: rspam01
X-HE-Tag: 1762762770-651479
X-HE-Meta: U2FsdGVkX1+E5BIGP9F2qhmwnULJY/p7wZNdIQwBJJy+NLKLMQaECXlwrBsH1rQLVarxSu5cipKzOoirLYZJlI+FcpGxbbhfMQt4rNp/KzUGE+e74qn8zIKBtwyDM2SXbFPZvfFzfgtCmrCJW3fVduxGQBGBwhARWyzQpYUiNTcqg8VJkKR7JoCifWLVdt+oMxXpv6OiU3chZ1AW3+Ms21za265+tFrD5wVmy9CYQ+aF7sl+ZBIP3sx0wNFwd3on9xaC1sV5xMDiUyPwob0EOZ45NTVn+mjwpa6/OcCIq2h3MsmqcOCT5/v+5wHGgn2OGYv7H93iqe8/nIyAJIPJlhQL0cw+8xrC+oWG35zuXbR/8fYfKka9mru5LnZvkzS1WSKmKkBuXsjQpH/wB9QUUQQfn+XwwKHbqN5raKcCkYx0ePr13mICpYLS0t41DkDm061yqKa2x/eNpCD20OYVOWFL0mKuxG2WYoHRFZ9gXcd6kBP8Sb/PIb7lGsVjxCaImMGn7WRGMMbFszt2jYk882dMn8MDxHZRAtseNINvfhL6pyqIxMEBjEDEwFtLN/VMj/0A6KZDDmL0q2JpTpwuaOAJ5joZr/zbVvLBiFNEON86UhkRTptt1hrkJ+V7U1mmUxTfCf1/8q7fu+2bJhZq8C1wLluIBrRLA6F/UWCwkHuKcUhgMaxs5DY1D+WLCee7FmPUcmb+dQkUqeJbb8oHdPy9XRXNtfqqDBEtStlThyj6gze1h747pPHQF6tednPIQBp1xspG0NYwc/tf2+jxJD1Q0pMQ+XV9YtfOOfQEDa34MUVLbgXbjGvuWRQ3WazwlRifSEQnGyXb5SsTcdgVJSBY25hpl8kA+z6GS4rFUdjjar2hgGsi7KcmOvOVy/gCXCEYrpcG0wssRp6JI1/oCBBE2aV5FXmi2YJQdvtvdVtLTyZdwe3GfJKJ2RqgfgvbGMOVF8i5coDMyfMx2tg
 lXIyqyDc
 GCCLhOWbP/RN34G3Pt67QB9OUtmWhlPrFxEv75hnfClnpnH/1Fi2hfEQaX1PjAwf7+lwV8eu/0FjjvUeoaSwfmOpicWAJPmHHGHTfkUC6q0XoSWv3D2YWJbYkddY6HAY9eeLaaWocLj3Ze7Na7N9D9tUKXMyLOO9A6votvMtDls11UgXpMtTnBcUC0iTxtQN6YLtLXoYv9VlzLW1PoKmc0s8GBLxP8msGXPlMFSNGoHrLK2eh9jYYWEmVoU4TessC7Hc7Ip1Mz9uFWqj9F8lc6lc42Q9z1xRVjhBehiPHFmKnIt8EYkOHUjIPcECfS1BK9Vv/b6bUHbUY57SVcgUm93wjUPYgQYRfsq1G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Similar to list_lru, the split queue is relatively independent and does
not need to be reparented along with objcg and LRU folios (holding
objcg lock and lru lock). So let's apply the similar mechanism as list_lru
to reparent the split queue separately when memcg is offine.

This is also a preparation for reparenting LRU folios.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/huge_mm.h    |  4 ++++
 include/linux/memcontrol.h | 10 +++++++++
 mm/huge_memory.c           | 44 ++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |  1 +
 4 files changed, 59 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 5ba9cac440b92..f381339842fa1 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -412,6 +412,9 @@ static inline int split_huge_page(struct page *page)
 	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
+#ifdef CONFIG_MEMCG
+void reparent_deferred_split_queue(struct mem_cgroup *memcg);
+#endif
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
@@ -644,6 +647,7 @@ static inline int try_folio_split_to_order(struct folio *folio,
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fad2661ca55d8..8d2e250535a8a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1774,6 +1774,11 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 
 bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
 
+static inline bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return memcg ? css_is_dying(&memcg->css) : false;
+}
+
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1840,6 +1845,11 @@ static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
 {
 	return true;
 }
+
+static inline bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return false;
+}
 #endif /* CONFIG_MEMCG */
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index db03853a73e3f..8bb63acaa8329 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1118,8 +1118,19 @@ static struct deferred_split *split_queue_lock(int nid, struct mem_cgroup *memcg
 {
 	struct deferred_split *queue;
 
+retry:
 	queue = memcg_split_queue(nid, memcg);
 	spin_lock(&queue->split_queue_lock);
+	/*
+	 * There is a period between setting memcg to dying and reparenting
+	 * deferred split queue, and during this period the THPs in the deferred
+	 * split queue will be hidden from the shrinker side.
+	 */
+	if (unlikely(memcg_is_dying(memcg))) {
+		spin_unlock(&queue->split_queue_lock);
+		memcg = parent_mem_cgroup(memcg);
+		goto retry;
+	}
 
 	return queue;
 }
@@ -1129,8 +1140,14 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
 {
 	struct deferred_split *queue;
 
+retry:
 	queue = memcg_split_queue(nid, memcg);
 	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+	if (unlikely(memcg_is_dying(memcg))) {
+		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
+		memcg = parent_mem_cgroup(memcg);
+		goto retry;
+	}
 
 	return queue;
 }
@@ -4402,6 +4419,33 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 	return split;
 }
 
+#ifdef CONFIG_MEMCG
+void reparent_deferred_split_queue(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
+	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
+	int nid;
+
+	spin_lock_irq(&ds_queue->split_queue_lock);
+	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
+
+	if (!ds_queue->split_queue_len)
+		goto unlock;
+
+	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
+	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
+	ds_queue->split_queue_len = 0;
+
+	for_each_node(nid)
+		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
+
+unlock:
+	spin_unlock(&parent_ds_queue->split_queue_lock);
+	spin_unlock_irq(&ds_queue->split_queue_lock);
+}
+#endif
+
 #ifdef CONFIG_DEBUG_FS
 static void split_huge_pages_all(void)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 025da46d9959f..c34029e92baba 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3920,6 +3920,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	zswap_memcg_offline_cleanup(memcg);
 
 	memcg_offline_kmem(memcg);
+	reparent_deferred_split_queue(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
-- 
2.20.1


