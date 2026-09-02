Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC2DC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C61F6B0095; Tue,  1 Sep 2026 20:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3E36B0096; Tue,  1 Sep 2026 20:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88BB16B0098; Tue,  1 Sep 2026 20:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 611FB6B0095
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:04:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3BD2A443C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:04:04 +0000 (UTC)
X-FDA: 85166874408.01.FC9F8A3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BC33A0009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:04:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BWd8Eosu;
	spf=pass (imf25.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788307442;
	b=k0DqDgXlTWjlwmm8TW1Z/kSsg0mYd8n/W7PaKmxYbzJI1quh8DxTRyxkgzRUXgY41xiAvh
	3zW628zSX7NOF2CrKd5muLiQ1nkQ6r/B7im+DSwh88zSTXt2R5zrfPF0auHDkY59Xc170E
	LdNcvuBwxT3M+8iEhdGeVXFXu6IgVdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788307442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYDxHroGknJr1/jZwZGmfnWpU8A9SIlKLioOzD1gdE4=;
	b=Na0vjDDcSyFQuIfUU10s3aM0M9TNEIp/LotTw+dwlYF3vxD6rU1tRKbDQSqANWdhg/1MFh
	B/A3bUhnlIr71s+fxlwploWaNScjhCwNLiHyraI3YKww/RcT/3XBrkV9W6cR1S3Ec8JdwS
	gl6VrdioTRQx2XeuwfsFp6xcRSweWqA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BWd8Eosu;
	spf=pass (imf25.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788307442; x=1819843442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4HA4NOSLIzsRJHIxI6uRGIPpQMeaoKh+cm0awgGMBMQ=;
  b=BWd8EosuxRjjOe07cahsc2Ae/iBhFRCamV3EsPgH+xAvVe1/TF99sJK3
   eElpdmnrrqkwP0dAxsz8pewWOX6fA2G+FDuSN6qvx/4pqaFCz3Z8MRH5h
   YFD8uTSr3CgkvWC4BG7B8cveu9iJjj1duQALrtSyZjthly02MXXpKBS31
   0Rt1z7UoDY/7wuPJVcTPJPctMDpdOVuncPlPaijoij/3obkCCzlnPTt6+
   w5D3V6r19wyistjYnqUUmkOMPV7zIPro8wLkWocpDMoDwrDwxikR72nSP
   U4BPUvCfhXHFKf2Gg6PhN24IIfIYbay4bLbZPCrixfCfSDjz8ozW2ORgv
   Q==;
X-CSE-ConnectionGUID: e51tmfzQTkiQiF6ocrPJ6A==
X-CSE-MsgGUID: FkC2jVFeQ5ue5pTl8Yq+WQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="106272985"
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="106272985"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 17:03:57 -0700
X-CSE-ConnectionGUID: /z/QCYmlRButVJ3u2YlN8A==
X-CSE-MsgGUID: W5+9GGHUTz2HpPZKxYFwFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="265531792"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa010.fm.intel.com with ESMTP; 01 Sep 2026 17:03:42 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"chen . yu @ linux . dev" <chen.yu@linux.dev>
Subject: [PATCH 1/2] sched/cache: Decouple sched_cache_group from mm
Date: Tue,  1 Sep 2026 17:08:55 -0700
Message-Id: <f7b3f8577da365010479da95b07d7dce5365e7fa.1788305725.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1788305725.git.tim.c.chen@linux.intel.com>
References: <cover.1788305725.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4BC33A0009
X-Stat-Signature: 4d4znhetecnm8o4x47ec3y8ipdgk9azo
X-HE-Tag: 1788307442-937686
X-HE-Meta: U2FsdGVkX19nBfZOWQjD5rvxB9yrK397irGbTVw5Xo44E48tjbq8QSxVt1hqN4rA7L9RUC6Zoa0q830+OrT8kEL+0z3bR38JEWfVJyZA0O0yXT8RlothnrgHZFqYPkuf6y5elTRmgn4JIWsegmakPG7sDTLrM+jzGwIH8te7swmk8LCjUlE1eD6muR+3j08H+IEA/wZVRIaqja/FqGZp1ebJnCvQxbKRHgp026neiHym7lJEPZxJZggpwZ4XTH5WtlUmOUC3FQpVlte5VLUf9JhIP5S/MKMrYUVe7Ldi0MxdI85vX5XyQLrtsAG/AxPIrAYtls5+xX8fo2YxEQTxqlKKRE4vrxgaXtcxr6vRJdJp2T0Onpl0bsMfTea+BcwyJPCFZRFW4nDUCH6GonQZ6tpN6+jSIdkkzCuJjUDpVurPaxndGnLGJa9Yy0MfhSOnM2RvPhxfUCGDHwd3ng3L/rGasPWQvZdAS/QB0czaSDNTKQ1PaJL4M8uelsmJrQbCUUMNg8Is/daJnenlMwWw4UbuHdY0qzkcKqMuAlCnpas1SN4kaNKps0BeVYcrN9+AuCedezxrQ4TAWaf22UowBvv12Jffe6fCUh+U4HGRTrKRjwFnLsSjVzNOqoqq4xwahYUFRg1rY93oNh4CTfrgEL0XeSFFwXcLSLDt1awiJ3pwzLy43irfaeOCnon5AsR2FjsTpIrrlmtWGuQ9jyen106rZ5r0QPvAvYc982/Xv73DtK/eURX9oCPa8O6vq2Ylq7w3YDxoFohye6hbYv/zbrfMvomgZmnH2nuld3DcvZ22KSe5YmprpNBgjaOlxTgEKuVMeBiS1SBs8/hLosbuvdL8IBzDDKAJXopd1BN3oZJ/tx12OKis/g1/b2mcQWCUfLaDRxkdV4fQFpoXYPmP3TleBvdVn0l2EZ7f+wes/a/4f/KSl9MEA1JVEtV5GpvQRZrSRRrHrcG3SmKpk8l
 bYnr8god
 bAdSX4ePeB1JC+YA6E7l7yD6X0AjYNlSiq8HJ0n5ZkQPqEb/yc5TUOHHoX2l0EfdJ0qMLyYIafvb3Oqm3xLMSxqP/y+vsVE2VG+ttBb6vwl7qg9F/UB8AF8rACOrxq62pQwvX0dKK21EFyvjMyU6WtxaZnDPyk4r1DsluxHB8q7L8nQrTF4sHObQihSpzy9NdhGmcGf9SfqwTtzPpOMwTxngvrDF2IOa43ewKtEBJg7IAiJ9fNKoAGR1LjRz540ZeT1Zc62G+J1Em/cTKOlfENte3KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently the sched cache grouping is by mm and the scheduling statistics
sched_cache_stat lives in the mm structure.  This ties the life cycle
of scheduling stats with mm.

In account_mm_sched(), the scheduling stats are accessed by
task->mm->sc_stat.  However, a task may be switching mm on one CPU when
another CPU is running account_mm_sched(), and possibly accessing the
old mm that was freed.  This problem was found when running tests with
KASAN by Hyunwoo.  https://lore.kernel.org/lkml/apPb-Dr4nPYuHQOK@v4bel/

Instead of serializing the mm access by introducing extra acquisition of
rq lock in the mm free path, extract sched_cache_stat from mm_struct,
rename it as sched_cache_group and manage its life cycle apart from
mm_struct with its own ref counting. Access sched_cache_group directly
from a task instead of having to go through a task's mm. This allows us
to later add a refcount on sched_cache_group when a task links to it,
preventing the use after free issue when accessing stale and released
old mm and its sched cache stat a task switches to a new mm while
account_mm_sched() is done elsewhere.

The other benefit of this restructure is in the future, the grouping of
tasks to a LLC would have the flexibility to be associated with cgroup,
cookie group, numa_group or others instead of just with a single mm
address space.

Rename sched_cache_stat to sched_cache_group and turn it into a refcounted
object allocated from mm_struct.  The mm_struct now holds a pointer
(sched_cache_grp) to this object instead of embedding it.

Introduce kernel/sched/cache_sched.c to host the cache aware scheduling
helpers and define sched_cache_group_put() there.

Meanwhile skip kthreads in account_mm_sched(), consistent with
task_tick_cache().

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Closes: https://lore.kernel.org/lkml/apPb-Dr4nPYuHQOK@v4bel/
Tested-by: Hyunwoo Kim <imv4bel@gmail.com>
Fixes: df0d98475954 ("sched/cache: Introduce infrastructure for cache-aware load balancing")
Co-developed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/mm_types.h     |  15 ++---
 include/linux/sched.h        |   8 ++-
 kernel/exit.c                |   6 +-
 kernel/sched/build_utility.c |   4 ++
 kernel/sched/cache_sched.c   |  20 ++++++
 kernel/sched/fair.c          | 118 ++++++++++++++++++++++-------------
 6 files changed, 113 insertions(+), 58 deletions(-)
 create mode 100644 kernel/sched/cache_sched.c

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6d815f6440c9..f3e5a2fadbe5 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1226,7 +1226,7 @@ struct mm_struct {
 		struct mm_mm_cid mm_cid;
 
 		/* sched_cache related statistics */
-		struct sched_cache_stat sc_stat;
+		struct sched_cache_group *sched_cache_grp;
 #ifdef CONFIG_MMU
 		atomic_long_t pgtables_bytes;	/* size of all page tables */
 #endif
@@ -1624,8 +1624,9 @@ static inline unsigned int mm_cid_size(void)
 #endif /* CONFIG_SCHED_MM_CID */
 
 #ifdef CONFIG_SCHED_CACHE
-void mm_init_sched(struct mm_struct *mm,
-		   struct sched_cache_time __percpu *pcpu_sched);
+int mm_init_sched(struct mm_struct *mm,
+		  struct sched_cache_time __percpu *pcpu_sched);
+void mm_destroy_sched(struct mm_struct *mm);
 
 static inline int mm_alloc_sched_noprof(struct mm_struct *mm)
 {
@@ -1635,17 +1636,11 @@ static inline int mm_alloc_sched_noprof(struct mm_struct *mm)
 	if (!pcpu_sched)
 		return -ENOMEM;
 
-	mm_init_sched(mm, pcpu_sched);
-	return 0;
+	return mm_init_sched(mm, pcpu_sched);
 }
 
 #define mm_alloc_sched(...)	alloc_hooks(mm_alloc_sched_noprof(__VA_ARGS__))
 
-static inline void mm_destroy_sched(struct mm_struct *mm)
-{
-	free_percpu(mm->sc_stat.pcpu_sched);
-	mm->sc_stat.pcpu_sched = NULL;
-}
 #else /* !CONFIG_SCHED_CACHE */
 
 static inline int mm_alloc_sched(struct mm_struct *mm) { return 0; }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8b3d47a325cc..1f254364f216 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2405,7 +2405,7 @@ struct sched_cache_time {
 	unsigned long epoch;
 };
 
-struct sched_cache_stat {
+struct sched_cache_group {
 	struct sched_cache_time __percpu *pcpu_sched;
 	raw_spinlock_t lock;
 	unsigned long epoch;
@@ -2413,11 +2413,15 @@ struct sched_cache_stat {
 	unsigned long next_scan;
 	unsigned long footprint;
 	int cpu;
+	refcount_t refcnt;
+	struct rcu_head rcu;
 } ____cacheline_aligned_in_smp;
 
+void sched_cache_group_put(struct sched_cache_group *grp);
+
 #else
 
-struct sched_cache_stat { };
+struct sched_cache_group { };
 
 #endif
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 97686af89501..006edcc0c2c5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -560,12 +560,12 @@ static void exit_mm_sched_cache(struct mm_struct *mm)
 		return;
 	/*
 	 * No lock protection due to performance considerations.
-	 * Make sure mm->sc_stat.footprint does not become
+	 * Make sure the group footprint does not become
 	 * negative.
 	 */
-	fp = READ_ONCE(mm->sc_stat.footprint);
+	fp = READ_ONCE(mm->sched_cache_grp->footprint);
 	sub = min(fp, current->total_numa_faults);
-	WRITE_ONCE(mm->sc_stat.footprint, fp - sub);
+	WRITE_ONCE(mm->sched_cache_grp->footprint, fp - sub);
 }
 #else
 static inline void exit_mm_sched_cache(struct mm_struct *mm)
diff --git a/kernel/sched/build_utility.c b/kernel/sched/build_utility.c
index e2cf3b08d4e9..24202893b262 100644
--- a/kernel/sched/build_utility.c
+++ b/kernel/sched/build_utility.c
@@ -89,6 +89,10 @@
 # include "core_sched.c"
 #endif
 
+#ifdef CONFIG_SCHED_CACHE
+# include "cache_sched.c"
+#endif
+
 #ifdef CONFIG_PSI
 # include "psi.c"
 #endif
diff --git a/kernel/sched/cache_sched.c b/kernel/sched/cache_sched.c
new file mode 100644
index 000000000000..d492df55f9d5
--- /dev/null
+++ b/kernel/sched/cache_sched.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "sched.h"
+
+static void sched_cache_group_free_rcu(struct rcu_head *rcu)
+{
+	struct sched_cache_group *grp =
+		container_of(rcu, struct sched_cache_group, rcu);
+
+	/* free_percpu() may be called from atomic context. */
+	free_percpu(grp->pcpu_sched);
+	kfree(grp);
+}
+
+void sched_cache_group_put(struct sched_cache_group *grp)
+{
+	if (!grp || !refcount_dec_and_test(&grp->refcnt))
+		return;
+
+	call_rcu(&grp->rcu, sched_cache_group_free_rcu);
+}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf..8587dcbaa1cf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1489,7 +1489,7 @@ static bool exceed_llc_capacity(struct mm_struct *mm, int cpu)
 		 * excluded.
 		 */
 		llc = sd->llc_bytes;
-		footprint = READ_ONCE(mm->sc_stat.footprint);
+		footprint = READ_ONCE(mm->sched_cache_grp->footprint);
 
 		/*
 		 * Scale the LLC size by 256*llc_aggr_tolerance
@@ -1534,7 +1534,7 @@ static bool invalid_llc_nr(struct mm_struct *mm, struct task_struct *p,
 	if (scale == INT_MAX)
 		return false;
 
-	return !fits_capacity((mm->sc_stat.nr_running_avg * cpu_smt_num_threads),
+	return !fits_capacity((mm->sched_cache_grp->nr_running_avg * cpu_smt_num_threads),
 			(scale * per_cpu(sd_llc_size, cpu)));
 }
 
@@ -1611,12 +1611,20 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
 	}
 }
 
-void mm_init_sched(struct mm_struct *mm,
-		   struct sched_cache_time __percpu *_pcpu_sched)
+int mm_init_sched(struct mm_struct *mm,
+		  struct sched_cache_time __percpu *_pcpu_sched)
 {
+	struct sched_cache_group *grp;
 	unsigned long epoch = 0;
 	int i;
 
+	grp = kzalloc_obj(*grp);
+	if (!grp) {
+		free_percpu(_pcpu_sched);
+		mm->sched_cache_grp = NULL;
+		return -ENOMEM;
+	}
+
 	for_each_possible_cpu(i) {
 		struct sched_cache_time *pcpu_sched = per_cpu_ptr(_pcpu_sched, i);
 		struct rq *rq = cpu_rq(i);
@@ -1627,18 +1635,35 @@ void mm_init_sched(struct mm_struct *mm,
 		epoch = rq->cpu_epoch;
 	}
 
-	raw_spin_lock_init(&mm->sc_stat.lock);
-	mm->sc_stat.epoch = epoch;
-	mm->sc_stat.cpu = -1;
-	mm->sc_stat.next_scan = jiffies;
-	mm->sc_stat.nr_running_avg = 0;
-	mm->sc_stat.footprint = 0;
+	raw_spin_lock_init(&grp->lock);
+	grp->epoch = epoch;
+	grp->cpu = -1;
+	grp->next_scan = jiffies;
+	grp->nr_running_avg = 0;
+	grp->footprint = 0;
+	refcount_set(&grp->refcnt, 1);
 	/*
-	 * The update to mm->sc_stat should not be reordered
-	 * before initialization to mm's other fields, in case
+	 * The update to grp->pcpu_sched should not be reordered
+	 * before initialization to grp's other fields, in case
 	 * the readers may get invalid mm_sched_epoch, etc.
 	 */
-	smp_store_release(&mm->sc_stat.pcpu_sched, _pcpu_sched);
+	smp_store_release(&grp->pcpu_sched, _pcpu_sched);
+	/*
+	 * Publish the group last.  Not every reader qualifies it by
+	 * grp->pcpu_sched - can_migrate_llc_task() only checks that the
+	 * pointer is non-NULL before reading grp->footprint and
+	 * grp->nr_running_avg - so a reachable group must already be
+	 * fully initialized.
+	 */
+	mm->sched_cache_grp = grp;
+	return 0;
+}
+
+void mm_destroy_sched(struct mm_struct *mm)
+{
+	if (mm->sched_cache_grp)
+		sched_cache_group_put(mm->sched_cache_grp);
+	mm->sched_cache_grp = NULL;
 }
 
 /* because why would C be fully specified */
@@ -1696,7 +1721,7 @@ static int get_pref_llc(struct task_struct *p, struct mm_struct *mm)
 	if (!mm)
 		return -1;
 
-	mm_sched_cpu = READ_ONCE(mm->sc_stat.cpu);
+	mm_sched_cpu = READ_ONCE(mm->sched_cache_grp->cpu);
 	if (mm_sched_cpu != -1) {
 		mm_sched_llc = llc_id(mm_sched_cpu);
 
@@ -1739,11 +1764,15 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	/*
 	 * init_task, kthreads and user thread created
 	 * by user_mode_thread() don't have mm.
+	 *
+	 * A kthread can temporarily adopt an mm via kthread_use_mm(),
+	 * so p->mm alone does not imply a user task.
 	 */
-	if (!mm || !mm->sc_stat.pcpu_sched)
+	if (!mm || p->flags & PF_KTHREAD || !mm->sched_cache_grp ||
+	    !mm->sched_cache_grp->pcpu_sched)
 		return;
 
-	pcpu_sched = per_cpu_ptr(mm->sc_stat.pcpu_sched, cpu_of(rq));
+	pcpu_sched = per_cpu_ptr(mm->sched_cache_grp->pcpu_sched, cpu_of(rq));
 
 	scoped_guard (raw_spinlock, &rq->cpu_epoch_lock) {
 		__update_mm_sched(rq, pcpu_sched);
@@ -1756,11 +1785,11 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	 * If this process hasn't hit task_cache_work() for a while invalidate
 	 * its preferred state.
 	 */
-	if ((long)(epoch - READ_ONCE(mm->sc_stat.epoch)) > llc_epoch_affinity_timeout ||
+	if ((long)(epoch - READ_ONCE(mm->sched_cache_grp->epoch)) > llc_epoch_affinity_timeout ||
 	    invalid_llc_nr(mm, p, cpu_of(rq)) ||
 	    exceed_llc_capacity(mm, cpu_of(rq))) {
-		if (READ_ONCE(mm->sc_stat.cpu) != -1)
-			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		if (READ_ONCE(mm->sched_cache_grp->cpu) != -1)
+			WRITE_ONCE(mm->sched_cache_grp->cpu, -1);
 	}
 
 	mm_sched_llc = get_pref_llc(p, mm);
@@ -1784,19 +1813,19 @@ static void task_tick_cache(struct rq *rq, struct task_struct *p)
 		return;
 
 	if (!mm || p->flags & PF_KTHREAD ||
-	    !mm->sc_stat.pcpu_sched)
+	    !mm->sched_cache_grp->pcpu_sched)
 		return;
 
 	epoch = rq->cpu_epoch;
 	/* avoid moving backwards */
-	if (time_after_eq(mm->sc_stat.epoch, epoch))
+	if (time_after_eq(mm->sched_cache_grp->epoch, epoch))
 		return;
 
-	guard(raw_spinlock)(&mm->sc_stat.lock);
+	guard(raw_spinlock)(&mm->sched_cache_grp->lock);
 
 	if (work->next == work) {
 		task_work_add(p, work, TWA_RESUME);
-		WRITE_ONCE(mm->sc_stat.epoch, epoch);
+		WRITE_ONCE(mm->sched_cache_grp->epoch, epoch);
 	}
 }
 
@@ -1808,7 +1837,7 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p)
 	if (!static_branch_likely(&sched_numa_balancing))
 		goto out;
 
-	cpu = READ_ONCE(p->mm->sc_stat.cpu);
+	cpu = READ_ONCE(p->mm->sched_cache_grp->cpu);
 	if (cpu != -1)
 		nid = cpu_to_node(cpu);
 	curr_cpu = task_cpu(p);
@@ -1880,12 +1909,12 @@ static void task_cache_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;
 
-	next_scan = READ_ONCE(mm->sc_stat.next_scan);
+	next_scan = READ_ONCE(mm->sched_cache_grp->next_scan);
 	if (time_before(now, next_scan))
 		return;
 
 	/* only 1 thread is allowed to scan */
-	if (!try_cmpxchg(&mm->sc_stat.next_scan, &next_scan,
+	if (!try_cmpxchg(&mm->sched_cache_grp->next_scan, &next_scan,
 			 now + max_t(unsigned long,
 				     READ_ONCE(llc_epoch_period), 1)))
 		return;
@@ -1893,8 +1922,8 @@ static void task_cache_work(struct callback_head *work)
 	curr_cpu = task_cpu(p);
 	if (invalid_llc_nr(mm, p, curr_cpu) ||
 	    exceed_llc_capacity(mm, curr_cpu)) {
-		if (READ_ONCE(mm->sc_stat.cpu) != -1)
-			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		if (READ_ONCE(mm->sched_cache_grp->cpu) != -1)
+			WRITE_ONCE(mm->sched_cache_grp->cpu, -1);
 
 		return;
 	}
@@ -1917,8 +1946,10 @@ static void task_cache_work(struct callback_head *work)
 				continue;
 
 			for_each_cpu(i, sched_domain_span(sd)) {
+				struct sched_cache_group *grp = mm->sched_cache_grp;
+
 				occ = fraction_mm_sched(cpu_rq(i),
-							per_cpu_ptr(mm->sc_stat.pcpu_sched, i));
+							per_cpu_ptr(grp->pcpu_sched, i));
 				a_occ += occ;
 				if (occ > m_occ) {
 					m_occ = occ;
@@ -1951,7 +1982,7 @@ static void task_cache_work(struct callback_head *work)
 				m_a_cpu = m_cpu;
 			}
 
-			if (llc_id(cpu) == llc_id(READ_ONCE(mm->sc_stat.cpu)))
+			if (llc_id(cpu) == llc_id(READ_ONCE(mm->sched_cache_grp->cpu)))
 				curr_m_a_occ = a_occ;
 
 			cpumask_andnot(cpus, cpus, sched_domain_span(sd));
@@ -1960,7 +1991,7 @@ static void task_cache_work(struct callback_head *work)
 
 	if (m_a_occ > (2 * curr_m_a_occ)) {
 		/*
-		 * Avoid switching sc_stat.cpu too fast.
+		 * Avoid switching sched_cache_grp->cpu too fast.
 		 * The reason to choose 2X is because:
 		 * 1. It is better to keep the preferred LLC stable,
 		 *    rather than changing it frequently and cause migrations
@@ -1969,10 +2000,10 @@ static void task_cache_work(struct callback_head *work)
 		 * 3. 2X is chosen based on test results, as it delivers
 		 *    the optimal performance gain so far.
 		 */
-		WRITE_ONCE(mm->sc_stat.cpu, m_a_cpu);
+		WRITE_ONCE(mm->sched_cache_grp->cpu, m_a_cpu);
 	}
 
-	update_avg_scale(&mm->sc_stat.nr_running_avg, nr_running);
+	update_avg_scale(&mm->sched_cache_grp->nr_running_avg, nr_running);
 	free_cpumask_var(cpus);
 }
 
@@ -3776,18 +3807,19 @@ static void task_numa_placement(struct task_struct *p)
 			 * heuristic and occasional lost updates are tolerable.
 			 *
 			 * If a task exits, its corresponding footprint must
-			 * be subtracted from the mm->sc_stat.footprint, otherwise
-			 * the mm->sc_stat.footprint will not converge:
-			 * the exiting thread's footprint remains unchanged/undecayed
-			 * in mm->sc_stat.footprint. See exit_mm().
+			 * be subtracted from the mm->sched_cache_grp->footprint,
+			 * otherwise the mm->sched_cache_grp->footprint will not
+			 * converge: the exiting thread's footprint remains
+			 * unchanged/undecayed in mm->sched_cache_grp->footprint.
+			 * See exit_mm().
 			 *
 			 * Lost updates and unsynchronized subtraction
 			 * in exit_mm() can cause footprint + diff to
 			 * go negative. Clamp to zero to prevent the
 			 * unsigned footprint from wrapping.
 			 */
-			new_fp = (long)READ_ONCE(p->mm->sc_stat.footprint) + diff;
-			WRITE_ONCE(p->mm->sc_stat.footprint,
+			new_fp = (long)READ_ONCE(p->mm->sched_cache_grp->footprint) + diff;
+			WRITE_ONCE(p->mm->sched_cache_grp->footprint,
 				   max(new_fp, 0L));
 #endif
 		}
@@ -10703,18 +10735,18 @@ static enum llc_mig can_migrate_llc_task(int src_cpu, int dst_cpu,
 	int cpu;
 
 	mm = p->mm;
-	if (!mm)
+	if (!mm || !mm->sched_cache_grp)
 		return mig_unrestricted;
 
-	cpu = READ_ONCE(mm->sc_stat.cpu);
+	cpu = READ_ONCE(mm->sched_cache_grp->cpu);
 	if (cpu < 0 || cpus_share_cache(src_cpu, dst_cpu))
 		return mig_unrestricted;
 
 	/* skip cache aware load balance for too many threads */
 	if (invalid_llc_nr(mm, p, dst_cpu) ||
 	    exceed_llc_capacity(mm, dst_cpu)) {
-		if (READ_ONCE(mm->sc_stat.cpu) != -1)
-			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		if (READ_ONCE(mm->sched_cache_grp->cpu) != -1)
+			WRITE_ONCE(mm->sched_cache_grp->cpu, -1);
 		return mig_unrestricted;
 	}
 
-- 
2.32.0


