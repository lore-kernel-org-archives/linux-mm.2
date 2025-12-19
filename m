Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85650D78785
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93A46B0092; Fri, 19 Dec 2025 10:15:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22FF6B0093; Fri, 19 Dec 2025 10:15:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2FA76B0095; Fri, 19 Dec 2025 10:15:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF40F6B0092
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:15:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A171130BC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:15:35 +0000 (UTC)
X-FDA: 84236569830.15.74E160E
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf12.hostedemail.com (Postfix) with ESMTP id 313E540024
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:15:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3FGxFaQkbAFMDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3FGxFaQkbAFMDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766157333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ZrLXi5yFv0qYWcnJNp69lP7G3qb5LjucnWTiIeW8S9Q=;
	b=AWUlALVn6zRmPVtYNvp1bUWdT8pjcOMACRCpnjJuODi50ekzOmcdjlmfgTwupVN72Q+1Uv
	OO7DOT9rgdYFw8EDyqDL7ri05as9++J34lPDODcKXQLfVDv6zq2vEKfIH9TAYn9BVBNKL8
	OzI26YBfUcjNsusDoHLeDP6JWh1GkF4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3FGxFaQkbAFMDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3FGxFaQkbAFMDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766157333; a=rsa-sha256;
	cv=none;
	b=HfIeOg3hiaBQkO5LBciktRDIGvpdQJnCOpvKQdAtvx2OB7yw0bxxHje4Wfbkj5BEWFeaTT
	A6f5ErPZ0702JhkXTPKyLaRjZywXm/C5gyxRidvOnKg60N/gOsRthgeLsiy0VQd3i7VSQr
	4sV4A6H+5SHMmt8H3pR/zGSLxECBOqw=
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-65b31ec93e7so2905253eaf.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:15:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766157332; x=1766762132;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZrLXi5yFv0qYWcnJNp69lP7G3qb5LjucnWTiIeW8S9Q=;
        b=M286X9tZIim5NQBfsEqW1mnSTm2864s8pYJ6+EVnRSzVbtkq3JkF6SbE7XfDnQTV2u
         5w1g62tw/AbDM4NR3JoAtqH6rKwzZGeN1Lcrs/HtgDf2zdB/42V9M6jko+K9d6RPD9Yp
         Nak9/7e5xzavD8XcUbs03D0Msb7pfk+9hdxLeMmd7/txnwfsRK5TiwiAngfiLdxflinw
         Nw1EgyYeATY+U6YxzeXW/nRHmNfSs13SkhtmUQ+wEArkO49G3OhZoet0tVJ5KbnZpei0
         r+QBFLg5JT5tTsgoBdYQBfHVeJt4yi+5UHhovIByrVjiTJPJmNSuKhqpPQPDSyd5/i2m
         Bfkg==
X-Forwarded-Encrypted: i=1; AJvYcCVKrshS91oofnjyrsNCGnnTECAvcfOglXls/QqQCMJO324ALzJP8PXKCu0nuvX0puLTyZj0h+Pf1g==@kvack.org
X-Gm-Message-State: AOJu0Yye9z6iyF/AK0/xgG+xC9+DqV8FPEk101i0tEGyTocYYP8IOfli
	ldAjwIeEjl2d/GJCx2nNjxRWr9rHrVyF4XS51J5lfJKj6/u1Z/+uc3Rm4HiWWgpWDKjlAUfnOPJ
	Ac4NJRBtAhHldITMpRDjFlOmhnOQU213FKsZUwhyh5gRIuuswNdyLqVw10QI=
X-Google-Smtp-Source: AGHT+IGo1p/eAOFq2gEg6L7vcl5bVFW/wX9QM04M4QuMiVtQUVMFgRZE3Pa57iTjNPK2XquQ4wXDw3yAEkjc2YOlIsCW7rfP5ajJ
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f028:b0:65d:579:95d9 with SMTP id
 006d021491bc7-65d0ea9bdf3mr1468400eaf.41.1766157332172; Fri, 19 Dec 2025
 07:15:32 -0800 (PST)
Date: Fri, 19 Dec 2025 07:15:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69456c14.a70a0220.207337.0115.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in sys_io_uring_enter (3)
From: syzbot <syzbot+a62ea1d07ee6ab5ec277@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rd9qgffeaq9tx3k9ou5ci7ar4p5kg9f1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 313E540024
X-HE-Tag: 1766157332-304635
X-HE-Meta: U2FsdGVkX18LegFTRYGeqQ2cRotxTxLIRsxEuPeZF1V+JZltxAiHZr4yIePJEeke6gDNpbh6/5rVa1zmFLFUPFhqu/3qhk1EFA+o5bp4iAedam2n1jdBfQYuIlkPiKyKv4I71On0FgQxJWSyCerqaSzPIZK+D8I9fEHZxTea8VUnoTcZf75n6nYbbywmuf7UjxrawYwBgrFCJgC68kwjxIwYQZI2S8q8R8yX5Xx0pVxodTZ9LcaY1fA4vxLGzp0z27On4G4eCHs99ztXiILFMco4idV2+c8FPjQwL1oRjTjd7Cku9wxV4w0ua5KaZuraTylsv5lbBXr8eiD64rwE2S5oSNMxeVnSVw658/A4EWYCjwO9B+Avyn3vPo9fD8M0RB3oiLnf7DaXaV+SSlOdJF2rzSkkyjSVaxdJLnj3d/DQw2eNc37LdrSjqcL6zyBw2rm5eh0RV2KwWErnoBmROpMm0WgqexZjOe/LLduF1sr84m6z+IBPZPzCceV7hBTs/C9BDoS1vlXtujg6BSF57Nh5AJ2ZlSZYeM0hwaF6DVY/Jsd/UrG7zznbqjo5oT1ilbAEgeleHw67LkrKdrnnk4crf2R2P9ZFnFLiJmZaembHH4szdvcdlR4KXC/IBXTruOECg/bvMS2BCAQ9ogCcQecQALTP28a+bxbZgcFBoom+BofvezPZowp8JMjQ9fhCHuz35wgTKZUkbm9fTjkOxOBf4EiwcRplc+gKtv48yvZFO7ME8ZrsdWi3RznNSH6Zo9aLTZL1T/7J6rVd1mqpnVUmNtoSF7HiB2AckX3KnG0clcyyd0OxoBYmm8EnBAXu6pck4UOjTy3O3J1reb96HgKmTsZ/0fXcRc2/DDrM9iIJmzNnrEYebSgHC/1ussEUQYtk6O0zsPcQ66VJE3dREJlpqWHMiQpbFLf0k1AkSf+fW3PgfTwP20S05sqdGN/ZekUweliLxOrIVT4G8KT
 u4zfZOQR
 d5s275xub/CQ0QbqPdWWDmP6e+z+lwYW4b+3hxDF+h15cXu7BOh8KisVXTS6LF+7s1eca18aq+ehnFJmUjI43a2wajuZHXidm6BpnbcBmOAxOYW4NEoJ90mOOSdurjhwPsd82Rq6p8e9pGJkKTKIX615IeGNCF1I6uyUksEpZ5FG1t5ZIsZT7GgdOx5SYxuxORj//JK76h/78cV/s3vwrgzRK7EK11kV95Qdb8MFlDYN2nuZM27pQkTo/50cpkoHPXTUl7SXaS11Oh6CCKZ3jj+jWUTda61pqqihKURti8rG5HYd98XwAkKDZBLawRxNK1nbSAo3TDZ6JgittUCzd6tI4aHK7oyt4qxADWAsP93gvdVsTz9XA3yo4Ud98HcTyTifB/uIxM7DAEWeoRx4TDwBjIuuVFJdeMkwMMM0ox8L90QyDou5LN59N/6co9DzcylV1pDFmbG95PjyhbLWFdIi9HBbcyRT+JhU30qN+BPCjkhN6cG0lMY1u/7ESCzJXluxBVCjImUJw59vRQRKihfMffj1bHq/6cOLqEOVPsgpXfgxF7EV+ohGJ3OfJfDT6g+6Qg+K3QubosTME87huzKTwWgQ8Ta5Mxa76goLnlWcyv9k7v7KLAaSh48l/DTOlD3F0H45DWFLvsBwOWorJEZkpkz38sAnimLkCyIh7Md5EOOnsdUAk99AOSInsfPgYrihM2EWeEDpD59R0cYeOjjQ4X3Q32rpCuBymFd7IwjE9/+V087wr5DjVIxg3/OxBhlnk5aJgt1ls7TVBCcV5AZg1EzStJpdtccfWkJRJ+3ypjzWhcjk59ST1jav/VJDMrlDbAcyeMD5rEMBbUo8YJ+7R1E9R7oQPruRaQ1BK3D0fuG0Ce547HsXUTV/hc2kuIGUBKX6Ayfivtbb3/PqRczHWTo7T4WJpbgqPs1JJ/IGcejLwJ/Wsc1AHIP8BrF33DffIn/2lfBgEuLvxYEt27yqTBmke
 Df8CsCAI
 hJvsHYvejTK8R0HicwM4pYQWMtS7TcOg4aNgwFyHkHNqMCpOMxnqP0u0GInYe6RWI3xO0bONRuIjwONXyGQ1yNde3FtyL+H9fcBZhfjodA1U13DyP8dGHTR3T2bdle9bZFhlPdgfznTzoUv43ZmExrEVsTv5uVRSkdGOtqhBwyxSQ3NY+TPBFfQ2O0u9roCiqaA/8UhXqIbxxrYUE4J4OllHfHZ/WwQ8uqVF/RUk8Q8KWNYiPbGoEvfvJKdR7Cx0AcLhbuNQtaQLYCKWwxmONyLdOsmEW+ewIEjq5slTNCWzEwiNU8I3N4ajyMDQec3BBwZtbd2PS6Qdhv/3+mMA3u0Ony/W0IsSAl2i6SuJK+5jvXubhWdrfDF+VGjT9nRfYO8rISUHdG0ekfnammMy1NlBOUjP0l/ZpJDKyZSa7yDrdhds2QeCeZ6EbUicG+xTq/SX6JuZgLqGTvWpfUTFCAz69PiU9CVB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    8ffd015db85f Linux 6.15-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=137b4fe4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a972ee73c2fcf8ca
dashboard link: https://syzkaller.appspot.com/bug?extid=a62ea1d07ee6ab5ec277
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2640fd4fd0f2/disk-8ffd015d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1c5931df89bc/vmlinux-8ffd015d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f8fece45017d/bzImage-8ffd015d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a62ea1d07ee6ab5ec277@syzkaller.appspotmail.com

bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6067/1:b..l
rcu: 	(detected by 1, t=10503 jiffies, g=10825, q=1601 ncpus=2)
task:syz.0.44        state:R  running task     stack:22760 pid:6067  tgid:6065  ppid:5852   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5382 [inline]
 __schedule+0x1b88/0x5240 kernel/sched/core.c:6767
 preempt_schedule_irq+0xfe/0x1c0 kernel/sched/core.c:7090
 irqentry_exit+0x5e/0x90 kernel/entry/common.c:354
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:lock_acquire+0x167/0x2f0 arch/x86/include/asm/irqflags.h:-1
Code: c7 44 24 10 00 00 00 00 9c 8f 44 24 10 f7 44 24 10 00 02 00 00 0f 85 fd 00 00 00 41 f7 c6 00 02 00 00 74 01 fb 65 48 8b 45 00 <48> 3b 44 24 38 0f 85 72 01 00 00 48 83 c4 40 5b 41 5c 41 5d 41 5e
RSP: 0018:ffffc9000b6ef1e8 EFLAGS: 00000206
RAX: 85be2b162476f200 RBX: ffffffff8ed3dfa0 RCX: 85be2b162476f200
RDX: 0000000000000000 RSI: ffffffff8e4fde18 RDI: ffffffff8ca1b520
RBP: ffffffff9368d020 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000002 R14: 0000000000000246 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 rcu_read_lock include/linux/rcupdate.h:841 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1155 [inline]
 unwind_next_frame+0xd5/0x23b0 arch/x86/kernel/unwind_orc.c:479
 arch_stack_walk+0x11e/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x11a/0x1d0 kernel/stacktrace.c:122
 save_stack+0xfc/0x1f0 mm/page_owner.c:156
 __reset_page_owner+0x76/0x1e0 mm/page_owner.c:308
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1262 [inline]
 __free_frozen_pages+0xde8/0x10a0 mm/page_alloc.c:2680
 discard_slab mm/slub.c:2720 [inline]
 __put_partials+0x160/0x1c0 mm/slub.c:3189
 put_cpu_partial+0x17e/0x250 mm/slub.c:3264
 __slab_free+0x294/0x390 mm/slub.c:4516
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4151 [inline]
 kmem_cache_alloc_bulk_noprof+0x4fe/0x7c0 mm/slub.c:5375
 __io_alloc_req_refill+0xa3/0x330 io_uring/io_uring.c:963
 io_alloc_req io_uring/io_uring.h:450 [inline]
 io_submit_sqes+0xc47/0x1ce0 io_uring/io_uring.c:2331
 __do_sys_io_uring_enter io_uring/io_uring.c:3402 [inline]
 __se_sys_io_uring_enter+0x2cd/0x3560 io_uring/io_uring.c:3336
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f744438d169
RSP: 002b:00007f74451ef038 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f74445a6080 RCX: 00007f744438d169
RDX: 0000000000000000 RSI: 00000000000047f6 RDI: 0000000000000008
RBP: 00007f744440e990 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f74445a6080 R15: 00007f74446cfa28
 </TASK>
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)


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

