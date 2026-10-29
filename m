Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57C6606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D623A6B05B6; Wed, 28 Oct 2026 22:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39746B05B7; Wed, 28 Oct 2026 22:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FB26B05B8; Wed, 28 Oct 2026 22:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98F6C6B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:27:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28DFFA75A0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:27:53 +0000 (UTC)
X-FDA: 85374078426.26.C729CE3
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf15.hostedemail.com (Postfix) with ESMTP id D8175A0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:27:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf15.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793240870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cIqXubhfvQ0epaWyz6DKO9ldyOApfI9geSDy6/6YGp4=;
	b=7WyVelAQdB0cqjynBPFJqzWbbCuB104Q0HceK/Cngn+M547U3aFUU1eow8tDqOddQbX8RR
	nm77YzZuRI8JHcFcfvHzDZ3m/TVkP5VMOZAPWrLJ3tPLV5x2F09Z2ypiWJPPzP7q7P/Sc8
	xQDQ7u/pI0PrWHDqMlqN1pzrSLN1eFE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf15.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793240870;
	b=1jrxqnFReAxUeGRieSIUpqTtUO0glDemtOiI2XktMG0JJ8BMoAiNMLnUO8tEItdY1kI2BZ
	pLJZufsV8U0PIh9RYZJhquR5IJ7adsWZddRdYXvQaWW9NXWOhXhK7rl2tqs9mqW2iHdIue
	m4oQDcJnGaMNtrApVTeNutBuDBzR5go=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSn96xhpzwXwL;
	Thu, 29 Oct 2026 10:27:41 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSn94qcNzwXwL;
	Thu, 29 Oct 2026 10:27:41 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 57329314AC01;
	Thu, 29 Oct 2026 10:27:18 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:27:40 +0800
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
Subject: [RFC PATCH v3 02/17] sched/topology: Build NUMA node affinity sequences
Date: Thu, 29 Oct 2026 10:20:20 +0800
Message-ID: <20261029022036.4002331-3-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Queue-Id: D8175A0002
X-Rspam-User: 
X-Stat-Signature: htjx6enfbzg6z67a68e9ww7o7eot6j4o
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793240868-243261
X-HE-Meta: U2FsdGVkX18AzQRu0aFXP2CL1yK5J0hVL2uwZ7b9MPMXayUftrhvxC+BQOITUIidM0aYUR3GRoHuDmiW2nGIkVuZzyf7y6ImaucW+InoeDdwH+l0faH2R1RX3/csY7cf+/BU8AYy23wDocicTg1782TAYlFpB1ZU74Lil5YuqjWXG/91XLbJ+39wyEFnGC0ZBacgYT7c4OpJ4rWM+QjBNgQKiWgZQzI6h6Jc72iXH+uiwVRdXRtyazbi93pZunGd6h0xHP5TT+UlbJ1JoEqHghwdmhyiUZwBo2fiXFeH8gdPQssh7bcgz8ERc8m0+xxMVv5rROPoc1DCYijW80jG98uk4ycyfp0hQ9TuzA4DTIEWrbBTx/mHGmjpylXjOzRFaQYZIYl3jRmSO2QBaLaQ9X+SWoTxQ5RMxC/eRtNvhZq6rTu1uQyWXg+VDCQ/S9bmxpgzRAolKnE364pV+e8Z4MHigu+Jp4ZrFSdQcpFjoSD42sDMvk3NTL71Zh8RcgtfDFilyzW6TDW09S+GcAWDYdDxKo72zl6/7ubsrz+IiwFF5DLWei52qjwSpUh1vTknSRMx+gUq3KhS+P1lKju/iJeMBN8R+C0Ov04A0NU2bkZdjur30CtYeNF8bUZRx2R32ZtGr600mY72t9ey773sCfn8dR70leD6Jk8phBDbsmJQqX/Ck4g1TYj0cO1+F7crXpaCyNueoh+JjDMT3LGT/16DTAIY5v63/TWqGG6NBxSSOIlAuBioWknSOkRhALBzoG8PkShU70D9LOjVPhagNCaXqlh0pcSLW9CFZB/6VB1axKTzC4FLxVOWtZvXyu+sRQXf8Aw7pSwfK7I3ho2IHQmdYOOT/DoQUvDYFvltp81/W7t6XkUODePUhCSpg+IdI9Zd9hpUZ/+bdj7JXzeoOB6z3SkY4TAkIsTv9R1jk4viUKnN7ovUGYk6kBzJ94dhi8hZhm1RqeufpQxcw+x
 2KHLYO4z
 1uNBg436MhIHWOkGBULrPPGIwprvkitoYTGGulZ6tjX9PwpvgUMEnt9hqJV0HBqvV3GG+QrlSLKOYnDtUHaPNaJ0gUHtFSZBsenbpr0z6JXrUem1qBB3hKgw4JGM4gTmLsGUpOfWtXUVp8b6bk5rcDszU8DDw0kK88OoJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Cache-aware scheduling currently aggregates a workload into its preferred
LLC. To accommodate workloads that need more than one LLC, establish an
LLC affinity sequence for each preferred LLC. This sequence will guide
aggregation as the workload expands beyond that LLC.

Since LLCs belong to NUMA nodes, construct the ordering in two levels:
order the NUMA nodes first, then order the LLCs within each node. Build
the NUMA node affinity sequences here; subsequent patches handle the
intra-node LLC ordering.

Call the node containing the preferred LLC the cache-preferred node, to
distinguish it from the preferred node selected by NUMA balancing.

Raw NUMA distance provides the primary ordering, but multiple nodes may
have the same distance from the cache-preferred node. Breaking these ties
by ascending node ID creates a systematic preference for low-ID nodes.
For example, consider four nodes with the following distance matrix:

       N0   N1   N2   N3
  N0   10   20   20   20
  N1   20   10   20   20
  N2   20   20   10   20
  N3   20   20   20   10

Using node IDs to break ties gives these sequences:

  N0: N0 -> N1 -> N2 -> N3
  N1: N1 -> N0 -> N2 -> N3
  N2: N2 -> N0 -> N1 -> N3
  N3: N3 -> N0 -> N1 -> N2

Suppose processes A and B have cache-preferred nodes N2 and N3,
respectively. When both nodes are full and the workloads need to expand,
both processes first prefer N0. They may therefore compete for resources
on N0 while N1 remains idle.

Use a triangular-number permutation to distribute tie-breaking positions
across nodes instead. Let N be the number of possible nodes. Assign them
consecutive ordinals in ascending node ID order, excluding ID holes, and
let p be the cache-preferred node's ordinal. Construct the offsets as:

  M = 2^ceil(log2(N))
  T(i) = i * (i + 1) / 2,             i = 0, ..., M - 1
  R(i) = T(i) % M
  offset = [R(i) for i = 0, ..., M - 1 if R(i) < N]
  sequence[p][j] = (p + offset[j]) % N, j = 0, ..., N - 1

Filtering preserves the original order. The first M triangular numbers
modulo M form a permutation when M is a power of two, so each retained
offset appears exactly once. Convert the resulting ordinals back to node
IDs. Across these cyclically shifted sequences, each node occupies each
position exactly once.

This sequence defines the tie-breaking order, not the final NUMA
ordering. Keep the cache-preferred node first, then sort remote nodes by
raw NUMA distance, using their positions in this sequence to break ties.
The raw distances are not modified. With unequal remote distances, the
final sequences need not retain the positional balance of the underlying
tie-breaking sequences.

For the example above, the offsets are [0, 1, 3, 2], giving:

  N0: N0 -> N1 -> N3 -> N2
  N1: N1 -> N2 -> N0 -> N3
  N2: N2 -> N3 -> N1 -> N0
  N3: N3 -> N0 -> N2 -> N1

If N2 and N3 are full, A skips N3 and expands to N1, while B expands to
N0. This avoids both processes choosing N0 while N1 remains idle. The
construction is a deterministic ordering heuristic, not a guarantee of
minimum contention for every topology or workload.

Build the sequences in sched_init_smp(). powerpc can update its NUMA
distance table at runtime in update_numa_distance(), so bracket that
update with sched_cache_numa_distance_update_begin() and
sched_cache_numa_distance_update_end(), which rebuild the cached
sequences under a mutex to keep them consistent with the raw distances.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 arch/powerpc/mm/numa.c   |   4 +
 include/linux/topology.h |  11 +++
 kernel/sched/core.c      |   1 +
 kernel/sched/sched.h     |  34 +++++++
 kernel/sched/topology.c  | 190 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 240 insertions(+)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index f4cf3ae036de..b2befd6ec448 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -25,6 +25,7 @@
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
+#include <linux/topology.h>
 #include <asm/cputhreads.h>
 #include <asm/sparsemem.h>
 #include <asm/smp.h>
@@ -350,7 +351,10 @@ void update_numa_distance(struct device_node *node)
 		if (!associativity)
 			return;
 
+		/* Keep cached node orders consistent with raw distance updates. */
+		sched_cache_numa_distance_update_begin();
 		initialize_form1_numa_distance(associativity);
+		sched_cache_numa_distance_update_end(true);
 		return;
 	}
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 709a2dcf4c73..22bf14aaa543 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -177,6 +177,17 @@ static inline int cpu_to_mem(int cpu)
 
 #endif	/* [!]CONFIG_HAVE_MEMORYLESS_NODES */
 
+#ifdef CONFIG_SCHED_CACHE
+void sched_cache_init_node_order(void);
+/* Sleepable pair bracketing runtime changes to raw node_distance() data. */
+void sched_cache_numa_distance_update_begin(void);
+void sched_cache_numa_distance_update_end(bool changed);
+#else
+static inline void sched_cache_init_node_order(void) { }
+static inline void sched_cache_numa_distance_update_begin(void) { }
+static inline void sched_cache_numa_distance_update_end(bool changed) { }
+#endif
+
 #if defined(topology_die_id) && defined(topology_die_cpumask)
 #define TOPOLOGY_DIE_SYSFS
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 96226707c2f6..bcf4026e5bd6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8860,6 +8860,7 @@ int sched_cpu_dying(unsigned int cpu)
 void __init sched_init_smp(void)
 {
 	sched_init_numa(NUMA_NO_NODE);
+	sched_cache_init_node_order();
 
 	prandom_init_once(&sched_rnd_state);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4ee223416012..4dba127f1d4f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4109,6 +4109,40 @@ static inline bool sched_cache_enabled(void)
 extern void sched_cache_active_set(void);
 extern int llc_to_node(int llc);
 
+/*
+ * Lexicographic node affinity key. Keep the raw NUMA distance as the first
+ * component: it identifies the distance level without changing its order.
+ * tie_rank is used for tie-break if level equals.
+ */
+struct sched_cache_numa_key {
+	int level;
+	int tie_rank;
+};
+
+/* Both nodes must be valid */
+static inline struct sched_cache_numa_key
+sched_cache_numa_key(int node0, int node1, int tie_rank)
+{
+	return (struct sched_cache_numa_key) {
+		.level = node_distance(node0, node1),
+		.tie_rank = tie_rank,
+	};
+}
+
+static inline int
+sched_cache_numa_key_cmp(struct sched_cache_numa_key a,
+			 struct sched_cache_numa_key b)
+{
+	if (a.level != b.level)
+		return a.level < b.level ? -1 : 1;
+	if (a.tie_rank != b.tie_rank)
+		return a.tie_rank < b.tie_rank ? -1 : 1;
+	return 0;
+}
+
+/* Node IDs in, zero-based rank out; -1 if unavailable or invalid. */
+extern int affi_node_rank_of(int prefer_node, int node);
+
 #endif
 
 void sched_domains_free_llc_id(int cpu);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 18171d2338fe..6b7b38eb7cd3 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -6,6 +6,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/sched/clock.h>
 #include <linux/bsearch.h>
+#include <linux/sort.h>
 #include "sched.h"
 
 DEFINE_MUTEX(sched_domains_mutex);
@@ -701,6 +702,18 @@ struct llc_node_map {
 static struct llc_node_map __rcu *llc_to_node_map;
 static void rebuild_llc_node_map(int size);
 
+struct affi_node_order_topology {
+	struct rcu_head rcu;
+	int size;
+	int nr_nodes;
+	int *rank;
+	int order[];
+};
+
+static struct affi_node_order_topology __rcu *affi_node_order;
+static DEFINE_MUTEX(affi_node_order_mutex);
+static bool affi_node_order_ready;
+
 #endif
 
 static void update_top_cache_domain(int cpu)
@@ -932,6 +945,183 @@ static void rebuild_llc_node_map(int size)
 	goto publish;
 }
 
+struct affi_node_candidate {
+	struct sched_cache_numa_key key;
+	int node;
+};
+
+static int affi_node_candidate_cmp(const void *a, const void *b)
+{
+	const struct affi_node_candidate *ca = a, *cb = b;
+
+	return sched_cache_numa_key_cmp(ca->key, cb->key);
+}
+
+/*
+ * Build a root-relative tie-breaking order for equal-distance NUMA nodes.
+ * Sorting ties by node ID would make different roots consistently prefer
+ * low-ID nodes. Instead, use a permutation of cyclic offsets, shifted by
+ * each root's ordinal among possible nodes.
+ *
+ * Let N = nr_nodes and M be the smallest power of two >= N. Generate:
+ *
+ *   T(i) = i * (i + 1) / 2, i = 0, ..., M - 1
+ *   offset = T(i) % M
+ *
+ * These M residues form a permutation of [0, M). Keep only offsets < N,
+ * preserving their order, to obtain a permutation of [0, N). Using M
+ * rather than N avoids repeated or missing offsets when N is not a
+ * power of two.
+ *
+ * Store the inverse permutation: inverse[offset] is the position of
+ * that offset in the order. For root ordinal p and candidate ordinal q,
+ * the caller uses inverse[(q - p + N) % N] as the tie-breaking rank.
+ * Ordinals are consecutive and exclude holes in the node ID space.
+ *
+ * For N = 4, offsets are [0, 1, 3, 2], giving:
+ *
+ *   root 0: 0, 1, 3, 2
+ *   root 1: 1, 2, 0, 3
+ *   root 2: 2, 3, 1, 0
+ *   root 3: 3, 0, 2, 1
+ *
+ * Each ordinal occupies each position once across these shifted orders.
+ * Raw NUMA distance remains the primary sort key; this rank only breaks
+ * ties. Thus the final distance-sorted rows need not retain that balance.
+ */
+static void build_numa_tie_ranks(int *inverse, unsigned int nr_nodes)
+{
+	unsigned int mod = 1, pos = 0, i, rank = 0;
+
+	while (mod < nr_nodes)
+		mod <<= 1;
+	for (i = 0; i < mod; i++) {
+		if (pos < nr_nodes)
+			inverse[pos] = rank++;
+		pos = (pos + i + 1) & (mod - 1);
+	}
+}
+
+/* Possible nodes include CPU-less nodes and exclude node ID holes. */
+static void rebuild_node_order(void)
+{
+	struct affi_node_order_topology *topo = NULL, *old;
+	struct affi_node_candidate *cand;
+	int *tie_rank;
+	int size = nr_node_ids, nr_nodes = num_possible_nodes();
+	int root, node, i, k, root_ord = 0, node_ord, delta;
+	size_t order_entries = size_mul(size, nr_nodes);
+	size_t rank_entries = size_mul(size, size);
+	size_t entries = size_add(order_entries, rank_entries);
+
+	lockdep_assert_held(&affi_node_order_mutex);
+	if (!nr_nodes)
+		goto publish;
+
+	cand = kmalloc_array(nr_nodes, sizeof(*cand), GFP_KERNEL);
+	if (!cand)
+		goto publish;
+	tie_rank = kmalloc_array(nr_nodes, sizeof(*tie_rank), GFP_KERNEL);
+	if (!tie_rank) {
+		kfree(cand);
+		goto publish;
+	}
+	topo = kvzalloc(struct_size(topo, order, entries), GFP_KERNEL);
+	if (!topo) {
+		kfree(tie_rank);
+		kfree(cand);
+		goto publish;
+	}
+	build_numa_tie_ranks(tie_rank, nr_nodes);
+	topo->size = size;
+	topo->nr_nodes = nr_nodes;
+	/* Store both directions in one allocation and publish them together. */
+	topo->rank = topo->order + order_entries;
+	memset(topo->rank, -1, rank_entries * sizeof(*topo->rank));
+	for_each_node(root) {
+		int *row = topo->order + (size_t)root * nr_nodes;
+		int *rank = topo->rank + (size_t)root * size;
+
+		k = 0;
+		node_ord = 0;
+		for_each_node(node) {
+			/* Ordinals, rather than IDs, keep holes out of the cycle. */
+			delta = node_ord++ - root_ord;
+			if (delta < 0)
+				delta += nr_nodes;
+			if (node == root)
+				continue;
+			cand[k].node = node;
+			cand[k++].key = sched_cache_numa_key(root, node,
+							 tie_rank[delta]);
+		}
+		sort(cand, k, sizeof(*cand), affi_node_candidate_cmp, NULL);
+		/* Keep the local node first regardless of firmware distances. */
+		row[0] = root;
+		rank[root] = 0;
+		for (i = 0; i < k; i++) {
+			row[i + 1] = cand[i].node;
+			rank[row[i + 1]] = i + 1;
+		}
+		root_ord++;
+	}
+	kfree(tie_rank);
+	kfree(cand);
+
+publish:
+	/* On failure, new readers fall back to the local node, not stale rows. */
+	old = rcu_replace_pointer(affi_node_order, topo,
+				  lockdep_is_held(&affi_node_order_mutex));
+	kvfree_rcu(old, rcu);
+}
+
+/*
+ * Serialize runtime distance writes with construction of the cached rows.
+ * Architectures must hold this sleepable pair across their raw update.
+ * Readers continue to use an immutable old row until publication completes.
+ */
+void sched_cache_numa_distance_update_begin(void)
+{
+	mutex_lock(&affi_node_order_mutex);
+}
+
+void sched_cache_numa_distance_update_end(bool changed)
+{
+	lockdep_assert_held(&affi_node_order_mutex);
+	if (changed && affi_node_order_ready)
+		rebuild_node_order();
+	mutex_unlock(&affi_node_order_mutex);
+}
+
+void __init sched_cache_init_node_order(void)
+{
+	sched_cache_numa_distance_update_begin();
+	/* Include firmware updates made before scheduler initialization. */
+	affi_node_order_ready = true;
+	sched_cache_numa_distance_update_end(true);
+}
+
+/*
+ * Return @node's zero-based rank in @prefer_node's affinity order, with
+ * @prefer_node itself ranked first. Both arguments are node IDs, not CPUs.
+ * Return -1 for an unknown node or an unavailable ordering. Each query
+ * uses one RCU snapshot; separate queries may observe different versions.
+ */
+int affi_node_rank_of(int prefer_node, int node)
+{
+	struct affi_node_order_topology *topo;
+
+	if (prefer_node < 0 || node < 0)
+		return -1;
+
+	guard(rcu)();
+	topo = rcu_dereference(affi_node_order);
+	if (!topo || prefer_node >= topo->size || node >= topo->size)
+		return -1;
+
+	return topo->rank[(size_t)prefer_node * topo->size + node];
+}
+
 /*
  * Get the effective LLC size in bytes that @cpu's bottom sched_domain
  * can use. A CPU within a cpuset partition can only use a proportion
-- 
2.34.1



