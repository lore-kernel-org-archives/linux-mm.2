Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F7F2CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 05:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1CE8E000C; Tue, 16 Sep 2025 01:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B98E8E0001; Tue, 16 Sep 2025 01:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF6D8E000C; Tue, 16 Sep 2025 01:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF8E8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:40:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC8D9C0840
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:40:29 +0000 (UTC)
X-FDA: 83894013378.26.A3A6075
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2C44AA0008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:40:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3S_jIaAkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.78 as permitted sender) smtp.mailfrom=3S_jIaAkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758001228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=QqbNwQGwcLZCF6E/RzvcFo4KBG4VYoymvX8uP1Ymm8E=;
	b=5yYzCidX0SmWhp3of6b9csRD20DWKQ2iAkDqVIST4whBXXSOF1utHukqhLFc157c7jOsqa
	a9IOPEzWF8KkN+t5R2FOvnED7RNYbjLPvbIW7W62y/+WRv+lowtEJVgeF4Fxy7kbPEJTLO
	ELvUXrqrAze5EAnrlYSU0HoHlgXaaFY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3S_jIaAkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.78 as permitted sender) smtp.mailfrom=3S_jIaAkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758001228; a=rsa-sha256;
	cv=none;
	b=gAk12Es6ifdVZzWB3627D0UuKA01kgMSGD/g8NmRArrCSJ+xITJTEbURuKAPEPSAqBRrDf
	mol21464jGules2JlRjZZvBAqykv2gACyIWySFb0MZVPFoT8ZDk0vr3Y4417psRin+Cclp
	ZhHEX7dMpeWSj4n1AZpXJLLAv8brhh4=
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-889b8d95367so549448539f.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:40:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758001227; x=1758606027;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QqbNwQGwcLZCF6E/RzvcFo4KBG4VYoymvX8uP1Ymm8E=;
        b=ZfTOK6E1s8KQ2Tw5Z/4U737a47G53PZVpzS6ciOiZVAyLisF7dAbUwvK8unfHnJP15
         t4IF6UQ0qyRs8VFlO4cLPlCo3GgUVkkWifL0YiLB3AxfoK3hMJKEWdClZgKKbfoaTaOp
         8O8meY81tTSx6E74KYeHSOjIV11TozCODAh6NJ2kdR0+dAHsgxGMGe7yhwH9WeqK0AGx
         94WdJ7gM8EXrn55R5XngPGhEjJoQXnaNbCTSAUh9PH1BYc4UHCwsZh9fWNSeDrCyMqlF
         ZQzU/7hgWy7e9/Taf3VLkayBPaFdG6TItNy3EJC9a6OuXy3VSvRlUdUTCvUn9ydncJEl
         6cQQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+F0BhugGGkeWqBsGEs/JH1oWymjBwjx7EsLS8CMk1/zMqwj/wrYE+MLRTLz32GYEpxj+n8wu69A==@kvack.org
X-Gm-Message-State: AOJu0Yy6CKr7opZxq7Hgdn9eE54zEOe7megFfpV9vdeUCIRXjqWE8hco
	1IwJ9JQNWoXC+eBzrDwgkkS64WdZOotkn0CkXce9JuoDcNtgHNkYF2myyERjzjIyzPjlWeXJeOa
	zq0QUZVYRLxwfDTWgdvFnObe7hlZe9yIQMV0YgAmayYUVqoX4OUXd2Jzw7as=
X-Google-Smtp-Source: AGHT+IFfl5F6ZvVpRZ5U1Pi4oGshhXhgdiBV7Hyhw1qW6ik58aa0ZJeMEPOuwyAq+ilfWZJWBEU0f6y0VssawWJsBReHlJ10p9Q8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a07:b0:408:c77b:a7ea with SMTP id
 e9e14a558f8ab-420a417433emr139512185ab.22.1758001227240; Mon, 15 Sep 2025
 22:40:27 -0700 (PDT)
Date: Mon, 15 Sep 2025 22:40:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c8f84b.050a0220.2ff435.03bc.GAE@google.com>
Subject: [syzbot] [mm?] kernel BUG in __free_one_page (2)
From: syzbot <syzbot+43235b3002d58852ea38@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, chrisl@kernel.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, syzkaller-bugs@googlegroups.com, 
	weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2C44AA0008
X-Stat-Signature: g5ims7zocyfdge9dguhb6fachogn8h4f
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758001228-840226
X-HE-Meta: U2FsdGVkX18+1s/xra0VrlG37oUYuDGEElDctIbw0GdWaPYoxJwdgUf8CUG2nppi9rjrqZ4mTEx3mQ4RfD/Bu5qmzpR4Ksv13vVY+e/hSuiuI6PD7U/3o1OfK8NmM8Lj9qphAV4j61LGHrlvhVfx/FZ7SdBJc22EzV8UL2/cltKW63J1nsOGTbMrZn2gOIeCAiBJ7KedgD4LKjw5d2f7D7XqTpXywiBedI1t8tMSHZJFVF80xVw8oxF422X6SUxLJwyVta5X5QvwTz02nNC45ZU6pZtZFYlmNX0/Zy2kw7JMBpaNWQTyzHb3mQ+pYgeYpjBkzqjxEb8kZ3CQLAkTlUvawC4tTvJ2Xj8n5hnH8kBcwe2BFybYJxkWHaj+WA223aT8Ysmv4BArpMvfGyr1oocfO0qVJnuaBeX/jBYrpjxqBjcuLbEBKQsIQt870gZ+pBdK1ZJs4L11Lpehu/57Ca1AxcuQcQ3OIVflF1KYTq+vEmlQXPbsK9b3cT6qA92he2T1ZgRWMGEWh4SPXZCAIMhKvC1fH69GxFOj+IE/iHOq9t4B5OMUm23xFllZ6xVfLURuHpg5NftBUu7bjBpVhdlHCqngoxGA5DoTmlF5Q7qFbkoVfBIZPLfZnFwzdnxGWHlSFtiDnuwIg/g94HlkHA0+KxaWsihOhtjMpKDPWx0gBGNb4asc/a9igH7eYvdSCqronGZJPCp5exvrBJE82mYUhCc0vrZxV39lbTHJSkdOX0K5u0oisvPP9VEEsqBwYHITvO3PtUlokpU3Hf3KpSFAn1AToscL0DgGk9skbN4hDuGMQob/ynRPk8Pk5HmclTrhWOIjcDmvMMMZrZhJ8Je3c03Hpoz/at6kIRfa1vRO7SOuz9w9t34pVsmjWOlsqXPPDj6euygbzTEFGJe/QRYCEW2Rh1GMGc3jMEJeJDPoe6ft/jjhNr7ZuTbfnxYRolxidUi1zawiR5JmEEY
 1rRGbdGo
 lf6MmsF4zw8DtPOHRE2cIW60Mi0c4halahxQsbkuDY8oSmwuagytTsNo/Zm/S9vnx8WmEOKEc6QCMJyCsHimlDBWU2elCuu2yrhsy6mKeCLmKjTwL4X8034c+1pSEsgzGGDPCd/CLMbTaLUmZy3MrStPguo+KrAhn+B4T+AytGmv27qDR/BS1/DBm9qlgjt/X9lB4hFFFk+31c6oY8i/l7d4tgKAVHEHCia78Qyvmy580YGwLSgM9sVKsP0gcvL1p+Qc1CVx1Qlh/Bi12iI/+GeBe3ALMil5Nv3uY3BsYhnbOvV+2YqnXi9/Nlsyfgb6In1R+Oa/RQ0DoOiaYzwofLxcr8U7JcXsWSf+AWlVYSmU/b1Gn5OjQzRSeiUcmLArLBHP8KMHIz+d60ZlTTyqSmVWlMi3eyGe22I8FT946SobRrIYavACawji485XeblrwPt+S0+lS/ktAUUSMKZYvR7OsGydwpc+e4fxMIyN5nZdq/yDXbqYUeJ+DSj5FxM3Q+DYkqQpPqRT+BC1Y8a3rb0PYWwntbm2nc/+1elIIbLgsNShHlLWF9SzPBJEzVj9j1g5K+K0tnaZgfUeU4Er6whxxaOYKbwJM+zqGLB7MIcHaSb5byCBkKad5iElkb7O9rD5eiNij2HvMGAfEwzKZt+Sc0+rMRrRqLbgzHxdwsc84QHAbha/sKCRunpd34xm6iYrIH9WQRuXJ3NGINL8qqfa7F81eKGnO9GqpndbqvOsepFI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    8736259279a3 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1107e934580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9ed0a6d7c80843e9
dashboard link: https://syzkaller.appspot.com/bug?extid=43235b3002d58852ea38
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137f3362580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109f6b12580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/025c082a7762/disk-87362592.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/606f903fe4d2/vmlinux-87362592.xz
kernel image: https://storage.googleapis.com/syzbot-assets/23ea2634f398/Image-87362592.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+43235b3002d58852ea38@syzkaller.appspotmail.com

raw: 05ffc00000200000 fffffdffc3207008 ffff0001fea8cba0 0000000000000000
raw: 0000000000000000 0000000000000004 00000001f0000000 0000000000000000
page dumped because: VM_BUG_ON_PAGE(page_count(buddy) != 0)
------------[ cut here ]------------
kernel BUG at mm/internal.h:664!
Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6702 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 634000c5 (nZCv daIF +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : page_is_buddy mm/internal.h:664 [inline]
pc : find_buddy_page_pfn mm/internal.h:716 [inline]
pc : __free_one_page+0x8b8/0x988 mm/page_alloc.c:969
lr : page_is_buddy mm/internal.h:664 [inline]
lr : find_buddy_page_pfn mm/internal.h:716 [inline]
lr : __free_one_page+0x8b8/0x988 mm/page_alloc.c:969
sp : ffff8000a0ac71f0
x29: ffff8000a0ac7210 x28: fffffdffc3c88034 x27: fffffdffc3c88000
x26: 0000000000132200 x25: 0000000000000000 x24: 0000000000000004
x23: 0000000000132210 x22: dfff800000000000 x21: fffffdffc3c88400
x20: 0000000000000000 x19: ffff0001fea8c880 x18: 00000000ffffffff
x17: 3030303030303030 x16: ffff80008b0155d8 x15: 0000000000000001
x14: 1fffe000337976f2 x13: 0000000000000000 x12: 0000000000000000
x11: ffff6000337976f3 x10: 0000000000ff0100 x9 : e31af28274316600
x8 : e31af28274316600 x7 : ffff800080563530 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000000 x3 : ffff8000807de30c
x2 : 0000000000000001 x1 : 0000000100000001 x0 : 000000000000003b
Call trace:
 page_is_buddy mm/internal.h:664 [inline] (P)
 find_buddy_page_pfn mm/internal.h:716 [inline] (P)
 __free_one_page+0x8b8/0x988 mm/page_alloc.c:969 (P)
 split_large_buddy+0x108/0x1d0 mm/page_alloc.c:1512
 free_one_page+0x94/0x2e0 mm/page_alloc.c:1559
 free_unref_folios+0x6b0/0x1454 mm/page_alloc.c:2959
 folios_put_refs+0x608/0x718 mm/swap.c:997
 folios_put include/linux/mm.h:1419 [inline]
 __folio_batch_release+0x78/0xb0 mm/swap.c:1057
 folio_batch_release include/linux/pagevec.h:101 [inline]
 truncate_inode_pages_range+0x2f8/0xe18 mm/truncate.c:383
 truncate_inode_pages+0x2c/0x3c mm/truncate.c:460
 kill_bdev block/bdev.c:91 [inline]
 blkdev_flush_mapping+0xfc/0x254 block/bdev.c:712
 blkdev_put_whole block/bdev.c:719 [inline]
 bdev_release+0x478/0x654 block/bdev.c:1144
 blkdev_release+0x20/0x34 block/fops.c:699
 __fput+0x340/0x75c fs/file_table.c:468
 ____fput+0x20/0x58 fs/file_table.c:496
 task_work_run+0x1dc/0x260 kernel/task_work.c:227
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x524/0x1a14 kernel/exit.c:961
 do_group_exit+0x194/0x22c kernel/exit.c:1102
 __do_sys_exit_group kernel/exit.c:1113 [inline]
 __se_sys_exit_group kernel/exit.c:1111 [inline]
 pid_child_should_wake+0x0/0x1dc kernel/exit.c:1111
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: 90052f41 913e0021 aa1b03e0 97d585d0 (d4210000) 
---[ end trace 0000000000000000 ]---


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

