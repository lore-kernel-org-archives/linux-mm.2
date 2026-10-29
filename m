Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C13606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4E06B05BD; Wed, 28 Oct 2026 22:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775176B05BE; Wed, 28 Oct 2026 22:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618E76B05BF; Wed, 28 Oct 2026 22:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3071E6B05BD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:32:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9EA71A7AE7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:32:08 +0000 (UTC)
X-FDA: 85374089136.27.9F02115
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5BE79C0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:32:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf10.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793241126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EH0oxZVLk6+N14ooU0LLaz84UIE1gfj7bD0AK3HAWzo=;
	b=5IrBcLlxOB68/S0M3pauH1WtwDTsx7ErjpBtvKlBZwj7gCvt0TJbdADZHep1bmyuULHw6K
	QY71JHORXEJmDE5C0fEXBpoqbLEI0ddzXBRqVmxFuJaMCR5DBYxLg3hj4dNnzfEAwOq3Oi
	60ECIphKq3da8j0WYG+YRFV2hv8PKTE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf10.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793241126;
	b=Scd3wFS6dcsPhmSQvLBzTTF6hcj7CVxI4wYntpI6yzxg6F3bwwgmI28ew362EwFeYvYm9J
	zaYbjuCpqlLWbwq7pOYopcv2sQ7+Y7vtKvjOEaRQAb0fH4OGHZq2CDW6xkmUE+vxYEvZCR
	LQ6gkdhbscfcBDJgnUisxXhuNsUvaaA=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFStD06V9z171YX;
	Thu, 29 Oct 2026 10:32:04 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFStC5rsgz171YX;
	Thu, 29 Oct 2026 10:32:03 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 75724314AC01;
	Thu, 29 Oct 2026 10:31:39 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:32:01 +0800
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
Subject: [RFC PATCH v3 09/17] sched/cache: Introduce rq affinity gain calculation
Date: Thu, 29 Oct 2026 10:20:27 +0800
Message-ID: <20261029022036.4002331-10-wujianyong@hygon.cn>
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
X-Rspamd-Queue-Id: 5BE79C0002
X-Stat-Signature: hjjdtmd497qetq6go865teot3utjztcy
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793241126-361221
X-HE-Meta: U2FsdGVkX18+tdduJdY9s0G7/vjQZvDKzcrtf5U/8YthdVqqnzugRGyVsO4zrdVmQ1qqqKMg9HhZ7PJxJjP27TimVPqzUHQ0eiRNGoVXTRLd2y0LxB+R5ZnS4yBalKQ7m0i2oPtjbJ0aqiGRRj3HU9X4r5V6nkQVvNPZXuhStymhDYxibUwkji6cxwz2vS4EnBkrF74u382ZlVyCXVp9oXDiNSZGAUS4+HQLRWFrJZFyl9tVU67c4gnNj9yxdVO3y454J7u1loW/GGRS8lYrFiqXoat03PaLSpj5ZEfUdZxDtL4GuSA368BGaUCleERi2Y/tPrl7i1UY5BqflLIpyVrfBtHH6/FdSZGL4PRYeT5kY1U2BRiqDRfCj/YqlnabPQXLyVqYEu8ZlE8673I0xAdYrjFQOBzoXB6bmiUq6l3exq+UNBqLvCVoYVsF6WoAaocwFn/rHZBLOYgnoXb0K8cJxhU5x7Rl/hvGK/ikOUuq85FuOqRq5RmDN46hHLUsPZ4NwdkLh+YbhZhr1aml9ihvbMBDMKD/1PImSYMH9SBamtzd/sK96gDUkslKYKxM8EuTlRxORScayZiRCQN9QAr2mIKsml6Vn8zmx+QsA3qVrkC+9kqz0mZnAHSovSrUXBgFtd8xQ6QJbdF1s1aFFqtydvBzLabBC6I+1t70KrEGMQvpxgK/nvzuhiEuEHpwzH3DqZ9Bwydhb/faRrT3TpDnOS9QYl444eDER+qNqWMe/eoCzhJeJQb13RIqXB2eMKt+hTy8/5Tjas/gG/R9DTu70pDVwdV8xvgGyjHVZUtr7Czw1ZOkaTHPzFc9az2lgDjFLD6YFGqSo1NTNbxo5xH31Hu7wTwUkFK4rdZDKIy8oj2VbmVVRhMGhMZZfyDP91ZZ3rHg6gjuHZy2BOKiie0MJIEB2OweK7hMzLW1bI8vLxCr4iipHgV3KRX1lx7M0xwAx8EuoQW8dX1cxiC
 DCwZxIjG
 nseDgCcbAFhmlafKKFwS0Fs14Qrrmx10ED45mNTz35yS9fPcW9p15IebHRN9FcX4soSrY6HxiDrYtgsIa2Iaj3TunK3yVnE/I0PKUjxrWtGHddzw2TAcSfnv50mFrzTiFSkDbDM8Okj+IcoRq7wuBKqLcdOdsr0DXiTnn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The current cache-aware source selection counts tasks whose preferred LLC
is the destination LLC. This misses opportunities to aggregate a workload
across multiple LLCs when moving toward the preferred LLC improves
affinity even without reaching that LLC.

For example, suppose thread group A prefers LLC0 and its LLC affinity
sequence is {LLC0, LLC1, LLC2}. A task of A moving from LLC2 to LLC1
improves affinity because LLC1 precedes LLC2 in that sequence. However,
that task does not contribute to the existing count of tasks preferring
LLC1. A source rq containing such tasks should receive credit for this
potential improvement.

Introduce helpers to calculate an affinity-gain score for a candidate
source rq and a fixed destination CPU. The calculation has two steps:

1. Identify the preferred LLCs or cache-preferred nodes for which moving
   from source to destination improves affinity.
2. Iterate only those selected LLCs or nodes and sum the counts of tasks
   on the source rq with those preferences, applying the corresponding
   affinity weights.

For NUMA-domain balancing, define the raw distance difference to each
cache-preferred node i as:

  D(i) = node_distance(src_node, i) - node_distance(dst_node, i)

Step 1 selects node i if D(i) > 0, or if D(i) == 0 and destination
precedes source in the affinity sequence rooted at i. Let E be this set
of eligible nodes.

Step 2 iterates only the nodes in E. For each node, sum the source rq's
counts for preferred LLCs belonging to that node, then apply its weight:

  W(i) = clamp(D(i), 1, 1024), for i in E
  S = sum_{i in E}(W(i) * task_count_for_cache_preferred_node(i))

For eligible equal-distance moves, the weight is 1. The fixed node order
determines eligibility, while its rank difference does not affect the
weight.

For LLC-level balancing, source and destination are in the same node.
When a task's preferred LLC is in that node, use the affinity sequence
rooted at that LLC to determine whether destination precedes source.
For preferred LLCs on other nodes, use ascending LLC ID order within the
source/destination node. Each eligible task contributes a unit weight:

  S = sum_i(task_count_for_preferred_llc(i))

Here, i ranges over the preferred LLCs selected in the first step. Thus,
the LLC order determines eligibility without weighting the score by the
rank difference.

Subsequent patches use these helpers for source rq and group selection.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 213 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 213 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4eb7cede9080..eb08ae66f465 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11999,6 +11999,219 @@ static bool update_llc_busiest(struct lb_env *env,
 	 */
 	return sgs->nr_pref_dst_llc > busiest->nr_pref_dst_llc;
 }
+
+/*
+ * Get preferred LLCs for which the destination precedes the source in
+ * that LLC's intra-node affinity order. For preferred LLCs outside the
+ * source/destination node, include them only when src_llc > dst_llc,
+ * following ascending LLC ID order within that node.
+ */
+static int get_affi_llcs(int src_llc, int dst_llc,
+			 int *affi_llcs, int llc_max)
+{
+	int j = 0, src_rank, dst_rank, cur_node, node, llc;
+
+	if (src_llc == dst_llc)
+		return 0;
+
+	cur_node = llc_to_node(src_llc);
+	if (cur_node != llc_to_node(dst_llc))
+		return 0;
+
+	for_each_node(node) {
+		for_each_llc_of_node(llc, node) {
+			if (llc >= llc_max)
+				continue;
+			if (node == cur_node) {
+				src_rank = affi_llc_rank_of(llc, src_llc, cur_node);
+				dst_rank = affi_llc_rank_of(llc, dst_llc, cur_node);
+				if (src_rank < 0 || dst_rank < 0)
+					continue;
+				if (src_rank > dst_rank)
+					affi_llcs[j++] = llc;
+			} else {
+				if (src_llc > dst_llc)
+					affi_llcs[j++] = llc;
+			}
+		}
+	}
+
+	return j;
+}
+
+static int get_affi_numas(int src_node, int dst_node, int *affi_nodes, int *affi, int max)
+{
+	int j = 0, src_dist, dst_dist, node;
+
+	for_each_node(node) {
+		if (j >= max)
+			break;
+		src_dist = node_distance(src_node, node);
+		dst_dist = node_distance(dst_node, node);
+		if (src_dist < 0 || dst_dist < 0)
+			continue;
+		if (src_dist == dst_dist) {
+			src_dist = affi_node_rank_of(node, src_node);
+			dst_dist = affi_node_rank_of(node, dst_node);
+			if (src_dist > dst_dist) {
+				affi[j] = 1;
+				affi_nodes[j++] = node;
+			}
+			continue;
+		}
+
+		if (src_dist > dst_dist) {
+			affi[j] = clamp(src_dist - dst_dist, 0, 1024);
+			affi_nodes[j++] = node;
+		}
+	}
+
+	return j;
+}
+
+static int calc_affinity_numa_score(struct sched_domain *sd, int src_cpu, int dst_cpu,
+			int *affi_node, int *affi, int *last_node, int *num, int llc_max)
+{
+	int llc, src_node, dst_node, tmp_node, score = 0, numa_count, node_max;
+
+	src_node = cpu_to_node(src_cpu);
+	dst_node = cpu_to_node(dst_cpu);
+	node_max = min_t(int, nr_node_ids, llc_max);
+	/*
+	 * The destination stays fixed during this source-rq scan. Reuse the
+	 * eligible node list and weights for consecutive source CPUs in the
+	 * same node; each rq's task counts are applied below.
+	 */
+	if (src_node != *last_node) {
+		*last_node = src_node;
+		*num = get_affi_numas(src_node, dst_node, affi_node,
+				      affi, node_max);
+	}
+
+	for (int i = 0; i < *num; i++) {
+		if ((unsigned int)affi_node[i] < nr_node_ids) {
+			tmp_node = affi_node[i];
+			numa_count = 0;
+			for_each_llc_of_node(llc, tmp_node) {
+				if (llc >= sd->llc_max)
+					continue;
+				numa_count += sd->llc_counts[llc];
+			}
+			score += numa_count * affi[i];
+		}
+	}
+
+	return score;
+}
+
+static int calc_affinity_llc_score(struct sched_domain *sd, struct sched_domain *sd_rq,
+			int src_cpu, int dst_cpu, int *affi_llc,
+			int *last_llc, int *num, int llc_max)
+{
+	int src_llc, dst_llc, score = 0;
+
+	if (sd->flags & (SD_NUMA | SD_SHARE_LLC))
+		return 0;
+
+	src_llc = llc_id(src_cpu);
+	dst_llc = llc_id(dst_cpu);
+
+	/*
+	 * The destination stays fixed during this source-rq scan. Reuse the
+	 * eligible LLC list for consecutive source CPUs in the same LLC;
+	 * each rq's task counts are applied below.
+	 */
+	if (src_llc != *last_llc) {
+		*last_llc = src_llc;
+		*num = get_affi_llcs(src_llc, dst_llc, affi_llc, llc_max);
+	}
+
+	for (int i = 0; i < *num; i++) {
+		if ((unsigned int)affi_llc[i] < llc_max)
+			score += sd_rq->llc_counts[affi_llc[i]];
+	}
+
+	return score;
+}
+
+/*
+ * Scratch arrays used while scoring rqs during load balancing. They live on
+ * the bottom sched_domain of the CPU running the balance, so they share the
+ * sched_domain lifetime and need neither a separate allocation nor any RCU
+ * handling of their own. Load balancing runs with preemption disabled, so
+ * this_rq() stays stable for a whole pass, and two CPUs balancing at the same
+ * time each get their own arrays.
+ */
+static void __maybe_unused lb_affi_scratch(int **ids, int **weights, int *llc_max)
+{
+	struct sched_domain *sd = rcu_dereference_all(this_rq()->sd);
+
+	*ids = sd ? sd->affi_ids : NULL;
+	*weights = sd ? sd->affi_weights : NULL;
+	*llc_max = sd ? sd->llc_max : 0;
+}
+
+/*
+ * To locate a source sched group/rq during load balancing, we require
+ * a metric to evaluate the migration benefit of each rq. For cache-aware
+ * scheduling, the primary optimization target is affinity improvement.
+ *
+ * This implementation quantifies affinity gains for candidate group/rq by
+ * computing an affinity score for each rq.
+ *
+ * The score is calculated for a given source and destination. Domains
+ * with SD_NUMA use NUMA-node granularity. Non-NUMA domains spanning
+ * multiple LLCs within one node use LLC granularity. This includes a
+ * package domain on a single-node system with multiple LLCs, as well as
+ * a NODE domain on a multi-node system.
+ *
+ * A task's cache preferred node is the node containing its preferred LLC.
+ * At NUMA level, score the cache preferred nodes for which moving from
+ * source to destination improves affinity. If the raw distances differ,
+ * use the positive distance difference as the weight. If they tie, use
+ * the cache preferred node's fixed affinity order to decide whether the
+ * move is eligible, with a unit weight:
+ *
+ *   Di = node_distance(src_node, NUMAi)
+ *        - node_distance(dst_node, NUMAi)
+ *   Ai = clamp(Di, 0, 1024)                 if Di > 0
+ *      = 1                                  if Di == 0 and dst ranks
+ *                                           before src for NUMAi
+ *      = 0                                  otherwise
+ *   Rt_i = sum_j(rq->sd->llc_counts[j]), LLCj belongs to NUMAi
+ *   Wi = Rt_i * Ai
+ *   p  = sum_i(Wi)
+ *
+ * At LLC level, the source and destination LLCs are in the same node.
+ * For each preferred LLC in that node, add the source rq's task count if the
+ * destination precedes the source in its fixed LLC affinity order.
+ * For preferred LLCs outside that node, include their task counts only
+ * when src_llc > dst_llc, following ascending LLC ID order within the
+ * source/destination node. Each eligible task contributes a unit weight.
+ *
+ * @last_node and @num cache the affinity vector while candidate runqueues
+ * are scanned for one load-balance destination. The destination CPU must
+ * remain unchanged for the lifetime of the cache. The caller must
+ * initialize *@last_node to -1 and *@num to 0.
+ */
+static int __maybe_unused
+calc_affinity_score(struct sched_domain *sd, struct rq *rq, int src_cpu,
+		    int dst_cpu, int *affi_nodes, int *affi, int *last_node,
+		    int *num, int llc_max)
+{
+	struct sched_domain *sd_rq = rcu_dereference_all(rq->sd);
+
+	if (!affi_nodes || !affi || !last_node ||
+			!num || !sd || !sd_rq || !llc_max)
+		return 0;
+
+	if (sd->flags & SD_NUMA)
+		return calc_affinity_numa_score(sd_rq, src_cpu, dst_cpu, affi_nodes,
+						affi, last_node, num, llc_max);
+
+	return calc_affinity_llc_score(sd, sd_rq, src_cpu, dst_cpu, affi_nodes,
+				       last_node, num, llc_max);
+}
 #else
 static inline void record_sg_llc_stats(struct lb_env *env, struct sg_lb_stats *sgs,
 				       struct sched_group *group)
-- 
2.34.1



