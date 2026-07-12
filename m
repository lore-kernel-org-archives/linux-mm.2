Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C37C44501
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 18:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF136B0005; Sun, 12 Jul 2026 14:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFD46B0088; Sun, 12 Jul 2026 14:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E566B008A; Sun, 12 Jul 2026 14:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 529496B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 14:24:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8E0692D97
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 18:24:33 +0000 (UTC)
X-FDA: 84980950026.11.FC1A1EA
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf18.hostedemail.com (Postfix) with ESMTP id 167591C000D
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 18:24:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 339tTagkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=339tTagkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783880672;
	b=UHoJg9zzH/Q91G/r6VGSV3RxtnRlnElo9WyTm6B9GlW1W1rKJpX/btKd1OdsdYvFBcxaQv
	KUss31TOveXEJXmXZS7TFMiSBTtTJZTF/t7ePZBHoqS+DFo+p9fkOLt2XVlvdA7nrX7lUK
	tRo+6stb3utLzYnBIGKTyCgYIYC5SDQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 339tTagkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=339tTagkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783880672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Bm3GLgw5QRz0pWFmcJD3kxPC574v3ZdKQ/1jUqQQkPU=;
	b=LnaCRrYjQnl+JZm0jpyaY1K/zntBPfnxzSEVJVbAnmPpaN/P8VIJtNJmWIvd5t/YeuYrDW
	xq6AWFk35m/SS/vzFTNPup1ZJ9TPmFoVjek3DkMnC145QWlkgdKGFIrP7CB7JEC3jUWNRs
	6eBiBCNJI4EgzI5GagSKi7w2+aTvZmY=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-48f680bda84so2970207b6e.1
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:24:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783880671; x=1784485471;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Bm3GLgw5QRz0pWFmcJD3kxPC574v3ZdKQ/1jUqQQkPU=;
        b=cpKhkZlAmWsieJOS8z3ojzY5RhiZIHz//yctH9M5ttuUoRrZcXtai2ou6IVO6N/67D
         cPZOXNZiX2dnbRax7qtPqYbCwdxxswoUGUGUUr7u3JL7nlBzg5W8E+sw1i3DEjR/F0oj
         s0ETf6d8ZJj+BLtD66614jDDYgZG9SvE1n2jveExiVtKruMj3eSdLZvC1Bq7lC2gHzIt
         FxVIW82/PoLRN0gYO1mEiss7VESe1hbcwtcJMhfrk/Cy13mm0bVyHmEMjKqPrI8b6KwH
         rh6Hxk6BF7lRsnr9BVdrLTrGlFO+iBmX9kaHWzQAP5zn9uhacGgZDbyjLkOhd4UlOY0H
         wq1Q==
X-Forwarded-Encrypted: i=1; AFNElJ+2popMb/JF0D22QyUFUVlsTGd6eKcJf0EEKcVDjCwXU6ehf0j23BRtXaQ+GAO0JajtNdvgGT5FpA==@kvack.org
X-Gm-Message-State: AOJu0YyTMt4i4uqu1mMBY/OPOulonLugEiNSWhR8pmZFgj/hBqYPUNHe
	qcO/EJuKp8YLeHg3c0Pfq2LjO6UfAhKWYOUA3wtAdugzdROLMCd16y5H3uw84uaSeo2x5d7gnHg
	d3bfnSBJt7JFcp+8I1V2i6DpeJuJPn3r1frSKDwROLFTLUX1iJjK3RLuTH50=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1514:b0:4a4:77c:1bda with SMTP id
 5614622812f47-4a42ad053f8mr3971369b6e.4.1783880671257; Sun, 12 Jul 2026
 11:24:31 -0700 (PDT)
Date: Sun, 12 Jul 2026 11:24:31 -0700
In-Reply-To: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a53dbdf.574492cf.19a3b.0010.GAE@google.com>
Subject: [syzbot ci] Re: mm: batch rmap walks during large folio migration
From: syzbot ci <syzbot+ci3fb2c0e04129d571@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, bharata@amd.com, 
	byungchul@sk.com, david@kernel.org, dev.jain@arm.com, fvdl@google.com, 
	gourry@gourry.net, harry@kernel.org, jannh@google.com, 
	joshua.hahnjy@gmail.com, kinseyho@google.com, kmanaouil.dev@gmail.com, 
	lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com, mhocko@suse.com, 
	rakie.kim@sk.com, riel@surriel.com, rientjes@google.com, rppt@kernel.org, 
	shivankg@amd.com, surenb@google.com, vbabka@kernel.org, weixugc@google.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 167591C000D
X-Stat-Signature: b9fxfo5m4n5hwgrgd4cujwf6ss84s34k
X-HE-Tag: 1783880671-542077
X-HE-Meta: U2FsdGVkX1+gAd6RQ4UxReLZy1w8c783TLGTMxUlZFnN7/y+qtcySJFuE9C0AngejCPlF1nZIbvGq9HzOXqqT+H+UedF0hG5WZ7SUgJ6ptGFu3VeGPdHKajvBIQMB1E57yR0jIl6LE50iCmF7jMidLog6VyH0c7SexekechQ3vDs5SObJpM79mZfW/h/SYWlwQKglfkVOYlOPUmmiiYYfyasC0B3WdTqSOIFXr4Ia7ZenOjvvx6v0PfBZbYJM/SwDuD9Jc17HtO6JG0r8DgFG9zx1vOI1jaw1YfrLwSbc232ObWeC+vEkYHxz5xrNaNQ73Qimy7PgM1fKiIzSMREIS7XGSFTLdxBOwazQepMOiVUzGBaQDiP96Q0lAnnXIm5Eyu4n2ih1TeTX2XtzEWB68mWOS1g47dyoAuTH3LUYHxNs2fSCDCM2XwyYV+EdKw2rv0jkG5Z6USieUwzKxojwYr4WLifYmfSIWJUps6Xys9+uQNCL2t1p82/W9kCKXusAojbpVPA1VLi7xOHvErXULxAah0id7o49omTCqBME5GfDnmPz7DSOF8SuScuX6UyKiSfljMJG2K9DNhEkZXW6bxDYeBcHSB2KnywxVOS/n/Y9hkzxKZzWBb0XPR/6MUkSmzBBsRX2PNGoNztJpX/WYGsKYJhHAvSct1UJO37Gz0IVRdsg/qwmjL5qKQ4HsdQ/vAzo27kjSbN68ledjHqrah9bUmQs+QSNOZ/hApvKtClzGMHiljbmHDjP+n86ryY4U7wUa/Kc6GEGhUrJcpxWHqUc40cwL5O8FVauZ42PnvFwblgn+2u0i3MT2tKiL2BEHOkq8F4YoiyODSE8BXIL1dOVibPkqRYlpSoRidHtEzTtG4gEOq2Q9aNClB8kDO7aVC4D7Owz/3dQY6O8mLPhIOwzmX2rosuC1jvAufusSO10zMBUI39878Ab94RMkfWaqDavdMVpuGCItSqjhc
 aV+3QTLp
 VAOAu1J56HAL5wdVr1PPqpZQBEJn66z+SI/5gHXIjqsFPslLBaaOh14ED1YLUEAfWrgDID+Ghh6vyozdbYHkDJnWjYzfhUVeoVoZgNubGpEhoJtc3GqP3dEGEQ5LItqm2/RUjdnyhjBwj4XS5R864/Zrg0eWym+whHtQn5G3h30LT/LQgvbVg/CQVXhHQrkaZN3KDg7jZ7vb1YKy0wNaW9tTlyd80CldKMI/vZlte8wiB3H/qfPP7m7ussH0cEY3qVgQVsTsgMwr62ZVDTKPly5ufntj1HJ5mCRuiiMRkDdtb7acNwNL2uLasMkECmhHLTtf4wX2yVxw1HQ0iNMvk+VUfB8317CJOCd4Z9IZMq1IHTgNXdpbXXZr0/xoST5rbSfo1OERtxLO4FQ1v8lUWEqnwuTpNDvxtoh4+J3tECE7dZAqAEZzhJvMRZ2D8EoWTYpeF9dIhgjhpvlHHIpzyxEFDGX6ZVk9wTKxcDYg5Q2BKRf2fxCuzrUI0vH7V3/23Gfu02hD0hPsqRbdshBIVlNWSgcWcEShsyT53FFpm3MCZPCtoJgGuO0IlCEeqhetP4adOPwjmKuc0wg+Fm2xZnp1TrtjNeuFla7/4WKa/wrTzPAq0zEi8sZETmA/eTcgOtVz9not/0ocu+216qqtwtid8n6sqD2aCaQMCM6zCI3+EQjjXc2bqwzwutDzCaOZ8Mi9RzhHbt0/2JAt1h3NVv+es9oZwRK414fJ7nOceGbLpfQIIe7m2sC6woxD220W26o2YL2zUpdGmGFsetxxyrMnDYpJ3y+rEGN6mTw3tUghQx4N9Aj7C4cRoSMB5UiOhdooouoZrqoivdrSwYQ/dWG2+NGoIQrCOxNumtaWj+YgQfiy3PfYeiDfe/pCc9qzBb5u/a3MdVQfVDOrUnLiLgv0thD9Ck8GLrk3PsG72oSvCs5ig0pVTWCq4kUI/+pHPdpHGxHGpiZYlxd3SvEIsj6Bp5ycd
 J6naZjn4
 QavfyeMkQrXf2OvKQZfgCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm: batch rmap walks during large folio migration
https://lore.kernel.org/all/20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com
* [PATCH 1/6] mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
* [PATCH 2/6] mm: factor out generic PTE batch detection from swap_pte_batch()
* [PATCH 3/6] mm/migrate: split remove_migration_pte_hugetlb() out of remove_migration_pte()
* [PATCH 4/6] mm/migrate: batch the restore-side migration rmap walk
* [PATCH 5/6] mm/rmap: split try_to_migrate_hugetlb_one() out of try_to_migrate_one()
* [PATCH 6/6] mm/rmap: batch the unmap of large folios in try_to_migrate_one()

and found the following issues:
* BUG: scheduling while atomic in exit_to_user_mode_loop
* BUG: sleeping function called from invalid context in migrate_pages
* BUG: sleeping function called from invalid context in migrate_pages_batch
* BUG: sleeping function called from invalid context in move_pages
* BUG: sleeping function called from invalid context in store_status

Full report is available here:
https://ci.syzbot.org/series/f6ed0914-22d0-4ad7-be5e-be4ed8fb9961

***

BUG: scheduling while atomic in exit_to_user_mode_loop

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      61cccb8363fcc282d4ae0555b8739dd227f5ad0b
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/a27db994-58f5-48f4-a7f5-528b63f5a7c6/config
syz repro: https://ci.syzbot.org/findings/72fb0597-196f-4679-88a2-7d2dafda8454/syz_repro

BUG: scheduling while atomic: syz.0.17/5797/0x00000002
1 lock held by syz.0.17/5797:
 #0: ffff88810aa64e58 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #0: ffff88810aa64e58 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock+0x17b/0x1e0 include/linux/hugetlb.h:1318
Modules linked in:
Preemption disabled at:
[<0000000000000000>] 0x0
Kernel panic - not syncing: scheduling while atomic: panic_on_warn set ...
CPU: 0 UID: 0 PID: 5797 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 vpanic+0x56c/0xa60 kernel/panic.c:651
 panic+0xc5/0xd0 kernel/panic.c:788
 check_panic_on_warn+0x89/0xb0 kernel/panic.c:525
 __schedule_bug+0xf6/0x150 kernel/sched/core.c:6061
 schedule_debug kernel/sched/core.c:6090 [inline]
 __schedule+0x189d/0x56c0 kernel/sched/core.c:7083
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 __exit_to_user_mode_loop kernel/entry/common.c:55 [inline]
 exit_to_user_mode_loop+0x83/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1b3439ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc9098d528 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
RAX: 0000000000000000 RBX: 00007f1b34615fa0 RCX: 00007f1b3439ce59
RDX: 0000000000004000 RSI: 0000000000002000 RDI: 0000200000195000
RBP: 00007f1b34432e6f R08: 0000000000000008 R09: 0000000000000003
R10: 0000200000000400 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1b34615fac R14: 00007f1b34615fa0 R15: 00007f1b34615fa0
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


***

BUG: sleeping function called from invalid context in migrate_pages

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      61cccb8363fcc282d4ae0555b8739dd227f5ad0b
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/a27db994-58f5-48f4-a7f5-528b63f5a7c6/config
syz repro: https://ci.syzbot.org/findings/9dd2d2c8-a699-4e7c-8f73-4400d3057853/syz_repro

BUG: sleeping function called from invalid context at mm/migrate.c:1741
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5809, name: syz.0.17
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
1 lock held by syz.0.17/5809:
 #0: ffff88817766d6d8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #0: ffff88817766d6d8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock+0x17b/0x1e0 include/linux/hugetlb.h:1318
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 5809 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
 migrate_hugetlbs mm/migrate.c:1741 [inline]
 migrate_pages+0x49b/0x27e0 mm/migrate.c:2196
 do_mbind mm/mempolicy.c:1617 [inline]
 kernel_mbind mm/mempolicy.c:1760 [inline]
 __do_sys_mbind mm/mempolicy.c:1834 [inline]
 __se_sys_mbind+0xe82/0x10e0 mm/mempolicy.c:1830
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc92ad9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc92bc65028 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
RAX: ffffffffffffffda RBX: 00007fc92b015fa0 RCX: 00007fc92ad9ce59
RDX: 0000000000000001 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007fc92ae32e6f R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc92b016038 R14: 00007fc92b015fa0 R15: 00007ffed35b2a68
 </TASK>

======================================================


***

BUG: sleeping function called from invalid context in migrate_pages_batch

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      61cccb8363fcc282d4ae0555b8739dd227f5ad0b
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/a27db994-58f5-48f4-a7f5-528b63f5a7c6/config
syz repro: https://ci.syzbot.org/findings/1c235813-ad03-46d5-93c7-2702e3513739/syz_repro

BUG: sleeping function called from invalid context at mm/migrate.c:1923
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5820, name: syz.1.20
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
1 lock held by syz.1.20/5820:
 #0: ffff88810903b618 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #0: ffff88810903b618 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock+0x17b/0x1e0 include/linux/hugetlb.h:1318
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 5820 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
 migrate_pages_batch+0x5c5/0x5020 mm/migrate.c:1923
 migrate_pages_sync mm/migrate.c:2115 [inline]
 migrate_pages+0x1a8b/0x27e0 mm/migrate.c:2224
 migrate_to_node mm/mempolicy.c:1322 [inline]
 do_migrate_pages+0x656/0x8b0 mm/mempolicy.c:1421
 kernel_migrate_pages mm/mempolicy.c:1935 [inline]
 __do_sys_migrate_pages mm/mempolicy.c:1953 [inline]
 __se_sys_migrate_pages+0xaa2/0xc90 mm/mempolicy.c:1949
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1175d9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1176c21028 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
RAX: ffffffffffffffda RBX: 00007f1176015fa0 RCX: 00007f1175d9ce59
RDX: 0000200000000000 RSI: 0000000000000004 RDI: 0000000000000000
RBP: 00007f1175e32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000000300 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1176016038 R14: 00007f1176015fa0 R15: 00007ffd17a9f8a8
 </TASK>

======================================================


***

BUG: sleeping function called from invalid context in move_pages

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      61cccb8363fcc282d4ae0555b8739dd227f5ad0b
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/a27db994-58f5-48f4-a7f5-528b63f5a7c6/config
syz repro: https://ci.syzbot.org/findings/5cf317a6-38fc-4f7b-aa15-e8cca68ee0f8/syz_repro

BUG: sleeping function called from invalid context at mm/migrate.c:2320
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5872, name: syz.0.21
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
1 lock held by syz.0.21/5872:
 #0: ffff88810e2682b8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #0: ffff88810e2682b8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock+0x17b/0x1e0 include/linux/hugetlb.h:1318
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 5872 Comm: syz.0.21 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
 __might_fault+0x76/0x130 mm/memory.c:7425
 store_status mm/migrate.c:2320 [inline]
 move_pages_and_store_status mm/migrate.c:2431 [inline]
 do_pages_move mm/migrate.c:2525 [inline]
 kernel_move_pages mm/migrate.c:2704 [inline]
 __do_sys_move_pages mm/migrate.c:2718 [inline]
 __se_sys_move_pages+0x1b5d/0x1c80 mm/migrate.c:2713
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f364019ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3640f79028 EFLAGS: 00000246 ORIG_RAX: 0000000000000117
RAX: ffffffffffffffda RBX: 00007f3640415fa0 RCX: 00007f364019ce59
RDX: 00002000000003c0 RSI: 0000000000000002 RDI: 0000000000000000
RBP: 00007f3640232e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3640416038 R14: 00007f3640415fa0 R15: 00007fff4d7049e8
 </TASK>

=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W          
-----------------------------
syz.0.21/5872 is trying to lock:
ffff88816dd71078 (&mm->mmap_lock){++++}-{4:4}, at: __might_fault+0xaf/0x130 mm/memory.c:7427
other info that might help us debug this:
context-{5:5}
1 lock held by syz.0.21/5872:
 #0: ffff88810e2682b8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #0: ffff88810e2682b8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock+0x17b/0x1e0 include/linux/hugetlb.h:1318
stack backtrace:
CPU: 0 UID: 0 PID: 5872 Comm: syz.0.21 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4830 [inline]
 check_wait_context kernel/locking/lockdep.c:4902 [inline]
 __lock_acquire+0xef0/0x2e50 kernel/locking/lockdep.c:5188
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5890
 __might_fault+0xcb/0x130 mm/memory.c:7427
 store_status mm/migrate.c:2320 [inline]
 move_pages_and_store_status mm/migrate.c:2431 [inline]
 do_pages_move mm/migrate.c:2525 [inline]
 kernel_move_pages mm/migrate.c:2704 [inline]
 __do_sys_move_pages mm/migrate.c:2718 [inline]
 __se_sys_move_pages+0x1b5d/0x1c80 mm/migrate.c:2713
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f364019ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3640f79028 EFLAGS: 00000246 ORIG_RAX: 0000000000000117
RAX: ffffffffffffffda RBX: 00007f3640415fa0 RCX: 00007f364019ce59
RDX: 00002000000003c0 RSI: 0000000000000002 RDI: 0000000000000000
RBP: 00007f3640232e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3640416038 R14: 00007f3640415fa0 R15: 00007fff4d7049e8
 </TASK>
BUG: scheduling while atomic: syz.0.21/5872/0x00000002
INFO: lockdep is turned off.
Modules linked in:
Preemption disabled at:
[<0000000000000000>] 0x0


***

BUG: sleeping function called from invalid context in store_status

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      61cccb8363fcc282d4ae0555b8739dd227f5ad0b
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/a27db994-58f5-48f4-a7f5-528b63f5a7c6/config
syz repro: https://ci.syzbot.org/findings/bd9708eb-bf3f-4bb4-acb1-82ff8e5bb3c2/syz_repro

BUG: sleeping function called from invalid context at mm/migrate.c:2320
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5813, name: syz.1.18
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
1 lock held by syz.1.18/5813:
 #0: ffff888176f9ac78 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #0: ffff888176f9ac78 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock+0x17b/0x1e0 include/linux/hugetlb.h:1318
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 5813 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
 __might_fault+0x76/0x130 mm/memory.c:7425
 store_status+0x40/0xb0 mm/migrate.c:2320
 move_pages_and_store_status mm/migrate.c:2431 [inline]
 do_pages_move mm/migrate.c:2513 [inline]
 kernel_move_pages mm/migrate.c:2704 [inline]
 __do_sys_move_pages mm/migrate.c:2718 [inline]
 __se_sys_move_pages+0x10e4/0x1c80 mm/migrate.c:2713
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb06159ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb062390028 EFLAGS: 00000246 ORIG_RAX: 0000000000000117
RAX: ffffffffffffffda RBX: 00007fb061815fa0 RCX: 00007fb06159ce59
RDX: 00002000000017c0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 00007fb061632e6f R08: 0000200000001840 R09: 0000000000000002
R10: 0000200000001800 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb061816038 R14: 00007fb061815fa0 R15: 00007ffcb4b262e8
 </TASK>

=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W          
-----------------------------
syz.1.18/5813 is trying to lock:
ffff88817695d038 (&mm->mmap_lock){++++}-{4:4}, at: __might_fault+0xaf/0x130 mm/memory.c:7427
other info that might help us debug this:
context-{5:5}
1 lock held by syz.1.18/5813:
 #0: ffff888176f9ac78 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #0: ffff888176f9ac78 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock+0x17b/0x1e0 include/linux/hugetlb.h:1318
stack backtrace:
CPU: 1 UID: 0 PID: 5813 Comm: syz.1.18 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4830 [inline]
 check_wait_context kernel/locking/lockdep.c:4902 [inline]
 __lock_acquire+0xef0/0x2e50 kernel/locking/lockdep.c:5188
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5890
 __might_fault+0xcb/0x130 mm/memory.c:7427
 store_status+0x40/0xb0 mm/migrate.c:2320
 move_pages_and_store_status mm/migrate.c:2431 [inline]
 do_pages_move mm/migrate.c:2513 [inline]
 kernel_move_pages mm/migrate.c:2704 [inline]
 __do_sys_move_pages mm/migrate.c:2718 [inline]
 __se_sys_move_pages+0x10e4/0x1c80 mm/migrate.c:2713
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb06159ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb062390028 EFLAGS: 00000246 ORIG_RAX: 0000000000000117
RAX: ffffffffffffffda RBX: 00007fb061815fa0 RCX: 00007fb06159ce59
RDX: 00002000000017c0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 00007fb061632e6f R08: 0000200000001840 R09: 0000000000000002
R10: 0000200000001800 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb061816038 R14: 00007fb061815fa0 R15: 00007ffcb4b262e8
 </TASK>
BUG: scheduling while atomic: syz.1.18/5813/0x00000002
INFO: lockdep is turned off.
Modules linked in:
Preemption disabled at:
[<0000000000000000>] 0x0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

