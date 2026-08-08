Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB17C5AD44
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 20:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642186B00D9; Sat,  8 Aug 2026 16:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61B116B00DB; Sat,  8 Aug 2026 16:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5303D6B00DC; Sat,  8 Aug 2026 16:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC736B00D9
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 16:10:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6201403E4
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 20:10:33 +0000 (UTC)
X-FDA: 85079194746.13.0795A26
Received: from mail-oa1-f77.google.com (mail-oa1-f77.google.com [209.85.160.77])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34CBCA0003
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 20:10:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3N413agkbAIo6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.77 as permitted sender) smtp.mailfrom=3N413agkbAIo6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786219832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=CzClKpT45UdPzKPYBztnn32Cksr2GcbB4kXjyAm2OcA=;
	b=8GydFm/DE4UrRmBQZp8z4LSyYaaO74P1JniBDXZF9xog7fK/fTC9j7L6HxVcU/pZadz8bO
	urFipZQVDgf5et4zZGuyQoDihx+EauYcep2dzpDOLzn5LCxxUjdC77woxz04ysqgL7UvSX
	W7oqhJIS2mQjHEuykOA3zNLJefgVANQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786219832;
	b=EqzPxbdGrjJMGaP2HgJk/JCmxQbKCiX68ZpegbUqI+SAR8OMBLIgsZKq1AbKpAvD2IXkhH
	UThTAI+KW7mPQPIFiPsJ6Cfij9BTZ8J15JDH6vG4jfW4ouN/uz5lGhIwoQM3kiiaVbLM14
	bszLBHTAAfFU5ooSDBOBgCQ/pJqAwFk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3N413agkbAIo6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.77 as permitted sender) smtp.mailfrom=3N413agkbAIo6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oa1-f77.google.com with SMTP id 586e51a60fabf-456b5122c7cso3872852fac.1
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 13:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786219831; x=1786824631;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CzClKpT45UdPzKPYBztnn32Cksr2GcbB4kXjyAm2OcA=;
        b=ZyZGObanGoNidzyHjo1bDiiGOgJ4KhfvxBN12tKIHF278QHm/BMLjXUole/DOVEFnN
         RjzTRsiG3cOnF/CNV5SR062TfV5CmhHUY0Wjm2Rm0dhJAAJYQhK2udTmIoreVihawfWR
         9euorckNSOP05eceM6yqunQ5I/xg0DgrN7edBn1i33+RAv29DQ/+2qyrVqPoFAZe3TMJ
         LfeNs0uPAgvT2vBT7t+rzN80P20Ul5qoTNYKKHUGqYHl6+TQh0xF+G6MghdcogT4bFEc
         b4/8ewjltcrhS5ndAL/myzddluwQnECwjGPzqlajIgnFxbNctuUb9FUBF7QOq8NG1zOr
         vJtQ==
X-Forwarded-Encrypted: i=1; AHgh+RoGRitiH6Sv/iVRsTjBPUroHAtumRuXi5Lhbfm1DPAHTlZSwOzh6rub+cknksPpj891RxwtgWHy3Q==@kvack.org
X-Gm-Message-State: AOJu0YzC8Hiyt9aE3NdltpahBjUxyepwx8UMNQA6Nt31SK+bHM59iqf3
	qY4eezorn7l8nE3L0QNuvEdnahaUPKcA9yhw16+u1e4k4ELedRK+Ddb6dd0zax3gGqFH652FT6T
	bt8J+vNJExQgO3IRrYwG+rvRJnE6dfyRxTsTKIf8DFLiqWXKUbfmTFj7SgRw=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:13d4:b0:496:9ee:e538 with SMTP id
 5614622812f47-4b1af69a123mr4067786b6e.5.1786219831127; Sat, 08 Aug 2026
 13:10:31 -0700 (PDT)
Date: Sat, 08 Aug 2026 13:10:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a778d37.01d0871a.3a0d52.0070.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in mmap_region
From: syzbot <syzbot+d3c6764857d7cac5048a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 34CBCA0003
X-Rspam-User: 
X-Stat-Signature: i3qssaskk74bbe8iiyehqpb5gzbgtit8
X-HE-Tag: 1786219832-880037
X-HE-Meta: U2FsdGVkX19D7ihu72tDTsZqP6QTrQ0Y3FHpHPCnhqRT10wPArQALGBEN0GcFNjkVXPbWdHwFp+DrGs8jiFf0l/9QhNipYnEWzhzq/oXO1bFf6sSD+0LQCuT4CD++cmP4jUenSPFqD64UaT8p4iO4owQx7s3Yp04Gae4iwHTj3DhSnFn1wK4D4bL/CtsJmOwRL/GcgK1LR5qI/rdu84DXA6VxvTucjMVQ6a0LjjWDLZRXlvhK3ttf0wx0fpCNkAoD5lMHvWwjQlMlqInUh3x10TTtfeHf5TxOPvjkBBcaupu8U5zyQZr34B0BnYMzL8cdQENuoZoyGFzdxU/ml8tgNa7jdKYG9BJ2ccE6afUFXDQg5gaJoVcxz7IB8C+c+cnXMhoDeHBXuODjrTN945Es5fuBEgQNKxqN9A9WEJPqvdEHYmF1ADLaJpBX/gB7TlSXm8QCdSc6N4J9lkIeyChn0RwE+SOC7kxLvIdpygmF1YSV1h1WdSYvBkGqwV6cYd3AM3ZJsa+b1aakUlNV3foqwdqqO649S04hjf4NAVPwKSiGYIP0zxBQzZ6vebgvfmlYknJZBkBlzsBflRce8mgQ82fBIqh9x4GoFzMIdhZm51fbYuz2nl0xoMFXTjzgL4Akt8nCYRRqvuBwVljNU7g8T1VWYLk1GzKU5Fyfi4h2NAFrPD8iCz/VnQgrNVGVcXH7RcG0dcq9vi7pLf5M6Py+7n8xy0F75fi61NdMiLJx8i5n4OcxqbN19CdmGU7LC+c7TpnVID6a0cZjZjdQuq5fdya4NE1eVhBszHO/8JCs6/lVZdvFB4jw6NCmmuvF5R9fz20Mzlu4yD4S9nmW4IeyxijAlnGotv7xEZeJoxyCI1oBv9hcc5iC3NbS9O17h4PWgFYYp2qyF97B8tNWq6eNrLPL/hYPqoTUqT2UbXpHdaw4Nz9JOJOjCUfGyztmn7Icr2lRyvuQN0boSLPIe6
 GEB5NNx7
 5f4BwxP4PYjUYF1L6B11CxSMrCQA75HMXw7rSPtoFnkJ9cAmHl8n4gF5z1kvoDpFxVuRa2ILJ9nOauisLPinGwe5kPgTT+vaaZCMZ023XTLqUzRpseiM4hPHPdq2zO9tNbh3h5Lu2Ju3rIBKHbCoHWaj2fyTkBUWNMxI+we71ycYMVPKRxdR/hd+8Wm3FltgBES69WWgfru+y3N1SgKxmDDl8a+nmRhZdjp01i/XAF+2ZY2w3joIunIzEI4PI4zVk3+Dt2nr1r6/cgli6wtkU4hlulWZO7uzj5TUWkJLTYV5706hrYK+1mVB4l1Drp2Lv4WkO+3V21Ly832/Qujh/NEiJl+nPcTREbsvMhcUcFhfsehQHymfeMln4EwuxJdVoJXA7HWN88sIXBbhPS1JWdSKTbprfTzEKsmAcTF9IuGrFKSyR7wn9otGhUq690/qpYXvkX8C8zvcP46TrxvjDHA/lq86rIMuPpVjrVNPHTMbaathbVIQJtoTOcfxIrLbX2qTLtCoEUMPJZdsI1kW7J0yIFv2KrtVpg7vPp9kpgnn8/Jna2U0qxnUI6n+iscfyJBE1VYFK1yZ4s4GYJyL2oxIUOKu3KKjbANiH6NWCWdAeYuNC5F7Tn3lpjrMqdcIHzN0Bh7SQfByHIUm41R2XUSy2qb3HukrXcqkPbS9Wx4TgSjaWQ0nsf49K9IIUZLmaqXZ5bcbEEppMBD41W9B58VizgMhB6uZlR7mZpi2sWCOus/aj/2HchHlh6XeYY9SxWoNgl8pzisVJujeKA/HNkK9J587LfGFT0ngntU4D76C6jHJNqsv9H+oiqYwL81qnYxTTXPflbxAJ4ITTOVWaDFOlfQec2ouEvfFbpyS0X84iQEDXRXYti3SZ153rd3ct74iXEbfOO4deE6xh1AOuvLe9cs+sHJ+uIRkbs1xSH3EkIOe71gKQ+lmc/v1JBWMBh1wmDSVX5/pOpBgqCe8OAOoWSnh2
 SvHxJGk/
 qij3Uz4rBeBOSTgPMUxpinw7KbmAPM84DeQthNWUfsA2wg275v6/4ElCZMME099/91MyYK7f27s60TA1znB6zZEDAK0WHfbwHc4cMsgwJ2bPaQc74A+oBzfsaAdhaRGZka7MYqPyaXfKLfeO+xUolkcJ/Kc/y0tKsu1dSUTR8CdpHF2fMhGKQgGtkl29cVjtzjITI9F+IqpWMqlwYhHQMlr68QN0fnlKwUeH5Uml3FEtftBU3jbrZGr6/K/3gask/xZKti+8jtXoWdt7kJi0QaWjc6tihJxH8p5+LgOn+GUos7ViYfWBeBVrpH20u2HaUHz37wHeo5TNP6EB6DCuEsdJfv1cJqilR0KKi40ykkl74SEA6ZO4PhYAzuZD3hlRJ/HXY4oQCYxkclccbQPeZppQsg+UakvtSwcqhKrsUviA/BOA3gjnr/VTWADWI4oK8ZLM9YE34Og=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    1701fda2f58e Add linux-next specific files for 20260805
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=120a0fb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1abaff330e312dba
dashboard link: https://syzkaller.appspot.com/bug?extid=d3c6764857d7cac5048a
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1255d7b9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/260da702bc71/disk-1701fda2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/006e50e3e545/vmlinux-1701fda2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/232c4643654a/bzImage-1701fda2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d3c6764857d7cac5048a@syzkaller.appspotmail.com

------------[ cut here ]------------
vma_is_anonymous(vma)
WARNING: mm/internal.h:241 at mmap_file mm/internal.h:241 [inline], CPU#0: syz.0.17/5892
WARNING: mm/internal.h:241 at __mmap_new_file_vma mm/vma.c:2586 [inline], CPU#0: syz.0.17/5892
WARNING: mm/internal.h:241 at __mmap_new_vma mm/vma.c:2685 [inline], CPU#0: syz.0.17/5892
WARNING: mm/internal.h:241 at __mmap_region mm/vma.c:2905 [inline], CPU#0: syz.0.17/5892
WARNING: mm/internal.h:241 at mmap_region+0x1f8d/0x2460 mm/vma.c:2990, CPU#0: syz.0.17/5892
Modules linked in:
CPU: 0 UID: 0 PID: 5892 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:mmap_file mm/internal.h:241 [inline]
RIP: 0010:__mmap_new_file_vma mm/vma.c:2586 [inline]
RIP: 0010:__mmap_new_vma mm/vma.c:2685 [inline]
RIP: 0010:__mmap_region mm/vma.c:2905 [inline]
RIP: 0010:mmap_region+0x1f8d/0x2460 mm/vma.c:2990
Code: d6 a0 ff e9 69 f1 ff ff e8 10 d6 a0 ff 90 0f 0b 90 e9 5f e2 ff ff e8 02 d6 a0 ff 90 0f 0b 90 e9 02 fe ff ff e8 f4 d5 a0 ff 90 <0f> 0b 90 c7 44 24 08 ea ff ff ff 48 b8 00 00 00 00 00 fc ff df 41
RSP: 0018:ffffc900037bf560 EFLAGS: 00010293
RAX: ffffffff8226adfc RBX: fffff520006f7ec0 RCX: ffff88801d711f40
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffffc900037bfb70 R08: ffff8880122eb803 R09: 1ffff1100245d700
R10: dffffc0000000000 R11: ffffed100245d701 R12: dffffc0000000000
R13: 1ffff920006f7efd R14: 1ffff11006c41e09 R15: ffff88803620f048
FS:  0000555564503500(0000) GS:ffff888124f18000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa7f9a70000 CR3: 0000000071f6c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 do_mmap+0xe0a/0x1300 mm/mmap.c:573
 vm_mmap_pgoff+0x272/0x4e0 mm/util.c:581
 ksys_mmap_pgoff+0x4dc/0x760 mm/mmap.c:619
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x510 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa7f9b9e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffcfdacab8 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007fa7f9e25fa0 RCX: 00007fa7f9b9e0d9
RDX: 0000000002000000 RSI: 0000000000003000 RDI: 0000200000ffa000
RBP: 00007fa7f9c35024 R08: 0000000000000003 R09: 0000000100000000
R10: 0000000000000013 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa7f9e25fac R14: 00007fa7f9e25fa0 R15: 00007fa7f9e25fa0
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

