Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07816C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774106B009B; Thu, 10 Sep 2026 13:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D70D6B009F; Thu, 10 Sep 2026 13:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DA026B009D; Thu, 10 Sep 2026 13:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2205E6B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:40:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CAC7A529B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:40:55 +0000 (UTC)
X-FDA: 85198568070.21.0434450
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf21.hostedemail.com (Postfix) with ESMTP id 409581C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:40:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CebidueY;
	spf=pass (imf21.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789062053;
	b=4ieyeT4zE7/egrMrSpplVNik/1dFEUcRBme+sfw/ZEHTVg8u0Na+SWn5cVbv3E+ogWSRWo
	R3JaUDDsnMSZFj5M8riDTDeNgyUdYpzIMuEmc7YV6rbQ1Ql6MqcRzS4ofyTDsn9HPAI8GB
	sZ0s0CUYap61+rnFONWeXltBtvzwAK4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CebidueY;
	spf=pass (imf21.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789062053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNB/Iwlx1X+8VpwX4a0OFVS7SoVQ/LnsvgpFuJtWDCc=;
	b=AazeD6zS8jr1ZTcvkGhg3rMxhfQKX831hT6luqhWo6hd5loNJvLYIGQG+mHSzftrQUGvrt
	OJFbPf+1Gb8F2d4BezSUJfH0cHkjVW60SrypZ+G3urYtp45Zd+0AxKjYGFt5tAD4S64vGr
	VjCy0hbyglvf1uP6TTTN1VGfpl/wQBw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789062053; x=1820598053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/x/tN7WmmH/4PHrZfpNrj4Si0ibG5LSvyskeb6D3gbU=;
  b=CebidueYT4sj2ege6DXh/NYFZrAdQ0gVbCgtteSqZWAaaaM7ajAIniZ6
   DqHXdkO3MyrL878KYRdn7zemu5dIMwsyQX5EYmnnzgRQW1s7/ZSHuNkf7
   izvv8joHLNrOKq6NSM1Ejdbw1BLVhJdvT8RUk7teL6EPMNIDYJbX9KLNv
   Lfq49WpG+qKnoNTkvSElIjSiOcveBrT4NPgphO2GuMsfsnJpWRuWe76ig
   y4pXsSlaNLmeyUDAcS07DYCxq6ayTvw3jK6qFo82ZErdvqLyz1eY1ZAZP
   N2IOZ3NXeUyv85c+8X6AbWy5BCy6SeqGXvTEPOJm2PtyrIHkWfa7itCsw
   Q==;
X-CSE-ConnectionGUID: VLkOncq+R5a6FDoFgWfIjQ==
X-CSE-MsgGUID: 2iDHPe8iSViS3qdJ/xVNfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89453810"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="89453810"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 10:40:51 -0700
X-CSE-ConnectionGUID: e+BP3wmrSN2jUJdv9UnRHQ==
X-CSE-MsgGUID: hO178K8CTNel8PY+P6Q4jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="275222018"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by orviesa003.jf.intel.com with ESMTP; 10 Sep 2026 10:40:51 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Lu Wang <wanglu.priv@gmail.com>,
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
	Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/4] sched/cache: Honor migrate_llc_task semantics in active load balance
Date: Thu, 10 Sep 2026 10:46:10 -0700
Message-Id: <4c921888d81e4a7eefa14322bf04058a1a30f4e9.1789061845.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1789061845.git.tim.c.chen@linux.intel.com>
References: <cover.1789061845.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 409581C0002
X-Stat-Signature: rt47fecegdg6eaiqesj1owcawqewbjhf
X-HE-Tag: 1789062053-100458
X-HE-Meta: U2FsdGVkX19LS4MUyJ26tFBhnX0p9pSzlC2Db5uPTfVjWUnzr+FqCgIkUKe32hQ+ijp8HjB19bfCbXEQzPB395J63eRrWCcjzDLj1hNEhbMAGaa8XgDXgvJMfx1mMQKfiJrWgyQvW2hD//TWb1n0MB2K0sZ5D+Orj89VL5rycfI9FBWm4fLihVABT4ksjFa3JYYxJb8sFrlD/PVoiVQvdefGcXRfrVFxjBdkSTmsvqSEzYBCTqcMUPZleGFzOvo0VT2u9sPmnCo52wTmZWHS8Kdv5RCdXjxszihJtaBTd0lbxk50CDf8xiK06bvGZriLoa1rYW1V2wwU8Yc73Kn5BJLGoqGLg3Me2er5Rvv/Y/F9kGAquCc+idMiiCQIWmh86BVky6Svmgfm0oNCo/oENTy3F+7PZEnf9T3IBXjoDROM9YeL6zErK1TmONas2fIEKoDbNeDp6juuFZ5LcjfqO21EtPnao5jOl1J7SLUKCxG2FbaLxPzJOonDP6/T/HmQ4NBR1rhGjA1vd0XKirZhayoPg7JbANIoOe0fjomVHyNBKz/F/HUsO+7Rygy3RO2xQNhix7jYZlT2YV7qrOAgoQ2ca8+dUtFqrtJIw6HRQWmwtQjo1EYuzmKyijQPCCQCfkMHmmVxnXUF3Yghci/p/l3URK6tyQvD6R+y/pUU9YFMPuw99ykLOJ4acHIIwk/LU3ypqDPgjkTXiK77WhD0B9z6IhUOjf4cpRFAs5DI7Pjpk3NwT4ym/rIZov/Gv/LGrfU7ir6UTh64BWgu0LaqKdEbKY/eQ6UCHNOKKYuf8PF3dtSwuZoEHGY0azRJVi33BgSpsy3zUsREs03iGEjdhh1wglEOOLBRLM/V3327KuMwPLDWgWSTRfXwjWsrFIaWpPvLZxhxJNmi9sNXhmjiFPbtKF+IqiAoC9bL/jDsEr0ec6fbTAGhk93rzEvpKPz7o9J9HsS8qL1tvdxtBfE
 JZdaqjdq
 4hxekcZvZE4t7CUDibv/gssKenac223eHdMQ6WT+ESWkcoJkdQ4lfb564d+zj8jxHe/RhXrUdcY8/aithkwCmE65EdEJi8FZIaI9CcDb4nnmcXM1/NIWjdoycmxkRDE7leSTZzr81odF/viuqGEPfew4gxGdBWDsCaqDOKvLEFs6q1Xe5FqgQuqGhEf+TMAX0WnMhz2oYLXjYtLuSNIGBkHDbqTBEY4J/gebdRfuPSw8YDPYZjFJUaafDCvJeiYqq2FOrLtFfnNejKg0CDWtmrOtbhYvd1VXz24xtbhY5/GFQdX78Vdaf2pwnztaaE19CzaKr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lu Wang <wanglu.priv@gmail.com>

CAS introduced the migrate_llc_task migration type to direct tasks
toward their preferred LLC, but its semantics can be lost when passive
load balance falls back to active load balance. This may allow ALB to
select a candidate whose preferred LLC does not match the destination,
moving it away from its preferred LLC.

Example scenario:

src_rq has two runnable tasks, p1 and p2. p1 prefers dst_rq (dst_llc),
while p2 prefers src_rq (src_llc). In this case, migrate_llc_task is
set because src_rq has at least one task, p1, that wants to migrate to
dst_rq. In ALB, can_migrate_task() finds p2 and returns true for it,
thus moving p2 out of its preferred LLC.

Solution:

The CPU stopper in ALB constructs a fresh lb_env that does not inherit
migration_type from the passive load-balance pass. Two approaches are
possible:

(a) Add a new member to struct rq so ALB can inherit migrate_llc_task
    from the passive LB that triggered it.

(b) Define a new flag LBF_ACTIVE_LB_LLC and select the stopper callback
    at kick time to preserve the migration semantics across the
    asynchronous boundary.

We choose (b) because it avoids passing migration_type through the
stopper, which would affect the meaning of migration_type for
delayed-dequeue tasks.

Fixes: e4c9a4cb244a ("sched/cache: Add migrate_llc_task migration type for cache-aware balancing")
Suggested-by: "Chen, Yu C" <yu.c.chen@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Lu Wang <wanglu.priv@gmail.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/fair.c | 57 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b1ef013b0342..32213801ea39 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10448,6 +10448,7 @@ enum migration_type {
 #define LBF_SOME_PINNED	0x08
 #define LBF_ACTIVE_LB	0x10
 #define LBF_LLC_PINNED	0x20
+#define LBF_ACTIVE_LB_LLC	0x40
 
 struct lb_env {
 	struct sched_domain	*sd;
@@ -10866,6 +10867,21 @@ alb_break_llc(struct lb_env *env)
 	return false;
 }
 
+/*
+ * Returns true if p's preferred LLC does not match the destination CPU
+ * under migrate_llc_task semantics. Passive LB passes migrate_llc_task
+ * in env->migration_type, while active LB carries LBF_ACTIVE_LB_LLC in
+ * env->flags to avoid overwriting env->migration_type.
+ */
+static inline bool
+migrate_llc_task_wrong_dst(struct task_struct *p, struct lb_env *env)
+{
+	return sched_cache_enabled() &&
+	       (env->migration_type == migrate_llc_task ||
+		env->flags & LBF_ACTIVE_LB_LLC) &&
+	       READ_ONCE(p->preferred_llc) != llc_id(env->dst_cpu);
+}
+
 /*
  * Check if migrating task p from env->src_cpu to
  * env->dst_cpu breaks LLC localiy.
@@ -10894,8 +10910,7 @@ static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
 	 * run on env->dst_cpu, skip the tasks do not prefer
 	 * env->dst_cpu, and find the one that prefers.
 	 */
-	if (env->migration_type == migrate_llc_task &&
-	    READ_ONCE(p->preferred_llc) != llc_id(env->dst_cpu))
+	if (migrate_llc_task_wrong_dst(p, env))
 		return true;
 
 	if (can_migrate_llc_task(env, p) != mig_forbid)
@@ -10917,6 +10932,12 @@ alb_break_llc(struct lb_env *env)
 	return false;
 }
 
+static inline bool
+migrate_llc_task_wrong_dst(struct task_struct *p, struct lb_env *env)
+{
+	return false;
+}
+
 static inline bool
 migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
 {
@@ -11016,7 +11037,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 4) too many balance attempts have failed.
 	 */
 	if (env->flags & LBF_ACTIVE_LB)
-		return 1;
+		return !migrate_llc_task_wrong_dst(p, env);
 
 	degrades = migrate_degrades_locality(p, env);
 	if (!degrades) {
@@ -13415,6 +13436,20 @@ static int need_active_balance(struct lb_env *env)
 }
 
 static int active_load_balance_cpu_stop(void *data);
+static int active_load_balance_llc_cpu_stop(void *data);
+
+/*
+ * migration_type is checked elsewhere to decide migration policy, so
+ * it shouldn't be repurposed just to flag an LLC-directed active
+ * balance across the stopper. Pick the callback here instead.
+ */
+static inline cpu_stop_fn_t alb_stop_fn(struct lb_env *env)
+{
+	if (env->migration_type == migrate_llc_task)
+		return active_load_balance_llc_cpu_stop;
+
+	return active_load_balance_cpu_stop;
+}
 
 static int should_we_balance(struct lb_env *env)
 {
@@ -13760,7 +13795,7 @@ static int sched_balance_rq(int this_cpu, struct rq *this_rq,
 	}
 	if (active_balance) {
 		stop_one_cpu_nowait(cpu_of(busiest),
-				    active_load_balance_cpu_stop, busiest,
+				    alb_stop_fn(&env), busiest,
 				    &busiest->active_balance_work);
 	}
 	preempt_enable();
@@ -13865,7 +13900,7 @@ update_next_balance(struct sched_domain *sd, unsigned long *next_balance)
  * least 1 task to be running on each physical CPU where possible, and
  * avoids physical / logical imbalances.
  */
-static int active_load_balance_cpu_stop(void *data)
+static int __active_load_balance_cpu_stop(void *data, unsigned int lb_flags)
 {
 	struct rq *busiest_rq = data;
 	int busiest_cpu = cpu_of(busiest_rq);
@@ -13915,7 +13950,7 @@ static int active_load_balance_cpu_stop(void *data)
 			.src_cpu	= busiest_rq->cpu,
 			.src_rq		= busiest_rq,
 			.idle		= CPU_IDLE,
-			.flags		= LBF_ACTIVE_LB,
+			.flags		= LBF_ACTIVE_LB | lb_flags,
 		};
 
 		schedstat_inc(sd->alb_count);
@@ -13943,6 +13978,16 @@ static int active_load_balance_cpu_stop(void *data)
 	return 0;
 }
 
+static int active_load_balance_cpu_stop(void *data)
+{
+	return __active_load_balance_cpu_stop(data, 0);
+}
+
+static int active_load_balance_llc_cpu_stop(void *data)
+{
+	return __active_load_balance_cpu_stop(data, LBF_ACTIVE_LB_LLC);
+}
+
 /*
  * Scale the max sched_balance_rq interval with the number of CPUs in the system.
  * This trades load-balance latency on larger machines for less cross talk.
-- 
2.32.0


