Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05868CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 11:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED78C8E0003; Sat, 20 Sep 2025 07:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF568E0001; Sat, 20 Sep 2025 07:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5378E0003; Sat, 20 Sep 2025 07:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAAE18E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:52:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46F4B580CB
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 11:52:38 +0000 (UTC)
X-FDA: 83909466396.17.C32BF75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id AB9C11C0016
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 11:52:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I5KVkUJs;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758369156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DsQAuiKSHWSv/2kdYLrHPsfJyhc8yahuL4UP5jLXQM=;
	b=CIrbfCgOhOrWHmbV2ttRBSA5oaCjsaAqxBkyBa5zJnBvi6XgQclPcFOxfg6HKuknyFkjM3
	yWU8shKUrLfzXrm+XstN0rooTxqXjHcmQKQySOcOGYZocQkfu9VsPeKUUExAyfjUGfWQ8M
	fiA8sKuj0CUcMqoPLZAix3tTGNptXPU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I5KVkUJs;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758369156; a=rsa-sha256;
	cv=none;
	b=1ingoTVJhtGtpnuhPVR3FnqQ4yd7kn0QQJ8d4qwRlgVDWqOxlGhy111Vg+MobuCFBdUNE6
	OfJsvBUugNxfjRL3szs9fWtNL7c+h9HJ6Ko1b1JhZ3fANb3AOjC/cqGF3GcG9vJe6b+YoF
	jCsJ1GFLw6Y23e6ftHvUZcE1KDpaE9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D7EE260193;
	Sat, 20 Sep 2025 11:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539D8C4CEEB;
	Sat, 20 Sep 2025 11:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758369155;
	bh=qkFAf6DwfbvkwPeEE8GmREgow0tD/rDTLlcg75UhjAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5KVkUJsJ6sOW1WLVYwww7GETzgpe2Fuq5C5d1dcCwly0ibEse/2+gAyU92bwU1yh
	 VgDLTG+mC5dNEwNqzzuUoY0Aaaq/3zvTGHFJXiznlMF3oEkceyn+yKLVfqR3UgI6yO
	 HimotSfwxxU8K9EUBBkLfchrZZQhI0JGHoEhpXYmuAbdhWPZuQ2K5LzFDZuc3awFYl
	 sU4f4osOmmKxkgq/BsdZQLjQBihW5CMFu1SRoXPoE2lZPWxzalYejzTkyCLJsL8YFG
	 5t+OqHjikr5aABsZpsn6uw6sbjmYoCnbkFDEhQX9+1XUhYWbeytQzZkMaBq2U3jKJd
	 IR+OBSiQuzAxA==
From: SeongJae Park <sj@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	linux-mm@kvack.org,
	Kiryl Shutsemau <kirill@shutemov.name>
Subject: Re: [Patch v2 2/2] mm/khugepaged: remove definition of struct khugepaged_mm_slot
Date: Sat, 20 Sep 2025 04:52:33 -0700
Message-Id: <20250920115233.81851-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250919071244.17020-3-richard.weiyang@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB9C11C0016
X-Stat-Signature: npfs778mo1kcr668wqpmk31zc8uy3rm1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758369156-350525
X-HE-Meta: U2FsdGVkX1/9h34AnM8+OJSaFabwaSSjCC6OOR3L4HM0GbHrijlzYA3yyUbcLZ+7QMSGDykgkn5k7b7y+lovUMF3qN3nkhtxgBf9+aUcjX9o2u9BQCMMwTqC5wztRRsDjCSFoXIU9rM7OIwL3OuYnIT+ehlkOcYVD0PXNvieIuHTjHy10DRQYO+3QMHUS8WSrFDocL8Jqtt2gDnS7C8TD7nT3g8z+XLX7UxhkWjQWU7NNSFSHaOzVXgLuM9ATUGQpOJm7En/qLsAt1hssBzdATEOIYWsyEZZczqWkzjKPBHHFfhFCrJNCxHsFZOZ6OXIXdSSw2caDkehEx2wxb+04Mxw8nRNgmrF2IvAjFIhamUJJNXaRmPlcuyuv5RUzraIKnWix+cBoGWcTxictvDZIcOTWKJs5VkmZF1IcT/vq6tIE7wcTtqTyqxI7iCkujyapv0/DTKq8410/jbJGW7BBQCoMPuCLDMPdpP2EeOGZ1LekjVGCaNbNvVuHdYgpI857upf6e7mauUabFFXRTD+yfjrV7FVN3zdnS6ieeWe0BWj9Rmj4mtft2M04HtL7JVcB9B8oqCkMT2TL4Xwk98lS4X3Rxbd6wzw3yprzXgxa1J7gNTu96wAzt13vQwJtYBJVB3l9M3TxDXaZ7hD3tuKpb1QoOXmgvP1gbU7WC/duhINqQY04EJ+mm9ycUNs78f4ob2NY5OBFRtU5vzkpFipTR3oejkH/ulaejIs+K+9kJPJY2GJvIIdc4KNuO2eBgqiTfteDJE/AHuqdRJ9OfbyQUedr/yD5SBcTj+aHUdT68i5A1XCzJ+CNz9BW1kkR1AfqST6l2abs0a02YkIEZTdvMy9EyN1cDXezSrCanm6qMqptIRmskwp9HOeep3lbRtPldVY8PFz41lyUdUgGyblJouLM28JumWS1SJaYm4aO6wAn/Sv8/z8andpc5OejKTPaiuAQogBvO3Ewu3+ss8
 Y8TXQqPY
 MQxgtb7n467LWSNQS6+/h8J+mbhZuAfDp2xTapBCXmXBvFQwuctnqfV609Mhjt4DVuvJCiwjsLI6RiDEcmIXvSWZIwQ/N16sVOU7MB7C4sHBJW4CyOAUJvnjMJ72e4RVssur2Zzf0yoYEPkL/43tsjMROgITlQLiuvNtWSM36vOrqQNuZtHy3WgNk+Czi35aIpKpcLdeRh+0zCNJGqeteQyA/+e+ASS8LkupG4MPWlbxwW1bEogoDamjbQbiWwUL7YM3ZxlnE5na3DdZXdBxtSN82RxFUHPwYIih2o/QhOIQoXKJdLn/GObZbQ0a7K6BooaNARvBlihhx31/5sBCHQ0Yxgm7Gg0Jj0oDBCK5h5TGT2U9Cs/qlRjef5VON/Wb+Jeip1ZK5f3a16DNkMAKd1Cn3aMUBJlKvIJL6x+S1gOCrgRAUSddNr48hyJNkwSlPj/hYwMuyD078wpAuRJ59JRJW/GpUQyC2SG+HMX8Wwo4rrGo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, 19 Sep 2025 07:12:44 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> Current code is not correct to get struct khugepaged_mm_slot by
> mm_slot_entry() without checking mm_slot is !NULL. There is no problem
> reported since slot is the first element of struct khugepaged_mm_slot.
> 
> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot,
> there is no need to define it.
> 
> Remove the definition of struct khugepaged_mm_slot, so there is not
> chance to miss use mm_slot_entry().
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu.xin16@zte.com.cn
> ---
>  mm/khugepaged.c | 57 ++++++++++++++++++-------------------------------
>  1 file changed, 21 insertions(+), 36 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e019ea2cbab0..88ea92c64bf0 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
[...]
> @@ -2376,7 +2365,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  	__acquires(&khugepaged_mm_lock)
>  {
>  	struct vma_iterator vmi;
> -	struct khugepaged_mm_slot *mm_slot;
>  	struct mm_slot *slot;
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> @@ -2387,14 +2375,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  	*result = SCAN_FAIL;
>  
>  	if (khugepaged_scan.mm_slot) {
> -		mm_slot = khugepaged_scan.mm_slot;
> -		slot = &mm_slot->slot;
> +		slot = khugepaged_scan.mm_slot;
>  	} else {
>  		slot = list_first_entry(&khugepaged_scan.mm_head,
>  				     struct mm_slot, mm_node);
> -		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>  		khugepaged_scan.address = 0;
> -		khugepaged_scan.mm_slot = mm_slot;
> +		khugepaged_scan.mm_slot = slot;
>  	}
>  	spin_unlock(&khugepaged_mm_lock);
>  
> @@ -2492,7 +2478,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  breakouterloop_mmap_lock:
>  
>  	spin_lock(&khugepaged_mm_lock);
> -	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
> +	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
>  	/*
>  	 * Release the current mm_slot if this mm is about to die, or
>  	 * if we scanned all vmas of this mm.
> @@ -2505,15 +2491,14 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		 */
>  		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
>  			slot = list_next_entry(slot, mm_node);
> -			khugepaged_scan.mm_slot =
> -				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> +			khugepaged_scan.mm_slot = slot;
>  			khugepaged_scan.address = 0;
>  		} else {
>  			khugepaged_scan.mm_slot = NULL;
>  			khugepaged_full_scans++;
>  		}
>  
> -		collect_mm_slot(mm_slot);
> +		collect_mm_slot(slot);
>  	}
>  
>  	return progress;
> @@ -2600,7 +2585,7 @@ static void khugepaged_wait_work(void)
>  
>  static int khugepaged(void *none)
>  {
> -	struct khugepaged_mm_slot *mm_slot;
> +	struct mm_slot *slot;
>  
>  	set_freezable();
>  	set_user_nice(current, MAX_NICE);
> @@ -2611,10 +2596,10 @@ static int khugepaged(void *none)
>  	}
>  
>  	spin_lock(&khugepaged_mm_lock);
> -	mm_slot = khugepaged_scan.mm_slot;
> +	slot = khugepaged_scan.mm_slot;
>  	khugepaged_scan.mm_slot = NULL;
> -	if (mm_slot)
> -		collect_mm_slot(mm_slot);
> +	if (slot)
> +		collect_mm_slot(slot);
>  	spin_unlock(&khugepaged_mm_lock);
>  	return 0;
>  }
> -- 
> 2.34.1
> 
> 
> 

On latest mm-new tree, I am getting below error while building UML mode kernel
for kunit.  And 'git bisect' points me this patch.  I'm not familiar with this
code and have no time to dive deep for now, so reporting first.

Oops: general protection fault, probably for non-canonical adI
[  356.456907] CPU: 34 UID: 0 PID: 309 Comm: khugepaged Not tainted 6.17.0-rc4+ #370 PREEMPT(voluntary)
[  356.457702] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-4.el9 04/01/2014
[  356.458484] RIP: 0010:collect_mm_slot (mm/khugepaged.c:1427)
[  356.458904] Code: 48 89 df 5b e9 1a 29 f3 ff 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 908

Code starting with the faulting instruction
===========================================
   0:   48 89 df                mov    %rbx,%rdi
   3:   5b                      pop    %rbx
   4:   e9 1a 29 f3 ff          jmp    0xfffffffffff32923
   9:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
  10:   00 00 00
  13:   90                      nop
  14:   90                      nop
  15:   90                      nop
  16:   90                      nop
  17:   90                      nop
  18:   90                      nop
  19:   90                      nop
  1a:   90                      nop
  1b:   90                      nop
  1c:   90                      nop
  1d:   08                      .byte 0x8
[  356.460685] RSP: 0018:ffffb61a46e37df8 EFLAGS: 00010286
[  356.461115] RAX: e1bca96613f6fe2b RBX: 0000000000000000 RCX: 8000000000000007
[  356.461692] RDX: 0000000000000001 RSI: ffffeba0443b2600 RDI: e1bca96613f6fe2b
[  356.462269] RBP: 00000000000000f2 R08: ffff8ea80ec9aa00 R09: 0000000080150001
[  356.462842] R10: 000000008015000e R11: 0000000000000000 R12: ffff8ea80ec9aa00
[  356.463574] R13: 00000000000001e5 R14: 0000000000000001 R15: ffffb61a46e37e60
[  356.464249] FS:  0000000000000000(0000) GS:ffff8eaf13dd1000(0000) knlGS:0000000000000000
[  356.465070] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  356.465578] CR2: 00007f8e913e2a1c CR3: 00000008cb022000 CR4: 00000000000006f0
[  356.466185] Call Trace:
[  356.466398]  <TASK>
[  356.466576]  khugepaged (mm/khugepaged.c:2519 mm/khugepaged.c:2556 mm/khugepaged.c:2612)
[  356.466869]  ? __pfx_khugepaged (mm/khugepaged.c:2605)
[  356.467284]  kthread (kernel/kthread.c:463)
[  356.467592]  ? finish_task_switch.isra.0 (arch/x86/include/asm/paravirt.h:671 kernel/sched/sched.h:1531 kernel/sched/core.c:5105 kernel/sched/core.c:5223)
[  356.468068]  ? __pfx_kthread (kernel/kthread.c:412)
[  356.468480]  ret_from_fork (arch/x86/kernel/process.c:154)
[  356.468849]  ? __pfx_kthread (kernel/kthread.c:412)
[  356.469223]  ret_from_fork_asm (arch/x86/entry/entry_64.S:258)
[  356.469591]  </TASK>
[  356.469778] Modules linked in: binfmt_misc ppdev parport_pc parport pcspkr evdev joydev button serio_raw sgn
[  356.473304] Dumping ftrace buffer:
[  356.473618]    (ftrace buffer empty)
[  356.473966] ---[ end trace 0000000000000000 ]---
[  356.474506] RIP: 0010:collect_mm_slot (mm/khugepaged.c:1427)
[  356.475142] Code: 48 89 df 5b e9 1a 29 f3 ff 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 908

Code starting with the faulting instruction
===========================================
   0:   48 89 df                mov    %rbx,%rdi
   3:   5b                      pop    %rbx
   4:   e9 1a 29 f3 ff          jmp    0xfffffffffff32923
   9:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
  10:   00 00 00
  13:   90                      nop
  14:   90                      nop
  15:   90                      nop
  16:   90                      nop
  17:   90                      nop
  18:   90                      nop
  19:   90                      nop
  1a:   90                      nop
  1b:   90                      nop
  1c:   90                      nop
  1d:   08                      .byte 0x8
[  356.478405] RSP: 0018:ffffb61a46e37df8 EFLAGS: 00010286
[  356.478935] RAX: e1bca96613f6fe2b RBX: 0000000000000000 RCX: 8000000000000007
[  356.479763] RDX: 0000000000000001 RSI: ffffeba0443b2600 RDI: e1bca96613f6fe2b
[  356.480722] RBP: 00000000000000f2 R08: ffff8ea80ec9aa00 R09: 0000000080150001
[  356.481703] R10: 000000008015000e R11: 0000000000000000 R12: ffff8ea80ec9aa00
[  356.482402] R13: 00000000000001e5 R14: 0000000000000001 R15: ffffb61a46e37e60
[  356.483060] FS:  0000000000000000(0000) GS:ffff8eaf13dd1000(0000) knlGS:0000000000000000
[  356.484027] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  356.484861] CR2: 00007f8e913e2a1c CR3: 00000008cb022000 CR4: 00000000000006f0
[  356.485559] note: khugepaged[309] exited with preempt_count 1


Thanks,
SJ

