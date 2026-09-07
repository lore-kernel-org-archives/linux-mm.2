Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BED8DC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581306B008A; Mon,  7 Sep 2026 14:51:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A566B008C; Mon,  7 Sep 2026 14:51:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4DC6B0092; Mon,  7 Sep 2026 14:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3263A6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:51:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D4791A028A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:51:16 +0000 (UTC)
X-FDA: 85187858952.06.3470C84
Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	by imf15.hostedemail.com (Postfix) with ESMTP id 02510A0005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:51:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EcL5nzSM;
	spf=pass (imf15.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788807074;
	b=pyzmkUhdr2OzIvGuW4BltVKMMpUHBo9kTjukdOKs6EmgvUdnXqYj5w4kwOoz33R27SCLPu
	RcC3jRLPdHiNemW02Z5Uy7N13Apbvynln599j//+b5rQ0cSIO1HVFu1dJ6mLTCnEv0XDz6
	QfvDmTJn4LlHE9FCmkFPsjROess+4Sc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EcL5nzSM;
	spf=pass (imf15.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788807074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nq5kH4buBYfnVz92jkpoGNXt/0aiwaMBDOTgjaNywH0=;
	b=4ttkiafFYb2BuVr++LmaY/pqO9htxtS5vstkCSbTSlYzCaIMY0AmKqVzrsBHkFja4YtBdF
	3Hl6+kb+krZXrYVFmry9MpYGtnEWR++eUAESP5DdbvrVRYo28Vs+hZWOzurhgDBDhyJfHb
	gLHV/voM52pRjFPpld8xhPoEiGxmAkQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NddO47tYxBI2h7DsCq/hs4VZYoZz/R9enIlpJ3TUNlw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788807072; v=1; x=1789411872;
 b=EcL5nzSMc/vm/90o63vsPdZHGM3U7c9pGvBSvfZmIIpjN9vH34WFfRrRdNfk2xBuYWbQ6Ckr
 MeV4cOF0JgerKOzZLNevblkr8FTzqlzYmcJ1cbCFhA3P5a037/TPsO5vBCLIsmzoNgzHzwMK6Lp
 mxU+qbAzF1dt6uO4RS6b8g68=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0ed654492ec4f958;
	Mon, 07 Sep 2026 18:51:11 +0000
X-Mizu-Trace-ID: 0ed654492ec4f958
X-Migadu-Flow: FLOW_OUT
Message-ID: <6df0f368-0acb-49b4-8bf6-c82d3d2c79a1@linux.dev>
Date: Mon, 7 Sep 2026 11:51:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v8 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
To: Hui Zhu <hui.zhu@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>,
 Barry Song <baohua@kernel.org>, Geliang Tang <geliang@kernel.org>,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1788764121.git.zhuhui@kylinos.cn>
 <0f1e2b5408aef7baaacf7306dff5f6d4fb91e441.1788764121.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <0f1e2b5408aef7baaacf7306dff5f6d4fb91e441.1788764121.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 02510A0005
X-Stat-Signature: p5qhfghrws4a3nyi37juxwtgi4mmiqq5
X-HE-Tag: 1788807073-498136
X-HE-Meta: U2FsdGVkX18k5m0WKkaAcPbo2fRgsne8gdl3npuL8Faww76s5GGlQSUNoTqrL/tuOdBuzXgVNVI/kouhyfCG0rpltHOsCmBK9wFyXFMd4BWheY0WKKAGwehSGf6Oyi0Q8l7/NPQgKjbCj9qFnzxoYq0SnEHY6+mVhsPltA5jx57Rb61XZ7bvpXc5T+BU1+UqDefLyTCpW/WcFw+9GrR4tad5d2QkJUZt9yIYE0fB0uNncv3Fqif+GA4nxp7fiQkGLywxQrwpKTUBnjrZu7iMFEO4lP1wnprndkhTeJXKRqucPIB3JuJjl3z1geDsW2Kmn9R89Tkk/YXqjWeYzzQvWWYtmEqf1AUjgucSJvGC8U+5EstqvKswsUWrY9UjLBpLVNUup5StH6U9RhLN2A/cv+xNx/Jyqn761YBghPblWeRspAaaFgu/bgKOcs9ZFAv/EPhrn/QXj67hgjwj3NrTzq/TqHvgkxP4LwBjEmtX+fqE9n7QI2KSlQQvYyygTxETySxU611cFNRnPL7UtRC4GpZJ+hvjCfQHHreJpPSfdIKjJe3T66KwFbAimxH0MYW/GAhnObEerxcncFYpRiBXUNWnJ1y/JOMdxOXSp7gjKzh32AtsA+PCr5V047jCR57hmMUJfA1DJQ/gNhrs5fHVaiGo1oPY1tUiqCskK+fQD8ufhAklEQIOO5BWUcARR856K1uGvtb9UjS6wKrAzxHGNFh8CunDjWNaQN6cvUu7DD/onIdmcVtV6xx9hrJfnwDMfUHeYi8P0vtPA6RZZAUqRTlZzS/iiqQRmSJfaurtsfSzzW4424j5b6J0X24n/YLf+TWJMEsEPqqBeh5yeSqdA8pNqIHekN32g36HK7750k+xry0WlhihXjoo+1RZ7Z2dWh84Fz1dVfAjFMvuMcW+v+Op5o5VgUFLuEE4u7Xkmd/Zps7KrJi56m6sSeATJsenLp2FFfXI7UUy1GyGItc
 +j39tSr3
 6kZoQtstSJGvDNCb0EnQZWLzTEFzr6O5xT/hmDv4pbqgTEq9XfiF6+AkqlmsHaxRexf3XIjMaqWIK23L8WDXejeQ3l3xi9O05pS9M4YnpKc/1UW1ug8p04TYcb8nAUOhoKCOEVYVRFGbIAHnYgrd+OYKkS1c8KA3wm0YV2CWMi6qj9o+6B2kPdgYF+sKQ9LQMeEjB5779PB684+mxBms+XdRNOuDBWhGH1lCO34ua3hM5uS8AP/2GEb6TkJoY52LSQispbz+CSzzOVtqyQvizkuKytYApmTpb8OAx+jfGxJxywaRLOO0lT6TrqFE4Ix9t42TYOMnXaXHVXpQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hui,

On 9/7/26 12:08 AM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
> proactive reclaim pass on a given memory cgroup, similar to a write
> to memory.reclaim but without retrying until the target is reached.

The cover letter has the reasons why you're adding this kfunc. It should
be included before this paragraph.

> 
> The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
> always runs in a clean process context. Generic sleepable programs
> may execute with filesystem locks held or in NOFS/NOIO contexts,
> where the reclaim path could deadlock in filesystem shrinkers. A
> SYSCALL program can still drive reclaim asynchronously through
> bpf_wq or task_work callbacks, which run in process context and
> keep the SYSCALL program type, so they can call the kfunc too.

I think this paragraph would read better if you inverted the decision
and rationale. Something like:

"Since some bpf program types may be invoked while holding fs locks,
limit the kfunc to only syscall progs to avoid..."

> 
> The reclaim target of a single call is clamped to MEMCG_CHARGE_BATCH.
> try_to_free_mem_cgroup_pages() takes nr_to_reclaim as a lower bound,
> so nothing else limits how long one call scans. An unbounded call
> stalls other work on a shared workqueue, and since lru_lock is held
> with interrupts disabled the contention delays IPI handling and can
> cause CSD lock stalls. MEMCG_CHARGE_BATCH is the bound already used
> by high_work_func(), so each call becomes a bounded unit of work.

It's not strictly speaking a bounded unit of work though. The scan work
time can vary.

The example of interrupt delay I gave on the prior rev is included here,
unnecessarily increasing the verbosity. I think you can just say that
you're following the precedent in high_work_func() which uses the same
cap, but I would still emphasize like I said above that the actual
scanning work is not bounded.

> 
> Reclaiming more than one batch is left to the BPF program. This is
> documented in the kfunc rather than enforced: call the kfunc once
> per bpf_wq callback and requeue the same work item for the next
> batch instead of looping inside a callback, and give each target
> memcg its own bpf_wq item. Keeping the policy in BPF lets a program
> decide when to reclaim and when to stop, e.g. once the target cgroup
> is dying.

You should be explicit on the different calling contexts. This is one
way to use it, but someone could still invoke it directly in the syscall
program.

> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>   mm/bpf_memcontrol.c | 94 ++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 92 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..74ccac30c011 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -6,8 +6,11 @@
>    */
>   
>   #include <linux/memcontrol.h>
> +#include <linux/swap.h>
>   #include <linux/bpf.h>
>   
> +#include "internal.h"
> +
>   __bpf_kfunc_start_defs();
>   
>   /**
> @@ -159,6 +162,71 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>   	mem_cgroup_flush_stats(memcg);
>   }
>   
> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> + *                         cgroup
> + * @memcg: the target memory cgroup to reclaim from
> + * @size:  the amount of memory to reclaim, in bytes, clamped to
> + *         MEMCG_CHARGE_BATCH (64 pages)
> + * @swappiness: the reclaim swappiness, in the range [0, 201] where 201
> + *         means anon-only reclaim; a negative value means the memcg's
> + *         own swappiness is used
> + *
> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> + * memory.reclaim, but without retrying until @size is reached.
> + *
> + * @size is clamped so that one call is a bounded unit of work, matching
> + * the memory.high workqueue fallback in high_work_func(). To reclaim
> + * more, call this kfunc repeatedly instead of passing a larger @size.

Again I think "bounded unit of work" is too strong here. The reclaim
target is clamped but the scanning work/time will vary. Lets be explicit
that we're only capping the reclaim target.

> + *
> + * This kfunc is restricted to BPF_PROG_TYPE_SYSCALL to ensure it runs
> + * in a clean process context. The SYSCALL program can schedule the
> + * actual reclaim work via bpf_wq or timers, which also execute in
> + * safe process context (workqueue, task_work).

"clean" and "safe" are ambiguous here.

This is another example of mixing calling contexts. You should separate
them. i.e. can I call this directly in a syscall prog? does it have to
be async work? Also, as it reads, it makes it sound like calling the
kfunc is ok in a timer program.

> + *
> + * When reclaim is driven from a bpf_wq, call this kfunc once per
> + * callback and requeue the same work item for the next batch rather
> + * than looping inside the callback: a long-running callback stalls
> + * other work on the shared workqueue, and because lru_lock is held with
> + * interrupts disabled the resulting contention also delays IPI
> + * handling. Give each target memcg its own bpf_wq item, so that
> + * reclaiming one memcg neither serializes behind nor piles up on top of
> + * another. Deciding whether to submit the next batch is up to the BPF
> + * program, which can stop at any point, e.g. once the target cgroup is
> + * dying.

If this is the intended usage, be more explicit on the recommendation.
Reduce the verbosity on the interrupt delay here, similar to the advice
on the changelog.

> + *
> + * Must not be called with a filesystem lock held: the reclaim path
> + * may deadlock on it via filesystem shrinkers.

This should move to the syscall-only prog rationale. Otherwise, it reads
like something for callers to enforce.

> + *
> + * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
> + * smaller than a page, or (unsigned long)-1 if @swappiness is out of
> + * range.
> + */
> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> +						unsigned long size,
> +						int swappiness)
> +{
> +	unsigned long nr_reclaimed;
> +	unsigned long nr_pages;
> +
> +	if (swappiness < -1 || swappiness > SWAPPINESS_ANON_ONLY)
> +		return (unsigned long)-1;
> +
> +	if (size < PAGE_SIZE)
> +		return 0;
> +
> +	nr_pages = min(size / PAGE_SIZE, (unsigned long)MEMCG_CHARGE_BATCH);
> +
> +	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages,
> +						    GFP_KERNEL,
> +						    MEMCG_RECLAIM_MAY_SWAP |
> +						    MEMCG_RECLAIM_PROACTIVE,
> +						    swappiness < 0 ? NULL :
> +								     &swappiness);
> +
> +	return nr_reclaimed * PAGE_SIZE;
> +}
> +
>   __bpf_kfunc_end_defs();
>   
>   BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> @@ -171,22 +239,44 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events)
>   BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
>   BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
>   BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
> -
>   BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
>   
> +/*
> + * Proactive reclaim needs a clean process context, so it is restricted
> + * to BPF_PROG_TYPE_SYSCALL. The bpf_wq and task_work callbacks that a
> + * SYSCALL program schedules run as the same program type, so they can
> + * still invoke it; generic sleepable programs (e.g. fentry on reclaim
> + * paths, inode_rmdir) cannot.

This comment feels out of place here and is not buying much at this
point. You already explained it in the kfunc comments, and the syscall
only registration further down is explicit enough by now.

> + */
> +BTF_KFUNCS_START(bpf_memcontrol_reclaim_kfuncs)
> +BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
> +BTF_KFUNCS_END(bpf_memcontrol_reclaim_kfuncs)
> +
>   static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
>   	.owner          = THIS_MODULE,
>   	.set            = &bpf_memcontrol_kfuncs,
>   };
>   
> +static const struct btf_kfunc_id_set bpf_memcontrol_reclaim_kfunc_set = {
> +	.owner          = THIS_MODULE,
> +	.set            = &bpf_memcontrol_reclaim_kfuncs,
> +};
> +
>   static int __init bpf_memcontrol_init(void)
>   {
>   	int err;
>   
>   	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
>   					&bpf_memcontrol_kfunc_set);
> -	if (err)
> +	if (err) {
>   		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
> +		return err;
> +	}
> +
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
> +					&bpf_memcontrol_reclaim_kfunc_set);
> +	if (err)
> +		pr_warn("error registering bpf reclaim kfuncs: %d", err);
>   
>   	return err;
>   }


