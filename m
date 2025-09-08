Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B4FBCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 18:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A2F8E0002; Mon,  8 Sep 2025 14:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CFD8E0001; Mon,  8 Sep 2025 14:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79B08E0002; Mon,  8 Sep 2025 14:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF39F8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:45:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8279A1190C6
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:45:33 +0000 (UTC)
X-FDA: 83866961346.15.7E7AD56
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC73940008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:45:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of 3SiS_aAkbANsPVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3SiS_aAkbANsPVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757357131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=0BYpbNj94Ojs8b5h4+Yv8Gr1eSotCP4HbUumdYPAAoY=;
	b=t3JlG58Y0Rg6u3pSh/dzIo0NnBZYMr9vrjpZd9a59sA9mS+r/I+l1nAgXeRHc9lhbCV6J8
	OoT9NPGRi4GzyZXcXZ5y3TOpwp4JM2DGL6uY201cK+tP9fnIprh/bRQ5vRqebAz1s2mc3R
	t4aMRzgra2FLo6JYO93ACPIEIhpKVac=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of 3SiS_aAkbANsPVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3SiS_aAkbANsPVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757357131; a=rsa-sha256;
	cv=none;
	b=iZXbNeMxHQzFL/IF4blE993zZiSmmfzBRlck1tTAwwt5esYGPk5OC48wksXE+TqvG6qkol
	vcZZ0v7nLOoppTJuLMhfI5h2fuOeItDNNgpJFJ4lFOqzk4tqqU5NgYuLXI09tHNNdx/tyX
	genDT1gQ6+2GO9ZShZpDUcalOzVF8mU=
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-4048726387fso52216575ab.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 11:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757357131; x=1757961931;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0BYpbNj94Ojs8b5h4+Yv8Gr1eSotCP4HbUumdYPAAoY=;
        b=pVgYTNOMYCqmEkfsVbI6GcNRnMyX8T51IfwoGSlHo0kxb9plAPSppmdLEGaC2LK0lO
         sHu0rUn4kZhdLnv7K+eTsTF3xj1KP7ta7xlgi0O6gIoMevsZa8H9oVsV1KwmeUTZoBNv
         Y+FqDxudx1M+VR6wzeRHF47TUtSODb2zZeGQnY8rR6DNqqDCIztVtepE//DkZBh2/cL6
         uoU6Vw+FudqSCIfnexqbUB34ib8hiUf3OxnF+FJyOykzye1My22yVgGSt1z19PZ1UvP1
         M7XFbmYDBwGc0pxIHZbJZ98jFdiLdFVAVsN8CPXOKiF9S94mUhJO7hYo4ZZymAdFlY1O
         CDXw==
X-Forwarded-Encrypted: i=1; AJvYcCXZjsdjpaEKpwEABHyaq+Oa2MCA0hBryuGUcC761iWgqWa+uGWdstg0ark/TmW3hSKt44dH7zMVYA==@kvack.org
X-Gm-Message-State: AOJu0YzorARLIoh7d7Z4ilWIQckHfNDEHxJRv58glnkPAhWJVpXmLEtO
	Qp6liPqJr4awq84d6JiQB0bfxm8l9kwdMgdRTv+4iSgHNqDuQIa+eK75XmrW0Ia+5+HviGW+Kue
	J4++9FUXJWTsi+rAJZt3+9yL9lQZShOyV96OHSo9sGC0Jz01cFKZvyoxWoe0=
X-Google-Smtp-Source: AGHT+IEK42zR8SiAURm5964soSiT50Cu6mxHG3e2DKnwf8R1xNwacwNFbovAXCL3TNOYUMvwm1EmQrN6AEqDV3VpCHYgYLTSy7aX
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1487:b0:3f6:609d:1855 with SMTP id
 e9e14a558f8ab-3fd8925cb22mr129479185ab.31.1757357130805; Mon, 08 Sep 2025
 11:45:30 -0700 (PDT)
Date: Mon, 08 Sep 2025 11:45:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bf244a.050a0220.192772.0883.GAE@google.com>
Subject: [syzbot] [mm?] [ext4?] WARNING in ext4_init_orphan_info
From: syzbot <syzbot+0b92850d68d9b12934f5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CC73940008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sc99ja488widuyy6emr3d489p3pxbop5
X-HE-Tag: 1757357131-260731
X-HE-Meta: U2FsdGVkX18reQqgxSV4MvdNoZ9N6K5pnDMu6dPvkEpPvN91cyC08CPAR5199x1o98/8F1rVYHH7byx1hkl3ryiry0AlZZA3H8slc6nAz3HiWWhbKYQ/hDN77YfRDNssTmoqTaM2uKv5MfCSjdW+xX+EhdfO/Rc3EoGusZ4+ys05g/p5JK5AKCNI0Bs8vLPVxX1Yj1KPpVaDlyHqTcMkvyUZnoGhzmbErpH1qvXL7CT/+w6MfVhHTB0/P/3dik4Y5WASMZIBOwC30OrMBUoZ3/5/T1FHpgsq5icWYuDAoE6qmtIZnURX301cz1M/Ie+BqZ4QHYM24DiTVIiMj9/BUm+JFZXxFkDsGnU3H4yxE/HvkEbQudD26IaBpniDPUBDjPn84ty0M+zjDs8aj52nXJNxXa55kTS8jawLT74utKySEotIKARAJ8mhtGx7LUquUh2saEHaP13cjCPF4/s5jnd81JrEoFx+GVzIN9AxBTiRzSYm/F/r1sLXHve4IWPN5gZuj7i72MJ4qh63jEkY3SKkWx+FBrHJWHKsys7MLT/h+ehEnsLYTt8lt9deD4EsSg9A1qA9r+MgASkGztG4cWBsBPDF26TcVWBxx2BZmRbH7RJCFGu/3mo1e9f+1fhYDsX64Pfm18MUG+g059Fn5OrGeYN4nzNl1F/DNDGzE66HIah4934c7eUE1DIIz8+cMEshE2+uTq9xql1Fs98x1qmQLLgYUI1I79OkjgoibaN9AgJDCaLY6BN456ofZ5Ylr66noUNIuegJ7DYhNlmv8RjVc6HYUjlA5kjOIpBMFEiJpqK57dIrJ7KG5DskeBOT9sWkMcoKHXmqA9Gdu3VPOXvgAbdC1rm9xSuh2IQjcxn1OO/u8EVEdQTB41bO648xi4hDjvuY7hdXtV9Dqh+qTQPs3lotgY2YEOEQGD7ws2zDHdquk1/fiJcK6JVmz5YJ6x2vReR3+BZhdlZo9gY
 VT+FTyYL
 SF0yc+joYtnHw9GrGap2gsr0YC7EBOECs73vndUM5cW8F0BAaw6+Xjb7I1cRhc1HjCADDkVH+Yu7ZKIYJlatZ9G8tcVuwQ6KspS3bR9QHklQuZMXSOrTwO/NXjRYmmvX19f7Kc4Gk7kGatp/MV2y3WU4SbCcQ9AJgtYuMEhDOd+X8a3IPMO8Qt7TRjY313fHnMs1jMUPfyD4wvZwTuekM7TlCotS1vucR9KgazBpzMth3pyYw5BULFp1ciDw/vt7a8WFgAFhVNaqW2jhE1qqmEdzv/ECP5uf9vznM+KJXuuw/+SbjOgzCroML3Q5AgWG9K9Cfo/ps0GRKaMIVE7fQh8QmP6iU+OMRvAyM8Bzuy1LQJfgABtE77Y6UpIyQ6mSSudQZSvmxspGY5UzQv/UyC0JEyoHQwGgD61zONJP984JYNzKkQWo0uCzC5zx/F3rajS8/1t6r8cM0jlr2F3raqzyckxj1PmdZFdA79P9bq4x+mB/YR/ZefaR2rm6jD92m8/JY8osVD31e8/UWnnvs9ZA51o1dlPwtQr3Js6ujEkEla8evkk2eZwp0MEngHvjtgDuSQPui43KVjtHvtJiJk6NSVk5eymXTwUZfKXMH71SL/E0dUncm/CFYbhS4gDiB3gOo7+1rpzqdHcy81o4y/3T1H1ntLsCqU6RIVbh2JtUlHo2z9hh38H3FcSpywgOYwU4WV1nDVSuYyywDAinWOgeYUqesCK6ZTy5iqdcJvzZakUshV9DgbjpKd4DE6NkSLiEGA5XivIabZk1IT0F6MbC0VM7Yf8kYmUY3ycB5TGWaAZ1lB06JMj5SxDtUwrDN869oh5GGIt22IzrvVwCRVC6n6rs4SP4fW4gI7uNuw9nM/k/ZiiscKA5X9ngiAQbidTAZSYJrrixg8qnCxUu6LJMyFPkTXVE5nfLm7bhsUYMF+AtSuldoU4JouEIPdDcftwPVPulmxG7pQ/SE9OiawJgl0qJs
 GmJ5ESCn
 wB4kuO5Dw/mUUFM+7ciXbAIlGhwNwsuiiUVtOkVy1UrpthkkTeqijo8b6rLiYnHKjwNRf+GSlTVomK/tDNfZRJyHs6oBCLv/hzMcTOavgNuSClZUsE8SFXRuatvLT1cInWFm3YuOej9PCyU14uqsnclCoQ84xvAzl+7tc/fP6wGp2BHSzhtPZnuWNA9SemRhGJoN2Nrxmxvg2i4ovTntaDjeYcGCIPZpXCwK7axsGOv9BtBiTnNpiDDr3/r1S/K78JiRoEifMHq1F/lTmSq8WLoAptuSdk6Vamh5PU5xv/oc46UMENCV9bCz7BNKcWG5TAVWa6NsRdO/Q2xpeZUwJjYUZMKEdovcMlDTWiJevNCulcMluJ+I1ko+U4zZtwjc6Bbs5KWI1ZUSEqty9BXud5xW0SAI9Er/PlWykMgMjkgXZ7DGe4XUsk+8RkriSZeO+xfCZtL6CJS1CyXS4C2Cf2PrTx/eReXJHeQ85kuUy1UAS/oAb8Wdwp7T2AqHmjSwqrwiSEfg0edvYW55vC2+GNhucBqciVUsJII12tqvY8EgZ6nedHljNw3SOAqTc5JK8gXYXJ0dhf0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    76eeb9b8de98 Linux 6.17-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12ca0934580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=429771c55b615e85
dashboard link: https://syzkaller.appspot.com/bug?extid=0b92850d68d9b12934f5
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168d2562580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15869562580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/eee687cc7d76/disk-76eeb9b8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4062cd7a7107/vmlinux-76eeb9b8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3bcb5a03c247/bzImage-76eeb9b8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7e09a33c999c/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=140df312580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0b92850d68d9b12934f5@syzkaller.appspotmail.com

EXT4-fs: Warning: mounting with data=journal disables delayed allocation, dioread_nolock, O_DIRECT and fast_commit support!
EXT4-fs (loop0): encrypted files will use data=ordered instead of data journaling mode
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6103 at mm/page_alloc.c:5124 __alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5124
Modules linked in:
CPU: 0 UID: 0 PID: 6103 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:__alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5124
Code: 74 10 4c 89 e7 89 54 24 0c e8 24 e2 0c 00 8b 54 24 0c 49 83 3c 24 00 0f 85 a5 fe ff ff e9 a6 fe ff ff c6 05 a6 ac f6 0c 01 90 <0f> 0b 90 e9 18 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
RSP: 0018:ffffc900047676a0 EFLAGS: 00010246
RAX: ffffc90004767600 RBX: 000000000000000e RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90004767708
RBP: ffffc900047677a0 R08: ffffc90004767707 R09: 0000000000000000
R10: ffffc900047676e0 R11: fffff520008ecee1 R12: 0000000000000000
R13: 1ffff920008eced8 R14: 0000000000040cc0 R15: dffffc0000000000
FS:  000055556bfce500(0000) GS:ffff8881268bf000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f54f6aba6b0 CR3: 000000003b292000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 alloc_pages_mpol+0xd1/0x380 mm/mempolicy.c:2416
 ___kmalloc_large_node+0x5f/0x1b0 mm/slub.c:4317
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:4348
 __do_kmalloc_node mm/slub.c:4364 [inline]
 __kmalloc_noprof+0x27a/0x430 mm/slub.c:4388
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kmalloc_array_noprof include/linux/slab.h:948 [inline]
 ext4_init_orphan_info+0x2b7/0xc70 fs/ext4/orphan.c:592
 __ext4_fill_super fs/ext4/super.c:5590 [inline]
 ext4_fill_super+0x55ef/0x60b0 fs/ext4/super.c:5728
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbc7ab6038a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffed38a5318 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffed38a53a0 RCX: 00007fbc7ab6038a
RDX: 0000200000000040 RSI: 00002000000001c0 RDI: 00007ffed38a5360
RBP: 0000200000000040 R08: 00007ffed38a53a0 R09: 0000000000000c04
R10: 0000000000000c04 R11: 0000000000000246 R12: 00002000000001c0
R13: 00007ffed38a5360 R14: 0000000000000448 R15: 0000200000000580
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

