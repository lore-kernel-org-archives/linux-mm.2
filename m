Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ABC3606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897376B05C0; Wed, 28 Oct 2026 23:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E5D6B05C1; Wed, 28 Oct 2026 23:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D4A6B05C2; Wed, 28 Oct 2026 23:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1CF6B05C0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:01:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DAE31A025C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:01:27 +0000 (UTC)
X-FDA: 85374163014.04.74E1D00
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf01.hostedemail.com (Postfix) with ESMTP id 37ABD40008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:01:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf01.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v2WxOJQXc1Rpx1VWweZKIZ05Pcv9QyrOy3INkyTffTk=;
	b=64yZaf0oxq0F0vcUnj/HRkVoVjcqTW8zosRg6Bj3qW9uVLHOQuK9ONxUurZ+FD7nj67G/l
	DeuT09Zo134gCvCh/6q7k5OZqf/rLUZ4orIZpt80yVE3eMWOG/lbiV+BwCXkvroeJe5i6z
	tHBc4ai/RpcsIcd/YPACiY/S4piHKdY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf01.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242886;
	b=0TAMwz3/LdFhObkbmZb+dJuRwhcv3YyfRfYlSMLTUJvyNSk2flEeihYl0QQAt66Wbeyx+l
	WWUrozPmiOt9G50HTWyjcL2BS26g5tzp70DK8k1pIUKPGy+KXLmxhL3R+T3m65QAPsIOFX
	kwD2OFiLPOy6CPlU2a7TeYyJQtF2pAs=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFTX11XDmz171Ys;
	Thu, 29 Oct 2026 11:01:21 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFTWz08wDz171Yf;
	Thu, 29 Oct 2026 11:01:19 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 2405378B2;
	Thu, 29 Oct 2026 11:01:12 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 11:01:17 +0800
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
Subject: [RFC PATCH v3 15/17] sched/cache: Include recently used preferred nodes in LLC scans
Date: Thu, 29 Oct 2026 10:56:14 +0800
Message-ID: <20261029025614.4004884-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Queue-Id: 37ABD40008
X-Stat-Signature: k6p14maa7gek1yg5p35rimwuh9trr96g
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793242884-690525
X-HE-Meta: U2FsdGVkX19Ae3f5q/SLpD59GH/s+0xfpjJunM6OoUlNFvYuyKgf9z3YxTYvbcBB3AR/vq9fa0l1kMScfe76ra6jIM7k67R66IvgVTzoDzqGXadKQxASUKGiN0MnXyemZU0TJ1YRogThZFKxg4o/qpkWtjOvHnLik5SI4Z9uP5raUjwVc4TKKBplMld+Zohem/HEYZVvu4z4VR8ZBmg0/gDGeBpDMiVJ1VzfCDnw3KtwaB+kO5cRGr9GTQcSOu9S+gzkMEiEQ2Xa03rIsmTzE6QAayN2D6njZfN/dUL7nzmr0ZLRNKblUz7pyNSCAyusuUQKeFgVWd40gtt+pELslLBttSUyWrw49PQ43eNzut8gPgoYkvaI3swLZ4hDqqI4cxoeMMJL7VAuBQvKflru6hd6AmK0FJvkVQS05oBA0vQoA9AbYNnwpyKTMDQxauueCBPEphUNXgW4RY9JjbApTAYvbFKOEaK7Ts+DAJ7A2KlUBTbJ+5yTzpCBMpV27XWog+Q0H/FVRy5tdG9C8014zN4G7m1GaqFGTHXlAB4NCtxh81FgB2va9qQbz3jz9Lkm/6c7tSHHMoUR3fkegD7nwJ7ncIoTAKxCVJO3/DCktT+Mdipm1qO4PGWMzyHBHjeT3ma8ptjSoFPcZ7RYd3eqneTUbWFIC0eMHdQ3Od0lTDja95CrWPb96TyzQ7eKw6AakN32AnkEBrfCWsAV6ZQ79pyZ8pLvFvYQI+w5nLFF5vZAeUBXMRPMNAEfhU4z/Fnw9uMFH/Phn+0lSUdaiyh/y49D99dqQEo4xvfMxP0vRRslT4paCXPaFgzXkx2XGwPNBrHASGEDLOtFkqvjIU6PgZ7mCQPh6vrVw92wKxxtMTDc/IaE9Hn9hTeICudCIs/yDI3nh0gy4fjnTn67iAeUeLZUJ5hBKnaLPtibGFZYzX7Czw3MwsbXULL+8zsXZwp439SjX6ePL1xYJmL1dqg
 Hp51jtmS
 gfvKSuZTN3vNsiBje+79GGpuC6OAtl6BWIOIzptiApEFzoBukF8NyhsMA42SAVVxa2bERgFUSeB0+pdwinIXV2tb0ulkStLkZE/LLkTjIUxePUAHiwmb/YuikaJl9KTkQ00fxAQVNSGjSk5H8iRBsWwabrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_scan_cpumasks() includes the current task's preferred NUMA node,
but other tasks sharing the mm may prefer different nodes. This makes
the LLC scan scope depend on which task performs the scan.

Record preferred nodes observed while accounting tasks that share the
mm, and include recently observed nodes in the scan mask. Expire stale
records using the LLC affinity timeout and clear them when the mm's
preferred cache state is invalidated.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 include/linux/mm_types.h |  6 +-----
 include/linux/sched.h    |  1 +
 kernel/sched/fair.c      | 44 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 5 deletions(-)

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
index 20a6a7f5c2f7..b93b6e6c9dea 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1594,6 +1594,9 @@ void mm_init_sched(struct mm_struct *mm,
 	mm->sc_stat.next_scan = jiffies;
 	mm->sc_stat.nr_running_avg = 0;
 	mm->sc_stat.footprint = 0;
+	mm->sc_stat.node_epoch = kcalloc(num_possible_nodes(),
+					 sizeof(*mm->sc_stat.node_epoch),
+					 GFP_KERNEL);
 	/*
 	 * The update to mm->sc_stat should not be reordered
 	 * before initialization to mm's other fields, in case
@@ -1602,6 +1605,14 @@ void mm_init_sched(struct mm_struct *mm,
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
@@ -1689,7 +1700,9 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 {
 	struct sched_cache_time *pcpu_sched;
 	struct mm_struct *mm = p->mm;
+	unsigned long *node_epoch;
 	int mm_sched_llc = -1;
+	int node, pref_nid = NUMA_NO_NODE;
 	unsigned long epoch;
 
 	if (!sched_cache_enabled())
@@ -1713,6 +1726,13 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 		epoch = rq->cpu_epoch;
 	}
 
+	node_epoch = mm->sc_stat.node_epoch;
+#ifdef CONFIG_NUMA_BALANCING
+	pref_nid = READ_ONCE(p->numa_preferred_nid);
+#endif
+	if (pref_nid != NUMA_NO_NODE && mm->sc_stat.node_epoch)
+		mm->sc_stat.node_epoch[pref_nid] = epoch;
+
 	/*
 	 * If this process hasn't hit task_cache_work() for a while invalidate
 	 * its preferred state.
@@ -1722,6 +1742,16 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
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
@@ -1765,10 +1795,12 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p)
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
@@ -1789,6 +1821,18 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p)
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



