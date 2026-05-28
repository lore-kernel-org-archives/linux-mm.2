Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1156ACD5BC9
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 01:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D36A6B00A8; Wed, 27 May 2026 21:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 183F26B00A9; Wed, 27 May 2026 21:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A4E6B00AB; Wed, 27 May 2026 21:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEE146B00A8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 21:12:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1B9DA056B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 01:12:32 +0000 (UTC)
X-FDA: 84815053344.25.0789687
Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	by imf09.hostedemail.com (Postfix) with ESMTP id F2C69140008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 01:12:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 3fZYXagkbAGAQWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3fZYXagkbAGAQWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779930751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=9TEmRizXMIbGZYx1Ws9m3mt6dQBmNYp3px/KVX87cR4=;
	b=uWoScYOEze5vXLJcd5mJuvehOBMo/G3Jht/zA23dkuD1z9jB1FD7HTOQ4xKPwKNhh6ul5m
	DEqh+646WD2q8qRjQG9cz66UpNWc6nS/fCuqb5e+vKc4iquvPTiPSYsY/+L3iAZAppF6r7
	U/x8pQbaGKYb8PZZb75jtBqXjMC0Cn0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 3fZYXagkbAGAQWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3fZYXagkbAGAQWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779930751; a=rsa-sha256;
	cv=none;
	b=MrMhYcPG5iL19GQFnH2u0TqmaBU+fZ7zmPhxC0ARTmUfSbXluqnGKpVri/cHIck5vAgyzU
	amkgw02rg0UltOr5oPo9JXlLZhqb8NaWom3NqxrfRIFwZNCWa23yENAcYzydgE7pG+CmH1
	YX89Lu27DvWy7g9aPmpKmJhJy4kJLLo=
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7e666c30bdeso2391309a34.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 18:12:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779930750; x=1780535550;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9TEmRizXMIbGZYx1Ws9m3mt6dQBmNYp3px/KVX87cR4=;
        b=NFuRCOeJckChTJ7Vks7NsJ+pRHX+9cpp1xMVg6S/axV3RkNMtvrTN1W7WZGt1Dxled
         Td0ppCaHk4V88td4hAZxp5nN2tSPKvqzABXvB7M5eBcedkQA5ucwdt/FY5waYLSjeR+O
         isFjJ7WJ97KbKKkG/qE/tJNmk62o0VpVWPfdDN6K6twyQVo5s1hfaHpDnQ0p/l8Xphcz
         9Mlg917+dLF3lJCnYNxrdJwDBujeMt12qaBMdf64hmTkBNHEhNTNb7XF7yAbrVhCf6qq
         4RsrdB4C5xxn3cB571gJuXtHWDU/M3ytoKbn8I0lew8++WulaZWkxHpYZV7Yv5lZsZ6u
         dkjA==
X-Forwarded-Encrypted: i=1; AFNElJ8mqQSGtoBM5dHQaDWhooN6np56BcS4Ns3VKUy4RTOBlKMccPmiGJy3zfed4tFsfDB5m1ych2DULg==@kvack.org
X-Gm-Message-State: AOJu0Yz82tptzGtdEUDEBtQymiBMsDmRR2L06jLJ2DGqwYO12Hw+iyUC
	QRhsnSnAjB0hbr2/kxN6vkrzYuS15g8US2f6ahAPoR5moKe45d86Zu0yXidA31bO34zqbn53Vwy
	6iBScCQZWMClW3Idd4A5zS9qCJfh2Kk9ZhNKP64pj9n6OSEALvbyYkdwPLeQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:221d:b0:69d:e3b4:4e1b with SMTP id
 006d021491bc7-69de3b44f12mr2974690eaf.55.1779930749986; Wed, 27 May 2026
 18:12:29 -0700 (PDT)
Date: Wed, 27 May 2026 18:12:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a17967d.5bfaf17f.38d970.0000.GAE@google.com>
Subject: [syzbot] [cgroups?] [mm?] INFO: rcu detected stall in clone3 (6)
From: syzbot <syzbot+774c2dfaebdf78f984c5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F2C69140008
X-Stat-Signature: dd9c4gixdc91qnz1zxrr8iruhsyx6stg
X-HE-Tag: 1779930750-218422
X-HE-Meta: U2FsdGVkX19KLImTT6MELdDGSEcMo6/V7uV4HsO557Yp6toQj4GD/5JBK189jmMmD9NkMbOK9u8GtwYPPt5RfYXY7ZU6xPttdaI3K1x5N0alyoXoq+pGN3lll3uxW4O/AIrqe1w2Su08BD+XsZpPTDne9fyx5dp+ssIclibjxE7qzM/Caso3spT88E4kIrByHK/9B2CgTLMr6AvPhG/uwF9kEl2Jc6yVCq6Rr68l7eAcVVWsy6QEFcXke8yLXS/5gYK6OQDGGzV4xeZFB+gqKpWXVFhztPxFvvSiQOGc/HzmTGgHK8yipa31F2KWuWMVLCK3vwEg9+j+exfDNIMrlKdNP8tjhzCxl9vnh+r7b7uBeBB+3lTkC+klXMi31c1r1M8Jhvv6McZMTkLxWJ5OsHnFwyvYOvwWBwv7dL/eK7tn5vUXxTwAD3yICM4QSOYphh3glUv4Lj83tz2dpZ8rOOPd4oQuyFXsR1BaAYmUlFFpPTCIjfQsZoqXiL1ulFxpD6tHKrKd036xNABqiY9almdH1T0f3MELB7T50jKQrNte6eXyuqUXYeEnH9iQd0d2Zhg0DUlXeGy8vpqPSX1j0HwhG/TOkBO75kBfhHb7DLkZFSejsV5Wi2m4Ks/4gFlXGMm1T+yLHrIGUmJn5Fag+PGnmLLu8cbKhm4sDdu2IFRZgie9l7kAPcp/4VV0aYws7GIVXF+aFRYbMPJYjLGfpiZkIX4YF6Hs9ZPfPnNklCxccxcNSoRRFJQ/Uf69fNk0kblg1YtMRaZxPkPVFgqf6Jkf/wFwrHlwaZ9ykvpRc7Um6vnmN1enR10D/5afWAxm7j9MBnXhBdKSFH+f0R+ib5Xw3f0qFp8Jyhbfktmu48bmkMre7MOgJAf0XOGmJNsTJu1j4VJSOLzZHdtUqqOdOglDtcNP19Mx6hz+7L3AMbyRI9nwDRLipsgLczJS/0A+ZUirCRg7kVlvo/VSwtB
 qsOvuf5x
 QNus0Vk0q3AjH2CIu8xzQdShXfJJsh8Z48F1SmgMnaMr4EZggpjeFn4xgTJ3CcG0UgRfAN05C0jJRLQP2ekhLbSDkIA5AbCrv6KN8ZNRinxc2MMmwsfN4svrLZ8HuwFhUx8tjFBTuQW26tjTOI0xinLbhq9nLFOP146sXroq+S1gp0dW6N5oYWMWyZPN3iRBXl6G5NmZuEBN0mbkGvBIwb/GghoZuHxvssY9uvHiIk1mCKFBsY78QMezzHg2Rr30qT3tL7X0N6ljaqEJ4xSnbmUJew7Z1NAZYezhEbIyLrpQBQSBar5no/kXHReXpaH2NABBnasDSAq4eZl0SaPfoNjdwBskxTfTxD3L4+lBL2lT7krbJJqx6qvT0HW5uUEMO/pCmyK0waYQ3HXja3Vv/Upe2X9Cf8oa+n6uf8sYGP0fOyeWTPIXhDcNp51jQ9cY87f/ARh9spnC7XU4M/brIxk81UY0e8dyxb5yIlh4LT1ngHsQRlqD/Gu7MfKL0Qnk1Ay7h/z8ytAqiP83wbhTjs9Qjb6F9SNr4YHezNQBrZlq6CEORSh4+gBI6R4YA20ZEiR/PGiFWBGv42TCcbKGrrCr0/AGr/NIiZ7CDmAS5WH7dNqcYe1oOj5HGKqR72Um2CT8oXuJg6Z31O3w+9TWj2euvRYNBa1At0kPGCtwlk4a8x7blYs1Ig6vRu2Xa6yM4iY80PT6RbftSjTKwIz4yjlOB6D0Glb9uoSXlS4X5JDfi3AHwLoWQbweqpIDe9onHlWp3IHrJBy+YImHmXz0Xzf/QOLwkvqU6+AlXbRwFpLSPEqXYVn68iWxsfPUZx9Y+5L9Gp3zOMLM8HQTvZBQi60yGd3JtXj5Kgk93Awm5o0MbrVoATco/Fh7I5Qakimf6dwg5Ebu6SnACtovhAKKwV1mVuAtmct7P6aO4c1LqiKYTR6FsTi0u4aHo8JFHAWe41k88Qpje2MKBpoxfczD3hMtDZG0J
 72HSqDrv
 yhGftxRxq1eIfRh8/E4CM4A7105yu8qUqkzHIfdZlvkvmzM4pPVNcz1dZZDHEfL7mNxhibaJM9m9qjL4c/8hrS3Qd0twfCX6Ps14RlrIwj628Ts+sYZB1/BuIBZNtP7svxQ9HcrI0fjOAZbOfst5UmQIc/1pEl8IsbflZm3t04SaizFVs2MryudOQydA+esa/KA5Hz3IOw0Y+LSPFYHtKyU0l1k27bl83rdgJgsM5evdbtbHZxz3F9lejhNppTuGRCWO+cj8uy5batcy4yM/afNwXkPGYByiVqlT1Y5ayycUeZVy0sZoRH0z2xeOY5qkx2UGp2oeHYLl/Pu6f8Hr+iDmm3qsqgmig1lPOR3kuf2E1SzSZVoTPjMKD7Jqc7QK+regttjJH6DP3XlWcQG5YbsgobDoyd/7PKY+miOO5YA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    e8c2f9fdadee Merge tag 'for-7.1/hpfs-fixes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=131dcf96580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8d24a1331e060dda
dashboard link: https://syzkaller.appspot.com/bug?extid=774c2dfaebdf78f984c5
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7980daa950e4/disk-e8c2f9fd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8bdb257b9cb5/vmlinux-e8c2f9fd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/827a38d4946b/bzImage-e8c2f9fd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+774c2dfaebdf78f984c5@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P17948/1:b..l
rcu: 	(detected by 0, t=10503 jiffies, g=351569, q=826004 ncpus=2)
task:syz.4.14533     state:R  running task     stack:25592 pid:17948 tgid:17948 ppid:10462  task_flags:0x400040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1821/0x5740 kernel/sched/core.c:7189
 preempt_schedule_irq+0x4d/0xa0 kernel/sched/core.c:7513
 irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
 irqentry_exit+0x14f/0x760 kernel/entry/common.c:164
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:__rcu_read_unlock+0x0/0xe0 kernel/rcu/tree_plugin.h:431
Code: d9 80 e1 07 80 c1 03 38 c1 7c dc 48 89 df e8 07 77 85 00 eb d2 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <f3> 0f 1e fa 41 57 41 56 41 55 41 54 53 49 bf 00 00 00 00 00 fc ff
RSP: 0018:ffffc9000596f390 EFLAGS: 00000286
RAX: c3ba2f73bc45e400 RBX: 00007f67769da601 RCX: 0000000000000046
RDX: 0000000000000001 RSI: ffffffff8e220c4d RDI: ffffffff8c28b860
RBP: dffffc0000000000 R08: 0000000000000022 R09: ffffffff8e95cce0
R10: dffffc0000000000 R11: ffffffff81b0e040 R12: 00007fff7b795798
R13: ffffc90005968000 R14: ffffc9000596f468 R15: ffffffff8176e256
 rcu_read_unlock include/linux/rcupdate.h:871 [inline]
 class_rcu_destructor include/linux/rcupdate.h:1181 [inline]
 unwind_next_frame+0x1bbf/0x2550 arch/x86/kernel/unwind_orc.c:709
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 save_stack+0x122/0x230 mm/page_owner.c:165
 __reset_page_owner+0x71/0x1f0 mm/page_owner.c:320
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
 __slab_free+0x274/0x2c0 mm/slub.c:5613
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4570 [inline]
 slab_alloc_node mm/slub.c:4899 [inline]
 kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4951
 alloc_task_struct_node kernel/fork.c:187 [inline]
 dup_task_struct+0x52/0x840 kernel/fork.c:918
 copy_process+0x89b/0x4440 kernel/fork.c:2090
 kernel_clone+0x284/0x8f0 kernel/fork.c:2721
 __do_sys_clone3 kernel/fork.c:3025 [inline]
 __se_sys_clone3+0x33c/0x360 kernel/fork.c:3004
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6775b9dc49
RSP: 002b:00007fff7b795798 EFLAGS: 00000202 ORIG_RAX: 00000000000001b3
RAX: ffffffffffffffda RBX: 00007f6775b591e0 RCX: 00007f6775b9dc49
RDX: 00007f6775b591e0 RSI: 0000000000000058 RDI: 00007fff7b7957f0
RBP: 00007f67769da6c0 R08: 00007f67769da6c0 R09: 00007fff7b7958d7
R10: 0000000000000008 R11: 0000000000000202 R12: ffffffffffffffe8
R13: 000000000000006e R14: 00007fff7b7957f0 R15: 00007fff7b7958d8
 </TASK>
rcu: rcu_preempt kthread starved for 332 jiffies! g351569 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27536 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1821/0x5740 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7283
 schedule_timeout+0x158/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x312/0x11d0 kernel/rcu/tree.c:2095
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2297
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 9543 Comm: kworker/u8:15 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: wg-kex-wg1 wg_packet_handshake_send_worker
RIP: 0010:on_stack arch/x86/include/asm/stacktrace.h:58 [inline]
RIP: 0010:stack_access_ok arch/x86/kernel/unwind_orc.c:409 [inline]
RIP: 0010:deref_stack_reg arch/x86/kernel/unwind_orc.c:419 [inline]
RIP: 0010:unwind_next_frame+0xdd5/0x2550 arch/x86/kernel/unwind_orc.c:614
Code: 61 0b ba 00 48 89 5c 24 60 4c 89 64 24 18 49 8d 5c 24 f8 4d 8b 66 10 48 b8 00 00 00 00 00 fc ff df 48 8b 4c 24 20 0f b6 04 01 <84> c0 0f 85 2c 12 00 00 41 83 3e 00 0f 95 c0 49 39 df 0f 96 c1 20
RSP: 0018:ffffc90000a075f8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffc90000a07c28 RCX: 1ffff92000140ed9
RDX: ffffffff914bec6a RSI: 0000000000000002 RDI: ffffffff8c28b800
RBP: 1ffff92000140eda R08: 000000000000000b R09: ffffffff8e95cce0
R10: dffffc0000000000 R11: ffffffff81b0e040 R12: ffffc90000a09000
R13: 1ffff92000140edb R14: ffffc90000a076c8 R15: ffffc90000a01000
FS:  0000000000000000(0000) GS:ffff888125387000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0dcae0021c CR3: 0000000090206000 CR4: 0000000000350ef0
Call Trace:
 <IRQ>
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2689 [inline]
 slab_free mm/slub.c:6251 [inline]
 kmem_cache_free+0x182/0x650 mm/slub.c:6378
 kfree_skb_reason include/linux/skbuff.h:1322 [inline]
 enqueue_to_backlog+0x69b/0xee0 net/core/dev.c:5421
 netif_rx_internal+0x120/0x560 net/core/dev.c:5719
 __netif_rx+0x78/0xc0 net/core/dev.c:5739
 loopback_xmit+0x43a/0x660 drivers/net/loopback.c:90
 __netdev_start_xmit include/linux/netdevice.h:5368 [inline]
 netdev_start_xmit include/linux/netdevice.h:5377 [inline]
 xmit_one net/core/dev.c:3888 [inline]
 dev_hard_start_xmit+0x2cd/0x830 net/core/dev.c:3904
 sch_direct_xmit+0x251/0x4c0 net/sched/sch_generic.c:372
 qdisc_restart net/sched/sch_generic.c:437 [inline]
 __qdisc_run+0xa83/0x1560 net/sched/sch_generic.c:445
 qdisc_run include/net/pkt_sched.h:120 [inline]
 __dev_xmit_skb net/core/dev.c:4292 [inline]
 __dev_queue_xmit+0x1d26/0x3950 net/core/dev.c:4831
 dev_queue_xmit include/linux/netdevice.h:3418 [inline]
 neigh_hh_output include/net/neighbour.h:544 [inline]
 neigh_output include/net/neighbour.h:558 [inline]
 ip_finish_output2+0xc68/0x1070 net/ipv4/ip_output.c:237
 NF_HOOK_COND include/linux/netfilter.h:307 [inline]
 ip_output+0x29f/0x450 net/ipv4/ip_output.c:438
 synproxy_send_client_synack+0x8c1/0xe30 net/netfilter/nf_synproxy_core.c:485
 nft_synproxy_eval_v4+0x34a/0x4e0 net/netfilter/nft_synproxy.c:60
 nft_synproxy_do_eval+0x305/0x580 net/netfilter/nft_synproxy.c:142
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 nft_do_chain+0x48d/0x1ae0 net/netfilter/nf_tables_core.c:285
 nft_do_chain_inet+0x360/0x4b0 net/netfilter/nft_chain_filter.c:162
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK+0x21f/0x3c0 include/linux/netfilter.h:316
 NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:318
 __netif_receive_skb_one_core net/core/dev.c:6202 [inline]
 __netif_receive_skb net/core/dev.c:6315 [inline]
 process_backlog+0xaa3/0x1950 net/core/dev.c:6666
 __napi_poll+0xae/0x340 net/core/dev.c:7733
 napi_poll net/core/dev.c:7796 [inline]
 net_rx_action+0x627/0xf70 net/core/dev.c:7953
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 do_softirq+0x76/0xd0 kernel/softirq.c:523
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0xf8/0x130 kernel/softirq.c:450
 blake2s_compress+0xf9/0x1eb0 lib/crypto/x86/blake2s.h:42
 blake2s_update+0x14b/0x450 lib/crypto/blake2s.c:119
 hmac+0x2d3/0x3b0 drivers/net/wireguard/noise.c:332
 kdf drivers/net/wireguard/noise.c:367 [inline]
 message_ephemeral+0x255/0x310 drivers/net/wireguard/noise.c:493
 wg_noise_handshake_create_initiation+0x257/0x830 drivers/net/wireguard/noise.c:545
 wg_packet_send_handshake_initiation drivers/net/wireguard/send.c:34 [inline]
 wg_packet_handshake_send_worker+0x18d/0x350 drivers/net/wireguard/send.c:51
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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

