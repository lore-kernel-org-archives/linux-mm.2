Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1447CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF64A6B0093; Mon,  5 Oct 2026 06:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6386B0095; Mon,  5 Oct 2026 06:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E38C6B0096; Mon,  5 Oct 2026 06:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74D1E6B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:05:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DC951201C9
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:05:44 +0000 (UTC)
X-FDA: 85288141008.23.070D956
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf10.hostedemail.com (Postfix) with ESMTP id D408EC000C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:05:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of 3dXbDagkbAMwAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3dXbDagkbAMwAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791194742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=jxRAgRCn0djyme+/P9KKlTJtsN6YIDbfEo4rgZVD75A=;
	b=eXtbMJ0UJQturS942YCSu1wmC6nSVsNUbYPYWoSc6qfMrdTGJAQZvMkwXExg98OVBKoddr
	ur+WkPEgsZzsVbcepBB7p6kRcbrxVE3OvdAGgFMyZ6gVHRxljX6HAe2JltEc4NutWT60Bu
	Xbrqz2ZwBflwIZGplhuL67prNajWung=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of 3dXbDagkbAMwAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3dXbDagkbAMwAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791194742;
	b=E/eVJWmVzrsfFiZpq4nr3EAR8hfF971OYizciIzmfppiyg3HXq6ZBdIGeEDe8F9qNHEMRz
	F6XP3+lRpE970mfgHlKMtQDhkUu41cK8MFiPa7VcvBVtzOFy177l50drI09f6Rs6ADAh1z
	hpOir8mvuG2TA1pa+uDuBpgRHnSSczE=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4eb0b989f0eso2803767b6e.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 03:05:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791194742; x=1791799542;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jxRAgRCn0djyme+/P9KKlTJtsN6YIDbfEo4rgZVD75A=;
        b=gHBojGRN/+54AeRsz/UfKNWAygPd2Ad8AI5mhOuLkdUWJHY3O0x2DPV8hbwWKFkqy4
         ujF94NxCa3Y5693pg1IrVPK3fJQdv+0FJRjJtusrbSov/rXAxcBf5xF5oo9S2R2ikIta
         7sdkBq15crMRn5X+bVZjWM1xqtRFNmu5Guxq27Fa1zkKtOdSnJAS+5RoT6RvTkVl+zhI
         G02Z+1LuClIminehOHyezsDsbbnyAwFoSFgfJeBlPqIWvVAhMkbbqNTrn1SVmQ/3LCLO
         YB0S9qa/yMz3a4Z/F25zRXminfz0ZI2V1/1f3FuPAxM3A//vDzLa/tJp9oY3Js4Ir932
         klcg==
X-Forwarded-Encrypted: i=1; AKwUvByUgX/QmIAGVB7XmDJDLSuNrgmqocYGrxyusbHEvBKusGeMWJtU3s5GDZyFtXWx6mKScD/PQua4sQ==@kvack.org
X-Gm-Message-State: AFuF++lGkGm8lV8JCrET5ELegOF+OAiOYBtwaUHv3XQgaVGbd4c+96yc
	neCseyjgh5DfqCC76y4akWVo4HBuu71wahxAE7l+Z/tWKHAY2xeRLklEtDreVlK03SfLW4wuq1h
	+tdB4N84tLYXhLroGqdpZLwFPqKNxEWok4rr2mx6O0BbnqnOQjxAaedhs8Mc=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4444:b0:495:f8a5:8797 with SMTP id
 5614622812f47-4f2fc48a50fmr10409344b6e.0.1791194741975; Mon, 05 Oct 2026
 03:05:41 -0700 (PDT)
Date: Mon, 05 Oct 2026 03:05:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac37675.63a243ec.3d2de0.0000.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] INFO: rcu detected stall in kswapd (4)
From: syzbot <syzbot+f886305df0acc6fa097a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D408EC000C
X-Rspam-User: 
X-Stat-Signature: zd8ksoonzq7hsjbpkxjxuty6ubpjg96q
X-HE-Tag: 1791194742-391238
X-HE-Meta: U2FsdGVkX18ZeZlKF8RObfRga5RMBYYg1Sncq5Rd989OuuZT3G8ZAZ+MrQ1CqUku5tVY+0pGswEYP3Sst6zArNckswTblLJc6/30ZuTkq9g9Qsgo4T71Gc6TGXNN35TUDPvr+s1rV8mOpVDZSFbJY7h+Eq2dPRuuX+tOlb9DyjB6Wmw3K1VUyAUVlBJNRZ+eL1fvVCyA4GjTGlyTbWJn4NtRKwcozuulEjj3IoA3btMRe2D2J+s2jiZERhJ/8sRWBkkUkIVnZ1+NXJlhGg0vF46r4xjZ316Hze9Hbz9UUAkDyIiyGLYQJHvog18A59meytexur6JOa7+MmQXgfKjViq1FXc5v7pkxAYv8deVZYxVdpXPQg5wMd82Ldo9TT8QqwwScdl/gZnFehttGmnpCr8ojibAaxNsGpLxiNllTxWSc1/hXT5dgu6fNXm029FTPE9DdKbHUIwH/ywJo+EUi7OyGTm3sqvvth8HHN2AKGo21kDqqDJKHietQPTuVssyRB7rjtrluV8j8/P8u2u0iRSTs7k1pzZDK7bnPpkQhovVmvky4OAWiELzqqlKcodP6lzy83ZaW4NL2CMP0lOgiqTvTvYqAMNrEWovW9pfXmpDH5PQUewEsVPv3eAASnZM0rA7BuWk9AVLR6uJ4p/+4a1Xzb2dYDD+/Nn2qTzPXoAtKG+v/lXYEFtmMwsR4njVURz3E/gabXfMCgvQQk0rYRGXLkDuQvfFQKGXollcjJw3OkvaAtPrflA+bMqx5y1phDo97H1s4YqVVX+WVQ6kjoFui9eJJ1//vIqsc03AsgKbsH6XeUoKeENjWc5aCms1g7g/9IkDlFaEeQJKUgvGKW0i/kJXkYeNPq/Bdev9xHLZOosLi5XhXQXfXsSuQeq1oOPJtkBzJYSOPhVKXYEaHdatlU8uvWx35ZZCrc7rDNE1SZPCd8DDyE/QuofsFlBXU9di7ioFMk5IOIsLpwx
 mzB+gepv
 ll2UFN/8FKR5Cy+M80NBFy3gwNikmlXu1MtbOWIcnFjXptSC38q8wCqH+rDy0i/TYMJTk/gdXZ/jIigSz153f2XSQWhRmHNBu7wcurqSM8JPO0qgL/9F0EiMdPO09Oj2QKM7SjmEM+4EYtBY4lbJ8OZt19EfUqH3YSBi5Myfi5ILXT5qEg79pntmcWtyNH1OT9b/1SGWIw3ctxRtyG4NR0ak1bbwUFN0Lv9wM5kGPyrNe1Lz4yDyZWTjKfDTmOJCVcQJ6CEIo66nJHs+1t/SKFeNHWlNr8thp2wojSevMnKUwxzKXtBCkyy5HR98erMpOPs2f+5F8dE/9aF93WzWVNYfkSiCrOzsXijJ0g2hmRr8BbsFOC4lJBtHX1Tkjq5Iou/x7VE8lQOOnf+CphByXCSWvSLH43WX1KpbF7LnlHS8irGlpP6f3R/rL0o7UpUzBblM5aKVl826z8QcxSLKG5Cp0kS5BWd6ctEYoeuHWa5zgdFN4Kybcn5ZJZ3ti6c7VTDHZN5sCQXqBKGXAjHs3RKA00OUn8D1cfkYGvVwjIV0obRXZRs93N5HmacH3aNgeLGEDr7qYZyVKB8SyFES8nYcLKQyEqJ2GNLBt4FX4fw/NwK6o+bh8BC9MCffQ4QcweEop6i+ARaiG9Gioa+63xGkxuqRd80F/epF3iWp7xulBqW83/YrdEGHGulGf2zNit6laOs4VY34OwOM35BoD09cbVMTtwROyGI2X0uD/GuxkVjTFE3IS0FCwv32NpizL5+4NIwdhs5HQuiBh4fKAosIea3M5cpJZzVw+NJVjgunZWfk3qwm3PpbnEv+gzTA0o4Wp1BMOYoMNKqqN9AkijLiBZpmn8WEBGJkLW4aZiCMnEXz1aVI72IRDKVqKRejV/8IOE6aH2oSWXswhfaFZ6v24fadslgUnRjb8FShihhKT4WEZpzWH27Rph98Z4F7uAWxyrQphqxYzGlotGUrftESCa2mA
 4hRq4HKl
 gxcLCifQaoywtLFQTXGGr9BS5YJa1hWgmo1XJmerF1VU0VmM6JoOeyjuHC7TNVg9FjxCSWnLuAuIP/IW9gcsyw3TenX4Iy1og71J2QHREjQmXbI/hVZBBnUNTGsRcA3IY7ebo9vTCtvRjI+v9PrQcrzQj5+/K3rKgI3+lZ6sMvRnnQ45z5u0DcpEYjGxhIWFFeGGYNk/HtHNvHCwzy2fy1bJwNJiBZSi0RHr6UCpEqkwcAh6d+DqNWUX3NsckxXvjyIVpejgN3ksbIB/r/lxb+hccB2nHtGwizHT5Xd993svvJjrx7yzjM1EHG47vd4SnvXTE7QGv0rxZHEK4O/AOZ405lJRzuBMiLxJU8RYLyeytb+MwqNGaMMm+KjSBbuQddliVAPjTopuMkGR9Gdw9PdC7H1KN0zr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    551c722f4080 Merge tag 'rtc-7.3-fixes' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13398725580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b924f079099ba6e
dashboard link: https://syzkaller.appspot.com/bug?extid=f886305df0acc6fa097a
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10b98725580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-551c722f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c3bdf9d33a9b/vmlinux-551c722f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a4322b07d54a/bzImage-551c722f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f886305df0acc6fa097a@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-0): P5719/1:b..l
rcu: 	(detected by 0, t=10502 jiffies, g=57681, q=371 ncpus=1)
task:syz.2.25        state:R  running task     stack:26616 pid:5719  tgid:5719  ppid:5420   task_flags:0x400040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5533 [inline]
 __schedule+0x17db/0x58f0 kernel/sched/core.c:7284
 preempt_schedule_common+0x7f/0xd0 kernel/sched/core.c:7463
 preempt_schedule_thunk+0x16/0x40 arch/x86/entry/thunk.S:12
 __raw_spin_unlock include/linux/spinlock_api_smp.h:201 [inline]
 _raw_spin_unlock+0x41/0x50 kernel/locking/spinlock.c:213
 spin_unlock include/linux/spinlock.h:401 [inline]
 do_wp_page+0x769/0x4b80 mm/memory.c:4467
 handle_pte_fault mm/memory.c:6582 [inline]
 __handle_mm_fault mm/memory.c:6707 [inline]
 handle_mm_fault+0x15d7/0x3750 mm/memory.c:6876
 do_user_addr_fault+0xa4f/0x1340 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0033:0x7f0879a66723
RSP: 002b:00007ffde218fc10 EFLAGS: 00010246
RAX: 00007f0879e25fa0 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000003 RSI: 00007f0879e26038 RDI: 0000000000000000
RBP: 00007f0879e25fb0 R08: 0000000000000000 R09: 00007f0879e26038
R10: 0000000000000003 R11: 0000000000000000 R12: 00007f0879e25fa0
R13: 0000200000000000 R14: 00007ffde218fc88 R15: 00007f0879e25fa0
 </TASK>
rcu: rcu_preempt kthread starved for 3418 jiffies! g57681 f0x0 RCU_GP_WAIT_FQS(5) ->state=R ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27496 pid:17    tgid:17    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5533 [inline]
 __schedule+0x17db/0x58f0 kernel/sched/core.c:7284
 preempt_schedule_common+0x7f/0xd0 kernel/sched/core.c:7463
 preempt_schedule_thunk+0x16/0x40 arch/x86/entry/thunk.S:12
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:211 [inline]
 _raw_spin_unlock_irqrestore+0x76/0x80 kernel/locking/spinlock.c:221
 debug_object_free+0x294/0x340 lib/debugobjects.c:1038
 schedule_timeout+0x162/0x2c0 kernel/time/sleep_timeout.c:103
 rcu_gp_fqs_loop+0x30c/0x11f0 kernel/rcu/tree.c:2122
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2330
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 80 Comm: kswapd1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:finish_task_switch+0x413/0xc60 kernel/sched/core.c:5384
Code: 04 00 00 41 c7 84 24 20 0e 00 00 00 00 00 00 0f 1f 44 00 00 49 83 c4 48 4c 89 e7 e8 b7 5f 55 0a e8 d2 3b 3a 00 fb 4c 8b 65 c8 <49> 8d bc 24 18 17 00 00 48 89 f8 48 c1 e8 03 42 0f b6 04 30 84 c0
RSP: 0018:ffffc90000e97600 EFLAGS: 00000202
RAX: 0000000000076e43 RBX: ffff88801fc3c8e0 RCX: 8000000000000001
RDX: 0000000000000000 RSI: ffffffff8e419dcf RDI: ffffffff8c6dcd80
RBP: ffffc90000e97650 R08: ffffffff907a877f R09: 1ffffffff20f50ef
R10: dffffc0000000000 R11: fffffbfff20f50f0 R12: ffff8880317aa580
R13: ffff88801fc3c8a8 R14: dffffc0000000000 R15: 1ffff11003f8791c
FS:  0000000000000000(0000) GS:ffff88808c2bc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0f31591ac0 CR3: 000000004374b000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5536 [inline]
 __schedule+0x17e3/0x58f0 kernel/sched/core.c:7284
 preempt_schedule_irq+0x4b/0x90 kernel/sched/core.c:7606
 irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
 irqentry_exit+0x14f/0x910 kernel/entry/common.c:167
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:__might_resched+0x144/0x4c0 kernel/sched/core.c:9229
Code: d0 02 00 00 41 f6 45 00 02 75 21 4d 8d ae 38 0b 00 00 4c 89 e8 48 c1 e8 03 0f b6 04 28 84 c0 0f 85 cd 02 00 00 41 83 7d 00 00 <74> 7e 48 c7 c0 80 3c 7a 90 48 c1 e8 03 0f b6 04 28 84 c0 0f 85 45
RSP: 0018:ffffc90000e97980 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000046
RDX: 0000000000000000 RSI: ffffffff8e6a36ef RDI: ffffffff8c6dcd80
RBP: dffffc0000000000 R08: ffffffff907a877f R09: 1ffffffff20f50ef
R10: dffffc0000000000 R11: fffffbfff20f50f0 R12: ffff8880317aaa44
R13: ffff8880317ab0b8 R14: ffff8880317aa580 R15: 1ffff110062f5548
 kthread_freezable_should_stop+0x23/0x180 kernel/kthread.c:199
 kswapd+0x7af/0x32c0 mm/vmscan.c:7535
 kthread+0x38b/0x480 kernel/kthread.c:436
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

