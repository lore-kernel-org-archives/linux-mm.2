Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC63606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 03:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MWpJUclY
Received: by kanga.kvack.org (Postfix)
	id 8E58C6B08DF; Tue, 24 Nov 2026 22:36:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8971F6B08E0; Tue, 24 Nov 2026 22:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC226B08E2; Tue, 24 Nov 2026 22:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE2C6B08E0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:36:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E136A0E1D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:36:35 +0000 (UTC)
X-FDA: 85472229150.07.41E87E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5BE49140005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:36:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MWpJUclY;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795577793;
	b=wgovsIBIsdYvkonHjl1oA7i6CkrSuUBPP8/YdaDBJtebqqv/S/suk8I9zoixiVfublkNE2
	ZXPsv583otPHzH/6PMXxRJMgeiN1UQTyPD5WzsX0FQ2k3+JVZ6EUa8ZrsquOoo7kRj3spU
	Sdl/9KZ6V9cpXd1Cvm7Cxe0uECqaGrY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795577793;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/a9HOlzDKclBVIcngPtDurnY3BPZo/KeL8Bm68r1HuU=;
	b=gZXCzW65ZGbuwxkFy1yIRS0xcViwzwIMn+EHcedyYp73Xv+HvE4+o6CmwXOTWhf0sxJwCE
	UiaGxee/tToWEpjjfScus2MjFqjTixlSSaInb1UjTR/6JFkj89s8ygYJ1rDiyL+ZRrd4DP
	ebFxIvcKDsAvRA5UIhNz9IQKoOsB52k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MWpJUclY;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40DB2404FB;
	Wed, 25 Nov 2026 03:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1341F000CA;
	Wed, 25 Nov 2026 03:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795577792;
	bh=/a9HOlzDKclBVIcngPtDurnY3BPZo/KeL8Bm68r1HuU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MWpJUclY4V5cnSvH+UPmpbHbqrHyvnjsaa9P6zHEVgP2dtpQViiQ/Ml88r7go/70S
	 /dyxxfgDggOiTIBseAbKHturaPzT+ZRQ7MXrXNZ6CM3Hmu0l+KYTnN7Ye6vFa7ofFw
	 8PYBkyFvKCGvSw3FVzyJhpRyNeTWy6EuEf6etzps1iiMwSTt8gvGM4szCGpKMuh0fZ
	 sVy6SZkHhjL539VAQL9r0okkLumeZ4/z1t79a9E6qY3DRyhwEvTQ/JVgP7Gas9XRX/
	 VtkvbCnpLKSbJTPVwr7bI0OwKYPKoWmYKqqAIm/QCbBO2PgivbUCY+3beBQ4lja8AI
	 RuUmbwYg6m0OQ==
Message-ID: <sashiko-outbox-232471@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] cgroup: list a process whose leader has exited
 where its threads are
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhan Xusheng" <zhanxusheng1024@gmail.com>, tj@kernel.org
Cc: hannes@cmpxchg.org, mkoutny@suse.com, mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, kolyshkin@gmail.com, chris@chrisdown.name, linux-mm@kvack.org, zhanxusheng@xiaomi.com
In-Reply-To: <20261124033547.2373352-2-zhanxusheng1024@gmail.com>
References: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
 <20261124033547.2373352-2-zhanxusheng1024@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 03:36:31 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5BE49140005
X-Stat-Signature: 5ey7z6sguzxxbw1zec56hsjen8yxjw8m
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795577793-730177
X-HE-Meta: U2FsdGVkX18t1LfOqQzbmSUN69oyNF5RTwAHLqbu+bhtfZfl/zL3JB1A3N7wjqYxg5QrGGgWjBnjV1xMgG8ubR7hTusUAE4EScKfTytJbLsw28IdfY8AyJGbkeysKBMj9elruIZTn5ctAKJqogtaK1CJjhvKXtMrSBxDKQeKqFUylFdn2L/CG2V19xadW8eDTMXzpFiKPTEwcz/AVgotcfXlNeccXe73mslVKmJDHBgGx8n5kW1vTWVmAeoe6fyna3n4vHTJb9wxdDDicw3HHnHfthQyBxnsWju4/VSpqJjAM0c8/wAkmXv6nOmjSiZZLXnnU9TnAF+uOVj6vUPo5DXEUVrIVQTsDj3bOGdI7f+dvl8ZzgiAPkEb9aR3agoaMmpD3oX1UuktQ0C9j97ewarfWbZ91kQpL/GASrwBjxPOQPdScltgC0F6roXMukKOm+UUti9RcW7k2+3Z80oMdKgjnCPdalm0nkA50O2KRRTcsCFbIHtF35gj3rVmSn4MoFAP3AAGrpj7jt4+TW2HmKnVsJqXNNN6gjNZDPEAGadIl9haXutDIoibgEsO616QQCT/xCy7c92VMBvl68Ulsp6XIdhTWfolqe/nGpqn/UzUxleQKmvRV4KO+lrHaL0SytE133Ul9ImQt4GXjhBJwQiKXd+39o7L/bOeR16OGvDUNKkkFocQYF6cDb/Co+vxZ+mrB8NNH/k5nm9kRZBKxsqxtJuePOj4EFWu3yn9Ti475URPPhfE5YTvS7TpRESeWt8D4shMWQSIWli77D74JYxcRT8Uj4Bz/2wfO1vdaxnvutkIrQNZ0AVIt3t8p+uvo0qoWdjNty3B5tA+b250MdxaBNh9JFWAMTssqmW4nqA6NU7yXfzXscDx9RRWSbFY3lHM9iFBJqpibj0BrNAM5nMHomq/yD/0B7BaZwUklltjR4o49qGSZHw8AccfWEnyvsy/CZOcRc1rH0guHRy
 Vm3mkrej
 0Ixh8GNkB+yylq4Nk3AC8tLQBso8JLGKqf/f2j1FC+MuyaRUHJLKuMRn7Z/AEHJhPpmGypvAOqowkr4FnK7SO8X97ff6f1vLhLbEgbbDW9YzpmuD89eKiIiTODkxXE8KlQuSTcfD/UYws4/BOGhycjxlQyniiCl/w/GGSsqg8FgY43XaWizDh/qf0z5r47d25JFt0tCLhyHyfUYInoycs9vZsV4NU364oZIx9m4yGpPRLaEn/Bv6Adsv/ohnPUOR6Jirj0OhTZmKVMg6r9Zxu5lDd2DosGdaY2ilTpcshat8yveSiMyyT1HAon9HpdVPH4vlhhhyVtHgaIyEPsepQqbbvPoXeE/k2PkA+I+SwRZcu1Ia/ay1NLms92K6dL15KLeLYtZMFkOKl8zMsl6VXgNQsEUixWRk7W5tvwO001WmnoNToc79FlxO/2/Rp8wB8C1SeL05X0XEg+nlpaTSOv3EbOAd5nwtigk9+MP+fYDx5cXfTL8kiRLYYUKHDifgWjj/AUOQhPTzS8xXNsjvSHgmTJARN7R11/lVqz6GPAd5v31LOHF6gg0wk9a0pKC5CA1qTf17aEZGDjIT+gwKG1Izfha8vAvrfoqWoJ2H02XsxxgLAdOEnxcFG8HEfTFFpkH4LhG6HdAoWrMN3zk7JRoufOcAIbNbla8hVVWUTp/Qhp6VEiTBZJy7IW1nhyo4CNEqToswA+ADFlvi2UYOgbZHxdlQbC8LdQWF2fR1fDFW5oz35O86QviqvjajizzOPp+efMuD20mNY4TgUULVlmKX0Up7pf8xPl9bUoI64KB38oMLT0sDnUEqP0ncYy4gOLCDig5W1W47JQGyr6YGMx/j7Og3zU/gi3BA8bPJKLkZdlpA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] cgroup: use-after-free on group_leader in css_task_iter_next()
  and procs_stand_in()
- [Medium] cgroup: missing cg_leader_left update in
  cgroup_update_dfl_csses()
- [Medium] cgroup: __cgroup_procs_write() checks permissions against
  left-behind leader cgroup
- [Medium] cgroup: quadratic thread traversal under css_set_lock in
  procs_stand_in()
- [Low] cgroup: procs_live_thread() fallback to leader resurrects
  process in old cgroup
--

commit e947916a597995307d4cc64d14f765928b1b3027
Author: Zhan Xusheng <zhanxusheng@xiaomi.com>

cgroup: list a process whose leader has exited where its threads are

This commit visits a thread group leader that was left behind during a
cgroup.procs migration at the first live thread of the process during
CSS_TASK_ITER_PROCS walks.

Link: https://lore.kernel.org/all/305c5803b904a57c188b505d6ed9e1e4@kernel.o=
rg/

> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index b3657e72db99e..ab442f94e29d2 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3081,6 +3081,9 @@ int cgroup_migrate(struct task_struct *leader, bool=
 threadgroup,
>  		if (!threadgroup)
>  			break;
>  	} while_each_thread(leader, task);
> +	/* see procs_live_thread() */
> +	if (threadgroup && (leader->flags & PF_EXITING))
> +		WRITE_ONCE(leader->cg_leader_left, true);
>  	spin_unlock_irq(&css_set_lock);
> =20
>  	return cgroup_migrate_execute(mgctx);

[Severity: Medium]
Does setting cg_leader_left only in cgroup_migrate() miss migrations driven
by cgroup_update_dfl_csses() and cgroup_transfer_tasks()?

When a controller such as memory is enabled or disabled via
cgroup.subtree_control, cgroup_update_dfl_csses() calls
cgroup_migrate_add_task() and cgroup_migrate_execute() directly without
going through cgroup_migrate().  If a process in a descendant cgroup
already has an exited leader, the live threads move to the new css_set
while the leader stays on the old css_set with cg_leader_left still false,
so controller-scoped CSS_TASK_ITER_PROCS walks such as
mem_cgroup_scan_tasks() will still miss the process.

Should __cgroup_procs_write() also resolve src_cgrp from the live thread's
css_set rather than task_cgroup_from_root(task, &cgrp_dfl_root)?  For
threadgroup migrations, task is the group leader, so after one migration
leaves the exited leader behind, a second cgroup.procs migration checks
cgroup_attach_permissions() against the stale cgroup where the leader
exited rather than the cgroup currently holding the live threads.

> @@ -5200,6 +5203,40 @@ static void css_task_iter_skip(struct css_task_ite=
r *it,
>  	}
>  }
> =20
> +/*
> + * A cgroup.procs migration skips a leader that is already exiting, as t=
he
> + * controllers don't deal with exiting tasks, so the leader stays on its
> + * css_set while the rest of its process moves.  CSS_TASK_ITER_PROCS wal=
ks
> + * visit such a leader at the first live thread of the process instead, =
if
> + * that thread is on a different css_set.
> + *
> + * PF_EXITING isn't set under css_set_lock, so a walk that races with a
> + * thread starting to exit may visit the process twice or miss it.
> + */
> +static struct task_struct *procs_live_thread(struct task_struct *leader)
> +{
> +	struct task_struct *t;
> +
> +	if (!READ_ONCE(leader->cg_leader_left))
> +		return leader;
> +
> +	for_each_thread(leader, t) {\n> +		if (!(t->flags & PF_EXITING)) {
> +			if (task_css_set(t) =3D=3D task_css_set(leader))
> +				return leader;
> +			return t;
> +		}
> +	}
> +	return leader;
> +}

[Severity: Low]
When the last live thread of a migrated process enters do_exit(), can
falling back to returning leader at the end of procs_live_thread() make the
process transiently reappear in its old cgroup?

In exit_signals(), a dying thread sets PF_EXITING before decrementing
signal->live.  If a CSS_TASK_ITER_PROCS walk on the old cgroup visits the
left-behind leader on dying_tasks during that window, every thread already
has PF_EXITING set while signal->live is still non-zero, so
procs_live_thread(leader) returns leader and css_task_iter_advance() does
not skip it.

> +
> +static bool procs_stand_in(struct task_struct *task)
> +{
> +	struct task_struct *leader =3D task->group_leader;
> +
> +	return leader !=3D task && procs_live_thread(leader) =3D=3D task;
> +}

[Severity: Medium]
Can calling procs_stand_in() for every non-leader thread cause quadratic
thread-list traversal under css_set_lock?

When an N-thread process with cg_leader_left set is exiting, threads that
have set PF_EXITING in exit_signals() remain on cset->tasks and
signal->thread_head until they pass exit_notify() and do_cgroup_task_dead().
Because neither css_task_iter_advance() nor procs_stand_in() filters out
tasks with PF_EXITING or tasks on the same css_set as their leader before
calling procs_live_thread(leader), a single css_task_iter_advance() call
under spin_lock_irqsave(&css_set_lock) walks all N threads on cset->tasks
and rescans across the exiting threads at the head of signal->thread_head
each time.  In addition, cgroup_migrate() sets cg_leader_left even when no
tasks move or cgroup_migrate_execute() fails, enabling this scan when all
threads are still on the leader's css_set.

> +
>  static void css_task_iter_advance(struct css_task_iter *it)
>  {
>  	struct task_struct *task;
> @@ -5246,8 +5283,18 @@ static void css_task_iter_advance(struct css_task_=
iter *it)
>  		goto repeat;
> =20
>  	if (it->flags & CSS_TASK_ITER_PROCS) {
> -		/* if PROCS, skip over tasks which aren't group leaders */
> -		if (!thread_group_leader(task))
> +		/*
> +		 * If PROCS, skip over tasks which aren't group leaders, except
> +		 * for the thread a left-behind leader is visited at.
> +		 */
> +		if (!thread_group_leader(task)) {
> +			if (!procs_stand_in(task))
> +				goto repeat;
> +			return;
> +		}
> +
> +		/* and leaders visited at another thread */
> +		if (procs_live_thread(task) !=3D task)
>  			goto repeat;
> =20
>  		/* and dying leaders w/o live member threads */
> @@ -5322,6 +5369,9 @@ struct task_struct *css_task_iter_next(struct css_t=
ask_iter *it)
>  	while (it->task_pos && !it->cur_task) {
>  		it->cur_task =3D list_entry(it->task_pos, struct task_struct,
>  					  cg_list);
> +		/* a left-behind leader is visited at a live thread */
> +		if (it->flags & CSS_TASK_ITER_PROCS)
> +			it->cur_task =3D it->cur_task->group_leader;
>  		/* a task on dying_tasks with zero refcount is only valid for
>  		 * RCU readers, not even interesting for
>  		 * CSS_TASK_ITER_WITH_DEAD, find another one */

[Severity: High]
Can css_task_iter_next() and procs_stand_in() dereference a freed
group_leader after the stand-in thread exits?

A non-leader thread T does not hold a reference on its group_leader L, and
T->cg_list remains linked on dst_cset->tasks until the end of do_exit() in
do_task_dead() -> cgroup_task_dead() (or the deferred irq_work on
CONFIG_PREEMPT_RT).  Once T passes release_task(T) -> __exit_signal(T), L
can be reaped and RCU-freed while T is still on dst_cset->tasks, while
cgroup_task_free(L) only skips iterators on L's own src_cset:

CPU0                                  CPU1
css_task_iter_start()
  css_task_iter_advance()
    /* parks it->task_pos at T */
  spin_unlock_irqrestore(&css_set_lock)
                                      do_exit() /* last live thread T */
                                        exit_notify()
                                          release_task(T)
                                          /* zap_leader or parent wait */
                                          release_task(L)
                                            put_task_struct_rcu_user(L)
                                        /* RCU grace period elapses */
                                        delayed_put_task_struct(L)
                                          free_task(L)
css_task_iter_next()
  spin_lock_irqsave(&css_set_lock)
  it->cur_task =3D T->group_leader
  tryget_task_struct(L)  <-- use-after-free

The same stale T->group_leader is also dereferenced in
css_task_iter_advance() -> procs_stand_in(T) -> procs_live_thread(L) if a
sibling thread T2 calls execve() -> de_thread() after T passes
__exit_signal(T): de_thread() reaps and RCU-frees L without updating
T->group_leader (because T was already unlinked from signal->thread_head),
and signal->live remains non-zero because T2 is alive, so
css_task_iter_advance() does not skip T before calling procs_stand_in(T).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124033547.2373=
352-1-zhanxusheng1024@gmail.com?part=3D1

