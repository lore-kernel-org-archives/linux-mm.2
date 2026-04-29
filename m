Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A90FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 04:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF4C6B0005; Wed, 29 Apr 2026 00:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6F26B008A; Wed, 29 Apr 2026 00:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25F36B008C; Wed, 29 Apr 2026 00:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E13596B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:40:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0446E8F6A3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:34:56 +0000 (UTC)
X-FDA: 84710328234.09.60D8D4F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id E1C954000B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:34:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="R/GNfer8";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777437295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8owAGB2dES6d7EjS4RuaoW7yOHbnwCyeEq2Bot6ImOo=;
	b=rCsG0RUxXo+Usiky0/ZSlZJxFq0y+Y62J778JSRYsO7Palv4E4Q+uNCiaZD/8UuVs//hh5
	mFAZvB0OiOR91fkvWdMJJ8gtMUnx+ZiSVfpjVKYQGtJUwAV9o8msvZreulCMoOPZM38u+I
	qgFAQMYPrM6nlPQje5+J9qDOrEK0ybQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777437295; a=rsa-sha256;
	cv=none;
	b=MTrq8W0qMq1pAK8bklKtvsmv3mR6/OcsC/2Reg2RKwF96/QB/UIthK6P9Cd5g206M/rxUb
	oISf+xeISKQZ/nX4UFDR+2fsW0l6/J1LTwtI5dsbAYbFrstC1uePa9afCjpWYr3xOlZMSC
	0rAL2K4zZ0i2cM3JFELPCE0eTbZAYcM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="R/GNfer8";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
Message-ID: <7b17c0c8-253f-4755-a324-1132cd3c0921@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777437292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8owAGB2dES6d7EjS4RuaoW7yOHbnwCyeEq2Bot6ImOo=;
	b=R/GNfer8bsyRbTQyVruq90Dylr8abYClc80TDVE5TNJ2eAW95mwTwgTImMrRW61ia3wygK
	q2G9fJBWVrOU89kcOtLjeqv7xH3Tu52I7WP+3Cborh/n+xHEn2dAZDhsqOi9tdIQA+jXqs
	MYtUQkLuAzGCPzWaJw/8+6UX9On+YHc=
Date: Wed, 29 Apr 2026 12:34:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 08/17] mm: introduce bpf_oom_kill_process()
 bpf kfunc
To: Matt Bobrowski <mattbobrowski@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-9-roman.gushchin@linux.dev>
 <aYAsxRI2JGU9KCeO@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <aYAsxRI2JGU9KCeO@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E1C954000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 88p7zid3sgcy6f53b757er9t6p5i71ty
X-HE-Tag: 1777437294-242244
X-HE-Meta: U2FsdGVkX19qtqSunQVEhtfjfN6yjWeehSiF11rOoa46PbJsS/0CDey7sl/XfGCZqPzsKJoKGrRKr/NdzuovN2LTbQVULtsGZWOF0HVBMPFCJopNGMjhhWGNieRPNkJdHPM30ua8WXaAp9Dy2B3vRtgX1BkMkBZ6or+bvST1avFiHcTN9UjyfTTX6Nu2vOx6Z+07XxDa6c1/kqtE5dZbtQg3Vu/CFT44HF4xL9IFMehFhoAdWAiAMnZoZjKZWNk6NAJqyWEGeHoTCgUbk7o7I24IPRUAgSrUkSzGdALRkpBSx9bNbEy2Jos5pynntXDFpfZfWrOJCZ1RjrB/ujfVntzzpty4J+q4oMxCUUlSLVF+aswpbd+qbjvktooEd+/E8XbFeUXxLHXcoTDfuMTMSAaJq1sY/J/RZISxie2pnPPjsSderskbuls0Gr+4Qis0OuR7JnfSOwy3JhZU+wi+m6XlPMFKneumHEKF7/BBCcg7kztmgf9RTIU7SYzmxppJC8Y9v30saJURqk2twqnLwyFOXaunL+ixvrjHtpP025nBR3Vv9OF/9+yHTJGPwx3m6jLHWj/YbDvfQlZ+Bd9hYXAZkoTHFpQuRniwJ1o0n14uA8fVIDb9h5TSFJs5cNKZOSQzKsZ4P2DLtGIPI2vf8xlSu/cjoLRHJ50Ki0dSym4HT2BhM7KZch7VbdM1rg1DY4AkeeBQqRa8dYc+sIzMtW9K/OVaVkwD9WOke+yj77/y6Z9s0Jqnib/Cd5wZDH/xTHNfX4pLsVVOL1uFCcjqH6X/UV3REYCU2RJTC3Ucltwpk1lz43bMrnzBkFy+CcpuFYcjoARrdqaTycS7tyKlruWonWQSTtRhV6ivtrpEon5EI4cTELyvTVILZxRlBZy3DqpDtCeSuH3h1Tjkufvbjv93ToxuwIN38FjhVXBajRTXt/EgpWWjyEP5ql4VEijmFNN7joBlPkWDO4tBTFM
 Wtmv0RK/
 0RTf+NffM4ikYcFJVuSOoI1TAxR+3ZaejS9SI7J7XfO35MR+LHChUwxCNAJhUwRIwEjv0VAWageupYJOtW2JRKwwwGFZrT/9pcm4O7R9O6YQTh8Gj4+IiFmE10q81mpkUAi/woRXC7p7W4BksPXEAGh+wgNJnWVIfGNgk2f4L5MxxVVde4lZKLiFpeihZXKTe1gaXOj/ccxeCzGKRf+fzX8pU/dVqHTD9dP0htqPtOeSl2lyxhLMw7ZDy/4R60je6fTSTmiZdiE4tLG143y43Cc7lICt5Q2eipEsF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/2/2 12:49, Matt Bobrowski wrote:
> On Mon, Jan 26, 2026 at 06:44:11PM -0800, Roman Gushchin wrote:
>> Introduce bpf_oom_kill_process() bpf kfunc, which is supposed
>> to be used by BPF OOM programs. It allows to kill a process
>> in exactly the same way the OOM killer does: using the OOM reaper,
>> bumping corresponding memcg and global statistics, respecting
>> memory.oom.group etc.
>>
>> On success, it sets the oom_control's bpf_memory_freed field to true,
>> enabling the bpf program to bypass the kernel OOM killer.
>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>   mm/oom_kill.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 80 insertions(+)
>>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 44bbcf033804..09897597907f 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -46,6 +46,7 @@
>>   #include <linux/cred.h>
>>   #include <linux/nmi.h>
>>   #include <linux/bpf_oom.h>
>> +#include <linux/btf.h>
>>   
>>   #include <asm/tlb.h>
>>   #include "internal.h"
>> @@ -1290,3 +1291,82 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
>>   	return -ENOSYS;
>>   #endif /* CONFIG_MMU */
>>   }
>> +
>> +#ifdef CONFIG_BPF_SYSCALL
>> +
>> +__bpf_kfunc_start_defs();
>> +/**
>> + * bpf_oom_kill_process - Kill a process as OOM killer
>> + * @oc: pointer to oom_control structure, describes OOM context
>> + * @task: task to be killed
>> + * @message__str: message to print in dmesg
>> + *
>> + * Kill a process in a way similar to the kernel OOM killer.
>> + * This means dump the necessary information to dmesg, adjust memcg
>> + * statistics, leverage the oom reaper, respect memory.oom.group etc.
>> + *
>> + * bpf_oom_kill_process() marks the forward progress by setting
>> + * oc->bpf_memory_freed. If the progress was made, the bpf program
>> + * is free to decide if the kernel oom killer should be invoked.
>> + * Otherwise it's enforced, so that a bad bpf program can't
>> + * deadlock the machine on memory.
>> + */
>> +__bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
>> +				     struct task_struct *task,
>> +				     const char *message__str)
>> +{
>> +	if (oom_unkillable_task(task))
>> +		return -EPERM;
>> +
>> +	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
>> +		return -EINVAL;
Hi Matt and Roman
> task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN is also
> representative of an unkillable task, so why not fold this up into the
> above conditional? Also, why not bother checking states like
> mm_flags_test(MMF_OOM_SKIP, task->mm) and in_vfork() here too?
>
> In all fairness I'm a little surprised about constraints like
> task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN being enforced
> here. You could argue that the whole purpose of BPF OOM is such that
> you can implement your own victim selection algorithms entirely in BPF
> using your own set of heuristics and what not without needing to
> strictly respect properties like oom_score_adj.

Just my 2 cents — historically many users rely on setting oom_score_adj 
to OOM_SCORE_ADJ_MIN to protect their critical processes.

If we don't check this here and a custom BPF program happens to forget 
it, users would be quite surprised to find their most important

processes killed despite having explicitly marked them as protected.

So this really comes down to a priority question: when a custom BPF OOM 
policy decides to kill a process that the admin has explicitly

marked as protected via OOM_SCORE_ADJ_MIN, which one should take 
precedence?


> In any case, I think we should at least clearly document such
> constraints.

Fully agree. We need thorough documentation on what 
bpf_oom_kill_process() enforces on the kernel side,

so that custom BPF programs know exactly what's already handled and what 
additional checks they may

need to perform depending on their use case.


Thanks

Best regards.
Hao

>> +	/* paired with put_task_struct() in oom_kill_process() */
>> +	get_task_struct(task);
>> +
>> +	oc->chosen = task;
>> +
>> +	oom_kill_process(oc, message__str);
>> +
>> +	oc->chosen = NULL;
>> +	oc->bpf_memory_freed = true;
>> +
>> +	return 0;
>> +}
>> +
>> +__bpf_kfunc_end_defs();
>> +
>> +BTF_KFUNCS_START(bpf_oom_kfuncs)
>> +BTF_ID_FLAGS(func, bpf_oom_kill_process, KF_SLEEPABLE)
>> +BTF_KFUNCS_END(bpf_oom_kfuncs)
>> +
>> +BTF_ID_LIST_SINGLE(bpf_oom_ops_ids, struct, bpf_oom_ops)
>> +
>> +static int bpf_oom_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
>> +{
>> +	if (prog->type != BPF_PROG_TYPE_STRUCT_OPS ||
>> +	    prog->aux->attach_btf_id != bpf_oom_ops_ids[0])
>> +		return -EACCES;
>> +	return 0;
>> +}
>> +
>> +static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
>> +	.owner          = THIS_MODULE,
>> +	.set            = &bpf_oom_kfuncs,
>> +	.filter         = bpf_oom_kfunc_filter,
>> +};
>> +
>> +static int __init bpf_oom_init(void)
>> +{
>> +	int err;
>> +
>> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
>> +					&bpf_oom_kfunc_set);
>> +	if (err)
>> +		pr_warn("error while registering bpf oom kfuncs: %d", err);
>> +
>> +	return err;
>> +}
>> +late_initcall(bpf_oom_init);
>> +
>> +#endif
>> -- 
>> 2.52.0
>>

