Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08062D6552C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55E2F6B0005; Wed, 17 Dec 2025 07:05:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C2B6B0089; Wed, 17 Dec 2025 07:05:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40AAE6B008A; Wed, 17 Dec 2025 07:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6A76B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:05:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5BD05BDAB
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:05:01 +0000 (UTC)
X-FDA: 84228832002.19.BB0F196
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id CB043180002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:04:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765973100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yEDFiTNKR9k5aG+LxJiEBHZkFlNPQs/POmgowgXY+48=;
	b=plMB0+qZqpSr4buJxjUuth4a0huDdqTnjFUIlyKNOLy9pLCmUMsIpSOWm7U6dr2D/I5VJ7
	20pwFUbdW14hSJild0ydtbtpO9pFJOtNpCREUft/J/I+4R0AOEHZ6jJpxNrDz7JT49twsV
	MDPAS1S8GzYzlKcLDEnMnn8rUX61jEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765973100; a=rsa-sha256;
	cv=none;
	b=x1WEtXfW2WINtJKXvvmmjd0lhr3ipteCEf1m4eXDq0PMJSVgL4uBjR43SMGhFQZyEJYa31
	IfvuE9lQNGCk4MQQgWPyBqq/6x56ijDnVAeOJnbTsJAiH/zhisuExVu34w1N7QN43/6mDR
	vjKeQyZqCF6Olpmsv7q06moOEf3OCvE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9267414BF;
	Wed, 17 Dec 2025 04:04:51 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DC733F73F;
	Wed, 17 Dec 2025 04:04:50 -0800 (PST)
Message-ID: <d96ac977-222e-4e8d-9487-da1306198419@arm.com>
Date: Wed, 17 Dec 2025 12:04:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] introduce pagetable_alloc_nolock()
Content-Language: en-GB
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, bigeasy@linutronix.de,
 clrkwllms@kernel.org, rostedt@goodmis.org, catalin.marinas@arm.com,
 will@kernel.org, kevin.brodsky@arm.com, dev.jain@arm.com,
 yang@os.amperecomputing.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, linux-arm-kernel@lists.infradead.org
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
 <916c17ba-22b1-456e-a184-cb3f60249af7@arm.com>
 <aUGOPd7gNRf1xHEc@e129823.arm.com>
 <100cc8da-b826-4fc2-a624-746bf6fb049d@arm.com>
 <aUKKZR0u22KOPfd7@e129823.arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aUKKZR0u22KOPfd7@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sfqedhm1xx3agqcojju7gpfgribbb45n
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CB043180002
X-Rspam-User: 
X-HE-Tag: 1765973099-941728
X-HE-Meta: U2FsdGVkX1+0RIdAY8kzR2aHs0eMMxhDRWX+vVLCLdw7ff0hJ0CJlllAc3LojVK0hwyxtRbreiLAPfs9V56GYFPtE81JZJtS89QaTnWVnflS2CkjEGIdlbZ9Otdh8wPcA+sFjW7lUsHeVRGEC6je7fZQ3BN4Feu6+dXXcsl8XaoTDr8FWRyPF/QePeOQkWMTyhwUp+1sqGME4n9UT6qrPHyrcw0NZcs1jzfibXUQFXgLyFMEDa3g+3pJHWQBAA9xCqhfuP+fS7YUEf05oh3bWouV/fuSpPb6AEC1P1k3JKmofGOO7CAdHLCPbzSlcOgYjOo4yn5zhPtfR9XjcHOxuMDRTs+nIanj5QFaJjhnx/61F521SFHSeZXbREiEE3Nt4mCH2iVImre7ldpn5tAIgh2kdmoeKAFnYiEwr/y/+WFtb25dbx11G3QQtzrJ5QSD6VG+AElgpetZoghQk/oUr47Y4LOUaPWZ0/vYW3M9ayhfS+CUIBnkUaiX3y4MoRtD2K1SHuxnSMcEOpzI553VdMEaq1u/+Ak+eA2CLYcr+iueedehyhFHjpi3GTDs+kRKpClQ7lhbGL3CYPRdHpR6zV4KZvIUf0ucMHlHNftslgGH367Rf9wLATVv7nFoUnBaiByemlqDR1MMOwQo0CiaiVzEwvyvcuYvjF4k+OetydNoSWKzV6dlNUF5Suea7r86expsvgMnS1A43vv/Kp5G7ZmOh7sRofCXSF+y2ETm6bIv3Hj3y2YSSzd6A3p0BPLJSkPkAKbxWJbVgiYc8HMALqYUts3BzuVDyVUPShVAfPeaNGimOVHR11+9B95nJ2589FVN+8A2uSROikMoeBhabYbeThbbNqmC2Y//KmAL/efy12ahsozUJxD85e6rr5QikAecrzRNv8qXdWIV8BjFFrHH6vlGxrGtBUjVHZpOdwGTP6nraZi7bgewss9DP2P/GKtr94DY/HX8ayHhXfy
 SnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 10:48, Yeoreum Yun wrote:
> Hi Ryan,
> 
>> On 16/12/2025 16:52, Yeoreum Yun wrote:
>>> Hi Ryan,
>>>
>>>> On 12/12/2025 16:18, Yeoreum Yun wrote:
>>>>> Some architectures invoke pagetable_alloc() or __get_free_pages()
>>>>> with preemption disabled.
>>>>> For example, in arm64, linear_map_split_to_ptes() calls pagetable_alloc()
>>>>> while spliting block entry to ptes and __kpti_install_ng_mappings()
>>>>> calls __get_free_pages() to create kpti pagetable.
>>>>>
>>>>> Under PREEMPT_RT, calling pagetable_alloc() with
>>>>> preemption disabled is not allowed, because it may acquire
>>>>> a spin lock that becomes sleepable on RT, potentially
>>>>> causing a sleep during page allocation.
>>>>>
>>>>> Since above two functions is called as callback of stop_machine()
>>>>> where its callback is called in preemption disabled,
>>>>> They could make a potential problem. (sleeping in preemption disabled).
>>>>>
>>>>> To address this, introduce pagetable_alloc_nolock() API.
>>>>
>>>> I don't really understand what the problem is that you're trying to fix. As I
>>>> see it, there are 2 call sites in arm64 arch code that are calling into the page
>>>> allocator from stop_machine() - one via via pagetable_alloc() and another via
>>>> __get_free_pages(). But both of those calls are passing in GFP_ATOMIC. It was my
>>>> understanding that the page allocator would ensure it never sleeps when
>>>> GFP_ATOMIC is passed in, (even for PREEMPT_RT)?
>>>
>>> Although GFP_ATOMIC is specify, it only affects of "water mark" of the
>>> page with __GFP_HIGH. and to get a page, it must grab the lock --
>>> zone->lock or pcp_lock in the rmqueue().
>>>
>>> This zone->lock and pcp_lock is spin_lock and it's a sleepable in
>>> PREEMPT_RT that's why the memory allocation/free using general API
>>> except nolock() version couldn't be called since
>>> if "contention" happens they'll sleep while waiting to get the lock.
>>>
>>> The reason why "nolock()" can use, it always uses "trylock" with
>>> ALLOC_TRYLOCK flags. otherwise GFP_ATOMIC also can be sleepable in
>>> PREEMPT_RT.
>>>
>>>>
>>>> What is the actual symptom you are seeing?
>>>
>>> Since the place where called while smp_cpus_done() and there seems no
>>> contention, there seems no problem. However as I mention in another
>>> thread
>>> (https://lore.kernel.org/all/aT%2FdrjN1BkvyAGoi@e129823.arm.com/),
>>> This gives a the false impression --
>>> GFP_ATOMIC are “safe to use in preemption disabled”
>>> even though they are not in PREEMPT_RT case, I've changed it.
>>>
>>>>
>>>> If the page allocator is somehow ignoring the GFP_ATOMIC request for PREEMPT_RT,
>>>> then isn't that a bug in the page allocator? I'm not sure why you would change
>>>> the callsites? Can't you just change the page allocator based on GFP_ATOMIC?
>>>
>>> It doesn't ignore the GFP_ATOMIC feature:
>>>   - __GFP_HIGH: use water mark till min reserved
>>>   - __GFP_KSWAPD_RECLAIM: wake up kswapd if reclaim required.
>>>
>>> But, it's a restriction -- "page allocation / free" API cannot be called
>>> in preempt-disabled context at PREEMPT_RT.
>>>
>>> That's why I think it's wrong usage not a page allocator bug.
>>
>> I've taken a look at this and I agree with your analysis. Thanks for explaining.
>>
>> Looking at other stop_machine() callbacks, there are some that call printk() and
>> I would assume that spinlocks could be taken there which may present the same
>> kind of issue or PREEMPT_RT? (I'm guessing). I don't see any others that attempt
>> to allocate memory though.
> 
> IIRC, there was a problem related for printk while try to grab
> pl011_console related lock (spin_lock) while holding
> console_lock(raw_spin_lock) in v6.10.0-rc7 at rpi5:
> 
>     [  230.381263] CPU: 2 PID: 5574 Comm: syz.4.1695 Not tainted 6.10.0-rc7-01903-g52828ea60dfd #3
>     [  230.381479] Hardware name: linux,dummy-virt (DT)
>     [  230.381565] Call trace:
>     [  230.381607]  dump_backtrace+0x318/0x348
>     [  230.381727]  show_stack+0x4c/0x80
>     [  230.381875]  dump_stack_lvl+0x214/0x328
>     [  230.382159]  dump_stack+0x3c/0x58
>     [  230.382456]  __lock_acquire+0x4398/0x4720
>     [  230.382683]  lock_acquire+0x648/0xb70
>     [  230.382928]  _raw_spin_lock_irqsave+0x138/0x240
>     [  230.383121]  pl011_console_write+0x240/0x8a0
>     [  230.383356]  console_flush_all+0x708/0x1368
>     [  230.383571]  console_unlock+0x180/0x440
>     [  230.383742]  vprintk_emit+0x1f8/0x9d0
>     [  230.383832]  vprintk_default+0x64/0x90
>     [  230.383914]  vprintk+0x2d0/0x400
>     [  230.383971]  _printk+0xdc/0x128
>     [  230.384229]  hrtimer_interrupt+0x8f0/0x920
>     [  230.384414]  arch_timer_handler_virt+0xc0/0x100
>     [  230.384812]  handle_percpu_devid_irq+0x20c/0x4e0
>     [  230.385053]  generic_handle_domain_irq+0xc0/0x120
>     [  230.385367]  gic_handle_irq+0x88/0x360
>     [  230.385559]  call_on_irq_stack+0x24/0x70
>     [  230.385801]  do_interrupt_handler+0xf8/0x200
>     [  230.386092]  el1_interrupt+0x68/0xc0
>     [  230.386434]  el1h_64_irq_handler+0x18/0x28
>     [  230.386716]  el1h_64_irq+0x64/0x68
>     [  230.386853]  __sanitizer_cov_trace_const_cmp2+0x30/0x68
>     [  230.387026]  alloc_pages_mpol_noprof+0x170/0x698
>     [  230.387309]  vma_alloc_folio_noprof+0x128/0x2a8
>     [  230.387610]  vma_alloc_zeroed_movable_folio+0xa0/0xe0
>     [  230.387822]  folio_prealloc+0x5c/0x280
>     [  230.388008]  do_wp_page+0xc30/0x3bc0
>     [  230.388206]  __handle_mm_fault+0xdb8/0x2ba0
>     [  230.388448]  handle_mm_fault+0x194/0x8a8
>     [  230.388676]  do_page_fault+0x6bc/0x1030
>     [  230.388924]  do_mem_abort+0x8c/0x240
>     [  230.389056]  el0_da+0xf0/0x3f8
>     [  230.389178]  el0t_64_sync_handler+0xb4/0x130
>     [  230.389452]  el0t_64_sync+0x190/0x198
> 
> But this problem is gone when I try with some of patches in rt-tree
> related for printk which are merged in current tree
> (https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/log/?h=linux-6.10.y-rt-rebase).
> 
> So I think printk() wouldn't be a problem.
> 
>>
>> Anyway, to fix the 2 arm64 callsites, I see 2 possible approaches:
>>
>> - Call the nolock variant (as you are doing). But that would just convert a
>> deadlock to a panic; if the lock is held when stop_machine() runs, without your
>> change, we now have a deadlock due to waiting on the lock inside stop_machine().
>> With your change, we notice the lock is already taken and panic. I guess it is
>> marginally better, but not by much. Certainly I would just _always_ call the
>> nolock variant regardless of PREEMPT_RT if we take this route; For !PREEMPT_RT,
>> the lock is guarranteed to be free so nolock will always succeed.
>>
>> - Preallocate the memory before entering stop_machine(). I think this would be
>> much more robust. For kpti_install_ng_mappings() I think you could hoist the
>> allocation/free out of stop_machine() and pass the pointer in pretty easily. For
>> linear_map_split_to_ptes() its a bit more complex; Perhaps, we need to walk the
>> pgtable to figure out how much to preallocate, allocate it, then set it up as a
>> special allocator, wrapped by an allocation function and modify the callchain to
>> take a callback function instead of gfp flags.
>>
>> What do you think?
> 
> Definitely, second suggestoin is much better.
> My question is whether *memory contention* really happen in the point
> both functions are called.

My guess would be that it's unlikely, but not impossible. The secondary CPUs are
up, and presumably running their idle thread. I think various power management
things can be plugged into the idle thread; if so, then I guess it's possible
that the CPU could be running some hook as part of a power state transition, and
that could be dynamically allocating memory? That's all just a guess though; I
don't know the details of that part of the system.

> 
> Above two functions are called as last step of "smp_init()" -- smp_cpus_done().
> If we can be sure, I think we don't need to go to complex way and
> I believe the reason why we couldn't find out this problem,
> even using GFP_ATOMIC in PREEMPT_RT since there was *no contection*
> in this time of both functions are called.
> > That's why I first try with the "simple way".
> 
> What do you think?

As far as linear_map_split_to_ptes() is concerned, it was implemented under the
impression that doing allocation with GFP_ATOMIC was safe, even in
stop_machine(). Given that's an incorrect assumption, I think we should fix it
to pre-allocate outside of stop_machine() regardless of the likelihood of
actually hitting the race.

Thanks,
Ryan

> 
> --
> Sincerely,
> Yeoreum Yun


