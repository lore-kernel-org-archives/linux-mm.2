Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B5AFDEE39
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 00:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C81F6B0088; Thu, 23 Apr 2026 20:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778BD6B008A; Thu, 23 Apr 2026 20:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F1A6B008C; Thu, 23 Apr 2026 20:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 573406B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:23:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAD5B1A0A6A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:23:33 +0000 (UTC)
X-FDA: 84691550706.20.54728A5
Received: from mail-oa1-f79.google.com (mail-oa1-f79.google.com [209.85.160.79])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1D910C0010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:23:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3A7jqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.79 as permitted sender) smtp.mailfrom=3A7jqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776990212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=toPj91gHoyvrb/6k9QW3xQFCS5cPHJVPPzwARqoevbM=;
	b=n3q/3QBu9Ngz2pKBaCGvWLcpLiWzFzOr9Y0LbFrfUWWepTE0yHwet1qgb5BlY5wSQqp3Hn
	tz3YmWD3f9WTetbUhnfXb/a2ZJamrRcfuZgW1trJoPwSKrVI1jlZUz+xbWkVL/7bLnM0qz
	yVYDL5kJF9Wv+b244IU+Jb9kLOmm7cM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3A7jqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.79 as permitted sender) smtp.mailfrom=3A7jqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776990212; a=rsa-sha256;
	cv=none;
	b=LCMASS50d9t1hkJV/mQizE1zcWFK29Qfh9K+1MBxUNsUyP0Ei3al5ztt+GOf7FX1Uw6Rt6
	NJBdjyqyw4lK5IaGLmroP1Vgc8gc0K1UH26pVsdBi+tToaBT1rtQNCxdkzmE6+amLx1JNU
	t25+Iw6qoe2M87YJ68QyM9Z+cKa9Y+g=
Received: by mail-oa1-f79.google.com with SMTP id 586e51a60fabf-42393e9b4aeso6704500fac.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776990211; x=1777595011;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=toPj91gHoyvrb/6k9QW3xQFCS5cPHJVPPzwARqoevbM=;
        b=aTwUnADFWtXSHc77C+yZD5n2kO9isZXN4Ff6/IYcjje4Zgz42R3VJGLrzFQbHPRPPD
         UHI/Ek+/S+4eIib/2xt328cxB+NjRZWLsp2iqC4m719srOVgcYnpADf08KaZl/SOuSCX
         mcyIkBCFwMpcxZ0ahBsbD3R9lcyhW7+iYE4aIFfy001l0Og6SFVTdwtRC1JhgAgltT3X
         JpSdxWpeKPCAgg/ktrMNumXh/Q6BPAUyLqmrWZNWKu3dATAgERzF0uMB9LH0ZAsBaYvH
         g6Kn8KgcY8mNMTSJlyYzzdkctmV8uX240Dn8VoOi84PYPadkN4qPIBdl6nE9tjdW1uDe
         NHYA==
X-Forwarded-Encrypted: i=1; AFNElJ/jLPODc44gVLbKVH0F+Lkur9uR5pubQ0aNOBhlXkGfu6kGgZbnjKA5rl25NvvzIDvmesUrYpM8+Q==@kvack.org
X-Gm-Message-State: AOJu0YwwF1G02wdnDzHW/6Fclf5linC/nPt2pSbGuYaWButF0BFFyFEP
	D8ZPrOXSFX3OYvifcw3qXwmX1JvYIvtcBDfkjfju2qdbUoqg2viMUDO6mLq6VTNjVOs2TBi9C5c
	qYzDurDk5o/W6DAjBSRZPYEIKKQw0apojngsQ2G4OhGifo+Xe+PxKekuRlWQ=
MIME-Version: 1.0
X-Received: by 2002:a4a:e84a:0:b0:692:a19b:af6b with SMTP id
 006d021491bc7-69462e57b48mr15598213eaf.13.1776990211136; Thu, 23 Apr 2026
 17:23:31 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:23:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69eab803.a00a0220.17a17.004a.GAE@google.com>
Subject: [syzbot] [arch?] [mm?] BUG: sleeping function called from invalid
 context in tlb_flush_mmu
From: syzbot <syzbot+98bfe400bc653d89958c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, aneesh.kumar@kernel.org, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	npiggin@gmail.com, peterz@infradead.org, syzkaller-bugs@googlegroups.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1D910C0010
X-Stat-Signature: qg498reokg5dird8u8u7kus3absbcc7e
X-Rspam-User: 
X-HE-Tag: 1776990211-548121
X-HE-Meta: U2FsdGVkX18bLEmA3Ab9KVA3AKy/96FSeactxMhXGPmlYzEDzD3D3Jn3lnlEX189xCspLFBaPCMDw8X5mlQseqbgoe81LcsH2OOjTtBmW+DA0KmJDmo9+fSWvHfkFmGB2tDbuDGVdH4h10Ry621K3MWzyvBItJ1Y72/E64ZnjDVawyecSwTU7D9/YGMsY2LIiMs33VWv7nn5kGTJoIdHVime+noGONuQUDWR6NDeurL1Cu+k0xBrgq7qda+qgxcO+nubXbgUvk9ENqSqiWyL6SGKlqi+v1Uay720KwisK6c8x/Z3NQutkt5tWeaaW/Tfp/sQWHMVrc/V07UxUVIloQPgNJrTST5XWLPfIT1oaQ/PcqMCBp/MUSvdaakcyLauK7LGrewPhW6xjdSQyEa3E4ZW2sjlWz6MtP6cL2ljC6XPng8Lefkl96UqaOCGuZQ4iMfIQvI+Kz5dV5/MmQivtQEM2Uxp5H/EGao3Mcf5T2aI8T+PEHiNoHVYHtTnzyuru8EPjeDrF/A8vUQT1PUBXtHnmkVTqP4z6XLNfwBAcQyQe2yh0I9seuwOhRIL45RH5mojS7ZZQp9RhiX+9QyKumaBV0tmk+wI2sqwojzCazaVVJJTvtva6N7YzIkuxHFtM1aoUkNyteg99tfDwiBmGQDPJSPyleIhcqXhXq/39LLDO6PUghiCItjuN9qsbNW5cM4pyshpBfH83khBnRLorPBVWP3dJOYME8InCWzbLyG5E2h9j2v/75ItM2z4m92J4fd1+AdNLE7nz5pskxU6+NFl2uPCvpPDMTz2UQdBEFGUgid6VwzG62Qp/J3nOm9V3orMO/BAmGexpUI1cvyZ6SUJwUPwfaBzhTKa72hwqbeCAoRXY8/BnqSjIlxRE9NAqxR+qKAv5zuH7jaM6Pqa2J2Hbkxoid0rWlyqnkEiSgeXa25i32HpK7p9jahRvaOFCH/aEIQkZswZqIClddJ
 b4LyQN/S
 ++XSq1SMP28zkvq1jeM1nEJ6W3YSv79AvS+IjuB/gUxveHMcir++eQcldgEBC/bJCjwquE8uVay+dY82qPYQTMrZcLLmXHpeMNIQF7xR86D6QJUkbu83Ozfo56AqhRiGMSdlKF2xj7pJkEw+XETsCQ39A7qtF8yfJ8Rk6wv7SqpXzSE20NWGYzW/+afDuzFGvKdWQ27M75ciKM+Q/aM0TgRZKbLv5v3zeCDMArE9/uEz9OwTnzZBPOyHTd0Nht+2+4yGad4HMMszGcM31TjO3OODoy547MRxvyvCzfDVyTRbxnl4nrD8ourFCkfJ6tbkzCiKr09BqfvbY2whqK5F+fGN4gCJrxMwwOF0oTZFvj5H7YSZoQvjD/DKFlZRnha6d+PjzaQWo0NYCCaAiGSbO0cQieci2Eiq/K890kud28HsUvey4lVjE5ykmHO5kAz15Cpng2zmd2WC9QtVfExU3qPbGzUCmSEJB0SxSdXL9+vDt6oSAu9Tqiqm6Af0WCqaY7qND+xFUMXO2N5WUtpZOLW48Tah8gcW3CMHu8eQEJQHdzal8nLGR4b8c7N1DTjQgCuJyZa6cx6Fds6aW27JkWxpdtk+oGIyzNRpwYGyI3lvPH/XEgHfOiJT60LhAY9iIYXY6Aep2vwcvHt6gorhwjzVIdJACKIAz7ZpfXKbY11mwv0/DoATsX+V2bOqnnw9JNRMFmwo3b8pD1enqNTO+xBf18lBY9JsMmHYEUkP4MlzEbqXBMhoyQPjhEPOn+grMSlPWcdCrDG+gymCglZgWng2Kzvdrgqa6z3hLW4Lu4NL4JeaHDJ2tdeaPGbtQGa8wPnugP/jIBLwfMPqldflhYfMSLkhEriC+hfSobzzB59l6se9NatW6C81ffYdxQ2sopmGZ9hRbGa5Bls1rgNSZqT77HFEh7V96enLE69MOIvstQ4XAQcBjvBOFbaF6SYRGcaVNbRoFMQrE2jrd5E7BJ1ff+vHs
 7FXBP3mn
 XAyeyHiq8HUG18oi+jAAz9/ygPeUzXXau+X2U+9XoherzM2A8+bh4eyv3zoqYfn+jaue5xjlPvC6+8XPLJyxQAvpHfKVDquH5I4DCQ+Pep52Xe3InQwMDFfdHpf2AOBbuRaX6bGFWUziGzpUBvEPaolOljVk3IMMK//e8ZmZ2jTtQm67/mX7KoQa9th4A8kwME8Kf/VJ9+xw/zjU+gROOTzDkHtf/6lN7ovQLaFxrbJ9cDw7+G/MuxOm2jflli2idnBeMLNvlRcxYFMhpQse7dmz52e9ua/EGdD1IGK6dXn2BMMckZIKFuz92SrQ0bnxkD0AV9TTsCvzYgyjQLAwOpKRj5QE7eZjxRqIXA9YCiwp13oo3PzKe4csh0tXOL38L7hEtA2WqyRSZsdrrcuKYcIVj9bph4B9mWpmMXNbMWmpNasvBrRq/EYoROp4V3eXc9NEZqnKXYadZdlVwfiw1XIPJjwdhSwc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    70c8a7ec6715 Add linux-next specific files for 20260422
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1586ae6a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d941ac7f11ceb230
dashboard link: https://syzkaller.appspot.com/bug?extid=98bfe400bc653d89958c
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a920efda9ff7/disk-70c8a7ec.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7d7626f0c3dc/vmlinux-70c8a7ec.xz
kernel image: https://storage.googleapis.com/syzbot-assets/261effff1138/bzImage-70c8a7ec.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+98bfe400bc653d89958c@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at mm/mmu_gather.c:142
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5808, name: udevd
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by udevd/5808:
 #0: ffff8880387090b0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock include/linux/mmap_lock.h:536 [inline]
 #0: ffff8880387090b0 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x2c2/0x9e0 mm/mmap.c:1308
 #1: ffffffff8dfc81c0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #1: ffffffff8dfc81c0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #1: ffffffff8dfc81c0 (rcu_read_lock){....}-{1:3}, at: folio_lruvec_lock_irqsave+0x24/0x540 mm/memcontrol.c:1452
CPU: 0 UID: 0 PID: 5808 Comm: udevd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x329/0x480 kernel/sched/core.c:9162
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:142 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6f2/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0xcb/0x3e0 kernel/fork.c:1178
 exit_mm+0x18e/0x250 kernel/exit.c:581
 do_exit+0x6a2/0x22c0 kernel/exit.c:963
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1126
 x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f62bcd8c6c5
Code: Unable to access opcode bytes at 0x7f62bcd8c69b.
RSP: 002b:00007fff29267f78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 000055dbfa9391d0 RCX: 00007f62bcd8c6c5
RDX: 00000000000000e7 RSI: fffffffffffffe68 RDI: 0000000000000000
RBP: 000055dbfa6da910 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff29267fc0 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W          
-----------------------------
udevd/5808 is trying to lock:
ffff8880406438b8 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff8880406438b8 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x89/0x250 net/socket.c:725
other info that might help us debug this:
context-{5:5}
1 lock held by udevd/5808:
 #0: ffffffff8dfc81c0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8dfc81c0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8dfc81c0 (rcu_read_lock){....}-{1:3}, at: folio_lruvec_lock_irqsave+0x24/0x540 mm/memcontrol.c:1452
stack backtrace:
CPU: 0 UID: 0 PID: 5808 Comm: udevd Tainted: G        W           syzkaller #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4832 [inline]
 check_wait_context kernel/locking/lockdep.c:4904 [inline]
 __lock_acquire+0xec1/0x2cf0 kernel/locking/lockdep.c:5189
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5870
 down_write+0x3a/0x50 kernel/locking/rwsem.c:1625
 inode_lock include/linux/fs.h:1029 [inline]
 __sock_release+0x89/0x250 net/socket.c:725
 sock_close+0x1c/0x30 net/socket.c:1529
 __fput+0x461/0xa70 fs/file_table.c:510
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x70f/0x22c0 kernel/exit.c:975
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1126
 x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f62bcd8c6c5
Code: Unable to access opcode bytes at 0x7f62bcd8c69b.
RSP: 002b:00007fff29267f78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 000055dbfa9391d0 RCX: 00007f62bcd8c6c5
RDX: 00000000000000e7 RSI: fffffffffffffe68 RDI: 0000000000000000
RBP: 000055dbfa6da910 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff29267fc0 R14: 0000000000000000 R15: 0000000000000000
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

