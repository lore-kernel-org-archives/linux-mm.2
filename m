Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3A3C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23BB86B00A5; Mon,  7 Sep 2026 04:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EAC66B00A6; Mon,  7 Sep 2026 04:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3786B00A7; Mon,  7 Sep 2026 04:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2F986B00A5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:14:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 600FD140674
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:14:57 +0000 (UTC)
X-FDA: 85186255434.29.610ED6C
Received: from mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6BB6FC0008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:14:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IK19lLt3;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.227 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768895;
	b=uD59aNJf+aPqhK9yQU/7sYmF4h0Zt+Mg22/WwiDBG+p062bKyKb1KSA0SqC9CtGr21LzkS
	h3JtJ+/RHGXu9rNie1dl15Gz6zrrUm+sLGIvl60S4GeELsUIWDSRTCue+jBRhSIM0fEu4V
	/R1q+GDf4zNWB4+GX4h9hJqE3YHNFhk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IK19lLt3;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.227 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIWVAkgul39EU7L8+1Wyw1ZlWb12R4TO5OwkpUN7c9U=;
	b=P69tucNSiV7uNjzp19oNJDzjfWisrUNeFMzs42SCaVrKRiVXWoKIJ+6v+KyYh7IwLdRDz9
	ix60/jmo+qfriCXTni4HOCvicNbqTSQy95ylL8SJu9JyrBw5zim33rNpRi75d4m0wlsBQW
	2lr7v1IXASov6NwACshF6YgX1rWUaOI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GYHf+zbpJIbN8wdET2m2KoX50bTFoVYyZ6SIH+UzDwc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788768893; v=1; x=1789373693;
 b=IK19lLt3RNhYH68ocEIktoMXlTKmsbtOmPmpyDQFNth/wOqvSaB7UimEnHmi81y5XUfTIvwb
 kKKcLzcqR7McNFASai1GURu9fB3QBwYl8KS2twuyvQUTMw7KgSZP295bAN8RXc1oUjTU5fNebjS
 eABgGH/ib6letISwgKAGFn/0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 70f3f824a87c0db2;
	Mon, 07 Sep 2026 08:14:52 +0000
X-Mizu-Trace-ID: 70f3f824a87c0db2
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	mic@digikod.net,
	oleg@redhat.com,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	gnoack3000@gmail.com,
	ljs@kernel.org,
	sj@kernel.org,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v2 5/8] kernel: convert process/thread iterators to for_each_*_rculock
Date: Mon,  7 Sep 2026 16:13:31 +0800
Message-Id: <20260907081334.1152889-6-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907081334.1152889-1-ye.liu@linux.dev>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6BB6FC0008
X-Stat-Signature: smo4o9jab3pbsmpa1shooojem49kbfdy
X-HE-Tag: 1788768895-880741
X-HE-Meta: U2FsdGVkX1/UejTEa22KFFdUUxOAnPRybHvd/HqagMggY6Whd1trbr7VKeawXMcUxzFLoM3weXbyPvN4SqtA/j6q2ThAY6s3BL38aCfaWXWOYAk7wRf/QCTHxZWIPviT1S50k3W2qv2H9DTRBZ6Twf07KeW9mK9qDxz0mIqhweCOe2bdtBBosC+prHg99ofG/p0xaCpN0JJgtqu7rgWR9P8NmIsiYCDsGIlo+/rhq3t1bR09T/C2VlHOKfR7QA+vPc6QLsMwXXO886WT3iNRyJM5pFAtWrrvjNOusBrJEhgXFF94bOLCLnsD2hCTP0CBRUfD4/LpOLpXxGDhTQGTexLWqYZkYyaZ9eRH7lPuqq6SgLUicCD9lRdxYNsUCfsRJDzi8/eNdJGy1h42JvXMeRwnTFxGNMOw73ZZEZ39J6w3Vay4aVbemYpkiv7jY/qMPztCSY91pVF/CMjB79NZvbudPnFL5qzzr+fpb4vT/KmHOZZ2oj8VuiffRmwKq86xxZ7aL0c8tNlyKhfBmqIvTz2n2TP+afOxdv8CGWyAHQqdk2v+nkSOxh1P0UPoM7uqJptMdP40Q1XtvWkaRqJUJ8ikQAJ7X1Wtbwsk/oqron45q01MHGaLpEJ+X68x62QBv3puW/RD0Jq6XP2eSPhdEvYahG1d9ygxgcSRBfEAxX4ksWcbOE94S2Zuhua7jrt7g30Fqqy7tfXnzDMaEH7CVQLrhkKs9riCAs5i69SGgkVZI5DCK3+/OsBjBW08XatTY7mbU/12CRcAD4/o+/1A/iu11TAc9vYYCNu1bbAimS8fov4d3yANHoCJi8YJELmyCTmVOJUzM90K1pPZDONbCVp98eqj9HHqPDCou9uP6BoiZJAak1BV2fQ4Uswi6FN2wwMgdKn4G26deu3b/1xQ4Uuq22n1F5KgSdSDPJOQ6sZEw45chI2rDoHLxgMbBoczfnWtI8lSSmxFFzjmYwO
 4a+enLWK
 Cbz/G2sj5LgFP210uf7y15Obmn8bu0TyU3LwLs6HfnUPE1uUbRaSccfRf6MwXnyp5y7W6STjvjt8+rQbz7TP8ByV7sMQyyFgZZfxwUq8tlqiB6oUHpIVtqNm1kmdWgeIDu5nfH3FStzTPsrgjAHVD3/nDN1Y2zvGKVAA5f7OlFFCYPc8dxhZwbIFnCOqvvRl1MWJxab0mcgGtLatJNdRC33skxaERGUi4jGwXCoORe+lcPUXPhI6niUxoTrDdFQGEGavqKSaa4zu1oRQPR0IttU+sfSFKcOJC6wu1XwCsY66nUZiCI3L6lNc3L34VM4RKuy+YdolWE8puYkk2gMjY4jk/mxWgGUBcH/r5yrM6NfnzDoqKrORLGDMTzFaK/G3qauSUwD+ASWkTKeLMBbbsuweZ5JjuKUaCLx/2dYYl9IYE67IEcdjWguExkWbWNGF4dBbT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() and guard(rcu)
pairs combined with for_each_process(), for_each_thread() and
for_each_process_thread() loops across kernel/ with the
for_each_*_rculock() macros, which scope the RCU read lock to the
loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
---
Changes in v2:
  - Rename *_rcu to *_rculock
  - Rename stale 'unlock:' label to 'out:' in hung_task.c (Günther Noack)
 kernel/cpu.c             |  4 +---
 kernel/freezer.c         |  4 +---
 kernel/hung_task.c       | 11 ++++-------
 kernel/locking/lockdep.c |  4 +---
 kernel/rcu/update.c      |  4 +---
 kernel/sched/core.c      |  3 +--
 kernel/sched/debug.c     |  4 +---
 kernel/trace/fgraph.c    |  8 ++------
 kernel/unwind/deferred.c |  3 +--
 9 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index b3c8553d7bd6..00638d2abc0f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1254,8 +1254,7 @@ void clear_tasks_mm_cpumask(int cpu)
 	 * full-fledged tasklist_lock.
 	 */
 	WARN_ON(cpu_online(cpu));
-	rcu_read_lock();
-	for_each_process(p) {
+	for_each_process_rculock(p) {
 		struct task_struct *t;
 
 		/*
@@ -1268,7 +1267,6 @@ void clear_tasks_mm_cpumask(int cpu)
 		arch_clear_mm_cpumask_cpu(cpu, t->mm);
 		task_unlock(t);
 	}
-	rcu_read_unlock();
 }
 
 /* Take this CPU down. */
diff --git a/kernel/freezer.c b/kernel/freezer.c
index a76bf957fb32..7a870f71dcf6 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -217,11 +217,9 @@ void thaw_process(struct task_struct *p)
 {
 	struct task_struct *t;
 
-	rcu_read_lock();
-	for_each_thread(p, t) {
+	for_each_thread_rculock(p, t) {
 		__thaw_task(t);
 	}
-	rcu_read_unlock();
 }
 
 /**
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 6fcc94ce4ca9..73a5ad3be9a8 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -315,13 +315,12 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 		return;
 
 	this_round_count = 0;
-	rcu_read_lock();
-	for_each_process_thread(g, t) {
+	for_each_process_thread_rculock(g, t) {
 		if (!max_count--)
-			goto unlock;
+			goto out;
 		if (time_after(jiffies, last_break + HUNG_TASK_LOCK_BREAK)) {
 			if (!rcu_lock_break(g, t))
-				goto unlock;
+				goto out;
 			last_break = jiffies;
 		}
 
@@ -337,9 +336,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 			hung_task_info(t, timeout, this_round_count);
 		}
 	}
- unlock:
-	rcu_read_unlock();
-
+out:
 	if (!this_round_count)
 		return;
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c56a7f91d72e..ea218dc75ad5 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -6834,15 +6834,13 @@ void debug_show_all_locks(void)
 	}
 	pr_warn("\nShowing all locks held in the system:\n");
 
-	rcu_read_lock();
-	for_each_process_thread(g, p) {
+	for_each_process_thread_rculock(g, p) {
 		if (!p->lockdep_depth)
 			continue;
 		lockdep_print_held_locks(p);
 		touch_nmi_watchdog();
 		touch_all_softlockup_watchdogs();
 	}
-	rcu_read_unlock();
 
 	pr_warn("\n");
 	pr_warn("=============================================\n\n");
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 2a778b8ab4ad..d8e0b5896db9 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -548,15 +548,13 @@ void synchronize_rcu_trivial_preempt(void)
 	struct task_struct *t;
 
 	smp_mb(); // Order prior accesses before grace-period start.
-	rcu_read_lock(); // Protect task list.
-	for_each_process_thread(g, t) {
+	for_each_process_thread_rculock(g, t) {
 		if (t == current)
 			continue;  // Don't deadlock on ourselves!
 		// Order later rcu_read_lock() on other tasks after QS.
 		while (smp_load_acquire(&t->rcu_trivial_preempt_nesting))
 			continue;
 	}
-	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_trivial_preempt);
 #endif // #if IS_ENABLED(CONFIG_TRIVIAL_PREEMPT_RCU)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0697ed0f1c3d..fd5bdd2cb798 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2005,8 +2005,7 @@ static void uclamp_sync_util_min_rt_default(void)
 	smp_mb__after_spinlock();
 	read_unlock(&tasklist_lock);
 
-	guard(rcu)();
-	for_each_process_thread(g, p)
+	for_each_process_thread_rculock(g, p)
 		uclamp_update_util_min_rt_default(p);
 }
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 72236db67983..cdae165b98f7 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1029,14 +1029,12 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 #endif
 		   "\n");
 
-	rcu_read_lock();
-	for_each_process_thread(g, p) {
+	for_each_process_thread_rculock(g, p) {
 		if (task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
 	}
-	rcu_read_unlock();
 }
 
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 40d373d65f9b..f797ce119223 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1057,11 +1057,10 @@ static int alloc_retstack_tasklist(unsigned long **ret_stack_list)
 		}
 	}
 
-	rcu_read_lock();
-	for_each_process_thread(g, t) {
+	for_each_process_thread_rculock(g, t) {
 		if (start == end) {
 			ret = -EAGAIN;
-			goto unlock;
+			goto free;
 		}
 
 		if (t->ret_stack == NULL) {
@@ -1074,9 +1073,6 @@ static int alloc_retstack_tasklist(unsigned long **ret_stack_list)
 			t->ret_stack = ret_stack_list[start++];
 		}
 	}
-
-unlock:
-	rcu_read_unlock();
 free:
 	for (i = start; i < end; i++)
 		kmem_cache_free(fgraph_stack_cachep, ret_stack_list[i]);
diff --git a/kernel/unwind/deferred.c b/kernel/unwind/deferred.c
index 5bea47314254..ecfe1336095e 100644
--- a/kernel/unwind/deferred.c
+++ b/kernel/unwind/deferred.c
@@ -319,9 +319,8 @@ void unwind_deferred_cancel(struct unwind_work *work)
 
 	synchronize_srcu(&unwind_srcu);
 
-	guard(rcu)();
 	/* Clear this bit from all threads */
-	for_each_process_thread(g, t) {
+	for_each_process_thread_rculock(g, t) {
 		atomic_long_andnot(BIT(bit),
 				   &t->unwind_info.unwind_mask);
 		if (t->unwind_info.cache)
-- 
2.25.1


