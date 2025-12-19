Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3006E66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4826B0005; Fri, 19 Dec 2025 14:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28CDF6B0088; Fri, 19 Dec 2025 14:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BBC6B0089; Fri, 19 Dec 2025 14:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01C5B6B0005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:37:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A35FB139F1C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:37:30 +0000 (UTC)
X-FDA: 84237229860.28.EC9CEA6
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf01.hostedemail.com (Postfix) with ESMTP id C8EF04000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:37:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3d6lFaQkbADIgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3d6lFaQkbADIgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173048; a=rsa-sha256;
	cv=none;
	b=qUG3xQofKvvgeLApKAZe/2mn+k9T5sp2twf7Kx8BW1RzCAzPWsClivHcUSMi7q/QvMrNER
	JJb80mDlbDd0eO016c3Xzc9elZZ4+c/ynpY/OEzXXKZa2I7DLcaxfs+QtkJn8OiyquDwrC
	p5PaXN+DL3fVs6abWQAI1/HmkiIX3jU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3d6lFaQkbADIgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3d6lFaQkbADIgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=BP0RWLAyRhHu9ohQtCCX4/g/RB+AGRKBZSPWi5YHOa0=;
	b=HQqpdM8j7Iy4hyuTQUWSPLET4kr+lUy4sBofyObBwB4UAhs1N52MPGccd2RDkqS0wFq2Km
	JV54sIj0QJy8t6sPNgs7dMD13+V/5srxCzcbTDr1PDf318sFH9+9gECuwzkiUYlvhxJBtE
	vL2WaLcJSpXjuhTp08reNUi4h+8XyaQ=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65b2fb9d54bso3198285eaf.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:37:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173048; x=1766777848;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BP0RWLAyRhHu9ohQtCCX4/g/RB+AGRKBZSPWi5YHOa0=;
        b=m99XnLeNgI9rMk9FKkDYM3LUN8J4PmFy7Bn10zHhphKpYm5+2pF6vfzA4xktMjpy2j
         wlgbY1uniYAzWi9HeBJGx1H3t1lEOVnqoQBx6WAEQsgV4kAeBeRbmK/qoYCB/tAqh4SZ
         nnQ7meQAP/MQYDn+gu0sI0VcihJfn0HGYmDXEQ1nGPEDJ6xUhOdz8xOKSIpbgMO2XcqP
         1+wmTS8If4TIhXmFVmexXpC1r72nzzn11O2381UhTL3dLrj/pHANzk+FAVo4FDFUxVHn
         32P0MeDL1pWDucoCwLKPi0iy6B8b6wiy08tx3ZFpK1xZDI31f1w3dId2lGXVvnH+xfmb
         XZ4g==
X-Forwarded-Encrypted: i=1; AJvYcCXh8nJ5CLWwkUzzrtOroCvbj5tSpLyhv366yGNIz9g9G2M/iVSvJiZZxpx5wz5a6GI6swtldlBxlg==@kvack.org
X-Gm-Message-State: AOJu0Yxj8irZ5pgkUsMLtuSpPTHHbjoSsU0X4Tq3wre+IyYRXleHT++L
	GQcwY95DjlvfYTMI+Gbu3FGbu08g9Qs4bO9wQ+rVJFI0IWD3s3BIh699M6fYCRPVtgjaTIODwGE
	ntgF9o7r7y3PBv+RQIb7PhLCGhHVdHdZ/eVoZWmq1c8ZRledXREXm3lCtXGQ=
X-Google-Smtp-Source: AGHT+IG12J63ubVefcKRPgqZoGvqHvqElintOD1u5pd2UoSFgJ3SLnY95dRb91ewhelNq/D3bd4EQHqYumD/xRSOmG7kSn0OU5wQ
MIME-Version: 1.0
X-Received: by 2002:a4a:ddc1:0:b0:65b:2b26:8022 with SMTP id
 006d021491bc7-65cfe667108mr2922608eaf.6.1766173047808; Fri, 19 Dec 2025
 11:37:27 -0800 (PST)
Date: Fri, 19 Dec 2025 11:37:27 -0800
In-Reply-To: <68a7eee9.a00a0220.33401d.0168.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6945a977.a70a0220.207337.011c.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
From: syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bigeasy@linutronix.de, 
	david@kernel.org, harry.yoo@oracle.com, jannh@google.com, jpoimboe@kernel.org, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, peterz@infradead.org, pfalcato@suse.de, 
	riel@surriel.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: C8EF04000B
X-Rspamd-Server: rspam04
X-Stat-Signature: je4wytxusxpbox7ipd8wdz1wha1enjud
X-HE-Tag: 1766173048-889364
X-HE-Meta: U2FsdGVkX1+8BmLx07UR8kEqnzz2uLEan49hZeZLzbFc5UAR44DqiWIs+WsedSOOZHbXsiN21CIzh5b7BiMgTe1Gkmp4ybDoYUYFgLniFz1js2MSVFZmUHu8Uq/BdkMqbeqoF+UUCt5k41Jp5E6CnP+/6RmaKv57UgaOW2bQK+hhUKSRdiyCoUbQzN6hb8lk/ejcmw02vzl0WRQx1rddtTFfZ6FwD0XOJlnCdgGCBH7ENyxzwxkiPFJYTBVVWcjb1Yvw6gIUAAgdXg9rCnMjWcCz4OYBHaglLpsNp5p8BZ8Hp58Zl7Ra0teKEXnzxvTYECsGx5GoWHKkJWuqVUgSZEGXCqVVhiRpdWTE2/K4QHOXAdSitcAgxZ3ABRjcBj5NRRn14MxnPb0BdHPRXOJ8MiSn5V4MHWqWvJZoG/bxSmlqqY0Npyany5aYwWjiY7l37Kszyapw6GpmBglDBj1VJWnxpMDjMH2U0Jglwv2SbTwFiZzuqdiiLOuIoeUZxhPLYObzg2qV0SQpxOcaNZ9UZaPfthjnUP0LsadFNr1zphC4LYOpJpuHsV9oxViEo0Pawo+tD343L+6EEF60ykRn2shsise3dI0LJRKnhucC+z6cEecvMOAgBuPqb4vT9Vhw0geoV4GJoASr1ujlsx4SjR4nKAOyvYIEiYxHsrWeeL2wuTJe7n8CY1kwGjj+6kqPkdmBwVmFasPMHiRdYV9gjGkBXP4e/Y23l12jovIxg52pQpfn4R0vhFZTN2LhvQDafvm5dg9+OHPOATDOJ+0hmRS0MODAuCHwreRTVlBh9d4nPLA+94Jqsaxmtl8s/DUVM0so7mHJYku5eot3KYCIMTzTcpddmvbaaSJC0RA3NHMm9LrJVp4kMOEt5/h08Xjdc4N+KEYVVjDO8e2NbkV3zrUpVMpz/R0pDMnWQJ9/VtzLnDqOgUwTzhFiHjHOS+++d5sOBC9AgzQm7LBCqqe
 zaSWnFpw
 lGxmpkvQWKtD/fHgr5BysR6eXsb1ox4Il0YgI2ERu8xXg4iI0LoRW6CKjdB1TA6pGtigzT4rFG+qcY6NvYNBwSz1ij6fjChTrdSnVS0wAk+VvVyhIt2/0VZFqf7g6PL0HbifryjbE+un51iResws2vL6zVV2J3WGz9G0eSmqd2uUVrvoqv4opZ/C1m0KQrrw6DuKV8EThCIRCIK2XJy+jO+W5WtGlXkaMsFMeKuSAoowN/1dvxcqM/QEsR8e6w4ZhWR6+Ace2FvEa8cR6h7Z6cGo1hnVeYmHaXwf8aWkC9SZWEKb8gTYQlasr6dQcPiW3qUdsHXVxf+SpT3RBgfABSRE9xffBtqa2wlPbzyFnrNGdndsXGD6FsRVaVgdJ1PgOC2vnAkUeCTQRfwukuD0yOa8XLKanBaEjk5Aq7YtnGjEtCtRYTPaVJgOv2vGyK54PathOb6DkrpQ8rQmkqg9OTM9a/aLau7kle4CiSeD8/R7DNs1a8F6ldqvztGpdPawXFS8nVY1PWwVup8nRqFdUnsMAuTfgRjb7jGF+Xk6tjA/KMyVZeo7ta1ZHH1bIhblf6IFql7rxrLfhf9+Npv/t+qh8Fui5Shj77KniTnujXdYntoqly0/yL1kaky3upsbHHhTAwrMpNsiRJrIc25YgvIbnNv5GCdj6MjJlnI+BJu4YWRQxvyZZEUouQJxPNX7aRZ6hPR+NhTX27y9f2vHpCSKHIm4EpS0HD6AUa3855epeBLgAOQvzfXtAFTtRJyGsOe35JQha5rPQ9SIGk2ccPcu1udLs6fR1n7kBEtebcN3FGyMbzdYA+KWr+IefXPZvxko/AW+h7fymob0iSQLevuW1vf91MtD3OqCtnmfyMypRAZS6A+x+b7bJXQMgZ38pifBedrvZ8FJIDlE3BiXlbyfZ7aNDsgG7H+aa0q2EzQbXlxqK9qQrHK6COcLxvXAYTvPfQhBPLqt1VE4AfR/fnsM8Mvky
 FlkQ9zWK
 a4agNCy3me01uLfCGV4qhy1dyxxsrWB55pyCbkLguCPyFUwYw8psWAIpsAEEBqcg/tMP9G6DlrthUzSvfE7NVHUnlkgYs8MirnPQMD5pDDmPpILA/3gQU5m08ModQ4+WRWCfFzCISbtzBBMApAsNRMeYn+SUUbxSAAlqD/d0i215Gz5O/g90CW0zgUsvJMHzvSIeauU6QV2G16zuGINCgZNt3DYLWBjxArBHK7sSok4bgilSqYEur1VGDGmTpV2VaTboM0OF02KWoMDlNLd4P3vYr/W95da97JGSodYakA29b+bsNWU/igOlDQYGMbKBbf+okGjliRVPg95LolUo54AS8bDAsDjo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    dd9b004b7ff3 Merge tag 'trace-v6.19-rc1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10010d1a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a94030c847137a18
dashboard link: https://syzkaller.appspot.com/bug?extid=8785aaf121cfb2141e0d
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1519cd58580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1438f9b4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ea0a8b24838c/disk-dd9b004b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/67ac69e3e131/vmlinux-dd9b004b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/570521afa03d/bzImage-dd9b004b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6120/1:b..l
rcu: 	(detected by 0, t=10502 jiffies, g=13285, q=486 ncpus=2)
task:dhcpcd          state:R  running task     stack:25432 pid:6120  tgid:6120  ppid:5490   task_flags:0x400040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7190
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:lock_acquire+0x16c/0x340 kernel/locking/lockdep.c:5872
Code: 00 00 00 00 9c 8f 44 24 30 f7 44 24 30 00 02 00 00 0f 85 cd 00 00 00 f7 44 24 08 00 02 00 00 74 01 fb 65 48 8b 05 d4 38 e0 10 <48> 3b 44 24 58 0f 85 e5 00 00 00 48 83 c4 60 5b 41 5c 41 5d 41 5e
RSP: 0018:ffffc900031970d8 EFLAGS: 00000206
RAX: e8c1bbb3b5be3a00 RBX: 0000000000000000 RCX: e8c1bbb3b5be3a00
RDX: 000000005594689c RSI: ffffffff8d979233 RDI: ffffffff8bc08360
RBP: ffffffff81743f85 R08: ffffffff81743f85 R09: ffffffff8df41a20
R10: dffffc0000000000 R11: ffffffff81ada120 R12: 0000000000000002
R13: ffffffff8df41a20 R14: 0000000000000000 R15: 0000000000000246
 rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 rcu_read_lock include/linux/rcupdate.h:867 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1195 [inline]
 unwind_next_frame+0xc2/0x23d0 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 poison_kmalloc_redzone mm/kasan/common.c:397 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:414
 kasan_kmalloc include/linux/kasan.h:262 [inline]
 __kmalloc_cache_noprof+0x3e2/0x700 mm/slub.c:5776
 kmalloc_noprof include/linux/slab.h:957 [inline]
 slab_free_hook mm/slub.c:2492 [inline]
 slab_free mm/slub.c:6668 [inline]
 kmem_cache_free+0x16b/0x620 mm/slub.c:6779
 anon_vma_free mm/rmap.c:136 [inline]
 __put_anon_vma+0x12b/0x2d0 mm/rmap.c:2780
 put_anon_vma include/linux/rmap.h:117 [inline]
 unlink_anon_vmas+0x503/0x670 mm/rmap.c:443
 free_pgtables+0x735/0x9d0 mm/memory.c:414
 vms_clear_ptes+0x423/0x530 mm/vma.c:1236
 vms_complete_munmap_vmas+0x206/0x8a0 mm/vma.c:1280
 do_vmi_align_munmap+0x364/0x440 mm/vma.c:1539
 do_vmi_munmap+0x253/0x2e0 mm/vma.c:1587
 __vm_munmap+0x207/0x380 mm/vma.c:3203
 __do_sys_munmap mm/mmap.c:1077 [inline]
 __se_sys_munmap mm/mmap.c:1074 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1074
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd7d0dad2e7
RSP: 002b:00007ffd60bdc648 EFLAGS: 00000206 ORIG_RAX: 000000000000000b
RAX: ffffffffffffffda RBX: 000055f3a7cc03f0 RCX: 00007fd7d0dad2e7
RDX: 0000000000000002 RSI: 0000000000061018 RDI: 00007fd7d0add000
RBP: 00007ffd60bdc750 R08: 0000000000000030 R09: 000055f3a7cc0fa0
R10: 00007ffd60bdc580 R11: 0000000000000206 R12: 00007ffd60bdc698
R13: 00007fd7d0dc0000 R14: 000055f3a7cc03f0 R15: 0000000000000000
 </TASK>
rcu: rcu_preempt kthread starved for 10455 jiffies! g13285 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27736 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6960
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6122 Comm: vhost-6117 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:do_user_addr_fault+0x1cd/0x1380 arch/x86/mm/fault.c:1293
Code: e8 b8 39 54 00 fb 4c 89 7c 24 38 0f 1f 44 00 00 e8 a8 62 4c 00 44 89 f6 83 e6 40 31 ff 48 89 74 24 30 e8 76 67 4c 00 44 89 f6 <83> e6 02 31 ff 48 89 74 24 40 e8 64 67 4c 00 45 31 ff 4c 89 f6 48
RSP: 0018:ffffc900031b7878 EFLAGS: 00000293
RAX: ffffffff81754fba RBX: 0000000000000200 RCX: ffff88802c92db80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff8f822077 R09: 1ffffffff1f0440e
R10: dffffc0000000000 R11: fffffbfff1f0440f R12: ffffc900031b7968
R13: 0000000000000002 R14: 0000000000000000 R15: ffff88802c92db80
FS:  000055555ad2e500(0000) GS:ffff888125f35000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000002 CR3: 00000000322fa000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0010:__get_user_nocheck_2+0x6/0x20 arch/x86/lib/getuser.S:130
Code: 01 ca e9 c8 d6 b5 f5 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 01 cb 0f ae e8 <0f> b7 10 31 c0 0f 01 ca e9 98 d6 b5 f5 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc900031b7a10 EFLAGS: 00050202
RAX: 0000000000000002 RBX: ffff8880244f01e0 RCX: ffff88802c92db80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880244f01e0
RBP: 0000000000000000 R08: ffffffff8f822077 R09: 1ffffffff1f0440e
R10: dffffc0000000000 R11: fffffbfff1f0440f R12: dffffc0000000000
R13: dffffc0000000000 R14: ffff8880244f0290 R15: ffffc900031b7a18
 vhost_get_avail_idx+0xc4/0x450 drivers/vhost/vhost.c:1531
 vhost_enable_notify+0x303/0x650 drivers/vhost/vhost.c:3245
 vhost_transport_do_send_pkt+0xf55/0x1330 drivers/vhost/vsock.c:125
 vhost_run_work_list+0x14e/0x1e0 drivers/vhost/vhost.c:454
 vhost_task_fn+0x27c/0x430 kernel/vhost_task.c:49
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

