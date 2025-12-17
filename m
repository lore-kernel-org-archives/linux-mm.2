Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15245D65521
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677E16B0005; Wed, 17 Dec 2025 04:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB6D6B0089; Wed, 17 Dec 2025 04:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9B86B008A; Wed, 17 Dec 2025 04:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38DFD6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:34:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D815EBBEAF
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:34:26 +0000 (UTC)
X-FDA: 84228452532.30.E13B810
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id D1A121A0018
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:34:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765964065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lpa2rhDPjPOei7xhJfHDGmklb1GOZ+SO0ChmZ0J+oe4=;
	b=oUVuvd6EzlgevZrwv/XYk/rIOm7kC+Vnn6YPwHBviRNu24g17hh1Fh1dA80L8uxB77bTmx
	d1e32IcQelgs82REfVgyhcreAz7DOF3SGXuvrvZB2UIzw/o4hw45hrdooOdtLZ+Atv2Msr
	HZ5I4Bk6JIofNC+zRDxpE7gZmxvI28M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765964065; a=rsa-sha256;
	cv=none;
	b=NQMK3JsA8ZUce+jHhGJyYm+9taSZYPHpN9dPkw3eA3JWU/i+gK6xgdbXRdn0rtmGRgFDSM
	VfSDZTjd+w6D1qXb7/stUh4j1QcGfCczwpG11RtEvern4SVV8y6ReDwyLXDU5lNojS1jrq
	cgcNVG23rRGAGfWgoTKt/B6+wsyfxQQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9305914BF;
	Wed, 17 Dec 2025 01:34:16 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 894773F73B;
	Wed, 17 Dec 2025 01:34:17 -0800 (PST)
Message-ID: <100cc8da-b826-4fc2-a624-746bf6fb049d@arm.com>
Date: Wed, 17 Dec 2025 09:34:15 +0000
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
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aUGOPd7gNRf1xHEc@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: g3wkhp1z3cyuf319buqbaqr16wst3fo6
X-Rspam-User: 
X-Rspamd-Queue-Id: D1A121A0018
X-HE-Tag: 1765964064-476546
X-HE-Meta: U2FsdGVkX1/dDu5LDKI9xzaaHqUSMaOyCyu0HRT3qeVQ7/G2AzcxGlbtRrgeSULwcwv3pyaeMac24OSgUf15RW27cHYIXO9AwBsw4BQoQBlLSNuyx+iUMDExCZAHsc9FRsUtm427kHB7QKnkSL4zTrYwVamWt19EXVlrIq53odbAceKRYTUZ3xHzv3uZBzL3Mi2lJDJfYIRnLeR5dMTyAz8ZwbDn2LnX26QRzMBi5q38ro7uaTGEwGCZQWhQCyHj3EE7DR89c1ZQHXaqbB7bF0jIuqXyqgysCoLZWIgAVBkbT9IsckoMlaSi222mGf3Iv2nBVA/VnIQqAzOYR6giSgJDGw+jbujLkHFJLSRWMPnwGZ/wlcgpms1fNt1ceEdLQBWBKTxmRIVLDJptuTIY7eUenZh72+riAfZhEpTLsaQV6BPd0WWD3b2k/s495svIRSoRXBQN2hD+13ieHhNiNzsPHqweUxQaXCE8757nNcAkUdXTFt/lpGxTXnO777qliAE4XTp9ZCzfEQ75LoiJnf1t0yuvLznM0nIlDgZa6w/x75rEveG32+Cjmud02pA/Ic6rQR9xZLLpND8Hw3R9Vf8D/Du3widEpppW4KwVDbq9XiciHGH7l0HHY7rymN7dqRY+iB5dj2Y3CvrCKCDwhf7DYavyNuIIZqxPGbZXhmlLyIzK00fleUUDjAZic4kRcwidwalBQYevLfGtJ/3m6czQyIq/SWUJ46BeZV/p96QPbmtAcbF0JUhOBui6xpz35iBjnvRCGrtSdM5wfFCyhljhYXq7Cc8TJ8Ajhvc2SeucUwla26tOHYSo5hDGBtPBFaaF9sEZKrzFIasf/SbQF8Dtjy5FVsNHhIhoVEugwZysKI2I8FDjLpMQZkLfJcIewoWpwYaQQogfS8C1xQF9ksIfS3RV1Sz+tnyO/qevkXrWeLDtiuSwIMFy0jHu1IXVT+CocP6g0rg/2hCvbRH
 8a+iKK0R
 yf3swzBDDOzhTABY/rSgRimE9XptbaNL4sQ50V+Hgi9BVgqTS54Kno8BEikLMihhs6OdCrRSn8ZG+LSnAXs3v/ToR7NH/SQ0ViY/JDqK0HSQN2l657+/wZhF1Gn9XWu6vPl2hK4/At+UrshARp4NNq35SBA8ELQrfiYlk694acgb0KhR9+4yVo1EscyIQo/nTPzzGSUHbtlqLh9F7GxrK8tD7MvmK+rzdSn2+qyeRGOun+olCi9pau5TTOulF707NPyd9Vt0eUig4GsJtDBxLJTgKjxEuXSvMFVfi/JW/ER+oLfuk80FeX7V4ceDfKYl2aq19hm4V8sMb+i9YxKlFdX8HYSk428ZnNL/NQolwJkP9zu4vz1fCGX3INQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/12/2025 16:52, Yeoreum Yun wrote:
> Hi Ryan,
> 
>> On 12/12/2025 16:18, Yeoreum Yun wrote:
>>> Some architectures invoke pagetable_alloc() or __get_free_pages()
>>> with preemption disabled.
>>> For example, in arm64, linear_map_split_to_ptes() calls pagetable_alloc()
>>> while spliting block entry to ptes and __kpti_install_ng_mappings()
>>> calls __get_free_pages() to create kpti pagetable.
>>>
>>> Under PREEMPT_RT, calling pagetable_alloc() with
>>> preemption disabled is not allowed, because it may acquire
>>> a spin lock that becomes sleepable on RT, potentially
>>> causing a sleep during page allocation.
>>>
>>> Since above two functions is called as callback of stop_machine()
>>> where its callback is called in preemption disabled,
>>> They could make a potential problem. (sleeping in preemption disabled).
>>>
>>> To address this, introduce pagetable_alloc_nolock() API.
>>
>> I don't really understand what the problem is that you're trying to fix. As I
>> see it, there are 2 call sites in arm64 arch code that are calling into the page
>> allocator from stop_machine() - one via via pagetable_alloc() and another via
>> __get_free_pages(). But both of those calls are passing in GFP_ATOMIC. It was my
>> understanding that the page allocator would ensure it never sleeps when
>> GFP_ATOMIC is passed in, (even for PREEMPT_RT)?
> 
> Although GFP_ATOMIC is specify, it only affects of "water mark" of the
> page with __GFP_HIGH. and to get a page, it must grab the lock --
> zone->lock or pcp_lock in the rmqueue().
> 
> This zone->lock and pcp_lock is spin_lock and it's a sleepable in
> PREEMPT_RT that's why the memory allocation/free using general API
> except nolock() version couldn't be called since
> if "contention" happens they'll sleep while waiting to get the lock.
> 
> The reason why "nolock()" can use, it always uses "trylock" with
> ALLOC_TRYLOCK flags. otherwise GFP_ATOMIC also can be sleepable in
> PREEMPT_RT.
> 
>>
>> What is the actual symptom you are seeing?
> 
> Since the place where called while smp_cpus_done() and there seems no
> contention, there seems no problem. However as I mention in another
> thread
> (https://lore.kernel.org/all/aT%2FdrjN1BkvyAGoi@e129823.arm.com/),
> This gives a the false impression --
> GFP_ATOMIC are “safe to use in preemption disabled”
> even though they are not in PREEMPT_RT case, I've changed it.
> 
>>
>> If the page allocator is somehow ignoring the GFP_ATOMIC request for PREEMPT_RT,
>> then isn't that a bug in the page allocator? I'm not sure why you would change
>> the callsites? Can't you just change the page allocator based on GFP_ATOMIC?
> 
> It doesn't ignore the GFP_ATOMIC feature:
>   - __GFP_HIGH: use water mark till min reserved
>   - __GFP_KSWAPD_RECLAIM: wake up kswapd if reclaim required.
> 
> But, it's a restriction -- "page allocation / free" API cannot be called
> in preempt-disabled context at PREEMPT_RT.
> 
> That's why I think it's wrong usage not a page allocator bug.

I've taken a look at this and I agree with your analysis. Thanks for explaining.

Looking at other stop_machine() callbacks, there are some that call printk() and
I would assume that spinlocks could be taken there which may present the same
kind of issue or PREEMPT_RT? (I'm guessing). I don't see any others that attempt
to allocate memory though.

Anyway, to fix the 2 arm64 callsites, I see 2 possible approaches:

- Call the nolock variant (as you are doing). But that would just convert a
deadlock to a panic; if the lock is held when stop_machine() runs, without your
change, we now have a deadlock due to waiting on the lock inside stop_machine().
With your change, we notice the lock is already taken and panic. I guess it is
marginally better, but not by much. Certainly I would just _always_ call the
nolock variant regardless of PREEMPT_RT if we take this route; For !PREEMPT_RT,
the lock is guarranteed to be free so nolock will always succeed.

- Preallocate the memory before entering stop_machine(). I think this would be
much more robust. For kpti_install_ng_mappings() I think you could hoist the
allocation/free out of stop_machine() and pass the pointer in pretty easily. For
linear_map_split_to_ptes() its a bit more complex; Perhaps, we need to walk the
pgtable to figure out how much to preallocate, allocate it, then set it up as a
special allocator, wrapped by an allocation function and modify the callchain to
take a callback function instead of gfp flags.

What do you think?

Thanks,
Ryan

> 
> [...]
> 
> --
> Sincerely,
> Yeoreum Yun


