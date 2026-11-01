Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DA5606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1516B05B2; Sun,  1 Nov 2026 13:25:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52496B05B3; Sun,  1 Nov 2026 13:25:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68146B05B4; Sun,  1 Nov 2026 13:25:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72F5D6B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:25:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7F2B1C447F
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:25:31 +0000 (UTC)
X-FDA: 85387378062.23.524882C
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf18.hostedemail.com (Postfix) with ESMTP id 507DC1C0005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:25:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3GYTnagkbAB4MSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3GYTnagkbAB4MSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793557530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=CMF+rDxX3I6Jh93CcarKiFP3ZLIidiAmOkST9zJjDqc=;
	b=Kl3Bd+W7B2GEY1WYChWzEG8pN3y14++JxHImjLRCbdgkoscYOtxlDC+WAfVJiIPIseZwsZ
	+hiYayC/rO6zmTNP7mjo1wDo/pTH+YCoZxmd5vkYM8UsDlEs+lQm1Jx/njlfISjSY0veES
	N5/873ljh9OLMfG0DzX36QqTVeBY/Ls=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3GYTnagkbAB4MSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3GYTnagkbAB4MSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793557530;
	b=6wnfx7ICHCFDiS/0iYofMTdpnWHCIhww6VAuSSK94rZyFq1+QghHJtACjhVL/sm81Vo//o
	cw3hzqikMz/6Dn1zII2xV8vIk4dxGSvPbaO9umLOSrllDcWjevTIQs3e/93UmRgb3Crg6t
	6XUnCU5JSJliIfAJl0TgLFkeh9i+wuU=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-547ae874949so3689052b6e.2
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 10:25:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793557529; x=1794162329;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CMF+rDxX3I6Jh93CcarKiFP3ZLIidiAmOkST9zJjDqc=;
        b=Npt7r+rmSsEGRsD3Kgn1J7rD6javaA5vLwKfbQn7tNFYHOnnKp4pZ+kXTVRnSrVhzD
         yHV+Lki8uee/UAdXSs+VhP6ygqFYolg59CMdXCubAgx6seHsD8iBU792HEwWEiplG+eC
         P+XLgq1jmOAKdJZln6/3WwKVBn5IMEp85iGwBh9mHYwrV72nc01DnPP7QL08lhlnUFaA
         RrUWzVg9iZUXXUC1fHnsoyZJ/gUU+9iT6UjdwLubWQkZEi8+qBMyzf6xQkOknqfjfUyR
         TlQSmhhjlPwBQHfLLGDjaITlh6wdw/+eg7QyIFYhSh9Y2IfBCjpDBvCElc3FuSZsCMNk
         3ItQ==
X-Forwarded-Encrypted: i=1; AKwUvBxZ8hoNE0NiL1i09n4aiQX46w4KDl6wfjO15BuH26Z0lKQQ+Hg10xzdaAKvX2+7XlCk65H7ZxSKdA==@kvack.org
X-Gm-Message-State: AFq9FYKhHfavDT1qEXlA816jDoqRBmgbxlpDom5XRtZS4vOkunhUH/AQ
	T8sY5geJYvIqiExlUTjtRulgW5XLjhj5Ui9f2QAQ4BaTgMAe2oIR5wRoTbl8gnX5wrtmoVN8J7O
	wnVnjXeilld3eSzt7t3zSkb7IzHo6e83uU+cU3E/Vx8v6JFhrTU7Gk7SvtAs=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1244:b0:510:7dc8:5ff7 with SMTP id
 5614622812f47-5640deea651mr5941698b6e.19.1793557529004; Sun, 01 Nov 2026
 10:25:29 -0800 (PST)
Date: Sun, 01 Nov 2026 10:25:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae78418.6552420f.2a0efc.005c.GAE@google.com>
Subject: [syzbot] [mm?] general protection fault in validate_mm (2)
From: syzbot <syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 507DC1C0005
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zd5pyfgwdaacifoerzxqktptnrj1szak
X-HE-Tag: 1793557530-183917
X-HE-Meta: U2FsdGVkX1/QFuKSMEMn2/FczBrA3EwiiM/gcP+jZmALbcVLX55OU0t/4WQLhUxtvMPuM27IjDOeVd9G7eK32aPb6egINJFMalBR3h9jbCyeEbxE07ulCei+6BcEmmr01T1Ej34GpmnF9e/h+vMKputRhFA3nmA77Mz7E2wURIl10WLqLo4Y9NG8RpdOxvJwTRbPii73sv1qj77/0qPqw1JxIUQ0GDmYAuz4pqjeZFOMmkFs+bS7bMqBxUeBkC+8JxAg1ISW6uQqS0e5n6l619UrlFMEEKEw2bMYCLnXl9RaBy52u5ULqfx965X/0OUf8oO1Jg3NqRritRV5mdsHeVlFJV8YiY4WU6yPGZtfti0MSNY/ahR4zYzdqdBBotADqP4UJC3DFVRrI5uAdvu5ZHo8u1P0Umy2gac25kWnK7O86aSRNZvc7kvEo9DDF5dKfua0B5hC5Pg6yT8wR4WWIKKNsrucYp7lzHCTvMbS293BES0DIbqytvAbubT1UofACKIfs9Wi+k2pNTcR5hYIMIsnzcOcnSufveA//5UfBem5Pp28toIs+BNClruVlePB7kpvfVjUfAWxpIEKo4QkMINIBjQnT7H3VpZsezyVaGofE+iiMC1RowYK9xFS1J7NjE3DprbXsNDQW6Cn8OAwZZ6FT6ZWqepjMfedwDwUukU8ZvbszIbpkxImzYEkqJKfExEK1JzvxxU8u16sOOUjZqPx7EcgxwGjtsKnwtts0se9C2vUO0cgCf1MLhlrGSddlTUGGYiRiveA6D1Yra6bKRWXWDMuXOyrHbCTIntyVs7+DWSVvbn8Oxp8/JueUHpfaMf3rfrlE7exC9xs9Wh5qoauTcS2ocOUYPciS6VGKKBawVx+cJfNofr2jqMadLxUNSKCw5Xh39a9zWqgPTgiANaOf1a8fK7ODHb1Ofdt6Y17vNYCpf9RrXXYxRz3PoKxtAc5gjnAT6GOJ5LgUtr
 OpiZDWZT
 saI1pDQ6FZzXWIdconTHbAjqqy0k5C1dWp1/zbl6H/K4s+7jwxRXteI0EUYg8iJi7LvwZK+po4AESlp+vpqO8DTy42BtuYc/a7Q9smfJab1NHyZdZURu3779s+F8dFp/HZX4w6AYRNf+DxZq8Xcx7PbkBM2wiZ9whAqEiImTmP+7Fn/5Zjfq7MB/Jh7A3OphJy9llzguL53DQKYAEQhfOZerC87ig4AjOnXyJG70fZL7kQCTqSN1tfEW28w/xOPK0utjeT3k14HTocUQJqzVNwtOUjGoNLCHhbAILWVwEKGyR9gwkdyNF+OOI1I51no1zzxrEuvfUG5/izGG4DVwkh6x1fpEyfAh+xtK4ukIl0tHsre/kT9nDEbmHIhcMx9PfUI4ndOfKz6MOUXJw+CZSb3u8U1MUxsYodsWO3JR8yVojPSiduD9XIPTLAOwSE94hwHa0A0XapyIjGtjNY8MS7RZ2fK/Q82aq6zT4J50raaveeJ0qjPgDWJjYmRaoFhRCeUxBT8K+jQWjvwf36BrN8HBLfNgBrVL6XmGlqiJ2dCmxNDGYYZSR3QqUm80zYxTlcp5JXFs1/ELfvMdGlqI8zYsCIdXZguf0N/nOE4W6Hyk70yOP1NB8uNmTpXxJFrQUH6gRdfb389WJ/du7Ems05tbu0VeByTmEqTrCbrTa+BQxPYYLI92MP0sXyErgKaicP6MaSTxxFqHwnwuD0bBWJ202kUHy8ONsfaxQYrVQATyWDuZJ5h+AjfPY5q1CVb9ablWITPFp6dQlOPgDceak2/afHljDhYxYn9HJm0qNGYWU9iHdwf2SsQtty4MY5WR6b3XU+9zD/tBxCNvptG2IsnVQKEIm9OxNj+539gorQ58PtCbA+HQHlasbVpgWbOCp70jlXKZ8et1QeceFEzdDK+iUmEljHQbVn3xT0fjjH7wLeYxTZ36h9BgU6uV6MZN2BH+NSpHWMUmNvSPT2GFpT4NpNjAq
 qAuMS+GD
 d5l8mKsf1i1hq0XY1pmAXdg4dxmrk4ZvB5c1YRzCZquSlvXS/Oz4WLUrE4ewTBUcSzGQhOOwSNbyWA3NpJJMtw9vt3U7VIUrOuBvAOfdKp+CLsSJkCfW4bVPMdqojcbi/ketFdipIyMSSacKY/zEZx/DtafyNyVwD4UH9zhUsNJ/D1mkyvIl5Ew1v/yPRfkCqG9lWO1ghNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot found the following issue on:

HEAD commit:    36aad21d50d1 Merge tag 'ksmbd-for-7.4-rc1-part2' of git://..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=12b81cb1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd712e5dbce1d1a0
dashboard link: https://syzkaller.appspot.com/bug?extid=10e72ea5747737bcd2ad
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a58f95580000

AI-generated root cause summary:
In validate_mm() (mm/vma.c), struct anon_vma *anon_vma = vma->anon_vma caches
the anon_vma pointer at the beginning of the VMA iteration loop. In
vms_complete_munmap_vmas(), mm->mmap_lock is downgraded to a read lock before
validate_mm() is called, allowing a concurrent page fault on another thread to
populate vma->anon_vma via __anon_vma_prepare(). When this race occurs,
vma_has_anon_rmap(vma) evaluates to true by re-reading vma->anon_vma, but
anon_vma_lock_read(anon_vma) is invoked with the stale NULL local variable,
resulting in an unhandled NULL-pointer dereference and kernel crash.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=10e72ea5747737bcd2ad

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 6142 Comm: syz-executor263 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:anon_vma_lock_read mm/internal.h:315 [inline]
RIP: 0010:validate_mm+0x3d4/0x780 mm/vma.c:707
Code: d2 e0 98 ff 48 89 df e8 5a 10 f1 ff c6 05 db a8 dd 0f 01 90 0f 0b 90 e9 04 fd ff ff e8 b5 e0 98 ff 48 8b 44 24 08 48 c1 e8 03 <80> 3c 28 00 0f 85 25 03 00 00 48 8b 44 24 08 4c 8d 63 30 48 8b 00
RSP: 0018:ffffc900040d7870 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88806b186000 RCX: 0000000000000000
RDX: ffff888000794b00 RSI: ffffffff8274c56b RDI: 0000000000000005
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffff88806b186083 R11: 0000000000000001 R12: ffff88806b186010
R13: ffff88806b186040 R14: 0000000000000001 R15: 000000000000003d
FS:  0000000000000000(0000) GS:ffff888095281000(0063) knlGS:000000005727b3c0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f7f72000 CR3: 000000004e463000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 vms_complete_munmap_vmas+0x83b/0xdf0 mm/vma.c:1437
 do_vmi_align_munmap+0x44f/0x5f0 mm/vma.c:1677
 do_vmi_munmap+0x1f8/0x410 mm/vma.c:1725
 __vm_munmap+0x196/0x3c0 mm/vma.c:3562
 __do_sys_munmap mm/mmap.c:1094 [inline]
 __se_sys_munmap mm/mmap.c:1091 [inline]
 __ia32_sys_munmap+0x57/0x80 mm/mmap.c:1091
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:79 [inline]
 __do_fast_syscall_32+0x14b/0x8c0 arch/x86/entry/syscall_32.c:282
 do_fast_syscall_32+0x32/0x70 arch/x86/entry/syscall_32.c:307
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf7eaafbc
Code: d2 74 05 c1 e8 0c 89 02 8b 5d fc 31 c0 c9 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 2e 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00 58 b8
RSP: 002b:00000000ff8ab10c EFLAGS: 00000296 ORIG_RAX: 000000000000005b
RAX: ffffffffffffffda RBX: 0000000020088000 RCX: 0000000000001000
RDX: 00000000f7f70ff4 RSI: 00000000000000fb RDI: 0000000000000040
RBP: 00000000ff8ab168 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:anon_vma_lock_read mm/internal.h:315 [inline]
RIP: 0010:validate_mm+0x3d4/0x780 mm/vma.c:707
Code: d2 e0 98 ff 48 89 df e8 5a 10 f1 ff c6 05 db a8 dd 0f 01 90 0f 0b 90 e9 04 fd ff ff e8 b5 e0 98 ff 48 8b 44 24 08 48 c1 e8 03 <80> 3c 28 00 0f 85 25 03 00 00 48 8b 44 24 08 4c 8d 63 30 48 8b 00
RSP: 0018:ffffc900040d7870 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88806b186000 RCX: 0000000000000000
RDX: ffff888000794b00 RSI: ffffffff8274c56b RDI: 0000000000000005
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffff88806b186083 R11: 0000000000000001 R12: ffff88806b186010
R13: ffff88806b186040 R14: 0000000000000001 R15: 000000000000003d
FS:  0000000000000000(0000) GS:ffff888095281000(0063) knlGS:000000005727b3c0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f7f72000 CR3: 000000004e463000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess), 4 bytes skipped:
   0:	48 89 df             	mov    %rbx,%rdi
   3:	e8 5a 10 f1 ff       	call   0xfff11062
   8:	c6 05 db a8 dd 0f 01 	movb   $0x1,0xfdda8db(%rip)        # 0xfdda8ea
   f:	90                   	nop
  10:	0f 0b                	ud2
  12:	90                   	nop
  13:	e9 04 fd ff ff       	jmp    0xfffffd1c
  18:	e8 b5 e0 98 ff       	call   0xff98e0d2
  1d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  22:	48 c1 e8 03          	shr    $0x3,%rax
* 26:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1) <-- trapping instruction
  2a:	0f 85 25 03 00 00    	jne    0x355
  30:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  35:	4c 8d 63 30          	lea    0x30(%rbx),%r12
  39:	48 8b 00             	mov    (%rax),%rax


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

