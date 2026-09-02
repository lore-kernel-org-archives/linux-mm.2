Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9702EC624D5
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC296B00F7; Wed,  2 Sep 2026 14:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986D46B00F8; Wed,  2 Sep 2026 14:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D096B00F9; Wed,  2 Sep 2026 14:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8C76B00F7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:14:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8477160337
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:14:43 +0000 (UTC)
X-FDA: 85169622846.02.A3C0CD0
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	by imf01.hostedemail.com (Postfix) with ESMTP id 77EB440003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:14:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cGVJ/emS";
	spf=pass (imf01.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788372881;
	b=e3rHJHgwgzdSOvsEjtb9ft9/xFoqPV9IsfOQvX1Zoh34bd2qFs1CpHjI3MPhbbpIKz5TgG
	g9aYGlEhs61j+XsjAjjX2+zD4/Qft+TOZAEZD1gQvRPUNnYhFdgUM2d8mjdzhTU9i2LTtP
	LMRm5qgi1hwQM5FgPy4aK9sGuIBfsOo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788372881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKXJHj6v8tdI2Cf9Gn/I7ION7E36cl+qYwoBjKcIzEM=;
	b=MS32qs4iacfVVs9bQLiyuS6fXNXBslLKOtOdhh4ADa9HEaAj0/YVvIhSvu6J8gNHQUNrt+
	gK4oORqE0Xd8edDgvvxuQRGdWlfYU5NQ08Y07ErzWBsOOMweD33wMy84oUtohnsn/SjD6f
	nH0AuFjCtHzCsaU7WChwC1vPUsIQnyQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cGVJ/emS";
	spf=pass (imf01.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nWX6IV7rvjDZC3OxCVmBkgxl+C30+nJvbQf0lpMwKFY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788372880; v=1; x=1788977680;
 b=cGVJ/emSENpPRCgpl5IX5G76SQ9eV0zUuqrhDtsh6+A8dZvBgPG+sIWStAvqrU/v6R0YYfhY
 db8/flnIlpBmJ2dM+IojHZZR8lwGfWIfBmmCftYiBickp2crZsbGbSdWSALOj0hqxp33tjDjETN
 tZQt3/nMIjRfgA9QvjsqeIac=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9c513c2073537b38;
	Wed, 02 Sep 2026 18:14:39 +0000
X-Mizu-Trace-ID: 9c513c2073537b38
X-Migadu-Flow: FLOW_OUT
Message-ID: <89f88778-2347-4f78-9c27-b2aaec56681a@linux.dev>
Date: Wed, 2 Sep 2026 11:14:32 -0700
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
 <f9e77f14-a6a9-4cd3-a217-43abe4747275@linux.dev>
 <9ff42a33-8ad2-40cd-a980-9fa87474e527@linux.dev>
Content-Language: en-US
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <9ff42a33-8ad2-40cd-a980-9fa87474e527@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 77EB440003
X-Stat-Signature: n6dqyy45cmig4cwz7x17b1wbxdk7ty7x
X-HE-Tag: 1788372881-248891
X-HE-Meta: U2FsdGVkX18TAzaRliG6kVohkgLD4dONZMpjtPaFzrxvQ1u4Zr4rFDk/5YnToje5hpk9wiID2GG9tN5E7uPWPCW3j/+KLf1EVNLkuBy6hsUTb+akOOrr3qo6fjvPTJ9KHta9IfF0vz04+x1VoSw5aWY9aoNlYtzjRUk9LnE2h0TqhGloLre0eBSg7TtSl0Yau5haJjpqYoWHSg1dFnxTW9ZDI9mlPqLg9zTNynEIgrUa30NkNhgoKOuv08vzn0GqREM/SYkFSb2tERbFVDHufLrUgMJ2PwIeXJ+nejig+WcvwHiLZqjoShhWg9TYgIuMsSjXmDt6nGeknGNRS2MS4OYVakK6NDisByVamDjjc3/rUef88+v+YO3bt0eSVFAP9LK7EZ4JaCH4kwW9shqjiakkdBcROL7wWHp2zdPL1qfD+LPvLDRcbp3f2HEYYHZHIJapEnRppcD1q1oyPjuH4iTABZTfzLIN0G4MWkxMJb8D97iURLCZ4PTYLuK7QzyYB+QnVWTsjvEcyPEdNowz9tVtJa3F8ROFJVuXZaRgnZUpoz3rpEr6rHi4lCvkvqKiqFbNex5xhSpQJkuGY0raOEC8hcBYCBm4q7M+9M0lrDtdovSxNFmwet4BgD8hoaThDpxQfLI/6qCWOA1WHRmk56xX7R6M1EOZ0cZANYuCJY9Z/MQm5rW1DwHCMoMsZ+Ex6kTuFxp5zoegj68jP902vUxzBXQfCzrp6fsX1K4EafIbYFH5m9J/8h/j6+fLa+2AHjuDLRbVIKeVq2tqxXl1Q/kZg6LL6w0ac2JLFCtAu0zka1QTVfnKrKCRXq6lqTsnHsHNzlSHwyGzoXN+g1KqDsWBhaZEug/mpgk8dV39mhTie4YMrQ6CoQAoDkLaZvGYyQJ2086+npQW232Xbi0W8+dCtd8mhyYUDdQwSLoVFM0pT4/w6+O4gR+oJPhkSuPoI1JiFlb42ErfKIXITct
 R+x9Uznt
 8WTkTnSghJRCKiAD0ax7maC0r5z00LuJ/jCxpAGxhJgnLLCwwIjrYyC0oTsAVrzk6c3A7zuxjaVnnUOtL8XvYoAo2yNU8vY7aWDwXqLswrzI+eokjJtp8vlqg8Rkf15CryJxzwawVUrBIDMMwpC5gWFKw7ycpvS3xZ+WcQz0OKbQ930oo1/uMFf/yaeVn1a655HbGPYmRiCaDN2NG42Zf5fLA5q+NY1le6ZVnlD/dixyP5sY5dlnRd7RNLq9q58r/pHMzQZFVLe/2bZVPROWgTpB623+4XW9ebmXqT/dXl7HwoCenZzSpBXcHSEQ1FDsyqCnkeEwOMAqI/cfCQ1Zw83Vhw8YnsuEvP9UK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 11:57 PM, Hui Zhu wrote:
> Hi JP,
> 
> Thanks for the review!
> 
>> Hi Hui,
>>
>> On 8/31/26 7:21 PM, Hui Zhu wrote:
>>> From: Hui Zhu <zhuhui@kylinos.cn>
>>>
>>> Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
>>> proactive reclaim pass on a given memory cgroup, similar to a write
>>> to memory.reclaim but without retrying until the target is reached.
>>>
>>> The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
>>> always runs in a clean process context. Generic sleepable programs
>>> may execute with filesystem locks held or in NOFS/NOIO contexts,
>>> where the reclaim path could deadlock in filesystem shrinkers. A
>>> SYSCALL program can still drive reclaim asynchronously through
>>> bpf_wq or task_work callbacks, which run in process context and
>>> keep the SYSCALL program type, so they can call the kfunc too.
>>>
>>> The kfunc refuses to reclaim if the calling task is already in a
>>> reclaim context, as a nested reclaim would corrupt the outer reclaim
>>> state.
>>>
>>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>> ---
>>
>> The difflog is missing in these patches.
> Sorry, my mistake. Will add the changelog (changes since v4) in the
> next version.
>>
>>>   mm/bpf_memcontrol.c | 76 +++++++++++++++++++++++++++++++++++++++++++--
>>>   1 file changed, 74 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>>> index 716df49d7647..fd48faa5f8b0 100644
>>> --- a/mm/bpf_memcontrol.c
>>> +++ b/mm/bpf_memcontrol.c
>>> @@ -6,6 +6,7 @@
>>>    */
>>>     #include <linux/memcontrol.h>
>>> +#include <linux/swap.h>
>>>   #include <linux/bpf.h>
>>>     __bpf_kfunc_start_defs();
>>> @@ -159,6 +160,55 @@ __bpf_kfunc void 
>>> bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>>>       mem_cgroup_flush_stats(memcg);
>>>   }
>>>   +/*
>>> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
>>> + * current->reclaim_state, so a nested call would corrupt the outer
>>> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
>>> + * reclaim_state is also checked because it is installed slightly
>>> + * before PF_MEMALLOC.
>>> + */
>>> +static bool bpf_in_reclaim_context(void)
>>> +{
>>> +    return (current->flags & PF_MEMALLOC) || current->reclaim_state;
>>> +}
>>> +
>>> +/**
>>> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
>>> + *                         cgroup
>>> + * @memcg: the target memory cgroup to reclaim from
>>> + * @size:  the amount of memory to reclaim, in bytes
>>> + *
>>> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
>>> + * memory.reclaim, but without retrying until @size is reached.
>>> + *
>>> + * This kfunc is restricted to BPF_PROG_TYPE_SYSCALL to ensure it runs
>>> + * in a clean process context. The SYSCALL program can schedule the
>>> + * actual reclaim work via bpf_wq or timers, which also execute in
>>> + * safe process context (workqueue, task_work).
>>
>> On the workqueue aspect, I could see potential issues. The target size
>> has no upper bound so the total scan/execution time on the shared
>> wq can easily stall other work. Contention on the lru_lock can make
>> matters worse because interrupts are disabled while holding the lock. So
>> the contention would not only stall other work, but can delay IPI
>> handling leading to CSD lock stalls.
> 
> 
> Agreed. I previously misread
> 
>      .nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX)
> 
> in try_to_free_mem_cgroup_pages() as an upper bound on the reclaim
> target; it is actually a lower bound, so nothing inside the reclaim
> path limits how long a single kfunc call can run. The next version
> will cap the per-invocation reclaim target.
> 
> 
>>
>> It looks like the only existing path that explicitly calls
>> try_to_free_mem_cgroup_pages() from a shared wq is the memory.high
>> fallback used when the limit is exceeded outside of task context. But
>> even in that case, it's more constrained. The reclaim request is bounded
>> at MEMCG_CHARGE_BATCH (in high_work_func()) and is limited to one work
>> item per memcg.
>>
>> Would it make sense to follow the existing precedent and use the same
>> bound in your kfunc? You could then batch the wq submissions and you
>> would also be able to stop submitting in between if needed, like in the
>> case of the cgroup dying.
>>
> Yes, the next version will cap the reclaim target of a single
> bpf_proactive_reclaim() call at MEMCG_CHARGE_BATCH, following the
> high_work_func() precedent, so each invocation is a bounded unit of
> work on the shared wq.
> 
> For the "one work item per memcg" side, I'd like to hear your
> thoughts on the following approach: allow only one in-flight
> bpf_proactive_reclaim() per memcg. The kfunc would take a per-memcg
> flag (atomic cmpxchg) on entry and return 0 if another BPF reclaim
> pass is already running on the same memcg, mirroring the
> one-work-item-per-memcg property of high_work. This would prevent wq
> work items from piling up reclaiming the same memcg.
> 
> The reason for doing this with a per-memcg in-flight check rather
> than a fixed per-memcg work item is to keep bpf_proactive_reclaim()
> flexible: it bounds how much reclaim can run against one memcg at any
> moment, while leaving the reclaim policy -- when to reclaim, how many
> passes to batch, and when to stop (e.g. if the target cgroup is
> dying) -- entirely in the BPF program. Do you think this is a
> reasonable way to bound the total reclaim activity per memcg, or
> would you prefer something else?

Let's not add state to the memcg to emulate high_work in bpf. I think
you should document and implement this on the bpf side. Change the
selftest example so that bpf_proactive_reclaim() is invoked only once
per callback (instead of a in a loop) and requeue the same work if
another reclaim batch is needed. You could also check if the cgroup is
dying and discontinue the work.

I would also document that each memcg should use its own bpf_wq item.
Correct me if I'm wrong, but it looks like that is your intention in the
selftest wq_map.

> 
> With the per-invocation cap, each kfunc call becomes a small, bounded
> unit of work, and the BPF program does the batching: it schedules
> successive wq submissions and can stop submitting between passes when
> needed. This keeps the "when and how hard to reclaim" policy in BPF
> while bounding the kernel-side cost of each invocation.
> 
> Best,
> Hui
> 
> 
>>> + *
>>> + * Must not be called with a filesystem lock held: the reclaim path
>>> + * may deadlock on it via filesystem shrinkers.
>>> + *
>>> + * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
>>> + * smaller than a page or the task is already in a reclaim context.
>>> + */
>>> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup 
>>> *memcg,
>>> +                        unsigned long size)
>>> +{
>>> +    unsigned long nr_reclaimed;
>>> +
>>> +    if (size < PAGE_SIZE || unlikely(bpf_in_reclaim_context()))
>>> +        return 0;
>>> +
>>> +    nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, size / 
>>> PAGE_SIZE,
>>> +                            GFP_KERNEL,
>>> +                            MEMCG_RECLAIM_MAY_SWAP |
>>> +                            MEMCG_RECLAIM_PROACTIVE,
>>> +                            NULL);
>>> +
>>> +    return nr_reclaimed * PAGE_SIZE;
>>> +}
>>> +
>>>   __bpf_kfunc_end_defs();
>>>     BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
>>> @@ -171,22 +221,44 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events)
>>>   BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
>>>   BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
>>>   BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
>>> -
>>>   BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
>>>   +/*
>>> + * Proactive reclaim needs a clean process context, so it is restricted
>>> + * to BPF_PROG_TYPE_SYSCALL. The bpf_wq and task_work callbacks that a
>>> + * SYSCALL program schedules run as the same program type, so they can
>>> + * still invoke it; generic sleepable programs (e.g. fentry on reclaim
>>> + * paths, inode_rmdir) cannot.
>>> + */
>>> +BTF_KFUNCS_START(bpf_memcontrol_reclaim_kfuncs)
>>> +BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
>>> +BTF_KFUNCS_END(bpf_memcontrol_reclaim_kfuncs)
>>> +
>>>   static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
>>>       .owner          = THIS_MODULE,
>>>       .set            = &bpf_memcontrol_kfuncs,
>>>   };
>>>   +static const struct btf_kfunc_id_set 
>>> bpf_memcontrol_reclaim_kfunc_set = {
>>> +    .owner          = THIS_MODULE,
>>> +    .set            = &bpf_memcontrol_reclaim_kfuncs,
>>> +};
>>> +
>>>   static int __init bpf_memcontrol_init(void)
>>>   {
>>>       int err;
>>>         err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
>>>                       &bpf_memcontrol_kfunc_set);
>>> -    if (err)
>>> +    if (err) {
>>>           pr_warn("error while registering bpf memcontrol kfuncs: 
>>> %d", err);
>>> +        return err;
>>> +    }
>>> +
>>> +    err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
>>> +                    &bpf_memcontrol_reclaim_kfunc_set);
>>> +    if (err)
>>> +        pr_warn("error registering bpf reclaim kfuncs: %d", err);
>>>         return err;
>>>   }
>>


