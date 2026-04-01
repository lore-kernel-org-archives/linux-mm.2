Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6391B1076373
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 06:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5926B0088; Wed,  1 Apr 2026 02:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655246B0089; Wed,  1 Apr 2026 02:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56B666B008A; Wed,  1 Apr 2026 02:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 423C16B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:08:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D328EC58EC
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:08:29 +0000 (UTC)
X-FDA: 84608957538.18.0DC10BA
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3C473A0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:08:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 3W7bMaQkbAFAAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3W7bMaQkbAFAAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775023708; a=rsa-sha256;
	cv=none;
	b=LA3qYg/dPrOXu1a0FATdGVOQiH6JC9ppiF6EbWb2oCBXuuLkoxKKvSoWdbdpz3E/cSLdxo
	WVyd3nN1wVlQ4nGx8LlBZhDGokMBWOZC0ET488Qne9uyqwHiBu7APce+Oac7vZcReerk5u
	DeSGDMT5SsrYprNj8JJ75VnQ0l2tIHg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 3W7bMaQkbAFAAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3W7bMaQkbAFAAGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775023708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=B8imTJkYF2MocIjm75G8YhXSiMp1UnsjBdDNgbNRGPk=;
	b=KzNkHBuzXYcjQiyAYggFZiB1/lCRTzAZR6YpYCrbc1h6oEevFK80xr3CPvmKzAIPaiNkkb
	FQg0V5nDQKZ5+ulLNqmknqCQsVaCGx3rBuAfFnMH5uN0CDbmwuR6mEy/t9K1eIwAnhTc01
	JZElBZrwzjzhQ8kj8qQNvGBSycskWRM=
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-67df63d61e0so25534029eaf.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:08:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775023707; x=1775628507;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B8imTJkYF2MocIjm75G8YhXSiMp1UnsjBdDNgbNRGPk=;
        b=PBFmwSpMj/B5ujlQl0J7dy0XPtzkv22szkcLA8j94F+eG8S6tznuKC/MF3kTlGprG+
         d21ykHXU1rNgxgS/U97Fsd6ba35JH4Z224BnlmaTGPs7E/VVlS7GRv/GiU1o2ZMKvrmB
         uwOaW6QjkiE91XqvafyP4FFiF+IYVeaRONCCNti0rBjh8cF83C/P9EsRqb7j9UGMEE0C
         bO9QFWyCCtZK+6BhVn/XCCIa/R5/hyXsoMp7g63O1n4Go9zHdqesHOUVtTkcRojmg52s
         VTLeT932ReiwWE2dgI6+5ONYdg4O8zLnUR5WOopXKuWOl7EcBkBw95tRdZFkLReApoHI
         hGlg==
X-Forwarded-Encrypted: i=1; AJvYcCV8PojNGGFsL7x/2Nkb2i1YWqfmuRjhw5io8V13tP0FxZ59oOjalaTsPde0qp+meC2x8wpIquxPyw==@kvack.org
X-Gm-Message-State: AOJu0YxZS1KOQG1I4JmmOCnzAbJH1K9awH/9+1WFc1TU5ZNJxNvQdGat
	PDKODq50lvSrlhHbGHnrvpkOrFZc9sEjNUAo+JQsqgiYwJbW3BhGVS4yBYpV1f82G5BLVrmYAD/
	XxR+zAvdMffRoi48YGA4Uvqdt7Cu18Fl30YjAF15UgqOdLf1ezxli5qi6yHo=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1628:b0:67e:3ae6:9031 with SMTP id
 006d021491bc7-67fabd01024mr1125354eaf.59.1775023707158; Tue, 31 Mar 2026
 23:08:27 -0700 (PDT)
Date: Tue, 31 Mar 2026 23:08:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ccb65b.050a0220.183828.003a.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in deferred_split_folio
From: syzbot <syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mon6gdezro6dz1fjc6pnuey9c6px784g
X-Rspamd-Queue-Id: 3C473A0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775023708-324699
X-HE-Meta: U2FsdGVkX1+QnMtGYAIrPNOxTNd8h/k5vtSz316ho7rnC0UD73UBUZvT26oTIc/fOZRB/yQt2FlSY7T+K2HQOJnATsePsqG771poaa3v/8iUreK2pmI0hhNDrj2FzphUM/ELwEYNO9drksRCb+qJJpQX9KZCAhnCYRtKQlQ6PKGW3DeUv8mvxe6I7ego8SO8N5SaypFV1r8YMOyYpUOjhQXFS0JsKHQzFCOm80f13oyGqoB9R2Jpt9sXBxyT+40KZ+MLCM8LAMwCkfdvRXejDdhxNWYa6R+KIVnE5pvTINestwnJfY+DFkOKqM8tp70TwxfHdgNp2oCpzcAryL+1oxUtwnmVeRU/XwiFF01UKHlJFVkpWzlTs46OOrHOS1PJevsovei6vxQ4AJKyRBI2gwKIba1ySVcndKk4LRsd5G9cn43cefstpetN46GjtecwdQdGuy1jVswOs8nOXBSIbWmL82oirPXF5LP6sif9erxFbMCDhgWA5bgmfQmxopXZfHLpTGDmrP392gZzo2m7FvE8PrEnQleRlE0+dqUOW1pIHFM7EjU2IdLEnUolz10R1icgo9y04ST9SFWN1qAV4hVXgFCYJtQoz/D356SXnQDdzfxZagpJ8ybB7LotpHfBTHvjpM7rma78PBPx0FoZfSxfFLVwgUtnp7m64I8qzFhwOYWgAooKyn3XnS6ZONzkkZ5Aj9CpwHGy8XkQTwrxOip3mbV0dqqvAcu9Wuh2SIYx6suv3aiXUwbaZdrmzA3A3ES1tPrjUYlMObslf717+CHykZGwFS13VFkpTxtl+vYhVjHpHIwtur9vBJX4FU81qReXBzOkJ10rXguZnly2ocT8eYdAePQfa5kUkm/+eCm4JKk5+mWvb5BhzYgIXDYyV34AqZ5VShLAZpsABPD2kpEGLmyE0VChAOflj3mFkFjsdg31R0LoY62Z7N5WOqws4lOpg0SkGS6ahszyqUW
 HaHMWeCc
 ptBFujwvzY9YkOLr8LmPyk7QdwbJQofdymtjM6elBCWEHXum8t84uJPuDA1hAMc3p6/hNxT+YbLuVbzvjlmkai2IpltA+EgoQOf7p71RxazU1mIQl1eLjeO7zuhZoDNeojBDk9XCkBKAOhb1e+tS/USSn5qRItGZnQLlWLaxv0dvj53rpSsmQsa2z4fkOk2UAnBdOz6IlvsnjZzSxSZOzVq6GpeChfEZ46tnUVBEmbyPbJlu2TXWY6iWQkLA9CnJtlyWTlRXbvlue7slJAJfi2FX7w9JNLnvb6E8gKm2Qr3yaJ8OP0N8pqJXp7Amzzc/hH4prC8fPHyawU+C6CM+HtiJ3IyChd321dlGLp99aZWGGSlEAPm13HxhetUXmovYjjEhHI72/f4NSsNLVCbvY1WdLvVS+EwYuk1sm3q24hbNyOMVtuPtN41kdZCfhOGKj8e39ree0+0eER85SBTGOB2bcdO+62LsWpG0Ie5KMK7liJOT5qxY1nCDAnGlHtaIwkpERHZXXzRj2jO6gZXstJL3mauA6loz/SOJSskhS5SMcUu6N6AUgrZzynBM9QFKAcHdh8JnDbXO8ZseOpTRyWyUjlkJLv4pCl/VFxER1KcxentUse1GBr2u4u3fXw7lSGvvJPNAtv3vKoJYENDoJo1YqihELHc1JLyClUBmiExGDVPnZ+kKh9aJIB7qAlu4Cqo36M3CLbHKU1vwL7OGKsSfy+indil6kzdaJmQ5pEa4ES/r/wHWt3YQs64QSrEpIudGoZMt5uf6GeKDsrtE2j4qQeKu9iylznPQSaB5t/3R5/wvUJw6CrqhT5KI1tC+hJ4b1wyxNh5OBByn+esqUDmAT+Mq5g78XaeHZDBwGzi83Hb+fopaclu91W/Vo2UcNhziv+4UP8sBhAiWqew4ecjB0bzEbEZ8WLbsWRe1C3YQzBaWu/p2BRhkJXcdDwNlw6U2LwtHqjuPBIBoJ+Wu4RciUHSk5
 flHcTwTz
 3Tn97YZdZ734hMxRDiMYpbvg7jrWcqLgsM3xNSf2T/lpHgon49ydKUmTmoy9BUlgK9ySrw8qAhvZrfpqHcEJvGeQ+Ui7CPxdb49C6PDUwDifqC1OoV0wjCbvnLmW/Ln2fi3hZqbPezs6gM7DqC4IpWcK4VyPmAYwa9Y6aHXODbsho7aNz6Z2tp5M4MhN0pEQZIzlgdC13ovWf8YUJgR7QLt1CyGMfiYNBw48n6U4VbTA5VeRNm7LXSyCZg5UPhSXZTHiODEFKMvJe7umAsLyBj8kJostacEE44YVKm7UvNUPFjOp6oiTMg6OLobY5rju9Cyt5BiGzz5jEUbgf4A6awOmrdAMEwrWCGgvRTYZTWpiAn++xi8N0gRy+XATA87X3VhzVEl/vFnLaoaMFhVhxDNyxyLE2mHCSKLPhQBorEk2X1IUCxpVKSgg2x03mepeKUL2mSJtWSJytG4YBszlqr287dwH/ZRM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    cf7c3c02fdd0 Add linux-next specific files for 20260330
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=154ee46a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3944d875fa9bfb67
dashboard link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c846ba580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/053d3b49a360/disk-cf7c3c02.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/faabb37d41d0/vmlinux-cf7c3c02.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8d47fe92aaa8/bzImage-cf7c3c02.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com

 free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1177
 exit_mm+0x18e/0x250 kernel/exit.c:581
 do_exit+0x6a2/0x22c0 kernel/exit.c:962
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1116
 __do_sys_exit_group kernel/exit.c:1127 [inline]
 __se_sys_exit_group kernel/exit.c:1125 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1125
 x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
1
WARNING: mm/huge_memory.c:4371 at deferred_split_folio+0x974/0xaa0 mm/huge_memory.c:4371, CPU#1: syz.3.1110/10500
Modules linked in:
CPU: 1 UID: 0 PID: 10500 Comm: syz.3.1110 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:deferred_split_folio+0x974/0xaa0 mm/huge_memory.c:4371
Code: 31 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 c2 67 8d 09 cc e8 8c 73 93 ff 48 89 df 48 c7 c6 20 5b fc 8b e8 dd 2b f5 fe 90 <0f> 0b 90 e9 d4 fe ff ff e8 9f 7a 8a 09 e8 6a 73 93 ff 48 89 df 48
RSP: 0018:ffffc900047ef540 EFLAGS: 00010046
RAX: 1c05fb65cfaab100 RBX: ffffea0001840000 RCX: 0000000080000001
RDX: 0000000000000002 RSI: ffffffff8e4da1c7 RDI: ffff88807d6f9e80
RBP: ffffc900047ef610 R08: ffff8880b87247d3 R09: 1ffff110170e48fa
R10: dffffc0000000000 R11: ffffed10170e48fb R12: ffffea0001840040
R13: 0000000000000000 R14: 0000000000010000 R15: 1ffff920008fdeb0
FS:  00007f32e32a76c0(0000) GS:ffff8881250e8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5825757930 CR3: 0000000034ad8000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 migrate_folio_move mm/migrate.c:1411 [inline]
 migrate_folios_move mm/migrate.c:1740 [inline]
 migrate_pages_batch+0x319f/0x4c40 mm/migrate.c:1996
 migrate_pages_sync mm/migrate.c:2026 [inline]
 migrate_pages+0x1c74/0x2a10 mm/migrate.c:2135
 do_mbind mm/mempolicy.c:1614 [inline]
 kernel_mbind mm/mempolicy.c:1757 [inline]
 __do_sys_mbind mm/mempolicy.c:1831 [inline]
 __se_sys_mbind+0xe89/0x10f0 mm/mempolicy.c:1827
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f32e239c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f32e32a7028 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
RAX: ffffffffffffffda RBX: 00007f32e2616090 RCX: 00007f32e239c819
RDX: 0000000000000000 RSI: 0000000000800000 RDI: 0000200000001000
RBP: 00007f32e2432c91 R08: 0000000000000000 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f32e2616128 R14: 00007f32e2616090 R15: 00007ffe30c61cc8
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

