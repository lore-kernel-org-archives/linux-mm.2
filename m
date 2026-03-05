Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4BAF30950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 073986B009B; Thu,  5 Mar 2026 06:55:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A6A6B009D; Thu,  5 Mar 2026 06:55:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F066B009E; Thu,  5 Mar 2026 06:55:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6F0F6B009B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:55:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 962E7BBC4D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:55:11 +0000 (UTC)
X-FDA: 84511853622.22.0DD97FC
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id C701318000D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:55:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EHiZT0m1;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5rM3hQDqpUHUQyzUXFcLhuGKQoF0cAvo8SOoxm2ygg=;
	b=t9z/xumfyjNqNCPuKbGME//Of1NPylInVC2zSMCLwluF1ikBPpY7r9DovGsjPJXNAqo7f/
	7h3vHh7Td5N/GmPpGHwLIhrVFdFCKlDMcHb8INYXRTr7qWvzJT/e69KkpTRUD4JT7V9EiN
	Ie/pxCcmi+6aMNhgq98tK9zfgNsE0zY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EHiZT0m1;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711710; a=rsa-sha256;
	cv=none;
	b=aKLvpQsYJc9YU9vlSOk/HG3Or3AwF1Nx8d/XwUKSNmT+iqrb3Gsnw+27YE0qEPxKbjc1MV
	aL9IeuPgExWCuKym67VPUrWe7qYeRG0oogOWEgigHTtnR3QRv+7I9LiZgLQdas2eLBEWls
	LPcfmNWVTF6Upf5TXbF1hA+QuDCxAos=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n5rM3hQDqpUHUQyzUXFcLhuGKQoF0cAvo8SOoxm2ygg=;
	b=EHiZT0m1ECW8ox899R8iliXjZOJ/dD5ofGIxpwnahXjLK7nGEq2KPAT8hIpVKLSkfd3XMV
	1zfY7VUYw1qKkg0kJQFPnHTzUzwtkcCH4LtE1a1F0+ZdN4Jv+Hvi0SnTsHO7YhmUjT403a
	0vA3DqXIPQvYqmbULJwouIywxjhB0IY=
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
Subject: [PATCH v6 06/33] mm: memcontrol: allocate object cgroup for non-kmem case
Date: Thu,  5 Mar 2026 19:52:24 +0800
Message-ID: <b77274aa8e3f37c419bedf4782943fd5885dda82.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ziozck3huphi9mst7buiouapxznqjymf
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C701318000D
X-HE-Tag: 1772711709-342033
X-HE-Meta: U2FsdGVkX18cnQNLzKfdAlc80B9GNKGkt5Ww7vdrJLF3QTAQR8Th+zW7tWKCziOjSl6V1RN7nrBlxknXNwRYpBxsuY9Ru3QK4/M4OozVa+c30RGJ7IconeaLjFS+0wBrqu5cM4GsevQc+0gkWbkf8DEyack1kkOtPBcXrCnRLSK/S8MLpswEkIG22gY/Hno0sqxMPK++bazppuN4uVphb9zdYjv+awlbXqQOYY+GkZ+D3uYT+lKJ+emRIlSuKki6uJWJYJwNL1o/3nG4gMi9UTRCbF8a3vwHgxFpYH1pUoXAloy2z2wfxk/xa2GMDTVo/8SuRtIao6rRXip1AhbJG3HXGJ8adBSNqX2TvN+uWice8KizMYWCYwYPB2iXYtIxxI7GEcLODhTeGOqgoojea/f3c+stlkWyS4oM1vo6YBj/n5MxK7tBf/rhZA6pXg4px3N5coH86tYZ21URKmfPXQY3X9et/23NX0cnBoTn5oSMooKIHFDeZ1lmJ++GIIox8JQsut8S1n8yBNw28mysDcsypwGyhZ+Rh6txlQ6APOiHRSx3e86bevY//ltV1JhVSEOWsF2erpvHCydMuz9p//jIJrAGWqgi71m6wXcH/9f8DdOY2Mct/UQeY+XFsw4QwEr2BDUhtn3gp8p3iVlzll/6HD5mllpuCNXY2GVF/h02Mfx/pZweZc1dUnKaMXNISMAYkAr+HiBgGl2WzJMknDHUQCds73Ye2P794gyoyH48fFhEz9pPU6t99gynOh/zvZg+iE8SUIUwPYIfpCrIsQ23jCK4Z7+ZPxUR/FROnDYjyKWqTXgYPA+G0iBwYuH+QAgFIXAl5o25hFZ9ig36RXW2O88Rmxzv1o9ZpaDqu2CRQIkxnVACWkq+57UG3ERR9TvQZkCncvmU0FlBq/iJ77N553mAvGaG7skHjEUQNidvdFOmr8isgGtDrZ/TgABw6g2iOn4aQSj074wZfA/
 yWT5ZgDw
 LNkwhWOnigKeGh+5SaezZlGC8+Wh1bF09jfg0mTxiSJcxZVch3zc8lZOv3UhfK3ii/BdQEPNSQf8XcdMNTBW9+4i7X5pQgik+tXxCSRHk1s88WE9q/6haTeUnJcmHmOyoyk730nZREAbKsxeGni8L8cIm6DWC4V6gdipneim2oOghVlmUtHEJ5w3z71CIh0X0E/hsn5KOk5G1iAykm70bbg+WOdOWEl66hs1wgrbBa1sBxl8K3qaOFoPcUm8GMAtxWTfspt++7HzefHFgmRTQ9LUqZVs04oc+yvbk
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


