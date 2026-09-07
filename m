Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A6BC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13F86B009E; Mon,  7 Sep 2026 08:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB946B009F; Mon,  7 Sep 2026 08:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28696B00A0; Mon,  7 Sep 2026 08:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD0966B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:21:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C21416013C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:21:10 +0000 (UTC)
X-FDA: 85186875900.14.1D33A9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 89E342000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:21:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bHCkg4gb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788783668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RafqFe1zOQfVX4I3+CvQ7y72wqiedDGCRPziRNypvU=;
	b=cVxISRu7Fl9jcs/nfHKcK90ySx25TS1F6RSpxMYWW9+SxsoZK9jW9/PGlCRWwqT6rXqsVV
	nlDqMx1qiwY76ybX2nbKI5cmoxqNJRwTqGaHyXgn/zthYYP0/SaDsYytJQHw/QvSjKoVXc
	nEWYkIeG09msrB5nwlzl5yrngJTdBv4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bHCkg4gb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788783668;
	b=G52lpMiV9lHkg7mKXOS7g0YZJ/QvsXvHdSFBMbv7JU6gGKfSEP4HairPX18R8PaV1E9OWE
	2JMemC2/TIYcAIAIQhkq6a2hqdN1qbnLWHbuRWcvtRJKO0FX3ql8mBVBZBaFN/i/l0sST4
	es2cr0rm59Of8ElGyajX4pNi637FElM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 013ED60AB5;
	Mon,  7 Sep 2026 12:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71C81F00A3A;
	Mon,  7 Sep 2026 12:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788783667;
	bh=6RafqFe1zOQfVX4I3+CvQ7y72wqiedDGCRPziRNypvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bHCkg4gbtV4fR2YXJbmLmuc4792CiiwMkkiRBQHsBe3wK55pXp+8DhreyLDcaIbMw
	 +XMz1qywEjymPY3Ej4XpuBzolt+eJO+nukbZ7CXCsQNU26wwPA1iXIhTSrRLpbGDix
	 fwWR2FArhe/UEy7m95AYiCBVgXqtLK4g9V7jnUSj20xaBegsmmoK4Eg5QF6p25qKod
	 FvDJ/mDhse/p+LJ4rbaxHYb1QC5RLLos4JcnAt7VH2IvwsAiCyGi4lzj9mRyvxW/JA
	 h+bvh9R1HO3HUjIq8DKQveOiIQHs0vc3Dpq6Hwle2VPzfsPQD/3qCXSkt6Tz4Wm3Zg
	 Y31OxqU9Ezkow==
Date: Mon, 7 Sep 2026 13:20:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Thomas Gleixner <tglx@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>, 
	Michal Hocko <mhocko@suse.com>, mic@digikod.net, oleg@redhat.com, david@kernel.org, 
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, gnoack3000@gmail.com, sj@kernel.org, 
	rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap6d3zuVsJiLkrpr@gremlin>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260907081334.1152889-6-ye.liu@linux.dev>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: um185dgbh7pmziozw16rau67b7kfptqk
X-Rspamd-Queue-Id: 89E342000C
X-HE-Tag: 1788783668-736314
X-HE-Meta: U2FsdGVkX1+pghBnEwRQfcSf07o7tZ8fgm/CiN/K3FhHZYSXjERmOF/hzLydZqRq6K0Q3xjKFvS3LU3MkQ93XTlMDligsCdlFoSIiFmaH6LTmx5Hd6a6ie6HhygNyUW0QM2HcgCZkVoKFf2A6QbqII3trJ/+oYz5hkWAoQV/FXNFhaEuF/lqZqsbSlhf8IPI3B7JqoO0SZggDjTFA24/0wC08h3nRdKlSWS73p1xFSqTloMiD6Vk1+kde+xmsW662hIWbxEOGhBHiAzCC/cL/nqIk8T+V8fWqOubZvAo4iZPXWOru+aXS/XDQLe6Q3D8BcisbZHgwntOp9BtjFlHr6GhBOZkDMQH9mJPKm824NwCTrSkHR0t6+kMw9gNsiDjsgBWO/oxdhD1zebggEnNxakcEvpIVc0HG2r2XAk6psIZS/VvC5xDA7UiL73z5+mmjIUPAXtpzr2RAVNr9Y40LW0aNrIR7yzW2Vaq6JqT6hu2MTOyhMaipKPmxjf7JlwjdQ5cElweLGQm4bIuOnJeVHtMniyBUWPkD76VhqfUQXDjPhNSGwslIUNcvnyraJUumgP4svjay12IVoTVWYrl1GlUx8dG260f017NOuTFDx7jacraNj4jK33KiTHXlFxROriGEqUdEoW6j5O3NLHxpuoq7uFzRNJTtpD8wAe+mwXS6J90ocWMdqh68ybhSP/VcHvB2eyM/tpr1Na/ocwAMJU3GOOlHSVKkYXKUH6H34lIORtnfJ6xo9BqI/fgDpP7luUBsk3yToc3ZO/pUjir+gcOhYinFzuxrVEJZ5cVB6d8t/BYVm4HZRLigv5i7trxItspXnP+PtZlPxlcYelM888f4d+rf1wn0F6g0cNi8tUWUKhPm0IAllTXiJRkdH6wsiJdDd1PwCxvbnJwGRufprMuvdIgNNstcg6R5nuQVexDi9TvcyDxuIeJbn64lv5HMShNvywjNxTdQ5ItrRk
 EtL+hzrK
 yx1LRJEtGyYE1wlMNCyj0JaXPAAK1MaqNFh/bd3+IST0yNKzyc5lN/sDHDyH5ML8/wW45vIZJojdqHIiHxwtM6z9bIwr6gdpUCjHllbetP3F3K5Bd27T/vyfZkpMePSgWuCVcibiGeAwnCOT/NR68IyChXo7DPUDYuF8d0RDheZVhoS/BMGII8UqAldKfgmUegQZgzZqYguxjDinCP0z+mnvfA8pmM2jllsrNUgk7hx4/2UmL3tbbMTLDFm55FfaUGjjIUa/ed5d55fnQV8l8PjBKLs6qEbaBKICq5IeH7rVqZwp50tgKb4E5wXXDtgBFVsZy995HZ8gV46Nn0fa3mucrjYfbZr0jM5nncXyRqyYXKf6o0gG9W2vG4VEME6ZUTE3Pl+2vY4F+/nlJ9M1sfXJ2KGm28wNgvRUYBkCwUBFvIScfd+rFXmY/C1PhuAhHw7bT3mTpTWCzBLlSwNDOXOGXVmsh7SUUsddY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:31PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Replace the manual rcu_read_lock()/rcu_read_unlock() and guard(rcu)
> pairs combined with for_each_process(), for_each_thread() and
> for_each_process_thread() loops across kernel/ with the
> for_each_*_rculock() macros, which scope the RCU read lock to the
> loop body via scoped_guard(rcu).
>
> No functional change.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v2:
>   - Rename *_rcu to *_rculock
>   - Rename stale 'unlock:' label to 'out:' in hung_task.c (Günther Noack)
>  kernel/cpu.c             |  4 +---
>  kernel/freezer.c         |  4 +---
>  kernel/hung_task.c       | 11 ++++-------
>  kernel/locking/lockdep.c |  4 +---
>  kernel/rcu/update.c      |  4 +---
>  kernel/sched/core.c      |  3 +--
>  kernel/sched/debug.c     |  4 +---
>  kernel/trace/fgraph.c    |  8 ++------
>  kernel/unwind/deferred.c |  3 +--
>  9 files changed, 13 insertions(+), 32 deletions(-)
>
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index b3c8553d7bd6..00638d2abc0f 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -1254,8 +1254,7 @@ void clear_tasks_mm_cpumask(int cpu)
>  	 * full-fledged tasklist_lock.
>  	 */
>  	WARN_ON(cpu_online(cpu));
> -	rcu_read_lock();
> -	for_each_process(p) {
> +	for_each_process_rculock(p) {
>  		struct task_struct *t;
>
>  		/*
> @@ -1268,7 +1267,6 @@ void clear_tasks_mm_cpumask(int cpu)
>  		arch_clear_mm_cpumask_cpu(cpu, t->mm);
>  		task_unlock(t);
>  	}
> -	rcu_read_unlock();
>  }
>
>  /* Take this CPU down. */
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index a76bf957fb32..7a870f71dcf6 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -217,11 +217,9 @@ void thaw_process(struct task_struct *p)
>  {
>  	struct task_struct *t;
>
> -	rcu_read_lock();
> -	for_each_thread(p, t) {
> +	for_each_thread_rculock(p, t) {
>  		__thaw_task(t);
>  	}
> -	rcu_read_unlock();
>  }
>
>  /**
> diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> index 6fcc94ce4ca9..73a5ad3be9a8 100644
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -315,13 +315,12 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
>  		return;
>
>  	this_round_count = 0;
> -	rcu_read_lock();
> -	for_each_process_thread(g, t) {
> +	for_each_process_thread_rculock(g, t) {
>  		if (!max_count--)
> -			goto unlock;
> +			goto out;
>  		if (time_after(jiffies, last_break + HUNG_TASK_LOCK_BREAK)) {
>  			if (!rcu_lock_break(g, t))
> -				goto unlock;
> +				goto out;
>  			last_break = jiffies;
>  		}
>
> @@ -337,9 +336,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
>  			hung_task_info(t, timeout, this_round_count);
>  		}
>  	}
> - unlock:
> -	rcu_read_unlock();
> -
> +out:
>  	if (!this_round_count)
>  		return;
>
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index c56a7f91d72e..ea218dc75ad5 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -6834,15 +6834,13 @@ void debug_show_all_locks(void)
>  	}
>  	pr_warn("\nShowing all locks held in the system:\n");
>
> -	rcu_read_lock();
> -	for_each_process_thread(g, p) {
> +	for_each_process_thread_rculock(g, p) {
>  		if (!p->lockdep_depth)
>  			continue;
>  		lockdep_print_held_locks(p);
>  		touch_nmi_watchdog();
>  		touch_all_softlockup_watchdogs();
>  	}
> -	rcu_read_unlock();
>
>  	pr_warn("\n");
>  	pr_warn("=============================================\n\n");
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index 2a778b8ab4ad..d8e0b5896db9 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -548,15 +548,13 @@ void synchronize_rcu_trivial_preempt(void)
>  	struct task_struct *t;
>
>  	smp_mb(); // Order prior accesses before grace-period start.
> -	rcu_read_lock(); // Protect task list.
> -	for_each_process_thread(g, t) {
> +	for_each_process_thread_rculock(g, t) {
>  		if (t == current)
>  			continue;  // Don't deadlock on ourselves!
>  		// Order later rcu_read_lock() on other tasks after QS.
>  		while (smp_load_acquire(&t->rcu_trivial_preempt_nesting))
>  			continue;
>  	}
> -	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL_GPL(synchronize_rcu_trivial_preempt);
>  #endif // #if IS_ENABLED(CONFIG_TRIVIAL_PREEMPT_RCU)
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 0697ed0f1c3d..fd5bdd2cb798 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2005,8 +2005,7 @@ static void uclamp_sync_util_min_rt_default(void)
>  	smp_mb__after_spinlock();
>  	read_unlock(&tasklist_lock);
>
> -	guard(rcu)();
> -	for_each_process_thread(g, p)
> +	for_each_process_thread_rculock(g, p)
>  		uclamp_update_util_min_rt_default(p);
>  }
>
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 72236db67983..cdae165b98f7 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -1029,14 +1029,12 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
>  #endif
>  		   "\n");
>
> -	rcu_read_lock();
> -	for_each_process_thread(g, p) {
> +	for_each_process_thread_rculock(g, p) {
>  		if (task_cpu(p) != rq_cpu)
>  			continue;
>
>  		print_task(m, rq, p);
>  	}
> -	rcu_read_unlock();
>  }
>
>  void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
> diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
> index 40d373d65f9b..f797ce119223 100644
> --- a/kernel/trace/fgraph.c
> +++ b/kernel/trace/fgraph.c
> @@ -1057,11 +1057,10 @@ static int alloc_retstack_tasklist(unsigned long **ret_stack_list)
>  		}
>  	}
>
> -	rcu_read_lock();
> -	for_each_process_thread(g, t) {
> +	for_each_process_thread_rculock(g, t) {
>  		if (start == end) {
>  			ret = -EAGAIN;
> -			goto unlock;
> +			goto free;
>  		}
>
>  		if (t->ret_stack == NULL) {
> @@ -1074,9 +1073,6 @@ static int alloc_retstack_tasklist(unsigned long **ret_stack_list)
>  			t->ret_stack = ret_stack_list[start++];
>  		}
>  	}
> -
> -unlock:
> -	rcu_read_unlock();
>  free:
>  	for (i = start; i < end; i++)
>  		kmem_cache_free(fgraph_stack_cachep, ret_stack_list[i]);
> diff --git a/kernel/unwind/deferred.c b/kernel/unwind/deferred.c
> index 5bea47314254..ecfe1336095e 100644
> --- a/kernel/unwind/deferred.c
> +++ b/kernel/unwind/deferred.c
> @@ -319,9 +319,8 @@ void unwind_deferred_cancel(struct unwind_work *work)
>
>  	synchronize_srcu(&unwind_srcu);
>
> -	guard(rcu)();
>  	/* Clear this bit from all threads */
> -	for_each_process_thread(g, t) {
> +	for_each_process_thread_rculock(g, t) {
>  		atomic_long_andnot(BIT(bit),
>  				   &t->unwind_info.unwind_mask);
>  		if (t->unwind_info.cache)
> --
> 2.25.1
>

--
Cheers, Lorenzo

