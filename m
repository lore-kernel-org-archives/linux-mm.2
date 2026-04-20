Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 807D5F5A8BC
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 21:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9206B0088; Mon, 20 Apr 2026 17:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AAFB6B0089; Mon, 20 Apr 2026 17:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BFF96B008A; Mon, 20 Apr 2026 17:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACFE6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:36:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED9D81A0AEF
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:36:23 +0000 (UTC)
X-FDA: 84680243046.05.D4B5E29
Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A86C14000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:36:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of 3VZzmaQkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3VZzmaQkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776720982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ptLfAn3MhmEj6CBoEOsP94Qs16PUR2cMjXJj5E5I4cY=;
	b=MPZQtsUjBXDhJcLrOLZG7ONxa67UNdlFGHhkl71yrcNISj3OwQcFjG94BmJSzKP/n3uxFx
	L1WM6FdX+xCKUQA1MrRThd8zG776+ru/K4nn3xxZG4EGGd5Yp7LiLPrHr7FuM+AHG+64iF
	/WbAWaJq+slUqN4aP9nQSLzrD3yC/gk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of 3VZzmaQkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3VZzmaQkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776720982; a=rsa-sha256;
	cv=none;
	b=kK7vJhFMrcuKCN58tBC6/5abdZ3nCd+QKrmqjy74/Cgzp9v0ebnqROGjkd0VFUqIxAheaB
	yymlkP+fllir5eiyXU6iLQrIWyYhDIzWSjFsSZDOdh+6mCONoEyUFUBMkssAsuKfBWzpj6
	6cscd3VNXS+Mjbx3ZwdFKipUnwPqrfM=
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7dbe11b1f03so7499580a34.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720981; x=1777325781;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ptLfAn3MhmEj6CBoEOsP94Qs16PUR2cMjXJj5E5I4cY=;
        b=QEB7Gh+lbyeXACNlL0iesN+z0xeHCf9KR5YGYGHO8Xtw86yJWoiHZtxdAWrnuBNHtC
         Aq3HuT/Fu5h2XSfFJm3+WMbpywzxzlYyDQsGjlLEgggxR8miF0jd4hUhKzCLrQ7N2trx
         2/jzKSESCoKXZArOHFL2zavx3a4Lfyz9Xy50uQa9Tuwm/Mzkd67+bZnKvQsBDoQg3QML
         RZO+hIySmu1LILpJ6soN0Yom/EX0RXoBt+KtkGDiSX7iIT76SwFKSRzJfpaDbxIuEurp
         qD4pO7gp676mvu4rDpkbkkjPQ/FJTsYs2J4qZiEaS/pjW0EWFB4frRovpSVVKZsmlHJp
         DJVw==
X-Forwarded-Encrypted: i=1; AFNElJ/Pv4a3WvAvASGtm6RZ+oaO8xMZGn20NJ9lcXIa6lr2T0HtnjhPb4qHtjBtWpPLpksOB8gnvutWOQ==@kvack.org
X-Gm-Message-State: AOJu0YxrhEI0tjUHRkCcrLR2/jiObmPQxras2LQDEaLg2jsF6LdHaZda
	1fwRxPsMx/Z8TRyq+TUpz4Apk2YEXiD7LumFYxRpn4GZotRP/zMk7FloTN/sXIBfti1jvq5JAxn
	CjRG15nK2uBlV5/LBRWgFcaqO4qoyHRwPPfE2TJx0d+uAwuRWamepfq3vOfU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:162c:b0:689:ceb5:6f38 with SMTP id
 006d021491bc7-69462de1bdfmr8077832eaf.5.1776720981320; Mon, 20 Apr 2026
 14:36:21 -0700 (PDT)
Date: Mon, 20 Apr 2026 14:36:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e69c55.050a0220.24bfd3.002a.GAE@google.com>
Subject: [syzbot] [mm?] BUG: sleeping function called from invalid context in __zap_vma_range
From: syzbot <syzbot+4cc5bc01fb4a179c4ffa@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tt3hndirtjys5z9fmzwoskwi6xwjgs8c
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A86C14000F
X-HE-Tag: 1776720982-258823
X-HE-Meta: U2FsdGVkX1/rWllMhL/W21MbEO8axum0IP/UhOe/EUyhhdeuVpHUg8g9VVE73KAY34xAbsVIFBxJdpd1qyKjAdXx+9SjGG5QH7fkrCmnx9hvmAhpWTZrVWoiIDNDpsaNKKlYctw3t+JyHpvSE4rAekB5Cu2G3LUlPUTCJz08wLQ0mx2E5m0Vf0qvFgWyB7JDamohJq60rdOCtSzNyWZWVI3wcq+a6ZSO9P23v6tbSBsDtKJTsg+I0VBUCV9iAETS2qrC5u6HAIYBplYmg8m6KCiUm4m+rqeyylCKoQAqkB6HuY0xIH7VrZ2nD0objMo2Zn0GifImPZrxokEN7LQ9TxX5Onu/0oZNI14tUw2VRXQwJqLTAflgx4mXlaGiGZJS7PMUy1p91xj+GwejZLUyIKgn8xLw1Pk+BPBbHS9OKnJk78LjxYOa56Kbuppu0XTS6dTQoDxhWAzfoqMqP/FkCD+5YtCgxDhQlVgosTpyzjJrMVJVXl14QlVwzHEvpkVUlVkO8Q5lYWMhcN2iveN2Ucl/pEG9Z9TL0G2A2yELoQg05AQLKIhDxcjYSUk4JWPTiwIbBMVBclJOkOUoEsIird3luQcIe/PZO1KJ4HYDjjkoDKUUFQ7XELjgo29+DGqzUfKSHR+xxbGNz1TJk/tJ3zfANsCmNbxd7O9i0JVL7/g9vd/iRVKR05Q+N8/SYKgPLm6k8MnjvJ6x4tstsK3km7lvPK6Q25hTBl1/nM7cTMR1Td/5o/MjVmE4mai+i3Z84+8S2lM0HAcWQXjpJDjoHqK3Jw7KhNYhkGK3noUenDiAky+g5qOk21dnvtsRMdZXLWB7OB9Lga3P+7iWopxcEpLFzgpgRYNErXFugb+pInkbuke/brb6bnVBQF8/4kusu4rPmoS2XhdxTkRK9lRxhhNdNKUEq4uHB/WSbbOU3Ip+ArNB5+cQM+y0aw0LLvAVNV6Se+A35H5LuA+/D+f
 Ke0odjRD
 XphrosCpOb99tcWb1kmWJfT9x9SGpRVqDn+VKDEIrFuvCclmR0Lsvjqv9L4p3mndFxj+uNZSB6dt1TyYdGexFSE1NT8kTUoZAn3/i2FTaX2eL+TzXluH6GncDVMJ9TfUEYebnHCKPKZN0nUTnGyAhJ0HuahEKSbRf8Gxkx/lEhYMqDgFvox5r7pwWLqd1yWifWuFPJbvpZodWybdHdnTzMYe070fgaBkTnTyhfinunDLluM1IrNMJjHpUI4ScCQp3SrrpBueVtuEX0NavlNZi4vz2Hz1AqCvJtOxlrGn8Wa4poFpJ0pBg68kNgPuSdnp0QArYjpoOyrqj1CsDTJzHPO6DE94Jtpfg78BTDcWur7Snwnq08CumgOlXK1EUgA0hK6xeUUXpca9649pEkuZMuATw8j4JpajWzSmacflvpAxvhkxj16wxDISHdL5xot3k1pD/H834eitz5ak4LhibvxN5CSF9cAR4OAebgWe/oi6B0KiCUCM7EQKYH54nQ9veZ9D8UfcFQgCPDeH95JJ9GvOF3XjtiIqYU/amKOB7N/okDZnjNSC51/HQGyA6pCErnQcLf5G7y4c7vxtpHxd45p8Naip9LftgNtpdZLH4TbAXKLpdYaxbbjfsAYrPPLVMM+joQSfW3c76nrSbd7yX3EzHSDwheNew8VZ+6BT/QzqMs3e0h/gwvCJ86op9ShM9raPXLyQU9L9h+3KAJ9ZVv2QoDw2EKceAa/s952tamUVZ/4vnzKf/CH6JOPmfVe25Amg7hW1RxmghD8GOZDYjcKjyR+BJzcVahlJsWucNWe+33l0HOtxVg5a1/6bHPynZInr2tb1//FD8m96LH0F9kZOSFi246RG+AjblcVWdHhODX3cNI5e0SkjX8WFgHaNZqjRPEXhzBy6D/NvVjTWqUYUCJv5Juo5EKlQk8W0bxe6IgeLEKmLOxMwkM9fvi1iJdtzmActJ/UJMo8IxbEyx9mPozjtF
 wWs6A/PZ
 1fb4Fg+viN/2xDVCNsxzzVLv7rUGtC9p20J7qhz+Wn0WNj4oUidlMnpUiAV7k27NJFWIqZbKTXz/96jKtiY7nFhPKjDhbEhdlkUOpUKBLdI1lNGYvdNFRPAutj/uc+G+P/tHWuq5yyFRT4klkTJ6Crox/1BWG2xIcPeaBsqJp9ctjOoZ7okHeUffjXc+f1exLNhNYQQ6rHWiRCM2ecG+sECLdHjCoy70lcOZv7HsFJjG5kt8IMSEw1Agh0wxLXjOxSwzJb8sEKDuX4Apwrl5388pZWaO6rFd3vavcSp3xJBGSHosNtCbswoR8bOOxUITycK17wtUPFJgVaTHCeDCyzn8V/HTlcHAEq9bu+Oix1LDWJmmVAveE9txOCFxwMeFU6xgz8xo/7WzWvm0aLk6j5TIL/m3yFjOL6Zx2GiwoPXk4XU5d3VJIgZmYypg1cJuhtYlchN3KNKwwTA5xKwVBUhyBqGruZbH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    c1f49dea2b8f Merge tag 'mm-hotfixes-stable-2026-04-19-00-1..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=142514ce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a29a582d8ced859
dashboard link: https://syzkaller.appspot.com/bug?extid=4cc5bc01fb4a179c4ffa
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c1f49dea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/402c79548d6e/vmlinux-c1f49dea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1bc39526d7f4/bzImage-c1f49dea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4cc5bc01fb4a179c4ffa@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at mm/memory.c:2007
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5913, name: cmp
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by cmp/5913:
 #0: ffff88801b8cc078 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:592 [inline]
 #0: ffff88801b8cc078 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x124/0xa10 mm/mmap.c:1284
 #1: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #1: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #1: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x310 mm/pgtable-generic.c:290
CPU: 3 UID: 0 PID: 5913 Comm: cmp Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 __might_resched.cold+0x1ec/0x232 kernel/sched/core.c:9162
 zap_pmd_range mm/memory.c:2007 [inline]
 zap_pud_range mm/memory.c:2032 [inline]
 zap_p4d_range mm/memory.c:2053 [inline]
 __zap_vma_range+0x184b/0x4bf0 mm/memory.c:2093
 unmap_vmas+0x299/0x5f0 mm/memory.c:2162
 exit_mmap+0x1ef/0xa10 mm/mmap.c:1300
 __mmput+0x12a/0x410 kernel/fork.c:1178
 mmput+0x67/0x80 kernel/fork.c:1201
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x833/0x2a60 kernel/exit.c:963
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1126
 x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fedcf5c96c5
Code: Unable to access opcode bytes at 0x7fedcf5c969b.
RSP: 002b:00007ffd9f5f73c8 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fedcf6cafe8 RCX: 00007fedcf5c96c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
RBP: 0000000000000001 R08: 00007ffd9f5f7358 R09: 0000000000000000
R10: 00007ffd9f5f71f0 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fedcf6c9680 R15: 00007fedcf6cb000
 </TASK>

=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W          
-----------------------------
cmp/5913 is trying to lock:
ffff88801b8cc078 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock include/linux/mmap_lock.h:536 [inline]
ffff88801b8cc078 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x22c/0xa10 mm/mmap.c:1308
other info that might help us debug this:
context-{5:5}
1 lock held by cmp/5913:
 #0: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x310 mm/pgtable-generic.c:290
stack backtrace:
CPU: 3 UID: 0 PID: 5913 Comm: cmp Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4830 [inline]
 check_wait_context kernel/locking/lockdep.c:4902 [inline]
 __lock_acquire+0xfa4/0x2630 kernel/locking/lockdep.c:5187
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
 down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1625
 mmap_write_lock include/linux/mmap_lock.h:536 [inline]
 exit_mmap+0x22c/0xa10 mm/mmap.c:1308
 __mmput+0x12a/0x410 kernel/fork.c:1178
 mmput+0x67/0x80 kernel/fork.c:1201
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x833/0x2a60 kernel/exit.c:963
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1126
 x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fedcf5c96c5
Code: Unable to access opcode bytes at 0x7fedcf5c969b.
RSP: 002b:00007ffd9f5f73c8 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fedcf6cafe8 RCX: 00007fedcf5c96c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
RBP: 0000000000000001 R08: 00007ffd9f5f7358 R09: 0000000000000000
R10: 00007ffd9f5f71f0 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fedcf6c9680 R15: 00007fedcf6cb000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

