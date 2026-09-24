Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65728C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB9C6B0099; Thu, 24 Sep 2026 14:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3666B009D; Thu, 24 Sep 2026 14:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526A36B009E; Thu, 24 Sep 2026 14:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2778B6B0099
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:48:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 107361C27EF
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:47:59 +0000 (UTC)
X-FDA: 85249540278.20.3945EFF
Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0C868A0008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:47:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hRt6T8GX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275677;
	b=ctQ/R4LZLQniPlhq36EKn5U4DbNq73cLrzA+2gxllmqrENsR88dnArvqnpNohU/UTxNKok
	LzquDq0etLHklboqm1tQeo5GMe4nEhlsWlXbG2rz5wQW26GBdgVztjIvHYdYAvsmXOleYx
	IyeOKxDpnrpPd6/U4egG0E0dgwKndU4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hRt6T8GX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JogHQaCxW8NClL5DvCzu+C8uVXKBS+4ZOUPX7Drto4=;
	b=R3HGfhbexZfEk2zmhbkItFx+8GgVVA7aIN3rOXiRrE8uQVoslRoKoB8hNKp6BfLJ1N4Nk7
	eQuO3Yjjc8CG2HbIo+J2frlPzCaCsiYx7a81TAcYT+HJglxT2o3OMAuhQAlHVkF2z4oyvJ
	NH5gEsY4qRXlrFtKt0RUtWA4kw4WxGM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YPDMx5Cpm0Ky2M5qOc3ie9+dgsk3KEGxwc7kMebFStk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275675; v=1; x=1790880475;
 b=hRt6T8GX88GoHf5QBQK+pSkz/vS596pjl0ZY5HL4IoVLD1gXsNPWE8+Xin3CSM9peiBdJvj1
 B65aPsUnHWs30w5E5gAIRODr+kWUrvbJ9gaAbrxPzFjn7Gx8LnXrMnqoPAcE14G74xU6IWJ3BHT
 D4bL3PTKBTIjkOk0NGppL7H0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 458fdd5e55f5d437;
	Thu, 24 Sep 2026 18:47:55 +0000
X-Mizu-Trace-ID: 458fdd5e55f5d437
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
Subject: [RFC PATCH 5/7] cgroup: take set_active_cgroup() time out of the cgroup's cpu.max
Date: Thu, 24 Sep 2026 11:47:09 -0700
Message-ID: <20260924184714.912181-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: a4fqwki5rkurwrqq3f9dri77ang18nja
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C868A0008
X-HE-Tag: 1790275676-891782
X-HE-Meta: U2FsdGVkX1/L1vUjtJUWoAWeY/ZRMcTutghgiIC+Xn1R9SCwy9mzqfQXHHNBAzaZINhpxo17ThmWGUaqhwxchZpoyOXVpYSEg9qosn9dind3a+643/OdWPwt7+gTckh0KB2jWZUTyd4mxNNtGb3W9+E9L6lZJ3H2VYVd07gza8EZKqkROM0V7ORHdmLyKG3SPA9GiUNgKRuITRG1/RU8zdMHS4tiTTLTlCTR+x+qPsrgvpdHXPKNUECwo2I+zo3Iu3NuAEvhIwlSqFxvNaYCUDDOUE6bdWjypY0ODLwE9f43HpkPyeIFgFUwyW7Qneh7BMEKssRYPWg417Oxe+q3aUJVC0sEyVWQtFb41YtM7Okn9Oso3iif06oxsyE5JD8HKm0LoopJ+QFD5e/5hRjMab2lf3EpGBtCWQOFPQ+95e8Ws7oJTJOUA+b/q+5wVoqT12pFPSX6v5rIg2BEOrOaSrAsHNGLeBv9Dffd6xVlh/9+nCEI73+m/EuYl5nrOv4QzjlYPF/q3/EhoZruvt4AwYsKGfjiTtMn8FkLNccCZ4WmZCZDa/OxFZ6ezoaII/50wSPXvSw6BqAzYx/JOeRtdEJjF4DregdMU/XkdkUGo2pjSchrPG3Lp/Fu4Vad1QKeAGjSiewBt9UAs14oCrSWaUxWp65W7NYIEbMAlvTSb/gkktUbPmpjAsTwgQ0fnLus9yB4FrH0gA5g22DGFKLatRFTfRZUEtPzqa94Lv+nMoIYL0oPoUpeRc24/Nzg9b7xr/RXPz5yBanxkhjCgfFUZB6l9z/c3hh8cVw8VPuYwzxdm80e1QQEAzyTqid0Rqu2j7bpK0+iifOtK0Kj4GXslKnjfQnJR0a7xkxaXVTNrh4fWbZSamG3MaEwD7j61PNgm3BFMGn3GdGqViUAZGVAfMFrFS7TJ1CUebvOS2n+LFZ3PYr7DcqxNotyCvi7fo2nhqwQh5Z7DWdWDR/INQu
 wBiU3F9m
 eKVecM6wji5g4G4CPkeHTskNcPp5Hl2LFD/Q217dPBvBen4g+S2xc8S0Xt24fqLE8fezZtYgt3T+h37m0G61JNwDn7MXrI2yeHOwQvHaO1t+7bTOJjqx7DSxglJ7eHjURAWP1ITrk1crpIYROC6jzLmN/q6jpwnBL0YgSrQKTpE95xMURFeCZF6DLwEIrNZ3VsEsgAtjYtalwl15IBzscBsOMriYt/ED2dp3L21AG2zhm3vpY5C+7kLU/OBUt8KRG+kha/5IVtDHR8k/YH8PlUkVYIFbXWu1P/avcSKHjqgFVWyJmp0SAj0+FK5Phlt+EI3lORY/CdBKDFaVQouLs78O7HDE10wTCxmha
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel work done under set_active_cgroup() shows up in the cgroup's
cpu.stat, but the cgroup's tasks still get their full cpu.max quota.

Remember the task's run time at each set_active_cgroup(). When the
active cgroup changes, charge the time used under the old one to its
cpu.max quota with cfs_bandwidth_charge(). The caller is in the root
cgroup, which has no cpu.max, so no quota is charged twice.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/sched.h |  2 ++
 kernel/sched/core.c   | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 002941f60e88..7ecea9cfa702 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1358,6 +1358,8 @@ struct task_struct {
 	struct list_head		cg_list;
 	/* If set, CPU time is charged here; see set_active_cgroup(): */
 	struct cgroup			*active_cgroup;
+	/* se.sum_exec_runtime at the last set_active_cgroup(): */
+	u64				active_cgroup_start;
 #ifdef CONFIG_PREEMPT_RT
 	struct llist_node		cg_dead_lnode;
 #endif	/* CONFIG_PREEMPT_RT */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a487da494795..91fec6461e4f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5738,8 +5738,9 @@ unsigned long long task_sched_runtime(struct task_struct *p)
  * @cgrp: the cgroup to charge, or NULL for current's own cgroup
  *
  * For kernel code that does work for a cgroup. The time it uses is charged
- * to @cgrp as kernel time. Returns the old value, which the caller restores
- * when done. @cgrp must stay alive until then.
+ * to @cgrp as kernel time, and taken out of @cgrp's cpu.max quota. Returns
+ * the old value, which the caller restores when done. @cgrp must stay alive
+ * until then.
  *
  * Only for callers in the root cgroup, like kworkers. The scheduler still
  * runs the caller in its own cgroup, so from any other cgroup the time would
@@ -5753,6 +5754,7 @@ struct cgroup *set_active_cgroup(struct cgroup *cgrp)
 	struct cgroup *old;
 	struct rq_flags rf;
 	struct rq *rq;
+	u64 used;
 
 	WARN_ON_ONCE(!in_task());
 	WARN_ON_ONCE(cgrp && cgrp->root != &cgrp_dfl_root);
@@ -5768,9 +5770,15 @@ struct cgroup *set_active_cgroup(struct cgroup *cgrp)
 	rq->donor->sched_class->update_curr(rq);
 
 	old = p->active_cgroup;
+	used = p->se.sum_exec_runtime - p->active_cgroup_start;
+	p->active_cgroup_start = p->se.sum_exec_runtime;
 	psi_set_active_cgroup(p, cgrp);
 	task_rq_unlock(rq, p, &rf);
 
+	/* Take that time out of the old cgroup's cpu.max quota as well. */
+	if (old)
+		cfs_bandwidth_charge(old, used);
+
 	return old;
 }
 #endif
-- 
2.53.0-Meta


