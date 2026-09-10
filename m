Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42159C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613C56B0099; Thu, 10 Sep 2026 13:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4F36B009B; Thu, 10 Sep 2026 13:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43EC86B009E; Thu, 10 Sep 2026 13:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A65A6B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:40:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BD4E80597
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:40:55 +0000 (UTC)
X-FDA: 85198568070.24.428BA86
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf18.hostedemail.com (Postfix) with ESMTP id 467731C000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:40:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="aJaRx3/n";
	spf=pass (imf18.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789062053;
	b=dPkmzEdl283EVmIbDKmEYskv4s7EBirynCrITLu7jSgZ0SdNXNVorW62HLMwxPGm5/h+o2
	/c3BBHOP1QNuTW7K3Gn0e2c7VfsrrG4tXcV8ZpzbCylwRt6khJhIohDoK5owuaxQCcjb6F
	cy8lPLmlD4GQPDMLbvNO1wItKV7qwR4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="aJaRx3/n";
	spf=pass (imf18.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789062053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHehugcdwgkeFJpldUBtpuhzImAxeKTmzHzCt57fkkM=;
	b=Rr78L+OKhWBDnNBKhME1DU9yCwobHl+pm8G2GwCDa1XfmAiY7kEh1wwyboOoSBg3q4Z0Zp
	GdTCHW3TXCoMuwOjV/D5FX8TYNFeT32O3VflefwrVsZ6HM2mpZexhRBrzB0A8Dgj9jERKQ
	MbZ5mj8JdEpxeyfRdyrJ0XJMDhd7PdA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789062053; x=1820598053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dc2RMLeUehLuIVfyB7SwlY7vmORAF8TywZmeXgYir0k=;
  b=aJaRx3/nIo0jXwv5ebjs5SeTGgDn6OUQvtN077pQgWeGy7hsxergSH01
   NBFPHuJea2BuQNOTVjeRNzSDaZOolBPpxDV7MZT4jJ2ct4pwYebTq+9GF
   amOr58nLVxQU1WvK8HFb8yxtApXLf21cxS22x+kXbUiLtiCMCKgcIVbMy
   7xJY/UEs+cAelMlrAbY4OR6j86RGmUb9J91ImbmVYbiFuf/mBJki5cYgP
   sggXmoZPXofE8wnonDMet2rMI4lPna3BrokwGSM9UWGVjJuSby/FFQWx5
   m7hiGcL7PUenxYk3JNwOQEZsYyloZmqJsnMvibBiQJZRxgFnWsTNPi0+Z
   g==;
X-CSE-ConnectionGUID: Inftv7plTd2kUIc0ye0ZDA==
X-CSE-MsgGUID: oPetZqblQym6KWTvaZkA8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89453828"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="89453828"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 10:40:52 -0700
X-CSE-ConnectionGUID: rmltQ60YQxmnoyF6tpw5lA==
X-CSE-MsgGUID: Iax3Joh0TFeIm2CtQ2sinQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="275222021"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by orviesa003.jf.intel.com with ESMTP; 10 Sep 2026 10:40:51 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	Ricardo Neri-Calderon <ricardo.neri-calderon@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Lu Wang <wanglu.priv@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/4] sched/cache: Decouple sched_cache_group from mm
Date: Thu, 10 Sep 2026 10:46:11 -0700
Message-Id: <cb678eddae708e2865ec69a04edf999119c2168a.1789061845.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1789061845.git.tim.c.chen@linux.intel.com>
References: <cover.1789061845.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 467731C000B
X-Stat-Signature: ea3ahwwn8fgpj8ab1bu66xz43emckfq5
X-HE-Tag: 1789062053-313367
X-HE-Meta: U2FsdGVkX1+ZLgCTOgoEbZCsC4qmf9u5FpsqlO5R7xeKIxKuibQr9VGNJf96m90t8xEQa+Z+VvgnQi0VbWvzceqb844Ew5oqPy0pLyvFQhU6Z/yhv+hCQj+kKMvdabUs0TISRckVhKxEZ8MpjqyP7E4Uh5uoNCRZ+hB0DIxCQ9rX9f2ALPvQM46XRPWDpcAO4b1zpaWDk4l7BJWbRojwLNlIL/ckhthysT7wt+m5t7sYTAWyRYTBRX5VHiwT425of2JOec232kSLm59924i1XtkMJkNfj9oA0gQEriWPf6r9U47rfQ7ok+MziJlfZamY+JKYdVvPHw8cGif77kEFk2wie/8vE0xB1OXAYZWZG754JnegwvNwYeNwd63S4CsFB0SieM1K2s9nFP52yZyQgdyyA1na1zZ0jrEkFTzQwvOqSDB7Txs9gnFr5BF91sv+Uf/yby1Co0+izkHpHTKPEvg8Xn6gnljR6VHW+b0Fcq8kiwpHp1plzgyC5POOkhIHclVbRbtzBKrkpenY16T5LS87rEpfh39Bo+wstlpkmUBchy2pTm7bAmU7vm91y+CYRObQvLDGbZKT9d3N5ENhCEj240DDvkYMqo8iQFjqFu2yG62naoRzVXxwcY+FHa9sGQgcTvabdqUVEZEn96+yvu3tc0LRkhyj7Ng3uy1K/tZkqUMF46PBtsgBaM6Mx2R9OIBH5OnfLCAwry3aWCbpMYmQOa5T3ntHzA+F4eak6DcagqKmVHwKnd8We+7rMK/4WpDX3hpJeHcBXGsRoadSSffAOf5+g1mG6YAvvZRjnbNyqo6rJsqGUOPDWj/CNmpNBsERoGJ2/IpaVjPV+2FP9/pUqSMdbltALSewZVNDnX1gduopZMqdS7SMJ/tOWEM0q9ZJ5/YEGfDyPskcCAJfXslv0sbAJZ17kfGdHHwn+I0Cmtg8hnRzee9e0FLZjGFYje1cdlBntm6gWakWSLs
 Yqd+Erl0
 Y+fhw0qIcVnBlqpSYvRvpejzy3sRv5xhrF4PT/y1ULzpMk//yogQxaXIBEhR3ALQgo77ag1kmf9DWqM6RKiAJSewgrXVChzPQzaGRh7s4p9UG6Xej6QAdzijrgpYIEkNAGNCW4ko77doqS5oUuqCu/6+Zup69d9/Kdwtw++Uxvk2menrmKl2v+E/3yYYxLlPJQUx9l5CabzQmHdNJfNxws+7JdEdk3LiI73cSaxXW+ygZKzISUiS2EPaVSe9f7+bffb2rVhaLqzOG06nkKQ2VZ4rpWSoQC6AOjInodGPozN2w1WQwJvm40KmFORwhWW5uvxGUPnnp0OWgTyQYpTA8dyZj4Y0Nmr9ILG7w
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
mm_struct with its own ref counting.  This allows us in the next patch
access sched_cache_group directly from task, and add a refcount
on sched_cache_group when a task links to it. This prevents the use
after free issue when accessing stale and released old mm and its
sched cache stat a task switches to a new mm while account_mm_sched()
is done elsewhere.

The other benefit of this restructure is in the future, the grouping of
tasks to a LLC would have the flexibility to be associated with a user
defined grouping, or cgroup, cookie group, numa_group or others instead
of just with a single mm address space.

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
index 32213801ea39..b5a823f0a622 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1502,7 +1502,7 @@ static bool exceed_llc_capacity(struct mm_struct *mm, int cpu)
 		 * excluded.
 		 */
 		llc = sd->llc_bytes;
-		footprint = READ_ONCE(mm->sc_stat.footprint);
+		footprint = READ_ONCE(mm->sched_cache_grp->footprint);
 
 		/*
 		 * Scale the LLC size by 256*llc_aggr_tolerance
@@ -1547,7 +1547,7 @@ static bool invalid_llc_nr(struct mm_struct *mm, struct task_struct *p,
 	if (scale == INT_MAX)
 		return false;
 
-	return !fits_capacity((mm->sc_stat.nr_running_avg * cpu_smt_num_threads),
+	return !fits_capacity((mm->sched_cache_grp->nr_running_avg * cpu_smt_num_threads),
 			(scale * per_cpu(sd_llc_size, cpu)));
 }
 
@@ -1653,12 +1653,20 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
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
@@ -1669,18 +1677,35 @@ void mm_init_sched(struct mm_struct *mm,
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
@@ -1738,7 +1763,7 @@ static int get_pref_llc(struct task_struct *p, struct mm_struct *mm)
 	if (!mm)
 		return -1;
 
-	mm_sched_cpu = READ_ONCE(mm->sc_stat.cpu);
+	mm_sched_cpu = READ_ONCE(mm->sched_cache_grp->cpu);
 	if (mm_sched_cpu != -1) {
 		mm_sched_llc = llc_id(mm_sched_cpu);
 
@@ -1781,11 +1806,15 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
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
@@ -1798,11 +1827,11 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
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
@@ -1826,19 +1855,19 @@ static void task_tick_cache(struct rq *rq, struct task_struct *p)
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
 
@@ -1850,7 +1879,7 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p)
 	if (!static_branch_likely(&sched_numa_balancing))
 		goto out;
 
-	cpu = READ_ONCE(p->mm->sc_stat.cpu);
+	cpu = READ_ONCE(p->mm->sched_cache_grp->cpu);
 	if (cpu != -1)
 		nid = cpu_to_node(cpu);
 	curr_cpu = task_cpu(p);
@@ -1922,12 +1951,12 @@ static void task_cache_work(struct callback_head *work)
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
@@ -1935,8 +1964,8 @@ static void task_cache_work(struct callback_head *work)
 	curr_cpu = task_cpu(p);
 	if (invalid_llc_nr(mm, p, curr_cpu) ||
 	    exceed_llc_capacity(mm, curr_cpu)) {
-		if (READ_ONCE(mm->sc_stat.cpu) != -1)
-			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		if (READ_ONCE(mm->sched_cache_grp->cpu) != -1)
+			WRITE_ONCE(mm->sched_cache_grp->cpu, -1);
 
 		return;
 	}
@@ -1959,8 +1988,10 @@ static void task_cache_work(struct callback_head *work)
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
@@ -1993,7 +2024,7 @@ static void task_cache_work(struct callback_head *work)
 				m_a_cpu = m_cpu;
 			}
 
-			if (llc_id(cpu) == llc_id(READ_ONCE(mm->sc_stat.cpu)))
+			if (llc_id(cpu) == llc_id(READ_ONCE(mm->sched_cache_grp->cpu)))
 				curr_m_a_occ = a_occ;
 
 			cpumask_andnot(cpus, cpus, sched_domain_span(sd));
@@ -2002,7 +2033,7 @@ static void task_cache_work(struct callback_head *work)
 
 	if (m_a_occ > (2 * curr_m_a_occ)) {
 		/*
-		 * Avoid switching sc_stat.cpu too fast.
+		 * Avoid switching sched_cache_grp->cpu too fast.
 		 * The reason to choose 2X is because:
 		 * 1. It is better to keep the preferred LLC stable,
 		 *    rather than changing it frequently and cause migrations
@@ -2011,10 +2042,10 @@ static void task_cache_work(struct callback_head *work)
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
 
@@ -3822,18 +3853,19 @@ static void task_numa_placement(struct task_struct *p)
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
@@ -10788,18 +10820,18 @@ static enum llc_mig can_migrate_llc_task(struct lb_env *env,
 	src_cpu = env->src_cpu;
 	dst_cpu = env->dst_cpu;
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


