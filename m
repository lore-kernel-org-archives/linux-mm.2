Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E610CCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 20:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C40E8E0015; Tue, 11 Nov 2025 15:25:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C3C8E0002; Tue, 11 Nov 2025 15:25:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9598E0015; Tue, 11 Nov 2025 15:25:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A16E8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:25:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7F15B6DFC
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:25:31 +0000 (UTC)
X-FDA: 84099456462.12.E4F4417
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf01.hostedemail.com (Postfix) with ESMTP id E2E4240011
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:25:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3uZsTaQkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3uZsTaQkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762892730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=cJkFoSRs8okndB0NF+WpPovtnW03gk5UHbHwEREFNng=;
	b=o4U1iNL1qSd4uwBvFhxRTJEXH5dZYqpGrZjjVpnyOF4Wb1MhCC3x8SDvEOpgGHpXxIXGt2
	qPS6SeyBHVzMSoHZyTOxYF2dTHdqxX3gJdrU2yOjkT7GoEOKJIzd7257EkqNUz2lIB8b+f
	WMW2ANu9OXErejLX+6QJu66+o24DNEc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3uZsTaQkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3uZsTaQkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762892730; a=rsa-sha256;
	cv=none;
	b=D4CvUxIGtg65b5m/QrVOUfOuJZg1WAmRpEDmb3fQXiLuApKyk4/YA5gscwkZ614VMx2YU3
	rjKpZ8EGcuHD4xA46ahNX89e0bnhcOobkK6QWWJ6zRXBEFOzcWIfCX13gdCJwo0feiFsjF
	YGKYA6D+CLhk/RmGaO6i9SnAkdpWxb0=
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-433689014feso1417375ab.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:25:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762892729; x=1763497529;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cJkFoSRs8okndB0NF+WpPovtnW03gk5UHbHwEREFNng=;
        b=DL3hps7HHnA6lvSET7U0UR4cfszWMHdKvLBlI2JJ17UnXPMr5lS+XwMEZ8p5p4/I/7
         xiD7zJILy0yK5vr/7XxrF1l6yRU7wP1A04U42nOU28ByEmtDheLusNzFDMRuWMY3k/Rr
         HS7HrVGFU+kJFrCcidtsS6lGFSK8lFdq8Db67Ct7hq5C2Tx1IRA6h+P0dY9hlfzjDsjI
         KAz52EaRYOquKKfrfqiLSSQEw6ctsyJVZvghc8JtjNf0BxoBaef8Y9i0mdk/aQebNzTF
         e7m0N1MBmYeA/ke4JDxgBZ+BiSsp+e4vix+gwyxdzzxm4EpJFOn9dotaL9E+yFDWxgOW
         5MsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUm/Qxc5LDzcTbbhk7i5J9AHtV0Hhg390b4dkxWkHBWP4iTvDjZntSRH24WWUCmcxmMRmv+FoOhCQ==@kvack.org
X-Gm-Message-State: AOJu0YzTbn6wpIZiU3zongyfOs7CGR9y7MxPk1pQDj+texae5x3pflnP
	+j33V8XpamPjLUxtjirCaEgmgp6R9j+5bW6LFNWcPzYEr9E5Olf7/x15zG/9VR1+Cnp5aEgtUmv
	Zk161bw9ySoqQQ4W4YcuvQgDICWQNK6W+V3c+BlHct8S4v4vuZMDQe3cMo0M=
X-Google-Smtp-Source: AGHT+IE57QnP1Vs+yJMpX9ldQWcn5HAda5L26waD+epriwGTu5HuGfk0y33jAEuhEL/M3mr1UhZ6/3KppppFA4yr6gR+Z3oG1zU+
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:370e:b0:433:7885:6105 with SMTP id
 e9e14a558f8ab-43473d6b887mr6996185ab.15.1762892729015; Tue, 11 Nov 2025
 12:25:29 -0800 (PST)
Date: Tue, 11 Nov 2025 12:25:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69139bb9.a70a0220.22f260.014b.GAE@google.com>
Subject: [syzbot] [mm?] general protection fault in __rt_mutex_slowlock_locked
From: syzbot <syzbot+60f8f8d9d0a992e59f1a@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2E4240011
X-Stat-Signature: ghshwgkpg5x3173zwz13mstfim5cmh3x
X-Rspam-User: 
X-HE-Tag: 1762892729-323569
X-HE-Meta: U2FsdGVkX1/l4NHJv8zMOIHlWqJeFjVXnzU6O4Xz97C3n5uGb7/WJ+smbU8v/vyiMoQe5DN/B0wpdCKVqL++9amgoJO15WpJP2gu2ODkJlSTjHKcNPpd4mpncqC47KCGmlx27S2Hzm8+dXoYwFV82EhTaSb4Im2fr0eTVlyNfzPdZ3WaYZ8K5ESdG2bObLGi8+AQKqbgA5QvD8CtJ6y13wMg6kXWBOL1V9P+EtivqiiwFl889FghB9f4Ez4mXWPKFEEzurIO7AexdywDbYLy5s6Qe4uU19oOKBgAQ2oxIrsZYBAuDgqnhYe5eehXwt9rcXY5c/Ne2cmWeZbxdWQjXyjWW31xxpqmrut8TbUvnIl6WUAp+kXhnLNFmHlBx/eLqv+Y4Bdd479uBmCk+In8xdXWXcawtJyr1A5qR80BDhhaicBJoaL1f6wYFfSz057OVCuS2R8Mv/MR72gkQ+QGdVv1fXJtZTXXUpqsOvfAEY26QrLc5BZJUYc3QEKBXHNKHJsLWsiPnOK/r+vHLIBSuxm3iEp3H42qu7PGKxYPVnLZkNJBUCWbekY0+/Ttfjp74xkpFxx1CmEGakG3yZ2nYSg2sC74veO4khl6d1d91H9HpsOxxzrcd9s/nUOLLfVi3JltKeaDABBwDoFzEXOrGLTX8404cIIXw/cvH8KVwonSI8g3DhVWXcRL1fXsHtRjZX+otiEv7j5I1Q7YatH7NWDz1vSHvQwXU8+yAumZULfZz9KZpV/By1VyzO1SC96+0PW2nYuTXzCReJFl0FZ87MMzNypRnjlR/qRB7bF3bu9OD9hIIvNiUyEvO2ZBRxCZe9mJSNIX4mHfilDS/bCiBgrDsG0oX4CgPEYEKTJz5do6rQepJqpiSg1/pGIIvIqVlA9v8JU6wKJszSIReJ1rzN3ZGpt2N1S9mcqXdMttPzyqO6qe/F7ztL+z7gx/sioxLGMklOzCBjaHdDeo7II
 uI1IXSga
 6z3Th/meBew0pGzekmn7fNaFTHfqjaYh70tEdG4Sk1zc8CTgmU3DZQx/3myh+tQqeBaspjxI1PfZtu9NF0Mleg2rnIPCgZS9k30QgHpUBzQmsYYJ8lxu1oIQxIR8XQ9tJmoWmrVvFzwxfYjvYNZenu89yq78Mofi9NtXNBUnP/32RcOCOzKNkIuMykGBwNHhEY8b44yOYbqFKfLkKDneuANlJfWau+xejXZ30rkZ0NAo8mWlklv9pywMOFhCYpY+xL7JVVmLJ98SltpiHBtFRcpAmCX3vMdGNsW8svvwRQZ6ORAIgDOS8lVWztlWw9mBBq3QbUmOVsUmGY8fmDi7yKBYE6062l3GZ3qIewM5vS/HFMoyUcuB7n04CkCiNVIS2BPBS5Sz8WxI/3Z+h+MxexXx8njAW4C0pwE3RHRKVPThNXSVwdO1QOFqItL5rFP2jl8i1bcaOxSvdTAbvNFgDz3IrA4IL9EHd8+VD/lqtw5RBXYtu0qaFurz82ET+MvIQq3kE1XFoDYSPFLARZSvGEZZl/YFHXTmEhcCUNrabNi+SxA036GB33XVLABUEQ45gmxgHKOggsYlOFLyhFihuPLVqnPtrRAW9fh3JX0VZ1olHU2ZoGdxqmi3WGgy21y0g4xlvrbD6Krq48Q2cYkWU9W5BSYfXcQ5wesvWGxrGrAAePUpIbFw6ALWhKsqXbM3Y9mzHqyyw0oeJo0GkPMSAdoeba+6UyxcI6wgbEjmXVYVxwEFSw3eHzZ2DoFjmqJHKImgmEXIdRMIypgZvmIXgqREgHKkGhe/HzBz18c2+oiF5p9kLvFEkb5ULXZ3wUnIE00pLVKzetnKRixH0ax5CodMWSPaT//pOo+Hm6tJd+USTHRINdj9aaMw3irLajAWwJ45YH4Y1Hq8P7G/HW+AMbm8Tebmj2KBlK/TCERl0kPkkbf7WB3D2/tssr6nZvzEgt2mo86yVm2eHrrKLWvjJ5wBRUk0o
 j+AtKitJ
 I0UOWNuqdB+87iMgrjQW4WxjL0JQxI8/Pxa+4gOaOZvdsKW1J2+hyzE4yVSfeZiyENESJNEyp2oOgLZ3NyqLdyYLr6InK2pkN8L144ERTNol4FPb8xULM6wJnOMkTUKmban1FvKLWH1Yvtz3BMNUYEkETzlTbDAFxoFN+qeNnO9MqMsX9AasdLTcVbHSMc65/YYZeJBUuBjBNCYW4qYATMFgFxinnzlhnuHpxIuhQbkDo0x1zNLpRKaFWrHkRyRvESGagQNi5KVczrTjS87+snR0Jk5fZizkK3gFx3p+QDFsQj/JJ0uymmcp2Tsznsohl3mdjSz9JMyVWmN8A8oSHQmvetxinBEbZPKbMAglh3hCIdkvfziFBvQeQb9JXDTo3e7rXCtVDM/33hzSEea1J2D/4K6V8DMaevm9VMioofE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    4a0c9b339199 Merge tag 'probes-fixes-v6.18-rc4' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=136e9114580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41ad820f608cb833
dashboard link: https://syzkaller.appspot.com/bug?extid=60f8f8d9d0a992e59f1a
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2f1bc58f2850/disk-4a0c9b33.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d4d546567b38/vmlinux-4a0c9b33.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4618744dea2b/bzImage-4a0c9b33.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60f8f8d9d0a992e59f1a@syzkaller.appspotmail.com

loop2: detected capacity change from 0 to 32768
Oops: general protection fault, probably for non-canonical address 0xdffffc00e0000153: 0000 [#1] SMP KASAN PTI
KASAN: probably user-memory-access in range [0x0000000700000a98-0x0000000700000a9f]
CPU: 0 UID: 0 PID: 13777 Comm: syz.2.923 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:kasan_byte_accessible+0x12/0x30 mm/kasan/generic.c:210
Code: 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 c1 ef 03 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 07 3c 08 0f 92 c0 c3 cc cc cc cc cc 66 66 66 66 66 66 2e
RSP: 0018:ffffc90004b4f2f0 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: ffffffff8ac3ee8e RCX: 8a8d6ce156f8e600
RDX: 0000000000000000 RSI: ffffffff8ac3ee8e RDI: 00000000e0000153
RBP: ffffffff819ba5a3 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed100a608c91 R12: 0000000000000000
R13: 0000000700000a98 R14: 0000000700000a98 R15: 0000000000000001
FS:  00007f6cb050e6c0(0000) GS:ffff888126df9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31923ffc CR3: 0000000068aae000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __kasan_check_byte+0x12/0x40 mm/kasan/common.c:579
 kasan_check_byte include/linux/kasan.h:401 [inline]
 lock_acquire+0x8d/0x360 kernel/locking/lockdep.c:5842
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 task_blocks_on_rt_mutex kernel/locking/rtmutex.c:1265 [inline]
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1719 [inline]
 __rt_mutex_slowlock_locked+0x1223/0x25e0 kernel/locking/rtmutex.c:1760
 rt_mutex_slowlock+0xb5/0x160 kernel/locking/rtmutex.c:1800
 __rt_mutex_lock kernel/locking/rtmutex.c:1815 [inline]
 rwbase_write_lock+0x14f/0x750 kernel/locking/rwbase_rt.c:244
 i_mmap_lock_write include/linux/fs.h:548 [inline]
 vma_link_file mm/vma.c:1781 [inline]
 __mmap_new_vma mm/vma.c:2499 [inline]
 __mmap_region mm/vma.c:2670 [inline]
 mmap_region+0x1bf4/0x20f0 mm/vma.c:2740
 do_mmap+0xc23/0x10c0 mm/mmap.c:558
 vm_mmap_pgoff+0x2a9/0x4d0 mm/util.c:581
 ksys_mmap_pgoff+0x4e9/0x720 mm/mmap.c:604
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6cb22af6c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6cb050e038 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f6cb2505fa0 RCX: 00007f6cb22af6c9
RDX: 00000000027ffff7 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007f6cb2331f91 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000004012011 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6cb2506038 R14: 00007f6cb2505fa0 R15: 00007ffebcf391b8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:kasan_byte_accessible+0x12/0x30 mm/kasan/generic.c:210
Code: 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 c1 ef 03 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 07 3c 08 0f 92 c0 c3 cc cc cc cc cc 66 66 66 66 66 66 2e
RSP: 0018:ffffc90004b4f2f0 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: ffffffff8ac3ee8e RCX: 8a8d6ce156f8e600
RDX: 0000000000000000 RSI: ffffffff8ac3ee8e RDI: 00000000e0000153
RBP: ffffffff819ba5a3 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed100a608c91 R12: 0000000000000000
R13: 0000000700000a98 R14: 0000000700000a98 R15: 0000000000000001
FS:  00007f6cb050e6c0(0000) GS:ffff888126df9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31923ffc CR3: 0000000068aae000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   7:	00
   8:	90                   	nop
   9:	90                   	nop
   a:	90                   	nop
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	0f 1f 40 d6          	nopl   -0x2a(%rax)
  1c:	48 c1 ef 03          	shr    $0x3,%rdi
  20:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  27:	fc ff df
* 2a:	0f b6 04 07          	movzbl (%rdi,%rax,1),%eax <-- trapping instruction
  2e:	3c 08                	cmp    $0x8,%al
  30:	0f 92 c0             	setb   %al
  33:	c3                   	ret
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	cc                   	int3
  38:	cc                   	int3
  39:	66                   	data16
  3a:	66                   	data16
  3b:	66                   	data16
  3c:	66                   	data16
  3d:	66                   	data16
  3e:	66                   	data16
  3f:	2e                   	cs


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

