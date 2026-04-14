Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA0EAF9D0FB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 21:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D476B0088; Tue, 14 Apr 2026 17:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E7B6B0089; Tue, 14 Apr 2026 17:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D7F6B0092; Tue, 14 Apr 2026 17:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A18A86B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:57:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 455B81A0287
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:57:59 +0000 (UTC)
X-FDA: 84658524678.25.0969D8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5212740016
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:57:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bpO0O54J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776203877; a=rsa-sha256;
	cv=none;
	b=xK7KhPp25DPGfenkTQji2GyZ3g4MMB99wYx0b4gyMBRULyDDFwbGIFtaBDRXnEODOZCFGC
	jWRDtzFCExQc2nMk04K04RHzyvR8vb2GH6JmwuBCTcZM7xUVpIaBORiUU9n+q7w5jJzyTV
	xtqW3eWCUR9OQXY69KLhxkuw2s+oeMg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bpO0O54J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776203877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcnAPqU0em6JyH9R/MSpb7uUF5Scb9Lqe9O4cMftCn0=;
	b=4va5L4RS+oCSaof230LHTCd3jF14VwlNmiNjLpkhdyx8mkEpFPJM4d8wZlaGgYbaBujEuT
	z2bh4ICgGds1weN1SiJrCHhoE/PhWpTcFlHe43U7Jz1vt9PFp+1CRdYp56SVA/KTsHhJiE
	1lHW8kNB1dPPoHyxOVeRFyNveh80YNM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0598444307;
	Tue, 14 Apr 2026 21:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA95EC19425;
	Tue, 14 Apr 2026 21:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776203875;
	bh=ZUNzTicQgDcyFP5w0RI4Nrc7tmhjfuPP2YRMHTfeXHw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bpO0O54J2tayfMK4LNj+PnNzYYE4jpf3X6/mDcNY+6rk5Iu3nuFLpco5R5ZzI0cqE
	 1FS2FTQ1hTF/HrWbhVai0pCIBDQh9x//cPwtiInWdpQwVH/0QW0vOVeXgnwFA27D+d
	 dWjnEJxD2jYfv0nRE7nM+UtQRYf+vR7EtCW2+fmlAGhtdC4+c+wLWqn3Skmb+M7S01
	 6qa3LyUdW91baafo8JAYu2iOSg2Dwsf0At3W/2Te4M3Jz+C6o7zoKelMpO3E8Hhy4O
	 vR5+74ONopnl8+XXC7oUb31d3nocIMR2Otp5hCvt3O/crKmRHOK2/WshfIcZ+gApy1
	 AkdHVnGu+8dDw==
From: Thomas Gleixner <tglx@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang@linux.dev>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Tejun Heo
 <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Waiman Long
 <longman@redhat.com>, Chen Ridong <chenridong@huaweicloud.com>, Michal
 =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
Subject: Re: [PATCH v2 04/12] tick/nohz: Transition to dynamic full dynticks
 state management
In-Reply-To: <20260413-wujing-dhm-v2-4-06df21caba5d@gmail.com>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
 <20260413-wujing-dhm-v2-4-06df21caba5d@gmail.com>
Date: Tue, 14 Apr 2026 23:57:52 +0200
Message-ID: <87tstddx27.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5212740016
X-Stat-Signature: xw6fpp5weypohqn4m7we9wp7cuneiwkg
X-Rspam-User: 
X-HE-Tag: 1776203877-41913
X-HE-Meta: U2FsdGVkX1/4DkiRVXJRgiv7tJyFrnpCu56CVjSZ72hJaPChxdXbWE5w3G5zX8o9ak2Dl1M6+xMwAIS1LktAy5KykJI/eTKH+h6GVKDj1BvuBaOspcAxAsjSLgSUI9VntYMopdIyBtC4pX+DSLKJliY9ZjlS6ywAWbzSbb1Jr1qwX71KfxGc6ONOPAMy4AoA2EOmwsYhbb8KpDP5Daq0kqKJJ3n08eZE9Rebei58j60WMwvx7+J4Wis6ISBXUipoGcs/2zqKOCndjtvP1wsKpIesSSNv8KwLcwNC0mk+/jNl3G0nITWmsA4dPNBYwAqBKdzMEI6HXPuLlUs55625KMmffIzI8YljoYa++KOtvATc1xZE1+dCtwiY3+Z0aN2TY3G+6oi1t5k9rRB/Af1pYIVYbhIN0cAeueIYYdDLLTkeqjmMfpNe4HDe23p19GcTiQPGcDdEA9g0Pi20lBKmzhvNHfgpHLRdtbr1ONx2etqPObT4vFOJufA8L9yR4PAlPxp9C9gM3/ckAADgHcUZ3CyUL3Bfu3iOCcVz6p+TPH7W3IutTCftvaWfnnzE4h1PKSvMX2gpc5IU9dyMuVKXHvPY7BsygZXWcQtlgc2+xb9txustIujGWQpE9+x/2K9ll9lNX2IOT1RSzdmB89TRC78gpd30A3wcgJmOXNU9BX+wrfRuKwSv8dkibWJyWXxXteY8v3SelQMWiPNIwrXKqpcEthIQtq6WQt61YKGg4t8imKWkXftmHioRFTAAvw/Z9uOsepXkDh1gRzR0mN91LHpA42mStaeken8JZiQOOSp46ojIkpN7C/NNHyZFLMzgdAJikbDi+6N8+hOvaA9M+rLnjJe+lb5AVUns64vLpoYmSPnap/Ick5vdnqmymFceU1SNPR1GwwLQhVDJwx4R9gLbIAo673l7SFTzDmRSQ1onh454nHZM81xcIEsogI9qyDsS3kLg4uBHrv0nptq
 pjC2EZyI
 Hsba14EXb3kU5JK2pE+HD5ZVWOZa3sARFV16SAJ9+X2QS4ONRjaO+/SgtLlEc+p78pZvdd6buLVo5c5d27hGCGvi7cvTceKQ4fMlzPLzLETo3ocxCu6XzvBqKMcH7ExAFi1kpHJroaBjHAkvFfQe9ThQTVeRS6/ku//OOe4jjxSIRsGii0hAHeQ2K+U+9Q8NJ296jz3GUaqMukOafc0Lcg/q1KSW9V/fqnczDxXw1Ng+Sk8MwrPdatJ78tgA46Carutd3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13 2026 at 15:43, Qiliang Yuan wrote:

> Context:
> Full dynticks (NOHZ_FULL) is typically a static configuration determined
> at boot time. DHEI extends this to support runtime activation.

I have no idea what DHEI is. Provide proper information and not magic
acronyms.

> Problem:
> Switching to NOHZ_FULL at runtime requires careful synchronization
> of context tracking and housekeeping states. Re-invoking setup logic
> multiple times could lead to inconsistencies or warnings, and RCU
> dependency checks often prevented tick suppression in Zero-Conf setups.

And that careful synchronization is best achieved with an opaque
notifier callchain which relies on build time ordering. Impressive.

> Solution:
> - Replace the static tick_nohz_full_enabled() checks with a dynamic
>   tick_nohz_full_running state variable.

That variable existed before and you are telling the what and not why
this is required and how that is correct vs. the other checks in
tick_nohz_full_enabled(). Also what's static about that function aside
of being marked static inline?

> - Refactor tick_nohz_full_setup to be safe for runtime invocation,
>   adding guards against re-initialization and ensuring IRQ work
>   interrupt support.

Refactoring has to be done in a preparatory patch and not 

> - Implement boot-time pre-activation of context tracking (shadow
>   init) for all possible CPUs to avoid instruction flow issues during
>   dynamic transitions.

Again lot's of hand waving without a proper explanation.

> - Hook into housekeeping_notifier_list to update NO_HZ states dynamically.

See above.

> This provides the core state machine for reliable, on-demand tick
> suppression and high-performance isolation.

I can find a lot of hacks, but definitely not the slightest notion of a
state machine. Don't throw random buzzwords into a changelog if there is
no evidence for their existance.

> +static int tick_nohz_housekeeping_reconfigure(struct notifier_block *nb,
> +					     unsigned long action, void *data)
> +{
> +	struct housekeeping_update *upd = data;
> +	int cpu;
> +
> +	if (action == HK_UPDATE_MASK && upd->type == HK_TYPE_TICK) {
> +		cpumask_var_t non_housekeeping_mask;
> +
> +		if (!alloc_cpumask_var(&non_housekeeping_mask, GFP_KERNEL))
> +			return NOTIFY_BAD;
> +
> +		cpumask_andnot(non_housekeeping_mask, cpu_possible_mask, upd->new_mask);
> +
> +		if (!tick_nohz_full_mask) {
> +			if (!zalloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL)) {
> +				free_cpumask_var(non_housekeeping_mask);
> +				return NOTIFY_BAD;
> +			}
> +		}
> +
> +		/* Kick all CPUs to re-evaluate tick dependency before change */
> +		for_each_online_cpu(cpu)
> +			tick_nohz_full_kick_cpu(cpu);

That solves what?

> +		cpumask_copy(tick_nohz_full_mask, non_housekeeping_mask);

What's the exact point of this non_housekeeping_mask?

Why can't you simply do:

		cpumask_andnot(tick_nohz_full_mask, cpu_possible_mask, upd->new_mask);

That'd be too simple and comprehensible, right?

> +		tick_nohz_full_running = !cpumask_empty(tick_nohz_full_mask);
> +
> +		/*
> +		 * If nohz_full is running, the timer duty must be on a housekeeper.
> +		 * If the current timer CPU is not a housekeeper, or no duty is assigned,
> +		 * pick the first housekeeper and assign it.
> +		 */
> +		if (tick_nohz_full_running) {
> +			int timer_cpu = READ_ONCE(tick_do_timer_cpu);

New line between declaration and code.

> +			if (timer_cpu == TICK_DO_TIMER_NONE ||
> +			    !cpumask_test_cpu(timer_cpu, upd->new_mask)) {

No line break required. You have 100 characters

> +				int next_timer = cpumask_first(upd->new_mask);

next_timer? Please pick variable names which are comprehensible and self
explaining. Also why can't you re-use timer_cpu, which would be actually useful?


> +				if (next_timer < nr_cpu_ids)

How can upd->new_mask be empty? That'd be a bug, no?

> +					WRITE_ONCE(tick_do_timer_cpu, next_timer);
> +			}
> +		}
> +
> +		/* Kick all CPUs again to apply new nohz full state */
> +		for_each_online_cpu(cpu)
> +			tick_nohz_full_kick_cpu(cpu);

This whole thing lacks an explanation why it is even remotely correct.

> void __init tick_nohz_init(void)
...
> +	if (!tick_nohz_full_mask) {
> +		if (!slab_is_available())
> +			alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
> +		else
> +			zalloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL);
>  	}

I've seen the same code sequence before. Copy & paste is simpler than
providing helper functions.....
  
> -	if (IS_ENABLED(CONFIG_PM_SLEEP_SMP) &&
> -			!IS_ENABLED(CONFIG_PM_SLEEP_SMP_NONZERO_CPU)) {
> -		cpu = smp_processor_id();
> +	housekeeping_register_notifier(&tick_nohz_housekeeping_nb);
>  
> -		if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
> -			pr_warn("NO_HZ: Clearing %d from nohz_full range "
> -				"for timekeeping\n", cpu);
> -			cpumask_clear_cpu(cpu, tick_nohz_full_mask);
> +	if (tick_nohz_full_running) {

This indentation and the resulting goto mess can be completely avoided
if you actually refactor the code and not just claim to do so.

Again, this does too many things at once and then explains them badly,
which makes it unreviewable.

Thanks,

        tglx

