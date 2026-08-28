Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54EFDC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D71E6B008C; Thu, 27 Aug 2026 22:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF306B0092; Thu, 27 Aug 2026 22:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4CE6B0099; Thu, 27 Aug 2026 22:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0426B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:13:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80819A364D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:13:27 +0000 (UTC)
X-FDA: 85149056454.07.B7D3774
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3950514000E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:13:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf09.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787883205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PiuBIcCPbrx7zZvwAXPNlucNpCdjVBzFrVMLGG7Mw20=;
	b=Ro+4+rzpBhVr/bqISW8CLG1fd/FMB5eJFvBppf2lKx9RyCDX12rfBKXhaGX1cBYS4Ar5w8
	BbDtum/k11LP3X3tmE5RhBXJiUVbIUHxL3JN/q9hP2UKqOxdkKBjugFpvolkR5TxFsqL+o
	6EdZwNCLzjvWxxhvAJfPsqz4ye0Rvmg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf09.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787883205;
	b=nJ6Kg10eCPChN2ilJVqXu7uiXMGXPQ+z0VurEcaY0/4Br0BKK/gYCSFMkzKnyh/Beu4Fp4
	LFhqp+nlcCq4s4Vj9NWiwSo8al2pv0vj2Z/OGrYaQ4GINzDsHk1BvPQ2t4cb5iOMPYFB3f
	srlftOky3p8bi6oveL0eGWzKDa7fejk=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMPD0dwrz3L52B;
	Fri, 28 Aug 2026 10:13:20 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMP96d8qz3L52B;
	Fri, 28 Aug 2026 10:13:17 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id B225C3104800;
	Fri, 28 Aug 2026 10:09:34 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 28 Aug
 2026 10:13:16 +0800
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
Subject: [RFC PATCH v2 18/23] sched/cache: Scan all prefer nodes in thread group
Date: Fri, 28 Aug 2026 10:09:24 +0800
Message-ID: <20260828020924.785596-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3950514000E
X-Stat-Signature: 4y1g1j69uj9ne3scrrog15fepjd57b57
X-Rspam-User: 
X-HE-Tag: 1787883203-242148
X-HE-Meta: U2FsdGVkX1/bZIG7VrLdUVHXw09uFPMeW64g8jZuo7oS4IsliPjJSLRKAxkBa2LmdD8yFXvI+jN7ZtFlP3mzoIkJGOHy83uvfUmEmdlDhracf/Xsb7G1GKJTHCxDI2bBgt4jfTm3dRyX0zCxAE6X6IPse+QbhvRhni0UaLcbKDsn1JPq8QOolL6RsGud7ADCSdvI5Ifbx3Zrg7FMWvjTnhhic9OFUBuKzvQPGMbT0n2XoyUR/i2hwSf0KQYW2yPqHEcHAIviJwD9xc2zH+PSL1Br6iwl7aI5twus1ACF4QMin3GM++7OfVdGksqmUaebLKFugJVe9dtXH7wnzqcX8BNUuY9+TaXNtL5VECwjm2i38o2AZwTazBLbEFEI+wCN9wij1+0xajtVsjgn88zA4xVvChLMo7DwT0VlYj+fsX1dIvoV3q/5GRwyiN3GQWpudI4U8v5GCHbob/5CtT432Gw2T4Mc0L6EeFz5DuQBygcScp9Dyp0X605xe4puMnkz0Jol9vr4IefFJ9jm/7B1y350N/+iHR/oAyoYHvooBDhdTb2bLPAXYzRwgzFjud4q57I5K66hzwWvyidqmhlQCMUXHWJHOb4TMnVVIHbuIUqUOjVR1LsQtuupaH6sGeVzqVsvuSi7QmPIfOBIX0ZW56RGLDaD7NnoM3UCkjKCtxHOZ9KQ2JD9aTzMnM3T2TjBjOA5qzh48EdjBfgFjZYm7EfEIQmk/Z/eF8UlwHE/LKK10ZkjP9h+FLALjLV8iqkKgXnUsVUUwmV9lrR2r4KpK+cE2i420eIPnTzHkWR8A9U+BdRS9vd0hyzmpCrud3Y1CrFpqm51AdExEq5+ES5ebr7q5cxn8WRcoj7jvRFrcrAd5C6mwEkEVnkXXZJfGqv92ELPWSmZOuphrReRTdMYCfgjZQGMUCg2zc1Mz1NFSQ+cHpms/EOqOGuI7W+fsnyCkW/NhoaU8izSedEwCWM
 42fldUer
 It9qGpcUH0EequTanV4K8jjS0/I5B8szDMFqPRIFz4jc1ZDGWVW8c2yHGUgjonMN0FLJe75Gcn6NUCwMec3wK+fOBqv2FUQttxTrtAMz23N25YORu7IxnR3cqvknnXPTvNmkuuXwLxAhY+bKYs2hqUJN/yGX5xMoZ6XbOU6BWxm4DU/B42jgdnwPA0DuL+rZ2WjWJdsxnDTw/tDmUxtZZNfNOUZxp1VC6fOJkI1jO2pkNEtHm/+Jkz6S4T2X3HmClOJuTmYJoFRJBpuU2XaoeScyIiW2kW9eXCku7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_scan_cpumasks only scan the current task's preferred node.However,
each of task inside a thread group may have its own preferred node. Thus,
each scan may have different scan scope which may make it unstable to find
preferred LLC.

To address this issue, record all of the active preferred nodes from all
of the whole thread group. Then, take them all into the scan scope.
Additinally, remove the preferred node from the scan scope if it has not
been touched for a while like preferred llc invalidation does.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 include/linux/mm_types.h |  6 +-----
 include/linux/sched.h    |  1 +
 kernel/sched/fair.c      | 42 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..7fef34c6f33a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1626,11 +1626,7 @@ static inline int mm_alloc_sched_noprof(struct mm_struct *mm)
 
 #define mm_alloc_sched(...)	alloc_hooks(mm_alloc_sched_noprof(__VA_ARGS__))
 
-static inline void mm_destroy_sched(struct mm_struct *mm)
-{
-	free_percpu(mm->sc_stat.pcpu_sched);
-	mm->sc_stat.pcpu_sched = NULL;
-}
+void mm_destroy_sched(struct mm_struct *mm);
 #else /* !CONFIG_SCHED_CACHE */
 
 static inline int mm_alloc_sched(struct mm_struct *mm) { return 0; }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1e4136c2b2a3..7fd4ea8c9037 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2393,6 +2393,7 @@ struct sched_cache_time {
 
 struct sched_cache_stat {
 	struct sched_cache_time __percpu *pcpu_sched;
+	unsigned long *node_epoch;
 	raw_spinlock_t lock;
 	unsigned long epoch;
 	u64 nr_running_avg;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 00f49e767583..27cb05373a1d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1605,6 +1605,9 @@ void mm_init_sched(struct mm_struct *mm,
 	mm->sc_stat.next_scan = jiffies;
 	mm->sc_stat.nr_running_avg = 0;
 	mm->sc_stat.footprint = 0;
+	mm->sc_stat.node_epoch = kcalloc(num_possible_nodes(),
+					 sizeof(*mm->sc_stat.node_epoch),
+					 GFP_KERNEL);
 	/*
 	 * The update to mm->sc_stat should not be reordered
 	 * before initialization to mm's other fields, in case
@@ -1613,6 +1616,14 @@ void mm_init_sched(struct mm_struct *mm,
 	smp_store_release(&mm->sc_stat.pcpu_sched, _pcpu_sched);
 }
 
+void mm_destroy_sched(struct mm_struct *mm)
+{
+	free_percpu(mm->sc_stat.pcpu_sched);
+	mm->sc_stat.pcpu_sched = NULL;
+	kfree(mm->sc_stat.node_epoch);
+	mm->sc_stat.node_epoch = NULL;
+}
+
 /* because why would C be fully specified */
 static __always_inline void __shr_u64(u64 *val, unsigned int n)
 {
@@ -1700,7 +1711,9 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 {
 	struct sched_cache_time *pcpu_sched;
 	struct mm_struct *mm = p->mm;
+	unsigned long *node_epoch;
 	int mm_sched_llc = -1;
+	int node, pref_nid;
 	unsigned long epoch;
 
 	if (!sched_cache_enabled())
@@ -1724,6 +1737,11 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 		epoch = rq->cpu_epoch;
 	}
 
+	node_epoch = mm->sc_stat.node_epoch;
+	pref_nid = READ_ONCE(p->numa_preferred_nid);
+	if (pref_nid != NUMA_NO_NODE && mm->sc_stat.node_epoch)
+		mm->sc_stat.node_epoch[pref_nid] = epoch;
+
 	/*
 	 * If this process hasn't hit task_cache_work() for a while invalidate
 	 * its preferred state.
@@ -1733,6 +1751,16 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	    exceed_llc_capacity(mm, cpu_of(rq))) {
 		if (READ_ONCE(mm->sc_stat.cpu) != -1)
 			WRITE_ONCE(mm->sc_stat.cpu, -1);
+
+		if (node_epoch)
+			memset(mm->sc_stat.node_epoch, 0,
+				sizeof(*node_epoch) * num_possible_nodes());
+	} else if (node_epoch) {
+		for_each_node(node) {
+			if ((long)(epoch - READ_ONCE(node_epoch[node])) >
+			    llc_epoch_affinity_timeout)
+				WRITE_ONCE(node_epoch[node], 0);
+		}
 	}
 
 	mm_sched_llc = get_pref_llc(p, mm);
@@ -1777,10 +1805,12 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p)
 {
 #ifdef CONFIG_NUMA_BALANCING
 	int cpu, curr_cpu, nid, pref_nid;
+	unsigned long *node_epoch;
 
 	if (!static_branch_likely(&sched_numa_balancing))
 		goto out;
 
+	node_epoch = p->mm->sc_stat.node_epoch;
 	cpu = READ_ONCE(p->mm->sc_stat.cpu);
 	if (cpu != -1)
 		nid = cpu_to_node(cpu);
@@ -1801,6 +1831,18 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p)
 	if (pref_nid == NUMA_NO_NODE)
 		goto out;
 
+	if (node_epoch) {
+		int node;
+
+		for_each_node(node) {
+			if (node == pref_nid)
+				continue;
+
+			if (node_epoch[node] > 0)
+				cpumask_or(cpus, cpus, cpumask_of_node(node));
+		}
+	}
+
 	cpumask_or(cpus, cpus, cpumask_of_node(pref_nid));
 
 	/* honor the task's preferred LLC CPU */
-- 
2.34.1



