Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95FEF606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA186B05C1; Wed, 28 Oct 2026 22:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779BF6B05C2; Wed, 28 Oct 2026 22:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667F46B05C3; Wed, 28 Oct 2026 22:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3006B05C1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:34:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E5D8120200
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:34:20 +0000 (UTC)
X-FDA: 85374094680.27.DE6022B
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf24.hostedemail.com (Postfix) with ESMTP id 40509180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:34:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793241258;
	b=c1WWm/19OtztnwT2/CkUNLwMDU9mGBjUHMCLP4IEfgeqCAtfTmfVVi+6drtKTAKDRu09ev
	1mXBwQpaemLsclS1BUoZqNexQFya1toDQ61/eBigMHCTrtiZ3AEdgY1oAZMzBGxeXAICPf
	5bQ4UxHD+J3ev7IBbPdmb8VqsVIVbG8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793241258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o5RHaA6P4mHnMaWoy4pvjSkU8wKQhDbvT54INjVW8fM=;
	b=k4tdKhbWfVYTGysKFjCiR67fXlRBc9fWNLDMup7K8Q7asdbdZKmx39yPFPReM03Mm1Fh02
	bng9ANUL+HUdqG5lg+uPRCS2IqgeTLUJO2arKm+VWIcraGkB/eo161wKVOullS21l9eTCH
	zveUxHCdmGD3OvbCRpHJW21vZ2O5bYw=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSwm0B81z1G81W;
	Thu, 29 Oct 2026 10:34:16 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSwj1TH0z171YV;
	Thu, 29 Oct 2026 10:34:13 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 5A93416DE;
	Thu, 29 Oct 2026 10:34:05 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:34:10 +0800
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
Subject: [RFC PATCH v3 12/17] sched/cache: Apply multi-LLC aggregation policy to task migration
Date: Thu, 29 Oct 2026 10:20:30 +0800
Message-ID: <20261029022036.4002331-13-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Stat-Signature: j4crenimjn4gx3uxnhbwa34q9ndi6z67
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40509180003
X-Rspam-User: 
X-HE-Tag: 1793241258-223701
X-HE-Meta: U2FsdGVkX1/HXchXTQ8ZI0y+/IXEEE9nyPL6cEqdgpOfdF/cb5z4LFNHNnSjQxAvvdHMpeQ1PjxDC0e60xiaR5uno7ifKU83ycA1U76GJOoWHXutM8FFtbDkm1GPc846uegZLABC3LmtIAr0So8zqmmC+Uven3tx4KNyvYP3EtGM29iRdfaIujnu9033THVnzNa0mF5IwarP5lKlu9ccpp/db3M34Fo4Rmdb40CmDCd2+lvJpf3uHANkaTD0Nz9y+KMNXc5LyyhPLmPfsn1pXfdBHzqmtrUD1TL3NTTxmlBB4pAbz2gAvoYxedJYPrxNzI+8psa0OJ2K3pJcENH/S5HOMfzoLfVDdgo8A+2DF/jlHby1NmNa++gpw47rTxca1zW8SMDuf6RrM24l35uVRjz5Rv+2w5hzl7dZlRpJaHiRrf+TcevflWtCb16blGx6zdk5WACWnjDFg0EONeLqcKirfHTcdXW2AWJfH+ngwPoSC3ddSdzwt/zMG/feNYKVmoEwt1dcDHFwqLcWSJrjuBjHcaqZtTYXCHh9cVH8QJm3r0DrwJ5YIwiDT+btgpUCp2nVG1KF77hni7YBJXNDNOB5mKP/HITvAyC/1Lg9AX5hf+zW/dLdEtwQln27fscdkjBOoNATpmTgDOYRGJ3EFUk0hD63NaYZG18/9GJ5rt4irZxiBhBlNdHMCszb53CB1t906oXEMF00RYOTxodq9vqqtLoj62GTPJ98Y7Ycdcmr8LCTkDo5ImZbkmDKmOtzEkGX0HvpGzdrCoG3yclMIRyjXHCFxPUdCfvWncsNuWmfLv7hpXTUdC41g/KMrQKcRwssENCE/QeSR00Q98SsruzORkAV7fivvJexaNP02D0GnbUoSnPhwNu2dSG0f6/xj0Vpe58+T4elpMhwKnmfzg3Q/xwftcwzjKE4nSxbKLk82CGEdfAhnLQFSwgAfUQUlrONGt+WM073yb4akB/
 fhJoXX7z
 xSUC+LT6a9GwtLa1Ikrngb2ETqtCP7UzjbEP0lknZh9XIumlPB5xiYg69FtPW0olo0hjsvciKJv73P/agbeJou6qs1S/IsTEE1J1lR68RfWdS3tVATRfkmKFX1KODleu+N53fxG54xXhv0EFzQXn9OnbxRMeAFLfnILOv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The existing task migration checks only apply the cache-aware policy
when either endpoint is the task's preferred LLC. Moves between other
LLCs are left unrestricted by that policy.

Apply the multi-LLC aggregation policy to these moves as well:
if_to_prefer() decides whether the move raises the task's affinity,
and can_migrate_llcs() decides whether to block it, based on that
direction and the load of the LLCs involved. Remove the obsolete
can_migrate_llc() helper.

Active balance has the same limitation. alb_break_llc() assumes
aggregation into a single LLC: only a task on its preferred LLC counts
as aggregated, so it restricts active balance only when every runnable
task on the source runqueue is on its preferred LLC. Once aggregation
spans multiple LLCs, a task outside its preferred LLC may still be
within the aggregation range, and pulling it to an LLC later in the
affinity sequence lowers its affinity.

When the source runqueue has exactly one task, check that task with
if_to_prefer() and can_migrate_llcs() wherever its preferred LLC is.
With more than one task, the task to be moved is not known here, so
leave the decision to can_migrate_task(). Move its active-balance fast
path after the cache-aware check so that active balance cannot bypass
a cache-aware veto when NUMA locality is neutral.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 111 +++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 79 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 03bb5c85a8b7..c3f9ef8798d6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10580,54 +10580,6 @@ enum llc_mig {
 	mig_unrestricted	/* G: Don't restrict generic load balance migration */
 };
 
-/*
- * Check if task can be moved from the source LLC to the
- * destination LLC without breaking cache aware preferrence.
- * src_cpu and dst_cpu are arbitrary CPUs within the source
- * and destination LLCs, respectively.
- */
-static enum llc_mig can_migrate_llc(int src_cpu, int dst_cpu,
-				    unsigned long tsk_util,
-				    bool to_pref)
-{
-	unsigned long src_util, dst_util, src_cap, dst_cap;
-
-	if (!get_llc_stats(src_cpu, &src_util, &src_cap) ||
-	    !get_llc_stats(dst_cpu, &dst_util, &dst_cap))
-		return mig_unrestricted;
-
-	src_util = src_util < tsk_util ? 0 : src_util - tsk_util;
-	dst_util = dst_util + tsk_util;
-
-	if (!fits_llc_capacity(dst_util, dst_cap, false) &&
-	    !fits_llc_capacity(src_util, src_cap, false))
-		return mig_unrestricted;
-
-	if (to_pref) {
-		/*
-		 * Don't migrate if we will get preferred LLC too
-		 * heavily loaded and if the dest is much busier
-		 * than the src, in which case migration will
-		 * increase the imbalance too much.
-		 */
-		if (!fits_llc_capacity(dst_util, dst_cap, false) &&
-		    util_greater(dst_util, src_util))
-			return mig_forbid;
-	} else {
-		/*
-		 * Don't migrate if we will leave preferred LLC
-		 * too idle, or if this migration leads to the
-		 * non-preferred LLC falls within sysctl_aggr_imb percent
-		 * of preferred LLC, leading to migration again
-		 * back to preferred LLC.
-		 */
-		if (fits_llc_capacity(src_util, src_cap, false) ||
-		    !util_greater(src_util, dst_util))
-			return mig_forbid;
-	}
-	return mig_llc;
-}
-
 /* Accumulate a NUMA node's utilization and capacity at LLC granularity. */
 static bool get_node_stats(int node, unsigned long *util_out,
 			   unsigned long *cap_out, int *nr_llcs)
@@ -10768,7 +10720,7 @@ static enum llc_mig can_migrate_llcs(int src_cpu, int dst_cpu,
 }
 
 /* Decide whether the destination precedes the source in the affinity order. */
-static bool __maybe_unused if_to_prefer(int src_cpu, int dst_cpu, int pref_llc)
+static bool if_to_prefer(int src_cpu, int dst_cpu, int pref_llc)
 {
 	int src_rank, dst_rank, src_node, dst_node, pref_node;
 
@@ -10827,55 +10779,52 @@ static enum llc_mig can_migrate_llc_task(int src_cpu, int dst_cpu,
 		return mig_unrestricted;
 	}
 
-	if (cpus_share_cache(dst_cpu, cpu))
-		to_pref = true;
-	else if (cpus_share_cache(src_cpu, cpu))
-		to_pref = false;
-	else
-		return mig_unrestricted;
+	to_pref = if_to_prefer(src_cpu, dst_cpu, llc_id(cpu));
 
-	return can_migrate_llc(src_cpu, dst_cpu,
-			       task_util(p), to_pref);
+	return can_migrate_llcs(src_cpu, dst_cpu,
+			       p, to_pref);
 }
 
 /*
  * Check if active load balance breaks LLC locality in
  * terms of cache aware load balance. The load level and
  * imbalance do not warrant breaking LLC preference per
- * the can_migrate_llc() policy. Here, the benefit of
+ * the can_migrate_llcs() policy. Here, the benefit of
  * LLC locality outweighs the power efficiency gained from
  * migrating the only runnable task away.
  */
 static inline bool
 alb_break_llc(struct lb_env *env)
 {
+	int pref_llc = -1;
+	bool to_pref = false;
+
 	if (!sched_cache_enabled())
 		return false;
 
 	if (cpus_share_cache(env->src_cpu, env->dst_cpu))
 		return false;
 	/*
-	 * All tasks prefer to stay on their current CPU.
-	 * Do not pull a task from its preferred CPU if:
-	 * 1. It is the only task running and does not exceed
-	 *    imbalance allowance; OR
-	 * 2. Migrating it away from its preferred LLC would violate
-	 *    the cache-aware scheduling policy.
+	 * We need the preferred LLC to decide whether we can perform migration.
+	 * Therefore, we need to obtain task_struct, which is only meaningful
+	 * in the case that only one task on the rq.
+	 * For cases with more than one task on the rq, we need to check
+	 * this in can_migrate_task().
 	 */
-	if (env->src_rq->nr_pref_llc_running &&
-	    env->src_rq->nr_pref_llc_running == env->src_rq->cfs.h_nr_runnable) {
-		unsigned long util = 0;
+	if (env->src_rq->nr_running == 1) {
 		struct task_struct *cur;
 
-		if (env->src_rq->nr_running <= 1)
-			return true;
-
 		cur = rcu_dereference_all(env->src_rq->curr);
-		if (cur && cur->sched_class == &fair_sched_class)
-			util = task_util(cur);
+		if (!cur || !cur->mm)
+			return false;
+
+		if (cur->sched_class == &fair_sched_class)
+			pref_llc = llc_id(cur->mm->sc_stat.cpu);
 
-		if (can_migrate_llc(env->src_cpu, env->dst_cpu,
-				    util, false) == mig_forbid)
+		to_pref = if_to_prefer(env->src_cpu, env->dst_cpu, pref_llc);
+
+		if (can_migrate_llcs(env->src_cpu, env->dst_cpu,
+				    cur, to_pref) == mig_forbid)
 			return true;
 	}
 
@@ -11027,14 +10976,11 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 
 	/*
 	 * Aggressive migration if:
-	 * 1) active balance
-	 * 2) destination numa is preferred
+	 * 1) destination numa is preferred
+	 * 2) active balance
 	 * 3) task is cache cold, or
 	 * 4) too many balance attempts have failed.
 	 */
-	if (env->flags & LBF_ACTIVE_LB)
-		return 1;
-
 	degrades = migrate_degrades_locality(p, env);
 	if (!degrades) {
 		/*
@@ -11060,6 +11006,13 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		hot = degrades > 0;
 	}
 
+	/*
+	 * Keep this after the cache-aware check so active balance respects its
+	 * migration veto when NUMA locality is neutral.
+	 */
+	if (env->flags & LBF_ACTIVE_LB)
+		return 1;
+
 	if (!hot || env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 		if (hot)
 			p->sched_task_hot = 1;
-- 
2.34.1



