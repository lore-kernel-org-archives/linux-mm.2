Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 824EBF4198C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECF6B6B0095; Wed, 15 Apr 2026 06:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7086B0096; Wed, 15 Apr 2026 06:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4736B0098; Wed, 15 Apr 2026 06:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2BA76B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:39:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A857B8C27
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:39:15 +0000 (UTC)
X-FDA: 84660443070.24.B07D8F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A949A4000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:39:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BGe4oo+R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776249553; a=rsa-sha256;
	cv=none;
	b=YVO6nCWJTfNGrPkWy1lepLt0t2LYwP6iAxtx2Lm0De8qYcbDhCBOFPSZdORUiwSlFFXSHF
	+t7GbQPatIWuKDx2rFqRACFWT3y93ymEQ+kBP74daa2Bx20UcMc/ySNzjN3UPhIZVJ+5R2
	rFF37DS+/v1M575wKnDWyLnn4yP9Uf8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BGe4oo+R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776249553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REJdlz6haytozkXBA7NxskT06BgVRXRDvLFQqIcOZ5c=;
	b=Opg6m5H7wk8Kic0gO8w/qGZonpGzCW2u2GMZjrWxlReFpMgpfEbYFZmr9IDpwRJIg3eNP9
	yv8GAJkQDpuQeqdzEZIsRF57m+hlpt1QyfH8UY3asoTtrqGoOCK5Mu44H2yhZzHwm87ULn
	sXawz5tE4kODoh2/mjokzpbVbJ39FmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94F1E44192;
	Wed, 15 Apr 2026 10:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06538C2BCB3;
	Wed, 15 Apr 2026 10:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776249552;
	bh=aheK/gwMEHe63duzE1RlMxnosDOaR8fFPomYOSoLjoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BGe4oo+Rr6efnJSmuEhBX+8+oci2s7TXrD5SAWzJAgUDrNqIZUeYYJa0E8QnfxweL
	 mJkuSi14CLX1B+D4k7vrsP/EjDztM4ALt7A8qRxFy+WRwQbnQKfKcnYNMUt9NCwuBY
	 LS4WjGrlJhJQgOYUdb5nMedpcZ20GSGY8Yjjgzt1cM4mdLcaero9rGoiwOds/QPtlV
	 mOh3tP04HhFrWRTtwssAJwOwmLoQn1F1Bs9guHDbjmRjfO3XWpgOUzeOGpbAsO4PB+
	 3duhimw3Vj44ywaZQIWg5//grARbOZy4Lt6DBUwxk/0uDBqggy2CUnKERkvyz28C50
	 b/4pQqyTYyx1Q==
Date: Wed, 15 Apr 2026 12:39:09 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 03/12] rcu: Support runtime NOCB initialization and
 dynamic offloading
Message-ID: <ad9qzVGrcgVL9SQk@localhost.localdomain>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
 <20260413-wujing-dhm-v2-3-06df21caba5d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260413-wujing-dhm-v2-3-06df21caba5d@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A949A4000B
X-Stat-Signature: aug7dgi79cm7twj3bf5oegof9rxyxnky
X-Rspam-User: 
X-HE-Tag: 1776249553-356636
X-HE-Meta: U2FsdGVkX18QEVLlxd1UP4FyPiluJ3RGPeI74xlxlO0JlAwDPnLkd2bOdwDchlZPLAJrQlqdEfRNmSqVCxPuhz3PopO/x8OWbl30G532aL26b1dtorHuRqeHCgyx1rjXaJ9LzGvln9KVG7jyoI2IrsOkzKIWIQRLLro/P1l9TGdGn+axzeWd7ff8YYVv4y5EouQXP/bG3nq42whmTKXgFTZ1ihry6o8QKQQq3pkT+3bloGbeDPhokh7f6erY2Kw7vEBC2NXTcqgK6q6Mfqj54HPLoiJ06L3KptHanXKaQDALMklHw+lTOGIgF48MxY3R2yfItkU7yOR1GOMrN8hyf/lKjFIBdBgu/z1VsHQjvXY/qSO/+sFQw33K9dUz9jfu8WSlm/p5hvi+poYWGTsZfXxLsiypBfWfNKlwXCtCQFeOkgKvdsHqbBaQZyTInqoLteWFCM9HLFgnX3aO1dXj/fSRTvLSDRx5rPp2mxpa7C8XqXnY+QkG0PrdTu+FDde6yWP9fzjvQtS6UrXaS0ZRkRe27TROATY+53jqNzQjT6K3DzeFMLY/lqllyJ/wiiEsW7EhIHydJUGvwd64yFihunWvZwDz96hzDW2xY2kmPi7ac94jsWr0Hu0+90zrcZz1ubjhyDUwHUWjwUS8opvY7QFYnLLFUyHyCdV/GWVZzUd3/X4YtPPKKhxTjnmhD1jQpf3Q/zyS3r3BWXhdBCtWs9s/UvBgaroOvWnx3gu1SSLsG0qdINjR1yFepy/sXDRh5HwKFjKSecHqyvAsHggHedte9FlitjW3WGGGtHn9rhpdZItWL6BBjKTOYXF0onBY844ecD6yoyeMYpYti27RptOkmW/yMnVAYv02q66COimTPHOTMURousXs3jT8Kowv2Xwek+O/GlSkJiATRB6gM+4TruuUple1DFUNPOP4MPW6Kk+GmxK4gMqvgdAYLy+T2khvThKdysNtZyIPxXT
 TT1UE5n/
 qeNUjPkgubzAC9aLKLduMv+gsR6/2KLyp/UYPd5n9ZMA2Zosna/oNiPNCfU/YFkpprFBeUOcxAptFCV1LsjZTF7M7PNIO1xCwZdVjlHcuqV0aSzexJfbhU3iXKBJhy6FFPEKl5VcV+aL6zkMidBw46/k30/lE7CA+wWnmBoIDQJ40uc1pvrgCS5DeBpj+8KAAzPPwmCdovHHUu5GuiZTjyF7bQjOb1YXBTbEypkpqG5RLnN3usLuxp+RS/X1WHZ3UW1jrVtYF/vGvGmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Apr 13, 2026 at 03:43:09PM +0800, Qiliang Yuan a écrit :
> Context:
> The RCU Non-Callback (NOCB) infrastructure traditionally requires
> boot-time parameters (e.g., rcu_nocbs) to allocate masks and spawn
> management kthreads (rcuog/rcuo). This prevents systems from activating
> offloading on-demand without a reboot.
> 
> Problem:
> Dynamic Housekeeping Management requires CPUs to transition to
> NOCB mode at runtime when they are newly isolated. Without boot-time
> setup, the NOCB masks are unallocated, and critical kthreads are missing,
> preventing effective tick suppression and isolation.
> 
> Solution:
> Refactor RCU initialization to support dynamic on-demand setup.
> - Introduce rcu_init_nocb_dynamic() to allocate masks and organize
>   kthreads if the system wasn't initially configured for NOCB.
> - Introduce rcu_housekeeping_reconfigure() to iterate over CPUs and
>   perform safe offload/deoffload transitions via hotplug sequences
>   (cpu_down -> offload -> cpu_up) when a housekeeping cpuset triggers
>   a notifier event.
> - Remove __init from rcu_organize_nocb_kthreads to allow runtime
>   reconfiguration of the callback management hierarchy.
> 
> This enables a true "Zero-Conf" isolation experience where any CPU
> can be fully isolated at runtime regardless of boot parameters.
> 
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> ---
>  kernel/rcu/rcu.h       |  4 +++
>  kernel/rcu/tree.c      | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/rcu/tree.h      |  2 +-
>  kernel/rcu/tree_nocb.h | 31 +++++++++++++--------
>  4 files changed, 100 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
> index 9b10b57b79ada..282874443c96b 100644
> --- a/kernel/rcu/rcu.h
> +++ b/kernel/rcu/rcu.h
> @@ -663,8 +663,12 @@ unsigned long srcu_batches_completed(struct srcu_struct *sp);
>  #endif // #else // #ifdef CONFIG_TINY_SRCU
>  
>  #ifdef CONFIG_RCU_NOCB_CPU
> +void rcu_init_nocb_dynamic(void);
> +void rcu_spawn_cpu_nocb_kthread(int cpu);
>  void rcu_bind_current_to_nocb(void);
>  #else
> +static inline void rcu_init_nocb_dynamic(void) { }
> +static inline void rcu_spawn_cpu_nocb_kthread(int cpu) { }
>  static inline void rcu_bind_current_to_nocb(void) { }
>  #endif
>  
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 55df6d37145e8..84c8388cf89a1 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -4928,4 +4928,79 @@ void __init rcu_init(void)
>  #include "tree_stall.h"
>  #include "tree_exp.h"
>  #include "tree_nocb.h"
> +
> +#ifdef CONFIG_SMP
> +static int rcu_housekeeping_reconfigure(struct notifier_block *nb,
> +					unsigned long action, void *data)
> +{
> +	struct housekeeping_update *upd = data;
> +	struct task_struct *t;
> +	int cpu;
> +
> +	if (action != HK_UPDATE_MASK || upd->type != HK_TYPE_RCU)
> +		return NOTIFY_OK;
> +
> +	rcu_init_nocb_dynamic();
> +
> +	for_each_possible_cpu(cpu) {
> +		struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
> +		bool isolated = !cpumask_test_cpu(cpu, upd->new_mask);
> +		bool offloaded = rcu_rdp_is_offloaded(rdp);
> +
> +		if (isolated && !offloaded) {
> +			/* Transition to NOCB */
> +			pr_info("rcu: CPU %d transitioning to NOCB mode\n", cpu);
> +			if (cpu_online(cpu)) {
> +				remove_cpu(cpu);

We plan to assume that the CPU is offline while updating HK_TYPE_KERNEL_NOISE
through cpusets. So you shouldn't need to care about offlining here.


> +				rcu_spawn_cpu_nocb_kthread(cpu);
> +				rcu_nocb_cpu_offload(cpu);
> +				add_cpu(cpu);
> +			} else {
> +				rcu_spawn_cpu_nocb_kthread(cpu);
> +				rcu_nocb_cpu_offload(cpu);
> +			}
> +		} else if (!isolated && offloaded) {
> +			/* Transition to CB */
> +			pr_info("rcu: CPU %d transitioning to CB mode\n", cpu);
> +			if (cpu_online(cpu)) {
> +				remove_cpu(cpu);
> +				rcu_nocb_cpu_deoffload(cpu);
> +				add_cpu(cpu);
> +			} else {
> +				rcu_nocb_cpu_deoffload(cpu);
> +			}
> +		}
> +	}
> +
> +	t = READ_ONCE(rcu_state.gp_kthread);
> +	if (t)
> +		housekeeping_affine(t, HK_TYPE_RCU);
> +
> +#ifdef CONFIG_TASKS_RCU
> +	t = get_rcu_tasks_gp_kthread();
> +	if (t)
> +		housekeeping_affine(t, HK_TYPE_RCU);
> +#endif
> +
> +#ifdef CONFIG_TASKS_RUDE_RCU
> +	t = get_rcu_tasks_rude_gp_kthread();
> +	if (t)
> +		housekeeping_affine(t, HK_TYPE_RCU);
> +#endif

No need to handle kthreads affinities. This is already taken care of by isolated
cpuset partitions.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

