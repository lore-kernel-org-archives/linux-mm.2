Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BFAC9831F
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187306B0092; Thu, 24 Sep 2026 16:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E6E6B0093; Thu, 24 Sep 2026 16:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075026B0095; Thu, 24 Sep 2026 16:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE9666B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:15:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C45A40470
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:15:18 +0000 (UTC)
X-FDA: 85249760316.14.9D63637
Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2B7F74000D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:15:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ChxHHwVg;
	spf=pass (imf11.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790280916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQ+Q6b31tVRCANGEVGMnh/gtRt24762TRSbgsQ3sP0o=;
	b=7M2oZ2kv7BH2+LxwCwmuoVbb/FgTbK6qi+geFDv5xyD1E3qVHz8fJ7nJXFAG9zokFiJrJp
	eUU/0jT0XzyET2u6B1W6ND1gB9f7YtAJTeQOFyPHQOmjAh0NLmE29eVsXb5f1MOMCtuAw4
	I4q30noaeziShWbcu68rqt+zQN/Y2VQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790280916;
	b=CU4Zhrw7Ne5c71UZJOmNenceA8qAadIKvVyt1VhIVoe9xjmmOjs/dr+w9J/KJ9067r2ubu
	3zsPmrHVCxrBTGYOqp4FMcgY7CKntTigo0fjFdy2uRmhcu6tP9ssYGKjRkggNtUF6Tr4JX
	MRTYvOAt0wMIi2v4x4oDkZ3KCpZgKnc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ChxHHwVg;
	spf=pass (imf11.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3FK/qIMRQSXYGyL8CzqTw7WcVWDR72Geww9KG/fEIE4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790280914; v=1; x=1790885714;
 b=ChxHHwVgP9KdlO3V13lZO747makbszLlWUeQH45JDzr1Ect26ZLJ5QK+I9f58Lk0zeN1jOyO
 g8w7hAeP1UrmlTpgsNCiCnDhDNFmfGqOyN7vpKYorX+1jSRcxhGh9RFPElVR28J+R4heqKeJVvv
 EdnAqvHDihIS4Z7agyct5Ggk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f3b409eef374a769;
	Thu, 24 Sep 2026 20:15:08 +0000
X-Mizu-Trace-ID: f3b409eef374a769
X-Migadu-Flow: FLOW_OUT
Message-ID: <c8b8504c-8e54-479f-a372-3d2755edaf88@linux.dev>
Date: Thu, 24 Sep 2026 13:14:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] memcg_ext: allow BPF to defer memory.high
 enforcement
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
 Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>,
 Emil Tsalapatis <emil@etsalapatis.com>, Jiri Olsa <jolsa@kernel.org>,
 Ihor Solodrai <ihor.solodrai@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev,
 Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <20260921192559.2619635-4-shakeel.butt@linux.dev>
Content-Language: en-US
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <20260921192559.2619635-4-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B7F74000D
X-Stat-Signature: r35oohrsabqgrd6kabi43rhkaycwqbpy
X-Rspam-User: 
X-HE-Tag: 1790280915-904469
X-HE-Meta: U2FsdGVkX19zXbn47IFm8lUMaGfSoLjjMNE27syKtCDKgChPpYDZcMFEkhx/9+bBENwJZpaS2hlt388qHqz/RscWXDVFomtk2jc39l/fbjHpHFp3E8ZgQjw3c3duoGYB3ByQGFqaEeizDXa8iVnupgc2Dv0uyYlF2DI3FjfSPMJ6dxULLm1oyLlKvsCv3WUhXeDL/58IZe+rJvKU9Zg2mC9gA2ep+AEb/r7VsvyFG9KEynbUceH9cPu7e4F1Yyp0EMdHZIKXpsSE2+J+fGmDrtL4Ud7ggyNJiMCffzPsmgi/QT3NgfDXSp87DfFs55poFq3ihtPRNyV17//y/a+tB7xVVa6kTVJ6umisRL5IJNh4YNQ/C+VcKHvI5tY5t54W/0JGFRwqfAp/biqLArcVJUt+aYKlfOaJzZRbccurJA39z+0XPgB8kX6p3zI+glSukcLVWR20UxDkMV+fUCaVPZuOoWrFbmRgCPMEiCAxwRadFs4f2j54g51andRMO7e50TBBocIiwGqBNlUGFLOd7cS3MdGJszU2kDqhnvW2CIyhlDMoWT7AHd1P9pAYwcoJF9d7ArTu2YdR57iL4BS/r7T4nHjGpS3y9KP5CnTK2S3NN0WDZgv8geTqG1fczVWdpvwqO0TCkgDCjSjSRvH5k4eiAiV1mdrU9tFhPRbqQdXAi5CWArXKBIZJEJV/9QyzbZBgbmOUIgUdVhi3+qQLuqJX5ZfahNd0VILDeKPKEZDuyKIIHno6rmcigZHI7Ry43mRPoFtv+btgkJV1j4elVEkiKNc2iw6WOReXuJpeXEjqbBgZLhO+IuIzNvBYKqBJSxeYvloMvOumBw3VIRQr0Hx3hzQVG+FkPVaRx4pk2vRtxJ/JFlAMpoM6TMuFr66xpXjAvQ/isy2mE5k9jCRuQl947YheAA5x1+u87eLbmDLoUxppQg/R+SWBac5Zqed+LCEiRjBftruy6JVuNGD
 1SE0kfH+
 sX8DQtGzw8xah3NK/YN02Jv57ri/gDv4aXu3hKiciv1Af0nP4DHwYUWdEYdt5r0NhGdt7gYeQxK1A3jPd2ohNbtNi08WhwSYjNmY3XMiEw4lqmTpYqYQKs9O1eArQ48LGiZdmB7MT3e5/5A+aw2IJ26u/vrGCVZlYB8h6j23wLaIwwSUzjpM6P/Czg1SeZQFMV+PIOQZyyNllYs0bTQnZWOxy8UTLlSYzQCxvNgyyBNC3vGJnPNX0/gKrQGVlgVajOFW0ndRot2RObAa/XdG0P6bhOprL9mdSCs5Dm8q710I+If4K5JLMB+csz0xS8X7VHdpRT+RWHnVgz+asl49vMXrVt2AqvoDnMHLVwzOz3vTtr/YMBPyEf2iKBLcvgPxP3KrKR763yDwUdnvxy9R0JLIPhRitBGBLVrooAfXApoUs9do+w1iTBVUpJEQgOkMpRW5PGRXQxPRnLKqwBJ9ykDSn4KVPJc7O7uDXebQh19EYHN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 12:25 PM, Shakeel Butt wrote:
> Before it returns, try_charge_memcg() calls __mem_cgroup_handle_over_high(),
> which reclaims and can throttle the task.  That happens wherever the charge
> happens, so a task holding a kernel lock can be stuck there, and everything
> waiting on the lock is stuck behind it.
> 
> Let's add high_policy ops through which a program gets a read-only snapshot
> of the charge and returns a request.  There is one so far:
> BPF_MEMCG_HIGH_DEFER_INLINE skips the inline call.
> 
> A charge runs the policies of its cgroup and of every ancestor.
> task_struct::in_bpf_memcg stops a program that allocates from re-entering
> the charge path and the dispatcher with it.
> 
> A memcg outlives its cgroup while it has charges, and cgroup_bpf_release()
> frees the arrays when the cgroup goes. Take the reference for the walk.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>   MAINTAINERS                    |  1 +
>   include/linux/bpf-cgroup.h     |  3 ++
>   include/linux/bpf_memcontrol.h | 53 +++++++++++++++++++++-
>   include/linux/cgroup.h         |  7 +++
>   include/linux/sched.h          |  4 ++
>   mm/bpf_memcontrol.c            | 82 +++++++++++++++++++++++++++++++++-
>   mm/memcontrol.c                | 31 ++++++++++++-
>   7 files changed, 176 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6215fcb07770..0c84beab396f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5032,6 +5032,7 @@ L:	bpf@vger.kernel.org
>   L:	linux-mm@kvack.org
>   S:	Maintained
>   F:	mm/bpf_memcontrol.c
> +F:	include/linux/bpf_memcontrol.h
>   
>   BPF [MISC]
>   L:	bpf@vger.kernel.org
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 4e8150848bd2..e19cf83e58f3 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -517,6 +517,9 @@ static inline int cgroup_bpf_struct_ops_attach(struct bpf_map *map,
>   
>   #define cgroup_bpf_enabled(atype) (0)
>   #define cgroup_bpf_enabled_runtime(atype) (0)
> +/* Nothing can be attached, so the walk has nothing to walk. */
> +#define bpf_cgroup_struct_ops_foreach(var, item, cgrp, atype)		\
> +	for ((void)(cgrp), (item) = NULL, (var) = NULL; 0; )
>   #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, uaddrlen, atype, t_ctx) ({ 0; })
>   #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, uaddrlen, atype) ({ 0; })
>   #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
> diff --git a/include/linux/bpf_memcontrol.h b/include/linux/bpf_memcontrol.h
> index 8204d894761e..76ea5d1c3d32 100644
> --- a/include/linux/bpf_memcontrol.h
> +++ b/include/linux/bpf_memcontrol.h
> @@ -5,13 +5,62 @@
>    * A bpf_memcg_ops is attached to a cgroup.  A charge runs the policies of
>    * that cgroup and of every ancestor, and the kernel combines what they
>    * return.  BPF only picks between things the kernel already does.
> - *
> - * The type has no members yet; they come with the policies that use them.
>    */
>   #ifndef _LINUX_BPF_MEMCONTROL_H
>   #define _LINUX_BPF_MEMCONTROL_H
>   
> +#include <linux/types.h>
> +#include <linux/gfp_types.h>
> +
> +struct mem_cgroup;
> +struct task_struct;
> +
> +/*
> + * What a policy can ask for when a cgroup is over memory.high.  The kernel
> + * ORs them, so one policy cannot undo another.
> + */
> +enum bpf_memcg_high_request {
> +	BPF_MEMCG_HIGH_NO_OPINION	= 0,
> +	/*
> +	 * Skip the inline reclaim and throttle.  The debt is kept and paid on
> +	 * the way back to userspace, where no kernel locks are held.
> +	 */
> +	BPF_MEMCG_HIGH_DEFER_INLINE	= 1U << 0,
> +};
> +
> +#define BPF_MEMCG_HIGH_VALID_MASK	BPF_MEMCG_HIGH_DEFER_INLINE
> +
> +/* Read-only snapshot.  Only values the caller already has. */
> +struct bpf_memcg_ctx {
> +	struct mem_cgroup	*memcg;			/* charged memcg */
> +	struct mem_cgroup	*memcg_over_limit;	/* NULL if none found */
> +	struct task_struct	*task;			/* current */
> +	u64			cgroup_id;
> +	u64			over_limit_cgroup_id;	/* 0 if none */
> +	u64			nr_pages_over_high;
> +	u32			gfp_flags;
> +};
> +
>   struct bpf_memcg_ops {
> +	/**
> +	 * high_policy - say where memory.high should be enforced
> +	 * @ctx: snapshot of the charge
> +	 *
> +	 * Return: bits from enum bpf_memcg_high_request, or 0.  Other bits
> +	 * are dropped.
> +	 */
> +	u32 (*high_policy)(const struct bpf_memcg_ctx *ctx);
>   };
>   
> +/*
> + * Run every high_policy on @memcg's cgroup and its ancestors, and return the
> + * combined request for the caller to act on.
> + *
> + * @memcg:	the memcg being charged, never NULL
> + * @over_limit:	first memcg found over memory.high or swap.high, or NULL
> + * @gfp_mask:	the charge's gfp mask
> + */
> +u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
> +			  struct mem_cgroup *over_limit, gfp_t gfp_mask);
> +
>   #endif /* _LINUX_BPF_MEMCONTROL_H */
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 5dfa915a630e..cf92b6cec819 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -959,10 +959,17 @@ static inline void cgroup_bpf_put(struct cgroup *cgrp)
>   	percpu_ref_put(&cgrp->bpf.refcnt);
>   }
>   
> +/* Fails once the cgroup is gone and its bpf state has been freed. */
> +static inline bool cgroup_bpf_tryget_live(struct cgroup *cgrp)
> +{
> +	return percpu_ref_tryget_live_rcu(&cgrp->bpf.refcnt);
> +}
> +
>   #else /* CONFIG_CGROUP_BPF */
>   
>   static inline void cgroup_bpf_get(struct cgroup *cgrp) {}
>   static inline void cgroup_bpf_put(struct cgroup *cgrp) {}
> +static inline bool cgroup_bpf_tryget_live(struct cgroup *cgrp) { return false; }
>   
>   #endif /* CONFIG_CGROUP_BPF */
>   
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8b3d47a325cc..4b20a346aaa8 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1031,6 +1031,10 @@ struct task_struct {
>   #ifdef CONFIG_MEMCG_V1
>   	unsigned			in_user_fault:1;
>   #endif
> +#ifdef CONFIG_MEMCG
> +	/* A bpf_memcg_ops program is running; do not recurse into policy */
> +	unsigned			in_bpf_memcg:1;
> +#endif
>   #ifdef CONFIG_LRU_GEN
>   	/* whether the LRU algorithm may apply to this access */
>   	unsigned			in_lru_fault:1;
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index fd6dff150f01..cfd0f1d443c9 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -246,8 +246,17 @@ static const struct btf_kfunc_id_set bpf_memcontrol_reclaim_kfunc_set = {
>    * request and the kernel acts on it.  Nothing here reclaims or sleeps.
>    */
>   
> -/* CFI stubs.  A slot points at these while its policy is being detached. */
> +/*
> + * CFI stubs.  These really run: a slot points at them while its policy is
> + * being detached.  Return 0, the identity for the kernel's OR.
> + */
> +static u32 high_policy_stub(const struct bpf_memcg_ctx *ctx)
> +{
> +	return BPF_MEMCG_HIGH_NO_OPINION;
> +}
> +
>   static struct bpf_memcg_ops __bpf_memcg_ops = {
> +	.high_policy = high_policy_stub,
>   };
>   
>   static const struct bpf_func_proto *
> @@ -326,6 +335,77 @@ static struct bpf_struct_ops bpf_memcg_ops_desc = {
>   	 */
>   };
>   
> +static void bpf_memcg_ctx_init(struct bpf_memcg_ctx *ctx,
> +			       struct mem_cgroup *memcg,
> +			       struct mem_cgroup *over_limit, gfp_t gfp_mask)
> +{
> +	ctx->memcg = memcg;
> +	ctx->memcg_over_limit = over_limit;
> +	ctx->task = current;
> +	ctx->cgroup_id = cgroup_id(memcg->css.cgroup);
> +	ctx->over_limit_cgroup_id = over_limit ?
> +		cgroup_id(over_limit->css.cgroup) : 0;
> +	ctx->nr_pages_over_high = current->memcg_nr_pages_over_high;
> +	ctx->gfp_flags = (__force u32)gfp_mask;
> +}
> +
> +u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
> +			  struct mem_cgroup *over_limit, gfp_t gfp_mask)
> +{
> +	const struct bpf_prog_array_item *item;
> +	const struct bpf_memcg_ops *ops;
> +	struct bpf_memcg_ctx ctx;
> +	u32 acc = BPF_MEMCG_HIGH_NO_OPINION;
> +	struct cgroup *cgrp;
> +
> +	if (!cgroup_bpf_enabled(CGROUP_MEMCG_OPS))
> +		return acc;
> +
> +	/*
> +	 * Only the default hierarchy has a cgroup_bpf, and the static key is
> +	 * global, so one policy anywhere turns this on for v1 memcgs too.  A
> +	 * v1 memcg still cannot get here, because memory.high and swap.high
> +	 * are both v2-only and so it never builds the debt that leads to this
> +	 * call.  A hook on a path v1 can reach needs its own cgroup_on_dfl()
> +	 * test: a v1 cgroup has no effective array and an uninitialised
> +	 * cgrp->bpf.refcnt.
> +	 */
> +	cgrp = memcg->css.cgroup;
> +
> +	/*
> +	 * A program can allocate and re-enter the charge path.  Skip the
> +	 * nested call.  This guards the callbacks only.
> +	 */
> +	if (current->in_bpf_memcg)
> +		return acc;
> +	current->in_bpf_memcg = 1;
> +
> +	rcu_read_lock_dont_migrate();
> +
> +	/*
> +	 * A memcg outlives its cgroup while it has charges, and
> +	 * cgroup_bpf_release() frees the arrays when the cgroup goes.
> +	 */
> +	if (!cgroup_bpf_tryget_live(cgrp))
> +		goto out;
> +
> +	bpf_memcg_ctx_init(&ctx, memcg, over_limit, gfp_mask);
> +
> +	bpf_cgroup_struct_ops_foreach(ops, item, cgrp, CGROUP_MEMCG_OPS) {
> +		if (ops->high_policy)
> +			acc |= ops->high_policy(&ctx) &
> +			       BPF_MEMCG_HIGH_VALID_MASK;
> +	}

If I'm reading correctly, the gfp_mask at this point doesn't account for
task restrictions, so the BPF program may see __GFP_FS, __GFP_IO, etc
which may later be cleared when setting up the scan_control instance.

