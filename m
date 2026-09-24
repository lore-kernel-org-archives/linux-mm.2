Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA1DC98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9935C6B0093; Thu, 24 Sep 2026 14:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9445E6B0095; Thu, 24 Sep 2026 14:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BD166B0096; Thu, 24 Sep 2026 14:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 496716B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:47:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC245C0470
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:47:44 +0000 (UTC)
X-FDA: 85249539648.15.953DE22
Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	by imf02.hostedemail.com (Postfix) with ESMTP id BDDF18000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:47:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mbQdCytu;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhE26qdu0oIuouPPT5B85LZV9K6FgWolV5noT6kkqR0=;
	b=kPVXZI1PuM3Ck23YJIS+iGNTQPlCi7FR7ELOL8EBBGBK2NlB3V1CJckJt+rlu8Wi+vDbgM
	WR55Y1SK2HV+mdWhCCe4Bl6oUdmfxP3VGxQ9BGE/k4ygY1FBT/jZebv9WAGnLDxAHHkGjX
	pqYhk9l40sqCLJx39NMuHoFHxNipYpQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275663;
	b=EoOb4DqTHd0ZGlDmPjZcXM92y0L3kQts/kQzbCmtn5cnfD0ujSuPMSvlR7c57v73gZcGY0
	ZheIfyW7eklFOhE8W74DUzsSQ78mxOp/RXV4siS46+QBEK1tLgRqpaNoVpNaGpxUCh1jni
	lhM4mBFrwQ8M7wLZ+hB1896XPLZM1Lg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mbQdCytu;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PCLpGfGy//n9UKU35pNohFAj9dJU7KEFqV53+5uIk0w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275661; v=1; x=1790880461;
 b=mbQdCytucYohHkXCoCDfpZaaMDUh3P1wGCpd9SyJEfSVghsL1cc8lWLca6m/zs91j6nDnJD2
 DW/w+/rnaF+CDss0AOXDKlQUwOVTN6nKaHjK2tC22yQ/F5rD1kfC3YOh/uUHYhblDdWslS2e5rj
 vVmSRkMSxkQfLWv7D7vya008=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b5bb50beb49d0e34;
	Thu, 24 Sep 2026 18:47:41 +0000
X-Mizu-Trace-ID: b5bb50beb49d0e34
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>,
	kernel-team@meta.com,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/7] cgroup: add set_active_cgroup() to charge CPU time to a cgroup
Date: Thu, 24 Sep 2026 11:47:06 -0700
Message-ID: <20260924184714.912181-3-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: g37fobr8yuatbpjyu1e9xzusrqrz1qxd
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BDDF18000A
X-HE-Tag: 1790275662-188695
X-HE-Meta: U2FsdGVkX1/4EOw4ESnnWN9W8aLx0sQ0n+3KK8ub0HLHdfy8I7ZUupIbRm7QykeSE2YAP8JtY1Lr9qQoUF2oXmujLA+RQZBDK6Y1DFI+Klfj54BC63+WXwuJBLNt1LTCc4gFPXL/c0MHd+MizccVYcnDnWahM1hZzCgFm8nHGLJEE1efXulZWDxLtfX/Zj0rOlQVpM2Zyp4FWhLaaWnA/pzqcOc1c/Vh9FCykpbd254j2RQClt3xFaaUljkFABhC+tLrpZVtZsU6TQmbSjr/qjTyXJLwqr9BQs9xDDrbpWMlo3VNsp5/98t2k9Fed7YyfExa6xdB9gPlFIuHhmi9+7TlWytmttkhA+YGknX17RYFTAWHJbE9XUd+tKb2r6R+ZkyUnlTuBNlK4OPXzYnRfneJ8qi92OIFEMOERegpaltHmFHm10SSyMUpMkmLL834kEXCJrWMg4ilfwckAis8oAFSsC7IEA+rX+LGDhT9iCJSaj0XcQyTFoDx4mR9TO4Gd4t7CvikAC9KyyDl6ngcIlSaozveFkgHzv4iTEXXAOFVyWIIg3iThDf+1vzcbnGEEtNU6ab7UdaQUBu4KpF1P4HNOwU7u6+PjMNo6kyLVz2VLHZEkwxHGU39RbIPgHubz3FH1Fdcs2q1cAecg/7ilH4pQA28z7jWGixGl1jz21avEhQSQyC9ISXbQqUtAOb845BAxbx2ipEDV/02y0JU35RVcSWNui82nww7aROF+jzg0kyXHV2U7IElFxSYjeCGQtainvp6UNPYSbTgf1nqmSVp+SMh45UZwUm5kinDLOZjj09MIKmQQ42/5YFXcDA5CC5zypUdj2uaUCsSOL2zOAGrPm8QetusKpShJvhLoENKygXsYLCo1XJZVG1hA1bvr8IBOD6cdnFLcv3H01sWKWf8/itm62IWFezF6Eai1QeFN8qY3545Nkh8NHJxkiKz7MMGegI/ShJZ/+er61v
 GVqAPdYZ
 2MGva3vQIoMubDCT8kGYq5ZV16kXrbGdiRQU3fgZ85kZTjJFAlZvhix03Y5exlZQPBt7vWcAQt+FpkBY6fyyKFtw0bvZJ9tWcaPvm2k3uj9yHKjAAMsfxKEliGvqBeNaBrMgWrp2vougCnKkU33ClstxLdOADyVaEPUYL/9nywxMwtHedtZXOPN3LVgfMKFKFqta7rzeALezEeghL5+Ihy6jgsN8G4TlyKa3KW0QbmLc0oUvVIvrwas6QGcsmp2MCL3FC8uT/GmGPy3qev24JpzeQn8CfOmEy9cvyi9GSqmZoNyzYFQsqCQBUxQMxDVlntKvYRsAk/vjBJJ4pnA3MsyRDL+zjDwgHVrMr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A kernel thread that does work for a cgroup, like memcg reclaim from a
workqueue, has that CPU time charged to its own cgroup, usually root.

Add task_struct::active_cgroup. When set, the task's CPU time goes to
that cgroup instead. set_active_cgroup() sets it and returns the old
value, like set_active_memcg(). It first charges the time used so far to
the old cgroup, so even short work is charged to the right place.

Code under set_active_cgroup() is kernel code, so charge its time as
system time right away. Skip the tick and vtime path for it, which could
charge it late, after the old value is back. Forced idle time from core
scheduling comes through that path too. It is not run time, so charge it
to the active cgroup there.

Only allow callers in the root cgroup, like kworkers. The scheduler still
runs the caller in its own cgroup and takes the time from that cgroup's
cpu.max, and on nohz_full CPUs vtime can post system time from inside the
scope to that cgroup after the old value is back. Warn and do nothing for
other callers.

Warn and clear it if a task exits with it still set.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/cgroup.h | 26 +++++++++++++++++++++++++
 include/linux/sched.h  |  2 ++
 kernel/cgroup/cgroup.c |  4 ++++
 kernel/fork.c          |  4 ++++
 kernel/sched/core.c    | 43 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 79 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7b19ded2578d..761bd0a81c67 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -879,6 +879,8 @@ static inline void cgroup_account_system_time(struct cgroup *cgrp,
 	}
 }
 
+struct cgroup *set_active_cgroup(struct cgroup *cgrp);
+
 static inline void cgroup_account_cputime(struct task_struct *task,
 					  u64 delta_exec)
 {
@@ -886,6 +888,12 @@ static inline void cgroup_account_cputime(struct task_struct *task,
 
 	cpuacct_charge(task, delta_exec);
 
+	/* Time spent under set_active_cgroup() is all kernel time. */
+	if (task->active_cgroup) {
+		cgroup_account_system_time(task->active_cgroup, delta_exec);
+		return;
+	}
+
 	cgrp = task_dfl_cgroup(task);
 	if (cgroup_parent(cgrp))
 		__cgroup_account_cputime(cgrp, delta_exec);
@@ -899,6 +907,20 @@ static inline void cgroup_account_cputime_field(struct task_struct *task,
 
 	cpuacct_account_field(task, index, delta_exec);
 
+	/*
+	 * cgroup_account_cputime() has charged the run time already. Forced
+	 * idle time from core scheduling is not run time: charge it here.
+	 */
+	if (task->active_cgroup) {
+#ifdef CONFIG_SCHED_CORE
+		if (index == CPUTIME_FORCEIDLE &&
+		    cgroup_parent(task->active_cgroup))
+			__cgroup_account_cputime_field(task->active_cgroup,
+						       index, delta_exec);
+#endif
+		return;
+	}
+
 	cgrp = task_dfl_cgroup(task);
 	if (cgroup_parent(cgrp))
 		__cgroup_account_cputime_field(cgrp, index, delta_exec);
@@ -913,6 +935,10 @@ static inline void cgroup_account_cputime_field(struct task_struct *task,
 						u64 delta_exec) {}
 static inline void cgroup_account_system_time(struct cgroup *cgrp,
 					      u64 delta_exec) {}
+static inline struct cgroup *set_active_cgroup(struct cgroup *cgrp)
+{
+	return NULL;
+}
 
 #endif	/* CONFIG_CGROUPS */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5ce350a616e4..002941f60e88 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1356,6 +1356,8 @@ struct task_struct {
 	struct css_set __rcu		*cgroups;
 	/* cg_list protected by css_set_lock and tsk->alloc_lock: */
 	struct list_head		cg_list;
+	/* If set, CPU time is charged here; see set_active_cgroup(): */
+	struct cgroup			*active_cgroup;
 #ifdef CONFIG_PREEMPT_RT
 	struct llist_node		cg_dead_lnode;
 #endif	/* CONFIG_PREEMPT_RT */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 804318ae160e..f51ed71c122f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -7173,6 +7173,10 @@ void cgroup_task_exit(struct task_struct *tsk)
 	struct cgroup_subsys *ss;
 	int i;
 
+	/* The task forgot to undo set_active_cgroup(). */
+	if (WARN_ON_ONCE(tsk->active_cgroup))
+		set_active_cgroup(NULL);
+
 	/* see cgroup_post_fork() for details */
 	do_each_subsys_mask(ss, i, have_exit_callback) {
 		ss->exit(tsk);
diff --git a/kernel/fork.c b/kernel/fork.c
index 39be51048d77..044a4a5de8ef 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1006,6 +1006,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->active_memcg = NULL;
 #endif
 
+#ifdef CONFIG_CGROUPS
+	tsk->active_cgroup = NULL;
+#endif
+
 #ifdef CONFIG_X86_BUS_LOCK_DETECT
 	tsk->reported_split_lock = 0;
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 57dad4fc163e..ccb7ee9f2f26 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5732,6 +5732,49 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	return ns;
 }
 
+#ifdef CONFIG_CGROUPS
+/**
+ * set_active_cgroup - charge current's CPU time to another cgroup
+ * @cgrp: the cgroup to charge, or NULL for current's own cgroup
+ *
+ * For kernel code that does work for a cgroup. The time it uses is charged
+ * to @cgrp as kernel time. Returns the old value, which the caller restores
+ * when done. @cgrp must stay alive until then.
+ *
+ * Only for callers in the root cgroup, like kworkers. The scheduler still
+ * runs the caller in its own cgroup, so from any other cgroup the time would
+ * also count against that cgroup's cpu.max, and on nohz_full CPUs some of
+ * it could show up in that cgroup's cpu.stat. It warns and does nothing for
+ * such a caller.
+ */
+struct cgroup *set_active_cgroup(struct cgroup *cgrp)
+{
+	struct task_struct *p = current;
+	struct cgroup *old;
+	struct rq_flags rf;
+	struct rq *rq;
+
+	WARN_ON_ONCE(!in_task());
+	WARN_ON_ONCE(cgrp && cgrp->root != &cgrp_dfl_root);
+
+	scoped_guard(rcu) {
+		if (cgrp && WARN_ON_ONCE(cgroup_parent(task_dfl_cgroup(p))))
+			return p->active_cgroup;
+	}
+
+	rq = task_rq_lock(p, &rf);
+	/* Charge the time used so far to the old cgroup. */
+	update_rq_clock(rq);
+	rq->donor->sched_class->update_curr(rq);
+
+	old = p->active_cgroup;
+	p->active_cgroup = cgrp;
+	task_rq_unlock(rq, p, &rf);
+
+	return old;
+}
+#endif
+
 static u64 cpu_resched_latency(struct rq *rq)
 {
 	int latency_warn_ms = READ_ONCE(sysctl_resched_latency_warn_ms);
-- 
2.53.0-Meta


