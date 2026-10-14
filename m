Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7CABCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29CE6B00D2; Wed, 14 Oct 2026 05:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDA786B00D4; Wed, 14 Oct 2026 05:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E186D6B00D5; Wed, 14 Oct 2026 05:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6E386B00D2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:47:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A266140452
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:47:14 +0000 (UTC)
X-FDA: 85320753588.08.B0C625B
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6141B80005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:47:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UNWzPU7G;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791971232;
	b=p7/OLt0omZ/8Zi73XLinV6VmJwJcdjJFVPn0xYhitoXu9eqfModoEIVPORsaE9QVUNUvKU
	0Z+CTyQOtjLbfQ5P6QT1jC44flRIks5XM7wGNiKlxx29zrOdS4udsDvHETZOhyR/r1HhqD
	fDxB/xvnWoxHJVjItPTLtQthrC3YTl8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UNWzPU7G;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791971232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvSSi/qfex9riZEpa78JUEMn8C07c1f5TdCJDgGPBWk=;
	b=u6+OYcODyL6Vj7wkOjRBlyw0B1Kqn6nWYnF00WLqKpCcAqsPryahMDYLuBhvqRHo7goR41
	cF5MVdacH465LY3QDpCVuSU5VN7EkHJ13/3JHZ8XJSPwXmuNH2HdMarLWb6IN6tjxH3wa+
	q2cENqkx7XhhG6hqSCRbTLg2WlU+xME=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791971227; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=WvSSi/qfex9riZEpa78JUEMn8C07c1f5TdCJDgGPBWk=;
 b=UNWzPU7G/WKZtu+E2SlLjQSyjdH2ozBiMRrQCqdQqq5uL1k0IAqbf/KeqKt8zVXJcxSJQo
 zrJUKakCB1m4nYJM9XRplGQTbkVW/1I6uGihVaxjpdYxmsee2npPP6+63lie70RzZyArXm
 uffBP67OCtRFibDRnc+We89rPxhlooK2tkuZWVOSHDFybamQBqL3rVwMJFsYnmqss/nSNI
 f71ZrO9ONsgcj8ur58DpsJozBPqLznHK9aIcpuAOjqt7vTYtUAI9/w3eaV8jr6OszJjWP9
 B6b45DhBabq0hc2bhkMa6pKo/reYOT7Dnp4x2TAVjVRJ8zUCKviIM0L0rOV0zQ==
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Date: Wed, 14 Oct 2026 17:43:47 +0800
Mime-Version: 1.0
In-Reply-To: <20261014094347.99157-1-lizhe.67@bytedance.com>
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH 6/6] sched/numa: ignore preferred nodes without normal balancing
X-Lms-Return-Path: <lba+26acf4f99+4829ef+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <mgorman@suse.de>, 
	<riel@redhat.com>, <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>
Message-Id: <20261014094347.99157-7-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6141B80005
X-Rspam-User: 
X-Stat-Signature: s3yocuhxd677k9amajhyz3hky7pj4tbi
X-HE-Tag: 1791971232-728758
X-HE-Meta: U2FsdGVkX1/701ZTvEx4ERQaYmtHeTHzExuCZU2bE3pEP1g+ZHP3qlGsjeaeGNehI6maQLnS/ejLbPn/V2BIhL6apgl7z+vkb8kn/3od1/QM3CEFgYCP6Qm8oYmAKiXxlOo01wCW0iN9CGqa1JQs5TZ2vmHefz/bSRapOIBzbSB99kScy1TSNYtyNhWPMqdWDP9qGHLc00oZ7GsJL99SbeEvSDRhT1zyoXX3sXp6K1zB0YKMdJP0KUk9sihqfk8M7BLZrKxCTZPV6002+kW++ZpRs3oDxxC28OlUQQ8Qb0PNGa/pVYYEiSxfaFB4hnbqvPDNrGMSbEaevd3+g2h0YfKS93GHLapbOS2GGXYedsXN9Sfs14OqGpRSY9bOq6Nyfo4CGJuhd0WF0Dv5nYq8X2i5mFViAmUpFNes/CQ04/SYkXaoRS4k1ZdSJE5TC5AmBgVuTUDaHthL2OlD6bYu87rr+ULxFLKS/pphSSRC8XTwbEtHIFMj+dLYhYSHCn2B0KmXh4SOhyVGy+7/27uCrBURc9brQQ0kbHdoL32Z44ajloPLcLwlMdtSxvYflZMFZ9v73VFR/onNDFvP2v2yZo+0bnMx1f1ybqh0aVUTyFw9rOMNCXgJpmcNf7JcAjk/taHs92EvR32n3H2Dm08gsPp+noNVXemtz4LWkIysWCR3hpxTKJ/7LLdFyiL/B9MKtJwiXbNTZLVSJ3+cbYrvkeoW6ayFrQoIYKvOxqNkcvkpagxv1Ll4wPmN4IBWSa1ZLY7vG1G+28lxmdzQNPBVdGCATBm+Y9SEuzkaGcprSmoFJJ0ax51J8MdzbE4OQp3H3pIN4Bs178xnG+b5rjZMXBmN5UEF/zzEvoi0L4G0R0Z9hposZv6jMH7S/mA1UUwizPaZQe4bQuizLphEvn6/7siCmnAextLFn04E6GwKAS7IsXlZw/baGmeTGhI2C4Z77x9UpDKYLZxWmOiiVLL
 Pl73QH/h
 ufZYomWt8g17Nl2dZOwQt+mzssXBY5PDWtXte2JBByM8QvSkXPgksZlPmLLsg5R+rH4+7Z1O34ec/IhuWDt1mm3hWSAyuUrOEhe9NAxn5Y5se0nF2VpM6jwTYpsPdNfxvlf1pcjdXMAkIAC9jdiBBiaR8hEwZsoFbK1osp9FT0UK1DqnrehKl3hXPw0Vrj84zqdRW6Xlm3zCdfjPoxIWTjpPmt2ysaJDTswdP33kZ8DUQqVJ2Qn2UwJ/usyVo5gdnc2A5ssMV6mU07Bi4dzB7SOPXEcayemBbtT8zx8OhfJwY5Z3Gtyg+eKbYckkP3b9NqHb0M1/G7oRssi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_preferred_nid is normal AutoNUMA task-placement state.
Memory-tiering-only mode uses NUMA hint faults to drive page promotion,
not CPU placement.

Even after tiering-only faults stop updating normal placement statistics,
a task can still have a preferred NUMA node from earlier normal balancing
or from previously polluted state. Several scheduler paths consume that
stale state when the NUMA balancing static key is enabled, including
explicit NUMA task migration, sched-cache preferred LLC and scan CPU mask
selection, load-balance locality checks, fbq classification, and wakeup
group selection.

Add a small helper for normal NUMA placement being enabled and use it to
ignore numa_preferred_nid when NUMA_BALANCING_NORMAL is disabled. Keep
the preferred-node migration retry timestamp update before the normal-mode
check so accepted non-normal sysctl states do not leave stale retry state
behind.

Keep the rq nr_numa_running and nr_preferred_running accounting unchanged
so runtime mode changes do not make enqueue/dequeue accounting asymmetric;
the load balancer simply stops consuming those counters while normal
balancing is off.

This does not clear numa_preferred_nid and does not change memory-tiering
promotion decisions.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 kernel/sched/fair.c | 55 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ec08406d1364..11b54bb353ad 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1328,6 +1328,21 @@ static int select_idle_sibling(struct task_struct *p, int prev_cpu, int cpu);
 static unsigned long task_h_load(struct task_struct *p);
 static unsigned long capacity_of(int cpu);
 
+#ifdef CONFIG_NUMA_BALANCING
+static inline bool numa_balancing_normal_enabled(void)
+{
+	return sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL;
+}
+
+static inline int task_numa_preferred_nid(struct task_struct *p)
+{
+	if (!numa_balancing_normal_enabled())
+		return NUMA_NO_NODE;
+
+	return p->numa_preferred_nid;
+}
+#endif
+
 /* Give new sched_entity start runnable values to heavy its load in infant time */
 void init_entity_runnable_average(struct sched_entity *se)
 {
@@ -1890,10 +1905,12 @@ static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp)
 		 * than sched_setnuma() at least -- and thus the
 		 * conflict only exists for a short period of time.
 		 */
-		if (static_branch_likely(&sched_numa_balancing) &&
-		    p->numa_preferred_nid >= 0 &&
-		    cpu_to_node(mm_sched_cpu) != p->numa_preferred_nid)
-			mm_sched_llc = -1;
+		if (static_branch_likely(&sched_numa_balancing)) {
+			int pref_nid = task_numa_preferred_nid(p);
+
+			if (pref_nid >= 0 && cpu_to_node(mm_sched_cpu) != pref_nid)
+				mm_sched_llc = -1;
+		}
 #endif
 	}
 
@@ -2009,7 +2026,7 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p,
 	 * current running node to mitigate the bouncing risk.
 	 * TBD: numa_group should be considered during task aggregation.
 	 */
-	pref_nid = p->numa_preferred_nid;
+	pref_nid = task_numa_preferred_nid(p);
 	/* honor the task's preferred node */
 	if (pref_nid == NUMA_NO_NODE)
 		goto out;
@@ -3649,6 +3666,9 @@ static void numa_migrate_preferred(struct task_struct *p)
 	interval = min(interval, msecs_to_jiffies(p->numa_scan_period) / 16);
 	p->numa_migrate_retry = jiffies + interval;
 
+	if (!numa_balancing_normal_enabled())
+		return;
+
 	/* Success if task is already running on preferred CPU */
 	if (task_node(p) == p->numa_preferred_nid)
 		return;
@@ -10740,6 +10760,9 @@ static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	if (!static_branch_likely(&sched_numa_balancing))
 		return 0;
 
+	if (!numa_balancing_normal_enabled())
+		return 0;
+
 	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
 		return 0;
 
@@ -12533,6 +12556,9 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 #ifdef CONFIG_NUMA_BALANCING
 static inline enum fbq_type fbq_classify_group(struct sg_lb_stats *sgs)
 {
+	if (!numa_balancing_normal_enabled())
+		return all;
+
 	if (sgs->sum_h_nr_running > sgs->nr_numa_running)
 		return regular;
 	if (sgs->sum_h_nr_running > sgs->nr_preferred_running)
@@ -12542,6 +12568,9 @@ static inline enum fbq_type fbq_classify_group(struct sg_lb_stats *sgs)
 
 static inline enum fbq_type fbq_classify_rq(struct rq *rq)
 {
+	if (!numa_balancing_normal_enabled())
+		return regular;
+
 	if (rq->nr_running > rq->nr_numa_running)
 		return regular;
 	if (rq->nr_running > rq->nr_preferred_running)
@@ -12843,17 +12872,21 @@ sched_balance_find_dst_group(struct sched_domain *sd, struct task_struct *p, int
 		if (sd->flags & SD_NUMA) {
 			int imb_numa_nr = sd->imb_numa_nr;
 #ifdef CONFIG_NUMA_BALANCING
-			int idlest_cpu;
+			int pref_nid = task_numa_preferred_nid(p);
 			/*
 			 * If there is spare capacity at NUMA, try to select
 			 * the preferred node
 			 */
-			if (cpu_to_node(this_cpu) == p->numa_preferred_nid)
-				return NULL;
+			if (pref_nid != NUMA_NO_NODE) {
+				int idlest_cpu;
 
-			idlest_cpu = cpumask_first(sched_group_span(idlest));
-			if (cpu_to_node(idlest_cpu) == p->numa_preferred_nid)
-				return idlest;
+				if (cpu_to_node(this_cpu) == pref_nid)
+					return NULL;
+
+				idlest_cpu = cpumask_first(sched_group_span(idlest));
+				if (cpu_to_node(idlest_cpu) == pref_nid)
+					return idlest;
+			}
 #endif /* CONFIG_NUMA_BALANCING */
 			/*
 			 * Otherwise, keep the task close to the wakeup source
-- 
2.20.1

