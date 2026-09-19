Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899B0C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 05:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634306B0095; Sat, 19 Sep 2026 01:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6446B0096; Sat, 19 Sep 2026 01:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE476B0099; Sat, 19 Sep 2026 01:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D46B6B0095
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:07:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FC6D1401BA
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:07:26 +0000 (UTC)
X-FDA: 85229328492.11.4193BCF
Received: from mail-oi2-f0.google.com (mail-oi2-f0.google.com [74.125.231.192])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9164940007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:07:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3ixiuagkbANAEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.192 as permitted sender) smtp.mailfrom=3ixiuagkbANAEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789794444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=XxzdYtFKH/Wd1tPRHa/P6bYgy1e4uRMJUfNAlpzw3sA=;
	b=nwCUK+pnulqa6lLmTJSC5s/x9+9YSsT0SRSSHCpWRfZtU+pfupuZoNMNDJuP60YbBHUE0V
	UgPqw+Ec8mFGmcNJTWYiXN4VWdzVs5GkwRpBTqghelVqucLm7nQUyA62RbhTPa8goxJm6Q
	O6JpiaMpMj93VKM5DLti+7Y67mT6W8g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3ixiuagkbANAEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.192 as permitted sender) smtp.mailfrom=3ixiuagkbANAEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789794444;
	b=eu35vCtb3qE4Ynzvc5xJXc1wYKBY5KlojKRz4Fk2XyR3i138drRGnxaVq5kgT6on0/ZcUN
	CzJy0DiLymIIq0dH1BePZ2CPMEu8+FmZELlFxXpyQC46jSfYl2g5n3KAJt5/mOUa8FMeKX
	Do0lXJCwfWv/j9N2H9HaG1cYizKo1eI=
Received: by mail-oi2-f0.google.com with SMTP id 5614622812f47-4a4492f5cd1so260994b6e.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 22:07:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789794443; x=1790399243;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XxzdYtFKH/Wd1tPRHa/P6bYgy1e4uRMJUfNAlpzw3sA=;
        b=R6yZCl5EfNtF+c9rRdaefmiWH6l/tpPMROTMSyB1y73mVOVwMb85D1ygWtoCqV0LAE
         nA0RYlhqZULuM1bcnjnwHi8dJGiA3TS/zQjRrveX2aZZOxpTpOmddfuT0uu1UrRRG5su
         9dY/f9SywbxdrpS7vSi4NSa5USe8XjkxhIIx2TrNyZ4jUk68ROZRbpje0F63ca8ZVolY
         Z/dtxH8Lshr6Y0HDrYWz7aIn5UJ3J+OQ9GbKTvouK0qctDAiKlUw2RquhedMP1Z3Gy9V
         mdOLkYNFrquoq9vOnhUHLrCrlDiEjYcgMN12kkvLhwh2WwA87Emj8/axVRAyuDyQr9UI
         atag==
X-Forwarded-Encrypted: i=1; AKwUvBzvemKQVpFQjiub5ZGuMk/9vmkNBOhcAoRJcdzxKTfRZkdGpo8yHbXI01O0Us7Se8u1suOYw2VDAg==@kvack.org
X-Gm-Message-State: AFuF++njlMVQG1VC41d6hBrCbBAZxA6PxGU7jZPS94AlPHJ4RXgLCnzQ
	5kjv5R/rIFoUaNFEQzxl+JJyd1py1er43ArJyXT3aOQl5X5iUmtxn/GyU5DhzBMrQYQS/kJOskr
	zlaoNS5dQqwxgQisbS36Irs9NQvuw7sSFxzzLSXzu4mgcj4S7/O01c7AzH4A=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b09:b0:6b4:c316:6fdd with SMTP id
 006d021491bc7-6ca9aa41fcbmr4126293eaf.19.1789794443460; Fri, 18 Sep 2026
 22:07:23 -0700 (PDT)
Date: Fri, 18 Sep 2026 22:07:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aae188b.71f81b7d.15fa6d.0004.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in v9fs_fid_get_acl (2)
From: syzbot <syzbot+de6fd6789748a8aa64a0@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9164940007
X-Stat-Signature: uswix6bjw6sjotir64kitxog9tf9u585
X-Rspam-User: 
X-HE-Tag: 1789794444-165820
X-HE-Meta: U2FsdGVkX1/V+HxQvjIO9SN9N0dIXYOeiUywD7WIJ8wVuelwdbmrlahlbac+ePTqoWIddsT0LO1cVrn+xuCs0108oLe/4XG4tGPFD7vP3ZDBOmqzBxXSzuBQFR87sp3UHl9Jds528TdslyzJgEpLxZWxlS8vY1/Ojv6eMnvgDPlJjcNmsy8VLRcNuDL6H/QV1qpjY4Krw7gWEaL6U1AjxlXj43S1gsinsvc+Y1Aj0StNuNDJ24KkxTL2o7mwcXgrnG5jO1GkJBufNJnGuWcakNeBm3mjY2djIimtjaVmZKTKs8kMqNRfLlYUVyJO8Vg4f4J71xB8lTNMp+R0PMHBodLlM1ldXGHhOcUG66GsiZAeAIID1glZn68eypQXjhb3PrM32zQxYhL3eey3RD0tbSPB3GjfveePI7JHQtW97ywKMgm+oANTagBIKh8WP8N1RcjNQDc2CkFJFRsNJV8cEbDz8Vq47bgZ7QAEYqZ3PJfnUB9VfvdNXH3AWNAu1ArMAzTk9ljjjq3ROgk23JngDuzvWhPtlk1SzTEk/t374lJlVlrqltev6SR+firo35P+UCY7wG8O/AA969Rud/y9Hr2vBhS5uQFjXRSr94XBranBZ15TxOTxwZQvFKT4frjXgD3uy7Rf6nnaqTyWCNMrHhIOlc2rpdyUdrl//lr6sMIB6x8JvP4HQEKP3NjFGcdDNuL4PjgUsyI4MJMMH+g52+VWkC5cZF8HYJriZtEPVnufnTQGExqBiT2xfoNzTUlbW6Ef8GVJMMdvh2HICZgoMHw1OcDyqPsQl3ISfqtAZMKiac7Dc6Nzhp1UsIpuhxAHHpR8nbkCmjHLEovy8qLr9cdkFyLtQw4ALzLBOknk5Ole8QbWWBauUtRk+c3Q5DhvN1ozRkffrnIUttiHNhhDs60HWwMA/ahYX4K5cnCEKhagIb6qqkiXxo6lAYO7mmrPBPqtB5fS6eWT4TED/g8
 BggLZxeH
 Zn8k3KPodww6Z6TIoWVK0f+PuQGvzjdr6rKrh8VvUR+5EBsEhCcvDMTywIXw7va6bTx6HcKlXLHScK/f1Fmc36o+QMmnhLykEdVUPezNuplHETazVx2nvFDdJZIqNHbOcXy6OgOt9taOzUNjU1Zdekp16GLqiRZExCDDRwdFmiZrk/bvO51Z1iAkaey1hUFjABI80/DHj2m+F6OaU0L85CAd5OITrlus9m3HZuJR1eEa5ihgiJm8911/CLPeDlhYT93tJOuSPKkARBMfcvm1UH/sn+uTY6KSSv5UXkIddv527AJo1+w+oO2GqAVDKlhTxNHqDRBlV5pT6p0GqukYpB+FwZuS0lPKsdEN5OObnf8fq5qGlsJb8a9fC8675YlAokwu+98qkmI849Tv9xJhJ/BM/dGrDKeCxpEVl9q6ySQhTfXcRtJ8BnwuFZL0qBd/tiwXZmZEjqad9vslxBAystlICUoKQgr1QWJZclDcwTxIkVFGJt3ZnG55v6Kwp8F+rluS6dALZoqpX8PJfsW2eD8TMDISUNCTSncLxVghXu0usnsX8JxXorsw9RWJc8K0WOQ7pt6iWPDa4C+q0jx8QajamD+w1uKb2JGQ2gHFhGf+My8VBfv59DlFnsqSFBn4eDlUEV+9jM8BqbxEZckpeqsG01tZ36Dd3X0mwYoXUxziLag1JyPkynuFI3UEYRxQWVnOfEJUFcaxVxbuQkQSsFtuiLiwvNq/2fd7TftHNeWsQqKA3dIU67bEd0678bWwoQyfLSAiYbQ6mQkvRX/1bFu7VoMhtjzfl9cxiX7mvpRRl8cWpjrKfCRO5TDM+Jg4qOEVZ4lwiiPKHzWc+C2TbM1gOL78pjuE60f7RpSfZSjvrjxYV6HVMYOAW5YAsNXyJjm6tmQ4kTs4hvC5INfr7jLyJyz9D85zkmW0NXhcM58KaFTNVMr1jnjYZoNTQzsO5OH/yCZ1SxAEYzWsx1oEO04i/2fiG
 xHKiflOj
 jJq0fONw6kzu08fMXpRDAj4I9rJFgtvqbzoIIpdcag4631M9AzkGQFmUyXU2kViCm8yQQOAmM3hBo4yKsXcM3WM3g/k+yViKNl9wiOhr061UV6DoRod4lG01FmLU241sbJbzrcl9L26QYBqwzfq+rLt6iI4/2O7hfDTzVrO2vlu7VuDwPmCr86+GsWKkgKCmWlB2wOdJKUVCxzmCgsbkOsDd0fafM4XY3p+5KEH1IHupd2+q2FwLbWIlGQ+PUEuEAnKW7QjXRbSfR0mnffnrkaiiRJFS4jHK8hl0RyrVVAYHWIhzETQoH9DwiiltAMDoMV1W8dzL1JdSPAWfK0Db3a4PGWZbbl1vAUYXx4flFQGXh77DNUZxWOZU+MuBHoTk/V4oQlc4lZvy68TZj2d14h+xnZsJDQc7ROrSVi6pJzWTWK6zeLQllTmWRC1YKxCk3fPW+kNPbe9eBBIWPcAoVeniBDMOAmKLwXxJOXrqTcSk4K9XLlQ58g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    587858367581 Merge tag 'nfsd-7.3-1' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1361a115580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5c3949d762a91f
dashboard link: https://syzkaller.appspot.com/bug?extid=de6fd6789748a8aa64a0
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f64df9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e1a115580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-58785836.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f8460d7438eb/vmlinux-58785836.xz
kernel image: https://storage.googleapis.com/syzbot-assets/551bf08b9af2/bzImage-58785836.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de6fd6789748a8aa64a0@syzkaller.appspotmail.com

------------[ cut here ]------------
1
WARNING: mm/page_alloc.c:5340 at alloc_order_allowed mm/page_alloc.c:5340 [inline], CPU#0: syz.1.357/7872
WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0x2137/0x3300 mm/page_alloc.c:5397, CPU#0: syz.1.357/7872
Modules linked in:
CPU: 0 UID: 0 PID: 7872 Comm: syz.1.357 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:alloc_order_allowed mm/page_alloc.c:5340 [inline]
RIP: 0010:__alloc_frozen_pages_noprof+0x2137/0x3300 mm/page_alloc.c:5397
Code: 13 00 00 39 84 24 98 00 00 00 0f 85 4a fa ff ff e9 91 f6 ff ff 80 3d e2 93 bb 0e 00 0f 85 9d e2 ff ff c6 05 d5 93 bb 0e 01 90 <0f> 0b 90 e9 8d e2 ff ff 31 c0 e9 5f ec ff ff 48 8b 7c 24 08 48 c7
RSP: 0018:ffffc90004df7758 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000029 RDI: 0000000000040d40
RBP: 0000000000000029 R08: 0000000000000000 R09: 0000000000000009
R10: 0000000000000029 R11: 0000000000000000 R12: 0000000000040d40
R13: 1ffff920009bef47 R14: 0000000000000000 R15: 1ffff920009bef05
FS:  00007fc8804026c0(0000) GS:ffff8880d5b59000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc88037dff8 CR3: 0000000037685000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x201/0x550 mm/mempolicy.c:2486
 ___kmalloc_large_node+0xe8/0x130 mm/slub.c:5353
 __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5385
 __do_kmalloc_node mm/slub.c:5402 [inline]
 __kmalloc_noprof+0x5a8/0x840 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 v9fs_fid_get_acl+0x7a/0x120 fs/9p/acl.c:33
 __v9fs_get_acl fs/9p/acl.c:67 [inline]
 v9fs_get_acl+0xe8/0x480 fs/9p/acl.c:93
 v9fs_qid_iget_dotl fs/9p/vfs_inode_dotl.c:131 [inline]
 v9fs_inode_from_fid_dotl+0x26d/0x300 fs/9p/vfs_inode_dotl.c:154
 v9fs_get_new_inode_from_fid fs/9p/v9fs.h:264 [inline]
 v9fs_get_tree+0x55c/0xb50 fs/9p/vfs_super.c:120
 vfs_get_tree+0x92/0x320 fs/super.c:1933
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount fs/namespace.c:3848 [inline]
 path_mount+0x7d0/0x24c0 fs/namespace.c:4168
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount fs/namespace.c:4374 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc87f59e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc880402028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fc87f825fa0 RCX: 00007fc87f59e159
RDX: 0000200000000240 RSI: 0000200000000200 RDI: 0000000000000000
RBP: 00007fc87f63503b R08: 0000200000000180 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc87f826038 R14: 00007fc87f825fa0 R15: 00007ffeeb3b2c38
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

