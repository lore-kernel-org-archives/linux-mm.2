Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 237DAC982F0
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 00:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA446B00AA; Mon, 21 Sep 2026 20:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792A26B00AB; Mon, 21 Sep 2026 20:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681096B00AC; Mon, 21 Sep 2026 20:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 368716B00AB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:32:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B943F4032A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:19 +0000 (UTC)
X-FDA: 85239521598.30.3A8C562
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id 67160180005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NTijbP2Z;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790037137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWioyOy1raRX5s3iNMGf3wFa/JJxcVRYz5CYT2CK/4I=;
	b=eR9gToFnyzm3uo8VaQEC+4/BoxS3pi9rL/ORrD/2q9Q92UGGJlJtFeM3dbAEJgccE8/QGK
	WiAW7slXSilWurSdSUywn1QI5OZ72TR9sIoOb3QsDuEfCRkIAsI3re1zvSrYR9fmkK4rKn
	Kl7Pz/t7Z1m/tGfG5Lws8dzhNcdSgXs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790037137;
	b=rcyRgJQ638FY8G6OeabsHOjQriHwdbwtLzq9hsHcIvOQpIYSgbU+iE7lHceFV6Kbcp3Ko7
	H/sox/47kwRNklNUitNZf0moKQIGa3q3o/x/UeY7WyRetCZhpcKGqo3msldwBneX7uz+eq
	QSxs1x0oPNwrWZJU4WV9U2T85ZwA+WY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NTijbP2Z;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790037138; x=1821573138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+1tSKOiwkomk8D3mtv6M2i5ogdNO51o7OpMzTMwjWRQ=;
  b=NTijbP2Zm8yD7YFX3REb2JR71kyFlB2U6BGKOXAP8CHLY6CXonaLDeZQ
   5DGazQ07C/zOycaHidrC03778HcAff7RWQyX9vnDR+bsel1hjf+slpNa3
   JXPVW0fJ0NnAr6dEUjK3HF/71QHc+9vGhwTBlgzbuoaW8oqJyIrDYiIPd
   7UqgUHFhdrfSmA35D9/iwXrbw5ynId9POs7zNGcl0bgEQLpJGxso9usYk
   vQHpsKqjao1GzXkmIuOjoNPvBsF6oRqKYvhEXMJ0y/YS2iYDXjiGHH2RR
   rw0owsmK8p7Yvjq2qubB9z59QqNqNVf8N8VElAE/Jb19NUHqgun2f9s4s
   A==;
X-CSE-ConnectionGUID: RUTraa8EQXSPih6vyPkbzQ==
X-CSE-MsgGUID: Lxn1RHEIRMuGaJMJ3bAabg==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90716702"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="90716702"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 17:32:17 -0700
X-CSE-ConnectionGUID: suUgIRFJSGqtNw+SpAWtNg==
X-CSE-MsgGUID: VHXHKVwgRJqRI/9S0w5HsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="277671883"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa004.fm.intel.com with ESMTP; 21 Sep 2026 17:32:15 -0700
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
Subject: [PATCH v2 4/6] sched/cache: Introduce task_struct->sched_cache_grp
Date: Mon, 21 Sep 2026 17:37:25 -0700
Message-Id: <ae7081dc54736bf115215f9867abb2711a7403fb.1790035273.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1790035273.git.tim.c.chen@linux.intel.com>
References: <cover.1790035273.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 67160180005
X-Stat-Signature: u8e4scw1hgxbn8teejz7ehsqww1ycehb
X-HE-Tag: 1790037137-400519
X-HE-Meta: U2FsdGVkX1/jRd0FN5b/RSlRoCdqYaTxU+Y3YYrqmln3/fQsCfqiidgRu5AjA0WdKdlxgwiaIFv868/iGxcdQxsmHKDQ7UkRSDw/rGIK27q8YzqGU3rTO4SqPu0hUuf71Xa8qND9CsMey/aHne60MXcvxI/Eofxw7vRNHNrOmWaRCAh4NbpfFB+uqh6hpIvGb/2OjCqe+0hi6I1PkussF/owmFihJ/anZdwkkKbiPGgbCA+9BvrkfY+M5RLI1TfFjJSVWtq+8gaJHXa3GC4VzKASR7joACfSSVsBeOIBidmsbEitdbdUW507n2v/ly/RXXc4zqwy4RBYEqy5uTtslR/7cMnRQ78VmQh33ejPMOm6YW6wRhNG6zFQjvbvTudT9ovyQ/Io97ejAXsf+bMJ+q3GK3YF8MoKjTJpr977XJlG6Swo9nTvwbQGuN3/gPA80U9Fh4RdVF2GnjlGjA/J9KwGmSBb2mZI+PHFd2QKJyRPdwkFIRdMlp9FpnCoS60GoZAqrD6PNy56oI11RGlNVbXMxD6wTcx5BX59QC8O4Wk5b2UUkxtI93PX3Uz9tM2LwgqRSPgCOhelM4re4S4j6X9PcII94oafxVIIcQhO1K9wLL2x84WfIefBwW3WVmiWky5VeNdkdYWJvVcqDr5bRmnJH6++gKE6qoDAh2Kn51add3M4h5cGmeRjA4oC6YBkWBkWAub68/P/TId2usa04LAZIwSeE54ULe53/DvJUJp2freh7Q2i+y4BrzMdxsRdWeGYQyF4pUaD0qmSEs3HSgL/z4N8gYceKLbqxf9yZMMEAxB6B2MEOyl4vr8bh14Ix+Gc491QSHe42/9MJRChQ8Kyc4j2HL+SaabF43vKnW+qgroP1DJztzWM/ezrW5Uhmcy4OnwLnGNk7mGFrDnN4FaxIFrKnX/K5fEuyRIqkGUveu3DsiDrvaww7X/pD5Bj4EKTzSSEuuTxN3lvQl1
 6fYyzCoG
 +c5gdzcLNiQrx+2giktohetn/Oi0pTAXrq5DiRjwlm0/OFaq5y9Ii137WNONLWif3OfvZpbf7SvFalhEbEyE0fKn5uUNz9uONu3FlY1P/oHajDlpoxMdLy47a0GC5JNkdpKcldCqEcAzrQtHnHt2JQfLwiFLQci6/P74yuNKkAGZlv7+r7vFO1f2LBTFVwFaDZJJfSHRPOTuJJwmZAY+FSp8jKKSgmn62oqAC/FWOgfAAeTVyONtZYrj/k67oBRLCuhcIlqdW73u+vDzCquc5XBTi0/F1rvKTsfkjRgVKeFKPeov8+EGBWk29JDsxGsa+KyE9M8a4EEmXhnyr4DWErpdQty7yx/YMZ3hN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sched_cache_grp pointer to task_struct so that scheduler code
can access the cache group directly via the task, without going
through mm->sched_cache_grp.  This decouples the scheduler's hot-path
accesses from the mm_struct.

Each task holds its own refcount on the sched_cache_group, separate
from the reference held by its mm_struct.  The reference is acquired
in copy_mm() (fork) and exec_mmap() (exec), and released in exit_mm().
This fixes the use-after-free when account_mm_sched() reaches the group
through a task whose mm is being switched, as reported by Hyunwoo:
https://lore.kernel.org/lkml/apPb-Dr4nPYuHQOK@v4bel/

Convert all scheduler code in fair.c and exit.c to use
p->sched_cache_grp instead of p->mm->sched_cache_grp.

Keep the fork/exec/exit reference management out of the generic mm
paths: add sched_cache_fork(), sched_cache_fork_cleanup(),
sched_cache_exec_mmap() and sched_cache_exit_mm() in
kernel/sched/cache_sched.c (with empty stubs for !CONFIG_SCHED_CACHE),
so fs/exec.c, kernel/fork.c and kernel/exit.c each call one helper
instead of open-coding the refcounting under #ifdef.  Also add
sched_cache_group_get() and task_cache_group_get().

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
 fs/exec.c                  |   1 +
 include/linux/sched.h      |  13 +++++
 kernel/exit.c              |  33 +-----------
 kernel/fork.c              |   2 +
 kernel/sched/cache_sched.c |  87 ++++++++++++++++++++++++++++++
 kernel/sched/fair.c        | 106 ++++++++++++++++---------------------
 kernel/sched/sched.h       |   3 ++
 7 files changed, 153 insertions(+), 92 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 745f6eb5279e..6400bae97a32 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -882,6 +882,7 @@ static int exec_mmap(struct linux_binprm *bprm)
 	active_mm = tsk->active_mm;
 	tsk->active_mm = mm;
 	tsk->mm = mm;
+	sched_cache_exec_mmap(tsk, mm);
 	mm_init_cid(mm, tsk);
 	exec_state = task_exec_state_replace(tsk, exec_state);
 	/*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1f254364f216..1aa81cb6637b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1434,6 +1434,7 @@ struct task_struct {
 #ifdef CONFIG_SCHED_CACHE
 	struct callback_head		cache_work;
 	int				preferred_llc;
+	struct sched_cache_group __rcu	*sched_cache_grp;
 	/* 1: task was enqueued to its preferred LLC, 0 otherwise */
 	int				pref_llc_queued;
 #endif
@@ -2418,11 +2419,23 @@ struct sched_cache_group {
 } ____cacheline_aligned_in_smp;
 
 void sched_cache_group_put(struct sched_cache_group *grp);
+struct sched_cache_group *sched_cache_group_get(struct sched_cache_group *grp);
+struct sched_cache_group *task_cache_group_get(struct task_struct *p);
+
+void sched_cache_fork(struct task_struct *p);
+void sched_cache_fork_cleanup(struct task_struct *p);
+void sched_cache_exec_mmap(struct task_struct *p, struct mm_struct *mm);
+void sched_cache_exit_mm(struct task_struct *p);
 
 #else
 
 struct sched_cache_group { };
 
+static inline void sched_cache_fork(struct task_struct *p) { }
+static inline void sched_cache_fork_cleanup(struct task_struct *p) { }
+static inline void sched_cache_exec_mmap(struct task_struct *p, struct mm_struct *mm) { }
+static inline void sched_cache_exit_mm(struct task_struct *p) { }
+
 #endif
 
 #ifndef MODULE
diff --git a/kernel/exit.c b/kernel/exit.c
index 16abbe1cf682..35afa1d2d251 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -547,37 +547,6 @@ void mm_update_next_owner(struct mm_struct *mm)
 }
 #endif /* CONFIG_MEMCG */
 
-#if defined(CONFIG_SCHED_CACHE) && defined(CONFIG_NUMA_BALANCING)
-/*
- * Subtract the memory footprint of the current task from
- * mm.
- */
-static void exit_mm_sched_cache(struct mm_struct *mm)
-{
-	struct sched_cache_group *grp;
-	unsigned long fp, sub;
-
-	if (!current->total_numa_faults)
-		return;
-	/*
-	 * No lock protection due to performance considerations.
-	 * Make sure the group footprint does not become
-	 * negative.
-	 */
-	grp = READ_ONCE(mm->sched_cache_grp);
-	if (!grp)
-		return;
-
-	fp = READ_ONCE(grp->footprint);
-	sub = min(fp, current->total_numa_faults);
-	WRITE_ONCE(grp->footprint, fp - sub);
-}
-#else
-static inline void exit_mm_sched_cache(struct mm_struct *mm)
-{
-}
-#endif /* CONFIG_SCHED_CACHE CONFIG_NUMA_BALANCING */
-
 /*
  * Turn us into a lazy TLB process if we
  * aren't already..
@@ -590,7 +559,7 @@ static void exit_mm(void)
 	if (!mm)
 		return;
 
-	exit_mm_sched_cache(mm);
+	sched_cache_exit_mm(current);
 
 	mmap_read_lock(mm);
 	mmgrab_lazy_tlb(mm);
diff --git a/kernel/fork.c b/kernel/fork.c
index 416758c8a3d4..d9b263a32471 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1599,6 +1599,7 @@ static int copy_mm(u64 clone_flags, struct task_struct *tsk)
 
 	tsk->mm = mm;
 	tsk->active_mm = mm;
+	sched_cache_fork(tsk);
 	return 0;
 }
 
@@ -2599,6 +2600,7 @@ __latent_entropy struct task_struct *copy_process(
 bad_fork_cleanup_namespaces:
 	exit_nsproxy_namespaces(p);
 bad_fork_cleanup_mm:
+	sched_cache_fork_cleanup(p);
 	if (p->mm) {
 		mm_clear_owner(p->mm, p);
 		mmput(p->mm);
diff --git a/kernel/sched/cache_sched.c b/kernel/sched/cache_sched.c
index ff3d9538e7a4..7c5d23a1e09c 100644
--- a/kernel/sched/cache_sched.c
+++ b/kernel/sched/cache_sched.c
@@ -1,6 +1,93 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "sched.h"
 
+#define rcu_deref_sched_cache_grp(tsk) \
+	rcu_dereference_check((tsk)->sched_cache_grp, (tsk) == current)
+
+static struct sched_cache_group *sched_cache_replace_grp(struct task_struct *p,
+							 struct sched_cache_group *new)
+{
+	struct sched_cache_group *old;
+
+	old = rcu_deref_sched_cache_grp(p);
+	rcu_assign_pointer(p->sched_cache_grp, new);
+
+	return old;
+}
+
+struct sched_cache_group *sched_cache_group_get(struct sched_cache_group *grp)
+{
+	/*
+	 * refcount_inc_not_zero() is the acquire primitive for lockless
+	 * (RCU) lookups; plain refcount_inc() would scribble the count if
+	 * it already reached zero. Return NULL in that case.
+	 */
+	if (grp && !refcount_inc_not_zero(&grp->refcnt))
+		grp = NULL;
+
+	return grp;
+}
+
+struct sched_cache_group *task_cache_group_get(struct task_struct *p)
+{
+	guard(rcu)();
+	return sched_cache_group_get(rcu_dereference(p->sched_cache_grp));
+}
+
+void sched_cache_fork(struct task_struct *p)
+{
+	/*
+	 * The child takes its own reference on the mm's cache group, separate
+	 * from the reference held by the mm. @p is not yet visible to readers,
+	 * so a plain initializing store is enough.
+	 */
+	RCU_INIT_POINTER(p->sched_cache_grp,
+			 sched_cache_group_get(p->mm->sched_cache_grp));
+}
+
+void sched_cache_fork_cleanup(struct task_struct *p)
+{
+	/*
+	 * A fork that fails after sched_cache_fork() never reaches exit_mm(),
+	 * so drop the reference here. @p never became visible, so there are no
+	 * concurrent readers and the reference we hold keeps the group alive.
+	 */
+	sched_cache_group_put(rcu_access_pointer(p->sched_cache_grp));
+	RCU_INIT_POINTER(p->sched_cache_grp, NULL);
+}
+
+void sched_cache_exec_mmap(struct task_struct *p, struct mm_struct *mm)
+{
+	struct sched_cache_group *old;
+
+	/*
+	 * Acquire the new reference before publishing the pointer, then drop
+	 * the old one. @p is current and the only writer of its own pointer.
+	 */
+	old = sched_cache_replace_grp(p, sched_cache_group_get(mm->sched_cache_grp));
+	sched_cache_group_put(old);
+}
+
+void sched_cache_exit_mm(struct task_struct *p)
+{
+	struct sched_cache_group *grp = sched_cache_replace_grp(p, NULL);
+
+#ifdef CONFIG_NUMA_BALANCING
+	/*
+	 * Subtract this task's footprint from the group before dropping the
+	 * reference, so the group footprint converges as its threads exit.
+	 * Unlocked for performance; clamp to avoid underflow.
+	 */
+	if (grp && p->total_numa_faults) {
+		unsigned long fp = READ_ONCE(grp->footprint);
+		unsigned long sub = min(fp, p->total_numa_faults);
+
+		WRITE_ONCE(grp->footprint, fp - sub);
+	}
+#endif
+	sched_cache_group_put(grp);
+}
+
 static void sched_cache_group_free_rcu(struct rcu_head *rcu)
 {
 	struct sched_cache_group *grp =
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6e939807dff2..3e2d236be2a3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1483,7 +1483,7 @@ static inline int get_sched_cache_scale(int mul)
 	return (1 + (tol - 1) * mul);
 }
 
-static bool exceed_llc_capacity(struct mm_struct *mm, int cpu)
+static bool exceed_llc_capacity(struct sched_cache_group *grp, int cpu)
 {
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned long llc, footprint;
@@ -1497,11 +1497,6 @@ static bool exceed_llc_capacity(struct mm_struct *mm, int cpu)
 		return true;
 
 	if (static_branch_likely(&sched_numa_balancing)) {
-		struct sched_cache_group *grp = READ_ONCE(mm->sched_cache_grp);
-
-		if (!grp)
-			return true;
-
 		/*
 		 * TBD: RDT exclusive LLC ways reserved should be
 		 * excluded.
@@ -1536,10 +1531,9 @@ static bool exceed_llc_capacity(struct mm_struct *mm, int cpu)
 	return false;
 }
 
-static bool invalid_llc_nr(struct mm_struct *mm, struct task_struct *p,
+static bool invalid_llc_nr(struct sched_cache_group *grp, struct task_struct *p,
 			   int cpu)
 {
-	struct sched_cache_group *grp;
 	int scale;
 
 	if (get_nr_threads(p) <= 1)
@@ -1553,10 +1547,6 @@ static bool invalid_llc_nr(struct mm_struct *mm, struct task_struct *p,
 	if (scale == INT_MAX)
 		return false;
 
-	grp = READ_ONCE(mm->sched_cache_grp);
-	if (!grp)
-		return true;
-
 	return !fits_capacity((READ_ONCE(grp->nr_running_avg) * cpu_smt_num_threads),
 			(scale * per_cpu(sd_llc_size, cpu)));
 }
@@ -1765,15 +1755,10 @@ static unsigned long fraction_mm_sched(struct rq *rq,
 	return div64_u64(NICE_0_LOAD * pcpu_sched->runtime, rq->cpu_runtime + 1);
 }
 
-static int get_pref_llc(struct task_struct *p, struct mm_struct *mm)
+static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp)
 {
 	int mm_sched_llc = -1, mm_sched_cpu;
-	struct sched_cache_group *grp;
 
-	if (!mm)
-		return -1;
-
-	grp = READ_ONCE(mm->sched_cache_grp);
 	if (!grp)
 		return -1;
 
@@ -1807,9 +1792,8 @@ static unsigned int task_running_on_cpu(int cpu, struct task_struct *p);
 static inline
 void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 {
+	struct sched_cache_group *grp = rcu_dereference_all(p->sched_cache_grp);
 	struct sched_cache_time *pcpu_sched;
-	struct sched_cache_group *grp;
-	struct mm_struct *mm = p->mm;
 	int mm_sched_llc = -1;
 	unsigned long epoch;
 
@@ -1820,12 +1804,8 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 		return;
 	/*
 	 * init_task, kthreads and user thread created
-	 * by user_mode_thread() don't have mm.
+	 * by user_mode_thread() don't have a cache group.
 	 */
-	if (!mm)
-		return;
-
-	grp = READ_ONCE(mm->sched_cache_grp);
 	if (!grp || !grp->pcpu_sched)
 		return;
 
@@ -1843,13 +1823,13 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	 * its preferred state.
 	 */
 	if ((long)(epoch - READ_ONCE(grp->epoch)) > llc_epoch_affinity_timeout ||
-	    invalid_llc_nr(mm, p, cpu_of(rq)) ||
-	    exceed_llc_capacity(mm, cpu_of(rq))) {
+	    invalid_llc_nr(grp, p, cpu_of(rq)) ||
+	    exceed_llc_capacity(grp, cpu_of(rq))) {
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
 	}
 
-	mm_sched_llc = get_pref_llc(p, mm);
+	mm_sched_llc = get_pref_llc(p, grp);
 
 	/* task not on rq accounted later in account_entity_enqueue() */
 	if (task_running_on_cpu(rq->cpu, p) &&
@@ -1862,19 +1842,15 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 
 static void task_tick_cache(struct rq *rq, struct task_struct *p)
 {
+	struct sched_cache_group *grp = rcu_dereference_all(p->sched_cache_grp);
 	struct callback_head *work = &p->cache_work;
-	struct sched_cache_group *grp;
-	struct mm_struct *mm = p->mm;
 	unsigned long epoch;
 
 	if (!sched_cache_enabled())
 		return;
 
-	if (!mm || p->flags & PF_KTHREAD)
-		return;
-
-	grp = READ_ONCE(mm->sched_cache_grp);
-	if (!grp || !grp->pcpu_sched)
+	if (!grp || p->flags & PF_KTHREAD ||
+	    !grp->pcpu_sched)
 		return;
 
 	epoch = rq->cpu_epoch;
@@ -1956,14 +1932,13 @@ static inline void update_avg_scale(u64 *avg, u64 sample)
 
 static void task_cache_work(struct callback_head *work)
 {
+	struct sched_cache_group *grp __free(sched_cache_group_put) = NULL;
+	cpumask_var_t cpus __free(free_cpumask_var) = CPUMASK_VAR_NULL;
 	int cpu, m_a_cpu = -1, nr_running = 0, curr_cpu;
 	unsigned long next_scan, now = jiffies;
 	struct task_struct *p = current, *cur;
 	unsigned long curr_m_a_occ = 0;
-	struct sched_cache_group *grp;
-	struct mm_struct *mm = p->mm;
 	unsigned long m_a_occ = 0;
-	cpumask_var_t cpus;
 
 	WARN_ON_ONCE(work != &p->cache_work);
 
@@ -1972,7 +1947,12 @@ static void task_cache_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;
 
-	grp = READ_ONCE(mm->sched_cache_grp);
+	/*
+	 * A reference makes sure grp is not released by others. The rcu
+	 * lock can not be held till after zalloc_cpumask_var() below,
+	 * because the latter might sleep.
+	 */
+	grp = task_cache_group_get(p);
 	if (!grp)
 		return;
 
@@ -1987,8 +1967,8 @@ static void task_cache_work(struct callback_head *work)
 		return;
 
 	curr_cpu = task_cpu(p);
-	if (invalid_llc_nr(mm, p, curr_cpu) ||
-	    exceed_llc_capacity(mm, curr_cpu)) {
+	if (invalid_llc_nr(grp, p, curr_cpu) ||
+	    exceed_llc_capacity(grp, curr_cpu)) {
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
 
@@ -2021,9 +2001,13 @@ static void task_cache_work(struct callback_head *work)
 					m_cpu = i;
 				}
 
+				/*
+				 * rcu_access_pointer() is used because the
+				 * pointer is only compared, never dereferenced.
+				 */
 				cur = rcu_dereference_all(cpu_rq(i)->curr);
 				if (cur && !(cur->flags & (PF_EXITING | PF_KTHREAD)) &&
-				    cur->mm == mm)
+				    rcu_access_pointer(cur->sched_cache_grp) == grp)
 					nr_running++;
 			}
 
@@ -2069,7 +2053,6 @@ static void task_cache_work(struct callback_head *work)
 	}
 
 	update_avg_scale(&grp->nr_running_avg, nr_running);
-	free_cpumask_var(cpus);
 }
 
 void init_sched_mm(struct task_struct *p)
@@ -2078,6 +2061,13 @@ void init_sched_mm(struct task_struct *p)
 
 	init_task_work(work, task_cache_work);
 	work->next = work;
+	/*
+	 * dup_task_struct() copies the parent's task_struct, including its
+	 * sched_cache_grp, for which the child holds no reference.  Clear it
+	 * here - before copy_mm() runs - so the child never carries a
+	 * borrowed pointer that the fork error path would put.
+	 */
+	RCU_INIT_POINTER(p->sched_cache_grp, NULL);
 	/*
 	 * Reset new task's preference to avoid
 	 * polluting account_llc_enqueue().
@@ -3878,10 +3868,9 @@ static void task_numa_placement(struct task_struct *p)
 			 * heuristic and occasional lost updates are tolerable.
 			 *
 			 * If a task exits, its corresponding footprint must
-			 * be subtracted from the mm->sched_cache_grp->footprint,
-			 * otherwise the mm->sched_cache_grp->footprint will not
-			 * converge: the exiting thread's footprint remains
-			 * unchanged/undecayed in mm->sched_cache_grp->footprint.
+			 * be subtracted from p->sched_cache_grp->footprint,
+			 * otherwise the footprint will not converge: the
+			 * exiting thread's footprint remains unchanged/undecayed.
 			 * See exit_mm().
 			 *
 			 * Lost updates and unsynchronized subtraction
@@ -3889,12 +3878,14 @@ static void task_numa_placement(struct task_struct *p)
 			 * go negative. Clamp to zero to prevent the
 			 * unsigned footprint from wrapping.
 			 */
-			grp = READ_ONCE(p->mm->sched_cache_grp);
-			if (!grp)
-				continue;
+			scoped_guard(rcu) {
+				grp = rcu_dereference(p->sched_cache_grp);
 
-			new_fp = (long)READ_ONCE(grp->footprint) + diff;
-			WRITE_ONCE(grp->footprint, max(new_fp, 0L));
+				if (grp) {
+					new_fp = (long)READ_ONCE(grp->footprint) + diff;
+					WRITE_ONCE(grp->footprint, max(new_fp, 0L));
+				}
+			}
 #endif
 		}
 
@@ -10843,7 +10834,6 @@ static enum llc_mig can_migrate_llc_task(struct lb_env *env,
 					 struct task_struct *p)
 {
 	struct sched_cache_group *grp;
-	struct mm_struct *mm;
 	bool to_pref;
 	int cpu, src_cpu, dst_cpu;
 
@@ -10852,11 +10842,7 @@ static enum llc_mig can_migrate_llc_task(struct lb_env *env,
 
 	src_cpu = env->src_cpu;
 	dst_cpu = env->dst_cpu;
-	mm = p->mm;
-	if (!mm)
-		return mig_unrestricted;
-
-	grp = READ_ONCE(mm->sched_cache_grp);
+	grp = rcu_dereference_all(p->sched_cache_grp);
 	if (!grp)
 		return mig_unrestricted;
 
@@ -10865,8 +10851,8 @@ static enum llc_mig can_migrate_llc_task(struct lb_env *env,
 		return mig_unrestricted;
 
 	/* skip cache aware load balance for too many threads */
-	if (invalid_llc_nr(mm, p, dst_cpu) ||
-	    exceed_llc_capacity(mm, dst_cpu)) {
+	if (invalid_llc_nr(grp, p, dst_cpu) ||
+	    exceed_llc_capacity(grp, dst_cpu)) {
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
 		return mig_unrestricted;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e656c7059bf8..8b67af28a471 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4145,6 +4145,9 @@ static inline bool sched_cache_enabled(void)
 	return static_branch_unlikely(&sched_cache_active);
 }
 
+DEFINE_FREE(sched_cache_group_put, struct sched_cache_group *,
+	    sched_cache_group_put(_T));
+
 extern void sched_cache_active_set(void);
 
 #endif
-- 
2.32.0


