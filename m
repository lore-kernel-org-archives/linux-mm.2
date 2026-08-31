Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 723DAC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 06:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2FE6B008C; Mon, 31 Aug 2026 02:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074556B0092; Mon, 31 Aug 2026 02:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7CDD6B0095; Mon, 31 Aug 2026 02:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2CEB6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:55:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E60CA0297
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:55:15 +0000 (UTC)
X-FDA: 85160652990.09.1E71E4F
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6BB6618000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:55:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=KL+4rUB4;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=a29XZ2n3;
	spf=pass (imf06.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788159313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nynhrnqtEuo6q3mWnANIEB+FXk5hwnBGAQkgvtuMEts=;
	b=sfZGx9Vn3J1Itx0M0D0bvFeA4JgaV7irRPTed0I44Pe+O6Kc9fQB+/8NH1WgqnC86MV75j
	8EG49r49KwAK1FaK98DKUg7r4C4VXLjk8Bhn4ZpByJkNnAKqVzTR0PsNGrrfMv1viyGAVC
	rWLEqNH65yAMtW74ek7AnkNKfXGEmdQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788159313;
	b=S+P8LsJLUUwfbGP8CIxU12/LPxHq4JgBlNjcdC6LaAvaVdL+O86Fz1G343LSuulupLCJxL
	p1NZfxDeOyO5j/jaE1BDdGp368jCnZH/pCONQWudAM8IbLS1DTEs7s/bsKi9qnmXM94HQf
	bZivOcWBviMhHKNJZoIIWBbTfG9fb+k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=KL+4rUB4;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=a29XZ2n3;
	spf=pass (imf06.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Mon, 31 Aug 2026 08:55:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788159311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nynhrnqtEuo6q3mWnANIEB+FXk5hwnBGAQkgvtuMEts=;
	b=KL+4rUB4zJvHeW/e+ma42rA7ScTJJgxkDvYpwfduRCtSORsiO48NJJ1bSAgiMqM46F+QhT
	8hD2jIVe603/RMJ1W0VbalsutLGDr/w3TP0Ko77d7E9dfNl8b3OSl9O6AyYfKT2VgsISYM
	4t72GYfkudKq2kn/0Sj0LwgCgpUrKa3hxfaltxxoGNmAHVlIn5D9BIDftKg9MJEuh4oJGj
	6jeuOV4ZoQlwbub8qNPBN2X2s4Yj6rqm/XRJmbk36bbLZ7LcNaxBLebRXkLWr0YIV/Le8K
	uob/C+5/W0jWISxQUXPsoGf4G8tV6Yu1GRkMurlAdsNPkuDAj6cMUeqvRq6XyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788159311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nynhrnqtEuo6q3mWnANIEB+FXk5hwnBGAQkgvtuMEts=;
	b=a29XZ2n32W6NbMPFEh5HdOb3M7PYRJuNPQawecuczPwFeSw3z+MDtTiY//DSwIJ7cqkpo7
	U0+RAJ9BUQKImTAg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	David Stevens <stevensd@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260831065509.qqEtERDB@linutronix.de>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <20260828151018.HnR9xV1N@linutronix.de>
 <20260828150836.2d5b378c@gandalf.local.home>
 <20260828151313.5c4a5e4b@gandalf.local.home>
 <20260828151747.20035d50@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260828151747.20035d50@gandalf.local.home>
X-Stat-Signature: pwxk4e45jiq3t8ue6m4ufaq7cpwhc6t4
X-Rspamd-Queue-Id: 6BB6618000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788159313-998130
X-HE-Meta: U2FsdGVkX1/ozTekKfIO3bmKe40ayeY4GBdb7Bbn49DZWkcIgnpqm+iSOXQrKEc5QXNUdMeaAhBDhYY7q9NWv3D5oyjMc8tYBbIge5T+DCUuTRC5P4eiDFLLLemZewmakPoTmz6SN/sAiKaTFEOvjVKPB540kUQXNSmXaNBnwPDZvq5t6Xe8mmaSLNeBcmB6mxjIBzq3yb68c+9Vjcu9jl1uU07UnzFFlQjjIxPZdGtWVj9NfCIXNmDYKw9+hYB+uNhJZEbQxfnDNwLoZ/0ZQNXc2XhAiB4VtmUoVHfzNXjejwn9DgfN77TLBP9gPN3UFKOfWN1nc6S46a106H4ppSr0KBxuvSc6gZWwL4dZbyajLJvZ5W/fTZd9kwsPp2KFd5M3U8DuRAiZv/yHH8WIPrYJKTIvjRDPx0mZJF3MAUcg6dE3oRO6BMpOmTvP0iJHwd5YSQZDUqQSIMzbuvOHv1PuRH4a42JHr32PBUAWca5D0jqx55XjEfvBloqikGd83SBOCquhHhW2Q8smD341/pplblRgBV5sASn9e8VZQOeJXol4R32W//hY/G7OQ1ER04cZR/ihnMmIAxgWMMBWQYbJv+VSHTt9oG95GDnkJDm3oM4qHk8qcZ14s5+KVVww0/c7JsIRYeNOWdSllNY0UFz1NwXXNNlXHgVw9qjb+fw5TBTjoW39fEAwt5QKnsj2W2jNVwBDHI9i3Dvs5jeluty+5zYVBfHG7GGrc460JgEu9JKrh7aRDSdgEpwu2qu/EyfIQ5BNUWu7N4/LXmYIo32XmhMfI6s5EAYAE7s2WCne9+/we0kSAD5QAEaYNurer4fURv+qfTqlTobPAc8PDXA/7EA3RjYJXcJsxIzOooJ5dSC0NaFkvBxcnmfIk1orKhinIMxvMb8jGCLol/NEEjAkfhL6uZxqiYwvXh8WmA7R3b7j0TB1rcQArq8x+O7lMEE8twMSr2eFka2rPby
 TNBCdpty
 pRTgx/K0BnHxWeCABb4j1HVICpsNGjMg/5WQKZ6bC8VCyxT3jUrhsYI320BljbwBFZBsljoebaMmQlfuvfHJLkjGyevR3MotP6BWsFSrjh4uCX0MYNNX0Vs+U93jZhz8kdRYmGipjjkP0fgU0LhdIY7JWl47LEhLPYrzg89H8Gw65r8MKEgeowY7ejQ1DuDdCVAbwuqXQh+hLgfTyHpD5zTKRqTwX/ninFjHIbbUpaXjDjStN0rNcEjE4qL8Mf0jGkWuH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-28 15:17:47 [-0400], Steven Rostedt wrote:
> On Fri, 28 Aug 2026 15:13:13 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > If one worries about stack size, they may want to turn off
> > CONFIG_RANDOMIZE_KSTACK_OFFSET as I see some big numbers for do_syscall_64()
> 
> And the scheduler has some heavy stack usage here!
> 
>   # trace-cmd stack
> (stack tracer running)
>         Depth    Size   Location    (31 entries)
>         -----    ----   --------
>   0)     8120      48   __msecs_to_jiffies+0x9/0x30

I didn't expect get_user_pages_unlocked() getting that big:

(stack tracer running)
        Depth    Size   Location    (60 entries)
        -----    ----   --------
  0)     8176      48   __css_rstat_updated+0x9/0x150
  1)     8128       8   __cgroup_account_cputime+0x2f/0x50
  2)     8120      48   update_se+0x10c/0x1b0
  3)     8072      48   update_curr+0x31/0x180
  4)     8024      56   put_prev_entity+0x153/0x1f0
  5)     7968     136   pick_next_task_fair+0x684/0x8e0
  6)     7832     120   __schedule+0x1ca/0x1130
  7)     7712       8   preempt_schedule_irq+0x38/0x60
  8)     7704      72   irqentry_exit+0x148/0x6b0
  9)     7632     136   asm_sysvec_apic_timer_interrupt+0x1a/0x20
 10)     7496     240   HUF_compress1X_usingCTable_internal_bmi2+0x12d2/0x1c40
 11)     7256      80   HUF_compress4X_usingCTable_internal+0x192/0x1d0
 12)     7176      32   HUF_compressCTable_internal+0x61/0x90
 13)     7144     136   HUF_compress_internal+0x2d2/0x500
 14)     7008      56   HUF_compress4X_repeat+0x25/0x60
 15)     6952     176   ZSTD_compressLiterals+0x1ad/0x400
 16)     6776     224   ZSTD_entropyCompressSeqStore_internal+0xfb/0x320
 17)     6552     112   ZSTD_compressBlock_internal+0x11b/0x210
 18)     6440     296   ZSTD_compressContinue_internal+0x232/0xdd0
 19)     6144      56   ZSTD_compressEnd_public+0x27/0x190
 20)     6088     112   ZSTD_compressStream2+0x9fc/0xa60
 21)     5976      80   ZSTD_compress2+0x83/0xd0
 22)     5896      24   zstd_compress+0x3d/0x70 [zram]
 23)     5872      72   zcomp_compress+0x62/0x90 [zram]
 24)     5800     144   zram_submit_bio+0x558/0xb00 [zram]
 25)     5656     128   __submit_bio+0x164/0x240
 26)     5528      96   submit_bio_noacct_nocheck+0x134/0x390
 27)     5432      64   bio_await+0xa7/0xb0
 28)     5368      16   submit_bio_wait+0x16/0x20
 29)     5352     184   swap_writepage_bdev_sync.isra.0+0x12e/0x230
 30)     5168      40   swap_writeout+0x18d/0x2e0
 31)     5128     176   shmem_writeout+0x286/0x530
 32)     4952     440   shrink_folio_list+0x588/0xfc0
 33)     4512     296   evict_folios+0x399/0xac0
 34)     4216     160   try_to_shrink_lruvec+0x1a4/0x390
 35)     4056      64   shrink_one+0xc0/0x1a0
 36)     3992     240   shrink_node+0xa9a/0xcf0
 37)     3752      88   do_try_to_free_pages+0xb3/0x4d0
 38)     3664     176   try_to_free_pages+0xce/0x220
 39)     3488     264   __alloc_pages_slowpath.constprop.0+0x8cc/0x1240
 40)     3224      96   __alloc_frozen_pages_noprof+0x2f6/0x340
 41)     3128      64   alloc_pages_mpol+0xb6/0x190
 42)     3064      56   vma_alloc_folio_noprof+0x6e/0xd0
 43)     3008      80   do_anonymous_page+0x32e/0x8f0
 44)     2928     224   __handle_mm_fault+0xb31/0xf60
 45)     2704      64   handle_mm_fault+0xee/0x2f0
 46)     2640     152   __get_user_pages+0x1b5/0x1140
 47)     2488     104   get_user_pages_unlocked+0xf0/0x330
 48)     2384     128   hva_to_pfn+0x2ea/0x450 [kvm]
 49)     2256      64   __kvm_faultin_pfn+0x61/0x90 [kvm]
 50)     2192     120   kvm_mmu_faultin_pfn+0x2cf/0x6f0 [kvm]
 51)     2072      24   kvm_tdp_page_fault+0x94/0xf0 [kvm]
 52)     2048     120   kvm_mmu_do_page_fault+0x1d9/0x210 [kvm]
 53)     1928     200   kvm_mmu_page_fault+0x7e/0x7b0 [kvm]
 54)     1728      40   npf_interception+0xba/0x240 [kvm_amd]
 55)     1688     168   kvm_arch_vcpu_ioctl_run+0x931/0x1900 [kvm]
 56)     1520     200   kvm_vcpu_ioctl+0x2e4/0xa10 [kvm]
 57)     1320      56   __x64_sys_ioctl+0x97/0xe0
 58)     1264    1072   do_syscall_64+0xe1/0x640
 59)      192     192   entry_SYSCALL_64_after_hwframe+0x76/0x7e

Does this stack tracer distinguish between the kernel-stack and
IRQ-stack? I would expect asm_sysvec_apic_timer_interrupt() on the
IRQ-stack and not adding weight to the kernel stack.
Given how close this is to 8192, I don't think two stack pages will
happen soon.

Sebastian

