Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CCB6CD3426
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 11:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E6C6B0005; Sun,  3 May 2026 07:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECEC16B008A; Sun,  3 May 2026 07:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD9B6B008C; Sun,  3 May 2026 07:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6E066B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 07:47:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 567A51C069D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 11:47:29 +0000 (UTC)
X-FDA: 84725933418.11.ED0A337
Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E37080009
	for <linux-mm@kvack.org>; Sun,  3 May 2026 11:47:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3zjX3aQkbAG0djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3zjX3aQkbAG0djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777808847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=XzAAI/ptUzx8XTD2iRvyBhOM1/obDCx04Mkukv6AGf0=;
	b=47iA+DRMRUzgNbaMMg/pf9VJY1nPHUIA7OblNHT2Li/h2XgF7b4mNPO14Ots+aUbVa4Kwh
	8bxv0fabZ2sJhlYN2q2ZpPX6s2nYfHK6k4TnBKfRLagz5c4Y1ryLyTV0KWa76mFiueiUwJ
	gC2+FWGsP+MHDxq6TftXcRJyiFGJhIU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3zjX3aQkbAG0djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3zjX3aQkbAG0djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777808847; a=rsa-sha256;
	cv=none;
	b=C4aU839YbDunzey5ih7YhkHT5AP5g51BR86I6/9swZ/NeX/VqA9AzAAwoRIBReFkSzcMRk
	b8kE+xFI3zOfSnq0kvnKauLRlAq/OgPX7tHxdqv7i2WO0GPqPvxMgBudcQyjf0ltHHqkHs
	OPA1ap+h1DSoLZxvhPTx3UQajWLx2kM=
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7dcd7302f00so3236619a34.0
        for <linux-mm@kvack.org>; Sun, 03 May 2026 04:47:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777808846; x=1778413646;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XzAAI/ptUzx8XTD2iRvyBhOM1/obDCx04Mkukv6AGf0=;
        b=qW0vsE9UfxQ+fAZxPVIvoED/iNs5/jRkxKyjvuCXydk1cGSEWr5ynDrUTp4egJmyRa
         NcqnBE+QtkUrn+mVmJJFop1TtJFpYddsb+5x5GI4VcgaIqaSQzkrqjH+YRbhj6KEYWtq
         HWwIopV0MQmjsngB+iuw/TA5wqMQwA4O7P9Nr4/1EChWiT9cFe40LJ9VjjdvKk5XBhkQ
         ygZawETIcRJeEKKlGq16ywC1bSw97NeNyhJynA8zXWt6Z5Q58ufH2mdVNU7KOwkqU8lW
         6+QfEKfo2t6YW21zxWELcbX6Yqu1exsmUS9AKexT7C0mppUPztxLsP2Hz7fL12San2+C
         cJiA==
X-Forwarded-Encrypted: i=1; AFNElJ8yhHg+YtQXVG0EY1tmXy0X1cHFNH64no5qT/hSW1OQRp2/pyuWylykwvK22EqxiZyE5Riu3vO/NA==@kvack.org
X-Gm-Message-State: AOJu0YxtVslJ8y78pvYvvuykx0jnp9FoJgicLdERriv9sKEglJlKx332
	G/a1t6KFXL4BkSIGsas5MFIKcMWW8reDu7pDt8nvAmI292ikBUHhRX1x6MRp7tjKcm7WhhI/CC3
	v0WbcZM754lj0prpe1UZcSICdPkdGPkcr2CuGakB6iguHCgmeW6oVLb//134=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f031:b0:694:9afd:7607 with SMTP id
 006d021491bc7-696979cbe93mr2853690eaf.14.1777808846497; Sun, 03 May 2026
 04:47:26 -0700 (PDT)
Date: Sun, 03 May 2026 04:47:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f735ce.050a0220.312cd3.0031.GAE@google.com>
Subject: [syzbot] [mm?] BUG: sleeping function called from invalid context in
 vma_alloc_folio_noprof (2)
From: syzbot <syzbot+a21650c1666eae7b2aae@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7E37080009
X-Stat-Signature: 9saofzzzub9e9tq7xp5sa7wn5n9na4tx
X-HE-Tag: 1777808847-483370
X-HE-Meta: U2FsdGVkX1+k4I9FvpzWLT/fq+2rNdhOFJkrmASiMinMaoAPoiZ9dAXrZzVsyZfzSvaHftP1uzzEmWxGZjgZ1UCk3T5Vm7MVsUAxOjaUwlz60XPIkYL4ndOHhvlqb28I5qOJpQh/aVU7fyaZGM65RvOAv/GCRjVc5Z7O9jpzDV/83JZWOuS0IKXeIHh0l3JeqTihwHdR2mdqCa6Aao437HM7wADYKgrvGkqpfztT3YHYv1RyrqTEgwholM+IeMNjTXOmxGhQaSGPwbYDIV8aUCplDoRXaNPhUxcHoczRP9hv8HB7+kq/8B4F34rC7fz1IGrwUCiOqD8YzIqbFr8hd8N5W9wAqxzx6LzWKt3tN/pCjcQwVLLsrYob3cv1V2kZIknkhSBvOB0835CInCjFfX9u3TDDXsNOvo3pMJB2zuBwRDtkugfnTijoKMP++vTrGKolrMZ2xcnPEUkoNSPXB3IbLuN07UT254//q3aqNnA3BcR5sIXK77pNQ2vmOAkouultCfBfAKCuoaedLWqoKsu0dg6MdAFjqsmF4yQEJa5EoU+HNyQ9/dk/Qfe1lPgTFlsR58xMFzOpYoSG81B5X1Z2Pc2QGs0PFwivkGJLDhgutWUBZiDdPg184GWWI5f60x3K8oq2a9RmyuhI+mICjsVUVpyv+pP0LM2KnLW76A/KkFSWThAYOx3nsCmN0YwMWgyGeM8HWUjlIquohWN3bkywDjJRdjRGoRopomvagGg24f3JASQ0S6whdpyjRVKC1YE3FItdbHr8UMjyDchMEGRFPwVH44l7cEsfhsrRT2rw1lk01aO6rWTHReC+56flB4LqmtbTc4nMvc/MlibCn9oGjp98hfJEU9b83JB/azmcoYnYMEioiAhCmDZr375ZpDTH4M71BNufJT8XAB0nZH8EaJKD61LwYNYJPR80Asj6THleW/8/+mABXIHPS2lfPL2rF8m7A82yoptD5Xs
 CjumTcHQ
 R5Agbxnn4zcyyEDUIZe55aNlEIJn7BszR/NW841D0RHSGAs8gYKPWamaze2MPIw6tYa98JaOjJGi30kbiCDFBj3obxz8RUuuClKg/tI1PbA8SDHAbwO6efe/fwuOMYgXQpamiH+SESHuF3tXKp3SIrjbiFe+DNIIQuNFUK6VPAXJgSSjKiy6xK4h4+E0CDXOo6mAn+OPQ0PFaZPHL2VAlXOaeX5+UVoAI1lYl0R8vgh5CKBFctisjUAa9II+0ZSVE724qZ5kUVWYz3UEKtmNiu0N6E1k0hFmNCsSYIgITwUDNmcmlxFIjRB83Wo8tZi4xuH7F2wK2Tx3BONiyUQk1mIdHWUrt+q2R2IO6JA6pdTtMo7Chz0pEGmSyBXAYyg8LQWvVoBmw7mNASMZeAUHLb/Sm6Tmx2qPGaEAeyXARzvovgGG3mYdAVZ+JrmUnOv2bS5Ch39dsmMb0aARwI8pxSmPqCehJHs0XB4HOSy3rAjeJoer+sxaOGPPWFzu6Q0CZHHIYOkMe3PbllzMmDU8xQPAGTBP40rkQE0fGqxMn3bAIDC3R1hg19GEsn0i7NqecNg6qTE+XBUYmwdKwnICISXJsZEp8z5/6HiOdEzNPkFHLeqyn4BfsbBS3DTD6IuBW6hIVEEwO1+eB2gx01BIDK+e9uWu4wJ8k/IPCZ5l+BBzfBQrtc2tsHWD+xylj3NYTJnHqin1oP1kOSxGIx5cuvJh/AtIWY/VCJz7zL4/YOKjYxF/eKajE6P4eHI/IuI8kOy/rfez1BfvpfyBccyS4h8wthNUcPe8LuUqhZgF78g0J8nUbPeXbNEbdH10vfwXyMo7zg1yqWa0GESe4JtAa4tr6wbldXxzw2jUULaA3HiHO+0MUU1uW7PdezhuowfiBRZtX3BlyithUAtl79KQr3LJifhl1XkiyuVxEmAkJYaTJCk8OFEcjCkrUK+YhIqvZ/lNB0kyGiV4cSN4qMwJu3lbvO2EL
 f87j2sc4
 8QjuR6r4YfTfsZ0cYYj79BSDlTdkW7bLEUB01u0XJzbe/ETsCokt1HeAY54MXRleWUJER+7c2PmVHMQ9140y8BmhYIIYiUyMeWxQaGIaJ/g5t8jya/3okI6UTbvZOejPh5ejDqWlqqFsQ4q62dbSQfkBxRTvn/+klBQ1jrYfm7lTjUBNk8Jb4Czz9Z2SlLbUdPG4YRspthG2QnZjCa19y5b20fEzVehnTrlprHcS/iN1S5pHLqwprWiNigobpfeGQ26XSZ2glENdxJy33TjPRmU5irtycu23NmMgr9c3frxbvneEJSr6SoNNXtDmaUx1CHbM+McwPKfUhkd4MbUlAHJ7r/gh8rIl0lqfSubY2qpphnlkgjNYd2tJUaKFYFP8enj2vfOgkKlZ5hjq2cNKKnbJOA8RgFxMWQdk6sc+TVCpUOIoreZfmDBtssIhFVkMx2FyaQB/N7Yy/bXm62dOGsXGSeAmB5/X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    dca922e019dd Merge tag 'xsa48x-7.1-tag' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=100242ce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0f0911eedbc130a
dashboard link: https://syzkaller.appspot.com/bug?extid=a21650c1666eae7b2aae
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-dca922e0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1e719cb224ff/vmlinux-dca922e0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/79a541b03a9e/bzImage-dca922e0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a21650c1666eae7b2aae@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5665, name: dhcpcd-run-hook
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by dhcpcd-run-hook/5665:
 #0: ffff8880243d01c8 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310
 #1: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #1: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #1: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x310 mm/pgtable-generic.c:290
CPU: 0 UID: 0 PID: 5665 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 __might_resched.cold+0x1ec/0x232 kernel/sched/core.c:9162
 might_alloc include/linux/sched/mm.h:323 [inline]
 prepare_alloc_pages+0x44a/0x5f0 mm/page_alloc.c:4995
 __alloc_frozen_pages_noprof+0x19a/0x2bc0 mm/page_alloc.c:5215
 alloc_pages_mpol+0x1fb/0x540 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x36/0x260 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xed/0x1d0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:1193 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x1ee1/0x4350 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault+0x1ab6/0x2a00 mm/memory.c:6549
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f5a6f60980e
Code: df e8 d7 c4 ff ff 48 8d 3d 9c 92 05 00 31 c0 e8 e1 ca ff ff 95 75 24 48 8d 05 5e 9c 07 00 44 89 f2 4c 89 e6 48 89 df 48 8b 00 <83> a0 f8 02 00 00 00 e8 de eb ff ff e9 a8 00 00 00 48 85 db 0f 84
RSP: 002b:00007ffc0b5c63f0 EFLAGS: 00010246
RAX: 000055c4ea134910 RBX: 000055c4ea135c60 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000055c4ea138c30 RDI: 000055c4ea135c60
RBP: 0000000000000000 R08: 00007f5a6f5b4b60 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 000055c4ea138c30
R13: 000055c4ea135c60 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

================================================
WARNING: lock held when returning to user space!
syzkaller #0 Tainted: G        W          
------------------------------------------------
dhcpcd-run-hook/5665 is leaving the kernel with locks still held!
1 lock held by dhcpcd-run-hook/5665:
 #0: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x310 mm/pgtable-generic.c:290


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

