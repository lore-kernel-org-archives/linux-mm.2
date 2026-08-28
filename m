Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BC0C61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3CA6B0096; Thu, 27 Aug 2026 22:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3547F6B0099; Thu, 27 Aug 2026 22:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B086B009B; Thu, 27 Aug 2026 22:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0599C6B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:16:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FE7D14024E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:16:01 +0000 (UTC)
X-FDA: 85149062922.21.D2D7186
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf20.hostedemail.com (Postfix) with ESMTP id 26E291C0005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:15:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf20.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787883359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=if1uQ5BKxb2RD6AuQn4vqGfrRV2L+GkCVV+g78hJKBY=;
	b=uJQ7EsSdkl8ajmYWeSGU00kDKOeVwq6gAdLml1VnKjz3U2giDHY0ASr/N2G5dmTVXAOZne
	nO9s5C7dFsfHBYz64rfWooAC5CrL5p/2Cxw1SUOAKo5YEeeKWoqNs9pbqLVA0fD070EPmh
	oMJ6yOP3Xf65Wm3Pl0RU7zFJwWzKKcw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787883359;
	b=SbT+yv7DGA36bySv7y7k5zmCihIu1Y/1yvZVaNiLawgzqC6xeiTH3DNbyXGh9OK2b2LhAG
	tAAVYezlFTsE7bAk4ciFDLxBYM2/zkhbjWb2D5zmqT5ZAbPzU6TzG/skbziTEsdF0K0y7R
	rvrPHELwPw01GoSSxjdeMlOpDsf/bG0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf20.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMSD0kHrzTdtV;
	Fri, 28 Aug 2026 10:15:56 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hWMSB071vzTdtV;
	Fri, 28 Aug 2026 10:15:54 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id C07D578AD;
	Fri, 28 Aug 2026 10:15:45 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 28 Aug
 2026 10:15:52 +0800
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
Subject: [RFC PATCH v2 20/23] sched/cache: Estimate utilization of the whole thread group
Date: Fri, 28 Aug 2026 10:11:56 +0800
Message-ID: <20260828021156.785662-1-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 26E291C0005
X-Stat-Signature: 1p46tpw3u47uhxtshop3167ypkdc3b5n
X-HE-Tag: 1787883359-180958
X-HE-Meta: U2FsdGVkX18Q+CTx+whh6VEW1q51u7JJ1XIbAlvPuwZU/G97ODfzdWoHdICiZRHYEtt5XTaRcrnT0cOWVmJy+CmhO8aJrCR/Hakr6bYZzhQpoYZuJBMBznxaUbe6QNOAqTsYxBzMQNA/SW/WYmHxEzlLevPwPGuaHTO3A3m0mxVUP4BtzYkWi4mYKT6QUA5ifL961UPfD6B/kJWe9r2Xnhc6qGuarXp7Z5WSCuyXfju+I5zXbkLPn4gI6mm1VuFRJ6BzT9kKQvzUf//+5tG4LLnIm3pqSkJjnCCBI1Tjcqo1Bed1RDaqEMokx6HwJi1evQwCpgVNRYRE8tkr/44qRlrEC3nU08/1bSEaoKOTlEqp2VEtCNnt3r+Kfwl2hHMizu5O8bhxrhvFO7vjJfBvzNHoigyBB6PI6LZrGYZck+EgDVQOL0ukvE3I9PC6PDxowFwWjWUWqsHKjfsnIVQ733erOqD/0r1aCS3G5Prbowp3aXcoNn8uTZz8GpnNOaETNSfE11h6Yfp1ZnhJL1abPB6lSfQ9pcUCOJiEpd9q7PB4dayWPM2lCut0TEbJtpNFgMe1A0baiuoRkvjtekCLmCpFeFWecZVoeTr29R9167lbycuyu5XOTzMXk1yCKSLpDZwc/DussXX+3TbshCT0z2l9rZAeGwVYmVnIwi1zjerVMvfL6Fez0s/71PuM+JmlSkbyyYgoXdeSLv16nkm8xaMn/2oTjaabtiilJJL1q+9aTmNwiYWI6nqc5TYOrYvvWNV95KQDyYGGvk3u8skWYaA2iQRvfelZZTjjhYrlsqbAnUyyZROdKYRZaHMrtZpjFY4LMKZrcxzE/fTWacyg8mDqENNoziU2JevBeQw3MrRuo5iRWhWTcJ5xFopFD7XN0Jg6woxLnlrOg4/KbcDb/3YPi95FmxSxVFtt3gjCe7vvra2mvl/vXyUFEzE1KDS7rf/kHnwmYHpzON0C7wa
 vCTQC7Y9
 I1bwEkvBwqNjvYNFlKGxDFFBVwOqQ9LXV4QF36oQKCY6CZhUVGnpUHGqisO6YA+U6PRSpP5KZHvv5jspXrPcgW456ok8xzCxFG7VjntL/nV7Gz5bMNPHfihpN/0AW+KCCGlMWWHAL6BMDQW5/d/KhL7y4IMJqM5w698VSxTneV7tRLe/7nPbExXmzL0cqEJkwKJ5rvMC92V11eLIBiAZzgfUhF/76ocT0VbMfestGYdE6gwAXm14pvEN7pYi9YmLHeNgTqYINv5qQ/Ug+YGXPJPjsIi1DivLpl+Hl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we want to spread threads across multiple LLCs, it is helpful
to know the overall utilization of the thread-group when deciding
whether a task may be migrated to a destination LLC.

We track this estimate using an asymmetric EWMA: rising load is
weighted by 1/2, while falling load uses a weight of 1/8.
This allows fast expansion of placement, while preventing premature
range contraction caused by short-term idle periods.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 include/linux/sched.h |  1 +
 kernel/sched/fair.c   | 44 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7fd4ea8c9037..96263bcb9e84 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2397,6 +2397,7 @@ struct sched_cache_stat {
 	raw_spinlock_t lock;
 	unsigned long epoch;
 	u64 nr_running_avg;
+	u64 util_avg;
 	unsigned long next_scan;
 	unsigned long footprint;
 	int cpu;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 45dd3e5e0a86..848abcf93c47 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1604,6 +1604,7 @@ void mm_init_sched(struct mm_struct *mm,
 	mm->sc_stat.cpu = -1;
 	mm->sc_stat.next_scan = jiffies;
 	mm->sc_stat.nr_running_avg = 0;
+	mm->sc_stat.util_avg = 0;
 	mm->sc_stat.footprint = 0;
 	mm->sc_stat.node_epoch = kcalloc(num_possible_nodes(),
 					 sizeof(*mm->sc_stat.node_epoch),
@@ -1860,11 +1861,35 @@ static inline void update_avg_scale(u64 *avg, u64 sample)
 	*avg += div64_s64(diff, divisor);
 }
 
+/*
+ * Keep a conservative estimate of the total CFS utilization generated by an
+ * mm.  Rise quickly so that spreading is not delayed when demand grows, but
+ * decay slowly so that a short idle interval does not immediately pull the
+ * workload back into fewer LLCs.
+ *
+ * The value is expressed in scheduler capacity units: SCHED_CAPACITY_SCALE is
+ * one fully utilized CPU.
+ */
+static inline void update_mm_util_avg(u64 *avg, u64 sample)
+{
+	s64 diff;
+	u32 divisor;
+
+	if (sample >= *avg)
+		diff = sample - *avg;
+	else
+		diff = -(*avg - sample);
+
+	divisor = diff > 0 ? 2 : 8;
+	*avg += div64_s64(diff, divisor);
+}
+
 static void task_cache_work(struct callback_head *work)
 {
 	unsigned long next_scan, now = jiffies;
 	struct task_struct *p = current, *cur;
 	struct mm_struct *mm = p->mm;
+	u64 group_util = 0;
 	unsigned long m_a_n_occ = 0, curr_m_a_n_occ = 0, curr_m_a_occ = 0;
 	unsigned long pref_llc_occ = 0;
 	int cpu, m_a_n_cpu = -1, nr_running = 0, curr_cpu;
@@ -1933,9 +1958,23 @@ static void task_cache_work(struct callback_head *work)
 					continue;
 
 				for_each_cpu(i, sched_domain_span(sd)) {
+					unsigned long cpu_util, mm_util;
+
 					occ = fraction_mm_sched(cpu_rq(i),
 							per_cpu_ptr(mm->sc_stat.pcpu_sched, i));
 					a_occ += occ;
+
+					/*
+					 * fraction_mm_sched() is a share of executed CFS
+					 * time, not an absolute utilization.  Scale the
+					 * CPU's PELT utilization by that share to estimate
+					 * this mm's utilization on the CPU.
+					 */
+					cpu_util = cpu_util_cfs(i);
+					mm_util = mul_u64_u32_div(cpu_util,
+							min_t(unsigned long, occ, NICE_0_LOAD),
+							NICE_0_LOAD);
+					group_util += mm_util;
 					if (occ > m_occ) {
 						m_occ = occ;
 						m_cpu = i;
@@ -2003,6 +2042,7 @@ static void task_cache_work(struct callback_head *work)
 		WRITE_ONCE(mm->sc_stat.cpu, new_cpu);
 
 	update_avg_scale(&mm->sc_stat.nr_running_avg, nr_running);
+	update_mm_util_avg(&mm->sc_stat.util_avg, group_util);
 	free_cpumask_var(cpus);
 }
 
@@ -10639,7 +10679,7 @@ static enum llc_mig can_migrate_node(int src_cpu, int dst_cpu,
 	struct mm_struct *mm;
 	unsigned long dst_util, dst_cap, tsk_util = 0;
 	unsigned long src_util = 0, src_cap = 0;
-	unsigned long acc_util = 0, acc_cap = 0;
+	unsigned long acc_util = 0, acc_cap = 0, dst_pre;
 	int node, target_cpu = src_cpu;
 	int get_src = 0;
 
@@ -10659,9 +10699,9 @@ static enum llc_mig can_migrate_node(int src_cpu, int dst_cpu,
 	}
 
 	dst_util = dst_util + tsk_util;
+	dst_pre = dst_util - tsk_util;
 
 	if (to_pref) {
-		unsigned long dst_pre = dst_util - tsk_util;
 
 		if (fits_llc_capacity(dst_util, dst_cap))
 			return mig_llc;
-- 
2.34.1



