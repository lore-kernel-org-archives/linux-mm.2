Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5395DC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BA4E6B008C; Thu, 27 Aug 2026 22:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492766B0092; Thu, 27 Aug 2026 22:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9576B009B; Thu, 27 Aug 2026 22:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6956B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:18:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93DF5A38CF
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:18:46 +0000 (UTC)
X-FDA: 85149069852.17.D8F5C71
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2685B20003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:18:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf31.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787883524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HM0QoZhl6M6XP9XJ2Chn9jO12MGIwHfpWEsnq9ihcH0=;
	b=4BgH368LpLkFeD8grLMxPsgyui69xKc5Y2PDm6akzaSZzgEN6OcStF3EprFkMuOW8rqf2W
	Wld86rkt7wCtRE6F/cBHF6jLyz1/4BhtRGZfoXtD+59t05X8URVTGrSswY+oFmysnFmiDx
	mCYAwYvz/08kCFbJNeDjZ9V6B9lA8VU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787883524;
	b=ok8i2N7sTMtIkyLI904iHznlLZp4u7cCTZuuW1+TCgACgcQ4p3iDeycIG9fLv/Fud4B4SO
	Cgzq8IMrv9YHLQt6NcET8NnVb20PzJ/kMjreftyGEh6Dar7c4B1Oux38145fqEh5ImrsCC
	EAyNYVMET1u3yW44cZDrlTtAWp7q8Us=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf31.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMWP0pd6z3L52C;
	Fri, 28 Aug 2026 10:18:41 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMWM1FThz3L52C;
	Fri, 28 Aug 2026 10:18:39 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id ECF723104800;
	Fri, 28 Aug 2026 10:14:55 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 28 Aug
 2026 10:18:37 +0800
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
Subject: [RFC PATCH v2 22/23] sched/cache: Walk the preferred node from the preferred LLC
Date: Fri, 28 Aug 2026 10:14:41 +0800
Message-ID: <20260828021441.785736-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2685B20003
X-Stat-Signature: mg7e3hx5fz8y93d1hgzscd8u387c1xre
X-Rspam-User: 
X-HE-Tag: 1787883524-604872
X-HE-Meta: U2FsdGVkX1/kxTtwrGku0jYeqVfh5qQd+egaZ2RQEvQO8oHchfErTNZKvEeNxpw3h7RdbNSbxnqWUsa8rb+EK4BnG1oXxViBtdDFGebhhBYycnT2zGAJnowaByYmWEpAr//rH0t6x+2U8N2xyHmcynnARqsv2xNOFXOXw4PGTMZ/EC/QAc0NmebYRGs1usv+X4BUxHSvemiOSDDAI6k1m5qZJKafKY+PmRlBI7wcDBKzdimJXNjvOGCBuTm4O4yQCZ9K07wWWKjtBashmdvZ/H8IhDiCcxGqy/hPQZDrZ8WmNwDlMiOC8ofoiVATTuNSSyxfdDmsfIpoF+/t8IkfHBj7wFBaOLqlrr5Ap+0lINms9tzIQpI/PrU77EzItbQrWDRuFTIMJk+im4WSrWOMXZ4QPQerLZP2ms7cNrNSVbQhzVQ/06QyU3irwnzFIkq/4RuCqcUMTSVDL3f6PRV3a46yMrVPNcVyv51CFkQZmsAYUsXQzsdb9t2CWe3Yt1Zj4yO87lb/gdcHbs2y5w9doLcIHqw9dbeAKwfZPEj7TV/bEq4hmdZAQLOf90KWOI48CvgzNy2VPdTXofB51cCmgkssMMposPUATUiw785W90ZA0nRPvj1h+9Jv0oq2Yg3prsrAvX3dj7vO0+afmBn86EdiOdaQk5Iv1fXChPQPcddh4W0c+bOA6unEs5rAJnM7uYxdeGDr8Umn6CWMJRj8msxz/SBRlMS9koq3RGrCmtJA9Ly/PTgCPpmN2PRN9ppTZ/fwi7PjDcEsPiECeXlbgM2dr0ZU65KREknX9foaNOyOyg1Js7AHE/5xjxnO6igEts7v/62AwiAtfsKwAjvgILweXmXDl7VHIQaj5wvINFZZ2PC/lgLAg94ilC/7gK5+0xq+phF9epo2ingTH3/oUxrWwRoSRUl9HQqsqfvbMkMe5Os6r3PgCcVQFpynUFTSl/F5eJXAs8+IDaAa2OL
 3NvZAUfY
 +liNi4Vj1hQbOAdRxW/4dzalLwSAJ393+RzZcQZbqJ4iJAjWY9HxMpUWWfqDG9DihknZBhLIWgY1sIsOUTx62dhCdEXOpodleHpSXos1PwZ5af5vgxhNnd67aISRbWKrwkzohK0kb6q43nTSSkBSuWC2ky3uQioVx57V8c4wHWiK1hjnTu9TMzRJltIKNGGmHojhjHw3dNzeR3qUsKsWHbnKwdDTO3EqiWvfJNHJXQHQ07T4gnKDaL2bHDJbB1o+ycn+k5s1m5A4vb4GFz3Qajg37uFNxi6+4YoVL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

for_each_llc_node_span() hands out a node's LLCs ordered by
llc_intra_node_distance() from that node's first LLC. That anchor is the
right one for every LLC outside the node, which all see the same order,
but not for the node the mm's preferred LLC lives in.

llc_intra_node_distance(a, b) is (rank_a + rank_b) % k + 1, so the order
seen from a rank-r anchor is a rotation of the order seen from rank 0.
With four LLCs per node and the anchor at rank 2, the canonical walk
yields distances 3, 4, 0, 2 instead of 0, 2, 3, 4. Callers that accumulate
while walking therefore treat farther LLCs as nearer ones.

Add llc_node_span_from() and for_each_llc_node_span_from(), which take the
anchor as an argument and undo the rotation, and use them wherever a
preferred LLC is already known. Nodes the anchor does not belong to keep
the canonical order, so only the preferred node's walk changes.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c     |  8 ++---
 kernel/sched/sched.h    | 17 +++++++++++
 kernel/sched/topology.c | 68 +++++++++++++++++++++++++++++++++++++----
 3 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index def42490fa2a..21513e3dd65a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10866,7 +10866,7 @@ static int mm_estimated_range_dist(int pref_cpu, u64 group_util,
 		int next_dist = INT_MAX;
 
 		for_each_sched_node(pref_cpu, node) {
-			for_each_llc_node_span(node, span) {
+			for_each_llc_node_span_from(node, llc_id(pref_cpu), span) {
 				int cpu = cpumask_first(span);
 				int dist = mm_cache_distance(pref_cpu, cpu);
 
@@ -10881,7 +10881,7 @@ static int mm_estimated_range_dist(int pref_cpu, u64 group_util,
 			break;
 
 		for_each_sched_node(pref_cpu, node) {
-			for_each_llc_node_span(node, span) {
+			for_each_llc_node_span_from(node, llc_id(pref_cpu), span) {
 				int cpu = cpumask_first(span);
 
 				if (mm_cache_distance(pref_cpu, cpu) != next_dist)
@@ -11030,7 +11030,7 @@ static enum llc_mig can_migrate_node(int src_cpu, int dst_cpu,
 		if (cpumask_test_cpu(dst_cpu, cpumask_of_node(node))) {
 			nu = 0;
 			nc = 0;
-			for_each_llc_node_span(node, span) {
+			for_each_llc_node_span_from(node, llc_id(target_cpu), span) {
 				get_span_stats(span, &u, &c);
 				nu += u;
 				nc += c;
@@ -11082,7 +11082,7 @@ static enum llc_mig can_migrate_node(int src_cpu, int dst_cpu,
 		}
 
 		/* Don't migrate if this is a good place to live. */
-		for_each_llc_node_span(node, span) {
+		for_each_llc_node_span_from(node, llc_id(target_cpu), span) {
 			get_span_stats(span, &u, &c);
 			if (cpumask_test_cpu(src_cpu, span)) {
 				if (fits_llc_capacity(u, c))
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e13775e9b177..409e889d660f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4128,6 +4128,8 @@ extern int sched_node_order_at(int cpu, int idx);
 extern int llc_node_stride;
 extern int llc_node_count(int node);
 extern const struct cpumask *llc_node_span_by_dist(int node, int index, int *llc_out);
+extern const struct cpumask *llc_node_span_from(int node, int anchor_llc,
+						int index, int *llc_out);
 
 /*
  * Walk each individual LLC belonging to NUMA node @node, nearest-first
@@ -4140,6 +4142,21 @@ extern const struct cpumask *llc_node_span_by_dist(int node, int index, int *llc
 	     ((span) = llc_node_span_by_dist((node), __lns_idx, NULL)) != NULL; \
 	     __lns_idx++)
 
+/*
+ * Same walk as for_each_llc_node_span(), but ordered from @anchor_llc when
+ * that LLC lives in @node. Callers that already have a preferred LLC should
+ * use this so the walk starts at the anchor instead of the node's first LLC;
+ * the two orders differ because llc_intra_node_distance() wraps modulo the
+ * node's LLC count. For any node the anchor does not belong to, this falls
+ * back to the canonical order.
+ */
+#define for_each_llc_node_span_from(node, anchor_llc, span)			\
+	for (int __lns_idx = 0, __lns_nr = llc_node_count((node));		\
+	     __lns_idx < __lns_nr &&						\
+	     ((span) = llc_node_span_from((node), (anchor_llc), __lns_idx,	\
+					  NULL)) != NULL;			\
+	     __lns_idx++)
+
 #endif
 
 void sched_domains_free_llc_id(int cpu);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 13d360070679..a0c3ec1278a6 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1022,6 +1022,25 @@ static int llc_local_rank_node_count(int node)
 	return count;
 }
 
+/*
+ * 0-based rank of @llc within its own NUMA node, -1 when unknown.
+ * Ranks are handed out in ascending LLC id order, so the node's first
+ * LLC always has rank 0.
+ */
+static int llc_local_rank(int llc)
+{
+	struct llc_local_rank_topology *topo;
+	int rank = -1;
+
+	rcu_read_lock();
+	topo = rcu_dereference(llc_local_rank_topo);
+	if (topo && llc >= 0 && llc < topo->nr_llc)
+		rank = topo->rank[llc];
+	rcu_read_unlock();
+
+	return rank;
+}
+
 static void rebuild_llc_node_map(int size)
 {
 	int *new_map, *old_map;
@@ -2854,25 +2873,62 @@ int llc_node_count(int node)
 
 /*
  * Return a pointer to the cached cpumask of the LLC at position @index
- * within NUMA node @node, ordered ascending by
- * llc_intra_node_distance() from that node's lowest-id LLC.
+ * within NUMA node @node, ordered ascending by llc_intra_node_distance()
+ * from @anchor_llc.
+ *
+ * @anchor_llc is only honoured when it belongs to @node. Pass -1, or an LLC
+ * from any other node, to get the canonical order anchored at the node's own
+ * first LLC - the order every LLC outside the node agrees on.
  */
-const struct cpumask *llc_node_span_by_dist(int node, int index, int *llc_out)
+const struct cpumask *llc_node_span_from(int node, int anchor_llc, int index,
+					 int *llc_out)
 {
 	struct llc_aggr_topology *topo = rcu_dereference_all(llc_aggr_topo);
-	int llc;
+	int base, cnt, rank, self_slot, slot, llc;
 
 	if (!topo || node < 0 || node >= topo->nr_node)
 		return NULL;
-	if (index < 0 || index >= llc_local_rank_node_count(node))
+
+	cnt = llc_local_rank_node_count(node);
+	if (index < 0 || index >= cnt)
 		return NULL;
 
-	llc = topo->node_llc_by_dist[topo->node_offset[node] + index];
+	base = topo->node_offset[node];
+
+	if (anchor_llc < 0 || llc_to_node(anchor_llc) != node) {
+		llc = topo->node_llc_by_dist[base + index];
+	} else if (!index) {
+		llc = anchor_llc;		/* distance 0 */
+	} else {
+		rank = llc_local_rank(anchor_llc);
+		if (rank < 0)
+			return NULL;
+
+		/*
+		 * llc_intra_node_distance(anchor, x) is
+		 * (rank + rank_x) % cnt + 1, so walking that modular sum
+		 * ascending walks the distances ascending. The anchor itself
+		 * owns slot (2 * rank) % cnt and was already returned at
+		 * index 0, so step over it.
+		 */
+		self_slot = (2 * rank) % cnt;
+		slot = index - 1;
+		if (slot >= self_slot)
+			slot++;
+
+		llc = topo->node_llc[base + (slot - rank + cnt) % cnt];
+	}
+
 	if (llc_out)
 		*llc_out = llc;
 
 	return topo->llc_span[llc];
 }
+
+const struct cpumask *llc_node_span_by_dist(int node, int index, int *llc_out)
+{
+	return llc_node_span_from(node, -1, index, llc_out);
+}
 #endif /* CONFIG_SCHED_CACHE */
 
 const struct cpumask *tl_pkg_mask(struct sched_domain_topology_level *tl, int cpu)
-- 
2.34.1



