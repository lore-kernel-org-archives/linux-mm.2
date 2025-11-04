Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7988ACCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C7B8E0105; Tue,  4 Nov 2025 04:08:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24548E00E7; Tue,  4 Nov 2025 04:08:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60AA8E0105; Tue,  4 Nov 2025 04:08:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5F4B8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:08:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5AF4F13AB92
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:08:55 +0000 (UTC)
X-FDA: 84072349830.04.B751CE8
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A587C000B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:08:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3pMIJaQkbAJ8RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3pMIJaQkbAJ8RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=G129N04BjLFHinVS/jNh9nO9kb8p/9wuEhtZ/Y8I17I=;
	b=Fu2ncwEatzYePXAKeKsUUwX/l6MSuAh+V2csNj+RuOax2QHEEyQLXEbmrNDFpAQQNBI/ke
	CuOK4OdyozEeyDeUQGHlFgaTTkmaKfyasSeWFGPopOKndpASTbL5V2N9LaJ6oLNtjoadSX
	rHZ8W+DcAKMwUjfWAmPcTACtkmlhBTY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3pMIJaQkbAJ8RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3pMIJaQkbAJ8RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247333; a=rsa-sha256;
	cv=none;
	b=L/oVz/hYLu5n7SO4Sd5O5IS0upTKUmKujr0tCKUZvQ9IkbJ6bQ3MeJjTGh4JeGWk5Ul8uL
	hTIEcmX1uCIp5vLqT2iEciw/07bUzYmgvx8+Y3DETWzpbdDDm7gKaTH9em4Hoo6VmYM3pn
	uuAQYDHnXZVRet8sGN0NZc6Lms1QpOQ=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-433299e5160so21850875ab.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 01:08:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762247332; x=1762852132;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G129N04BjLFHinVS/jNh9nO9kb8p/9wuEhtZ/Y8I17I=;
        b=xOsVzLjDQRIOHHQj2nm71zubogJW3dxCKSnmSbnbvhEkMqf2J2OqPtxLoHyNU0edcu
         Af327RotfX7UdxWnmP2UWGDa3gNfrnOroQNuoMj9oJgTE+7ge7m9/Zw7o6X/s6zVxP4Z
         fcGaBTCq5V8Uettc2rjIXS/RrJxqmM3fxWwF5YGY6TGWarJtyWK1RGyawhSJpHB8DdXt
         LQ7YC03TbeGxh6qlgFO7ntwDuai1lb07HseS9CZBmtO/BFp6x2pBFD4Uz+x2KA2vSv9W
         f402cnBGPpL9R8yLYZOGBkvAU0/petVhI6rl/T16XjPxmCu0KcME89oJtkaNaoyX/4bi
         /vgA==
X-Forwarded-Encrypted: i=1; AJvYcCUhQkH1oSaw5BRF+u28Tq83HyEQxHxrIVEzfkDyy24ezc1DKSYCtz6Y1W3CCthA8X59kLfD9Vs7yQ==@kvack.org
X-Gm-Message-State: AOJu0YzYNRQWHEKA1ToYjY75GGaSzVl45d8IhQvQfyaupH/qK5wxUV8I
	qHJoaKGSNDTWc7Xav+fWIgVGwyoDKhgjtLIrNMzI2qSmD/uAfsswDISIjETp2w7GkXsMzN6tb6o
	+HGqp43/FwExI2T2Cp9CBKswDVWRwNwo5MRQTZAucSrAcfhhQpj6ZHDfS4cA=
X-Google-Smtp-Source: AGHT+IEBKE3inw+JwQHUYR/CfJd/TNna+rZ8yMk5BapQe/jriuxDSLwOcefxZiBHukbRgMdnVUnA08TMDKHpdhgNeA+5YD0JsZ1t
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1606:b0:430:aedb:3719 with SMTP id
 e9e14a558f8ab-4330d125bc1mr217117295ab.4.1762247332639; Tue, 04 Nov 2025
 01:08:52 -0800 (PST)
Date: Tue, 04 Nov 2025 01:08:52 -0800
In-Reply-To: <20251103180348.3368668-1-willy@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6909c2a4.050a0220.98a6.00a8.GAE@google.com>
Subject: [syzbot ci] Re: vma_start_write_killable
From: syzbot ci <syzbot+cicf36371c0f59f4ad@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chriscli@google.com, jannh@google.com, 
	liam.howlett@oracle.com, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz, 
	willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9A587C000B
X-Stat-Signature: yozrh67fuwyxod1chzcejpdxpcxogzzs
X-Rspam-User: 
X-HE-Tag: 1762247333-255368
X-HE-Meta: U2FsdGVkX1+kTmc7S2xJFKPa5FjF9A8o/bAnIG8ndeZSLBcuIrwJWOMMGsr2JLawm8TKrtRuF6pyqqESrXgx+vrqQxCx1RKLux2YRxbs136o/SJL6+IaC9P8bR4ftqAv1JaT1FAxLA5+/gYqa3kKMNpRSJxspzloph0kHAej5AHeIr3Ub340MuW42g97u8D/jS91YLIk4+OZ1i4CPLznP+mc2x4WB/hhrKRvAWZsTvA9ec6VvlIjQDrzEpE2gGrR6kidd73R41GwFNxRyQ4/SLqdymYvPekfnk0ODCYz0sx/U7lgHJTd6d39rFKgAoI3zBiMFi2w4gTZfML0z+cEl8VaV6MoEzl8xuCym5qxBr0YaIF5MMYnVFmzNAeB1uSwv/9cwljXtv6LTyAC7THU5OUwH2HWNUzmhvQoO1tcHUZzD4wU4ntqQqdStyFT9qOi7TNbIFPF3ayLqOtzSCjneIV4jCqdwV3BmbLx1nIanOaqDZ1Vs8zvS88pnWpopjLo8HiKmdAU7gyAPe3W0oqwdlmnxxFnXwuC6cNtfN5SPpR8NuAa9mrbmgG+BloqMufKlbDQevx/A2P1vR+S/nrIymlfzimAvTYqUhs/FB9v8ue8ZRY+qoAt/BzrwTRJOLhHN0l0I+4Vfhfe4X8vxsmR4XDrDzjKxf9dO1hUeOEHjrnEvg1FnmWLoBraMTlTM5RpLm3EWIpprygfJF9Zq6xDipWlnRkuv4c0PDH4ikkfo9s/xrH9IHjZVWbLy0gN9kvBNhHm+BAbVH+otSSJ1Ffz2P3piGuuwDuwNfAeTfbkhzUPn0VCrI2HgKp/QcQs6edxZTznNKAWzTP4fvFYLZDhgebvzQgAtEJoUmnaYgJlhcl9VsLlBFioKsQzwnz727xAo9Dzh0H45B8CILRy4+5pdp+1xRuf+86RedmVo44YUtKTfuHuH1uYxpDhOFgXZSNh/C0QzkPPerI0V5f1TyI
 zT1CP2En
 qs1AWjtcqWRIOYA6VTU4pWwbChzSFlAytvTDPI+zvrDYNe4V1n+EEAKquJCy4PRPtT7QEqzsH62WQ+FuF7JWjBgaydnwxlSlp4dgQzTmruwsVnnE6AwZ72Naj3X17jsrLMqfetxUMS4ncLedIJ4pEOaHfMGSfmdzrcbi9gJQg9wuVXLnABuqCkzjikxdmYVCcJnPlUexhqLuoHod2jXdNbtO/Qe9FWdRqPVxtSXTywIOGYdoK2lai/tEM9cPD835SrTy7xDj5KdJP+E9RJf7+wtZqEPA0UxgRCMb6yfAinxORBQOsX3+I7cXeOMmM8PsnwjdmL8Sl2ZY6GS/I8kchuTyd5oda9h5irb+ZS98iFKMp/oHMIgn/1xVV9LirU95+GKycfuteNNIcUAsQrVXziwUYD3jW6KKkeomLkGTGbiCeR+wqPUVYW+gymzPCMTLOxtyE/W5kBBQoc2rsIJO5hCRGKtBs9YI3yFMgsYXi7SKiHTw6+faNPwvjns4KDeIz2QspIIX2S6N7muxxXuKE6iRqM+GlsKJSDW7SSqckLuGjhnO47/NH1xtdemBNTf6CwG/O3Kw/xMCMP/NuuOAPeS4SQNW+lJ6qblmZQWaFkklbpQCP19xUm2eRFQNbCnUpob6qcwsrYyOsnW1+69O0Rh1dqw1SsVxSWNySynjV+Xv/38UkHh4zUXD2FEfAWmthB3igpoByHDv2wG/8kf8BX8TZJMQVTv27rm3Q7QehOzI6EpLyAOVsPwYheczdBbmCIWwdxTW+nu9KwdxGUjk8rmh0xvRstnkA3o9Ww98FKDcINCFiH6TdToft7N9Dyig+jG3o69yAEUzP2qLZxT9MzubRJ4gyETJCjZdWPq8gnzwPlESfUdedaxdssHZCvGOLTOD6HiZ27rr9EaBZjNZNDsvko53EppmFhlM4hOdOuQmr1m2w+7IoJXK7iDPIMbx8s16BN7TXJm07yEiK+b/090TMg4dB
 DUinvJiR
 JbJEODaoUTQ0ZJsytr9Pkeup/UlbgeWy1XrHpPTsZyyuQGv9VwPJ/Np7ySCMvbfVqKwaN2f74UrNCJWtwITyWXMHCWCKTf8frML6yt3qFjjzNe3E0P2uzOJ8XMRwsivAvYR65Bch4KtdE6qNFLgmgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] vma_start_write_killable
https://lore.kernel.org/all/20251103180348.3368668-1-willy@infradead.org
* [PATCH 1/2] mm: Add vma_start_write_killable()
* [PATCH 2/2] mm: Use vma_start_write_killable() in dup_mmap()

and found the following issue:
possible deadlock in exit_mmap

Full report is available here:
https://ci.syzbot.org/series/3eb0eeab-3254-43ec-ad2d-e439ab81ad3e

***

possible deadlock in exit_mmap

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      fd57572253bc356330dbe5b233c2e1d8426c66fd
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b55422d4-9fe5-4a2c-9938-3e67223a358f/config
C repro:   https://ci.syzbot.org/findings/ecb8b9e5-1c01-48c4-b7b6-9155dea27118/c_repro
syz repro: https://ci.syzbot.org/findings/ecb8b9e5-1c01-48c4-b7b6-9155dea27118/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.24/6004 is trying to acquire lock:
ffff88810f7fcd20 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:395 [inline]
ffff88810f7fcd20 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x126/0xb40 mm/mmap.c:1265

but task is already holding lock:
ffff888111ad0f88 (vm_lock){++++}-{0:0}, at: __vma_start_write+0x23/0x140 mm/mmap_lock.c:92

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (vm_lock){++++}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __vma_enter_locked+0x1a0/0x570 mm/mmap_lock.c:65
       __vma_start_write+0x23/0x140 mm/mmap_lock.c:92
       vma_start_write include/linux/mmap_lock.h:213 [inline]
       mprotect_fixup+0x57d/0x9c0 mm/mprotect.c:828
       setup_arg_pages+0x52a/0xa90 fs/exec.c:670
       load_elf_binary+0xba4/0x2740 fs/binfmt_elf.c:1028
       search_binary_handler fs/exec.c:1670 [inline]
       exec_binprm fs/exec.c:1702 [inline]
       bprm_execve+0x99c/0x1450 fs/exec.c:1754
       kernel_execve+0x8f0/0x9f0 fs/exec.c:1920
       try_to_run_init_process+0x13/0x60 init/main.c:1411
       kernel_init+0xad/0x1d0 init/main.c:1539
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (&mm->mmap_lock){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_read+0x46/0x2e0 kernel/locking/rwsem.c:1537
       mmap_read_lock include/linux/mmap_lock.h:395 [inline]
       exit_mmap+0x126/0xb40 mm/mmap.c:1265
       __mmput+0x118/0x430 kernel/fork.c:1133
       mmput kernel/fork.c:1156 [inline]
       dup_mm kernel/fork.c:1506 [inline]
       copy_mm+0x1f3/0x4b0 kernel/fork.c:1541
       copy_process+0x1706/0x3c00 kernel/fork.c:2181
       kernel_clone+0x21e/0x840 kernel/fork.c:2609
       __do_sys_clone kernel/fork.c:2750 [inline]
       __se_sys_clone kernel/fork.c:2734 [inline]
       __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2734
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(vm_lock);
                               lock(&mm->mmap_lock);
                               lock(vm_lock);
  rlock(&mm->mmap_lock);

 *** DEADLOCK ***

2 locks held by syz.0.24/6004:
 #0: ffffffff8dff64d0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm kernel/fork.c:1488 [inline]
 #0: ffffffff8dff64d0 (dup_mmap_sem){.+.+}-{0:0}, at: copy_mm+0x131/0x4b0 kernel/fork.c:1541
 #1: ffff888111ad0f88 (vm_lock){++++}-{0:0}, at: __vma_start_write+0x23/0x140 mm/mmap_lock.c:92

stack backtrace:
CPU: 0 UID: 0 PID: 6004 Comm: syz.0.24 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 down_read+0x46/0x2e0 kernel/locking/rwsem.c:1537
 mmap_read_lock include/linux/mmap_lock.h:395 [inline]
 exit_mmap+0x126/0xb40 mm/mmap.c:1265
 __mmput+0x118/0x430 kernel/fork.c:1133
 mmput kernel/fork.c:1156 [inline]
 dup_mm kernel/fork.c:1506 [inline]
 copy_mm+0x1f3/0x4b0 kernel/fork.c:1541
 copy_process+0x1706/0x3c00 kernel/fork.c:2181
 kernel_clone+0x21e/0x840 kernel/fork.c:2609
 __do_sys_clone kernel/fork.c:2750 [inline]
 __se_sys_clone kernel/fork.c:2734 [inline]
 __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2734
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f45ab18efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f45abfaefe8 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f45ab3e6090 RCX: 00007f45ab18efc9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000001000
RBP: 00007f45ab211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 00007f45ab3e6128 R14: 00007f45ab3e6090 R15: 00007ffe9b2a02c8
 </TASK>
------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: CPU: 0 PID: 6004 at lib/refcount.c:19 refcount_warn_saturate+0x13a/0x1d0 lib/refcount.c:19
Modules linked in:
CPU: 0 UID: 0 PID: 6004 Comm: syz.0.24 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:refcount_warn_saturate+0x13a/0x1d0 lib/refcount.c:19
Code: 20 57 be 8b e8 87 a8 f9 fc 90 0f 0b 90 90 eb b7 e8 6b 8c 36 fd c6 05 1b 75 dd 0a 01 90 48 c7 c7 60 56 be 8b e8 67 a8 f9 fc 90 <0f> 0b 90 90 eb 97 e8 4b 8c 36 fd c6 05 ff 74 dd 0a 01 90 48 c7 c7
RSP: 0018:ffffc900036f75a8 EFLAGS: 00010246
RAX: 37ca69179b3b1c00 RBX: 0000000000000000 RCX: ffff88810c6c0000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc900036f76b0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba650 R12: ffff888111ad0f80
R13: 1ffff920006deec4 R14: ffff888111ad0f80 R15: 0000000000000000
FS:  00007f45abfaf6c0(0000) GS:ffff88818eb3e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f45abfaefc8 CR3: 00000001bbaba000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __refcount_add_not_zero include/linux/refcount.h:187 [inline]
 refcount_add_not_zero include/linux/refcount.h:212 [inline]
 __vma_enter_locked+0x534/0x570 mm/mmap_lock.c:62
 __vma_start_write+0x23/0x140 mm/mmap_lock.c:92
 vma_start_write include/linux/mmap_lock.h:213 [inline]
 vma_merge_existing_range mm/vma.c:905 [inline]
 vma_modify+0xce0/0x1970 mm/vma.c:1608
 vma_modify_flags_uffd+0x204/0x250 mm/vma.c:1697
 userfaultfd_clear_vma mm/userfaultfd.c:2030 [inline]
 userfaultfd_release_all+0x34c/0x5d0 mm/userfaultfd.c:2149
 userfaultfd_release+0xe7/0x1b0 fs/userfaultfd.c:868
 __fput+0x44c/0xa70 fs/file_table.c:468
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 get_signal+0x11ec/0x1340 kernel/signal.c:2807
 arch_do_signal_or_restart+0xa0/0x790 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x72/0x130 kernel/entry/common.c:40
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f45ab18efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f45abfaefe8 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: fffffffffffffff4 RBX: 00007f45ab3e6090 RCX: 00007f45ab18efc9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000001000
RBP: 00007f45ab211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 00007f45ab3e6128 R14: 00007f45ab3e6090 R15: 00007ffe9b2a02c8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

