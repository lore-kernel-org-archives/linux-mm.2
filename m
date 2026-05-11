Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F62CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00366B0088; Mon, 11 May 2026 16:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7446B008A; Mon, 11 May 2026 16:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED8C6B008C; Mon, 11 May 2026 16:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD5836B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:26:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61A871C0727
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:26:10 +0000 (UTC)
X-FDA: 84756270900.05.A8827EA
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf18.hostedemail.com (Postfix) with ESMTP id 766C31C0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:26:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778531168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JP8rHf1qeHZYJnRW7yDeQwcx21Z7I+GtAcwj25/GsYk=;
	b=xk8Zy92S0lsxjPi1rZdZtocH9nQ1xb6f3eqKNjVD5DEaM5FA2cFbFt8Qg58oHrMhXOADbL
	0t5Vu4gIyTZACTtHyxjQczhK107Lwz17jYmYr1W5npTkRkm5YGZHOb5c03fxy7La1jAdT8
	lP59J55uZGUJ7ed0gAdbaAAEXBXEKNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778531168; a=rsa-sha256;
	cv=none;
	b=jXCnNEziBN7cIPVU++q6AWqZGxLlndyfh+u1CIIoWjQxNbmHUKvtnQwGi82clVPxSdtxVj
	8KP84CKlPZhnVfa2MY1vL3/YSoe8i/UpavbYIDqMCRVtIb1BJ3JjuEZB9QUsy17mKlQLir
	7k6JNOCC29D+ZHS3x6YE5Gl22umtnkg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 053FD3ECD9;
	Mon, 11 May 2026 20:26:02 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 4/8] mm: memcontrol: track MEMCG_KMEM per NUMA node
Date: Mon, 11 May 2026 22:20:39 +0200
Message-ID: <20260511202136.330358-5-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511202136.330358-1-alex@ghiti.fr>
References: <20260511202136.330358-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGASuQ7DzVEqE1yqVdt2m1IEMvyeiZ424ZAVS1woSZRBsZRcHOaYxo/wRroa9V549fgoGhwPyYnAfDpxQNFtzkxj0I5TMeBg/5jBppJQkWIBRGnFCdwyKb3+iAwjbc6HCyc2w6Fq1RMe0bJWfA1ndpco4RPwk+ydi46o3tuXnoPGtt57UGuv0fBX6aLFC8egYVKjqd5+b/oNYSj52BJhnje7YewqzwfY3MT59q3IHUZSXd+23dBE9VioRxzwOkioSO0aPH0PeFEsizQ7P2RVgZRWW0PznWL4m6swkEsBSSzcbL/DhTQy/lqZtdEuHj15ch+irNHdmG3iRmpUdYJcCG6UFYwppZMwjrObvHgS58EMHksvqWQIt2KoQM0PZI1xpseSbGrSzDpknKQ+GFdNcw6nOnuQ7+BHS8KOGvpiRrvIYuNxZheuDRqrTykhxMCB4UABVryh8YDbWheFsYjuf47s1ibUxyV/k+zNA2KBvnrWQo+TqY1nHZR1pKRBn4vA1Js2TB6x2+e46F3wkLynXmRZ7UOBPtwrw/U8L6g1VS5gQu7/v9h7bC/QwawE1PkD4NW825qh3+uTm/QJcU5xEOFLVpUaL4Atbgj7z+hHtFPYRb2xCf+4dewwOSer5gMqtqckA2iapVf+FiWW+VV5nGaibP2+vS0guMGZW1Df2SyvQ
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 766C31C0005
X-Rspam-User: 
X-Stat-Signature: qmkxooy54d33ids8ajk1cqd9tb7e7zjd
X-HE-Tag: 1778531168-129703
X-HE-Meta: U2FsdGVkX18uVeIxBpJIc3SJoOTfEsYXndWHrd5ub4bTMdDpQJYCLGGYhcSpabAtx/KhuKHDkhv00W0s5gI8t5y08DxcA/D3vdpv4cmoaPE3+zVAGd28coxR/we/ry+GZLu/G2EN4teLeefXmC4NokcacC2ozOXeJfzD5fbx2mRIf3JK5rqaXSLA5TTaYXCLco6h83IcZ0YC84kz7eQx33PA75aHpdWDhJgik0rVPjULJP+Q/y8lsVpgggiGIX0oU5fpEoV04KNomtbPolbdVj1VPYTJfPGI28bVPuqW0RPDzX+Cf+krTZmY0MzvT0sYEXtR2zaPL+SSWCjoTb2U128xHzozGqPA+cZNPEi3sHlJQi+gDzdyNZAkF0b8fyw1UmhuTOZpgjJXcWCS2N8ApC3esp3wTOs+QHfwdBJbOlPBiIMFiu0JwGnyAZN+S9YOyt0XkVLvRx1QLhjpXuHj05EzTvEvOihXJK1uYPk4LHFs5lLKbIUMvkSAH7OvrQh9BLAbEE7hcH3VNeHGNo7J2M10a1e58bSp1VaKD6ZHiFVaffYXtQBlHbXFWDJd2WCb6Ke19DFcmUU4lXpDZudm8lMTrX6xVBCtsdMXhA7QW+I7hLnMyLEPVDl4ZQRv7/1fhZQgn8gT/mCTEmtn57v3v55bCYhicJjwwA4f8zR9/6WeV8PMnedMDYCgnxOXTXBgNFiWWadvH+NU0reM2XhoZhLR9rHcBFbxBTm6lkAZ5623cfdL2FhV9outIln9Vpu7odJR7b9+/FruEeCB0O6UjWYuQQz8WWC4mfsj8Iwbx9c8qTG+qr1ehoCTx6nceuZRikaoTQI0lbnzGC06uarE9kRv3BhyNk+G2tEn3pPh75DTDsx/Nr1JU0ysdv3mM1XqHjIdutGypL0u9HJSGPtHaaiZFuhd0n2KGKYUuXgqiOIHNnj8qdD2ove6h3qZqhJCw8o/Zc7S2PLfxCD6kbt
 PDEcpgbC
 iVgjJR0wgdZKSuI4h+yRur3f6fQQt10f4GXk43/rkbxMG7jOZ8FT0RK9EAWserb5DUE9cFEp5yP/hKP9TR2bs6hmWD6Wu8ELrAizVz0bxBMqA3Ws1UN6+ePYg8wOht1IMEId7JIhC3PZTbf+J3AtNQFFoM4/77MDIzfvZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch gets rid of MEMCG_KMEM and wires all the "generic" functions
by introducing per-node obj_cgroup objects.

Note that it does not convert the kmem users to proper per-memcg-per-node
accounting now, this is done in upcoming patches.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/memcontrol.h | 23 ++++++++++----
 include/linux/mmzone.h     |  1 +
 mm/memcontrol.c            | 64 ++++++++++++++++++++++++--------------
 mm/vmstat.c                |  1 +
 4 files changed, 59 insertions(+), 30 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 568ab08f42af..17cf823160e4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -35,7 +35,6 @@ enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
@@ -126,9 +125,10 @@ struct mem_cgroup_per_node {
 	struct list_head objcg_list;
 
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-	/* slab stats for nmi context */
+	/* slab and kmem stats for nmi context */
 	atomic_t		slab_reclaimable;
 	atomic_t		slab_unreclaimable;
+	atomic_t		kmem;
 #endif
 };
 
@@ -190,6 +190,7 @@ struct obj_cgroup {
 		struct rcu_head rcu;
 	};
 	bool is_root;
+	int nid;
 };
 
 /*
@@ -254,10 +255,6 @@ struct mem_cgroup {
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
 	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
 
-#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-	/* MEMCG_KMEM for nmi context */
-	atomic_t		kmem_stat;
-#endif
 	/*
 	 * Hint of reclaim pressure for socket memroy management. Note
 	 * that this indicator should NOT be used in legacy cgroup mode
@@ -776,6 +773,20 @@ static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 		percpu_ref_put(&objcg->refcnt);
 }
 
+static inline struct obj_cgroup *obj_cgroup_get_nid(struct obj_cgroup *objcg,
+						    int nid)
+{
+	struct obj_cgroup *nid_objcg;
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	nid_objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
+	rcu_read_unlock();
+
+	return nid_objcg;
+}
+
 static inline bool mem_cgroup_tryget(struct mem_cgroup *memcg)
 {
 	return !memcg || css_tryget(&memcg->css);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da5..97eb168fd7f3 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -326,6 +326,7 @@ enum node_stat_item {
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
+	NR_KMEM,
 	NR_BALLOON_PAGES,
 	NR_KERNEL_FILE_PAGES,
 	NR_GPU_ACTIVE,	/* Pages assigned to GPU objects */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aaaa6a8b9f15..979a847e542a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -136,6 +136,7 @@ bool mem_cgroup_kmem_disabled(void)
 }
 
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
+static void mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx, int val);
 
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
@@ -170,9 +171,11 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 
 	if (nr_pages) {
 		struct mem_cgroup *memcg;
+		struct lruvec *lruvec;
 
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(objcg->nid));
+		mod_lruvec_state(lruvec, NR_KMEM, -nr_pages);
 		memcg1_account_kmem(memcg, -nr_pages);
 		if (!mem_cgroup_is_root(memcg))
 			memcg_uncharge(memcg, nr_pages);
@@ -423,13 +426,13 @@ static const unsigned int memcg_node_stat_items[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
+	NR_KMEM,
 };
 
 static const unsigned int memcg_stat_items[] = {
 	MEMCG_SWAP,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
@@ -1537,7 +1540,7 @@ struct memory_stat {
 static const struct memory_stat memory_stats[] = {
 	{ "anon",			NR_ANON_MAPPED			},
 	{ "file",			NR_FILE_PAGES			},
-	{ "kernel",			MEMCG_KMEM			},
+	{ "kernel",			NR_KMEM				},
 	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
 	{ "pagetables",			NR_PAGETABLE			},
 	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
@@ -3004,20 +3007,26 @@ struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
 }
 
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-static inline void account_kmem_nmi_safe(struct mem_cgroup *memcg, int val)
+static inline void account_kmem_nmi_safe(struct mem_cgroup *memcg, int nid, int val)
 {
 	if (likely(!in_nmi())) {
-		mod_memcg_state(memcg, MEMCG_KMEM, val);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+
+		mod_lruvec_state(lruvec, NR_KMEM, val);
 	} else {
+		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
+
 		/* preemption is disabled in_nmi(). */
 		css_rstat_updated(&memcg->css, smp_processor_id());
-		atomic_add(val, &memcg->kmem_stat);
+		atomic_add(val, &pn->kmem);
 	}
 }
 #else
-static inline void account_kmem_nmi_safe(struct mem_cgroup *memcg, int val)
+static inline void account_kmem_nmi_safe(struct mem_cgroup *memcg, int nid, int val)
 {
-	mod_memcg_state(memcg, MEMCG_KMEM, val);
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+
+	mod_lruvec_state(lruvec, NR_KMEM, val);
 }
 #endif
 
@@ -3033,7 +3042,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	account_kmem_nmi_safe(memcg, -nr_pages);
+	account_kmem_nmi_safe(memcg, objcg->nid, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
 	if (!mem_cgroup_is_root(memcg))
 		refill_stock(memcg, nr_pages);
@@ -3061,7 +3070,7 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 	if (ret)
 		goto out;
 
-	account_kmem_nmi_safe(memcg, nr_pages);
+	account_kmem_nmi_safe(memcg, objcg->nid, nr_pages);
 	memcg1_account_kmem(memcg, nr_pages);
 out:
 	css_put(&memcg->css);
@@ -3238,10 +3247,11 @@ static void drain_obj_stock(struct obj_stock_pcp *stock)
 
 		if (nr_pages) {
 			struct mem_cgroup *memcg;
+			struct lruvec *lruvec;
 
 			memcg = get_mem_cgroup_from_objcg(old);
-
-			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+			lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(old->nid));
+			mod_lruvec_state(lruvec, NR_KMEM, -nr_pages);
 			memcg1_account_kmem(memcg, -nr_pages);
 			if (!mem_cgroup_is_root(memcg))
 				memcg_uncharge(memcg, nr_pages);
@@ -3250,7 +3260,7 @@ static void drain_obj_stock(struct obj_stock_pcp *stock)
 		}
 
 		/*
-		 * The leftover is flushed to the centralized per-memcg value.
+		 * The leftover is flushed to the per-node per-memcg value.
 		 * On the next attempt to refill obj stock it will be moved
 		 * to a per-cpu stock (probably, on an other CPU), see
 		 * refill_obj_stock().
@@ -3417,7 +3427,7 @@ void obj_cgroup_account_kmem(struct obj_cgroup *objcg, unsigned int nr_pages)
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	account_kmem_nmi_safe(memcg, nr_pages);
+	account_kmem_nmi_safe(memcg, objcg->nid, nr_pages);
 	memcg1_account_kmem(memcg, nr_pages);
 	rcu_read_unlock();
 }
@@ -4165,6 +4175,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 		if (unlikely(mem_cgroup_is_root(memcg)))
 			objcg->is_root = true;
 
+		objcg->nid = nid;
 		objcg->memcg = memcg;
 		rcu_assign_pointer(memcg->nodeinfo[nid]->objcg, objcg);
 		obj_cgroup_get(objcg);
@@ -4369,15 +4380,6 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 {
 	int nid;
 
-	if (atomic_read(&memcg->kmem_stat)) {
-		int kmem = atomic_xchg(&memcg->kmem_stat, 0);
-		int index = memcg_stats_index(MEMCG_KMEM);
-
-		memcg->vmstats->state[index] += kmem;
-		if (parent)
-			parent->vmstats->state_pending[index] += kmem;
-	}
-
 	for_each_node_state(nid, N_MEMORY) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 		struct lruvec_stats *lstats = pn->lruvec_stats;
@@ -4408,6 +4410,18 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
+		if (atomic_read(&pn->kmem)) {
+			int kmem = atomic_xchg(&pn->kmem, 0);
+			int index = memcg_stats_index(NR_KMEM);
+
+			mod_node_page_state(NODE_DATA(nid), NR_KMEM, kmem);
+			lstats->state[index] += kmem;
+			memcg->vmstats->state[index] += kmem;
+			if (plstats)
+				plstats->state_pending[index] += kmem;
+			if (parent)
+				parent->vmstats->state_pending[index] += kmem;
+		}
 	}
 }
 #else
@@ -5173,7 +5187,9 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 	if (ug->nr_memory) {
 		memcg_uncharge(memcg, ug->nr_memory);
 		if (ug->nr_kmem) {
-			mod_memcg_state(memcg, MEMCG_KMEM, -ug->nr_kmem);
+			struct lruvec *lruvec =
+				mem_cgroup_lruvec(memcg, NODE_DATA(ug->objcg->nid));
+			mod_lruvec_state(lruvec, NR_KMEM, -ug->nr_kmem);
 			memcg1_account_kmem(memcg, -ug->nr_kmem);
 		}
 		memcg1_oom_recover(memcg);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..d55437d1852e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1293,6 +1293,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
+	[I(NR_KMEM)]				= "nr_kmem",
 	[I(NR_BALLOON_PAGES)]			= "nr_balloon_pages",
 	[I(NR_KERNEL_FILE_PAGES)]		= "nr_kernel_file_pages",
 	[I(NR_GPU_ACTIVE)]			= "nr_gpu_active",
-- 
2.54.0


