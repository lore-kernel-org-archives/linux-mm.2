Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E0DCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 20:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4F96B00EE; Tue,  9 Jun 2026 16:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC6D6B00F1; Tue,  9 Jun 2026 16:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9BE6B00F2; Tue,  9 Jun 2026 16:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF486B00EE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:37:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 314D6407B6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:37:31 +0000 (UTC)
X-FDA: 84861534702.04.53295B3
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf20.hostedemail.com (Postfix) with ESMTP id 785C81C000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:37:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3iHkoagkbAHUlrsdTeeXkTiibW.ZhhZeXnlXkVhgmXgm.Vhf@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3iHkoagkbAHUlrsdTeeXkTiibW.ZhhZeXnlXkVhgmXgm.Vhf@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781037449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=5w4r/SmKLyV+1NqD1bLWjTjqfFpIbX6njjJ6Sw/ijS0=;
	b=eD8ZYJq47kGk39nYIMFjjtzNoQ+uVSYOwrPaN+it4BAg0HVsICAiVS/BS5Bvh/74Yb1WJr
	l5Ah9IKHFuqZ9AADiD8D6iN5l31aCrpWSA2yAdGraw+s4aPvYs9zGEKJl5ZTUeKDu7JSog
	mSkFqOmCoC/MNY2BHNtswUW5MFOCC2s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3iHkoagkbAHUlrsdTeeXkTiibW.ZhhZeXnlXkVhgmXgm.Vhf@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3iHkoagkbAHUlrsdTeeXkTiibW.ZhhZeXnlXkVhgmXgm.Vhf@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781037449;
	b=tuOrEaI1BR9hgkUdp3Fah7HNWWjR3AGbo6l3DD6qO1m75d9ryaUWW0uKIo3qeNAeiNnhgF
	TLNiw7HcoLLgOKIKdTUshDrh7X9+LUY4Bx/HyS6AXgVte77sEqw351xLbqFHW62Rsu6itt
	zQhkOzqZx04jbGympYVPCwJdHqS40ms=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-69ea6309883so2375936eaf.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 13:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781037448; x=1781642248;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5w4r/SmKLyV+1NqD1bLWjTjqfFpIbX6njjJ6Sw/ijS0=;
        b=XHWfs010UuD0hBEmjSWN4nfTuf8tEHhfxf031uICouREsNrXgOycJ4bQWS9xz1h7s3
         CdGQ2r1gCcaz7RamEi63mpIfe0Rol/+WGQT6TBcxXh7TIaUjdQOylY8a60CZCyfrOPyC
         HgU1RxQTykB9auPx46Jf6L8oXvCvbVi0pFJwFE+kKtk3AG+DjN0z7y1GF+2mwVlqpgUY
         G1QHIuOv9Zsr5uco3Mx2qoM0jiCldgXqAZ/0/szELBcfvlHXcGQvZGQueY+FkTXaUS7q
         kI9EzBzgCWfNI6iKuaqsBIFc7pzxOw5jNI96fiyge21ZwxjXdblWjhQNcdfmBjCoYrPR
         L2Qg==
X-Forwarded-Encrypted: i=1; AFNElJ8DQon6Qpg3G0TGzOiNVJQXKSkDhFv8dxIuH9SL+uC3tRQb6XUv+Vfc/RZkdV37T8uSa1kb0tukgA==@kvack.org
X-Gm-Message-State: AOJu0YyKAzorCkbUCA1wyNQ8QRQzciGO6oLuQINUIhGZRKEEb5jcc7GX
	NaaHIPuuVgEnnV1s5aCxAzlh61JoVkyWfO9vMO4o+1PjWOMev4jRTLJSEolDstVrEtwph1Iqy0i
	7c6F/iZuh3tnRTYLgAzraYXPlyK3AtA8JLqioO/kOBG1uOOUgs56qG47HmKc=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1687:b0:69d:281c:27aa with SMTP id
 006d021491bc7-69e68c27774mr11845499eaf.29.1781037448515; Tue, 09 Jun 2026
 13:37:28 -0700 (PDT)
Date: Tue, 09 Jun 2026 13:37:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a287988.39669fcc.33b062.00a0.GAE@google.com>
Subject: [syzbot] [mm?] KASAN: use-after-free Read in ptdump_pte_entry (2)
From: syzbot <syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 785C81C000D
X-Stat-Signature: qpu5dasyrbko671iq6epjm8cdc8cop49
X-Rspam-User: 
X-HE-Tag: 1781037449-883428
X-HE-Meta: U2FsdGVkX18vA907um4jnIF5cWawmXct2bZBRhK4P2yfyFRz6XPI9Uq/7GPw7zOnJduTYx8Q+MhU+YmvCoWE7u+PullLgE0wyGCQ/GaKeQtYESeL0WF1iZYiTnMk50PFqsF9x2cPi2pu+QXPg1lRV+OkyT/kMcGAn0Jx9dNeQdahilJZrDZK7SbAkeoskk8FGB7l2TZ+7mvta+v9YwJD/tGyxP0igOyF7djRgNmIAuVaTYOXYO2PmgxR46vr9baaAkxkvy5E6KaxMgsEPxPCS+J/V7RYznBdLQia9QxsOFGC9jckS/K2GNaLp1Q3inFPBaMrdnItFaJZasyfJuzNlFv49tTHXCPgtX3TEHrtj6FFZPws21QmQcQ/8VvsQsrYLmYc+t5MEsYjH7HJaVozIhvIxZzeL7TUK0pinCtxuacIN4cGO2VoD54Ok9E+E823Bk9cgDWjBuLUnPoM1tYLRuKpOi6HBUhpj0FgGPx4CZ6qpbexgN6nJvelowhVwerBmqYJGMmRLKk/UDHdqxcUBLU0Ly6bqTGCltKN/nVUhz3u29gh6MF5gtUINvAThzpTa2ru9OJfAV4tGP17qdjnM6Gzd78hJdyu1uJTGBi2w1BrrAN8dzgoRM7n+RCht0UB0TfwIhtQdp871tibJ5bMOAk/kT7voS4U5YacYEDJ8HvLhfL7VbHRt2VQT6e6QFP9F5OgJDtCBizdgJ9DrvAEv4TIN1al9xyl0p6aReF8uKbMQL0VX+G0WhBHPlp4dkh4GuXbQzPDot6gNNi3iIxuOvnQ04dv1ZxyZgdyGC2EimVPnRh5HxnZcxyX8cNMOXYNKENnZBsfnaPRjHweci1ok34FMyfioD/qtFNeYqr/aJe4egXldkA+Cao/0gPTYxxkvl7vlp29aelN6KTUPM0ln689ji7i1dW0BZ0+6w0amSy4HrNyyQ7bZhdSJKrguqoDD6ygU6aPir9z2/t9SNm
 fczhmOCu
 yTWiGctRfcTORoCvGErFeiJL11tYwlDgDHQNe89zPlquqNuoMokkn0cINGpT3To3kg61kJ7+w+1xH1UtcMyurd4FS4kyiYZ2CX2tJDDaiAaMxumWMNAnd+AaU4HWZKBcmjzZiT8MpYtaNaq7wHTS/0ZXpdelTkzRYSR5MMnzAcNc/yrUghzUfJpnJYocBDT87IyTc1EOc94kgSSxbNZD7xrs9dtU2IkalSQXOctKPjY/OUOYo4/dh9zhu1fJh1xmwpkbYHrL2e31z12do2X0dLolJIiw7yMKILUOfxl44Qp9f7HA+k5MNgJjIgrQVSsw9SFdWkGs+fJbky50/mOnNvCWqlBFC2FH2O9/d1OhLiHUhC6GzDoHz0avL/zYLTfttc90WVZy9bpVVKYwhTsCAHjJ3YUBzzGhNAIz6p9NnOnK6cHEmALvdm5qtN4iAxvT+JvcbD/cefy8xm5kmk0Ie8EhQ7cd+HRGa3O3AcLbbNdzamgYQP8ZAVTY4dot5g2fu/HigLSBOznLo1YgrkcrfNkn3ve4pBskGmTJ5bAzsL4x175RRnPW53SkBTRgB0WdtU3knTIN/2SL1BtdLw0x5SdFW5t+FAMP/qz1GFQZgBFQTYo/CtLSrljAFgaEFytY7Ez1WAbTSrg/BBmLrXnpqDC0M76utNBKMOTnDTv9XeCiS5T8GxtLh5atvHILunbR6pZjmSp4q6n/SzPu8iVXbWYKjOJ61QzFAOrXi4qKToQ7pD+rBxxWJUONIKydnMmsOJ4XNimztmNyJEj05hAIWll6C7mlYDlci/WuQxvi1IxeIAhLbJy838eREZm61TFpcNhHvuRIKkuXSXx7UHyxH3C3C91ZJNI0NTDgj8420F6G7C22lcjJRzDTg9mWHvo6aFovoDLjidXsH/p4K3yoIp26rWjD5A9Cy0C8RJnpbqCxjL2KQYxZhPNiBxNvK0TrVcrYwCY3ZD4fy/T+mC78FfnlOd2nK
 pVLr+fMo
 wrMaH7IEavG4lwODNUIMn+13hJhpVzidXQsuigI0mx3OMc+451THfQJuROM7/fQKSkNAKJphyBfPilVLjFv5UbTHVcbz0q5Pr6figHelGOI/xt3zsjOV/1TuQiU8pcARb3o49oy13CZGjgrVgtgX5oceS2XZymJbibkhI4xWok0DADVV2oUgZg8kXG4VVrFMsK1viHeYMsuD0cMTaht3GXIpzp8Tf/X+hQ3xZ8LZUSBUFIcebCKW+utffvExkQBWqMGzTtSeg67B5G6jGALMkIHYv+05PfEE3PDL4eZ1BxcYjtwdmQr3m3650rKQg7enKdRps4iS2uTYuuu7OdiTvz27Idah0wxq17z/TV9486hFxIlgClx6I22MuR2BSbAcpNIwnJrOatxPvQVjDWtIYSfOYxB0UdksSRretP7uL4xU2RI1cltM5iH3D0HKe3d5wbGfRX7qOdiMCr5AnWdpIjLl4zrGl0dA4HcVG9gfWB6zQ/1ZF/XKF/s8SiQAIpMK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    ba3e43a9e601 Merge tag 'soc-fixes-7.1-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=106d9e0e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e4d2284f2ffa41
dashboard link: https://syzkaller.appspot.com/bug?extid=fd95a72470f5a44e464c
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2b5eb2255685/disk-ba3e43a9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4a9a553d87d9/vmlinux-ba3e43a9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/07d7b83d93f7/bzImage-ba3e43a9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in ptep_get include/linux/pgtable.h:461 [inline]
BUG: KASAN: use-after-free in ptdump_pte_entry+0xec/0x100 mm/ptdump.c:124
Read of size 8 at addr ffff88806640f530 by task syz.1.2229/17788

CPU: 0 UID: 0 PID: 17788 Comm: syz.1.2229 Tainted: G     U       L      syzkaller #0 PREEMPT(full) 
Tainted: [U]=USER, [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1d0 mm/kasan/report.c:595
 ptep_get include/linux/pgtable.h:461 [inline]
 ptdump_pte_entry+0xec/0x100 mm/ptdump.c:124
 walk_pte_range_inner+0x258/0x370 mm/pagewalk.c:49
 walk_pte_range mm/pagewalk.c:80 [inline]
 walk_pmd_range mm/pagewalk.c:173 [inline]
 walk_pud_range mm/pagewalk.c:239 [inline]
 walk_p4d_range mm/pagewalk.c:280 [inline]
 walk_pgd_range+0xee1/0x1dd0 mm/pagewalk.c:321
 walk_kernel_page_table_range_lockless mm/pagewalk.c:664 [inline]
 walk_kernel_page_table_range mm/pagewalk.c:638 [inline]
 walk_page_range_debug+0x2fd/0x370 mm/pagewalk.c:696
 ptdump_walk_pgd+0x129/0x330 mm/ptdump.c:182
 ptdump_walk_pgd_level_core+0x26c/0x300 arch/x86/mm/dump_pagetables.c:458
 ptdump_show+0x1e/0x30 arch/x86/mm/debug_pagetables.c:10
 seq_read_iter+0x32f/0x1270 fs/seq_file.c:231
 seq_read+0x33b/0x4c0 fs/seq_file.c:163
 full_proxy_read+0x135/0x1a0 fs/debugfs/file.c:378
 vfs_read+0x1e4/0xb30 fs/read_write.c:572
 ksys_read+0x12a/0x250 fs/read_write.c:717
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x840 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9f8859ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9f89458028 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007f9f88815fa0 RCX: 00007f9f8859ce59
RDX: 000000000000001c RSI: 0000200000004c40 RDI: 0000000000000003
RBP: 00007f9f88632d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9f88816038 R14: 00007f9f88815fa0 R15: 00007fff37ecdda8
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x6640f
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 ffffea00019900c8 ffffea00019902c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x40dc0(GFP_KERNEL|__GFP_ZERO|__GFP_COMP), pid 5628, tgid 5628 (syz-executor), ts 76048833593, free_ts 678067566484
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x11a6/0x3410 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x27c/0x2bc0 mm/page_alloc.c:5221
 alloc_pages_mpol+0x1fb/0x540 mm/mempolicy.c:2490
 alloc_pages_noprof+0x1a/0x160 mm/mempolicy.c:2581
 pagetable_alloc_noprof include/linux/mm.h:3651 [inline]
 __pte_alloc_one_kernel_noprof include/asm-generic/pgalloc.h:21 [inline]
 pte_alloc_one_kernel_noprof include/asm-generic/pgalloc.h:45 [inline]
 __pte_alloc_kernel+0x22/0x5c0 mm/memory.c:465
 vmap_pages_pte_range mm/vmalloc.c:537 [inline]
 vmap_pages_pmd_range mm/vmalloc.c:581 [inline]
 vmap_pages_pud_range mm/vmalloc.c:599 [inline]
 vmap_pages_p4d_range mm/vmalloc.c:617 [inline]
 vmap_small_pages_range_noflush+0x9d8/0xd50 mm/vmalloc.c:639
 __vmap_pages_range_noflush+0x601/0x660 mm/vmalloc.c:668
 vmap_pages_range_noflush mm/vmalloc.c:694 [inline]
 __vmap_pages_range mm/vmalloc.c:703 [inline]
 __vmalloc_area_node mm/vmalloc.c:3910 [inline]
 __vmalloc_node_range_noprof+0x9ed/0x1630 mm/vmalloc.c:4064
 vmalloc_user_noprof+0x9e/0xe0 mm/vmalloc.c:4218
 kcov_ioctl+0x4c/0x720 kernel/kcov.c:726
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x840 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 809 tgid 809 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 __free_frozen_pages+0x794/0x10a0 mm/page_alloc.c:2938
 __pagetable_free include/linux/mm.h:3661 [inline]
 kernel_pgtable_work_func+0x21a/0x2f0 mm/pgtable-generic.c:438
 process_one_work+0xa0e/0x1980 kernel/workqueue.c:3314
 process_scheduled_works kernel/workqueue.c:3397 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3478
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88806640f400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88806640f480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88806640f500: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                     ^
 ffff88806640f580: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88806640f600: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


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

