Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 538E2E7C711
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 05:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550096B0005; Sun,  1 Feb 2026 00:31:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531DB6B0089; Sun,  1 Feb 2026 00:31:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430936B008A; Sun,  1 Feb 2026 00:31:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30A6D6B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 00:31:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B94C713A80A
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 05:31:31 +0000 (UTC)
X-FDA: 84394765182.16.7DC13E1
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf20.hostedemail.com (Postfix) with ESMTP id 125BF1C0003
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 05:31:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3MeV-aQkbAEo4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3MeV-aQkbAEo4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769923890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=ZW4f0rXeJpGepXMy39mLGrGmbt04aLNLgRNvAwsNfo4=;
	b=3Zu9neCrOECxYg7fEm3dlhSYCBnRHOM+El8rz2D7vkZ1Jl++NghaaX4Zs/LNYN9R7MxwC1
	D/PteUpxaI1ZANsFgK6v+9yXgj1PnGcE0vGVh8EjPyBcjobCZj5kO9NsOH7I1kVGoSbk85
	8mIsIj9/16Xy8HNtTv4LPkZYPEKv0Po=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3MeV-aQkbAEo4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3MeV-aQkbAEo4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769923890; a=rsa-sha256;
	cv=none;
	b=dGJYJ4af+cVEmT3oijUyJUI5M9VTja6Ahe5gNjuRGtlMTnMg303xfwh4w6jN/LztVkqnou
	M4TVZwaDmmpmgUiCzgu1mzkA5VvhistvWvPtzjfjfG/FMkjLlheMWUaskwuD3fdp4YQae4
	uT058L0SprzIQsbn57+5jyVfgi4ajNw=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-66485ced4cdso5120572eaf.1
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 21:31:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769923889; x=1770528689;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZW4f0rXeJpGepXMy39mLGrGmbt04aLNLgRNvAwsNfo4=;
        b=R4E3gu8V+WSiBiL5aASd8SlEFw8Bw7tsZwspl/V4GVWDJg6DozzosRhrOdeSh7nh2A
         sXyys8Sqx1iNkiebXs3ddxQ/HD5kUjl1RJQExa7DWlhh8hWDYcZJwbykN3UiC2HQqmbE
         7lthNRS9iOsQb6oFUiEkqncDJQT3eL2ppOFfwmj+LbquXtYsEb0/Yyoer7zrNaPKFRnw
         6mcPCyR4MDUe3AgZKtLYdDj7loEJFffa3Z6qqh8x27aPy4KkK3wMwf/GdJy2VNSjw5lI
         bOcbH5vw5ZCkyy5F6h26T6Sn3PXE3gzTc14HcdpxhVW/93Qulj895Pww/MGcTJaJK/Cp
         Qgjw==
X-Forwarded-Encrypted: i=1; AJvYcCVONkhOVuOKgSB/dUzfNfMDmab7hmnML0/gYW+R72BGLFVsuOGenCqXoXukHx3VJy0Zh//J72CfNw==@kvack.org
X-Gm-Message-State: AOJu0Yz+vQ+yQCjJ7vk/nNn/xR7lqbeOtwli3PpvH+EepqQk4BHCG34B
	O/l/0NOrLG+2hHaO+eYJEW3O13KUg3ILlZE7QkGMs6qRkztl2RiCFkZYSkAUZDxYqAgSC7QScDW
	Zb8w3gJG6HoJ2VnjAf/m8zdBZffmS9+ZHXCRdhd9bY+z8ZVEcyiTrv7pX/j0=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:814:b0:663:b86:493 with SMTP id
 006d021491bc7-6630f03726cmr3488940eaf.33.1769923889108; Sat, 31 Jan 2026
 21:31:29 -0800 (PST)
Date: Sat, 31 Jan 2026 21:31:29 -0800
In-Reply-To: <68f848cf.a70a0220.3bf6c6.000e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697ee531.050a0220.16b13.0098.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in shmem_file_write_iter (3)
From: syzbot <syzbot+f172d48953db0cf91855@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 125BF1C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: ah8esqs1tico371afceh5fafb4msfqk9
X-HE-Tag: 1769923889-196317
X-HE-Meta: U2FsdGVkX1/DhPYYdisCqQGSIdkkq6mG50XFpOn78qpEPBDfRGcYH6+DE/bQlDPLMspjS5JZiuv8Uvm4GEZlAMySmM/xd+AC6D9t6at0a/4iHHa+WSJhCBZ1Ty33sIJxCh3W4nAEp4EL99G3iUciL9Cf3rUnJ4omAS/+ueyLiTplMNY5EOJne48wtKkaB6CYKfHIX+NAwRKmX1Uv1NRgZQ9FpVFgjoWKlj0oC0poKDmb02yrng9fpOW7TIyKWH82r7t+UpUjVWSx854cR029e0Ya4zg3vf61xT/UYRFPAG28wYa7w+NsOBmaa0Tmlxo6JMnjphj7OIci0uyAK3wvoiodl4bvqtjeCiXFhxAvffBBitPDS+HDrDp3CUzlUfObKKqFhL/fGxMPCjxT1XhFNkfCcRUgTia6gULCtMje+Q3jk1rG51dDuCQJ2CU6KnNxzlQDTSRiYTEBofFk68DCHtxl7tRPfvUMzQfQyHKHKo/ujbhlHz4QGJiRZo0wPpj5Yk4FOSgEeVT+UItEwDcnvJrmbo5mp7YA4C4wuVH1Khvqs4w5BCzCcA5y+w5gbXhwANKlzqAeEOLAELgyH4Jv7U87yxnuyfXIsAmofVyw7xl+05VcVn7E1h7gMvqnj9YVQ+IuJ8vjfXR9ZlzNCvfhj1kViEZtmSvsPOKXKH2nh1WMztaWOu2QsfHpOPlbZmyvQT9Ae1RIaplpmR5ZGQQLxPgy5y5YuB+JD6RiUAcgPba30Uh/yYdMz+OzkDrsYoe68+IHB2yLFGbngJyjrH+u2+K0Elwm06gVzrqwFA4XBcA4FOANZWyYha/Svd18K+5xCKhzHgKi9aCPY+bwmat2WP/IMqfTPpO43JVm1I/qWdZj+EnNjYtkb9PnF0NSFRJPQa5FhBdvkug8zOjBFdyAS5ilFw2TOOlx5SbwLzBEBS9PGz88hvdOg59Wt5qeDJzTZd3MBk0bVgvQ3Z8I5jC
 laqHFrNp
 x2T/aYDWf26g0KCXOzbgPR9NXdNdt3paQvEvKzwdnaztd8Pm2cwwKzfmP8xNw+5sMvo6nOWXm2mWgmTRGS6XBePP8tdUE5Ktg5NCgNB5n6Iz9e8jbCG7mKJymY6lL+tb6wwY0c9vUMJHtFu5ImhxuCdCrxo1v1OgF3+tBoftn9zUR4EpptPGkey1rJ8yhcfZFlAboNTA3UMEoV1WuRTZ5Zuh6rs6h4JQqyJV7Of3CrpgbzbycnjlGZT/3/LdmaKXGR2oEGpizBJwy4hL+L1u9MyUGceQAf/w+Mn4q1vKV01jhBlXmU3Dtr9Z9wS0fmHbkppT8xV+FiWQ1RDN+GPenn8ev/2AtgMDZQvmggpIC577tAsiRK02HEg6S1AN04O1nUCfs3F9nw2hrklpmvfa7JsKrh31QPNWSE9o+mPd4WbksE749MsqFfaWId3fnS5e9qZgGWiWiJYJ4mYOKrKmhaaI1TA6h703J/SIfP27FVCaHLPrfplpRmEzryhNT4gpG0Mxb1BTs/IjsWT4VCXsN1Ae2rkwk0vcEctleo0EVKnE0j+4RizkJN7q/NzS9W0cz7xsoUYmsBYZcOoL6D+4Nt9ohADBfbDhb+c+I20+Lnx6gVc1mlxEpfQDQgWH9fqWETJGJ3EzjlbkLTD82EmWp0BklMVYif9eKOAent1QHZzOwhc6cXM/EcVVpdBY+byp+2BObsplTjkBXHrdsEDX5fjJZD+CUe+OzkIvAqON8k90V1pF/1ee1GghYvRUhGBlbPWww12e5FK0jn7qEUqGDbWxj1hQTjlcdClA4MH8CvWpXjEfmabL0VW44ngMvLGAsT/yLINIjk0peYWLoonhSjtMq2yeukDETR0C2UlsHB08bhG39rnplvLysu980QF46/kCLQldT4UPJKEiG9sUmSrJfZDsvk6Cs/EzGCAbrVG97oF+0m/ahV6tpNrx2oQ4SijkLWWRmN4ZOVfytPxcg6qfDnCZQ
 wxlCWgMo
 1eEnXcHjk6Sytyge9F0n/6oHZVj6aEdCVxCmml/SA6QTHLHoqDbNKymYNuzg7NZPAQFh7jjGM3Bcd++gTkmvm+ClB45UyLSwLAiRz+/1E2n/FF9CVkXNDI3UnsczAA0ymRwjag+oHQhtnXoAeLa7mFR58oC6qFhEzCGT+j3lF2fcUMg85uB0KYUApD4M+VePmkh37J4AyfX3nnk198oRhyxC5JwTC2R7AxLipGg5ccdBCxgUYJoWG20t8LqBNWdfFwAJqTofEv/gU5PdK2OUIQJ8t8i2WUYrZ8KN0JgVf91KC4Mel4sFcVHduwUSohn/SzklA052w9cb8APnstiBc4i+tJ6Kmaaw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    162b42445b58 Merge tag 'iommu-fixes-v6.19-rc7' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=175f845a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4aae00ac5a9d2645
dashboard link: https://syzkaller.appspot.com/bug?extid=f172d48953db0cf91855
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1458d322580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12dabbfa580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-162b4244.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d7fb932fd633/vmlinux-162b4244.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0008cacaef76/bzImage-162b4244.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e800ad00fb07/mount_2.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=14699c52580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f172d48953db0cf91855@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-0): P5973/1:b..l
rcu: 	(detected by 0, t=10502 jiffies, g=33977, q=94 ncpus=1)
task:syz.5.221       state:R  running task     stack:25112 pid:5973  tgid:5973  ppid:5485   task_flags:0x400040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5260 [inline]
 __schedule+0x14ea/0x5050 kernel/sched/core.c:6867
 preempt_schedule_irq+0x4d/0xa0 kernel/sched/core.c:7194
 irqentry_exit+0x597/0x620 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:__rcu_read_lock+0x31/0x60 kernel/rcu/tree_plugin.h:416
Code: 8b 1d bb 01 49 11 48 81 c3 84 04 00 00 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 0f b6 04 08 84 c0 75 18 ff 03 8b 03 <3d> 00 00 00 40 7d 07 5b c3 cc cc cc cc cc 90 0f 0b 90 eb f3 89 d9
RSP: 0018:ffffc90003b170c8 EFLAGS: 00000202
RAX: 0000000000000001 RBX: ffff8880526f8484 RCX: dffffc0000000000
RDX: dffffc0000000000 RSI: ffffffff8200ea42 RDI: ffffc90003b171a8
RBP: dffffc0000000000 R08: ffffc90003b17270 R09: 0000000000000008
R10: ffffc90003b171f8 R11: ffffffff81afb170 R12: 1ffff92000762e35
R13: ffffc90003b171e0 R14: ffffc90003b171a8 R15: ffffc90003b17b20
 rcu_read_lock include/linux/rcupdate.h:865 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1195 [inline]
 unwind_next_frame+0x9e/0x23c0 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 save_stack+0x122/0x230 mm/page_owner.c:165
 __set_page_owner+0x8d/0x4c0 mm/page_owner.c:341
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
 prep_new_page mm/page_alloc.c:1892 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3945
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 folio_alloc_mpol_noprof+0x39/0x70 mm/mempolicy.c:2505
 shmem_alloc_folio mm/shmem.c:1913 [inline]
 shmem_alloc_and_add_folio+0x445/0xf80 mm/shmem.c:1955
 shmem_get_folio_gfp+0x5a9/0x1670 mm/shmem.c:2579
 shmem_get_folio mm/shmem.c:2685 [inline]
 shmem_write_begin+0x16c/0x330 mm/shmem.c:3338
 generic_perform_write+0x2e2/0x8f0 mm/filemap.c:4314
 shmem_file_write_iter+0xf8/0x120 mm/shmem.c:3513
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:686
 ksys_write+0x150/0x270 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1ef735b78e
RSP: 002b:00007ffc44ca3b98 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000055558e4b7500 RCX: 00007f1ef735b78e
RDX: 0000000001000000 RSI: 00007f1eee400000 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 00007ffc44ca3cd0 R14: 00007ffc44ca3c90 R15: 00007f1eee400000
 </TASK>
rcu: rcu_preempt kthread timer wakeup didn't happen for 10497 jiffies! g33977 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
rcu: 	Possible timer handling issue on cpu=0 timer-softirq=24428
rcu: rcu_preempt kthread starved for 10498 jiffies! g33977 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:28784 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5260 [inline]
 __schedule+0x14ea/0x5050 kernel/sched/core.c:6867
 __schedule_loop kernel/sched/core.c:6949 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:6964
 schedule_timeout+0x158/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x312/0x1560 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x9d/0x3b0 kernel/rcu/tree.c:2285
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 1314 Comm: aoe_tx0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x47/0x80 kernel/locking/spinlock.c:194
Code: f7 e8 dd 47 05 f6 f7 c3 00 02 00 00 74 05 e8 80 b5 30 f6 9c 58 a9 00 02 00 00 75 27 f7 c3 00 02 00 00 74 01 fb bf 01 00 00 00 <e8> 64 13 f7 f5 65 8b 05 cd b5 57 07 85 c0 74 18 5b 41 5e c3 cc cc
RSP: 0018:ffffc9000858f788 EFLAGS: 00000206
RAX: 0000000000000006 RBX: 0000000000000286 RCX: 0000000000000202
RDX: 0000000000000002 RSI: ffffffff8dccfc9a RDI: 0000000000000001
RBP: dffffc0000000000 R08: ffffffff8fef3f77 R09: 1ffffffff1fde7ee
R10: dffffc0000000000 R11: fffffbfff1fde7ef R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff9a3421a0 R15: ffffffff8edf0cc0
FS:  0000000000000000(0000) GS:ffff88808ccea000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6c1dbf8000 CR3: 000000005495c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 spin_unlock_irqrestore include/linux/spinlock.h:406 [inline]
 uart_port_unlock_irqrestore include/linux/serial_core.h:788 [inline]
 uart_port_unlock_deref drivers/tty/serial/serial_core.c:91 [inline]
 uart_write_room+0x3b0/0x840 drivers/tty/serial/serial_core.c:647
 handle_tx+0x163/0x610 drivers/net/caif/caif_serial.c:212
 __netdev_start_xmit include/linux/netdevice.h:5273 [inline]
 netdev_start_xmit include/linux/netdevice.h:5282 [inline]
 xmit_one net/core/dev.c:3866 [inline]
 dev_hard_start_xmit+0x2cd/0x7f0 net/core/dev.c:3882
 __dev_queue_xmit+0x168f/0x3850 net/core/dev.c:4832
 dev_queue_xmit include/linux/netdevice.h:3381 [inline]
 tx+0x6b/0x190 drivers/block/aoe/aoenet.c:62
 kthread+0x1e0/0x3f0 drivers/block/aoe/aoecmd.c:1241
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

