Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65581C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0242A6B0088; Tue, 22 Jul 2025 11:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E4D6B0095; Tue, 22 Jul 2025 11:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7AE46B00A9; Tue, 22 Jul 2025 11:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5BBC6B0088
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:17:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BC39B9873
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:17:36 +0000 (UTC)
X-FDA: 83692254912.24.43E7CE5
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	by imf21.hostedemail.com (Postfix) with ESMTP id CA8981C0009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:17:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3iqt_aAkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.78 as permitted sender) smtp.mailfrom=3iqt_aAkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753197454; a=rsa-sha256;
	cv=none;
	b=IhYlKI4Olp0FtESX5dHF3k34INZD9r0EfXMa74W0gphP5vp40LqrgYZtrvNdCIIoJt4Tc+
	1oUaIvqz4DFscEYX21hTjuzJ+nq4B4NyabZQ6D5DRNX5fSRT/n1v5IHm5XzNAaUthkwFw7
	p/szHV26H3eBshuNYS20kwTdP2gGUbE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3iqt_aAkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.78 as permitted sender) smtp.mailfrom=3iqt_aAkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753197454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=wmyd6XAvUPNz3WJI42+ETXxM5nefYwl4sg3Kyc9Zirk=;
	b=a5ZHAR6hXM/MKRqnxUHV//gVUuQSSkrk1LMbT884wVVC24RctRWWq1F5EHZkipPcz3X4gw
	cEFlSnMNJszlWVQ8YcKdcQrT4F30Yn1jMYuNusnpCvMP/TO++B/h0simTsS0PJigCKWpUn
	3LWy4L23m3XJqIQBXVcsJMsummRBSBY=
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-876b1339851so232952839f.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753197454; x=1753802254;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wmyd6XAvUPNz3WJI42+ETXxM5nefYwl4sg3Kyc9Zirk=;
        b=R25Z+qTt/NMibu3XX2kBok6Bx7pdghtwGcMWHh3C1jFgMeIAzKb2nuoII/J6AbzG/z
         NfbdEf8vacbnjRvDy0NELojCFZnGkciQJ02O6M6nMsa+FiEP8L4I3ie1IPZOZku/F/vM
         DyTPHz2F2sxeZxHnq6Udc45hWii4bX6qvF9uA5BYFGKc2W2rL7cHZSH+bHFHdX8cOe7X
         cr4IkC6H1fTQa/9qS/X2wDvQJoXVQpMidlz1kXxdFBS9wIQxSB5K32FTglXcAq/qT0eP
         NiwvTVB0POTyz+U9TKkSaFhA6SK8g3LNKCf0dJpJSsbY6hRYeI3A6RhpWKM70TSCB3kD
         AThQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwpJAYSGOouZw/nZ0i2N07vq6473wJxjL7LNm0hE7uFYSaO0Zyx+hgo4zOATjkOJJAWM9/UagbCw==@kvack.org
X-Gm-Message-State: AOJu0YxPhVfCiL1vKcIH4H3TiagAm/P/NSPcO6N5JnukjZf8JQVtD5bT
	c31k0+ak9wa++9Kg6TedZ+ilpbTVKi7MAgAcT98TCbNqI1h8dzZ2UjaoDfhzPeLL9NdCWn/8+su
	L6BnXA7zosi2qh3lTN288M73EvT++0+AsymhLmQNNeh8GJFumY4hhdczNos0=
X-Google-Smtp-Source: AGHT+IFaZVkLYIY7cjuvwnLtdewQvSUzhywQ7t9Oj/Vj6j2ZWERYx9pO89FXZg+btXHjSdGd+mbb5IgBSMcEYNSu/Dd+/Fd+Bly7
MIME-Version: 1.0
X-Received: by 2002:a05:6602:a10a:b0:85b:476e:ede2 with SMTP id
 ca18e2360f4ac-879c2b7a452mr2400560339f.13.1753197450372; Tue, 22 Jul 2025
 08:17:30 -0700 (PDT)
Date: Tue, 22 Jul 2025 08:17:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687fab8a.a70a0220.693ce.0104.GAE@google.com>
Subject: [syzbot] [kernel?] INFO: task hung in exit_mm (5)
From: syzbot <syzbot+1c6607097b258f18065c@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, brauner@kernel.org, 
	jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mjguzik@gmail.com, oleg@redhat.com, 
	pasha.tatashin@soleen.com, pfalcato@suse.de, rostedt@goodmis.org, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: b41cf6zzezrpw1ynebfxnkdwm1wix9rf
X-Rspam-User: 
X-Rspamd-Queue-Id: CA8981C0009
X-Rspamd-Server: rspam02
X-HE-Tag: 1753197454-946467
X-HE-Meta: U2FsdGVkX1+/VUUWyLS1Qad7LhK7TX8RNbcPOQPO2JT7++6dbEZJXhZbGkF2K3hQAP6zgDj9/wBVKqYuYk/5YeuDV0UrvDRKruhrGYvDDZL92ogtzBIv8cKUJroc1yZLPvsPZ9dvskbfUzSvJ2ORZS+VcZpjduqKm5IJUA6vBbJkyrXjpfVY2AtrjKbQpRc4fJk+nGw9YUtbVbtrSYjkpcTxXOPspqbPoGsmNFosZ+QeR/HE32klatdXbj2wCWjk0VUYR0QCipNjSUxiFZIVASmXBLFl0Sqqr6ux/mnVg+MMlecwv+zFvnuywRlsEifC7eYbBIwN5iJh7AjUgKrKK76CvWY5YzqcK6tBpcJ0+UCwiTNWobdNgjkZn3meRirBubJ2KuSFvirCcr3//t84WdKvUSFdmS5kFwmIGPK5Ez6d2Wiph+a2OoujQvUiwdbEpy7vsjBE9S7nmvxFfTNqlxZ4VNeoQKa783N9EIkF09C6i6AkHwPVcZX5uqqWsBIgCcUS5AzblGwcFsFLrxjxqXVe4QvPRF2SrcVrFup3mnsGoDWOuQZfJjrgpK6m1dlHBslSIAlGsh/zEv2a0eOqTNHGEWyUJ1EZKGco3CwtnUgY0hv6oHIfTUovQHxM6hZaJh87s3otzjjH4/fUmSHoUi7RiS15/t71dP/WUr8tnZGKG2eH2OjM5HocHP7qmVylU5fEN3ceQ9hXgOG29t+roO4ZWVZOQCxSqp8V/PmIvq5XlN114fBU28IRSOQMWbK7IqUFtx6XEi+r1Owpa7PJzkX1IeqWRjDwbN/5eh5TjKKTXuR4OQhht2xeMTfAgph4DfwL0meueXwLm30stf2GOgBw3Lw0a4TEoTeazPKg6AR/EkTAcRhMKGc2AwrZwLzGa0MEUgCBiqgEpsrExfq7YFJt/NRRiuswbfAywx4fM6iR2lDdR0OxPbcqIgDoHDqIVpOtW812oRRjC/Gk/B5
 hV2QMViI
 uvh4aFvpyISrO8+NpQ8Q9HOr6TSqOkTC/yqA7ADtM3XaKVdCgBRpuO/aHY60s73sDIdhYD5IGzoqs138gwG0H3CekaHIOBHVKmYhEf26OrYOYjNwKmOwb2Dhjsdkk3Q3O/GZKls6rvIH8C4CZVqNbmU/YjbBM8BoW+wUd2I+GaWQFeTIIDGUGXYO5BLdmmRrbdmfcJfm7B5y+XLpOuxTTryF/Mbo6F2l3/SItWeOOYZGEuO+K+leD6FgvkfbDy+uQf5gTQm5OTUDC4zkmo4RuYiX+723Bubcd1QaTtQNRmpUCwqDc8uZbf2eiJ2zsQQfVwRgWSlynx2f+Ky8MCh0fS8sQBEjTw9ltrU96NAfyzKF4h85jCkQav1ZqmHojd7ZoDUffM1Gse9HPB5+kg/JJ7tz+fRiIx69pIcG3RNtvU6TMl1hotLfgWJ8Yfk6iBten8aVYJ4bcGgjUVQShEbyDEyDEfTS6vcX1zjcY5i7v0oA9oSw03gv78I49SxysX25bPquk3EEyOxeiFa2bd419JHV39Z/QPKSlsy3Mt4XH5ULht6ocn/Sgxjb/ksPqHgCSxFKQsqda8j/EIRWutG0Es9VhtEqgOngMrHNe29ReEaz1utogmOZs3+Ioj6zePGeydQl53+N9TKWHj4o1BBh155khpU7taFVA5xaWbBElfbJ1ZnR5EVXi5UZSOGgeoAV3gN8zZkkaWL36oisf3BizbJ7hX/NU3EvUp6rs54dNT/p0647POMjczCp8CqHeD/GbmDREaOXW1f5Ner3RqCZ3pFczYT4/nIbnewEV1xH/cWDMoW+xWOZnDYIzevYgxb+x208VS0/VjeK844C8AqUCtZUr15TkcECB+41Vnr9AuU4vQE+vp9JGXiXB7qbi9EiazFnlKUYdxF2nWah99BZE5Qj6Dhb+MhbQ1La8i867sNq0kurUNSW/mcEJ+09O2rxCb4YdxqK5wZ0m3L0ZJVDgJxvSneAe
 iw2A92Fy
 fbdQ3x3DTJ/t4BE1ywzZQC5tpWB26JvWjVC0q6qz4o35e6zDmhq0MigqcM9esPAf/NBYHJ1Co6ahTX9gIjW2rJlLLpfmQ3baDr91hgj4fjFaXHrAY/lY041EIa/2I8SyDLNnZI/eYMrcVNpen9sTQQoFAsjdO3mNeDIUX1RcAYMdic9O8ugqrTFCl3eg0XJoCIc2b1kJCSGlCgEJ1N9Jcmsk6Xe31Mi0LUAGHsLY1RwgpZ85KIzd9NVcXBdrKNYf/YWeU074yzUajeCct5138C2sRq5PqaRUNC1HRMyYmBkC/vkhgiYknPUpmLNL2wYGy9sRVVoELkpZWkrGOoGAYgsaQTUoKp4kpo1DSzypddXiPpjLP0dd+o1Rbk0yc9Hp3LwMkFEQ8dFchrU2ulP+V3d8fOXkNpZtCl92tSAA1PD5clHejRNHxe1fYP8R3JWUhqsA+8UcP5A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    d086c886ceb9 Add linux-next specific files for 20250718
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15c4c4f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cc0cd9fdf69889c3
dashboard link: https://syzkaller.appspot.com/bug?extid=1c6607097b258f18065c
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f1e38c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c4c4f0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4435f80a19c4/disk-d086c886.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9a7dc57a5ea3/vmlinux-d086c886.xz
kernel image: https://storage.googleapis.com/syzbot-assets/da9f2dc22ae1/bzImage-d086c886.xz

The issue was bisected to:

commit d22f1d61e7d950dccee81e3ed75ff2908aecd1a9
Author: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date:   Wed Jul 16 19:29:54 2025 +0000

    mm/mremap: reset VMI on unmap

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10e42f22580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12e42f22580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14e42f22580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1c6607097b258f18065c@syzkaller.appspotmail.com
Fixes: d22f1d61e7d9 ("mm/mremap: reset VMI on unmap")

INFO: task syz-executor942:5848 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc6-next-20250718-syzkaller #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor942 state:D stack:25848 pid:5848  tgid:5848  ppid:5846   task_flags:0x40004c flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5351 [inline]
 __schedule+0x1737/0x4d30 kernel/sched/core.c:6954
 __schedule_loop kernel/sched/core.c:7036 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7051
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7108
 rwsem_down_read_slowpath+0x5fd/0x8f0 kernel/locking/rwsem.c:1088
 __down_read_common kernel/locking/rwsem.c:1263 [inline]
 __down_read kernel/locking/rwsem.c:1276 [inline]
 down_read+0x98/0x2e0 kernel/locking/rwsem.c:1541
 mmap_read_lock include/linux/mmap_lock.h:412 [inline]
 exit_mm+0xcc/0x2c0 kernel/exit.c:557
 do_exit+0x648/0x2300 kernel/exit.c:947
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1100
 __do_sys_exit_group kernel/exit.c:1111 [inline]
 __se_sys_exit_group kernel/exit.c:1109 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1109
 x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f70d2bb1349
RSP: 002b:00007ffd9c81a718 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f70d2bb1349
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007f70d2c3d2b0 R08: ffffffffffffffb0 R09: 7fffffffffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f70d2c3d2b0
R13: 0000000000000000 R14: 00007f70d2c3de40 R15: 00007f70d2b7f160
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e13d8a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e13d8a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8e13d8a0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
2 locks held by getty/5605:
 #0: ffff888033a1b0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
1 lock held by syz-executor942/5848:
 #0: ffff88807fbd57e0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:412 [inline]
 #0: ffff88807fbd57e0 (&mm->mmap_lock){++++}-{4:4}, at: exit_mm+0xcc/0x2c0 kernel/exit.c:557
1 lock held by syz-executor942/5849:

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.16.0-rc6-next-20250718-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:328 [inline]
 watchdog+0xf93/0xfe0 kernel/hung_task.c:491
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5849 Comm: syz-executor942 Not tainted 6.16.0-rc6-next-20250718-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:mas_next_slot+0x7b4/0xcf0 lib/maple_tree.c:4718
Code: 08 4c 89 f7 e8 7d 0c b3 f6 49 89 1e 48 8b 44 24 48 42 0f b6 04 20 84 c0 0f 85 f8 03 00 00 48 8b 44 24 10 44 0f b6 38 41 fe c7 <44> 88 38 48 8b 44 24 68 42 0f b6 04 20 84 c0 0f 85 f6 03 00 00 48
RSP: 0018:ffffc9000413f320 EFLAGS: 00000206
RAX: ffffc9000413f4fd RBX: 00001fff829eb000 RCX: ffff88807d0fbc00
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 00001fff829eafff
RBP: 0000000000000001 R08: ffff88807d0fbc00 R09: 0000000000000004
R10: 0000000000000003 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888076c6d200 R14: ffffc9000413f4c8 R15: 0000000000000005
FS:  00007f70d2b6c6c0(0000) GS:ffff888125ce3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005634ac61d168 CR3: 0000000076c8c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 mas_find+0xb0e/0xd30 lib/maple_tree.c:6062
 vma_next include/linux/mm.h:864 [inline]
 validate_mm+0xe1/0x4b0 mm/vma.c:652
 vma_link+0x366/0x450 mm/vma.c:1799
 copy_vma+0x70c/0x940 mm/vma.c:1880
 copy_vma_and_data mm/mremap.c:1184 [inline]
 move_vma+0x81f/0x1840 mm/mremap.c:1282
 mremap_to+0x6d6/0x7a0 mm/mremap.c:1406
 remap_move mm/mremap.c:1863 [inline]
 do_mremap mm/mremap.c:1906 [inline]
 __do_sys_mremap mm/mremap.c:1970 [inline]
 __se_sys_mremap+0xa0b/0xef0 mm/mremap.c:1938
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f70d2bb32e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f70d2b6c228 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
RAX: ffffffffffffffda RBX: 00007f70d2c3d308 RCX: 00007f70d2bb32e9
RDX: 0000000000001000 RSI: 0000000000001000 RDI: 0000200000000000
RBP: 00007f70d2c3d300 R08: 0000200000481000 R09: 00007f70d2b6c6c0
R10: 0000000000000007 R11: 0000000000000246 R12: 00007f70d2c3d30c
R13: 0000200000000000 R14: 0000200000a96000 R15: 00007ffd9c81a698
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.092 msecs


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

