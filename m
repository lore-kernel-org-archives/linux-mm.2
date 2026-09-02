Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F515C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D706B0092; Wed,  2 Sep 2026 02:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D7F6B0095; Wed,  2 Sep 2026 02:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C996B0096; Wed,  2 Sep 2026 02:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6756B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:57:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D7994074C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:57:53 +0000 (UTC)
X-FDA: 85167917226.29.D0BBDFA
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA76D1C0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:57:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D0wlcP9p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788332271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXZSsj1h/BySZVviXGKCL9ci08G0rsvYfAminc8wBk4=;
	b=FYsQ5TLQvuJ1PJpl6Ix9nActW3mU0Zi6OLRyh2Udj6kI7g27QIk2Xtqw/xS8iNVo/UDh8G
	qHntvfu8I77MiiajmqniTwr65UIdkSDnMYXEIkSKcnSTMS8wev+77+tWnGr5tbuwjxfy0P
	d7VQXhXEeec7dFYJdlcPZ/E/mXsJC0s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D0wlcP9p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788332271;
	b=VY7m6XBSG9o9GovrAuIb2tblJ4X+Y0ZDbLnhVvhsO7mYvSTlIDKXjQ+f94qVrFay2UZ6s0
	BrXAzje8bJMGJedpe+wwApiGdrHfzcVFb6lvYPUjvFJgpxVlVRWNvS0jvM1wEPqzvFYIHL
	tnGS47xmJcDsTzbN/u1KsN9lK3p/N+E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dYnmVRgv/hTqXQbdZ6YIg65oaInMmkvygceKouO7NOk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788332269; v=1; x=1788937069;
 b=D0wlcP9ph+/u4QBChid0aJR9pjdX6OyQzuCC1kQjP66yKOJLEVwdAkq3ftwm3vIPvpWgOqhU
 cYxlFSKOuPeI/JJDiWwWqSShAlD2euWWEJepdgeq/unE06ojaJiGrjl/eu/1pK1SW9VIEo8jWeY
 dFhdZis6fbV2PDqBaszRPEjo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 15f431fa020b49d7;
	Wed, 02 Sep 2026 06:57:48 +0000
X-Mizu-Trace-ID: 15f431fa020b49d7
X-Migadu-Flow: FLOW_OUT
Message-ID: <9ff42a33-8ad2-40cd-a980-9fa87474e527@linux.dev>
Date: Wed, 2 Sep 2026 14:57:43 +0800
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH bpf-next v6 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
To: JP Kobryn <jp.kobryn@linux.dev>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
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
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <f9e77f14-a6a9-4cd3-a217-43abe4747275@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xwta8658qmb7yrgjm4wjbupiesyjaxyc
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA76D1C0002
X-Rspam-User: 
X-HE-Tag: 1788332270-768773
X-HE-Meta: U2FsdGVkX1/7vSh1USK3FDbQBcrp6D+HOGqZiXCNZZVYVctfb2ZCfuiNjpdweNRey5QZCpAV9O7OJDAX5hTiVj/gHDfHXXvWw11YIk00dxt8xhSb8Vq8BWtpKLaC7FA/SXPiBKjj9nSzeIObYyhMPmcwzLvU+e8ieFTvcgHmrsIc1AykxJVJqxEGttq+E4Y4STOy9XApthzQZ4+1RyAmHt2rft9HpvPu7xFZlLqHpXLcaF73MQ4NYCULkf4ExOZOkbBchguBlvzsW1/9aJpmGBtVGaNZPnSmaUTsUJ2eEEn4ZmWSM/YjyatQxBoMRHNEp/A5qopd52MC1+FLKlZWluC7uxXsBsUohW4bmP31T4NkciVzksOsHP/60Yzj8yUtyboVY4ENjd6xVWXkgia+JpW8ltN7TlijISV+QCgtxe5OK168Cra81mBTNQOKHkeDWnAQBA4q4cd7bd13l6K0Pa8kG7gVl92XDL2LrzqcyCifcJZxECjc+5RfktjdM3QI2xXu9RJ4SQpGEgCLQj6DOpFMUfbMYg1xCZiFjUmnpfq5WPyizfClTidrOk5qP17pHocyTH6Kdvw89CYJwkRItkANTHRHxzq4QSIaf1R/ukYJr2GHyC7A6KKeDyQTwpKwhd58WvWUFRiE3IoylclrCG+RnMJRTKAhu4VctCef8QRbjXlHqiTgAyR1oWdHNbQAmb1aEG1F8BCiNYyd/dmpfFXDdjVGxRXgLvaBNaB98MqPmFW1Wk9ryDTCypCuHsMT+AdYeDPUrN1/7V7MNw9DnoEHWHLDgcdteAc0JIQrxbj3Zv0mkKyuq7xs1KdYfonbr4M+QYARVUVkUQnl2/UN9pyVpSvYt+yRAjrf4QuBL/yQwP8cNwmC1UuBU6KV2bMbxK6/R2of/cruO9QDbsBiVl0540l3zVE/gdd4Jc2A/FW66B8+I4bwZjQHOhfdaN59yEffWPZL/VDD6tHYKwu
 XU6r6PLt
 vlc54/hH/hDqQOCa1fpmT6KDdiyp9zgcf9QAnYIA43L7JfuC2uDcJ7WTcgXOYgj//1KIlgo1a6ij8wQbE6Crm3Pq0QL4kup8TTJEribu/AVgi2wxl1QF0FEha5Zj2x8v8D8nBqNvuWZKdmEXlyRSxHwpVJ5a/xgbVR1TwaMYvifD3ysoQDRrVHyvXXHhR5ObKlmL97CTDxrv6cbMsJ8jcef33pP0Cfjz8Zm5obCeMfWK5sLVUylp7qo/ZYLovfiJTY3A/p1NniJCjTgpdrkvXIPsPzDYcUBLOwexvyFHOIldd9V4OTbh+r+va6pyfxOQmPHTm876oIAr7G1HRIQL6PcW/cZ120MA+itOT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi JP,

Thanks for the review!

> Hi Hui,
>
> On 8/31/26 7:21 PM, Hui Zhu wrote:
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
>> proactive reclaim pass on a given memory cgroup, similar to a write
>> to memory.reclaim but without retrying until the target is reached.
>>
>> The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
>> always runs in a clean process context. Generic sleepable programs
>> may execute with filesystem locks held or in NOFS/NOIO contexts,
>> where the reclaim path could deadlock in filesystem shrinkers. A
>> SYSCALL program can still drive reclaim asynchronously through
>> bpf_wq or task_work callbacks, which run in process context and
>> keep the SYSCALL program type, so they can call the kfunc too.
>>
>> The kfunc refuses to reclaim if the calling task is already in a
>> reclaim context, as a nested reclaim would corrupt the outer reclaim
>> state.
>>
>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>> ---
>
> The difflog is missing in these patches.
Sorry, my mistake. Will add the changelog (changes since v4) in the
next version.
>
>>   mm/bpf_memcontrol.c | 76 +++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 74 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index 716df49d7647..fd48faa5f8b0 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>> @@ -6,6 +6,7 @@
>>    */
>>     #include <linux/memcontrol.h>
>> +#include <linux/swap.h>
>>   #include <linux/bpf.h>
>>     __bpf_kfunc_start_defs();
>> @@ -159,6 +160,55 @@ __bpf_kfunc void 
>> bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>>       mem_cgroup_flush_stats(memcg);
>>   }
>>   +/*
>> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
>> + * current->reclaim_state, so a nested call would corrupt the outer
>> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
>> + * reclaim_state is also checked because it is installed slightly
>> + * before PF_MEMALLOC.
>> + */
>> +static bool bpf_in_reclaim_context(void)
>> +{
>> +    return (current->flags & PF_MEMALLOC) || current->reclaim_state;
>> +}
>> +
>> +/**
>> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
>> + *                         cgroup
>> + * @memcg: the target memory cgroup to reclaim from
>> + * @size:  the amount of memory to reclaim, in bytes
>> + *
>> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
>> + * memory.reclaim, but without retrying until @size is reached.
>> + *
>> + * This kfunc is restricted to BPF_PROG_TYPE_SYSCALL to ensure it runs
>> + * in a clean process context. The SYSCALL program can schedule the
>> + * actual reclaim work via bpf_wq or timers, which also execute in
>> + * safe process context (workqueue, task_work).
>
> On the workqueue aspect, I could see potential issues. The target size
> has no upper bound so the total scan/execution time on the shared
> wq can easily stall other work. Contention on the lru_lock can make
> matters worse because interrupts are disabled while holding the lock. So
> the contention would not only stall other work, but can delay IPI
> handling leading to CSD lock stalls.


Agreed. I previously misread

     .nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX)

in try_to_free_mem_cgroup_pages() as an upper bound on the reclaim
target; it is actually a lower bound, so nothing inside the reclaim
path limits how long a single kfunc call can run. The next version
will cap the per-invocation reclaim target.


>
> It looks like the only existing path that explicitly calls
> try_to_free_mem_cgroup_pages() from a shared wq is the memory.high
> fallback used when the limit is exceeded outside of task context. But
> even in that case, it's more constrained. The reclaim request is bounded
> at MEMCG_CHARGE_BATCH (in high_work_func()) and is limited to one work
> item per memcg.
>
> Would it make sense to follow the existing precedent and use the same
> bound in your kfunc? You could then batch the wq submissions and you
> would also be able to stop submitting in between if needed, like in the
> case of the cgroup dying.
>
Yes, the next version will cap the reclaim target of a single
bpf_proactive_reclaim() call at MEMCG_CHARGE_BATCH, following the
high_work_func() precedent, so each invocation is a bounded unit of
work on the shared wq.

For the "one work item per memcg" side, I'd like to hear your
thoughts on the following approach: allow only one in-flight
bpf_proactive_reclaim() per memcg. The kfunc would take a per-memcg
flag (atomic cmpxchg) on entry and return 0 if another BPF reclaim
pass is already running on the same memcg, mirroring the
one-work-item-per-memcg property of high_work. This would prevent wq
work items from piling up reclaiming the same memcg.

The reason for doing this with a per-memcg in-flight check rather
than a fixed per-memcg work item is to keep bpf_proactive_reclaim()
flexible: it bounds how much reclaim can run against one memcg at any
moment, while leaving the reclaim policy -- when to reclaim, how many
passes to batch, and when to stop (e.g. if the target cgroup is
dying) -- entirely in the BPF program. Do you think this is a
reasonable way to bound the total reclaim activity per memcg, or
would you prefer something else?

With the per-invocation cap, each kfunc call becomes a small, bounded
unit of work, and the BPF program does the batching: it schedules
successive wq submissions and can stop submitting between passes when
needed. This keeps the "when and how hard to reclaim" policy in BPF
while bounding the kernel-side cost of each invocation.

Best,
Hui


>> + *
>> + * Must not be called with a filesystem lock held: the reclaim path
>> + * may deadlock on it via filesystem shrinkers.
>> + *
>> + * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
>> + * smaller than a page or the task is already in a reclaim context.
>> + */
>> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup 
>> *memcg,
>> +                        unsigned long size)
>> +{
>> +    unsigned long nr_reclaimed;
>> +
>> +    if (size < PAGE_SIZE || unlikely(bpf_in_reclaim_context()))
>> +        return 0;
>> +
>> +    nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, size / 
>> PAGE_SIZE,
>> +                            GFP_KERNEL,
>> +                            MEMCG_RECLAIM_MAY_SWAP |
>> +                            MEMCG_RECLAIM_PROACTIVE,
>> +                            NULL);
>> +
>> +    return nr_reclaimed * PAGE_SIZE;
>> +}
>> +
>>   __bpf_kfunc_end_defs();
>>     BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
>> @@ -171,22 +221,44 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events)
>>   BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
>>   BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
>>   BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
>> -
>>   BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
>>   +/*
>> + * Proactive reclaim needs a clean process context, so it is restricted
>> + * to BPF_PROG_TYPE_SYSCALL. The bpf_wq and task_work callbacks that a
>> + * SYSCALL program schedules run as the same program type, so they can
>> + * still invoke it; generic sleepable programs (e.g. fentry on reclaim
>> + * paths, inode_rmdir) cannot.
>> + */
>> +BTF_KFUNCS_START(bpf_memcontrol_reclaim_kfuncs)
>> +BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
>> +BTF_KFUNCS_END(bpf_memcontrol_reclaim_kfuncs)
>> +
>>   static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
>>       .owner          = THIS_MODULE,
>>       .set            = &bpf_memcontrol_kfuncs,
>>   };
>>   +static const struct btf_kfunc_id_set 
>> bpf_memcontrol_reclaim_kfunc_set = {
>> +    .owner          = THIS_MODULE,
>> +    .set            = &bpf_memcontrol_reclaim_kfuncs,
>> +};
>> +
>>   static int __init bpf_memcontrol_init(void)
>>   {
>>       int err;
>>         err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
>>                       &bpf_memcontrol_kfunc_set);
>> -    if (err)
>> +    if (err) {
>>           pr_warn("error while registering bpf memcontrol kfuncs: 
>> %d", err);
>> +        return err;
>> +    }
>> +
>> +    err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
>> +                    &bpf_memcontrol_reclaim_kfunc_set);
>> +    if (err)
>> +        pr_warn("error registering bpf reclaim kfuncs: %d", err);
>>         return err;
>>   }
>

