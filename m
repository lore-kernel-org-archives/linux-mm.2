Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8CF606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724276B05BB; Wed, 28 Oct 2026 22:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBE36B05BC; Wed, 28 Oct 2026 22:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6123C6B05BD; Wed, 28 Oct 2026 22:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 403F36B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:30:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C70E4A75A0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:30:15 +0000 (UTC)
X-FDA: 85374084390.12.9B41F3A
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf09.hostedemail.com (Postfix) with ESMTP id 332BF140008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:30:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf09.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793241013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=anwB4tQveasnMNBaC79HF4iqwVuUGDsqZ8YnV4hzKPo=;
	b=P5WpdXwgOf5+g3skVnRyDvfiAMq0cH47M/OViZLJuWe6L4BRUwGxN0kog68Uh5lz4jFoE3
	UvEcuZ+VxSQQkntX35J32ofOnmHdESKCMErPRt620YvCPDDsDyIr1hzn/DFebxDCPtWWy0
	v5K5wXUAYAV8CQg+Qby/Ma6GLSs2wFI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf09.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793241013;
	b=4Vm0e3P5k2HKFwPT0xIEWybHhRhdT0JmTKR47SKd1ztrJCrbdtFCj0hPX8s/RWu0hPo4+5
	f6eFgkDOlFs2v+KEfF9KV6r14feKX6pbkVuwMFo8zvIzMcRqz9jkaX7tY9usbF/GSrSzVl
	By11gHplvcK/Rr1LUhpnQxdIXtBCwrw=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSr071g8zwXwL;
	Thu, 29 Oct 2026 10:30:08 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSr04TYHz171Yx;
	Thu, 29 Oct 2026 10:30:08 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id C5C2C5943;
	Thu, 29 Oct 2026 10:30:01 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:30:06 +0800
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
Subject: [RFC PATCH v3 06/17] sched/cache: Prioritize cache-preferred node selection over LLC selection
Date: Thu, 29 Oct 2026 10:20:24 +0800
Message-ID: <20261029022036.4002331-7-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Queue-Id: 332BF140008
X-Stat-Signature: 96pg1win9xqnomkroodm3qqettoppcog
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793241013-746724
X-HE-Meta: U2FsdGVkX1+hxhyqOCT3zbcnzQvtBb5K3d93Wv9dYARV04UVfrvO2U5I+/mmfEXgX8J1kFSI6g8n61d1YtWb9YOsueR02ttSzOvBDQRAPdS6HZ33Q1ghAmJK6OywyLPshcKALlRA7IfHDnydpGiiynyKw/dU1j3hOFQVaokBW4Vh2Ts8MAYg6gR6oAbBA+xwBiNiz1R1W2woGfNhWM4p2P5ZI1L3NM97HifKBoX7kncFcTq4dSq73xqCTITZ6aqkX1HwHFCB8SKLSjbOZXDfQswC4YTwFbeUYgIdtPUzY5fy0BT8vvFFCUFPdE1JhzHbdZfe4h87EPjSVJWGUZj1gSn9A2dEQAyyhzTvS/Cf0F2+k+U64zXsvsbuD07I8sdL6rKrg0e0uyes+CzDZzU94qWEL+ugjf8IRHvmleDTnP+M4UBKTVKEsS74AN+EGjXdYTk8PWVSu1NWo03ZCiBwznG3SwoQZ4GrRVc0Cb4rykPbct1KyylJJb2lauNfVeX4HMDQ1IQwu5uGoDUI38p8vORnVSW6laE/mpzQzGWpj9YAVtRLgHprhQjyhdtW9G2WZ1YI2lrmtcNjU/eTYrkGI2qVzuDGEGD6En7v7fp4tXAWPtbxEXSXvan+yuhe2yBhjvsAbAoiypOxBuaxwPAvN7CmMCO/sgZqcwMJSxAQlBIJSodzfF4JehOII/s+gW62LEgEojQ+I1dqNzd6BKm/qkkNXnAl7YuljxE7O5S/4c0RTfZFpfMdNPrwyVG0/SYovPYtk4JiN4aYIczsuIWkjSue8QAWpBBNFLAiLfQxD/dkfmOWE25G+4unLsBd/+V6089uK9rTZnxsJuM4sOv2KBVxKtdYQ6TA8zBkhAAaavoT89CU2lUFVNwTaX5SxLCx8jlVhcaRJV3zGlgKzspkHNb3iXjmGrrW3fUD+oz8uGzkDVJZau8Oiunad2zRtkW9WF04k6DoyPAMBukfFLH
 iOCx0rSA
 Ofevyzpr8QUMOimwY6W3nef8jqsoKdQFC1E+pphTOyKWdqM1tU7qcWb9EDuQ4s3aEB3xAMderLozo5jRUo+vnNyoUy46Yxp/617ddL5h30xk3xit/RqLjKmuV86B4wxAEaYdBGhL7gL66kbE+XTFwX4DHKnyf/SFv7GPH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The LLC affinity sequence is rooted at the preferred LLC, and its node
order is rooted at the node containing that LLC. task_cache_work()
currently selects the preferred LLC by per-LLC occupancy alone. For a
workload spanning multiple nodes, small occupancy shifts between LLCs
can move the preferred LLC to another node and reorder the entire
sequence.

Occupancy aggregated over a larger set of CPUs is more stable: shifts
between LLCs of the same node cancel out in the node's sum. Make the
node-level decision on this sum first, then choose the LLC within the
selected node:

  1. Sum the thread group's occupancy over the LLCs of each node. If
     the busiest node exceeds twice the current cache-preferred node,
     switch to it and select its busiest LLC.
  2. Otherwise, stay on the current cache-preferred node and switch to
     its busiest LLC only if that exceeds twice the current preferred
     LLC.

This keeps the LLC affinity sequence stable. The node order changes
only when the workload's occupancy really moves to another node, and
switching LLCs within a node changes only the intra-node LLC order.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 162 +++++++++++++++++++++++++++++---------------
 1 file changed, 109 insertions(+), 53 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f15f5764818e..fe357d79b6e0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1824,14 +1824,47 @@ static inline void update_avg_scale(u64 *avg, u64 sample)
 	*avg += div64_s64(diff, divisor);
 }
 
+/*
+ * Accumulate the mm's occupancy over one LLC. Returns the sum over @span,
+ * stores the busiest CPU in @max_cpu and adds the CPUs running a thread of
+ * @mm to @nr_running.
+ */
+static unsigned long scan_llc_occ(struct mm_struct *mm, const struct cpumask *span,
+				  int *max_cpu, int *nr_running)
+{
+	unsigned long occ, m_occ = 0, a_occ = 0;
+	struct task_struct *cur;
+	int i, m_cpu = -1;
+
+	for_each_cpu(i, span) {
+		occ = fraction_mm_sched(cpu_rq(i),
+				per_cpu_ptr(mm->sc_stat.pcpu_sched, i));
+		a_occ += occ;
+		if (occ > m_occ) {
+			m_occ = occ;
+			m_cpu = i;
+		}
+
+		cur = rcu_dereference_all(cpu_rq(i)->curr);
+		if (cur && !(cur->flags & (PF_EXITING | PF_KTHREAD)) &&
+		    cur->mm == mm)
+			(*nr_running)++;
+	}
+
+	*max_cpu = m_cpu;
+
+	return a_occ;
+}
+
 static void task_cache_work(struct callback_head *work)
 {
-	int cpu, m_a_cpu = -1, nr_running = 0, curr_cpu;
 	unsigned long next_scan, now = jiffies;
-	struct task_struct *p = current, *cur;
-	unsigned long curr_m_a_occ = 0;
+	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
-	unsigned long m_a_occ = 0;
+	unsigned long m_a_n_occ = 0, curr_m_a_n_occ = 0, curr_m_a_occ = 0;
+	unsigned long pref_node_llc_occ = 0;
+	int cpu, m_a_n_cpu = -1, nr_running = 0, curr_cpu;
+	int pref_cpu, pref_node_llc_cpu = -1, new_cpu = -1;
 	cpumask_var_t cpus;
 
 	WARN_ON_ONCE(work != &p->cache_work);
@@ -1863,75 +1896,98 @@ static void task_cache_work(struct callback_head *work)
 	if (!zalloc_cpumask_var(&cpus, GFP_KERNEL))
 		return;
 
+	pref_cpu = READ_ONCE(mm->sc_stat.cpu);
+
 	scoped_guard (cpus_read_lock) {
 		guard(rcu)();
 
 		get_scan_cpumasks(cpus, p);
 
 		for_each_cpu(cpu, cpus) {
-			/* XXX sched_cluster_active */
-			struct sched_domain *sd = rcu_dereference_all(per_cpu(sd_llc, cpu));
-			unsigned long occ, m_occ = 0, a_occ = 0;
-			int m_cpu = -1, i;
+			const struct cpumask *node_span =
+				cpumask_of_node(cpu_to_node(cpu));
+			unsigned long a_occ, a_n_occ = 0, m_llc_occ = 0;
+			int m_llc_cpu = -1, m_cpu, k, nr_llc = 0;
 
-			if (!sd)
-				continue;
+			for_each_cpu_and(k, node_span, cpus) {
+				/* XXX sched_cluster_active */
+				struct sched_domain *sd =
+					rcu_dereference_all(per_cpu(sd_llc, k));
 
-			for_each_cpu(i, sched_domain_span(sd)) {
-				occ = fraction_mm_sched(cpu_rq(i),
-							per_cpu_ptr(mm->sc_stat.pcpu_sched, i));
-				a_occ += occ;
-				if (occ > m_occ) {
-					m_occ = occ;
-					m_cpu = i;
+				/*
+				 * No sched domain, e.g. an isolated CPU: retire
+				 * the bit so the node is not walked again for it.
+				 */
+				if (!sd) {
+					__cpumask_clear_cpu(k, cpus);
+					continue;
 				}
 
-				cur = rcu_dereference_all(cpu_rq(i)->curr);
-				if (cur && !(cur->flags & (PF_EXITING | PF_KTHREAD)) &&
-				    cur->mm == mm)
-					nr_running++;
+				a_occ = scan_llc_occ(mm, sched_domain_span(sd),
+						     &m_cpu, &nr_running);
+
+				cpumask_andnot(cpus, cpus, sched_domain_span(sd));
+				nr_llc++;
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
+			 * Nothing scanned for this node, none of its CPUs in the
+			 * mask is attached to a sched domain.
+			 */
+			if (!nr_llc)
+				continue;
+
+			/*
+			 * Remember the busiest LLC of the node the preference
+			 * currently points at, as opposed to the LLC the
+			 * preference itself points at, so that the LLC level
+			 * decision can be taken once, after the whole scan.
 			 */
-			if (a_occ > m_a_occ) {
-				m_a_occ = a_occ;
-				m_a_cpu = m_cpu;
+			if (pref_cpu >= 0 && m_llc_cpu >= 0 &&
+			    cpu_to_node(pref_cpu) == cpu_to_node(m_llc_cpu)) {
+				pref_node_llc_occ = m_llc_occ;
+				pref_node_llc_cpu = m_llc_cpu;
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
+	 * Moving the preference to another node takes precedence over moving
+	 * it to another LLC of the node it already points at.
+	 */
+	if (m_a_n_occ > 2 * curr_m_a_n_occ)
+		new_cpu = m_a_n_cpu;
+	else if (pref_node_llc_cpu >= 0 && pref_node_llc_occ > 2 * curr_m_a_occ)
+		new_cpu = pref_node_llc_cpu;
+
+	if (new_cpu >= 0)
+		WRITE_ONCE(mm->sc_stat.cpu, new_cpu);
 
 	update_avg_scale(&mm->sc_stat.nr_running_avg, nr_running);
 	free_cpumask_var(cpus);
-- 
2.34.1



