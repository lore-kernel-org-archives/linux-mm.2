Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F099C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8289E6B008C; Thu, 27 Aug 2026 08:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2DB6B0096; Thu, 27 Aug 2026 08:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9E56B0098; Thu, 27 Aug 2026 08:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3806F6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B22D41C1CA1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:20 +0000 (UTC)
X-FDA: 85146989760.09.C6BD768
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E672C000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787833998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JXhaw+nsJkMJQswNXrQt19a/v7qAw2k3Zz6rGfwM3Ts=;
	b=p4x5WGbKOocT9piwpAxcRTrFi+ijUhH2Y4THRXsPHIO2ZkTZM40f8pvjqMqvuphvasHUyQ
	/clE/IjSL0bP9C+s3+vauKeKTtk1MnW3CQquOSHPY3cfkNaJLikwwoOjOQADpcVhyuPp2o
	0Jvil1MEP2c6WDaGG93CF7cWRvJrfBc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787833998;
	b=UkLwRzBDRfVriFhjaN+NZnZtouRIZNcSHAXA9cortq0DmLCsc8SHv2dxcnRG0HSVvroLvr
	PJTZ96UUpqVowANCRme4xckHmhGB/s5D/HXY3P1iSsW914m92g3s/7XtgkpHOkPdrnLCcK
	5CBHrW82XVd098gtH2sezKv1dg1hqhI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1C00WHczBJb6Y;
	Thu, 27 Aug 2026 20:33:16 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1Bz3jV1zBJb6W;
	Thu, 27 Aug 2026 20:33:15 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 1847978AD;
	Thu, 27 Aug 2026 20:33:08 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:13 +0800
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
Subject: [RFC PATCH v2 05/23] sched/topology: Introduce a macro to traverse LLC inside node
Date: Thu, 27 Aug 2026 20:27:58 +0800
Message-ID: <20260827122816.756234-6-wujianyong@hygon.cn>
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E672C000B
X-Stat-Signature: 9axm4346y4zdo1kwjfmgwym6kspw3wtw
X-HE-Tag: 1787833998-76004
X-HE-Meta: U2FsdGVkX181+akb4Y9rrKKSHEigw7cnMYB0rApcJazDlt8HvFKmUSQ/MyBrwjPgUJ0i0D21WiopGMswReDxZ2Bml2D2l8DV0AUDB7TSStjM/hxF/d/9cnPDJDlOmn8utgdFcXlDkXpFhmtaldRb52ep0hKDH4qBS1UgOB4MpguxNkPYaWz/yKGOyNeo2Ooklu8PmhfBZGdCfeK2KKLq2r7rmTA54RM1TCrUI8tXzugk6aFUAZGd8xuuyrIBZaMxELbvLL8VF6E8MfbD5jyiVIRjrsbOMiufjr3IpA9DCNf5k3pbs4L4pTgtsoFI7yU+Myoq/p8trKQUkLV43uQ7n2/1Cjs7rrbegx2NKuL1aFn+BhPUMfPDVrAaOOgn0xWpcoq2PfDdrwDGOkw4PJVbHHsOwP66zrKGKisenMrXxprQNeNv/HnOxW6t+ktr2K9wR1th1RSLKqXcj0kIWITIUOCFp1Dz3AkXRiCjtP3H4gxKGIwToN6T4ytaV8ZEC8IdgO5uAZsk4U6EjAE4Vun4ncecvuPCRhQSYH2uwOY5NPa1DPdBYd2EWh4ybgETOPGjhh7KZI1T/dUpQrvg43G5NDGhdAf/Uvnc0CMrcFCnmj99fwndLer9WPHTLg6Zlo6IkgernNWVyyNveLmw94mxvziM1qFfkTYWnq4rq4hlkOTAKInFv/wU9KmdvK+GPFwePj/eBI4Iwacps3Kva7ptjfJoVf2e5g7JfMkhKPn3TMi2YHuWjqIuU92KoFL6cu1AMqqO3a+gCRFRbCbwV1h28cyGxumO2vTAUws/Vdu3nhGzOUOGXTMj8SYvD/1B+SV1ysiP0wgh3d3JZcn7+SDaFLZ1/0odKNDsXgnp1PxD5WcaCVjHfairEmm+arIQtXWQlzzk2kEleH4HnNU2JtOsTnfYh+k5r2ldYQ8DvnxooccNNJozw2z17k10wI8br7AX+tfhSYhZoYVK98Y+ENb
 QrKgDbuw
 yt06P744oZuzUyES8UjoWWuiJYAWcfbR2tgJMLvo+1a0xW6U0SgQOaWfO9Q06oFfF+8dtTGrxuGoG7Kp/m+Vqk5EAPsT3QqCEG9aKlxD/+OeQTU2wDvdn/Mynkvu8am43DLZH8BUDyTy1rNW9eJWYZ7CMN5JFciT6zs50ZIXTmUYdHu992pj1vbVMr4+JXJ5KIY5DOHkP8Rzkzp/oBIXiWSw5yhsnw7GP3ltKgeUWo0HK8dkYBDwOkjT1kJsJ/M02MaxHK25tUZqpbIrkdnq02dnXfWlX3L57YGA/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a macro to traverse LLC only inside a node. Give a node id, this
macro can return the LLC cpumask in the order based on the LLC distance
construct in the previous patch.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/sched.h    |  14 +++
 kernel/sched/topology.c | 214 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 228 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88b71e0f5ef0..38453a78c885 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4124,6 +4124,20 @@ extern int sched_node_order_at(int cpu, int idx);
 	     ((node) = sched_node_order_at((cpu), __sn_idx)) >= 0;	\
 	     __sn_idx++)
 
+extern int llc_node_count(int node);
+extern const struct cpumask *llc_node_span_by_dist(int node, int index, int *llc_out);
+
+/*
+ * Walk each individual LLC belonging to NUMA node @node, nearest-first
+ * by the same-node-only llc_intra_node_distance() ordering instead of
+ * the plain ascending llc_id order of for_each_llc_in_node().
+ */
+#define for_each_llc_node_span(node, span)					\
+	for (int __lns_idx = 0, __lns_nr = llc_node_count((node));		\
+	     __lns_idx < __lns_nr &&						\
+	     ((span) = llc_node_span_by_dist((node), __lns_idx, NULL)) != NULL; \
+	     __lns_idx++)
+
 #endif
 
 void sched_domains_free_llc_id(int cpu);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index a47ed44f7b1f..eaaca6c9a805 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -6,6 +6,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/sched/clock.h>
 #include <linux/bsearch.h>
+#include <linux/sort.h>
 #include "sched.h"
 
 DEFINE_MUTEX(sched_domains_mutex);
@@ -698,6 +699,7 @@ static int			*sched_numa_node_distance;
 #ifdef CONFIG_SCHED_CACHE
 static int __rcu *llc_to_node_map;
 static void rebuild_llc_node_map(int size);
+static void rebuild_llc_aggr_windows(int size);
 static int __rcu *sched_cache_node_dist_matrix;
 static int sched_cache_node_dist_size;
 static void rebuild_node_distance_matrix(int size);
@@ -969,6 +971,24 @@ int llc_intra_node_distance(int llc1, int llc2, int node)
 	return (rank1 + rank2) % k + 1;
 }
 
+/*
+ * Number of LLCs in @node, sourced from llc_local_rank_topo
+ * (rebuild_llc_local_rank()).
+ */
+static int llc_local_rank_node_count(int node)
+{
+	struct llc_local_rank_topology *topo;
+	int count;
+
+	rcu_read_lock();
+	topo = rcu_dereference(llc_local_rank_topo);
+	count = (topo && node >= 0 && node < topo->nr_node) ?
+		topo->node_count[node] : 0;
+	rcu_read_unlock();
+
+	return count;
+}
+
 static void rebuild_llc_node_map(int size)
 {
 	int *new_map, *old_map;
@@ -1434,6 +1454,7 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 	rebuild_node_distance_matrix(nr_node_ids);
 	rebuild_node_order(nr_node_ids);
 	rebuild_llc_local_rank(max_lid + 1);
+	rebuild_llc_aggr_windows(max_lid + 1);
 	return true;
 err:
 	for_each_cpu(i, cpu_map) {
@@ -2585,6 +2606,199 @@ const struct cpumask *tl_mc_mask(struct sched_domain_topology_level *tl, int cpu
 
 #define llc_mask(cpu) arch_llc_mask(cpu)
 
+#ifdef CONFIG_SCHED_CACHE
+/*
+ * For each node we remember where its slice of the flattened per-node
+ * LLC-id list (node_llc[]) starts (used by the for_each_llc_in_node()
+ * iterator; per-node LLC counts come from llc_local_rank_topo, see
+ * llc_local_rank_node_count()). We also cache each LLC's own cpumask
+ * (llc_span[]).
+ */
+struct llc_aggr_topology {
+	int nr_llc;
+	int nr_node;
+	int *node_offset;		/* [nr_node]: node's slice start in node_llc[] */
+	int *node_llc;			/* [nr_llc]: flattened per-node LLC ids, ascending */
+	int *node_llc_by_dist;		/* [nr_llc]: same slices as node_llc[], sorted by
+					 * llc_intra_node_distance() from each node's
+					 * lowest-id LLC instead of by id
+					 */
+	struct cpumask **llc_span;	/* [nr_llc]: cpumask of each LLC */
+};
+
+static struct llc_aggr_topology __rcu *llc_aggr_topo;
+
+static void free_llc_aggr_topology(struct llc_aggr_topology *topo)
+{
+	int i;
+
+	if (!topo)
+		return;
+
+	if (topo->llc_span) {
+		for (i = 0; i < topo->nr_llc; i++)
+			kfree(topo->llc_span[i]);
+		kfree(topo->llc_span);
+	}
+	kfree(topo->node_offset);
+	kfree(topo->node_llc);
+	kfree(topo->node_llc_by_dist);
+	kfree(topo);
+}
+
+static void rebuild_llc_aggr_windows(int size)
+{
+	struct llc_aggr_topology *topo, *old;
+	int *seen;
+	u8 *seen_llc;
+	int cpu, llc, node, i;
+
+	if (size <= 0)
+		return;
+
+	topo = kzalloc_obj(*topo);
+	if (!topo)
+		return;
+
+	topo->nr_llc  = size;
+	topo->nr_node = nr_node_ids;
+	topo->node_offset = kcalloc(nr_node_ids, sizeof(int), GFP_KERNEL);
+	topo->node_llc    = kcalloc(size, sizeof(int), GFP_KERNEL);
+	topo->node_llc_by_dist = kcalloc(size, sizeof(int), GFP_KERNEL);
+	topo->llc_span    = kcalloc(size, sizeof(struct cpumask *), GFP_KERNEL);
+	seen = kcalloc(nr_node_ids, sizeof(int), GFP_KERNEL);
+	seen_llc = kcalloc(size, sizeof(*seen_llc), GFP_KERNEL);
+	if (!topo->node_offset ||
+	    !topo->node_llc || !topo->node_llc_by_dist ||
+	    !topo->llc_span || !seen || !seen_llc) {
+		kfree(seen);
+		kfree(seen_llc);
+		free_llc_aggr_topology(topo);
+		return;
+	}
+
+	/* Cache each LLC's cpumask. */
+	for_each_possible_cpu(cpu) {
+		llc = per_cpu(sd_llc_id, cpu);
+		if (llc < 0 || llc >= size || seen_llc[llc])
+			continue;
+		seen_llc[llc] = 1;
+
+		topo->llc_span[llc] = kzalloc(cpumask_size(), GFP_KERNEL);
+		if (!topo->llc_span[llc]) {
+			kfree(seen);
+			kfree(seen_llc);
+			free_llc_aggr_topology(topo);
+			return;
+		}
+		cpumask_copy(topo->llc_span[llc], llc_mask(cpu));
+	}
+
+	for (i = 1; i < nr_node_ids; i++)
+		topo->node_offset[i] = topo->node_offset[i - 1] +
+					llc_local_rank_node_count(i - 1);
+
+	/* Fill node_llc[] (ascending llc_id per node). */
+	memset(seen_llc, 0, size * sizeof(*seen_llc));
+	for_each_possible_cpu(cpu) {
+		llc = per_cpu(sd_llc_id, cpu);
+		if (llc < 0 || llc >= size || seen_llc[llc])
+			continue;
+		seen_llc[llc] = 1;
+
+		node = llc_to_node(llc);
+		if (node < 0 || node >= nr_node_ids)
+			continue;
+
+		topo->node_llc[topo->node_offset[node] + seen[node]] = llc;
+		seen[node]++;
+	}
+	kfree(seen);
+	kfree(seen_llc);
+
+	/*
+	 * fill node_llc_by_dist[], the same per-node slices as
+	 * node_llc[] above but sorted ascending by
+	 * llc_intra_node_distance() from that node's lowest-id LLC (the
+	 * same one node_llc[]'s slice starts with) instead of by id. Used
+	 * by for_each_llc_node_span() to walk a node's own LLCs
+	 * nearest-first, unlike the plain id order of for_each_llc_in_node().
+	 * llc_intra_node_distance() guarantees no two same-node LLCs tie
+	 * from a fixed anchor's point of view, so this sort is unambiguous.
+	 */
+	for (node = 0; node < nr_node_ids; node++) {
+		struct dist_key *cand;
+		int base = topo->node_offset[node];
+		int cnt = llc_local_rank_node_count(node);
+		int anchor, k;
+
+		if (cnt == 0)
+			continue;
+
+		anchor = topo->node_llc[base];
+
+		cand = kmalloc_array(cnt, sizeof(*cand), GFP_KERNEL);
+		if (!cand) {
+			free_llc_aggr_topology(topo);
+			return;
+		}
+
+		for (k = 0; k < cnt; k++) {
+			int llc_id = topo->node_llc[base + k];
+
+			cand[k].id = llc_id;
+			cand[k].dist = llc_intra_node_distance(anchor, llc_id, node);
+		}
+
+		sort(cand, cnt, sizeof(*cand), dist_key_cmp, NULL);
+
+		for (k = 0; k < cnt; k++)
+			topo->node_llc_by_dist[base + k] = cand[k].id;
+		kfree(cand);
+	}
+
+
+	old = rcu_dereference_protected(llc_aggr_topo,
+					lockdep_is_held(&sched_domains_mutex));
+	rcu_assign_pointer(llc_aggr_topo, topo);
+	synchronize_rcu();
+	free_llc_aggr_topology(old);
+}
+
+/* Return the number of LLCs belonging to NUMA node @node. */
+int llc_node_count(int node)
+{
+	struct llc_aggr_topology *topo = rcu_dereference_all(llc_aggr_topo);
+
+	if (!topo || node < 0 || node >= topo->nr_node)
+		return 0;
+
+	return llc_local_rank_node_count(node);
+}
+
+/*
+ * Return a pointer to the cached cpumask of the LLC at position @index
+ * within NUMA node @node, ordered ascending by
+ * llc_intra_node_distance() from that node's lowest-id LLC.
+ */
+const struct cpumask *llc_node_span_by_dist(int node, int index, int *llc_out)
+{
+	struct llc_aggr_topology *topo = rcu_dereference_all(llc_aggr_topo);
+	int llc;
+
+	if (!topo || node < 0 || node >= topo->nr_node)
+		return NULL;
+	if (index < 0 || index >= llc_local_rank_node_count(node))
+		return NULL;
+
+	llc = topo->node_llc_by_dist[topo->node_offset[node] + index];
+	if (llc_out)
+		*llc_out = llc;
+
+	return topo->llc_span[llc];
+}
+#endif /* CONFIG_SCHED_CACHE */
+
 const struct cpumask *tl_pkg_mask(struct sched_domain_topology_level *tl, int cpu)
 {
 	return cpu_node_mask(cpu);
-- 
2.34.1



