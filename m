Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A1C606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01E056B05BA; Wed, 28 Oct 2026 22:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10D36B05BB; Wed, 28 Oct 2026 22:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E7D6B05BC; Wed, 28 Oct 2026 22:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD6126B05BA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:29:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48B241A02DA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:29:27 +0000 (UTC)
X-FDA: 85374082374.18.7A7D814
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf14.hostedemail.com (Postfix) with ESMTP id B612F100002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:29:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf14.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793240965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SNAZgMWdago4QF2GOz0W0+f73cppO6R0b/wUNfoa/VU=;
	b=RFWUfKVqYIyoqXpmVU48cVqqYan6++9kMp7DtfYiDicR3o+25vz8sX3q2jeoUe4PFl+erg
	XjcCjgzRJ9e/csphpAgZgtOAGm3kKVxEYv79CIrzUqtSomm+OgHz+a5PNZdAPHIJm0t6AK
	GvXY30LSeNJBt16t+KGbc+I93tcLTI8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf14.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793240965;
	b=Lw9WjUZZ60JmCHW2WNqx7gOZdHpL5DFBTYt2FtLjYSYLYLsolqmB96kMR64GFh4XHYiafa
	ru/jJ1FoVszC/yjZnXlBFaCNd0nKX9uPA5NPR4FE3j9MesB9h/v9Yo/swK8A/jROeJQV2z
	q0J6UspxV2VGi3L7h+IoOzyBZmghWBw=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSq470Xhz171Yr;
	Thu, 29 Oct 2026 10:29:20 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSq32bswz171Yp;
	Thu, 29 Oct 2026 10:29:19 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 0AC65314AC01;
	Thu, 29 Oct 2026 10:28:56 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:29:17 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
	<vincent.guittot@linaro.org>, Chen Yu <yu.c.chen@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>
CC: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Phil Auld
	<pauld@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, <maddy@linux.ibm.com>, Michael Ellerman
	<mpe@ellerman.id.au>, <ljs@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>
Subject: [RFC PATCH v3 05/17] sched/topology: Walk LLCs in NUMA node
Date: Thu, 29 Oct 2026 10:20:23 +0800
Message-ID: <20261029022036.4002331-6-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B612F100002
X-Stat-Signature: cr3gr1y1pexyfh38zw9azoj46j46k787
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793240964-618484
X-HE-Meta: U2FsdGVkX187xP/t+U05mTU4L2I0wx0gBv0uETklfGuXeTZ9luiyUySfYHMEwsdjPr6FcBiFpXOpZwd3x3QPvbrLtDLzTz4XsAQJbtcBiWIXkUQR3yH0SdQJ8E3HfCt8o7d9st6eMlwkhqjSnN+k+rWEWsP/QZD5wFBnUE7vupFk/MqbXrh3ngd1hAh9u4XD3SNELx4Lcwf46CUTQrNepT5JfQctv1SoGKlVXpj+x4YIdIKO6hgDxV6sipFOE5NrRTQREDkQPb+JnQBcRDohvzsQIP2HLRVof9UlXi0t0iA/rZ4Z0zYeOrNxsj+Uh7uqrup8ZiQElzLAca7MJdxcIjh4szUbSN8y3A5DF6omCNOkx+FbMOzxAW1Nh/PyrFYLetOKC6vgIQtYFob14MgIwut3LNregn3Xyh5MlczH+j79aaCr18xtuKS6oxVtS2o0eyRUnAypKCz2eHFy/b3UCkcZk9QCvGzn50mHdFry+lFhZtLHLkvX2+cBNHcg9/ZaBZf3BiyohFH/kqpnQAWtx49ZwGYiNVG9eJzXeh8QGDy4TX7tYNGXZO/J2LyJ2BVcCrttmXythB8Vg1rr+jM5Ae7BZCGu6SS2Vx3rUZcnjoRjPPNRBCqEqy+8uzF+DsziUYUWabIdG1IPUNakdNAmyrfrOjwxa6oETarCIox3BZ73WwT1NHbkwWvEQUB1euk8X2vQbqyBkfmt3LRKyI4zR7MeQamEByiEdadCa7gjLz5hGIvArSmhne+5y2SqmA9vDo0quyic+gu4RtaN8+yN34CEb1JP31m1R5ciikFK0gMdLST0wPVj2UIfbYej//wu5mmbNQeo6WSIWJbA8Y5p8+bPve4+NCOk+clLW+PN9x7GKBnPPlNG0fiO2lKab4CG/k6tgFyJjYJ/NZ+OeaD0T4ny20TXw+t4ym+37SovB9W2XjsGLs7iHKYbCIvEFIchMW+Wkh2143BMpBLPao0
 KOWYhlno
 tim73cOblbl5xd2CbxRmf/jO/PqHPX7lsEiA1aQ0IHRHCa9ng1ztjKDTPinLRX14/gLf1qaTBv7IpycvBfQvxUNud0Os46hxLVJT54wzrNhYVeNglXukQvsI+EQeBBEPsGeUpbGqvrougvVjQwLxiJd0hz54VYZq/NbLX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Cache-aware scheduling needs to walk the LLCs of a NUMA node, either by
LLC ID or by their CPU spans. The existing LLC-to-node map records each
LLC's node and rank, but does not provide a direct per-node walk.

Store LLC IDs grouped by node in ascending ID order and cache each LLC's
CPU span in the RCU-published map. Add iterators for both forms of
traversal; the span iterator skips empty spans, and both keep the map
alive throughout the walk.

Refresh the map after CPUs are attached to or detached from root domains.
Also refresh it when a CPU gives up an LLC ID even if another CPU still
holds that ID, so the cached spans reflect the current load-balanced CPUs.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/sched.h    |  37 +++++++++++
 kernel/sched/topology.c | 134 ++++++++++++++++++++++++++++++++++------
 2 files changed, 153 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b114b7cc813f..dec697c6a283 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4141,6 +4141,43 @@ sched_cache_numa_key_cmp(struct sched_cache_numa_key a,
 	return 0;
 }
 
+struct llc_node_iter {
+	const int *llc;
+	int nr;
+	int index;
+};
+
+/* Walk the LLC IDs of a node in ascending order under one RCU snapshot. */
+extern struct llc_node_iter llc_node_iter_begin(int node);
+extern int llc_node_iter_next(struct llc_node_iter *iter);
+
+#define for_each_llc_of_node(llc, node)					\
+	scoped_guard(rcu)						\
+		for (struct llc_node_iter __ln_iter =			\
+			     llc_node_iter_begin(node);			\
+		     ((llc) = llc_node_iter_next(&__ln_iter)) >= 0;)
+
+struct llc_node_span_iter {
+	const int *llc;
+	const void *span;
+	int nr;
+	int index;
+};
+
+/* Hold RCU continuously from begin() through the final next() call. */
+extern struct llc_node_span_iter llc_node_span_begin(int node);
+extern const struct cpumask *llc_node_span_next(struct llc_node_span_iter *iter);
+
+/*
+ * Visit @node's LLC spans in ascending LLC ID order. Empty spans are skipped.
+ * The body must not sleep.
+ */
+#define for_each_llc_node_span(node, span)					\
+	scoped_guard(rcu)							\
+		for (struct llc_node_span_iter __ls_iter =			\
+			     llc_node_span_begin(node);			\
+		     ((span) = llc_node_span_next(&__ls_iter)) != NULL;)
+
 struct affi_node_order_iter {
 	const int *order;
 	int root;
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 512a9762b9a2..37f1eeae9b7b 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -698,14 +698,22 @@ struct llc_node_map {
 	int nr_llc;
 	int nr_node;
 	int *rank;		/* [nr_llc]: ascending LLC ID rank within its node */
+	int *node_llc;		/* [nr_llc]: IDs grouped by node, in rank order */
 	int *offset;		/* [nr_llc]: triangular offsets, grouped by node */
 	int *inverse;		/* [nr_llc]: position of each offset */
 	int *node_count;	/* [nr_node]: number of LLCs in each node */
-	int *node_offset;	/* [nr_node]: start of each node's offset slice */
+	int *node_offset;	/* [nr_node]: start of each node's LLC/offset slice */
+	void *span;		/* cpumask_size() bytes per LLC ID */
 	/* One allocation contains node[] and all the arrays above. */
 	int node[];
 };
 
+/* The span array holds cpumask_size() bytes per LLC; never index it with []. */
+static inline struct cpumask *llc_span_at(const void *span, int llc)
+{
+	return (void *)span + (size_t)llc * cpumask_size();
+}
+
 static struct llc_node_map __rcu *llc_to_node_map;
 static void rebuild_llc_node_map(int size);
 
@@ -935,25 +943,33 @@ static void build_llc_offsets(struct llc_node_map *map)
 static void rebuild_llc_node_map(int size)
 {
 	struct llc_node_map *new_map, *old_map;
-	size_t entries;
+	size_t entries, span_off;
 	int cpu, llc, node;
 
 	lockdep_assert_held(&sched_domains_mutex);
 	if (size <= 0)
 		goto fail;
 
-	entries = size_add(size_mul(size, 4), size_mul(nr_node_ids, 2));
-	new_map = kzalloc(struct_size(new_map, node, entries), GFP_KERNEL);
+	entries = size_add(size_mul(size, 5), size_mul(nr_node_ids, 2));
+	span_off = struct_size(new_map, node, entries);
+	if (span_off == SIZE_MAX)
+		goto fail;
+	span_off = ALIGN(span_off, sizeof(unsigned long));
+	/* The spans grow with nr_llc * nr_cpu_ids; avoid high-order kmalloc. */
+	new_map = kvzalloc(size_add(span_off, size_mul(size, cpumask_size())),
+			   GFP_KERNEL);
 	if (!new_map)
 		goto fail;
 
 	new_map->nr_llc = size;
 	new_map->nr_node = nr_node_ids;
 	new_map->rank = new_map->node + size;
-	new_map->offset = new_map->rank + size;
+	new_map->node_llc = new_map->rank + size;
+	new_map->offset = new_map->node_llc + size;
 	new_map->inverse = new_map->offset + size;
 	new_map->node_count = new_map->inverse + size;
 	new_map->node_offset = new_map->node_count + nr_node_ids;
+	new_map->span = (void *)new_map + span_off;
 	for (llc = 0; llc < size; llc++) {
 		new_map->node[llc] = NUMA_NO_NODE;
 		new_map->rank[llc] = -1;
@@ -962,17 +978,23 @@ static void rebuild_llc_node_map(int size)
 	/*
 	 * for_each_possible_cpu() revisits the same LLC non-consecutively
 	 * under SMT (each node's LLCs are walked once per thread), so
-	 * dedup by populated node entries, not by comparing against the
-	 * immediately preceding CPU's llc.
+	 * assign the node once by checking populated node entries, not by
+	 * comparing against the immediately preceding CPU's llc.
 	 */
 	for_each_possible_cpu(cpu) {
 		llc = per_cpu(sd_llc_id, cpu);
-		if (llc < 0 || llc >= size || new_map->node[llc] >= 0)
+		if (llc < 0 || llc >= size)
 			continue;
-		node = cpu_to_node(cpu);
-		if (node < 0 || node >= new_map->nr_node || !node_possible(node))
-			continue;
-		new_map->node[llc] = node;
+		if (new_map->node[llc] < 0) {
+			node = cpu_to_node(cpu);
+			if (node < 0 || node >= new_map->nr_node ||
+			    !node_possible(node))
+				continue;
+			new_map->node[llc] = node;
+		}
+		/* CPUs detached from load-balanced domains keep their LLC IDs. */
+		if (cpu_rq(cpu)->rd != &def_root_domain)
+			cpumask_set_cpu(cpu, llc_span_at(new_map->span, llc));
 	}
 
 	/* Rank LLCs by ascending ID, independently of CPU enumeration order. */
@@ -984,6 +1006,12 @@ static void rebuild_llc_node_map(int size)
 	for (node = 1; node < new_map->nr_node; node++)
 		new_map->node_offset[node] = new_map->node_offset[node - 1] +
 					     new_map->node_count[node - 1];
+	for (llc = 0; llc < size; llc++) {
+		node = new_map->node[llc];
+		if (node >= 0)
+			new_map->node_llc[new_map->node_offset[node] +
+					  new_map->rank[llc]] = llc;
+	}
 	build_llc_offsets(new_map);
 
 publish:
@@ -2464,6 +2492,69 @@ const struct cpumask *tl_mc_mask(struct sched_domain_topology_level *tl, int cpu
 
 #define llc_mask(cpu) arch_llc_mask(cpu)
 
+#ifdef CONFIG_SCHED_CACHE
+/* The iterator's LLC slice remains valid throughout the caller's RCU scope. */
+struct llc_node_iter llc_node_iter_begin(int node)
+{
+	struct llc_node_iter iter = {};
+	struct llc_node_map *map;
+
+	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(), "LLC walk without RCU");
+	map = rcu_dereference_all(llc_to_node_map);
+	if (!map || node < 0 || node >= map->nr_node)
+		return iter;
+
+	iter.nr = map->node_count[node];
+	iter.llc = map->node_llc + map->node_offset[node];
+	return iter;
+}
+
+int llc_node_iter_next(struct llc_node_iter *iter)
+{
+	if (iter->index >= iter->nr)
+		return -1;
+
+	return iter->llc[iter->index++];
+}
+
+/* The iterator's arrays remain valid throughout the caller's RCU scope. */
+struct llc_node_span_iter llc_node_span_begin(int node)
+{
+	struct llc_node_span_iter iter = {};
+	struct llc_node_map *map;
+	int base;
+
+	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(), "LLC span read without RCU");
+	map = rcu_dereference_all(llc_to_node_map);
+	if (!map || node < 0 || node >= map->nr_node)
+		return iter;
+
+	base = map->node_offset[node];
+	iter.nr = map->node_count[node];
+	iter.llc = map->node_llc + base;
+	iter.span = map->span;
+
+	return iter;
+}
+
+const struct cpumask *llc_node_span_next(struct llc_node_span_iter *iter)
+{
+	const struct cpumask *span;
+	int llc;
+
+	while (iter->index < iter->nr) {
+		llc = iter->llc[iter->index++];
+		span = llc_span_at(iter->span, llc);
+		if (cpumask_empty(span))
+			continue;
+
+		return span;
+	}
+
+	return NULL;
+}
+#endif /* CONFIG_SCHED_CACHE */
+
 const struct cpumask *tl_pkg_mask(struct sched_domain_topology_level *tl, int cpu)
 {
 	return cpu_node_mask(cpu);
@@ -3426,7 +3517,7 @@ static int __sched_domains_alloc_llc_id(void)
 	return lid;
 }
 
-/* Return true only when the last CPU releases the LLC ID. */
+/* Return true if @cpu held an LLC ID, whether or not the ID is released. */
 static bool __sched_domains_free_llc_id(int cpu)
 {
 	int i, lid, max;
@@ -3442,7 +3533,7 @@ static bool __sched_domains_free_llc_id(int cpu)
 	for_each_cpu(i, llc_mask(cpu)) {
 		/* An online CPU owns the llc_id. */
 		if (per_cpu(sd_llc_id, i) == lid)
-			return false;
+			return true;
 	}
 
 	__cpumask_clear_cpu(lid, sched_domains_llc_id_allocmask);
@@ -3458,6 +3549,7 @@ void sched_domains_free_llc_id(int cpu)
 {
 	sched_domains_mutex_lock();
 #ifdef CONFIG_SCHED_CACHE
+	/* Drop @cpu from the LLC span even if another CPU still holds the ID. */
 	if (__sched_domains_free_llc_id(cpu))
 		rebuild_llc_node_map(max_lid + 1);
 #else
@@ -3532,10 +3624,6 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 		}
 	}
 
-#ifdef CONFIG_SCHED_CACHE
-	/* The map depends on assigned LLC IDs, not on sd_llc allocations. */
-	rebuild_llc_node_map(max_lid + 1);
-#endif
 	if (WARN_ON(!topology_span_sane(cpu_map)))
 		goto error;
 
@@ -3608,6 +3696,11 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	}
 	rcu_read_unlock();
 
+#ifdef CONFIG_SCHED_CACHE
+	/* LLC spans depend on the root domains just attached. */
+	rebuild_llc_node_map(max_lid + 1);
+#endif
+
 	if (has_asym)
 		static_branch_inc_cpuslocked(&sched_asym_cpucapacity);
 
@@ -3723,6 +3816,11 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)
 	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	rcu_read_unlock();
+
+#ifdef CONFIG_SCHED_CACHE
+	/* Detaching CPUs must also remove them from the published LLC spans. */
+	rebuild_llc_node_map(max_lid + 1);
+#endif
 }
 
 /* handle null as "default" */
-- 
2.34.1



