Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 708B8C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795AA6B0096; Thu, 27 Aug 2026 13:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CA16B0098; Thu, 27 Aug 2026 13:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AAB96B009F; Thu, 27 Aug 2026 13:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 425266B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:50:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B73A7A0156
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:50:06 +0000 (UTC)
X-FDA: 85147788012.01.14BDD57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 212D620008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:50:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWi1wjzL;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787853005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8auLYL/honounuAgEiIEfBufuI789JRuMjZqxnhKg2w=;
	b=b11szctSOCyosmkGX86SZHKTUVa/lIdDEnWVX29QA97Rv5Tv91OYgR+YGxwKunwRfgkWrt
	rOVdDXqDp4fowE1/yLC8jFJon6JhIbMPrq+6c/gUFtnoqAL0oRzB9V/OdhDkvCyIToYRi6
	5UUtCf0t9sb7NcMzkTTzKQNI3wHkW2M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787853005;
	b=FbZi4qr8/owE8+3+nXJU7Gc/hnjbeX0kQZqvR2whq5j7Drf1NkIotpCFmC1bZga9eXZ86u
	NMwcdhLNAd9Hxuhag1wrMejRTf6cTuxPg8AkPdEkO5TU0Ko0KiFBqaNvJcF19ZCrhkJR1z
	TyVzydOndVRVu8vgLub7qpal8lWrLD0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWi1wjzL;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99912600D2;
	Thu, 27 Aug 2026 17:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA401F000E9;
	Thu, 27 Aug 2026 17:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787853004;
	bh=8auLYL/honounuAgEiIEfBufuI789JRuMjZqxnhKg2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GWi1wjzLnDJHypMmFBXTzvinWIOG/rwytTmd21trvbNDlgq6ZMPoslM9XYrKm4jyM
	 o523GOy0ABpOUEHPMC4UnfkRQcDSLdZbUkXM+amrBnJjFATxum44qwtmbQxuu9uM1T
	 FbllLtgmyfpFX14SmNU3IG8onJB7R/3qUVgCjvy3RmK+d3EF6nrAq2D97EWejFP4uy
	 sfUS3v1/437XMe/2I87aIU7yooBfrF16DlTNJRO1abyX7iXyKsZfE2Co58mlwxTJgS
	 LskJB1KlIqGBekVBhPfIa8mmWejOqAo+TgOGAUoAgTUb/HAR5gm+qkvBlzhi7C/n4A
	 2Z3MPvZipQ8dQ==
Date: Thu, 27 Aug 2026 18:49:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: syzbot <syzbot+5c417b73ac02e0e352c4@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in __split_vma
Message-ID: <apB4tHJmDWwpDdnh@gremlin>
References: <6a8ff666.27659fcc.2ceef7.000f.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a8ff666.27659fcc.2ceef7.000f.GAE@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 212D620008
X-Stat-Signature: 879h514bmxpufisk7dzuyd4ctum8xhpe
X-HE-Tag: 1787853004-927928
X-HE-Meta: U2FsdGVkX1+/zhLL1thw741yHQbPGeFPKaSyQYZm6mPUXqkoI12PxGgJ0mt9E7W9vcvchzTgpLXQXVP5au4YNSFuvchIY9o29Xry9nGTur0xenCukqM5pTsJS4BQhxD2cALefGm7EMWCyz8irMh0tOiWMJrSMhGQk/Bd8Rf605BSrV2cv+8/pq4/4GbcfQeXBuYbA/s+DY1vX5syQw4vATEkHDxwJs4i71bpnHFfvActAZtpnKA4yvf0RBfF4PtndurQiv0yKSlwkBAiXntqH+YHefiURxdFiRqdwbVRZ7o/tAZcwys5chQZUvCXfc1uG2/g6JYMkm6ef8IgwWX2WciAShGuke+eRDfH+uYS25jICuV3IoOOLODBT6OFAvrZ87r32HcigTJyQCQDKbK9N3zDPIzNR6oEgHPyJd3AqVa10/v/bREoAZF0usujpC9xTnQyYjuaedK+q7vENbg8eu1iCqx6F1gvmjNyPwZ31R91kxeiNgRFXLyAGzCYumJw6QjkP9bvbuGkgfPrK6OAtyluMu8Tr6wMol0EBd7Me8zqi7BcEVVZXlaj087TMqhxClxFtEl8iYDsy5uI1y2DMPF8BW8NS0G5P0M9V2IReiyuDXW6Lmb2U9uIx511aZYlj83pvQmuxrPdS+0bikSGus5MF3vwRn/2A9lirbxeNkaVsZQPPlhyZftchlz0GeMbFFYKvMKKSKkOxQnz0iMK4s5JVmqO/Eh84ElXh0e7YnbHrGdIKwcMRzltYB2nyW8APIs3F6XARioflShOSGtUnSG8iIkJfUXxpuRJubjvqWK82Nf78FWXmECrGYh0s7lQA652gowaNcbuJegTsofPoaK4O5+l1S5bh2URvCYo3/dLu9/2G4XtGCyVJRH+g1o+S1ixo/FaKqZlVZ69fH/JnrelKBjCpZ7huehMk8KDgU3cfcuYHY6CV7JshqhGzYCFzMPVqsd+1F5QpURonZ7
 HM7sRulL
 OI0OtaBoByvF+FFC3xY+E3llNRSVxWB0S2/LvbZhHP+pJ2tifa/bgps+rhJODxH2yxLm94zZexalaf4Hw65oRtS/6/uEk98KGSJoFVn6psTdNiSpGkylxPw9VdjYl0ar3CY5IoQjJ8NG4qUhEYor7vcc7UaasFBKkzWKMmLiX0Xdz9I0Ag8akuMb1u4SQGA/PgWfwm9SRiiLTq3iOd3/pYF04AW/EjjnkmK6q31DUn4Qe8m5H+IS+hMtOQ5+fZkv2uncFWp72wmhtZuhnkheWSpXrRJEzCQChbiaxiWzlfqfEZM8ayluVsEwZEnUikll2etAZZK7vtRAZjfCMRhIB1s78Cf4eV9IIPLX1SW5yUfGPZIAh5arhZAOMUPsHhrATRp5KJQsx7Nl2psQAfuBx7hXfctcgZqngSdcCc0+JWKDgCiMldLB3C4BMZL3RLyc+Qj4MmD7BTcytx0vzi3ps8FRzy6wAnBHXN+n7xolfYjNqV1FkZlLr7x2pj6EiqTa+ugFrtGcCL+D0S/72EslZWsoSVS0EongYZbtXLTmF7IWDXUgVOreurOPAIaxvERePRJ584r8Z6+XWWbb5h9vqNpI3NKmLhytM4D+CYI3LEdU+hTzo6R1xCxBytfFytnn5Ilz9hawQxJ9zMVZgh4gmF77hfMpV9E9kScT6Hr1NErW1uGOAySVBQj0zyH3v2+0cMnNMOhOwR6XhyPqB3+PMQ02JZThpTvjO6eyVi5EUVomwfYNfMfTM2lavoXovtnedg8x8Rr2Nq34Zm5ckx2blluYZn2lGU16/f2HZi+/QHr8VqVKDp7aHvh6SqA/ruduX/CPfPeIV9AK3vUh9i7WTLRC3gG+gg2yo9BFcST984QJFPM2LC2ma7QqKWPe8QbaRsT+Muomlvw1UUXH2NbMUxMPU4Bt0/6bXEcOMnz4+HhHj0D4/vM9dKCSLpOyEm7SgrT0vWmb5fuDQ9faALhn2yqn1RTpS
 OWUeWGrI
 v3E2IwOyC2H2OFfshbZyt3dgFErtGM2x0KTRIE3zUv/VeswaAk4ayBs3zissM3Wh8Rf8AnwkTYTjz+4JXjXv1YrBoqRQ35YZoarMjNiFVM8mynwSFb/aC9EsjSIVEbDsBNoUGR4p2ovoDHr8AiDBhpS0ArFYEnSc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz dup: [syzbot] [mm?] WARNING in vma_set_pgoff

On Thu, Aug 27, 2026 at 01:33:42AM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1645f979580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
> dashboard link: https://syzkaller.appspot.com/bug?extid=5c417b73ac02e0e352c4
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104a0d49580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f35979580000
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-818bebeb.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6e4100526b12/vmlinux-818bebeb.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/723c4783ee96/bzImage-818bebeb.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5c417b73ac02e0e352c4@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> pgoff != vma->vm_start >> 12
> WARNING: mm/vma.h:276 at assert_sane_pgoff mm/vma.h:276 [inline], CPU#2: syz.0.17/5920
> WARNING: mm/vma.h:276 at vma_set_pgoff mm/vma.h:282 [inline], CPU#2: syz.0.17/5920
> WARNING: mm/vma.h:276 at vma_add_pgoff mm/vma.h:289 [inline], CPU#2: syz.0.17/5920
> WARNING: mm/vma.h:276 at __split_vma+0x1228/0x1800 mm/vma.c:578, CPU#2: syz.0.17/5920
> Modules linked in:
> CPU: 2 UID: 0 PID: 5920 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:assert_sane_pgoff mm/vma.h:276 [inline]
> RIP: 0010:vma_set_pgoff mm/vma.h:282 [inline]
> RIP: 0010:vma_add_pgoff mm/vma.h:289 [inline]
> RIP: 0010:__split_vma+0x1228/0x1800 mm/vma.c:578
> Code: 3c 02 00 0f 85 d3 05 00 00 4c 8b 2b 48 89 ef 49 c1 ed 0c 4c 89 ee e8 a7 3d 9e ff 4c 39 ed 0f 84 bf fd ff ff e8 b9 43 9e ff 90 <0f> 0b 90 e9 b1 fd ff ff e8 ab 43 9e ff 48 8b 54 24 38 48 b8 00 00
> RSP: 0018:ffffc9000344f228 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88803e4b23c0 RCX: 0000000000000000
> RDX: ffff888030d0a580 RSI: ffffffff826cbe17 RDI: ffff888030d0a580
> RBP: 0000000200000003 R08: 0000000000000006 R09: 0000000200000003
> R10: 0000000200000ffd R11: 0000000000000000 R12: ffff88803e4b2410
> R13: 0000000200000ffd R14: ffffc9000344f5c8 R15: 0000000000000000
> FS:  000055555d60b500(0000) GS:ffff8880d5da2000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ff66f270000 CR3: 000000001345e000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  vms_gather_munmap_vmas+0x1d2/0x1720 mm/vma.c:1472
>  __mmap_setup mm/vma.c:2496 [inline]
>  __mmap_region+0x4a7/0x30b0 mm/vma.c:2818
>  mmap_region+0x5a8/0x6d0 mm/vma.c:2921
>  do_mmap+0x12c7/0x1c30 mm/mmap.c:573
>  vm_mmap_pgoff+0x28d/0x470 mm/util.c:581
>  ksys_mmap_pgoff+0x3cb/0x610 mm/mmap.c:619
>  __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
>  __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
>  __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff66f39e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffec1164ee8 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: ffffffffffffffda RBX: 00007ff66f625fa0 RCX: 00007ff66f39e0d9
> RDX: 0000000000000001 RSI: 0000000000003000 RDI: 0000200000ffd000
> RBP: 00007ff66f435024 R08: 0000000000000004 R09: 0000010000000000
> R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff66f625fac R14: 00007ff66f625fa0 R15: 00007ff66f625fa0
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

--
Cheers, Lorenzo

