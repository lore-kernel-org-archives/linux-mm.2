Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408E2606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFF26B0280; Wed, 21 Oct 2026 21:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A07A6B0281; Wed, 21 Oct 2026 21:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B996B0282; Wed, 21 Oct 2026 21:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D30836B0280
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:49:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57AA31406A2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:49:46 +0000 (UTC)
X-FDA: 85348580772.18.40C542B
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf25.hostedemail.com (Postfix) with ESMTP id A48EFA0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:49:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3t2vZagkbAFICIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3t2vZagkbAFICIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792633784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=JssOmerse6tIPNiF9hOfYFsHOXG2slRdb88lB5aCnO4=;
	b=A+WTvfp7Wjsdhm7bvKjJu8zY4SU6UscBnqbMcdublLlQU2tGPQTI9aUtScVE8bNWTlbh81
	lqn+EolRSrehcwtt42G+BuQBTxtHqZbz23q3PQQkSz74BpKcojNvcPMMsmBurBpjjDn++C
	cKxcnAUmeqVGqrpiR10p3GYOKt5XuN4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3t2vZagkbAFICIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3t2vZagkbAFICIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792633784;
	b=WKKtlvMJm5Ed6yNCBWdXS2d1F30X2O/k28SX0qrNVwl37PTsQhatFAtCt37kpjHOEU7zjI
	9XZIrQK+diAlGF0t/Y+UMBEdGi30DrSXJZu2Y2oBGmYSQ7I+QnRT8u1Y/ORfnLrNKhM8LT
	pmUrDxuv5JlZtRzo/NPsQZuRNLMfx58=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a45b3f0bdfso1866497b6e.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:49:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792633784; x=1793238584;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JssOmerse6tIPNiF9hOfYFsHOXG2slRdb88lB5aCnO4=;
        b=ybcBssnm0570rwYriGTcj0mfHi0NG4xuzoT2/zH7BLq6mMHlW7A8f3tmdW3qJglVVW
         NMTkrKedSFtX6TBmNkIOMbEUGC5Q5sSs6p98APWzCuYivEnysNNQomNwRxbTeUcL+A9o
         /ePP99x/Cv1XNIHbaMxhFlxONe18Muf/P8g+Gr/M9FwMOS2QZaIUlzdAW+srRA0i5oYV
         ExHLtw5vRbgDgDDSO7k8PSlpfKtMXo9lv+xdHnoYPDgUY9ygzLcWXxz0yvpEnUvoqx+J
         PPjto5cJyZsO7+xsf8xdnUO+hx+xHNr7AfrDfcB+Tg0cuJBCaLF2beZ6X2jn+2ioVZNv
         UD8A==
X-Forwarded-Encrypted: i=1; AKwUvBzyXEkmeB0AfwGM0+K12PD9oOp6q5Id3kE6nv9t3QHeqepnXSYbzkII2d9B2YsQJZnyMXpJx6e6pA==@kvack.org
X-Gm-Message-State: AFq9FYJ+7elKflhSsZbm/ccVB9fLo/79a3rCX2HedaknPVQG9uTFVE0z
	LqqxHiKOhYF+rKRl5MvbVq4EnesZQmL578YdQPM5TREu+OGeb0jNWClLr+VFaBIZcrQ655a+APx
	5begjUq7RDZxqgfpJil6rhl0NNQRSo/l2XvDIAa+9mHF39VPKVtCcI5M2HT8=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1687:b0:4eb:b0b9:2dbe with SMTP id
 5614622812f47-5535700ff21mr2591872b6e.27.1792633783759; Wed, 21 Oct 2026
 18:49:43 -0700 (PDT)
Date: Wed, 21 Oct 2026 18:49:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad96bb7.d1c214cc.659fa.0082.GAE@google.com>
Subject: [syzbot] [mm?] KCSAN: data-race in _copy_to_iter / _copy_to_iter (3)
From: syzbot <syzbot+68c0534b26fbda7ed84f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A48EFA0003
X-Stat-Signature: 1frf37hzq81ym6bad8hbasqn1sp4arix
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792633784-573199
X-HE-Meta: U2FsdGVkX18AnY/Ay7FQyIzZt+KJWIPr3JUUclQrIQuHXSUW04ZXiEdMCnFkitjulvShRUbYNMG30+PtM1Ez7Gtyq2vyxsizMspOWgnhjoBzckhC4FhC0b9cYXtkX6m5aSGyNUSApTXxBLOTuuGwnHVYwk44jjySag5nYeaZaDhVqSoPRH/AEMcfVc6XMbSDIXzN9IFGo2oRzMFXVEtIktl0k3n3wEcM0I1TslrysEzhTVfexSxFAon+BDySrtTy0oxcdjt3Hv/XL9sXsLpAKgelOL+gafJ5AjyR4uLhBLzs6QA6PBqm6o7Kl0zuWJk78aPQgpyf025QnCOCXYRzNNNmAvBrCX/bqWJZKBhO7eXHlGllcOaIngpX+T0HmidwqcuZPmN2VK2KRcOA8LsCL0+AFLjzXglym1wHOal8T7lVeAPp5tgxiIS+XLs8rnUXIixcmr11i5fLXZagWGv41x0NqEFKA0WtoWs/egGJaH5IzOWKDpzCO2P1szwmp02j41i+RlxczwGL76sDXBJ9LB6YcJClsvKmUAWgHVFx/ALNg+I1HsZhQDfMdKM+0mMwxb4q9fbJ8Ms55B6uGxgxr4jraZjvdo38Qw06e0TU+p1AWUopOy7nxD7nZsZLU5eEcVLYFP4GEi1A/KBpEmP9km273xuJvSL9Wb/3Hs7wczCbbgRj6NNPYviqPAetZSJ0uIwzdyDQTq1ATvXM9f0K8fZxmDM/EF6RhCVQL5oYEtWFCPFUY6/aWmD7zxq8JxokxuT6tsaYuC0FQ3of7PGnMVkoGzYoc2T7DOPEp8dZnwTG4gtkPeMnjklAnWzdliAYaUDjr0r5PrDkmh48hylE+IsS77mGdasAtZBYCx3c3tW94JFiKIPPaI+Er+oeZt3aMlaC8yCKSVliFzrFT8Po9G+Kq8GvhlfiNK5BTKYhi13OvPmq5lPPToPZBvZPJqhWh0RJTNbPTRRTCurGQZY
 nbknNZbR
 +OQzJgcjbcdSog+wxu4G6aopapvo/MBu2NTzCK+GKjWrnl7m0nEQ/gnvzZoyz+Vw5iuJDkkjQEUkYleweTLk4rQRSEvVNVW38zxtkPxDbpMqf4nMV+Pq+Zch/Pbf/1sDNjY9OxwmXCghx5r0xCKcvITrSTJCQKpCXNZDmgBrGixKSRhhn633uMGwVwK9GEgl1bb6qIYdyDIItNNF96xNqJut7HkPB3gIzP9++iwKUj4A3/OUA1E31KwrTOBNKtFXggraGFiiFztIfp/dT9ZvkqzKgCs0O0eyeQuM6lYtSnI5I93MVDyrO+S6jQk0nYa0TCEGAIOzj3vTbgM/EYF/CBQ6ut3DnfT8dAfFPN8JsDcqMqyr0y2TNP10iw2qgQ9GJuu3285FkBLkKsab+jeeTsgwXsqb71hzBOa6kTyc061Nn+mZ6s9M9HlCwXwXZoZIygbc67qjhR8qIlvH8W5rmb+YZIamjNosSrAjbDdoVsI1bZB2GvduVh2N+8SatFVkw1bJUqNy0vLtQsm/uZMleMhV8e/UvIVG9Ji68vhG0zljRXnZ7mgwcNwKv5KtgIBotQGVvFfGmjR5GFROoVLVj2nnaGn+2lxC2ElMDJd3zDp8Gc3BeOMY3/y3nQRsL0ku9XLU1mp4bc7XoIHL5jCSE86NaasfHXIDEpkUd/CX0VVihHfrx6pbwD4H6mnnCU+Ef6rWz6svtcwUOTa2hEfM6PM4GIUt4puJg77viC2V4BbUH6ZF0HQzoWUmiqEcD63M4P2lCHvO88z/df8IMx9zdT0Nd/SYotMSPSuLnjFOBxYgenedclBw1hnEuuCfCtLkVgly0wvxiL2DcWOLQoQo8L5RbvwyAqqPRxe1sbz9u6T4p/Owkm0cVm4oNApuMnybctJSC91FVm4x+pzO4C42ka6Mx5qWduy3eNXyaBtKx0ItM1WJPjXG9ww7EaYh0g6LtzGsnRwL9J7VJG9WumQYBmDCTYNDF
 r7Aiw5eM
 D8geluzzigDalvDP3HW2KS0znJSXVJz9R8NuPL6rYVF9JqcypjJ+a1Oyad8sF8GhWCcDWUVjwKzThslVELFkiN5wy7bEVj/U7/8l0iXrtZJGubAIijsK1qKHD8cU8v2hJ73yaY3zXBxlFS4+b+EQXEfu9CPftvyVvuG4fooA+6iZza6FxM/H7abo78//5WFgHebTKsV7DNpD+LVZ3Aco2Kg+WEj7CEY13xznOXRCnYnECJwsHrM74W9Sl9RiHZRnauh/VflT3Z2Mm5uFfCvY0kY3XebhLWFO9LiGmLYgxprfjg+H0mqvJFqomQfhrmox9CsjJ8uaz6vn0KlNf3VIsvJ/q2q00ii6gGXzr3uZ8D/FKl6/WWhW2s3R0DqcZTgyUH1Wj3ibjzrS0QHq7SCG7FnRO7PE8zAmlvMSpiQsIB8yqoAGKeyqRnfaDC1KjMqtKHJcckN4csw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot found the following issue on:

HEAD commit:    a804c5742bff Merge tag 'lsm-pr-20261016' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=170e93cd580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0a09745349d136e
dashboard link: https://syzkaller.appspot.com/bug?extid=68c0534b26fbda7ed84f
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/171f09113e28/disk-a804c574.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0f8812b149fb/vmlinux-a804c574.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6349a85938ab/bzImage-a804c574.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+68c0534b26fbda7ed84f@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in _copy_to_iter / _copy_to_iter

write to 0xffff88810d40b000 of 1024 bytes by task 12 on cpu 1:
 memcpy_to_iter lib/iov_iter.c:77 [inline]
 iterate_bvec include/linux/iov_iter.h:123 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:306 [inline]
 iterate_and_advance include/linux/iov_iter.h:330 [inline]
 _copy_to_iter+0x605/0xea0 lib/iov_iter.c:197
 copy_page_to_iter+0x174/0x210 lib/iov_iter.c:374
 copy_folio_to_iter include/linux/uio.h:204 [inline]
 shmem_file_read_iter+0x29c/0x4a0 mm/shmem.c:3391
 lo_rw_aio+0x6a6/0x760 drivers/block/loop.c:-1
 do_req_filebacked drivers/block/loop.c:-1 [inline]
 loop_handle_cmd drivers/block/loop.c:1949 [inline]
 loop_process_work+0x569/0xac0 drivers/block/loop.c:1984
 loop_workfn+0x31/0x40 drivers/block/loop.c:2008
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0x53f/0xa10 kernel/workqueue.c:3479
 worker_thread+0x569/0x750 kernel/workqueue.c:3560
 kthread+0x223/0x270 kernel/kthread.c:436
 ret_from_fork+0x146/0x330 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

read to 0xffff88810d40b000 of 512 bytes by task 13858 on cpu 0:
 instrument_copy_to_user include/linux/instrumented.h:130 [inline]
 copy_to_user_iter lib/iov_iter.c:24 [inline]
 iterate_ubuf include/linux/iov_iter.h:30 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:302 [inline]
 iterate_and_advance include/linux/iov_iter.h:330 [inline]
 _copy_to_iter+0x130/0xea0 lib/iov_iter.c:197
 copy_page_to_iter+0x174/0x210 lib/iov_iter.c:374
 copy_folio_to_iter include/linux/uio.h:204 [inline]
 filemap_read+0x3f8/0xad0 mm/filemap.c:2875
 blkdev_read_iter+0x21e/0x2d0 block/fops.c:838
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x699/0x7c0 fs/read_write.c:574
 ksys_read+0xdc/0x1a0 fs/read_write.c:716
 __do_sys_read fs/read_write.c:725 [inline]
 __se_sys_read fs/read_write.c:723 [inline]
 __x64_sys_read+0x40/0x50 fs/read_write.c:723
 x64_sys_call+0x2135/0x2550 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x112/0x360 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 13858 Comm: udevd Not tainted syzkaller #0 PREEMPT(lazy) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
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

