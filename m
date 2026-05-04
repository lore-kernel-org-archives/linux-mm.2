Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B5BFCD3424
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 00:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9776B0088; Sun,  3 May 2026 20:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A096B008A; Sun,  3 May 2026 20:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FB96B008C; Sun,  3 May 2026 20:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 458816B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 20:14:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C269D1205CF
	for <linux-mm@kvack.org>; Mon,  4 May 2026 00:14:03 +0000 (UTC)
X-FDA: 84727814766.09.C3A0654
Received: from smtp153-171.sina.com.cn (smtp153-171.sina.com.cn [61.135.153.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id AD66F1C0004
	for <linux-mm@kvack.org>; Mon,  4 May 2026 00:13:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=fCpdBCGN;
	spf=pass (imf21.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.171 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777853642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4aSJ/v/RvbXjHG3z7fYTH9GGDSTKWBAD45M2X70Pmg=;
	b=K+856gxaC29G95hQbDieTRh9DKfRQtB/RW6AQr/312ZM2bD0aX+5GN6N2IwId6WIboVX1z
	Bjms+KpBhCfIqzTgbOA4Rw+dqDXs1RBaKSGfT8cK2FEBS1j37NaCofUsBVK2dX9HL4yVC9
	Ly7ma1GH8ynf5UqGPWvCPT9IcG9KNV0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777853642; a=rsa-sha256;
	cv=none;
	b=ytpIyudrkV1C83UNmlbtytSn1obS7VsPMmk0DFDYOBtaVy9et9ct/0EP5pgjvCUE+qOjgY
	/0A/68cx5uPjZ3er8m5aGAMmroDuNlngCZacH6o9LvJ8WCr+VpD76Wrf09vSeTFXTdKFDi
	ZV/hBAsTwD9PamitmfZSlFcPcdWVgbs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=fCpdBCGN;
	spf=pass (imf21.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.171 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1777853640;
	bh=m4aSJ/v/RvbXjHG3z7fYTH9GGDSTKWBAD45M2X70Pmg=;
	h=From:Subject:Date:Message-ID;
	b=fCpdBCGNwVI7puycc7FDMy3WYPPDE9aQ7foou5Mto0QQD9mnc42thYPAUj/4cayym
	 45NI+MX5Oz7UYAWRxrz9/1naYfSXpo/ooFZyRv6AztHA96jyApxIHxUNzFsqBPOqBb
	 Se63ytv7ZYNA/Zvz5pGM5pBkcWcrARNSbp/l7VCM=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.34) with ESMTP
	id 69F7E4BE00004D28; Mon, 4 May 2026 08:13:51 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 8880276292018
X-SMAIL-UIID: 41E3D6F3D43F4283A5B5BD8EC0EE964A-20260504-081351-1
From: Hillf Danton <hdanton@sina.com>
To: syzbot <syzbot+a21650c1666eae7b2aae@syzkaller.appspotmail.com>
Cc: Boqun Feng <boqun@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com,
	vbabka@kernel.org
Subject: Re: [syzbot] [mm?] BUG: sleeping function called from invalid context in vma_alloc_folio_noprof (2)
Date: Mon,  4 May 2026 08:13:42 +0800
Message-ID: <20260504001345.307-1-hdanton@sina.com>
In-Reply-To: <69f735ce.050a0220.312cd3.0031.GAE@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AD66F1C0004
X-Stat-Signature: whagsr5ixywkf57iaryafnttwc3djiks
X-Rspam-User: 
X-HE-Tag: 1777853639-325574
X-HE-Meta: U2FsdGVkX193j5v8YHZEmL/6m5N7Xo59btUlui460SoBLMzpf0WUBZquqoAMtryF+iaxKA+AgzQEhPxKxM5HbHoxZVu6XAa8yOXaqPCgmSiVa3n596RD6IjHlX5zcuN1X7kyCEMF3NKlYSxTs3QkEA5PvdZz9m1rsMy61GRV7v+q0h/o0zQmilPSXJCGEaMSf/rAsPop5JfCT2n8BX5ZKUXUh5Ot/1dsPUh70h1IJQgp0VHmWYVtBozYAgQELqURGMUtdK5B8iCb24y+EQjyccghABuZFS0Sr5wbChumcrEucDd9tkU1yFxZ6F7kXgAyuN5FZU6NFuGfpVsp8UBtVyGZ4LgpJT5vBYxlQCN7NMiaNNDhXGxHFW5M0+f6rsr/EXm5VvHSmE2HsvXXuEVowU9SeXAOiqv6pLReKkY98jbXWeGJJAsar4zLeuUjJOvQaLliWrZplw15Cbuo6g5ylqVaMMQdxFZOfYgb/E0DBoxKOJW6hiAw36SIGf9aETc8dTLegsAUwrhXNeEcla23jtTeF/fNE4rU6JXkfgOfcukH9sSWlR3dfUYOwGdDE0NdwE9Gy0iJGNdgfT1sajlAImPGR20TFNcvMLdZN5D3q2NRV6iKknCj7KYxtmiFpg8bEoUR6NHiHA39DxuEbvFV7/McD19KeWHAjrCvwQSgBtOH7J4p9qU4YHw5KGpLTxXeZCK8fizAM8CtNINhweV3HHmvbuZ3CZGpvTYOlEskIkaDu+XUbqjegtpsNbdRDbASCdRAv9OfrI9DLeEetO5RR+gv28bMkIAgiKPNE5sdzGV91VMrnIQ+nwLKX7RFGZgyZuSi22jGPTaYnmJaM0n/FPvDAc9CXrAZ4aIcoXPzoGde0GroCZwcI7+bPIS+1yh+Axbp4ma/x+EW1xb4JeY8+ygBJ4eFF0ig795BlhTZ1TCPj1qmiAQCq3o83HZBf6MCfcnkpXdJer4atLJf2Ay
 PC6/cu4v
 XY6226it22ZktNoH9Mku01s6UFKOeSJpAWVm3/cfVagdz7rvz7zzhX6KStd1YBe9poy+IoAJmOAumUry+JO7XmOA2JWAH8/6bRhVUIxI4MJIx6EiS/yfzmqiejJDiebcchmgD04gjDErd0792Lu+O14pRp+twPo0CotvJ+ZR2Y+2Xt6Aeh4RZxIcvA9+aCtMU2zp7+jbuexamFIW4tONcHBJFg4GJMcvKsEj2KtLLJLJAxRmSm0LaUr30GeFMGbhWwI1HfIWIKUlgqhXB3GaSsu/mYgIG187isepcXCP41X5Xd0jxyLmsqg5EjcVdHrZTaPSE9VBFdiL9NoNMRm8UbLg2uiBYXagqg52mWShiZr2iTpaWaHtyEcelEVS4uM7/He2ex6069nZxlwWMWN1F9e0yMYwMq02YAOTSeg52uojzxXhW3eDcM+wWeMXgdlG832Q3g4uCASJbyYmeyRi+pzA8WFpTsX315DqvkK+mH/o24PX5O/XgNPOxh7rmH2/KTrhktiSKtjcrLcPpT9E8a0+VgrKG9vwwHFcYpm3dxfvIvHpil+BZmUqdhF8E+MNXE8PDBRLtNUcZlFfeOhB6gvevYBoqGNUUZQ7kmOYu8XeymgHnKIZuqWvaztuwPXeGtDAlI1p+VqkYnQx560u5vqejoknsUxi4vCBhrV3BjsA8a2ApJoaqzayjZ5kQrfbix1Tmn9cm+KG7/rffiE7hXU9TxsRJ2iJ8fN0scqT9P4wFqaZREI7Un4QxBwfJbhlTyehi7PS+2TcJCJO5SsjlBzrT39upoipx9VI001jq/QTnCjoWkG1uJJoR5orZmkMr2XyDmaAPAPtMBZhr/6+xuuEjzg1andSR7afDMBJz5S2zNivNokHDea+0Y8+fszRHtvWjDfwtgRns8A7LTDw/EOvFwBunOiiz3PA4atVaIHCZd/a4m1JebpEXBYxTD6Yp/G3n7KPVewSEycks09x8mKWC5lAD
 Fuu3UW32
 wFbQw3wz1jF7CpFkxsPvUjfr28UUkGAqmUaIFZGQEpNhlub0wblgDeAX5ynosymYQmQzP8/gHglyK9WM+h8GPIeUNfdr+taq73GkWwXFucrhtmmxqfI8ypIgeMAbfsUl/9uTRxaFzVMBD2L2SDsp9+Q3WwyETWoo0hx2UOy4VAgi2gdgA7wYiRexQ7sFCuJf6AhIgKq9rnf1z0bzgC5mYE4eLqA94wuz5N5ubcnGmAVUmK3ma78ub75W75/OGPi6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Date: Sun, 03 May 2026 04:47:26 -0700	[thread overview]
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    dca922e019dd Merge tag 'xsa48x-7.1-tag' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=100242ce580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d0f0911eedbc130a
> dashboard link: https://syzkaller.appspot.com/bug?extid=a21650c1666eae7b2aae
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-dca922e0.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/1e719cb224ff/vmlinux-dca922e0.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/79a541b03a9e/bzImage-dca922e0.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a21650c1666eae7b2aae@syzkaller.appspotmail.com
> 
> BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5665, name: dhcpcd-run-hook
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> 2 locks held by dhcpcd-run-hook/5665:
>  #0: ffff8880243d01c8 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310
>  #1: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>  #1: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
>  #1: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x310 mm/pgtable-generic.c:290
> CPU: 0 UID: 0 PID: 5665 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>  __might_resched.cold+0x1ec/0x232 kernel/sched/core.c:9162
>  might_alloc include/linux/sched/mm.h:323 [inline]
>  prepare_alloc_pages+0x44a/0x5f0 mm/page_alloc.c:4995
>  __alloc_frozen_pages_noprof+0x19a/0x2bc0 mm/page_alloc.c:5215
>  alloc_pages_mpol+0x1fb/0x540 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x36/0x260 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xed/0x1d0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:1193 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x1ee1/0x4350 mm/memory.c:4320

Given pte_unmap_unlock() [1] before wp_page_copy(), the lockdep record
of rcu lock above looks false positive. Baffled.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/memory.c#n4315

>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault+0x1ab6/0x2a00 mm/memory.c:6549
>  handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
>  do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7f5a6f60980e
> Code: df e8 d7 c4 ff ff 48 8d 3d 9c 92 05 00 31 c0 e8 e1 ca ff ff 95 75 24 48 8d 05 5e 9c 07 00 44 89 f2 4c 89 e6 48 89 df 48 8b 00 <83> a0 f8 02 00 00 00 e8 de eb ff ff e9 a8 00 00 00 48 85 db 0f 84
> RSP: 002b:00007ffc0b5c63f0 EFLAGS: 00010246
> RAX: 000055c4ea134910 RBX: 000055c4ea135c60 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 000055c4ea138c30 RDI: 000055c4ea135c60
> RBP: 0000000000000000 R08: 00007f5a6f5b4b60 R09: 0000000000000000
> R10: 0000000000000008 R11: 0000000000000246 R12: 000055c4ea138c30
> R13: 000055c4ea135c60 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> ================================================
> WARNING: lock held when returning to user space!
> syzkaller #0 Tainted: G        W          
> ------------------------------------------------
> dhcpcd-run-hook/5665 is leaving the kernel with locks still held!
> 1 lock held by dhcpcd-run-hook/5665:
>  #0: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>  #0: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
>  #0: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x310 mm/pgtable-generic.c:290
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

