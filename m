Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D387E606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7936B05B7; Wed, 28 Oct 2026 22:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C81486B05B8; Wed, 28 Oct 2026 22:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70026B05B9; Wed, 28 Oct 2026 22:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BBAF6B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:55:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FDD6802AD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:54:59 +0000 (UTC)
X-FDA: 85374146718.26.CC47982
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf23.hostedemail.com (Postfix) with ESMTP id B8419140004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:54:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nwzRLqo3JIwT8sW8EedZYwfWsX0Ld8ECZ+PVvahOUys=;
	b=ZasmJqsMmRGeBkbgTEDvlwxKqKn9sazZ52Vy1AX6WeDvhzapfPRxwwdVq4LmZnemJNCjzq
	pAE3bMq3ed45iTAPLZMd/OwZL2N6/M8T386wOuVYDNRV1Mdg8vIAzFlqS1WOBSO3WX62vg
	UDZkvl45h5bzAvlWeWa3lPi/JCuFWZc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242497;
	b=flU/R7lKlf4DroGeDQKNISb31P7nn1zo2TDYW78Swq0Kc7lJRltJO5eyK1J2z/hEQqq1oq
	/iNhoaFo8X6uZ1kDXPq0d04LjzLFpUEArDB3suitFC8Cqc9nuzz/g0C4ZkwxyuHVLZswNl
	A4ha66ZjqFuLBa3CAqapZJL4+L8MJww=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFTNX0rb9zwXwL;
	Thu, 29 Oct 2026 10:54:52 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFTNW2YXfzwXwL;
	Thu, 29 Oct 2026 10:54:51 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 036E1314AC01;
	Thu, 29 Oct 2026 10:54:27 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:54:48 +0800
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
Subject: [RFC PATCH v3 14/17] sched/cache: Consider LLC load when selecting a single-task source rq
Date: Thu, 29 Oct 2026 10:50:11 +0800
Message-ID: <20261029025011.4004061-1-wujianyong@hygon.cn>
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
X-Rspamd-Queue-Id: B8419140004
X-Stat-Signature: pxk5xtcpw9sfw5e49us6hu8acrzjsy9h
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793242496-563826
X-HE-Meta: U2FsdGVkX18ne9GELhmhbD7hGVIXHT/25+I9G/57gH0Fo4v3EgveErS46U4HV6R3f6IDIRYTXqy71/s7SEyP/aug9Y1cO0kiaFEACsYQQMhy+lUkLWhHnz9IagDwPfYuepuwIB3AHDbidLRLuLk3ATREdcfwj5Ab71yHCdp4ppdxTTv01HMPS6EBrAf+eJycRGh9Cnhb++kx/FWqAXgYvyzOFNeyJS9iNcmxGvNOm/rM6eAw7IXxQnVb4cZDeu82Han3Hnu8OppWO2S6rjNPHZgAzWyI7F9BrG6yNjqHEeKy77iUrlwb357K04oRb8Z11R3rWUQFEfKIAu21Oz6cx57b3uhqDdHQYqzLZ+PAR2AchRDNQayMbMU9ThtOFqVNbmm9qmEqFd7Y9uO1ImhEdeZxD1US4CE6MLg/EX2Q1/TO6gBT3mo2Lspa+6KqYJqMnAyU5m8/9vP1czngbABwneC7epaCJ5vaMtmIp8V0pOK57qf6ydZTLQO+ikie/FQCmobSHe4ZwlFpRSYoaCKNTly6cLo7mjPCpKGzy0zz3Fs4/tigEjz/cOBkbC+gpqDQk7uMPrIjPcgAVKPJewAeE+iJsPIkNf3v689MaCy2PGqoMX4AGIPn+6ViLfoOjc0rFq71pA0vDqX1pHvkrlir1g6qsWkvGIr8337zpkJ+u9slnxYlcbmpcb4KBiv4qZCL5jOSFbxqm3srrzu7eXBegYAIhKtBc07jra7nI9/6Rf3xD5J8mPy2KanHYEx3v7lyvkVOVCMFfjn/h7TLPquVPO7inkSMJO4GZhK6yXdC73zQtOI5HsVQfeUqle5kryxQdN4ip+QXEjYo0hTvW0F/vkSAzwa90ZipT3QvMgCTvHRCqC+kifuVswWv0l6SX8hMMViUZgdryDRG11Z0mS5xpq9lt8WYU0GRCLe1JNhUuQXPOL8zMStWUXakwgQIAuL50ZF8ZY/urxH/odo98BL
 6xRz9wW0
 5vKnAjyKuKSyVt224Er1Qg2XVTSvgz8Q3/9dcWlFOm7HZ7cv5Qd6SYINR9JZY2TqGaWN5hXY0fb/ptf9mO9gdoJMo+k7tcWIdvqOe2bNZs+fiVTD4Jj9Cexyhsmay/5NsrXrQ5nC/37zLjohSuidlXJeBegySCd+RXINE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a source sched group spans multiple LLCs and every eligible rq has
at most one runnable task, migrate_task selects the first eligible rq.
It cannot distinguish an LLC above the aggregation threshold from one
at the threshold. If the selected rq is in an LLC at the threshold, the
cache-aware migration checks can veto the pull, while the LLC above the
threshold is never selected. The excess then persists.

For example, consider a two-socket machine with this topology:

  Socket 0: NUMA nodes 0-3
  Socket 1: NUMA nodes 4-7
  Each node: four LLCs
  Each LLC: four cores with SMT2, exposing eight logical CPUs

With a 50% aggregation threshold, each LLC can hold four full-utilization
tasks at the threshold. Suppose a workload has its preferred LLC in
node 6, with the node affinity order starting with 6, 7, 4, 5, followed
by the nodes in socket 0. One LLC in node 7 holds five CPU-bound tasks,
while every other LLC in socket 1 holds four. Each task runs on its own
rq, and socket 0 has spare capacity.

When socket 0 balances against socket 1, rq-level task counts select
the first CPU in node 4. Moving its task would leave node 4 below the
threshold, so the migration checks forbid it and active balance is not
started. Every such pass fails the same way: the five-task LLC stays
above the threshold while socket 0 has room. Balancing within node 7
does not help either, since moving a task to a sibling LLC with four
tasks merely reverses their task counts.

With cache-aware scheduling enabled, at domains above the LLC, track a
candidate rq in the LLC with the highest utilization within the source
group. Use it when the maximum runnable task count is one. In the
example, socket 0 then pulls from the five-task LLC. Node 7 remains
filled, so the move is permitted and brings that LLC back to the
threshold.

Keep task-count priority when an eligible rq has more than one runnable
task. Use the per-CPU scratch mask added earlier to sample each LLC
once during the existing scan.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1e286296cd65..20a6a7f5c2f7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -13357,8 +13357,18 @@ static struct rq *sched_balance_find_src_rq(struct lb_env *env,
 #ifdef CONFIG_SCHED_CACHE
 	int last_node = -1, node_num = 0, llc_max;
 	int *cache_data, *affi;
+	unsigned long llc_util, llc_cap;
+	struct sched_domain *llc_sd, *sd_self;
+	struct rq *llc_busiest = NULL;
+	unsigned long llc_busiest_util = 0;
+	struct cpumask *llcs_cpumask = NULL;
 
 	lb_affi_scratch(&cache_data, &affi, &llc_max);
+	sd_self = rcu_dereference_all(this_rq()->sd);
+	if (sd_self)
+		llcs_cpumask = sd_self->llc_stats_mask;
+	if (llcs_cpumask)
+		cpumask_clear(llcs_cpumask);
 #endif
 
 	for_each_cpu_and(i, sched_group_span(group), env->cpus) {
@@ -13472,6 +13482,34 @@ static struct rq *sched_balance_find_src_rq(struct lb_env *env,
 				busiest_nr = nr_running;
 				busiest = rq;
 			}
+#ifdef CONFIG_SCHED_CACHE
+			/*
+			 * When every eligible rq has at most one runnable task,
+			 * task-count comparisons select the first non-empty rq,
+			 * favoring lower-numbered CPUs regardless of LLC load.
+			 * This can leave LLC load uneven even when individual
+			 * runqueues have the same number of runnable tasks.
+			 *
+			 * Track an rq in the LLC with the highest utilization
+			 * during the same scan. Use it only if no eligible rq
+			 * has more than one runnable task, preserving task-count
+			 * priority while helping resolve LLC imbalance.
+			 */
+			if (busiest_nr < 2 &&
+				!(env->sd->flags & SD_SHARE_LLC) &&
+				nr_running == 1 && sched_cache_enabled() &&
+				llcs_cpumask && !cpumask_test_cpu(i, llcs_cpumask) &&
+				get_llc_stats(i, &llc_util, &llc_cap)) {
+				if (!llc_busiest || llc_util > llc_busiest_util) {
+					llc_busiest_util = llc_util;
+					llc_busiest = rq;
+				}
+				llc_sd = rcu_dereference_all(per_cpu(sd_llc, i));
+				if (llc_sd)
+					cpumask_or(llcs_cpumask, llcs_cpumask,
+						   sched_domain_span(llc_sd));
+			}
+#endif
 			break;
 
 		case migrate_misfit:
@@ -13514,6 +13552,11 @@ static struct rq *sched_balance_find_src_rq(struct lb_env *env,
 		}
 	}
 
+#ifdef CONFIG_SCHED_CACHE
+	if (busiest_nr == 1 && llc_busiest)
+		return llc_busiest;
+#endif
+
 	return busiest;
 }
 
-- 
2.34.1



