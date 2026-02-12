Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4A6EDF039
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 05:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F0A6B0005; Thu, 12 Feb 2026 00:14:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5025A6B0089; Thu, 12 Feb 2026 00:14:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40EAC6B008A; Thu, 12 Feb 2026 00:14:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 318F46B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:14:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C633888BC5
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:14:54 +0000 (UTC)
X-FDA: 84434640108.14.51EC452
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 09DBA120009
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:14:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770873293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KpAB1ilcTljzmGJOv5VdHQT6F61PmtFrFeE43rn3Y6E=;
	b=Phk/HF1VvRpbK9cx9bSuAAB4jZ4SMP2ct8PgnRhoN7f4Gqgm413LmZAhwGXswb/AX1MRN3
	tPBoArAxqAbFQGCl2CeWdUsXCKNejoZCvgyEveBtJDmHfV3PFq0SVfhLpIvNZSus1rRPHw
	NTO7dxipC2/gRiEI4cWAxZRvvqm5mGg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770873293; a=rsa-sha256;
	cv=none;
	b=jlIa/EqWDbymUCpMhvjdX/V4ya3KRqBgUlx6HwqKx/xrRhBGLKGp01EGrkxxZfbgxuCAYF
	OIWx03sF99Xgec4xfpRTnZUgk05F+eGGXvJKwaQ7R89zDhy9BGZv2L+v1b+fkkeRb85Qar
	QUIk0SqQWylam1NFyAnA8HfaNSBsq3Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC78A339;
	Wed, 11 Feb 2026 21:14:45 -0800 (PST)
Received: from [10.164.148.47] (MacBook-Pro.blr.arm.com [10.164.148.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16E273F73F;
	Wed, 11 Feb 2026 21:14:47 -0800 (PST)
Message-ID: <f5d16072-d8a4-40a6-9414-bc4115013564@arm.com>
Date: Thu, 12 Feb 2026 10:44:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com> <aYOuCmjQ5lGm8Mup@linux.dev>
 <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com> <aYQuj6Ot-JS4tXvY@hyeyoo>
 <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
 <b77dc11e-fe09-4f0c-a912-d05faa01ff1c@arm.com> <aYtbevHEwx_3fn0Q@linux.dev>
 <5a6782f3-d758-4d9c-975b-5ae4b5d80d4e@arm.com> <aYxDkkDI4mk3r011@hyeyoo>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aYxDkkDI4mk3r011@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 09DBA120009
X-Stat-Signature: njmoc9563tj5moi5f4z8pcr7fo3tnyfa
X-Rspam-User: 
X-HE-Tag: 1770873292-172100
X-HE-Meta: U2FsdGVkX1/tUA3XGH55VU6Z9rpkq19czVLJImu+ZEH0CfNotf6sf6jlzX93knzJ3efxWtXBE5keFf1QuyaSSdrfo5AiNSMl3pSTNvkaDwYcc0SAHwSWgg6B0j2gXFq/aaNFbg4cHWgQdduMtsnF6YBw9e84QSbmtyJoiG4um1dBWJH2EJVIf9YXS9A0FQcXYOdHLmU9tveVSrM2fL6+ioTFyy3S4ba1Bm3GnGExbGj75KrMPHBvo9uUL04x9No9kTjZEnwRY1CZYTiL+pdG/OgoKpKR6WoWoQifFyrNrPILIUwFuHGpYAf9nPz2asEjuazuTflKIMkTMKuqZTV2bgfy5/2rkZz8vrw9kWvGcPFzfo57Xl1+qceTffIfrzU8T5tNUNpF7Leafabufl3VXUN29Y1X/+SiShRJ/iSO6TEyotuomjlmVR2bV4kgKtndPq9jvZi5AFBZSIrbtUVhtbiRuEqT9elVhpnaNzoiXU4yMi3rxPilIO3Eft0gURtyWbB5DeCkkGHbGF8v4DFF/OP9Gr2cRgUo1Rxk3uvEsAAffm9QG0tGspY49bljanqZeWVtKc69QK3dGldopt3JJ1KR69grXdfUWUiKvEURJ9gnntc7X/tqzRO2E/GBI6O2h3LmNiH2BJY4DvCFNIwZ8xpcJgmGQUfpOaO0LuALkoZCE9KMo+WyPiI3OHtNWxbBGd3a/ZmetqNkv30pfMVD8OkILvXtxtk4RGK47YTSlf9QxROhwLMGIYtJJfAAuyieL0kUFbuC+axr83ZT0ZWrJ4qXsOIxxdnfpjHRx3XAv8IwzKdQxXVemfJoE9Jw8etGJ++iKydbOEb8EPhJyPXk8lvsa/ILSag+cxE/sm32pdi+ex0ISFBhN74pYaDz+qIXDk86XEE7wmzHomgqg4zWqR1BFG504IPptzRN62hcY94iqYh3pI/ppuYXZIIkvSVgB4f/uowL3hZZeUSnuN4
 v/29qlnv
 dHN0HGVnKl2rYvrRA6UWqIu0VG6CVz8MSexVeXkNNC/C8/UKTpcrdC3jh5IZbTL+EEqHAtIr12H6TVX6V5r5k6xRhOj/YFGUZgv+nibB074DTFJiUnwbpWwUlA3RPotZR5nQWKMShhaIlnxQGmPEs3xem+rgk69sVPaRe9Plz91QSSIJQbjCvazcgFXmCnqW3LDqui7VePQswjiP/aXbulCLv9CfVm3ys84ASftWqSa5+C1KWn40TrVQmpA7Mh60IrYyTXRlcsQBgUdM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/02/26 2:23 pm, Harry Yoo wrote:
> On Wed, Feb 11, 2026 at 01:07:40PM +0530, Dev Jain wrote:
>> On 10/02/26 9:59 pm, Shakeel Butt wrote:
>>> On Tue, Feb 10, 2026 at 01:08:49PM +0530, Dev Jain wrote:
>>> [...]
>>>>> Oh so it is arm64 specific issue. I tested on x86-64 machine and it solves
>>>>> the little regression it had before. So, on arm64 all this_cpu_ops i.e. without
>>>>> double underscore, uses LL/SC instructions. 
>>>>>
>>>>> Need more thought on this. 
>>>>>
>>>>>>> Also can you confirm whether my analysis of the regression was correct?
>>>>>>>  Because if it was, then this diff looks wrong - AFAIU preempt_disable()
>>>>>>>  won't stop an irq handler from interrupting the execution, so this
>>>>>>>  will introduce a bug for code paths running in irq context.
>>>>>>>
>>>>>> I was worried about the correctness too, but this_cpu_add() is safe
>>>>>> against IRQs and so the stat will be _eventually_ consistent?
>>>>>>
>>>>>> Ofc it's so confusing! Maybe I'm the one confused.
>>>>> Yeah there is no issue with proposed patch as it is making the function
>>>>> re-entrant safe.
>>>> Ah yes, this_cpu_add() does the addition in one shot without read-modify-write.
>>>>
>>>> I am still puzzled whether the original patch was a bug fix or an optimization.
>>> The original patch was a cleanup patch. The memcg stats update functions
>>> were already irq/nmi safe without disabling irqs and that patch did the
>>> same for the numa stats. Though it seems like that is causing regression
>>> for arm64 as this_cpu* ops are expensive on arm64. 
>>>
>>>> The patch description says that node stat updation uses irq unsafe interface.
>>>> Therefore, we had foo() calling __foo() nested with local_irq_save/restore. But
>>>> there were code paths which directly called __foo() - so, your patch fixes a bug right
>>> No, those places were already disabling irqs and should be fine.
>> Please correct me if I am missing something here. Simply putting an
>> if (!irqs_disabled()) -> dump_stack() in __lruvec_stat_mod_folio, before
>> calling __mod_node_page_state, reveals:
>>
>> [ 6.486375] Call trace:
>> [ 6.486376] show_stack+0x20/0x38 (C)
>> [ 6.486379] dump_stack_lvl+0x74/0x90
>> [ 6.486382] dump_stack+0x18/0x28
>> [ 6.486383] __lruvec_stat_mod_folio+0x160/0x180
>> [ 6.486385] folio_add_file_rmap_ptes+0x128/0x480
>> [ 6.486388] set_pte_range+0xe8/0x320
>> [ 6.486389] finish_fault+0x260/0x508
>> [ 6.486390] do_fault+0x2d0/0x598
>> [ 6.486391] __handle_mm_fault+0x398/0xb60
>> [ 6.486393] handle_mm_fault+0x15c/0x298
>> [ 6.486394] __get_user_pages+0x204/0xb88
>> [ 6.486395] populate_vma_page_range+0xbc/0x1b8
>> [ 6.486396] __mm_populate+0xcc/0x1e0
>> [ 6.486397] __arm64_sys_mlockall+0x1d4/0x1f8
>> [ 6.486398] invoke_syscall+0x50/0x120
>> [ 6.486399] el0_svc_common.constprop.0+0x48/0xf0
>> [ 6.486400] do_el0_svc+0x24/0x38
>> [ 6.486400] el0_svc+0x34/0xf0
>> [ 6.486402] el0t_64_sync_handler+0xa0/0xe8
>> [ 6.486404] el0t_64_sync+0x198/0x1a0
>>
>> Indeed finish_fault() takes a PTL spin lock without irq disablement.
> That indeed looks incorrect to me.
> I was assuming __foo() is always called with IRQs disabled!
>
>>> I am working on adding batched stats update functionality in the hope
>>> that will fix the regression.
>> Thanks! FYI, I have zeroed in the issue on to preempt_disable(). Dropping this
>> from _pcpu_protect_return solves the regression.
> That's interesting, why is the cost of preempt disable/enable so high?
>
>> Unlike x86, arm64 does a preempt_disable
>> when doing this_cpu_*. On a cursory look it seems like this is unnecessary - since we
>> are doing preempt_enable() immediately after reading the pointer, CPU migration is
>> possible anyways, so there is nothing to be gained by reading pcpu pointer with
>> preemption disabled. I am investigating whether we can simply drop this in general.
> Let me quote an old email from Mark Rutland [1]:
>> We also thought that initially, but there's a sbutle race that can
>> occur, and so we added code to disable preemption in commit:
>>
>>   f3eab7184ddcd486 ("arm64: percpu: Make this_cpu accessors pre-empt safe")
>>
>> The problem on arm64 is that our atomics take a single base register,
>> and we have to generate the percpu address with separate instructions
>> from the atomic itself. That means we can get preempted between address
>> generation and the atomic, which is problematic for sequences like:
>>
>> 	// Thread-A			// Thread-B
>>
>> 	this_cpu_add(var)
>> 					local_irq_disable(flags)
>> 					...
>> 					v = __this_cpu_read(var);
>> 					v = some_function(v);
>> 					__this_cpu_write(var, v);
>> 					...
>> 					local_irq_restore(flags)
>>
>> ... which can unexpectedly race as:
>>
>>
>> 	// Thread-A			// Thread-B
>>
>> 	< generate CPU X addr >
>> 	< preempted >
>>
>> 					< scheduled on CPU X >
>> 					local_irq_disable(flags);
>> 					v = __this_cpu_read(var);
>>
>> 	< scheduled on CPU Y >
>> 	< add to CPU X's var >
>> 					v = some_function(v);
>> 					__this_cpu_write(var, v);
>> 					local_irq_restore(flags);
>>
>> ... and hence we lose an update to a percpu variable.
> ... so, removing preempt disable _in general_ is probably not a good idea.
>
> [1] https://lore.kernel.org/all/20190311164837.GD24275@lakrids.cambridge.arm.com

Thanks for the link!


