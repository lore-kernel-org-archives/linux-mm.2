Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4956C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90096B0098; Thu, 24 Sep 2026 14:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19206B0099; Thu, 24 Sep 2026 14:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0396B009B; Thu, 24 Sep 2026 14:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68A9D6B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:47:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 655401A0478
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:47:53 +0000 (UTC)
X-FDA: 85249540026.25.4F3B32E
Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	by imf17.hostedemail.com (Postfix) with ESMTP id 767DC4000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:47:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AIwnS3bu;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.162 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/GTpbeNre9f+7NRFhSsYmx2laiBunXLJbfODm/8I8WI=;
	b=BdPSQe5RMjKyhZvRAD5kWuxwf/0+sgAytp4db4b2yDPtQpFxE8wbqu7ZCGMSE8MCyobLNJ
	hxew/k8mrr3fviOqJf/pPYSlqFP3zfp8htTyAjcZZz5x55gDmxVRpD425T6uLwXldY6TSj
	GP/bOCOSaWrWjuh51LT6Gw9agceIL1c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AIwnS3bu;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.162 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275671;
	b=GFISolnNKy9LMvRT3kzez/+7i6EzQ68m5FerFMAxbzNHSWgCDWiD7Q+BGYXGxTG/fw//Za
	GDTaAtxak68GSirhSu2ZHLh7VMjEnEa/rTAArLPGDDXN/hxmF449ZpC/wSGJ73rXCzRDSh
	v+4GP+ZneXuM1cIMF0mkJayHlmP0fGA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bvsZVhH3fXVvwRMjzbTh1Q0bqUQyRzPT8xCixvm+AS8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275670; v=1; x=1790880470;
 b=AIwnS3bu82n/6i8h81+UuybcqZEvxDzN7ZVnE6jw/vZ85Yfr99LPq3lcClGmhALWsbZyGqVF
 C2z4WFkDopIheipluEuhSDyU0G2o5iiX9cqpVOuB79wTUUBWy+vMkyFSdOqDmj2T+M3Hs2OSD2B
 nVkJSwtECuvECqKlE6NS/W/8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 687bc44cdcacb26c;
	Thu, 24 Sep 2026 18:47:49 +0000
X-Mizu-Trace-ID: 687bc44cdcacb26c
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
Subject: [RFC PATCH 4/7] sched/fair: add cfs_bandwidth_charge() for kernel work done for a cgroup
Date: Thu, 24 Sep 2026 11:47:08 -0700
Message-ID: <20260924184714.912181-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 767DC4000A
X-Stat-Signature: aex8zqecyosuz8zxyefu4b5jaja89n6d
X-HE-Tag: 1790275671-721479
X-HE-Meta: U2FsdGVkX1/WN/fDpXXcpKgU5sgGZI7brICSpTZrBDL7WHO0f4tk2iJdkHv2smmPNaWNF4oL5ieImrJyx4eBR0DPVA3dhDYEvKSkRGfjvzsKukPzUyQtTrcbGKoDXBPMylkX9ZEc5d5gVa5TsOu8Gh6apigieTnmf/jJRvXZlakIFJDnEgWOcLN+HXNt1/xzvrj4i3Fc7zrfcA76go2gLPnT9IDwfT0S3Y3ryrG1huaez5+PoJI7UHQ9/oaBdDpD9ZQKQGYmziIFDUnRvDJycYZiiD+BbevpqebUBqj2a0n8Bj7GpR82e+3O7rV57aBD1hpLNPBjFTkMZeMgjUiBgIJ9TL/6L1S+2X032PahuwE/Wa3wRurwPUCRcvxWhJ1S6eVb4tMQ5kHmlFKUl3DcCDk52gqyduxoUQy0UifadRTIqw9vsw1uO722Kh4nKSYzIjzvxeHdviYKtwS0IJdSTqaCKT3g+vxf3YY6XJMAwo1vLiVlYXgPS+z6KgaoMaVXqFGehqGQNqtNljSc7TSN+tdGt1TmQt79E1MdliNrzg0aIkItYjZ3QOUVWTCpoMlUmiTcfObehwRnukc9kzerlN+LyVZ6+bYmPllPpjePBPXSLDG5meLMsWHRidMf6n2x07lrNQOjL/WcOnFuK7Qxxgo3+uMebYREk7wy7wPYKNeeovbUKTwZkQZCPiAVwlUM9KJRMYBIc3v8NgYodwSc2fuOrWJ4ztBg3ZUt1wAanHzoSubNobvcaiYjUf3y8EX9dbjnfOVZKUxALJn55Sj4F+CGMWqnRUZG5fHvt37fTHDhXgSPwHTIkHcfPc2/4jobsTBXQpE7K1WLoxOzIVW8JOWKKdMSro+bi17f+q7jhBmV9/M3wuiMok94ke3hXhrYGDzBDZ8wWM7Rzadh8FweT/T6UVdKSTvx602souT+oeWG8iKr0nYXtzx+/9DA0FzgZeHoEqksnmwDMogwC4z
 DptW78L9
 wxfcIzE3HFrr+DQ5qKYwGKf48nBm07ThESgWJsYSaAbfTXT0psHKlC4n+Dm1KaBoGRJNykePT69XflkdiLPma7oZ2fw2MQpxMe/+UtCXuLiVHqY5zXHtc/0bOXgVAww5maM2Q28GZ3gF+T38F33UBDu2j2mH29lqojzL9054KbnPK3QAXDQwRAkKeX8PhzCO9YrccP1Kosv/T57lrsFmW3/pErg7hWvD7bsD+ork785ojQPISBCB0xj4+YaewPMtmDc82i/LUwUDI7rGx/TrLD+ft2zgzzJPcMtk7TOPsMtTQNuvvEmdSuCWxeUk/DslVqJ0ozVUoChicFod1/ryzHtogMyLOQ8AyQIYP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

set_active_cgroup() charges a kernel thread's CPU time to the cgroup it
works for, but only in cpu.stat. The work still does not count against
that cgroup's cpu.max.

Add cfs_bandwidth_charge(). It takes the time out of the cpu.max pool of
the cgroup's task group and of each limited ancestor, the same way the
group's own run time is taken. The work itself is never throttled: it
has already run. Instead the group's own tasks get less time afterwards.

What the pool cannot cover now becomes debt, paid out of the next
refills. The debt is capped at one period's quota, so a burst of work
cannot starve the group for long. Changing cpu.max clears it.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 kernel/sched/core.c  |  1 +
 kernel/sched/fair.c  | 43 +++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |  8 ++++++++
 3 files changed, 52 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b9e288b76da9..a487da494795 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9809,6 +9809,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg,
 		cfs_b->period = ns_to_ktime(period);
 		cfs_b->quota = quota;
 		cfs_b->burst = burst;
+		cfs_b->debt = 0;
 
 		__refill_cfs_bandwidth_runtime(cfs_b);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 69145dda0df5..84250bd5caa2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6626,6 +6626,7 @@ static inline u64 sched_cfs_bandwidth_slice(void)
 void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
 	s64 runtime;
+	u64 pay;
 
 	if (unlikely(cfs_b->quota == RUNTIME_INF))
 		return;
@@ -6638,9 +6639,51 @@ void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 	}
 
 	cfs_b->runtime = min(cfs_b->runtime, cfs_b->quota + cfs_b->burst);
+
+	/* Pay back the kernel work charged by cfs_bandwidth_charge(). */
+	pay = min(cfs_b->runtime, cfs_b->debt);
+	cfs_b->runtime -= pay;
+	cfs_b->debt -= pay;
+
 	cfs_b->runtime_snap = cfs_b->runtime;
 }
 
+/*
+ * Kernel work used @delta of CPU time for @cgrp, see set_active_cgroup().
+ * Take it out of the quota of @cgrp's task group and of each ancestor with
+ * a limit, the same way the group's own run time is taken. What the pool
+ * cannot cover now becomes debt, paid out of the next refills. The debt is
+ * capped at one period's quota, so the work cannot starve the group for
+ * long.
+ */
+void cfs_bandwidth_charge(struct cgroup *cgrp, u64 delta)
+{
+	struct task_group *tg;
+
+	if (!cfs_bandwidth_used())
+		return;
+
+	guard(rcu)();
+	tg = css_tg(cgroup_e_css(cgrp, &cpu_cgrp_subsys));
+
+	/* No limit here or above. */
+	if (READ_ONCE(tg->cfs_bandwidth.hierarchical_quota) == RUNTIME_INF)
+		return;
+
+	for (; tg; tg = tg->parent) {
+		struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+		u64 take;
+
+		guard(raw_spinlock_irqsave)(&cfs_b->lock);
+		if (cfs_b->quota == RUNTIME_INF)
+			continue;
+
+		take = min(delta, cfs_b->runtime);
+		cfs_b->runtime -= take;
+		cfs_b->debt = min(cfs_b->debt + delta - take, cfs_b->quota);
+	}
+}
+
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 {
 	return &tg->cfs_bandwidth;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6c3ad70e58b8..2d1adfd7ad37 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -456,6 +456,8 @@ struct cfs_bandwidth {
 	u64			runtime;
 	u64			burst;
 	u64			runtime_snap;
+	/* Kernel work charged by cfs_bandwidth_charge(), not paid yet: */
+	u64			debt;
 	s64			hierarchical_quota;
 
 	u8			idle;
@@ -618,6 +620,12 @@ static inline bool cfs_task_bw_constrained(struct task_struct *p) { return false
 
 #endif /* !CONFIG_CGROUP_SCHED */
 
+#ifdef CONFIG_CFS_BANDWIDTH
+void cfs_bandwidth_charge(struct cgroup *cgrp, u64 delta);
+#else
+static inline void cfs_bandwidth_charge(struct cgroup *cgrp, u64 delta) { }
+#endif
+
 /*
  * A weight of 0 or 1 can cause arithmetics problems.
  * A weight of a cfs_rq is the sum of weights of which entities
-- 
2.53.0-Meta


