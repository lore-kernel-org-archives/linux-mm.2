Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86E6E6B25C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 05:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191C16B0005; Tue, 23 Dec 2025 00:23:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163C06B0089; Tue, 23 Dec 2025 00:23:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0455F6B008A; Tue, 23 Dec 2025 00:23:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E65176B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:23:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98F116039C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:23:20 +0000 (UTC)
X-FDA: 84249592560.14.D20918E
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf07.hostedemail.com (Postfix) with ESMTP id ED24240008
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:23:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of 3RSdKaQkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3RSdKaQkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766467399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=MUUzU2h/tbsdYlnI1rIO3W8VfaBD879P7b/jFRPk4BI=;
	b=XZ6dV/ui23z0tICQfwEpEsoWe97GGBKapJRQQM6J/BbcTvyeoEHx8gdIqx9/t/J9Txfo6B
	/jCxVxeOA8TiMz3+/ywHvhCtolHUFq7iHKMeCeYY1c+pwH2w0fgsPfjmzArteuXhfhtGp8
	DeryL44xrkpU+v6oOJBZT4Kxt8B7VN8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766467399; a=rsa-sha256;
	cv=none;
	b=FrmW6cVuKr40TTcG8VZhF8/umNnEiFhQbbN4MZ9jl1oCIYzcpdQna2wdAjR0cBdxDAXyuz
	iUmCKAy27RV4Ccf9/VL0nTSzO1Op76nFkhVcAjHzy3xMPqE9B3CIdX9vqGOJm0gsv47CQM
	X8hiWB9k4xB0Sf4OHz0s4MFG655kMMI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of 3RSdKaQkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3RSdKaQkbAA46CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-65b37e173faso7127683eaf.0
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:23:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766467398; x=1767072198;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MUUzU2h/tbsdYlnI1rIO3W8VfaBD879P7b/jFRPk4BI=;
        b=r/aL7aEq9mknDc4C75KvsYKc4uD6+HwqvjBeWc0q7j3GJxprYbyDk9Ty8CunyAgirl
         vFs4BPeU+5gXtM1ID9AzzGU4sB+JIYiRb078XrVG1vihJlxwHDpPsjGQ2cFtIw15pYLA
         dFHgZk820drXPtRHnADVbXi1Gb4P/FYc+3h/2FuIfYpV/B4ZfcasQeQ5XTLOH5N/0vCM
         BaTOvlwzkmloyPZyOY7jvrlQ4tBFixbfGzhBn8LvUf0TfwXTdttxngZeuQ5uOf0EvmFV
         PWHaUldWtvMvS9ue1INl2WEwRDbTMjS+lojoCS4eOiy4F2FjJDWP8AWW6FMqnAPPwdGK
         bKcA==
X-Forwarded-Encrypted: i=1; AJvYcCXmvbEWHvNYN30NNR6720tkMOmCsdDc5JZvsk4h8PtytpMjn3P38BRgpqYA4nFxFBlvb/YtSURAgA==@kvack.org
X-Gm-Message-State: AOJu0Yzq8Dld6YorGJ5jOfNc9DaQOHYgLzVMUX8FTlFlImiMU5O6ntx+
	80sUs46dEOhIujycD7j0YYMIwt+Dgzfc+WL0Not/w7ELqo2agaxC+rC0prYmY4K31WWEtp2BPcZ
	dyjHFlNTO8l56ZB/GzULWX+57n/tDGGIfw+lv0safgvWBvnKWUF1tyYkl0tc=
X-Google-Smtp-Source: AGHT+IGTYzvj5tLeyt1xU+NtqrkYNsd/x7u2BcYtYmYxUBNqpvzTWKLyngY2uODw8mntI9RSWy0DDfb8m4X2KJUI4VIKi086YP9o
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca9:b0:65d:79a:cf00 with SMTP id
 006d021491bc7-65d0eb2a0e0mr6563272eaf.79.1766467397975; Mon, 22 Dec 2025
 21:23:17 -0800 (PST)
Date: Mon, 22 Dec 2025 21:23:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694a2745.050a0220.19928e.0017.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
From: syzbot <syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mco977pbxbtixic1q6xfhu31ta7qwxds
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED24240008
X-Rspam-User: 
X-HE-Tag: 1766467398-24725
X-HE-Meta: U2FsdGVkX18nFOVX5blRIoxXGb5NASOy/VrOerhjSFBgBJ1U+cGwo9MuFaVNM5HPYwLBz/qBV2Bzx7IFKwkpfZxUUTp4sGiw9XMTpCUzDpxnIkFS5aP9eos30BM8nPuaW4xw7FjJr5/TkXIzNe88Pg3UAf42Ep7owosgMnNKS1KPmfnGmx26HbE7kSheCbleTk1EOEG/kZeZs1eOJd0tsmlxOFwtmblt7rhIL/PRNXarN5rVq4//xrZgU53qVJsQmx7MFw9wvvNvJ0t24mk78W0fq5QBmAI+ITRdhkzsHVCqx0jopmJQEv+hpIC8dVAbRvu1ENTz9uEwGpZ9HV54Z/SJA4zMwhIkJCfvdy+VYSgqxklDvp93zpIWIMGKoDbSp7FjLAp4NjWAIM3fYGXdM/6oitLlv5659AZMBK6t7z9ZlBe6eFKgKlqHvSG/l/RSR+FDMNVyzyDnpKSofEDavgESmaWhpLeO0Supi8xfDVcrPkD64evH4TnUu2GY8EiAayAgHxc3mEIpJ8C7mQmGBrTwEJYyUUttXWbLoB7zOwa5enuCeNEZ8fjYQffUFQgXTCvRLH5ePh7Mcho8rVZLoVTQl+zjko4QGJDUInbHMUAL/yPvTv3QZaGhd4HQpbq3X6xKskxllSK9nL2OAUYeqnHuzmdPngJZA/6rhM1QSMMgNajFlgohnfBoFY6Er/J68pbOG3cX2fVi/rgIwAAWRf4z/5xe91z2ZE1mTg2X8dG2y0R5FvXrcCAfbBgPKL3A/nScDUKH3pvyEHj+c53HIJcZ4H6LcELE31E5nViAxrJECURRh7LOGMyC2cLw2rOhuOqT/ssPCtftYDiee7cJEplxCCf4XflzTerosrouiaW/8oYgViivjkjFA0Me+VswH/xoLtoIwDuWDBqY4rL6m4a0T4xpoY0ux2BBP6V9yK8W3CreTLR/Ygc1kG7hkEFIPEX6QEo2DoSwULoGLSY
 qP+ujtHq
 x0hJp3kA0oM/AkN2eNT10fBV/WQwri94fC+k3QLwXhaSTeZbZXsGRZdMCA6YWqpFni63KTuI0MZhSBMYV+1kZ8TiZ84w1W48orwfFKsnDVI4cL1L/1BmDcblYuXRVWCx6kyjNuJocPKQwBCX5bohqKuEI6YrmDTyuOImpcpvOjAhMS8KJIyYxc9JqUD6DCfLbHjpi/WSVzuVS0SpHOXjW8y8cY/BiSAK4QKDCMyWJWPsdLvQp3Q/nqt8Dqb2TZdwHca/lzjpX2VTVEGQ6S0VwBDuwy0j6Y05O1+ebcAGleZsSI3poQkq/nvwIMDm87bfEVPUcTrZCS4eKWFr1gyzYDie4KfIfokTU9tGp7TH+ljVwRbZfAD7v61K+Sutuig9F3OgJlGwq6sv128a70ufhivfmcxNN6AHtU27rTtXzNkQvAXD3tS+vDyj0osLpq9SPEFl+/LI3Mhx5/etLPCRgxpO4947CF6a4KkGPjFyRubIFmHR11YUBhRutxt/4wdr0v2UpeZ6ovdnfoukvGvdK82uTDCYGugJsF1Pf31htQrPahNb2QueI11zvPllHuEDYawfekbS8DNNFm/h3mjO9zXN7OV1+74AkMzYzXoD1k0Kw3mJiVvKSgfu4JmlyBmSp82nPRKqAIlRUgCVHTslL8x46HWhfejWE57jdxxz/1i1l3/mTaUTLhA4+banzvpU0XGTUsOWnJc9XNuLFki/JT0MeqmzypOUyhCPJNu93c2zbZh7h9TntV051a5pL/OUEfkYrDxM10/lLpIvHbqO8wj5n9S/5sveqj9PB8NN00yHjhPx3x5Y6hx14J3BCDFW6nWQWs9KeWLDUzurZicuR6TgLxYU+hbf0HxLu3ZFrQknJuRNGgUtL9r7/qVy4qBd988r9jXK16O9rpAAMJzRWP78wAJiYXZ0TT+6XF/Dkwk9asPlmCZcyIng2mde0+GWqzpTQzClzF3rk0mCnZpqc8h6t9LYI
 wJL4GcCS
 GNxVziAYYBVhdPOJMbCq/Iz3Soa8MgN9+EKzGX+d9lr1A/i1ggzbJBal/FSxHrY/FG4UkybYUFwULcjcVTBVbzspjPF7Xt7AywUU/7crMEN2A0vb7hB/oQoJXf/Mm/1X3weVHrFIVtfR05SRXguXi29KYvLxyvTgOKGLiabIcmiBQrY6BtHiizeKfaGYD5HAVE5a/7IK+nwgJ0Qlm8xe5hg+HcIVbJttCkhNHZPiIuwdkRKTwg7g0NXr2aUivQeQehSzuLxKISeRvXhqrmx+l9rtVvfbDi2GSaWoxfpGL8E1ctmrMy35AmbJ/HKOxaKIVGV+CMXR9NBP2sbUdA9YFdlAIjW/V7St0NKbYcQbtusFHnetn1fg09ytnXABwkUFfCy4rXZIq6S+F1Jt8aeD5JFC5EUcqTKpLFLYEDrcrzs1ssGYFLxekiyPf4ZuHY3eKcC1kfx+4XTwDCC05ysEFLz4eMvZ8r63
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    9094662f6707 Merge tag 'ata-6.19-rc2' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1411f77c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
dashboard link: https://syzkaller.appspot.com/bug?extid=b165fc2e11771c66d8ba
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11998b1a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128cdb1a580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9094662f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5bec9d32a91c/vmlinux-9094662f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3df82e1a3cec/bzImage-9094662f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com

 handle_mm_fault+0x3fe/0xad0 mm/memory.c:6580
 do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x64/0xc0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
------------[ cut here ]------------
WARNING: ./include/linux/rmap.h:462 at __folio_rmap_sanity_checks include/linux/rmap.h:462 [inline], CPU#1: syz.0.18/6090
WARNING: ./include/linux/rmap.h:462 at __folio_remove_rmap mm/rmap.c:1663 [inline], CPU#1: syz.0.18/6090
WARNING: ./include/linux/rmap.h:462 at folio_remove_rmap_ptes+0xc27/0xfb0 mm/rmap.c:1779, CPU#1: syz.0.18/6090
Modules linked in:
CPU: 1 UID: 0 PID: 6090 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__folio_rmap_sanity_checks include/linux/rmap.h:462 [inline]
RIP: 0010:__folio_remove_rmap mm/rmap.c:1663 [inline]
RIP: 0010:folio_remove_rmap_ptes+0xc27/0xfb0 mm/rmap.c:1779
Code: 00 e9 49 f4 ff ff e8 a8 35 aa ff e8 c3 55 17 ff e9 98 fc ff ff e8 99 35 aa ff 48 c7 c6 80 b7 9c 8b 4c 89 e7 e8 8a 12 f5 ff 90 <0f> 0b 90 e9 5a f6 ff ff e8 7c 35 aa ff 48 8b 54 24 10 48 b8 00 00
RSP: 0018:ffffc90003f5f260 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffea0001417f80 RCX: ffffc90003f5f144
RDX: ffff88803368c980 RSI: ffffffff8214b106 RDI: ffff88803368ce04
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: ffff88803368d4b0 R12: ffffea0001417f80
R13: ffff888030c90500 R14: 0000000000000000 R15: ffff888012660660
FS:  00007f98fd3fe6c0(0000) GS:ffff8880d69f5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f98fd3ddd58 CR3: 000000003661c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 zap_present_folio_ptes mm/memory.c:1650 [inline]
 zap_present_ptes mm/memory.c:1708 [inline]
 do_zap_pte_range mm/memory.c:1810 [inline]
 zap_pte_range mm/memory.c:1854 [inline]
 zap_pmd_range mm/memory.c:1946 [inline]
 zap_pud_range mm/memory.c:1975 [inline]
 zap_p4d_range mm/memory.c:1996 [inline]
 unmap_page_range+0x1b7d/0x43c0 mm/memory.c:2017
 unmap_single_vma+0x153/0x240 mm/memory.c:2059
 unmap_vmas+0x218/0x470 mm/memory.c:2101
 vms_clear_ptes+0x419/0x790 mm/vma.c:1231
 vms_complete_munmap_vmas+0x1ca/0x970 mm/vma.c:1280
 do_vmi_align_munmap+0x446/0x7e0 mm/vma.c:1539
 do_vmi_munmap+0x204/0x3e0 mm/vma.c:1587
 do_munmap+0xb6/0xf0 mm/mmap.c:1065
 mremap_to+0x236/0x450 mm/mremap.c:1378
 remap_move mm/mremap.c:1890 [inline]
 do_mremap+0x13a8/0x2020 mm/mremap.c:1933
 __do_sys_mremap+0x119/0x170 mm/mremap.c:1997
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f98fdd8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f98fd3fe038 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
RAX: ffffffffffffffda RBX: 00007f98fdfe5fa0 RCX: 00007f98fdd8f7c9
RDX: 0000000000004000 RSI: 0000000000004000 RDI: 0000200000ffc000
RBP: 00007f98fde13f91 R08: 0000200000002000 R09: 0000000000000000
R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f98fdfe6038 R14: 00007f98fdfe5fa0 R15: 00007ffd69c60518
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

