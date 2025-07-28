Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47074C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 23:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48A96B0088; Mon, 28 Jul 2025 19:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9976B0089; Mon, 28 Jul 2025 19:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F446B008A; Mon, 28 Jul 2025 19:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4FF6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:27:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F10CB944B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 23:27:37 +0000 (UTC)
X-FDA: 83715262554.03.0A6BD4A
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6501440002
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 23:27:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3ZgeIaAkbAN8TZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3ZgeIaAkbAN8TZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753745255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=hD5qCfVKkQkP0GM9gjEI3OSR5qeZPRyjb0lH1o5UpyI=;
	b=5lVMbHPXubVDoJXFVsjz8oVZrXONborUnjH+i1Kn3WemgjhYqXeD24n1PaJ99AG+/hjsk3
	Fr/nOWY1q55OcSU3TkRs1qRxVKUggl6iNFEoyf3Fl4wiiBaTRHFVDNZ8OLDSyMHXtz3Whx
	Hap5HUfQ4DvPhhVkblYoVOsn0QeY0yM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753745255; a=rsa-sha256;
	cv=none;
	b=oSbtRglc9qcBGfI03KEVncbOCV53fAdV7cf9TiU6vh11Kzfvx3l0ULQ7X2IZXZK/BqNb5p
	eXsYmcW7n3JbVKCd4fKMvbHVPlcIUXgXtzShOC+JWhcUeg6FRwTotNJ0WYvowja9V/Jfwf
	dqv7518MX92HteXUY+F2zzKhCK7aHZM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3ZgeIaAkbAN8TZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3ZgeIaAkbAN8TZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3e2c230d55dso51774995ab.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753745254; x=1754350054;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hD5qCfVKkQkP0GM9gjEI3OSR5qeZPRyjb0lH1o5UpyI=;
        b=FXUQu8V0OO0rVz51hwXcPWjMUzII6njg9q9Xdrfr3Mz0ijutPRmzqLvoAC/9qJHiny
         3MvSzj8NJbtDoXPoBO0GX4abNAJc7vdfKUHdm4T57zRHIO5USqkQzspBV6t6aG4WFlm4
         icv/Fur3cusPvRCsZ49nZq4nao+DdgSaPdvzdTHgS/zhw7ua7XpqAPd0pLXM5n2/tmR4
         vbbVPO5wYGgl/t4nT0qeHzg/1kyuqWNqKRwuC5hyRh4i8JVdQY5DNJJZlYrxb9iszgp0
         OpW/GwA6T34yUEa0gcE/UsG1G0N7CusEeO121RHqug3VUpdxAW5qRql9Jyz4h09J0mRq
         9z/g==
X-Forwarded-Encrypted: i=1; AJvYcCWdMYuzJ96YTUzbtvj79ErHrkcjWOsMAyl2l3jC6cMU27Z5NioYx7KFd+WAIGOM8ouOxEKZvoDynw==@kvack.org
X-Gm-Message-State: AOJu0Yzn2hiT27K/9doIyDp3BYaZZVW/8V3SnvcOLNzu/MfeDzKAwA6H
	A7NKWeU1QyGAkP4VDf3UEqIIBtMkK96KFcH4XfyL+LIanY1XvKOXo4fVJv5VCpSvrNN1rCx189P
	+dRsyJui4+hnRhLp74d7JrvgnK+DSeCNfCLAp0Dn5o92qVwP/rcjxzM9UJ20=
X-Google-Smtp-Source: AGHT+IHhXsEtfhTdqeefK2LawH5pZPtCQBSt2iG1H1PkCV5Lvfs4Sxa6MHL1kQNWFql45es2q2U05rl9bb4G0SYRFz0BF0DKd39p
MIME-Version: 1.0
X-Received: by 2002:a92:c26e:0:b0:3e2:9caa:7cbb with SMTP id
 e9e14a558f8ab-3e3c527d214mr185025325ab.9.1753745254372; Mon, 28 Jul 2025
 16:27:34 -0700 (PDT)
Date: Mon, 28 Jul 2025 16:27:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68880766.050a0220.3cc461.000f.GAE@google.com>
Subject: [syzbot] [kernfs?] [mm?] INFO: rcu detected stall in kernfs_fop_open (7)
From: syzbot <syzbot+19d01f6082ec61dd45b2@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6501440002
X-Stat-Signature: i1ic51uidoutyf1z9d9pamz88ecsxu1i
X-Rspam-User: 
X-HE-Tag: 1753745255-526655
X-HE-Meta: U2FsdGVkX1/jbDWziFzWXBko43quuV+hHHJDcHXxyXg6KYsl/aSFqdgbRu96xNGLwD5t79owGlZVLw/NSSNoBBjggvX7+UIVwOkhZyLG5lAwAV5HqzsZGVnuuIGnwCTlTUEb5PLiekUX7kCwFNwEvb02jo70iP8/pIPUjqYUifpa+9BfNUgG+w5UOxdFv2/wVTLzeI0L6j8y0glHb5zWhM/XrT/cdwUqVQ+txwt6hPIc/i78zEJskcMvj2Qfcd5IJw8w2B/BzDOZFQqjIYiZoAWFH4Vqloj/R+gH2C8EQ/Km0AJ5VNEz3K6eO23eJY7mgB72KH8RVTWy6GtMco/qmkNHxH01JKUi2AphRgKzCY2DKBnq6ujKGuRYdfyGjJcahBpg6iIBddyZHtgWmRirE1DKDXmfCyOyqHQMg1GCIY+p+8pILQvLbuXA13TFHCBLRAzur38Z/EagnC2eKmDIUIs6oZU7XxYDxhor15xTqpGtuHmCW+aA22FbDG8OO+/yNOMSFLDi1nugvtlUDXc2UL6USfl2DG/Rk6vQeaB1uvpAhwW5pVqk7Dx/mm/GFy0fxmBXy0NEgnvWnmxh8/mGHSIRx7MKRuGOs90GPinezqjh6PvA5+RimPbUdy1QK0fr+YTGki2c1hkvKUILeUJErol/cMapHqS40kG90kVVms9t7eg83i3ksFjq48oZ+GqF2mYn+i/fyj+wZEvLTlusUtGLBQMn8vTifV2S1kTJp9v/+1Gqijr7G2x1cCn0GLBIK9pkxxMTJFkvzvjxyia9aXUtOYV+aK+Oq87eUhrUDsjCjcnw/I4ran82Nxhl1Zu4chvIJ7yT/yweX5xH7nIezy4gKhXIg+1EdkhacE63i2MT9yXRl6v01VkxgDiH5NIztWwcZvSv2yI+oeVZYsCJFC6VyHhYdVF/jQyZujboVK5WxjAQyOCXUjLxTldMaunb2xFBmdEuyJMQcBonzNU
 3mD8Jjya
 Tum6iUzUoZ55U/UVXq1o3m+izrSH6qWkImkezKmw5iuhKjRz12zlnf1MKhrI24ENFlflens1SKCrCC3LtoFrhYWKgdC0wNezD4gu4OmDQwJjohpeNet1pJ+vZUB8Q+MYw1cpAxBKI0tIdTxlSjjkMfBkGFCYUv5o9fTZSbaS2K/KecmcD9Kmdaj1m0bPxnvX7RWMMfMmVHhzLsEyAdMxAblZy3TNAsGhNd/EzmmgLwS3urmOdEyj5lZn5/x4sSErF9mNOpIsA0+gsrpBArf6iprqchCbGYldgVp55NmeUpm2ToXS/ep9Ca81/DvKT3jr00pZSzNqzAjkDrfpPtqOfCXFKVOjb9LlEs1rWb0xrVeG0shd+6bdvHF3cnbi+1uWVVvKjaMEnOuGv+cVjoa8C7X+3Cn9n+ENHwAq6Fa/Ap/sUG804eIM1u5gCcZMMPqOBprvYiyZAXlhj8dvLeYN8V6pSVvjDWbxKYV1iQLYoYdNlnMj9yuRx2geTjngnzd1NQyqUc4VqLJ0LF51z+l72xc4ktHM+m5miF2ZPkqb5LuYfUVCxOxH2lf5lKVc/10ZRSEliFszcJlu6SY4KLolFDhTbFFVh77WoJQkrRLJo3vDusdW0Bnu1sjJNfBLCKiTl/cjRKcEtSoWudVjqhQMEFNEfDoRTOb5GnB1E57VEE2h0dNUw8MpP/asMMVsOZW/JqalmFkjpTjCQtC8oXvLhdGVmJohMqmD+8378HU4tQMPye8duzN2dWizWBAPea+XCetZi5OYbB0eX6GEhyuRIU3PqA1CyIWtmJqanZO8s63sQQnPQgJqAtSYZ9TXKtEQPFyEotdx/BHCitAdM9Bw+XjqN68SI+8FBPQJZarTMPXitqJK8TpycAMiYLA1PQDqoGNuQkFiA7M4ileSURdL+J7cpThz/To0gljzKfjyMWqhnu+61EGiLopGRjnnXQfV9bmDHr9jdDoAHZINKDdV9X9EB7qxm
 FqIWKbxv
 DsSVJj1URIelUbQukdhETkm2w2ZODYi71R2g8s4aTkXXaJD+UbOLGcLqPLOmt4UEgyqTy4MYkhCG7eGG9as7fTFCAK9k5ngb/e/9sSoAYBkpdKkSqrYEO5dYEPo0yI3lemHNxP2XZ4wvjwTNDmnQN+QX/b5//Ct+ocTUp0lVkhTth8rEAZr6SQ2Uc8dhegOH2dyAjMRoNt9488POOl4ermsJEXV+jE2u/qgfQUjcKkClzRQQmUUYrnMFQn3RqzAZNnnj5Aq517hBM3xWsJec0D6Tj0LH07c0b3Dk3b1c7Q+oE771gX6WVIX+33kwAfpHLuwHgdrr4gff6g4ISJoTUPVXKxP/nzLRWaCmkh3xzB0nVRhwaKy9SYfcJ9WGnwmpk5z/DOW5FYxrH4c6QbnTP6oJR/emnf2IC55TAFr3ESs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    25fae0b93d1d Merge tag 'drm-fixes-2025-07-24' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a5bfd4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4bcc0a11b3192be
dashboard link: https://syzkaller.appspot.com/bug?extid=19d01f6082ec61dd45b2
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1656bb82580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a070a2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/26a32daab34b/disk-25fae0b9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/44b0af5dddac/vmlinux-25fae0b9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0687991f0381/bzImage-25fae0b9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+19d01f6082ec61dd45b2@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...!: (1 ticks this GP) idle=375c/1/0x4000000000000000 softirq=18409/18409 fqs=0
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P5512/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=12441, q=623 ncpus=2)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5955 Comm: udevd Not tainted 6.16.0-rc7-syzkaller-00034-g25fae0b93d1d #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:hlock_class kernel/locking/lockdep.c:234 [inline]
RIP: 0010:__lock_acquire+0xa4f/0xd20 kernel/locking/lockdep.c:5237
Code: e5 ff 90 0f 0b 90 90 90 31 c0 48 8b 3c 24 48 83 78 40 00 0f 84 8c 02 00 00 41 8b 46 20 25 ff 1f 00 00 48 0f a3 05 f1 3a 09 12 <73> 10 48 69 c0 c8 00 00 00 48 8d 80 f0 82 48 93 eb 40 83 3d 38 ca
RSP: 0018:ffffc90000007b70 EFLAGS: 00000003
RAX: 000000000000006d RBX: 0000000000000001 RCX: 00000000ab2b819a
RDX: 00000000001bf57d RSI: 00000000f5f6d907 RDI: ffff888061b90000
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff81ae7962
R10: dffffc0000000000 R11: fffffbfff1f43b9f R12: 000000000000006e
R13: ffff888061b90af0 R14: ffff888061b90b18 R15: 4d4df099ab2b819a
FS:  00007fe3e1610880(0000) GS:ffff888125c23000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f509ec85f98 CR3: 0000000032c5c000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0xa2/0xf0 kernel/locking/spinlock.c:170
 __run_hrtimer kernel/time/hrtimer.c:1765 [inline]
 __hrtimer_run_queues+0x602/0xc60 kernel/time/hrtimer.c:1825
 hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1887
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1039 [inline]
 __sysvec_apic_timer_interrupt+0x108/0x410 arch/x86/kernel/apic/apic.c:1056
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1050
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:26 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:109 [inline]
RIP: 0010:arch_local_irq_save arch/x86/include/asm/irqflags.h:127 [inline]
RIP: 0010:lock_acquire+0xc9/0x360 kernel/locking/lockdep.c:5867
Code: 01 11 85 c0 0f 85 eb 00 00 00 65 48 8b 04 25 08 d0 9f 92 83 b8 ec 0a 00 00 00 0f 85 d5 00 00 00 48 c7 44 24 30 00 00 00 00 9c <8f> 44 24 30 4c 89 74 24 10 4d 89 fe 4c 8b 7c 24 30 fa 48 c7 c7 20
RSP: 0018:ffffc90003197290 EFLAGS: 00000246
RAX: ffff888061b90000 RBX: 0000000000000000 RCX: 0d0c881f9d5e1900
RDX: 0000000000000000 RSI: ffffffff8172ab02 RDI: 1ffffffff1c27e1c
RBP: ffffffff8172aae5 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc90003197458 R11: ffffffff81acfe40 R12: 0000000000000002
R13: ffffffff8e13f0e0 R14: 0000000000000000 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 rcu_read_lock include/linux/rcupdate.h:841 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1155 [inline]
 unwind_next_frame+0xc2/0x2390 arch/x86/kernel/unwind_orc.c:479
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __kmalloc_cache_noprof+0x230/0x3d0 mm/slub.c:4359
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 kernfs_fop_open+0x397/0xca0 fs/kernfs/file.c:623
 do_dentry_open+0xdf0/0x1970 fs/open.c:964
 vfs_open+0x3b/0x340 fs/open.c:1094
 do_open fs/namei.c:3896 [inline]
 path_openat+0x2ee5/0x3830 fs/namei.c:4055
 do_filp_open+0x1fa/0x410 fs/namei.c:4082
 do_sys_openat2+0x121/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1463
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe3e0ea7407
Code: 48 89 fa 4c 89 df e8 38 aa 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffe447dd8f0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fe3e1610880 RCX: 00007fe3e0ea7407
RDX: 0000000000080000 RSI: 00007ffe447dda70 RDI: ffffffffffffff9c
RBP: 0000000000000008 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000556b9eca17f5
R13: 0000556b9eca17f5 R14: 0000000000000001 R15: 0000556b9ecbc140
 </TASK>
task:dhcpcd          state:R  running task     stack:21384 pid:5512  tgid:5512  ppid:5511   task_flags:0x400140 flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x16fd/0x4cf0 kernel/sched/core.c:6786
 preempt_schedule_common+0x83/0xd0 kernel/sched/core.c:6966
 preempt_schedule+0xae/0xc0 kernel/sched/core.c:6990
 preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
 _raw_spin_unlock_irqrestore+0xfd/0x110 kernel/locking/spinlock.c:194
 spin_unlock_irqrestore include/linux/spinlock.h:406 [inline]
 __wake_up_common_lock+0x190/0x1f0 kernel/sched/wait.c:108
 sock_def_readable+0x1fb/0x550 net/core/sock.c:3583
 unix_dgram_sendmsg+0xd78/0x17d0 net/unix/af_unix.c:2236
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:727
 sock_write_iter+0x258/0x330 net/socket.c:1131
 do_iter_readv_writev+0x56b/0x7f0 fs/read_write.c:-1
 vfs_writev+0x31a/0x960 fs/read_write.c:1057
 do_writev+0x14d/0x2d0 fs/read_write.c:1103
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f810cb46407
RSP: 002b:00007ffd0761b7f0 EFLAGS: 00000202 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007f810cabc740 RCX: 00007f810cb46407
RDX: 0000000000000002 RSI: 00007ffd0761b890 RDI: 000000000000000b
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 000000000000000b
R13: 00007f810cabc6c8 R14: 0000000000000000 R15: 00007ffd0762b9a0
 </TASK>
rcu: rcu_preempt kthread timer wakeup didn't happen for 10501 jiffies! g12441 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
rcu: 	Possible timer handling issue on cpu=0 timer-softirq=4027
rcu: rcu_preempt kthread starved for 10502 jiffies! g12441 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:27128 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x16fd/0x4cf0 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6879
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2054
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2256
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
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

