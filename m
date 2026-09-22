Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01161C982E6
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 00:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2526B00A5; Mon, 21 Sep 2026 20:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289B66B00A6; Mon, 21 Sep 2026 20:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177F66B00A7; Mon, 21 Sep 2026 20:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD02A6B00A5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:32:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D47740328
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:17 +0000 (UTC)
X-FDA: 85239521514.11.0A05036
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id F2578180004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Uq0mHBPI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790037134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15upBn1Ptt/HYHV74i6dRm+1Ntk73YSdxc0fG5WhMzY=;
	b=BdDNgfNcO9ubCXURAFMBcoyiCb0QXy0qWGVEBN1AxaGlSJSru0Cr8OEh+qoak11hnCPQsI
	Zh7cu0vx68Jma5gJoF2TPmn3Cibbj75yhO526Z8yjsJ8jCWbjWt9c2KzUw7V3qs8LEekXH
	tBp/hxGovP0thP2+brX1nVM6v/ekyiU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790037134;
	b=bbQKAcXNk88Rrx4JQQFFUxmOQF00LQv2/pbWdkhKLrrMoUzMVrEMJCHkxGdFFEBMB/l+tY
	OP0kKyWfF4tTN1KWAn1TgmJXUi26DQJhyV/6HGWn/8JdP2rCfFo92KujEHTLOSPfEP+EYO
	UmlF7TAdeFScyg2ULITPTZoBnYgWpg4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Uq0mHBPI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790037134; x=1821573134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TLr+muP9IJPeDswlAwrJ9DVaMebbbJPEc9g+IiyTn3Q=;
  b=Uq0mHBPITNdj63IvoB/8ng7yjXqkbZuxw9o1dz/syQgOzDy+HWTYcls/
   7LAYvauYdvzoSxLGa/ioVJgXR8U8Y4cS/P7zHGrTUU9rvs7AOrfa/y2XR
   GRLYeLhDSVMyKhNHxzMRMh46IHaEl4KiCxlqYIJLXNlVjgNfsNbXA4BVl
   FBlz9Jvn46AnNSWYpBVVEFHXyAgGwIyn2TYog0xtgkUwS+i77eAGDFtMh
   yLIV1H23SNDcXadOSzacHftQg2PSSPVCMAQfZLv/VlxdIvG6uNDk7RRqy
   pdX4XoK8c1GK3CyIAFFj+2JctywmT8j5j6xkkg9CXv2Sw4ZxdCX3zYZxh
   w==;
X-CSE-ConnectionGUID: qH7a8s9ARnGtZD+NK6OrRg==
X-CSE-MsgGUID: VRq13rN0S6S98ViHkifwGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90716638"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="90716638"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 17:32:12 -0700
X-CSE-ConnectionGUID: twlC2qkvS7CeVw4fkj5Ksw==
X-CSE-MsgGUID: bQa3l3LNTVy7qIDuPDoQrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="277671820"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa004.fm.intel.com with ESMTP; 21 Sep 2026 17:32:10 -0700
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
	Kayra Cizmeci <kayracizmeci@gmail.com>,
	stable@kernel.org
Subject: [PATCH v2 1/6] sched/cache: Keep nr_pref_llc_running in the runnable domain
Date: Mon, 21 Sep 2026 17:37:22 -0700
Message-Id: <06af61afedac32e6477f57feb4d658f6c411c3af.1790035273.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1790035273.git.tim.c.chen@linux.intel.com>
References: <cover.1790035273.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F2578180004
X-Stat-Signature: rumhsnxabpo5ycuwcrg6jc51cby6gdg5
X-HE-Tag: 1790037133-830882
X-HE-Meta: U2FsdGVkX19/GY/E4WR7IEIe8+LBia1d8tp52TQOD4GVFoYriYEiqSMkPHvEaEQTWW4SW0DCtYE/NV5lCxiAmWUxitbb7pW2SnDvE2svcsa1pypuiNGDHp1f8Ogsnki0tG25WyK/Cv2D66EfB63SctcRLcMBpO7Kyr6lmiXbDOEePVfHyhDMu7su4r/mNzkagG/p4FlrOAEaiw/XICrU1IQIz1UlilC18Viem28fRiyZ+Il99x4TtKGoCPlUGkooI9hSPhfNTdhOxfOrqUItytEdBy4H8Kb4vtQB1D8WuuSBZ334IkTniUBsg0CK6XCa6vNq/s40cl1rYS6wnZP0N2uCH1NV7fca1OWVT4n2yCSfUsvKjvKi8nUOoGijB9ToOX1EPqbEo+2bloXsaF0ZQ/37TlWF4O1AX4bwpnV5bLelcpey0n/4BYIp8XZEMqwJABjr/w4qHV/HV/68v1Argvyl7rSpkC236RIWHRxFvjHBy1It7WJekBeGY8i9LpkLMZ8un8a5fWnhnz3oUq+VRd921YSZm0pkXRtOtlQnp2du+HrGeYdPGR5ns8QQhJP/Drzt0zSfYccxCevCQgy/SXJuc8skwb0ScYIdyecRbdfC2THENRLL0SlWNlWKZrL5KgJH/wRvRE2Al3OhdTgodQ3KYN3DMQ9aIn/Wn5b9c3/5CRb+Px/2rc/R+c1EGZYXbnsUfSUmWlXm4DFhxJZ1P1EcECcqR+Wls6M7a691FZ55pKHyKfYfGKGpBer0cKxbRVUrj0DK6MjyxI+2xIWS71yljHoU/AHfrxgmnACGTaOWjmxZerWCEdVBy+Qnm7bm9Blbc+gxdPIQODJQitSD9cNWtjFGF3QCozkMFvahzMNO9xmv0+HYohW2yJVajJ0tU7yFAJFMNh7PcmsRmDMruDAilAC5hEQzfrJXuBWlhPSOdGnzHDVtJ6F8c0oy+618ACUnVlW+RDd3mJLcJwK
 RTNf9Nuf
 psvBEnInQQnSBg7uvvP1jQZn9zGBiw68teJRTDgDHHOyjY24td1Xem2WR/jBgKOCos8WJ0gjIqBg9MNMASYb6s4PkEB3q/updxcX3xFJdxgcCE4W7X34A6DMOyWEd8a7X1iH1L8eqQCVaxS8SSuIcb+zfbX+W4qEPu4knS4Xnj2qi5Ubjw4xYKRt9qURS6q/Oti67BxTutne3KZlKzPjhPrqQBfSvJtI1ZJY7e8jCOq+wdRHZqiDTmgqBN/CJfxSvUWTmDtHlclTCGTmgZrorajtm2nPfLMBfyQdaMKAzNGeF1/Dj/1VWAOBz7aSbh+QgQKF5A82nxZpD+Hp6hVxUjQUlRNH6Kgd4LnaIUWykEUP4IA74504UbG4/gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alb_break_llc() decides whether to break LLC preference during active
load balance. It does so by testing that every runnable fair task on the
source rq prefers its LLC:

	env->src_rq->nr_pref_llc_running == env->src_rq->cfs.h_nr_runnable

But the two counters cover different sets. nr_pref_llc_running is updated
in account_llc_enqueue()/account_llc_dequeue(), next to cfs_rq->nr_queued,
so it follows queued tasks. h_nr_runnable is updated in set_delayed()/
clear_delayed() and drops delay-dequeued tasks.

So under DELAY_DEQUEUE, a preferring task that goes to sleep stays counted
in nr_pref_llc_running while h_nr_runnable falls. The equality then breaks,
alb_break_llc() returns false, and active balance is free to pull a task
off its preferred LLC. Active balance only moves runnable tasks, and this
is the only LLC check it consults: once the stopper runs, LBF_ACTIVE_LB
skips the per-task test in can_migrate_task(). The runnable set is the one
we want.

Fix it on the counter side. A task should be counted in
nr_pref_llc_running exactly while it is both queued on its preferred LLC
(pref_llc_queued) and runnable (!sched_delayed). Define that membership
once in task_pref_llc_runnable(), and adjust the counter only through
pref_llc_running_inc()/pref_llc_running_dec() from the four sites that
change either input: account_llc_enqueue(), account_llc_dequeue(),
set_delayed() and clear_delayed(). Gating every update on the same
predicate keeps the delay, wake and dequeue paths from double-counting
or underflowing; see the comments at those sites for the ordering.

nr_llc_running and sd->llc_counts are not touched and stay on queued
semantics.

Fixes: 714059f79ff0 ("sched/cache: Handle moving single tasks to/from their preferred LLC")
Reported-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Closes: https://lore.kernel.org/lkml/20260827135000.735138-1-zhanxusheng@xiaomi.com/
Suggested-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
Cc: stable@kernel.org #7.2.x
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/fair.c | 63 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d5989b53adef..19765ee1af83 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1551,6 +1551,28 @@ static bool invalid_llc_nr(struct mm_struct *mm, struct task_struct *p,
 			(scale * per_cpu(sd_llc_size, cpu)));
 }
 
+/*
+ * A task counts in nr_pref_llc_running while it is queued on its preferred
+ * LLC (pref_llc_queued) and runnable (!sched_delayed), keeping the counter in
+ * the runnable domain so alb_break_llc() can compare it with h_nr_runnable.
+ */
+static bool task_pref_llc_runnable(struct task_struct *p)
+{
+	return p->pref_llc_queued && !p->se.sched_delayed;
+}
+
+static void pref_llc_running_inc(struct rq *rq, struct task_struct *p)
+{
+	if (task_pref_llc_runnable(p))
+		rq->nr_pref_llc_running++;
+}
+
+static void pref_llc_running_dec(struct rq *rq, struct task_struct *p)
+{
+	if (task_pref_llc_runnable(p))
+		rq->nr_pref_llc_running--;
+}
+
 static void account_llc_enqueue(struct rq *rq, struct task_struct *p)
 {
 	int pref_llc, pref_llc_queued;
@@ -1562,7 +1584,6 @@ static void account_llc_enqueue(struct rq *rq, struct task_struct *p)
 
 	pref_llc_queued = (pref_llc == task_llc(p));
 	rq->nr_llc_running++;
-	rq->nr_pref_llc_running += pref_llc_queued;
 
 	/*
 	 * Record whether p is enqueued on its preferred
@@ -1580,6 +1601,9 @@ static void account_llc_enqueue(struct rq *rq, struct task_struct *p)
 	 */
 	p->pref_llc_queued = pref_llc_queued;
 
+	/* Skipped while delayed; clear_delayed() adds it back on wake. */
+	pref_llc_running_inc(rq, p);
+
 	sd = rcu_dereference_all(rq->sd);
 	if (sd && (unsigned int)pref_llc < sd->llc_max)
 		sd->llc_counts[pref_llc]++;
@@ -1596,7 +1620,12 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
 
 	rq->nr_llc_running--;
 	if (p->pref_llc_queued) {
-		rq->nr_pref_llc_running--;
+		/*
+		 * Skipped if still delayed (set_delayed() already removed it);
+		 * clearing pref_llc_queued below also stops clear_delayed()
+		 * from re-adding it.
+		 */
+		pref_llc_running_dec(rq, p);
 		/*
 		 * Update the status in case
 		 * other logic might query
@@ -2000,6 +2029,7 @@ void init_sched_mm(struct task_struct *p)
 	 * polluting account_llc_enqueue().
 	 */
 	p->preferred_llc = -1;
+	p->pref_llc_queued = 0;
 }
 
 #else /* CONFIG_SCHED_CACHE */
@@ -2021,6 +2051,10 @@ static void account_llc_enqueue(struct rq *rq, struct task_struct *p) {}
 
 static void account_llc_dequeue(struct rq *rq, struct task_struct *p) {}
 
+static void pref_llc_running_inc(struct rq *rq, struct task_struct *p) {}
+
+static void pref_llc_running_dec(struct rq *rq, struct task_struct *p) {}
+
 #endif /* CONFIG_SCHED_CACHE */
 
 /*
@@ -6395,15 +6429,27 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void set_delayed(struct sched_entity *se)
 {
-	se->sched_delayed = 1;
-
 	/*
 	 * Delayed se of cfs_rq have no tasks queued on them.
 	 * Do not adjust h_nr_runnable since __dequeue_task()
 	 * will account it for blocked tasks.
+	 *
+	 * This check can be removed because when flat pick
+	 * patches get merged as only task can get delayed,
+	 * same for clear_delayed().
 	 */
-	if (!entity_is_task(se))
+	if (!entity_is_task(se)) {
+		se->sched_delayed = 1;
 		return;
+	}
+
+	/*
+	 * Drop a task leaving the runnable set.
+	 * Needs to be called before sched_delayed is set.
+	 * clear_delayed() mirrors this after clearing the flag.
+	 */
+	pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
+	se->sched_delayed = 1;
 
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
@@ -6425,6 +6471,13 @@ static void clear_delayed(struct sched_entity *se)
 	if (!entity_is_task(se))
 		return;
 
+	/*
+	 * Re-add on wake, after sched_delayed is cleared. On a final delayed
+	 * dequeue account_llc_dequeue() already cleared pref_llc_queued, so
+	 * this does nothing.
+	 */
+	pref_llc_running_inc(rq_of(cfs_rq_of(se)), task_of(se));
+
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-- 
2.32.0


