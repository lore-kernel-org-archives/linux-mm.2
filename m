Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DB1C87FCA
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 10:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1B26B0088; Sun,  3 Aug 2025 06:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252DE6B0089; Sun,  3 Aug 2025 06:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168526B008A; Sun,  3 Aug 2025 06:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 095556B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 06:27:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D396160A0A
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 10:27:47 +0000 (UTC)
X-FDA: 83735070174.10.516468F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 50D0E40005
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 10:27:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754216865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgoRrGLqeM928/YXpmVFgZgiv4ZlIAwqWNIBZcTEsG4=;
	b=MROhA+fkdNDB0N3FcGBNSP69UuBc7Fv3tUVOgBKNu4gGHDEdK2t7eNheXYBS3i0iEgcam+
	iMIW4eTaffj2a+jy/YCuERyFFihGf+MQqY7KEPAH0TyZxPI5yr0ELBJTrByMTkD/j4oI8v
	WSARIVLjW+TG7QNFcJtyMXVQPylYSYM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754216865; a=rsa-sha256;
	cv=none;
	b=28JcwYDTFjUBUUg/dD9nbpoFpIMIyw+gWDdv55cDN9bYy8QQiPAA1eVl7NsOJ+EtNV7KHD
	SrfFfMirC1xxChkZgyMlNzwpMCVxxHIudcfxNZOa61E0ISjMy2iXBD2iNL4o0925EqEmMP
	QmAc+LIXsxQn3Tb9N11elyEUoIess7A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DC85150C;
	Sun,  3 Aug 2025 03:27:36 -0700 (PDT)
Received: from [10.163.64.123] (unknown [10.163.64.123])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25AF43F5A1;
	Sun,  3 Aug 2025 03:27:41 -0700 (PDT)
Message-ID: <9cbc13bf-bfbf-4108-bbc0-d33d75fe7d18@arm.com>
Date: Sun, 3 Aug 2025 15:57:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/debug_vm_pgtable: clear page table entries at
 destroy_args()
To: Andrew Morton <akpm@linux-foundation.org>,
 "Herton R. Krzesinski" <herton@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Gavin Shan
 <gshan@redhat.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>
References: <20250731214051.4115182-1-herton@redhat.com>
 <20250801135050.c9cc7226938f9f0f4fa3b83d@linux-foundation.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250801135050.c9cc7226938f9f0f4fa3b83d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 50D0E40005
X-Stat-Signature: ada4dnfa6yjxxjettdtfrnhzb6pkn6wq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754216865-998969
X-HE-Meta: U2FsdGVkX18B3UzEJcjEfzR6OUuMSKIHTW8lnqQOcWSAHdek0jDCM3LDnGnxAirYZWweHlDg4FIsbXJybr8bTCmYojKqQ4ViOzQfo9oNrDsTNDXbzwjGo3+Kf0YGj7TSG909XDXHWGzFl+ggjy91Wam92TA8orTfbct185v2MBR0aJ73ZUjbyixkTKUBe07xkGPXhMBaFFv16tpLgcqN3Jq9AdlKxV6hr7kN6R1W3AnpcaOg/iJFL7rkbuJroxTTccSs9wynw9pDV77PDhGtQU+iwz7MYohy7iqK31nAcP7ZUcNGx7kuUaoJxF3DENoJdBTWvtDGfBaH7lvQ0NyGG7UN6gyF66S87SUwgEDEqs6bNFANpbQlIwsPWp9pWjl8r1UHHmjp7+oqLnr3oQz+erJAAbguXT0u8VxfOQufbbBbamIuVDB3Hpi9C77lusJ6D6Tvr4yRL3m7HaK/YJEJ955iB+34x0SXzxxahWKehOZ4HSEVqvT/eGOa4SEVx+fltXO0toD+J4bkagArT60K0/yfTzk17qWU9ZkFbybTo5jHRNTRNlDXNAvoe4SpxNeHzhFaVF4YQD25QpLVirxgoSPm1X1drKZC8XIyiQloze8ZTSiuiDZFzo/9kR65nakmcwnnAHE02XrfO9kpuNc5E5DYG0nDZWDGE+du80mx7wcNu1IwMICyGiu8mPmSzE1leXXL1+sXC1/K2/XmQM2A1drlunalq3RRAwvgJv9O0bV8tEaxw3XFkdCRXif7AvpTPinqC5X+IWgJ+fmOpK7o/34WjH2nc51TLoxpX9dyRBhIyRN2ha3toat1+a3XNoGufCmSdrJIUc8CDblDSrTMlZSIWDU+AryIqgW3NmwBDavIyH3Ze8qeS0DjE3JgJ4T+xAjRkF4o/tUOXcWU5QVqEdW/x7FF121FD0qZL5Rp0LBRgqbhDCbkBSZ+irA1LJXHv5ZBgLPdbxh7BzudEYA
 7WIlnXrJ
 Cfrt2ZQIpciHpk8JyXDep6Tr1bpWVmYFS9n1/hbYnBlhjSTCRX7oezy2+XUPxMNoUN8h0Lg4VhgdkaqA43YV1L7ReLeAM6Dw9Ne1U4z4kKtmgVSNm82OQGtbiAyznyePfRANssKb/Ksr2MCo1Z0C2ZzkH5glEkycaIYaqBpmVS0Xu/n4ZZL4exIMJhqbz7/CTsV7U+KtdgV4NtXYqFjfqHhQU2NrsN1sKhOPA273RlDn6dx4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/08/25 2:20 AM, Andrew Morton wrote:
> On Thu, 31 Jul 2025 18:40:51 -0300 "Herton R. Krzesinski" <herton@redhat.com> wrote:
> 
>> The mm/debug_vm_pagetable test allocates manually page table entries for the
>> tests it runs, using also its manually allocated mm_struct. That in itself is
>> ok, but when it exits, at destroy_args() it fails to clear those entries with
>> the *_clear functions.
>>
>> The problem is that leaves stale entries. If another process allocates
>> an mm_struct with a pgd at the same address, it may end up running into
>> the stale entry. This is happening in practice on a debug kernel with
>> CONFIG_DEBUG_VM_PGTABLE=y, for example this is the output with some
>> extra debugging I added (it prints a warning trace if pgtables_bytes goes
>> negative, in addition to the warning at check_mm() function):
> 
> A quick shot with git-blame led me to include
> 
> Fixes: 3c9b84f044a9e ("mm/debug_vm_pgtable: introduce struct pgtable_debug_args")
> Cc: <stable@vger.kernel.org>

Agreed.

> 
> And `git show 3c9b84f044a9e' tell me this email didn't have enough cc's
> (added).

Sure, that makes sense.

> 
> Thanks, I'll include this in mm.git's mm-hotfixes branch and I shall
> await further review activity.

Right - it will be great to have this tested across other supporting platforms.

> 
> 
>> [    2.539353] debug_vm_pgtable: [get_random_vaddr         ]: random_vaddr is 0x7ea247140000
>> [    2.539366] kmem_cache info
>> [    2.539374] kmem_cachep 0x000000002ce82385 - freelist 0x0000000000000000 - offset 0x508
>> [    2.539447] debug_vm_pgtable: [init_args                ]: args->mm is 0x000000002267cc9e
>> (...)
>> [    2.552800] WARNING: CPU: 5 PID: 116 at include/linux/mm.h:2841 free_pud_range+0x8bc/0x8d0
>> [    2.552816] Modules linked in:
>> [    2.552843] CPU: 5 UID: 0 PID: 116 Comm: modprobe Not tainted 6.12.0-105.debug_vm2.el10.ppc64le+debug #1 VOLUNTARY
>> [    2.552859] Hardware name: IBM,9009-41A POWER9 (architected) 0x4e0202 0xf000005 of:IBM,FW910.00 (VL910_062) hv:phyp pSeries
>> [    2.552872] NIP:  c0000000007eef3c LR: c0000000007eef30 CTR: c0000000003d8c90
>> [    2.552885] REGS: c0000000622e73b0 TRAP: 0700   Not tainted  (6.12.0-105.debug_vm2.el10.ppc64le+debug)
>> [    2.552899] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24002822  XER: 0000000a
>> [    2.552954] CFAR: c0000000008f03f0 IRQMASK: 0
>> [    2.552954] GPR00: c0000000007eef30 c0000000622e7650 c000000002b1ac00 0000000000000001
>> [    2.552954] GPR04: 0000000000000008 0000000000000000 c0000000007eef30 ffffffffffffffff
>> [    2.552954] GPR08: 00000000ffff00f5 0000000000000001 0000000000000048 0000000000004000
>> [    2.552954] GPR12: 00000003fa440000 c000000017ffa300 c0000000051d9f80 ffffffffffffffdb
>> [    2.552954] GPR16: 0000000000000000 0000000000000008 000000000000000a 60000000000000e0
>> [    2.552954] GPR20: 4080000000000000 c0000000113af038 00007fffcf130000 0000700000000000
>> [    2.552954] GPR24: c000000062a6a000 0000000000000001 8000000062a68000 0000000000000001
>> [    2.552954] GPR28: 000000000000000a c000000062ebc600 0000000000002000 c000000062ebc760
>> [    2.553170] NIP [c0000000007eef3c] free_pud_range+0x8bc/0x8d0
>> [    2.553185] LR [c0000000007eef30] free_pud_range+0x8b0/0x8d0
>> [    2.553199] Call Trace:
>> [    2.553207] [c0000000622e7650] [c0000000007eef30] free_pud_range+0x8b0/0x8d0 (unreliable)
>> [    2.553229] [c0000000622e7750] [c0000000007f40b4] free_pgd_range+0x284/0x3b0
>> [    2.553248] [c0000000622e7800] [c0000000007f4630] free_pgtables+0x450/0x570
>> [    2.553274] [c0000000622e78e0] [c0000000008161c0] exit_mmap+0x250/0x650
>> [    2.553292] [c0000000622e7a30] [c0000000001b95b8] __mmput+0x98/0x290
>> [    2.558344] [c0000000622e7a80] [c0000000001d1018] exit_mm+0x118/0x1b0
>> [    2.558361] [c0000000622e7ac0] [c0000000001d141c] do_exit+0x2ec/0x870
>> [    2.558376] [c0000000622e7b60] [c0000000001d1ca8] do_group_exit+0x88/0x150
>> [    2.558391] [c0000000622e7bb0] [c0000000001d1db8] sys_exit_group+0x48/0x50
>> [    2.558407] [c0000000622e7be0] [c00000000003d810] system_call_exception+0x1e0/0x4c0
>> [    2.558423] [c0000000622e7e50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec
>> (...)
>> [    2.558892] ---[ end trace 0000000000000000 ]---
>> [    2.559022] BUG: Bad rss-counter state mm:000000002267cc9e type:MM_ANONPAGES val:1
>> [    2.559037] BUG: non-zero pgtables_bytes on freeing mm: -6144
>>
>> Here the modprobe process ended up with an allocated mm_struct from the
>> mm_struct slab that was used before by the debug_vm_pgtable test. That is not a
>> problem, since the mm_struct is initialized again etc., however, if it ends up
>> using the same pgd table, it bumps into the old stale entry when clearing/freeing
>> the page table entries, so it tries to free an entry already gone (that one
>> which was allocated by the debug_vm_pgtable test), which also explains the
>> negative pgtables_bytes since it's accounting for not allocated entries in the
>> current process. As far as I looked pgd_{alloc,free} etc. does not clear entries,
>> and clearing of the entries is explicitly done in the free_pgtables->
>> free_pgd_range->free_p4d_range->free_pud_range->free_pmd_range->
>> free_pte_range path. However, the debug_vm_pgtable test does not call
>> free_pgtables, since it allocates mm_struct and entries manually for its test
>> and eg. not goes through page faults. So it also should clear manually the
>> entries before exit at destroy_args().
>>
>> This problem was noticed on a reboot X number of times test being done
>> on a powerpc host, with a debug kernel with CONFIG_DEBUG_VM_PGTABLE
>> enabled. Depends on the system, but on a 100 times reboot loop the
>> problem could manifest once or twice, if a process ends up getting the
>> right mm->pgd entry with the stale entries used by mm/debug_vm_pagetable.
>> After using this patch, I couldn't reproduce/experience the problems
>> anymore. I was able to reproduce the problem as well on latest upstream
>> kernel (6.16).
>>
>> I also modified destroy_args() to use mmput() instead of mmdrop(), there
>> is no reason to hold mm_users reference and not release the mm_struct
>> entirely, and in the output above with my debugging prints I already
>> had patched it to use mmput, it did not fix the problem, but helped
>> in the debugging as well.
>>
>> Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
>> ---
>>  mm/debug_vm_pgtable.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>> index 7731b238b534..0f5ddefd128a 100644
>> --- a/mm/debug_vm_pgtable.c
>> +++ b/mm/debug_vm_pgtable.c
>> @@ -1041,29 +1041,34 @@ static void __init destroy_args(struct pgtable_debug_args *args)
>>  
>>  	/* Free page table entries */
>>  	if (args->start_ptep) {
>> +		pmd_clear(args->pmdp);
>>  		pte_free(args->mm, args->start_ptep);
>>  		mm_dec_nr_ptes(args->mm);
>>  	}
>>  
>>  	if (args->start_pmdp) {
>> +		pud_clear(args->pudp);
>>  		pmd_free(args->mm, args->start_pmdp);
>>  		mm_dec_nr_pmds(args->mm);
>>  	}
>>  
>>  	if (args->start_pudp) {
>> +		p4d_clear(args->p4dp);
>>  		pud_free(args->mm, args->start_pudp);
>>  		mm_dec_nr_puds(args->mm);
>>  	}
>>  
>> -	if (args->start_p4dp)
>> +	if (args->start_p4dp) {
>> +		pgd_clear(args->pgdp);
>>  		p4d_free(args->mm, args->start_p4dp);
>> +	}
>>  
>>  	/* Free vma and mm struct */
>>  	if (args->vma)
>>  		vm_area_free(args->vma);
>>  
>>  	if (args->mm)
>> -		mmdrop(args->mm);
>> +		mmput(args->mm);
>>  }
>>  
>>  static struct page * __init
>> -- 
>> 2.47.1

