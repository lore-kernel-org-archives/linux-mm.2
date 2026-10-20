Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD08A606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 01:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n6eDkrQT
Received: by kanga.kvack.org (Postfix)
	id C3A9E6B0117; Mon, 19 Oct 2026 21:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEBED6B011B; Mon, 19 Oct 2026 21:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADABE6B011C; Mon, 19 Oct 2026 21:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1066B0117
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:16:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23074C0828
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:16:01 +0000 (UTC)
X-FDA: 85341238122.19.714FBA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E339140002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:15:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6eDkrQT;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792458959;
	b=O1ZtveXQ1niwxG3P439VdVcKu0T7d8TQHmeWaKdWweZSTMMe5JfzpCbfKp4prXuaM3nku3
	qP0T88y7jIT1IdKMFndaPfyUmnDlDqX0qr+7AfCDGwCLmhj8CzGE0l3c4JCFiXGtrr1yMq
	Pi9m76iBpdEKmXcS/EI2+pQ3iKzGf94=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6eDkrQT;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792458959;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PofXJdtzFZtwuWvsf1UigVwLVE0UlV/1/R7tX4bqvFQ=;
	b=Loq+Y1aTxyq9UMp5/DwTAILVRJqt/pNozC/ZEcRZAben/z6V9EZExt2X6llvj/zfIqsjBU
	4OC6o7m71LQcEn82DEvYHbbhwYSu77ATVkqR35Bs6YgtJiIcjOuoyYKBF0ax7DGWlct8nn
	XmELOV2RME7fVPtXTemqjbkMct/n53Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BBDD141262;
	Tue, 20 Oct 2026 01:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431B51F000C4;
	Tue, 20 Oct 2026 01:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792458958;
	bh=PofXJdtzFZtwuWvsf1UigVwLVE0UlV/1/R7tX4bqvFQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n6eDkrQTBE5XG7WvdONAHThI+LJzOulTvRSvB8qY1k1UsekWhZ7+AXU1YyrH08L+l
	 //i6NX+1L1RXJQF3WPYzv1RDKLjOtHgNywDL4q0FwVb5vBwkJFGUZo8ZEG337Ukcxn
	 AWmiW8qMMCoUt/DKKzuC7+2LYtq6PaMI6IVn6HbX4/geMgSh6r9ZqTNtSknEUeyygV
	 VE/k8IZrCsDbw1oHh1SOt5FvM8JWK7Sv57ZZs0RrcDKZeuJKH+TbSyr+EboQ8sdq4e
	 YCvKxc5zxT4q/n7u6MtugvjWlyZ/Lyz3avGHRIb6ODk1t23/8FcJ5qptLPnaZTBxT5
	 RYATOqGJJeMow==
Message-ID: <sashiko-outbox-178407@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/8] sched/deadline, topology: Avoid O(N^2) dl_server
 bandwidth walks during root_domain rebuilds
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>, kees@kernel.org, rppt@kernel.org, juri.lelli@redhat.com, nik.borisov@suse.com, tglx@kernel.org, vschneid@redhat.com, kprateek.nayak@amd.com, vincent.guittot@linaro.org, bp@alien8.de, jpoimboe@kernel.org, tony.luck@intel.com, david@kernel.org, mingo@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org, seanjc@google.com, ljs@kernel.org, zhangguopeng@kylinos.cn, dietmar.eggemann@arm.com, mhocko@suse.com, vinicius.gomes@intel.com, vbabka@kernel.org, peterz@infradead.org, surenb@google.com, hpa@zytor.com, x86@kernel.org, dmatlack@google.com, tim.c.chen@linux.intel.com, kexec@lists.infradead.org, pratyush@kernel.org, dave.hansen@linux.intel.com, rostedt@goodmis.org, gmonaco@redhat.com, jgross@suse.com, mgorman@suse.de, graf@amazon.com, liam@infradead.org, ridong.chen@linux.dev, blum@kernel.org, longman@redhat.com, bsegall@google.com
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com
In-Reply-To: <20261019011446.834487-7-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
 <20261019011446.834487-7-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 01:15:55 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E339140002
X-Stat-Signature: iyfwyn9jq8ft69po8y45qojgw1nre6k6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792458959-751616
X-HE-Meta: U2FsdGVkX18Qlxem7kxW/JWn6evGP+kegyiWAWOOS602E4u3gQJhFafgVrDzQ7gu04V5v6ZczmsIi3CdUvtIg5DcLxIITpXIiLLdQ5rqb96f+Bmpyvj5VIY/lJ0HT082iDN5y5WNmmReWXKRu7RTnYtHLWNLAoiYG+LniVw97bhNrWyZAyCPJey+kokcNMch34Wt0so4DoXzz8250lt4R+2fkXH4whAtvDJp8xrT7qOTZofzL+SX+3rZoxsQYcRegW28UtjRnn8mFWJ2MsGUkwSQhxy5AQ4uWNl+hSQ70+FJZd5udPmSHjlnzbCdkzVmc/oN9Ts79PS2Mu9hV/4Nambus3oxmgq9Cbmfwe75moP9kcEZK52IoM33EqxTLjuncqyZ3L5BqgHq3Z2nVORvKgl4KraVig3QEXXnIP3gCWq+jnuUnT0/qpIZJaCsB/5gsA3DKOZmaSEMEfxzJ6LBEePw37rvNJWZnp5XDlQ9IAF5ICCl9XC37nMwxbCic5krWoRhA4MR6O0ESbSPzd7hUOUK+PZN25cy6cXwFraqjNdKaJoPqSfq/+XTzIQIP1vYXZ0BpZjBzNayQW+ZSGE5QlvmtUeyPdN1ofmLMlXsEi7l7BGg/b2XfcY4KRP5Mao+GPP0nGRCXP938BSh7VhrJ1qUn2waXoIHTihI/nVEjDYMnef9otUI2svrXQ/OHeVJYGPxbg+mCsd2pw9aeNAnT3usnQibLhe2uhraG7xtFN4h3WB6kgpqvcBi50iXU3MEJaYdiJCLEpx+D4SG0+MHtACymYAMo088LoEE/2OFmpTd/bYjR9fc7nshObKOCLJJ2KUs9hTw4pP+JxOZpFz5nGhwoZ64/WtGD6Bkp4F0hbZcmNn+JFwg1ErANZxGiySUueG+txyFc0OUMVeYH/raPlWkGM+LT8ZUZj7LYJY9fnJItnWcvmQK0mX7j3dMFvZzDsWgIKFzmm9++ss5F8v
 EVD1D/Xz
 Q40szAucKaUsMegX5K5NfFtPRx81dkFm+qagorVxQyCXG+kr13dzutqynwMQ8z2PKTNJOnUigF+eyzPeXQNbwKDb2NZs3SNAzwpBStqJPHZkwayUGpMEvPvIERDFC7icdpD8txJy6lwvIYodqQKtT0I7g0vjfhM4wKpT60fnxVPowYrjyFWNmHVsZrQb5om2VGrYQ0IvqIdKv19aUmknziyYJ1S9ymBg3DDCVTurgqsG10Sknk0MnXK1geVfMbX/QUmJrCcKTv9rwqxM6851ZNewh5QDXTd8orLn2AOrMuX/PIj5lUApiuAsmTOuzvtx85OGXDoHW+sYJt3/Hq2UwyPnY6JofkrnGkMF+/hb0UDr3bT/4iYw/hPT89vrdsFjVzxMahywzE+BaRds7gsqe4kmzgK2s+pKLN4KF7n3Hjt6Iwkm4hBu9pZx56tcQ/HrIqleNwvSOqBr9otjiYIPzGCzN6AbTH+q+lbgSHNdSmJ5FerIb4FN2rBwIhrjPjsuvlIdzKlG2LyftSroYcjS6thhOUOCDiMMzhOSQMUY/rJF8JF/wIGgD1bq4/NsnS81l76JShednu6UB+vCND4s6Tr/bmIjBQIAqWpchqsndiYyklHqA34BVXqp6OpzeGnHu1wshSFjdnP2oVYINk2hlBPVzZxRsxVlO39XlYUqmxNUbBI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] sched/deadline: dl_rebuild_rd_accounting() drops TASK_DEAD inactiv=
e_timer bw
- [High] sched/deadline: unskipped zero-dl_bw tasks in dl_add_task_root_dom=
ain()
--

commit e4cc8155c8ec900e6f7e52f8baebd0b6ab370fff
Author: Pasha Tatashin <pasha.tatashin@soleen.com>

sched/deadline, topology: Avoid O(N^2) dl_server bandwidth walks during roo=
t_domain rebuilds

This commit removes redundant __dl_server_attach_root() calls from
rq_attach_root() and replaces the nested O(N^2) loop in dl_clear_root_domai=
n()
with an O(N) accumulation and update pass. It also adds a !CONFIG_CPUSETS
implementation of dl_rebuild_rd_accounting() and skips TASK_DEAD tasks on
inactive CPUs in dl_add_task_root_domain().

> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index c0ebdcde5fe5d..c8847e1ea55a0 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
[ ... ]
> @@ -3433,7 +3415,8 @@ void dl_add_task_root_domain(struct task_struct *p)
>  	struct cpumask *msk;
> =20
>  	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
> -	if (!dl_task(p) || dl_entity_is_special(&p->dl)) {
> +	if (!dl_task(p) || dl_entity_is_special(&p->dl) ||
> +	    (READ_ONCE(p->__state) =3D=3D TASK_DEAD && !cpu_active(task_cpu(p))=
)) {
>  		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
>  		return;
>  	}

[Severity: High]
Can this trigger the BUG_ON(cpu >=3D nr_cpu_ids) just below in
dl_add_task_root_domain() for tasks where dl_task(p) is true, but
p->dl.dl_bw =3D=3D 0?

During CPU hotplug or sched domain rebuilds, partition_sched_domains_locked=
()
calls dl_rebuild_rd_accounting() -> dl_add_task_root_domain(p) on tasks whe=
re
dl_prio(p->prio) / dl_task(p) is true:

kernel/sched/deadline.c:dl_add_task_root_domain() {
	...
	msk =3D this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
	dl_get_task_effective_cpus(p, msk);
	cpu =3D cpumask_first_and(cpu_active_mask, msk);
	BUG_ON(cpu >=3D nr_cpu_ids);
}

In dl_get_task_effective_cpus(), if p->cpus_ptr only intersects with
isolcpus=3Ddomain CPUs, it returns the active isolated CPUs:

kernel/sched/deadline.c:dl_get_task_effective_cpus() {
	hk_msk =3D housekeeping_cpumask(HK_TYPE_DOMAIN);
	if (housekeeping_enabled(HK_TYPE_DOMAIN)) {
		if (!cpumask_intersects(p->cpus_ptr, hk_msk)) {
			cpumask_andnot(cpus, cpu_active_mask, hk_msk);
			return;
		}
	}
	...
}

Normally, dl_bw_deactivate() blocks deactivating the last CPU in that domain
while reserved task bandwidth (total_bw - dl_server_bw) is non-zero. Howeve=
r,
dl_task(p) can be true while p->dl.dl_bw =3D=3D 0 in two situations:

1. A non-deadline task (!task_has_dl_policy(p)) is PI-boosted by a
   SCHED_DEADLINE waiter via rt_mutex_setprio(), which sets
   p->prio =3D MAX_DL_PRIO - 1 while p->dl.dl_bw remains 0.

2. An exiting SCHED_DEADLINE task (p->__state =3D=3D TASK_DEAD) has already=
 had
   its bandwidth subtracted and cleared to p->dl.dl_bw =3D 0 by
   __dl_clear_params(&p->dl) in task_non_contending() or
   inactive_task_timer(), leaving p->prio as MAX_DL_PRIO - 1 while the
   unreaped zombie remains on the process/thread list.

Because p->dl.dl_bw =3D=3D 0, dl_bw_deactivate() sees total_bw - dl_server_=
bw =3D=3D 0
and permits all isolcpus=3Ddomain CPUs to be taken offline.

The new check only skips TASK_DEAD tasks when !cpu_active(task_cpu(p)). It
does not filter out PI-boosted non-DL tasks (where p->__state !=3D TASK_DEA=
D,
such as a task blocked on a PI futex while affine to an isolated CPU) or
TASK_DEAD zombies whose task_cpu(p) is still active while p->cpus_ptr is
restricted to now-offline isolcpus=3Ddomain CPUs. For those tasks,
dl_get_task_effective_cpus() returns an empty mask and cpumask_first_and()
returns nr_cpu_ids, hitting BUG_ON(cpu >=3D nr_cpu_ids) just to add
p->dl.dl_bw =3D=3D 0.

Should dl_add_task_root_domain() check !p->dl.dl_bw (or !task_has_dl_policy=
(p))
before computing the effective CPU mask?

[ ... ]
> @@ -3510,6 +3504,33 @@ void dl_clear_root_domain_cpu(int cpu)
>  	dl_clear_root_domain(cpu_rq(cpu)->rd);
>  }
> =20
> +#ifndef CONFIG_CPUSETS
> +void dl_rebuild_rd_accounting(void)
> +{
> +	struct task_struct *g, *p;
> +	u64 cookie =3D ++dl_cookie;
> +	int cpu;
> +
> +	lockdep_assert_cpus_held();
> +	lockdep_assert_held(&sched_domains_mutex);
> +
> +	rcu_read_lock();
> +	for_each_possible_cpu(cpu) {
> +		if (dl_bw_visited(cpu, cookie))
> +			continue;
> +
> +		dl_clear_root_domain_cpu(cpu);
> +	}
> +	for_each_process_thread(g, p) {
> +		/* Racy pre-check; dl_add_task_root_domain() rechecks under pi_lock. */
> +		if (!dl_prio(READ_ONCE(p->prio)))
> +			continue;
> +		dl_add_task_root_domain(p);
> +	}
> +	rcu_read_unlock();
> +}
> +#endif

[Severity: High]
Can dl_rebuild_rd_accounting() drop the bandwidth of a TASK_DEAD
SCHED_DEADLINE task whose p->dl.inactive_timer is still armed, leading to an
underflow of rd->dl_bw.total_bw or a divide-by-zero in inactive_task_timer(=
)?

When a running SCHED_DEADLINE task p exits via do_exit() -> do_task_dead() =
->
__schedule() -> dequeue_task_dl() -> dequeue_dl_entity() ->
task_non_contending(&p->dl, true), if its 0-lag time is in the future,
task_non_contending() does not subtract p->dl.dl_bw immediately. Instead, it
sets p->dl.dl_non_contending =3D 1, takes a reference with get_task_struct(=
p),
and arms p->dl.inactive_timer.

When p->dl.inactive_timer later fires, inactive_task_timer() unconditionally
subtracts p->dl.dl_bw:

kernel/sched/deadline.c:inactive_task_timer() {
	...
	if (!dl_task(p) || READ_ONCE(p->__state) =3D=3D TASK_DEAD) {
		struct dl_bw *dl_b =3D dl_bw_of(task_cpu(p));

		if (READ_ONCE(p->__state) =3D=3D TASK_DEAD && dl_se->dl_non_contending) {
			sub_running_bw(&p->dl, dl_rq_of_se(&p->dl));
			sub_rq_bw(&p->dl, dl_rq_of_se(&p->dl));
			dl_se->dl_non_contending =3D 0;
		}

		raw_spin_lock(&dl_b->lock);
		__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
		raw_spin_unlock(&dl_b->lock);
		__dl_clear_params(dl_se);

		goto unlock;
	}
}

There appear to be two ways a root domain rebuild loses p->dl.dl_bw while
p->dl.inactive_timer is still pending:

1. In the new !CONFIG_CPUSETS dl_rebuild_rd_accounting(),
   dl_clear_root_domain() resets rd->dl_bw.total_bw to only the dl_server
   bandwidth and rebuilds task bandwidth via for_each_process_thread(g, p).
   If p was a sub-thread, autoreaped, or already reaped by wait(),
   release_task() -> __exit_signal() -> __unhash_process() has already remo=
ved
   p from the process/thread lists before p->dl.inactive_timer expires.
   for_each_process_thread(g, p) will not visit p, so p->dl.dl_bw is omitted
   from rd->dl_bw.total_bw, and when inactive_task_timer() later calls
   __dl_sub(), it underflows rd->dl_bw.total_bw and inflates rq->dl.extra_b=
w.

2. Even if p is still an unwaited zombie in for_each_process_thread(g, p),
   the new (READ_ONCE(p->__state) =3D=3D TASK_DEAD && !cpu_active(task_cpu(=
p)))
   check in dl_add_task_root_domain() skips p when task_cpu(p) is deactivat=
ed
   during CPU offline while p->dl.inactive_timer is armed. That drops
   p->dl.dl_bw from the active root domain on rebuild, and if
   inactive_task_timer() fires after task_cpu(p) is attached to
   def_root_domain, __dl_sub() underflows def_root_domain.dl_bw.total_bw and
   divides by dl_bw_cpus(task_cpu(p)) =3D=3D 0 when no isolated CPUs are ac=
tive in
   def_root_domain.

_________________
_________________
_________________

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019011446.8344=
87-1-pasha.tatashin@soleen.com?part=3D6

