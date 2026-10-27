Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF4660A380D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=McZtdrTo
Received: by kanga.kvack.org (Postfix)
	id E7FA56B05D5; Tue, 27 Oct 2026 08:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57246B05D8; Tue, 27 Oct 2026 08:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93FD6B05D9; Tue, 27 Oct 2026 08:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B00646B05D5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:03:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4626BC09A8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:03:08 +0000 (UTC)
X-FDA: 85368270456.15.0AE2B2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9D6BB40007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:03:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=McZtdrTo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793102586;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gsm8FCTfYMjJ9X/qLkjkV5oaQ/Rkh0bb8SRkihyvQKE=;
	b=a99w+1WVCrusY/zF93VFnVO/aYVFwi+C1BdWHnylq8cmO2Y+IWSoSyy++cOt6OEISRUj7B
	zVJyEOlaNT2WU3rnAsSMUFvyhRXiJBQrI9o9+quJmQ/iJ/CqhNTR6LjCQxZbjGurcnMTW7
	lIFwamXwWGQvMQ1EuV9FpqEj4NFHlWY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=McZtdrTo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793102586;
	b=ZEUs7sWu8wulcpK5jLHbEa4Bo1KMMax5AVE5EVBO7miGrczFa6lc1xGsdfSlPkKg0jlpkF
	oNAH13ZgfJ4jdpezIxu5LerTR5IiSmmnRRHrt5FMPKeQN2AyCbwXHGBQ3F8bpaJF/h4bVT
	yshcmC4dMCbQlVZ+UURnTzZvxRD6iJk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 159166021D;
	Tue, 27 Oct 2026 12:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB9D1F01825;
	Tue, 27 Oct 2026 12:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793102585;
	bh=Gsm8FCTfYMjJ9X/qLkjkV5oaQ/Rkh0bb8SRkihyvQKE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=McZtdrToE8CDK2o9wG4UlcFC4ijx8Vo4p8T2oQyeTtP3EpgIyosiRVwaL+ENbj3q8
	 1CZIjXolREOa3uTRxJJhBZgl6TQuM5qdOeZceeL6k0UkiLwrQUfPN54zDMmfjt+Gel
	 5WuYf/QpwYpTBuGXhAYUjF1qrg5w61SYNE2hGZRJ5kBvog+Pn/HYNMwLT0moOwEhAP
	 0Wcg+7FX8rPqloHYXtuS2T+LUFjy0ATuXrvvvy7ZgJQwej8CwpiMfGSnVnKc3iQSgP
	 X21CwczMBVXHhpr2METiXzJqU4usmHRR096+/JX7ACulVEudiOboyo/UKPKm54PblM
	 rfXuAYv42txYw==
Message-ID: <sashiko-outbox-186496@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhan Xusheng" <zhanxusheng1024@gmail.com>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, penguin-kernel@I-love.SAKURA.ne.jp, tj@kernel.org, mkoutny@suse.com, linux-mm@kvack.org, zhanxusheng@xiaomi.com
In-Reply-To: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
References: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 12:03:04 +0000
X-Rspamd-Queue-Id: 9D6BB40007
X-Stat-Signature: oeqboaweu91hs7ewqydaxifwukm9ax76
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793102586-642924
X-HE-Meta: U2FsdGVkX18x47izE/6WWxAPLX+OWlMrT/wEM+xVm69xusvJRVOcHPdoXyXVv6j8rTedkzp4WmI+6WCkNY4HIKUm0tuZoYgg5ynW7B2yofDKUyES8r55hzzgyj+6QNUbNJPCkYk0v0ntoW+bfi0yD6Jy5689CXdvuxBBoUxWDySRexi4tUH4cOPuPqMV4jpwnKTWlbJUQFY4VYbwxJNt395588OlBCsuO0TN2PJ5+vy/OzBfUEVUBaiPZaHGmTcyElWjNbYrLDGOK1Jw+PjP5tsundwWTDDdUYu+sdQnWGZCt0OZZ6dGJLStY5Ne9+h4wvB0jUeIqVLUPVm7upz8k1vtP0HeLf2aDNlZIw9POrpBP419pyWnS22mH54FTF5sBlYqJvzdv6ayq1/TdiMBWSxjKZuSyESOqWuaaZX0kh1De3LVEAXI8MVXbQQcKZTyBCamBAcQkFUOuN/fqBFfC4ktD00/qnwE8aJHzyMvJIsn80niL+3/Is6TA5WIx6v+QATTRE7EjEEylDuLXr1BuYSZZVkvqMp99cGUJO3vMeEBk7OfVzVDmmR60wvNnx5UTD+HhIODxQrjfDx2g/1Na4adgH6bQsEnonEd2GaKUp4NRdMxrJMbonIT/DLbN9if+RBtZ1sd9sB/RuApkYKSzTFmN5XPFwh0rlgrZULoEiCZuWS+Qf2PlVGNwdlwDf6xBXfE1PSZ/Jgp60VOMjeRPb/vja/lL8C/wbQqhQOT2RC64FjGp8Yi9/jlxLpCCI/Nn+l6lShIwm/2E1xWxAin9U7cNUlRNfBhNdW98dhdZOehYP/fR+EEuL2clUb3GmNE/t48f9wESI2P3P2P9ochYEZpn86dYQCNClntzpBiE9QPoKVz3zxzCu1r+KEbL+3STc0C6dtUUrP/jBtGsDo39KpIi9+3s3uIQaYHlXazBpN+5IhJDZGqAgFnRlDrMp40pEEotoPaIhTNvcsrj/A
 bZf8kIZA
 OLCS8IbzaSM19R3z1/tRNGcAkDQNtFKECSIpahAfe9nc4WU0uusNQ//wwMrTLKUgtumyw3Em01GoGiPqnGLnbveLb4cES9NciEqFYsVQDEohCQdJDi59zAezS77NNpNxfCgXrlLQSOwSCDCmg1xZkr7Lh1QJt1q+SHoBBrGEBVo77wI/XsqD6vCCWNEFExwzTjNPC9BAKJn637UCvUw//suMCrlxSn8TK+U8lvFEBzivqcdQqJvGk3SnbbV2vN3gnA9ODckD7cc1VzsBhj+H5fRYdeIFKrBAA9lbCNkHdmr+ufyDlD/DQyscTwuHo03cazcUW4rMJEIDjdyUsEYH9gXZestXhYZdbR30tuSWsBnM1P56TJpO0RaW3+HAhzTQN2uRSSXqjFhhw8tHdq3ny14RqkO06wBg85443nbqYCsf0u+Mv5+2TYGkrJzXvRA9esRX90NXQN+E2YJSENnmjcnTR+8VidNWprP3TZXkVpG0XevwKyff+0xbCBjtHZdwor3FZzd6dfUO54rUjTf0+gHfVU38LAsul19a/zzSiA63YltIMCTKUp0M5XHei5R4RaOKiQb29OecUPhYkDee5LEw+xwcE/XQqw/8vWwZZqdrKt1V19rvW7x208N6RwjmziCSMbiadCwvruX5xA2TQ3etNz5/Z2jjhN2WXg4b6N7imINyoz3nvTi1EJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] mm: memcontrol: use-after-free on group_leader in mem_cgroup_s=
can_skip()
- [High] mm: memcontrol: duplicate or missed process scan in mem_cgroup_sca=
n_skip()
- [High] mm: memcontrol: mem_cgroup_scan_skip() skips exiting OOM victims
--

commit dc2989b6546fee5aa393d439ca588a7e5bf50831
Author: Zhan Xusheng <zhanxusheng@xiaomi.com>

mm: memcontrol: don't miss processes whose leader has exited in OOM scans

This commit changes mem_cgroup_scan_tasks() to iterate over all tasks in a
memory cgroup without CSS_TASK_ITER_PROCS and adds mem_cgroup_scan_skip() to
pick either the thread group leader or the first non-exiting thread when the
leader is exiting.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4d00748c8a5b8..8823c549b6af6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1427,6 +1427,36 @@ static void invalidate_reclaim_iterators(struct me=
m_cgroup *dead_memcg)
>  						dead_memcg);
>  }
> =20
> +/*
> + * Take one task per thread group: the leader, or the first live thread =
once
> + * the leader is exiting, since migrating the group leaves an exiting le=
ader
> + * behind.  Exiting threads are skipped, as one left behind may belong t=
o a
> + * group that has moved out.
> + */
> +static bool mem_cgroup_scan_skip(struct task_struct *task)
> +{
> +	struct task_struct *leader =3D task->group_leader;
> +	struct task_struct *t;
> +	bool skip =3D true;
> +
> +	if (READ_ONCE(task->flags) & PF_EXITING)
> +		return true;

[Severity: High]
Won't unconditionally skipping every task with PF_EXITING set hide in-flight
OOM victims from concurrent OOM scans before they finish releasing their
memory?

When a process is killed by the OOM killer via __oom_kill_process(),
mark_oom_victim() sets task->signal->oom_mm. In do_exit(), each dying thread
sets PF_EXITING in exit_signals() and decrements signal->live before reachi=
ng
exit_mm() -> mmput() -> __mmput() -> exit_mmap(), where the address space is
unmapped and MMF_OOM_SKIP is finally set:

kernel/exit.c:do_exit() {
	exit_signals(tsk);  /* sets PF_EXITING */

	seccomp_filter_release(tsk);

	acct_update_integrals(tsk);
	group_dead =3D atomic_dec_and_test(&tsk->signal->live);
	...
	exit_mm();
}

In mm/oom_kill.c, oom_evaluate_task() relies on mem_cgroup_scan_tasks()
visiting an OOM victim until MMF_OOM_SKIP is set so that concurrent OOM sca=
ns
abort rather than killing another process:

mm/oom_kill.c:oom_evaluate_task() {
	if (!is_sysrq_oom(oc) && tsk_is_oom_victim(task)) {
		if (mm_flags_test(MMF_OOM_SKIP, task->signal->oom_mm))
			goto next;
		goto abort;
	}
}

Once all threads of an OOM victim have passed exit_signals() and set
PF_EXITING (and with css_task_iter_start() called without
CSS_TASK_ITER_WITH_DEAD once signal->live reaches zero),
mem_cgroup_scan_skip() skips every thread of the victim before exit_mmap()
sets MMF_OOM_SKIP. Could this cause select_bad_process() in a concurrent me=
mcg
OOM scan to miss the exiting victim and kill additional processes
unnecessarily?

> +	if (task =3D=3D leader)
> +		return false;
> +	if (!(READ_ONCE(leader->flags) & PF_EXITING))
> +		return true;
> +
> +	rcu_read_lock();
> +	for_each_thread(leader, t) {

[Severity: Critical]
Can this trigger a use-after-free on leader when dereferencing leader->flags
and leader->signal?

In mem_cgroup_scan_tasks(), css_task_iter_next() acquires a reference only =
on
task via tryget_task_struct() and drops css_set_lock before returning task =
in
preemptible context. Holding a reference on a non-leader thread pins task a=
nd
task->signal, but does not pin task->group_leader.

Here, mem_cgroup_scan_skip() reads leader =3D task->group_leader without
rcu_read_lock() or READ_ONCE(), dereferences READ_ONCE(leader->flags) outsi=
de
rcu_read_lock(), and then passes that earlier leader pointer to
for_each_thread(leader, t), which expands to __for_each_thread(leader->sign=
al,
t).

Two races can free leader after task->group_leader is read and before
rcu_read_lock() is acquired:

1. If the non-leader thread task calls execve(), task does not set PF_EXITI=
NG,
and de_thread() replaces group_leader and releases the old leader:

fs/exec.c:de_thread() {
		tsk->group_leader =3D tsk;
		leader->group_leader =3D tsk;
		...
		write_unlock_irq(&tasklist_lock);
		cgroup_threadgroup_change_end(tsk);

		release_task(leader);
}

2. If leader is already in EXIT_ZOMBIE and task exits after passing the
PF_EXITING check in mem_cgroup_scan_skip(), release_task(task) unhashes task
from the thread group and reaps leader via put_task_struct_rcu_user(leader)
even while css_task_iter still holds a usage reference on task:

kernel/exit.c:release_task() {
	leader =3D p->group_leader;
	if (leader !=3D p && thread_group_empty(leader)
			&& leader->exit_state =3D=3D EXIT_ZOMBIE) {
		...
		zap_leader =3D do_notify_parent(leader, leader->exit_signal);
		if (zap_leader)
			leader->exit_state =3D EXIT_DEAD;
	}
	...
	put_task_struct_rcu_user(p);

	p =3D leader;
	if (unlikely(zap_leader))
		goto repeat;
}

If mem_cgroup_scan_skip() is preempted before rcu_read_lock() and an RCU gr=
ace
period elapses, leader is freed before leader->flags and leader->signal are
dereferenced. Should rcu_read_lock() cover the READ_ONCE(task->group_leader)
load and all dereferences of leader?

> +		if (!(READ_ONCE(t->flags) & PF_EXITING)) {
> +			skip =3D t !=3D task;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return skip;
> +}
> +
>  /**
>   * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarc=
hy
>   * @memcg: hierarchy root
> @@ -1452,9 +1482,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memc=
g,
>  		struct css_task_iter it;
>  		struct task_struct *task;
> =20
> -		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
> +		css_task_iter_start(&iter->css, 0, &it);
>  		while (!ret && (task =3D css_task_iter_next(&it))) {
> -			ret =3D fn(task, arg);
> +			if (!mem_cgroup_scan_skip(task))
> +				ret =3D fn(task, arg);
>  			/* Avoid potential softlockup warning */
>  			cond_resched();
>  		}

[Severity: High]
Because mem_cgroup_scan_skip() recomputes which thread represents the proce=
ss
as each thread is visited across cond_resched(), can a multi-threaded proce=
ss
be evaluated multiple times or missed entirely during a single scan?

1. Duplicate evaluation and repeated OOM kills: Suppose a process has threa=
ds
[leader, T1, T2] and css_task_iter visits leader first. mem_cgroup_scan_ski=
p()
returns false and invokes fn(leader, arg). When fn is oom_kill_memcg_member=
()
(for memory.oom.group), it calls __oom_kill_process() and returns 0 to
continue scanning:

mm/oom_kill.c:oom_kill_memcg_member() {
	if (task->signal->oom_score_adj !=3D OOM_SCORE_ADJ_MIN &&
	    !is_global_init(task)) {
		get_task_struct(task);
		__oom_kill_process(task, message);
	}
	return 0;
}

If leader enters do_exit() and sets PF_EXITING before T1 sets PF_EXITING (or
if the first visited thread exits concurrently during oom_evaluate_task() or
dump_task()), css_task_iter_next() next visits T1. At that point
mem_cgroup_scan_skip(T1) sees leader has PF_EXITING set, finds T1 as the fi=
rst
non-PF_EXITING thread in for_each_thread(leader, t), and returns false again
for the same process, causing oom_kill_memcg_member() to call
__oom_kill_process() repeatedly on sibling threads.

2. Missed process when iteration order differs from signal->thread_head:
css_task_iter walks css_sets and cset->tasks in cgroup attachment order, wh=
ich
can differ from signal->thread_head order (for example, when threads are
distributed across threaded child cgroups under the same memory domain or
created with CLONE_INTO_CGROUP). If css_task_iter visits T2 before T1 while=
 T1
is earlier in signal->thread_head, mem_cgroup_scan_skip(T2) skips T2 because
T1 is still alive; if T1 then sets PF_EXITING before css_task_iter reaches =
T1,
T1 is also skipped and the process is missed completely.

3. Missed process when threads are split across memcgs in cgroup v1: If the
leader or first non-PF_EXITING thread in signal->thread_head resides in
another memcg while sibling threads reside in the memcg being scanned,
mem_cgroup_scan_skip() will return true for every thread in this memcg beca=
use
the first non-PF_EXITING thread in signal->thread_head is never one of the
tasks in this memcg.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026120248.2188=
024-1-zhanxusheng1024@gmail.com?part=3D1

