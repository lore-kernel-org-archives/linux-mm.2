Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42464EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C286B0096; Wed, 25 Feb 2026 02:50:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D7D6B0098; Wed, 25 Feb 2026 02:50:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993E06B0099; Wed, 25 Feb 2026 02:50:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87CC56B0096
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:50:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EB151B68F9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:34 +0000 (UTC)
X-FDA: 84482206788.14.ECCD89A
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id A9B2380003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PA33FlY7;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5rM3hQDqpUHUQyzUXFcLhuGKQoF0cAvo8SOoxm2ygg=;
	b=ukVHulMuefjnyY8YqDZdnaz8Xz0Yj4KG9kv0h++kX2z62WiMlU0tBVxzWEJ2WoOyE1rAD5
	UTCHgZdCuouqqAeG2KCvy/HEgtIxxVrO2NeKW6wV1QOq7buCLzH0laZPfxpa723pI8n8yb
	FetenS7jj8PRwgKoXhkUWbpb5vXh5t4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PA33FlY7;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005832; a=rsa-sha256;
	cv=none;
	b=Z5AlhrXePQQliko4RZFv4aGTUdYlfyMBRIxbcWUbNY5rN5ok5mzCE6qknbUXBxp/zziGYw
	K7YuKcELyDGjhTF69yOJ4B9oYxhcluo0Q2ndLpXXxNCKyxZ9fa0bFc7ash4b3CN3XYBHp9
	fCGtvLDth8+GEGPjIxlvBHzfnWHT6qU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n5rM3hQDqpUHUQyzUXFcLhuGKQoF0cAvo8SOoxm2ygg=;
	b=PA33FlY7IZtTsz8nPGzL2jTPdwPoEj8AA0l1w/BPskCkavCPng2w02ECWdeVsIGEXQRcbL
	rxZkafRkGTFrSTn2Wkd+JVA9peKacEeTeFnnV7xYa6NLhMqL5OjOP2Xie83TeRxsDnv2n2
	mGSJ9G21pG8AmGy3i4+Nb/s3DedGlM0=
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
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v5 06/32] mm: memcontrol: allocate object cgroup for non-kmem case
Date: Wed, 25 Feb 2026 15:48:39 +0800
Message-ID: <b77274aa8e3f37c419bedf4782943fd5885dda82.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: m6f1ug8p6yphhmcrpuqagj7atrezmtu4
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: A9B2380003
X-HE-Tag: 1772005832-566086
X-HE-Meta: U2FsdGVkX18pCneKzqzXcIMJ4N+K9NGNFw/LFORM15rUbkvsDX23ZQaVBG9YGG7oPS8AbBkGst0moymnjzUmIsSfkgEk94lWKyo2lIwcze9SpO0DRn6U2qVxer/7LjPqiGZFK/1K94Jp52/HKhsRN1FYO96uD3vZ3RdKDraYQhQ2ApByLzh+cvWbMaS3w1Qp9rK3gcCecZsTEQeR+6UOEPaHM71HLCWPtYVptQf+D7lDBB7jrjgqOTLrhwWGP2tKg0A7ID7u4+cO8hPNs+MpbnzyObTWjV1uJmNWewmOje3bQ9iWQpVMk+9vaoQvgRCBcUzpbj0Rk6qFcifP760Kkz4vnIf+WFA1UMar9rMQ6Q1EknL0q1tI7fDCsY5EHGivmrisDGpamJKyvawxvSMwntVtGWV7NXIEVUahUbcJNCjWWMkYnjKexYzAJdxQtGzRSyEbqDDZSWhNIOtmWjzMurMSoFUAE+g7rImWA64O4I5PHhqOlxaDutdXzZQRoL+nMoEqp0L4pbKUwCGDpaHs2Z4u5A9Od13qosR+TtpAwwce4oafM4jraZj4T1ryTABVGH5j80Tl6K4mxcc8UQM5XFnIVG8UfG5vQEwIt9SA8ezQddVyaYcODOhHsCVdNKer7tvTPMKz3E1B1EZ4d8+OMgGv2Gdj+FqHmX8H8dehJi9wbcdoGM3TxuMYSE/aw4nwis2aiLoJ3apveYTz/tabo3o1+VkqFacurXLt6mBS8nSyuo+VHeGrZe4vVigIzizQb1eqgfuflxR3qUgDG79uSKz4xxwaIoE6lOCld0Tkg2gMtFhjFUkMaDJTIgLfyM6mHsmUA6cOLVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

To allow LRU page reparenting, the objcg infrastructure is no longer
solely applicable to the kmem case. In this patch, we extend the scope of
the objcg infrastructure beyond the kmem case, enabling LRU folios to
reuse it for folio charging purposes.

It should be noted that LRU folios are not accounted for at the root
level, yet the folio->memcg_data points to the root_mem_cgroup. Hence,
the folio->memcg_data of LRU folios always points to a valid pointer.
However, the root_mem_cgroup does not possess an object cgroup.
Therefore, we also allocate an object cgroup for the root_mem_cgroup.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
---
 mm/memcontrol.c | 51 +++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aab863e1822d4..508ee182c032e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -207,10 +207,10 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
-				  struct mem_cgroup *parent)
+static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg, *iter;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
 
@@ -3387,30 +3387,17 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
 	css_get_many(&__folio_memcg(folio)->css, new_refs);
 }
 
-static int memcg_online_kmem(struct mem_cgroup *memcg)
+static void memcg_online_kmem(struct mem_cgroup *memcg)
 {
-	struct obj_cgroup *objcg;
-
 	if (mem_cgroup_kmem_disabled())
-		return 0;
+		return;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
-		return 0;
-
-	objcg = obj_cgroup_alloc();
-	if (!objcg)
-		return -ENOMEM;
-
-	objcg->memcg = memcg;
-	rcu_assign_pointer(memcg->objcg, objcg);
-	obj_cgroup_get(objcg);
-	memcg->orig_objcg = objcg;
+		return;
 
 	static_branch_enable(&memcg_kmem_online_key);
 
 	memcg->kmemcg_id = memcg->id.id;
-
-	return 0;
 }
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
@@ -3425,12 +3412,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 
 	parent = parent_mem_cgroup(memcg);
 	memcg_reparent_list_lrus(memcg, parent);
-
-	/*
-	 * Objcg's reparenting must be after list_lru's, make sure list_lru
-	 * helpers won't use parent's list_lru until child is drained.
-	 */
-	memcg_reparent_objcgs(memcg, parent);
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -3931,9 +3912,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct obj_cgroup *objcg;
 
-	if (memcg_online_kmem(memcg))
-		goto remove_id;
+	memcg_online_kmem(memcg);
 
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
@@ -3943,6 +3924,15 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
 
+	objcg = obj_cgroup_alloc();
+	if (!objcg)
+		goto free_shrinker;
+
+	objcg->memcg = memcg;
+	rcu_assign_pointer(memcg->objcg, objcg);
+	obj_cgroup_get(objcg);
+	memcg->orig_objcg = objcg;
+
 	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
 		queue_delayed_work(system_dfl_wq, &stats_flush_dwork,
 				   FLUSH_TIME);
@@ -3965,9 +3955,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
 
 	return 0;
+free_shrinker:
+	free_shrinker_info(memcg);
 offline_kmem:
 	memcg_offline_kmem(memcg);
-remove_id:
 	mem_cgroup_private_id_remove(memcg);
 	return -ENOMEM;
 }
@@ -3985,6 +3976,12 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	memcg_offline_kmem(memcg);
 	reparent_deferred_split_queue(memcg);
+	/*
+	 * The reparenting of objcg must be after the reparenting of the
+	 * list_lru and deferred_split_queue above, which ensures that they will
+	 * not mistakenly get the parent list_lru and deferred_split_queue.
+	 */
+	memcg_reparent_objcgs(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
-- 
2.20.1


