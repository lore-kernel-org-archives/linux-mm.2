Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10217C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FEC66B00A0; Thu, 27 Aug 2026 08:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9622B6B00A1; Thu, 27 Aug 2026 08:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DA7C6B00A2; Thu, 27 Aug 2026 08:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5368E6B00A1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C57E3403F4
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:38 +0000 (UTC)
X-FDA: 85146990516.08.318F22D
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf10.hostedemail.com (Postfix) with ESMTP id C516AC0002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787834017;
	b=ecAOo7W+Ni5xdML//22CxZfuUU7lxfVNwiuWhe7TWZSxxSqWXZtbXSdbvKwRroCvon2E5T
	/LEZDWckypden6c5llFqDtDHyYakf8s56RzcWLL+rU3bIcSbPUmVKNi/18SLZImTFuEkn+
	C5aFnJ+sLqLphjUzQM4tKVwArHX6tCo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787834017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRUkxAxCAz41c43ToDRMs50HPiD6wPKBGza4XJOcjbs=;
	b=X0gP645Rtpcym77sMHZQJJTL5sEWrhpSz6BzW1bG9Unmqocmchbs/OVPl21GQKijUR6X9E
	pM/MDYuYU60aKDhFtb7SCVx6wiOA9pvXkq9KrlYGyo2R62wgAn3yVSjZFgssvSBHZkcXsM
	HsQWtipzIyQgl2ErpzMztdxNJTPkuKM=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CL0WlCzBJb6q;
	Thu, 27 Aug 2026 20:33:34 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CK57yVzBJb6c;
	Thu, 27 Aug 2026 20:33:33 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 7DE4436F1F84;
	Thu, 27 Aug 2026 20:29:51 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:32 +0800
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
Subject: [RFC PATCH v2 12/23] sched/cache: Introduce rq affinity gain calculation
Date: Thu, 27 Aug 2026 20:28:05 +0800
Message-ID: <20260827122816.756234-13-wujianyong@hygon.cn>
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
X-Stat-Signature: 8mqn1igecmwp63djo98f8fcgo4poyyi9
X-Rspamd-Queue-Id: C516AC0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787834016-173367
X-HE-Meta: U2FsdGVkX19lmOj/pdPiYB/j96Ay6ZQf/bzJt9wOfd5Icu0w3GRSEvJybBPVeycEdLKwwn8VWJntj4IlPwSWpug0UfEVlYO7vJaDXO+oexWwiZIn+Z8wfSPgawpShJVV2vq/VZQaebW4UM/56JiuA9hycg8nJL38K1oIhaDr6vtXU+oMFT1Cw4Au2uoN2lSM6TgFzfIXOJTrNYsQ8kn3krO7WNYSaIYNaFrqUHMmNnfVx6XTciUZu/OYvJGrFtQAaRzQYUTxn8u0RbwJWa1XJECoS7lqU+/Ix1E2/NGl4dYVhLygtcT5wuslju0YyUKNV95oTXmcQqQAyHh3K7FtVtfQO+8m3mUruYsRpEgF85nEsMC8LoyC/XApjk60hgxllTK3zJJjAMd/H50JPFDqBpSw34e7TQpQ6RFlI1NES/ktPeESpdn7xNIlypTPyhYjDh/84mPgBCy2bWM5/hdXRBa+YRplIq4/mYjnMYryHIJVnjfUA0WeQ4FDEKH8Owa5AR3nXHsb4T/0dOK0krcnPOdYXFGc/AYjqKNTBjNUbMvco1QKFgAkPf+y9MPi3cCugnukbWAGgRg/GU860M8VXX7NX/dWhFh00+K7+p+W0JxLewRtaHpHzpDZbG1wjR1DdblUokr2qX5lKYzwkL0bsoAAhZ4P6vnAhdKTVTPVy8ag8by5RQ4ASSCIVyCNgeD4zg9QhcVt9jqdlDJuMM4fu89715OIvFizr55He9FMH4F7Rvnl82aBaI5hE5iatk3p+5ONzUrW0NgANulj5jTc3M2MN/75ydK9vymQyuOut+hPpGYNRjG2Uxe870rysbNMPME/tR9b+YUMpg1e67FYTVuvludQVNgh61NMeCkqEVPqukFG4PfpjSlWA4rpSX05HMNG5FBgtbUvGGkTaadVUs43N7h0TOHbHVi9nupyo6NaFLIpxk0tmWa+ckMn54fOHhAiN6gKSktjFXo4Qq/
 sRv9cV1f
 HzrcRU9ouMj4g3BYAy22DNmRi0SF+mIDdVK5Yw+aSuK1TfhmAMKeqm44pCp5+jSvi33FJsxipfQIPk4dHdzBeYPtkpZCXyxtyEQgcN0lRMBPsPS++eaxfVDYszQL2Sl6DrAut3UIVzTazxCUOGPOUhICpDju+8APawv5T4+PpFnDPu5vW2jnNNM7fKOH1UCTnniLoYVksHm7wcdocA0F8PavCtQZkXumg455ecUklDRnoRjc0EtLtkoES2tW4L8thvod8N4Q8ZK9iDTdOipVvD0m2rCv977gnnVYg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cache-aware scheduler's current source runqueue selection logic
only matches a task's preferred LLC against the destination LLC.
This misses many migration opportunities that deliver improved NUMA
affinity even when preferred LLCs do not align.

As an illustrative example: source CPUs reside on NODE0, destination
CPUs on NODE1. A task on the source runqueue has its preferred LLC
located on NODE2. If the NUMA distance NODE0<->NODE2 is 20, and
NODE1<->NODE2 is 15, migrating this task reduces remote memory latency.
The existing policy cannot capture this beneficial case.

To fix this gap, implement a new scoring algorithm to quantify total
affinity promotion for a source runqueue given source and destination
LLCs. The algorithm operates in two distinct phases:

Iterate all system nodes, for the NUMA-level domain load balance, or
intra-node LLCs, for NODE-level domain load balance, and filter those that
yield improved affinity.
Take NUMA-level domain as an example. If tasks bound to NUMAi migrate from
the source CPU to destination CPU. Compute the distance delta Di for each
NUMAi, via:

  Di = node_distance(src_node, NUMAi) - node_distance(dst_node, NUMAi)

Aggregate total affinity promotion score for the candidate runqueue
by summing weighted contributions from all resident tasks. Per-task
weight and total score are calculated as follows:

  W_i = Rt_i * Di
  p = sum_i(W_i)

Here p is the total affinity gain of the runqueue; Rt_i denotes the
count of tasks on the runqueue with NUMAi as their preferred node,
tracked via rq->sd->node_count.

By this way, we can select the right src sched group or the src rq in load
balance.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 169 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 169 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cfbd596992ab..505a1ea9537f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11920,6 +11920,7 @@ sched_reduced_capacity(struct rq *rq, struct sched_domain *sd)
 }
 
 #ifdef CONFIG_SCHED_CACHE
+extern int max_lid;
 /*
  * Record the statistics for this scheduler group for later
  * use. These values guide load balancing on aggregating tasks
@@ -11998,6 +11999,174 @@ static bool update_llc_busiest(struct lb_env *env,
 	 */
 	return sgs->nr_pref_dst_llc > busiest->nr_pref_dst_llc;
 }
+
+/*
+ * Get all LLCs that are closer to the destination LLC than to the
+ * source LLC inside a NUMA.
+ */
+static int get_affi_llcs(struct sched_domain *sd, int src_llc, int dst_llc,
+			 int *affi_llcs, int *affi)
+{
+	int j = 0, src_dist, dst_dist, cur_node;
+
+	if (src_llc == dst_llc || sd->flags & (SD_NUMA | SD_SHARE_LLC))
+		return 0;
+
+	cur_node = llc_to_node(src_llc);
+	if (cur_node != llc_to_node(dst_llc))
+		return 0;
+
+	for (int i = 0; i <= max_lid; i++) {
+		if (cur_node == llc_to_node(i)) {
+			src_dist = llc_intra_node_distance(src_llc, i, cur_node);
+			dst_dist = llc_intra_node_distance(dst_llc, i, cur_node);
+			if (src_dist < 0 || dst_dist < 0)
+				continue;
+			if (src_dist > dst_dist) {
+				affi[j] = clamp(src_dist - dst_dist, 1, 1024);
+				affi_llcs[j++] = i;
+			}
+		} else {
+			/*
+			 * Assume the distance between LLCm on nodeA and LLCn on nodeB follows:
+			 * llc_dist(LLCm, LLCn) = node_dist(nodeA, nodeB) + m + n,
+			 * where m and n represent the intra-node index of LLCm and LLCn
+			 * within their respective nodes. Under this definition, we derive:
+			 * llc_dist(src_llc, i) - llc_dist(dst_llc, i) = src_llc - dst_llc
+			 */
+			if (src_llc > dst_llc) {
+				affi[j] = clamp(src_llc - dst_llc, 1, 1024);
+				affi_llcs[j++] = i;
+			}
+		}
+	}
+
+	return j;
+}
+
+static int get_affi_numas(int src_node, int dst_node, int *affi_nodes, int *affi)
+{
+	int j = 0, src_dist, dst_dist, node;
+
+	for_each_node(node) {
+		src_dist = sched_cache_node_distance(src_node, node);
+		dst_dist = sched_cache_node_distance(dst_node, node);
+		if (src_dist < 0 || dst_dist < 0)
+			continue;
+
+		if (src_dist > dst_dist) {
+			affi[j] = clamp(src_dist - dst_dist, 4, 1024);
+			affi_nodes[j++] = node;
+		}
+	}
+
+	return j;
+}
+
+static int calc_affinity_numa_score(struct sched_domain *sd, int src_cpu, int dst_cpu,
+			int *affi_node, int *affi, int *last_node, int *num)
+{
+	int src_node, dst_node, score = 0;
+
+	src_node = cpu_to_node(src_cpu);
+	dst_node = cpu_to_node(dst_cpu);
+	if (src_node != *last_node) {
+		*last_node = src_node;
+		memset(affi_node, 0, (max_lid + 1) * sizeof(int));
+		memset(affi, 0, (max_lid + 1) * sizeof(int));
+		*num = get_affi_numas(src_node, dst_node, affi_node, affi);
+	}
+
+	for (int i = 0; i < *num; i++) {
+		if ((unsigned int)affi_node[i] < nr_node_ids)
+			score += sd->numa_counts[affi_node[i]] * affi[i];
+	}
+
+	return score;
+}
+
+static int calc_affinity_llc_score(struct sched_domain *sd_cur, struct sched_domain *sd,
+			int src_cpu, int dst_cpu, int *affi_llc,
+			int *affi, int *last_llc, int *num)
+{
+	int src_llc, dst_llc, score = 0;
+
+	src_llc = llc_id(src_cpu);
+	dst_llc = llc_id(dst_cpu);
+
+	if (src_llc != *last_llc) {
+		*last_llc = src_llc;
+		memset(affi_llc, 0, (max_lid + 1) * sizeof(int));
+		memset(affi, 0, (max_lid + 1) * sizeof(int));
+		*num = get_affi_llcs(sd_cur, src_llc, dst_llc, affi_llc, affi);
+	}
+
+	for (int i = 0; i < *num; i++) {
+		if ((unsigned int)affi_llc[i] < sd->llc_max)
+			score += sd->llc_counts[affi_llc[i]] * affi[i];
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
+static void lb_affi_scratch(int **ids, int **weights)
+{
+	struct sched_domain *sd = rcu_dereference(this_rq()->sd);
+
+	*ids = sd ? sd->affi_ids : NULL;
+	*weights = sd ? sd->affi_weights : NULL;
+}
+
+/*
+ * To locate a source sched group/rq during load balancing, we require
+ * a metric to evaluate the migration benefit of each rq. For cache-aware
+ * scheduling, the primary optimization target is affinity improvement.
+ *
+ * This implementation quantifies affinity gains for candidate rqs by
+ * computing an affinity score for each rq.
+ *
+ * The score is calculated given source LLC/node and destination LLC/node,
+ * under two distinct scenarios: NUMA-domain load balance and NODE-domain
+ * load balance. For NUMA-level balancing, affinity gain is accounted at
+ * NUMA granularity; for node-level balancing, evaluation proceeds at LLC
+ * granularity.
+ *
+ * Taking NUMA-level balancing as an example, the score is computed as:
+ * Di = node_distance(src_node, NUMAi) - node_distance(dst_node, NUMAi)   (1)
+ * Wi = Rt_i * Di                                                       (2)
+ * p  = sum_i Wi                                                        (3)
+ *
+ * Where:
+ * i        Index of a remote NUMA node
+ * Di       Affinity gain, derived from the difference between node
+ *          distance from source to NUMAi and distance from destination
+ *          to NUMAi
+ * Rt_i     Count of tasks on this rq whose preferred NUMA is NUMAi,
+ *          retrieved via rq->sd->node_count
+ */
+static int cal_affinity_score(struct sched_domain *sd, struct rq *rq, int src_cpu, int dst_cpu,
+			int *affi_nodes, int *affi, int *last_node, int *num)
+{
+	struct sched_domain *sd_tmp = rcu_dereference(rq->sd);
+
+	if (!affi_nodes || !affi || !last_node || !num || !sd || !sd_tmp)
+		return 0;
+
+	if (sd->flags & SD_NUMA)
+		return calc_affinity_numa_score(sd_tmp, src_cpu, dst_cpu, affi_nodes,
+						affi, last_node, num);
+
+	return calc_affinity_llc_score(sd, sd_tmp, src_cpu, dst_cpu, affi_nodes,
+				       affi, last_node, num);
+}
 #else
 static inline void record_sg_llc_stats(struct lb_env *env, struct sg_lb_stats *sgs,
 				       struct sched_group *group)
-- 
2.34.1



