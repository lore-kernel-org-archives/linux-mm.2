Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C96C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE82C6B0098; Thu, 27 Aug 2026 08:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99266B009B; Thu, 27 Aug 2026 08:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFD66B009D; Thu, 27 Aug 2026 08:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 710D46B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E64671C1CA1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:26 +0000 (UTC)
X-FDA: 85146990012.08.A4D1CE9
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf25.hostedemail.com (Postfix) with ESMTP id DFB77A0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf25.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787834005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kOO+O1N0i2pRz4fHoGy2lSSHVUFQXGxckc2U7pOlVrg=;
	b=3duZpkCYro9TmfCkNjEJtNGt/ptr7P+Ci537sD86R6/Wlbymgamt6+V2rJXB5vpTIzogUj
	LjpSnWpwfjlvWOtTsU5tAR3DvhofKOdJdc0T/BUnKT1x1j5iRl8tgoQb03+F0T1W9eSPhi
	fC3hA3h5AhdljCtkpKCHzhakXo3pn+s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf25.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787834005;
	b=OEYGqZgVcYPvGkGTXJD1CFNpx+vwgpC9ooSw+sibLhXocLgeVlZsauM4q7fdC0WjGugKWu
	XbugBA64uWsEf1RFus6cMwb8601ssxu/TXNkXUsv+7lo9rX2Md55YLsD1dAgUX5NP1iyJ9
	Qbk1XuiBCoJT/g0CtORNg5NOFfx1l1w=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1C60WLDzBJb6g;
	Thu, 27 Aug 2026 20:33:22 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1C44rBxzBJb6b;
	Thu, 27 Aug 2026 20:33:20 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 432F178AD;
	Thu, 27 Aug 2026 20:33:13 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:19 +0800
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
Subject: [RFC PATCH v2 07/23] sched/cache: Prioritize preferred NUMA node selection over LLC selection
Date: Thu, 27 Aug 2026 20:28:00 +0800
Message-ID: <20260827122816.756234-8-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6jxmqa4k4zmsn9edfhr3af4hdjj56y59
X-Rspamd-Queue-Id: DFB77A0009
X-HE-Tag: 1787834004-497748
X-HE-Meta: U2FsdGVkX18ri9FEdtkMCfEqeOpEeV/mrZQJu7ZNJeOUpXf2iZ0O8wTzm76RqBpYbFfSdgjZb/pv0bgdVVtoZd4RWezmsUCpjk+8Af5zRlRst9M5bGGI9Axr7/ZBuxYctnz2txQ6VWzyB0jXuAdPahf641ivA6/cx8fRFTlF0x9EDuoMUH+lqsgtXZmz9lzW9OCRUiviQN/XnYAEjeV5/RaxM1w5QJvvEMts0ZAulgruqf86s5o7BCWL9+s4pRuQwM7aTMA0ry+8s/5HWl7jG0EOy3y20VDKARIGsQ4A1v3pMZsTm2zuv2lGpJ5Bd5QGzKUOiv9OW1A0K2/oUJgslMbVe0ZCFUuVmBzD12Jt28Sfglrw71W4GUNZgyX2kUzcwburmvY2deemdnkqI2lfiCL3iR46i1x0TtNh1Yg2lZCNHqp1tlGckgPeR2eeLZ3VL78rmPtwsJ18YT9ARRMFT2J9AVtaRagsQ+nzAGqVJ/VHj+mfsdyK073iszhpTulZTAlN/n+kOwbUh2svjJDye4jghZ//TZsfkCuO09lPaATlJz0Mv7vrcWT3qHFVEDULpiBlWpPBSDDGePSDCGRFN/uLhto4/dvMUQkMWMTk9xFJAnvp2gVMvM+IDf/phVes2m1zR32Oq2N6kU362rLFUBx+pAsc3L0Dq6O9PuSdzpORiVP5rLIDuIh53f5EF34MXwvhjTRO3p8Jf8IYDj0pm1r0MAeFyOwFYmGHgBNcrG4hWL4jrfNGn4bIXRS1lKt8FIaZLB2tI0mwCx96FAQ8NXEs7v677BMC5xIK7idoSNlR6o5zYl3AA0m4K6xgRw85rcNApNWmJTukRRlvL+4YCRyZt7VOgGDyV9P79G1leA//TL2Zi/CjntGI/PGcZzDr02i5HeQEcCjhPOW5UL+v6lEdDEDOO6Jcf0lDd6lcafeD9bTwUAZyiaBKqDr930nf5GDX5zroLfQn5ybK4m+
 5DYZ4MK6
 UX2fJn9HpUOGPRv+4Zjzrosjl4WkoXyiA+XtMli5tYd0Uf8zoYCORs5MCghLgJuFG/1W91s95LuECGKvtj3a7ODyNI6DjDogS871h5xuAWl0YKBrPQn5pWYSaijld1GUrR8nvKA+7wLJQQTQHfhSU86+Wt2PhxLMtpQgZ2ukTlQkSVfxb3q9fF+R6UTZfaWhQRS8S6/FA+o7Y9oxKuF/qC4jmfuFmrLbl8JSePqciS58xefA47+jDQFngwxl0fzf5no/0FvFI3NtqL6aQ43d/toth720fX+EbMmkW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the current implementation, the preferred LLC is selected based on the
LLC with the largest running time of the thread group. However, the
preferred LLC may be prone to frequent migration when the workload
spreads across the entire system, especially when the number of CPUs
sharing an LLC is small. A better approach is to first select a preferred
NUMA node in the same way, and then select the preferred LLC within that
preferred NUMA node.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 131 +++++++++++++++++++++++++++-----------------
 1 file changed, 82 insertions(+), 49 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f15f5764818e..30de09ebd9f6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1826,12 +1826,13 @@ static inline void update_avg_scale(u64 *avg, u64 sample)
 
 static void task_cache_work(struct callback_head *work)
 {
-	int cpu, m_a_cpu = -1, nr_running = 0, curr_cpu;
 	unsigned long next_scan, now = jiffies;
 	struct task_struct *p = current, *cur;
-	unsigned long curr_m_a_occ = 0;
 	struct mm_struct *mm = p->mm;
-	unsigned long m_a_occ = 0;
+	unsigned long m_a_n_occ = 0, curr_m_a_n_occ = 0, curr_m_a_occ = 0;
+	unsigned long pref_llc_occ = 0;
+	int cpu, m_a_n_cpu = -1, nr_running = 0, curr_cpu;
+	int pref_cpu, pref_llc_cpu = -1, new_cpu = -1;
 	cpumask_var_t cpus;
 
 	WARN_ON_ONCE(work != &p->cache_work);
@@ -1863,6 +1864,13 @@ static void task_cache_work(struct callback_head *work)
 	if (!zalloc_cpumask_var(&cpus, GFP_KERNEL))
 		return;
 
+	/*
+	 * Sample the current preference once, up front. Re-reading it during
+	 * the scan would let a choice made while walking one node feed into
+	 * the comparison made for the next one.
+	 */
+	pref_cpu = READ_ONCE(mm->sc_stat.cpu);
+
 	scoped_guard (cpus_read_lock) {
 		guard(rcu)();
 
@@ -1870,68 +1878,93 @@ static void task_cache_work(struct callback_head *work)
 
 		for_each_cpu(cpu, cpus) {
 			/* XXX sched_cluster_active */
-			struct sched_domain *sd = rcu_dereference_all(per_cpu(sd_llc, cpu));
-			unsigned long occ, m_occ = 0, a_occ = 0;
-			int m_cpu = -1, i;
+			struct sched_domain *nsd = per_cpu(sd_node, cpu);
+			unsigned long occ, m_occ, a_occ, a_n_occ = 0;
+			unsigned long m_llc_occ = 0;
+			int m_llc_cpu = -1, m_cpu, i, k;
 
-			if (!sd)
+			if (!nsd)
 				continue;
 
-			for_each_cpu(i, sched_domain_span(sd)) {
-				occ = fraction_mm_sched(cpu_rq(i),
+			for_each_cpu_and(k, sched_domain_span(nsd), cpus) {
+				a_occ = m_occ = 0;
+				m_cpu = -1;
+				/* XXX sched_cluster_active */
+				struct sched_domain *sd =
+					rcu_dereference_all(per_cpu(sd_llc, k));
+
+				if (!sd)
+					continue;
+
+				for_each_cpu(i, sched_domain_span(sd)) {
+					occ = fraction_mm_sched(cpu_rq(i),
 							per_cpu_ptr(mm->sc_stat.pcpu_sched, i));
-				a_occ += occ;
-				if (occ > m_occ) {
-					m_occ = occ;
-					m_cpu = i;
+					a_occ += occ;
+					if (occ > m_occ) {
+						m_occ = occ;
+						m_cpu = i;
+					}
+
+					cur = rcu_dereference_all(cpu_rq(i)->curr);
+					if (cur && !(cur->flags & (PF_EXITING | PF_KTHREAD)) &&
+					    cur->mm == mm)
+						nr_running++;
 				}
 
-				cur = rcu_dereference_all(cpu_rq(i)->curr);
-				if (cur && !(cur->flags & (PF_EXITING | PF_KTHREAD)) &&
-				    cur->mm == mm)
-					nr_running++;
+				cpumask_andnot(cpus, cpus, sched_domain_span(sd));
+				if (a_occ > m_llc_occ) {
+					m_llc_occ = a_occ;
+					m_llc_cpu = m_cpu;
+				}
+				if (pref_cpu >= 0 && llc_id(pref_cpu) == llc_id(k))
+					curr_m_a_occ = a_occ;
+				/* record for numa node */
+				a_n_occ += a_occ;
 			}
 
 			/*
-			 * Compare the accumulated occupancy of each LLC. The
-			 * reason for using accumulated occupancy rather than average
-			 * per CPU occupancy is that it works better in asymmetric LLC
-			 * scenarios.
-			 * For example, if there are 2 threads in a 4CPU LLC and 3
-			 * threads in an 8CPU LLC, it might be better to choose the one
-			 * with 3 threads. However, this would not be the case if the
-			 * occupancy is divided by the number of CPUs in an LLC (i.e.,
-			 * if average per CPU occupancy is used).
-			 * Besides, NUMA balancing fault statistics behave similarly:
-			 * the total number of faults per node is compared rather than
-			 * the average number of faults per CPU. This strategy is also
-			 * followed here.
+			 * Remember the busiest LLC of the node the preference
+			 * currently points at, so that the LLC level decision can
+			 * be taken once, after the whole scan.
 			 */
-			if (a_occ > m_a_occ) {
-				m_a_occ = a_occ;
-				m_a_cpu = m_cpu;
+			if (pref_cpu >= 0 && m_llc_cpu >= 0 &&
+			    cpu_to_node(pref_cpu) == cpu_to_node(m_llc_cpu)) {
+				pref_llc_occ = m_llc_occ;
+				pref_llc_cpu = m_llc_cpu;
 			}
 
-			if (llc_id(cpu) == llc_id(READ_ONCE(mm->sc_stat.cpu)))
-				curr_m_a_occ = a_occ;
+			if (a_n_occ > m_a_n_occ) {
+				m_a_n_occ = a_n_occ;
+				m_a_n_cpu = m_llc_cpu;
+			}
 
-			cpumask_andnot(cpus, cpus, sched_domain_span(sd));
+			if (pref_cpu >= 0 &&
+			    cpu_to_node(cpu) == cpu_to_node(pref_cpu))
+				curr_m_a_n_occ = a_n_occ;
 		}
 	}
 
-	if (m_a_occ > (2 * curr_m_a_occ)) {
-		/*
-		 * Avoid switching sc_stat.cpu too fast.
-		 * The reason to choose 2X is because:
-		 * 1. It is better to keep the preferred LLC stable,
-		 *    rather than changing it frequently and cause migrations
-		 * 2. 2X means the new preferred LLC has at least 1 more
-		 *    busy CPU than the old one(200% vs 100%, eg)
-		 * 3. 2X is chosen based on test results, as it delivers
-		 *    the optimal performance gain so far.
-		 */
-		WRITE_ONCE(mm->sc_stat.cpu, m_a_cpu);
-	}
+	/*
+	 * Avoid switching sc_stat.cpu too fast. The reason to choose 2X is
+	 * because:
+	 * 1. It is better to keep the preferred LLC stable, rather than
+	 *    changing it frequently and cause migrations
+	 * 2. 2X means the new preferred LLC has at least 1 more busy CPU than
+	 *    the old one(200% vs 100%, eg)
+	 * 3. 2X is chosen based on test results, as it delivers the optimal
+	 *    performance gain so far.
+	 *
+	 * Moving to another node takes precedence over moving inside the
+	 * current one, as it did when the two updates were applied in that
+	 * order.
+	 */
+	if (m_a_n_occ > 2 * curr_m_a_n_occ)
+		new_cpu = m_a_n_cpu;
+	else if (pref_llc_cpu >= 0 && pref_llc_occ > 2 * curr_m_a_occ)
+		new_cpu = pref_llc_cpu;
+
+	if (new_cpu >= 0)
+		WRITE_ONCE(mm->sc_stat.cpu, new_cpu);
 
 	update_avg_scale(&mm->sc_stat.nr_running_avg, nr_running);
 	free_cpumask_var(cpus);
-- 
2.34.1



