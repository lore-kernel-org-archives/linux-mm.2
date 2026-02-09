Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FDAE7E0D5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 18:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F696B0089; Mon,  9 Feb 2026 13:26:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312A46B008A; Mon,  9 Feb 2026 13:26:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211FF6B008C; Mon,  9 Feb 2026 13:26:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7956B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:26:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 993751601FB
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:26:30 +0000 (UTC)
X-FDA: 84425748540.30.A2F0829
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	by imf18.hostedemail.com (Postfix) with ESMTP id E0B791C0012
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:26:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 30yaKaQkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=30yaKaQkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770661589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=rHb1csLytyyiMKOXyYY5iKGtJrwFDhra+RzcW23fs9U=;
	b=b3sDzNGlUvH8mBMXKVCuZqocJh+GIeMoY11sSj3Tsw8U/p8RMohI8OdD9YqvL1hKsK/Tah
	Mp4oCcKC4aDeBSyKSq6ln/PVbezdeSEEBlWrzQk1CytBDLWe5WgTpEzio4u40GLKbFdoWH
	Y4k2Ipl+gcX/VDqvuAMp6zPUeui6++M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770661589; a=rsa-sha256;
	cv=none;
	b=z2AucQ5j4WuG4n5Q4ACiOG7AyBfaeEKQWkxJa7rlV97hl449x1eZPVB+E/uwqy+rZEBMy5
	tMU+RrjeBB3TscNnzONRFlCizqry1U91jfu9bIPjA+m8bJe+OZYPYTWyIv1fgRI9fiaHNB
	MAp9A4dZjjFrKyMeXJwYd9t/6I8Akfk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 30yaKaQkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=30yaKaQkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-662f839d680so8386411eaf.2
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 10:26:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770661588; x=1771266388;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rHb1csLytyyiMKOXyYY5iKGtJrwFDhra+RzcW23fs9U=;
        b=ftg9NId49dZgjdmTXqDGTyD1PDmUjQggNwuzmUgDBvZ/LeFlcCMQ+lNH9ffQHd/iDw
         A4ENzxmkzaT7JECnUT1HrVBtrdcXMGEOBtzsffpQ4Is9D89wgTmqJ8TAdrrPpr4AUItH
         YBDGymdI8KSXuMwhQYeAo18hsYyUQMWD7c8BbGlP2xnWAauzM55gH+45DQTNgWKQJwNl
         B0W94XQRZgeoFVghjJ48oWVSzE/nJjd/BY+pyvuR8qHtKYQRlf3KnuBoI1p1KDuYLInr
         49Qq5Qj8zPwEvnfVRKLZ2ORm9F72toLlFea/GScQZHwEROdS/2cZ4yYINdVIblBswExa
         FIHA==
X-Forwarded-Encrypted: i=1; AJvYcCUsqK8DUeWcH8VImfMyaf/TftHrmdkH+jmHDgVQ0xvb0NAz1bvTORwaioxb2cW22M1YG4x7V+SBYQ==@kvack.org
X-Gm-Message-State: AOJu0YyqDkjm+vIPR/p2oy+sgKBV6DmtK0Y6ZwYhVB9hoOHmMAQk4A5p
	+/LL/K1leX/gz1Dz+YmtrsnqvfhFYmsyYBkkS41rfmO3mqm79I3md988wNqEnQPnKb2UjSSNaWo
	86flhzauR5JKq0Cy0o7/MiAsGsikSHXN4fe7ZA743qDI9ypOoK6VKfovjgX8=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1614:b0:663:bad:9727 with SMTP id
 006d021491bc7-66d0d10b432mr5479618eaf.78.1770661587911; Mon, 09 Feb 2026
 10:26:27 -0800 (PST)
Date: Mon, 09 Feb 2026 10:26:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
Subject: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org, 
	jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E0B791C0012
X-Stat-Signature: scpxic9m4rugqq5ue1p1aor4zc1ku7ai
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770661588-427811
X-HE-Meta: U2FsdGVkX19R4MzWKBUdb2UjJPH5VBJvN6oA2U7I1H7SOTf4yTd5/VY1vYAJu7GcbCVlRQ4DRovUrrzrkSi0hYUmemhkFMt4dyk9FdAwnthN7xKcLDfq2paSS1up0YNc+yYm0TNVJKbTD2nKLc1aK0MhAXe4LMjm13i3H5q6p20ZqHdT8GpFdC1RVB0gZUz+0zipGyNYNCOUeqcdp/0N1xZL/nIWD4qcyJTRMWiotPP9FGfS+DomuRRymLR2MgIbATZMMeu1H4TU8AysnWKmaS8yTV3xye/zP9hdkMXwywsscQBQmbUQdYjLxjTKeHgzLyOHjEc9uilmsPavQQuLTsarYQMHI7v1J1iHoGjsCydpy9DIRgrYr/CxfvKV+0YsQOHhEeemvUVc9sar7D9w777KH0BcBp3ZdoaycjLZw7CZS2QWzz3awfmaJW6pf0s3WuRXBrBCZiJKDkNoI5PVcCFPqA9nsjEyaF0kCPyOf8vUgBbmjlhHkd3pc/nDlhnnomlTzUHZ57ODDiOMYBaXDGUb4iKfju57XdECxK/C7KdwFAQkIPYYUeVE8tifqBU6HH4EheTJqrujL0m7Ch/bR9WvcMt+PTHMG5i7jbger6MEYsjB5XUZTGltLCx9zoIvrD8ycL2uYGEo2nL1scQipTx67qJfnobzgsWBbGXGu48fexsSSuHfTYeoFyTwyXZ8bNIHNk3BGYwGGDjBb6j9BHhZSj/ROXoazNLfphkI8APNy3Y1mjEqeJgZUyHQWUlN9tOjLsWNdEGaq6h5ZLZGVE+zzkka5k69lQ/PhqtQiMeg3SMRV9MsHOQ1dVAU0V7jXA7lMczeIKJ9Z3Z7ed7bETSYZGS3CrPmyjM0Hh9NvFnb8HhEEUA/xOjEgJeiOeUdslSqkHST5d3f6govNyxrpXVQA/8QshR04UCaVyuyAydBM+xZB/3foQvahN2InsICD/Yv8qrV//4MvSDC7aJ
 0p54XOOn
 tRQZAaGLJOKILHh84FfqzdEhvJ+mh3FamYBmCRRQDcjl31tkFzJUfKitSNnn+d5/PW9LODvVMw4QneaMCnOypUZF+2PmOgakA10dNEvFJLjstGsEUJnJlMCBfsxndfn7ognHbNMuYRDMbCtGMouHqwTLxUTZK1oAkxMEWZ7F/PpUHhQhZFSeBl5Q8KnaPDPXayCkK305+EL7XcKNCvOOdFGa0mBL8ZFgpiS/VXFbGy44qSNFwsUFzhE5H4BVq/H9h/cMe4qsXPL+l88JK7E4hVNeBcMgh6hqXly86ZAYgVIV5vZV9okwEHZaRt/HLQV2KjI5sv6DTkvTP/WXPJL4C0I8S5S7FyfmImIHS4y9DSkP/B26o6NLvEM6VDrB4GixL229d1FmKDaobhfRFTPGvSxzhz7nIt85UJmZYcQD/ggIOBvh6X6tJPMZQ33qVcwQHUVeL30yxtXoEIU8DnwKsPhsCDRp+4s/JJBObyqvG/UjHtpDyQmBDxIFTUD5lfWyQdLlT35bZJNBxnJqjxWKfWUO1JLQcJCxL9ffpTVFl/UByNxo2ssX4lmThnSHTi/GzDMKHrYZ8Y01kBZhNpkKwPg9aymVYUfwudfx63ZiUCCUqbt1P9Yo+RrpotH52sgqaKk/nrpHyq3QtcamxRHJLSDUnDB9X2OkukuC7yhOkKLmBma/SyT2pJ+vlkojbEpc853sgubbKMsC56MBxqp5qwkTYy2UEfqLtEoghxcEgce4pkCHB7cLS4hU1yv1XKNPN4/gAXYmqrjO11o+rDyXDF7LioGIWgCpFyTT/YTzARHoseCdySjAif1m41o99w1wMqnXC7BC/F2AeR5OZnwBsYc1AI0qlw0c2QDbFGVhA41vOp0kNUVBOIIJ5odqRZLn+rYM0U/IZd3XZoZClRd+SRBt3YmAHQfyutlzAEW8cAmYCAobWqPQWUZadTExgw7nXOzv1UrdCzKxli19Ctjk/tZ+4lfo/
 J2AuFKrc
 UmhBJFiNsHBlS+lm9Nz1DNVad9gDaa70oTIoM1Z9wIbeElaCrFga3vM5b+UACYAfgSyZtzFDAS1Cnpp4ukiWb2VygWIDecYC0RH3g3ENyAYPJ4Rkh+dE+FmEH8vtBNKnC7QZrht8s2o6Xm2xzUrBO0sMu6fqee3Mr2u1fMmqNoSSJEJxADT33P4kIByCpmd64IRXYLoEyesj5g9+I7vek3r5tw3Mh5oHyjBps2spQjOyQj27v91WlCqYQCo0crcat4VOy9i/3AJVEF4V5q3FnIUrfkima/uXRHlmyI4wRFF/vriVxUnqkTnTLiBEnNs/83CEFnI/NKT1jjA26P0NuzGzAOPHe1mKGn3NJAy/Xv8+YSKd68+SAbY4U7QWS54Rqv0MLMCTsuIWF5YuC+LYrcjaPJ/qHpSPNg+5590rlF3efGxc27N3Sd85jb6dwqWb5jUhdnVLNIRc+rHZwc4YwU5YbyNaC1FO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    e7aa57247700 Merge tag 'spi-fix-v6.19-rc8' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=122ae7fa580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d7d0fbecb37bff8
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130e2944580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/28d29c9b5ae2/disk-e7aa5724.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0683244c7a0f/vmlinux-e7aa5724.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cd8cc5cb8b94/bzImage-e7aa5724.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f78f58e821b0/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=10f7165a580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888113218600 (size 512):
  comm "sed", pid 6046, jiffies 4294945902
  hex dump (first 32 bytes):
    00 8e 13 29 81 88 ff ff 00 12 86 27 81 88 ff ff  ...).......'....
    00 5a 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  .Z..............
  backtrace (crc 49909e19):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x465/0x680 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kzalloc_noprof include/linux/slab.h:1094 [inline]
    alloc_empty_sheaf+0x36/0x50 mm/slub.c:2618
    __kfree_rcu_sheaf+0x155/0x210 mm/slub.c:6304
    kfree_rcu_sheaf mm/slab_common.c:1631 [inline]
    kvfree_call_rcu+0x202/0x3d0 mm/slab_common.c:1981
    ma_free_rcu lib/maple_tree.c:208 [inline]
    ma_free_rcu+0x29/0x40 lib/maple_tree.c:205
    mas_free lib/maple_tree.c:1174 [inline]
    mas_replace_node lib/maple_tree.c:1581 [inline]
    mas_wr_node_store+0x5fc/0x730 lib/maple_tree.c:3553
    mas_wr_store_entry+0x4eb/0x760 lib/maple_tree.c:3764
    mas_store_prealloc+0x358/0x740 lib/maple_tree.c:5169
    vma_iter_store_overwrite mm/vma.h:544 [inline]
    commit_merge+0x28e/0x490 mm/vma.c:763
    vma_expand+0x264/0x460 mm/vma.c:1200
    vma_merge_new_range+0xe3/0x350 mm/vma.c:1099
    __mmap_region+0x54b/0x15b0 mm/vma.c:2747
    mmap_region+0xfb/0x1e0 mm/vma.c:2830
    do_mmap+0x7ac/0xb80 mm/mmap.c:558
    vm_mmap_pgoff+0x1a6/0x2d0 mm/util.c:581
    ksys_mmap_pgoff+0x233/0x2d0 mm/mmap.c:604

BUG: memory leak
unreferenced object 0xffff888127861200 (size 512):
  comm "udevd", pid 6236, jiffies 4294948784
  hex dump (first 32 bytes):
    00 86 21 13 81 88 ff ff 18 e0 05 00 81 88 ff ff  ..!.............
    00 5a 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  .Z..............
  backtrace (crc 5b72581e):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x465/0x680 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kzalloc_noprof include/linux/slab.h:1094 [inline]
    alloc_empty_sheaf+0x36/0x50 mm/slub.c:2618
    __kfree_rcu_sheaf+0x155/0x210 mm/slub.c:6304
    kfree_rcu_sheaf mm/slab_common.c:1631 [inline]
    kvfree_call_rcu+0x202/0x3d0 mm/slab_common.c:1981
    ma_free_rcu lib/maple_tree.c:208 [inline]
    ma_free_rcu+0x29/0x40 lib/maple_tree.c:205
    mas_topiary_node lib/maple_tree.c:2311 [inline]
    mas_topiary_node lib/maple_tree.c:2299 [inline]
    mas_topiary_replace+0xb0f/0x1400 lib/maple_tree.c:2410
    mas_wmb_replace lib/maple_tree.c:2433 [inline]
    mas_spanning_rebalance+0x14e1/0x24b0 lib/maple_tree.c:2738
    mas_wr_spanning_store+0x983/0x10d0 lib/maple_tree.c:3479
    mas_wr_store_entry+0x4d5/0x760 lib/maple_tree.c:3767
    mas_store_gfp+0x341/0x640 lib/maple_tree.c:5138
    vma_iter_clear_gfp include/linux/mm.h:1141 [inline]
    do_vmi_align_munmap+0x259/0x2d0 mm/vma.c:1574
    do_vmi_munmap+0x17c/0x280 mm/vma.c:1627
    __vm_munmap+0xec/0x200 mm/vma.c:3247
    __do_sys_munmap mm/mmap.c:1077 [inline]
    __se_sys_munmap mm/mmap.c:1074 [inline]
    __x64_sys_munmap+0x1f/0x30 mm/mmap.c:1074
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff88812c458000 (size 4480):
  comm "udevd", pid 5181, jiffies 4294950983
  hex dump (first 32 bytes):
    01 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 80 00 00 00 00 00 00 00  ................
  backtrace (crc ad4af9e6):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    kmem_cache_alloc_node_noprof+0x422/0x590 mm/slub.c:5315
    alloc_task_struct_node kernel/fork.c:184 [inline]
    dup_task_struct kernel/fork.c:915 [inline]
    copy_process+0x286/0x2870 kernel/fork.c:2052
    kernel_clone+0xac/0x6e0 kernel/fork.c:2651
    __do_sys_clone+0x7f/0xb0 kernel/fork.c:2792
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff8881274a1540 (size 184):
  comm "udevd", pid 5181, jiffies 4294950983
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 54e589bc):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    kmem_cache_alloc_noprof+0x412/0x580 mm/slub.c:5270
    prepare_creds+0x22/0x600 kernel/cred.c:185
    copy_creds+0x44/0x290 kernel/cred.c:286
    copy_process+0x7a7/0x2870 kernel/fork.c:2086
    kernel_clone+0xac/0x6e0 kernel/fork.c:2651
    __do_sys_clone+0x7f/0xb0 kernel/fork.c:2792
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888109639020 (size 32):
  comm "udevd", pid 5181, jiffies 4294950983
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    f8 52 86 00 81 88 ff ff 00 00 00 00 00 00 00 00  .R..............
  backtrace (crc 336e1c5f):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x465/0x680 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kzalloc_noprof include/linux/slab.h:1094 [inline]
    lsm_blob_alloc+0x4d/0x80 security/security.c:192
    lsm_cred_alloc security/security.c:209 [inline]
    security_prepare_creds+0x2d/0x290 security/security.c:2763
    prepare_creds+0x395/0x600 kernel/cred.c:215
    copy_creds+0x44/0x290 kernel/cred.c:286
    copy_process+0x7a7/0x2870 kernel/fork.c:2086
    kernel_clone+0xac/0x6e0 kernel/fork.c:2651
    __do_sys_clone+0x7f/0xb0 kernel/fork.c:2792
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888126fdbd80 (size 64):
  comm "udevd", pid 5181, jiffies 4294950983
  hex dump (first 32 bytes):
    c0 c3 4e 46 81 88 ff ff 00 00 00 00 00 00 00 00  ..NF............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 508a43e4):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x465/0x680 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kzalloc_noprof include/linux/slab.h:1094 [inline]
    lsm_blob_alloc+0x4d/0x80 security/security.c:192
    lsm_task_alloc security/security.c:244 [inline]
    security_task_alloc+0x2a/0x260 security/security.c:2682
    copy_process+0xf07/0x2870 kernel/fork.c:2203
    kernel_clone+0xac/0x6e0 kernel/fork.c:2651
    __do_sys_clone+0x7f/0xb0 kernel/fork.c:2792
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


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

