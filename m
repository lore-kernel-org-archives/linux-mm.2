Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E08EBCAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 16:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3768E0005; Sun, 21 Sep 2025 12:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3828E0001; Sun, 21 Sep 2025 12:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB93A8E0005; Sun, 21 Sep 2025 12:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C59438E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 12:07:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 523111A035F
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 16:07:44 +0000 (UTC)
X-FDA: 83913738048.29.7B28F06
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3EA0E1C000B
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 16:07:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dgEHK0ci;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758470862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zjoLSQR9f5Kz4CSDXR4Q0rh7rP7KG7CUswa5U48yEU=;
	b=kfPmqWR/eXiDXQqMmm4SHj+5lB3ZMMdetNBP8pwn6EjtADJldKBI8VYQPkKKwpSq/gDNKW
	FVfpdQtNVxNdkqSGu1iCTJrPap2wYmGzkMFlEWqQnnSjBR60lTE3D9pdrfL6JjSI9xSNvq
	2w1w9wQwfm6dp+o8RgUP56HJUb17Xi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758470862; a=rsa-sha256;
	cv=none;
	b=hyYRZttu1XIsnGRXi35We5F+cueG2PmSZjdJTz6j/zmbyN01tGCUHyR8aMrl7rNE3b9KxP
	9oqRsUTOuV7DCvAnuUk2HFcVcaxFHWJrqQ33nQcBPts0dn1MSPSy3C7Q2fDM99cVgbWSqI
	eJ24Yqvad8Jr7wAmM4MIaziPd5pUrLg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dgEHK0ci;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c4df52c1-f873-4e2c-ae7d-f66bcf6e2fbb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758470859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0zjoLSQR9f5Kz4CSDXR4Q0rh7rP7KG7CUswa5U48yEU=;
	b=dgEHK0ciIbIudJEIyl3aaie5hHexffWZQHoHY3E9ldawsQ6aKs/Z6ExnzwR9dDNaCkToRy
	wNrPzXvOdgnxmdS4b8/SUhFQMINJ/zTp/W9+/k36UgzToCcSfiGDXuNcCiyWhOy0MGlQsW
	4EDMuVrUdiZBVsFUaTu9jqPnIk3cR/o=
Date: Mon, 22 Sep 2025 00:07:32 +0800
MIME-Version: 1.0
Subject: Re: [Patch v2 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
To: Wei Yang <richard.weiyang@gmail.com>, SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, xu.xin16@zte.com.cn, linux-mm@kvack.org,
 Kiryl Shutsemau <kirill@shutemov.name>
References: <20250920115233.81851-1-sj@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250920115233.81851-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3EA0E1C000B
X-Stat-Signature: d7n7bopgk9xgr34obp9gkud7rt1unkto
X-Rspam-User: 
X-HE-Tag: 1758470861-86624
X-HE-Meta: U2FsdGVkX18MX8bmO37Rw57QpMnBmZT70W+f9Hk2rk6VzaYDTSR365T0BwxFZWs7ngI3s+8zynBUSNfD0mvPV6sY3tp1Oi+ic4iS/CB04+3ogslfG+sUDatRCZqtn9XFiCB/OqfkH3o3YUdUW9NpSOlQQQZkUt+KeRm5oqnhChiAl4HoTHUXbv7tJpHlyeHwFuer4NBjcpbR0Laxgmg9xAlgdhlXQ7DshFmpnj1pG9AqOJ8aLomoFszbFzWjizkBDPMuh7nMrN2dU7nXEx/kEW70YoTJzrdD286YzXMIlRlhmJdXHAeSbqZHukkAMTLoHjO9KUj3C/9MsKTm06VUSsowF9u5OBUj9pMZACi8SUKxPzcV0rqhTUT4HnFOQlizeorLaMBZukEnOdKG+EYRwrWVvBxK8YSfVQPfN6O8DPrLsSh6645tX0oeXuSpZIIaUsCV79KpG21/gNNEwpUgWZ2mHwqq07OU0E1M4ULZvwhzHjqnUxy/igQboMvEcoBzUdY/rScRMHH7HLdMsbbe6CFZdLE9awnZ5TjAMtz7TOlwfcNpB5Obh7Q7oCVJzlGAnixry9q4jI4XRCC/x6Rz9vbo+0NQZttnmzonNqa7E6A9G4Pr6T0kuA35+vgOvQ/TNT4EftxwdYQtSXsa6QPEp+NgSK2hc05gdfU9g8szQ0g8AEXXL5o0RnX9z+RcIrjW5kuSRnNFAlMFPn2Y5z4JwhJ/lkexHdkGMBFiomozg6Lb8WFUGqZ0S2avMM3fp36Sz/hBew7aeBhVrY+JTANkxbq3QNGCjPG/1EnXyToVpng0wTxmVVRCP+SvOnUM5yqQMgUupdY+38yod10lKN4gZnslvMW5B0io5eSr14UvXcMT8Fo0uWJ1FmxixoRpPAk54qSVgGNs/sqnkD4wQsu1OGyXLfv0pGlSG6gc7fVOrn0/QbrJn12MaQ1sTeK+TI1HFUDzoZM81/g7kUluHeD
 NjjvK6Wj
 IOjNqAjhqoRFhyXEmUNX4+n4QVE1nm7Wc3W6VK/ZPrcsaN8OwaGlVtlGPeY4elNfrFTZpgW3XyySKlBAhp6o6abIeSuZzSrVP20mjb6/Bg1nMGCnv+mudL1YLz6rfhGwgVuhbxspXthKSPWKFjaeLtWnxPLyjF2x6V0Oe1RcIPRZNiAOVVnpY6rT8YUthe+om5ZFod4NEbTeANBcmz2RGCyGjW4a/q7dtvc7qkkX1mv+UIr1bEMq3/bEXPy3ve0KE8JKepR+UawVX8C5B5t9Az6tUv9VVGC07b2gaSYqP/0Xk2BoBLZXVZ5KW9jTSHzBLjM+bbtryaBBno0snSJlVEeIDltUgBVz094cC5MXGwA9TTEkf5AevjTCglW5ancf9Fiq8gqose3K/g8ty6jnraJrt5SzmkE6HcalN2KcAuyTa/36i6SAbGQxLtukeRAJJfOnASW3hAA8iIJJADOAo71ewuLhm9puM4JZrehDJX5V/7Dk8AiMi9+Onyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Good catch!

Looking at the crash report, this seems like a use-after-free bug
introduced in khugepaged_scan_mm_slot(). See below please.

On 2025/9/20 19:52, SeongJae Park wrote:
> Hello,
> 
> On Fri, 19 Sep 2025 07:12:44 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
> 
>> Current code is not correct to get struct khugepaged_mm_slot by
>> mm_slot_entry() without checking mm_slot is !NULL. There is no problem
>> reported since slot is the first element of struct khugepaged_mm_slot.
>>
>> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot,
>> there is no need to define it.
>>
>> Remove the definition of struct khugepaged_mm_slot, so there is not
>> chance to miss use mm_slot_entry().
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Kiryl Shutsemau <kirill@shutemov.name>
>> Cc: xu.xin16@zte.com.cn
>> ---
>>   mm/khugepaged.c | 57 ++++++++++++++++++-------------------------------
>>   1 file changed, 21 insertions(+), 36 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index e019ea2cbab0..88ea92c64bf0 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
> [...]
>> @@ -2376,7 +2365,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   	__acquires(&khugepaged_mm_lock)
>>   {
>>   	struct vma_iterator vmi;
>> -	struct khugepaged_mm_slot *mm_slot;
>>   	struct mm_slot *slot;
>>   	struct mm_struct *mm;
>>   	struct vm_area_struct *vma;
>> @@ -2387,14 +2375,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   	*result = SCAN_FAIL;
>>   
>>   	if (khugepaged_scan.mm_slot) {
>> -		mm_slot = khugepaged_scan.mm_slot;
>> -		slot = &mm_slot->slot;
>> +		slot = khugepaged_scan.mm_slot;
>>   	} else {
>>   		slot = list_first_entry(&khugepaged_scan.mm_head,
>>   				     struct mm_slot, mm_node);
>> -		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>>   		khugepaged_scan.address = 0;
>> -		khugepaged_scan.mm_slot = mm_slot;
>> +		khugepaged_scan.mm_slot = slot;
>>   	}
>>   	spin_unlock(&khugepaged_mm_lock);
>>   
>> @@ -2492,7 +2478,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   breakouterloop_mmap_lock:
>>   
>>   	spin_lock(&khugepaged_mm_lock);
>> -	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
>> +	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
>>   	/*
>>   	 * Release the current mm_slot if this mm is about to die, or
>>   	 * if we scanned all vmas of this mm.
>> @@ -2505,15 +2491,14 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   		 */
>>   		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
>>   			slot = list_next_entry(slot, mm_node);

In the original code, we used two distinct local variables.

1) struct khugepaged_mm_slot *mm_slot:
mm_slot consistently pointed to the item being processed in the
current call.

2) struct mm_slot *slot:
The local slot pointer could be advanced to the next item.

>> -			khugepaged_scan.mm_slot =
>> -				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>> +			khugepaged_scan.mm_slot = slot;
>>   			khugepaged_scan.address = 0;
>>   		} else {
>>   			khugepaged_scan.mm_slot = NULL;
>>   			khugepaged_full_scans++;
>>   		}
>>   
>> -		collect_mm_slot(mm_slot);

At the end, collect_mm_slot(mm_slot) correctly operated on the
original item for that scan.

>> +		collect_mm_slot(slot);

However, this patch merges these two into a single slot variable.

When slot = list_next_entry(slot, mm_node); is called, the slot
pointer is updated to the next item.

Passing this new pointer to collect_mm_slot() then causes a
use-after-free on the following iteration, IIUC.

Cheers,
Lance



>>   	}
>>   
>>   	return progress;
>> @@ -2600,7 +2585,7 @@ static void khugepaged_wait_work(void)
>>   
>>   static int khugepaged(void *none)
>>   {
>> -	struct khugepaged_mm_slot *mm_slot;
>> +	struct mm_slot *slot;
>>   
>>   	set_freezable();
>>   	set_user_nice(current, MAX_NICE);
>> @@ -2611,10 +2596,10 @@ static int khugepaged(void *none)
>>   	}
>>   
>>   	spin_lock(&khugepaged_mm_lock);
>> -	mm_slot = khugepaged_scan.mm_slot;
>> +	slot = khugepaged_scan.mm_slot;
>>   	khugepaged_scan.mm_slot = NULL;
>> -	if (mm_slot)
>> -		collect_mm_slot(mm_slot);
>> +	if (slot)
>> +		collect_mm_slot(slot);
>>   	spin_unlock(&khugepaged_mm_lock);
>>   	return 0;
>>   }
>> -- 
>> 2.34.1
>>
>>
>>
> 
> On latest mm-new tree, I am getting below error while building UML mode kernel
> for kunit.  And 'git bisect' points me this patch.  I'm not familiar with this
> code and have no time to dive deep for now, so reporting first.
> 
> Oops: general protection fault, probably for non-canonical adI
> [  356.456907] CPU: 34 UID: 0 PID: 309 Comm: khugepaged Not tainted 6.17.0-rc4+ #370 PREEMPT(voluntary)
> [  356.457702] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-4.el9 04/01/2014
> [  356.458484] RIP: 0010:collect_mm_slot (mm/khugepaged.c:1427)
> [  356.458904] Code: 48 89 df 5b e9 1a 29 f3 ff 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 908
> 
> Code starting with the faulting instruction
> ===========================================
>     0:   48 89 df                mov    %rbx,%rdi
>     3:   5b                      pop    %rbx
>     4:   e9 1a 29 f3 ff          jmp    0xfffffffffff32923
>     9:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
>    10:   00 00 00
>    13:   90                      nop
>    14:   90                      nop
>    15:   90                      nop
>    16:   90                      nop
>    17:   90                      nop
>    18:   90                      nop
>    19:   90                      nop
>    1a:   90                      nop
>    1b:   90                      nop
>    1c:   90                      nop
>    1d:   08                      .byte 0x8
> [  356.460685] RSP: 0018:ffffb61a46e37df8 EFLAGS: 00010286
> [  356.461115] RAX: e1bca96613f6fe2b RBX: 0000000000000000 RCX: 8000000000000007
> [  356.461692] RDX: 0000000000000001 RSI: ffffeba0443b2600 RDI: e1bca96613f6fe2b
> [  356.462269] RBP: 00000000000000f2 R08: ffff8ea80ec9aa00 R09: 0000000080150001
> [  356.462842] R10: 000000008015000e R11: 0000000000000000 R12: ffff8ea80ec9aa00
> [  356.463574] R13: 00000000000001e5 R14: 0000000000000001 R15: ffffb61a46e37e60
> [  356.464249] FS:  0000000000000000(0000) GS:ffff8eaf13dd1000(0000) knlGS:0000000000000000
> [  356.465070] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  356.465578] CR2: 00007f8e913e2a1c CR3: 00000008cb022000 CR4: 00000000000006f0
> [  356.466185] Call Trace:
> [  356.466398]  <TASK>
> [  356.466576]  khugepaged (mm/khugepaged.c:2519 mm/khugepaged.c:2556 mm/khugepaged.c:2612)
> [  356.466869]  ? __pfx_khugepaged (mm/khugepaged.c:2605)
> [  356.467284]  kthread (kernel/kthread.c:463)
> [  356.467592]  ? finish_task_switch.isra.0 (arch/x86/include/asm/paravirt.h:671 kernel/sched/sched.h:1531 kernel/sched/core.c:5105 kernel/sched/core.c:5223)
> [  356.468068]  ? __pfx_kthread (kernel/kthread.c:412)
> [  356.468480]  ret_from_fork (arch/x86/kernel/process.c:154)
> [  356.468849]  ? __pfx_kthread (kernel/kthread.c:412)
> [  356.469223]  ret_from_fork_asm (arch/x86/entry/entry_64.S:258)
> [  356.469591]  </TASK>
> [  356.469778] Modules linked in: binfmt_misc ppdev parport_pc parport pcspkr evdev joydev button serio_raw sgn
> [  356.473304] Dumping ftrace buffer:
> [  356.473618]    (ftrace buffer empty)
> [  356.473966] ---[ end trace 0000000000000000 ]---
> [  356.474506] RIP: 0010:collect_mm_slot (mm/khugepaged.c:1427)
> [  356.475142] Code: 48 89 df 5b e9 1a 29 f3 ff 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 908
> 
> Code starting with the faulting instruction
> ===========================================
>     0:   48 89 df                mov    %rbx,%rdi
>     3:   5b                      pop    %rbx
>     4:   e9 1a 29 f3 ff          jmp    0xfffffffffff32923
>     9:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
>    10:   00 00 00
>    13:   90                      nop
>    14:   90                      nop
>    15:   90                      nop
>    16:   90                      nop
>    17:   90                      nop
>    18:   90                      nop
>    19:   90                      nop
>    1a:   90                      nop
>    1b:   90                      nop
>    1c:   90                      nop
>    1d:   08                      .byte 0x8
> [  356.478405] RSP: 0018:ffffb61a46e37df8 EFLAGS: 00010286
> [  356.478935] RAX: e1bca96613f6fe2b RBX: 0000000000000000 RCX: 8000000000000007
> [  356.479763] RDX: 0000000000000001 RSI: ffffeba0443b2600 RDI: e1bca96613f6fe2b
> [  356.480722] RBP: 00000000000000f2 R08: ffff8ea80ec9aa00 R09: 0000000080150001
> [  356.481703] R10: 000000008015000e R11: 0000000000000000 R12: ffff8ea80ec9aa00
> [  356.482402] R13: 00000000000001e5 R14: 0000000000000001 R15: ffffb61a46e37e60
> [  356.483060] FS:  0000000000000000(0000) GS:ffff8eaf13dd1000(0000) knlGS:0000000000000000
> [  356.484027] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  356.484861] CR2: 00007f8e913e2a1c CR3: 00000008cb022000 CR4: 00000000000006f0
> [  356.485559] note: khugepaged[309] exited with preempt_count 1
> 
> 
> Thanks,
> SJ


