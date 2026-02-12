Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B347FEDF034
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 05:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2536B6B0089; Thu, 12 Feb 2026 00:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2CF6B008A; Thu, 12 Feb 2026 00:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E32D6B008C; Thu, 12 Feb 2026 00:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F32D86B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:16:44 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B511559F1D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:16:44 +0000 (UTC)
X-FDA: 84434644728.27.B619799
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0006FC0010
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:16:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770873403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UEDHW0tPcBQT4yrHJksy/6yPk7Tx7tA8x6ae+G3ePP4=;
	b=XmbNjwYxVVWwy3X91K0UWPyE4WxQPHqhnSDJNuXemPmL/rL/rQe0xwNIns5na2QuTs9oT8
	1I+V0JLIS1LDlnbbcx01y+NUo+JNOFtPGFzeO+53pbR6T2D/IKEuvtNk7yNduf5aNw0csp
	C9ca47LuzUCl+14U+uSiXAYQoZpaeJ0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770873403; a=rsa-sha256;
	cv=none;
	b=IcQFwpe5HSwxE3wmf4O7JYD+HkwEwNAROgKdkV+6Cs3pUiDYB56bLLqbEM5MdDwjQP5XYm
	bUaKOojmmXWgBRP0z6InRwVPATsjCQVPpsNlhM9XKScJwaBd3pyajfMBnnklcXZEDiFKk3
	WgUGjY/CqTXpeIGPrwI7F+T4fTQF/Gk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA3F0339;
	Wed, 11 Feb 2026 21:16:35 -0800 (PST)
Received: from [10.164.148.47] (MacBook-Pro.blr.arm.com [10.164.148.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 118973F73F;
	Wed, 11 Feb 2026 21:16:37 -0800 (PST)
Message-ID: <331b6f7b-3b3e-49dc-9f20-b1e4df424fde@arm.com>
Date: Thu, 12 Feb 2026 10:46:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: Shakeel Butt <shakeel.butt@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com> <aYOuCmjQ5lGm8Mup@linux.dev>
 <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com> <aYQuj6Ot-JS4tXvY@hyeyoo>
 <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
 <b77dc11e-fe09-4f0c-a912-d05faa01ff1c@arm.com> <aYtbevHEwx_3fn0Q@linux.dev>
 <5a6782f3-d758-4d9c-975b-5ae4b5d80d4e@arm.com> <aYxDkkDI4mk3r011@hyeyoo>
 <aYxIr5neJP8wBdZg@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aYxIr5neJP8wBdZg@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0006FC0010
X-Stat-Signature: e99f3hxfwtfabbchqgjyewc8jkhtiu59
X-Rspam-User: 
X-HE-Tag: 1770873402-951964
X-HE-Meta: U2FsdGVkX19ffDd25sEji4wtszTtYCaQ440o+q8laUh0hZ1fwrYd/hyOLKh/bCrKNP/CK6fM0PZ5jGkVd7DflC7MXQoFx44pMDfh5iqvHW5+IKbOqe2pEdJDgFRmpAS0BObcIvlAXYw4ODyiP1nM5/MagSDrHbiaV1Rt6Cql2EaHQjswV3oAx9nyb5txCXAs1LC1av5q0H3hTI8fcTo8NqDUU144y3f37o2njqvhwB5gMiR0cVADi6h4DrscOqRnkzh9VM6EzJBuDauz96P7Rn/Ku+8hoX4D8LrzMyapDRrKiVTpV9ZeYMHiNkL3QTK1gvXK71UYz/0038r48ZiFl5hD9h8eI+imiRa+z1vG2yQJ03sDPYyqxuDx556fPM6urkdiTu7BKkYoREzPAmu1C1By8iFNUjsLzg2VcdR7s/uX+2r5MA3xQuFxjCw0rJhSa67Y2RVEvVStbW8lIXkHMqg/HLCIRnI3sLjCD99B36xCsB7OfXzUYd5y4MpJ5SEa3zxFSogI2NGp6cLqQWAw5aRLKU7hCk2YdT+XmAgwIedIkdn5JDwj2Pcf8+oOVMx9HDk2WV4H3es5elz+EDOLCzb2IUwpq8dCcMe1eKz7g3nO9Yt7AaEAwS5WAWkBObIRiXf8FWE3mGFSayoIRRvrkNgK+sZTW8h/t/BxpwQ9L4OUpR1JepNeyTgfguttR11exo2Z8v1oYEu7pw49hA06zLCSlfOf2o191qWNPahh1a8ZziYV95nm858TUtcN0PO8h059Phf9hutqyvNnfWUqFyp17BJaoAZJBF3+w9DkyG859q0R0Q19QBl4X11vYQeVrsjXc0FGbcDVWqxKjUcbU2r5BjHM83lT4lbxf+39+VWaFHjkHRjfLOLqy+kSD1pvdpzyWO8x+9bGd3WXFbC7ML+gQRzL6ftzRFaZIyUEAVejksy72lVAA8i2ZJ7S2kcPFWvFA8uIfU3HBXUeaXO
 hUY1pBnP
 N0bVSCqkwFXDggdbYhW+n0Ac6jE/TfYRgCPx0VgQUJq2e49S8Jz8UAkrB7ednTTudF+fkeTbxO3hz6i3pWk2T1UDOK2CAetxMMixe3hVZDXQO9ZD1tx4hUk7wkE1SG9SkVX/Bi0g+HNgnYgpoE84PuoHTuK2/UgcBtq5R72KgHuEPWckF4+JRaR34TzPMGOvxJAIwC15QyWSxlTm/7uDId8q3ZbjEHZhZDHQqs+D3ZlKaaQbzPFQ2GCRcQu0E9yBp405AIHdg+Lckvxs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/02/26 2:54 pm, Shakeel Butt wrote:
> On Wed, Feb 11, 2026 at 05:53:38PM +0900, Harry Yoo wrote:
>> On Wed, Feb 11, 2026 at 01:07:40PM +0530, Dev Jain wrote:
>>> On 10/02/26 9:59 pm, Shakeel Butt wrote:
>>>> On Tue, Feb 10, 2026 at 01:08:49PM +0530, Dev Jain wrote:
>>>> [...]
>>>>>> Oh so it is arm64 specific issue. I tested on x86-64 machine and it solves
>>>>>> the little regression it had before. So, on arm64 all this_cpu_ops i.e. without
>>>>>> double underscore, uses LL/SC instructions. 
>>>>>>
>>>>>> Need more thought on this. 
>>>>>>
>>>>>>>> Also can you confirm whether my analysis of the regression was correct?
>>>>>>>>  Because if it was, then this diff looks wrong - AFAIU preempt_disable()
>>>>>>>>  won't stop an irq handler from interrupting the execution, so this
>>>>>>>>  will introduce a bug for code paths running in irq context.
>>>>>>>>
>>>>>>> I was worried about the correctness too, but this_cpu_add() is safe
>>>>>>> against IRQs and so the stat will be _eventually_ consistent?
>>>>>>>
>>>>>>> Ofc it's so confusing! Maybe I'm the one confused.
>>>>>> Yeah there is no issue with proposed patch as it is making the function
>>>>>> re-entrant safe.
>>>>> Ah yes, this_cpu_add() does the addition in one shot without read-modify-write.
>>>>>
>>>>> I am still puzzled whether the original patch was a bug fix or an optimization.
>>>> The original patch was a cleanup patch. The memcg stats update functions
>>>> were already irq/nmi safe without disabling irqs and that patch did the
>>>> same for the numa stats. Though it seems like that is causing regression
>>>> for arm64 as this_cpu* ops are expensive on arm64. 
>>>>
>>>>> The patch description says that node stat updation uses irq unsafe interface.
>>>>> Therefore, we had foo() calling __foo() nested with local_irq_save/restore. But
>>>>> there were code paths which directly called __foo() - so, your patch fixes a bug right
>>>> No, those places were already disabling irqs and should be fine.
>>> Please correct me if I am missing something here. Simply putting an
>>> if (!irqs_disabled()) -> dump_stack() in __lruvec_stat_mod_folio, before
>>> calling __mod_node_page_state, reveals:
>>>
>>> [ 6.486375] Call trace:
>>> [ 6.486376] show_stack+0x20/0x38 (C)
>>> [ 6.486379] dump_stack_lvl+0x74/0x90
>>> [ 6.486382] dump_stack+0x18/0x28
>>> [ 6.486383] __lruvec_stat_mod_folio+0x160/0x180
>>> [ 6.486385] folio_add_file_rmap_ptes+0x128/0x480
>>> [ 6.486388] set_pte_range+0xe8/0x320
>>> [ 6.486389] finish_fault+0x260/0x508
>>> [ 6.486390] do_fault+0x2d0/0x598
>>> [ 6.486391] __handle_mm_fault+0x398/0xb60
>>> [ 6.486393] handle_mm_fault+0x15c/0x298
>>> [ 6.486394] __get_user_pages+0x204/0xb88
>>> [ 6.486395] populate_vma_page_range+0xbc/0x1b8
>>> [ 6.486396] __mm_populate+0xcc/0x1e0
>>> [ 6.486397] __arm64_sys_mlockall+0x1d4/0x1f8
>>> [ 6.486398] invoke_syscall+0x50/0x120
>>> [ 6.486399] el0_svc_common.constprop.0+0x48/0xf0
>>> [ 6.486400] do_el0_svc+0x24/0x38
>>> [ 6.486400] el0_svc+0x34/0xf0
>>> [ 6.486402] el0t_64_sync_handler+0xa0/0xe8
>>> [ 6.486404] el0t_64_sync+0x198/0x1a0
>>>
>>> Indeed finish_fault() takes a PTL spin lock without irq disablement.
>> That indeed looks incorrect to me.
>> I was assuming __foo() is always called with IRQs disabled!
> Not necessarily. For stats which never get updated in IRQ context, can
> be updated using __foo() with just premption disabled.
>
>>>> I am working on adding batched stats update functionality in the hope
>>>> that will fix the regression.
>>> Thanks! FYI, I have zeroed in the issue on to preempt_disable(). Dropping this
>>> from _pcpu_protect_return solves the regression.
>> That's interesting, why is the cost of preempt disable/enable so high?
>>
> What made you (Dev) so convinced that preempt_disable is that expensive.

As I wrote above, dropping the preempt disable from _pcp_protect_return solved
the regression. So, it hints at the cost of this - although it seems surprising
that this may be expensive, so need to investigate : )

>
>>> Unlike x86, arm64 does a preempt_disable
>>> when doing this_cpu_*. On a cursory look it seems like this is unnecessary - since we
>>> are doing preempt_enable() immediately after reading the pointer, CPU migration is
>>> possible anyways, so there is nothing to be gained by reading pcpu pointer with
>>> preemption disabled. I am investigating whether we can simply drop this in general.
> [...]
>> ... so, removing preempt disable _in general_ is probably not a good idea.
>>
> Yup, I agree here.
>
>> [1] https://lore.kernel.org/all/20190311164837.GD24275@lakrids.cambridge.arm.com
>>
>> -- 
>> Cheers,
>> Harry / Hyeonggon
>>

