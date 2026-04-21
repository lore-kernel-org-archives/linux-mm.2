Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 060B8F327CD
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 09:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F9A6B0088; Tue, 21 Apr 2026 05:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420BF6B0089; Tue, 21 Apr 2026 05:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35DA06B0092; Tue, 21 Apr 2026 05:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 262F46B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:32:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3330C3D0A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:32:17 +0000 (UTC)
X-FDA: 84682047114.15.CA9573C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1172214000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:32:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRbLeEEK;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776763936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2ppitpp5MKFrVMm/GrVw59lqqL0cbPnu6Hixo/v5NE=;
	b=G96/YK463Qs4Jk7PZE10KYV10ynM1KZ7tLSbfWX62VoJy06pBsNe0/bioAJ7A3YlIY2fyV
	iixsc4jzeW/C/5U5gXJOn0j3W12ekU3TytKIWsCToexhFPDFaQiX3tzrpAJM0njvAMCRMa
	cgLYAEGKq1n284V+sBpeKqbUahTYU4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776763936; a=rsa-sha256;
	cv=none;
	b=6ZGQiAZaI2ys+Swj4xpco/DQTLiAaX/L/ADZysvkU43YOYUOJjbAmlaeuFaAoO8qUiRUGR
	NMLk4t+lhSUReAP3qOy2lYJf9oWM120veLr+iXIZO2QBfNQRJKgxXA3kiH9oToxDoIXCmH
	ShRGz9VLFupQTHVYeqP7QJ+u8AtmxrA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRbLeEEK;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14F6143E4D;
	Tue, 21 Apr 2026 09:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A9AC2BCB0;
	Tue, 21 Apr 2026 09:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776763934;
	bh=v8CjIjqWakQfGLJy9+I3WeWbMm2v1W7Fx6otO3HpYHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lRbLeEEKRZAxbka+gfmq9QRkcjZLBjw96VbSpNBsha8tZtlX2vwQVytNlaMzoPS7o
	 PACQJXdLsLXVN+HKq53RvMN8MG8Wbh11XP7VtIPL0b17m2+fB4lAlnajH1eDKzWBFy
	 apy/YwK4JAR0HfZo0zWtypU89V99HtFlp+NayRScj/WziyYG7BLg9IXfA/diuG0VDV
	 3ukIIlKmNVMVI+ouQGWwjAPyUE5nPnpjeGzY2vSxPMPuchf61ptfsIP9QRq1p9b20s
	 qdw98/cBkwl111iKBz00MI76YUwlPmDwoo0pTAzcagzEFVbGbxV1SX/H8aKG0RVogM
	 PH0fH21haLa3w==
Date: Tue, 21 Apr 2026 10:32:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: syzbot <syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in vma_mark_detached
Message-ID: <aedB4BJtOtZ3Aqrj@lucifer>
References: <69e69734.050a0220.24bfd3.0027.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69e69734.050a0220.24bfd3.0027.GAE@google.com>
X-Rspamd-Queue-Id: 1172214000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 81kztdw1wfh8np6cdso65cmfoopxr8sr
X-Rspam-User: 
X-HE-Tag: 1776763935-912706
X-HE-Meta: U2FsdGVkX1+VWuVzEU+UhFTpfUrdHRYqOCGi7n2dARv8nFe3f9ktYqC10OmXZzVe23uyOp5uB9cazYEVVj7RNN25megtUC1GRMxEnj+OW4J4lQPOSveCYjWFlR6MBFYiNnehrG03WvUYQv/LmCv5W3zpbujgbprPO0U53cE0SJClorlshujtwd+NdFFpw8k90L8JK4pLiwIpLSjaRqcHXYvBQCYtZ9mwC6mp7l5EsBrwKT5w8YFk0zAzKyfnuiPUlqwsFlzqf1X/zhNOxLyvwXJ9fFE9s0kLEyuB6AhZdeLpCsKeQ6mPG1piIhfklJiW81KlI09LVbgc2SUAn56qTZ9bBgHlnAVuF1L3f6CGqDAQNDrp53y+XKs1phfrmQ+RLtdoNmHRWOeD5g2TWQ65Q51IsS9XuZn20Kkpyivo+9fLTqdXYdDLW7zRwAJRfGn+zD8NMeS1ITGqyAqLXVNxJCzHTZNS92SQPTSrBm6wtFdLPzla5lx+I1WOS0jUG71lsCGKP/ibWzY/1tXV1g3Of4nmpcklk9eZ80yTj3RnLZCp6kCx2j4KrGYlMYCMv09MmSJJaebdPxfO7CKdxmFhTv/3AcWKgzM1yVf53ZeO8fzrk5gCeoQ41EpIAm2fFXC7avgEg9iIHeAys185A4K0Y0y4MJTmwHLjQa3MFQ53UcqhlZem2cahTbtvOvksuctw7xEuIVsu7cABfdHq+KcB0Bn5KinBCvL8WLaNbn3iGwltPaTJaO1fGUK438RqdgdXG60RV9p8cHOzCUEmbYE25EN4TVh6FLF/h5J3aB6WVkt++jrfTxMIF0NMO9poR1t9zooGjZq0XhkkkOJkDkNtbqDckLjQ3AL0WXFF7UvrFKZOhNdf5aQ5MjXMBi3TGhBk5CNS41TepXeldAA0VfW7DrJhKMy8DHz7Eh2msFaXD2N+j3OWdWN1eaG3bcxMnaWLkn9BiBk+LIz/9skTkJH
 w+G1E6T6
 In0PN3zazkaGOIuVFIFuFkKQycdQyqSBSvPbDIhDjNhfMATbXg1ZvkX5mPXrvZINCLsxKLhz76+p5zXteSGMJs6jkt/uuqrz8+vgsQ3Ptux6W4iKejBpjK4JilvkC38hDR42IHRSYM79MvHunfsWvLZUzNYNb3AjjVbJbCYExUb2sp2kmusjIpYYoPiBiPIMgi9F9dxEqUK5GP2HwQ0x+JG7GMqV7iz5pnTyjoGGznMwH+9hC4jDqnA04Yb1cVxs8Q6CCv8h/vgy3lBr9nbM3HTifLaIo9HGw8FLyqeIcoinXSfzagxtnVRva76TANlTjn3rMk71zm9nxPQkRMxzuDRAY+ZC2Wxo7kCJLX/j3wWmjpeZCS5sil4SIVhGY8N9E9euwfWYvOvSryF2KpHSOgK0W40E+7dfMVE5WM4HIc5imqwbf+rU9QzaPC+WvPEboiuiowNMczQx9NHR3zFHVo/9pZ38b7nHiYAA3UFOUinTZjg1lIud3Xil939KypH9sNHcRX8JlMSYfx8CSIU6cZVq7qZuyj+IxtILZeBiadDlefh1wiTx7vG4huNZ2//5a6aLtSA3W23iKOtuLwzCnkGfMPtPSHlyDbO4E9GHyYzJZSRiBrP5EE8esw2Oi7ufsVpqy20m6HRl+KC0JiTP5CwtILUikggwhy72/YAN8YMZ7mmE5VhXCll/Br8/IQnJSr607eSpuGfSAuToPU9IqV7Ee8va+TqbtR4Pi8N6Rm0GaQ0GGpEe6sWLacV2rStuZhvTQ+ZumLSmNoke3VUOx5ke6y1TUchmrtXr+NYuf9twndaPzpnab68YwI75R4UJKssk2TsEJ7QwDGkKv+C8GPZeLeTLuHbdDRr7BevQSNUL0vkOzhN7GUnlKJ89BQOnS7Awjeve/LHDcPrVtIabDvhWDPHs5b4HcK/8L/QANqVjbGfeXXAk1SSwZ6RGgI3GWkHpkTwPRqN/XLmFZNm+fsAl/XlLv
 5OIFiIKv
 ZGTsY5UfFSwtwF99m5qaMJUP4LovA0ml2B3OvKMqL/f+F85iDSb55JwHRmDDSbqLzLFLV0QSoHGPn4Kqr5rMrp/+PeprPRHi0kegHqqRJ77shi3UwCOVeOdB2hNBgTYV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 02:14:28PM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    43cfbdda5af6 Merge tag 'for-linus-iommufd' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17711906580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8195c5b22e79c2cf
> dashboard link: https://syzkaller.appspot.com/bug?extid=db390288d141a1dccf96
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14cd78ce580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161f82d2580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/848e46852283/disk-43cfbdda.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/24283dbdc318/vmlinux-43cfbdda.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f91b3fadd31d/bzImage-43cfbdda.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com
>
> RDX: bbdccba4532b703b RSI: 0000200000000000 RDI: 0000000000000000
> RBP: 00007ffcde93cf30 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007fa5dec15fac R14: 00007fa5dec15fa0 R15: 00007fa5dec15fa0
>  </TASK>
> HugeTLB: unable to allocate vma specific lock

OK so this is the (sketchy) hugetlb 'VMA lock' allocation code, which in fact is
not a VMA lock in the sense of core mm, but rather a hugetlb-specific thing.

There is an alloc failiure injected to do that.

> ------------[ cut here ]------------
> !vma_is_attached(vma)
> WARNING: ./include/linux/mmap_lock.h:435 at vma_assert_attached include/linux/mmap_lock.h:435 [inline], CPU#0: syz.0.17/6011
> WARNING: ./include/linux/mmap_lock.h:435 at vma_mark_detached+0x198/0x260 include/linux/mmap_lock.h:455, CPU#0: syz.0.17/6011

But this is saying the VMA is detached, which shouldn't be the case...

From the below, we're in an mmap compatibility layer scenario, so this is
complicated:

shmat
-> mmap_region
-> shm_mmap
-> compat_vma_mmap
-> mmap_action_complete
-> do_munmap
-> vms_gather_munmap_vmas
-> vma_mark_detached

This then is a product of the VMA being in its incomplete, not-yet-initialised
state, which explains why the VMA is detached.

So I think we need a way of propagating to the mmap_action_finish() handler that
we're in a compat handler and thus the unmapping is unnecessary.

I'll come up with a patch!

Cheers, Lorenzo

> Modules linked in:
> CPU: 0 UID: 0 PID: 6011 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
> RIP: 0010:vma_assert_attached include/linux/mmap_lock.h:435 [inline]
> RIP: 0010:vma_mark_detached+0x198/0x260 include/linux/mmap_lock.h:455
> Code: 01 00 00 00 89 ee e8 57 5f a4 ff 85 ed 7e 4b e8 0e 5b a4 ff 48 89 df 5b 41 5c 41 5e 41 5f 5d e9 7e db f3 ff e8 f9 5a a4 ff 90 <0f> 0b 90 eb 95 e8 ee 5a a4 ff 90 0f 0b 90 e9 04 ff ff ff e8 e0 5a
> RSP: 0018:ffffc90003396df0 EFLAGS: 00010293
> RAX: ffffffff8220ba17 RBX: ffff8880536f8500 RCX: ffff88802baf3d80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff8880536f8583 R09: 1ffff1100a6df0b0
> R10: dffffc0000000000 R11: ffffed100a6df0b1 R12: dffffc0000000000
> R13: ffffc90003397130 R14: ffff8880536f8580 R15: 0000000000000001
> FS:  000055555c863500(0000) GS:ffff88812522b000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2fb63fff CR3: 00000000325d8000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  vms_gather_munmap_vmas+0x6ab/0x1380 mm/vma.c:1458
>  do_vmi_align_munmap+0x2b4/0x4b0 mm/vma.c:1595
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
>  do_munmap+0xf9/0x170 mm/mmap.c:1067
>  mmap_action_finish mm/util.c:1422 [inline]
>  mmap_action_complete+0x480/0x590 mm/util.c:1491
>  compat_vma_mmap+0x243/0x2c0 mm/util.c:1280
>  vfs_mmap include/linux/fs.h:2072 [inline]
>  shm_mmap+0xda/0x200 ipc/shm.c:607
>  vfs_mmap include/linux/fs.h:2074 [inline]
>  mmap_file mm/internal.h:168 [inline]
>  __mmap_new_file_vma mm/vma.c:2496 [inline]
>  __mmap_new_vma mm/vma.c:2562 [inline]
>  __mmap_region mm/vma.c:2771 [inline]
>  mmap_region+0x1ab2/0x2280 mm/vma.c:2856
>  do_mmap+0xc39/0x10c0 mm/mmap.c:560
>  do_shmat+0x8d8/0xc10 ipc/shm.c:1662
>  __do_sys_shmat ipc/shm.c:1698 [inline]
>  __se_sys_shmat ipc/shm.c:1693 [inline]
>  __x64_sys_shmat+0x9c/0xf0 ipc/shm.c:1693
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa5de99c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcde93cec8 EFLAGS: 00000246 ORIG_RAX: 000000000000001e
> RAX: ffffffffffffffda RBX: 00007fa5dec15fa0 RCX: 00007fa5de99c819
> RDX: bbdccba4532b703b RSI: 0000200000000000 RDI: 0000000000000000
> RBP: 00007ffcde93cf30 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007fa5dec15fac R14: 00007fa5dec15fa0 R15: 00007fa5dec15fa0
>  </TASK>
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
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
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

