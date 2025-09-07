Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DDDDCA1013
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 07:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607368E0005; Sun,  7 Sep 2025 03:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF1A8E0001; Sun,  7 Sep 2025 03:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51BF18E0005; Sun,  7 Sep 2025 03:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0D58E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 03:11:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADD371A0722
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:11:37 +0000 (UTC)
X-FDA: 83861583834.18.EB11FAC
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf29.hostedemail.com (Postfix) with ESMTP id 04F8E12000F
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:11:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3JzC9aAkbAMg6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3JzC9aAkbAMg6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757229096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ubewheY8ZTSPDA8vJSlVExU9cNAqFiFuY9Aubhjpw4s=;
	b=FZEGqvV98E9LnRRQTUIP3bl1NiWfXmgYX+AoPz022kJv3X8Kno2aQhMcqw9bBB1L8Qdgyc
	KiQWxZJ0dWbnKkH/0gHEZOHE/XZKB6/JJyxCTwVI0L4Z/LmYbuLC2ZI6BBDUP5x3M9u1Nz
	wqPg9w4MSEiPuG3tVXIewEF+r2XU1zc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3JzC9aAkbAMg6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3JzC9aAkbAMg6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757229096; a=rsa-sha256;
	cv=none;
	b=IP/Cpd6LitxlSMCwwvOVrqKWIPOG8fIHvLKlyINSzoq91yHUqWOVLffeCspaBr6pehloot
	94qOR62TJW/hLBfV29iZK0M4pr8T+cq3dFnEPhugMM79pU10zD2JgWJ794+iYRtnJV2DUz
	12Us/f+QdOz4h1ZYy2j6wN/KwRlxhnI=
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3f321907716so65640615ab.0
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 00:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757229095; x=1757833895;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ubewheY8ZTSPDA8vJSlVExU9cNAqFiFuY9Aubhjpw4s=;
        b=EA4UyVAutsAJTI3w8pNhPBQGygnQOrWuz68Nt/m8OheXQd9xiDZFnGdGSdEw3zC6ke
         oNfuQZ3nh7p7+xLlX6DyzDQni5ZOp2GiqkvZ8QPYaGBVw0sk2+jn6ON0WDNPy3v1xOJK
         tdHL1aBbxCnzSrIKFDl7DcFqQ6lgSBnVkALhz+7cfRjnFyeFgAypscHhq5kJWK6+nJTu
         znSeTnD8Eekc3Mq7zmy5fObV1J5PEXttR6MIMgvPNS5HbudeQeYb1GMS8Q2ZOMBZ2H4a
         /HV0cBX94h0WeeBB2FzbnBRDSANkc45TigQR/OC2gdWQhsNW4h3ggLKQH3m09sUkv1UN
         4F1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVZoJyWl/f12fekLsJiGDzwzby52/DEMYWzc7G1dzeQY+1/vkaKzQT7Sijj63Px7ri0v9kPNyLmLw==@kvack.org
X-Gm-Message-State: AOJu0Yy4KV5Hfr9XTef0zPQR27yMccMZY4MuArdAoI7ejwIiAfYhXVNZ
	wJVSgwQCpfzzZ8PJJbyTlxv5t75iYEJgOLWTtPGKq3+FME8bLES2Ly9ygWCEMx+4ta4hEQD89xi
	ThZW7Z5sw7pPSPIlZlI5td4DNpghlS/M/Tcvbx4xk+lzgsgCMq89A4Armn4o=
X-Google-Smtp-Source: AGHT+IFhxpWMbfP/8VjiaFb7Tjmk3W3CHtWSS2RDMm5Zf5J9mhCagz2YYGMLQrpTVpALgZ+jcAzo324oJgcV6ErhnCztNRrgBxos
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a48:b0:3fb:d14c:3562 with SMTP id
 e9e14a558f8ab-3fbd14c368amr87816915ab.2.1757229095079; Sun, 07 Sep 2025
 00:11:35 -0700 (PDT)
Date: Sun, 07 Sep 2025 00:11:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bd3027.050a0220.192772.01cc.GAE@google.com>
Subject: [syzbot] [block?] general protection fault in bio_iov_iter_get_pages
From: syzbot <syzbot+b253ade8e1751d90a7a9@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, david@redhat.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pkw687zs4yqrg535kifiqsme71br56y9
X-Rspam-User: 
X-Rspamd-Queue-Id: 04F8E12000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1757229095-366682
X-HE-Meta: U2FsdGVkX19dhwBzNGbMeQyTBesl+vTyEsbef35L4ojBvUvUToJ+jzFdSsCzrRJd52w2ZQ+HgFGx4XA285aQ6zET11mG4YBTtoc+C7s5L1pU6iDiLFi+X7B5elMm6LtuEY07xKi7BNXvj1gRoFfmAC1ETKT5k7LlMX5306sXTepHMQ/dPywkVe88QDxKM6u735uvHJvUaIMSde89O6rnMhYSeJZgrFvqpL3tF8hXEhpPnhEwnYnbyq/zALlGLuanM6F19WGYX7gREH+NKanIDDnPI2wjc629vcrB06/347xSJfP+5ldd/2ohxuA3f8RJA9+WpzanR6AomBys06OpenGKePYdVplcGn+QE4aTH+/6Q06sxsQ2JHk5SzmUQNz5XDN4wuwzIA+b+DRCe2ZwDeBBYWVRkyVuYXKOH9z38RqIGMOatwD6Qz3hXediARVQscYoeEIJekGFJ+AFOjhJ4VE28cqd9bWATKDAMbwKXZa3KpXijqoskV4CYYvXM75IHapEM3TnLVdRq+CyGAueRpowI5cTzd5DofWEQOjcZIRozrWNZpJV1WQZaXUhYl80WvEC7tOStx0/E9SB6h6481HwkJy02XZOh1stQE128W4IaRhNaUgYZ6USef5lqZLmrc7JDymBZDLrlaTwj9KTupIjN9L09cbMmuxXV2QKmWCNtRbICQY/KyvUh/npedBHQLMo71Unr/JdXhq+Sk40Yc2E0ExVanZ370FLok8o7mWRWfsja4ThIayziXI4vtUEH77FY1VJtdjkMprmpPj64LmAYQZNXQRMd94u0SOgagYakdKyhHi3o5bc3zPvfWcDw4xEc6kW06o0oI9wdl2BMpnViiBQXGRRnu5rOsbxejGBHMfJh1hE6qFtzWwKjJmaBUumb+CaGA74ztNWRTUu70i/uXtChZkMIs5JWYzxajwEgFv8qsK8rbx8fFZCOAmG2pGWeQuLBYAgacXUdhz
 9v/p763u
 myg310MS/SXA5gVcgtMY6eJ5xmDM0aDdWH9QuQQYjQ2RchQWsn7JtpJ//bdLUUrFkOTlfnoSqoOb40VxxMlVOoPI/+5xhd9bZQ/i4j0VEzrJngs6NyuK6vOtPAzCChbgxGukiDN7F7WDMuDUKH8oW50zsz/084Y2a/c4c7XjGAhwUD/hEIDc7svqM+XyJO7O3V2rhHKYC+ru9oyW573m0ttKtHRbZMzke9H+6TR7Z45SayeFsLgX3zfqObbXiWCY14fPBB8hG0XwQguvOW5f3mLLixekayZDvlr/46wbr+H4shLtgFjjqj9EaGVDrx3wT6Bj+swdUbxJ58VOEog0zMs6BnNGFHTSqnIrfKv0pv36TNB7iLToS7PvtZwYmZfR6QmV4nfol5Ebw3C5cnAKKe3rpRj62XfO6nZsMwBYAAThOwGzEp0anjVt66XWVXf69tLEK9m10VS6NG2YbtdShQ8Yu+PTnC6tiOIRApQcHYv7UBMfzq/RELAVo2dIW/C09qUpZ5EMYQt6Fx6Wihol7wHtWTY5e6BTwFrEDktbAKzuNgzsdrvc2I0AU0NodJxYW3MRLpt8paCa23Nq9Y/hdgXiiTdwmk3nV8BHYSH3dcdx7/kcCAy3x+3YTTBnG7P9jlKE5jP18Q9X7atbN99LUHovv0rHggMiGEFC0PfMCQF804nO/7ISXwgXrDfK3ACC6S3t7xbh4MC4c6bVXY7AeI3mFhm5VTx3a+w47WatwqE8puhuXrwrJQf42ZreuhlXa4A9QRzizkHa2OCFUzvyTVgBJAARrb/u4MK9c4sz3xY7cwtFCHczm9m064VPYGKUT6VX0NtIwzCU16im/9K0XIjsleCUsnPxTLlBk9/FfD13X8aXuUmxvRnR8YVnpevgA++2bXBOkNpAtxZcDGKZ79aVe4L9We/Rk3GpK1P7nF9N+liCtPYAIzeCalcGYQlZzeHosEAFEZ06vBHN+gywN3qA/e2/U
 e/pvlFHu
 jFhOLt2MPlBX1RsT8IMXObz59zcIomQ8UcA74+b1HDpMwnJ/zNeSe/++PZGcl0p82D+PoTbFw7/ilueOPhqUddvhy1q3IVEtKTq2X03YSkfya0W9SviYqs+0pLsxrYR9g7Hfkb12cfDsa3usmZhuhLSL4OBYHOWQkzLHxGR+CqQnDh1QEbef3YAIJwo+NlDE7pqjALZsHkaYT9R3MmgyPL+5FzbysT4zs1pzuuarCi3TvvQpgPlsOF6uMphII3WcQWdMTRUDIdev1hc8DSGXyNFM2MgmdbW2s0KaoT8yRybv6qgmoemyc0wYPvL0aw5HtmQwitD96eoJzqhTPY+RGb+xHitGWyXXjREISt+x/EqgZMDdw5MB9jIVytl3BYuvWPzuN223OBYEZNsRITUzD+94UIv21miXVAmFVB64zVaslsDAWNLHbUmS6nvYNSDZeymVB8dI3p8enSFcAsIVtoIeQgvI4g8SCuLZ07ZAveEtkHCnY2OV01rPa55olIw5tdZvYqB525bhQWdUlf++HQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    be5d4872e528 Add linux-next specific files for 20250905
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17896962580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a726684450a7d788
dashboard link: https://syzkaller.appspot.com/bug?extid=b253ade8e1751d90a7a9
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10496962580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a98962580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f67121360b62/disk-be5d4872.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4f666ca2e57f/vmlinux-be5d4872.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e86b794b985e/bzImage-be5d4872.xz

The issue was bisected to:

commit db076b5db550aa34169dceee81d0974c7b2a2482
Author: David Hildenbrand <david@redhat.com>
Date:   Mon Sep 1 15:03:40 2025 +0000

    mm/gup: remove record_subpages()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a0b312580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17a0b312580000
console output: https://syzkaller.appspot.com/x/log.txt?x=13a0b312580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b253ade8e1751d90a7a9@syzkaller.appspotmail.com
Fixes: db076b5db550 ("mm/gup: remove record_subpages()")

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 UID: 0 PID: 6063 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
RIP: 0010:__bio_iov_iter_get_pages block/bio.c:1258 [inline]
RIP: 0010:bio_iov_iter_get_pages+0x5b2/0x11c0 block/bio.c:1336
Code: 9c 24 20 01 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 0c c9 7c fd 48 8b 1b 4c 8d 73 08 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 f7 e8 ef c8 7c fd 4d 8b 3e 4c 89 fe 48
RSP: 0018:ffffc90002f773e0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff88807bfd0000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002f77590 R08: 0000000000000000 R09: ffffffff84a7d3b5
R10: dffffc0000000000 R11: fffff94000329b51 R12: dffffc0000000000
R13: ffff888078cd0294 R14: 0000000000000008 R15: 00000000000000f0
FS:  0000555567d13500(0000) GS:ffff888125af9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9a3134c000 CR3: 0000000074d2a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __blkdev_direct_IO+0x60b/0xee0 block/fops.c:215
 blkdev_direct_IO+0x120f/0x1730 block/fops.c:434
 blkdev_direct_write+0x7c/0x140 block/fops.c:719
 blkdev_write_iter+0x547/0x710 block/fops.c:787
 aio_write+0x535/0x7a0 fs/aio.c:1634
 __io_submit_one fs/aio.c:-1 [inline]
 io_submit_one+0x78b/0x1310 fs/aio.c:2053
 __do_sys_io_submit fs/aio.c:2112 [inline]
 __se_sys_io_submit+0x185/0x2f0 fs/aio.c:2082
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9a3058ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdf48caa48 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007f9a307c5fa0 RCX: 00007f9a3058ebe9
RDX: 00002000000000c0 RSI: 00000000000000f3 RDI: 00007f9a3134c000
RBP: 00007f9a30611e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9a307c5fa0 R14: 00007f9a307c5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
RIP: 0010:__bio_iov_iter_get_pages block/bio.c:1258 [inline]
RIP: 0010:bio_iov_iter_get_pages+0x5b2/0x11c0 block/bio.c:1336
Code: 9c 24 20 01 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 0c c9 7c fd 48 8b 1b 4c 8d 73 08 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 f7 e8 ef c8 7c fd 4d 8b 3e 4c 89 fe 48
RSP: 0018:ffffc90002f773e0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff88807bfd0000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002f77590 R08: 0000000000000000 R09: ffffffff84a7d3b5
R10: dffffc0000000000 R11: fffff94000329b51 R12: dffffc0000000000
R13: ffff888078cd0294 R14: 0000000000000008 R15: 00000000000000f0
FS:  0000555567d13500(0000) GS:ffff8881259f9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe8453cfd8 CR3: 0000000074d2a000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	9c                   	pushf
   1:	24 20                	and    $0x20,%al
   3:	01 00                	add    %eax,(%rax)
   5:	00 48 89             	add    %cl,-0x77(%rax)
   8:	d8 48 c1             	fmuls  -0x3f(%rax)
   b:	e8 03 42 80 3c       	call   0x3c804213
  10:	20 00                	and    %al,(%rax)
  12:	74 08                	je     0x1c
  14:	48 89 df             	mov    %rbx,%rdi
  17:	e8 0c c9 7c fd       	call   0xfd7cc928
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	4c 8d 73 08          	lea    0x8(%rbx),%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 ef c8 7c fd       	call   0xfd7cc928
  39:	4d 8b 3e             	mov    (%r14),%r15
  3c:	4c 89 fe             	mov    %r15,%rsi
  3f:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

