Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1A8CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1036B00B7; Fri, 26 Jun 2026 06:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98996B00BD; Fri, 26 Jun 2026 06:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE706B00BF; Fri, 26 Jun 2026 06:29:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82C316B00B7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:29:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 118521C29F3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:29:48 +0000 (UTC)
X-FDA: 84921692856.29.1880AD4
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2F33F1C0008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:29:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782469786;
	b=EG2cZyKvqWBtPa1/69pxGoIsmmYH56caiib0QDTrcrN6YAVIwELEizB1nc+K6oCnKNU04T
	1BLxIsCNBEkZEwkaIsfKdddDE/lIF3254Ww/p+id2w1VS1GbrTMbMGFDuNvPX36zyBhRo+
	XDiwamw2lRsx+UOzVlaufpUcOql+TLU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782469786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=34FoDelv9uCpdyMKN831tcAvKj3F5ZwytacFyBF3Xfg=;
	b=iv2IPa0Sn+rWuT/UFLEF5hlLNzSQGAOXnUxmZoaYifJuvCi2FszwtHNpf8g27pO6GJTpn1
	wlUV+vn1XfkwXKTk3Nv91Pzf01cJMhrN1sWUTYQ0oIk53Gu2Twfc5T3f+hbpxy769lz0T+
	r8fUSg7KkE/LtVXOJ2b2LPkRyQK16kY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 0ACD21F65B;
	Fri, 26 Jun 2026 10:29:39 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 5/9] mm: memcontrol: track MEMCG_KMEM per NUMA node
Date: Fri, 26 Jun 2026 12:20:54 +0200
Message-ID: <20260626102358.1603618-6-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGdhs9xuqAzUROmmsJvsJjXlJZ0qeTIQWv1SwQGarWmGYIa0sFgvk5TpQ9jfrltusvZoPk8YdWn3PZEEalLBjdfHMe7NqNuZrhxSoChbVpy5Nep8byl3DHWVqDvp22mXFzlNO8942ydLlAkQ+L6aO+eIgnDvtvprJXn6Gk9sJGXK+ptPbEvnkFg0hCg1QwOx0jFi2oA3CD11zGmtPZ3Qj90hnJeuAwCdkM5UQT74WjOHTYJqjH6/g55DRp4gxglIvoWlT1Dy8heeGbvllTWUsmkWwtaP9Gq6rx1FN35MPiV+ZgrCHBylug5kSysqz4Bd4NnZNgsc26P0Z686fWBs04NmhDwJhRVUM511DOXL7IqzWPOEjEgB/QpJP6wf7Ur6bAZjKtcFUzy3c7uwImkbKgeFMzFpKuZTmoRC5EfVKrmvyqU8R4oK2AWp8fY+l9ov3UtyvlcviFq6iZwIRQv0dRr0H080tw081br9wjabs/4DorJCqi3zz2rKa40PV7BmVrpQVPEUQJD+UFXwROdU0MvLAyhWUKDyLJakdHOQdFCWxPJgpjMKTKj4/4OArD7AD86mZ87p7kz/z0WJFDaDvzk5KMgxRdDMJG1WY5B+ciyUyqtiDasAbdicuGnw8yF0b2KdSqUTsZybjqcHuXD7V17cgJ1q9CRxPXBghnegPIVJQ
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F33F1C0008
X-Rspam-User: 
X-Stat-Signature: w9chw6sqxkxog1zysgoub8f4i439xopw
X-HE-Tag: 1782469785-249222
X-HE-Meta: U2FsdGVkX18hlK+VHxiGdZG88w6m/KwNbU3UsMuQG1YbPiqpKFpsHfvc+I1FZMTTobZyrN8HjdX+gJdpEejBd1ddX4M7zKGrmFAAYe27KcDcKyHMxvKRSXzexJZ4Zc/LEwk5pccIQjQuNp9ewviQ4lAtYOjQVmDal9rNeDoNpT/OrBGfSTdaXqw0Nq4Ciiyhsn8zdhhO5CoB0X7YP0tijTux4K1PEX3m/HXfE3ri0ZZmlsUvuNCjx1bZuTh5og/NmJyG70z11IWzb5p/8UdbQXqNBQKnL/YT1/6cLwLUF5K632bpl/YuZTN9xTl+yPkwHtiEugUW0zGvWQrwGCC6E/9ufe+h/nadaeZuJtDiNUu6pJzjt3sKFHhLaLBJlfuyfVMMpQS1AHpdqQM6QwhKs7+vEfdeGyaZiu4Zs22uefGesnnecnCQjWTUrzOPCpsae5zEazEn4j5KiDKCkFXFQdWMvj7lmdsH0A5d0ZlbXJxYZdRTlNgQH3UpjxjtnkfIUmsykHpetThJAYedK5Z7GJ6R8oebk1QPR2qQxHxGzxt+Y0OHFbRS6Heqh+SnJijebSJp6TA+JoTT/+Tj+OX3sH8NdJEwAKaCyWgOy6X8xZIakWLOILEAs/pX6To2SiTIB/6YDxLc1Gkc3pZF3NzA8SRKU3GmwImuOXGbKFMPYgJaU8E1x5HsWQ9pB3d0jXUIHo1srj+v64u2y1vlA7sLjK905EGiGCa7uli5fYOawW7sC2wHIM6/t+uPF7I/msu6QVqPinmDb4A5O8oqPSVTtyEu9OgaiUmoPg2ixV0hAexCkIaG+UkxkaVVEh5CTdc+NCmWwGUQqJOFbCjmZZ3tUzbbdkyQX/r2RML1fg45Wbzu5NMHlbEGjPoIQirCOQ+O8wl0hxLAkXDhw6vvSRD8dbLMfbV6LiuNBXgw17Ludv40C0KVF83BhKyhK1POT0G+tVIWns6CCLaHo5wWIau
 ZZiO07f8
 HhAMdfvT9B/2VSM6tBTG7/qoylxdEe8HbqdW+3DTey/5MKRJBd8OzrnrycQ==
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
 include/linux/memcontrol.h | 19 +++++++----
 include/linux/mmzone.h     |  1 +
 mm/memcontrol.c            | 64 ++++++++++++++++++++++++--------------
 mm/vmstat.c                |  1 +
 4 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8f419ee54510..a60fa197a973 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -36,7 +36,6 @@ enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
@@ -127,9 +126,10 @@ struct mem_cgroup_per_node {
 	struct list_head objcg_list;
 
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-	/* slab stats for nmi context */
+	/* slab and kmem stats for nmi context */
 	atomic_t		slab_reclaimable;
 	atomic_t		slab_unreclaimable;
+	atomic_t		kmem;
 #endif
 };
 
@@ -191,6 +191,7 @@ struct obj_cgroup {
 		struct rcu_head rcu;
 	};
 	bool is_root;
+	int nid;
 };
 
 /*
@@ -255,10 +256,6 @@ struct mem_cgroup {
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
 	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
 
-#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-	/* MEMCG_KMEM for nmi context */
-	atomic_t		kmem_stat;
-#endif
 	/*
 	 * Hint of reclaim pressure for socket memroy management. Note
 	 * that this indicator should NOT be used in legacy cgroup mode
@@ -773,6 +770,16 @@ static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 		percpu_ref_put(&objcg->refcnt);
 }
 
+static inline struct obj_cgroup *obj_cgroup_nid(struct obj_cgroup *objcg,
+						int nid)
+{
+	struct mem_cgroup *memcg = obj_cgroup_memcg(objcg);
+
+	/* Borrowed RCU lookup: takes no reference, caller must hold RCU. */
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return rcu_dereference(memcg->nodeinfo[nid]->objcg);
+}
+
 static inline bool mem_cgroup_tryget(struct mem_cgroup *memcg)
 {
 	return !memcg || css_tryget(&memcg->css);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..753fdf9dc80f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -327,6 +327,7 @@ enum node_stat_item {
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
+	NR_KMEM,
 	NR_BALLOON_PAGES,
 	NR_KERNEL_FILE_PAGES,
 	NR_GPU_ACTIVE,	/* Pages assigned to GPU objects */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 480fba12a217..c6a0d8463400 100644
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
@@ -1546,7 +1549,7 @@ struct memory_stat {
 static const struct memory_stat memory_stats[] = {
 	{ "anon",			NR_ANON_MAPPED			},
 	{ "file",			NR_FILE_PAGES			},
-	{ "kernel",			MEMCG_KMEM			},
+	{ "kernel",			NR_KMEM				},
 	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
 	{ "pagetables",			NR_PAGETABLE			},
 	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
@@ -3052,20 +3055,26 @@ struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
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
 		__css_rstat_updated(&memcg->css, smp_processor_id());
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
 
@@ -3081,7 +3090,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	account_kmem_nmi_safe(memcg, -nr_pages);
+	account_kmem_nmi_safe(memcg, objcg->nid, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
 	if (!mem_cgroup_is_root(memcg))
 		refill_stock(memcg, nr_pages);
@@ -3109,7 +3118,7 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 	if (ret)
 		goto out;
 
-	account_kmem_nmi_safe(memcg, nr_pages);
+	account_kmem_nmi_safe(memcg, objcg->nid, nr_pages);
 	memcg1_account_kmem(memcg, nr_pages);
 out:
 	css_put(&memcg->css);
@@ -3337,10 +3346,11 @@ static void drain_obj_stock_slot(struct obj_stock_pcp *stock, int i)
 
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
@@ -3349,7 +3359,7 @@ static void drain_obj_stock_slot(struct obj_stock_pcp *stock, int i)
 		}
 
 		/*
-		 * The leftover is flushed to the centralized per-memcg value.
+		 * The leftover is flushed to the per-node per-memcg value.
 		 * On the next attempt to refill obj stock it will be moved
 		 * to a per-cpu stock (probably, on an other CPU), see
 		 * refill_obj_stock().
@@ -3548,7 +3558,7 @@ void obj_cgroup_account_kmem(struct obj_cgroup *objcg, unsigned int nr_pages)
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	account_kmem_nmi_safe(memcg, nr_pages);
+	account_kmem_nmi_safe(memcg, objcg->nid, nr_pages);
 	memcg1_account_kmem(memcg, nr_pages);
 	rcu_read_unlock();
 }
@@ -4302,6 +4312,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 		if (unlikely(mem_cgroup_is_root(memcg)))
 			objcg->is_root = true;
 
+		objcg->nid = nid;
 		objcg->memcg = memcg;
 		rcu_assign_pointer(memcg->nodeinfo[nid]->objcg, objcg);
 		obj_cgroup_get(objcg);
@@ -4505,15 +4516,6 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
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
@@ -4544,6 +4546,18 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
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
@@ -5332,7 +5346,9 @@ static void uncharge_batch(const struct uncharge_gather *ug)
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


