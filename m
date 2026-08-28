Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF94C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2B36B0099; Thu, 27 Aug 2026 22:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA776B009B; Thu, 27 Aug 2026 22:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C03B6B009D; Thu, 27 Aug 2026 22:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A74E6B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:17:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04421140259
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:17:37 +0000 (UTC)
X-FDA: 85149066996.10.71A311E
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3A02440003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:17:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf01.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787883455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OrQqZTjFnGf9mezTVInHxfcN3cqH/gfkDkygMSnCaNQ=;
	b=2wW0848wNZXOMjQ6F/sUTQ5j2A2WALE4X0ww8HXGZWjzBlbiaEXaaeS33d2T5iH41Maynp
	dbswmOK/B006eWMM6lgF48nT4KgLylaICisYC4Lghwj8RJq8OqbTA0dSu1Y94nUZ3QMUV+
	eLDFDJ7X7y4WUoYXkf53C8HaELi02RI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787883455;
	b=Zvu5fgr5rngAIT+xiTZhJZ4pqeaA8nTeQ0p5yrPca6s/moCot8hkJmc7j6B15NYFTT5AlG
	Nfk7ZmLoCZnFfSYM3n7j5WFf2DaSFUysaIqzfKe+V/e9bK7QwvKS2B73jsettvFWriugxC
	t+FW7GEYNwktKQCpxhkI8E3kD5D9zsU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf01.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMV40mxgz34Dg;
	Fri, 28 Aug 2026 10:17:32 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMV34F6Fz34Dg;
	Fri, 28 Aug 2026 10:17:31 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 5F1A63104800;
	Fri, 28 Aug 2026 10:13:48 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 28 Aug
 2026 10:17:29 +0800
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
Subject: [RFC PATCH v2 21/23] sched/cache: Spread workloads within an estimated LLC range
Date: Fri, 28 Aug 2026 10:13:32 +0800
Message-ID: <20260828021332.785700-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Stat-Signature: 31ai9z6fbdx6x79j1dfjkr8zpwxu35u8
X-Rspamd-Queue-Id: 3A02440003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787883455-425393
X-HE-Meta: U2FsdGVkX18p+/zblcR82i2It7lj1oTcLx1K/FfFfbV6pY3YdPwQGQAYpLoI/4s44+YjUji2Tj9E+gF07tYdXjmVwEavytKV79/WY/qVhuxhz2HgEPcj2PEW6Ot2tPHilSqkRhj5Igjs4d2CftX6gGNKwdy0q3/2f7hoxEfXq3LDm+PX9Hyg6Kxn7zprrVB88yJUpt+CLzPvxYsg9WiNaECqIUDLT3wL4cviG+qhZn8fFBkaCmB7pp+wi5TeBhl4NnKNyn5SYFS7YdpIgSOrXqMTui4ZZ0uPm4uy4vML4Du89p5OgjoXYaMepDhLlWZ0ImKqpshUaDhox5kDabBC8XzZ5bUqQhEVn2ZpseOLjyGolOtmxqGRSlp8yKU9Cyb4/3s4rwwdNsoZpdka8aDo1u21qTSUfMuk1BZocKuosZve9YiavHqWZ9m7T0nyl1Q5/mBuZta4afmxsH3pWt8FL35GSDPy1vfoWBO1ROClR4SZcL3CTRkI6p79Bu9UYyWg+ncBDlutcF0ntJJpVuqa5Dvy08spcqeiCfPXLuc4/goaQO9MMlPUsDTkDC5sNXRpTubnlzolSdkWCBm+R5HhqYL0L/Qk8gQng8XNaWHObkE+bK4AcB+kEJpSHgUlrzbWPsFPiO2OrEdaEKTSRTyX+SJj2WB61eg94UKCf5QUR7ATpJMl/o5/abV1OJ4F9zuC/pAOyyhLfjqAHP+r+VG09COR+znB+eS937UU2t/figeifNZpHoitsswVN9MxVZ59azgv73Pp0EKAMlPLFNdmRq1W89tKe9M4spAlfanhlBBMqWQv7JP3UYxVj2Y2qRlU4Z2gg424j0NyFoL6I5gfkGyYlGxtQuyW9QVKpcjbkjfX27Qb5paievB4sAyHs5RQEYyGLFjN1SLwdyP4CPMC45OoYSwS9eUCfIMRVVuVjwmNiVye5BMkFGne3Ab1K8XW4yp2p7blsX33XoLq/Du
 PLCXBAg0
 7JxMP3bp+CeSD1GGJ5sNJjtpQrtDVbpTdGftBuQGn22g8VH8hORMyL1gbuu/i8VoPWjCuMhHzZ1HWAeEW40PwHz4SmhrF6QZInwNq8Tbb5N1mdqqWT16ADSpVqhOU5OPk5RPr3zGBEJk0qYZQ2olsFwr7tfII/fQhffLvB/FLq4zRAcJwV1H66aPV4BsEP4Wy2e1qd68JReuofmi59xH871JL5jYW0ortKN6P23Olo8enmkM7WGPptw7+PqzG7/T+7RhRLhn7xclo34LfoTCW2jO8C8Ko3lRQG0PK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before this patch, migration of a task is forbidden if the previous
LLC in the preferred-LLC affinity sequence is not saturated, even
when the destination LLC falls within the thread-group's load range.
This hinders load spreading and causes LLC-level load aggregation.

To fix this issue, we first estimate the total load of the thread
group. Migration to the destination LLC is then permitted as long
as the target LLC lies within the acceptable load range. This change
accelerates load spreading and mitigates LLC load-aggregation.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 include/linux/sched.h   |   3 +
 kernel/sched/fair.c     | 332 +++++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h    |   1 +
 kernel/sched/topology.c |  14 +-
 4 files changed, 325 insertions(+), 25 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 96263bcb9e84..808a114c533d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1425,6 +1425,8 @@ struct task_struct {
 	int				preferred_llc;
 	/* 1: task was enqueued to its preferred LLC, 0 otherwise */
 	int				pref_llc_queued;
+	/* 1: task contributed to sched_domain::llc_counts */
+	int				pref_llc_counted;
 #endif
 
 	struct rseq_data		rseq;
@@ -2398,6 +2400,7 @@ struct sched_cache_stat {
 	unsigned long epoch;
 	u64 nr_running_avg;
 	u64 util_avg;
+	u64 llc_range;
 	unsigned long next_scan;
 	unsigned long footprint;
 	int cpu;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 848abcf93c47..def42490fa2a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1410,6 +1410,41 @@ __read_mostly unsigned int llc_epoch_affinity_timeout = EPOCH_LLC_AFFINITY_TIMEO
 __read_mostly unsigned int llc_imb_pct		= 20;
 __read_mostly unsigned int llc_overaggr_pct	= 50;
 
+#define MM_LLC_RANGE_INVALID	U64_MAX
+
+static u64 mm_llc_range_pack(int cpu, int dist)
+{
+	return (u64)(u32)cpu << 32 | (u32)dist;
+}
+
+static int mm_llc_range_cpu(u64 range)
+{
+	return upper_32_bits(range);
+}
+
+static int mm_llc_range_dist(u64 range)
+{
+	return lower_32_bits(range);
+}
+
+static int mm_estimated_range_dist(int pref_cpu, u64 group_util,
+				   u64 nr_running);
+static int mm_cache_distance(int pref_cpu, int cpu);
+
+static bool mm_llc_in_estimated_range(struct mm_struct *mm, int pref_cpu,
+				      int cpu)
+{
+	u64 range = READ_ONCE(mm->sc_stat.llc_range);
+	int dist;
+
+	if (range == MM_LLC_RANGE_INVALID ||
+	    mm_llc_range_cpu(range) != pref_cpu)
+		return false;
+
+	dist = mm_cache_distance(pref_cpu, cpu);
+	return dist >= 0 && dist <= mm_llc_range_dist(range);
+}
+
 static int llc_id(int cpu)
 {
 	if (cpu < 0)
@@ -1499,12 +1534,42 @@ static bool invalid_llc_nr(struct mm_struct *mm, struct task_struct *p,
 			(scale * per_cpu(sd_llc_size, cpu)));
 }
 
+static bool task_llc_affinity_counted(struct rq *rq, struct task_struct *p,
+				      int pref_llc)
+{
+	u64 range;
+	int pref_cpu;
+
+	if (pref_llc < 0)
+		return false;
+
+	/*
+	 * LLCs inside the estimated range are equivalent homes. Do not add
+	 * an anchor-directed affinity score while a task is already inside
+	 * that range; retain the anchor preference outside it so load balance
+	 * can still pull an escaped task back.
+	 */
+	pref_cpu = p->mm ? READ_ONCE(p->mm->sc_stat.cpu) : -1;
+	if (pref_cpu >= 0 && llc_id(pref_cpu) == pref_llc) {
+		range = READ_ONCE(p->mm->sc_stat.llc_range);
+		/* A single-LLC range still needs the original anchor affinity. */
+		if (range != MM_LLC_RANGE_INVALID &&
+		    mm_llc_range_cpu(range) == pref_cpu &&
+		    mm_llc_range_dist(range) > 0 &&
+		    mm_llc_in_estimated_range(p->mm, pref_cpu, cpu_of(rq)))
+			return false;
+	}
+
+	return true;
+}
+
 static void account_llc_enqueue(struct rq *rq, struct task_struct *p)
 {
 	int pref_llc, pref_llc_queued;
 	struct sched_domain *sd;
 
 	pref_llc = p->preferred_llc;
+	p->pref_llc_counted = 0;
 	if (pref_llc < 0)
 		return;
 
@@ -1529,12 +1594,14 @@ static void account_llc_enqueue(struct rq *rq, struct task_struct *p)
 	p->pref_llc_queued = pref_llc_queued;
 
 	sd = rcu_dereference_all(rq->sd);
-	if (sd && (unsigned int)pref_llc < sd->llc_max) {
+	if (sd && task_llc_affinity_counted(rq, p, pref_llc) &&
+	    (unsigned int)pref_llc < sd->llc_max) {
 		int pref_numa = llc_to_node(pref_llc);
 		sd->llc_counts[pref_llc]++;
 		if (sd->numa_counts &&
 		    (unsigned int)pref_numa < nr_node_ids)
 			sd->numa_counts[pref_numa]++;
+		p->pref_llc_counted = 1;
 	}
 }
 
@@ -1542,8 +1609,11 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
 {
 	struct sched_domain *sd;
 	int pref_llc;
+	int pref_llc_counted;
 
 	pref_llc = p->preferred_llc;
+	pref_llc_counted = p->pref_llc_counted;
+	p->pref_llc_counted = 0;
 	if (pref_llc < 0)
 		return;
 
@@ -1559,7 +1629,8 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
 	}
 
 	sd = rcu_dereference_all(rq->sd);
-	if (sd && (unsigned int)pref_llc < sd->llc_max) {
+	if (sd && pref_llc_counted &&
+	    (unsigned int)pref_llc < sd->llc_max) {
 		/*
 		 * There is a race condition between dequeue
 		 * and CPU hotplug. After a task has been enqueued
@@ -1605,6 +1676,7 @@ void mm_init_sched(struct mm_struct *mm,
 	mm->sc_stat.next_scan = jiffies;
 	mm->sc_stat.nr_running_avg = 0;
 	mm->sc_stat.util_avg = 0;
+	mm->sc_stat.llc_range = MM_LLC_RANGE_INVALID;
 	mm->sc_stat.footprint = 0;
 	mm->sc_stat.node_epoch = kcalloc(num_possible_nodes(),
 					 sizeof(*mm->sc_stat.node_epoch),
@@ -1695,6 +1767,7 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	struct sched_cache_time *pcpu_sched;
 	struct mm_struct *mm = p->mm;
 	unsigned long *node_epoch;
+	bool pref_llc_counted;
 	int mm_sched_llc = -1;
 	int node, pref_nid;
 	unsigned long epoch;
@@ -1734,6 +1807,7 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	    exceed_llc_capacity(mm, cpu_of(rq))) {
 		if (READ_ONCE(mm->sc_stat.cpu) != -1)
 			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		WRITE_ONCE(mm->sc_stat.llc_range, MM_LLC_RANGE_INVALID);
 
 		if (node_epoch)
 			memset(mm->sc_stat.node_epoch, 0,
@@ -1747,10 +1821,12 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	}
 
 	mm_sched_llc = get_pref_llc(p, mm);
+	pref_llc_counted = task_llc_affinity_counted(rq, p, mm_sched_llc);
 
 	/* task not on rq accounted later in account_entity_enqueue() */
 	if (task_running_on_cpu(rq->cpu, p)) {
-		if (READ_ONCE(p->preferred_llc) != mm_sched_llc) {
+		if (READ_ONCE(p->preferred_llc) != mm_sched_llc ||
+		    READ_ONCE(p->pref_llc_counted) != pref_llc_counted) {
 			account_llc_dequeue(rq, p);
 			WRITE_ONCE(p->preferred_llc, mm_sched_llc);
 			account_llc_enqueue(rq, p);
@@ -1918,6 +1994,7 @@ static void task_cache_work(struct callback_head *work)
 	    exceed_llc_capacity(mm, curr_cpu)) {
 		if (READ_ONCE(mm->sc_stat.cpu) != -1)
 			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		WRITE_ONCE(mm->sc_stat.llc_range, MM_LLC_RANGE_INVALID);
 
 		return;
 	}
@@ -2038,11 +2115,34 @@ static void task_cache_work(struct callback_head *work)
 	else if (pref_llc_cpu >= 0 && pref_llc_occ > 2 * curr_m_a_occ)
 		new_cpu = pref_llc_cpu;
 
+	update_avg_scale(&mm->sc_stat.nr_running_avg, nr_running);
+	update_mm_util_avg(&mm->sc_stat.util_avg, group_util);
+
+	/*
+	 * The estimated LLC range is consumed from the load-balance hot path.
+	 * Compute its distance frontier here, where a topology walk is cheap,
+	 * and publish the anchor and frontier in one 64-bit value so readers
+	 * never combine values from different preference updates.
+	 */
+	pref_cpu = new_cpu >= 0 ? new_cpu : READ_ONCE(mm->sc_stat.cpu);
+	if (pref_cpu >= 0) {
+		int range_dist = mm_estimated_range_dist(pref_cpu,
+					READ_ONCE(mm->sc_stat.util_avg),
+					READ_ONCE(mm->sc_stat.nr_running_avg));
+
+		if (range_dist >= 0)
+			WRITE_ONCE(mm->sc_stat.llc_range,
+				   mm_llc_range_pack(pref_cpu, range_dist));
+		else
+			WRITE_ONCE(mm->sc_stat.llc_range,
+				   MM_LLC_RANGE_INVALID);
+	} else {
+		WRITE_ONCE(mm->sc_stat.llc_range, MM_LLC_RANGE_INVALID);
+	}
+
 	if (new_cpu >= 0)
 		WRITE_ONCE(mm->sc_stat.cpu, new_cpu);
 
-	update_avg_scale(&mm->sc_stat.nr_running_avg, nr_running);
-	update_mm_util_avg(&mm->sc_stat.util_avg, group_util);
 	free_cpumask_var(cpus);
 }
 
@@ -2057,6 +2157,7 @@ void init_sched_mm(struct task_struct *p)
 	 * polluting account_llc_enqueue().
 	 */
 	p->preferred_llc = -1;
+	p->pref_llc_counted = 0;
 }
 
 #else /* CONFIG_SCHED_CACHE */
@@ -2068,8 +2169,7 @@ void init_sched_mm(struct task_struct *p) { }
 
 static void task_tick_cache(struct rq *rq, struct task_struct *p) { }
 
-static inline int get_pref_llc(struct task_struct *p,
-			       struct mm_struct *mm)
+static inline int get_pref_llc(struct task_struct *p, struct mm_struct *mm)
 {
 	return -1;
 }
@@ -10526,6 +10626,16 @@ static inline int task_is_ineligible_on_dst_cpu(struct task_struct *p, int dest_
 }
 
 #ifdef CONFIG_SCHED_CACHE
+static u32 llc_aggr_capacity_pct(void)
+{
+	u32 aggr_pct = READ_ONCE(llc_overaggr_pct);
+
+	if (cpu_smt_num_threads == 1)
+		aggr_pct = aggr_pct * 3 / 2;
+
+	return aggr_pct;
+}
+
 /*
  * The margin used when comparing LLC utilization with CPU capacity.
  * It determines the LLC load level where active LLC aggregation is
@@ -10536,16 +10646,18 @@ static inline int task_is_ineligible_on_dst_cpu(struct task_struct *p, int dest_
  */
 static bool fits_llc_capacity(unsigned long util, unsigned long max)
 {
-	u32 aggr_pct = llc_overaggr_pct;
+	return util * 100 < max * llc_aggr_capacity_pct();
+}
 
-	/*
-	 * For single core systems, raise the aggregation
-	 * threshold to accommodate more tasks.
-	 */
-	if (cpu_smt_num_threads == 1)
-		aggr_pct = (aggr_pct * 3 / 2);
+/* The estimated range may be filled exactly to the aggregation margin. */
+static bool fits_llc_range_capacity(unsigned long util, unsigned long max)
+{
+	return util * 100 <= max * llc_aggr_capacity_pct();
+}
 
-	return util * 100 < max * aggr_pct;
+static bool fits_llc_full_capacity(unsigned long util, unsigned long max)
+{
+	return util <= max;
 }
 
 /*
@@ -10668,6 +10780,143 @@ static bool get_span_stats(const struct cpumask *span, unsigned long *util_out,
 	return true;
 }
 
+/*
+ * Return the cache distance from the mm's preferred CPU to @cpu. LLCs in
+ * the preferred NUMA node are ordered relative to the preferred LLC. For a
+ * remote node, start at the node distance and add the target LLC's position
+ * in that node's cached LLC order. This makes the first LLC in a remote node
+ * the nearest one and opens the remaining LLCs one at a time.
+ */
+static int mm_cache_distance(int pref_cpu, int cpu)
+{
+	int pref_node = cpu_to_node(pref_cpu);
+	int node = cpu_to_node(cpu);
+	int anchor_llc, node_dist, offset;
+
+	if (pref_node == node)
+		return llc_intra_node_distance(llc_id(pref_cpu), llc_id(cpu),
+					       pref_node);
+
+	/*
+	 * for_each_llc_node_span() orders a remote node from its first LLC.
+	 * Reuse that anchor here. From the first LLC, the intra-node distance
+	 * is 0 for itself and local_rank + 1 for every other LLC, so removing
+	 * the non-zero bias gives the required zero-based offset.
+	 */
+	if (!llc_node_span_by_dist(node, 0, &anchor_llc))
+		return -1;
+
+	offset = llc_intra_node_distance(anchor_llc, llc_id(cpu), node);
+	if (offset < 0)
+		return -1;
+	if (offset)
+		offset--;
+
+	node_dist = sched_cache_node_distance(pref_node, node);
+	if (node_dist < 0)
+		return -1;
+
+	/*
+	 * De-duplicated node distances are only guaranteed to differ by one,
+	 * while @offset spans the node's LLC count. Adding them directly lets
+	 * two nodes share distance values, so a single tier would open LLCs
+	 * from several nodes at once instead of filling the nearest node
+	 * first. Scale the node distance past the widest node to keep the
+	 * per-node ranges disjoint.
+	 */
+	return node_dist * READ_ONCE(llc_node_stride) + offset;
+}
+
+/*
+ * Convert the mm utilization estimate into the furthest cache-distance tier
+ * it needs. This runs from task_cache_work(), rather than can_migrate_node(),
+ * so load balance does not walk every LLC for every migration candidate.
+ *
+ * Use an inclusive capacity boundary: an mm whose utilization is exactly 50%
+ * of an LLC fits that LLC and does not require the next tier. If the estimate
+ * exceeds the configured budget of the whole machine, return the last tier so
+ * every LLC remains eligible.
+ */
+static int mm_estimated_range_dist(int pref_cpu, u64 group_util,
+				   u64 nr_running)
+{
+	const struct cpumask *span;
+	u64 budget = 0;
+	unsigned long util, cap;
+	int frontier = -1, last_dist = -1, node;
+
+	if (!group_util)
+		return -1;
+
+	/*
+	 * Build the range one cache-distance tier at a time.  The topology
+	 * iterators order nodes relative to @pref_cpu, but LLCs within each
+	 * node are cached relative to that node's first LLC.  Consequently,
+	 * their nested iteration order is not necessarily monotonic from the
+	 * mm's actual preferred LLC.  Returning the distance of the first LLC
+	 * visited could therefore make a one-LLC estimate cover several LLCs.
+	 *
+	 * A distance is also a range boundary, so all LLCs at an equal distance
+	 * become eligible together.  Account their capacity together as well;
+	 * otherwise one remote LLC's capacity could open its whole distance
+	 * tier.
+	 */
+	for (;;) {
+		u64 tier_budget = 0, tier_capacity = 0;
+		int next_dist = INT_MAX;
+
+		for_each_sched_node(pref_cpu, node) {
+			for_each_llc_node_span(node, span) {
+				int cpu = cpumask_first(span);
+				int dist = mm_cache_distance(pref_cpu, cpu);
+
+				if (dist < 0)
+					return -1;
+				if (dist > frontier && dist < next_dist)
+					next_dist = dist;
+			}
+		}
+
+		if (next_dist == INT_MAX)
+			break;
+
+		for_each_sched_node(pref_cpu, node) {
+			for_each_llc_node_span(node, span) {
+				int cpu = cpumask_first(span);
+
+				if (mm_cache_distance(pref_cpu, cpu) != next_dist)
+					continue;
+				if (!get_llc_stats(cpu, &util, &cap))
+					return -1;
+
+				tier_capacity += cap;
+				tier_budget += mul_u64_u32_div(cap,
+						llc_aggr_capacity_pct(), 100);
+			}
+		}
+
+		/*
+		 * A workload whose active parallelism and utilization both fit a
+		 * single LLC does not oversubscribe it.  Keep the original single
+		 * anchor in that case: spreading communicating threads merely because
+		 * they cross the aggregation margin loses locality without creating
+		 * CPU capacity.  Larger workloads still grow at the configured margin.
+		 */
+		if (next_dist == 0 && group_util <= tier_capacity &&
+		    nr_running * SCHED_CAPACITY_SCALE <= tier_capacity)
+			return 0;
+
+		budget += tier_budget;
+		last_dist = next_dist;
+		if (group_util <= budget)
+			return next_dist;
+
+		frontier = next_dist;
+	}
+
+	return last_dist;
+}
+
 /*
  * Decide if migration should happen on a specific node.
  * The node here is an LLC or a NUMA.
@@ -10676,11 +10925,12 @@ static enum llc_mig can_migrate_node(int src_cpu, int dst_cpu,
 			struct task_struct *p, bool to_pref)
 {
 	const struct cpumask *span;
-	struct mm_struct *mm;
+	struct mm_struct *mm = NULL;
+	bool single_llc_range = false;
 	unsigned long dst_util, dst_cap, tsk_util = 0;
 	unsigned long src_util = 0, src_cap = 0;
 	unsigned long acc_util = 0, acc_cap = 0, dst_pre;
-	int node, target_cpu = src_cpu;
+	int node, target_cpu = src_cpu, mm_cpu = -1;
 	int get_src = 0;
 
 	if (!get_llc_stats(dst_cpu, &dst_util, &dst_cap))
@@ -10692,8 +10942,16 @@ static enum llc_mig can_migrate_node(int src_cpu, int dst_cpu,
 	if (p) {
 		mm = p->mm;
 		if (mm) {
-			if (mm->sc_stat.cpu >= 0)
-				target_cpu = mm->sc_stat.cpu;
+			mm_cpu = READ_ONCE(mm->sc_stat.cpu);
+			if (mm_cpu >= 0) {
+				u64 range = READ_ONCE(mm->sc_stat.llc_range);
+
+				target_cpu = mm_cpu;
+				single_llc_range =
+					range != MM_LLC_RANGE_INVALID &&
+					mm_llc_range_cpu(range) == mm_cpu &&
+					mm_llc_range_dist(range) == 0;
+			}
 		}
 		tsk_util = task_util(p);
 	}
@@ -10701,7 +10959,27 @@ static enum llc_mig can_migrate_node(int src_cpu, int dst_cpu,
 	dst_util = dst_util + tsk_util;
 	dst_pre = dst_util - tsk_util;
 
+	/*
+	 * Do not let a nearer LLC that can hold one task veto a destination
+	 * which the mm's aggregate demand is expected to need. The range check
+	 * says the destination belongs to the area needed by the whole mm. Let
+	 * it fill exactly to the aggregation margin; the ordinary strict check
+	 * would reject that boundary and strand runnable tasks on busier LLCs.
+	 */
+	if (!to_pref && mm_cpu >= 0 &&
+	    mm_llc_in_estimated_range(mm, target_cpu, dst_cpu) &&
+	    fits_llc_range_capacity(dst_util, dst_cap))
+		return mig_llc;
+
 	if (to_pref) {
+		/*
+		 * A single-LLC range means the mm fits without oversubscribing
+		 * the anchor.  Preserve that locality up to the LLC's full
+		 * capacity instead of applying the aggregation margin.
+		 */
+		if (single_llc_range && cpus_share_cache(dst_cpu, target_cpu) &&
+		    fits_llc_full_capacity(dst_util, dst_cap))
+			return mig_llc;
 
 		if (fits_llc_capacity(dst_util, dst_cap))
 			return mig_llc;
@@ -10727,6 +11005,11 @@ static enum llc_mig can_migrate_node(int src_cpu, int dst_cpu,
 		return mig_forbid;
 	}
 
+	/* Do not split a fitting single-LLC mm merely at the aggr margin. */
+	if (single_llc_range && cpus_share_cache(src_cpu, target_cpu) &&
+	    src_cap && fits_llc_full_capacity(src_util, src_cap))
+		return mig_forbid;
+
 	for_each_sched_node(target_cpu, node) {
 		unsigned long u = 0, c = 0, nu, nc;
 
@@ -10861,6 +11144,7 @@ static enum llc_mig can_migrate_llc_task(int src_cpu, int dst_cpu,
 	    exceed_llc_capacity(mm, dst_cpu)) {
 		if (READ_ONCE(mm->sc_stat.cpu) != -1)
 			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		WRITE_ONCE(mm->sc_stat.llc_range, MM_LLC_RANGE_INVALID);
 		return mig_unrestricted;
 	}
 
@@ -13601,12 +13885,12 @@ static inline bool llc_spread_active_balance(struct lb_env *env)
 		return false;
 
 	/*
-	 * Only move when the destination still fits with a full CPU of the load
-	 * added, and when the source leads by at least two CPUs worth, so that
-	 * moving one task cannot invert the imbalance and bounce it straight
-	 * back.
+	 * Only move when the destination still fits with a full CPU of load
+	 * added. The estimated range deliberately permits the exact aggregation
+	 * boundary, otherwise a three-task LLC cannot pull the fourth task needed
+	 * to balance a four-task-per-LLC workload.
 	 */
-	if (!fits_llc_capacity(dst_util + SCHED_CAPACITY_SCALE, dst_cap))
+	if (!fits_llc_range_capacity(dst_util + SCHED_CAPACITY_SCALE, dst_cap))
 		return false;
 
 	/* Avoid threads ping-pong migration */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3d3f1d40a672..e13775e9b177 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4125,6 +4125,7 @@ extern int sched_node_order_at(int cpu, int idx);
 	     ((node) = sched_node_order_at((cpu), __sn_idx)) >= 0;	\
 	     __sn_idx++)
 
+extern int llc_node_stride;
 extern int llc_node_count(int node);
 extern const struct cpumask *llc_node_span_by_dist(int node, int index, int *llc_out);
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 73d0c44dea92..13d360070679 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -722,6 +722,13 @@ struct llc_local_rank_topology {
 };
 
 static struct llc_local_rank_topology __rcu *llc_local_rank_topo;
+
+/*
+ * Largest number of LLCs held by any single NUMA node. mm_cache_distance()
+ * multiplies the node distance by this so that one node's per-LLC offsets
+ * cannot reach into the next node's range.
+ */
+int llc_node_stride __read_mostly = 1;
 static void rebuild_llc_local_rank(int size);
 #endif
 
@@ -1375,7 +1382,7 @@ static void free_llc_local_rank_topology(struct llc_local_rank_topology *topo)
 static void rebuild_llc_local_rank(int size)
 {
 	struct llc_local_rank_topology *topo, *old;
-	int llc, node;
+	int llc, node, stride;
 
 	if (size <= 0)
 		return;
@@ -1400,6 +1407,11 @@ static void rebuild_llc_local_rank(int size)
 		topo->rank[llc] = topo->node_count[node]++;
 	}
 
+	stride = 1;
+	for (node = 0; node < nr_node_ids; node++)
+		stride = max(stride, topo->node_count[node]);
+	WRITE_ONCE(llc_node_stride, stride);
+
 	old = rcu_dereference_protected(llc_local_rank_topo,
 					 lockdep_is_held(&sched_domains_mutex));
 	rcu_assign_pointer(llc_local_rank_topo, topo);
-- 
2.34.1



