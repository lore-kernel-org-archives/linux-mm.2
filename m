Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC61C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 07:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECF236B00B6; Fri, 31 Jul 2026 03:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7FC46B00B7; Fri, 31 Jul 2026 03:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95366B00B8; Fri, 31 Jul 2026 03:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF2CB6B00B6
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:30:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4328F1A0392
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:30:35 +0000 (UTC)
X-FDA: 85048249230.21.7929423
Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8793020011
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:30:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3GE9sagkbAMEz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=3GE9sagkbAMEz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785483033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=onVNy1/pz6Y8QBVwNGDpWVhxl07qQUJwn142gtHseXs=;
	b=NOYEw1KT09s+j17j9SnPXYMwMASc06meILeENVr8vz3OphHZ3U8OZk1zYM31Rixyw5l7D8
	yjCE04nA5vX56b1NBPSmciBqkvt3xLfzw2tQ3qx++Fl11JUKFDCEFduY1Ihw28x8rExRG5
	PIgiCgEexaekGSW3k+co4Zt+mG5Uvr0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785483033;
	b=8bEqizuYL0DVlWPNJAXuaHs5pTskN0fcP/p3OF6vabKI2F2aSXOefvJ1SB5khQ9CJDSr0M
	tPjAwsi0Y99ldMulXuCVqoY+i58TDYHqpLMh6lEj8zbaS2wGoEuBMQsWmOhUh9cao0bgXB
	cbaBjxqPVxUf6TjuYgsHpPNC0zbfETg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3GE9sagkbAMEz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=3GE9sagkbAMEz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-49ab6a82cd5so919986b6e.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785483032; x=1786087832;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=onVNy1/pz6Y8QBVwNGDpWVhxl07qQUJwn142gtHseXs=;
        b=RqxmoiPk4zlhimMddoBdsWjlR8h0YyjrZkbazxFhNiiNgIArtwvwjqfQUzqiDdzQCH
         imIY4qIoLaGp1KrRk9zk0mlBXY/SvqwrPhy9s4G9yjFcIc6WSd8ijykAJHQZXV91xXTm
         Rwsm3aRKsByB9LhVvaf2Hr1hEFirffTGeu3z4GIeMquS9BiBQK9RQ8GT/bETWK1pSFT9
         IIZprTr5ImFgQbwnJuubDNi5qXLGUUe4ypZQiawbgyvOWRg96tWDBpDcRrkX2sJml5mC
         FbCu9KNC86Yvj7qVrZsZpkVkoBCwI7dknoELYZwA3Kg/eiQ2Rhs5d7q52Wx3MjtazlZ3
         9jFA==
X-Forwarded-Encrypted: i=1; AHgh+RqWFhfwF5LvlfKTTueHt5SO5Hdwlr/XRVwf6adc8nnyZ/HMlA6jeS1WxExs0mmoaNIdOrrjuWW0yA==@kvack.org
X-Gm-Message-State: AOJu0YxriZkfBhm49sxYCyXWvXBoyLUVlydEM7kzjBJ2bLML0jJMAwlS
	rjoWmbs4S2ihbHsX2xg+ySE13UDf0X8FqWv/2K1ugElCWhnJ6RsoYU5T9npoiN4lUyZxyBdQa3J
	72NMEvthfdx8w5c6ezp60J48wqgFG0D2bjMDrBBD2WjqPWmjAz0B5V/eM26E=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f48:b0:495:d7ec:b6be with SMTP id
 5614622812f47-4ae4c424710mr871943b6e.18.1785483032617; Fri, 31 Jul 2026
 00:30:32 -0700 (PDT)
Date: Fri, 31 Jul 2026 00:30:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in mas_nomem
From: syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8793020011
X-Stat-Signature: zmaarnggiebzaox87bph1451dktxyyfu
X-Rspam-User: 
X-HE-Tag: 1785483033-34080
X-HE-Meta: U2FsdGVkX19ox/qzBtLN7YxHEjSibSa/dmlhQj30YhL0ioLamsIZ8Odxi7fWRfHGLo22AR92Qd5A5EltAhgkRoHQl1e9b1iJRHmwRcBr936JB1LQuWe7PvNzBKMYqYE9zt8vnO7GbPRIQD/YtarWEfmAS8plxASwD7UKtijpZmbUqiBV/1jyn5dlwuTzA3BSLg99sWNqXgpjsvJd5G3RfLBZi1UQPIGN9ISkijn4qfifz9ClZMNQpMeOtRIzUI+mRaqB6FORn26NulWVdm3NJI/uBUjGBa1iNaBmpKCAvjqybB6+NJTyzi0HTwny1MpE05D7PNPf01uWh/ykbcCGDbnk+U08VCBKQYeTiQhjKKZp0w1c3KuUoqkqQiZZmuq3RY2SQAuI0mqay8djcl/LI+sIZv2jHH0tm6uB2SL+bXGGJbQT8jZlx3Vu926vFOtndecr4QtkoyjHxVtmhGlutgYl1JwEJxvraCH6jYKgVdvk8pRdiElU1Bclo5n4FguBQWLSWSFSolx0oi1qI0f0ErxgpZFWd5Z1Juktpu4wXgmx7Ul9peCk/KQlTp+RK11+y+FWC5bP/Pmg2jTNAO444ltiIY7MRNRemPDCiZCDGqqgDeg6KyWOH6JOwacWcJgMwvWVF6lflsCeZygZK1NjmW8q2OklxmSH+Q6zPU0ax2g8uG91LSgXLBd5qp9es07HBlh6l10thiGFfE+gprK8YKN1GfMYjgmmHouHcoID9qwk7yKyVD1ysi6bloAvwMOZuvEv4VIMVGyjieTVu1kW3ixBMfGDvEVtT30WU9jEcR8sT2NCcMjh5jpbj4TInbU9mPLY8xSBgx4n4cobpCEto2Yye4Gv+XYVCVe3mDciNmTuYkvI3p6xH1tho/KuozRhRHcDFdaR7XOaVrAWGbiR6FkWxWSxWyhnQ+LJjSY9lAGNiDxM9xEWG490qisB1p1U834ENCMLIT7hVZ/v3xf
 ZseIXD3i
 nZAXMVhIw6YeZKVN9rlWzVGxX8GD9R1GIAYiV2+tqhmdDybBkZ6XsLhJSSaBp4tC5LNYBfwBzxzZ8EpgdK43u/rWs8DTKT/9xZsd+JS7mBU4TmJ7JEmA8eOabTLIeLACGbUCJKguV4x/2xA5q/RHvzMubTsVF0NUv6/UCo2y687NTe9OunIWcS6rRpAkY7VtkV7qK2mbKDPVnT3A0lY4F7LC9U7vPNby31BKt1I1V8bTNtg8UlU6rqdcGvkJ7JX71lZ3xk5rqe+hJJJecGqm1cwJg47ZusMx0esag4jRaOJJ/dfiYRIHDdbbP4ZziFVUiOv9+dfc9V3LRSm/2/CDdxufJpaAE45YLl9KfMcMSVaE/43W+AulvzY+rTXpOGZn0zyGU/qlbK1OA5qiM+JvwiqtcLgqlpzbZ4yOLkIfVXv9fHIhJ7PXZBLwaY6CWHT5LJlxPYH0UJytW87hwjKVCfy64VZQ2ZguOw5wn/K7LaoUTgQlIjeMmtbJ1uXdr6qbqRmMCBbmNtvks0W2yCDPAvJGs8KtBhQ0hngzcQxD08hkGZRlQ85YsGG/6WyqjQEYeeRIo1uSfIYz6xi+hMxtXfm5pAKkZpfN+D2CJ4xJHeiqe+IP8KTtnh/zAV5RaXm9qNtFkPeg9ytwlmBYhFMGgZ4Zp8SWzvpHi65jn1YNE2tTMkWnT/1SdFri9x/aqkOy9lTH4ty4klpcsNJr58zpPu3OI1671kkop5mmoGmFZ+2xeHSmzkApme4JVAx0ATJ1vDgoXIMlScYmsAbZwfAX62wvWHsaHyLlO82jetKphbNAI7SdZDUAfXene+A9NNqNN8GrRrbyPsMxbafIFZ4V/PHowzdNgHvjc1RFYM6pGNq4XSRBmzP4kd0Jcq0cdlD6p6swRK9XXgg2C3SWrJNmw5E6JAzP77f2xqo2iBbH/I0+vi6nv2UyERU1H+QM8v+xj0D+uP/UuyvqjfFH1S1ilKWKbcMRx
 fN5CEkig
 xcNFdGIvi5azNp1zJe82SlybNSTjry003ifePyvwruLWPDp0i7HAhAHDv41Ua/pwyXlctKmFM/EE7X4bsa+pIjP89MMNQL8KFCOICBu99pJ0VpN+4bwvdyylHoPdZgFIyhJi1Otyr4s7GAoDGRvrQQqe0HtX1RGBKkdW3kyIKw0rpbuj3N4Uya0lFNfHG77EUoW6/E1mLuTNbABDSjoAyV1rTOuliC2KkCHsfM6GrSeGpA1qligvMU0d4iuf4hQ0yN0tMaVNG9WsS85NlJ7lJK2JhbRzQB/W1NSG99mWjVOn6mR6OJ/Dd375edMevWqLzgmJA37vWlNmQeavNutBAknOosKDI+/VBqmFaXdSkTQ+SW4G3NmbRrPjyGsoWNxCAcdV4DkPwOh1SC+36Fz3zeX2sFqaiKyoP66HjPi67+/UbTlmPFh89sTS3DSEaP78u2hBk47DHXU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    cc2b5f627e8c Add linux-next specific files for 20260714
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15ce5632580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2290ccbf984c524f
dashboard link: https://syzkaller.appspot.com/bug?extid=78a7af91b68fc6394771
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179151b9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6836f8efb1da/disk-cc2b5f62.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0109d3477cc7/vmlinux-cc2b5f62.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c2e49e350bbf/bzImage-cc2b5f62.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com

------------[ cut here ]------------
!mas->sheaf && !mas->alloc
WARNING: lib/maple_tree.c:5751 at mas_nomem+0x1cc/0x210 lib/maple_tree.c:5751, CPU#0: udevd/5627
Modules linked in:
CPU: 0 UID: 0 PID: 5627 Comm: udevd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:mas_nomem+0x1cc/0x210 lib/maple_tree.c:5751
Code: 4c 89 ff e8 d6 85 ea f6 49 c7 07 00 00 00 00 b0 01 e9 95 fe ff ff e8 f3 2d 7e f6 90 0f 0b 90 e9 2b ff ff ff e8 e5 2d 7e f6 90 <0f> 0b 90 e9 77 fe ff ff 89 d1 80 e1 07 80 c1 03 38 c1 0f 8c ce fe
RSP: 0018:ffffc9000562f8f0 EFLAGS: 00010293
RAX: ffffffff8b4775cb RBX: 1ffff92000ac5fbf RCX: ffff8880366e3e80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000cc0 R08: 00000000ffffffff R09: 1ffffffff1ca1a86
R10: dffffc0000000000 R11: fffffbfff1ca1a87 R12: dffffc0000000000
R13: ffffc9000562fe18 R14: ffffc9000562fde0 R15: ffffc9000562fdf8
FS:  00007f9021203880(0000) GS:ffff8881259f2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056467bb0d750 CR3: 0000000046416000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 mas_store_gfp+0x37a/0x820 lib/maple_tree.c:4987
 vma_iter_clear_gfp include/linux/mm.h:1674 [inline]
 do_vmi_align_munmap+0x30c/0x4d0 mm/vma.c:1644
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1697
 __vm_munmap+0x241/0x3e0 mm/vma.c:3347
 __do_sys_munmap mm/mmap.c:1079 [inline]
 __se_sys_munmap mm/mmap.c:1076 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x17b/0x530 arch/x86/entry/syscall_64.c:85
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9021368097
Code: 73 01 c3 48 8b 0d 61 2d 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 0b 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 31 2d 0d 00 f7 d8 64 89 01 48
RSP: 002b:00007ffeaf32d0a8 EFLAGS: 00000206 ORIG_RAX: 000000000000000b
RAX: ffffffffffffffda RBX: 000056467bad9bf0 RCX: 00007f9021368097
RDX: 0000000000000000 RSI: 00000000009480e8 RDI: 00007f90208ba000
RBP: 000056467bad9910 R08: 000056467baec140 R09: 0000000000000006
R10: 0000000000000000 R11: 0000000000000206 R12: 00005646569e2588
R13: 00007ffeaf32d130 R14: 0000000000000000 R15: 0000000000000000
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

