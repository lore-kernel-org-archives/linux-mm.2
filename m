Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BD7AC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 11:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0286B008C; Mon, 10 Aug 2026 07:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A256B0095; Mon, 10 Aug 2026 07:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4489B6B0096; Mon, 10 Aug 2026 07:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07CE76B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:31:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A150120131
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:31:37 +0000 (UTC)
X-FDA: 85085144634.05.904DEC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7B39C0007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:31:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z2gzkiU9;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786361495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fm9Geb4aGObRV0Z2KKYaRcL9WsVE7Yc5H0R7lBJF+0=;
	b=uGZ8kMkgNxk2D8N+QYRi7GyPxa5z8hK+he/NQ346u3GV5DHvcJcYg4/VfNKnvIpozRejeJ
	X8XxXsvd/rJ7juFg2yUm8BH6ygnMnWqBttEK6KXe/gULsenpU5bqHjGLiSFEnRnXJpgee9
	0Rle12jUhhTe4m8a7TSIuxqY7h1dFx8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z2gzkiU9;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786361495;
	b=UVZ0TlObqOmuLW1dkKUgMmSjycrhIC++emlfjg+w9Nw0ROMqWUHsn5jxY0CaVz3zjdq53E
	L+94DjOUto3WjeeyI+ybOcj87TJ822L5I9fp8l46McMY4eOFM8qN5/MFf907A8eoQFWUYV
	xwq3F5BaFCpp28bVgXHLIT5tfG30e3Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 710FD60A5C;
	Mon, 10 Aug 2026 11:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117261F000E9;
	Mon, 10 Aug 2026 11:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786361495;
	bh=/fm9Geb4aGObRV0Z2KKYaRcL9WsVE7Yc5H0R7lBJF+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z2gzkiU9abLPshsPRB4wWw4tz7bAw/OMuMWm9FY2JVBYHTsR5yzusacKEHuafx80x
	 LQFGXX0tith2Q3iqCGYUYJf/oG03hwJRIaoZ95S1p2RtJLQGgEHMmHPMmoAoj9cSQa
	 /BeZYDjsVvP5AWPE+myCs7Vvt9cUvf5YVtbp3Nx75s5RZl8s6JAGa2eEcI9fHVbYlr
	 xrNA6L64Sxby/IGA1E0ay63iipTu/ExviG3ypGfXAQ4N6q/c8oX0SuX4FZnuaBoXLw
	 sstfV0/5ULHbwL0AQ+FVvbiyMS8VRvjfcNiCQ6QHUqAGKM5jASLilZSkMbxsiKlr4e
	 shivx3hyTA9ig==
Date: Mon, 10 Aug 2026 12:31:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: syzbot <syzbot+d3c6764857d7cac5048a@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in mmap_region
Message-ID: <anm1MJYQ8-NPWrxg@lucifer>
References: <6a778d37.01d0871a.3a0d52.0070.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a778d37.01d0871a.3a0d52.0070.GAE@google.com>
X-Stat-Signature: 7fm97ypcswf5t1zzpwo3ojeyboxbyeia
X-Rspamd-Queue-Id: D7B39C0007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786361495-353482
X-HE-Meta: U2FsdGVkX191gVGGfAlcOnF+4qlQE5w9uZsP01mNhYc3IuEmm8wjl3/vQ3Aa5VkavDI317Zp4mcU2q86Hvu/Erl1sY2ZYdG7PbgTJEGbuGRlFtooICctwwdIfvcR5G/VaxLy2oeuCDgPrwC341Dii6apPcS+uRpmwMTBBUX5nVps4xdul7jrD5Igd0Axc+VCPkRCmwe+x7rZiBg+tvZAv/BIwwL0/wQhaZ+DJVYeca0K1n0JmkyfCsg6XxpEy6dFIyBcYwQqjRJJbn9MosxeEB+bY5GnFIXJkCxhzwVSVumLVAnZFcZhesl7RikshfaUW1OAqSsvVY17hV+hA3dBGXGwq11oozB9VrcLN2WMkB6a8Q6ZWdgGF2zEEaxyR0c30y95LM+/wtVUXdM8LcpW895ytOLgkXYL4VMHM2bhGY8NZsy+k/6S08R97EEtMqAkv1/PDwnmgBE9X6stAkyYS1qp+jTs/wWIbGOzfduwOoBUTso2Ad5P1HK8Iehf6yH3w4zxgbz9U2IV+iQReB6l8apzELkkkqlSuz3LWt+2U5mH/YLtpUVivt8rfEZ6OFDFSGlXCLyxhojSQJ+g3F1r6GXYfFg2ozC9r54c135vCX/2grpzFof9bo69H/Wm6TRdbQ4T9o+PwGwTarurI1h6+A9LBpcW3h+/Wfeyi6oxFNdX0hYP3O8dbr0+tErwFJj7r4AxvbAvwqW0JRUJLsKWYHsM45Ee2qSxw8usLvfOgN2WZlqRW8cXLbmyDQIOZSs1J1FK0vnIPzzIaanQ34Jb3CoB6CCK+mpYgAXbXUBC81FUiiDpeEYERkq+kJWDnP15h1rlaD5vE3G8veFYHypZwxF6b8MmbHIMZ2oxQPnrcp+tcowLfDDgPKhaJo02TFeuLnY18VJG/B81rvnmMNiwwdf7c/iT0Qq70RwQ6KG21b7rqyqgoK9RRpuCLIFlkeug68yaNzd4JcKH5rGuqAf
 bIF21np/
 OMqQW7lCsa6QIWej3r8R3WFRVWbd5EDFx2vQ2TA7UfvjRIs85CeufFHK5CYFVTF0elPhzz+zaQmg6on/Wm65d5TOdfP9g9hzyMDzRH6PAHmaqCHZe90/jUlCreb3Lx+7Ht9J4JgpE7i3X1VgJgMTlPM5K/oJM4aWK9PigBzFYvWgeUJ70WjYkw8H+TuQvdrcM4fEOteB+Y0prXnz3pPM6RoCaxlhce5+S1SO06J/iKDEhLjfbgcrI2RQJppcsu7IMBLp14zS+EAdf3gvIHc4lq/t8l6NCQVsYuxeWVcsbWVuc3rSN8fal+zftpbTuWUvIDD1HEf/fyibpbBhsSf9oRfu89yz/Mnu88cONGIb4vvzAxDr31BuvN1Q7Y4S9gMGrflY+WAm1CCkoNXByS0nGu5cq4zkOhb/3SbYzRLw2BhCzg2xPHOLxlUwpUmYCbBYk8CVObM/BGVMpQvxC62sj5vHsAEaaNODIxIuBocnNzkTtJaW6JAeBTDF2lnIpNmPvezZ2XODCwVgXvovgwX5jMxs/+DBhwyQ0zniVFj4gZn9HS3/qon9Jk+M9w+tfvVFev23YDF0yt/T3esoNjTemqJVmRa4owGXpYZ+WBcsY7L1dct2cC6olqSs0rGXT8hTovkBL16wjJygJba2GGlEavy1Heo6oG3SeEZ6F7b4W2tU57xkj1dhquSFdKk4A6dUYmxQ+ua9r0BLPplhc0KKB/DU1pswGlmi29epSqQ9OqlMQLzTwjEtHME4z2LUY5n/pKOz/B7Q1Nzdm7Dyqu+j7y5mti/6PhCLqTphJhz652qzlFPoxQgrmxbC+ahnUapFOzaSAR+IaaSRNgl81F1Umqu/KUAU8lMLDHUaG3Bf18u5CmYrafa6mv6lUxu3WrTEMg5pk9/+IPId9qXqVeolV3SvBxMzIq0gjVTfS95oO6qGL1SpizyZqjpwz0MLVojyBtwGtoV28zYyZWu2FcR9eSAsJ0/JU
 JCDv26QR
 eQiVMwzf8c+Howdlog90Nd9TjeCdot8ALrffxvSocX0TWL9mez5IMqtZf26Y/Ph2qV4IqyQ+imG8PINWmrK5Z/XuCMUtnmiUxcZ537bn7ecHp1Ptm0OzUzfGL5K2xxiUb2vbpe7owLUWIlIrrcaLKMKmjDm6gEjVxX9yjW3ji6Ii88qVmKiqFQKwD/sKflrQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 01:10:31PM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    1701fda2f58e Add linux-next specific files for 20260805
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=120a0fb9580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1abaff330e312dba
> dashboard link: https://syzkaller.appspot.com/bug?extid=d3c6764857d7cac5048a
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1255d7b9580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/260da702bc71/disk-1701fda2.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/006e50e3e545/vmlinux-1701fda2.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/232c4643654a/bzImage-1701fda2.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d3c6764857d7cac5048a@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> vma_is_anonymous(vma)
> WARNING: mm/internal.h:241 at mmap_file mm/internal.h:241 [inline], CPU#0: syz.0.17/5892

This is:

	/* Hooks cannot mark themselves anonymous. */
	if (WARN_ON_ONCE(vma_is_anonymous(vma)))
		err = -EINVAL;

And this is a known bug that was addressed in v3 of my series (which is
currently at v4) - commit 1701fda2f58e (next-20260805) has the v2 (master has
v4).

Pertinent change:

- Fixed an issue with drivers that intentionally mark vma->vm_ops as NULL
  (using the legacy ->mmap callback). If they do this set dummy ops, which
  is what they meant. The mmap_prepare case is fine as nobody does this
  there and this will be fixed when all drivers are finally converted to
  mmap_prepare. As reported by Sashiko.

From https://lore.kernel.org/all/20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org/

And the stack below suggests this is the mmap path as expected (no mmap_prepare
callback does this :)

So TL;DR - this is already fixed - nothing to see here folks :)

> WARNING: mm/internal.h:241 at __mmap_new_file_vma mm/vma.c:2586 [inline], CPU#0: syz.0.17/5892
> WARNING: mm/internal.h:241 at __mmap_new_vma mm/vma.c:2685 [inline], CPU#0: syz.0.17/5892
> WARNING: mm/internal.h:241 at __mmap_region mm/vma.c:2905 [inline], CPU#0: syz.0.17/5892
> WARNING: mm/internal.h:241 at mmap_region+0x1f8d/0x2460 mm/vma.c:2990, CPU#0: syz.0.17/5892
> Modules linked in:
> CPU: 0 UID: 0 PID: 5892 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
> RIP: 0010:mmap_file mm/internal.h:241 [inline]
> RIP: 0010:__mmap_new_file_vma mm/vma.c:2586 [inline]
> RIP: 0010:__mmap_new_vma mm/vma.c:2685 [inline]
> RIP: 0010:__mmap_region mm/vma.c:2905 [inline]
> RIP: 0010:mmap_region+0x1f8d/0x2460 mm/vma.c:2990
> Code: d6 a0 ff e9 69 f1 ff ff e8 10 d6 a0 ff 90 0f 0b 90 e9 5f e2 ff ff e8 02 d6 a0 ff 90 0f 0b 90 e9 02 fe ff ff e8 f4 d5 a0 ff 90 <0f> 0b 90 c7 44 24 08 ea ff ff ff 48 b8 00 00 00 00 00 fc ff df 41
> RSP: 0018:ffffc900037bf560 EFLAGS: 00010293
> RAX: ffffffff8226adfc RBX: fffff520006f7ec0 RCX: ffff88801d711f40
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000001
> RBP: ffffc900037bfb70 R08: ffff8880122eb803 R09: 1ffff1100245d700
> R10: dffffc0000000000 R11: ffffed100245d701 R12: dffffc0000000000
> R13: 1ffff920006f7efd R14: 1ffff11006c41e09 R15: ffff88803620f048
> FS:  0000555564503500(0000) GS:ffff888124f18000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fa7f9a70000 CR3: 0000000071f6c000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  do_mmap+0xe0a/0x1300 mm/mmap.c:573
>  vm_mmap_pgoff+0x272/0x4e0 mm/util.c:581
>  ksys_mmap_pgoff+0x4dc/0x760 mm/mmap.c:619
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x510 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa7f9b9e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffcfdacab8 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: ffffffffffffffda RBX: 00007fa7f9e25fa0 RCX: 00007fa7f9b9e0d9
> RDX: 0000000002000000 RSI: 0000000000003000 RDI: 0000200000ffa000
> RBP: 00007fa7f9c35024 R08: 0000000000000003 R09: 0000000100000000
> R10: 0000000000000013 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fa7f9e25fac R14: 00007fa7f9e25fa0 R15: 00007fa7f9e25fa0
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

