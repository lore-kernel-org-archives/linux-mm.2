Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F318C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E1D6B0096; Thu, 24 Sep 2026 14:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5CB6B0098; Thu, 24 Sep 2026 14:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2E86B0099; Thu, 24 Sep 2026 14:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 418556B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:47:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D6BA120480
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:47:50 +0000 (UTC)
X-FDA: 85249539900.28.15D0A9F
Received: from mta0.migadu.com (out-152.mta0.migadu.com [91.218.175.152])
	by imf23.hostedemail.com (Postfix) with ESMTP id A7F0F140006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:47:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AY6vKe1X;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6HrlqRIqJ+8y3qBpZnnQWrgf4rlnKyUatiPXeQHxMk=;
	b=74Nshz5105l49P63Yr9Elr28JZIqDj0CP680XW0FqRPsi7PKMfIUmLu69AGILQ15AY3Q65
	tRA1mPdYzXfRXXo/u1HBQnkbcq1YnSg8RdMjTTq5XoXzc4UFd+CcogmkyjV7G3GIJM+GN8
	v2n74K/FYhen5A/issMIidxaMLkn1YA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275668;
	b=NcYtKwbFTRDNbosUyNYsvClPpGhZ/vssmRrEWA6jfneCxD5HjgtldF05kevdW7Beah8LK5
	v9R3k2OnK7UT0RAfHXbli/dOsWo+O8pv5SFtdK0+ubjSVtdI+DmSk1xPKp5cGOjvWe7uTj
	Wr+ZdM/E3YiZYVVuxELNkBiPZg5VBnw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AY6vKe1X;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fiIPJORvS4gxPp3xcAjHqBOYrPmfNQt6sseBDUijnxI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275667; v=1; x=1790880467;
 b=AY6vKe1Xmz4DW0XO0ofRpvtZ91wB4dFj7FYmcajb6TMWFYdJgJTq+V1Xc8iG+sbbztvScxMq
 whPgx0fEIjMBN+n8v4jEVidNiTApBWcfyeEjs6Zkb/H1CVFjL36/09bicfrlC+3IJsgA4wznxld
 rY0TU/3RIKfdZ/oNn4/6laBM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fb43f222c7f5ccb1;
	Thu, 24 Sep 2026 18:47:47 +0000
X-Mizu-Trace-ID: fb43f222c7f5ccb1
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
Subject: [RFC PATCH 3/7] psi: charge pressure to the task's active cgroup
Date: Thu, 24 Sep 2026 11:47:07 -0700
Message-ID: <20260924184714.912181-4-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: t7nxuo3urkfdpm4ddeaejr9qehijqrk1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A7F0F140006
X-HE-Tag: 1790275668-425000
X-HE-Meta: U2FsdGVkX1+JM6ra/cZQXyQo3RDbU4SVch1zgVcc/9IlrP+TopofJ5d8D3zeXpnW5RdWXTvhNr3I0VO8chWQGiahQlnrSF6fULR9s5yNhbd3KdLcCf6tMe27JttdCp/NxK48Bg+z7XCNLIu/F/wXvZxmhDaD+Flz08yLSqT10UXRfUUXHZTY+YY7YqGQFIWy2nOUIlsiHsR/g+Wl56gvPhToWw9f9mPIM065jIbIWNAYZgv5Z6N5H+T74hzGNEdvH5xBAPKFqs/lsWXPtNjKO5UceCejYMcBkxBCniFmS+/lpCuxdUsmLV/U6bty0od2Ub4Fom942EMlEiFGjVq3PIuGUzbzpKuiezu7+RsUcWZ8zYGsdyjTaYmuluYq7iYkXAwj6CbaprtYj5onVZjsp+XPdOYG7CMj/htG03neOakRpLEElZUZdM7cxaFA/EtCPojXvLOX7n6LMIuLh+D1IYhWtVxCGmnASLa9TlWDOT2iB63FKhfcwITwiF0+yvUHzSuG1gB0NvU63l+mbWiu+jL9PtOf9Zn2iIz6VIC19tQ7qLkYtW1mdp9wzu6qRwpr/lMUy1oxZfSmpsNlOTfRPUr6xrGNuW160snlm25D4cR4Z/ZZxcF2VIlAHwj1tbACiD2f7zYFJZPq+hpIiyF9wxa7FlDNHMPBNUZMWMI5xoeqXAzCEkMIMJWbU4DqLvDeMs8mMm4rl/cuT/OaN9//aazL2yIO9ic17g0+0Nw34y2BanDAmAAvUB+BfOg5fkVWiJ2C3dYWAoEGQP3wTEx0DpSEd+E1bpHTpQI4deUks5Crlh/v4PrZFr0Ifk0NVi8GqRZxTnIgXIZFtAWl6qrrHVS6b+Mrhc8IfRZyvBzv/KivrtWhDmtj2RRwbldO+e5JQJRZct2uUTn4sGWPd5J7YFsJPHdgRY1TUL9RqT9Ozkm9obnCgL0/wYx3YPliQutHZrYexgqKNUkV5hLNNhL
 SST47r5v
 86Tyhq8wKpencqTbL+PvqK8+/+xUZRVD2qLvabtJQKiyNyHvgmVRGgSTZQFEhbU6/to+2E+HWLet03hPt/i9INmDdqXcq3ovpYOSfLCR7o8bntPt+5KdPDpkp0j4N5D8khozw2JTyzbVGLJNtpgKubwTHVM9+WZd8EgImlB2QfcMn0S7CRiLC2nHL9Xzw0XtF/gT+uwT263pzbNA02en79pQ/2cSMuLsxCsoVY5ot/GAZw4GuhIGLLJi+96WzhAjjG8L8xURYTuwXitsc/cbg7OyXr6SihEAcupBS5eGmWIAZz2la0zXtKRABdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a kernel thread works for a cgroup under set_active_cgroup(), its
stalls, like memory reclaim, should count as that cgroup's pressure.

Make task_psi_group() use the active cgroup. When it changes, move the
task's pressure state from the old groups to the new ones, the same way
cgroup_move_task() does for a real cgroup move.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 kernel/sched/core.c  |  2 +-
 kernel/sched/psi.c   | 22 +++++++++++++++++++++-
 kernel/sched/stats.h | 10 ++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ccb7ee9f2f26..b9e288b76da9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5768,7 +5768,7 @@ struct cgroup *set_active_cgroup(struct cgroup *cgrp)
 	rq->donor->sched_class->update_curr(rq);
 
 	old = p->active_cgroup;
-	p->active_cgroup = cgrp;
+	psi_set_active_cgroup(p, cgrp);
 	task_rq_unlock(rq, p, &rf);
 
 	return old;
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 4e152410653d..7e03be26b8d3 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -886,7 +886,7 @@ static inline struct psi_group *task_psi_group(struct task_struct *task)
 {
 #ifdef CONFIG_CGROUPS
 	if (static_branch_likely(&psi_cgroups_enabled))
-		return cgroup_psi(task_dfl_cgroup(task));
+		return cgroup_psi(task->active_cgroup ?: task_dfl_cgroup(task));
 #endif
 	return &psi_system;
 }
@@ -1213,6 +1213,26 @@ void cgroup_move_task(struct task_struct *task, struct css_set *to)
 	task_rq_unlock(rq, task, &rf);
 }
 
+/*
+ * Set @task's active cgroup and move its pressure state along with it.
+ * The caller holds the task's rq lock.
+ */
+void psi_set_active_cgroup(struct task_struct *task, struct cgroup *cgrp)
+{
+	unsigned int task_flags = task->psi_flags;
+
+	lockdep_assert_rq_held(task_rq(task));
+
+	if (!static_branch_likely(&psi_cgroups_enabled) || !task_flags) {
+		task->active_cgroup = cgrp;
+		return;
+	}
+
+	psi_task_change(task, task_flags, 0);
+	task->active_cgroup = cgrp;
+	psi_task_change(task, 0, task_flags);
+}
+
 void psi_cgroup_restart(struct psi_group *group)
 {
 	int cpu;
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index ebe0a7765f98..60f46b7b598c 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -103,6 +103,9 @@ __schedstats_from_se(struct sched_entity *se)
 void psi_task_change(struct task_struct *task, int clear, int set);
 void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		     bool sleep);
+#ifdef CONFIG_CGROUPS
+void psi_set_active_cgroup(struct task_struct *task, struct cgroup *cgrp);
+#endif
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 void psi_account_irqtime(struct rq *rq, struct task_struct *curr, struct task_struct *prev);
 #else /* !CONFIG_IRQ_TIME_ACCOUNTING: */
@@ -227,6 +230,13 @@ static inline void psi_sched_switch(struct task_struct *prev,
 				    bool sleep) {}
 static inline void psi_account_irqtime(struct rq *rq, struct task_struct *curr,
 				       struct task_struct *prev) {}
+#ifdef CONFIG_CGROUPS
+static inline void psi_set_active_cgroup(struct task_struct *task,
+					 struct cgroup *cgrp)
+{
+	task->active_cgroup = cgrp;
+}
+#endif
 #endif /* !CONFIG_PSI */
 
 #ifdef CONFIG_SCHED_INFO
-- 
2.53.0-Meta


