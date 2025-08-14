Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3734ACA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C235A90013E; Thu, 14 Aug 2025 06:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4FD900121; Thu, 14 Aug 2025 06:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75A090013E; Thu, 14 Aug 2025 06:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB87900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:46:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 430DF117B75
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:46:11 +0000 (UTC)
X-FDA: 83775033342.15.F6D8163
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3F5C2C000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:46:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755168369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IIVK3+/oQmeFPwI4Ut9SelhyWIwxiHv6uaV97+15kV4=;
	b=0hqfuNaKCaRgzYBmtfFn72UXfPrMB4gXnjmxx8SDA2WpRdmFp9twlPEwN+GQk+k4kTAZjy
	UaAfh5MW5XEP1F0tdkUheBZnRPI22JvgsZjNJtZHUeD+Tk433eKCQ0hvDFEkevFieW4xLy
	OuHw7DwTXEAbZLAtkmNrh1Qln1cghwM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755168369; a=rsa-sha256;
	cv=none;
	b=d/a80o2N4M4rAe0jOruv+gXqoh4niDDGkehv8IsxJM2EhIA0EZW7SOouSxktWD9HNXg0Gh
	jj5MTVgK/dKlM3wGA+Y+CjwTuXUb5RQsBZhq4wULQLOrHuJdVDH54M00Yv7m4FR2PvgfdF
	XyelhI1CBIZ1N7fR2mXRTmCO8NQuAkY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E56F2113E;
	Thu, 14 Aug 2025 03:45:59 -0700 (PDT)
Received: from [10.163.65.236] (unknown [10.163.65.236])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C23BE3F738;
	Thu, 14 Aug 2025 03:46:06 -0700 (PDT)
Message-ID: <5e5f45c1-e813-4900-8fad-2ed0dc067468@arm.com>
Date: Thu, 14 Aug 2025 16:16:03 +0530
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
X-Rspamd-Queue-Id: 3F5C2C000A
X-Stat-Signature: o5gph6whurk4jahqdsakdirtdewcene4
X-Rspam-User: 
X-HE-Tag: 1755168369-586572
X-HE-Meta: U2FsdGVkX1+/6eaw80rakFq9Z7p3AWfmR85FTyC4yrnmnj2hq/u6iYimx8nAgMDHcCx1ST8cvkHtNMrlf9Eo8x1hp+oZV6tyIQx/2zyggo/LR2DVRrWaHZ8wHAir8zgoinFUuqK2PvDG91QPBd5pU17IJEBpYbktJzCKw0vdOGEumpje1y84u0SeYUxG8mRZEaH79GaBrXRUSfj+SFiEBGZfSY/+RrMhLDBSl2RZrfEdPzRtedqqvBYPM9pDlKmPx8vzt8YL4mf9xG5Q9p/lbIGFi+tne9G/s4+my4TRiKi1Sf3DHhg455mdNpikduRrltqA/rdsUGvXFkHlQY0sDRGtS7hJxwML2if0kVqN/mCdivhSvHYulc+KZf6KrkecGZYcSnHko+8spjw5hRC3QGnf13OP0bzzTDIctcSJZp2ud1MMKEIWS7WKySkQ1hUBoKmXhRrFdfC/wyL9JsN97x2MuGZvE3bc0WUT4XWHQmkNgZYgewE4V7mplwLUk+t1IYsT/0CPWtC1LhFCrIS2iXE4HbOnxUB+BhLa5SbcEmVWK/sf+7m4mQpcOlZVis+pCuPaX60BVVKJvaJVCxEWWNa7ueI0T1jctMthE+EYzT5x2LflXKjIxdoJTFRuuzDeov2MyR3fXaNdP/5Me3pJDaFMr5h1pkWERWcduDl7H3H0ahOpu7ZVUswtHdnmuNwfH2dX91g1WkOSVy2X/msfn/cik4YTv/kuBLjfhnxlUKCk9l1OMQ88Srz0/FSvNiwFcXg4u7Vdrj9DiMH0cS8wSLpfrhka+pwEepdi778MC776zGHkBsRgoucCmQQOWoY4BEmv063PqHlCfzPYtSlusn6pPidvGgQNkt8xsZ62/pRXLMRoR9MuP7I+j6Zvw+LaXT1wSIOy5Q2InBo+ksdnQZ+UEXCOtxZdfGvY4TI8WVzlD5+ePxoa9qZEKVd1MpeBr/RTQCSdLDnctozfh2c
 7etEBYU9
 S5Gs0FXelRZGQEoBuE1jJ3m8EDR28pW04pGVvxWCIvdHTn/8rwZghbp7HMvAD7SubXdeY/l09tgQJ2Yh6msJ7cxJa/Sex0vl8kD0qQTk2H2SMlIVJ3DTGtC50d3hqJLAR5otmUve6Rhv7nKuHsfLYuOqZMFkTfJoIZIHv+IhMUTg1niDroCYEa0znJi/ctbiuGVExbM1ci8Dh5G4Fuc9XuM3Bww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This has been on linux-next for almost last two weeks now and
no problem has been reported. So I guess it's all good.

On 01/08/25 3:10 AM, Herton R. Krzesinski wrote:
> The mm/debug_vm_pagetable test allocates manually page table entries for the
> tests it runs, using also its manually allocated mm_struct. That in itself is
> ok, but when it exits, at destroy_args() it fails to clear those entries with
> the *_clear functions.
> 
> The problem is that leaves stale entries. If another process allocates
> an mm_struct with a pgd at the same address, it may end up running into
> the stale entry. This is happening in practice on a debug kernel with
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
> negative pgtables_bytes since it's accounting for not allocated entries in the
> current process. As far as I looked pgd_{alloc,free} etc. does not clear entries,
> and clearing of the entries is explicitly done in the free_pgtables->
> free_pgd_range->free_p4d_range->free_pud_range->free_pmd_range->
> free_pte_range path. However, the debug_vm_pgtable test does not call
> free_pgtables, since it allocates mm_struct and entries manually for its test
> and eg. not goes through page faults. So it also should clear manually the
> entries before exit at destroy_args().
> 
> This problem was noticed on a reboot X number of times test being done
> on a powerpc host, with a debug kernel with CONFIG_DEBUG_VM_PGTABLE
> enabled. Depends on the system, but on a 100 times reboot loop the
> problem could manifest once or twice, if a process ends up getting the
> right mm->pgd entry with the stale entries used by mm/debug_vm_pagetable.
> After using this patch, I couldn't reproduce/experience the problems
> anymore. I was able to reproduce the problem as well on latest upstream
> kernel (6.16).
> 
> I also modified destroy_args() to use mmput() instead of mmdrop(), there
> is no reason to hold mm_users reference and not release the mm_struct
> entirely, and in the output above with my debugging prints I already
> had patched it to use mmput, it did not fix the problem, but helped
> in the debugging as well.
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


