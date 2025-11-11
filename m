Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E395FCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32FF48E0016; Tue, 11 Nov 2025 05:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0748E0002; Tue, 11 Nov 2025 05:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D648E0016; Tue, 11 Nov 2025 05:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8DD8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:02:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A86E31404CF
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:02:30 +0000 (UTC)
X-FDA: 84097886460.02.B185D8B
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0382940019
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:02:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 3tAkTaQkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3tAkTaQkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=O9gGu9oyo0707+mNJUixmiZvMnsJd1DK+S6x2+Dz/88=;
	b=Vf0Xe1cFaPQ2cde0E1aHwrht2I8giTctXVd5B0sUWrc0SpojsOEwLU9zC+nyFkplYbJ4IS
	CERipcaWZf0yUKAWLJbrISXm1XV7h85y01X3m8RJhk8oeEUKuUtWY7AxqNqkTtg7JGVI3x
	PfXVMNNTmxynFdqKr1iekTPZlhF3LZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855349; a=rsa-sha256;
	cv=none;
	b=YVQeeT2A2fnajrKENObU/K287TChyJ18+W76W8GLRZp9Ch/A3f3fE/pA3J2osYPXHhmV+q
	ZLR57FVGX/hsRUuwjfsx0Sy6TAUy0PbH4LpmDU0HIPuFFrAAE+YxBxiFzuKxOmLLwxsACW
	5OIesDAebeP8NnKZ/JAZPUb62r6Xx+g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 3tAkTaQkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3tAkTaQkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-9489bfaef15so243010339f.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:02:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762855348; x=1763460148;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O9gGu9oyo0707+mNJUixmiZvMnsJd1DK+S6x2+Dz/88=;
        b=oXjYxNYclpOB0tKNiCGwX5mNB+cVXwETaGVLQjSu+sIVxi+WDXT5noWUJ2vIUAZhr7
         eBdDwRXLqRj6PgSOFVNqu7NrG+zSq5UqRZYW/n+5o4vdgbX8Oo8lq2H94kWgqTIOVw4/
         tCzCMdnQiAgD2rFZhWMPOAZfu8sDP7DcxxjKUJ0c97KFai3Z0FkBAqCYj9ubVvKfmP2W
         HtIw1XOnoMWphmz0Xh70Yr8QVZoJ5fViHx5r4qsjD4hquy9fNKJ83fNrqgtdII/TxijD
         GhV6ArGllE1d95+TnKMzwpSiqMXlXIpyRPbNOyuDdW5RywmIi1VMbxnuo7cJPVChZtPG
         tCIA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ8+UiqoVIotPb/6XA0/tyYSemUf9PyBgBLn1ua4puUxZl8hbUhDy8tAwdJap0blQxSLdVmVGMqw==@kvack.org
X-Gm-Message-State: AOJu0YyKidsBwSHG+M065ceAFeCC7IpLP//LlpFdP5HP2K+EOpvQr/uI
	L9ea3eBVb/9GO4ndC5fTuggRer3BZB1w7Fiu3GzAyVljz63SleYyxYQNjRQCJgz3rqKynAfh1xV
	CX1N2nF0wlWR0Fhw7HJpKxKU4z7CGdXyHW0BhPzS/26sxPJhKbONSHiaIffs=
X-Google-Smtp-Source: AGHT+IEyDUDQ45SEEWG+uFxc4pqGZcp2gt5ExQ+vwzcmPnW1uzB1Ib8IQvzY7B/cXQ7ctysLLOyYJyk6qh7+sxTWJLS3PKY2MFT6
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3e93:b0:433:78fa:7fe9 with SMTP id
 e9e14a558f8ab-43378fa8302mr108807405ab.22.1762855348010; Tue, 11 Nov 2025
 02:02:28 -0800 (PST)
Date: Tue, 11 Nov 2025 02:02:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691309b4.a70a0220.22f260.0133.GAE@google.com>
Subject: [syzbot] [mm?] KASAN: slab-use-after-free Read in mtree_range_walk
From: syzbot <syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bkqshnxbgkwnhc486di95adac6j5y7b7
X-Rspam-User: 
X-Rspamd-Queue-Id: 0382940019
X-Rspamd-Server: rspam01
X-HE-Tag: 1762855348-220677
X-HE-Meta: U2FsdGVkX19A975kbUpqA/QDJuCVmF6mWJEfpEdaMp0tLAelTAGZI8ghMSHbCpPa2GzdPPK+tj7skvnxWmWYVcPJr98RZKAhf6oDRwrYiwqLG9DyfwzMXCtfXl7gR7x4k6M7ybi98FALZW1zjuVmJaoLxx+gXsL4l4B/tRT0n0q/mDX8jY8D0H7CA8D7t4RSheKUdylYlz01W98ZhHskP37v/HNd19pLzvJ7fQdU1j2mdDTJz2A+HHGs7WCFuQTMu3v7uIBMvwQPiy8HoMnH8yDTQqrXchmu2br0Buoj0M0fdpOne5UnjRQT/SfMqIt3zeF0wfcY4JFF5FuruDSg3D7YfJfGzENEXodz+0NxeUKLztWiA5m2vWmnEpao+QdUKznA5HGaV1ysfobmiPROpgq5jHdKjA+2kkxAl5gw/RWD7l3k0fvbDzVpUWiVrXqYdgqReTPkTYUEu4in41y1s+L5hLLZzPjuleVAtuJB5MWv/2+Nx+qdNjNWuQvnixBLCH8MsytT4YuX+xRTIYiggf7Wr/P5mcepuYCYMo2Y1Sn4OQtHuRJXbGUU7EvkTThhxkwUcWXICLquVKYNWIVNcFvNc36diy/xwn0V4Cg6tAxv2deruH91gUawIMnhBmQUN4QfQfgrst8w6CgZbB49fONvpu7UmMRDbRWGgLu/xq/hk2yQ65IRrj3OHDejrbdQ3/o78BAz8zDihipOK53zLc1xaLAlDbvu28fxy5gUDx2bXJcBB/BsiUFVR74WNUI7DdlxiPc+D3pGLXuSyclYoHB6vKk4uNiDqQX3wR82kxKtN3iU5s6i3MwRNxDm0gu3rn3wUyHrI10p326kaoJ0qU+Fh2cIK5qoeEmVixhNUJ8XQwuLBqarC3XYIB73427FAdGgIV1bmS69mJOMN6RvWqrZcIX+iPB3ocvp2BS7wXTNFtLmwzgiR8XTBh6q98rUo8VjR7aXqGahCGyE6eL
 vr7InnVj
 9frzQMqfXezmHmSOqWedubVIvCO4GHuWpyZB1YCyESCe2hlLm39QyAjiuwt3Lq2TLAcXyX1ARy2QroxdbVefQ0JDukeuyUUf/v36g2Y6TEamSCYeXvYO6FzgoxhUB5YG/MAazvo/SW84JpU7hWR7dEh21leLCs9FXgLVDqPCRVQ+k7jy+Oo35WpJg9TkXvvX56AJf08DBATH8EB8tQu7QzjkmskgMknTjEVsVnBr5+IEWDwCIJMt/B0le+XjQjXZMuFoVD/e3qi+WlCEHLy/+dnx6R+rndCdqadt8Xc0yd9CNHTyCV9LQLynoH5FA12+KMZdG9/zxloG3+fmgmlQPujvGKZvWHuQ5w5QINNtQm0iDHWIOiaN04fKjOLYsbrr846KXnJsmDETKRNhYtc/BmsYr/57KrZcNkr+zZpu7iQ75n4UkV0Eu2yN2n1X/UFpW6cEzq+geZDFXnmyapHHmuH9DmaKiaOeGV5RS376F3C8ebui1OLOrSrLUUOwOnVAVAXUc4Q2d2TfUSyvrwt6UQAm0lN8dv9lIfhT7/IOPsWXSl/dAn2pXekGe09yrqFwXs6ABR24Mz4gsiZC+i0gzUVoShs0UMRALWLSJcVYqRBXsFTAZTEb4BFPq+Ugg9yU+JkT2LhGM/WGCPmXo7KD6/qFqePa7efpgfh3qBA/2CeoW9NSEIkvbUv9YXRHDRaAC4V5j1abYueYvBp4cgFDnjpJCGg3EckLWn3HWl3DCR+C9jLPFD8AzmgVLZfvlGnjhWFMyp49s/V0IludwbZVT05IQXIr/aTesVuV0FMXijwjz9Jp3F7hRiSSGb7exoS6d9fI4QhjPOrrwdoWrZOnSNj8JycS6qRWfkGpko2EIWrZP7oyT8lz2k0PyRyijkiDNY9EqvQtxuiPBxbAJfvDvrqiEkDcRTPYhoka+uhSnZyh/EdmX0owgv6W0nxCkNlak73bQmY/N4UVL9XyPqS6qO5etv+fz
 fkdV/XTZ
 4UOBO1dD5ovodWDLSsEkHd+/kzajo9K0jPuo7qzjcTTKQcWIU/Co8LswzF8GvGZYwIRtkQ24zyqtOE59sBj8SFRpvxkVYZkfeBSu7vWbLwOR8MTPJSMqcspX3r5ugzTFAhVzqwa6luNADJG4rlQasCGFjn4pri5ITwKhu4ztywszyBplUPhBohTDSbrFnTNPi2jzBB5nC7lW8quXFrPRhYDPQUQPnmhqSdzEI20tJbPeSz0eClMQoet+MZqVUh72vRSR6tI1h95Bu7PRXDBkO8uiEFlpG8e6oHxol03yswQShF3H6VTI6FAkyX0MuMTztGBlQPnHf578vlQgcVBaQTp0HQiiZ4A1+WcDe/7KUYMBb3eGBPt23LoI/PhwhyBMFDclujhsPGjY55H0AILWr1tTcHWCW/49wkIDOS3RjATWNWdAr4Pnxnf/4GgRxHXe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    dcb6fa37fd7b Linux 6.18-rc3
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
console output: https://syzkaller.appspot.com/x/log.txt?x=10da7012580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3106dc390828a333
dashboard link: https://syzkaller.appspot.com/bug?extid=131f9eb2b5807573275c
compiler:       Debian clang version 20.1.8 (++20250708123704+0de59a293f7a-1~exp1~20250708003721.134), Debian LLD 20.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-dcb6fa37.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4a05d908f307/vmlinux-dcb6fa37.xz
kernel image: https://storage.googleapis.com/syzbot-assets/874b2b8dba2a/Image-dcb6fa37.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in ma_data_end lib/maple_tree.c:1255 [inline]
BUG: KASAN: slab-use-after-free in mtree_range_walk+0x604/0x8d0 lib/maple_tree.c:2556
Read of size 8 at addr 4cf000000dcf0178 by task syz.0.1606/8933
Pointer tag: [4c], memory tag: [fe]

CPU: 0 UID: 0 PID: 8933 Comm: syz.0.1606 Not tainted syzkaller #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_address_description+0xac/0x288 mm/kasan/report.c:378
 print_report+0x84/0xa0 mm/kasan/report.c:482
 kasan_report+0xb0/0x110 mm/kasan/report.c:595
 kasan_tag_mismatch+0x28/0x3c mm/kasan/sw_tags.c:176
 __hwasan_tag_mismatch+0x30/0x60 arch/arm64/lib/kasan_sw_tags.S:55
 ma_data_end lib/maple_tree.c:1255 [inline]
 mtree_range_walk+0x604/0x8d0 lib/maple_tree.c:2556
 mas_state_walk lib/maple_tree.c:3296 [inline]
 mas_walk+0xf8/0x34c lib/maple_tree.c:4597
 lock_vma_under_rcu+0x10c/0x35c mm/mmap_lock.c:232
 do_page_fault+0x3a8/0x1508 arch/arm64/mm/fault.c:625
 do_translation_fault+0xbc/0xfc arch/arm64/mm/fault.c:789
 do_mem_abort+0x50/0x110 arch/arm64/mm/fault.c:929
 el0_da+0x64/0x210 arch/arm64/kernel/entry-common.c:562
 el0t_64_sync_handler+0x90/0x12c arch/arm64/kernel/entry-common.c:768
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

Allocated by task 8934:
 kasan_save_stack+0x40/0x6c mm/kasan/common.c:56
 save_stack_info+0x30/0x138 mm/kasan/tags.c:106
 kasan_save_alloc_info+0x14/0x20 mm/kasan/tags.c:142
 unpoison_slab_object mm/kasan/common.c:342 [inline]
 __kasan_slab_alloc+0x94/0x98 mm/kasan/common.c:368
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4970 [inline]
 slab_alloc_node mm/slub.c:5280 [inline]
 kmem_cache_alloc_noprof+0x320/0x5a8 mm/slub.c:5287
 mt_alloc_one lib/maple_tree.c:172 [inline]
 mas_alloc_nodes+0x350/0x3b8 lib/maple_tree.c:1108
 mas_preallocate+0x544/0x970 lib/maple_tree.c:5192
 vma_iter_prealloc mm/vma.h:442 [inline]
 __split_vma+0x318/0xb00 mm/vma.c:528
 vms_gather_munmap_vmas+0x4d0/0x1474 mm/vma.c:1380
 __mmap_prepare mm/vma.c:2359 [inline]
 __mmap_region mm/vma.c:2652 [inline]
 mmap_region+0x6c0/0x1fcc mm/vma.c:2740
 do_mmap+0xa50/0xf64 mm/mmap.c:558
 vm_mmap_pgoff+0x290/0x3e8 mm/util.c:581
 ksys_mmap_pgoff+0x3a4/0x448 mm/mmap.c:604
 __do_sys_mmap arch/arm64/kernel/sys.c:28 [inline]
 __se_sys_mmap arch/arm64/kernel/sys.c:21 [inline]
 __arm64_sys_mmap+0x13c/0x198 arch/arm64/kernel/sys.c:21
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x90/0x238 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x180/0x2f4 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x58/0x74 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x234 arch/arm64/kernel/entry-common.c:746
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

Freed by task 8110:
 kasan_save_stack+0x40/0x6c mm/kasan/common.c:56
 save_stack_info+0x30/0x138 mm/kasan/tags.c:106
 __kasan_save_free_info+0x18/0x24 mm/kasan/tags.c:147
 kasan_save_free_info mm/kasan/kasan.h:406 [inline]
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x64/0x68 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2539 [inline]
 __rcu_free_sheaf_prepare+0x11c/0x2c4 mm/slub.c:2745
 rcu_free_sheaf+0x2c/0x138 mm/slub.c:6181
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xe14/0x1d30 kernel/rcu/tree.c:2861
 rcu_core_si+0x10/0x1c kernel/rcu/tree.c:2878
 handle_softirqs+0x36c/0xd08 kernel/softirq.c:622
 __do_softirq+0x14/0x20 kernel/softirq.c:656

The buggy address belongs to the object at fff000000dcf0100
 which belongs to the cache maple_node of size 256
The buggy address is located 120 bytes inside of
 256-byte region [fff000000dcf0100, fff000000dcf0200)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xbbf000000dcf0000 pfn:0x4dcf0
flags: 0x1ffc00000000200(workingset|node=0|zone=0|lastcpupid=0x7ff|kasantag=0x0)
page_type: f5(slab)
raw: 01ffc00000000200 d5f000000cc09700 ffffc1ffc0494790 ffffc1ffc051fb90
raw: bbf000000dcf0000 000000000010000e 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 fff000000dceff00: ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae
 fff000000dcf0000: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
>fff000000dcf0100: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
                                        ^
 fff000000dcf0200: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
 fff000000dcf0300: 70 70 70 70 70 70 70 70 70 70 70 70 70 70 70 70
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

