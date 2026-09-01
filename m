Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C3AC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12AD6B0088; Tue,  1 Sep 2026 14:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D486B008C; Tue,  1 Sep 2026 14:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990296B0092; Tue,  1 Sep 2026 14:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60BF66B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:19:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C397D1204BE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:19:48 +0000 (UTC)
X-FDA: 85166006856.12.73D88A4
Received: from mta0.migadu.com (out-94.mta0.migadu.com [91.218.175.94])
	by imf02.hostedemail.com (Postfix) with ESMTP id 661D68000C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:19:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cHcOXZ+F;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oq8v/6hkH54UlcPZtDCucEfRX/c9y/6/8t3adH/WDMs=;
	b=es+6vE4ng9TNsHw3ZE8PYk/uIU/OD2POF7gOJtca8WRTr8+UElocaIFa2CSITcD0UYi60j
	r2KhQuufWYhv2VU9s8JxrJQA6m0R0VWOHhPMctBb6x3ylv9rOYwk6VwuP6QGyY3Q2wp/ee
	Hjr8An+X8xJBzHmHt7her+lgbRgFyvU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788286786;
	b=5McLPYZebxcDMNg/WRqtqQ5tuuxAD4QSl5X0qu/8r4IYh1PFTPky9X+v/AnRJHaljfIxFA
	OmFQ317Mw29IFh83SXLmkPhSTselB8pZJr87zbSr1ujv7ktEDk3gFfftd5w4RUcuZRMZj1
	PUBt7LmcmggTKWXFCjZETpA3R/MpyNs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cHcOXZ+F;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Eh4Q1j/sDqvvOGlAPAzSg3v//wrdVpn0jOUzlGRcUjA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788286782; v=1; x=1788891582;
 b=cHcOXZ+FYT8Crz8bbugfydoCE4jwu54mxLZtcfmBrchQNeJPBB+iL3rzn/kn2yFchWuXhSRN
 tYPI49COlO8NGmeIIdbfQ4bZ786KzkU7MgjkAJM4C+yEARq6dVOR+9/aI/ALLvqUEriG+VBetY1
 Pmz+5uWrpn/sXKzwecMXIOdY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 25cdd9ad8101d769;
	Tue, 01 Sep 2026 18:19:41 +0000
X-Mizu-Trace-ID: 25cdd9ad8101d769
X-Migadu-Flow: FLOW_OUT
Message-ID: <f9e77f14-a6a9-4cd3-a217-43abe4747275@linux.dev>
Date: Tue, 1 Sep 2026 11:19:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v6 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
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
References: <cover.1788228773.git.zhuhui@kylinos.cn>
 <24726feaf836608d78986e2c565461cf809d8326.1788228773.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <24726feaf836608d78986e2c565461cf809d8326.1788228773.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 661D68000C
X-Stat-Signature: srnze36usfabcjau9643wyyutbht1zjw
X-Rspam-User: 
X-HE-Tag: 1788286786-130362
X-HE-Meta: U2FsdGVkX1/+jtbhEEPHva7S1iD+df6Q2laU1VYvL1iaY15eaJYgwE82mWhEtwcpjKGZoaxDMv6Uho030sseIWqyStKln3KGkVjAmMy6QXHmGexGvSOh0RobGCZNkbNWZyz9/pw6mApUp2DT4qcKV3D1XQ2EVKvUHuF1JTj6bQM5/uIsHJovg0gJJXXQC1I1kaUVXQh5DXFiSlIu5j5nCspR1f/y4yylq9EygVVzS62wJRree1zyOLJK1qmcLBTcU5ZL10e+0+bMVkLH1Q9BTPMUW1N02/EBncnpBjBkPzB/O9ufiorDvBaQKaZOXGmOM5CURONf2U7HKTwDSYpJBjLRlxEdcVVU6xg3CRzVzlo54rwT9Uvf1IL0ZgijnsNtFbEmXG9Xi0GQGPUjh8PbwyB4OwpH/+YtxPuf9ZoFgRDHXzEoIRMYHLIYEtHT4F5tElMACwD0CJO4wmcViyzF1CdynHJlqV5TSp6R02f7OpMj3cDlWlRdpb2qmWgOyPS6rFEV5UsMDcrIqYMKb8qhIDDpgDwpvB0l25eLUdhJQ3tRBdobLA5GoNG29w8//p8cg2Akk2SIx19vawmMcyuWTzV1P1LMnAr//2Hmw95MivFr69fpoH+liH8L79QNy9iApHxGque3bctXSTOdYLiAZsT61wWIChg2Aeri2FXmddb8rKBawynobf5Q0LY29Cd0y584Y4PZmq5/Hh2oeyIZlfMePSm9VsJqnJKMBw+He27j9jJNRPV5tSib7n/Du8HWWQAmbA9CyZQFG8n8Qqjnx57Yp5Jyk+a+bR2QQMwzjs35PtMIiAF4V5cdG6QoMAqs9ai3LKEHpO3RvEEfqR7+/YdO2JHjlgF0xpwY+AkKhEZjT5r+P/bBS24y5uxDW467vEL+TzPprWNkzy8sOrZ3ZEhhk7wS6+0Lei3nZcfxSaIqk0oGe4K1UQy+PrtP1ws1pzN8e+cB7hoy26tpWsF
 031z6ui9
 9vocXL+sYyKJ2oWOA5lPBdAcWFR4tuQU5pF+3ScDZhRdASKp7pDbueex2cFBy4b8WMh61UeNkkX7eRhh0SioJLHDgShMxxWxNeC/qrUkeWsRl1Ltc/yWMAIpjJeFdZFaM4HtAgT29mtNCSO3LfVuw50MLzqjBm3e+m/mlivHze8OoFuVdv31zABsaxCwceSJqtRVdDgMLF8vCpw+8zSq/a37KoRLV+wfvelYnCAOkGN5nEv1NsvAJ7TixHboSLloSxjIOO4ZR0rjK4pR62TzM8Hd7C1xKbQgK4AilKiO2PIcxk+A2zqzG/i4WZ7kj1ZQGr+N8pBDvcwfjPrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hui,

On 8/31/26 7:21 PM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
> proactive reclaim pass on a given memory cgroup, similar to a write
> to memory.reclaim but without retrying until the target is reached.
> 
> The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
> always runs in a clean process context. Generic sleepable programs
> may execute with filesystem locks held or in NOFS/NOIO contexts,
> where the reclaim path could deadlock in filesystem shrinkers. A
> SYSCALL program can still drive reclaim asynchronously through
> bpf_wq or task_work callbacks, which run in process context and
> keep the SYSCALL program type, so they can call the kfunc too.
> 
> The kfunc refuses to reclaim if the calling task is already in a
> reclaim context, as a nested reclaim would corrupt the outer reclaim
> state.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---

The difflog is missing in these patches.

>   mm/bpf_memcontrol.c | 76 +++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..fd48faa5f8b0 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -6,6 +6,7 @@
>    */
>   
>   #include <linux/memcontrol.h>
> +#include <linux/swap.h>
>   #include <linux/bpf.h>
>   
>   __bpf_kfunc_start_defs();
> @@ -159,6 +160,55 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>   	mem_cgroup_flush_stats(memcg);
>   }
>   
> +/*
> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
> + * current->reclaim_state, so a nested call would corrupt the outer
> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
> + * reclaim_state is also checked because it is installed slightly
> + * before PF_MEMALLOC.
> + */
> +static bool bpf_in_reclaim_context(void)
> +{
> +	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
> +}
> +
> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> + *                         cgroup
> + * @memcg: the target memory cgroup to reclaim from
> + * @size:  the amount of memory to reclaim, in bytes
> + *
> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> + * memory.reclaim, but without retrying until @size is reached.
> + *
> + * This kfunc is restricted to BPF_PROG_TYPE_SYSCALL to ensure it runs
> + * in a clean process context. The SYSCALL program can schedule the
> + * actual reclaim work via bpf_wq or timers, which also execute in
> + * safe process context (workqueue, task_work).

On the workqueue aspect, I could see potential issues. The target size
has no upper bound so the total scan/execution time on the shared
wq can easily stall other work. Contention on the lru_lock can make
matters worse because interrupts are disabled while holding the lock. So
the contention would not only stall other work, but can delay IPI
handling leading to CSD lock stalls.

It looks like the only existing path that explicitly calls
try_to_free_mem_cgroup_pages() from a shared wq is the memory.high
fallback used when the limit is exceeded outside of task context. But
even in that case, it's more constrained. The reclaim request is bounded
at MEMCG_CHARGE_BATCH (in high_work_func()) and is limited to one work
item per memcg.

Would it make sense to follow the existing precedent and use the same
bound in your kfunc? You could then batch the wq submissions and you
would also be able to stop submitting in between if needed, like in the
case of the cgroup dying.

> + *
> + * Must not be called with a filesystem lock held: the reclaim path
> + * may deadlock on it via filesystem shrinkers.
> + *
> + * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
> + * smaller than a page or the task is already in a reclaim context.
> + */
> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> +						unsigned long size)
> +{
> +	unsigned long nr_reclaimed;
> +
> +	if (size < PAGE_SIZE || unlikely(bpf_in_reclaim_context()))
> +		return 0;
> +
> +	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, size / PAGE_SIZE,
> +						    GFP_KERNEL,
> +						    MEMCG_RECLAIM_MAY_SWAP |
> +						    MEMCG_RECLAIM_PROACTIVE,
> +						    NULL);
> +
> +	return nr_reclaimed * PAGE_SIZE;
> +}
> +
>   __bpf_kfunc_end_defs();
>   
>   BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> @@ -171,22 +221,44 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events)
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


