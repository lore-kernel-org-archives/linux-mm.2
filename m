Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BC76D116E2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6EE6B0099; Thu, 27 Nov 2025 09:55:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DD96B009E; Thu, 27 Nov 2025 09:55:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACABE6B009F; Thu, 27 Nov 2025 09:55:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9236B0099
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:55:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C89656B64
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:55:27 +0000 (UTC)
X-FDA: 84156685494.07.B77798A
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9C615180011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:55:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3XGYoaQkbABsJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3XGYoaQkbABsJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764255325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=hCAVKRSWAFgcmFuKzO2EIexdVb24ue0/wi6M2luph+c=;
	b=DdlWkBGD/SUyaoZcdet2ZxYEUCCi72vVFqCInehF7kB4Yj6mttAQw5sYDRelZlarsW7WDX
	juwhAEK0LkO7rcicpMaYc9f6CNjGIZW6cRF2G3imijCPY8PYVDGRrMiwyBA9E5FO+esaLr
	IXyPCmG0Gjaa+7q8FT5aphcSk5JtLC4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764255325; a=rsa-sha256;
	cv=none;
	b=eQMPCAtriJBCB6p0D7Fva0YXOQLwgcKFRnVe+keKYSivGeoqMV8rZsmdX4+vQ0cfXgtXxf
	a1MAUZnsV+enImmmW9716i0FXUGD4AI3gQf3zgNfi5sGyi4EM0wXyX94EO6XQzQwFTbOBJ
	7INHNLvtmV76cqKnC4r4XGkFQ/BBrHw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3XGYoaQkbABsJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3XGYoaQkbABsJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-43328dcdac1so9113015ab.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:55:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764255324; x=1764860124;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hCAVKRSWAFgcmFuKzO2EIexdVb24ue0/wi6M2luph+c=;
        b=GLArxLALEKi2NunZ7jyIceOqslrmVCkfRJdACu0vQ+P6JBNzyhF62yG1ErrvQsNjTS
         POSyEKYjl7XRX8VuA0ixhMo3NkNjm0FxDOAw4dcKWRzdk8tbkr+gUeKj8E9HHP1uMekE
         aBeKkzbH8YPI1h4NTjUPZ7XtAnHoodLEIZMu1sxWk+22PQHgGF/AfURh8RuZfyV++Ins
         7kjqfNdmZs7l0L7auyNeGnIaWU7Ry6mS2mYsF3ofaMChKUvQlh9SL8uJUE4XiwogpR5Y
         R1gPtQm1sSpr+bkjF8LJJkb7okIgDEqHvUJSrTLrOz8BZV0jBk/owixy+Mej1w8mabME
         ATCw==
X-Forwarded-Encrypted: i=1; AJvYcCVUnk0Ik8sQ8jDRt0ILcA6+LHkmO8m8sAtqSsm33UcaHq0ZU2O7OHMRzkgY/x0fFf+gx228fRnJYQ==@kvack.org
X-Gm-Message-State: AOJu0YwuNbjEFm6IeF/kOsxg2yG6+g/8AmqCy/5mO5gnOojocbDNcJWV
	5l6bcOh2+Edmg9IER+riyCG7H+loIf0jsIDgMVjj1FtNFWpthI/LlwKy2porufLw0bXQe6mVaSW
	+EE0DFpKEmAc5KGneebiAk/9sA3Rk2vo6+5ba1O2BXzQbNs0uUqFqWwdDWxU=
X-Google-Smtp-Source: AGHT+IGhIQGX5rt1wjhEHu9BD/rsM//hmN5/8B3l8Epz9R5tqBC367cGCoVCcNYa5DDUZ82w1uKgPSJykbyy/R9ut3AvVifiylgh
MIME-Version: 1.0
X-Received: by 2002:a92:cd44:0:b0:433:68e3:7679 with SMTP id
 e9e14a558f8ab-435dd043b29mr76588715ab.8.1764255324606; Thu, 27 Nov 2025
 06:55:24 -0800 (PST)
Date: Thu, 27 Nov 2025 06:55:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6928665c.a70a0220.d98e3.0109.GAE@google.com>
Subject: [syzbot] [udf?] INFO: rcu detected stall in call_usermodehelper_exec_async
 (4)
From: syzbot <syzbot+be81254ae29faa71cdfe@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.com, jack@suse.cz, kees@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: ozz71r6w8z6fyeiybdpc5q3nnwbqx7js
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9C615180011
X-HE-Tag: 1764255325-89850
X-HE-Meta: U2FsdGVkX1+BPpJ+JBWBs5hgj+3W4bfvjDBeE5MUfHUfHS+E62UY93gKd9m6bzvbZbklzrS900yzFsl8fVUVccQQJ0HdMdQiKTRUEbZ52/CVNNeRSOCij1FkK1YAvWszmCAyHiI2yZLkKX8Kd6Kr+/amh6V7LH2bBEW2bk7CrRrbHPSS0MWMUrYNCrNP+1/Pt0c9+CxP1PKmZCBcu1R72rp0pi/h25NoxXZhFEVlToRYB5xGZSY7lBFTQyNac4i4MoXQImVh4chKRo89O83IsKbALM6Ix35ox67jDfTJVxBCTgrifk+JBk/pyfoJI2sR876CiRQRp8kEdnvMgutF4Ndlf2xkZhnG8ngVJg+ETUyGgC7ylPlucm7W/ZC5TQaJmC6PRLwRjUud3/VFIYr4esIIznJP8qOolalozFL1PtGvy6iobJjbYv88xuyaB3OMMrmgLAtcOc8iAS1GzWYVtgapc8X/AqTm0jk4JuFkHg6tWGYutfAPT28WcVcqthmYBG2xhA0WT2XvAnClDwz6ShT7skMsA4YfBadJHlR8GUZbB++HY3CvSixS1FckNkuGVYe5mdqhgtrh8XG4jgFMF8Q3pHDpZVa9tJoU85FOgkufTUmCIQlvnaJ09y9dodatzaNL5IiXaZv/ypxHfw+JdVxqVCgpmSN3kVmjSgr/eb5hcYfJE1oEV6aMuRlwohav60y9ITomb4VMTPcA1+NCNVNkHWJZ5fKKM+2fFNlIeid+9NGryDacBBm3XddKbiWz9yfTpP9MbvFak6M+BxpHsdsf2n3ipejCFRJv/C+ZvZG5czXzScmyNmrQfT3vwJGAJdaU+kbuct5DNnUA7Y/UWJJ2j/DODZZjVyVVz7jX8qQb61eBiqkcYAYbxrl9s9FLZnu1DkJBgDV6BpGshZgTcVzmA9Ly5+e6Cb0BepG9pv8vv3sWJkkMN6qMO495RaWSElyvaffBhFR/8EOS+mu
 WtvfL4zw
 uTcVq8TzerS8FcXiLTJ3R/+Nb/ldoAAV+y8lFSkSQEuVsjuy5TpVDIjrsTl/2dTaMFSzvzA3E+jgsqx+sjrPR/Kk3aipJNLkYh2rocUi5q0ZFacmlQLdzedY5ytkfFjb/GMhg6ofG4TQpi9U9U2Exr4UCuvhILjjt+nLmAV/+P7DSmgxoGScKab3j3ze/KlaIYyg9l0aUAUFHFtJznIfMv/WcGuNju3XlRq8Iwk4G6DZ0F9J/pSvWeScuZsm2bJdAMjoafXP+hpxwgnJ9ltVyOCJqoR/YNfKtHNz7JAzBtmsJpCBEfliwfa7f/TgYibUL8Kd166pqtNPh1nLULdLbwuMTd68ws4LoIf0pmRlheUtvdg5jkY4d4H7OVU2pxD/m3fgLxVFSO26qP7HUrh9cNwy5r35rg02181tTW/0c4mHzik59MML+T/qN/PUeJlcg3ETkpZ9guTpvf90TdwmeGDqrOyXJu8IEsdNbojU6rl4DsvPq1GW+D1pazIUO0g7Bb2qBEt9JaaEl2Pzvu4humg1TzefiwN+F6OjZTbI1Ks9OY7f4+x3DxaIQAjZPKDYjz9PExxwfjA4WH0clD54tJBbdJFQK9Chycna9adFkNfZzAjtqzphHdmTxZsypAPQoffXEnY4LlFGy7a8/QXvAcnSBAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    d724c6f85e80 Add linux-next specific files for 20251121
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16f1f742580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=68d11c703cf8e4a0
dashboard link: https://syzkaller.appspot.com/bug?extid=be81254ae29faa71cdfe
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c3ea12580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1064d8b4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0ccfc806f65a/disk-d724c6f8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c2ec31ffb05e/vmlinux-d724c6f8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c25d9c0c1917/bzImage-d724c6f8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9174536af225/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+be81254ae29faa71cdfe@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6121/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=13961, q=394 ncpus=2)
task:modprobe        state:R  running task     stack:26056 pid:6121  tgid:6121  ppid:13     task_flags:0x400000 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5257 [inline]
 __schedule+0x14bc/0x5030 kernel/sched/core.c:6864
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7191
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:unwind_next_frame+0xaa5/0x2390 arch/x86/kernel/unwind_orc.c:581
Code: 00 49 89 df 49 c1 ef 03 41 0f b6 04 2f 84 c0 0f 85 88 13 00 00 0f b6 76 01 83 e6 07 83 fe 04 4c 89 64 24 10 0f 84 49 04 00 00 <83> fe 03 0f 84 f3 01 00 00 83 fe 02 0f 85 a1 07 00 00 4c 89 7c 24
RSP: 0018:ffffc90003287898 EFLAGS: 00000293
RAX: 0000000000000000 RBX: ffffffff900ba31f RCX: ffffffff8f90e4cc
RDX: ffffffff900ba31a RSI: 0000000000000002 RDI: ffffffff8bbf8180
RBP: dffffc0000000000 R08: 0000000000000003 R09: ffffffff81745035
R10: ffffc900032879b8 R11: ffffffff81adcc20 R12: ffffc90003287f48
R13: ffffc900032879b8 R14: ffffc90003287968 R15: 1ffffffff2017463
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6663 [inline]
 kfree+0x1c0/0x680 mm/slub.c:6871
 kernel_execve+0x3c7/0x9f0 fs/exec.c:1922
 call_usermodehelper_exec_async+0x210/0x360 kernel/umh.c:109
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: rcu_preempt kthread starved for 10537 jiffies! g13961 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27064 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5257 [inline]
 __schedule+0x14bc/0x5030 kernel/sched/core.c:6864
 __schedule_loop kernel/sched/core.c:6946 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6961
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:pv_native_safe_halt+0x13/0x20 arch/x86/kernel/paravirt.c:82
Code: cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 33 70 0c 00 f3 0f 1e fa fb f4 <e9> c8 f2 02 00 cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffffff8dc07d80 EFLAGS: 000002c6
RAX: 9d3ae734e5c61000 RBX: ffffffff8197acb7 RCX: 9d3ae734e5c61000
RDX: 0000000000000001 RSI: ffffffff8d78f71d RDI: ffffffff8bbf81e0
RBP: ffffffff8dc07ea8 R08: ffff8880b86336db R09: 1ffff110170c66db
R10: dffffc0000000000 R11: ffffed10170c66dc R12: ffffffff8f7deb70
R13: 0000000000000000 R14: 0000000000000000 R15: 1ffffffff1b92a60
FS:  0000000000000000(0000) GS:ffff888125eba000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc4b4703020 CR3: 000000002998e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x73/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:190 [inline]
 do_idle+0x1e7/0x510 kernel/sched/idle.c:330
 cpu_startup_entry+0x44/0x60 kernel/sched/idle.c:428
 rest_init+0x2de/0x300 init/main.c:757
 start_kernel+0x3a7/0x410 init/main.c:1206
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x147
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

