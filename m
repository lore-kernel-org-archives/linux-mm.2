Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE23CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 04:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12E428000D; Fri, 22 Aug 2025 00:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9CE58E0056; Fri, 22 Aug 2025 00:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B648728000D; Fri, 22 Aug 2025 00:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8418E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:16:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 595D41168E1
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:16:35 +0000 (UTC)
X-FDA: 83803081950.18.E74E498
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf02.hostedemail.com (Postfix) with ESMTP id AF50C80005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:16:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 3IO-naAkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3IO-naAkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755836193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=S7uvD8/Hh04Ray/dr3eqanRrtzDNDO2JwOba62dm4Lc=;
	b=lYaRznWi7ZByRepJ756Le82Kfd+GrJ+Vs6dOfOwxl29nQ+T1CV+vlLAB5mrw743bE+1RLx
	i7ZbDookRfmx0sAjfPUgtwpg5+xN16QnunDw482VfappSXCh+hwY4l/r0Hw/8mTedIxdFR
	J1ylLh4H6kKtNYbJtPDODT4SEWolJr0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 3IO-naAkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3IO-naAkbAOkdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755836193; a=rsa-sha256;
	cv=none;
	b=LZ4/BGVBctT33dhI8eL4xZ6E4OGTFE1ZjYO9zBHPu8u0ObdVgksMwXZx0HIaBqdT5gaEvN
	VB53RQlRruJLha5GH+nnRyDIMqMOL02y9AWMF1ESs3hIzHt2eTKCBZpMR9De6YNaDM8jfy
	S8XPiMCw6qKO9l0Ez65zClIzLAz394Y=
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3e6649d783bso38185625ab.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:16:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755836193; x=1756440993;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S7uvD8/Hh04Ray/dr3eqanRrtzDNDO2JwOba62dm4Lc=;
        b=Kd5/UrX0o1SdZBrr+h76Gjhb6fyrzNUjf6JQzFqwrrAikDCgiisSss+EU6bL1Qpc0P
         1adqGrDWDaOuDzypD1dV/YEVw5WVG6QWAHcPWDBhKjnD1KB1+1kSQwHs/QkHXIicRYIc
         Id+no3puixF1XBBvhaVe60B5HHdbyrykU2SSy+i5sRM318GIRzw9FBRFeX0ZEjjQw0iy
         QkZiRpitG1p7d3Tw5e4blRdD7XhZz0/+GFlRPjhMBPxWrGj1lkslrY5iCkqnmdQd8f0u
         YqAG2Rmvlb4pdfcEcpo18sH4LnoKTFD0N3IW38pJaq7DGOXfeZuqF6wwaOOUCwekER07
         5XWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZIIgil73IQoYvqmxBFST4nXdOuBH9PDEwxQgjsMXhXYByuaBHRRw5nK97RKFu1fGRfLO0daZzcg==@kvack.org
X-Gm-Message-State: AOJu0YyYhyNa8p8+wQ6oM3sfuCIvsioSe6qybxVW1mSo8iKJVeWM1mx9
	5Z7sPC84jii2567FgFJ+48v5keCkKwqi6E+FRwMHydcMEZTxIlfHpqHMVlGZ95Rc/TMoobgTl2I
	tYCRZUUAGxdaCRNcGjspZ70OSjnwV1L90IXax1HhLNI8EytoDPFbYpwSJcFo=
X-Google-Smtp-Source: AGHT+IFwaCdiJ7lqFBsIffoZ1+cf64BbbV3JJhJA0zUvyfvTiZhbAzeFa5Q4fe2blHl8Ox+pYco9jyeLZObmcrIFIR5B/RD+Y5iA
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c6:b0:3e5:6a2e:e3bb with SMTP id
 e9e14a558f8ab-3e921a5d824mr30051815ab.13.1755836192799; Thu, 21 Aug 2025
 21:16:32 -0700 (PDT)
Date: Thu, 21 Aug 2025 21:16:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a7ef20.050a0220.37038e.004d.GAE@google.com>
Subject: [syzbot] [mm?] kernel BUG in page_table_check_set
From: syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: o8qa49bruqenmqb3i8gkscdmg3fa61ek
X-Rspam-User: 
X-Rspamd-Queue-Id: AF50C80005
X-Rspamd-Server: rspam01
X-HE-Tag: 1755836193-793163
X-HE-Meta: U2FsdGVkX19P/rutR+f6o3pp3+jBWPLDiETVwIvQQeE3aAwdRpkBAudenpWHEpUjndjcwgtpdOGN+p6j7/e2j/DI3Hfvbu6mXSADGhF9ox0fjEbqaeuK4eyGFKDRGZLAL8s8GyvzLK7a0oMT9axpdXNfNvkLRzduZVe37Fvp7fSUVSyP5l6UOiFeOM5EemqI2BsBxxdzBgsToojODOx4HyJo7e3rfjILlcyHPAlwDx8EQdAMEOqDq+PFPbgGolEk+Z5kSDYccTcqXDw61BZKCzHQ3wMbFlre0pqgEhdUk5DArkaULZMj6X21JJM0pHs6e23XChPUCIByHPoYCoURYOCYygBTf+5Smh+VY1SicGPlJ9tuShGmxNvDVaoxFe5wcynkMIoE7h1JA2aOZfTE0Tprkyp1EzA9JfHzyvdbMKDxxGTe6dhqAAirpvmOhyxfOPrINTeMNbVvj2z6kcngkeeL3H7JPweY4wTaxzWdgJV+Wdqoixv3a4/Q87ODFyxDLpL+BReCcaNjldHpIpzZqOgN7C3yWi4f8ZzORgYAnMyhtNdBicXBtitKug2foHW1WD4i70nNEDdkbdsvRAg9WrKG9NRfwoAv5M673tYTNK2Dlee5SWkWn3Lmc9OVbwDgWQi1TEwDfhZX6/GGoZI7ctdc1uKBFTG4pr1RMN2BMJyqvNDrIxKGCgL4zkg8luOsJ13Nwon8HYV7zYIxBp5AY4l7YS22Ph3timOjZPh4c7lEzTWPbDhpxC183X5cr5VN0H/ouEZv2gWoweWOWutGUofdso02v0FAZ+RjgJWGNOFsoEnse90TNte6fZMzFATppzUsxEAC6ISDgChKXB4xWe9wk60ABOa65Oj9AyldNFttHjrG4nCAwzmikqZuC5g+PbCyApC1bGE236aRzLrIUR17JBNyOOtv9VNkX8tgkS+G5nLw+zbbWd71B3d0awDlKr4oZ3YA/RyGt+TpbgX
 mHTpY9BV
 n/FM9cp5FUeLyJ9cMCpmdcv3+IiyZmKfZEKnwogG+psho3yIMCHsxKKNCylj0mg12bsRE6jynCMgdEj7wzvSbGWCxfIi3AudXVxmwvJkua2jbPC00kmf6sNLb7wf4/lknZrycuKqiT0eTyMo/B4IFQV14OPdL/gnS9l2JODUnnoLjBcPgQ1SmsdBpwlRDpzy5FhhzoLtHt7wzWeOHl4i0Mh9GfbBlJiUyA1f5jWkrOnB/zxtv7GzRMap7Q7poIqqgb4EmeUiafeCuycRgZ64cGYDojMUXX3lbWxg7JkkWGKPEd+KkEFYyXxwQSObjjYcbJU7N5ql7LCehx/IxbgMGILANT5n2ODCnEt8E+4qzU6Kh19ynBskEM6cNaGx/iAd6BlbmgiEfC9WSSqMA0kwSZXSmdYVgeUVhHexy5zGnFeK1ciymexF28pmiQdWFZwdxBr4b/BqGlRxxFx+CWCzSZTe/LLbapzebxlByUeXdIQKBFLbgo4gT1u+dGzKuNkzZfCLeHulfWjUZoFQFrhJwZ9TbXt5KynVNIV+11yZpAxwgTMB6fVRIkXjDrhZPP+zucZBffNSHAvwtFw7vrBqIdIsTLQfrYFzLNKXlgoeFR80xZhCNTpUciTWKLGzZcDA5PcnjzTBEElJynce3ZycoQdupnkNWWGwj8BET+Zr2604wH68qVEWnkEsZTbCj7WWqG95aaU8rwhyAAZWwIipmrDUNUyKnXsvaQJYzHLaJUI5TWF2LkaCP15IXJZIurKWijFbh/4+M8BHMuBWfRq3pbo/lL6G+NOwhnBkIqr5PjGwp1oXfDUTe6oPZQQqeuxH/mmwdLHjQAGJdApZDsj+hHamkTByPgEae8oggTqLZjDaatm5Eofh0kOYPHeFPdGwKOF/xAzlNIag7gpn7zVR8hIcroNRktK7Fx8BGF9aQNmhesGZ9Z6GlbPzUvpJXZdggq7F9fRLyKTAmKCHKPNQJlMx/A5Cv
 tFwR98IV
 MNoG0hdyIQT7cg+Gyfkybi+HsMu4OpS0MNhT1IKmeZ2wJv0tIfljTyFbDaeWaIOiMKJ/vwFpVMzTHD/ZSDgRyLsLMxDTXrIsoZ+lsZ596ZO0f5FU7LpoHEdSixc1/yIEwK97tzxpeTLtaZNfaWQlSj7Q8E7u6nKNYx+OS/xd++YG7qgzDOYCuIxCQK0TJzdXd1nXHeA9/3QkJYfT1WhdZStke1GU7bg9TqFUfhlE88LTpcRePC19+unZ0HO7tn4jc/LmuEtQtSLUgPl6pNUUNI4CMD/w8Xs7bAQP/c4EZMWhrAq5fdyTmlYmIRZwkITfmeY1JqMSoZZGinBV6ahRtbeBnBwzB9bw3Oh+8XkIdnv207ZxZbGZleEIGAuZA0JKg/9cshX/fznCYTy00qWUQ9W6U12zmV+WG/GObyrmriRAReZhXYlL/4wKzH6yKSur
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15f926f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=49a796ed2c9709652f1e
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15faa7a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144143bc580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at mm/page_table_check.c:118!
Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
Modules linked in:
CPU: 1 UID: 0 PID: 6740 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : page_table_check_set+0x584/0x590 mm/page_table_check.c:118
lr : page_table_check_set+0x584/0x590 mm/page_table_check.c:118
sp : ffff80009c9674c0
x29: ffff80009c9674d0 x28: ffff80008fae0000 x27: 0000000000000002
x26: ffff0000c079ca80 x25: 0000000000000001 x24: 0000000000000001
x23: ffff0000c079ca80 x22: 000000000012b950 x21: 0000000000000001
x20: 0000000000000003 x19: 1ffff00012eb65b0 x18: 0000000000000000
x17: 0000000000000000 x16: ffff800080528a28 x15: 0000000000000001
x14: 1fffe000180f3950 x13: 0000000000000000 x12: 0000000000000000
x11: ffff6000180f3951 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000cdb05b80 x7 : ffff800080d16554 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff800080d15b5c
x2 : 0000000000000001 x1 : 0000000000000002 x0 : 0000000000000001
Call trace:
 page_table_check_set+0x584/0x590 mm/page_table_check.c:118 (P)
 __page_table_check_ptes_set+0x2a8/0x2e0 mm/page_table_check.c:209
 page_table_check_ptes_set include/linux/page_table_check.h:76 [inline]
 __set_ptes_anysz arch/arm64/include/asm/pgtable.h:709 [inline]
 __set_ptes+0x4a0/0x504 arch/arm64/include/asm/pgtable.h:741
 contpte_set_ptes+0x120/0x188 arch/arm64/mm/contpte.c:464
 set_ptes arch/arm64/include/asm/pgtable.h:1794 [inline]
 modify_prot_commit_ptes+0x4e4/0x694 arch/arm64/mm/mmu.c:1556
 prot_commit_flush_ptes mm/mprotect.c:197 [inline]
 commit_anon_folio_batch mm/mprotect.c:246 [inline]
 set_write_prot_commit_flush_ptes mm/mprotect.c:273 [inline]
 change_pte_range mm/mprotect.c:354 [inline]
 change_pmd_range mm/mprotect.c:570 [inline]
 change_pud_range mm/mprotect.c:633 [inline]
 change_p4d_range mm/mprotect.c:659 [inline]
 change_protection_range mm/mprotect.c:687 [inline]
 change_protection+0x1e84/0x3ff0 mm/mprotect.c:721
 mprotect_fixup+0x504/0x744 mm/mprotect.c:837
 do_mprotect_pkey+0x864/0xb30 mm/mprotect.c:993
 __do_sys_mprotect mm/mprotect.c:1014 [inline]
 __se_sys_mprotect mm/mprotect.c:1011 [inline]
 __arm64_sys_mprotect+0x80/0x98 mm/mprotect.c:1011
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: d4210000 97e865fd d4210000 97e865fb (d4210000) 
---[ end trace 0000000000000000 ]---


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

