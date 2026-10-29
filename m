Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4681606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26FA6B05B8; Wed, 28 Oct 2026 22:28:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE716B05B9; Wed, 28 Oct 2026 22:28:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B786B05BA; Wed, 28 Oct 2026 22:28:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B70386B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:28:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B846160264
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:28:45 +0000 (UTC)
X-FDA: 85374080610.26.46272E3
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf07.hostedemail.com (Postfix) with ESMTP id 85D9A40002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:28:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793240922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=20duY2IP7jPpe7YOxQQZaC4NVCUJp+5qNS+r+ht1Gj0=;
	b=JKVDPISLqkFCx4rYKQ19ocxhGy7BurDkLXerN6a2nf8SCZRvk4d0zJdhchuZ6hoPWUTJHW
	E1yuyyRGntDEBzQApcsXaE2qVdzzod6bOOJwbXdR2MZfdyQT5KejYt2sSU74dIotoUq/rG
	aJb3XqjvcE+H8yaU/vGXMnfWmlxNzo8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793240922;
	b=ssRuqRuyrTuRU5MQ2Ky+1kg3uDZ7QA21dGo4yfwiXr3s0D2brhPUPlcZBCEWREwuooPIgI
	2nuBpOmT3JKfh2hPajqbqVn8gcTH2tuarcdUCnXpOka8dIAepxCJBIR6xcPoCnWphz1ft3
	wQgEyo9J5BhM9my2Z0tkHstZUAdB8U8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSpG6zMkz171Yp;
	Thu, 29 Oct 2026 10:28:38 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSpG6rlVz171Yp;
	Thu, 29 Oct 2026 10:28:38 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 9C819314AC01;
	Thu, 29 Oct 2026 10:28:15 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:28:37 +0800
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
Subject: [RFC PATCH v3 04/17] sched/topology: Build triangular affinity orders for LLCs in a node
Date: Thu, 29 Oct 2026 10:20:22 +0800
Message-ID: <20261029022036.4002331-5-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 85D9A40002
X-Stat-Signature: 7pio83xwmfmax3korfu8x3bagispj3sq
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793240922-115236
X-HE-Meta: U2FsdGVkX1+g7s1fmay2+stwWx4LcL9G0S8ObkxXSeQDfG1HEg9rp7aYwMHblytsFCPiEssgFW6OY8XeAbI51FNhDXB8vPbSKj6lgsmxeJz8t3IPcQ7dpHCDbg7JOS7ET+Vk1uwOHMjXsyPik+i5KNxNsb2RGVqbscz0n1958tNDGdoySpH9tblNCKoo/Cn8I4VL9LkqX4mqPp2n0iYef7n3zE9bSzDbYUqzGEaJoUOkrHfYfZEYAVkAkhxATWrPxIAThTQROHZ8EUamh0yRf28ZgyJ4L4jCIuNXKpDA6kEunDekfjNxVHeAL87Lf7o8C9uKcrtWqO+aq5bGaqd+IJXUVQvQSz3MEJQg5sYXF1Wsxf4RyWdN5W7rpqTvKzZULkMy/+fs13Juzx2Vs+V2jtVWbQbi2ssAe6ndenYhrzU9tUTiI4RU1Auve8eEs2F2uRMFI3gJ9zFzjyrgs7b1bwoEY26iepIHJ/5l6NkRgAttF0TQJYsGpfx79ytiCvss937YcGjutoBmU8IYffxoTAwcvzUq32JW+yUsfk+kz6/PJD1adUNfVJ2fMYpfBoOX8d240t9wuF4llkDJmJUfM+zsPvJxUxPkeLA2cQlvuejFylxcj7F9lCySgeh2pey4MffOsZkXKhCn7WCncnBZT5k1UkUHaRwdETfomTsiGahEZcj4YogVIzXWMMsoqMKNW53CenWQ8fSTMMwL4ok7RYaVICCX2S4BCx/lomGnhyOX1ZSRSXuKXWPmgKDs968h+yKw1drQrpXBPstL6heIed+24QkqrrgWz6BhQ7alF2SXqeCEHdB0zXf1AjMrrlB4AsUkm9jvnv308gnj57VYUblGtPFiz4zXCPGCqlGWKubR4LG9MdJAy+HLioIQOg1FneZhexPxoI/hhlHO382Zmz1qjXUpR/8tI6fHh/EOl3B4nnjU8+WuC3tciB5ZDdSh/Pt3qmGHLjhuO1FVFYD
 uveFvt2s
 yIFJi3HshABAaCv9kDnCwYNbc4RypL6JsJHbzU/ETegh844owYsEQbjxJ5YVS3nyQ/e1nUwngCDpt5rGV3i+Q6uvtfy/u+vO6IIWhggYlA0fphnmnjlPT3Xa3pMRLsJrGuCGvqJED9XZLOLRCKhskKAXmktGuRUaaE7sd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An earlier patch builds NUMA node affinity sequences. Build the LLC
order within each node here. Ordering the remaining LLCs by ID would
systematically favor low-ID LLCs, so use a triangular offset permutation.

Assign each LLC a node-local rank in ascending LLC ID order. For a node
with N LLCs, let M be the smallest power of two not less than N. Generate
the triangular offsets T(i) = i * (i + 1) / 2 modulo M for i in [0, M),
and discard offsets greater than or equal to N. Store the resulting
permutation and its inverse for each node.

For a preferred LLC with rank p, add p to each offset modulo N. For
example, with four LLCs, the order starting at LLC0 is:

  LLC0, LLC1, LLC3, LLC2

Shifting the same offsets by the node-local rank of LLC1 gives:

  LLC1, LLC2, LLC0, LLC3

In the system-wide affinity order used by subsequent patches, the
triangular LLC order applies only within the node containing the
preferred LLC. Other nodes follow the NUMA affinity sequence rooted at
that node, with LLCs within each remote node ordered by ascending LLC ID.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/sched.h    |  1 +
 kernel/sched/topology.c | 96 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 5d3fa5d70d16..b114b7cc813f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4108,6 +4108,7 @@ static inline bool sched_cache_enabled(void)
 
 extern void sched_cache_active_set(void);
 extern int llc_to_node(int llc);
+extern int affi_llc_rank_of(int prefer_llc, int llc, int node);
 
 /*
  * Lexicographic node affinity key. Keep the raw NUMA distance as the first
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8d0fd0f8a67a..512a9762b9a2 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -696,6 +696,13 @@ DEFINE_STATIC_KEY_FALSE(sched_cluster_active);
  */
 struct llc_node_map {
 	int nr_llc;
+	int nr_node;
+	int *rank;		/* [nr_llc]: ascending LLC ID rank within its node */
+	int *offset;		/* [nr_llc]: triangular offsets, grouped by node */
+	int *inverse;		/* [nr_llc]: position of each offset */
+	int *node_count;	/* [nr_node]: number of LLCs in each node */
+	int *node_offset;	/* [nr_node]: start of each node's offset slice */
+	/* One allocation contains node[] and all the arrays above. */
 	int node[];
 };
 
@@ -901,22 +908,56 @@ int llc_to_node(int llc)
 	return node;
 }
 
+/* Build one triangular permutation and its inverse for each node's LLCs. */
+static void build_llc_offsets(struct llc_node_map *map)
+{
+	int node;
+
+	for (node = 0; node < map->nr_node; node++) {
+		unsigned int mod = 1, pos = 0, i, index = 0;
+		int nr = map->node_count[node];
+		int base = map->node_offset[node];
+
+		if (!nr)
+			continue;
+		while (mod < nr)
+			mod <<= 1;
+		for (i = 0; i < mod; i++) {
+			if (pos < nr) {
+				map->offset[base + index] = pos;
+				map->inverse[base + pos] = index++;
+			}
+			pos = (pos + i + 1) & (mod - 1);
+		}
+	}
+}
+
 static void rebuild_llc_node_map(int size)
 {
 	struct llc_node_map *new_map, *old_map;
+	size_t entries;
 	int cpu, llc, node;
 
 	lockdep_assert_held(&sched_domains_mutex);
 	if (size <= 0)
 		goto fail;
 
-	new_map = kzalloc(struct_size(new_map, node, size), GFP_KERNEL);
+	entries = size_add(size_mul(size, 4), size_mul(nr_node_ids, 2));
+	new_map = kzalloc(struct_size(new_map, node, entries), GFP_KERNEL);
 	if (!new_map)
 		goto fail;
 
 	new_map->nr_llc = size;
-	for (llc = 0; llc < size; llc++)
+	new_map->nr_node = nr_node_ids;
+	new_map->rank = new_map->node + size;
+	new_map->offset = new_map->rank + size;
+	new_map->inverse = new_map->offset + size;
+	new_map->node_count = new_map->inverse + size;
+	new_map->node_offset = new_map->node_count + nr_node_ids;
+	for (llc = 0; llc < size; llc++) {
 		new_map->node[llc] = NUMA_NO_NODE;
+		new_map->rank[llc] = -1;
+	}
 
 	/*
 	 * for_each_possible_cpu() revisits the same LLC non-consecutively
@@ -929,10 +970,22 @@ static void rebuild_llc_node_map(int size)
 		if (llc < 0 || llc >= size || new_map->node[llc] >= 0)
 			continue;
 		node = cpu_to_node(cpu);
-		if (node >= 0 && node < nr_node_ids && node_possible(node))
-			new_map->node[llc] = node;
+		if (node < 0 || node >= new_map->nr_node || !node_possible(node))
+			continue;
+		new_map->node[llc] = node;
 	}
 
+	/* Rank LLCs by ascending ID, independently of CPU enumeration order. */
+	for (llc = 0; llc < size; llc++) {
+		node = new_map->node[llc];
+		if (node >= 0)
+			new_map->rank[llc] = new_map->node_count[node]++;
+	}
+	for (node = 1; node < new_map->nr_node; node++)
+		new_map->node_offset[node] = new_map->node_offset[node - 1] +
+					     new_map->node_count[node - 1];
+	build_llc_offsets(new_map);
+
 publish:
 	old_map = rcu_dereference_protected(llc_to_node_map,
 					    lockdep_is_held(&sched_domains_mutex));
@@ -1154,6 +1207,41 @@ int affi_node_rank_of(int prefer_node, int node)
 	return topo->rank[(size_t)prefer_node * topo->size + node];
 }
 
+/*
+ * Return @llc's position in @prefer_llc's intra-node affinity order.
+ * The preferred LLC is first; the other positions follow the triangular
+ * offset permutation of the node-local LLC ranks.
+ *
+ * Mapping, ranks and counts come from the same RCU snapshot. Return -1
+ * if the topology is unavailable or either LLC does not belong to @node.
+ */
+int affi_llc_rank_of(int prefer_llc, int llc, int node)
+{
+	struct llc_node_map *map;
+	int delta, nr, base;
+
+	if (prefer_llc < 0 || llc < 0 || node < 0)
+		return -1;
+
+	guard(rcu)();
+	map = rcu_dereference(llc_to_node_map);
+	if (!map || prefer_llc >= map->nr_llc || llc >= map->nr_llc ||
+	    node >= map->nr_node || map->node[prefer_llc] != node ||
+	    map->node[llc] != node)
+		return -1;
+
+	nr = map->node_count[node];
+	if (!nr || map->rank[prefer_llc] < 0 || map->rank[llc] < 0 ||
+	    map->rank[prefer_llc] >= nr || map->rank[llc] >= nr)
+		return -1;
+
+	delta = map->rank[llc] - map->rank[prefer_llc];
+	if (delta < 0)
+		delta += nr;
+	base = map->node_offset[node];
+	return map->inverse[base + delta];
+}
+
 /*
  * Get the effective LLC size in bytes that @cpu's bottom sched_domain
  * can use. A CPU within a cpuset partition can only use a proportion
-- 
2.34.1



