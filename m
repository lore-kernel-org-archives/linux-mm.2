Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A5AAEA8549
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 22:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3AA6B0005; Sun,  8 Mar 2026 18:54:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B806B0089; Sun,  8 Mar 2026 18:54:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D786B008A; Sun,  8 Mar 2026 18:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E214C6B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 18:54:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FA88596CD
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:54:49 +0000 (UTC)
X-FDA: 84524402298.03.C9002FD
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id CAC9980010
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:54:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3Nv6taQkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.72 as permitted sender) smtp.mailfrom=3Nv6taQkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773010487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=klmV39Nldt/BfDzkGU2IfR5AFtDZJ6Lqo+Yc/PdnYY0=;
	b=VVMsesOIT9TqH+FaG3HoAk7h5wjwK2zZZkiaF4YC0Kp1NOk1SnX2Ztj98vF03IeumpUX2Y
	fnU3LIdhAzNeRAn3DO/rW5Y2DQitQIq4ZFUg7e7t41xQuTmCLFfoX6avGPsR6EO9JX0Xon
	pZAw7Onkae1tFC0Zc4YFOcRje3CvZ94=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3Nv6taQkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.72 as permitted sender) smtp.mailfrom=3Nv6taQkbAD8tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773010487; a=rsa-sha256;
	cv=none;
	b=szhSTiyA4UANGmfE4f6IHUsRlesMlDMWMlbKWHVIaZnUMsm0oQ3J8ea5ijduNe3aYCbdog
	86UKJlKYdXYsoPQVNnrqwjKJOvOqIYqK4nnnGI60q0jB0snfcOjNsiQwSQ6mGHk8ktBaUR
	mkmPBfbKsyscRUnoAXAOel7ALSHxVOk=
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-417323e3806so3017942fac.2
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 15:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773010487; x=1773615287;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=klmV39Nldt/BfDzkGU2IfR5AFtDZJ6Lqo+Yc/PdnYY0=;
        b=PZWPB+6qMq5CMM9N3iSJbQdf3pW0D50tZpceZ+0b5MZvlN1NRMi2TXtxY13YoRd+gV
         uMyLB0ysi4dGn2e11uJQxMlqYW5Zkv3QdsRme4b23tX3vkQaz95KhAICnMHG6by8BwSJ
         wnryUtoesLjnKgBvIckJX+aMhaWGrw7Jz89+L8GAliSfNf2u+RmZc5ySqcP21fRiCJIg
         hSEPu76cRw6PKFUAYUowloh6QecMKJTxQZ6uf3RjRBalXg3cTzUohfNbGVsRFkUF1WlQ
         ktiGDj5s8BjmMLzLZsOQ0L8ywj1yVZqdqV9D2AucoJiqPgnHGvlyUtFO0n7SaB3Q72id
         SmAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqmVyr40dHn+MRsMlmVxH55WPq//idoZMl2sHFc20+0YgVT4qUQRE0oAmRB2fEC/70nCofc/Knlw==@kvack.org
X-Gm-Message-State: AOJu0Yw9d0BvMSf56Bccpi28t1Ce10gk1W1YCazhtAAd/Gb+Ju1r809c
	jqPSWocVJN8+VEUnPWMH4sJc1+cGV6yldhhoLU7lsD+rtUM/cotCWt2RMfCOUY+xLLupqKLdS4z
	M9bjsfmCKi8y2m0SFm6WtjfjLW9JeUvfksZtH9jnVEKxVEX/boypyA4CiNuU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2207:b0:67b:b13c:5a12 with SMTP id
 006d021491bc7-67bb13c5b4cmr1608311eaf.45.1773010486761; Sun, 08 Mar 2026
 15:54:46 -0700 (PDT)
Date: Sun, 08 Mar 2026 15:54:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69adfe36.a70a0220.52840.0008.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: suspicious RCU usage in usb_tx_block
From: syzbot <syzbot+602b46de41ef3a75dfb3@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, frederic@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CAC9980010
X-Rspamd-Server: rspam07
X-Stat-Signature: 3y19gt1j34b697pkk3grcfbgaw8koprs
X-Rspam-User: 
X-HE-Tag: 1773010487-295240
X-HE-Meta: U2FsdGVkX1/n6rqM1kmJRKzOq/JlLmSUxznHQC15bJXkdEBwme07Xjmhv82C8ejOmDisAEp/gH4JT7HoL+FygOzR4GeH1WPlNorKNiOhPM5CTxDkKT2B/oKmPfX7QOPbaoK6uYbMLo2Ly+vwtdNVIN8qLOKpTk8PCvMoISG9WleNngZk3BEaBJdmHDjY7XCQ1i7G8taS6hEyQn3XdS/36U78hkbwjpezZaCkm3dnt2xxSruJA5ZLKeexcZS+0+zNh50aiYJweZSRF/gBJrREOgtViDSnI2m2B+dglplOSldv4+dE6wodQ3HdmfdjjN1Q2ViBGGvyD+BBGCHp5c+t5gii7tal4VP4/olzzX/LMcXnTW7uvvZ4LTf+ArQB5NGg7l9B8/Q1Fvjt3v9ge2DeYP5TjFLudbfeF0+0uPKYUQ+rO8xtGcDNLfgdet5FOw9ZEx/FJgVCCr6Xbo4yHoZqUU16WJrAAYbljWTf4qvv96t4+fLj5gNZTqK8E8zYrqxc1K83NQy/+0mwJhG3dEMe143OTaZQTH7TdK2434qewYWFJfsAXdRTW1TP1evsP1yrQr3MXXqss6R5kdQOe4u8p1ufzhubFeewTKic3TnEfbQHSQ0c4uqtLqL7ZNqzt0JpN5aE7l0wuWhrwf/90F5j9saHTTmSgI3vBek1JTkfb1omJ3Rboofplj/SQ84UggPIKtQBc0uzbQuVFRJhDlr2Kf/nvHlMMMOBelEO/Bgd2YglnTP9k/7v7dK1W2X65JX+wXERdbYPuYGYMv4Oyod0PWpwsLF1rRbLhzxXCnQkJ3Em2Bmj1yL9UMKvDlv0iZQ6Ot8c7XO9EnozAuV+E4/DeFYBm0wMswjGNvkshemuewpPHdMmfJJYd7G/vIoc8Cts0X7W2KmCyr+sAevBbyD38ymSPnIG8qIBJ2B0G0w2QiA8ll+J6TQoJfr8dbBSTu+c3iHMWwwIlnol8C75uHQ
 OWpnpTqw
 F+C1OEVLVefQT/4jeLSubW+QifeymHBh68t6DTgW3h3Yco1ofY/PG7N0kvpDZ7D4BVxaUT7NuJpFEoWpsIzfxdv+7mvsT+qh4CaamUxgpbvfNo8gaDBHucIxMYWcJfycDedB5UJOWJPcCutwdXmKYk9ihX6yko370jPhJbmGQx2Z/VyNnTxPC6CkrjBSMgH4rfSNinxLb+uSOfGa6kvYebpr3dGOl0vQqMNRoEwufkCdQTacGEGXLtbD/+6jf+dvjEK/bbiyW/qUUBVltbLjZFZV2iRURg5/83fx/IuL+wolYlmjAFjkR6buerGzxu4127Wq2H1H+x7sVdEbubrIrdT4M8CQ4YEcyBkT0HbbqJi/22JRd+RJit0+rvxYyV2yHVZvIppvPTMmPFypyuzWf7bF0HEz/BV7eqI1cDR6jvkfgc9whw6EG3CW/VYHP5UrqPtxXYlFrAdWdZUnzHe+AVX9v9yuqJzrXSzt+rNVdM9Q4mOri6yjsmtMuZob2JT1LB5P9WlF4A7M9b2Oa9tbeL3yumnYc1lTBL1Ji/ge6TH8aZGx38AbMXEj4G79AAqbytVWbtBH1RQT+sBAZ+pIOkQixBMJmnoSDq0LCFzgQHk/RGHCF7Igvqz3v0dpkLfgXjF5mEiLcbyxvAxlZA8MhrWsL/LUF+Aw7gFjDxrSh51k52+xmvcn05KhpY4APj8YqcwXQU7azJs6mEsY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    bb375c251ab4 dt-bindings: usb: st,st-ohci-300x: convert to..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=13e19552580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1500201919951cc
dashboard link: https://syzkaller.appspot.com/bug?extid=602b46de41ef3a75dfb3
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2475c3172471/disk-bb375c25.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/30449aa672dd/vmlinux-bb375c25.xz
kernel image: https://storage.googleapis.com/syzbot-assets/46d3937d1c16/bzImage-bb375c25.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+602b46de41ef3a75dfb3@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
kernel/sched/core.c:8846 Illegal context switch in RCU-sched read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
8 locks held by syz-executor/16541:
 #0: ffffffff898137d0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm kernel/fork.c:1529 [inline]
 #0: ffffffff898137d0 (dup_mmap_sem){.+.+}-{0:0}, at: copy_mm kernel/fork.c:1582 [inline]
 #0: ffffffff898137d0 (dup_mmap_sem){.+.+}-{0:0}, at: copy_process+0x4594/0x7800 kernel/fork.c:2223
 #1: ffff888114e4cb40 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:554 [inline]
 #1: ffff888114e4cb40 (&mm->mmap_lock){++++}-{4:4}, at: dup_mmap+0x11f/0x1f30 mm/mmap.c:1740
 #2: ffff88811c64b340 (&mm->mmap_lock/1){+.+.}-{4:4}, at: mmap_write_lock_nested include/linux/mmap_lock.h:544 [inline]
 #2: ffff88811c64b340 (&mm->mmap_lock/1){+.+.}-{4:4}, at: dup_mmap+0x1ba/0x1f30 mm/mmap.c:1747
 #3: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #3: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #3: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x300 mm/pgtable-generic.c:288
 #4: ffff8881356161f8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}
, at: spin_lock include/linux/spinlock.h:341 [inline]
, at: pte_offset_map_lock+0x10f/0x320 mm/pgtable-generic.c:402
 #5: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #5: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #5: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x300 mm/pgtable-generic.c:288
 #6: ffff88813be78978 (ptlock_ptr(ptdesc)#2/1){+.+.}-{3:3}, at: copy_pte_range mm/memory.c:1269 [inline]
 #6: ffff88813be78978 (ptlock_ptr(ptdesc)#2/1){+.+.}-{3:3}, at: copy_pmd_range mm/memory.c:1405 [inline]
 #6: ffff88813be78978 (ptlock_ptr(ptdesc)#2/1){+.+.}-{3:3}, at: copy_pud_range mm/memory.c:1442 [inline]
 #6: ffff88813be78978 (ptlock_ptr(ptdesc)#2/1){+.+.}-{3:3}, at: copy_p4d_range mm/memory.c:1466 [inline]
 #6: ffff88813be78978 (ptlock_ptr(ptdesc)#2/1){+.+.}-{3:3}, at: copy_page_range+0xc75/0x2630 mm/memory.c:1552
 #7: ffffffff896e04e0 (rcu_read_lock_sched){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #7: ffffffff896e04e0 (rcu_read_lock_sched){....}-{1:2}, at: rcu_read_lock_sched include/linux/rcupdate.h:948 [inline]
 #7: ffffffff896e04e0 (rcu_read_lock_sched){....}-{1:2}, at: pfn_valid include/linux/mmzone.h:2197 [inline]
 #7: ffffffff896e04e0 (rcu_read_lock_sched){....}-{1:2}, at: page_table_check_set+0x4f/0xa10 mm/page_table_check.c:105

stack backtrace:
CPU: 0 UID: 0 PID: 16541 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 lockdep_rcu_suspicious.cold+0x4f/0xb1 kernel/locking/lockdep.c:6876
 __might_resched+0x2e0/0x330 kernel/sched/core.c:8846
 usb_kill_urb+0x8e/0x320 drivers/usb/core/urb.c:705
 usb_tx_block+0x91/0x320 drivers/net/wireless/marvell/libertas/if_usb.c:429
 if_usb_send_fw_pkt.isra.0+0x2e4/0x550 drivers/net/wireless/marvell/libertas/if_usb.c:366
 if_usb_receive_fwload+0x5d3/0x780 drivers/net/wireless/marvell/libertas/if_usb.c:592
 __usb_hcd_giveback_urb+0x38d/0x610 drivers/usb/core/hcd.c:1657
 usb_hcd_giveback_urb+0x3ca/0x4a0 drivers/usb/core/hcd.c:1741
 dummy_timer+0xd85/0x3670 drivers/usb/gadget/udc/dummy_hcd.c:1995
 __run_hrtimer kernel/time/hrtimer.c:1785 [inline]
 __hrtimer_run_queues+0x50e/0xa70 kernel/time/hrtimer.c:1849
 hrtimer_run_softirq+0x17d/0x350 kernel/time/hrtimer.c:1866
 handle_softirqs+0x1de/0x9d0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xed/0x150 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0x8f/0xb0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:__sanitizer_cov_trace_pc+0xb/0x70 kernel/kcov.c:213
Code: 5a 00 be 03 00 00 00 5b e9 e2 26 1a 01 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 65 8b 05 25 16 43 0b <48> 8b 34 24 65 48 8b 15 01 16 43 0b a9 00 01 ff 00 74 1b f6 c4 01
RSP: 0018:ffffc9001495f398 EFLAGS: 00000202
RAX: 0000000080000003 RBX: 00000000001475a1 RCX: ffffffff821a7c7e
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88811632ba00
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000008
R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
 rcu_read_unlock_sched include/linux/rcupdate.h:970 [inline]
 pfn_valid include/linux/mmzone.h:2207 [inline]
 page_table_check_set+0x86d/0xa10 mm/page_table_check.c:105
 __page_table_check_ptes_set+0x1db/0x230 mm/page_table_check.c:215
 page_table_check_ptes_set include/linux/page_table_check.h:83 [inline]
 set_ptes include/linux/pgtable.h:413 [inline]
 __copy_present_ptes mm/memory.c:1115 [inline]
 copy_present_ptes+0xcc4/0x4590 mm/memory.c:1194
 copy_pte_range mm/memory.c:1317 [inline]
 copy_pmd_range mm/memory.c:1405 [inline]
 copy_pud_range mm/memory.c:1442 [inline]
 copy_p4d_range mm/memory.c:1466 [inline]
 copy_page_range+0xe45/0x2630 mm/memory.c:1552
 dup_mmap+0xcb9/0x1f30 mm/mmap.c:1841
 dup_mm kernel/fork.c:1530 [inline]
 copy_mm kernel/fork.c:1582 [inline]
 copy_process+0x459f/0x7800 kernel/fork.c:2223
 kernel_clone+0xfc/0x9a0 kernel/fork.c:2654
 __do_sys_clone+0xd9/0x120 kernel/fork.c:2795
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x106/0x7b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3e86fc5212
Code: 89 e7 e8 71 8b f7 ff 45 31 c0 31 d2 31 f6 64 48 8b 04 25 10 00 00 00 bf 11 00 20 01 4c 8d 90 d0 02 00 00 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 66 89 c5 85 c0 75 3b 64 48 8b 04 25 10 00 00
RSP: 002b:00007fff99746eb0 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fff99746eb0 RCX: 00007f3e86fc5212
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
RBP: 00007fff9974703c R08: 0000000000000000 R09: 0000000000000001
R10: 00005555833b67d0 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000000927c0 R14: 0000000000301ae6 R15: 00007fff99747090
 </TASK>
BUG: sleeping function called from invalid context at drivers/usb/core/urb.c:705
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 16541, name: syz-executor
preempt_count: 103, expected: 0
RCU nest depth: 2, expected: 0
8 locks held by syz-executor/16541:
 #0: 
ffffffff898137d0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm kernel/fork.c:1529 [inline]
ffffffff898137d0 (dup_mmap_sem){.+.+}-{0:0}, at: copy_mm kernel/fork.c:1582 [inline]
ffffffff898137d0 (dup_mmap_sem){.+.+}-{0:0}, at: copy_process+0x4594/0x7800 kernel/fork.c:2223
 #1: ffff888114e4cb40 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:554 [inline]
 #1: ffff888114e4cb40 (&mm->mmap_lock){++++}-{4:4}, at: dup_mmap+0x11f/0x1f30 mm/mmap.c:1740
 #2: 
ffff88811c64b340 (&mm->mmap_lock
/1){+.+.}-{4:4}, at: mmap_write_lock_nested include/linux/mmap_lock.h:544 [inline]
/1){+.+.}-{4:4}, at: dup_mmap+0x1ba/0x1f30 mm/mmap.c:1747
 #3: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #3: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #3: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x300 mm/pgtable-generic.c:288
 #4: ffff8881356161f8 (ptlock_ptr(ptdesc)
#2){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x10f/0x320 mm/pgtable-generic.c:402
 #5: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #5: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #5: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x300 mm/pgtable-generic.c:288
 #6: ffff88813be78978 (ptlock_ptr(ptdesc)
#2/1){+.+.}-{3:3}
, at: copy_pte_range mm/memory.c:1269 [inline]
, at: copy_pmd_range mm/memory.c:1405 [inline]
, at: copy_pud_range mm/memory.c:1442 [inline]
, at: copy_p4d_range mm/memory.c:1466 [inline]
, at: copy_page_range+0xc75/0x2630 mm/memory.c:1552
 #7: ffffffff896e04e0 (rcu_read_lock_sched){....}-{1:2}
, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
, at: rcu_read_lock_sched include/linux/rcupdate.h:948 [inline]
, at: pfn_valid include/linux/mmzone.h:2197 [inline]
, at: page_table_check_set+0x4f/0xa10 mm/page_table_check.c:105
irq event stamp: 4986957
hardirqs last  enabled at (4986956): [<ffffffff876b20b2>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:178 [inline]
hardirqs last  enabled at (4986956): [<ffffffff876b20b2>] _raw_spin_unlock_irqrestore+0x52/0x80 kernel/locking/spinlock.c:194
hardirqs last disabled at (4986957): [<ffffffff876b1dc2>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:130 [inline]
hardirqs last disabled at (4986957): [<ffffffff876b1dc2>] _raw_spin_lock_irqsave+0x52/0x60 kernel/locking/spinlock.c:162
softirqs last  enabled at (4986950): [<ffffffff8176f0bd>] __do_softirq kernel/softirq.c:656 [inline]
softirqs last  enabled at (4986950): [<ffffffff8176f0bd>] invoke_softirq kernel/softirq.c:496 [inline]
softirqs last  enabled at (4986950): [<ffffffff8176f0bd>] __irq_exit_rcu+0xed/0x150 kernel/softirq.c:723
softirqs last disabled at (4986953): [<ffffffff8176f0bd>] __do_softirq kernel/softirq.c:656 [inline]
softirqs last disabled at (4986953): [<ffffffff8176f0bd>] invoke_softirq kernel/softirq.c:496 [inline]
softirqs last disabled at (4986953): [<ffffffff8176f0bd>] __irq_exit_rcu+0xed/0x150 kernel/softirq.c:723
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 16541 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 __might_resched.cold+0x1ec/0x232 kernel/sched/core.c:8884
 usb_kill_urb+0x8e/0x320 drivers/usb/core/urb.c:705
 usb_tx_block+0x91/0x320 drivers/net/wireless/marvell/libertas/if_usb.c:429
 if_usb_send_fw_pkt.isra.0+0x2e4/0x550 drivers/net/wireless/marvell/libertas/if_usb.c:366
 if_usb_receive_fwload+0x5d3/0x780 drivers/net/wireless/marvell/libertas/if_usb.c:592
 __usb_hcd_giveback_urb+0x38d/0x610 drivers/usb/core/hcd.c:1657
 usb_hcd_giveback_urb+0x3ca/0x4a0 drivers/usb/core/hcd.c:1741
 dummy_timer+0xd85/0x3670 drivers/usb/gadget/udc/dummy_hcd.c:1995
 __run_hrtimer kernel/time/hrtimer.c:1785 [inline]
 __hrtimer_run_queues+0x50e/0xa70 kernel/time/hrtimer.c:1849
 hrtimer_run_softirq+0x17d/0x350 kernel/time/hrtimer.c:1866
 handle_softirqs+0x1de/0x9d0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xed/0x150 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0x8f/0xb0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:__sanitizer_cov_trace_pc+0xb/0x70 kernel/kcov.c:213
Code: 5a 00 be 03 00 00 00 5b e9 e2 26 1a 01 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 65 8b 05 25 16 43 0b <48> 8b 34 24 65 48 8b 15 01 16 43 0b a9 00 01 ff 00 74 1b f6 c4 01
RSP: 0018:ffffc9001495f398 EFLAGS: 00000202
RAX: 0000000080000003 RBX: 00000000001475a1 RCX: ffffffff821a7c7e
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88811632ba00
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000008
R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
 rcu_read_unlock_sched include/linux/rcupdate.h:970 [inline]
 pfn_valid include/linux/mmzone.h:2207 [inline]
 page_table_check_set+0x86d/0xa10 mm/page_table_check.c:105
 __page_table_check_ptes_set+0x1db/0x230 mm/page_table_check.c:215
 page_table_check_ptes_set include/linux/page_table_check.h:83 [inline]
 set_ptes include/linux/pgtable.h:413 [inline]
 __copy_present_ptes mm/memory.c:1115 [inline]
 copy_present_ptes+0xcc4/0x4590 mm/memory.c:1194
 copy_pte_range mm/memory.c:1317 [inline]
 copy_pmd_range mm/memory.c:1405 [inline]
 copy_pud_range mm/memory.c:1442 [inline]
 copy_p4d_range mm/memory.c:1466 [inline]
 copy_page_range+0xe45/0x2630 mm/memory.c:1552
 dup_mmap+0xcb9/0x1f30 mm/mmap.c:1841
 dup_mm kernel/fork.c:1530 [inline]
 copy_mm kernel/fork.c:1582 [inline]
 copy_process+0x459f/0x7800 kernel/fork.c:2223
 kernel_clone+0xfc/0x9a0 kernel/fork.c:2654
 __do_sys_clone+0xd9/0x120 kernel/fork.c:2795
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x106/0x7b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3e86fc5212
Code: 89 e7 e8 71 8b f7 ff 45 31 c0 31 d2 31 f6 64 48 8b 04 25 10 00 00 00 bf 11 00 20 01 4c 8d 90 d0 02 00 00 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 66 89 c5 85 c0 75 3b 64 48 8b 04 25 10 00 00
RSP: 002b:00007fff99746eb0 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fff99746eb0 RCX: 00007f3e86fc5212
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
RBP: 00007fff9974703c R08: 0000000000000000 R09: 0000000000000001
R10: 00005555833b67d0 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000000927c0 R14: 0000000000301ae6 R15: 00007fff99747090
 </TASK>
BUG: scheduling while atomic: syz-executor/16541/0x00000104
8 locks held by syz-executor/16541:
 #0: ffffffff898137d0
 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm kernel/fork.c:1529 [inline]
 (dup_mmap_sem){.+.+}-{0:0}, at: copy_mm kernel/fork.c:1582 [inline]
 (dup_mmap_sem){.+.+}-{0:0}, at: copy_process+0x4594/0x7800 kernel/fork.c:2223
 #1: ffff888114e4cb40 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:554 [inline]
 #1: ffff888114e4cb40 (&mm->mmap_lock){++++}-{4:4}, at: dup_mmap+0x11f/0x1f30 mm/mmap.c:1740
 #2: ffff88811c64b340 (&mm->mmap_lock/1){+.+.}-{4:4}, at: mmap_write_lock_nested include/linux/mmap_lock.h:544 [inline]
 #2: ffff88811c64b340 (&mm->mmap_lock/1){+.+.}-{4:4}, at: dup_mmap+0x1ba/0x1f30 mm/mmap.c:1747
 #3: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #3: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #3: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x300 mm/pgtable-generic.c:288
 #4: ffff8881356161f8 (ptlock_ptr(ptdesc)#2
){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
){+.+.}-{3:3}, at: pte_offset_map_lock+0x10f/0x320 mm/pgtable-generic.c:402
 #5: ffffffff896e05a0 (rcu_read_lock){....}-{1:3}
, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
, at: __pte_offset_map+0x2f/0x300 mm/pgtable-generic.c:288
 #6: 
ffff88813be78978
 (ptlock_ptr(ptdesc)#2/1){+.+.}-{3:3}
, at: copy_pte_range mm/memory.c:1269 [inline]
, at: copy_pmd_range mm/memory.c:1405 [inline]
, at: copy_pud_range mm/memory.c:1442 [inline]
, at: copy_p4d_range mm/memory.c:1466 [inline]
, at: copy_page_range+0xc75/0x2630 mm/memory.c:1552
 #7: ffffffff896e04e0 (rcu_read_lock_sched
){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
){....}-{1:2}, at: rcu_read_lock_sched include/linux/rcupdate.h:948 [inline]
){....}-{1:2}, at: pfn_valid include/linux/mmzone.h:2197 [inline]
){....}-{1:2}, at: page_table_check_set+0x4f/0xa10 mm/page_table_check.c:105
Modules linked in:
irq event stamp: 4986957
hardirqs last  enabled at (4986956): [<ffffffff876b20b2>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:178 [inline]
hardirqs last  enabled at (4986956): [<ffffffff876b20b2>] _raw_spin_unlock_irqrestore+0x52/0x80 kernel/locking/spinlock.c:194
hardirqs last disabled at (4986957): [<ffffffff876b1dc2>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:130 [inline]
hardirqs last disabled at (4986957): [<ffffffff876b1dc2>] _raw_spin_lock_irqsave+0x52/0x60 kernel/locking/spinlock.c:162
softirqs last  enabled at (4986950): [<ffffffff8176f0bd>] __do_softirq kernel/softirq.c:656 [inline]
softirqs last  enabled at (4986950): [<ffffffff8176f0bd>] invoke_softirq kernel/softirq.c:496 [inline]
softirqs last  enabled at (4986950): [<ffffffff8176f0bd>] __irq_exit_rcu+0xed/0x150 kernel/softirq.c:723
softirqs last disabled at (4986953): [<ffffffff8176f0bd>] __do_softirq kernel/softirq.c:656 [inline]
softirqs last disabled at (4986953): [<ffffffff8176f0bd>] invoke_softirq kernel/softirq.c:496 [inline]
softirqs last disabled at (4986953): [<ffffffff8176f0bd>] __irq_exit_rcu+0xed/0x150 kernel/softirq.c:723
Preemption disabled at:
[<0000000000000000>] 0x0
----------------
Code disassembly (best guess):
   0:	5a                   	pop    %rdx
   1:	00 be 03 00 00 00    	add    %bh,0x3(%rsi)
   7:	5b                   	pop    %rbx
   8:	e9 e2 26 1a 01       	jmp    0x11a26ef
   d:	66 90                	xchg   %ax,%ax
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	90                   	nop
  1c:	90                   	nop
  1d:	90                   	nop
  1e:	90                   	nop
  1f:	f3 0f 1e fa          	endbr64
  23:	65 8b 05 25 16 43 0b 	mov    %gs:0xb431625(%rip),%eax        # 0xb43164f
* 2a:	48 8b 34 24          	mov    (%rsp),%rsi <-- trapping instruction
  2e:	65 48 8b 15 01 16 43 	mov    %gs:0xb431601(%rip),%rdx        # 0xb431637
  35:	0b
  36:	a9 00 01 ff 00       	test   $0xff0100,%eax
  3b:	74 1b                	je     0x58
  3d:	f6 c4 01             	test   $0x1,%ah


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

