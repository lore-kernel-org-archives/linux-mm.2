Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86536CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 23:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32108E011C; Fri, 24 Oct 2025 19:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE23A8E0112; Fri, 24 Oct 2025 19:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D15B8E011C; Fri, 24 Oct 2025 19:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8228C8E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:11:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DAD3C0FC0
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:11:31 +0000 (UTC)
X-FDA: 84034556382.28.8413383
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A2E8180008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:11:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of 3oAf8aAkbAO0hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3oAf8aAkbAO0hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761347489; a=rsa-sha256;
	cv=none;
	b=QliM1TcvNTE+rbtyshimA/K7R58/g9JZMEbScApxuP/RseKeBTHfJ8FBLP9CkggqlxrCP/
	4Xup80eAIroefnxWzseWcWAjzOQz8OWov8LQFYNLshuJgEKGcKtORX8rAPUQZMj3MUb7YL
	V22TV0ORjPCxMpWAtQYOUhQmlZrDRS0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of 3oAf8aAkbAO0hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3oAf8aAkbAO0hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761347489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=YLmm+C3ZCh8Qp07LUG92nktccaTXL6AyWpT7k1Nn7as=;
	b=yEI8YJmvGnAOPan1/ATuOTZPYbwhodg5VymlAeusCnrfvtY6q/vb9q9Sg+TtEUy36FHRvq
	eVdWqksqVH7nja1BKEFkXo/HD6n8PIUdGmhP5DhuV0gYlKePGR5jJfIC7MdFWhfVi7v0kV
	zjkk6qg34RnqjRHRA3SnETSC3LB91dk=
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-430d789ee5aso35235355ab.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761347489; x=1761952289;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YLmm+C3ZCh8Qp07LUG92nktccaTXL6AyWpT7k1Nn7as=;
        b=Wfmlx5JTxGoco7KgOZLHrqMV1p/7oIFvyswtsNISKMIPAQb+iZtOXti2pF5la3y98g
         ykSBljm0bja7+OCeAysJevbu9PLOQCypG/WdcVSt/S95S3PGN5LNl67v3QTW4DsV0tKE
         BFeCleuRaJW0nWA3k2e5fNudB6NmvL8vGq4wUbg/WsK60RmlckDdT+fppa1RDK7VJLCR
         nEMVejQsqnlIJQfUm04YPyOMFEyxGEiBo3X57Vbp+UpCot1RvVWMOVmz1FwtOXa0sDSM
         al2pzheHnVNKRfNGiEytdhL8XxssS8oxSZh4j8LosJCZOMz2c36b1eGoRNz3KkHnJ3O4
         bCVw==
X-Forwarded-Encrypted: i=1; AJvYcCVpqqgyFaZ2xoCy80/1JI8Qde4iB+C5Hd3whXJGpgMw5Co3nWcvJtGUg9NnQHAFiVQuPaP5+1uJsQ==@kvack.org
X-Gm-Message-State: AOJu0Yxexwr6LAoAL2aa9XL5CYA4XmKAElURdB9fEmoBtRpaa6fDCnEL
	kabvvqsbHgz2MhAjI+JqCvHlbmueB3ZG08ih6LGeOcwwSBqXBOSluWbuC4oiTRsW5Eg6fGLeSkP
	a7rcmP4LjU/OZB6otA6n2jVI7qLmqKt9mzjC9o08v2fDQaVQ0iun8UQoo640=
X-Google-Smtp-Source: AGHT+IGBSt7L9vcY/WLMU3vVT94oq8gMy2FOzTxRk6D8OcXsdeJI+zG817jRuUkMRphkH0xsDYJq2/MlLo8Wb4O54yFIpGU1eoZJ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aaa:b0:42f:6790:476c with SMTP id
 e9e14a558f8ab-430c52d5323mr419014795ab.23.1761347488684; Fri, 24 Oct 2025
 16:11:28 -0700 (PDT)
Date: Fri, 24 Oct 2025 16:11:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in raw_ioctl
From: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A2E8180008
X-Stat-Signature: pz37pw78ekiafrtbhcrs3irn1owjrcr1
X-HE-Tag: 1761347489-516975
X-HE-Meta: U2FsdGVkX18x5KtudfMeX3mjgQwQwB9IhC2Q8GipXgpuQN726I+Q+seHfQfzEkTlPa5VrAA4PZMPGLX70+jDXz/7zTdhhhq5mC6RZdXY9+elExlNOzUqrE638KgZYFElSbIMeB7hofZcvynhc5ZhBOAZLEUg7dQWijBgfJywJ0D7rzMgcnBGgv7CyxBMXTe4Piw65owQ6++LDkgc7BvjfSQjUS14UYT9lhDiN4O1A4S347/t2tTmv9aEoswD13RBnzxs02+cpY8Fox2LDL0BgGGnkbdC/CckuX6DqnjvnhBTHHBKb8e6fN4Pj3DFim4BQWKOAx/5SYUMpw8OYuXacUTAw44iU4uOgqzyd4hZJsbVp8eDiE7y4ntb/+JMT1qtTj3JFOjyY/ZxjmIIqLxBhTaRfgva+n51smmfxmdvT3jqgdE4yIcdwXC0xeniGTgMjauIJLuJTvs3Mcqp2xz1YgXegAoWxE+SEMmQfdXIsZZNhrkUCQSmxKcgDMEsXyjsdGYPBqNgAM9d6iLpBPwTRQlkyPp2PgHm8fwWxhl6W7gNaGbaMaH47c3FwLZ0MztO3EZ5mb4IIO5A47yyaCOAjbqjh1e7JmkeFffVUyfeHh6A7iYDUVRJVUirLratRqq6TrTKZyZdaFfBVe8CTSfMQGSPDPYJjT8B/xH37iKnhU1NKB2BoilUCKPiGoexRGHTPeX4HAeEMXhHJYtFyty6MXi9mRYMx6nNAFXlfgeEKFiXhMAQEBLsjuVdlna7Hn8eQiqhigsM/e/eWiLJoSB0jrHxut2p/DUxrW8PRNutJeGamSM++mwACaAh2m/fTpXWzK80+CZp/U5VmvnpRgGeyB091uOcGN4xNrhx1VVYrgB56ca63fV5ujZ6sGK1oqy1SKnBqETUL/uQzCUgm3vM5EEjOtxXiTOrCqaROlqcmG/Swp4HgxrMPebho0QixjKgNbibUoKCSqwMgHuAlYi
 JMmBhOCK
 4OFjSCcaFnVrbt2eB2cmH5GNhbmyKNcXGjU+1XmPEyXob+Ae4hDtk9+HpK9ASiBlFppm58gqyQ15zX1+6idWRS5MY6ktNHYoCmp5lSbnCdzCwgFnKZnIGyNAAiqrt+tfLTyxQlShzggwYW4jjR1tIW6sPiIkAUysyyZK52V1wX2nHxCfRNTkUuWBObh1vgTGqwgSOXLvNS3mTA8WlziZV2H1wjfOv9q8HHd+eZj0F90GGAEj68NAZBBgCxHViW1Yqr1I2KxetOgccOH+MVqKIpl4zWd8DK1Gp4sLtYF5dWVivedutKTtvEuYVd+xcQ0SBLgvDMvA7qwWU2fiZKAVUKgGxuCzUZufVuEEO2H49dGOOpV3Opn53BXqYPq2PEidhjvIdS/MfdUj7xFpKvUKwSKl+B80pPjoHQcwRkGDTvkHaHZhMmNV/epWA5M2h8ZlaLFAEg/ZLXoWzR07TXSEbFjLryNlJS21E+WLC5MS85PFMsxg8eC7evWnukfdba6sPQmGKUESlU858k682w98OSUrlIuuueXqEq5kYVn7owa/sKR12aFZ7wUefJtm0wF2PgOJRBoR8UbkdqJ4XvddN7lIAfrqRyjtAM03G9kUvV4wgv+MlnfSlOzE2jHPpyxuxcQVZzGHzZ2YAq+GOexQmdZeTRZTbEmpx6c2Hl1YGRN0IP6o+JjvukRlFJyaPVjuhwqcxK/d9D6oJ6rI0e5C2fmnvHDWeuRJ3iB+aKk/vi3pLWOYX6UU5mxsZQd/2N5h2GYest0IWBZE/rA51u/FjXlehKSfRi3i5hO/DJIcEh/hbDZLsDYtAgCvY6Z49X+4+Hie0OiCTjDHeOuuIceyJUAsmjbg+4T1+WDbmnWwkLHJ4A2UPe5SKuUNzC/VOBiNZaYScJDaxaGAO91rWE7wXTyQWO1sJz3z3jhvU1mraSVXZe0xUXURX8z04zhQnN7vphvQsVN2ra5ekaDH0Yumy8oHu5iwy
 haKaqpZS
 gFbqRua+daNnW1Esi9lUeqs7T6RyNfNAd3PEVeb06RIIGJTsWpV2OmmofK7bwIPtfkcKatu473nrIYtYUdAzlElvZuw1IgKfFOb8aH0JZV66i4FyZ1gCVW3lTYP0IETKmGlVwP5fe9pNIQUUEn6AGKHf9FqsNdMsqF6C9S1HswQ2UbfeGQyCHEJEkZSourYDP7HOiNI+NB4k3Slma+6nlmhDsPMGVWO6HBfxf1ZZ7CgEey3CuL5HvP7GVf0HGMY+KX8TQA+G7xnbHOX+y6jzUESxAoWB2hLP0JLHvMBzLNTWLFnviAfxtCtNNq2FRCglCcnbQ5cM/DSHjIw+0nyev/H91ULIHS4R8vrtLhvi3IOJJoAHtxjv+Iq2DVmJJ51p9Rg/yqMuxvFqjD9Zhi2tGArpeum4KX/xokeWSfDaA5kKZYHYmOXh1zIrh5Ru+qMbkRDFIJDBRjxuPbAyCVoYP8ueq5xhfRyW5ogiMuS0LTqlKuHyskszZ1dUdHZJvlrOy21YNh7ZgQqMS3Bp2q2B6wL94ZbNAb9468JLxEPjrM0bik1FKqLiz1lCJuESUhf3krdZ+A/baE0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    72fb0170ef1f Add linux-next specific files for 20251024
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10fd0be2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
dashboard link: https://syzkaller.appspot.com/bug?extid=d8fd35fa6177afa8c92b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119eae7c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140693e2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/be1fa3d1f761/disk-72fb0170.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/57302bf7af40/vmlinux-72fb0170.xz
kernel image: https://storage.googleapis.com/syzbot-assets/91c806bb2a2b/bzImage-72fb0170.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/page_alloc.c:5190 at __alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5190, CPU#1: syz.0.17/6001
Modules linked in:
CPU: 1 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:__alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5190
Code: 74 10 4c 89 e7 89 54 24 0c e8 64 b9 0d 00 8b 54 24 0c 49 83 3c 24 00 0f 85 a5 fe ff ff e9 a6 fe ff ff c6 05 b1 7d 70 0d 01 90 <0f> 0b 90 e9 18 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
RSP: 0018:ffffc90003017920 EFLAGS: 00010246
RAX: ffffc90003017900 RBX: 0000000000000013 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003017988
RBP: ffffc90003017a18 R08: ffffc90003017987 R09: 0000000000000000
R10: ffffc90003017960 R11: fffff52000602f31 R12: 0000000000000000
R13: 1ffff92000602f28 R14: 0000000000040cc0 R15: dffffc0000000000
FS:  000055558dedb500(0000) GS:ffff888125ddc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffef4504a80 CR3: 0000000072ffa000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2418
 ___kmalloc_large_node+0x5f/0x1b0 mm/slub.c:5583
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5614
 __do_kmalloc_node mm/slub.c:5630 [inline]
 __kmalloc_noprof+0x4c9/0x800 mm/slub.c:5654
 kmalloc_noprof include/linux/slab.h:961 [inline]
 raw_alloc_io_data drivers/usb/gadget/legacy/raw_gadget.c:673 [inline]
 raw_ioctl_ep_read drivers/usb/gadget/legacy/raw_gadget.c:1162 [inline]
 raw_ioctl+0x18fb/0x3be0 drivers/usb/gadget/legacy/raw_gadget.c:1325
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fccefd8efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef4505ad8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fcceffe5fa0 RCX: 00007fccefd8efc9
RDX: 00002000000000c0 RSI: 00000000c0085508 RDI: 0000000000000004
RBP: 00007fccefe11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fcceffe5fa0 R14: 00007fcceffe5fa0 R15: 0000000000000003
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

