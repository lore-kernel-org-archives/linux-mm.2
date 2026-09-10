Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEE8C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE9A6B0098; Thu, 10 Sep 2026 13:40:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63A1E6B0099; Thu, 10 Sep 2026 13:40:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4668D6B009B; Thu, 10 Sep 2026 13:40:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E35F6B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:40:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8496A1205C3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:40:54 +0000 (UTC)
X-FDA: 85198568028.06.01C48BC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf02.hostedemail.com (Postfix) with ESMTP id C236880005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:40:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bOdfvJHC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789062052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Er5f25aElyTfc1IPhDzdQv5/9Tg7EH5T0sTOwex8Y/w=;
	b=xwWdTQRVdRygOn0fZeY0Z6g0+5T1xQzUkUCo/2QH3N4B+stQ6BncnX04kMsaQ8p78QAwpN
	lwKyo2VEa2XZqW1IN0nZnCvQ7Fz8vfSnF1IoRXA/1B6a9alkMDZBNYZPdlDho1bMLq540z
	SyICOcVjP1EkExiX54a/HQ+96cIF6QE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789062052;
	b=2wfPtvP/hSTIvy46HX1IgvvZaOqEOzax6hou1mirEWZPLDpvdMt1pp2OKKF8VYWARNBXgg
	Cip5lGKSU8AcqxFLV5rx1f8XjGhkO8vwM7DKmnD3nJ64eN/tK4Y25jT3jExHSCaAOqGgVM
	Gli3p4PVHRYNL/esOYkck7nnHBciYKo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bOdfvJHC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789062052; x=1820598052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xFCDOkvk2TofjVGFvEcPYHDr8qB7EOl4xYV+VmLtdNo=;
  b=bOdfvJHCCmMXo+K1DITGpNwWP/wyOIsNkI4LebXdHpYtuuHgwt63b54e
   S3cBv1kQ4azxi1s0gnV0gkor9sPmcxNtRNaozbx6TskOjr5PJ9fb+zOG6
   LCMSOpjlYYNOlwc9XBDaKUHycdcfA8o7P+RhhflukLKSmsKAvB4LbxbJu
   YpISGoX00AzEPeX8inFufPc4LXy7EU8aEUptEuCkpEQ5MnWtbi7Elwa+i
   jEkqUXQxfuc8dWpw3pdY+8kt9FDer4A1wRnVWt0UjefDB55/18ix6BqAl
   idUi9lQShh7sX73/7eNoJIYCwSl3tcY/ggp6LWM1Nfkd4voHe9MFGmHs5
   A==;
X-CSE-ConnectionGUID: Qt2fV6qcQT2sLIErn8vKQQ==
X-CSE-MsgGUID: wNgYwwhpRsafvqRZ1+OKpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89453792"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="89453792"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 10:40:50 -0700
X-CSE-ConnectionGUID: ikLY6dI3QV64wg6PT8UPgw==
X-CSE-MsgGUID: UanPt+boQNeAlNLKbJnhTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="275222012"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by orviesa003.jf.intel.com with ESMTP; 10 Sep 2026 10:40:50 -0700
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
Subject: [PATCH 1/4] sched/cache: Keep nr_pref_llc_running in the runnable domain
Date: Thu, 10 Sep 2026 10:46:09 -0700
Message-Id: <82736e1329bf8ed195bbbc4990486c87094e6789.1789061845.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1789061845.git.tim.c.chen@linux.intel.com>
References: <cover.1789061845.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C236880005
X-Stat-Signature: mkjp9z56tzw9ccbexqyexoak6bknasr6
X-HE-Tag: 1789062051-81963
X-HE-Meta: U2FsdGVkX18sDX/Rf2WjTVaTgGVooywDwQcM1s3sL59F79dmYX4grsup9CganJ9cbBKROL0fAuGF121Zg6ESnfV0WzslW6SSCOPnpEu7HYN/LYUBzFztUyCx2cckK8B10GSbuni9RafOyPpWAoq6mrdxYUbpaMcAuchHBipA3yCQdFuLWi0+ZIYO81Gawl+UePpZidJ52oOfGrd6ZpzfA/on9UREf0abKklv+ytZeMyCSqZA1RWFtHOLek88xXlnC+WrJ2eI5JxqKnw5E+gDDlVJmC4cxdPkdDG+uDzcI/VWPWSGCVvtpkhXa7kH5DsbVe5b+KVFg7XPayqxF9kNA0DGeQwQB/f2W4+rf+xS0WXY1j2TXy6vdpJylexpvt0dCg4mrKDKx6RE3nRh9umcVSCjcXqYRzBxUyH/bluWg7okyvVG1hk4/dfBEMxl51o2FomX0cktR3u5Qc7vu9lPWbpt7nB0H3JrBnyESZ3qfhSUmhxElWlTKIYOZys1tV3qLNQSCxvDJdYVIGf/yF5wvRjutkAJ8GwQ6siC95E8qdcdhtRMmbyduA5PS4iLkMAeUkA3WXd3MeEg6EDAJ5mJwMYmTsddSDdamqJef3DUrNvS+ZizEE7eQS+a/iklCFj9bGDmQUTI2sLhSshfzaPG9LmUwDFYXr9yiagvReinXjcGFZzRYG1nRQxE3w0FpWje+whA7iPa4yim+HSh3g9l3IWUtcfiqS8NRpQAIGh43P9x8Q4/V6N0qPerl/xzx49brKdFQuANt5uHJYjsI9FWbQ3Vhi9hzN4Q7MkZGw/WICrXjJ21zVbqVhHMA++tpowNAn+72F9fUOOzJilNNK2AJioBqelHotPu/8jQNyF2fmZ5xO1qpkLQyxxTEO1WQjI0DfE5ciI1mArgnCehdD5mvGZpXPrO707ghVGwg1RTWrKF9PHe6V2LeaQvBcaRM49ScTb9yNZzYuipmCuF6Qt
 kG+hzUeF
 p+OH2eihppLFGZeb1O4NlwlidDA8AAdubxnSaYONA7sr7jUJK/ke6zViHvjd47uvCqkViDx7I9Z5Jq6yYTeA70etHUpzuPZJGMkrCNjbifRv0dOqjhaoNtSdNBDqGOhUF2GI6t9pE0XvPDm/E9iL4yvXhABM9zK4k8bzL9iDzrkDMqzLkO0sq3Uq3DeoNZBa1mtClA871vi2XxD9tJwvFyrNpmfCYvh98kgX3wrGt29BNJwKfT6h9Xnff2j6hso9ZuLT4BS3lZvNH31drGCJkchJPaxI/K6duOnVDw9K9z9GFAFEspebHbNk27g/j5hk8ReLQQVSTGruNSdhyH0+YNBat3g==
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

Reported-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Closes: https://lore.kernel.org/lkml/20260827135000.735138-1-zhanxusheng@xiaomi.com/
Suggested-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/fair.c | 52 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d5989b53adef..b1ef013b0342 100644
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
@@ -2021,6 +2050,10 @@ static void account_llc_enqueue(struct rq *rq, struct task_struct *p) {}
 
 static void account_llc_dequeue(struct rq *rq, struct task_struct *p) {}
 
+static void pref_llc_running_inc(struct rq *rq, struct task_struct *p) {}
+
+static void pref_llc_running_dec(struct rq *rq, struct task_struct *p) {}
+
 #endif /* CONFIG_SCHED_CACHE */
 
 /*
@@ -6395,6 +6428,14 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void set_delayed(struct sched_entity *se)
 {
+	/*
+	 * Drop a task leaving the runnable set. Must run before sched_delayed
+	 * is set, or task_pref_llc_runnable() would already exclude it;
+	 * clear_delayed() mirrors this after clearing the flag.
+	 */
+	if (entity_is_task(se))
+		pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
+
 	se->sched_delayed = 1;
 
 	/*
@@ -6425,6 +6466,13 @@ static void clear_delayed(struct sched_entity *se)
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


