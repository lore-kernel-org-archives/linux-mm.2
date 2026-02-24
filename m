Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB399EFB819
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 08:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258AB6B0089; Tue, 24 Feb 2026 03:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206256B008A; Tue, 24 Feb 2026 03:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105F26B008C; Tue, 24 Feb 2026 03:50:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECD576B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:50:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3CB31C387
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:50:27 +0000 (UTC)
X-FDA: 84478728894.20.E79FD58
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20F77A000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:50:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3UWadaQkbAOYaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3UWadaQkbAOYaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771923026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=tU4KeK3bukLdkToVFUU/DYEl43X5BYkLi3LM0va+rMg=;
	b=WbKt7DF+jyqhDDN9aCCxwNsP5VqCDIKmvFyyiG8Qt8QaA8GBEDYq/WkunZn3HxDzmfPR0a
	eYGExIpUpmEWp95EBO5AaCG9rub7NlANbxhsLH2H2Ijf6lwfFMSV0byqE7RA1jT3wauZPb
	738fAD8KxBxGdc79B/Ymq9HLEQAB/G4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3UWadaQkbAOYaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3UWadaQkbAOYaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771923026; a=rsa-sha256;
	cv=none;
	b=RF9NWcWhnfdgGXFKaoCv7sFe5z5QjUoZ9GmjvImttBZGsOuND9Wmwnw7fz0CwP+uvkcjSM
	IHBOiTpIEBP7aqz7lzOHbYgUaKcOC5xKkd6B8iVyiptTo0ARLZLKjvhsbwVlmuqARV/6Cp
	fFN7k7XCJySCzonTIiqv6P0aTjPVU0E=
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-679c5ed0942so29157001eaf.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:50:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771923025; x=1772527825;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tU4KeK3bukLdkToVFUU/DYEl43X5BYkLi3LM0va+rMg=;
        b=hupHv7pvEVIqXTQEFu6pAISGbFFsXlEDV3/cQZptapspaMr7AqYXEhKcgLC8KRMiQu
         sFMITkeGnEelyag1G308oA0i7rn8GKjrrPQH6g8FnDfNANc5jb9fvFSml/ca88XjWufL
         2DFEUbVWvahUan94IIeSQMspiyyaOhGQiG6re8h9z+eX/aHPklsXNNpJT414Nm4s83Oi
         JGTN40vSj3AxawFopZABS+NdMUjtBGulH2OHA1pfMB9rvjje1J8y0Lltv6UvOTl5zEUi
         J5bmNlgkE7kv7hpNahHra430EZA3+gNAoAPrNVIaYz8YRe2KtHbvxU77FjG1whVlIsx7
         LGBA==
X-Forwarded-Encrypted: i=1; AJvYcCX8NJGVj1JAIv3D929hDFwl+RzTYYgi7FFYHKSxUJ3WO3bq3J4TPYB76ZD2j/1CKfoqBCAKmCFz0A==@kvack.org
X-Gm-Message-State: AOJu0Yx7RiAFIgSuBcRY3/JclvVBXVUvTRuak/a6rHhpWMnxLBSqsHsG
	qOVo7oILJqPVh0Li31ZFpRn5fSChHxyBuEIUXzQrLR2kHRygSgAqF7ToZwh9otvr4FTlC1G6KIi
	eFUgoSxekusiGgqigEdsmVnC/DckGQ+d3MSwTpl7a+ShMldKZIz7OpNgb274=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b0f:b0:662:f91f:4a85 with SMTP id
 006d021491bc7-679c461d225mr6375070eaf.54.1771923025154; Tue, 24 Feb 2026
 00:50:25 -0800 (PST)
Date: Tue, 24 Feb 2026 00:50:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <699d6651.050a0220.247d23.03d2.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in sys_rename (8)
From: syzbot <syzbot+1e663068a97140bb66f3@syzkaller.appspotmail.com>
To: jmorris@namei.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, paul@paul-moore.com, 
	penguin-kernel@I-love.SAKURA.ne.jp, serge@hallyn.com, 
	syzkaller-bugs@googlegroups.com, takedakn@nttdata.co.jp
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20F77A000D
X-Stat-Signature: 4zb8to8gd1io9udsmp4sz4ttqefgxsf5
X-HE-Tag: 1771923025-323713
X-HE-Meta: U2FsdGVkX194bfcn3RAOHX5WSrb2HHUetskekYyDv04FfPhUAkIhrACHNo1OpViA0PdwYBd3UFz0IfMGaWma2FlICirkz1ajpTIsPaWbqgeABCfUiQWeQDCd5tGKt5DsGJaTP3Y4YLJTccbSXfEd8iiKG5yehV33MHrnSmFc83Lus+RDN9gwSyY1dvO8wRZK5c552ntxK1ZcNl0RsArZWWUB88LS/7nq7T09CMbzpwFdEKP8EEzVi2a9PuDgRb/0id3Vph8Kk+ppyyzUcAnQ84zyVB1bJZvZsDDKza8pxSlvnZdTQyVmMRe50I9YhoudGUuspOZXJbE0Wb6OKmaco8WWfwIPBTIOmYjxkAVbu+ewMxUrwpA4r8dB+wDKLkACMYudo4C7pvTOQgyK+hoaepNRFkrBrThmv7Mg5AeadOvQXW8QezIFaG+m7VWPaplBaFDe3Brzpha19/OjEbo3TbjTGBI7P/0ALh02TTIjPZkE/Xg+AgEE8oy723VtbC07zIWrwSBa7SKfcWb+D1ZdZj5qWRVoup12MFRFBlXnBAB5yKfs7L3Y3ictajL88zb2gKxRPd0Fl7W76MhbD45JjfA5s2fLrxQ5aeG7efL1oOynJpBBTXbd0gFyw8gDw7Qf+nDtk+5jOh1U27wAx328i9rt11LSAuuYMPuoc/fZlhwuqISTu4CGbgpecyJudy1ss3yOS5MhzPGRYuel6WQG67HXVC3ufAS4/Ol5ocAgCchtXD0Lm6kz8fOholdW8XK8LVAc/mOdS5PC2nj0INm7n1A5pngIkChIIl5qRAFkvLYnIKqHIwo8AI+21pspJ03pCjJDDSCtZwCWQVNCeV3qXb9ou5bVOfPB1KHCpWHgyabRmY0jpA7PfMX7xXxrwkr2rK6X+PJ6imcZAf9CecSfz6gPHIgpES2dinwnHkfwGNHkGrqpYX9BceaSN1RADk2gfU++Gwb5LRZQSZmCUrh
 YmhAz4BK
 FdgsI2JrdJVQtm3QW5KLQANmXwz+hnXPGXbJd8ZRNCoYGN/2WTb2Bk5hTq+gYpV4WMIlBzHebc5Euj2X8xeid2J9G2ZEJT/cBTSrBwo4fT5wiSChyZmsqGEYYF78JBzFE/+0yTYRM7wPqJ/f7PJB34PVEMahOzSpfwybVMXF2OsSXlVQtrxIrNJh/oTYjBH4YhIdzWRQ+3n3k9Ea8XKP06p6oVVjf8M61z1LLmiPcyNx93nDBMEfoVLEB3zaRFwcTpUeO93YL8HUbMP5mDN60/1mGhY6md9nmIeon1hmgI9vg2oKtRfh/exfk3bPqew367SXxoaSqVE/coasCbjpgMXgiRtPxfU/EwnCMqUMkOD5XD40QiwFZHDKw7Cgf7Mjt14rag2r8irhvBgrueeiwJFSNfDfPypzOnO7aCZVfTwyxM9B6vGkAVJIxUAZlpGAs+Z0Nl/Tw+thfSc9dzIMATNLBJ/lifVuoKu+o991K80oVcBQnMn8gYjKMl+bOIjV2mWySFiTsjZuTXEUi+R0tpx288sa+PMuTp1dRU6eArQ/90hV3Z6OPEEA/SQdwhnJo9gDMICStePtkTxTV+ihHJbT+ICTYnuGGKwytVneSyqyL5w3Dp6wsKOcHskOb1wZEZ3XCoKd69DMDUYqAOYe0wQpQwxMB5diOT8bDGULXGIvJev+wCjWfRwiBovcPnXq9kPJFV2NlLse90JLioR3ZMu0PPA81ebINrfkjkkglaMF/LfojMugMpm5A11Rkfc7Z4VEwadJaUJPHmBYAdpoJVtZ+dtq2wstxrLT556XwxwSOGkgjWSLqp3rkoUlhkL9mQne+cHjP4PMb80CxOncMl8/5vCCQQPPTU6atyu9aOWe4iPeKBm9UC/LGBDlPA4W80/lAPDo1a390t9vPRQO8Zg3UjF/Am+lHEexrdAxhvgm6Zq/q2kHr1LtqomK2yssBUX2lDvmz8oJIAsAmKHfyDUHCRGoK
 QR4PFTzL
 bt4Uajfe4L2tWnr3lwsyrj8C5N4VnaJwRoWH/VfIQAsAwrCmtys0+VPtjukJaKg4i4tQWKq5aZbWNDq0hLUnethOjgY4V07ZwyUCRd7S7H4y+F/TRLla4+feZLJ0X931AGe+pT4YY5BtFg1h9Iq4a2PaJUi5U3iqv/eeuqinGo6w37IGYgf2Mfjuy/FL4QXKBi2xX0unGQyYqTvOm0l0LdaGC6vRdKcwxdmDtdej1XCDf5THkqGQ3NNCk29giQust8LvUmJBUZmhzBnq1lZMrNU1nj+KfziggOMtjpF7LcXnQAXvvHaUyKPm+bL4x/GqUeAswpCnr2OjDIlZF1hP7zrtmslYe3YZMDPic0kOwixAlkP4O66vabmlnsy567cz/fP5UGEtDSxs9/XNg6DhNXuxQsdkkKQl673LUHqB/XGLheOd7mCUs/bw4NyjpFr8/RwYpaPeWSUFHBXIUifV96na9X8S+I7N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    44982d352c33 Add linux-next specific files for 20260219
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10ef3c02580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=51f859f3211496bc
dashboard link: https://syzkaller.appspot.com/bug?extid=1e663068a97140bb66f3
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1177fe52580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/173e988354ac/disk-44982d35.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/69062373098e/vmlinux-44982d35.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3dd3887dc600/bzImage-44982d35.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1e663068a97140bb66f3@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P1034/2:b..l P5873/1:b..l
rcu: 	(detected by 1, t=10504 jiffies, g=14085, q=669 ncpus=2)
task:udevd           state:R  running task     stack:23784 pid:5873  tgid:5873  ppid:5200   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x1585/0x5340 kernel/sched/core.c:6907
 preempt_schedule_irq+0x4d/0xa0 kernel/sched/core.c:7234
 irqentry_exit+0x599/0x620 kernel/entry/common.c:239
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:lock_acquire+0x20b/0x2e0 kernel/locking/lockdep.c:5872
Code: e9 30 ff ff ff e8 c5 f3 18 0a f7 c3 00 02 00 00 0f 84 38 ff ff ff 65 48 8b 05 41 01 a0 11 48 3b 44 24 30 75 33 fb 48 83 c4 38 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d 3d fe 3b 95
RSP: 0018:ffffc90003f073d8 EFLAGS: 00000286
RAX: a296ff60d4053400 RBX: 0000000000000246 RCX: 0000000000000046
RDX: 00000000112c4056 RSI: ffffffff8e287ccb RDI: ffffffff8c2a0a00
RBP: 0000000000000000 R08: ffffffff8176da45 R09: ffffffff8e9602e0
R10: ffffc90003f07538 R11: ffffffff81b115b0 R12: 0000000000000002
R13: ffffffff8e9602e0 R14: 0000000000000000 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 rcu_read_lock include/linux/rcupdate.h:850 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1193 [inline]
 unwind_next_frame+0xc2/0x23c0 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5219 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5231
 kmalloc_noprof include/linux/slab.h:966 [inline]
 tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path2_perm+0x2c5/0x760 security/tomoyo/file.c:927
 tomoyo_path_rename+0x14e/0x1b0 security/tomoyo/tomoyo.c:300
 security_path_rename+0x248/0x460 security/security.c:1518
 filename_renameat2+0x4c1/0x9c0 fs/namei.c:6139
 __do_sys_rename fs/namei.c:6188 [inline]
 __se_sys_rename+0x55/0x2c0 fs/namei.c:6184
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6cd687acc7
RSP: 002b:00007ffec20235f8 EFLAGS: 00000202 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 000055db72eaa280 RCX: 00007f6cd687acc7
RDX: 000055db72ea2010 RSI: 00007ffec2023610 RDI: 00007ffec2023a10
RBP: 000055db72ebff10 R08: 00000000000001e0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffec2023610
R13: 00007ffec2023a10 R14: 0000000000000000 R15: 000055db6bd089dd
 </TASK>
task:kworker/u8:7    state:R  running task     stack:24416 pid:1034  tgid:1034  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x1585/0x5340 kernel/sched/core.c:6907
 preempt_schedule_common+0x82/0xd0 kernel/sched/core.c:7091
 preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
 __local_bh_enable_ip+0xe1/0x130 kernel/softirq.c:457
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:924 [inline]
 __dev_queue_xmit+0x1e6c/0x38a0 net/core/dev.c:4864
 NF_HOOK_COND include/linux/netfilter.h:307 [inline]
 ip6_output+0x340/0x550 net/ipv6/ip6_output.c:246
 NF_HOOK include/linux/netfilter.h:318 [inline]
 ndisc_send_skb+0xbaa/0x14e0 net/ipv6/ndisc.c:512
 ndisc_send_ns+0xd7/0x160 net/ipv6/ndisc.c:670
 addrconf_dad_work+0xac4/0x14c0 net/ipv6/addrconf.c:4287
 process_one_work+0x949/0x1650 kernel/workqueue.c:3279
 process_scheduled_works kernel/workqueue.c:3362 [inline]
 worker_thread+0xb46/0x1140 kernel/workqueue.c:3443
 kthread+0x388/0x470 kernel/kthread.c:467
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: rcu_preempt kthread starved for 10573 jiffies! g14085 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27616 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x1585/0x5340 kernel/sched/core.c:6907
 __schedule_loop kernel/sched/core.c:6989 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7004
 schedule_timeout+0x158/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x312/0x11d0 kernel/rcu/tree.c:2095
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2297
 kthread+0x388/0x470 kernel/kthread.c:467
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6085 Comm: syz.0.27 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:check_kcov_mode kernel/kcov.c:194 [inline]
RIP: 0010:write_comp_data kernel/kcov.c:246 [inline]
RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x36/0x90 kernel/kcov.c:314
Code: 28 e9 7b 11 65 8b 0d 49 e9 7b 11 81 e1 00 01 ff 00 74 11 81 f9 00 01 00 00 75 5b 83 ba 54 16 00 00 00 74 52 8b 8a 30 16 00 00 <83> f9 03 75 47 48 8b 8a 38 16 00 00 44 8b 8a 34 16 00 00 49 c1 e1
RSP: 0018:ffffc900025e7a88 EFLAGS: 00000046
RAX: ffffffff81b67144 RBX: ffff8880b8423e40 RCX: 0000000000000000
RDX: ffff88802df49e40 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff81b32095 R09: ffffffff9a518508
R10: 0000000000000003 R11: ffffffff81742750 R12: 00000000100006b5
R13: dffffc0000000000 R14: 00000000000001ed R15: 0000000000000020
FS:  00007f9fec4f96c0(0000) GS:ffff888125002000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000058 CR3: 0000000075658000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 clockevents_program_event+0x1d4/0x350 kernel/time/clockevents.c:336
 hrtimer_start_range_ns+0x1687/0x1ff0 kernel/time/hrtimer.c:1331
 __posixtimer_deliver_signal kernel/time/posix-timers.c:314 [inline]
 posixtimer_deliver_signal+0x1ce/0x410 kernel/time/posix-timers.c:340
 dequeue_signal+0x249/0x370 kernel/signal.c:660
 get_signal+0x55d/0x1330 kernel/signal.c:2914
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9feb59c629
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9fec4f90e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f9feb815fa8 RCX: 00007f9feb59c629
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f9feb815fa8
RBP: 00007f9feb815fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9feb816038 R14: 00007ffda92b66d0 R15: 00007ffda92b67b8
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

