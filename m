Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F094CF854B
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 07:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6096B0007; Thu, 20 Nov 2025 02:27:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9DC16B0012; Thu, 20 Nov 2025 02:27:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3706B0027; Thu, 20 Nov 2025 02:27:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA1DA6B0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:27:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 547C85A95E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:27:35 +0000 (UTC)
X-FDA: 84130155270.19.9AC2A73
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2EB551C0009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:27:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763623653; a=rsa-sha256;
	cv=none;
	b=ed1ptx6Et0aUOniwwkOj9mbtKZhLMOsGDpJtb7atCKKwXgxiyL+FxMrfZtSYhB0o6QiDei
	c0/56Gg9P57k+YJFaOzP/dXhmljmta6ZU3MV+d/pm0yZPef88z24GeU+oNYZwlyS+QUZPt
	Abzr1eELGyDWxZ1Y5kvQ6FTedw1hNDQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763623653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PeXopoGnVpa1AMUDs7beSLhVS8PFd0/tK69ottiollU=;
	b=b839XPs9rhqOIYMC8aF3Hv6yAb1hL19T+2oF0zgYV4ZbQkZtG3lFy6czHTOUSQj3aufwye
	unOs+BC156oHA+713sT9/spcyOztruh0ptEvYYgfLblNY8w8sZC9dkxb01HcGCwNJs2tvW
	a7E0ua8PXHCUfu90S+sICllUIJqhpZc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0AA3C68B05; Thu, 20 Nov 2025 08:27:27 +0100 (CET)
Date: Thu, 20 Nov 2025 08:27:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: kernel test robot <oliver.sang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, oe-lkp@lists.linux.dev, lkp@intel.com,
	Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com
Subject: Re: [linux-next:master] [mempool]  022e94e2c3:
 BUG:KASAN:double-free_in_mempool_free
Message-ID: <20251120072726.GA31171@lst.de>
References: <202511201309.55538605-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511201309.55538605-lkp@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2EB551C0009
X-Stat-Signature: fyf3b9xco75b8njwfeby97889u47z4km
X-Rspam-User: 
X-HE-Tag: 1763623652-172107
X-HE-Meta: U2FsdGVkX19G0v9UGetIW5kga+tcE0xmDERrqlCEy7vC3x5Nl9N17tJ2CWvLryJLT5ISkd917zMyG16jxoBBWwNiiM8YTheir9dkArGpl78cwzs3FwEC2VgKTpF9CsTbn8BAeUUSBRtNW1F056FOiP4+cxJLwGbt+AZVFSsNL7wl9E5Oo/uLPefJV1CVdTpPVltIMZLuqXTXBAxjdWNCvRAdfnvkkXQrNerpiQZCdNWjgMaF5bIyhswA5MyBmW4287lfumY4gEIDvUWgySo5WvX6zvusCrR7VICa1UkrsPgVvL88FVXU6fwKFzDzDZpCr7RDmK5R5Wp1MncwCnO/712d1FLIxG5oop5Gb8DUO55q2lSgr9R0E0URtO/5RsVv8uSlFkPK+VHKcGN4y0RMYRZQCZXK+1FbeeBxQScH76M0IzvF2huNH18mQg0DKZx3kwTuCnFKXPSmzCjF4H2oJn9h20skwnsSChGFgq9hpp0I+W3jEp6ZHRK0EyF/hi1l1c6B1PpI6tFx3Oc5y82LX4TO1HbRlPuQP9e3rZC6ClXq5tINKfbiXq3VFJj0Fj9tBq6V5Y7jfho56eJyBQgGWYR7t9v1MEYXHBlYvHbh/iKM//GplPTn20IWaemkFVkfCkuUB33I/0zDkkAkMpwWEtE+wva1cezHxZAg3C1E8A6GNBloVN/fk+m4Ph7/71c/Dj8+SE6FxUabqJWsz9WaAY5DFbyVFTJVzfhH+dMYy1LMmaFMN/LqMdsNkW1eRpC3ciz6ePxg6U6E8JJ/ivjsbuPTwVM9OnFUtkhzlJUhK6tQvAINUr47/TbIzERuOwRL4cYdPM46a0NHOrWYkTFFJBgy4i2R2KUjmxR0IVcWlP5sPcRuGyYyoqavgUqMcWy81gr19bNjNFdXnYB0uGR3uXr+xTQmTfe6fO2FBLUpMSnoE6x9Xr2L2v8yzdnlQZttRTRAxAmldjSYwVzVcXF
 xJ0LJnUE
 OBBX7dQ2qMkqaRfwHZ+98ryDGHtEolR9NZa5Bve6wIh0aCiThyTXAhqa1tDo88upWRAPWCiHedFWCUGSYAEPEjED2zmSjbUPih5PQPORYx4jfW9Q4xVfBtLhWcO1VQQ6q7W2y5wbRzlagUoq5sSaM52HaGQ6gzgZz/HFnkFf3JNjzbnoe2kOVjAsW+YHCvpT48xEJuIddka3u4tcWVwjnpSaS3Y/FAxQxDHgOK716Czf6xt++QLekMfD8rPmUYdNNK9gf83x8o6+aeduIy6ofF/FW+5UUHZZzD6VBTbnlp9vrOuseNHzlz8/gL3pmoKzo04vEKws6eIcefcWjmoStyRz2tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Maybe I'm misunderstanding the trace, but AFAICS this comes from
the KASAN kunit test that injects a double free, and the trace
shows that KASAN indeed detected the double free and everything is
fine.  Or did I misunderstand the report?

On Thu, Nov 20, 2025 at 01:57:20PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG:KASAN:double-free_in_mempool_free" on:
> 
> commit: 022e94e2c304505973d00dedca4b1432c231fbf6 ("mempool: add mempool_{alloc,free}_bulk")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master 187dac290bfd0741b9d7d5490af825c33fd9baa4]
> 
> in testcase: kunit
> version: 
> with following parameters:
> 
> 	group: group-03
> 
> 
> 
> config: x86_64-rhel-9.4-kunit
> compiler: gcc-14
> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 16G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202511201309.55538605-lkp@intel.com
> 
> 
> kern  :err   : [  152.903458] [   T4181] ==================================================================
> kern  :err   : [  152.916375] [   T4181] BUG: KASAN: double-free in mempool_free (mm/mempool.c:687 (discriminator 1))
> kern  :err   : [  152.922918] [   T4181] Free of addr ffff88812a92b800 by task kunit_try_catch/4181
> 
> kern  :err   : [  152.932343] [   T4181] CPU: 2 UID: 0 PID: 4181 Comm: kunit_try_catch Tainted: G S  B            N  6.18.0-rc3-00007-g022e94e2c304 #1 PREEMPT(voluntary)
> kern  :err   : [  152.932348] [   T4181] Tainted: [S]=CPU_OUT_OF_SPEC, [B]=BAD_PAGE, [N]=TEST
> kern  :err   : [  152.932350] [   T4181] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
> kern  :err   : [  152.932351] [   T4181] Call Trace:
> kern  :err   : [  152.932353] [   T4181]  <TASK>
> kern  :err   : [  152.932354] [   T4181]  dump_stack_lvl (lib/dump_stack.c:122)
> kern  :err   : [  152.932358] [   T4181]  print_address_description+0x88/0x320
> kern  :err   : [  152.932362] [   T4181]  print_report (mm/kasan/report.c:483)
> kern  :err   : [  152.932365] [   T4181]  ? mempool_free (mm/mempool.c:687 (discriminator 1))
> kern  :err   : [  152.932367] [   T4181]  kasan_report_invalid_free (mm/kasan/report.c:563)
> kern  :err   : [  152.932371] [   T4181]  ? mempool_free (mm/mempool.c:687 (discriminator 1))
> kern  :err   : [  152.932374] [   T4181]  ? mempool_free (mm/mempool.c:687 (discriminator 1))
> kern  :err   : [  152.932376] [   T4181]  ? mempool_free (mm/mempool.c:687 (discriminator 1))
> kern  :err   : [  152.932378] [   T4181]  check_slab_allocation (mm/kasan/common.c:230)
> kern  :err   : [  152.932381] [   T4181]  __kasan_mempool_poison_object (mm/kasan/common.c:542 (discriminator 1))
> kern  :err   : [  152.932384] [   T4181]  mempool_free_bulk (mm/mempool.c:137 mm/mempool.c:160 mm/mempool.c:653)
> kern  :err   : [  152.932387] [   T4181]  ? mempool_init_node (mm/mempool.c:140 mm/mempool.c:160 mm/mempool.c:245)
> kern  :err   : [  152.932389] [   T4181]  ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:107 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:2170 (discriminator 4) include/linux/atomic/atomic-instrumented.h:1302 (discriminator 4) include/asm-generic/qspinlock.h:111 (discriminator 4) include/linux/spinlock.h:187 (discriminator 4) include/linux/spinlock_api_smp.h:111 (discriminator 4) kernel/locking/spinlock.c:162 (discriminator 4))
> kern  :err   : [  152.932393] [   T4181]  mempool_free (mm/mempool.c:687 (discriminator 1))
> kern  :err   : [  152.932395] [   T4181]  ? __pfx_mempool_free (mm/mempool.c:686)
> kern  :err   : [  152.932398] [   T4181]  ? kasan_save_track (mm/kasan/common.c:69 (discriminator 1) mm/kasan/common.c:78 (discriminator 1))
> kern  :err   : [  152.932400] [   T4181]  ? remove_element (mm/mempool.c:172)
> kern  :err   : [  152.932414] [   T4181] mempool_double_free_helper (mm/kasan/kasan_test_c.c:1444 (discriminator 17)) kasan_test
> kern  :err   : [  152.932423] [   T4181]  ? __pfx_mempool_double_free_helper (mm/kasan/kasan_test_c.c:1436) kasan_test
> kern  :err   : [  152.932440] [   T4181]  ? sched_clock (arch/x86/include/asm/preempt.h:95 arch/x86/kernel/tsc.c:289)
> kern  :err   : [  152.932442] [   T4181]  ? __update_idle_core (kernel/sched/sched.h:1340 kernel/sched/fair.c:7584)
> kern  :err   : [  152.932445] [   T4181] mempool_kmalloc_double_free (mm/kasan/kasan_test_c.c:1457) kasan_test
> kern  :err   : [  152.932453] [   T4181]  ? __pfx_mempool_kmalloc_double_free (mm/kasan/kasan_test_c.c:1448) kasan_test
> kern  :err   : [  152.932461] [   T4181]  ? __switch_to (arch/x86/include/asm/cpufeature.h:101 arch/x86/kernel/process_64.c:378 arch/x86/kernel/process_64.c:666)
> kern  :err   : [  152.932463] [   T4181]  ? __pfx_mempool_kmalloc (mm/mempool.c:715)
> kern  :err   : [  152.932466] [   T4181]  ? __pfx_mempool_kfree (mm/mempool.c:722)
> kern  :err   : [  152.932468] [   T4181]  ? __pfx_read_tsc (arch/x86/include/asm/tsc.h:57 arch/x86/kernel/tsc.c:1134)
> kern  :err   : [  152.932471] [   T4181]  ? ktime_get_ts64 (kernel/time/timekeeping.c:387 kernel/time/timekeeping.c:404 kernel/time/timekeeping.c:967)
> kern  :err   : [  152.932474] [   T4181]  ? __pfx___schedule (kernel/sched/core.c:6785)
> kern  :err   : [  152.932477] [   T4181]  kunit_try_run_case (lib/kunit/test.c:450 lib/kunit/test.c:493)
> kern  :err   : [  152.932480] [   T4181]  ? __pfx_kunit_try_run_case (lib/kunit/test.c:480)
> kern  :err   : [  152.932483] [   T4181]  ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:107 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:2170 (discriminator 4) include/linux/atomic/atomic-instrumented.h:1302 (discriminator 4) include/asm-generic/qspinlock.h:111 (discriminator 4) include/linux/spinlock.h:187 (discriminator 4) include/linux/spinlock_api_smp.h:111 (discriminator 4) kernel/locking/spinlock.c:162 (discriminator 4))
> kern  :err   : [  152.932486] [   T4181]  ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161)
> kern  :err   : [  152.932489] [   T4181]  ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161)
> kern  :err   : [  152.932492] [   T4181]  ? __pfx_kunit_try_run_case (lib/kunit/test.c:480)
> kern  :err   : [  152.932494] [   T4181]  ? __pfx_kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:26)
> kern  :err   : [  152.932498] [   T4181]  kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:31)
> kern  :err   : [  152.932501] [   T4181]  kthread (kernel/kthread.c:463)
> kern  :err   : [  152.932503] [   T4181]  ? __pfx_kthread (kernel/kthread.c:412)
> kern  :err   : [  152.932505] [   T4181]  ? __pfx__raw_spin_lock_irq (kernel/locking/spinlock.c:169)
> kern  :err   : [  152.932509] [   T4181]  ? __pfx_kthread (kernel/kthread.c:412)
> kern  :err   : [  152.932511] [   T4181]  ? __pfx_kthread (kernel/kthread.c:412)
> kern  :err   : [  152.932513] [   T4181]  ret_from_fork (arch/x86/kernel/process.c:164)
> kern  :err   : [  152.932516] [   T4181]  ? __pfx_kthread (kernel/kthread.c:412)
> kern  :err   : [  152.932518] [   T4181]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> kern  :err   : [  152.932522] [   T4181]  </TASK>
> 
> kern  :err   : [  153.201368] [   T4181] Allocated by task 4181:
> kern  :warn  : [  153.205558] [   T4181]  kasan_save_stack (mm/kasan/common.c:57)
> kern  :warn  : [  153.210098] [   T4181]  kasan_save_track (mm/kasan/common.c:69 (discriminator 1) mm/kasan/common.c:78 (discriminator 1))
> kern  :warn  : [  153.214637] [   T4181]  remove_element (mm/mempool.c:172)
> kern  :warn  : [  153.219176] [   T4181]  mempool_alloc_preallocated (include/linux/spinlock.h:406 mm/mempool.c:409 mm/mempool.c:585)
> kern  :warn  : [  153.224582] [   T4181] mempool_double_free_helper (mm/kasan/kasan_test_c.c:1439) kasan_test
> kern  :warn  : [  153.231213] [   T4181] mempool_kmalloc_double_free (mm/kasan/kasan_test_c.c:1457) kasan_test
> kern  :warn  : [  153.237839] [   T4181]  kunit_try_run_case (lib/kunit/test.c:450 lib/kunit/test.c:493)
> kern  :warn  : [  153.242727] [   T4181]  kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:31)
> kern  :warn  : [  153.248830] [   T4181]  kthread (kernel/kthread.c:463)
> kern  :warn  : [  153.252759] [   T4181]  ret_from_fork (arch/x86/kernel/process.c:164)
> kern  :warn  : [  153.257211] [   T4181]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> 
> kern  :err   : [  153.264025] [   T4181] Freed by task 4181:
> kern  :warn  : [  153.267866] [   T4181]  kasan_save_stack (mm/kasan/common.c:57)
> kern  :warn  : [  153.272416] [   T4181]  kasan_save_track (mm/kasan/common.c:69 (discriminator 1) mm/kasan/common.c:78 (discriminator 1))
> kern  :warn  : [  153.276964] [   T4181]  __kasan_save_free_info (mm/kasan/generic.c:590 (discriminator 1))
> kern  :warn  : [  153.282025] [   T4181]  __kasan_mempool_poison_object (mm/kasan/common.c:534)
> kern  :warn  : [  153.287868] [   T4181]  mempool_free_bulk (mm/mempool.c:137 mm/mempool.c:160 mm/mempool.c:653)
> kern  :warn  : [  153.292668] [   T4181]  mempool_free (mm/mempool.c:687 (discriminator 1))
> kern  :warn  : [  153.296944] [   T4181] mempool_double_free_helper (mm/kasan/kasan_test_c.c:1444 (discriminator 5)) kasan_test
> kern  :warn  : [  153.303573] [   T4181] mempool_kmalloc_double_free (mm/kasan/kasan_test_c.c:1457) kasan_test
> kern  :warn  : [  153.310203] [   T4181]  kunit_try_run_case (lib/kunit/test.c:450 lib/kunit/test.c:493)
> kern  :warn  : [  153.315091] [   T4181]  kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:31)
> kern  :warn  : [  153.321198] [   T4181]  kthread (kernel/kthread.c:463)
> kern  :warn  : [  153.325127] [   T4181]  ret_from_fork (arch/x86/kernel/process.c:164)
> kern  :warn  : [  153.329576] [   T4181]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> 
> kern  :err   : [  153.336387] [   T4181] The buggy address belongs to the object at ffff88812a92b800
> which belongs to the cache kmalloc-128 of size 128
> kern  :err   : [  153.350320] [   T4181] The buggy address is located 0 bytes inside of
> 128-byte region [ffff88812a92b800, ffff88812a92b880)
> 
> kern  :err   : [  153.365488] [   T4181] The buggy address belongs to the physical page:
> kern  :warn  : [  153.371765] [   T4181] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x12a92a
> kern  :warn  : [  153.380478] [   T4181] head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> kern  :warn  : [  153.388842] [   T4181] flags: 0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff)
> kern  :warn  : [  153.396513] [   T4181] page_type: f5(slab)
> kern  :warn  : [  153.400355] [   T4181] raw: 0017ffffc0000040 ffff888100042a00 ffffea00040b9600 0000000000000004
> kern  :warn  : [  153.408806] [   T4181] raw: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
> kern  :warn  : [  153.417258] [   T4181] head: 0017ffffc0000040 ffff888100042a00 ffffea00040b9600 0000000000000004
> kern  :warn  : [  153.425800] [   T4181] head: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
> kern  :warn  : [  153.434338] [   T4181] head: 0017ffffc0000001 ffffea0004aa4a81 00000000ffffffff 00000000ffffffff
> kern  :warn  : [  153.442876] [   T4181] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
> kern  :warn  : [  153.451422] [   T4181] page dumped because: kasan: bad access detected
> 
> kern  :err   : [  153.459902] [   T4181] Memory state around the buggy address:
> kern  :err   : [  153.465395] [   T4181]  ffff88812a92b700: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> kern  :err   : [  153.473335] [   T4181]  ffff88812a92b780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> kern  :err   : [  153.481266] [   T4181] >ffff88812a92b800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> kern  :err   : [  153.489195] [   T4181]                    ^
> kern  :err   : [  153.493121] [   T4181]  ffff88812a92b880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> kern  :err   : [  153.501051] [   T4181]  ffff88812a92b900: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> kern  :err   : [  153.508980] [   T4181] ==================================================================
> kern  :info  : [  153.517054] [   T3993]     ok 51 mempool_kmalloc_double_free
> kern  :err   : [  153.517141] [   T4183] ==================================================================
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20251120/202511201309.55538605-lkp@intel.com
> 
> 
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
---end quoted text---

