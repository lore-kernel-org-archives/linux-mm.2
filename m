Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0028C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79606B008A; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46616B0096; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71216B008C; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73C136B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 111BD1403F6
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:17 +0000 (UTC)
X-FDA: 85146989634.03.0B82505
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf28.hostedemail.com (Postfix) with ESMTP id A89BAC0008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787833995;
	b=c/jO3vte5iN6EGmjOu5W8bWSLHMZ2di+wge9ATlUDQuNA91niEziu17MS96fX077Tz56NW
	pXgzEmlmTrUFwLSI1lpCEPBGfAjPojp74lIOTGriKw4UhUTpcNURwKNP5FP1DOiwHEaZ1F
	cQINH9VNCZnRVGkWGk4yg/77Glwi23w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787833995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1JcWd1rNrevSRHHtcfFyccf8SxFIoBXq7Yti8zz7qD8=;
	b=JI4vcvkM3Yeo9JN0EuhWTSSu03dc8O+5IApvSlYHvLuJuhPA+/kka0SF6s/nR4qWNAthI5
	k0RFXaFL7dsfxTMehgMhUwhJYkPXIb6x+2Hi/OmnEbgstv1OlxbJyZj0H5nodE6rzoKZmc
	NaW8LY5YMnyUATuweMjfOHkrs91Vqc0=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1Bt0Vx7zBJY4k;
	Thu, 27 Aug 2026 20:33:10 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1Bq1hNPzBJY4k;
	Thu, 27 Aug 2026 20:33:07 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 0AA7B36F1F84;
	Thu, 27 Aug 2026 20:29:25 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:05 +0800
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
 Hildenbrand <david@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>, <justin.he@arm.com>
Subject: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance matrix with unique distance values
Date: Thu, 27 Aug 2026 20:27:55 +0800
Message-ID: <20260827122816.756234-3-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Stat-Signature: seqqckf1msu91ee54wug93muurrdnsor
X-Rspamd-Queue-Id: A89BAC0008
X-Rspamd-Server: rspam06
X-HE-Tag: 1787833993-641701
X-HE-Meta: U2FsdGVkX19PW9gKcTlhMs/QcnfNYJgvyFPmtjWSxfFJ2l1nx3ey7ZBEhyyoRs+VrrniA9IMh24ectTxKzPyP3kqIMTBHcEpzyAtKvbw32BkZ8/kVaQ92paGV0MwMJV4ek5NZm0JWAeanFZc2CPN8oUgkx2lonIfh846EqLR1IhjyughvrMgwSAXZX320R5hNkCEVuTBQhkclbhgNlIp8OpBEbdmgAUwt90+T+OdhrKLShYfGihczw93blKXfMM/7IQEkg5l9LL5o0Wk6LhH8WXSvMQ6Eo2wF1YQIqLPn3uFFLecAJEOxTTC8JQzbQE6pmtIyx2QJCD9YpvI2b5RflKFOXUKTjv5A/kmQg3a4LtvWrO6v4GJP8L0zFDiDvuiU4ZTUFF0wrwyTdG8WVtwCeknTzeS3qzYFGIfP3qXL/7VMUDBqsKQsOtkcphYoLddskjpKwROP2ih2itEetafV63Y+EaZR6QB1+pXhmDBVULmlGoHdOb/PNU2nimxkkoKPZAny/VuiLEZgwIPu+XkB/pkQSChmJmwOG8LDqST16tnVJXgPqrNAQx/asjEfIZk0hAILMIpI8tO+taeIwks1Fl6kfd2FGT5wXJbAfHJnZF/aLbNetvwldHB39s7TLJ9QTFYM2wXPx7HpBMqLWj6jR7nXKNlwRxPqzjPdWYBRQENLWqAEPTAao7mtxUQZ9LPuijFjkO7bkSN3BtusQmRb3jEGP5Mw3lyCSpjtYxpfK3AqVCG8ZghEwu1MVSkM0ks8f6DNc2DtQC+ndiiYEgekKZgDABEwMbgt7rC+OAG+F4WFSu7SYNEw382OZ+0XlYMft09haQHWz8+2WWkfLtHDrocRbKI43XuRGvg94le1nz8DaGkQIBtyXskMmmy2zv10sPSuiMgLuACyMf+MrhAVC3htGrvpr9/z1Q3YP97PRrK/Lb0PUiEwQeG4wb3UpMreTL1mIuC16uvwb8hopW
 cTyTA3qY
 U3o9ev9ICbeu+LECPY2vgyxIBkglwmv1pJfYFOo+v30/7S4XeefPn8NFZ09j5f68XxuNsFA+tuCkS3fH+N6/i9Zwf0PH4/p4Xoex9ald4k4tPOD5w+urLuXYZG8VfrU90df8ks4Z/RFR/OrFkv4LrRmvBnkBCHlQ9XpswJjmm7tWOS/dfbZF1cP2LSepMo/iEnvrOjP/7KOIv0cUmIOh49BuemS9q+lUt6zZHckNAWQEky0RdhvcvUfHAFrZPfpjNFp+vED+Ww6U8x9LJLqoCGrxmcmnf/rJNR0bh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Builds a refined node distance matrix based on the raw NUMA distance matrix
provided by BIOS. The refined matrix preserves the relative ordering of
NUMA distances, while assigning distinct distance values to node pairs that
originally shared identical distances within each matrix row. This matrix
is exclusively used for cache-aware scheduling and has no impact on existing
NUMA topology logic such as sched domain construction.

For example, consider a system with 4 NUMA nodes. The raw BIOS-provided
distance matrix may look like this:

        NODE0  NODE1  NODE2  NODE3
NODE0   10     20     20     30
NODE1   20     10     20     25
NODE2   20     20     10     20
NODE3   30     25     20     10

Multiple duplicate distance values exist within each row. After the
deduplication step, the refined distance matrix becomes:

        NODE0  NODE1  NODE2  NODE3
NODE0   10     15     20     30
NODE1   15     10     12     25
NODE2   20     12     10     15
NODE3   30     25     15     10

All entries in each row are now unique, while adhering to two core principles:
1. The relative distance ordering from the original matrix is preserved.
   For instance, original distance(NODE0, NODE1) < distance(NODE0, NODE3),
   and this relative relationship is retained in the refined matrix as well.
2. The matrix remains symmetric across its main diagonal. Maintaining
   symmetry is critical to guarantee consistent pairwise node distances.

Each row of this refined NUMA distance matrix is sorted in ascending order to
generate a unique per-node affinity sequence. This sequence will guide
thread migration logic introduced in subsequent patches.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 include/linux/topology.h |   1 +
 kernel/sched/topology.c  | 243 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 240 insertions(+), 4 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 9967739a180c..e01bc9ae6209 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -179,6 +179,7 @@ static inline int cpu_to_mem(int cpu)
 
 #ifdef CONFIG_SCHED_CACHE
 int llc_to_node(int llc);
+int sched_cache_node_distance(int node0, int node1);
 #endif
 
 #if defined(topology_die_id) && defined(topology_die_cpumask)
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index c6928c6b17b6..4c68dfe86019 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -685,9 +685,22 @@ DEFINE_PER_CPU(struct sched_domain __rcu *, sd_asym_cpucapacity);
 DEFINE_STATIC_KEY_FALSE(sched_asym_cpucapacity);
 DEFINE_STATIC_KEY_FALSE(sched_cluster_active);
 
+#ifdef CONFIG_NUMA
+/*
+ * The de-duplicated NUMA distance tiers. Defined here, rather than next to
+ * the rest of the NUMA topology state further down, because the cache aware
+ * code below has to reach them as well.
+ */
+static int			sched_numa_node_levels;
+static int			*sched_numa_node_distance;
+#endif
+
 #ifdef CONFIG_SCHED_CACHE
 static int __rcu *llc_to_node_map;
 static void rebuild_llc_node_map(int size);
+static int __rcu *sched_cache_node_dist_matrix;
+static int sched_cache_node_dist_size;
+static void rebuild_node_distance_matrix(int size);
 #endif
 
 static void update_top_cache_domain(int cpu)
@@ -875,6 +888,38 @@ int llc_to_node(int llc)
 	return node;
 }
 
+/*
+ * De-duplicated NUMA-node distance, looked up from
+ * sched_cache_node_dist_matrix[]. Unlike node_distance(), no two nodes
+ * seen from the same node compare equal, while every relative ordering
+ * of the original node_distance() values (e.g. node_distance(a,b) >
+ * node_distance(a,c)) is preserved. Falls back to the raw
+ * node_distance() if the matrix has not been built yet (e.g. very
+ * early boot, before the first rebuild_node_distance_matrix() call).
+ */
+int sched_cache_node_distance(int node0, int node1)
+{
+	int *matrix;
+	int size;
+	int dist = -1;
+
+	if (node0 == node1)
+		return 0;
+
+	rcu_read_lock();
+	matrix = rcu_dereference(sched_cache_node_dist_matrix);
+	size = READ_ONCE(sched_cache_node_dist_size);
+	if (matrix && node0 >= 0 && node0 < size
+		   && node1 >= 0 && node1 < size)
+		dist = matrix[node0 * size + node1];
+	rcu_read_unlock();
+
+	if (dist >= 0)
+		return dist;
+
+	return node_distance(node0, node1);
+}
+
 static void rebuild_llc_node_map(int size)
 {
 	int *new_map, *old_map;
@@ -911,6 +956,197 @@ static void rebuild_llc_node_map(int size)
 	kfree(old_map);
 }
 
+/*
+ * Build a de-duplicated NUMA-node distance matrix using a tiering +
+ * greedy edge-coloring technique, applied directly to node pairs.
+ * Reuses the already sorted, de-duplicated distance tier list
+ * (sched_numa_node_distance[]/sched_numa_node_levels).
+ *
+ * Guarantees, compared to the raw node_distance() table:
+ *   - still symmetric;
+ *   - every relative ordering between two node_distance() values is
+ *     preserved (if node_distance(a,b) > node_distance(a,c) then
+ *     sched_cache_node_distance(a,b) > sched_cache_node_distance(a,c),
+ *     and likewise for equal/less-than);
+ *   - looked at from any single node, the distances to every other
+ *     node are pairwise distinct (this is the property the raw table
+ *     can violate, e.g. two nodes genuinely equidistant from a third).
+ */
+static void rebuild_node_distance_matrix(int size)
+{
+	int *matrix = NULL, *old_matrix;
+	int *tier_dist = NULL;
+	int *tier_ncolors = NULL;
+	int nr_tiers = 0;
+	unsigned long **used_colors = NULL;
+	int i, j, t;
+	int scale;
+
+	if (size <= 0)
+		return;
+
+#ifdef CONFIG_NUMA
+	nr_tiers = READ_ONCE(sched_numa_node_levels);
+	if (nr_tiers > 0) {
+		tier_dist = kmalloc_array(nr_tiers, sizeof(int), GFP_KERNEL);
+		if (tier_dist) {
+			int *d;
+
+			rcu_read_lock();
+			d = rcu_dereference(sched_numa_node_distance);
+			if (d)
+				memcpy(tier_dist, d, nr_tiers * sizeof(int));
+			else
+				nr_tiers = 0;
+			rcu_read_unlock();
+		} else {
+			nr_tiers = 0;
+		}
+
+		if (!nr_tiers) {
+			kfree(tier_dist);
+			tier_dist = NULL;
+		}
+	}
+#endif
+
+	matrix = kcalloc(size * size, sizeof(int), GFP_KERNEL);
+	if (!matrix)
+		goto out;
+
+	if (!tier_dist) {
+		/*
+		 * NUMA distance tiers not available yet (e.g. very early
+		 * boot or a non-NUMA build): fall back to the raw
+		 * node_distance() table, same as sched_cache_node_distance()
+		 * would have returned anyway.
+		 */
+		for (i = 0; i < size; i++) {
+			for (j = 0; j < size; j++) {
+				if (i == j)
+					continue;
+				matrix[i * size + j] = node_distance(i, j);
+			}
+		}
+		goto commit;
+	}
+
+	tier_ncolors = kcalloc(nr_tiers, sizeof(*tier_ncolors), GFP_KERNEL);
+	if (!tier_ncolors)
+		goto out;
+
+	used_colors = kcalloc(size, sizeof(*used_colors), GFP_KERNEL);
+	if (!used_colors)
+		goto out;
+	for (i = 0; i < size; i++) {
+		used_colors[i] = bitmap_zalloc(size, GFP_KERNEL);
+		if (!used_colors[i])
+			goto out;
+	}
+
+	/* Greedy edge-color each tier; pack (tier, color) into matrix[]. */
+	for (t = 0; t < nr_tiers; t++) {
+		int dist = tier_dist[t];
+		int tier_max_color = 0;
+
+		for (i = 0; i < size; i++)
+			bitmap_zero(used_colors[i], size);
+
+		for (i = 0; i < size; i++) {
+			for (j = i + 1; j < size; j++) {
+				int color;
+
+				if (node_distance(i, j) != dist)
+					continue;
+
+				/* smallest color free at both endpoints */
+				color = 0;
+				for (;;) {
+					color = find_next_zero_bit(used_colors[i], size, color);
+					if (WARN_ONCE(color >= size,
+						      "sched_cache: no free color left in NUMA tier (node=%d)",
+						      i)) {
+						color = size - 1;
+						break;
+					}
+					if (!test_bit(color, used_colors[j]))
+						break;
+					color++;
+				}
+
+				set_bit(color, used_colors[i]);
+				set_bit(color, used_colors[j]);
+				if (color + 1 > tier_max_color)
+					tier_max_color = color + 1;
+
+				matrix[i * size + j] = t * (size + 1) + color;
+				matrix[j * size + i] = matrix[i * size + j];
+			}
+		}
+		tier_ncolors[t] = tier_max_color;
+	}
+
+	/*
+	 * Pick the smallest integer scale such that every tier's
+	 * span of increments (0..tier_ncolors[t]-1) still fits strictly
+	 * inside the gap to the next distinct tier once scaled.
+	 */
+	scale = 1;
+	for (;;) {
+		bool need_more = false;
+
+		for (t = 0; t < nr_tiers - 1; t++) {
+			int gap;
+
+			if (tier_ncolors[t] <= 1)
+				continue;
+			gap = tier_dist[t + 1] - tier_dist[t];
+			if (tier_ncolors[t] - 1 >= gap * scale) {
+				need_more = true;
+				break;
+			}
+		}
+		if (!need_more)
+			break;
+		if (++scale > 1000) {
+			scale = 1000;
+			break;
+		}
+	}
+
+	/* Unpack (tier, color) into the final, close-to-original value. */
+	for (i = 0; i < size; i++) {
+		for (j = 0; j < size; j++) {
+			int packed, t2, color;
+
+			if (i == j)
+				continue;
+
+			packed = matrix[i * size + j];
+			t2 = packed / (size + 1);
+			color = packed % (size + 1);
+			matrix[i * size + j] = tier_dist[t2] * scale + color;
+		}
+	}
+
+commit:
+	old_matrix = rcu_dereference_protected(sched_cache_node_dist_matrix, true);
+	sched_cache_node_dist_size = size;
+	rcu_assign_pointer(sched_cache_node_dist_matrix, matrix);
+	synchronize_rcu();
+	kfree(old_matrix);
+	matrix = NULL;
+out:
+	if (used_colors) {
+		for (i = 0; i < size; i++)
+			bitmap_free(used_colors[i]);
+		kfree(used_colors);
+	}
+	kfree(tier_ncolors);
+	kfree(tier_dist);
+	kfree(matrix);
+}
+
 /*
  * Get the effective LLC size in bytes that @cpu's bottom sched_domain
  * can use. A CPU within a cpuset partition can only use a proportion
@@ -981,6 +1217,7 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 	}
 
 	rebuild_llc_node_map(max_lid + 1);
+	rebuild_node_distance_matrix(nr_node_ids);
 	return true;
 err:
 	for_each_cpu(i, cpu_map) {
@@ -1949,15 +2186,13 @@ enum numa_topology_type sched_numa_topology_type;
 
 /*
  * sched_domains_numa_distance is derived from sched_numa_node_distance
- * and provides a simplified view of NUMA distances used specifically
- * for building NUMA scheduling domains.
+ * (defined near the top of this file) and provides a simplified view of
+ * NUMA distances used specifically for building NUMA scheduling domains.
  */
 static int			sched_domains_numa_levels;
-static int			sched_numa_node_levels;
 
 int				sched_max_numa_distance;
 static int			*sched_domains_numa_distance;
-static int			*sched_numa_node_distance;
 static struct cpumask		***sched_domains_numa_masks;
 #endif /* CONFIG_NUMA */
 
-- 
2.34.1



