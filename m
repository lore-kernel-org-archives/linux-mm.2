Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52471C5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 22:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367F36B009D; Thu, 20 Aug 2026 18:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1E86B009F; Thu, 20 Aug 2026 18:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA6F6B00A0; Thu, 20 Aug 2026 18:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6B696B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:52:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C00B61402B8
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:52:45 +0000 (UTC)
X-FDA: 85123149090.11.E136519
Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	by imf06.hostedemail.com (Postfix) with ESMTP id 276AF180004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:52:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3O4WHagkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.205 as permitted sender) smtp.mailfrom=3O4WHagkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787266364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=B6SKmu7d1mgJbjunUTptXi0qdthUgUNGQr2MeND2xXY=;
	b=H7x1QbP5YjfKGRE/vBHHfDLCx22FAAo+jKBUdYsEA38TnE2jS8i55nN7vrDtwop+p9QD2d
	tBniuw2Z3WfR+20D2G7hSn3ZM7CA8Mg3GbtfFmGUIYTej7jwOQ/lPM6sTBeG1bFDAENohE
	U6n/hQFReRbloz0mfyPfajFI6dWiCdE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3O4WHagkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.205 as permitted sender) smtp.mailfrom=3O4WHagkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787266364;
	b=5EyyY7q0ba0cweiTepwoMEeyQy6y9ALOi91ilVaL5KdQ+0et/i6k0+cB2f/6HSVNGa8Qys
	E7uz2QLwXYTGiaxTNSTzM+e405EHY4NiJ7BWQFYtsv/C0MI7GaSiqERYMy3KtAuPOnDIYb
	2yoVe+XVam1vuCosnG1YZNUR2XfsLNA=
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-4a49f09233fso281260b6e.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:52:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787266363; x=1787871163;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B6SKmu7d1mgJbjunUTptXi0qdthUgUNGQr2MeND2xXY=;
        b=gGZZOJo6b7cE09a5eWasUBcuSLge+4SZ99GlTGJEL3aYF4wjkgUlWYMeZpa2tZvqFa
         Rgv1A69aZ5lM6QVN7HFYrGKlekhERP4S8bSpjAjNLLq8Ci5CVSqxCevwjkHRBHms1GQJ
         qBZaDc08FWEGqO45A8oNBEMVBbqf9f8N8aZJV7zcMRtGuko+Rk/C0VCKH6CPPFnD+Yxr
         iskbSuOhemRZzdjiChYLMX6LJ91wV6ZRKENA3Yj/GgvRtFS/4VfgR0T9iwn53mxn5+G9
         5weWhAapm2G1qFj+QQeqFgKSEbf97scZ0BAQ4Tob2l2QtdcbI0iLKTOk8GGDaLi1sypB
         fkRA==
X-Forwarded-Encrypted: i=1; AHgh+RreK3lCyVcHiQIqlGWix+MY62gGJnjSCjS0MlGgZfXj4mz4yruIc0yfm6CGmExc5PwsGvDhPU9eLA==@kvack.org
X-Gm-Message-State: AOJu0YyAmC0aOU7bzfzqYGh07oEj7DCAeIibZLYCsKMt/n+3DEb2mkD1
	4foGsddPG+19feRtb11L6hEcODOQ5LTDkk64UX6NL3qyOg28NYCUwyO9GNp5Hch8gegMhnnOzZn
	UBobEzDKYo6w6xMI9Z8nfEeXzPcCzveht3pIqvMSXWKXZmUsWm9pFutQ4lgk=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fcf:b0:495:f697:92d9 with SMTP id
 5614622812f47-4b2cdbc6a87mr9595234b6e.7.1787266363199; Thu, 20 Aug 2026
 15:52:43 -0700 (PDT)
Date: Thu, 20 Aug 2026 15:52:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a87853b.ae6ddae5.3da009.0023.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in vma_set_pgoff
From: syzbot <syzbot+f12658786a4153df5113@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jnswxixe89ro73sggytxd1363835puat
X-Rspamd-Queue-Id: 276AF180004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787266363-926123
X-HE-Meta: U2FsdGVkX1/y+xEfgqwHpm7X7jt8PRHATgh2qzT2dDS6r0QnpMPvdtv9QAR46AEpYeWmqeI+KJRIpB7dGBcVuEGqHJiy0vOS3lIL4oJ9s07fAoEArGUDMR1TRBkXaogeSJbp6AQEXOvY4aubITHeKQKhKue8JaEJWeKm10D0KHo7f/RTbnS3EMNQSjTrAMCH6QwrKP5IaqqPm9LwKDxN5rClA++XzmxloNw/64FlFWWk40KH47ao1YaO2jnKubPUP8e9tKRcsZtfvkTg2Lk8FEOAlfPcLCxkxpEnIU3b4LL+ORSArmzcXDUmYmlmVp03WRGrfBn8dHeB+bBc0rnVVndUa26ngSIBtzOACEA4Zp+8NqKAyoVGS0ucHUX6hm+F1wCUvOtcy7X04WPitOsZxXnq8kK8bZGr9y+S51Ql3LNDKzLeA7Q2tbMw+y6Uj0z0ihNzMF+MsClnKdJ4vz24njdxBJS8uPDjoOlRnwGLRFIGtY05Mc54XPqiIVtUUzMQcKKX3E4kjaa6TelFzbPyfPiTnGghwQBJbGSB50K/8qjQVK5mOrcQ3GNqouYlYTo7teJp59JN6Rr4JETK+/6dMRCcYbaWVwZT/jFBk2pH75qLMuRzXKfY46ki9l3hosGl7cryKIoKFx2yGfysuRTQUNbYEV7RcutUGGSHBZxA4R2sspPpwxQH/Xi2er3Z83eyJWEFSPIpWtGrfMyWcdm5zYBrM1pm0Id9NiZauN3VWvi46aykQbuqHGWKjYPBdow+66g7VDFz2KlO2aMLSxK4TIWmuILt09v+PQ6bNUDFL1P8ihbSAktCcskNqA8aLHJ2xeQWvuey4ENv1YPVBrTA6hz8byP/3s0lIMSOmD7LJtaJ9/rCZ3KFjwQnnQoHuPnYiXiFiDeXCpAR+v7KVkr+oKgNiAoTL9AGVdPlrjfZdXiqAozxi2dBUEPZ9pud2jvf3YFq7m2J2BJK9eGOHcV
 TJbOZy5D
 LgB5PbVqgm3C9PcZaeXlYne/q0abBOi7IyCpWSx9SufPeQMaQ5GizW6m5v+FsYJTV9v//hd4yDU4CkBnMzKnMYTFoNwkg7jEDqTptcNZLEdfS4cES3bqom8mCCcuAzbIRZUugominIGxC0gTPMduV5BjtHWjxYoFd51UjeJyQe8mCiH1TgpOeyaNc8arT6MIxA+olqp4wMp5OLqXxiyEJ0PQYXrQxEBsysDcxH4HODsI4q4Qdt9V80pXCy0kRG+qxx1u1Ua3rPxutzf8IlcnjIooln/NE2p1s44+qg1TzeT+6yiXgwCZ7+4Qj4IQOPgNmN7kN5K/GFpqNLCtw097j7eCKFYtMv2lGXi+80JP9hYaWrG6hAZJH8BPNWPUfaVXVYYLehqL4C0h7gb/rXoSgCBrBKaPkMLyeyS5vsTXYcFQRPfwTWubk1IUWtOdtzo/za5dU42V+s7hOrmDBMAkfNPeyMBUCD6SmarYbHRH78rsxB+ZPE0ii1hEMVdmpzjW/2TcJgf4T/meW2uLlip6VFIXx1IC89hzkt8ywZwSMZffIsQkIq7vQhp/rRM9LWD0v2rIwmK+AlxCc3Ryth5JMAhm/n66xIwpT/MPV7rajiOQ9h+jLEAKOJHBPt8SvqfzKqLlQ700HE6qea258X3RXmiMrY5fOA4ArxEt0XzaDIrG/7dPFqlTCpe8+Byn08BKpxURe8Z7vGO85T686SfmNb5QjDXeJKXElP1vepmPPnB+99lyTuANXpNg8HCOoBBFGKRox2wP0GN0sZwygalAg/Escb5jNDZg7VP04qezsMPLqwD9TOpBEcIIUymPHPoScuu4nfWbBv7vSf3DC/oTvg3y0qPShAeEdE00UJ2oB5bGS72NFhbwc/KVGRXDAYAtuPqteq97CpYkoZKp7GjQ/9T8tWr4klfeGieOyfjcESQGECFS39I6o8E33mBROaVxR4kr30x207Bs92/iM59uUPNTzYdAQ
 UzflP0+M
 4mfsQ0y7YI4KA6trh1X8MLVhpf9dN1nWl12I8OPg9Kdy9bCyoOJCcoKb2P4qcHGyNEBn9pRi1BM+NXzYHCQAb8lk2ulMWJShCNyNMtZeP/GZi+43IQPF6sz3Yp2VGyNk2aODPme+feBShZkxbfIRTtVtlvbvNaFt0DvLdBNN4zF5H8TY9cjh4AwIPjYs4mqgTC1sgx+du4RTtWGKK0IRKfAeIbqaiqa0crKkpnzAyh0CNIWxODpzpbuRkbBiWfQA+Sqr90dDhb2NUwKvUnTn2oVWfsTWfgNyY6OG519X436HlA48RS8sR47yB4LkrAUfkpy4kJkykMOqfo6PMx2d5MuVCHLCvqBXuaLw03kftGBowcII3LbOq2QTG5u5IgcNVx/caRjJsgzz09OAbMstVY1iXWvfDl8hRlOWMIXls1DhqfaEZSAplQJ3XNK3YHn1MvDQW6KMyKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    4477a78374a5 Add linux-next specific files for 20260814
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=137fc679580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9b32a36dd637b06f
dashboard link: https://syzkaller.appspot.com/bug?extid=f12658786a4153df5113
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176d5949580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/994c1c8c560e/disk-4477a783.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cd54543d69ae/vmlinux-4477a783.xz
kernel image: https://storage.googleapis.com/syzbot-assets/407cdf8f3fc2/bzImage-4477a783.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com

------------[ cut here ]------------
pgoff != vma->vm_start >> 12
WARNING: mm/vma.h:277 at assert_sane_pgoff mm/vma.h:277 [inline], CPU#1: syz.0.17/5809
WARNING: mm/vma.h:277 at vma_set_pgoff+0x246/0x2d0 mm/vma.h:283, CPU#1: syz.0.17/5809
Modules linked in:
CPU: 1 UID: 0 PID: 5809 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:assert_sane_pgoff mm/vma.h:277 [inline]
RIP: 0010:vma_set_pgoff+0x246/0x2d0 mm/vma.h:283
Code: 0b 90 e9 d5 fe ff ff e8 a8 ed a0 ff 4c 89 f7 e8 50 5b 01 ff c6 05 b6 05 3c 0e 01 90 0f 0b 90 e9 fe fe ff ff e8 8b ed a0 ff 90 <0f> 0b 90 eb 9d 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c eb fd ff ff
RSP: 0018:ffffc900035ef748 EFLAGS: 00010293
RAX: ffffffff8226cfa5 RBX: 0000000200000a98 RCX: ffff88802733ddc0
RDX: 0000000000000000 RSI: 0000000200000002 RDI: 0000000200000a98
RBP: 0000000000000007 R08: ffff888076188bc3 R09: 1ffff1100ec31178
R10: dffffc0000000000 R11: ffffed100ec31179 R12: 0000000000000001
R13: dffffc0000000000 R14: ffff888076188b40 R15: 0000000200000002
FS:  0000555576422500(0000) GS:ffff888124df8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9f85a70000 CR3: 000000007cdfc000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 vma_add_pgoff+0x1a8/0x570 mm/vma.h:314
 __split_vma+0x89e/0xa60 mm/vma.c:607
 vms_gather_munmap_vmas+0x322/0x1370 mm/vma.c:1507
 do_vmi_align_munmap+0x2b4/0x4b0 mm/vma.c:1675
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1732
 __vm_munmap+0x241/0x3e0 mm/vma.c:3390
 __do_sys_munmap mm/mmap.c:1094 [inline]
 __se_sys_munmap mm/mmap.c:1091 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1091
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9f85b9e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff50d2f8f8 EFLAGS: 00000246 ORIG_RAX: 000000000000000b
RAX: ffffffffffffffda RBX: 00007f9f85e25fa0 RCX: 00007f9f85b9e0d9
RDX: 0000000000000000 RSI: 0000000000004000 RDI: 0000200000002000
RBP: 00007f9f85c35024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9f85e25fac R14: 00007f9f85e25fa0 R15: 00007f9f85e25fa0
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

