Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F310EBFD0F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24116B0089; Mon, 13 Apr 2026 03:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FBAF6B008A; Mon, 13 Apr 2026 03:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938806B0095; Mon, 13 Apr 2026 03:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84EC26B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:38:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 316AAC3A90
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:38:44 +0000 (UTC)
X-FDA: 84652730568.15.EB7E2CA
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id 71CFD100010
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:38:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3gZ3caQkbAIQ067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3gZ3caQkbAIQ067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776065922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=to68LlIkxkw+05Fou43elQ/Y+Uv6KL/gY+hMLBJGpG0=;
	b=L0eksWv0wXVBfCNyJA0ECFZWUsXvZL8vU+gNnZkczISIYUvKRrcHuKzaEgjSUJF0Jdfi5z
	SiQJqueSr3PFRI6MWtxsMdNGn3g46X+6HSnVXxgTN693ZocPE+LlISUr1dE7dM8izN9KiB
	VrzOZoVhu8sbxAFwTIC/cIBzSorGrjU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3gZ3caQkbAIQ067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3gZ3caQkbAIQ067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776065922; a=rsa-sha256;
	cv=none;
	b=CylptFLtiud8w/6tcS0M45IyRuxJ5v2pK6ih57n3j/9vudfyAYKprf4MjoH8UYcAnbMJKU
	sWfGuFPosssZGj7SPd+H/2+uBX8ktfPYdEbOVp3PRqnEe+f0rdyuSvLOd0Ym8ZRNSKG0cn
	iMkAJp88NmEJhntYDqNfy4+0cdp6CA4=
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-68e924f632bso1751026eaf.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776065921; x=1776670721;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=to68LlIkxkw+05Fou43elQ/Y+Uv6KL/gY+hMLBJGpG0=;
        b=UgSO2rkZkO9PEdp5SiA60u/b66ycsBXv85m5Q4DVss5+Yhp5o5SgdbVku7+oN6ta+B
         QAcgdM5ABpONOohHL/jfrJdR4XYa7iLPWKxSvtSJBqXz+jbkCgePBW4SGDGbxKRUPjYU
         9AXuRxjj5TnXHYNaJMa0ytv7nPd7WnIMBtTMX1eUcQVU/9sMeF+j/TIyHUf5SBnc4L/E
         4Q5NhdZUT5fjk7cslbx28xsXFL7SyZ7it1mbawujdQp/HWW2akxVL6Z5fA8BPk56kdAs
         CYnWq5pZoBwiIOuvR/xKGKXOloDpCvjOfj8AvQPt/ABuqMMsPwUHxTU98bQTHA80x7be
         08Bw==
X-Forwarded-Encrypted: i=1; AJvYcCXG/8/+a3esacqcDik+sLdxorcSwMpHGi1fJ7O7tp2QxHMd5GbiV7zPbyT0QT8SVBdlR2lyM28W+A==@kvack.org
X-Gm-Message-State: AOJu0YxzI9+oreNCAKuw+GlLdv4rJFdTCdWpexr2nnxMMnXqQ/FvO0hs
	wXaZDCHw7Y79wLD/Tvk4MpDdEUoI/OiRjsJhLmC1qNvu+ZVnBLt3LeZ0vNaOTL1jC0G8xKRyCuY
	Lrn6zTt467vMQoRSeiXGIMOEApG4iBuDkA5NZZHY43CA6sZetGn73231Ik7U=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c14:b0:689:da1a:3ac5 with SMTP id
 006d021491bc7-68be86e4616mr6161594eaf.42.1776065921546; Mon, 13 Apr 2026
 00:38:41 -0700 (PDT)
Date: Mon, 13 Apr 2026 00:38:41 -0700
In-Reply-To: <20260412174244.133715-1-osalvador@suse.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69dc9d81.050a0220.3030df.0047.GAE@google.com>
Subject: [syzbot ci] Re: Implement a new generic pagewalk API
From: syzbot ci <syzbot+ci8e8b776487075354@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, david@redhat.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, osalvador@suse.de, vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: pmz1bhjgoxedj8rhn1njscighjiphx84
X-Rspamd-Queue-Id: 71CFD100010
X-Rspamd-Server: rspam09
X-HE-Tag: 1776065922-220889
X-HE-Meta: U2FsdGVkX18EtFyvM2r998oJyVZ8u7oIQSUJ6raw3FJyAUOEsw8BeoA3FxlJWE5cj1hY57b37S4WbYzzyOliomLTFF7CAb4EfmpLR9ltSpZQamHrBvjnTH6sCguv9x2q2FBHrPvxIwgZwiTfnETrJv2k63xjEwLkPgVT2+4bU1pjEnV0cnhqQUGHPcSm7PB2IBmHD8eXa1LagHJcSN2cvqI+7vr+iZ6Y/QQd5YCoVssMbuWz8Vmi6nP75PYJA1IwfMacB6irF5kh/s54zoEDwI7RLTO+sU/I9h/o73k1l38EMZ6fRKSOpq3tXPM654zQSSRmMTk4nIqZqqpcaCmVx6QxTq0O5kcnGq8ypY58HxoPU5fBWRj++3DgXpLiqxO0XiVCGJX7cGt6QJNIbcNMZY+DfIxqBZzb2zA0/YppohHJ/CXdHxByNPX1ncqQNubLbIyQZDnh9+IUv2icin1mn/Hg84ytfH5aFggXWNpoE4zN4xnBp0tpQbZJdkfjwGsxp85t7xz7dZbAcfws8SiqupIMlDTg5fZ4ApOLC4jxKumdcb4tVmfmeTEM44L0A269LeHPiuxdmwVPe1TKrLnhqqoOcsg2oqfp11jkVcj7MEJoKFfGYtzRMCVr0cPAbiXCpF9iCqZ/SjVxhciR6UdQbKMpVIBrooP9sZjBrPudYdMtHw8kJqzSlBYfo+kCDkllPkE4jQ0jJKQiwWM620nzOHs1SFIKvO0QPNgT//cUVkrLxksRacOhKy3REaA/zEgBtf4zoO4bxmc2WpFQ6g9qj+f4QXmBnqxHvuMzByk59Hkb7U9HbomX7tYviQZFwAE2an7/3/9oLK34+4k0Bh5fR7pXuxA1qX00l2MVD2l3XArAwldhfHGWRG6SSLlOi1RdK3ArNC4H/ddfN1aFMwGS+5UCcQA/zcqhw24S7xwkXtu4hi6sjl/snwfFcz8ZIo3pEFrAlQ7PXtVRDnGk0yC
 yFlGRshA
 h5GIrRLxGWjqhMip5usdQfCB3oHyjvlkmDzlbT1oxEgE3vL3W3rufGR07L6G4M0mJP3dUEPaxHgqf28eN+sdLbDJIztLg1/ooLOJ6gDyDl4Xz8gKnMqD0n53p/LLqAE+7/1r63y/0qZZVn5MoV/XaECS9Ehu2FrBw/nJqYtoUrNw20/pEytwIO1M2+shPfJfmPj8objn4ftDfPFJk2NsSoAlW/B0+bCeJek3zL0rhcPt+sCew76e8xR3ehqLAI7hwKFuexc5gScJ7YTSF1cVyuYIxK7v+Q1iXJh3jkqbntCX2TrDu2rb2hTFaGdmnZY7golTBLnnN2vWwjpFrAhMtbICzCtaYY+EDsFyJ5sKeQb+Nu1ELssndF+X0U3//SQUEwxv8oW8peyscJZ0xcObfvkyVFAIH+WpmrNn/uly/hO9FchBHPbRBTsfy63GRIyIbEqZ6zrKKdfSBrdR9+dRX/8VJ36bKjA1igY9jBFZW+HD3tVydbeOmFBmygp14DbbhcnqBkqHqFqvoqFcXE2druPdcXAKsSHMmYCMBUAHZhwG9m2W8rkmHSFtlEQUXvWbN6Eq5UzQ2gXpwScNo17Jmjc2pT9hx+KnpQbGE5hngPhtt4gKBSG03utkgafSB0+Vx2erkzZHo/XmHJ515/sSQ8xwMMRH/7SnoROnt8pZ60MsZ0bZtfZYob6UO8Suz6VcXsr5VlC3Fp0AetY8B7sDAwwTJ7vep8yfBq7pT6jLOt2BV7ILsLO8a+IlOr3ZN9Px+9l9yvBCqQoYIBpER9JCWB3QL9lBlzv3wn6ZFL/9m+5k6Tb9EhBpG17S51Me9oXKrSQIsq6kxqvPiGeJgywKXfRtzy0yPDOMRa25x5gXbZx/cn5yNkajUkH8185FOUWbPvI361CxMWdhRJy7MS3Q+tp0C4lljZ5qBKEKKtkf2q3Z5jLVyDz9V0UZ5IBViIpJhL8VvpWGW39dxc0GC7mnbLAdU67ru
 O5wTfHTX
 1F1IJ9Uw0X8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] Implement a new generic pagewalk API
https://lore.kernel.org/all/20260412174244.133715-1-osalvador@suse.de
* [RFC PATCH 1/7] mm: Add softleaf_from_pud
* [RFC PATCH 2/7] mm: Add {pmd,pud}_huge_lock helper
* [RFC PATCH 3/7] mm: Implement folio_pmd_batch
* [RFC PATCH 4/7] mm: Implement pt_range_walk
* [RFC PATCH 5/7] mm: Make /proc/pid/smaps use the new generic pagewalk API
* [RFC PATCH 6/7] mm: Make /proc/pid/numa_maps use the new generic pagewalk API
* [RFC PATCH 7/7] mm: Make /proc/pid/pagemap use the new generic pagewalk API

and found the following issues:
* KASAN: slab-out-of-bounds Write in pagemap_read
* WARNING in pt_range_walk

Full report is available here:
https://ci.syzbot.org/series/1f85248a-1ac0-48e8-8ce3-edb89a6b9ee5

***

KASAN: slab-out-of-bounds Write in pagemap_read

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      857fa8f2a5b184c206c703a3d9ce05cea683cfed
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/932ed80d-9fb1-4c99-8096-4b7a9324bb7c/config
syz repro: https://ci.syzbot.org/findings/1083a63d-0470-4ce7-8943-0a60046b9269/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in add_to_pagemap fs/proc/task_mmu.c:1740 [inline]
BUG: KASAN: slab-out-of-bounds in pagemap_read_walk_range fs/proc/task_mmu.c:2736 [inline]
BUG: KASAN: slab-out-of-bounds in pagemap_read+0x19bc/0x21a0 fs/proc/task_mmu.c:2829
Write of size 8 at addr ffff88816d32b000 by task syz.0.17/5958

CPU: 0 UID: 0 PID: 5958 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 add_to_pagemap fs/proc/task_mmu.c:1740 [inline]
 pagemap_read_walk_range fs/proc/task_mmu.c:2736 [inline]
 pagemap_read+0x19bc/0x21a0 fs/proc/task_mmu.c:2829
 vfs_read+0x20c/0xa70 fs/read_write.c:572
 ksys_pread64 fs/read_write.c:765 [inline]
 __do_sys_pread64 fs/read_write.c:773 [inline]
 __se_sys_pread64 fs/read_write.c:770 [inline]
 __x64_sys_pread64+0x199/0x230 fs/read_write.c:770
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd47239c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd473284028 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
RAX: ffffffffffffffda RBX: 00007fd472615fa0 RCX: 00007fd47239c819
RDX: 0000000000019000 RSI: 0000200000000200 RDI: 0000000000000003
RBP: 00007fd472432c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000001000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd472616038 R14: 00007fd472615fa0 R15: 00007ffe3c81aa88
 </TASK>

Allocated by task 5958:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5339
 kmalloc_noprof include/linux/slab.h:962 [inline]
 kmalloc_array_noprof include/linux/slab.h:1109 [inline]
 pagemap_read+0x287/0x21a0 fs/proc/task_mmu.c:2781
 vfs_read+0x20c/0xa70 fs/read_write.c:572
 ksys_pread64 fs/read_write.c:765 [inline]
 __do_sys_pread64 fs/read_write.c:773 [inline]
 __se_sys_pread64 fs/read_write.c:770 [inline]
 __x64_sys_pread64+0x199/0x230 fs/read_write.c:770
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88816d32a000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 0 bytes to the right of
 allocated 4096-byte region [ffff88816d32a000, ffff88816d32b000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16d328
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x57ff00000000040(head|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000040 ffff888100042140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 057ff00000000040 ffff888100042140 dead000000000100 dead000000000122
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 057ff00000000003 ffffea0005b4ca01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 20801987900, free_ts 13278585415
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3255 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3444
 new_slab mm/slub.c:3502 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7134
 refill_sheaf mm/slub.c:2804 [inline]
 __pcs_replace_empty_main+0x2b9/0x620 mm/slub.c:4578
 alloc_from_pcs mm/slub.c:4681 [inline]
 slab_alloc_node mm/slub.c:4815 [inline]
 __kmalloc_cache_noprof+0x392/0x660 mm/slub.c:5334
 kmalloc_noprof include/linux/slab.h:962 [inline]
 kzalloc_noprof include/linux/slab.h:1200 [inline]
 kobject_uevent_env+0x28c/0x9e0 lib/kobject_uevent.c:540
 driver_register+0x2d4/0x320 drivers/base/driver.c:257
 usb_register_driver+0x1e4/0x390 drivers/usb/core/driver.c:1078
 hid_init+0x39/0x70 drivers/hid/usbhid/hid-core.c:1710
 do_one_initcall+0x250/0x8d0 init/main.c:1382
 do_initcall_level+0x104/0x190 init/main.c:1444
 do_initcalls+0x59/0xa0 init/main.c:1460
 kernel_init_freeable+0x2a6/0x3e0 init/main.c:1692
 kernel_init+0x1d/0x1d0 init/main.c:1582
page last free pid 10 tgid 10 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 vfree+0x25a/0x400 mm/vmalloc.c:3479
 delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3398
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:467
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88816d32af00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88816d32af80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88816d32b000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff88816d32b080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88816d32b100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


***

WARNING in pt_range_walk

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      857fa8f2a5b184c206c703a3d9ce05cea683cfed
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/932ed80d-9fb1-4c99-8096-4b7a9324bb7c/config
syz repro: https://ci.syzbot.org/findings/e7c203a3-133f-4435-b9ed-ee292b6685fe/syz_repro

------------[ cut here ]------------
next_addr < vma->vm_start || next_addr >= vma->vm_end
WARNING: mm/pagewalk.c:1052 at pt_range_walk+0x145/0x35f0 mm/pagewalk.c:1052, CPU#1: syz.1.18/6005
Modules linked in:
CPU: 1 UID: 0 PID: 6005 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:pt_range_walk+0x145/0x35f0 mm/pagewalk.c:1052
Code: df e8 9f 1a 15 00 49 89 dc 48 8b 1b 4c 89 ff 48 89 de e8 7e a5 aa ff 49 39 df 4c 89 b4 24 38 01 00 00 73 14 e8 0c a3 aa ff 90 <0f> 0b 90 41 be 01 00 00 00 e9 e5 21 00 00 49 8d 5c 24 08 48 89 d8
RSP: 0018:ffffc90003a279a0 EFLAGS: 00010293
RAX: ffffffff821b140c RBX: 0000200001000000 RCX: ffff8881027a5700
RDX: 0000000000000000 RSI: 0000200001000000 RDI: 0000200001000000
RBP: ffffc90003a27bb0 R08: 00000000000000ff R09: 0000000000000003
R10: 0000000000000002 R11: 0000000000000000 R12: ffff888105317380
R13: dffffc0000000000 R14: 1ffff92000744f60 R15: 0000200001000000
FS:  00007f0ccbd736c0(0000) GS:ffff8882a9467000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0ccb04edd5 CR3: 0000000115dba000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 pagemap_scan_walk fs/proc/task_mmu.c:2479 [inline]
 do_pagemap_scan fs/proc/task_mmu.c:2573 [inline]
 do_pagemap_cmd+0xfd5/0x2600 fs/proc/task_mmu.c:2869
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0ccaf9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0ccbd73028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f0ccb215fa0 RCX: 00007f0ccaf9c819
RDX: 0000200000000100 RSI: 00000000c0606610 RDI: 0000000000000003
RBP: 00007f0ccb032c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0ccb216038 R14: 00007f0ccb215fa0 R15: 00007ffd9c7ebb48
 </TASK>


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

