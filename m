Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93753C982FB
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 00:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E576B00A6; Mon, 21 Sep 2026 20:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5ED6B00A7; Mon, 21 Sep 2026 20:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD736B00A9; Mon, 21 Sep 2026 20:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FBC96B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:32:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 940A8A0340
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:18 +0000 (UTC)
X-FDA: 85239521556.21.F9E7DA4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E307A0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GXSV9vLE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790037135;
	b=qAw5Q76kx7TJZ6cTce038NY0E0iMYAsBLAkQMGvayBwVVweh+9ntxe9ur5QEmzu4tLvKBm
	ocvnBwLoG1oDnXUku+YYiHK36IA0IX3+Y2lAqrnhA/Zs365HGVsJR9wmsQ8H7RQK7GJhLd
	EsstIMO/aX/rEb0+9lqjh9QmTg6prpw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GXSV9vLE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790037135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7vxmU6jE7e9a3+tIMV17J3j1BWdQ/mdq86PD42qxmII=;
	b=m3kxsC0la4LKO0FFEY6vfUDVb+1JKLb7WFh7fivwFbe61DsJyEsVtRDDL1fq4uEex1gE3L
	dt5p2uzWp6KOqa/uXtEnSQI1LUyCWfn2PNTiXLY4YCsMa+42Wa76sBIwF8o8CZn92K3vzq
	Knz1onkygWKtA37uSb0mulTMHYoZfXE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790037135; x=1821573135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3SNad8cSGX/yLWI8E3JE9cy9dkKCeA1Qu3xf/C4B2+Q=;
  b=GXSV9vLEnEpNXn3P23L/OgQU/LKO2huYOswJkmY3Ci7GfMzQ1wg4dlp3
   5xsJAoiYmMqwKLEzkbSeoP0sMKPZZQ4bUnXh2LYWqXpPJ86qTYhxcaTII
   gkRvOF+ZzPNtn4FlFv6YaFVE0tWVyNYi8FJKvPZxd5o3iHW9sWbBsX1lE
   WIObpfEmXOS2LW9joXfiarW/sERhT4jWtZNRqY5LPjasbKOORqLseAsXA
   0wOSZaXiLnrvsYafEAupnWhzwsaA/kuQ/EWvDL7GTkMv3YLcT2EGOwKQh
   W9QvmKRvBvgH3a0VkjMDFUN/dR8Clr/hV8KqMfm4m6yiyXnUzS6agvpfz
   g==;
X-CSE-ConnectionGUID: CiZqTlNBT1yeiAVEqzg+Wg==
X-CSE-MsgGUID: V4auKFitQkyqWmiBdL4cNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90716659"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="90716659"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 17:32:13 -0700
X-CSE-ConnectionGUID: 4p7YC+7bQ++tsxep43jVwA==
X-CSE-MsgGUID: xD69XWy0QB2tetf9x/f/Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="277671840"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa004.fm.intel.com with ESMTP; 21 Sep 2026 17:32:12 -0700
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
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	stable@kernel.org
Subject: [PATCH v2 2/6] sched/cache: Honor migrate_llc_task semantics in active load balance
Date: Mon, 21 Sep 2026 17:37:23 -0700
Message-Id: <cb39f64a17fc2b76097264aaec74a2d6dfff4315.1790035273.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1790035273.git.tim.c.chen@linux.intel.com>
References: <cover.1790035273.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9E307A0004
X-Stat-Signature: 9gxf6eiuxpm588k9huw1c56kdmi9x6gh
X-HE-Tag: 1790037134-182626
X-HE-Meta: U2FsdGVkX1+z9vf1DFvoS/8sUSV6n4bvK3TM8ozpzV60ZNXfihAfJti/AdCAEsjzxpVd8DJb21M6/IOnWdVymEIg9favOF+GFlcreNho+2JTPAS7D1eTdH33LjxRNuyV5IWxABgZQ6Cys1ZHWrkiZSdx3+9L6MiS3fwdJwnuRq2q1PYcijTd0rXECojbxRLap/zSDhx40iilDQT9ScBIYyjGg3IGDVs+PJ+qf5+kqClnMvSDQ5ond4JuKysaZubG4fjvrOobw6QgKgU+NfSpiviGR5W53KcABBWPupvIHoyZKDbxnf/tvZAcAacAA9C7gAmCmTosAWhLTHuoWwMS45w8VeW2pkon6RJLH//clmpl4wLqhduCktJvl1XaZh77r0VlqngaZECNlhnVEUUYa0YIXKG95n2yLKGggcAte3i7TXerN2doV1iVRxdpPtVN+WyCje3AQE3dTTA0aOfVzooErMV6CSTQSfbrvf3nmOOi3wNUQr4baf4kma+jEoNM9Aww6JsSCcVtWGZkZTemmOIF5PYIg/Q5HueP2rMyzVvNCIxGrFiftIlq9F3sNML5mrCaEhK+1x/1/j3+yF9lInW36nKeLAKSZQlQaXk3XvV45K7rC7kaDUGDt+4bUQ/6VN0LSjh+Jkxf94+rrx8r6JMiBDY/pFJfr1b3m+x0iNsPhSZLsYnnDy7DiNOF7FWnaPH6aQ4erTjsxP9jlNVVI03LaJ+NUOwmneVQz6cRrkDCXhAB/WabXrJTxYmcK6W/XV/p9A/SilpjnnXT+igJii363E/3QuUCn0JS5r0Fo59hvL4rFZmEV6HrbmcW2pvIMUr8EC0LtvT63sZXvcYmdf5sOlgque0Jqibmli0WnlXSItujttc36Z5NxZRg5xHxr7jb4VPNxPbgm6919kbwJ8TqNfIpcsj8E3700jFIu5oBJs6zbLwndp1FXZgQub7Wwck7/IxprJQJwkiH3dB
 XALbtjWo
 7Jola/t9FQesmC/+Bn2M36bPM/WRdKA1nQ2eg8jK9+tQWfH2iZI63Tu0G41NQxAQUf+Luq79Qx/vbSJPI3FK5wkJ8IULuqqBbqWC4ZVZLc7uRncr1rCRcBUPwmNvb+IMOhF6yDMw7q/p1r5ndUBq2s4CdtKdoyHVDBVYBYr9VwdpyxGHTlrdI5UGqya1DJ0h5ctZmvzv2QPGZLS1ZgYEA7XgNGt3bwBLQMai9G+YQE4jnXmtgEOguD0OZBU1oaojaCDOkLBnyhJZLuqRdOFaIkTgnYTb/Mtw5G2ejOVI5LCzzrru859LKa3c+9uVMcdNzccDn/L6JQQPPJA1WC5OoINk/mxX7HQ0z2CMo
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
Suggested-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Lu Wang <wanglu.priv@gmail.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Cc: stable@kernel.org #7.2.x
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/fair.c | 57 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 19765ee1af83..6f1939d17e9e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10453,6 +10453,7 @@ enum migration_type {
 #define LBF_SOME_PINNED	0x08
 #define LBF_ACTIVE_LB	0x10
 #define LBF_LLC_PINNED	0x20
+#define LBF_ACTIVE_LB_LLC	0x40
 
 struct lb_env {
 	struct sched_domain	*sd;
@@ -10871,6 +10872,21 @@ alb_break_llc(struct lb_env *env)
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
@@ -10899,8 +10915,7 @@ static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
 	 * run on env->dst_cpu, skip the tasks do not prefer
 	 * env->dst_cpu, and find the one that prefers.
 	 */
-	if (env->migration_type == migrate_llc_task &&
-	    READ_ONCE(p->preferred_llc) != llc_id(env->dst_cpu))
+	if (migrate_llc_task_wrong_dst(p, env))
 		return true;
 
 	if (can_migrate_llc_task(env, p) != mig_forbid)
@@ -10922,6 +10937,12 @@ alb_break_llc(struct lb_env *env)
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
@@ -11021,7 +11042,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 4) too many balance attempts have failed.
 	 */
 	if (env->flags & LBF_ACTIVE_LB)
-		return 1;
+		return !migrate_llc_task_wrong_dst(p, env);
 
 	degrades = migrate_degrades_locality(p, env);
 	if (!degrades) {
@@ -13420,6 +13441,20 @@ static int need_active_balance(struct lb_env *env)
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
@@ -13765,7 +13800,7 @@ static int sched_balance_rq(int this_cpu, struct rq *this_rq,
 	}
 	if (active_balance) {
 		stop_one_cpu_nowait(cpu_of(busiest),
-				    active_load_balance_cpu_stop, busiest,
+				    alb_stop_fn(&env), busiest,
 				    &busiest->active_balance_work);
 	}
 	preempt_enable();
@@ -13870,7 +13905,7 @@ update_next_balance(struct sched_domain *sd, unsigned long *next_balance)
  * least 1 task to be running on each physical CPU where possible, and
  * avoids physical / logical imbalances.
  */
-static int active_load_balance_cpu_stop(void *data)
+static int __active_load_balance_cpu_stop(void *data, unsigned int lb_flags)
 {
 	struct rq *busiest_rq = data;
 	int busiest_cpu = cpu_of(busiest_rq);
@@ -13920,7 +13955,7 @@ static int active_load_balance_cpu_stop(void *data)
 			.src_cpu	= busiest_rq->cpu,
 			.src_rq		= busiest_rq,
 			.idle		= CPU_IDLE,
-			.flags		= LBF_ACTIVE_LB,
+			.flags		= LBF_ACTIVE_LB | lb_flags,
 		};
 
 		schedstat_inc(sd->alb_count);
@@ -13948,6 +13983,16 @@ static int active_load_balance_cpu_stop(void *data)
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


