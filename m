Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1037CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 08:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11F46B0096; Sat,  3 Oct 2026 04:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4026B0098; Sat,  3 Oct 2026 04:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8FD6B0099; Sat,  3 Oct 2026 04:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F92B6B0096
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 04:10:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2173340936
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:10:34 +0000 (UTC)
X-FDA: 85280593188.30.56560D0
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4D13D40008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:10:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of 3d7jAagkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3d7jAagkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791015032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=FU+MzeJUD4jN7QZs0C8lQMkG+5XN6W1QTOf7yTqArOg=;
	b=W5xW7E2oFlTumtBjFePbNYT0l7/icouTKqLPsHjnckqCl7u1c2e7ehlJ+JkWY6g6tK5ZMq
	nNA43wcdFkeCpRXA6tnTof6TbH7XcA883oBoRYFo6rlgEm7utj1kbbBDVHBs68Lt9n75VX
	8MYDR5jE2+YT/P9ohC3cro8ivZdM0UU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of 3d7jAagkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3d7jAagkbAEg289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791015032;
	b=NbdKRjnc14iAFOcPo0R9eFi7P3qhAHDYLa82j7RqzfW0VBj+6sEZAPSmfowapWVUKSW3nA
	JvnhjZ6MtVreaOMoPCbj1tapRNDeljrbSOVH4HIqku3A3bYVdZF00lRA2ljswGnWfBNmjU
	HaXOOcPwn4nAseAVIndzufRO/h8yqRk=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b37620eb73so349516b6e.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 01:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791015031; x=1791619831;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FU+MzeJUD4jN7QZs0C8lQMkG+5XN6W1QTOf7yTqArOg=;
        b=akQbgTIiAMXCILvQWgi997mKBBkHZ2sppja73/X/2upl0zkiEjoch8j45TkMAZCfba
         VffNM4RS/jJz7Qw6ACUoWc/e3sagznCq+N4ww4ocnfA6EtwdWgwTtwrt5BTxmTdxBzK8
         JBqx+s/g3Y6yt2y4bFUgfOoWxYRl3oQ6oBTw5O4+nM2w/0E0uCMKHb2reXkr3DWcq9dZ
         jA9tmy14Jn2dQKt4DRR4r1dvT4c+r19sonoBjPDLp8n90Zs71RC68q1rLFWmCz4xL+FW
         qVhkvQ9dcAgQTmiCR2zlenlMlpXZBcX135WmlouS4mKO7eOgRYi05Aq/NlCOlRNSyIxl
         28xA==
X-Forwarded-Encrypted: i=1; AKwUvBwQnSpDPD9ebZcqhi0Q/3bCb4+4A/dhSIRy4ZQAD9HAOjpzQXbhmhUyzda04dfceVUY8Po7dHSoLg==@kvack.org
X-Gm-Message-State: AFuF++n/+EpA+R/LWZsNxScL9ebZLfwDJXU47w6z4WFX+u5GIHhRpOao
	UkmejqTqQEAI1TuKonzF/cM6r0LMVFgx3qlmfpXcyFTWYmCHa56mBIH8d+7xj4TIqPxoivhVXFZ
	lkL94Ptu5EhS8y/mky7O8uUM+MhJJB6eEzHgfNA+jTxHKIBV+YqCBGqKzIFc=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2383:b0:4f3:2f34:fc51 with SMTP id
 5614622812f47-4f5267483a0mr4086203b6e.8.1791015031357; Sat, 03 Oct 2026
 01:10:31 -0700 (PDT)
Date: Sat, 03 Oct 2026 01:10:31 -0700
In-Reply-To: <20261001230219.818128-1-praan@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac0b877.81dddff3.363068.0005.GAE@google.com>
Subject: [syzbot ci] Re: iommupt: Introduce IO page table shrinker
From: syzbot ci <syzbot+ci374b2971a7526572@syzkaller.appspotmail.com>
To: danielmentz@google.com, iommu@lists.linux.dev, jgg@ziepe.ca, 
	joro@8bytes.org, kevin.tian@intel.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, loganodell@google.com, praan@google.com, 
	robin.murphy@arm.com, skhawaja@google.com, smostafa@google.com, 
	will@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ks99b4ehaez3sykrpm8ghz3mkbe8cy5o
X-Rspamd-Queue-Id: 4D13D40008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791015032-253099
X-HE-Meta: U2FsdGVkX1+qlbmDGBkrSfTRWctBVEkoCvmrVG2n5iJiSl33DDOnjXsYMx9vHSyrIc3fU5weoiA646ahN7G8Snq6WQqBCOzH8zYPnfyB9JnlyfGeukdntwQUavMVU9qEPwQAXFrulNSMxk41TA9v0BXZV6vhiFbWsMM9nR7HnpjYgoMmHxdQt+nid4rvoPC9wfQ0bsJxW02EQXwAUXX+2go9/3RRYdKabrb9jyFhNqgozVaUEQ2jU4Z2pWDHm39CCgMN0hXVT7Y83FXEPvOjiCU+H3zauQd2RFAOzxNSvkYjbyUJOGoPSOtb5IpNfv3OJ50Kt1PZzXKuRJB4v70WO049NFJOFdHrAGgVEbxp+65yH/IDDrfA22eQYBFT4EKOtKzEtKAp2ZMzXjrptRBpHagsN1aOGd965ixuk1TzpWEHCgDnZThAUqVUi4LeogUD9UKYsfrUGxvQjdLd7Zerm05a2DYiH2HRoWZ49/zJ72sR7KE22km1eGpP+ZgBXXYhDIj1Fjq2QwzUY2Sa863rIPTHMZ1NRE7MZF+0jv8hVJ1S6PgC2s1vvpXNH/nzq0q5tlf8jjHrFFfBkkPJGtlBBp0h3z6HzZkpw91gv/AU9F7vgw/KvhHvW0PHmOc5TY2hPLlLNkyTaE3f768gSnuxULcl3mbolUFrPGEsY5R1DX3deqgRDE7JG3oI8jFx9jZtQDWZzOUuNr681XlRMNfAfn6sBUe1M/MQ+98Lkl53yI8ICUG0NbZS+wnuNPMvpc5evQ3gS19SOPGZexlZS/kCkB8SxgmYGbN1up7V2RkjG46VhhPRxAVsWkuFjVJbRzWx4mfRl0yJN2iQJWcxxINwZNH/tAmr/NSyaFVw3BRc3FtKDMLokNa1/mGbebx9dISQHavkyOnQ0C3cRkB9acM2mYZ99g8lkNbhR/wOlyUzyUlyG3HFqtQeYtw4swxwYsCsyipeb6Ml7WilFEIva9x
 nzNHOWaq
 BLj6KtBK7svoBShve3b6D4aySMlEV/djWyv68IHIEd8EoDjMWH6K/+t/IKIhQ3z2KP5ANVE+N9IwKnxVG0xSPb1gbFBcoALSzEZujQABnUJQ2E1vBlzjCRgvbt6HftPCKBqatMiKmPkn3QNXHOU9TZRAdqDrTiEG3d6WX5YJJvjFSZo9LBmlbwNYuiu8LToFN2M/sqcvQgyh+72NDDdxGUrFUtYKilxsJnC7Xch9nmEjKAg0EQHtyBz0N84xIkhbQna2XZMOJ9Bf5BwchtgY247rZoWwiEFW5WEdoaVVupaCoFYkvxCz3Swi/sLWtBq4dOt7yEpM10YfgmFgjlvt3Y+dRSKw5htKW/emASNFd55XaaCzgGeEaydHs6HLmrWfi9d8NpEuY62Y/EBz5saXJVqnja1Mf5kX9V7I2He/g7sCvoOh3l0MiO/ZDZrKFrbazeBVIrKo94cfuWGmkaKhPkLzT9hciEYaZGNZ2H1Yy5cGXgAPFRG5HBkGeYqFSB4UPMlla9XfuR6gQJanuRb8KWlglJdmW8WXsfX9HDNBxP7QcOt/cnKxuN02aUeb3rbpgN8Vy+x8vQlZbkYZBkuUxZeSM+xrdCoxGm38gK2I6DCbvinJ2HoT+z7lKsgoNeNmHpdrWtwUXBbZ5ZeveHL0ohJVX4B+42HhNRuDWgGQEFWJHdtutWbo8lLpvDPiDP3QFo2xTzkgb5JdYzypoK7vUxCu18+Kn7yzPRnMul56o+G2GSegkZaZCDQXnHjGJK4LVKk2gD1C+01uM4j1NaSTzljdKbvZ7//z6s5fkHQQkfu26Ewq45jBrTX4H75vgiiTSK9D6O1ov2XI+fdqwo+vhJeSC5LnjlB5xXHgCr3s3tVcchJEbH3LobGKzuaLlo5LB2fipkc/a+sS4l3mQ9zi7Qy8BQwDXMVTzdqC+jPdliCwOCKpI+KlZRHaQvMWQMKEn+Xq8gG0m1X90Xjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] iommupt: Introduce IO page table shrinker
https://lore.kernel.org/all/20261001230219.818128-1-praan@google.com
* [RFC PATCH 1/5] iommu: Add reclaim_list xarray to struct iommu_domain
* [RFC PATCH 2/5] iommupt: Implement refcounting logic for Leaf entries
* [RFC PATCH 3/5] iommupt: Add lockless sever_branch helper
* [RFC PATCH 4/5] iommupt: Introduce lockless page table shrinker
* [RFC PATCH 5/5] iommupt: Return real page count to the shrinker core

and found the following issues:
* BUG: spinlock bad magic in xa_destroy
* INFO: trying to register non-static key in xa_destroy
* INFO: trying to register non-static key in xa_store

Full report is available here:
https://ci.syzbot.org/series/792388cb-7e39-4d83-8008-54d31031a227

***

BUG: spinlock bad magic in xa_destroy

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/40ee62cc-4991-4840-96ac-e3f70bd4b70b/config
syz repro: https://ci.syzbot.org/findings/96c389a5-7ad8-436e-87ca-df20279f6360/syz_repro

iommufd_mock iommufd_mock0: Adding to iommu group 0
BUG: spinlock bad magic on CPU#1, syz.2.19/5813
 lock: mock_blocking_domain+0x70/0xe0 selftest.c:-1, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
CPU: 1 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 spin_bug kernel/locking/spinlock_debug.c:78 [inline]
 debug_spin_lock_before kernel/locking/spinlock_debug.c:86 [inline]
 do_raw_spin_lock+0x1e5/0x2f0 kernel/locking/spinlock_debug.c:115
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:156 [inline]
 _raw_spin_lock_irqsave+0x4c/0x60 kernel/locking/spinlock.c:181
 xa_destroy+0x59/0x2e0 lib/xarray.c:2393
 iommu_domain_free+0x25/0x170 drivers/iommu/iommu.c:2130
 iommu_deinit_device+0x353/0x5d0 drivers/iommu/iommu.c:600
 __iommu_group_remove_device+0x1dd/0x270 drivers/iommu/iommu.c:764
 iommu_release_device drivers/iommu/iommu.c:783 [inline]
 iommu_bus_notifier+0x6d/0x2c0 drivers/iommu/iommu.c:1826
 notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
 blocking_notifier_call_chain+0x6a/0x90 kernel/notifier.c:380
 bus_notify+0x143/0x180 drivers/base/bus.c:1086
 device_del+0x740/0x8f0 drivers/base/core.c:3982
 device_unregister+0x21/0xf0 drivers/base/core.c:4006
 mock_dev_destroy drivers/iommu/iommufd/selftest.c:1042 [inline]
 iommufd_test_mock_domain drivers/iommu/iommufd/selftest.c:1108 [inline]
 iommufd_test+0x3e03/0x6360 drivers/iommu/iommufd/selftest.c:2109
 iommufd_fops_ioctl+0x465/0x600 drivers/iommu/iommufd/main.c:556
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9ceff9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9cf0ea9028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f9cf0225fa0 RCX: 00007f9ceff9e159
RDX: 0000200000000100 RSI: 0000000000003ba0 RDI: 0000000000000003
RBP: 00007f9cf003506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9cf0226038 R14: 00007f9cf0225fa0 R15: 00007ffe0de56058
 </TASK>


***

INFO: trying to register non-static key in xa_destroy

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/40ee62cc-4991-4840-96ac-e3f70bd4b70b/config

iommufd_mock iommufd_mock0: Adding to iommu group 0
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 1 UID: 0 PID: 5775 Comm: syz.2.31 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 assign_lock_key+0x133/0x150
 register_lock_class+0xcc/0x2e0
 __lock_acquire+0x10c/0x2de0
 lock_acquire+0x115/0x350
 _raw_spin_lock_irqsave+0x40/0x60
 xa_destroy+0x59/0x2e0
 iommu_domain_free+0x25/0x170
 iommufd_hwpt_nested_destroy+0x4d/0x1a0
 iommufd_object_remove+0x35a/0x4c0
 iommufd_fops_ioctl+0x465/0x600
 __se_sys_ioctl+0xfc/0x170
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f593cf9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f593df41028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f593d225fa0 RCX: 00007f593cf9e159
RDX: 0000200000000300 RSI: 0000000000003b80 RDI: 0000000000000003
RBP: 00007f593d03506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f593d226038 R14: 00007f593d225fa0 R15: 00007ffe5c49ab68
 </TASK>


***

INFO: trying to register non-static key in xa_store

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/40ee62cc-4991-4840-96ac-e3f70bd4b70b/config

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 6433 Comm: syz.2.305 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 assign_lock_key+0x133/0x150
 register_lock_class+0xcc/0x2e0
 __lock_acquire+0x10c/0x2de0
 lock_acquire+0x115/0x350
 _raw_spin_lock+0x2e/0x40
 xa_store+0x23/0x50
 __unmap_range+0x748/0x1190
 __unmap_range+0xbed/0x1190
 __unmap_range+0xbed/0x1190
 amdv1_mock_unmap_range+0x418/0x5e0
 __iommu_unmap+0x138/0x740
 iommu_unmap+0x114/0x200
 iopt_area_unmap_domain_range+0x279/0x310
 __iopt_area_unfill_domain+0x8a2/0xf30
 iopt_table_remove_domain+0x7e8/0xa90
 iommufd_hwpt_paging_destroy+0x1c1/0x2f0
 iommufd_object_remove+0x35a/0x4c0
 iommufd_hw_pagetable_detach+0x564/0x6a0
 iommufd_device_detach+0x1c/0x80
 iommufd_selftest_destroy+0xae/0x130
 iommufd_fops_release+0x186/0x3b0
 __fput+0x418/0xa50
 task_work_run+0x1d9/0x270
 exit_to_user_mode_loop+0x204/0x770
 do_syscall_64+0x328/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fed0639e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff16748678 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007fff16748760 RCX: 00007fed0639e159
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 000000000001312c R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b31420000 R11: 0000000000000246 R12: 00007fff167487a0
R13: 00007fed06625fac R14: 0000000000013174 R15: 00007fed06625fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

