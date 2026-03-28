Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965F710F3DCA
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 05:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A46226B008C; Sat, 28 Mar 2026 01:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1CFD6B0095; Sat, 28 Mar 2026 01:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932A56B0096; Sat, 28 Mar 2026 01:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83A506B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 01:14:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CC761B93E0
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 05:14:32 +0000 (UTC)
X-FDA: 84594306384.22.71FFA2A
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf23.hostedemail.com (Postfix) with ESMTP id 64DD8140009
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 05:14:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf23.hostedemail.com: domain of 3tWPHaQkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3tWPHaQkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774674870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=KrlfYzGaZgd+YLZ9uL1yPOfSpJdSlyUyCfs6atiEcFw=;
	b=eC63UOCD0Jjvx9CokLSz5gUoZSQ9cJDxg+NNRRPmqUI7nxXYO/o3sf3Y5Ugd0TtG1i24Cw
	urFOtyEtkeuh8ERbPrnGDALVsc9wOft5ZbJ+cXypbsiNBlgWHhhEPKqaq9jCwLba81w23R
	xILZn29DsTiKNX3rlt/EgUw+H8VaahY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774674870; a=rsa-sha256;
	cv=none;
	b=xFa33mo6lbUPjfDiHX0pPSiUnKLncB5QYjChrTT4ZFJ3seu9IJIwdXnJhNFdG+h0dI5djA
	gTd4aQhizlQ2pPONeyrMg+3PeWUQYNIaeAOOdmUgxQD7BuegpeJG0lmSnlXxchAJB3oIYa
	DMlmV13SESCDCFrCDrFm24JLgjTcBrg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf23.hostedemail.com: domain of 3tWPHaQkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3tWPHaQkbAO4iopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-67c7f139d4aso9340346eaf.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774674869; x=1775279669;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KrlfYzGaZgd+YLZ9uL1yPOfSpJdSlyUyCfs6atiEcFw=;
        b=o4w+Whf5gkZqIeQRxhVdgqzddfAAFTiuZ3cEG6IYLygxXeq7G8S397BBpD12b/s3og
         AS4QWJFjfQ154788MoO4UtPPTHvv+IjzutjDSLL6wAnVs7TibW76+zTwiFMjG8kZLByL
         C9IYYbFhDtN2l6OqxFCLQGw3pV4/TmTZrTiZGohfLN9rdz8ZM4VGoVYeB1dHKg3wWdOb
         n5MYXmz4O0J36HcH1SrBgQShtwG1Ljt0hfzytBFnTUHddXVdHJFcCoixeek58mWpYpNh
         6Jq5IFROLHMCKZ1m2M7vdlT+0h4RJP4UpUYyJdPlUg/Y79xDC6Dy26avgMt6GIjilrVB
         SgHA==
X-Forwarded-Encrypted: i=1; AJvYcCWhmVPrTrQwoR2Qn6S8JuHnULm7hZLBkfchAgOm73KNnvch3bwhT1RAf1K4G/l4H5rDgFw8tDdpCA==@kvack.org
X-Gm-Message-State: AOJu0YzOPgPvqTrdhPArrLCVait/0M2OGcbLZGPwNW+rbs0y/Isy3LX9
	anKpDEkQ/M0dShqSnq8AhqZ3QgREZg+npADUiuQCjxtePQgPZ3gfr6cUVpZUpIznYjy8LwxaLDL
	fy1CBpTlqWfbMf8wbtirZzElM+Q9fxjq1uLGNGaatp8kegCNZr/4EjT/91LI=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:99c:b0:67b:c9fa:c310 with SMTP id
 006d021491bc7-67e187726b3mr2714750eaf.68.1774674869418; Fri, 27 Mar 2026
 22:14:29 -0700 (PDT)
Date: Fri, 27 Mar 2026 22:14:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c763b5.a70a0220.128fd0.001a.GAE@google.com>
Subject: [syzbot] [mm?] [cgroups?] WARNING in page_counter_uncharge (2)
From: syzbot <syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, netdev@vger.kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 64DD8140009
X-Stat-Signature: 43bujwu8y5rj5sk6s9t81w1bismc9uqb
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774674870-600580
X-HE-Meta: U2FsdGVkX1+mt9U1KqZuyy8hKIr1sKKKeTK4WZANwPzqOKlJR5B1RLftbkPBXZUgNzUuEcbk9qXVF818bV1+Px8Nub9/i/eKE4Fsk/9bxurD+9f5wH7Vj20E1gl7YaPDIPQLzyPIqhtWVVIDfsdLjLj4JLHn8wWWz4m2CA9ts4rzxIzXai90c8CSbpqIw4VtpPCRiabL7exadZqs1QaYbne4n/hBg/5FJBkJu6fn7gU26qAKkCDu/Or9S7v0yRxfU9p0A7awgTTSUHAGCoXolPji7T3RxhXUX/b3WevZwYybm334l8xnd9Keg7Wxj3IHrstptO5gE8BXDh4lsd2GBzPINfStQ2jKC1bo5AJLkg05C0EMMINQvGdUtUwsQ6VmdnR77PvfxmG2aOySVQYwFdqTGHbuvhaH0HfSRPUv9pPgqEcUIfWCRiynPLUEmqe91mDu+e+66Q/KCECHgL/Cf/0PQxWaWEnWkgU0oOqZk+Ro934OzFoBzGXazsD1arfNpiv1j396LC5M0XLjmFEIz+bmFYWyeeQIMhJmgNDtMni5MH8fBvKSVpXG/+GtOdsfc5zm3bXzTLx/LpEHlhgt1sYlPhBtIJpiDIt+RcU/dV/ULSGOfZES63JjHagi8+hOzqMB1PkeRm3RehGp6RLqSsKD+Zyu+dsXvnyqUf65tzSl8xUI8T88lwnP1oMAmPJZmqvMkL1eBpqBdPzOKoV4YlfLOqMYETvHFx1tY1o9xtN/GZxWqSgxqcLidR4qKszx2xJCCHvlzNbwOqJ7UEew2DLLq6wBzy78ip78aIIapOikLlXFS/rdU9e9qfDIvun4UNHSTEFytoRdKFVfvzVhVK3E8as/xV0eK3wVs6T3c6l+Pa4Ypstlrl8s829mZWQb0tCa30dz52VLwvbdbt8FpRPaCCml0ZHLBb/4u4MU/Ktq7mc3xEHpH4A5dkqZeleLsRG2t+XgRF0NVjS5h83
 /Gc4BIPW
 RFEsm8LnbPz/FMiQodi41PvlVa3RtrMhX8ZYml3PFSgoejtNSEy/nXw/3PWzptg01vge1ziq3JFdE97Y4qzQvomJ2ay4OZjmiZYgJgmnZuGFwrGRl1T6GbO1eVpO+qGhaPQFshI79O+rZOl+W60DjKWSwPQ9jHkrd3ztsfXriFMa7bAwK4VdoqgeQw0gWacjkZLiP9SDblauMnmW1BXiY1tMeIhpN8XfzeHEhhXVfOFYTHfo1O+j9DRl/jqsY0OkX3rgldIaXicDpTrZ5pv3dPgjA6Q0mNKqEYNOogIoGoU7nRxQSC9NbtNmMRwh/0Z9IuKWpApuy5oRB0eS08vCA2aZiUCL3zrc1fqvMHpmqhsy+vq7C2Rt2WdnqBz6X/loA9mry6XBCzcc1s+CMMUSbYfr8cCe96dHIzrdUDZ9EBifz8eRI5Oj2VxN9+88BtEeedlAkdYJVr2sjGXHw/TmkjxOuqjCLPGz6M+dGJAFXPQ/h2njj/NGmD4uiS24rCymUdvWM4Gfy3REjCFrl5nWi7rXVkyiJ9FTK+t5DiiyePmFXz0dSdllNbJO+PUPiyeGi/WIIVVqHyfkiTyMWRFxaGkCPQIjnP7Q3gP+i0G6FafZ7Qyw0nAsnFGe20RaKq+qEO9H4go7MXhERCIqOn+0VG1xYfx6mYDTbFq8zKlhu/x/AuBPhtanI70NbnJtbUjVfQP+V3qef2XSjcl6uA8rdB92fILXDHKg8nc0/KFtuSF0sGpFT5YgwDznCEWSJC90Ub6xLrB1pC5ZoSRfruVXABegF8/BfnGtYn5D3+hjKN0UeqQJnfjFjgzgDzGoNDWD2RFYVeODHUx/ieVhqG+dql4UVioEuy9ZwEKOoePvxwJe8415bHDnsasSZd47AfHjtnXhR9zejQafp786ZKnE/hBJF+OZIqkNJCeyBuiSwSWOBzmk1iooiabPLrt0U+RWpFZczx345QP7vHcPQnKGsW7FI7y+b
 61ws+9Ve
 LdLo4NU6g1BduQZmvw7HpIrw4O9j/HDDBlGb4EKxXSdIGeDs2SDExWIE3pDbc4VY9Sgk/ECynzHKoxROqoOU5XzGdyYR0C0xJqcyyuTS7sQWeKmBWu5n+KTCkhyt4fTldgXkfAOyxcWy1Egvc7RX1Fic0PplWYlWOsSaF/Ni21JdEUXiDexnHUcAM9ga8maiKO9uZevzYOMio1e9ab8Jys06MIdl6DzDI1mImZhHkPpdfydK+qXXkZYv0QzgYV3Yql+9mOWChcII5SAaeHCelLwiDzKpnX0n4fyhhBi8HGp21/xfc+DhKquWKYIJVywj+C7iHgdoVT0lpHUFH3cmY2Nev6HtPhE4y7C5PN6dhL/u9o+26q8IUtQ78SN7WvGw10Pl/JOAihxHMhzo0mFsQpo6wmEZH1mspdYSS8o812eVdOe+yVZqkpRLaexBwfwgQV8f+6Z9gOqMOqRBtPIjaMnOBqYP2ocm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    5597dd284ff8 net: ti: icssg-prueth: fix missing data copy ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17f536da580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6754c86e8d9e4c91
dashboard link: https://syzkaller.appspot.com/bug?extid=226c1f947186f8fef796
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131baeda580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167d6f72580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b6c0ef6a1be9/disk-5597dd28.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/38b971059ff5/vmlinux-5597dd28.xz
kernel image: https://storage.googleapis.com/syzbot-assets/55dd4bd79e77/bzImage-5597dd28.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com

------------[ cut here ]------------
page_counter underflow: -512 nr_pages=512
WARNING: mm/page_counter.c:61 at page_counter_cancel mm/page_counter.c:60 [inline], CPU#1: syz.0.3396/16434
WARNING: mm/page_counter.c:61 at page_counter_uncharge+0xd2/0x150 mm/page_counter.c:184, CPU#1: syz.0.3396/16434
Modules linked in:
CPU: 1 UID: 0 PID: 16434 Comm: syz.0.3396 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:page_counter_cancel mm/page_counter.c:60 [inline]
RIP: 0010:page_counter_uncharge+0xd8/0x150 mm/page_counter.c:184
Code: f7 e8 7c 88 f8 ff 4d 8b 36 4d 85 f6 74 6e e8 cf 3f 8e ff e9 6c ff ff ff e8 c5 3f 8e ff 48 8d 3d 2e ea df 0d 4c 89 fe 48 89 da <67> 48 0f b9 3a 4c 89 f7 be 08 00 00 00 e8 e6 8a f8 ff 4c 89 f0 48
RSP: 0018:ffffc9000da772b0 EFLAGS: 00010093
RAX: ffffffff82376eab RBX: 0000000000000200 RCX: ffff88807c631e80
RDX: 0000000000000200 RSI: fffffffffffffe00 RDI: ffffffff901758e0
RBP: fffffffffffffe00 R08: ffff888032fd5387 R09: 1ffff110065faa70
R10: dffffc0000000000 R11: ffffed10065faa71 R12: 0000000000000001
R13: dffffc0000000000 R14: ffff888032fd5380 R15: fffffffffffffe00
FS:  0000000000000000(0000) GS:ffff88812555a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f14ec9d5ff8 CR3: 000000000e54c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __hugetlb_cgroup_uncharge_folio+0x15e/0x510 mm/hugetlb_cgroup.c:354
 free_huge_folio+0xaef/0x11e0 mm/hugetlb.c:1782
 folios_put_refs+0x553/0x8d0 mm/swap.c:983
 folio_batch_release include/linux/pagevec.h:101 [inline]
 remove_inode_hugepages+0xf50/0x11a0 fs/hugetlbfs/inode.c:608
 hugetlbfs_evict_inode+0xaf/0x260 fs/hugetlbfs/inode.c:623
 evict+0x61e/0xb10 fs/inode.c:846
 __dentry_kill+0x1a2/0x5e0 fs/dcache.c:670
 finish_dput+0xc9/0x480 fs/dcache.c:879
 __fput+0x691/0xa70 fs/file_table.c:477
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x70f/0x23c0 kernel/exit.c:976
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1118
 get_signal+0x1284/0x1330 kernel/signal.c:3034
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f14ebb9c799
Code: Unable to access opcode bytes at 0x7f14ebb9c76f.
RSP: 002b:00007f14ec9d60e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f14ebe16098 RCX: 00007f14ebb9c799
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f14ebe16098
RBP: 00007f14ebe16090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f14ebe16128 R14: 00007ffc404c7910 R15: 00007ffc404c79f8
 </TASK>
----------------
Code disassembly (best guess):
   0:	f7 e8                	imul   %eax
   2:	7c 88                	jl     0xffffff8c
   4:	f8                   	clc
   5:	ff 4d 8b             	decl   -0x75(%rbp)
   8:	36 4d 85 f6          	ss test %r14,%r14
   c:	74 6e                	je     0x7c
   e:	e8 cf 3f 8e ff       	call   0xff8e3fe2
  13:	e9 6c ff ff ff       	jmp    0xffffff84
  18:	e8 c5 3f 8e ff       	call   0xff8e3fe2
  1d:	48 8d 3d 2e ea df 0d 	lea    0xddfea2e(%rip),%rdi        # 0xddfea52
  24:	4c 89 fe             	mov    %r15,%rsi
  27:	48 89 da             	mov    %rbx,%rdx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	4c 89 f7             	mov    %r14,%rdi
  32:	be 08 00 00 00       	mov    $0x8,%esi
  37:	e8 e6 8a f8 ff       	call   0xfff88b22
  3c:	4c 89 f0             	mov    %r14,%rax
  3f:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

