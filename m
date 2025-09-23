Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60678CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 09:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4EE88E0017; Tue, 23 Sep 2025 05:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFED28E0014; Tue, 23 Sep 2025 05:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6328E0017; Tue, 23 Sep 2025 05:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EAFA8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:03:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A95714041E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:03:32 +0000 (UTC)
X-FDA: 83919926664.07.6E139D0
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8F1A440018
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:03:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3YWLSaAkbALwu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3YWLSaAkbALwu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758618210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=qawIWc6HWAuv7hppdrKNRGMrCqrgNjhh6jQdGpOVwNo=;
	b=FpXTw3sUPcbPx4pS1oq/OSct2QuC5vGS/aZSL7pPCrKMxIwvkAJYwirBKHAj00oY21q39E
	ma4buKzUlVXJRkRz8BYQ/Tf4czwnngGnAOof4AIChsp9aqoK8Kpk/KB+FBY9lRQeSJ1XKO
	1DFP68bMDWH4wq6ZG/sW0AXzTBXPDtw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3YWLSaAkbALwu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3YWLSaAkbALwu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758618210; a=rsa-sha256;
	cv=none;
	b=7Q6nu6tLWDsppCimY+i3SsU1clmt8ghKLUHBKooBSRUe95GaOhTNp1YdGSIxvqeNL7wa4t
	5xzREtfDVUTSfxmjwoG8MHm8KoXRq1l2uzKXwUQOQAUvw4oene1HExTjAuzhwLFwzsFA6E
	sKneY0v6aS6vCEI9xlwifobN1Oa0Nvs=
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-42571449766so55912335ab.2
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:03:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758618209; x=1759223009;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qawIWc6HWAuv7hppdrKNRGMrCqrgNjhh6jQdGpOVwNo=;
        b=dl3UoJQmcwX7F6AgXWFnVZnHl36G2j7NgH6GCoNAA+XnMAllLESIVWgkctRJnS26zL
         clisLKGyV9Npn4Ro6vv0LQnEKSVTW1UCipAGhXrWa/OiawjCmdW+9++xUG4VpRGSgs++
         KpuZFswg8bQv/KODSZMWIPnifFw8kXDlHc2+RTj+eTnthDTwdF1jw8BcTPOHG6tfNYxA
         nBld7tgz1g73dg8crZsvYNAOGjU126+N+TlNoUwJcmMEL5eKJ980khZja4h8Cml/6i6I
         Bft23c6Bd9mPSgWDpr9+yXzo0xY4J01My3Fk7rsLeCMAArUsO3YO70jlYv3zsMwtLiOI
         Engg==
X-Forwarded-Encrypted: i=1; AJvYcCXRSbCr6vwiuc+3Od2mmlZ6VVjBhUeeKzYuoQ/1NbWEAfsqE1Tp8ZxjRtDf3c/YiGvjmSsNmgn/Aw==@kvack.org
X-Gm-Message-State: AOJu0Yx7pTtYnuV+AhlwhzmK/1jVGHTKunHWCBH0X0HRKQ+Aake0EhY+
	7m2U+w3zjHQbIVwwZ/aRkb2+lfRhJNYS8XkbOARCNAm2IcH5q/P9pV2R8Djx3djOySmRyMurszb
	nHObpamNPHhO3WPKY12d0EI1eNPhvFTDYgm0Fet4j9/bA68tl0uoZ26NG/wo=
X-Google-Smtp-Source: AGHT+IHJlQAz5UGV5R9SQO4x/bEQmDqd47KX/iH2j0vkgz8h1aDacoLJGydUzrLZxCA2KDvIrVwKxzCeP+1pywKQVSp7kcRis0tr
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3f0f:b0:424:8d44:a261 with SMTP id
 e9e14a558f8ab-42581e2509cmr27390335ab.11.1758618209571; Tue, 23 Sep 2025
 02:03:29 -0700 (PDT)
Date: Tue, 23 Sep 2025 02:03:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d26261.a70a0220.4f78.0004.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] WARNING: bad unlock balance in hugetlb_vmdelete_list
From: syzbot <syzbot+62edf7e27b2e8f754525@syzkaller.appspotmail.com>
To: david@redhat.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	osalvador@suse.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8F1A440018
X-Rspamd-Server: rspam05
X-Stat-Signature: 4t4rbpima41duiih4xush5qbs3yzc9s1
X-Rspam-User: 
X-HE-Tag: 1758618210-575396
X-HE-Meta: U2FsdGVkX18ty9h/3PRxjGKjIdJzmdrH/bIktg5FAIe9MlOurO5C2ttJf5ZzMnXFqJEtVhGJOu6TAdPn/t9tGkl08mvtXO11ZolHYDjw/PBtkK6pq8lehiaTusQ5lIsVaa+/L9vdzqTf0BnxWxFaz/DXRm73RX7eR8Msyb4mZ//2Ph9Sjk4AAUveHNnXXzSHbSJ/Y9NU+m+LrHkL4GiCGc9/BvgZTw2VoFaC+veAlEEAt+EaxYQI9fmfrM+dxvMRq1kvpMhnbtd19ddDPMe92NEJaSBwK81OWPs5006G9eFj9xKmZyjOXUgskE69lqO7YZSa5r6umhle1PSh6OookielMnIQt0XwXJHZfj7st8yWXs9Pat4YPbI702w1TYQlE74dldWsv2egau7AMnekkFYIwffkEW3dF7hSoIENy7eKNet0fVtf/AOsCa/bJbyIfslkMVcE0sn7bMcGxzBWzi2oebmlI2yaAyAyKVq5RyoZwbBN6OTZNMFhix2NI1GOfi0aJS7IAS/qp8O+2cAernN/yhbPrrkoyKUZ02GCBB72D3I/cB+PI3pJh3L6jMYD/DTp9V/tkBRxhoGqmbaJQzFm/W4BZOtxFwvHw6Q/xUfbt9uEvBoYkACpIA+LOuW/WWZc/wAid4gGj4e7KYKwyNud+36+Dur+GVYOE+WuQAgaIg9TUL5pi+zkzRNHHN4Dlwqb7PzTM4ssk2//yERG/alk0m0vgy9CXPRzHwOxCEOu5968m014wd91kn7nOfZErQvQc2cYR2+4xzgiYbcuM9C78zttJ1q2IcJZVuHRx0ozMBwLVw1Uge8bsA9oa95ffAIsITofGqsXWle7CTunbESLV1l3d6y5Vu++4C0FNA82aWQXUgncgUKJoM3FSvsYD42o0FXCPdj6/Opntj5ICftqsONtG3ZhkPXTko9VIPk86yhkp2Bu7dg0Gto0xd7Hy31CUHefbZ/WgFvYUcD
 hKP9NNr0
 L8uhw5C9p9aHuJnAHGiDiDPpesECoVtlWKdvNOe/wd2Mkldi7lmnVcxFP52NTDN8waz1XuYp/hTMBsjZXlsmssmBfYiu0d5WOvick4siYaaa5vNxEjjr4N6M5+IXsxBeafjlB0mNxQ6COmVtYDZjNvbIcC/i367zpNgqMNhn1nuOpU+wSb0fbvydR+7WJzDSykEBvRDdLlbF0QaRCpS8OF5uzXnEl8Cqo2mVwuO3lFIeN4WpPCoOZdh40zvUUzaNZYmSNUObXx2peWNAYE+NV4qKu9Adn+IUYPW7M7xzKFxhVNHMesSIYONYG+lOpI+4eRE8dclTg2ZGOAbsvdfDsejrjlsRKLiMooCNLsZyBJW1auJXehGIH2tDOu6EQzO4SvObrnyJvqyX0N08dzEdiFJDgYxD2laIfXZlyqGC245uZAKK2FX7MDijoFENG45o36wSonEQmHRMxMQZ/1dh4AI4fmjqpMMyUPuIQmWx/mpnsUqKjDN4PTFBSlwQTqwlS2XHKbdaY3l4MJveYWxRG5ngd0osk8tFynz/se3yDJJRrITc/qr7aPmIjTvUge8gBw8vs5SySL0FXfyNDV9yShOgjwyYcU2Ufm4iVk/6t/8np8LF4OVAqbD8OqnHOxAf/baSzuFmYGYUuaKhGeOUehI3VLpcs24T6nvWbeyAKQuLUm5Is47Wm7ets79p/6fBco38ScT+Ka/eo1LzgGwbyWBwwaF7VYk7Cwsaa/BP//SnpGqUxx/j9BeNatE4tgj+cp+fT3d40Bma2S4YOuZmw/jGdXLu7BDhkMT4MVtTg7FGNGOwnoCK1HIiEs1DEK1Wz9zUW+IVRWNrwiUabdBb77V9HiGkA/YnlYHJyHXSA357guuDOExt8I/xtdoXzYO3ZhMsD+zYQqGZiFwj4GNzWdMejgDTtd7wkW4/NiPhDnbWd1vPlveK0IRyOYu8miXY61SkyoI0hKWZmnB2I2WeV4qkDw6Um
 db1kQB25
 fiO2/lSFPjanDhNPOu1Q64KMRI+fR9W2y3j7b8wyCki8FKiLWQDe5FiKTBueSNLdLYtobR2HT82sABZ+C1oi7cfcD2LJaesKV+LDBVtR0kPOv3TBYFuDKzaAAo15gMpItTkiT7MJg8IVGZwVgfca23+lCJhToQrCin8e1Q3CIR5WgpXuuXbbbarF34KR8oguV6X1XO51q1RNrR6v2e6wPTPKqJljLd8QxE4HQTHriLzLWQ7pA6w1KDwxS7q2pekH13YlPMAUabYxArkIis0Y1jUq4KbLFLmmAKC0N47NVCgjaWJFLVnlXiKm/7vNjogZ2JxVSDDePjFuK9B7bGDBJ3zs+VMvfwHrgAzWl6PVY1Riit8VTRhBVbR2iiDf1MoQvn8xZ0rEL1m+rZX11CGHNug9Y3TyU7P74DNXwu5VfTZ5BI3fubXGT/nE/ZsraQcFtWjGRAcyspUw0nB82y/ONxMQsz6gLxmphGNxZM0JV+3/Xt+QD4Ba31bzXadKcksj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    846bd2225ec3 Add linux-next specific files for 20250919
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13263534580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=135377594f35b576
dashboard link: https://syzkaller.appspot.com/bug?extid=62edf7e27b2e8f754525
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a118e2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e204e2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c53d48022f8a/disk-846bd222.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/483534e784c8/vmlinux-846bd222.xz
kernel image: https://storage.googleapis.com/syzbot-assets/721b36eec9b3/bzImage-846bd222.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+62edf7e27b2e8f754525@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz.0.8060/30977 is trying to release lock (&vma_lock->rw_sema) at:
[<ffffffff82903959>] hugetlb_vmdelete_list+0x179/0x1c0 fs/hugetlbfs/inode.c:501
but there are no more locks to release!

other info that might help us debug this:
3 locks held by syz.0.8060/30977:
 #0: ffff88807d8da420 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:508
 #1: ffff888034404648 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:985 [inline]
 #1: ffff888034404648 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: do_truncate+0x171/0x220 fs/open.c:63
 #2: ffff888034404918 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:548 [inline]
 #2: ffff888034404918 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: hugetlb_vmtruncate fs/hugetlbfs/inode.c:639 [inline]
 #2: ffff888034404918 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: hugetlbfs_setattr+0x489/0x6d0 fs/hugetlbfs/inode.c:879

stack backtrace:
CPU: 1 UID: 0 PID: 30977 Comm: syz.0.8060 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5298
 __lock_release kernel/locking/lockdep.c:5537 [inline]
 lock_release+0x269/0x3e0 kernel/locking/lockdep.c:5889
 up_write+0x2d/0x420 kernel/locking/rwsem.c:1642
 hugetlb_vmdelete_list+0x179/0x1c0 fs/hugetlbfs/inode.c:501
 hugetlb_vmtruncate fs/hugetlbfs/inode.c:641 [inline]
 hugetlbfs_setattr+0x4d1/0x6d0 fs/hugetlbfs/inode.c:879
 notify_change+0xc1a/0xf40 fs/attr.c:546
 do_truncate+0x1a4/0x220 fs/open.c:68
 handle_truncate fs/namei.c:3516 [inline]
 do_open fs/namei.c:3899 [inline]
 path_openat+0x306c/0x3830 fs/namei.c:4054
 do_filp_open+0x1fa/0x410 fs/namei.c:4081
 do_sys_openat2+0x121/0x1c0 fs/open.c:1435
 do_sys_open fs/open.c:1450 [inline]
 __do_sys_open fs/open.c:1458 [inline]
 __se_sys_open fs/open.c:1454 [inline]
 __x64_sys_open+0x11e/0x150 fs/open.c:1454
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdea5b8eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdea6945038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fdea5de5fa0 RCX: 00007fdea5b8eec9
RDX: 0000000000000100 RSI: 000000000014927e RDI: 0000200000000340
RBP: 00007fdea5c11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdea5de6038 R14: 00007fdea5de5fa0 R15: 00007ffe42e704f8
 </TASK>
------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE)): count = 0x0, magic = 0xffff8880295a5408, owner = 0x1, curr 0xffff8880260d9e40, list empty
WARNING: kernel/locking/rwsem.c:1381 at __up_write kernel/locking/rwsem.c:1380 [inline], CPU#1: syz.0.8060/30977
WARNING: kernel/locking/rwsem.c:1381 at up_write+0x3a2/0x420 kernel/locking/rwsem.c:1643, CPU#1: syz.0.8060/30977
Modules linked in:
CPU: 1 UID: 0 PID: 30977 Comm: syz.0.8060 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:__up_write kernel/locking/rwsem.c:1380 [inline]
RIP: 0010:up_write+0x3a2/0x420 kernel/locking/rwsem.c:1643
Code: d0 48 c7 c7 00 f0 aa 8b 48 c7 c6 20 f2 aa 8b 48 8b 14 24 4c 89 f1 4d 89 e0 4c 8b 4c 24 08 41 52 e8 b3 39 e6 ff 48 83 c4 08 90 <0f> 0b 90 90 e9 6d fd ff ff 48 c7 c1 74 0b e5 8f 80 e1 07 80 c1 03
RSP: 0018:ffffc900051076c8 EFLAGS: 00010282
RAX: b37f99c54516e500 RBX: ffff8880295a5408 RCX: ffff8880260d9e40
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: dffffc0000000000 R08: ffffc900051073e7 R09: 1ffff92000a20e7c
R10: dffffc0000000000 R11: fffff52000a20e7d R12: 0000000000000001
R13: ffff8880295a5460 R14: ffff8880295a5408 R15: 1ffff110052b4a82
FS:  00007fdea69456c0(0000) GS:ffff8881258a2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdea51fed58 CR3: 00000000779ba000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 hugetlb_vmdelete_list+0x179/0x1c0 fs/hugetlbfs/inode.c:501
 hugetlb_vmtruncate fs/hugetlbfs/inode.c:641 [inline]
 hugetlbfs_setattr+0x4d1/0x6d0 fs/hugetlbfs/inode.c:879
 notify_change+0xc1a/0xf40 fs/attr.c:546
 do_truncate+0x1a4/0x220 fs/open.c:68
 handle_truncate fs/namei.c:3516 [inline]
 do_open fs/namei.c:3899 [inline]
 path_openat+0x306c/0x3830 fs/namei.c:4054
 do_filp_open+0x1fa/0x410 fs/namei.c:4081
 do_sys_openat2+0x121/0x1c0 fs/open.c:1435
 do_sys_open fs/open.c:1450 [inline]
 __do_sys_open fs/open.c:1458 [inline]
 __se_sys_open fs/open.c:1454 [inline]
 __x64_sys_open+0x11e/0x150 fs/open.c:1454
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdea5b8eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdea6945038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fdea5de5fa0 RCX: 00007fdea5b8eec9
RDX: 0000000000000100 RSI: 000000000014927e RDI: 0000200000000340
RBP: 00007fdea5c11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdea5de6038 R14: 00007fdea5de5fa0 R15: 00007ffe42e704f8
 </TASK>


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

