Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D314CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CCC78E00EE; Tue, 14 Oct 2025 07:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5048E000D; Tue, 14 Oct 2025 07:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB108E00EE; Tue, 14 Oct 2025 07:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 730388E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:40:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19E6FC08E2
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:40:56 +0000 (UTC)
X-FDA: 83996528112.16.8B85C2D
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3C66F4000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:40:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3xTbuaAkbADoouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3xTbuaAkbADoouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760442054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=/PAUKKVkRXBheGduKaeWvWTn/477z7dsqbwkt84tc7M=;
	b=JIzJ6l2pYr7fCSfYR3xQ1joa1DC3wfag8jKV8prewgUlBoGtzA/wE5Jzeec6XdXXcXmyRY
	8yGCdShCP4bgUtkd9CM0D9N/k6iKyFZIhj2EiFzHDdaZK6k2mB3/tRYuD7vtoKhBU4Ehmj
	bd+bXPl2UihIvKMmsrtTioQvOGakwlY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3xTbuaAkbADoouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3xTbuaAkbADoouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760442054; a=rsa-sha256;
	cv=none;
	b=SUUX56ESC+TBkPIE65v2xgOcfdiyc7glPwQPyE+3SGpNsmaYUdP0GQh0iXVAMBthjVWlNU
	e/193M8cDrOx9Gxs0c2OtufU611f1crJCOpLWpFITuJdkEXwqKNmPRFoADn0N0f7qCzbZJ
	SJe8x9s15amek/WTBWvMTZF6IrHG5+8=
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-42f81a589caso313904565ab.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760442053; x=1761046853;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/PAUKKVkRXBheGduKaeWvWTn/477z7dsqbwkt84tc7M=;
        b=QDP+y3knJlDvox6OibMJOad+RTd4BQSiLyTWu8d3By/GvhYODitDP/46REF5KULMfQ
         56Zh2bZj6LvPShZXtil7HhrfEz1fa9jrAGwtj5vPbCQzvuE5MSlYfxkVGDrS3jex2hHj
         KfRcJArKJBZnfkWkwTxkeOIrM1XdyIjZc/R1fg9Dr1i6emDzqhPf10zADVXzUaTzhoGa
         CSPcZZnF3JkSV8v9vORQvjGzy0s/v+BixOfLyl2T6kJxoOif2Uvhy2BcQLFFyl9p+bRp
         y6QXxQcWeRWh50iXi8vaCF7ZH3yGCbBuR4LcL2TYHWzLDavmd3wD7+iwFcrfkPFT1Zyo
         pNWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUB+TagydNR+SnPsoHT03UuhUQLAV84XUs7RdHXu7MaED6DHhbaFLDUaV6Dvs4KgzTc5+OY1NRYRg==@kvack.org
X-Gm-Message-State: AOJu0YxJ9VyjE+xkdpPJ+dI6jn0I3geiSxLeP5uv1HTf8aLP9VS2LeeF
	5LTF9h7SDhQB3rLwvQriglErETpe3jk4Eqg/Qx+4bi97KWm7EuM/DbIXuJ42JTtcfTTzRX3sKEI
	J2gyzisCWrtlcXZp8iKBfRvuo9il1riaIsgjV4wyVTB9HpXiQvUcD1VOm7Tg=
X-Google-Smtp-Source: AGHT+IHDQOw0MGkhHMkqt81V1i7DK6QslMKoqOhfaUmigwCRgPhS97A7fo8C/0QFK+K1SSvMpG4XPLcD6tLx+1Y2+wXT2DxMF+7G
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ed:b0:42f:680c:9cc7 with SMTP id
 e9e14a558f8ab-42f873de65dmr271168475ab.16.1760442053342; Tue, 14 Oct 2025
 04:40:53 -0700 (PDT)
Date: Tue, 14 Oct 2025 04:40:53 -0700
In-Reply-To: <20251014055828.124522-1-pedrodemargomes@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ee36c5.050a0220.ac43.00fc.GAE@google.com>
Subject: [syzbot ci] Re: ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
From: syzbot ci <syzbot+ci6c8e6d88efa889f1@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chengming.zhou@linux.dev, craftfever@murena.io, 
	david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	pedrodemargomes@gmail.com, xu.xin16@zte.com.cn
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3C66F4000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qywfdednogs3zmo6b8e4rf6iyrs1m7fo
X-HE-Tag: 1760442054-887344
X-HE-Meta: U2FsdGVkX19ePzdueWiosFp23RglyGKwc35e8TUlH3kk8aWNpLeHRzFeJn7Sq5VFJbI0D5dPbOG33rHPpmb71D8Ia+8ivKyuCxKAi3a3YIfgz9TaDySm2luW1K9ffkkhBtOZxNJoWdcDYYSddMcRC5TDewj5tV2RWvinS8w6QyXKlZ+Y/7Kr9hJDMD7WE1wNznwFXJNcfTj554zK7LNHs15sCuzH2Uro2Ue+XLysdlEnx/BmlG2OfTGaLvgEQz0JviaKOa2BMtNM832/0fonfk/H19ng7jh2/5n+Agw1c29f3tgkviSagJA8Z4rLBDtDQy44Xcu4jPZSxllmMKFy9DeSMwqkNgKXlhsW4w/HMxqcLSYe6AElaIVQsFlhDZMJ5hjeKY112xtYGamfKSHZPUc7+AnQif5uNK8saFGoTq+VvJa6Q96EoWCgN8y1RLMyj1nOJoEN7gUFCjIiaYFQELtOGtqNRLbqNgdXQf2arbdKIwhhQvWUtCXzEvAgUaEBuNiDsFIXGe40PXjg1O3GlV/pnuWKmDb3ZPeXJXtb05UXyqPr8fEPgahg6Wzv0ImX+GbuMoMz+oxYRSIU6O7ZTP4dtB5tI6kSFCXp39++nAUa8QzhnZw+dTuXdVtfjZRkmvMjQF+88fKzcEvlZDYDntdnTMNj8+YBdRlfc+EcIUkf9eMFRKMI1CpEohKhCyXEC1vKhx0iU++Z8t9FNHfor0hmCFrkL/gE4G3WcF1Zexn5JQcWGvfupw/sjrszr7m+T5nTmx4jOzqLMDPqi6FeyD2CRmCWhEFZkF2Cb0iKtJ/ihuR0+UYqLrTGN+f5iKMdrejeXXJ7ynPpQE3JlmzJOhzgoX2IOv6pyqztPk/g5E1gN2fXgFegsZjZvx7d+GKutNhwhX8ZAMa2m/Fy5wdWZimB6bw9sJXL82QhmSrEJ4DTHENQGVdnnV8/r0zhWTzBUHgHs/aIDUMy9CkUUYD
 rHMi6Fgm
 eYZEwuwjzuFJvEnlRKoJrG5eTEVbl9pI5lEKZ23M9RsOocd/YQSjdrZvlAqtOWtj1l1VeIhd7DQz2VC9d5LFwYAeF/EVDxra7JSmEJ02COLEspLuTpVnb4FeNCLbTlslxTzx8FioUvdmxtWrTK+c2cZ0ZO3FtZxVElS9sn4Nvw+gSx74OSu+cDa2t4xyBGLqlxAA1h5VqN50Pr/G1S0PHSOs0yldaEAR6elb1TilOd7AluvGKcmDeMQ+KnonaGhnMTqrbOzW2E7LbHkC8dm6CM80UnmYgjPSua4+sWcbOjv7EDWYGbaIwejArJ+zaMMXMWazJeb7Zg2u7YIa64Nr5yHhsebC10asC+wbjVpLAKYFKp7uG81cp7iesxdJe1GwrOk1wHVMg+3gqI17zZTl4u3VLWheQ6/xfGIGSOSyMtwdutxzcrUO5lq1c52x+3Oqh2wQ1kJRXyVVNWxBXMIfBfWdNubaTnja2jTVMkWvPtzzMRABaRJE2nggfNt3IZcwnwmmjB1kiisKBNfAe+ETnGFlUuIbrriMBLxs39v0GgKHlT5wi/QXkzly3UmifHudeWZq3MVWSJ2O3efqyxcT8SHcF772ZPaBhcNrO97flRUa7VjxrG8Aza4xd8C+BJovmJJzkNbcVfpFeUR/4IjbvRwK8cGluEaKlzVOXjvaVIOnHtwci7xIRiP/+jL0cWxzZ11jRN/PJHK1EDju3kngKOPJOS/DUR5xchrTJP1qvJAszEjSBPAKG6ReTuIAVzN2O7ELTV+ulV9UnD7qlXGS11TzSPkPZ6Tx8stseVFk7XukZN5T2y6bjisI9dUHwEO8rYyV+X4ic7sGjtiS/qxLPHhel0jIUDX2NemtcFYiAkvELz79fvqfTh5aKrYIIcW0TlcDww8OP4iEGSyidexdhFLHJlGGDVnYrhujL3O9tZvDIw2/X6OoCQ3ZOgeq4JWisRLboU7h4U0OE7QoMRULutBKoAIT9
 cFpsyrjX
 vMqolX4QAWsCZTZpdZqEjN2kXBG/BEm4atbahc886Tu4QeL3E5JeVNDLHAtB3Sh6VC9//ZGnsdw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
https://lore.kernel.org/all/20251014055828.124522-1-pedrodemargomes@gmail.com
* [PATCH] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item

and found the following issue:
possible deadlock in __pte_offset_map_lock

Full report is available here:
https://ci.syzbot.org/series/15a341dd-23e3-4627-9fb9-00b92b7bae3f

***

possible deadlock in __pte_offset_map_lock

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0d97f2067c166eb495771fede9f7b73999c67f66
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/31dfd455-a2ef-4c41-8f8d-172612e161d9/config
C repro:   https://ci.syzbot.org/findings/5bddd702-c879-4aa6-b86d-5be2b4b3d0e2/c_repro
syz repro: https://ci.syzbot.org/findings/5bddd702-c879-4aa6-b86d-5be2b4b3d0e2/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
ksmd/41 is trying to acquire lock:
ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:318 [inline]
ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4897 [inline]
ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:5221 [inline]
ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5252

but task is already holding lock:
ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: __pte_offset_map_lock+0x13e/0x210 mm/pgtable-generic.c:401

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       spin_lock include/linux/spinlock.h:351 [inline]
       map_pte mm/page_vma_mapped.c:72 [inline]
       page_vma_mapped_walk+0xeea/0x20f0 mm/page_vma_mapped.c:291
       try_to_migrate_one+0x5d8/0x34d0 mm/rmap.c:2339
       rmap_walk_anon+0x553/0x730 mm/rmap.c:2855
       try_to_migrate+0x319/0x3d0 mm/rmap.c:-1
       migrate_folio_unmap mm/migrate.c:1319 [inline]
       migrate_pages_batch+0x1432/0x35e0 mm/migrate.c:1882
       migrate_pages+0x1d5a/0x2930 mm/migrate.c:2103
       migrate_misplaced_folio+0x28c/0x840 mm/migrate.c:2724
       do_numa_page mm/memory.c:6004 [inline]
       handle_pte_fault mm/memory.c:6183 [inline]
       __handle_mm_fault+0x3bab/0x5400 mm/memory.c:6318
       handle_mm_fault+0x40a/0x8e0 mm/memory.c:6487
       do_user_addr_fault+0x764/0x1380 arch/x86/mm/fault.c:1387
       handle_page_fault arch/x86/mm/fault.c:1476 [inline]
       exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
       __get_user_8+0x14/0x30 arch/x86/lib/getuser.S:100
       rseq_get_rseq_cs_ptr_val kernel/rseq.c:248 [inline]
       rseq_get_rseq_cs kernel/rseq.c:270 [inline]
       rseq_ip_fixup kernel/rseq.c:390 [inline]
       __rseq_handle_notify_resume+0x13d/0x1220 kernel/rseq.c:438
       rseq_handle_notify_resume include/linux/rseq.h:44 [inline]
       resume_user_mode_work include/linux/resume_user_mode.h:62 [inline]
       exit_to_user_mode_loop+0xbf/0x130 kernel/entry/common.c:43
       exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
       syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
       do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&anon_vma->rwsem){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       anon_vma_lock_write include/linux/rmap.h:122 [inline]
       vma_prepare+0x25c/0x4b0 mm/vma.c:309
       __split_vma+0x76e/0xa00 mm/vma.c:550
       split_vma mm/vma.c:598 [inline]
       vma_modify+0x13b3/0x1970 mm/vma.c:1631
       vma_modify_flags+0x1e8/0x230 mm/vma.c:1649
       mprotect_fixup+0x407/0x9c0 mm/mprotect.c:816
       do_mprotect_pkey+0x8c5/0xcd0 mm/mprotect.c:990
       __do_sys_mprotect mm/mprotect.c:1011 [inline]
       __se_sys_mprotect mm/mprotect.c:1008 [inline]
       __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:1008
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&mapping->i_mmap_rwsem){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       i_mmap_lock_write include/linux/fs.h:548 [inline]
       dma_resv_lockdep+0x2f6/0x5b0 drivers/dma-buf/dma-resv.c:797
       do_one_initcall+0x236/0x820 init/main.c:1283
       do_initcall_level+0x104/0x190 init/main.c:1345
       do_initcalls+0x59/0xa0 init/main.c:1361
       kernel_init_freeable+0x334/0x4b0 init/main.c:1593
       kernel_init+0x1d/0x1d0 init/main.c:1483
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4283
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4897 [inline]
       slab_alloc_node mm/slub.c:5221 [inline]
       kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5252
       alloc_rmap_item mm/ksm.c:565 [inline]
       get_next_rmap_item mm/ksm.c:2378 [inline]
       ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
       walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
       walk_pte_range mm/pagewalk.c:88 [inline]
       walk_pmd_range mm/pagewalk.c:155 [inline]
       walk_pud_range mm/pagewalk.c:224 [inline]
       walk_p4d_range mm/pagewalk.c:262 [inline]
       walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
       __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
       walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
       scan_get_next_rmap_item mm/ksm.c:2605 [inline]
       ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
       ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> &anon_vma->rwsem --> ptlock_ptr(ptdesc)#2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(ptlock_ptr(ptdesc)#2);
                               lock(&anon_vma->rwsem);
                               lock(ptlock_ptr(ptdesc)#2);
  lock(fs_reclaim);

 *** DEADLOCK ***

4 locks held by ksmd/41:
 #0: ffffffff8e259b88 (ksm_thread_mutex){+.+.}-{4:4}, at: ksm_scan_thread+0xc8/0x4b0 mm/ksm.c:2703
 #1: ffff8881703b9760 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:368 [inline]
 #1: ffff8881703b9760 (&mm->mmap_lock){++++}-{4:4}, at: scan_get_next_rmap_item mm/ksm.c:2596 [inline]
 #1: ffff8881703b9760 (&mm->mmap_lock){++++}-{4:4}, at: ksm_do_scan+0x578/0x5c10 mm/ksm.c:2681
 #2: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #2: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #2: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: ___pte_offset_map+0x29/0x250 mm/pgtable-generic.c:286
 #3: ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #3: ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: __pte_offset_map_lock+0x13e/0x210 mm/pgtable-generic.c:401

stack backtrace:
CPU: 1 UID: 0 PID: 41 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full) 
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
 __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
 fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4283
 might_alloc include/linux/sched/mm.h:318 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 41 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

