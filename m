Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F36C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 02:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9456B00B2; Thu, 31 Jul 2025 22:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91366B00B9; Thu, 31 Jul 2025 22:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA74A6B00BB; Thu, 31 Jul 2025 22:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A83FD6B00B2
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:40:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D4AA160EB1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 02:40:58 +0000 (UTC)
X-FDA: 83726636196.29.6863F78
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 65FE580004
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 02:40:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754016056; a=rsa-sha256;
	cv=none;
	b=kND5HAvHlof3LuhzNFkALGw4fCossx6nvra5kH455JBz8ouLWLuNLi670BTfiVwlxBjZR3
	6UkeQlJiz9x7PD1ToS5pnc/I7WSx/TOKQWnmEonpodUihi+5XbMhXzp1WP7IOi4bGbx9i3
	UEilnHpD8v/82R64M2nDp5Aoes8GTik=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754016056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MmDlPPXe7TbvZXcMn5DrT5gPyqKTuiy3b6OSFccn4+M=;
	b=VRxDtnVOtRSHanNVkuXS/pdd7vxWvqSZeSMBQ9zfzekjN3r6oIyR1BuSg7of9GYaCSATWI
	iQGsCkVUaare2+MEoJG6WO1IBm4oE5yxipah8y2qBjAOh1AgKHCFEkVgG5Gj9qzaZ7bfJb
	3v7NES9Bmgke11YGAOKGMyspAT8nQjU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 871DA16A3;
	Thu, 31 Jul 2025 19:40:47 -0700 (PDT)
Received: from [10.164.146.15] (J09HK2D2RT.blr.arm.com [10.164.146.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18C4A3F5A1;
	Thu, 31 Jul 2025 19:40:53 -0700 (PDT)
Message-ID: <d1445c9c-6603-4ff2-9cac-2a60ed4efe4b@arm.com>
Date: Fri, 1 Aug 2025 08:10:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/debug_vm_pgtable: clear page table entries at
 destroy_args()
To: "Herton R. Krzesinski" <herton@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20250731214051.4115182-1-herton@redhat.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250731214051.4115182-1-herton@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 65FE580004
X-Stat-Signature: 3t5x9imjctao843shwrzbstc51sbn8rg
X-Rspam-User: 
X-HE-Tag: 1754016056-787169
X-HE-Meta: U2FsdGVkX18YFL6aU3ualB1gcoRMII4gpt3xTYMLAfpo21p0W409WpWJhQZzjjPpcTP2ckf/UVZkCT6HFtZvLOZCIVrhN0jNMHetRf8zz8w4qzx9CMwAziisAmg2SxAdV1vU+vIDwb6GoeBuhEUD6eb/ySzE3uF0Mfd62yMizsquTYReid+XKII/kOCzdaa/VpPgiFUWzw7sIk/PkSvaWzC8WBMTFHST8d1QYtdERGr/Xo5YpHzsiODt8l3FwAhUNA0lrdEesjBOAHDI8489uwTGfoOTBokmQYBXONhPsa6ovCZa5UbqCqq3TlJw1DkKvVLziYpbt8iQ3GdigLn0w6qKfHodHqjFH3leMAjoZauyHwmnJZIqLM1UylZnZeBTrWz0n3zDu2f+3uXafbgnjS37kuqockwikTFtADPDPbiNtwnSwHqQvQrndL2Mbe5h74UyaaXjHo+I6SlyP2CTGWmvD6yWpVUL0vYOi4QDctu1YT/ZyMLWmYGhVATBSmGYR3U5eeWIV4+lg/VuZzA5klOMhb1yDrH77W9qjeukg1Ru5BuUHrQdjRNDgpcZYAxjpdc8nQnWVsAFaLRtM0hghJHeosZw8NZZQIkBtiVeKZ9iUNxguP1vN7cUZ3SolKFsOZSeLWIlg9tIWDnOSTg4mgIqNPmBXAVPUkUhSYtNms6BT5wTY1TB3vtGbv866RLu3kZexXNXs9K9z1DlS+vFyL+LhcR492itidgN8ImKZVEEGJVxbIOQPfllYbPVzJlwcUhWiFbLpG9zuLNzDInPBP2lAYtOLA9YxjijbGXvatT02mboN5Q2TLwKYTohSxZ01ml+6cYbuE3kWSVXprysx6sBYlmSpk4Pb8Xe6rnclQ7yZ7dFfc0XUjGJPpd6GD+ZM+HLDBsyI7c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Herton,

On 01/08/25 3:10 AM, Herton R. Krzesinski wrote:
> The mm/debug_vm_pagetable test allocates manually page table entries for the
> tests it runs, using also its manually allocated mm_struct. That in itself is
> ok, but when it exits, at destroy_args() it fails to clear those entries with
> the *_clear functions.
> 
> The problem is that leaves stale entries. If another process allocates
> an mm_struct with a pgd at the same address, it may end up running into
> the stale entry. This is happening in practice on a debug kernel with

Should not the allocators ensure that the allocated memory elements are
all cleaned up before using them ?

> CONFIG_DEBUG_VM_PGTABLE=y, for example this is the output with some
> extra debugging I added (it prints a warning trace if pgtables_bytes goes
> negative, in addition to the warning at check_mm() function):
> 
> [    2.539353] debug_vm_pgtable: [get_random_vaddr         ]: random_vaddr is 0x7ea247140000
> [    2.539366] kmem_cache info
> [    2.539374] kmem_cachep 0x000000002ce82385 - freelist 0x0000000000000000 - offset 0x508
> [    2.539447] debug_vm_pgtable: [init_args                ]: args->mm is 0x000000002267cc9e
> (...)
> [    2.552800] WARNING: CPU: 5 PID: 116 at include/linux/mm.h:2841 free_pud_range+0x8bc/0x8d0
> [    2.552816] Modules linked in:
> [    2.552843] CPU: 5 UID: 0 PID: 116 Comm: modprobe Not tainted 6.12.0-105.debug_vm2.el10.ppc64le+debug #1 VOLUNTARY
> [    2.552859] Hardware name: IBM,9009-41A POWER9 (architected) 0x4e0202 0xf000005 of:IBM,FW910.00 (VL910_062) hv:phyp pSeries
> [    2.552872] NIP:  c0000000007eef3c LR: c0000000007eef30 CTR: c0000000003d8c90
> [    2.552885] REGS: c0000000622e73b0 TRAP: 0700   Not tainted  (6.12.0-105.debug_vm2.el10.ppc64le+debug)
> [    2.552899] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24002822  XER: 0000000a
> [    2.552954] CFAR: c0000000008f03f0 IRQMASK: 0
> [    2.552954] GPR00: c0000000007eef30 c0000000622e7650 c000000002b1ac00 0000000000000001
> [    2.552954] GPR04: 0000000000000008 0000000000000000 c0000000007eef30 ffffffffffffffff
> [    2.552954] GPR08: 00000000ffff00f5 0000000000000001 0000000000000048 0000000000004000
> [    2.552954] GPR12: 00000003fa440000 c000000017ffa300 c0000000051d9f80 ffffffffffffffdb
> [    2.552954] GPR16: 0000000000000000 0000000000000008 000000000000000a 60000000000000e0
> [    2.552954] GPR20: 4080000000000000 c0000000113af038 00007fffcf130000 0000700000000000
> [    2.552954] GPR24: c000000062a6a000 0000000000000001 8000000062a68000 0000000000000001
> [    2.552954] GPR28: 000000000000000a c000000062ebc600 0000000000002000 c000000062ebc760
> [    2.553170] NIP [c0000000007eef3c] free_pud_range+0x8bc/0x8d0
> [    2.553185] LR [c0000000007eef30] free_pud_range+0x8b0/0x8d0
> [    2.553199] Call Trace:
> [    2.553207] [c0000000622e7650] [c0000000007eef30] free_pud_range+0x8b0/0x8d0 (unreliable)
> [    2.553229] [c0000000622e7750] [c0000000007f40b4] free_pgd_range+0x284/0x3b0
> [    2.553248] [c0000000622e7800] [c0000000007f4630] free_pgtables+0x450/0x570
> [    2.553274] [c0000000622e78e0] [c0000000008161c0] exit_mmap+0x250/0x650
> [    2.553292] [c0000000622e7a30] [c0000000001b95b8] __mmput+0x98/0x290
> [    2.558344] [c0000000622e7a80] [c0000000001d1018] exit_mm+0x118/0x1b0
> [    2.558361] [c0000000622e7ac0] [c0000000001d141c] do_exit+0x2ec/0x870
> [    2.558376] [c0000000622e7b60] [c0000000001d1ca8] do_group_exit+0x88/0x150
> [    2.558391] [c0000000622e7bb0] [c0000000001d1db8] sys_exit_group+0x48/0x50
> [    2.558407] [c0000000622e7be0] [c00000000003d810] system_call_exception+0x1e0/0x4c0
> [    2.558423] [c0000000622e7e50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec
> (...)
> [    2.558892] ---[ end trace 0000000000000000 ]---
> [    2.559022] BUG: Bad rss-counter state mm:000000002267cc9e type:MM_ANONPAGES val:1
> [    2.559037] BUG: non-zero pgtables_bytes on freeing mm: -6144
> 
> Here the modprobe process ended up with an allocated mm_struct from the
> mm_struct slab that was used before by the debug_vm_pgtable test. That is not a
> problem, since the mm_struct is initialized again etc., however, if it ends up
> using the same pgd table, it bumps into the old stale entry when clearing/freeing
> the page table entries, so it tries to free an entry already gone (that one
> which was allocated by the debug_vm_pgtable test), which also explains the

How did you ensure that it was allocated from debug_vm_pgtable ? Trace prints during
its execution and then matching up the addresses ? Just curious.

> negative pgtables_bytes since it's accounting for not allocated entries in the
> current process. As far as I looked pgd_{alloc,free} etc. does not clear entries,
So should they clear entries or doing so would add to overall latency ?

> and clearing of the entries is explicitly done in the free_pgtables->
> free_pgd_range->free_p4d_range->free_pud_range->free_pmd_range->
> free_pte_range path. However, the debug_vm_pgtable test does not call
> free_pgtables, since it allocates mm_struct and entries manually for its test
> and eg. not goes through page faults. So it also should clear manually the
> entries before exit at destroy_args().

Makes sense.

> 
> This problem was noticed on a reboot X number of times test being done
> on a powerpc host, with a debug kernel with CONFIG_DEBUG_VM_PGTABLE
> enabled. Depends on the system, but on a 100 times reboot loop the
> problem could manifest once or twice, if a process ends up getting the
> right mm->pgd entry with the stale entries used by mm/debug_vm_pagetable.
> After using this patch, I couldn't reproduce/experience the problems
> anymore. I was able to reproduce the problem as well on latest upstream
> kernel (6.16).

Seems like a very rare case i.e both to reproduce and also to confirm if this patch
here has indeed solved the problem. Just wondering - did you try to reproduce this
problem on any other platform than powerpc ?

> 
> I also modified destroy_args() to use mmput() instead of mmdrop(), there
> is no reason to hold mm_users reference and not release the mm_struct
> entirely, and in the output above with my debugging prints I already
> had patched it to use mmput, it did not fix the problem, but helped
> in the debugging as well.

Makes sense.

> 
> Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
> ---
>  mm/debug_vm_pgtable.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 7731b238b534..0f5ddefd128a 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -1041,29 +1041,34 @@ static void __init destroy_args(struct pgtable_debug_args *args)
>  
>  	/* Free page table entries */
>  	if (args->start_ptep) {
> +		pmd_clear(args->pmdp);
>  		pte_free(args->mm, args->start_ptep);
>  		mm_dec_nr_ptes(args->mm);
>  	}
>  
>  	if (args->start_pmdp) {
> +		pud_clear(args->pudp);
>  		pmd_free(args->mm, args->start_pmdp);
>  		mm_dec_nr_pmds(args->mm);
>  	}
>  
>  	if (args->start_pudp) {
> +		p4d_clear(args->p4dp);
>  		pud_free(args->mm, args->start_pudp);
>  		mm_dec_nr_puds(args->mm);
>  	}
>  
> -	if (args->start_p4dp)
> +	if (args->start_p4dp) {
> +		pgd_clear(args->pgdp);
>  		p4d_free(args->mm, args->start_p4dp);
> +	}
>  
>  	/* Free vma and mm struct */
>  	if (args->vma)
>  		vm_area_free(args->vma);
>  
>  	if (args->mm)
> -		mmdrop(args->mm);
> +		mmput(args->mm);
>  }
>  
>  static struct page * __init
A quick test on arm64 platform looked fine. It might be better to get this
enabled and tested on multiple platforms via linux-next.

