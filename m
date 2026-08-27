Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA95C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F4F6B0088; Thu, 27 Aug 2026 04:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE81B6B008C; Thu, 27 Aug 2026 04:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0C06B0092; Thu, 27 Aug 2026 04:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89BD76B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:33:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0226C1A036C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:44 +0000 (UTC)
X-FDA: 85146386010.18.A8DA2D8
Received: from mail-oi2-f4.google.com (mail-oi2-f4.google.com [74.125.231.196])
	by imf17.hostedemail.com (Postfix) with ESMTP id 60C1740002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of 3ZvaPagkbAO0hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.196 as permitted sender) smtp.mailfrom=3ZvaPagkbAO0hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787819623;
	b=IpUt3cTK3WjXHLxskd1zNwIfMzmpRD+x4Oh+Kl2U53MKqajMRebAmGZ3R1sDoS59T9RQRk
	/HCkTjs4F5g6a1/USpBWUNaQh68GE3CwO6WMwXaJJW4KuTczEYXEFnXaeOBC7PJIG951yO
	HOuRpclXhbVZCAcBkErt0GEhZGW1A1A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of 3ZvaPagkbAO0hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.196 as permitted sender) smtp.mailfrom=3ZvaPagkbAO0hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787819623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=n9SjqDQMP4d9ke7LBuq+8qIZQA/L5115Lypl+jgL8Ic=;
	b=phlpYmCDIGVVoAp3ib+YKplz5Db2GAZgHxgVI5Lw2PYUtTLzxnLLXiQRqAf29fl/69EXjp
	SUCIjyxDDLGXzCatTUd0g3DcCpiFzYZwhT2TR/c6g3RhkIMQp9QtjBkRX62lx7V0Bx+P+k
	4PWAQEDGFgvkJi4KNfmUt5lE/vJpl/Y=
Received: by mail-oi2-f4.google.com with SMTP id 5614622812f47-4b3880be385so102236b6e.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:33:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787819622; x=1788424422;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n9SjqDQMP4d9ke7LBuq+8qIZQA/L5115Lypl+jgL8Ic=;
        b=i9YFIBD3acoNO1p6fhbNMhWgSsMohInkgJsY/ATINhDeLHIOWzq04404HBjK+8ajvn
         xUxxIKmkSIrBV2QJd2UMKYbu0ZMowpoL5PaArQOemiTqz0Lws2Y7sDCOqmhombKF64ET
         ynmRTIwjKW/JAvOpVFl9fzQ+LFziDi7CxcJIJG2nirombGw2I3ojyk4kWd7wS1IvZqsU
         iEoBzKtudfCxvhNxFrRMWev5oRLMrgjxUi1lPUz+A9Y8UIZMbxtP8uV06ar+SUh0ud3k
         i9vHynjHYsIualfLp+0LUExOFJJN1q0HYNqlqX8AKiXSCO1Xf/gXUsj5aG4Kw3zhL2lX
         A/bQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq0SbPAbNINIi28R8Cn9oqxt1LMcmykh+hd+qZe3bT299Sjs0a81HyEKmpWW03UHwPTtZQYI/Incw==@kvack.org
X-Gm-Message-State: AFuF++lV3ITbcssCVNtoRIuT+nH8OXM5CjoWPlYv3p6i497NZJr1ZI2I
	VQk7MOCj+1ttiYnCppI1bHe6GPPj72D9AwIHmbQ84z3CQiDNqpAPhC/lJGA3O5YyzX6m6NtuCg9
	JiFBzfXCcL+PWsCRcUdLpbfFP8qbu66cxfxsHNsV4XAPUUN5tCQ9sO2guisc=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5184:b0:4aa:cad:cb4c with SMTP id
 5614622812f47-4b366908457mr14805744b6e.1.1787819622498; Thu, 27 Aug 2026
 01:33:42 -0700 (PDT)
Date: Thu, 27 Aug 2026 01:33:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8ff666.27659fcc.2ceef7.000f.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in __split_vma
From: syzbot <syzbot+5c417b73ac02e0e352c4@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 60C1740002
X-Stat-Signature: 16eci1zm87ddia6fkpfr7mkd6tm7fkox
X-HE-Tag: 1787819623-445058
X-HE-Meta: U2FsdGVkX18aELlwSjNuDLrUSurJ6oey1MpCiwP6GfJ1W32pyTawzAusUPuHJhYeWDiA+If9K5z845wgdSKnIYQXZHl/Ivu5JrHznwy3+620s5+l6u2z38M29oK0pqxpHvgADFFEsA/NNVTox+d9qMl536vQ0u6wd2ghc5cOxcHOTz5d+E6iV4ZhCTML7mUUp9AlSw+fGCnGnaQXhqt5C1RB9XZu6D8+YVjuAuPttnKrrJq7xsJZLjScTh63xU752W6mTOVFIS7FYKO4yIj8dEUBmlekHz/AvwKE9Ib8+sanoPlK0tcyt+MpkDmOT8xHWpofJ+BAvgOs4f/bmhYOPVyQ4gzomnwRsge378bQzQinj/bj792lLnOJh3g+CBMXOhty1NrIKlC6WjflrgILncnDtvY302Dxpi7HdI3OugeX31NrfNHKpcnY9HLCjkHM8aniRNZZeTzhEdlVk/rS/fSI/TP6UtecTBu1IQkForzv7l6LtOH70mpQ+VW+gJuUBM6zkGJS+QfSxAA5Jaa8LifHTCxGtmrMTluRAQm5RK18dtj6T6rH3gbxAKGd87jAXstXa9Id4iPImZpu2FjSe78AHPy6eqg27crl1MMFrVMclFhhNTbXs00B+q/9AqVXaTNFk0luyWP3gf0deJC7M9PpKP377stKcoBjg//vKawRZaje4osCVgSGzX81UH12NvWY2MKlPv8UcxrJO9OHI+7SR8v6NJn2oxqsYNZ3NUKricuYSEQ5/etJbmvG+kFtE4SDxsf/pKGQ1t3kiObW1lY5FB0JYbEQqyb3S6Un/5F6oZhHhaLUGm/5e0NxE9L2+LRrVy4qYRVghZhG/fKQzRM+AsYA8wL36+C9WNNLmz8mSO0lwAY9CQ1u8fZOHUEDRnpzKSiyJHxx3rTDIqrOFoqbqEytQY5kxmC7qVxqofEp+866s6T6fYt91kUXqFvcf88E9dGeIXPJTUZZJG7
 Ey/eliXG
 9B12Uh/9kWKQ82wkhxsKCFZSu1Zcu6NhWBZbGUMQ48xO1m2FHwyR8Ran4lA933WCPMexssvzlvW+HSbd0GSA3T5SSYjHnc1RvF6zNW5MIb3mGBe55VH8snBcjZHCtZWk31GA/GILSlY47MdWADBnrflG+hdbdqfMFrBRK0R/XH9iMfB4GX0UUUEONB3UZsPtyzx8uHG0W8r4gj3A1PPnHWDpBpoaX4IdQXYME+/mXN/ia4/yF/9sXqoj/rXqvZNxikHzB3e0U//LS36CgQ1IwVyGGlpB9aN/XNNvOSVE3upMaNQgJuFeW1UdRq58mvzq01kZSgOmVcED7Ul+LUn3tzytO67yE5dzIkAhfTj8lts7ICktIXBLwbIdet19Iq+N5d+avivTa9EnUPzA+QQl2Lhznzq7niFPMPHyCf7OS6Jlg4s/Nnt14G+uqdwk9HKGy2jcS29HWCweD2mrDEWeTrOukUoWuKM5WBYn9v49mOVV5uFssgok90WYwaG8q4fh0fbv6JaPTqsHMgda6llKOhCt71hAZNENgrszO/bwybi46swgWuILr+noAg9tR0tnBv/v+At1m7ax7W0L5uHoaaa5ZTzL1llTwo3eKDbNRCT058S4oQBfy+MAy2tl2cVSRHVXzTDKUUMGrLjUKbGNndjne8a/cjvSKdKks+TRPZTvl4svHBgMIvjljXSMaNUdo2B3lny9tPKr/pKCnMgJv5T3Nj0oQIb25PLBH1xHAj5mhWxMp3cO03CX5tXfbc6zKBlTYDmsPafNP0j9PzsTwGTMnMDQWBvUewlZYNb0jWl0O/1E5XMzC2GRXEIdIiN2vV91St4hPNK1RLBaktnbZVx2K23DEAlNDeAlWwx0F8OuP0z58fJGHcMW4tzhxbQW1mmvPaYp1neQOhELpvZ3HzxqwHBJ7sPkZ654Cd8d8uUMBMfhWiHw2L2qjL96tmra2N0vWartdrwf0pR9yGPvuXVRWhZfa
 peOWnHwm
 VdkzCpGUl3eCcnAYMlIqWSGqoImY/9/eVQtO+w3pxUyL3gqJz1v35JgQmQ/tLzZRF4m4sgIJR4y2YbtosBd4UfUjmZ2HUpFUTlBx2kvyExEJXoDK+vTv3bo+tx/iYtA2/qdxjduh4175+mTCwVGaEBmi8Ymsu9wF5AfWro9scjz3BIq26YUc5kH0/qziEiElXI83m4xefOYBIzR6NQuXQNnbNHYcqKoLjdMHkmc/AntqPA2POh0mZlbVC+8BGbD/vxYTpeHDO19u+1moGeHsf6C6ixg2y3TgpxcdpK6WceVE6RDQaFSvjrmOcRDhD2khpI+rfD7qXiS+uHXrgV2nkZoaGHQirqIP3WnTkKNr6nCiW49SaN1e6E6s9Wr5irp8m3N5vq8ilJVF9EpizCXkxiJaaQn+SZit8I7U1TlJDKkBFkXNquRXr+xHqy0cycNPP98tMkuzRL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1645f979580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
dashboard link: https://syzkaller.appspot.com/bug?extid=5c417b73ac02e0e352c4
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104a0d49580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f35979580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-818bebeb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6e4100526b12/vmlinux-818bebeb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/723c4783ee96/bzImage-818bebeb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5c417b73ac02e0e352c4@syzkaller.appspotmail.com

------------[ cut here ]------------
pgoff != vma->vm_start >> 12
WARNING: mm/vma.h:276 at assert_sane_pgoff mm/vma.h:276 [inline], CPU#2: syz.0.17/5920
WARNING: mm/vma.h:276 at vma_set_pgoff mm/vma.h:282 [inline], CPU#2: syz.0.17/5920
WARNING: mm/vma.h:276 at vma_add_pgoff mm/vma.h:289 [inline], CPU#2: syz.0.17/5920
WARNING: mm/vma.h:276 at __split_vma+0x1228/0x1800 mm/vma.c:578, CPU#2: syz.0.17/5920
Modules linked in:
CPU: 2 UID: 0 PID: 5920 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:assert_sane_pgoff mm/vma.h:276 [inline]
RIP: 0010:vma_set_pgoff mm/vma.h:282 [inline]
RIP: 0010:vma_add_pgoff mm/vma.h:289 [inline]
RIP: 0010:__split_vma+0x1228/0x1800 mm/vma.c:578
Code: 3c 02 00 0f 85 d3 05 00 00 4c 8b 2b 48 89 ef 49 c1 ed 0c 4c 89 ee e8 a7 3d 9e ff 4c 39 ed 0f 84 bf fd ff ff e8 b9 43 9e ff 90 <0f> 0b 90 e9 b1 fd ff ff e8 ab 43 9e ff 48 8b 54 24 38 48 b8 00 00
RSP: 0018:ffffc9000344f228 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88803e4b23c0 RCX: 0000000000000000
RDX: ffff888030d0a580 RSI: ffffffff826cbe17 RDI: ffff888030d0a580
RBP: 0000000200000003 R08: 0000000000000006 R09: 0000000200000003
R10: 0000000200000ffd R11: 0000000000000000 R12: ffff88803e4b2410
R13: 0000000200000ffd R14: ffffc9000344f5c8 R15: 0000000000000000
FS:  000055555d60b500(0000) GS:ffff8880d5da2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff66f270000 CR3: 000000001345e000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 vms_gather_munmap_vmas+0x1d2/0x1720 mm/vma.c:1472
 __mmap_setup mm/vma.c:2496 [inline]
 __mmap_region+0x4a7/0x30b0 mm/vma.c:2818
 mmap_region+0x5a8/0x6d0 mm/vma.c:2921
 do_mmap+0x12c7/0x1c30 mm/mmap.c:573
 vm_mmap_pgoff+0x28d/0x470 mm/util.c:581
 ksys_mmap_pgoff+0x3cb/0x610 mm/mmap.c:619
 __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
 __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
 __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff66f39e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffec1164ee8 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007ff66f625fa0 RCX: 00007ff66f39e0d9
RDX: 0000000000000001 RSI: 0000000000003000 RDI: 0000200000ffd000
RBP: 00007ff66f435024 R08: 0000000000000004 R09: 0000010000000000
R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff66f625fac R14: 00007ff66f625fa0 R15: 00007ff66f625fa0
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

