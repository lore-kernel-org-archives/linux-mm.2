Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604EFEF5866
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 12:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2BA6B0005; Sun,  8 Mar 2026 08:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260D66B0089; Sun,  8 Mar 2026 08:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141AB6B008A; Sun,  8 Mar 2026 08:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03E856B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 08:37:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72585B9918
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 12:37:33 +0000 (UTC)
X-FDA: 84522846786.01.B4FD833
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id BB59C80002
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 12:37:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3CmytaQkbAOsflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3CmytaQkbAOsflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772973451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=eExMXBnXM4peFMhhjLeKZOOSaw7IwpgqnEj+UrfzQhQ=;
	b=xCzdTFcuG1CGYbsEiSa72AnkxS8wDv6DYICv0BZ2bW0vVXulHRWJCir5f3wmv7NcMih+eq
	vIrHfy2U0HoJV1jZVNQ6yGS9l18JbyUD8u7REFhT/CKlR3ALh9TUeGUa3Lf0SXxWYxr83k
	njnTQAtj7miLSrUbR2wfWtHHtuv76VE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3CmytaQkbAOsflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3CmytaQkbAOsflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772973451; a=rsa-sha256;
	cv=none;
	b=5RMuuMqcvsJjlRTkgOwWg+9+GN6ijoAvAtboAeNq3ESvObkVXGQ3nzvIwPXHLsa34XRGT5
	7FX5fx2zRWlihSaW7XfWc1Hw/gcYgiMieHe8pv7lPSScTQKA+tM85YNdXiuWMxwKekMPf7
	dODv/Or7//SMeSWh/3N8XrfdsUXL9SQ=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7d4be1dee67so111870306a34.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 05:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772973451; x=1773578251;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eExMXBnXM4peFMhhjLeKZOOSaw7IwpgqnEj+UrfzQhQ=;
        b=TbOXMbX9amDJQHB85o2RlGvUz1HR8w6Tr2BG6rpP70NO2Yk4IZgyDQRUtBgO7p9rwm
         7KVsicMWpdXRAS/oa/hkFFnyR7rMErMlJ43K9RItMtbXp6GCTh1iz8nj2dPpYaW6u2Rz
         6OJ1f1XKv+kpmyreZA8foubQvJ9j5f809KULD7xJ79kwsY/PUhvUZpaez0geE2YUuNNR
         WVOL8Jsqm/fZTjK4jB88iX3qV6vX4km2bU2JeZR59zf2hVsJn7z9JTl9mhwNPj5E4gXI
         LQ7dJ2WJMMLYnkNGDIvafYka148gehnorsuGVwTHNP61+Zx07lvizN0uco81O7yKlj2e
         AdsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPVvUAyA3abUbHrlfmsadS0UzZqHz35YKIS9F1CBHF10wZ1lPXdzUst9E9N2ER6nj0Web49xpwdg==@kvack.org
X-Gm-Message-State: AOJu0YzTAtQMEhwK2TRiP2RIZHhhCt42oww5vPw4A4kmBU02mjXrwoUu
	W7i9XVw/QRuMONdbDwzXGFVmQJu/XjUEFN2H3EFDtyzJlw8KEnIHLrHacBilAv87Ni3fTobkEDJ
	upy9KJ/YVidBk/k76W0oGWkbx73wXo0+1BpzkmR7M0qU2WGOXpXH/ZsC4s/c=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b05:b0:67a:4fe9:a4ba with SMTP id
 006d021491bc7-67b9bd49644mr4828247eaf.63.1772973066145; Sun, 08 Mar 2026
 05:31:06 -0700 (PDT)
Date: Sun, 08 Mar 2026 05:31:06 -0700
In-Reply-To: <aa1XX2ZXo-hc6LHG@arm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ad6c0a.a00a0220.b130.0000.GAE@google.com>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, catalin.marinas@arm.com, chao@kernel.org, 
	hao.li@linux.dev, harry.yoo@oracle.com, jaegeuk@kernel.org, jannh@google.com, 
	liam.howlett@oracle.com, linkinjeon@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org, vbabka@suse.cz, wangqing7171@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BB59C80002
X-Stat-Signature: pki7e3ixef67myba9k3w6mx9m4n5pptg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772973451-859189
X-HE-Meta: U2FsdGVkX18Rxdc0S6kmzbTH1M8Ssk05R0KW5h2v665Z1iCoyzR8mtfjoyYL//5synfbHsyMnvgc1BwnQz3ugNBYo9qRtRKhyMOvA85Mibc+cTlCVNtjbuOWiMyT3JvU3REBZpZzGNRS9ITICUoG1jtlBs84aAzwoCA4aSm/r6NoQ3133EEb3oIfdsJWo7ipErcMHei1Gi5alh1D5Hy1ZkjV8/xm48Wi0Lul49eTQGFwo0iWdKt3RJMAx78nB0M2f6oUWiB5/QKKywyvh9XxZ+LIj2F7/6j/R67BMVWoUKpWLdgTCgGjMYCFKAzmmmzM0I4GUz3cBJW3tz9Wd2/Ob+Ql/nmHOxLOEB2YaxPcUwGPF2frm7hNYh2bENlq8rp1jvatCEZMxKlHFDKWHO3NGACKdR2f4L5pzNAlq7HAfjjpFq1DLLPAHB4tnAnqgIdmkok17hdM67Htfhg6DkDUI/OZbTkPO+RXUHiDDokSGW0YOTIAXudua5hySc7Gu6oRzjxN+8CYkOU4en1HNJyeD5rrqPW2llBaQH5jUklqjj4w2nmqLtOu90iUo5DQJTull3NsaNB++KpLniEt0RfAKATbsBq4fUKnZg6j+bP69KcBjqymQAi9XToPqhySAG8e5a5YBTtOpg4szozzGwrI4P7SJHg+W2d8sdIOLc0feKstzrfV60+QnRblIXJPZGGIvXD1ZbfC346wvhZlMmiY2k3ZmmVpf05PGkCfb6TU7UWuDCkBS+ioqsuQ/4Zsnr0oFbCRYXmN2WzQN5f3XAyFhl3lMDwYT0d5S5EroTA+WlyGJJevhaA7Vf603syJYfOEU59AHm+YWV0aRlm0L8MesQib17M2KfdjUsy4ngIt2JAetRfCwiEquYbesTtHN82Ih5qMQTt0sHL9a4LpBY7Bm97LfHQlDfgagthbcv3Hqfxzyz1bmsN7KdomUCMvVeDxWGUm2FOyN0vsmragmGC
 ScR8kZFo
 yi6IjsKJN09kisDJN7OU2wCbZG1vO6rF8KOd0/oBD7Ez7ahY21BFzknAKKAefZQZgQZ7+nMf+UwrPMg5qrecHSS8Zl7XyBmrlAUy08kWTl9PjQu+uQc1lFb7j9/nsYYZHMq98tcnuvRyUPo4BvU6bqtmjSganGaWPvGcL8VD1OtxopHkXMSytvH/Fl0C0uk5pxX7wrh7VKTrqfmkSA6HVTGUJCeasnirJdBuA0hGMRXKq1z+SnQ9bCI6NsJ49Vm8b2Fl75tfpsB0rwSFVonIEILelZ0DgRYRX91O4g/rvPbeuYSmitILCV94y+e2fs9hLdIr35MkN78yGAhW9aTyoeka4yXDprHaiHbtbrAYUvlWwfD6pM2hdSKHm9mJrtLCtoIedNcgnFi7eZQHWj6T+aUjDO1uf44xCTmfPQKc6Uu6I3gaxeF+VF+yioxsBnHB7//59MGFVBq6bgPl+BgbySeD80+HBP68jktGlUk0xbZ0p3AEV2vQCtS7e17ggyW/gLlg+ilNQDjN9TKklBir/uJukWYhGYhP3MezJROzeVeGLNEhBwASKDcqKLkVogBgZ9wgn7M/XeD5AduL/sOX50LVg2QXbveysoDU6eVSldNWCuOy9bpRdYAXo6hlpnnDls6OADlcxTPC0o7xtH8jSdZHTovtmobsJ8PpjSkgd4HFdCkvorKYBhs8jGfRwUsTvUGDpeAqvJudx1QtK8v5QVGqxp7ZdImT83moZ5I4kRse1TtgoBJIaeAg8xzIHKSeu6gqm4hFFe6b43+vdNddYoA5cevxZyglt51Znw/zrG05AkNV8nUtsNRQqDIzmgDacNix/CYJY2IiBioVRNGbH8czUPdsMSQKckQ6LzoxfEedUe7oa08MKgFKp7pAKXgJIS+oG/0qbq14PJh0L/4S56F9Q/FOzWh5oOofCt47AOXBE1QddrjnOps1FeRyxdidf1QQ/vL+pjMiz65e4oMHTjzn2duQA
 7mCS7VG4
 /1MWh+eXPnoPCY3hPd8d786B+BdjJtAVwZ/0h9ww5dM1gfkCxEwVCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in __pcs_replace_full_main

BUG: memory leak
unreferenced object 0xffff888101d79200 (size 512):
  comm "kworker/u8:5", pid 182, jiffies 4294937433
  hex dump (first 32 bytes):
    e0 22 eb 30 81 88 ff ff b0 b7 ad 81 ff ff ff ff  .".0............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 3ee28017):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5725
    free_to_pcs mm/slub.c:5778 [inline]
    slab_free mm/slub.c:6173 [inline]
    kfree+0x352/0x390 mm/slub.c:6486
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:119
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888101fa6c00 (size 512):
  comm "kworker/1:1", pid 41, jiffies 4294937441
  hex dump (first 32 bytes):
    b0 1e fc 11 81 88 ff ff b0 b7 ad 81 ff ff ff ff  ................
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc a295f059):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5725
    free_to_pcs mm/slub.c:5778 [inline]
    slab_free mm/slub.c:6173 [inline]
    kfree+0x352/0x390 mm/slub.c:6486
    vfree.part.0+0x1d5/0x4d0 mm/vmalloc.c:3485
    vfree mm/vmalloc.c:3456 [inline]
    delayed_vfree_work+0x5b/0x90 mm/vmalloc.c:3398
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888109d31a00 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937949
  hex dump (first 32 bytes):
    c0 fa 74 29 81 88 ff ff b0 b7 ad 81 ff ff ff ff  ..t)............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc e073aa0b):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5725
    free_to_pcs mm/slub.c:5778 [inline]
    slab_free mm/slub.c:6173 [inline]
    kfree+0x352/0x390 mm/slub.c:6486
    vfree.part.0+0x1d5/0x4d0 mm/vmalloc.c:3485
    vfree mm/vmalloc.c:3456 [inline]
    delayed_vfree_work+0x5b/0x90 mm/vmalloc.c:3398
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888109d3d800 (size 512):
  comm "udevadm", pid 5179, jiffies 4294938390
  hex dump (first 32 bytes):
    88 43 58 27 81 88 ff ff b0 b7 ad 81 ff ff ff ff  .CX'............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 37e3920):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2834 [inline]
    __pcs_replace_empty_main+0x1d2/0x260 mm/slub.c:4629
    alloc_from_pcs mm/slub.c:4720 [inline]
    slab_alloc_node mm/slub.c:4854 [inline]
    __kmalloc_cache_noprof+0x3ac/0x480 mm/slub.c:5378
    kmalloc_noprof include/linux/slab.h:950 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    kernfs_get_open_node fs/kernfs/file.c:543 [inline]
    kernfs_fop_open+0x4f3/0x580 fs/kernfs/file.c:718
    do_dentry_open+0x202/0x8d0 fs/open.c:949
    vfs_open+0x3d/0x1b0 fs/open.c:1081
    do_open fs/namei.c:4671 [inline]
    path_openat+0x154d/0x1e20 fs/namei.c:4830
    do_file_open+0x121/0x200 fs/namei.c:4859
    do_sys_openat2+0xa5/0x140 fs/open.c:1366
    do_sys_open fs/open.c:1372 [inline]
    __do_sys_openat fs/open.c:1388 [inline]
    __se_sys_openat fs/open.c:1383 [inline]
    __x64_sys_openat+0x82/0xf0 fs/open.c:1383
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff88810b5a5000 (size 512):
  comm "udevd", pid 5178, jiffies 4294938454
  hex dump (first 32 bytes):
    80 c5 8e 2b 81 88 ff ff b0 b7 ad 81 ff ff ff ff  ...+............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc bce89c59):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2834 [inline]
    __pcs_replace_empty_main+0x1d2/0x260 mm/slub.c:4629
    alloc_from_pcs mm/slub.c:4720 [inline]
    slab_alloc_node mm/slub.c:4854 [inline]
    __kmalloc_cache_noprof+0x3ac/0x480 mm/slub.c:5378
    kmalloc_noprof include/linux/slab.h:950 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    kernfs_get_open_node fs/kernfs/file.c:543 [inline]
    kernfs_fop_open+0x4f3/0x580 fs/kernfs/file.c:718
    do_dentry_open+0x202/0x8d0 fs/open.c:949
    vfs_open+0x3d/0x1b0 fs/open.c:1081
    do_open fs/namei.c:4671 [inline]
    path_openat+0x154d/0x1e20 fs/namei.c:4830
    do_file_open+0x121/0x200 fs/namei.c:4859
    do_sys_openat2+0xa5/0x140 fs/open.c:1366
    do_sys_open fs/open.c:1372 [inline]
    __do_sys_openat fs/open.c:1388 [inline]
    __se_sys_openat fs/open.c:1383 [inline]
    __x64_sys_openat+0x82/0xf0 fs/open.c:1383
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888109d3ce00 (size 512):
  comm "udevd", pid 5189, jiffies 4294938454
  hex dump (first 32 bytes):
    b0 4e 89 2b 81 88 ff ff b0 b7 ad 81 ff ff ff ff  .N.+............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc e7e352bb):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2834 [inline]
    __pcs_replace_empty_main+0x1d2/0x260 mm/slub.c:4629
    alloc_from_pcs mm/slub.c:4720 [inline]
    slab_alloc_node mm/slub.c:4854 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x4c5/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    tomoyo_encode2+0xd0/0x1e0 security/tomoyo/realpath.c:45
    tomoyo_encode+0x29/0x50 security/tomoyo/realpath.c:80
    tomoyo_realpath_from_path+0xc4/0x2c0 security/tomoyo/realpath.c:283
    tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
    tomoyo_path_perm+0x12c/0x290 security/tomoyo/file.c:827
    security_inode_getattr+0xaa/0x200 security/security.c:1869
    vfs_getattr fs/stat.c:259 [inline]
    vfs_fstat+0x48/0xe0 fs/stat.c:281
    __do_sys_newfstat+0x42/0xa0 fs/stat.c:551
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         c23719ab Merge tag 'x86-urgent-2026-03-08' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1228e75a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1310e75a580000


