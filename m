Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17E46CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 03:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E528E0014; Mon, 22 Sep 2025 23:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1238E0001; Mon, 22 Sep 2025 23:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588158E0014; Mon, 22 Sep 2025 23:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4B78E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:55:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2D35C084B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:55:29 +0000 (UTC)
X-FDA: 83919150378.03.555E55F
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2FC46C0004
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:55:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 3LxrSaAkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3LxrSaAkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758599728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=f6QQWM5fRoiia+oLFHfMduX9EUKHNI+cY56i35VXsOQ=;
	b=rGABU+kIEnKgd/6KeplosrhioCAX0DADKONi14FPkJmCmKJkqX5ocYFmO/2KfejwUnWbOH
	i4HVbkL3E+W3Sb2TzRnl3vYc2WTN1AZpGr5ont3Z50XNa0WvZ9Iy0uceesJEOUdlHEZZD/
	66lm8LFu+LCK7muOMLUYb0ZWkrDmrpM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758599728; a=rsa-sha256;
	cv=none;
	b=mO3pEXr/5m2P3kMYFIrDurvALMjwEkLUW95+AGt9/zwPRqRNg9TeB7vU+IdEQbrRlLj5Y6
	5AM+esfpsNwPnxGfPYD0eccGQZhUbt7OExjSRaEsjX3fQyMo/kwopR8PrksE1+P5r51uIn
	2g1bfy1w5im4GaDr7XKsslNjLqvwf2g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 3LxrSaAkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3LxrSaAkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-4248b62c05dso39083195ab.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 20:55:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758599727; x=1759204527;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f6QQWM5fRoiia+oLFHfMduX9EUKHNI+cY56i35VXsOQ=;
        b=r7efVdHCCnbMo1y4nABmracNT6wNpgCa/absjMJdC6zjh3uoMmqBHm5cH7WqujeeJy
         9qbWxQTeVBsqEndEPNOroLq386nX5rSnEVKjmGi4u/0gDEHrKD4Wbh82aDLkg/LHmZHp
         rqbt4s4xv3RQkXGcFVVumTa9BFuo17u7psHKLesjOEJMiG3dVVJmKeswTnLYwOss3Kdv
         YeJl7PGzkQ37ecyFF8ZU9qNiyhwd5qyJG6X0lbP63Do+dIyYJLUb53ifUB4aTeQjUCKT
         Sv7wn0Hq1/0lt8qndG+zodluV69QKKzztu2poOmWJ5k7jy9lc+DZvlTKEg2RpgsRIGqV
         +Omw==
X-Forwarded-Encrypted: i=1; AJvYcCWVGhaqE9514JIhUpCOJISpevn9taV+Optyi0Tlwv5xt+O/xgTqYaFjpaOEupEGv6vcmjicYbE+Qw==@kvack.org
X-Gm-Message-State: AOJu0YzjPw6ry7KXoyxiV1OBXxSBFNMbw5qS9k++UriC6kgnL+hfnO/3
	nAeOLsYcHUgnM8JbINMKClnIdzskjcnXuOGfGaqw4Kotf/azqglfXZnbsl9OYaO3JPVDya8QfVi
	UlwBxCxgCkkaZviEQ+1SKQCkY8K3jiPmUzHhZwNgc/Lu76zbWL7s+dA/UTvM=
X-Google-Smtp-Source: AGHT+IF4DRqeQJmbuvS+SCCT1xYCrTL/XC7rwP+aFvBxomAU5mm+qMXcTSz7OlGdD0WPekjui9sS/Fsd4L5gESkRFKgNvTw04dU8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b48:b0:425:70ad:799e with SMTP id
 e9e14a558f8ab-42582315dcemr20343595ab.10.1758599727224; Mon, 22 Sep 2025
 20:55:27 -0700 (PDT)
Date: Mon, 22 Sep 2025 20:55:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d21a2f.a70a0220.1b52b.0044.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in __bch2_writepage
From: syzbot <syzbot+682a660800143ff55ffe@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: i7m1tn5sxkmuzgwk17ck45yjqobhk9qg
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FC46C0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758599727-961199
X-HE-Meta: U2FsdGVkX1/JiOxyriG4WpwRZvLe3RuxoC5LQYHO7vdL4pg9rfX0kPGcNrdGtLPm5YNrc+948UCIf22u0TM14P+74qlxJL99cfONj9LEJM8auiUfsBCeWp5jnZfn628SPJn52fH4Sl+c2/ZijGy/3EVA0ylTX0Tm11e2xSK/8fEjlmXG9d+PTP9s7bJYUImPKew+0c/qPJanGc3mhl6IDfGgPe/c45vG0RAgMU/tT9S7H6VERKtPL0xNxn+En3dDdrwBtLWuyCbzQgxOzXioXO1svzZr9yAdzNBhqB8QEJ/mBV+aPHwX2AbA0HneXZad1EQBU+XTParYKJxjPwy70TGcBKiVNL4bbvy8kvbx2AI1JwCvHoVjH5n2mMdiB7HmsSrimVRTabLVYl9/v3HGgqlLjShxx/0MgrBLLGC+/0HQwJ/qIzjAezAFNMw2Sg4kQqpB2Eho/jcxdjNIegN4+4BBcnvawyRnDuQrgCYaVXiEAtzseEJxirKgAbbXTBXXrOEI+xxD2O91AFGJ+gSBxyp31/aSugwiifWeXi/T6Z00Mh8LDj7NX1DW7Scs52ZGk0BiCeYSD/I/f8e7H4IVQ98MSiAtIInWUhg5lEkuBQlGxn3VN+vdHNBPuWnMpQ/7dp0MNW2ebrmA67zLKAbpvOjie3NloCHoBcZxYebVVtpyMabvUaFZ17Syakr2bUxoq5SdD7jnR7U0P84oI5KTLQtbP4m6r9L4N2yXxTnpdX6VF8xDt9UrgPUxG3eWFk0Y3+n+8LVhNi3pXvGyhAqXM4/XDzLzx/pDcaPOpCwXpUL07FQgzixnW7kmJPUyxYqLssfUsy3rh8lK0sU2AC5CPHUmV/EsWmhLomgxBCsf7xMbbyGl86uF0QcJ3OeQ8k67blUn/ZZY6/5shEOPNfVj057Ii7IYjhgrPDyZ7/K9yvRlT3mh+ALUFcFRJAq0YdwiZWreONRTdrtimiW2skC
 s3WkfRtW
 3UbVbIpN1UFwllvdvAQphUvwoxONv2a9TjS9749Ggj/GCql30gIuAcQtwW9YOeDwF7A17g6Ytu5jsvcEUWnLuARdlaIF17cmjSQYqLj5vnAsbkOlBOScmcF5hih+Nvh1CH2fyWH5YBmQ6s3BJ+lsgTaKmtj7akgbkYRw2Go+F91tzMMINT2V1WzP8dnXhQw2JVqhaCDd2YbeptQXopBGrKGO5E9dcS2B8U7uJDPp3oCPFZG8M3tyEToMnowl7vIqKmQzq94Z9Mt1JcB4FECaT5SEOlXQs1xHI9bTrwDD12lo80a9e2Fg1sQKJ3VNsCqMwUBbCWofTNLN4llQALvEYmwAX4D/L19znhZTdlvOOawm+HZIN3Fj80vOsUSTcrjoWA22S2Z6Edd9dzyAZ7baSru4wOV1hRJ9l9gv0iW2czNI5V0D1B5QuReTo9kwNb0XCMm5nZg+cXWJrzWQ7ni1pE9W/wkhXMKrMcFyhkY7oHdODjbu1eKTMEn0poNutvulz885ehNo1yM9nA13tTyixIQIaM/Z5GYbtsSUaY5NFVJul4DshdvKMFyEgpYHFF2J7YqirXPBtZFAmeTBL1s7//YDQavcjlbNwj9Vi5AUFPi19fq4IfeD1JzuqZPsfpvxZcbSdJCw6LVq+hEKth4RDrpzgQbDOPUUx9FbG+xCHgZdS+HCQdoAOYrjVT39Ol2jPvySZ0kD2vXDG8/krb1PBTw370kWXYkbGYRaBBh9jXX/sgVbOJtmFmFsKzt6OTBuXES59/VLmiWqzsScd5kTFEPMgNAENOSNnARt6HeFiyVFmNouhSGKthYb924as1rrDLLcGYEjwoSKqmuUEXOs4fXYPy7spF6SU6C0FE0ECw8UenW0xDmcySGd0GTQdTMFVcQHFpdQXuQ80TtLub2uRNxevodN6O0wougO0rxCWEeEVMTbYOEe5RPGVYdMX9GKOpNiAeaedb0MED3459961rD1l22o2
 mjBxAZJm
 zgfZ2fxeu+r/LYdfef12vtgl12tZNp0DDmtABpHX0zkzjW/6uLZBKfgqAkD9JxH2h9SR7dvGxbuR8I8wnZDjao5D1NVMNWqR8ur8CcmNmohVRy6W4BCweeowdSMoCUe7XaZJeTerZrcJufKxVv+uc2UhYTqjTeH8JF9F8g36YJIgFLuAPYpNC21M2TDUKUp/tkEqzf/TWZQgpwxz3mRUf6D9mZFHIlOEeDOw75dxOJW8I3Rsb2BnPypIkAulFs1z4wEWr2Yc4aq0FtPF++8pssQlCsMhHZNBvvwNa0SN5TX/Glv9tOXx/AOj28b6Lo4n7gTqfquo4oMx5pQBf2j6HZDNQLJlsIOieEFMD94pAf2SvX5EududZSoaw+oXEsyprTqtYlrQUa8XstkMAzuLOVCyQTFrSjolfKTie+SYnVmoGnrqz2ZAippHv9s0MnKZSxkhMhG03LZb02MSRV7EaFGBvGCiX6A5zXaXCyLW12kJTvTtH+t9dfApM8keqfoMZ8uayMk48DTRwbIuMA3F24s2WRjAIi58d0tKJQo+mXnOAlh2iMWZ80ANUdTZwBqQyb+WMzqA6TI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    cbf658dd0941 Merge tag 'net-6.17-rc7' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1702c712580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf99f2510ef92ba5
dashboard link: https://syzkaller.appspot.com/bug?extid=682a660800143ff55ffe
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-cbf658dd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a976546d6ce4/vmlinux-cbf658dd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/13baef55a10d/bzImage-cbf658dd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+682a660800143ff55ffe@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=errors=continue,metadata_checksum=none,data_checksum=none,compression=lz4,nocow
  allowing incompatible features above 0.0: (unknown version)
  features: lz4,new_siphash,inline_data,new_extent_overwrite,btree_ptr_v2,new_varint,journal_no_flush,alloc_v2,extents_across_btree_nodes
bcachefs (loop0): Using encoding defined by superblock: utf8-12.1.0
bcachefs (loop0): initializing new filesystem
bcachefs (loop0): going read-write
bcachefs (loop0): marking superblocks
bcachefs (loop0): initializing freespace
bcachefs (loop0): done initializing freespace
bcachefs (loop0): reading snapshots table
bcachefs (loop0): reading snapshots done
bcachefs (loop0):  loop0: Superblock write was silently dropped! (seq 0 expected 42)
bcachefs (loop0): done starting filesystem
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5357 at mm/page_alloc.c:4619 __alloc_pages_slowpath+0xcb3/0xce0 mm/page_alloc.c:4619
Modules linked in:
CPU: 0 UID: 0 PID: 5357 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__alloc_pages_slowpath+0xcb3/0xce0 mm/page_alloc.c:4619
Code: d8 48 c1 e8 03 0f b6 04 08 84 c0 75 2e f6 43 01 08 48 8b 14 24 0f 84 a2 f3 ff ff 90 0f 0b 90 e9 99 f3 ff ff e8 be 7b 64 09 90 <0f> 0b 90 f7 c5 00 04 00 00 75 bc 90 0f 0b 90 eb b6 89 d9 80 e1 07
RSP: 0018:ffffc9000d396e50 EFLAGS: 00010246
RAX: dff18e3eab6b8600 RBX: 0000000000000002 RCX: dffffc0000000000
RDX: ffffc9000d396f60 RSI: 0000000000000002 RDI: 0000000000048c40
RBP: 0000000000048c40 R08: ffff88801b6f303f R09: 1ffff110036de607
R10: dffffc0000000000 R11: ffffed10036de608 R12: ffffc9000d396f60
R13: 1ffff92001a72de8 R14: 0000000000048c40 R15: dffffc0000000000
FS:  00007fa3c72006c0(0000) GS:ffff88808d009000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000200000 CR3: 000000003e644000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:5161
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2492 [inline]
 allocate_slab+0xd9/0x370 mm/slub.c:2668
 new_slab mm/slub.c:2714 [inline]
 ___slab_alloc+0xbeb/0x1420 mm/slub.c:3901
 __slab_alloc mm/slub.c:3992 [inline]
 __slab_alloc_node mm/slub.c:4067 [inline]
 slab_alloc_node mm/slub.c:4228 [inline]
 __do_kmalloc_node mm/slub.c:4375 [inline]
 __kmalloc_noprof+0x305/0x4f0 mm/slub.c:4388
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kmalloc_array_noprof include/linux/slab.h:948 [inline]
 __bch2_writepage+0x653/0x2790 fs/bcachefs/fs-io-buffered.c:563
 write_cache_pages+0x61/0x100 mm/page-writeback.c:2612
 bch2_writepages+0xf9/0x2d0 fs/bcachefs/fs-io-buffered.c:666
 do_writepages+0x32e/0x550 mm/page-writeback.c:2634
 filemap_fdatawrite_wbc mm/filemap.c:386 [inline]
 __filemap_fdatawrite_range mm/filemap.c:419 [inline]
 file_write_and_wait_range+0x23e/0x340 mm/filemap.c:794
 bch2_fsync+0x127/0x330 fs/bcachefs/fs-io.c:245
 generic_write_sync include/linux/fs.h:3043 [inline]
 bch2_write_iter+0x2822/0x2b90 fs/bcachefs/fs-io-buffered.c:1089
 aio_write+0x535/0x7a0 fs/aio.c:1634
 __io_submit_one fs/aio.c:-1 [inline]
 io_submit_one+0x78b/0x1310 fs/aio.c:2053
 __do_sys_io_submit fs/aio.c:2112 [inline]
 __se_sys_io_submit+0x185/0x2f0 fs/aio.c:2082
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa3c638eba9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa3c7200038 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007fa3c65d5fa0 RCX: 00007fa3c638eba9
RDX: 0000200000000540 RSI: 0000000000000018 RDI: 00007fa3c71be000
RBP: 00007fa3c6411e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa3c65d6038 R14: 00007fa3c65d5fa0 R15: 00007ffd247f0388
 </TASK>


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

