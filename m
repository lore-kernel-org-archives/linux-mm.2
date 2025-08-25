Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7614CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 10:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16618E000E; Mon, 25 Aug 2025 06:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE078E0001; Mon, 25 Aug 2025 06:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03C08E000E; Mon, 25 Aug 2025 06:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AADBB8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 06:27:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2AF9A13909E
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:27:17 +0000 (UTC)
X-FDA: 83814902514.27.B2803DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 93631180010
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:27:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KbH6pmxm;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756117635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mowrh3frMbHEHD/HhUU5wlu9p9PDnaVvBi8ctUBS3M=;
	b=LuDv//PzfCy5OTdEsYiyr2FaDjhDAkIFLoYuP11oaVNoroRcr/b+/WujcR2GagHzr/oHAm
	6W6sNsugAJy7SyEbKsOTU204/aN9X/oQBnh/R5FE/Jg4jgWNIJJgENGeVBqCUKSx+w3MUZ
	aTZr1NS8v045Zt+gMvhVmV8A+tqY5Do=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KbH6pmxm;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756117635; a=rsa-sha256;
	cv=none;
	b=o0hGuLW8xJhWX4vvwWwPvYNUBTMTjy7Z8JuQH8AVkZAk60oLipA0kb8UnB+E67ATJzcHJ3
	nJUI9NQFVOgNh82aHWj9Y5KhyPXapIMAG4O8oNNZILYS9Oj+VQcoSa/zYD9MHUMKbfGyFP
	kTDX9fw6Zn/SBfGxnMF++qs6PUiLAio=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C2BE3601EF;
	Mon, 25 Aug 2025 10:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27661C4CEED;
	Mon, 25 Aug 2025 10:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756117634;
	bh=7eXQe0ppR67crwIxzEGbI8HTL2j+eg2UeV1vOND7m8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KbH6pmxmwtV7AmRZ596tGKRt9t7M7lAxvdMbUw+oaoyUFMMA+EyQy05hGJ3g9WwsB
	 Z1eMAAN0hLLeLUvb6KAzpYAn5REKd9ruZ9Tp7F7miFd9NnlMKIGXs/OUUbWERoUDQn
	 aM7jJisqh7oNweuIFKK0Hpty4DmFY33T+XE2EIKeWWEBvYToPKgm2TpiWFGzodZPpc
	 ks1MXF09AJ75Wy9QWZhT7FsaHaZiB2GuBTTwLlwykW8ZvOVYcxMceKfewYi5waVo5Y
	 0cqenAwDmaLHn1YX3eGSdNdZn19a8DMMgJ68FVHFHIJDWIi4e0SmxzR+EZkFV5lmUG
	 QfFpG5ucwxINw==
Date: Mon, 25 Aug 2025 13:27:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm/mm_init]  8a523d9e6f:
 BUG:sleeping_function_called_from_invalid_context_at_mm/mm_init.c
Message-ID: <aKw6fG9eryVNmeEc@kernel.org>
References: <202508251443.f2d9f77f-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508251443.f2d9f77f-lkp@intel.com>
X-Stat-Signature: jewo5f3djhtwayh579p8b6dch4pswd3k
X-Rspam-User: 
X-Rspamd-Queue-Id: 93631180010
X-Rspamd-Server: rspam01
X-HE-Tag: 1756117635-227805
X-HE-Meta: U2FsdGVkX1+YyuduFb6CKsufWimHGcHVyKDJXGzj/3bkldKDygBcQT3sJ+bkGbgOUeT0dnMy5mHKvO8D+Hc0k24rIoaf2ZMidzfOZww2MevS69mddJmYRfIXJt2ZGnreWi25TuMVL39HdpwPY/sh6uQIk26CVJSLrnBhPWoptJ3m7H033bJMDpnm5j+re3Y7mJzF9CPrYO3cJTWyzp9JmJq7z3uUNgjviLmiJQ/OpqFmQMXk1X84dOmU0vx/hpysN7Ad1ojkF+m1oeN5IY7LMU+gLdsB0dA8V0nvZGOzG92LjC/e/bAX1DjRp0Q9dzXb04V+/Q6+pCTkqo504P4Z5y9AMiAszK3+JpH97Mzsg7WkYXw+rFax5gjIDxcqd/MbKewUEPn549L7wGqeAoEnGSWOkg3iPdbrdYV8IkS92e16vYelKwvcVTD4EI1mc+O2StkMRORrvQCYwlRZy6pVkfd0XjjGpzxALV3LLoDtIYIHgKx8AnusEHOkYrycX2RMEOJkPGy8n/7uYHYesOvB4Q3JzkJv6ckh4LlgjMk+MTyOlGFNN+ap7QBEZiOq6ls0NknqagKGvki3Ht8rohpVKPy1PhPuKP0P7eUY2fAUeVzr8btp9GI85GBGI9B1u8BFJYQ06Jjn3Ttn+NcTywSQplhNNL75nS1ftMv43lMSHSqc+EdghrAu6edOYXnJKO9HDGxzd0duLSRQq7Bu5SwskYm7vzZ0BBKvaClJ+xkhj86yGkiCyRY+j0CCBcL19sf7fj7xSjgdfU6JKH5RyB94GmmDM5vgW4B5Gw4k8HGHPu9PpK4P37w/VtL8QwQ1Q+3uety+VT/hvxa3YtGmilC5sGWBsLxtxutx/bHOSggzK5p6ms0p9LEWi00yDiNVJyBk2NoMYDA6jqnBZutbuc6atejY8Kj33RLx4xsi6up/iPqd3b5c/CtkrpXx5Slf/AQdesvxQ61XUVz3iVfUYBU
 f+1jwWLS
 ZSFXmvxpNoi9k99J/4nlFuQaHtldbfR16GoiTBnKxMvJNMCJt1kQYw0BIr7gfcBMXKlUSWXcDGpwukQibdlT8alR7rmfKn+UMZcd39xqBE0Dxg941l1b+EF/6BHqy/l7fIw8hnP90313OFmD43uaMUGb38qPgls6mwpzw2rR/BZluveOeLgZQuEEOfjvRmL+EsldQJOPUY0MJ2wR06AJOJVLGg1uPdOt/USWj4Ww739/uCt3mP82SIcuvH2T4P4vLIFgbLjUeVpy+DKDdi4pag8T1K9zk1YDcLlv9NjlOQpH5DBblZWWlUdam6mAf2H+skWA1LJVkQm7g85GLPGBa/fF53lRJzSJSe1HIyUGywfK4mimzAhRap6eBJQmb/PdBZ08XEaTLFTan8ifFgz/WCMzgKfrfxFFiYfGBzsCf2u+kp7hJWCe8lUbLZ8YxrxAHasCMSQsqmUSMg9yIc0Hohkd0jODdq6Eb0kFzDkTpjd8SNsL3fqm41wmmVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Aug 25, 2025 at 03:01:12PM +0800, kernel test robot wrote:
> 
> Hello,
> 
> kernel test robot noticed "BUG:sleeping_function_called_from_invalid_context_at_mm/mm_init.c" on:
> 
> commit: 8a523d9e6f30349ad2f8c34d850483db905e976b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master 0f4c93f7eb861acab537dbe94441817a270537bf]
> 
> in testcase: blktests
> version: blktests-x86_64-34a7fc4-1_20250824
> with following parameters:
> 
> 	disk: 1SSD
> 	test: nvme-group-00
> 
> config: x86_64-rhel-9.4-func
> compiler: gcc-12
> test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory

This patch should fix it:


diff --git a/mm/mm_init.c b/mm/mm_init.c
index f907dc17387d..c26f33fdd32b 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2085,7 +2085,10 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 			deferred_free_pages(spfn, chunk_end - spfn);
 
 			spfn = chunk_end;
-			cond_resched();
+			if (irqs_disabled())
+				touch_nmi_watchdog();
+			else
+				cond_resched();
 		}
 	}
 
 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202508251443.f2d9f77f-lkp@intel.com
> 
> 
> kern  :err   : [    9.708923] BUG: sleeping function called from invalid context at mm/mm_init.c:2153
> kern  :err   : [    9.709485] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
> kern  :err   : [    9.709485] preempt_count: 1, expected: 0
> kern  :err   : [    9.709485] RCU nest depth: 0, expected: 0
> kern  :warn  : [    9.709485] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.0-rc1-00003-g8a523d9e6f30 #1 PREEMPT(voluntary)
> kern  :warn  : [    9.709485] Hardware name: IEIT SYSTEMS NF5180-M8-A0-R0-00/NF5180-M8-A0-R0-00, BIOS 00.14.04 09/23/2024
> kern  :warn  : [    9.709485] Call Trace:
> kern  :warn  : [    9.709485]  <TASK>
> kern :warn : [    9.709485] dump_stack_lvl (lib/dump_stack.c:123 (discriminator 1)) 
> kern :warn : [    9.709485] __might_resched (kernel/sched/core.c:8958) 
> kern :warn : [    9.709485] deferred_init_memmap_chunk (include/linux/sched.h:2070 mm/mm_init.c:2153) 
> kern :warn : [    9.709485] ? __pfx_deferred_init_memmap_chunk (mm/mm_init.c:2140) 
> kern :warn : [    9.709485] ? __pfx_try_to_claim_block (mm/page_alloc.c:2291) 
> kern :warn : [    9.709485] ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161) 
> kern :warn : [    9.709485] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
> kern :warn : [    9.709485] ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161) 
> kern :warn : [    9.709485] ? rmqueue+0x8f7/0x29d0 
> kern :warn : [    9.709485] deferred_grow_zone (mm/mm_init.c:2286) 
> kern :warn : [    9.709485] get_page_from_freelist (mm/page_alloc.c:3824) 
> kern :warn : [    9.709485] __alloc_frozen_pages_noprof (mm/page_alloc.c:5148) 
> kern :warn : [    9.709485] ? __pfx___alloc_frozen_pages_noprof (mm/page_alloc.c:5114) 
> kern :warn : [    9.709485] ? __pfx_smp_call_function_many_cond (kernel/smp.c:784) 
> kern :warn : [    9.709485] __alloc_pages_noprof (mm/page_alloc.c:5182) 
> kern :warn : [    9.709485] dsalloc_pages (arch/x86/events/intel/ds.c:611) 
> kern :warn : [    9.709485] ? __asan_memset (mm/kasan/shadow.c:84) 
> kern :warn : [    9.709485] reserve_ds_buffers (arch/x86/events/intel/ds.c:631 arch/x86/events/intel/ds.c:789) 
> kern :warn : [    9.709485] x86_reserve_hardware (arch/x86/events/core.c:420 arch/x86/events/core.c:409) 
> kern :warn : [    9.709485] x86_pmu_event_init (arch/x86/events/core.c:673 arch/x86/events/core.c:2475) 
> kern :warn : [    9.709485] ? kmem_cache_alloc_node_noprof (arch/x86/include/asm/jump_label.h:46 include/linux/memcontrol.h:1714 mm/slub.c:2210 mm/slub.c:4190 mm/slub.c:4229 mm/slub.c:4281) 
> kern :warn : [    9.709485] perf_try_init_event (kernel/events/core.c:12581) 
> kern :warn : [    9.709485] perf_event_alloc (kernel/events/core.c:12680 kernel/events/core.c:12954) 
> kern :warn : [    9.709485] ? __pfx_watchdog_overflow_callback (kernel/watchdog_perf.c:107) 
> kern :warn : [    9.709485] perf_event_create_kernel_counter (kernel/events/core.c:13779 (discriminator 1)) 
> kern :warn : [    9.709485] hardlockup_detector_event_create (kernel/watchdog_perf.c:133 (discriminator 3)) 
> kern :warn : [    9.709485] watchdog_hardlockup_probe (kernel/watchdog_perf.c:267) 
> kern :warn : [    9.709485] lockup_detector_init (kernel/watchdog.c:1312) 
> kern :warn : [    9.709485] kernel_init_freeable (init/main.c:1571) 
> kern :warn : [    9.709485] ? __pfx_kernel_init (init/main.c:1461) 
> kern :warn : [    9.709485] kernel_init (init/main.c:1471) 
> kern :warn : [    9.709485] ? calculate_sigpending (kernel/signal.c:194) 
> kern :warn : [    9.709485] ? __pfx_kernel_init (init/main.c:1461) 
> kern :warn : [    9.709485] ret_from_fork (arch/x86/kernel/process.c:148) 
> kern :warn : [    9.709485] ? __pfx_kernel_init (init/main.c:1461) 
> kern :warn : [    9.709485] ret_from_fork_asm (arch/x86/entry/entry_64.S:258) 
> kern  :warn  : [    9.709485]  </TASK>
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20250825/202508251443.f2d9f77f-lkp@intel.com
> 
> 
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 

-- 
Sincerely yours,
Mike.

