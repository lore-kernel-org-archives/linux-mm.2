Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6171AC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 00:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C09A6B00A9; Mon, 21 Sep 2026 20:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34BC36B00AA; Mon, 21 Sep 2026 20:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23AC06B00AB; Mon, 21 Sep 2026 20:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E91B46B00A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:32:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C162160346
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:19 +0000 (UTC)
X-FDA: 85239521598.08.16D9C5A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0DC17C0006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dpWcsFa1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790037136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOcuLdKTX//jgUT2oFjlUF7pbMhQxPCJE577teJ25P8=;
	b=h4GvvPJaKsA1kfG6hRceS/+byfPvmcgbMUmmhFs6xUS70yBhGm7BAo967JmIeR1tanznpe
	HQSo7NgmT/9g3EJHPh6sndCgxCtmS3JUTNSQjBvCOuX1l8zuTu8O6kMAi7DC399kx1pvKO
	whbmjLy22jLAVEI/rCLmFIrqn2Ia1po=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790037136;
	b=alYXjBLX/TM3YD2QXecbnQ/E6lq3KbOUWa2MTHnp5jKskv/lTeYNzjCTczsLlfNuAafxaE
	vuBuwEROOhWgTpvs6ftjlln7CZ4HULA6g5maQ1zHRMXZkrdghNzJtWYl3Z7XQeNDzDymN+
	gB08s8Yr3cbc4od2MQhJ9rZiUbEBiZI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dpWcsFa1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790037136; x=1821573136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NiligWz0gyX4ezHC8gHM6+vA0T6/3jJREB3L+QxjAf8=;
  b=dpWcsFa1Kmiw88a7SiWxSWJVEKLvpspZaxKyAHEPSFEkMLbFkAF/QtAC
   apFDx50vmiTO7j36aeYjCtv6UDEm+28aquIHBgDBfxPYZUm5KxpZeKMmF
   gXUOmo8JYtREpQaa9/B/xF7GZuBk6Sy6DczXs8IoLTwPUiSSicMjUlMAA
   SCkb71cIaVzi0QUYxG6BkkX/ymybHY1vbZtU5hmk5n2G6eh0w8Dc3GxYh
   gyx702TeWfViYW4RviM0oKR+RAjxMUUVGn4yosiQqcTmDbvz6ZcY6wKnJ
   8jBrYaQaAn136dV76UiswMJB0As8NygjwYx9pEsVmQes514zwFYmDlvSE
   A==;
X-CSE-ConnectionGUID: eDRBFRiWSwq6lek0RVXW5Q==
X-CSE-MsgGUID: tvsyuyrGR4KwUb+1K/Y5jQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90716680"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="90716680"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 17:32:15 -0700
X-CSE-ConnectionGUID: eZ2TKfSZTymQKBVejoNhvw==
X-CSE-MsgGUID: h98emjb1Rre/qLRRl6AFIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="277671856"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa004.fm.intel.com with ESMTP; 21 Sep 2026 17:32:14 -0700
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
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	stable@kernel.org
Subject: [PATCH v2 3/6] sched/cache: Decouple sched_cache_group from mm
Date: Mon, 21 Sep 2026 17:37:24 -0700
Message-Id: <91fd1e3266707c865bc9abecfb3e17bc676712df.1790035273.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1790035273.git.tim.c.chen@linux.intel.com>
References: <cover.1790035273.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0DC17C0006
X-Stat-Signature: 6t5w3zutdwzdzxihsx3qmeumjp61jbpq
X-HE-Tag: 1790037135-881662
X-HE-Meta: U2FsdGVkX1+gRsz/6T7u6zbc+MEcDVNfVLNAzawb1If3FfVRL3UNuVi8F4UgT4AdFLwulvK95BPpF2aTUYVtRXsrVDUE6IXTBcxuif2xIm4kpflFNOW4Zo+msADu0+fB6Mm3OujHdnoIcsJ85W/+gJ41ZMwG2KzXABNLRXwhA0o089mltwLq53oj74kBQi7G7LEmz/JQibOCC/+YDKn5xkocW8HU+811YQyqeMWAMNNWUrn4eYw7v9UVwE8ZC5U+I/GqIWh/GFYZ99ceC9PS6oTnddm6neyCSCE0OouhDq6vI25a7FYLiMlTjrsb2B81dB2BtEDpcHaOj9iCH0zE+jidobVsJWBjIUksilU4BwFwm6x4yDIQXDtNUkTjFk8Q8OHMMSKQwkK9J+hGd390cmxwMjlKkwxowwrGjy+S1tDc9e6ymYVjyC6F7FAr6E39PAmWyQ5QgYwBtS9ubFRfTV/nZcgki3hpkPiRj0RVEbV33CwHjiASWFDOHY7htlrsYlq9RHAUxS3ugHJSWUgQER8LK6C16Bj4mH+GdURAaXGRvIMFNHVYSfrqBnCOwLqEWyABS6n6xN+GoVO4kxYgVgoHQDiEhvFOnlwjWsqb0Uz0V8s20Z2o/zpr3dF1fogOPGUyj+00PF+FpbT34fB0xLFRn4zjOuSWeZOSX/DMViYKcdmzG6/QLqRybNrjOvx8AaMMu0z4e82Avewld7oNFu47gpsxfQ9I+8zJd46N10U2d08/uabmv3wyG9P2wu+HANdI3rcTA81UU3y05n3eG9uc23YRNbzXR0T6hM44dGNgWsy7tAyqciLeVbpp9//pajvrUtPDQ3iFhzuUwfQ9rE+UDdbbpbfWYvy6J79P4rzMXm3hSZSWdXVUa2Jvx2Ad6dlNHRz+sZvsblNAe0Zj3aFFwu4uAldUfzXLt7dnVS8oy48iJbYjYEblOm8RJn5xNAcw4tN/GpoqFunrUF0
 /1RoM3pE
 rmAfBJ9kf6C4edVyP60j1JV64M+xyShbMtiqbSpgvtT4Td9GnoI6zTcLdsKEiDiyf53MSX2CsDiQH35/bKh2n/skDBh9zVvcDTWT2qHUhX1cClSRl5z+QmkaggKlIsLoFxuBE7F6eoWKuMxl+axWHl9XowCXOsIfvyFsAuDgeiyJaTjLhe9KGSurTzLAPDtDHwJpgGc/7w8drh5yZHiEpciDAbIaPtvTCnMtAXzol0B+xlxt6964707JHNBgNz00dblgQkUM8YU5kR2jw/a7vXTdJ8nfUBk7lED7hB5I4MHI7np53c+bXCaeEgzXgSvcPmhtU5QBsF5yzyfi6EE3oS9KWZqAtcttCFbCg
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

Fixes: df0d98475954 ("sched/cache: Introduce infrastructure for cache-aware load balancing")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Closes: https://lore.kernel.org/lkml/apPb-Dr4nPYuHQOK@v4bel/
Reported-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/all/343a7e07-7fad-4979-9c9b-82ec038c293c@linux.dev/
Cc: stable@kernel.org #7.2.x
Co-developed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/mm_types.h     |  15 ++--
 include/linux/sched.h        |   8 +-
 kernel/exit.c                |  11 ++-
 kernel/sched/build_utility.c |   4 +
 kernel/sched/cache_sched.c   |  19 +++++
 kernel/sched/fair.c          | 156 ++++++++++++++++++++++++-----------
 6 files changed, 152 insertions(+), 61 deletions(-)
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
index 97686af89501..16abbe1cf682 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -554,18 +554,23 @@ void mm_update_next_owner(struct mm_struct *mm)
  */
 static void exit_mm_sched_cache(struct mm_struct *mm)
 {
+	struct sched_cache_group *grp;
 	unsigned long fp, sub;
 
 	if (!current->total_numa_faults)
 		return;
 	/*
 	 * No lock protection due to performance considerations.
-	 * Make sure mm->sc_stat.footprint does not become
+	 * Make sure the group footprint does not become
 	 * negative.
 	 */
-	fp = READ_ONCE(mm->sc_stat.footprint);
+	grp = READ_ONCE(mm->sched_cache_grp);
+	if (!grp)
+		return;
+
+	fp = READ_ONCE(grp->footprint);
 	sub = min(fp, current->total_numa_faults);
-	WRITE_ONCE(mm->sc_stat.footprint, fp - sub);
+	WRITE_ONCE(grp->footprint, fp - sub);
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
index 000000000000..ff3d9538e7a4
--- /dev/null
+++ b/kernel/sched/cache_sched.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "sched.h"
+
+static void sched_cache_group_free_rcu(struct rcu_head *rcu)
+{
+	struct sched_cache_group *grp =
+		container_of(rcu, struct sched_cache_group, rcu);
+
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
index 6f1939d17e9e..6e939807dff2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1497,12 +1497,17 @@ static bool exceed_llc_capacity(struct mm_struct *mm, int cpu)
 		return true;
 
 	if (static_branch_likely(&sched_numa_balancing)) {
+		struct sched_cache_group *grp = READ_ONCE(mm->sched_cache_grp);
+
+		if (!grp)
+			return true;
+
 		/*
 		 * TBD: RDT exclusive LLC ways reserved should be
 		 * excluded.
 		 */
 		llc = sd->llc_bytes;
-		footprint = READ_ONCE(mm->sc_stat.footprint);
+		footprint = READ_ONCE(grp->footprint);
 
 		/*
 		 * Scale the LLC size by 256*llc_aggr_tolerance
@@ -1534,6 +1539,7 @@ static bool exceed_llc_capacity(struct mm_struct *mm, int cpu)
 static bool invalid_llc_nr(struct mm_struct *mm, struct task_struct *p,
 			   int cpu)
 {
+	struct sched_cache_group *grp;
 	int scale;
 
 	if (get_nr_threads(p) <= 1)
@@ -1547,7 +1553,11 @@ static bool invalid_llc_nr(struct mm_struct *mm, struct task_struct *p,
 	if (scale == INT_MAX)
 		return false;
 
-	return !fits_capacity((mm->sc_stat.nr_running_avg * cpu_smt_num_threads),
+	grp = READ_ONCE(mm->sched_cache_grp);
+	if (!grp)
+		return true;
+
+	return !fits_capacity((READ_ONCE(grp->nr_running_avg) * cpu_smt_num_threads),
 			(scale * per_cpu(sd_llc_size, cpu)));
 }
 
@@ -1653,12 +1663,20 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
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
@@ -1669,18 +1687,34 @@ void mm_init_sched(struct mm_struct *mm,
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
+	smp_store_release(&mm->sched_cache_grp, grp);
+	return 0;
+}
+
+void mm_destroy_sched(struct mm_struct *mm)
+{
+	sched_cache_group_put(mm->sched_cache_grp);
+	mm->sched_cache_grp = NULL;
 }
 
 /* because why would C be fully specified */
@@ -1734,11 +1768,16 @@ static unsigned long fraction_mm_sched(struct rq *rq,
 static int get_pref_llc(struct task_struct *p, struct mm_struct *mm)
 {
 	int mm_sched_llc = -1, mm_sched_cpu;
+	struct sched_cache_group *grp;
 
 	if (!mm)
 		return -1;
 
-	mm_sched_cpu = READ_ONCE(mm->sc_stat.cpu);
+	grp = READ_ONCE(mm->sched_cache_grp);
+	if (!grp)
+		return -1;
+
+	mm_sched_cpu = READ_ONCE(grp->cpu);
 	if (mm_sched_cpu != -1) {
 		mm_sched_llc = llc_id(mm_sched_cpu);
 
@@ -1769,6 +1808,7 @@ static inline
 void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 {
 	struct sched_cache_time *pcpu_sched;
+	struct sched_cache_group *grp;
 	struct mm_struct *mm = p->mm;
 	int mm_sched_llc = -1;
 	unsigned long epoch;
@@ -1782,10 +1822,14 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	 * init_task, kthreads and user thread created
 	 * by user_mode_thread() don't have mm.
 	 */
-	if (!mm || !mm->sc_stat.pcpu_sched)
+	if (!mm)
+		return;
+
+	grp = READ_ONCE(mm->sched_cache_grp);
+	if (!grp || !grp->pcpu_sched)
 		return;
 
-	pcpu_sched = per_cpu_ptr(mm->sc_stat.pcpu_sched, cpu_of(rq));
+	pcpu_sched = per_cpu_ptr(grp->pcpu_sched, cpu_of(rq));
 
 	scoped_guard (raw_spinlock, &rq->cpu_epoch_lock) {
 		__update_mm_sched(rq, pcpu_sched);
@@ -1798,11 +1842,11 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	 * If this process hasn't hit task_cache_work() for a while invalidate
 	 * its preferred state.
 	 */
-	if ((long)(epoch - READ_ONCE(mm->sc_stat.epoch)) > llc_epoch_affinity_timeout ||
+	if ((long)(epoch - READ_ONCE(grp->epoch)) > llc_epoch_affinity_timeout ||
 	    invalid_llc_nr(mm, p, cpu_of(rq)) ||
 	    exceed_llc_capacity(mm, cpu_of(rq))) {
-		if (READ_ONCE(mm->sc_stat.cpu) != -1)
-			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		if (READ_ONCE(grp->cpu) != -1)
+			WRITE_ONCE(grp->cpu, -1);
 	}
 
 	mm_sched_llc = get_pref_llc(p, mm);
@@ -1819,30 +1863,35 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 static void task_tick_cache(struct rq *rq, struct task_struct *p)
 {
 	struct callback_head *work = &p->cache_work;
+	struct sched_cache_group *grp;
 	struct mm_struct *mm = p->mm;
 	unsigned long epoch;
 
 	if (!sched_cache_enabled())
 		return;
 
-	if (!mm || p->flags & PF_KTHREAD ||
-	    !mm->sc_stat.pcpu_sched)
+	if (!mm || p->flags & PF_KTHREAD)
+		return;
+
+	grp = READ_ONCE(mm->sched_cache_grp);
+	if (!grp || !grp->pcpu_sched)
 		return;
 
 	epoch = rq->cpu_epoch;
 	/* avoid moving backwards */
-	if (time_after_eq(mm->sc_stat.epoch, epoch))
+	if (time_after_eq(grp->epoch, epoch))
 		return;
 
-	guard(raw_spinlock)(&mm->sc_stat.lock);
+	guard(raw_spinlock)(&grp->lock);
 
 	if (work->next == work) {
 		task_work_add(p, work, TWA_RESUME);
-		WRITE_ONCE(mm->sc_stat.epoch, epoch);
+		WRITE_ONCE(grp->epoch, epoch);
 	}
 }
 
-static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p)
+static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p,
+			      struct sched_cache_group *grp)
 {
 #ifdef CONFIG_NUMA_BALANCING
 	int cpu, curr_cpu, nid, pref_nid;
@@ -1850,7 +1899,7 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p)
 	if (!static_branch_likely(&sched_numa_balancing))
 		goto out;
 
-	cpu = READ_ONCE(p->mm->sc_stat.cpu);
+	cpu = READ_ONCE(grp->cpu);
 	if (cpu != -1)
 		nid = cpu_to_node(cpu);
 	curr_cpu = task_cpu(p);
@@ -1911,6 +1960,7 @@ static void task_cache_work(struct callback_head *work)
 	unsigned long next_scan, now = jiffies;
 	struct task_struct *p = current, *cur;
 	unsigned long curr_m_a_occ = 0;
+	struct sched_cache_group *grp;
 	struct mm_struct *mm = p->mm;
 	unsigned long m_a_occ = 0;
 	cpumask_var_t cpus;
@@ -1922,12 +1972,16 @@ static void task_cache_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;
 
-	next_scan = READ_ONCE(mm->sc_stat.next_scan);
+	grp = READ_ONCE(mm->sched_cache_grp);
+	if (!grp)
+		return;
+
+	next_scan = READ_ONCE(grp->next_scan);
 	if (time_before(now, next_scan))
 		return;
 
 	/* only 1 thread is allowed to scan */
-	if (!try_cmpxchg(&mm->sc_stat.next_scan, &next_scan,
+	if (!try_cmpxchg(&grp->next_scan, &next_scan,
 			 now + max_t(unsigned long,
 				     READ_ONCE(llc_epoch_period), 1)))
 		return;
@@ -1935,8 +1989,8 @@ static void task_cache_work(struct callback_head *work)
 	curr_cpu = task_cpu(p);
 	if (invalid_llc_nr(mm, p, curr_cpu) ||
 	    exceed_llc_capacity(mm, curr_cpu)) {
-		if (READ_ONCE(mm->sc_stat.cpu) != -1)
-			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		if (READ_ONCE(grp->cpu) != -1)
+			WRITE_ONCE(grp->cpu, -1);
 
 		return;
 	}
@@ -1947,7 +2001,7 @@ static void task_cache_work(struct callback_head *work)
 	scoped_guard (cpus_read_lock) {
 		guard(rcu)();
 
-		get_scan_cpumasks(cpus, p);
+		get_scan_cpumasks(cpus, p, grp);
 
 		for_each_cpu(cpu, cpus) {
 			/* XXX sched_cluster_active */
@@ -1960,7 +2014,7 @@ static void task_cache_work(struct callback_head *work)
 
 			for_each_cpu(i, sched_domain_span(sd)) {
 				occ = fraction_mm_sched(cpu_rq(i),
-							per_cpu_ptr(mm->sc_stat.pcpu_sched, i));
+							per_cpu_ptr(grp->pcpu_sched, i));
 				a_occ += occ;
 				if (occ > m_occ) {
 					m_occ = occ;
@@ -1993,7 +2047,7 @@ static void task_cache_work(struct callback_head *work)
 				m_a_cpu = m_cpu;
 			}
 
-			if (llc_id(cpu) == llc_id(READ_ONCE(mm->sc_stat.cpu)))
+			if (llc_id(cpu) == llc_id(READ_ONCE(grp->cpu)))
 				curr_m_a_occ = a_occ;
 
 			cpumask_andnot(cpus, cpus, sched_domain_span(sd));
@@ -2002,7 +2056,7 @@ static void task_cache_work(struct callback_head *work)
 
 	if (m_a_occ > (2 * curr_m_a_occ)) {
 		/*
-		 * Avoid switching sc_stat.cpu too fast.
+		 * Avoid switching sched_cache_grp->cpu too fast.
 		 * The reason to choose 2X is because:
 		 * 1. It is better to keep the preferred LLC stable,
 		 *    rather than changing it frequently and cause migrations
@@ -2011,10 +2065,10 @@ static void task_cache_work(struct callback_head *work)
 		 * 3. 2X is chosen based on test results, as it delivers
 		 *    the optimal performance gain so far.
 		 */
-		WRITE_ONCE(mm->sc_stat.cpu, m_a_cpu);
+		WRITE_ONCE(grp->cpu, m_a_cpu);
 	}
 
-	update_avg_scale(&mm->sc_stat.nr_running_avg, nr_running);
+	update_avg_scale(&grp->nr_running_avg, nr_running);
 	free_cpumask_var(cpus);
 }
 
@@ -3731,6 +3785,7 @@ static int preferred_group_nid(struct task_struct *p, int nid)
 static void task_numa_placement(struct task_struct *p)
 	__context_unsafe(/* conditional locking */)
 {
+	struct sched_cache_group __maybe_unused *grp;
 	int seq, nid, max_nid = NUMA_NO_NODE;
 	unsigned long max_faults = 0;
 	unsigned long fault_types[2] = { 0, 0 };
@@ -3823,19 +3878,23 @@ static void task_numa_placement(struct task_struct *p)
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
-				   max(new_fp, 0L));
+			grp = READ_ONCE(p->mm->sched_cache_grp);
+			if (!grp)
+				continue;
+
+			new_fp = (long)READ_ONCE(grp->footprint) + diff;
+			WRITE_ONCE(grp->footprint, max(new_fp, 0L));
 #endif
 		}
 
@@ -10783,6 +10842,7 @@ static inline bool task_misfits_asym_cpu(struct lb_env *env, struct task_struct
 static enum llc_mig can_migrate_llc_task(struct lb_env *env,
 					 struct task_struct *p)
 {
+	struct sched_cache_group *grp;
 	struct mm_struct *mm;
 	bool to_pref;
 	int cpu, src_cpu, dst_cpu;
@@ -10796,15 +10856,19 @@ static enum llc_mig can_migrate_llc_task(struct lb_env *env,
 	if (!mm)
 		return mig_unrestricted;
 
-	cpu = READ_ONCE(mm->sc_stat.cpu);
+	grp = READ_ONCE(mm->sched_cache_grp);
+	if (!grp)
+		return mig_unrestricted;
+
+	cpu = READ_ONCE(grp->cpu);
 	if (cpu < 0 || cpus_share_cache(src_cpu, dst_cpu))
 		return mig_unrestricted;
 
 	/* skip cache aware load balance for too many threads */
 	if (invalid_llc_nr(mm, p, dst_cpu) ||
 	    exceed_llc_capacity(mm, dst_cpu)) {
-		if (READ_ONCE(mm->sc_stat.cpu) != -1)
-			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		if (READ_ONCE(grp->cpu) != -1)
+			WRITE_ONCE(grp->cpu, -1);
 		return mig_unrestricted;
 	}
 
-- 
2.32.0


