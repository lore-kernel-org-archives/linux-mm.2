Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525CDD65C5F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 15:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58E66B008A; Wed, 17 Dec 2025 10:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06796B008C; Wed, 17 Dec 2025 10:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986816B0092; Wed, 17 Dec 2025 10:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 820F56B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:10:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FF3113C048
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:10:59 +0000 (UTC)
X-FDA: 84229300638.10.3344F8F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 69795C0017
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:10:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W+2ObCHU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F28UgOjb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i+vuTk41;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=giRQf6IC;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765984257; a=rsa-sha256;
	cv=none;
	b=0kxxRhXCe34rILV72VnzTPf+BcwZDM36HcpDIe2Oeee3/Tf8z3dgZ4ekhbBXFuoY8k4yFm
	1NFkpAC9TXhdrVTCqlgdgwJp53LnLlhWw0fC9wMGZGmItOJrqeqXFjR/iNLGnBa7HjzVi5
	Viw+a26Sthwha9zVhnCw0dXtqziJA4g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W+2ObCHU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F28UgOjb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i+vuTk41;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=giRQf6IC;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765984257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZEiS3dW0yLBlNkCFnZqkFE2PhalZ4TjeG5Dke4M5o8=;
	b=qPjuZPf+anCqmMxMm2u/JrRBnpdh852GK/lXFHbVtv28NfYEbYHMnln2UMkHca72RYkthm
	etxbF5sIf79X2WAaRJ9AkaHcvyhDWtL258uEHQAGRtygBDBAzZZ+VuCfotfzaOnUd3YEfs
	p2BCB2onhEqRF5DPBPW8zwHjVvkOIPY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CF46133686;
	Wed, 17 Dec 2025 15:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765984255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UZEiS3dW0yLBlNkCFnZqkFE2PhalZ4TjeG5Dke4M5o8=;
	b=W+2ObCHUzE/Sc92pYIjWVxezrnSwWjbIGtVMw2Kv16EogFPOF2ncg9c+vujNh1KZC2c9xG
	z8SEcHy1vpxNjNYNhG37Vkzx4c/AC5REAuh6JfUWB969vZBr447yYoWV137hPyjbGqekur
	newyIEuIMqOqFHeGXdw6kXbwzIfDkiI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765984255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UZEiS3dW0yLBlNkCFnZqkFE2PhalZ4TjeG5Dke4M5o8=;
	b=F28UgOjbkAccjrllVZw/PtOu4EAKt3OLVaAm88nDzl6sZz3f+G07ONBbT0r1oAN6qIQPoq
	R6zLCRzBYqycqIBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765984254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UZEiS3dW0yLBlNkCFnZqkFE2PhalZ4TjeG5Dke4M5o8=;
	b=i+vuTk41c+0Wd3c2olnAWjDQFhMkDRdbW6A14N9OJJ8prDcuK1Wyp9OWYGudJLFyGsHy+R
	nI8mttueByUKWMgRZbINwDfYx8Wo3AegmWWRN1yOTeNzC8482ojevgJLZLadNS/s2eI+Y/
	ONkHHq4Us6EvjdXl2Ys1lkFgpQvpa+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765984254;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UZEiS3dW0yLBlNkCFnZqkFE2PhalZ4TjeG5Dke4M5o8=;
	b=giRQf6ICEmrQjhCwjb4CRrPytpVhd+dzKJtBQ8V0noi/d5JCKrpH/TbPjrJJaIeoIN29yO
	hCfspDB66oQuCTBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82DCE3EA63;
	Wed, 17 Dec 2025 15:10:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OmigH/7HQmm5MwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Dec 2025 15:10:54 +0000
Message-ID: <d5354d96-6f28-41d7-9f66-64c254d9477b@suse.cz>
Date: Wed, 17 Dec 2025 16:10:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] introduce pagetable_alloc_nolock()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
 ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
 rostedt@goodmis.org, catalin.marinas@arm.com, will@kernel.org,
 kevin.brodsky@arm.com, dev.jain@arm.com, yang@os.amperecomputing.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, linux-arm-kernel@lists.infradead.org
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
 <916c17ba-22b1-456e-a184-cb3f60249af7@arm.com>
 <aUGOPd7gNRf1xHEc@e129823.arm.com>
 <100cc8da-b826-4fc2-a624-746bf6fb049d@arm.com>
 <aUKKZR0u22KOPfd7@e129823.arm.com>
 <d96ac977-222e-4e8d-9487-da1306198419@arm.com>
 <aUKnfU/3FREY13g1@e129823.arm.com>
 <d912480a-5229-4efe-9336-b31acded30f5@suse.cz>
 <DF0J58HOVLL4.2E16Q87D2UXRW@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <DF0J58HOVLL4.2E16Q87D2UXRW@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 69795C0017
X-Stat-Signature: oxqxz8yiq7h5dmmz9a9dy1xu3prywbtr
X-Rspam-User: 
X-HE-Tag: 1765984256-748772
X-HE-Meta: U2FsdGVkX1+8fG49s8/Cr8/7T4j5HbohU3OTcnB6bTtBUzXiSeZeCHkdheFyWo6I4eSoIh3XPCsCmf+XSZXlsPPdP3oOF+wog8pjb8Ou5hTTzUZnRYRYDf/NP68e8JL92S7OekjPeW4nRpAdk7g+huWAqOwhTbSE7+Ard2auaCLsxHEoTNJgMTpYLpya+YXnoTtsFKBiTUZW9yn8mpswwSmAJ0A0fFldz4ZaCVneVlRjm+Q7trbLnJO/dOkZtn3ecVkpm9v25Q8+DjTdcWx12/+fjXpJUtxcKwTFNHcn9jPdxwKbaJMXjXfD3TwHjvEkLpbTjAdwZl+KkQ97YrZKRuyXJsqz9iAHHVljLZvpAxVdm8V3F5IZDZ5opBRNWn9DPVCvpQ4R6p7wkKHaWJfxLuAVA7qX3WDcPBQZMJmu97urBJvzySZDh3E0qudZgOkEj75OiRYS/a8IOYO/c0QpGJPIBuKdF8R31vZA/dlh/JOW0AYCyGvNxqPjP1TWHTekUm2m4CELfWD4cgSc/vtauUdD80fe3hXZ9p5L5JePBpNVSwpu3x9qN9JkwueViQiZFSqe8ZubRN0etjG08JU8o56k4QkqOxIHMrlJ8yjQ9q704iQZMjLLx3opxQ0UgdZm9QvydINpZYW0cZpKtN9oWKqjnmoZM5e4VAajRN1bnP1LhjW+CjUoJB4xuDJikc18vCu87na+ymRhgcb0R95EXltMkPNEODmSn09ibezXGBXGBMebuJV6BuSaDeMryo7AHFPPC4UYnWYbJ6rNkUc5Vaw1lgq6a0MUROeJ7YmxnIGwoFJWTuX0cq0jvpilAcATlXnPdXDOWKimev/zxFmxoUEjaFaJDesnPg2FcNydKi3cWPpio3g/aqsRlE8GPwAdauPy2jE9DBx/BvI+Ud/XYN2saYQCx4IUFNmoZWOleHyaVB3F56d8Jxe1mD2R4diKUCoCtlUHwUuzp57nM7P
 wB4I2Jn1
 SxkimLVPjih0v5hq8Sl4YHia+mHwQa+AQTpcUQlNX2B2ayGAOOvm0PIOVrQcUndSxWmwqLAGihCx0ER41OwOH/wJDMl/9v8y3ezR+g1fum7JOt64OP6vrMjdGsPJS0jLHMAfAiiFPk6V1IRIubv4r9GrqAbtC8bfoJXy311H67tMeZIS8CzxQHUPk4An3yUNdc5gLBCEZzn3bURLaMPOEKc/QAIRiUPIP0w4Hk17gqujqAXCW6NUTkPlV/Gx4ZSbI6/ii5ZhZFuMiEDuOHEZN1d8Xa5REGqMo+Qsj9qOYpaduhzsg3fZCpIBRvLo2Nq4ZfqHk0Au1QEtWDZlQM0AFObT3Him4/qY4wP32YF4/tSPTSbNmlIQ0Qs7zBsOO8TYouTcVvttfBOsqC3cC38qeRYjbasv2SVKeJHIwBGweuyIgad5LU8NdhtbJwxIH5MLgV0IMIM5z+6gbqkOEp+3jkk4MIUSScKZp84FUyHGi/NIxaknvb6py9sy+jtmoRYyOA9Uycd9/cGn9WwJhdGs1ET2qSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 14:35, Brendan Jackman wrote:
> On Wed Dec 17, 2025 at 1:15 PM UTC, Vlastimil Babka wrote:
>> On 12/17/25 13:52, Yeoreum Yun wrote:
>>>> On 17/12/2025 10:48, Yeoreum Yun wrote:
>>>> > Hi Ryan,
>>>> >
>>>> >> On 16/12/2025 16:52, Yeoreum Yun wrote:
>>>> >>> Hi Ryan,
>>>> >>>
>>>> >>>> On 12/12/2025 16:18, Yeoreum Yun wrote:
>>>> >>>>> Some architectures invoke pagetable_alloc() or __get_free_pages()
>>>> >>>>> with preemption disabled.
>>>> >>>>> For example, in arm64, linear_map_split_to_ptes() calls pagetable_alloc()
>>>> >>>>> while spliting block entry to ptes and __kpti_install_ng_mappings()
>>>> >>>>> calls __get_free_pages() to create kpti pagetable.
>>>> >>>>>
>>>> >>>>> Under PREEMPT_RT, calling pagetable_alloc() with
>>>> >>>>> preemption disabled is not allowed, because it may acquire
>>>> >>>>> a spin lock that becomes sleepable on RT, potentially
>>>> >>>>> causing a sleep during page allocation.
>>>> >>>>>
>>>> >>>>> Since above two functions is called as callback of stop_machine()
>>>> >>>>> where its callback is called in preemption disabled,
>>>> >>>>> They could make a potential problem. (sleeping in preemption disabled).
>>>> >>>>>
>>>> >>>>> To address this, introduce pagetable_alloc_nolock() API.
>>>> >>>>
>>>> >>>> I don't really understand what the problem is that you're trying to fix. As I
>>>> >>>> see it, there are 2 call sites in arm64 arch code that are calling into the page
>>>> >>>> allocator from stop_machine() - one via via pagetable_alloc() and another via
>>>> >>>> __get_free_pages(). But both of those calls are passing in GFP_ATOMIC. It was my
>>>> >>>> understanding that the page allocator would ensure it never sleeps when
>>>> >>>> GFP_ATOMIC is passed in, (even for PREEMPT_RT)?
>>>> >>>
>>>> >>> Although GFP_ATOMIC is specify, it only affects of "water mark" of the
>>>> >>> page with __GFP_HIGH. and to get a page, it must grab the lock --
>>>> >>> zone->lock or pcp_lock in the rmqueue().
>>>> >>>
>>>> >>> This zone->lock and pcp_lock is spin_lock and it's a sleepable in
>>>> >>> PREEMPT_RT that's why the memory allocation/free using general API
>>>> >>> except nolock() version couldn't be called since
>>>> >>> if "contention" happens they'll sleep while waiting to get the lock.
>>>> >>>
>>>> >>> The reason why "nolock()" can use, it always uses "trylock" with
>>>> >>> ALLOC_TRYLOCK flags. otherwise GFP_ATOMIC also can be sleepable in
>>>> >>> PREEMPT_RT.
>>>> >>>
>>>> >>>>
>>>> >>>> What is the actual symptom you are seeing?
>>>> >>>
>>>> >>> Since the place where called while smp_cpus_done() and there seems no
>>>> >>> contention, there seems no problem. However as I mention in another
>>>> >>> thread
>>>> >>> (https://lore.kernel.org/all/aT%2FdrjN1BkvyAGoi@e129823.arm.com/),
>>>> >>> This gives a the false impression --
>>>> >>> GFP_ATOMIC are “safe to use in preemption disabled”
>>>> >>> even though they are not in PREEMPT_RT case, I've changed it.
>>>> >>>
>>>> >>>>
>>>> >>>> If the page allocator is somehow ignoring the GFP_ATOMIC request for PREEMPT_RT,
>>>> >>>> then isn't that a bug in the page allocator? I'm not sure why you would change
>>>> >>>> the callsites? Can't you just change the page allocator based on GFP_ATOMIC?
>>>> >>>
>>>> >>> It doesn't ignore the GFP_ATOMIC feature:
>>>> >>>   - __GFP_HIGH: use water mark till min reserved
>>>> >>>   - __GFP_KSWAPD_RECLAIM: wake up kswapd if reclaim required.
>>>> >>>
>>>> >>> But, it's a restriction -- "page allocation / free" API cannot be called
>>>> >>> in preempt-disabled context at PREEMPT_RT.
>>>> >>>
>>>> >>> That's why I think it's wrong usage not a page allocator bug.
>>>> >>
>>>> >> I've taken a look at this and I agree with your analysis. Thanks for explaining.
>>>> >>
>>>> >> Looking at other stop_machine() callbacks, there are some that call printk() and
>>>> >> I would assume that spinlocks could be taken there which may present the same
>>>> >> kind of issue or PREEMPT_RT? (I'm guessing). I don't see any others that attempt
>>>> >> to allocate memory though.
>>>> >
>>>> > IIRC, there was a problem related for printk while try to grab
>>>> > pl011_console related lock (spin_lock) while holding
>>>> > console_lock(raw_spin_lock) in v6.10.0-rc7 at rpi5:
>>>> >
>>>> >     [  230.381263] CPU: 2 PID: 5574 Comm: syz.4.1695 Not tainted 6.10.0-rc7-01903-g52828ea60dfd #3
>>>> >     [  230.381479] Hardware name: linux,dummy-virt (DT)
>>>> >     [  230.381565] Call trace:
>>>> >     [  230.381607]  dump_backtrace+0x318/0x348
>>>> >     [  230.381727]  show_stack+0x4c/0x80
>>>> >     [  230.381875]  dump_stack_lvl+0x214/0x328
>>>> >     [  230.382159]  dump_stack+0x3c/0x58
>>>> >     [  230.382456]  __lock_acquire+0x4398/0x4720
>>>> >     [  230.382683]  lock_acquire+0x648/0xb70
>>>> >     [  230.382928]  _raw_spin_lock_irqsave+0x138/0x240
>>>> >     [  230.383121]  pl011_console_write+0x240/0x8a0
>>>> >     [  230.383356]  console_flush_all+0x708/0x1368
>>>> >     [  230.383571]  console_unlock+0x180/0x440
>>>> >     [  230.383742]  vprintk_emit+0x1f8/0x9d0
>>>> >     [  230.383832]  vprintk_default+0x64/0x90
>>>> >     [  230.383914]  vprintk+0x2d0/0x400
>>>> >     [  230.383971]  _printk+0xdc/0x128
>>>> >     [  230.384229]  hrtimer_interrupt+0x8f0/0x920
>>>> >     [  230.384414]  arch_timer_handler_virt+0xc0/0x100
>>>> >     [  230.384812]  handle_percpu_devid_irq+0x20c/0x4e0
>>>> >     [  230.385053]  generic_handle_domain_irq+0xc0/0x120
>>>> >     [  230.385367]  gic_handle_irq+0x88/0x360
>>>> >     [  230.385559]  call_on_irq_stack+0x24/0x70
>>>> >     [  230.385801]  do_interrupt_handler+0xf8/0x200
>>>> >     [  230.386092]  el1_interrupt+0x68/0xc0
>>>> >     [  230.386434]  el1h_64_irq_handler+0x18/0x28
>>>> >     [  230.386716]  el1h_64_irq+0x64/0x68
>>>> >     [  230.386853]  __sanitizer_cov_trace_const_cmp2+0x30/0x68
>>>> >     [  230.387026]  alloc_pages_mpol_noprof+0x170/0x698
>>>> >     [  230.387309]  vma_alloc_folio_noprof+0x128/0x2a8
>>>> >     [  230.387610]  vma_alloc_zeroed_movable_folio+0xa0/0xe0
>>>> >     [  230.387822]  folio_prealloc+0x5c/0x280
>>>> >     [  230.388008]  do_wp_page+0xc30/0x3bc0
>>>> >     [  230.388206]  __handle_mm_fault+0xdb8/0x2ba0
>>>> >     [  230.388448]  handle_mm_fault+0x194/0x8a8
>>>> >     [  230.388676]  do_page_fault+0x6bc/0x1030
>>>> >     [  230.388924]  do_mem_abort+0x8c/0x240
>>>> >     [  230.389056]  el0_da+0xf0/0x3f8
>>>> >     [  230.389178]  el0t_64_sync_handler+0xb4/0x130
>>>> >     [  230.389452]  el0t_64_sync+0x190/0x198
>>>> >
>>>> > But this problem is gone when I try with some of patches in rt-tree
>>>> > related for printk which are merged in current tree
>>>> > (https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/log/?h=linux-6.10.y-rt-rebase).
>>>> >
>>>> > So I think printk() wouldn't be a problem.
>>>> >
>>>> >>
>>>> >> Anyway, to fix the 2 arm64 callsites, I see 2 possible approaches:
>>>> >>
>>>> >> - Call the nolock variant (as you are doing). But that would just convert a
>>>> >> deadlock to a panic; if the lock is held when stop_machine() runs, without your
>>>> >> change, we now have a deadlock due to waiting on the lock inside stop_machine().
>>>> >> With your change, we notice the lock is already taken and panic. I guess it is
>>>> >> marginally better, but not by much. Certainly I would just _always_ call the
>>>> >> nolock variant regardless of PREEMPT_RT if we take this route; For !PREEMPT_RT,
>>>> >> the lock is guarranteed to be free so nolock will always succeed.
>>>> >>
>>>> >> - Preallocate the memory before entering stop_machine(). I think this would be
>>>> >> much more robust. For kpti_install_ng_mappings() I think you could hoist the
>>>> >> allocation/free out of stop_machine() and pass the pointer in pretty easily. For
>>>> >> linear_map_split_to_ptes() its a bit more complex; Perhaps, we need to walk the
>>>> >> pgtable to figure out how much to preallocate, allocate it, then set it up as a
>>>> >> special allocator, wrapped by an allocation function and modify the callchain to
>>>> >> take a callback function instead of gfp flags.
>>>> >>
>>>> >> What do you think?
>>>> >
>>>> > Definitely, second suggestoin is much better.
>>>> > My question is whether *memory contention* really happen in the point
>>>> > both functions are called.
>>>>
>>>> My guess would be that it's unlikely, but not impossible. The secondary CPUs are
>>>> up, and presumably running their idle thread. I think various power management
>>>> things can be plugged into the idle thread; if so, then I guess it's possible
>>>> that the CPU could be running some hook as part of a power state transition, and
>>>> that could be dynamically allocating memory? That's all just a guess though; I
>>>> don't know the details of that part of the system.
>>>>
>>>> >
>>>> > Above two functions are called as last step of "smp_init()" -- smp_cpus_done().
>>>> > If we can be sure, I think we don't need to go to complex way and
>>>> > I believe the reason why we couldn't find out this problem,
>>>> > even using GFP_ATOMIC in PREEMPT_RT since there was *no contection*
>>>> > in this time of both functions are called.
>>>> > > That's why I first try with the "simple way".
>>>> >
>>>> > What do you think?
>>>>
>>>> As far as linear_map_split_to_ptes() is concerned, it was implemented under the
>>>> impression that doing allocation with GFP_ATOMIC was safe, even in
>>>> stop_machine(). Given that's an incorrect assumption, I think we should fix it
>>>> to pre-allocate outside of stop_machine() regardless of the likelihood of
>>>> actually hitting the race.
>>>>
>>> 
>>> Yeap. It’s better to be certain than uncertain. Thanks for checking.
>>> I'll repsin with the preallocate way.
>>
>> Note this is explained in Documentation/core-api/real-time/differences.rst:
>>
>> Memory allocation
>> -----------------
>>
>> The memory allocation APIs, such as kmalloc() and alloc_pages(), require a
>> gfp_t flag to indicate the allocation context. On non-PREEMPT_RT kernels, it is
>> necessary to use GFP_ATOMIC when allocating memory from interrupt context or
>> from sections where preemption is disabled. This is because the allocator must
>> not sleep in these contexts waiting for memory to become available.
>>
>> However, this approach does not work on PREEMPT_RT kernels. The memory
>> allocator in PREEMPT_RT uses sleeping locks internally, which cannot be
>> acquired when preemption is disabled. Fortunately, this is generally not a
>> problem, because PREEMPT_RT moves most contexts that would traditionally run
>> with preemption or interrupts disabled into threaded context, where sleeping is
>> allowed.
>>
>> What remains problematic is code that explicitly disables preemption or
>> interrupts. In such cases, memory allocation must be performed outside the
>> critical section.
>>
>> This restriction also applies to memory deallocation routines such as kfree()
>> and free_pages(), which may also involve internal locking and must not be
>> called from non-preemptible contexts.
> 
> Oh, thanks for pointing to that, I had never read that before (oops).
> 
> Shall we point to this from the doc-comment? Something like the below.
> 
> BTW, Yeorum, assuming you care about PREEMPT_RT, maybe you can get
> Sparse to find some other bugs of this nature? Or if not, plain old
> Coccinelle would probably find a few.
> 
> ---
> 
> From 4c6b4d4cb08aee9559d02a348b9ecf799142c96f Mon Sep 17 00:00:00 2001
> From: Brendan Jackman <jackmanb@google.com>
> Date: Wed, 17 Dec 2025 13:26:28 +0000
> Subject: [PATCH] mm: clarify GFP_ATOMIC/GFP_NOWAIT doc-comment
> 
> The current description of contexts where it's invalid to make
> GFP_ATOMIC and GFP_NOWAIT calls is rather vague.
> 
> Replace this with a direct description of the actual contexts of concern
> and refer to the RT docs where this is explained more discursively.
> 
> While rejigging this prose, also move the documentation of GFP_NOWAIT to
> the GFP_NOWAIT section.

There doesn't seem to be any move?

> 
> Link: https://lore.kernel.org/all/d912480a-5229-4efe-9336-b31acded30f5@suse.cz/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Nit below:

> ---
>  include/linux/gfp_types.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 3de43b12209ee..07a378542caf2 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -309,8 +309,10 @@ enum {
>   *
>   * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
>   * watermark is applied to allow access to "atomic reserves".
> - * The current implementation doesn't support NMI and few other strict
> - * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
> + * The current implementation doesn't support NMI, nor contexts that disable
> + * preemption under PREEMPT_RT. This includes raw_spin_lock() and plain
> + * preempt_disable() - see Documentation/core-api/real-time/differences.rst for
> + * more info.

Can we reference the "Memory allocation" section directly?

>   *
>   * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
>   * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
> @@ -321,6 +323,7 @@ enum {
>   * %GFP_NOWAIT is for kernel allocations that should not stall for direct
>   * reclaim, start physical IO or use any filesystem callback.  It is very
>   * likely to fail to allocate memory, even for very small allocations.
> + * The same restrictions on calling contexts apply as for %GFP_ATOMIC.
>   *
>   * %GFP_NOIO will use direct reclaim to discard clean pages or slab pages
>   * that do not require the starting of any physical IO.
> --
> 2.50.1


