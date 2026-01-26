Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A74C88E57
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 07:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E9B6B009B; Mon, 26 Jan 2026 02:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CCD6B009D; Mon, 26 Jan 2026 02:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0382A6B009E; Mon, 26 Jan 2026 02:00:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E69A36B009B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:00:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8286E160723
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:00:07 +0000 (UTC)
X-FDA: 84373215654.05.48FE258
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A4B7180013
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:00:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=io0Jn+3N;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769410805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hybAGJDtwUTQyBJLSE6cgT3x4CprzyvIGdy1i62DoMg=;
	b=390T9ktp9WmNT5LdRct7awNjMlCriJGRO54yLpiSsgQx4QwMgKxD383UpGUFnhgKh5rNg+
	5dVNe4CjGy9CDGOajfXIhCH+IlsDF7aVXhnddanIoc+cR71V6g62BZal3zdTB80nvwEx/P
	P9XDVu7ygDxZ2rtZ4XLCgqOYvWoAo0g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=io0Jn+3N;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769410805; a=rsa-sha256;
	cv=none;
	b=J15cCLDM6PAH81rACC+eRH37twPn6hGRh9FBoGUPAiMINMbGmYRupxFfofByQkffmVwOG8
	7qzW5iBejzTGIxUrBl9tE0uoItgHyYxTxNJhY6dtVb92u4lGaFHIXJ2MNM+u8vqpwP/1Yg
	tMEa5BUA4yd/HEgw7Yj9rl223lqYcbI=
Message-ID: <646d9b5c-453c-4db8-b578-0f343e170379@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769410802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hybAGJDtwUTQyBJLSE6cgT3x4CprzyvIGdy1i62DoMg=;
	b=io0Jn+3NajuPHPI4XjqNt9sYHPn2FyPfP/1eLMYG5oEK9p8YQ2ayv0ii4eZsQi7AY5Kxh/
	8bRt82NClUXSKr1V31d6I/GqCfQd+DB4Ux8EDoCg31zgpyKNNatRAU/WP75QWfFgYjHG7n
	Oc4aJiIqhIpd+iDcwrxRH5wDMzgILbU=
Date: Mon, 26 Jan 2026 14:59:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
To: Andreas Larsson <andreas@gaisler.com>, david@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 sparclinux <sparclinux@vger.kernel.org>, will@kernel.org,
 peterz@infradead.org, akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, dev.jain@arm.com, ioworker0@gmail.com, linmag7@gmail.com
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
 <9199f28e-e2b7-48c8-b61f-0b787e322443@gaisler.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <9199f28e-e2b7-48c8-b61f-0b787e322443@gaisler.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: 5hg4pcmfs6a7phf9zddseji1fxnk8zi5
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A4B7180013
X-HE-Tag: 1769410805-891652
X-HE-Meta: U2FsdGVkX1/0pcpYMgBNZJCKgVaZQU675FKLbjSp1Ol0Q5sXJPTXDsLHssxQ/73ho4YAXvu4rnQ3SiqghdP31mlakCTsueRw3ifXTfZ9oy1YqQfP6X9GtyR4HRagHQmZOnjufEO03pPRLseKg1dNL+5vMvuduBpzx/PpvDjdpihb0oZKu8iOdOoEGBNMTlZChIuLRi2O7U7E2DWSPZwJbwBoyAGxZ74n1KjD7PXloPKDSDkAGP6fwqe6EWWWPZXFaxHGXmwa42xRUQqQePu4XN1ivl453zaqxsRt13pIST589J37L+Tb7Wk+oTDULk4Kc/E3bW+5ePD9wpyjvaAqmDn+lldZpJxXVKyr/bVONS53CQEC2ZUN33oGo/mXLzm8hmw7nziwYzxJcGDkeLyI0o6n6gBLInjTdhGJiQaWoMmqPa97o68gqpUTIeXfo4LsEjzs3vPfgByQ1fIdEQOXHVuMAJASLlsS38AQg9CySu+kszrwaet8ul1NPZw0tTZbm9MBsa5cX/gzA9uncCWDV3AZDYwwB7wlkL+NySlycwvygpXyO3Wx9KxnoDczZYWgsPGhxmzYsgGazmWb8nWuovuIazjl6EoGDjm1NI+gnY+N0uLQEBO2hlrAhhf2L1hAKari7Ti1JTEVHBPm8ReTyf1w+WegmzGKFMhWx8/sElHpVHo5l3v8WrU0E/RlpBmJFnGudQNqTLdmZQUyup9mUYQiaiElv/1pdNNhkKVnfQOmnB+4KQGvVRnKKozF2PG6VvetG1vf1iy2sCZn6pGjwymeg8SBNfMnLVxGZej1khnkRRE8Rys/XPqitRDJLDN4xPh1o1Io1fFBtgDlvAEREcMUkeOxl4RaiPRwMLJNidISIlOwy23+Lcuk04nDkL9rGk4IPEn7jki/uc5vcYDFS6XyA4pBHk6ffsn0HH2EdibH5NQtfudq3h5eXL301wQLmorvKRXlhK27vb2d6DP
 izN0UfNP
 KA/zWqRE4EEsWwFaES7KbpCinXzgB7h5ypQEyCP+7NXgMoMWYfauQvFqgwQhHcrx4Ztzpjxq7BSj4E8MLxDvFGxw8Fe3ynwfmvc31SLK/SamNdne1btZfHNoV6/FyJvAQuUD/uwrcIzLAwwE9OpVAOYK6U7LPL3U73kgj0ALwm7DP7eo5nFOUd3kWY6JxTEvOzyV436dIhYY8spD7ooUjavW65SYA7/PooEhyj0aJdaFHvYd4+MmFrcFJUQ05gd67c/GdfZwD2+UU5Mogwl4juwjK/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/23/26 11:15 PM, Andreas Larsson wrote:
> On 2025-12-17 10:45, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The PT_RECLAIM can work on all architectures that support
>> MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>> MMU_GATHER_RCU_TABLE_FREE.
>>
>> BTW, change PT_RECLAIM to be enabled by default, since nobody should want
>> to turn it off.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   arch/x86/Kconfig | 1 -
>>   mm/Kconfig       | 9 ++-------
>>   2 files changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 80527299f859a..0d22da56a71b0 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -331,7 +331,6 @@ config X86
>>   	select FUNCTION_ALIGNMENT_4B
>>   	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>   	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>> -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>>   	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>>   	select SCHED_SMT			if SMP
>>   	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index bd0ea5454af82..fc00b429b7129 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>>   	  The architecture has hardware support for userspace shadow call
>>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>   
>> -config ARCH_SUPPORTS_PT_RECLAIM
>> -	def_bool n
>> -
>>   config PT_RECLAIM
>> -	bool "reclaim empty user page table pages"
>> -	default y
>> -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>> -	select MMU_GATHER_RCU_TABLE_FREE
>> +	def_bool y
>> +	depends on MMU_GATHER_RCU_TABLE_FREE
>>   	help
>>   	  Try to reclaim empty user page table pages in paths other than munmap
>>   	  and exit_mmap path.
> 
> Hi,
> 
> This patch unfortunately results in a WARN_ON_ONCE and unaligned
> accesses on sparc64:
> 
> $ stress-ng --mmaphuge 20 -t 60
> stress-ng: info:  [559] setting to a 1 min run per stressor
> stress-ng: info:  [559] dispatching hogs: 20 mmaphuge
> [  560.592569] ------------[ cut here ]------------
> [  560.592663] WARNING: kernel/rcu/tree.c:3098 at __call_rcu_common.constprop.0+0x200/0x760, CPU#4: stress-ng-mmaph/568
> [  560.592777] CPU: 4 UID: 1000 PID: 568 Comm: stress-ng-mmaph Not tainted 6.19.0-rc5-00127-g62fc9f6ccb97 #8 VOLUNTARY
> [  560.592805] Call Trace:
> [  560.592812] [<00000000004368b8>] dump_stack+0x8/0x60
> [  560.592844] [<0000000000482a60>] __warn+0xe0/0x140
> [  560.592878] [<0000000000482b64>] warn_slowpath_fmt+0xa4/0x120
> [  560.592901] [<0000000000526a40>] __call_rcu_common.constprop.0+0x200/0x760
> [  560.592931] [<0000000000526fd0>] call_rcu+0x10/0x20
> [  560.592954] [<0000000000730838>] tlb_remove_table+0x98/0xc0
> [  560.592986] [<000000000071bec4>] free_pgd_range+0x224/0x4c0
> [  560.593021] [<000000000071c35c>] free_pgtables+0x1fc/0x240
> [  560.593042] [<000000000074a6f0>] vms_clear_ptes+0x110/0x140
> [  560.593068] [<000000000074c3dc>] vms_complete_munmap_vmas+0x5c/0x280
> [  560.593094] [<000000000074de5c>] do_vmi_align_munmap+0x1dc/0x260
> [  560.593117] [<000000000074df80>] do_vmi_munmap+0xa0/0x140
> [  560.593142] [<000000000074fb2c>] __vm_munmap+0x8c/0x160
> [  560.593168] [<000000000072cfd4>] vm_munmap+0x14/0x40
> [  560.593190] [<00000000004402a8>] sys_64_munmap+0x88/0xa0
> [  560.593221] [<0000000000406274>] linux_sparc_syscall+0x34/0x44
> [  560.593274] ---[ end trace 0000000000000000 ]---
> [  560.593960] log_unaligned: 209 callbacks suppressed
> [  560.593979] Kernel unaligned access at TPC[526a4c] __call_rcu_common.constprop.0+0x20c/0x760
> [  560.594121] Kernel unaligned access at TPC[526864] __call_rcu_common.constprop.0+0x24/0x760
> [  560.594198] Kernel unaligned access at TPC[52b3c4] rcu_segcblist_enqueue+0x24/0x40
> [  560.594275] Kernel unaligned access at TPC[526860] __call_rcu_common.constprop.0+0x20/0x760
> [  560.594360] Kernel unaligned access at TPC[526864] __call_rcu_common.constprop.0+0x24/0x760
> [  567.054127] log_unaligned: 1105 callbacks suppressed
> [  567.054167] Kernel unaligned access at TPC[526860] __call_rcu_common.constprop.0+0x20/0x760
> [  567.054331] Kernel unaligned access at TPC[526864] __call_rcu_common.constprop.0+0x24/0x760
> [  567.054410] Kernel unaligned access at TPC[52b3c4] rcu_segcblist_enqueue+0x24/0x40

Thanks for your report!

On sparc64, pmd and pud levels are not of struct page:

__pmd_free_tlb/__pud_free_tlb
--> pgtable_free_tlb(tlb, pud/pmd, false). <=== is_page == false
     --> tlb_remove_table

So in __tlb_remove_table_one(), the table cannot be treated as
ptdesc because it does not have an pt_rcu_head member.

Hi David, it seems we still need to keep ARCH_SUPPORTS_PT_RECLAIM?

Thanks,
Qi

> ...
> 
> I bisected to this one on mm-unstable from approximately 2026-01-12.
> 
> The warning is from
> 
> 	/* Misaligned rcu_head! */
> 	WARN_ON_ONCE((unsigned long)head & (sizeof(void *) - 1));
> 
> in __call_rcu_common() and the unaligned accesses follows from there.
> 
> Regards,
> Andreas
> 


