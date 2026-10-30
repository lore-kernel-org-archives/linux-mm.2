Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D954606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TidB5qin
Received: by kanga.kvack.org (Postfix)
	id 2851A6B05BD; Thu, 29 Oct 2026 23:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6F76B05BF; Thu, 29 Oct 2026 23:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6146B05C0; Thu, 29 Oct 2026 23:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C47556B05BD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:05:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A65E9C05AB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:08 +0000 (UTC)
X-FDA: 85377801096.22.1837662
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 09CE8C0002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TidB5qin;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329507;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkxYoYJCkX2YAFLHQUMw3KqFGEIML4u3uDs4jfLkO6U=;
	b=KtwSVqQnivr0sGNkFRycXXcsF1QjYamMYDtVM+aF7bY1hF5CYxnnAbb5ApBjycLy/hdfqB
	oxm1zVkJ6i1t92GuWiFd+9db2z+KX4IdA23yNs5hrDj35tHjqm8Vf1FAoZSv8TyNCgetxo
	gOHdfwZRBYRTJhND5eOFhBxFjKmaM3U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TidB5qin;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329507;
	b=yASEVpQav6G40l5CTxgGvU1jfr8zL4W6UnrrA5U3X7Va52ePUac4ixZHPVsGqnTegi6LTy
	T5ZpYqVuxuULr1awt5lunzLcHwf6+FTb0HeaYVErJNuy6w+B2SBh5H2/amLkr4Mhhj51KT
	2QpTz22nrqGUZr/9u0gR3jjemZrAU+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 988A560611;
	Fri, 30 Oct 2026 03:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337B11F0093A;
	Fri, 30 Oct 2026 03:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793329506;
	bh=nkxYoYJCkX2YAFLHQUMw3KqFGEIML4u3uDs4jfLkO6U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TidB5qiniO5A7XVovWmko4QvxqAm+ShCgHveNdob1DgIYmhDpFAUCNMsugjDpLGNL
	 mp3O06WdLR3dQWaxmlJSj5QA7z/q2AIfip8L5Fu4WfQ9kzveuhZ/3458WtcKnfMa1x
	 cNAi9wLls/uAYJHVI2LBcPQPYA/khAQPF0XaMVSE53hxmbbzSzJ8kg+t9jCPZaZQI4
	 fUi4OaHb4Yw6/wjrAVgfJge7EBAEHLKft1KgUuOp56xvvvSeENB219pDam6+lferra
	 4Zbf8gEYOgWaBPhi1Yh7YF4YXgFS6GAi54QRTFwBu+FhhwXxnmLJ3U3XYra9EPlfCn
	 OpHIQfODjesfg==
Message-ID: <sashiko-outbox-190207@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 13/17] sched/cache: Allow active balance to
 spread load from a full LLC
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
In-Reply-To: <20261029024543.4003980-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
 <20261029024543.4003980-1-wujianyong@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 03:05:04 +0000
X-Rspamd-Queue-Id: 09CE8C0002
X-Stat-Signature: 4rczfkckwqnhs5ufocgpydf7swht5su6
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793329506-774316
X-HE-Meta: U2FsdGVkX1/VwNZ0vu4rVnQZJRS1h1RNq4Fz5+Z2DOugNTJBY0fsAbEstvU6yMpd9Vknk9cfB+PN85u3Fuloy9x4X2+4NzZTiP7dtREYLPPh0lv6DbLLtg0HdPgMvVgGEFhew//TxzpWFAtjmt8XpTbH1C4ZraaHnZzitgqX3i6jlJ+FHIqMnKXbVY9fvYRk5WrjpPTugsu/1J3P4VtGOJcQbYe7otE1wQ77i/kqH4Nv+wf1oMsynqWDKYLFAjQZLSMEvGEUplvkrwQXD3H105xQbk+yOdq0rdTlIWeQSNLrg/yLdxDpg3/tymZToKxHU881E6Jz0POknhBvC3STKlY8kBIGf/yFkcUnszI2Ho+mxYPV9mlzDX2KiuAaa0RELTnCU3Gq1RY3TJXOxKcMlEjheev4W8xxXTe3HB6ut0OkBNPQtWCYDEAnY89QqnGgz4etWEmuCKK07Tu3tJ1MmKiRkaRprzzFg+TZnxTIHDiqEqIjx4Rqte/Ykec/YjVAEnU1cRzraT1DvhQK2A5AWKTDAvnZG0TriX2hQ0LYKSnF9rkAl4kyOiUwxKHQGgKmDcasVj60ZGGs5DC6H1zDrdmzZutBsaKqENz1xYC+RkRLaHAz1H5NjFgVuaSSEwNJxMn4p+ikehMRI++NwNcfN25yrBWKH1ItAxWUVsdT7P5i2G+cA3tL0+wingbcZmUm96KBPA1x8HHhmgajaG9s2nWt6kfALNu0PmABBuro33XwIHThDBtRYn/aQSqsuzuu3Ahb2qukJ+5LQoNeWzJCGA1mMJlGgRU50hILfD+uUyA50KIALgPWdi4avIkgay7/b35wEx87Wj85EioNWLn2nlp44QcAhqa1AcYOli8PVyBaJAQtDtWzsPIVytS9Ae5Zk0An+ciPW+ja1b0WroAljxuJTR3Ux5YJOmTbHq4NBfZhKCqJFA7kvJUme5zOn7dLWSuuCaS8tJ2cgdLSW9u
 NUatn+8/
 35+66D6PhzRNWU5bO/s+WMl6ajhMl0+uVtTDEd7BjNEXQGnrdcVKU2V9pDArIxHoiT0kAp3Rha3X30Gzmg2RN/RmIzN+w8vdJdilZdlISoaaqsQ3xHCZmVA0Ypl6HhVIhuUmH3cPNVCCNAuM33Y/r0zJzm++agy790nQO9slQPRVXe6CkFCjXxmSZFu5meis9c4dHWWAdskVNktnFKlLupMmPI7ftqwn5N1V3emSnENs470+qcTpO7nG9f1AQ1KXnMY1QcQPxQZtiVBWsBCcin/rsGRA+gLJ40JUUe9PNo6ZezLxtnN3A/RreZqa+uuUSQbv0Gxm6ZYqwfMcM/Q6XNTnSgjkQsDU48Cw7AnY+J24nY8zHuKCCups3fbw4OBrr412usiEwCZKpWmGesU5inmP2wzcYMGbsmE/FlQTKHix697EVdQ5U1X9T8O502ErGo9UovYK7sHufU3XOqT6Xr+2c10Q5WH3FpfU+FEj+WD6h7fr5nrCfvHI2kOZw35oz6d/jtYNYzujrY9PoM0Xsm+8lySQMfSL+KCb1XpX1LOh71k4z1PjbA7aJGuo7GNomf6w0
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
- [Medium] sched/fair: missing 2-CPU utilization gap check in llc_spread_ac=
tive_balance()
- [Medium] sched/cache: futile active load balance in llc_spread_active_bal=
ance()
--

commit 0b23fd14c184de7459085104b19552a73905471e
Author: Jianyong Wu <wujianyong@hygon.cn>

sched/cache: Allow active balance to spread load from a full LLC

This commit introduces llc_spread_active_balance() so migrate_task can trig=
ger
active load balancing across LLCs without waiting for nr_balance_failed to
exceed cache_nice_tries + 2 when the source LLC exceeds the aggregation
threshold and the destination LLC has spare capacity.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c3f9ef8798d6c..1e286296cd65c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -13558,6 +13558,57 @@ imbalanced_active_balance(struct lb_env *env)
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_SCHED_CACHE
> +/*
> + * Cache-aware aggregation can trigger active balance via migrate_llc_ta=
sk
> + * without waiting for nr_balance_failed. Spreading load via migrate_task
> + * normally waits for nr_balance_failed to exceed cache_nice_tries + 2.
> + * This can leave one LLC above the aggregation threshold while another
> + * LLC has room.
> + *
> + * Allow that spread when the source is above the aggregation threshold,
> + * the destination has room for one CPU's load, and the source leads by
> + * at least two CPUs' load. The gap prevents one migration from reversing
> + * their utilization ordering and immediately inviting a migration back.
> + * The task migration checks still decide whether the task may move.
> + */
> +static inline bool llc_spread_active_balance(struct lb_env *env)
> +{
> +	unsigned long src_util, src_cap, dst_util, dst_cap;
> +
> +	if (!sched_cache_enabled())
> +		return false;
> +
> +	if (env->migration_type !=3D migrate_task)
> +		return false;

[Severity: Medium]
Can llc_spread_active_balance() trigger repeated futile active load balance
attempts when env->src_rq->nr_running > 1 and detach_tasks() was vetoed by
cache locality checks?

In sched_balance_rq(), when detach_tasks() fails to pull a task because
can_migrate_task() -> migrate_degrades_llc() -> can_migrate_llcs() returns
mig_forbid, can_migrate_task() sets LBF_LLC_PINNED in env.flags.

When ld_moved =3D=3D 0, sched_balance_rq() skips incrementing
sd->nr_balance_failed if LBF_LLC_PINNED is set, and then calls
need_active_balance():

kernel/sched/fair.c:sched_balance_rq() {
    ...
		if (idle !=3D CPU_NEWLY_IDLE &&
		    env.migration_type !=3D migrate_misfit &&
		    !(env.flags & LBF_LLC_PINNED))
			sd->nr_balance_failed++;

		if (need_active_balance(&env)) {
    ...
}

In need_active_balance(), alb_break_llc() only checks can_migrate_llcs() wh=
en
env->src_rq->nr_running =3D=3D 1:

kernel/sched/fair.c:alb_break_llc() {
    ...
	if (env->src_rq->nr_running =3D=3D 1) {
		...
		if (can_migrate_llcs(env->src_cpu, env->dst_cpu,
				    cur, to_pref) =3D=3D mig_forbid)
			return true;
	}

	return false;
}

When env->src_rq->nr_running > 1, alb_break_llc() returns false, and
llc_spread_active_balance() does not check env->flags & LBF_LLC_PINNED,
env->src_rq->nr_running =3D=3D 1, or the post-departure and NUMA node const=
raints
in can_migrate_llcs().

If llc_spread_active_balance() returns true here, sched_balance_rq() queues
active_load_balance_cpu_stop() via stop_one_cpu_nowait() and resets
sd->balance_interval to sd->min_interval. When the CPU stopper runs
detach_one_task() -> can_migrate_task(), sd->nr_balance_failed is still 0, =
so
migrate_degrades_llc() rejects the migration for the same reason.

Should llc_spread_active_balance() bail out when env->flags & LBF_LLC_PINNED
is set (or check the post-departure state) to avoid kicking the CPU stopper
for a move that can_migrate_task() will reject?

> +
> +	if (cpus_share_cache(env->src_cpu, env->dst_cpu))
> +		return false;
> +
> +	if (!get_llc_stats(env->src_cpu, &src_util, &src_cap) ||
> +	    !get_llc_stats(env->dst_cpu, &dst_util, &dst_cap))
> +		return false;
> +
> +	if (fits_llc_capacity(src_util, src_cap, true))
> +		return false;
> +
> +	/*
> +	 * Reserve room for one CPU's load at the destination. A two-CPU gap
> +	 * keeps one migration from reversing the utilization ordering and
> +	 * causing the task to ping-pong between LLCs.
> +	 */
> +	if (!fits_llc_capacity(dst_util + SCHED_CAPACITY_SCALE, dst_cap, true))
> +		return false;
> +
> +	return util_greater(src_util, dst_util);
> +}

[Severity: Medium]
Does llc_spread_active_balance() actually enforce the two-CPU utilization g=
ap
described in the comment and commit message?

Moving a task with one full CPU of utilization (SCHED_CAPACITY_SCALE) reduc=
es
src_util by SCHED_CAPACITY_SCALE and increases dst_util by
SCHED_CAPACITY_SCALE, narrowing the gap between src_util and dst_util by
2 * SCHED_CAPACITY_SCALE.

However, the checks here only verify:
1. !fits_llc_capacity(src_util, src_cap, true), meaning src_util > threshold
2. fits_llc_capacity(dst_util + SCHED_CAPACITY_SCALE, dst_cap, true), meani=
ng
   dst_util <=3D threshold - SCHED_CAPACITY_SCALE
3. util_greater(src_util, dst_util), meaning
   src_util * 100 > dst_util * (100 + llc_imb_pct)

For equal-capacity LLCs, the two fits_llc_capacity() checks only ensure
src_util - dst_util > SCHED_CAPACITY_SCALE (one CPU of load), and
util_greater() only requires a 20% relative difference (which is smaller th=
an
2 * SCHED_CAPACITY_SCALE whenever dst_util < 10 * SCHED_CAPACITY_SCALE).

For example, on a 4-CPU LLC (cap =3D 4096, 50% threshold =3D 2048) with
src_util =3D 2050 and dst_util =3D 1024, all three checks pass even though
src_util - dst_util is only 1026 (~1 CPU). Migrating a 1-CPU task (1024)
drops src_util to 1026 (below the aggregation threshold) and raises dst_util
to 2048, reversing the utilization ordering between the two LLCs.

Furthermore, in can_migrate_llcs(), src_util has tsk_util subtracted before
checking the threshold and post-migration ordering:

kernel/sched/fair.c:can_migrate_llcs() {
    ...
			if (src_node =3D=3D dst_node) {
				/* Leave the source LLC at or above the threshold. */
				if (fits_llc_capacity(src_util, src_cap, false))
					return mig_forbid;

				if (util_greater(src_pre, dst_pre) &&
				    src_util >=3D dst_util)
					return mig_llc;
    ...
}

Should llc_spread_active_balance() check that src_util remains at or above =
the
threshold after subtracting SCHED_CAPACITY_SCALE (for example, checking
fits_llc_capacity(src_util - SCHED_CAPACITY_SCALE, src_cap, false) or
explicitly checking src_util >=3D dst_util + 2 * SCHED_CAPACITY_SCALE) so t=
hat
the two-CPU gap is enforced?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029022036.4002=
331-1-wujianyong@hygon.cn?part=3D13

