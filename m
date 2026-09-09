Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4837C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 20:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A800D6B008A; Wed,  9 Sep 2026 16:07:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A570E6B008C; Wed,  9 Sep 2026 16:07:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D496B0092; Wed,  9 Sep 2026 16:07:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0C06B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:07:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 069811C1E58
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:07:13 +0000 (UTC)
X-FDA: 85195307946.01.29F2483
Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3261A14000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:07:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PCRRj0kW;
	spf=pass (imf23.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788984431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoAO8xH5PIMRwA/Kfo9Esj4O3/Me5AzxgWN4yQPbIcs=;
	b=Bt8w3/ptSJke/IUEakF0cybpSv/ZeF5/XUJwnvwG0lHrcOc1gy+2ikJ0VPmh+JM9DlPnW6
	j4jQo9u6TpYZTCiFWfnGRoni5o3yJUqYwWTgj4sO08IRRI13daHKlX5pBM7dGwaDI9vvIF
	SfvVGRYl8yZCYesktr8PJF33EfCJlLI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PCRRj0kW;
	spf=pass (imf23.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788984431;
	b=qlSrTki1luX6tjeeO01XYw61I/3S6b+7Ao+873RMSkKOlOUYwxCiZMrQwfCftf4VgQaaoh
	WXe+WyDqjygt2h0N+l5O3g445EEMGLfeKG7hQkzqeFIzugtPb901BYybEq8uWtD6tZxukD
	qug55juUeF+TvdmYL8Po6aCygfpJcE4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OiDfq17QAZlSyhJb6xUWTPzHFTNiVBbD2d9LR/t1Ipc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788984424; v=1; x=1789589224;
 b=PCRRj0kWKKwpfIqAaP/+SG1CoXIuaUgKbVCd1lRHj73sXblIwBE157D2INvF3Ju1BzVjWhvt
 Eo5A/s3fQ0LCczJrksv3JEUsx6fWX+4nUcfHCz/26RpZXitiZ+7MRCm5mpzM1SzB+EIfMUb4i1y
 bsCEOuQwZ1sLa/GH+6tCsqss=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 04bb54aa1bc2000a;
	Wed, 09 Sep 2026 20:07:04 +0000
X-Mizu-Trace-ID: 04bb54aa1bc2000a
X-Migadu-Flow: FLOW_OUT
Message-ID: <d8d4de31-79ee-425f-8759-92a1ebfa9d0a@linux.dev>
Date: Wed, 9 Sep 2026 13:06:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v9 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
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
References: <cover.1788857915.git.zhuhui@kylinos.cn>
 <06452a0d7722c92a38fdfd117954d244c3e52d0e.1788857915.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <06452a0d7722c92a38fdfd117954d244c3e52d0e.1788857915.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3261A14000A
X-Stat-Signature: 56ogmz8czcnfk4htdsof7yxxzdehuui7
X-Rspam-User: 
X-HE-Tag: 1788984428-459942
X-HE-Meta: U2FsdGVkX1+5QF0BSMAJ9/73lX0l3iqy477Mz8b0ClUaoCfcfloxK1qtO8/2dPKbnQDALPy5miDHKq3LqlEjo9JoeRQnbqKneeLGe3xS7pt8tKqHfxwKPqrlZQeVYLgNh/WgAjWCb5gbzWEJZNKQKPrvi9Qo4PcmQSFH8imVquCByh3nnkPfCdYQwWY50pB2AxR7ZeWNbVbQolxww/Qc3YSeNiWYllPTPLbdzZxrnpqgcRydGHBY+BaBavSqRrVqFHGDms7HIyLZEHzq+u4unnLLR8a+MYIRhS+PqhQRwrGWeXORE921BoAVSwRjFACToRPYPt+h7hCGW/qKdAFokukEE08c4lgDpvu/Aw7vgfXwQ1zn7ycAs6RxurD+ZedZBcO+rKxJxR18Etii6nAX3jrA1fdZmve+IsMJtT6GwD73uGXWHTSQVS3pR7uQisetn4/+AyiV9FV/UuiIkaa/mylYzfSLbY+QRCZ5kSIdwbwRNSaHNyTeaVMSYM+XDUH6ENMf6OtXHjeIindAXSbe61Y0izpEyCA13R6v+QyIMIx8ol7PMGkdsejSgsWkThQK8FxYg/ND7pS8W+6UPXZ0r/x+FWQMwFh6QaiKY/lqhHJgrKZJ4JRvNybp334oa3GyssoBkG0F0Jden14fsO7ZZu8sXF/QtPisP/gDW44VcqD/xFpvCFLGMUXLsKezdEsPd5CRW8OWcgXSA/s3UZi87wXBAN3VAJ0ahdXaYJkZm3Agg9RSxz5ghsFnwe08wvPfy7ZqqyVmQ27hom3ECdsIq7qEFtu17Ly0gtC/96R7jPAaU6Y5cHRPmzWqKaN9M1WY7ay8f/yIZtGCeDBAJqfzehLvPrt1eJ9BmIxLDMRp3wLbHsFvY1UJVr1w/YYbRPFqJvaUu7eN3KHHOrlgSehRItuaUdDFA1IlJuEkd7hAGuc6uc6JFk80d+t2DgH70GeRdb8wHrFntudzvaKUVN0
 PplwTQQ4
 pG8iItZJpbtlCnwS25S8jF8GzlvaiUsxIlzyKh1UBDsbPIAh/olaJBxsVhuLHfiehLAg1zn7pGCs4aZFt5EZKNChvmFOmMf2DPktx9Ut1VYn9Kt/WMYCmX0QiCh/sbyjK+QJO5uCPIOSkgl/9sOCdomvhYFqGvw1YonEOmGuNwJQYcHNIZ9NRjPUgmdGnbZWnLkMbHEYIvJhxcRQ1xqf/Szl5TpjGPf43gabxtJXg8cEXqdc0NNLkZ9ff1iCIGQ6qtN2kDhjE9IewYDBCiCBYUsle+hVB/fERmAMQTtWPpJ5zIWFmSUxhW29ZrCCuFwzXPZgE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 2:11 AM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> BPF programs can observe memory pressure on a cgroup (e.g. refault
> stats via bpf_mem_cgroup_page_state()), but cannot act on it:
> triggering reclaim on a chosen cgroup requires writing to
> memory.reclaim, which BPF cannot do. Add bpf_proactive_reclaim(),
> a sleepable kfunc which performs one proactive reclaim pass on a
> given memory cgroup, similar to a write to memory.reclaim but
> without retrying until the target is reached, so that when and how
> hard to reclaim is BPF policy rather than hard-coded thresholds.
> 
> Since some bpf program types may be invoked while holding fs locks,
> limit the kfunc to BPF_PROG_TYPE_SYSCALL only, to avoid deadlocking
> in filesystem shrinkers on the reclaim path. A SYSCALL program can
> invoke the kfunc directly, or asynchronously from its bpf_wq or
> task_work callbacks, which run in process context and keep the> SYSCALL program type.
> 
> The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
> following the precedent of high_work_func(), the memory.high
> workqueue fallback, which bounds each reclaim request the same way
> and uses one work item per memcg. 

You can end the sentence here at "fallback" and remove the rest.

> Note that only the reclaim target
> is capped: the actual scanning work and its duration are not
> bounded. Reclaiming more than one batch is left to the BPF program
> rather than enforced by the kfunc: with one call per bpf_wq callback
> and the same work item requeued for the next batch, the program can
> also stop submitting batches in between, e.g. once the target cgroup
> is dying.>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>   mm/bpf_memcontrol.c | 88 ++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 87 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..2817c6db9a5d 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -6,8 +6,11 @@
>    */
>   
>   #include <linux/memcontrol.h>
> +#include <linux/swap.h>

You can drop this since internal.h below pulls it in.

>   #include <linux/bpf.h>
>   
> +#include "internal.h"
> +
>   __bpf_kfunc_start_defs();
>   
>   /**
> @@ -159,6 +162,73 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
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

It's awkward to point users to a numeric range and one magic number.
What if you changed the associated macros to an enum:

enum {
   MIN_SWAPPINESS = 0,
   MAX_SWAPPINESS = 200,
   SWAPPINESS_ANON_ONLY = MAX_SWAPPINESS + 1,
};

Then these would be available in vmlinux.h and you could name them in
the comment above.

> + *         means anon-only reclaim; a negative value means the memcg's
> + *         own swappiness is used

You reject anything less than -1 below. This should say "-1" instead of
"a negative value".

> + *
> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> + * memory.reclaim, but without retrying until @size is reached.
> + *
> + * Only the reclaim target is capped: @size is clamped to
> + * MEMCG_CHARGE_BATCH, following the precedent of high_work_func(),
> + * the memory.high workqueue fallback, which bounds each reclaim
> + * request the same way. The actual scanning work and its duration
> + * are not bounded. To reclaim more, call this kfunc repeatedly
> + * instead of passing a larger @size.
> + *
> + * The kfunc can be called directly from a BPF_PROG_TYPE_SYSCALL
> + * program, synchronously in the context of the thread running the
> + * program, or from the bpf_wq and task_work callbacks of a SYSCALL
> + * program, which run in process context and keep the SYSCALL program
> + * type. It is registered for BPF_PROG_TYPE_SYSCALL only, because
> + * generic sleepable programs may run with filesystem locks held or
> + * in NOFS/NOIO contexts, where the reclaim path could deadlock on
> + * those locks via filesystem shrinkers.
> + *
> + * For asynchronous reclaim of more than one batch, driving the
> + * reclaim from a bpf_wq callback is recommended: call this kfunc
> + * once per callback and requeue the same work item for the next
> + * batch, instead of looping inside the callback and monopolizing a
> + * workqueue worker, and give each target memcg its own work item,
> + * as high_work_func() does with one work item per memcg. Whether
> + * to submit the next batch is up to the BPF program, which can stop
> + * at any point, e.g. once the target cgroup is dying.
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

It would read more consistently if it was "swappiness == -1" here, since
you reject less than -1 early on.

> +
> +	return nr_reclaimed * PAGE_SIZE;
> +}
> +
>   __bpf_kfunc_end_defs();
>   
>   BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> @@ -174,19 +244,35 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
>   
>   BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
>   
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


