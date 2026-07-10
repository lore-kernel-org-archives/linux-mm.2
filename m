Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CF0EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 15:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443DB6B0005; Fri, 10 Jul 2026 11:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F51B6B0088; Fri, 10 Jul 2026 11:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4756B008A; Fri, 10 Jul 2026 11:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F26786B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:56:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72668C1CB9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:56:16 +0000 (UTC)
X-FDA: 84973318752.20.E92865B
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf10.hostedemail.com (Postfix) with ESMTP id A595DC000E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:56:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YZZHQTq4;
	spf=pass (imf10.hostedemail.com: domain of hao_zhang_kdev@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=hao_zhang_kdev@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783698974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qZtKULhQdTFcAQvH4QJGyUFmGJ4jmjBVsuXK9pkMZw0=;
	b=PMY9g06G30Ssg8GYIFZ2U4i9cj4agdhxLBjxloGg2WczY0kL0SFyB57N10DkwoWbrWViGZ
	FbmqGF9WfG3/jl5q01NlRuPNKukCTl6z+7/p+qzA0Xa9Rt3M7rfEHhRcje46X1c0SCubDV
	DyTNLWEaRplXTfq69k5NuB3feKs+2Ng=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YZZHQTq4;
	spf=pass (imf10.hostedemail.com: domain of hao_zhang_kdev@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=hao_zhang_kdev@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783698974;
	b=XPtzF4nxYyRbxzmK/2TUkwGSNpwyq/gngQUpo9xxJEIphOPaIrxE/d7Ib0cjo5biExQCD9
	0fH7C3x0kuu2khfwdD4nrZGCpHB4QgoVHUXiYNBL0iAHw1gwkoYXMMEtXV6wYkjWxxZulL
	veYzEwLI7dWNUUGRh88p4XmW2DqX5PE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=qZtKULhQdTFcAQvH4QJGyUFmGJ4jmjBVsuXK9pkMZw0=;
	b=YZZHQTq4MdNwh41LG/QR3T+XipFU2hSH2ucjaj3O1idfyRmiQu/dcRnZNsPUo/
	53ly2jtm3v6LxUR1yJ4QoX/akUoexa8FmgDMYIpF8BmTahY9NhID5cSS5B2qbfD/
	DWb10TBeTWpj4cgU6ZhEVlihdnmmUyIjVOjHdG1h5sGjI=
Received: from localhost (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDXfZEQFlFqQqLIFg--.8061S2;
	Fri, 10 Jul 2026 23:56:01 +0800 (CST)
Date: Fri, 10 Jul 2026 23:56:00 +0800
From: Hao Zhang <hao_zhang_kdev@163.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Hao Zhang <hao_zhang_kdev@163.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
Message-ID: <alEWEColDdwQboYX@192.168.1.215>
References: <20260710071344.GA106129@zh-pc>
 <alDSekC_5t-29vJS@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alDSekC_5t-29vJS@thinkstation>
X-CM-TRANSID:PCgvCgDXfZEQFlFqQqLIFg--.8061S2
X-Coremail-Antispam: 1Uf129KBjvAXoW3CrWkWF1rtFy5Cr1UKw47CFg_yoW8Gr1rJo
	WYqFW5Cr48Gr98Aay2kr4DJF1UJr9aqFnxJa15Cw4Uua13Xw4UG34Dta13A3yUtw47GFn3
	Ar12kr1rtay5Jr93n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RPKsbUUUUU
X-Originating-IP: [240e:380:971:2300:78cb:9604:937:33c5]
X-CM-SenderInfo: pkdrs65kdqwshngh4qqrwthudrp/xtbC+RF4a2pRFhHWFgAA3H
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A595DC000E
X-Stat-Signature: axjz41je8ephzkt1ezuaa7nzxm64zhm5
X-HE-Tag: 1783698973-79409
X-HE-Meta: U2FsdGVkX19UHHqbE6t+Tp+fYsmMi4CjvomRdrGmW3qQ9gDrDpF+Wo5ngIUUzpSqxQNv4uwxmh7/G2qnvTIukbpyp0u0JxO22ch09XQwMUPSAJqwYQP8muB3aiiiFbh1Wf0Bcs8zhiQNeowYvEOSRDJ3DXyaVXhVE/1nMoK3882KADDxZlAxkqZ2Gj9Ilu81T64AACZEo1UcoNa9ENF22xHikTxr+dkyzNsZOrWxWeHx+L5jIOryyipHfvhzIdCmhmvVCTQY7RWIsXSOMO8pmdQCZr4cefS72iNul1d7zr5NYjakZJo5lrRIHVTclionbcSeCzR0Snj3B3VF0WSebJ7Vdekq7ISma/UkCZblWH2u4xujbeFEagH/Td/zhkB12zsxp1Z21chbymRs2ZBdk6N/jbHUc0x8q+SeimTT2VbopIxvThPhtm80QxGdQlPhGjRXEoiiShon/NYdbP7K5ZJwtx5LK0HYonI2ym98ZaNSOTVZR45thRMfuBsVoZ7InbpArQytkq2LmViQswa8hGrw3W4gySD3AXdV4dnXdcBNiigX5tLzpiZ/iLQzs7X2/B0WvUYeNfqjpcx05aaD9PIeeDDnP1ajidviTgZbtRIHkfZoypzKQ/Z0ix/ZSs+NrQw1PRCRLcRWN9yPGkFa/y8L5dr9T2FxLQWKgR7t8mllaRRT8xI/2ea1j8ZfehxEi0QAKLkUTHQA8U13/FPpwrCxrHiacRdZdp9IHvIUD3BdERhClXKW46Q7R7jASKGWDUVTp0CcLroriiDeea3qy3mSVefRKlLPB77BE5y/L4CkAOnQ2P/aPUS34jNmmTDzMZ/+bTzJ8qWR72nyhBz3BWw4oLBRTP5+y36jv8B8ZPG+lufjZ7aeWiDB6PELp8NJGJpbiU7oMZXHOnDaNSEt/g7dvOoqSq0l8cpmvBjU+QhyPXwgQDH65ChGQv2xUpvxHjWNoRdyZIZffKxkmPf
 HyRtINkc
 NFSjBBFQqVVAqsEs/NyoKWmxKPT+1oQ2//N3BP3gO2698Toxyk14f62zxQ5bI981lENF2ZtdTiu2DkyqQppDqqNGyxn9Kl2QVgzH9UIJsllP+qIu5urbFHKykmSPbq8l6hC/MuSDwguE31lT0JriE2KBy5+AQF8X1Z0eK2RzRjlT31peCVX84gDRgbJJwe5gsnyEwTkpW3EgbV9K1eQoI9lLr/p8kd6R3blfTeXJ3Waad1fqrQH/CErFNchadevpZNlOv6XrNBTWCwc9WHDKwmLidKzOAz1ztFGuwx5rJvfsCNv43M+CZfDgfbppUIgSP86bDtwCeHmsLu6eVaGKXduOZREpYqN4t4AN4KmcQTkEu1JFK7NNxNnaggf0Ich+ESKia9EHg6uF60UHhpHF2sOT9Q5qlkZbwLA/OURFPReZrg+LXr/Kr0oRBiw3A732xl0iLhvVVK9F2ANbkozuKHQuigqQulqV1laz7jnU+NG1Qv5RKo9DrquCPjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026, Kiryl Shutsemau wrote:
> On Fri, Jul 10, 2026 at 03:13:44PM +0800, Hao Zhang wrote:
> > From: Hao Zhang <zhanghao1@kylinos.cn>
> > Date: Thu, 9 Jul 2026 16:30:00 +0800
> > 
> > __folio_split() takes mapping->i_mmap_rwsem while unmapping and
> > splitting a file-backed large folio. The lock is currently released
> > only after the split folios that are not returned locked to the caller
> > have been unlocked and put.
> > 
> > That leaves a lifetime hole. Once the split folios are unlocked and
> > their references are dropped, inode eviction can make progress through
> > the final page-cache truncation path. After the folios are removed from
> > the page cache and the last inode reference is dropped, the inode that
> > embeds the address_space can be freed after an RCU grace period. A later
> > i_mmap_unlock_read(mapping) then dereferences mapping->i_mmap_rwsem
> > from freed memory.
> > 
> > A possible race is:
> > 
> >   CPU0                                    CPU1
> >   __folio_split()
> >     i_mmap_lock_read(mapping)
> >     ...
> >     remap_page()
> >     folio_unlock(new_folio)
> >     free_folio_and_swap_cache(new_folio)
> >                                           evict inode
> >                                           truncate_inode_pages_final()
> >                                           destroy_inode()
> >                                           call_rcu()
> >                                           RCU callback frees inode
> >     i_mmap_unlock_read(mapping)
> > 
> > Release mapping->i_mmap_rwsem after the page-cache and reverse-mapping
> > work has completed, but before unlocking and putting any of the split
> > folios. Clear the local mapping pointer after the early unlock so the
> > common exit path does not unlock it a second time.
> 
> I don't buy this analysis. We still have the lock_at page which is locked
> and still in the page cache. Inode eviction cannot complete past
> truncate_inode_pages_final() until it is unlocked, which only happens
> after __folio_split() has released i_mmap_rwsem.
> 
> One possible path how this can be hit is if lock_at ends up in an
> after-split folio beyond EOF and __folio_freeze_and_split_unmapped()
> removes it from the page cache. Note the drop loop starts at
> folio_next(folio), so this requires splitting at a tail page (e.g.
> memory-failure) racing with truncate.
> 
> But that's not what your analysis claims. Please share the actual crash
> reports. Let's get to the bottom of the situation before changing the
> code.
> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov
>

Memory failure: 0x5a6a7: recovery action for clean LRU page: Recovered
Injecting memory failure for pfn 0x81bfe at process virtual address 0x200000ffe000
==================================================================
BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
Read of size 8 at addr ffff88800b81c5e8 by task syz.2.11034/45874

CPU: 0 UID: 0 PID: 45874 Comm: syz.2.11034 Not tainted 7.0.0-rc3base+ #62 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 __dump_stack data/linux/lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xbe/0x130 data/linux/lib/dump_stack.c:120
 print_address_description data/linux/mm/kasan/report.c:378 [inline]
 print_report+0xd1/0x660 data/linux/mm/kasan/report.c:482
 kasan_report+0xec/0x130 data/linux/mm/kasan/report.c:595
 __asan_report_load8_noabort+0x14/0x30 data/linux/mm/kasan/report_generic.c:381
 __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
 up_read+0x22/0x30 data/linux/kernel/locking/rwsem.c:1633
 i_mmap_unlock_read data/linux/include/linux/fs.h:537 [inline]
 __folio_split+0x732/0x1640 data/linux/mm/huge_memory.c:4100
 __split_huge_page_to_list_to_order+0x7b/0x140 data/linux/mm/huge_memory.c:4203
 split_huge_page_to_list_to_order data/linux/include/linux/huge_mm.h:385 [inline]
 split_huge_page_to_order data/linux/include/linux/huge_mm.h:389 [inline]
 try_to_split_thp_page+0xab/0x390 data/linux/mm/memory-failure.c:1675
 memory_failure+0x1394/0x26e0 data/linux/mm/memory-failure.c:2470
 madvise_inject_error data/linux/mm/madvise.c:1487 [inline]
 madvise_do_behavior+0x4ae/0x8a0 data/linux/mm/madvise.c:1925
 do_madvise+0x162/0x230 data/linux/mm/madvise.c:2028
 __do_sys_madvise data/linux/mm/madvise.c:2037 [inline]
 __se_sys_madvise data/linux/mm/madvise.c:2035 [inline]
 __x64_sys_madvise+0xae/0x120 data/linux/mm/madvise.c:2035
 x64_sys_call+0x1bed/0x25e0 data/linux/arch/x86/include/generated/asm/syscalls_64.h:29
 do_syscall_x64 data/linux/arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0x14e0 data/linux/arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x762e87f8f109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:0000762e88d6d038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 0000762e881e5fa0 RCX: 0000762e87f8f109
RDX: 0000000000000064 RSI: 0000000000003000 RDI: 0000200000ffd000
RBP: 0000762e88011f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000762e881e6038 R14: 0000762e881e5fa0 R15: 00007ffdc9863dc8
 </TASK>

Allocated by task 45874:
 kasan_save_stack+0x39/0x70 data/linux/mm/kasan/common.c:57
 kasan_save_track+0x14/0x40 data/linux/mm/kasan/common.c:78
 kasan_save_alloc_info+0x37/0x60 data/linux/mm/kasan/generic.c:570
 unpoison_slab_object data/linux/mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x9d/0xa0 data/linux/mm/kasan/common.c:366
 kasan_slab_alloc data/linux/include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook data/linux/mm/slub.c:4542 [inline]
 slab_alloc_node data/linux/mm/slub.c:4869 [inline]
 kmem_cache_alloc_lru_noprof+0x1e6/0x6b0 data/linux/mm/slub.c:4888
 shmem_alloc_inode+0x2a/0x60 data/linux/mm/shmem.c:5167
 alloc_inode+0x6b/0x230 data/linux/fs/inode.c:347
 new_inode+0x26/0x1c0 data/linux/fs/inode.c:1185
 __shmem_get_inode data/linux/mm/shmem.c:3079 [inline]
 shmem_get_inode+0x1de/0x1020 data/linux/mm/shmem.c:3154
 __shmem_file_setup+0x328/0x3e0 data/linux/mm/shmem.c:5852
 shmem_kernel_file_setup data/linux/mm/shmem.c:5883 [inline]
 __shmem_zero_setup data/linux/mm/shmem.c:5924 [inline]
 shmem_zero_setup+0x9c/0x1b0 data/linux/mm/shmem.c:5934
 __mmap_new_vma data/linux/mm/vma.c:2534 [inline]
 __mmap_region+0x2046/0x2a60 data/linux/mm/vma.c:2759
 mmap_region+0x162/0x320 data/linux/mm/vma.c:2837
 do_mmap+0x892/0x1000 data/linux/mm/mmap.c:559
 vm_mmap_pgoff+0x2a3/0x450 data/linux/mm/util.c:581
 ksys_mmap_pgoff+0xc8/0x5e0 data/linux/mm/mmap.c:605
 __do_sys_mmap data/linux/arch/x86/kernel/sys_x86_64.c:89 [inline]
 __se_sys_mmap data/linux/arch/x86/kernel/sys_x86_64.c:82 [inline]
 __x64_sys_mmap+0x11a/0x1b0 data/linux/arch/x86/kernel/sys_x86_64.c:82
 x64_sys_call+0x1afd/0x25e0 data/linux/arch/x86/include/generated/asm/syscalls_64.h:10
 do_syscall_x64 data/linux/arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0x14e0 data/linux/arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Freed by task 4601:
 kasan_save_stack+0x39/0x70 data/linux/mm/kasan/common.c:57
 kasan_save_track+0x14/0x40 data/linux/mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x60 data/linux/mm/kasan/generic.c:584
 poison_slab_object data/linux/mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x6f/0xa0 data/linux/mm/kasan/common.c:285
 kasan_slab_free data/linux/include/linux/kasan.h:235 [inline]
 slab_free_hook data/linux/mm/slub.c:2692 [inline]
 slab_free data/linux/mm/slub.c:6168 [inline]
 kmem_cache_free+0x2c4/0x650 data/linux/mm/slub.c:6298
 shmem_free_in_core_inode+0x54/0xb0 data/linux/mm/shmem.c:5177
 i_callback+0x4c/0xa0 data/linux/fs/inode.c:326
 rcu_do_batch+0x3af/0xdf0 data/linux/kernel/rcu/tree.c:2617
 rcu_core+0x4af/0x6f0 data/linux/kernel/rcu/tree.c:2869
 rcu_core_si+0xe/0x20 data/linux/kernel/rcu/tree.c:2886
 handle_softirqs+0x200/0x940 data/linux/kernel/softirq.c:622
 __do_softirq data/linux/kernel/softirq.c:656 [inline]
 invoke_softirq data/linux/kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x1ca/0x220 data/linux/kernel/softirq.c:723
 irq_exit_rcu+0xe/0x20 data/linux/kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt data/linux/arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0x92/0xd0 data/linux/arch/x86/kernel/apic/apic.c:1056
 asm_sysvec_apic_timer_interrupt+0x1b/0x20 data/linux/arch/x86/include/asm/idtentry.h:569

Last potentially related work creation:
 kasan_save_stack+0x39/0x70 data/linux/mm/kasan/common.c:57
 kasan_record_aux_stack+0xae/0xd0 data/linux/mm/kasan/generic.c:556
 __call_rcu_common+0xcc/0x1310 data/linux/kernel/rcu/tree.c:3131
 call_rcu+0x34/0x50 data/linux/kernel/rcu/tree.c:3251
 destroy_inode+0x144/0x1e0 data/linux/fs/inode.c:402
 evict+0x57f/0xac0 data/linux/fs/inode.c:870
 iput_final data/linux/fs/inode.c:1966 [inline]
 iput data/linux/fs/inode.c:2015 [inline]
 iput+0x6a0/0xb90 data/linux/fs/inode.c:1978
 dentry_unlink_inode+0x2a4/0x460 data/linux/fs/dcache.c:467
 __dentry_kill+0x1b2/0x5b0 data/linux/fs/dcache.c:670
 finish_dput+0x69/0x3e0 data/linux/fs/dcache.c:879
 dput.part.0+0x3c2/0x4d0 data/linux/fs/dcache.c:928
 dput+0x24/0x40 data/linux/fs/dcache.c:920
 __fput+0x49b/0xaa0 data/linux/fs/file_table.c:477
 ____fput+0x1e/0x30 data/linux/fs/file_table.c:497
 task_work_run+0x16a/0x270 data/linux/kernel/task_work.c:233
 resume_user_mode_work data/linux/include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop data/linux/kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0x185/0x600 data/linux/kernel/entry/common.c:98
 __exit_to_user_mode_prepare data/linux/include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare data/linux/include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode data/linux/include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x5dc/0x14e0 data/linux/arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The buggy address belongs to the object at ffff88800b81c060
 which belongs to the cache shmem_inode_cache of size 1520
The buggy address is located 1416 bytes inside of
 freed 1520-byte region [ffff88800b81c060, ffff88800b81c650)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xb818
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff88800b81fa51
flags: 0xfffffc0000040(head|node=0|zone=1|lastcpupid=0x1fffff)
page_type: f5(slab)
raw: 000fffffc0000040 ffff8880018618c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800130013 00000000f5000000 ffff88800b81fa51
head: 000fffffc0000040 ffff8880018618c0 dead000000000100 dead000000000122
head: 0000000000000000 0000000800130013 00000000f5000000 ffff88800b81fa51
head: 000fffffc0000003 ffffea00002e0601 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88800b81c480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88800b81c500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88800b81c580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                          ^
 ffff88800b81c600: fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc
 ffff88800b81c680: fc fc fc fc fc fc fc fc fc fc fa fb fb fb fb fb
==================================================================
Memory failure: 0x81bfe: recovery action for already truncated LRU page: Ignored
Soft offlining pfn 0x7a60f at process virtual address 0x200000841000
Soft offlining pfn 0x729b9 at process virtual address 0x200000842000
Soft offlining pfn 0x771f9 at process virtual address 0x200000843000
Injecting memory failure for pfn 0x7b9f2 at process virtual address 0x200000ffe000
Memory failure: 0x7b9f2: Sending SIGBUS to syz.1.11044:45913 due to hardware memory corruption
Memory failure: 0x7b9f2: recovery action for dirty LRU page: Recovered
Injecting memory failure for pfn 0x7a1ff at process virtual address 0x200000fff000
Memory failure: 0x7a1ff: Sending SIGBUS to syz.1.11044:45913 due to hardware memory corruption
Memory failure: 0x7a1ff: recovery action for dirty LRU page: Recovered

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>

This is the crash report, please review.


