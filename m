Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D569AD65C6C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 15:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21AF46B0005; Wed, 17 Dec 2025 10:37:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CE6D6B0089; Wed, 17 Dec 2025 10:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C73C6B008A; Wed, 17 Dec 2025 10:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBCE96B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:37:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EA5CBCBFE
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:37:28 +0000 (UTC)
X-FDA: 84229367376.06.9894C0C
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf26.hostedemail.com (Postfix) with ESMTP id C7BC914001A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:37:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of 3Nc5CaQkbAC4cijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3Nc5CaQkbAC4cijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765985846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=QHBBZDS3uErD1WD2BXCa3sIMfoS47xwCNCL3pxegcfQ=;
	b=8VUYmS9kOLeAJbuScJO+sFgh4xMdMfFd5UFeKX2DQ3FktFri33XAhxKZkcBIjRPCmPwmMi
	ivJZGCdJe/1Z9Z6u8z6RCmW0P02fKmi8N1iHQBBy98s3JfdxT/mBZcC/RzkkiU2iBeFc20
	I6wEIsA2Pj3KslT+GPsOU3X0uNFSzDs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of 3Nc5CaQkbAC4cijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3Nc5CaQkbAC4cijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765985846; a=rsa-sha256;
	cv=none;
	b=EsqBIC124mjx9FrH90Ky9Pf9l2oXDx5Dg0V1Auoqs/V/RGphVoc8l8pG0mFpDtEYxQ3nf9
	t6Rd1lJA2EpuamkQxCt3KuzSycbU6mfkp+mmms7Oykk4eWChctAcgZXb/HTAhdxSYsqwBp
	aObT00x3FypPquV14X4wYgpby9ei4Uk=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65b2d43a899so9082725eaf.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:37:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765985846; x=1766590646;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QHBBZDS3uErD1WD2BXCa3sIMfoS47xwCNCL3pxegcfQ=;
        b=EaLF6r9htkIJ1JpohOU66RZO2BjV8qn3vP1SdDi9p5XhJ4qQMWshGgS0cV/aUKYUSS
         fqDhzNs7C5K9rrAKh7lOicQAkg0I3RRawa3PHAcEKwVJkbibATon1lPLKONI2V7hLz/T
         GwSwtZcTIOeuI558AU8zea8AVhGsxGf+m+CUghq3f01/UD+3Nsa2a++mNsZ0JZ27pQ0L
         4XUKf/QHKtR7MkEmJyJ3ZJWRPZAjBV2lv/BJd0Jr94bIFs8FIdeuriUTaYIX6npk6yyC
         fCxuHX59rGCDh3G0tV2j1/hcD3FpvP1T9J64E054sQegRkkY/xIZiaN1JJmI2ed9hET9
         LhUw==
X-Forwarded-Encrypted: i=1; AJvYcCU2K5fEA0+8lDLmbnYaTRzKKJX9RBQaaAo9sOrkwJG8Ygrlm295KXVZYdHVGyzaX2BOJ8Fom722vA==@kvack.org
X-Gm-Message-State: AOJu0YyqwO9oFYlo/7/Phtsdq0L3XaOHVLbx5U/cLOdjAh9pp/AOGsBa
	qxHO+b43B/QvLxppvuuRiA+2lfJ9xlUtBuNUoeM2pvUIfyZHdEE+XvcHgA+AZhyt7JoRKCyUzQH
	vi6RXINQPXCtIGt9qSaTVQzjXgAr0FI5A9g55PDJL3dDVC83zg2V0uq1ara4=
X-Google-Smtp-Source: AGHT+IFZP0qpyXlqzklfHcoOPG7u9lmcK6SkDw7cma3REMbPywpjFcCQZq8MnjXXF5NJMOZxqq/v+kKjJbuuCQLuaTifZacJHxSI
MIME-Version: 1.0
X-Received: by 2002:a05:6820:198f:b0:659:9a49:9044 with SMTP id
 006d021491bc7-65b45165e85mr7444714eaf.15.1765985845818; Wed, 17 Dec 2025
 07:37:25 -0800 (PST)
Date: Wed, 17 Dec 2025 07:37:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6942ce35.a70a0220.207337.006b.GAE@google.com>
Subject: [syzbot] [cgroups?] [mm?] INFO: rcu detected stall in sys_signalfd4 (2)
From: syzbot <syzbot+d27ce4d3ef3a5d501b54@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1wnk7j4shhuwb8kqj5cstdru6pqrzwp9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C7BC914001A
X-HE-Tag: 1765985846-69445
X-HE-Meta: U2FsdGVkX1+HChPtpgolIehV9+f9+yH49Uqjq4r3cEiicslsmze2HBD0dpLRkwJvBCjPx/w+LYe/kcq5m3Ss1VMkQjFDprloCb305QdUwxzeIrrCYWfzWS1uQv8cHhWiO5DL7412m8wZL26R1JegAslcKS3FD0XwgGrN3+M6Pqc0SwnZTFLQ1StoZFffUIHXCs+qAG2SKMYOAee00d+k9G9A8wcUeO0YKFO2W3Eu2gkwCQHHxOyUHdAkQ8gScS6RtS0L3nJy/rSH/k7BzZnJAXQiT57g+sajIg2+DvO0Z86yyp1Smam5J1pXuy/l96AedVSDsMQw2ykS99h/RL6ftsBt2eXQFB2UluuB8f9bdtFEQSK8M006LTl5IHmrArfrGhzhrxuo29DRz8MWuzeU0mPLFtmBfAwxAAIwnCeGJsO3NJoHEdMkiEVzZbRgJV8vkJgBQ1lBcdBqhW/LdXj1+rpkaCCNcTyevqUme1wTnn12QP7a8LrfmudyY60BPcCVDIg4vufbwyD7hUdJfXnVHLb99SpJEfhUV6lp8E/jzrFpjQa05HKT0CIsLF06NDDi9mr9bPcKgJsaPqerp+sX7u9hIYt5656pXT4pFEFi81XNdFLchdNmSEvowMljjdQuzNDS6IFYHQCXbvhLzpQnbtBRZ2wa2dnAJfLRELhCfl3JG5eukUhRV9D8L9TKBDq6ZAPtnBYLYCq9iHzm7kHKfMxlDyvyviHk4qY6n/w5mFV3Iws7qiBGrtjEkK05KgHVNpq2s83hUnIfE0uoq86zB7idcBa2aissk1yamlX9eLtDnY7fa7ooDJ69s4NOW6aMpGw7nFAJqVNSNVrHxFHUIexjTM9bjQ1YWEZSelLo9ZwCnVZu+5FxMyumIdxGvdrCS7lrM+sXwQOj14X2DO/+KMd7GN5KJL+fnGL596jKAhsZcbUt/decX7QouLld7keNZWZC1t0rVWkWuvaU8dq
 Nnk4kXo/
 M3YH76P9bKYSSwx28p7YyANbw3jXIyhNZ5ihF6CJvwPCxzaLzR55SGS5jTw+Oxtmu7wQ4GMLbrAiaFJd0Zk8QRDsefZREG+o1Rj0OM+PqGpjWrlTg5zLcsZprT/yBjEVV/6eNMSsLkDPcvZ1huZf7mzBp2NrS6HWCki3uDdHskzKXhwc9GiRvjT52EPkRq+TdUFVLxplOA26n14cb/IUaoy6p7MDewl5cDJG4ID2ikw+hN1BwF7LrWmp869aDkWlD3asp/TVWXySW34l7tJ5B0oDGW6bH9wLqjcXCNeWUYtaipKZTPbJP5nMhtomLiTp6RyDSQTZ8DMSRXUL5/bO6sfHTGVBgvaFafU2b6s/5aTlPmelgxC9/M84ZMDIIAQz+3lGcNeAeUS+AmU014VhkHhUuKQcIht7YTCElVsHGzmFFK0ZrKcHoW77GBxFX7KXMzNl42f5eAtQsFshXbXL6Hh1u1Lf1ktGR508w3s7o937XZGVgckgs1GtAr2lPGtM49+17RHnMgwcnwuI9bo5RDOgi1SzeVVAq29465oSMJ6qTKKHdjP9xRh3GyYTAqhlx2cDdq6INVHCzhiM7BDkm1giUISo+1ep0tn2dwTyD2R2Q4/gJa2uaBrMdLP8lXvZlma6WZ7a08Moah3brpBJQIOeDztSc70I/U+8f2YeaBHsATN7KbWcEFYHoNicvFm9qrSgMi8s+iEdl+api6rcKwayl0cwwo2EZxAPmlXl97E4KYxdKa7Fg0oro+ZdnzY24fV7+UVvaUXqNNIuLKuyYbQG4bYXbYEO52mse0qdQYmyvS/Xik/CwdwHXW5Z+n+hV3KEmHGFQbNAmoXsgdUnf76PcR7UHijxdk9HsVsDIaK8t69WuMhp9FjA2y3myrOljNy8l+Hf61kvjywrgt0VQm+NX28rPC/hEbtKK8Je1GSDvJ0cXbM1FtKcKEY8RD0jtToEE2hct0RfB/KhVJtLV1ok1zWQe
 7JhalZdK
 4EK16QAUPwAC5SdQtYs3YtN2n9nN04zlbLPqOQXOlFx4m0Pl9iPQUm1nHkmZXP4zAT4gfx6XxMjqu99BMUwwSyCZmdnQH/S5wSwEyGqlsNHDgs+Ex+QnhBvgNRMYYp3GHfjn43PkDwj45Lus3PfKb4u+4mlsB0+t1TVmd91L4d0YUd3V4fqWcOH23ulITK1A3KI0tDzxjPXKPg1y3iuT1Ga7PQ8t5z+hhhLZE3+x51cWqtEL4Van08xX3jLDeeBH8NRXRZxDU3/S9+KCh3+k3zO5YPoKwt+z9cC9prKmGwn5t/jNN3fCEAYzsJpJmTDtQ6NGUxF9p2aBnx1KhyXLyLSIuP6+ODSogC2dkTKMtG9Pg5LCoP7+AOhPcNsJKLRD1ZFNkhu8HR0Rpv0TSkoY42vEJNFhzKtodZlcsZb16sk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    4a5663c04bb6 Add linux-next specific files for 20251215
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13b5ed92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b9f785244b836412
dashboard link: https://syzkaller.appspot.com/bug?extid=d27ce4d3ef3a5d501b54
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10568392580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fea1fcf777e7/disk-4a5663c0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/23d586650b2f/vmlinux-4a5663c0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2a3fea0a5cdf/bzImage-4a5663c0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d27ce4d3ef3a5d501b54@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P5805/1:b..l P6096/1:b..l
rcu: 	(detected by 0, t=10502 jiffies, g=13969, q=225 ncpus=2)
task:udevd           state:R  running task     stack:28344 pid:6096  tgid:6096  ppid:5197   task_flags:0x400040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7193
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:debug_lockdep_rcu_enabled+0x2d/0x40 kernel/rcu/update.c:320
Code: fa 31 c0 83 3d 17 57 5e 04 00 74 1e 83 3d 2a 86 5e 04 00 74 15 65 48 8b 0c 25 08 a0 c3 92 31 c0 83 b9 2c 0b 00 00 00 0f 94 c0 <e9> 8e e3 02 00 cc cc cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90
RSP: 0018:ffffc900031a7938 EFLAGS: 00000246
RAX: 0000000000000001 RBX: ffffffff8e37db60 RCX: ffff88807e5a3d00
RDX: 000000005a44979c RSI: ffffffff8be252c0 RDI: ffff88807e5a3d00
RBP: ffffc900031a79d0 R08: ffffffff8230bf9a R09: ffffffff8e341b20
R10: dffffc0000000000 R11: ffffed100fcb4a72 R12: ffffffff8230bf9a
R13: ffff88807e5a3d2c R14: 1ffff92000634f28 R15: dffffc0000000000
 rcu_read_lock_held_common kernel/rcu/update.c:105 [inline]
 rcu_read_lock_sched_held+0x60/0x100 kernel/rcu/update.c:124
 task_css include/linux/cgroup.h:460 [inline]
 mem_cgroup_from_task+0x4d/0x120 mm/memcontrol.c:885
 current_objcg_update+0x1a8/0x2c0 mm/memcontrol.c:2685
 current_obj_cgroup mm/memcontrol.c:2714 [inline]
 __memcg_slab_post_alloc_hook+0x67e/0x730 mm/memcontrol.c:3166
 memcg_slab_post_alloc_hook mm/slub.c:2338 [inline]
 slab_post_alloc_hook mm/slub.c:4964 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_lru_noprof+0x41f/0x6e0 mm/slub.c:5282
 __d_alloc+0x37/0x6f0 fs/dcache.c:1730
 d_alloc_pseudo+0x21/0xc0 fs/dcache.c:1861
 alloc_path_pseudo fs/file_table.c:363 [inline]
 alloc_file_pseudo+0xcc/0x210 fs/file_table.c:379
 __anon_inode_getfile fs/anon_inodes.c:166 [inline]
 anon_inode_getfile_fmode+0xb0/0x1c0 fs/anon_inodes.c:232
 do_signalfd4+0x1a5/0x3f0 fs/signalfd.c:273
 __do_sys_signalfd4 fs/signalfd.c:308 [inline]
 __se_sys_signalfd4 fs/signalfd.c:299 [inline]
 __x64_sys_signalfd4+0x154/0x190 fs/signalfd.c:299
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fac0bf214ff
RSP: 002b:00007ffe3f3752e8 EFLAGS: 00000286 ORIG_RAX: 0000000000000121
RAX: ffffffffffffffda RBX: 000056168c657840 RCX: 00007fac0bf214ff
RDX: 0000000000000008 RSI: 00007ffe3f375360 RDI: 00000000ffffffff
RBP: 000056168c64d910 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000080800 R11: 0000000000000286 R12: 000056168c66aca0
R13: 00007ffe3f375360 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
task:kworker/1:3     state:R  running task     stack:24000 pid:5805  tgid:5805  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: events_power_efficient gc_worker
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7193
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:seqcount_lockdep_reader_access+0x17e/0x1c0 include/linux/seqlock.h:75
Code: f8 4d 85 e4 75 16 e8 71 39 34 f8 eb 15 e8 6a 39 34 f8 e8 15 ba d7 01 4d 85 e4 74 ea e8 5b 39 34 f8 fb 48 c7 04 24 0e 36 e0 45 <4b> c7 04 3e 00 00 00 00 66 43 c7 44 3e 09 00 00 43 c6 44 3e 0b 00
RSP: 0018:ffffc9000401f860 EFLAGS: 00000293
RAX: ffffffff898db805 RBX: 0000000000000000 RCX: ffff8880336c1e80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000401f910 R08: ffffffff8fc3ce77 R09: 1ffffffff1f879ce
R10: dffffc0000000000 R11: fffffbfff1f879cf R12: 0000000000000200
R13: 1ffff110066d8460 R14: 1ffff92000803f0c R15: dffffc0000000000
 nf_conntrack_get_ht include/net/netfilter/nf_conntrack.h:342 [inline]
 gc_worker+0x308/0x1380 net/netfilter/nf_conntrack_core.c:1548
 process_one_work+0x93a/0x15a0 kernel/workqueue.c:3279
 process_scheduled_works kernel/workqueue.c:3362 [inline]
 worker_thread+0x9b0/0xee0 kernel/workqueue.c:3443
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: rcu_preempt kthread starved for 10562 jiffies! g13969 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
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
CPU: 0 UID: 0 PID: 6097 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x29/0x50 kernel/locking/spinlock.c:202
Code: 90 f3 0f 1e fa 53 48 89 fb 48 83 c7 18 48 8b 74 24 08 e8 ea d9 36 f6 48 89 df e8 22 51 37 f6 e8 5d b8 61 f6 fb bf 01 00 00 00 <e8> a2 45 29 f6 65 8b 05 db 8f 5b 07 85 c0 74 07 5b e9 c1 4b 00 00
RSP: 0018:ffffc900031e7c60 EFLAGS: 00000286
RAX: 0b0f3b2f78972000 RBX: ffff88802ef040c0 RCX: 0b0f3b2f78972000
RDX: 0000000000000000 RSI: ffffffff8daa56ad RDI: 0000000000000001
RBP: 0000000000000011 R08: ffffffff8fc3ce77 R09: 1ffffffff1f879ce
R10: dffffc0000000000 R11: fffffbfff1f879cf R12: 1ffff11005de086b
R13: 0000000000000000 R14: 0000000004000000 R15: ffff88802ef04358
FS:  000055558e963500(0000) GS:ffff8881259e6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31463fff CR3: 00000000730da000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 spin_unlock_irq include/linux/spinlock.h:401 [inline]
 get_signal+0x11a7/0x1340 kernel/signal.c:3037
 arch_do_signal_or_restart+0x9a/0x7a0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x87/0x4f0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2d0/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f92b238f751
Code: 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 48 3d 01 f0 ff ff 73 01 <c3> 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f
RSP: 002b:00007ffc8149b8b8 EFLAGS: 00000217
RAX: 0000000000000000 RBX: 00007f92b25e5fa0 RCX: 00007f92b238f749
RDX: 0000200000000300 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007f92b2413f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f92b25e5fa0 R14: 00007f92b25e5fa0 R15: 0000000000000004
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

