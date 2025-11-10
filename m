Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 790ADCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 987058E0027; Mon, 10 Nov 2025 10:19:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9364E8E000B; Mon, 10 Nov 2025 10:19:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825258E0027; Mon, 10 Nov 2025 10:19:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3748E000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:19:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22ABD14016F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:19:20 +0000 (UTC)
X-FDA: 84095056080.01.60750BE
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7388E180017
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:19:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3dQISaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3dQISaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762787958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=fZ2NWlZ546cks4M6j4DNqCc2vYjUuH0vrlSlhM9Y2K8=;
	b=TCqWDn0vnFqbwPyxMjVhb+POSbEmtGSMgNa+sGz6l78fwKkWeOV7kRCGGVFhB8etgheA/Z
	+TrVUAH2gumbzh546VWCjYRIjVYj/EMCZ9vJ8LglsP+hKqbaDFoyK3gFAozoc/IgOtcVX8
	5IXDHcEHAygC6xz6g+M+HLAA3H1888c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762787958; a=rsa-sha256;
	cv=none;
	b=Hp2Thmdxw7bYRGaxTMyC/y6xOKkXuJw0LLWEilDVQ5Nz3j4Fj6xJwnLwDRSMZy8N3ofiYN
	ZOVxtCRSztaCwYRCM5DHJug5uo/qPRERQmZ/TK0t5OCNJZG60OOhPPGZwJVeM118vlvEuB
	tjFEwYDIybnwmAgZZ8LpOfLyYv0VWi8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3dQISaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3dQISaQkbABIAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-432fb58f876so111589855ab.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:19:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762787957; x=1763392757;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZ2NWlZ546cks4M6j4DNqCc2vYjUuH0vrlSlhM9Y2K8=;
        b=kf2E2VxjE0tRR6eADHO2yqj8vLilbfR0X0ogjv2ohSNGkcdvul4aI0KGGTqM67/P84
         orP8hyGfkguRU4Ufg5x+7fouTDbjE/giXD86MxDWRzhggH/isCBmcihynP3pE5hVizWY
         SzzegwJr9DzQ0G189KSMXWbq3jUtjL81hPduV8ImV5zWa9vCMm/RYgi4yfa+1h+0F1lW
         SkFvoBPPSLRFQDT8EFYKOoBCQ893Dxghq3QwWL8mYDOYzSiFyW+ZILlJXDurIcFXdiFX
         0kiUuzKQnrUdOQJ4SJT/D3HK/9SJD+EQt0wLbYS9sxI7elB6zqNSYRWkx06ASTPhc67Z
         yLPw==
X-Forwarded-Encrypted: i=1; AJvYcCWGzdts3FLkssns00l9MURy49/oPt2iHU8tPQTrZPMO4ET7h0tKKn2zgwlNrpYcN3SKZj+o49G0gA==@kvack.org
X-Gm-Message-State: AOJu0YwKAgnQcqD2mJZFbG2wNBtcY2oHeudpqz83gTyeVT0sR0kMBWsX
	53qAi6Q7fJw1CNCzsdiKtP8QUB3hd+jzUQs6pyWRumxVuodxPiTKwi7twkfxQeLYz4jNz96IPm9
	k5yZ29ZryZ7a1+MFgWl5kTCv+qdjhTx66tuoHJ+aOUdgN0J+MakDLaRLjvbs=
X-Google-Smtp-Source: AGHT+IFT43QlM8pcln8U+Eww+O0zzAExm6XXgPQBWfT6KRG7VIkvfXjO0jztElePth8ZM3wp+BZTjgkncLB2kVRNvkTts8Hag2iy
MIME-Version: 1.0
X-Received: by 2002:a92:cccd:0:b0:433:7310:f5bf with SMTP id
 e9e14a558f8ab-4337310f94amr69754165ab.22.1762787957532; Mon, 10 Nov 2025
 07:19:17 -0800 (PST)
Date: Mon, 10 Nov 2025 07:19:17 -0800
In-Reply-To: <20251110111553.88384-1-lance.yang@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69120275.a70a0220.22f260.00f7.GAE@google.com>
Subject: [syzbot ci] Re: mm/hugetlb: fix possible deadlocks in hugetlb VMA
 unmap paths
From: syzbot ci <syzbot+ci4b465da2e9479793@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	osalvador@suse.de, syzbot@lists.linux.dev, syzbot@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7388E180017
X-Stat-Signature: c8xdiaxay3n4uexg3qfn1ou4dkroeiqw
X-Rspam-User: 
X-HE-Tag: 1762787958-675701
X-HE-Meta: U2FsdGVkX19FWrkwj4JAXfGA/QzUaEh15H9V+Xo+JLw5z1rDYddc/F1NR5fz0vGIjR1Y8GQll3qI04TZrZwGHKIudUf9OKp8YZejEDjrfymRu68GEtbgIX/jwBiNif65epme4oqo2wZzc9jhTRtF5VBAMS4qAzjPaXAjKKTv2866mcEGCEIwCYozdHKNWWfiFCzN9G04OZq8TDe60ASZNeVBkxoN56Pi4O0EW8fa/cJbKM6/anqNohs6s8wsNfuB0Y/F5EPbSDE03tC7LX+tXdSZx05mZ4cID5I/hEp4xTDH7Ots5s1/+FAO9Oz4zgu0GNW2es57f7dBooclqbC0jvlqIXBet3p9hi2QRTUHiD2Sw0JWyqcsyEPGLm/VlVt8jKEZnAb9xVqxlSeAVoNleB2ZtRd3FRPW2Txji/1K0A6FN+6vjDEkyC1swZzAfh/ZMd3UJKSoqUFTxMMKZAC4YqqFYM92388pnKSrdwWYxreV48w3iTHf3q5uy7fr3viZxTEnUzfduxzsS0/JzRKN/O4wV+WVlfsPQfFeWGGIaJDO7Dfr/FWi05uYtzs5c5m8jKib9dzI1WUSB8PjH68sG2CsECPza4AZh585R7xpNeLYGAuc953aX+Cr1RpCca06vC/MEXWCb/w8nSSEyfLatf8vUco3QmA73F2lpHtOwZAMUn+Jk891N76PGDZbgwjd3ZaB5Iqh8SOyDLSTyiFKtjHN32CgCRW28AQl/tPepKU9CJEXljVciTqLaCJlu121b37WRRlDxmpV0Tl4wEtCkcUz2cJoJjfUOmnSnXbo8fEaHcjOrYtViSyUJqv9umos2stHe3Q6e7nzFtEFdha/DoocHqsbI4Ugfr6Fhay1WZNrTENcmFFSB5j0aYFwk/Qk2U8yeSWrcUYuvc94LWh1UpmEXhB4r3BcccWBykfBc6WcbmN8vT4bkL0anfjxUjlRbcHHO9+b+gRBTXnN3ER
 B7/O95aq
 oqymqQIZJxrGv2pK0vfFkOICNrqdLwlBIghqR3FXAIVYgePKzh3MumRbnzxCfEFBQRug8NNlGOahxT2syl5yX0YUFUTehkT+N/pCI0aByq6bXZyj+G42HjkTnHqREVDXzha9L1qy4hf+K0vwSW3RdTehgWr+RNBiNkcKGFyV/AuhljJmcqtJn6p9tcpNERXJWW0sYwgcJKzavYe2ljI62T/tH6ApOMHsbr2x4OIrBgPjtWdaAHNLxm8nyalGgCT5OBj4OAx/WPguGR8BaTEM61IIuj1M2TZ4Kz9FA9ylWP9CeuASL91RpAHXppFINU7W1pEekUIWF2+Aq5wLuLBU5FtUSQY1C8XRC+hFzzG101E9DX+dzdrD73pyVH3fvEXeQpNHm1iTdFU3IfbrjaFMYtLAMAyTOJVhnQDz9ApJGvuSqqdNT81JUwrXvdDf92M9+gQMGbRXtd7p2jCeY4s0x40jnvPRLO714M+HDuYeg7sl1JxgSKz7vII8zpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm/hugetlb: fix possible deadlocks in hugetlb VMA unmap paths
https://lore.kernel.org/all/20251110111553.88384-1-lance.yang@linux.dev
* [PATCH v2 1/1] mm/hugetlb: fix possible deadlocks in hugetlb VMA unmap paths

and found the following issue:
possible deadlock in unmap_vmas

Full report is available here:
https://ci.syzbot.org/series/3106300b-af9f-40dc-985b-33cb937712aa

***

possible deadlock in unmap_vmas

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/089d8dad-bc85-4724-8a79-2ad934becf17/config
C repro:   https://ci.syzbot.org/findings/3dded3f6-aef2-4f4c-9dba-b23214df5e12/c_repro
syz repro: https://ci.syzbot.org/findings/3dded3f6-aef2-4f4c-9dba-b23214df5e12/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5963 is trying to acquire lock:
ffff88816cbda8e8 (&resv_map->rw_sema){+.+.}-{4:4}, at: hugetlb_zap_begin include/linux/hugetlb.h:257 [inline]
ffff88816cbda8e8 (&resv_map->rw_sema){+.+.}-{4:4}, at: unmap_vmas+0x23d/0x580 mm/memory.c:2098

but task is already holding lock:
ffff888172c80418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:548 [inline]
ffff888172c80418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: __hugetlb_zap_begin+0x2aa/0x3a0 mm/hugetlb.c:5331

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       i_mmap_lock_write include/linux/fs.h:548 [inline]
       hugetlb_change_protection+0x56a/0x18c0 mm/hugetlb.c:6439
       change_protection+0x386/0x38c0 mm/mprotect.c:655
       mprotect_fixup+0x6fe/0x9c0 mm/mprotect.c:774
       do_mprotect_pkey+0x8c5/0xcd0 mm/mprotect.c:930
       __do_sys_mprotect mm/mprotect.c:951 [inline]
       __se_sys_mprotect mm/mprotect.c:948 [inline]
       __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:948
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&resv_map->rw_sema){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       hugetlb_zap_begin include/linux/hugetlb.h:257 [inline]
       unmap_vmas+0x23d/0x580 mm/memory.c:2098
       exit_mmap+0x23e/0xb30 mm/mmap.c:1277
       __mmput+0x118/0x430 kernel/fork.c:1133
       exit_mm+0x1da/0x2c0 kernel/exit.c:582
       do_exit+0x648/0x2300 kernel/exit.c:954
       do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
       __do_sys_exit_group kernel/exit.c:1118 [inline]
       __se_sys_exit_group kernel/exit.c:1116 [inline]
       __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1116
       x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&hugetlbfs_i_mmap_rwsem_key);
                               lock(&resv_map->rw_sema);
                               lock(&hugetlbfs_i_mmap_rwsem_key);
  lock(&resv_map->rw_sema);

 *** DEADLOCK ***

2 locks held by syz.0.17/5963:
 #0: ffff88810e0f8ca0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:365 [inline]
 #0: ffff88810e0f8ca0 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x126/0xb30 mm/mmap.c:1262
 #1: ffff888172c80418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:548 [inline]
 #1: ffff888172c80418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: __hugetlb_zap_begin+0x2aa/0x3a0 mm/hugetlb.c:5331

stack backtrace:
CPU: 1 UID: 0 PID: 5963 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
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
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
 hugetlb_zap_begin include/linux/hugetlb.h:257 [inline]
 unmap_vmas+0x23d/0x580 mm/memory.c:2098
 exit_mmap+0x23e/0xb30 mm/mmap.c:1277
 __mmput+0x118/0x430 kernel/fork.c:1133
 exit_mm+0x1da/0x2c0 kernel/exit.c:582
 do_exit+0x648/0x2300 kernel/exit.c:954
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
 __do_sys_exit_group kernel/exit.c:1118 [inline]
 __se_sys_exit_group kernel/exit.c:1116 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1116
 x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6bb058efc9
Code: Unable to access opcode bytes at 0x7f6bb058ef9f.
RSP: 002b:00007ffedbb6b2f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6bb058efc9
RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: 00000002dbb6b3ef R09: 00007f6bb07b1280
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6bb07b1280 R14: 0000000000000003 R15: 00007ffedbb6b3b0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

