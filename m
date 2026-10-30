Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06A9606A324
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gTsP82pA
Received: by kanga.kvack.org (Postfix)
	id BAD8D6B05BC; Thu, 29 Oct 2026 23:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D646B05BD; Thu, 29 Oct 2026 23:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24466B05BE; Thu, 29 Oct 2026 23:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 719A96B05BC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:05:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A090A81C1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:07 +0000 (UTC)
X-FDA: 85377801054.18.98C2F1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 73F7840006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTsP82pA;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329505;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXhfIEDy4CTPoGjtcw0B4hVHKAfnO70M3fzVLJckIY4=;
	b=b4ki3XTirthtSxNmTg/xjLACichukMjnRC1NaBoR8YWytUJwFZmmFnV6atJHdUVA0Si5iF
	60oe3FBKH+i7HAttr71xfj25DsrXErEMJLGYuFljeJgZcxiZYXD07cqMZjDZNVyMH0zehW
	mGqRrwz5th9bsKgkukvoeKyaCqhIUHs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTsP82pA;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329505;
	b=rumCTyLVunFwoFsdvnt7i2+Uisjwv3XZsfTTNMFmhG2Nt+mgIgST1eIAlqf2yCmTglglJO
	Iu2kv+sZNxo1im2Avc04ImcUtqMn6RXzOtrO/V75DG9kz318PsR8Nv27m2aLZfmK1NbZlv
	heDWxGXY85a/SX9YesJ8eqylJ0+zWrU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0861260613;
	Fri, 30 Oct 2026 03:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B501F0093A;
	Fri, 30 Oct 2026 03:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793329504;
	bh=WXhfIEDy4CTPoGjtcw0B4hVHKAfnO70M3fzVLJckIY4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gTsP82pART3TnX9O3ulaGBbCQLhgq92Hg6rDqzSat5uDzTOj02VhwxuSCy5WO7pZq
	 +N4YCfptBzoMSGodJAskEubtJsxcVy1/4S1ZUpi+xiPvInQffKQAPH9zzP+IQqL1GS
	 H2++ZHtUiIQ5c8tEloQ7uibdZyr7QKfdrb+ySROtULDMp2ArtBykZ044hmVLhfnvgi
	 Q6N7S5Zg1pMrSOv5SfMsCDrQ1KSUZ8rGIEa0RQ6Aj7Fnjc19fSA3DbkZqbowNNT9Ym
	 V//O6n3Vp9aldQLak1iQ2xsdxbEvTlqPnpSwPPAqQ9SbdzSEZpmgYadN7voTtYnf6x
	 0a8sgZmAgP7AQ==
Message-ID: <sashiko-outbox-190206@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 12/17] sched/cache: Apply multi-LLC aggregation
 policy to task migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jianyong Wu" <wujianyong@hygon.cn>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Chen Yu" <yu.c.chen@intel.com>, "Tim
 Chen" <tim.c.chen@linux.intel.com>
Cc: "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Ben
 Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>, "Valentin
 Schneider" <vschneid@redhat.com>, "K Prateek Nayak" <kprateek.nayak@amd.com>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, "Phil Auld" <pauld@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, maddy@linux.ibm.com, "Michael
 Ellerman" <mpe@ellerman.id.au>, ljs@kernel.org, linux-mm@kvack.org, jianyong.wu@outlook.com, zhongyuan@hygon.cn, huangsj@hygon.cn, wangfengyu@hygon.cn, yingzhiwei@hygon.cn
In-Reply-To: <20261029022036.4002331-13-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
 <20261029022036.4002331-13-wujianyong@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 03:05:03 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 73F7840006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 98ubm5mfbix4o96o95on1c8ufc6c3rrf
X-HE-Tag: 1793329505-125031
X-HE-Meta: U2FsdGVkX1/mBYs0dQc7G5ep5nVnd+i5hZdSgVOvbfEpaUaM7wVNR2bfdw3V9rniVq4jNa2Sao9AL+x0LcA5hAz8Z8me+BL5Ib922FjMBHHFczCcSie1INBYmR4P4jN9WIp0pEfgqXJYlv52RWc6CCVx+IlODBs0Sbnp7BYOvMkw02ToCPbtthVfpiUwMLohg0oMgqoKq7xO8L1Qj22OkCXj+8ZctCyh9YCTEKTYx9o3/X9ECRbioHFonfiKsau/glzOQDCm0JYC8Vl2MZMIdg1G+z0GA627Z7uNwNDXeJx8WJAtg9022KciKi5h/ylBVqeYpQ3X74n8IgEv7qpjNkX5QKWJtsM0MjEsz6n0IBk9gJYKP/rePhAx8Da08stCeF9t/A3YeIhVWmNG5pVq/8fcWQGX4zrzH693oifM+3bg76Tb9oupXRA6uIa154f7fhUvYoYh2mfOJyjZ4ATSjCXg43oackcjxCyPSiBAwrYbiZy3ghMUyGnn5UjVQDfLdMyWU4/uOne2O4pZR+L3iZmEb6vbA6yldCsjpfv9flcx+lh6IGV+mthIPS1AkW92IsJb/abWYQ3LgIxd2oxD3UqPBo6LHm1rtxRTxvqd4VZURzr4EyChn4gFwXiji0IhZTts42fhUY9Z0PtoLFa5wywb8xUrC9bFGslBoIcRt8349Gbtm5d5Y2dA7nKVqnEPZYMq/DSNEXIKWqL6BAs/raqH+jF0Jkxgw/z7I6c74PYrvuzH+2k4kyZ5no7CoVcfrFnBlJTqzLHF460w5vPL1D/VvLkznWTY7jHK/JB6IU+xglETUTuZ6/Fngg/Ue9t7F+vLLp8i3bq5FCrBug6Ari4pspGD0YO/BYS8HehMy3w3+vCuBm5c89NYaxw8mHj40aCTN2/usdHu4bJcL8Qhqz3LGfVHXoVHnBX4nkTTab/0cHxL0ihcMdgyBN4o/2DA2fOx62LV7wCwWoU8+LY
 OJj88XjX
 uLwzBncUa57Q1rKB5lU+e/70l650ZJyZjFd1b4Hse6/CkEKhlwafGYrvcdPHyH2mYaZjYuDYpok0xdtDVUZhsWmD4UlNI0F6IW22VOLEhfuI94hYKXBUbMcP4UVB8oumidjB5uiSj0+xvmtNX8dRBBmPT5Mo6TJ4FkIdHlGCz9x/bCJB8/lSewx1zthavm7r0/ajOJdC0kmKKl17FCHlgbKZzs903km46mOjtC6Bejc+lk2w9j8YSHFHz7s8Irp/Sbcwb8N/8C78qy44jNwrZ2tdLcvZcLxrCcH9KanqyGflNREKqGyI3pceKRVtMkiOUeQhQryxoDbh6Ojq/c8wQqNdoe0zYK3gZZfGB8Fc8EhNORi8vBGnbS0P7P7KPwUxQYxrt2GVIB+tDwwIjWXoqVLJwC99P/JHeJVfuaFD0xMnjR5qK+hF5XDWMHP1pY4QyEYM90+KITpGjN13GWX6mOtGq/qFkQPkkikHhFcMKw3sdRYPDLCiqZ8WmCAe1vc5dKAJyTm4chfW3ALn1+Ww2QyrklF7LzTkUsL69XO6jms9cGLYPANYqhXy2t/nbUDpgf3Nj
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
- [Critical] sched/fair: NULL deref and mm_struct UAF in alb_break_llc()
- [High] sched/fair: alb_break_llc() blocks active balance when pref_llc < 0
- [Medium] sched/fair: active balance bypasses migrate_degrades_llc() when =
degrades > 0
--

commit 7bd76e4bf626d210dfac7f3c5332cbe2a77e81f9
Author: Jianyong Wu <wujianyong@hygon.cn>

sched/cache: Apply multi-LLC aggregation policy to task migration

This commit updates cache-aware task migration and active load balancing to
use if_to_prefer() and can_migrate_llcs() across all LLC pairs, removes the
can_migrate_llc() helper, and moves the LBF_ACTIVE_LB check in
can_migrate_task() after the locality check.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 03bb5c85a8b7b..c3f9ef8798d6c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c

[ ... ]

> @@ -10827,55 +10779,52 @@ static enum llc_mig can_migrate_llc_task(int sr=
c_cpu, int dst_cpu,

[ ... ]

>  static inline bool
>  alb_break_llc(struct lb_env *env)
>  {
> +	int pref_llc =3D -1;
> +	bool to_pref =3D false;
> +
>  	if (!sched_cache_enabled())
>  		return false;
> =20
>  	if (cpus_share_cache(env->src_cpu, env->dst_cpu))
>  		return false;
>  	/*
> -	 * All tasks prefer to stay on their current CPU.
> -	 * Do not pull a task from its preferred CPU if:
> -	 * 1. It is the only task running and does not exceed
> -	 *    imbalance allowance; OR
> -	 * 2. Migrating it away from its preferred LLC would violate
> -	 *    the cache-aware scheduling policy.
> +	 * We need the preferred LLC to decide whether we can perform migration.
> +	 * Therefore, we need to obtain task_struct, which is only meaningful
> +	 * in the case that only one task on the rq.
> +	 * For cases with more than one task on the rq, we need to check
> +	 * this in can_migrate_task().
>  	 */
> -	if (env->src_rq->nr_pref_llc_running &&
> -	    env->src_rq->nr_pref_llc_running =3D=3D env->src_rq->cfs.h_nr_runna=
ble) {
> -		unsigned long util =3D 0;
> +	if (env->src_rq->nr_running =3D=3D 1) {
>  		struct task_struct *cur;
> =20
> -		if (env->src_rq->nr_running <=3D 1)
> -			return true;
> -
>  		cur =3D rcu_dereference_all(env->src_rq->curr);
> -		if (cur && cur->sched_class =3D=3D &fair_sched_class)
> -			util =3D task_util(cur);
> +		if (!cur || !cur->mm)
> +			return false;
> +
> +		if (cur->sched_class =3D=3D &fair_sched_class)
> +			pref_llc =3D llc_id(cur->mm->sc_stat.cpu);

[Severity: Critical]
Can this dereference of cur->mm cause a NULL pointer dereference or a
use-after-free on struct mm_struct?

In sched_balance_rq(), need_active_balance() -> alb_break_llc() is called
before locking busiest (env->src_rq) and again after unlocking it, holding
only rcu_read_lock():

kernel/sched/fair.c:sched_balance_rq() {
	...
	if (need_active_balance(&env)) {
		unsigned long flags;

		raw_spin_rq_lock_irqsave(busiest, flags);
	...
}

Because cur is actively running on env->src_cpu and neither the runqueue lo=
ck
nor task_lock(cur) is held, cur can concurrently execute exit_mm() or
kthread_unuse_mm() and clear current->mm =3D NULL between the cur->mm check=
 and
the reload in cur->mm->sc_stat.cpu:

kernel/exit.c:exit_mm() {
	...
	local_irq_disable();
	current->mm =3D NULL;
	membarrier_update_current_mm(NULL);
	enter_lazy_tlb(mm, current);
	local_irq_enable();
	task_unlock(current);
	mmap_read_unlock(mm);
	mm_update_next_owner(mm);
	mmput(mm);
}

Even if the mm pointer is loaded only once, rcu_read_lock() only protects
struct task_struct, whereas mm_cachep does not use SLAB_TYPESAFE_BY_RCU and
__mmdrop() frees struct mm_struct immediately via free_mm(). If cur replaces
its mm in exec_mmap() or exits and switches out on the unlocked remote
runqueue, can alb_break_llc() and can_migrate_llcs() end up reading from a
freed struct mm_struct?

> =20
> -		if (can_migrate_llc(env->src_cpu, env->dst_cpu,
> -				    util, false) =3D=3D mig_forbid)
> +		to_pref =3D if_to_prefer(env->src_cpu, env->dst_cpu, pref_llc);
> +
> +		if (can_migrate_llcs(env->src_cpu, env->dst_cpu,
> +				    cur, to_pref) =3D=3D mig_forbid)
>  			return true;
>  	}

[Severity: High]
When pref_llc is negative (for instance, when cur->mm->sc_stat.cpu is -1 on
single-threaded tasks, or when cur is not in fair_sched_class), shouldn't
alb_break_llc() return false instead of calling can_migrate_llcs()?

When pref_llc < 0, if_to_prefer() returns false, and can_migrate_llcs() fal=
ls
back to using src_cpu as target_cpu:

kernel/sched/fair.c:can_migrate_llcs() {
	...
	if (p) {
		struct mm_struct *mm =3D p->mm;

		if (mm)
			target_cpu =3D READ_ONCE(mm->sc_stat.cpu);
		target_cpu =3D target_cpu >=3D 0 ? target_cpu : src_cpu;

		tsk_util =3D task_util(p);
	}
	...
}

With to_pref =3D=3D false and target_cpu =3D=3D src_cpu, can_migrate_llcs()=
 treats
src_cpu as the task's preferred cache location and returns mig_forbid whene=
ver
fits_llc_capacity() is true on the source LLC or node:

kernel/sched/fair.c:can_migrate_llcs() {
	...
			if (src_node =3D=3D dst_node) {
				/* Leave the source LLC at or above the threshold. */
				if (fits_llc_capacity(src_util, src_cap, false))
					return mig_forbid;
	...
}

Unlike can_migrate_llc_task(), which returns mig_unrestricted when cpu < 0,
won't this regression cause alb_break_llc() to block cross-LLC active balan=
ce
for tasks that have no preferred LLC?

[ ... ]

> @@ -11027,14 +10976,11 @@ int can_migrate_task(struct task_struct *p, str=
uct lb_env *env)
> =20
>  	/*
>  	 * Aggressive migration if:
> -	 * 1) active balance
> -	 * 2) destination numa is preferred
> +	 * 1) destination numa is preferred
> +	 * 2) active balance
>  	 * 3) task is cache cold, or
>  	 * 4) too many balance attempts have failed.
>  	 */
> -	if (env->flags & LBF_ACTIVE_LB)
> -		return 1;
> -
>  	degrades =3D migrate_degrades_locality(p, env);
>  	if (!degrades) {
>  		/*
> @@ -11060,6 +11006,13 @@ int can_migrate_task(struct task_struct *p, stru=
ct lb_env *env)
>  		hot =3D degrades > 0;
>  	}
> =20
> +	/*
> +	 * Keep this after the cache-aware check so active balance respects its
> +	 * migration veto when NUMA locality is neutral.
> +	 */
> +	if (env->flags & LBF_ACTIVE_LB)
> +		return 1;

[Severity: Medium]
What happens during cross-node active load balancing when
migrate_degrades_locality() returns a positive value (degrades > 0)?

In active_load_balance_cpu_stop(), the stopper task is queued on env->src_r=
q,
so env->src_rq->nr_running > env->src_rq->nr_preferred_running is true in
migrate_degrades_locality():

kernel/sched/fair.c:migrate_degrades_locality() {
	...
	/* Migrating away from the preferred node is always bad. */
	if (src_nid =3D=3D p->numa_preferred_nid) {
		if (env->src_rq->nr_running > env->src_rq->nr_preferred_running)
			return 1;
		else
			return 0;
	}
	...
}

When a task is on its preferred NUMA node, migrate_degrades_locality() retu=
rns
1, which skips the if (!degrades) block containing migrate_degrades_llc() a=
nd
sets hot =3D 1. Because the LBF_ACTIVE_LB check right after that block retu=
rns 1
unconditionally, won't active balance bypass migrate_degrades_llc() whenever
migrating the task also degrades NUMA locality?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029022036.4002=
331-1-wujianyong@hygon.cn?part=3D12

