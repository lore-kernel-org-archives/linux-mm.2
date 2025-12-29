Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F21E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 04:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD316B0088; Sun, 28 Dec 2025 23:10:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAA056B0089; Sun, 28 Dec 2025 23:10:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6966B008A; Sun, 28 Dec 2025 23:10:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9E646B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 23:10:25 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E0501407FD
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 04:10:25 +0000 (UTC)
X-FDA: 84271181610.26.04DF06B
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	by imf07.hostedemail.com (Postfix) with ESMTP id 43E1240008
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 04:10:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3Lv9RaQkbAMU39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3Lv9RaQkbAMU39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766981423; a=rsa-sha256;
	cv=none;
	b=JsDEiwXmUpzcTSgk/6FMRvHVENNxzaqGtnMhLgUmKUyLD58hkECOBj/9mHvafjFvFzt9Et
	xQaZ6j2VwH4mz2N9dRGLmZdtQqm3HFxVnl9Kw0RF67AU3uXzXPWe/WyYj8j4ar9kuQlTxg
	+axH7lzvixMni0H08vnb02BYlXIK068=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3Lv9RaQkbAMU39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3Lv9RaQkbAMU39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766981423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=mEpLPY44HLAax3LCr6aY4119TcZRpT06LgxjSSRPQLs=;
	b=WOz6cTwy2dZNgdsI5PywHhkrVQKD93J3Sqqm3vnLS29WBaFKQ0/YyidX8SjloSUh4YWWOX
	pNqZLghMIgKRUfsb2kGN13W/uUOmEd16sAOqWEv9pXPtLegqZZCvQAI6qHkYTgXj4NLG5o
	P3d+4c1D6MmHEa0UM/8frjber5mnNOU=
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-657537cef7cso15662748eaf.1
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 20:10:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766981422; x=1767586222;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mEpLPY44HLAax3LCr6aY4119TcZRpT06LgxjSSRPQLs=;
        b=kGk5G90LWal7nnwwpNcW+seNbZZyi+5FQVmwFZ866QTuLcBiHYAOybHUdavQJEN6+5
         9pw0rhQxo53/ux7jbpbuapJyHH0aKnhlbkjUgTgHlCU2G1clgubpz77nCgb/SBweeCPB
         kZfuzyztUTxyheSvHTmMB38cfTTBHOgbwQrSICxGm3imTP5OZvxFppjLfonjxDCD/D+u
         o/NMCcIJwtloZUFL+f5o8p0SWU3vsG9eqW5DCCHEvQ86Vv8PdGgsOdR48XbY0UmywuNc
         ucMjd9C/qphSownMsJN11fbJ+VDvtNR/5mCMYwO1ld3JsiXUxujkRlPwMqAclPvtgtCx
         Oxbg==
X-Forwarded-Encrypted: i=1; AJvYcCW8YeUrSU7bj62oNQGE2uFWjxTRI5wgJubQhmag1RoX6YLd+M1Z4drHTR1tTN8IdhIV27yY2MY4Ow==@kvack.org
X-Gm-Message-State: AOJu0Yz8OXElR24RKNGuS6grl8PB3+lDvfbq7lVaNY3bjgwpz1O+cDMs
	ww2OO/43LlHMzx3vNOIxp+5f4F86Pqu43v7YoGn+FWAf+Q0rU4u6WB+yLoIuPfumnK7TqrC7TIZ
	Rttdi7ZDu73PiO5TYOQq3iMbglnZPNxQ+7NvCxVwCvHGFaM2DWGPPjhI1RUs=
X-Google-Smtp-Source: AGHT+IGVuh3zWwQq7VhlQOoV8Aat5t4WVZNF4Nbbtns/oYoCWRfCZ6TLVj/D64+v5dQIbFapOmX2BxeXoAzlQpK24C5sLg8HfW6h
MIME-Version: 1.0
X-Received: by 2002:a05:6820:22a6:b0:659:9a49:901e with SMTP id
 006d021491bc7-65d0eaedcf0mr13755041eaf.75.1766981422258; Sun, 28 Dec 2025
 20:10:22 -0800 (PST)
Date: Sun, 28 Dec 2025 20:10:22 -0800
In-Reply-To: <693f889b.a70a0220.104cf0.0335.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6951ff2e.a70a0220.c527.0018.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in finish_dput
From: syzbot <syzbot+d1b2c58262854b97eb1f@syzkaller.appspotmail.com>
To: atomlin@atomlin.com, da.gomez@kernel.org, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, mcgrof@kernel.org, petr.pavlu@suse.com, 
	samitolvanen@google.com, syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 43E1240008
X-Stat-Signature: w3rttbmbdj88tbfx8mhdkaxqojauttnf
X-HE-Tag: 1766981423-232820
X-HE-Meta: U2FsdGVkX1/IiMGG9MCayik9EeIHT7e9C49Jq5+c/d+BJrZhsVQksk7hIPIf6AoPfCDtAyKxJkh4R9oZp/wlxmhc3RTvwEJigYgqCy1pWJd1mi9+p3z9mcNVF600OZF0oe34OPx/crkp4vZ/uc9Z1inT1WIVlAx4556MANsuDCau38yiXzkwnBCzOr6qRF5CnUY0BS6V7rVUz0HytcmkAvdsqKlVgamTKQnyhufpX23gBYe/k0jKZWj6TlDB0dyUTJOJmT0JP+3jXzuw6JYyfGQM8d/t2hxDJGI2q52/8n1HTdOei9PvQ1qdE5sAbJoCdCAzkge9OK8bRgcpavk79+gFM/YmciID6atjV6QLb63877LOTM7mWh9fHekQQ7P9GFiZ57QIz7KT265Fx+oxcJ00pZyLBuXZEWcNRItISQxixdFUOwbqMmLM3tkjJEykXP6JWkolpnMEek8O1ssmIhhlAt3xwkGnRSYHVnX0wNGTbWrJKEXYQB4I8yJ8SUJUXmitQStSUBx9mLiLLhC6nWNbFVlJgPmWsCFMOsGOdfEHnYYAA+qvJBaekPW9sbtnlSTR6pGxJuYTvfHEGOu3mnNRP1au94weUUZgwqsskLFcTIELMOHcuwttQu6AbYFY0d7+K6q/b1stWLSorcHx31h/FPsbNBs5Y+u0r79ycSre0MTDP5WFlLOMYxrdOGWx4Gmie8JMVAz9PdrUpV4Z+/lVxFuNZ2t+zkJudeLocjZAUjtVTWk8i1INDE5ic1OODCNjasEE1aSNQaH7+oU11faY8Wsctcwe9Z6Dw27zEdodWP9x5/Qc9Tu67hlk6yp4bY2CO3RzkeHbhi5TeYRElBPiy9M9hhGkZCasy2KTb3IfWFy/JE3KYd3k57Olw7YRVhYDKWADuRLqLr7NvA+JBdy73z1CfYzCUGuy+E1Zbm/W8x2zZiXdU5ZjG5n5LqBaJ5QH8+H8QAbMfQ5osN1
 CzkkMF5Z
 tEQAyYnfyL5fMnZ7K1Nj/1h8rziH/WYAhIHAdYdl4lTP5IKo0v/9+fD+1XSnI+2SZqDmQVSQBYhmHnNHCSm2fO5PcnhSDCk+Mt1DR2i51ENewqbs2ZJkWVmjIzDfxhtDozc98ZXRLXk/R/rOJ0pKNiLXkHj+lx3mm3adoH79J627LH5A28/bcjVXhTeVOq9l2Us6mKG4LPiVrUv6MPKbgBZlHVWLMSAqjt21mNDBzXwgkAXvNwSAnSW98NHZIS5mgO53T6U6VeLYRo7ulI2L94cgviYTRYZeuaUFALDmnenWMSKqspJiytF1HyFMtY6DNOfoG0fR8PNFjX0pLnfjju1kt0QVRXaHAsLgqAIX1XFaNAR3n40UHdJMSAjRl07/acsR+cZnmPI/xfEw1bsimE/UX4f3SPT1HldT2qWgf3iaF1GcksOK6XQvrEm/GBv+aSK10QLTkm56ryBqOWPUafRwwRinlYBBbeogKeNGDQBMctF6mBw3e92Wm5sGlrBsoxroqWfSarQ3FLD4yjg2WTKzk511NRGVhE4Dy8wy2TJelSscKlx5sPtsECoMu8vzD109qmc3II4z8DzISwaV3M+fHPqog9c0lUbyj0du5/DCmrLp9SGbcR+p5uhtDTUAiPuJquAgTErVkQPIixhG0/sjPjwBRXM7hzjZ1dxy1D5Lb8gnsXU8hdFWQiFU+mqO84nY5t6Bc/B/z+aIgasWFP7WsVkBtoU7IrlD1W1oww66vl4DHS+PeEf17aOv80bNwVvfZy23UrlYN6akRBgLyiUMN2u8xrK6m3tFwHTAHnjMkLUegysZadMkqErpR8LncITPoHoeZv1VQ0/yURJWLDaIa4jZxT0KyQKno3IweBKtU4C5F6dPGFQelTx4p/CE0ufpwwGgINIM4pgBAAp0XDFkmX8PXkfBq88D8W/04SZTdDFQZKZbxYyTj13u47D7fd4QSWW/38UxoscxaiVRCTC14Zse1
 XmThYZMK
 GxyRnt+4CIHa4XC70I6MbcZIMefuiuBSR0ZG8kAFw8P2EuMOXHX++5RRjy0iaMOH/rfsCmSS+SiydhLJVa2ZuJ4zWj7Q52Wfado/Xh7dljxPNgZXO7XmsPxwEUgqJ1Q88ChJwzUO2qqUWS6Vv05GBeXeWxyWGA+YA2O8XtUYRbCMpUbVES6tSoYqx7BRgXZ48KVRaoOiL6czuQjU3YtutVh5/AEfR9o1nj127YZw/GmAjoHjKMKNQewgpFxX4i1X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    cc3aa43b44bd Add linux-next specific files for 20251219
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16918422580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da1bc82c6189c463
dashboard link: https://syzkaller.appspot.com/bug?extid=d1b2c58262854b97eb1f
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16937c9a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11918422580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/30bf539e6f28/disk-cc3aa43b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0e2f8b08e342/vmlinux-cc3aa43b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ec7ee6ece11f/bzImage-cc3aa43b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b44ad9245927/mount_16.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=139de49a580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d1b2c58262854b97eb1f@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P5981/1:b..l P8410/1:b..l P5988/1:b..l
rcu: 	(detected by 1, t=10503 jiffies, g=18665, q=488 ncpus=2)
task:syz-executor    state:R  running task     stack:19496 pid:5988  tgid:5988  ppid:5980   task_flags:0x400140 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7193
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:lock_acquire+0x16c/0x340 kernel/locking/lockdep.c:5872
Code: 00 00 00 00 9c 8f 44 24 30 f7 44 24 30 00 02 00 00 0f 85 cd 00 00 00 f7 44 24 08 00 02 00 00 74 01 fb 65 48 8b 05 44 41 01 11 <48> 3b 44 24 58 0f 85 e5 00 00 00 48 83 c4 60 5b 41 5c 41 5d 41 5e
RSP: 0018:ffffc900041cf538 EFLAGS: 00000206
RAX: 32a75ba562c33400 RBX: 0000000000000000 RCX: 32a75ba562c33400
RDX: 000000005a44979c RSI: ffffffff8db7ed49 RDI: ffffffff8be07960
RBP: ffffffff81742f85 R08: ffffffff81742f85 R09: ffffffff8e13f2e0
R10: ffffc900041cf6f8 R11: ffffffff81ad9d50 R12: 0000000000000002
R13: ffffffff8e13f2e0 R14: 0000000000000000 R15: 0000000000000246
 rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 rcu_read_lock include/linux/rcupdate.h:867 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1195 [inline]
 unwind_next_frame+0xc2/0x23d0 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3119 [inline]
 call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3239
 __destroy_inode+0x2da/0x670 fs/inode.c:371
 destroy_inode fs/inode.c:394 [inline]
 evict+0x87d/0xae0 fs/inode.c:861
 __dentry_kill+0x209/0x660 fs/dcache.c:670
 finish_dput+0xc9/0x480 fs/dcache.c:879
 __fput+0x68e/0xa70 fs/file_table.c:476
 fput_close_sync+0x113/0x220 fs/file_table.c:573
 __do_sys_close fs/open.c:1534 [inline]
 __se_sys_close fs/open.c:1519 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1519
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f53c018e3aa
RSP: 002b:00007fff1566c5c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f53c018e3aa
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007fff1566c61c R08: 00007fff1566bf1c R09: 00007fff1566c327
R10: 00007fff1566bfa0 R11: 0000000000000293 R12: 000000000000003d
R13: 0000000000000059 R14: 00000000000789ec R15: 00007fff1566c670
 </TASK>
task:btrfs-cleaner   state:R  running task     stack:28144 pid:8410  tgid:8410  ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 preempt_schedule_notrace+0xd1/0x110 kernel/sched/core.c:7143
 preempt_schedule_notrace_thunk+0x16/0x30 arch/x86/entry/thunk.S:13
 rcu_is_watching+0x7f/0xb0 kernel/rcu/tree.c:752
 trace_lock_release include/trace/events/lock.h:69 [inline]
 lock_release+0x4b/0x3b0 kernel/locking/lockdep.c:5879
 rcu_lock_release include/linux/rcupdate.h:341 [inline]
 rcu_read_unlock include/linux/rcupdate.h:897 [inline]
 class_rcu_destructor include/linux/rcupdate.h:1195 [inline]
 unwind_next_frame+0x1ab1/0x23d0 arch/x86/kernel/unwind_orc.c:695
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3119 [inline]
 call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3239
 kernfs_put+0x18e/0x470 fs/kernfs/dir.c:591
 kernfs_remove_by_name_ns+0xb7/0x130 fs/kernfs/dir.c:1721
 kernfs_remove_by_name include/linux/kernfs.h:633 [inline]
 create_files fs/sysfs/group.c:66 [inline]
 internal_create_group+0x57b/0x1170 fs/sysfs/group.c:189
 btrfs_sysfs_feature_update+0x9b/0x1d0 fs/btrfs/sysfs.c:2689
 cleaner_kthread+0x302/0x400 fs/btrfs/disk-io.c:1482
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
task:syz-executor    state:R  running task     stack:19496 pid:5981  tgid:5981  ppid:5978   task_flags:0x400140 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7193
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:lock_release+0x2a6/0x3b0 kernel/locking/lockdep.c:5893
Code: 4d 48 c7 44 24 20 00 00 00 00 9c 8f 44 24 20 f7 44 24 20 00 02 00 00 75 52 f7 c3 00 02 00 00 74 01 fb 65 48 8b 05 2a 0f 01 11 <48> 3b 44 24 28 75 75 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d e9
RSP: 0018:ffffc900041ff430 EFLAGS: 00000206
RAX: 56b6579f03543c00 RBX: 0000000000000202 RCX: 56b6579f03543c00
RDX: 0000000000000001 RSI: ffffffff8db7ed49 RDI: ffffffff8be07960
RBP: ffff88801cb58b58 R08: ffffc900041ff808 R09: 0000000000000000
R10: ffffc900041ff5b8 R11: fffff5200083feb9 R12: 0000000000000001
R13: 0000000000000001 R14: ffffffff8e13f2e0 R15: ffff88801cb58000
 rcu_lock_release include/linux/rcupdate.h:341 [inline]
 rcu_read_unlock include/linux/rcupdate.h:897 [inline]
 class_rcu_destructor include/linux/rcupdate.h:1195 [inline]
 unwind_next_frame+0x1ab1/0x23d0 arch/x86/kernel/unwind_orc.c:695
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 save_stack+0xf5/0x1f0 mm/page_owner.c:165
 __reset_page_owner+0x71/0x1f0 mm/page_owner.c:320
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0xbc8/0xd30 mm/page_alloc.c:2943
 vfree+0x25a/0x400 mm/vmalloc.c:3504
 copy_entries_to_user net/ipv4/netfilter/ip_tables.c:866 [inline]
 get_entries net/ipv4/netfilter/ip_tables.c:1022 [inline]
 do_ipt_get_ctl+0xebc/0x1180 net/ipv4/netfilter/ip_tables.c:1668
 nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
 ip_getsockopt+0x1c4/0x220 net/ipv4/ip_sockglue.c:1777
 do_sock_getsockopt+0x2b4/0x3d0 net/socket.c:2398
 __sys_getsockopt net/socket.c:2427 [inline]
 __do_sys_getsockopt net/socket.c:2434 [inline]
 __se_sys_getsockopt net/socket.c:2431 [inline]
 __x64_sys_getsockopt+0x1a5/0x250 net/socket.c:2431
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb026b9148a
RSP: 002b:00007fff93b01148 EFLAGS: 00000212 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007fff93b011d0 RCX: 00007fb026b9148a
RDX: 0000000000000041 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007fff93b0116c R09: 00007fff93b01587
R10: 00007fff93b011d0 R11: 0000000000000212 R12: 00007fb026db8be0
R13: 00007fff93b0116c R14: 0000000000000000 R15: 00007fb026dba020
 </TASK>
rcu: rcu_preempt kthread starved for 10620 jiffies! g18665 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27728 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 __schedule_loop kernel/sched/core.c:6948 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6963
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
Code: cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 33 9e 2a 00 f3 0f 1e fa fb f4 <e9> 48 ee 02 00 cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90
RSP: 0000:ffffffff8de07d80 EFLAGS: 000002c6
RAX: 741d0ec708556100 RBX: ffffffff819786ba RCX: 741d0ec708556100
RDX: 0000000000000001 RSI: ffffffff8d997e54 RDI: ffffffff8be07960
RBP: ffffffff8de07ea8 R08: ffff8880b86336db R09: 1ffff110170c66db
R10: dffffc0000000000 R11: ffffed10170c66dc R12: ffffffff8fa22f70
R13: 1ffffffff1bd29b8 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888125c25000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000755b0000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x73/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x1ea/0x520 kernel/sched/idle.c:332
 cpu_startup_entry+0x44/0x60 kernel/sched/idle.c:430
 rest_init+0x2de/0x300 init/main.c:758
 start_kernel+0x3ac/0x400 init/main.c:1208
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x147
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

