Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4502C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 987526B00A6; Mon, 31 Aug 2026 22:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937306B00A7; Mon, 31 Aug 2026 22:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877396B00A9; Mon, 31 Aug 2026 22:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6063D6B00A6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:59:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E235EA3CCB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:59:40 +0000 (UTC)
X-FDA: 85163688120.28.EEFB427
Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	by imf07.hostedemail.com (Postfix) with ESMTP id C328640005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:59:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BVddg9xQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788231579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qA6eCz7ogSws82QxlmWlAQtT2XwqKswllqB3EZ5iiDU=;
	b=RakROsqUMgHSYameCFNWEp4fQbVfGbedsq7cEu8X2/RmV/YT5jNQoWIRzJ67FLZ5fJEGcd
	P8hGJ3ffdrMCLb5Aw5+/AXzg0ZMKV8W049dBwfl3QFU+cTnGSM2y3fQUDz54rDOZCErlrf
	tbBu6dA9YZqFhMdQFjYZf6UG+piWuR8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BVddg9xQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788231579;
	b=gEVs24bmPSBvM5m9ClQ/N+3w26VveAhnbgOyr3vZJ62/U6mQiGyWFtQ6LsNiQ1/QMWiccH
	A8GG5J7u0UPHlbUFdGWlReuyxOMpMgNT1XVLjR582TKw7eGeaFFSlmc03bziXU3+OijmqE
	PH8q04yLe8MxqdHBzkYBm8QoD/gMz1c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ciZZAzaZaR3UaV0eFejfaxcyL47+g1hpSZHv6435/SE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788231577; v=1; x=1788836377;
 b=BVddg9xQfgMBm84LyeQdcvSHAvPMHvHjo+BFO+MmquUDMQLeOuKFqK5661AWKPIRKRb/ODaE
 22Iw/mt+2pZn0IVc5aWGjiADZ1gD+AG4wT7FHx8oHkFBmNtIRVXGk90u4iXkAowjAmrdoWpV3HR
 dld728wU1Tx6YbToz/bwc0Hs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0a8ec0cb1a616635;
	Tue, 01 Sep 2026 02:59:37 +0000
X-Mizu-Trace-ID: 0a8ec0cb1a616635
X-Migadu-Flow: FLOW_OUT
Message-ID: <4984b835-6cd2-4870-9b2c-ebe74c684b23@linux.dev>
Date: Tue, 1 Sep 2026 10:59:27 +0800
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH bpf-next v5 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 JP Kobryn <inwardvessel@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>, Ihor Solodrai
 <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>,
 Barry Song <baohua@kernel.org>, Geliang Tang <geliang@kernel.org>,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1787826402.git.zhuhui@kylinos.cn>
 <5dfdc7800469eac4e9a240f2422ba65d4ef4c4ba.1787826402.git.zhuhui@kylinos.cn>
 <apHk86Y8araBlXcq@linux.dev> <DL0VTAZE10HC.3R4HIC6S0U3P1@gmail.com>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <DL0VTAZE10HC.3R4HIC6S0U3P1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C328640005
X-Stat-Signature: mypqrmjetfqf38d6tsguqerkkzhyaw7g
X-Rspam-User: 
X-HE-Tag: 1788231578-932614
X-HE-Meta: U2FsdGVkX1+LYTL2bQUtDwjJOztRgdrlgcgKCmeG+p+LBV2zGPpdmIJO6LIVD3tCbduhwyvSu5Vd0nEV7lNOxXIsPskTh2Yv6rAE/uFM5Zajc7sByEMAOYF7Uth1FBf/Z4GgVTzqmG2wuAnLc79yEj/nH8mcq7KfyNYY3NfzQoY3nuEMedjKt6NnjE7mEnJJPp668S9fj259i2Bqo/5vmiErEa0W6luia4VWXlybUQag3s1PlIiTliAzvNV6BhTl+YaV6M/nm6DO+EyKexqTuW4Fj1sAGuJBYdczpkiv00HvqQnQwzd0e7BfVHepAbUN+Ob8/VC1+JI2wo/FYo+Ag9ascGEIm2QoctJ0gf2a6v75PzDiPityrNryLhqRXbyU1KQ2movpn13RTg9xLJOSb/hoILh2kkntTBkqVrRmaT94KRfH6PePVAykoIxjn7skFNRbKnMlnVCViEBosvfqIFZ+mnfKYoqEQp+HdbbkZhHjwcQNDn0nsTQkTIsJFRLZBLGFAQBxjhh1agTxVsqP4xGjh0xFu86rpofYLcKnqfhdGE7eu1i9fdIbgbwst8ZoxVMLn+ul2Gc3uBc1TH6DvSD/U9Cd8lvwwJL6I+HrqAAgLfs2dUWo0Zl2+oisUl1x1NIImQWdwxUxBSc/Vx1uNlXaDswMsZtT2Mpyn/qx1B8Qf0UAh80SSdGXWEJ3r8/D5bXFk7jqYoSDIiN4/1kgKJBM+MYGqFjiU36c57jJh0msend1WwugRmrM+RMDwEp3et11Kj2Epn7aFyuQhBTk891scJ7rXSREGQquk6nq7YWgiFSGSD2Dp1TZrOAQm7pnc48MRkcd7d0usrXMZz4JRQA9y8O+/aTm6AEM9RPj43ZOb3QdPSjudKMVE3GURZ2tTSRwFww/sk1L40ZSxYAz1J1SNAhEFe8Em3M0C1xtW7KRq76fXwhEJG4VpfTAcybeY93uYicMsReGCuE38x2
 10LznL/v
 MK8odNWIaNlMq9lLMGHZGAdUi5yPxdt+PdOtK9FgAOy/sCppdonAee3K337s4AFgemCHtWKDmqd5Y6zGRADNKZeZUi/arasRoFmgnLHbmH/KKM4GlsjPw3w2pzXuMhpi5PYNVN7mjw9qSC9iR0TqLhl2hozHCplrKkuPb2o8H9HoEw2oPF0p34aD9bOMQImOhrdNkPP3KcLOHA8odgYCmLSvTyMGXz6LGebRmwXQ0aXy/Mtv/hIkT3408fASBU6yRr0XS8qlicWIzclGJl27KfY/Cza1OUAVPNuVkm+eCv7JOJAbhYyOsuaa83kDMSb7chNNH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> On Fri Aug 28, 2026 at 9:53 PM CEST, Shakeel Butt wrote:
>> On Thu, Aug 27, 2026 at 06:36:29PM +0800, Hui Zhu wrote:
>>> From: Hui Zhu <zhuhui@kylinos.cn>
>>>
>>> Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
>>> proactive reclaim pass on a given memory cgroup, similar to a write
>>> to memory.reclaim but without retrying until the target is reached.
>>>
>>> The kfunc refuses to reclaim if the calling task is already in a
>>> reclaim context, as a nested reclaim would corrupt the outer reclaim
>>> state.
>>>
>>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>> ---
>>>   mm/bpf_memcontrol.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 46 insertions(+)
>>>
>>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>>> index 716df49d7647..297ff7f05042 100644
>>> --- a/mm/bpf_memcontrol.c
>>> +++ b/mm/bpf_memcontrol.c
>>> @@ -6,6 +6,7 @@
>>>    */
>>>
>>>   #include <linux/memcontrol.h>
>>> +#include <linux/swap.h>
>>>   #include <linux/bpf.h>
>>>
>>>   __bpf_kfunc_start_defs();
>>> @@ -159,6 +160,49 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>>>   	mem_cgroup_flush_stats(memcg);
>>>   }
>>>
>>> +/*
>>> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
>>> + * current->reclaim_state, so a nested call would corrupt the outer
>>> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
>>> + * reclaim_state is also checked because it is installed slightly
>>> + * before PF_MEMALLOC.
>>> + */
>>> +static bool bpf_in_reclaim_context(void)
>>> +{
>>> +	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
>>> +}
>>> +
>>> +/**
>>> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
>>> + *                         cgroup
>>> + * @memcg: the target memory cgroup to reclaim from
>>> + * @size:  the amount of memory to reclaim, in bytes
>>> + *
>>> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
>>> + * memory.reclaim, but without retrying until @size is reached.
>>> + * Must not be called with a filesystem lock held: the reclaim path
>>> + * may deadlock on it via filesystem shrinkers.
>>> + *
>>> + * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
>>> + * smaller than a page or the task is already in a reclaim context.
>>> + */
>>> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
>>> +						unsigned long size)
>>> +{
>>> +	unsigned long nr_reclaimed;
>>> +
>>> +	if (size < PAGE_SIZE || unlikely(bpf_in_reclaim_context()))
>>> +		return 0;
>> I have been thinking about this more and more and after looking at the reasoning
>> behind your check current->reclaim_state and also Sashiko's comment on NOIO/NOFS
>> contexts, I am more convinced that this kfunc can not be a simple sleepable
>> function. We need more than that. We need clean process context as well similar
>> to the userspace poking memory.reclaim. Something like kthread or workqueue.
>>
>> Kumar & Andrii, is there a way to restrict a kfunc to only be called from
>> special BPF threads/workqueues? Is there some similar concept in BPF world?
>>
> Yeah, I think the concern is valid. E.g. inode_rmdir() is sleepable but will be
> problematic here, I think. My first instinct was if bpf_in_reclaim_context() +
> nofs/noio save-restore might provide enough protection to let it be callable
> from generic sleepable contexts, but I guess that will disable invocation of
> filesystem shrinkers unconditionally.
>
> So my suggestion would be to fix the context to BPF_PROG_TYPE_SYSCALL. There, we
> should be able to init and schedule timers which poll specific state and arms wq
> execution etc. It then remains invocable from sleepable async contexts (wq,
> task_work) or the syscall program, all of which should be ok. Once BPF kthread
> lands we can let it be callable from those threads as well, but that is for
> later.

Hi Kumar and Shakeel,


The patch has been modified according to your comments.

Please help me review it.


Best,

Hui


>> [...]

