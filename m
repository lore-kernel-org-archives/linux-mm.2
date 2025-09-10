Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2042CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 03:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F8D8E000A; Tue,  9 Sep 2025 23:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8F98E0002; Tue,  9 Sep 2025 23:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9598E000A; Tue,  9 Sep 2025 23:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D44488E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:46:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 670BB86D50
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 03:46:33 +0000 (UTC)
X-FDA: 83871953466.18.2B5FB89
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf16.hostedemail.com (Postfix) with ESMTP id B93F4180002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 03:46:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3lvTAaAkbAM8DJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3lvTAaAkbAM8DJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757475991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=nJpekRJ4ltGwgno2RKBtlHJn+DT7VRZwBvsTfYmMG40=;
	b=Ujsht6GFqPSunRX9t5w+7AOuBWQVYaW6undKFToxbm1YhypEvSipNY2MWdeHuc1R049BeN
	fig18ArBkpimpj50bQ62Sq1kJ4Mt7mVuyFlcf6g9gLOo1bboh3v6rzLrFlCaAaChXDPfDC
	W6cq6RY4HqslvMkaV7B2PjQDBKb0PaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757475991; a=rsa-sha256;
	cv=none;
	b=dYV6hpxpnh7oyP78MfLdLoUjxtR2RuhkBnCavxalXhGu0ZI+vl0qElqpxEXa7c/Mosocnx
	LZnRy1dxXm6nQ8mTI+hbdcATa8ZDxwwtE6N+TPgJGNasUOx0sRFGeOSUCEm/7cm+to9Xpq
	ogBZOxNw2+70ihM1k913lRFdRLPYh+U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3lvTAaAkbAM8DJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3lvTAaAkbAM8DJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-40856fed6a6so41343255ab.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 20:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757475991; x=1758080791;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nJpekRJ4ltGwgno2RKBtlHJn+DT7VRZwBvsTfYmMG40=;
        b=qJMe6BGOeyDIbHmyTM8lpm7az8GuG7U0DNqlD1znDZlJ26bpe4Ima4UmYhNoUou+sX
         zCv6bVGl5uMp7aEFVq3oFZ3TQj+rGVX8yp6pE6GmBjxJxPD1foQM/2L6mfXBtfvQ08d/
         g3eYGpJM2vx3xmLRrYjxDNpP8nfTAZcd7zucjja8HXn8JUhs7XBTR9FxgqElgVujZ42z
         0zekIG7Gr2wkBjST6AriH92H88YciNm2EA5Yby3l9N7VD+UtQBBmO+6eY0E2GlzlLlrX
         BwOvdT5EZ+ZWPfwb07Zdpv3dEx2WFpMrAMZ9W2XV6xO4/c1XErbauLkbTjgB517sve/Z
         hkmw==
X-Forwarded-Encrypted: i=1; AJvYcCUElWmp+3oIAu5eVOPjQqPAz/2N0rIdw0gCkoNaoRUjPKuGEmt3wghz7Ioo9jA/xLsexnOxXWcvUQ==@kvack.org
X-Gm-Message-State: AOJu0YxvO1cjGqFsD009nc0rHic21LtYfRXeF0T2o/cs6DIx1udA4Ghu
	VvRCdHITBlKynlOwFiaoeA7ciFV+XfyFzigOPWaV6/6yzvZEDML8bQWphjSwiK4M1RDxmBCZaR1
	6a4jYxEjcWK6J6z49m9i26VwrJk1atlEy5kCI8UsvvZKI7zlkcOTW7DJmhbA=
X-Google-Smtp-Source: AGHT+IE2m0YtHdklvI2AqehcAshQg6XJlAZm87AjsfgD2bo3DRMFpw4TS0BuY9ASks3/0aU0l1XFKsjAbyupZECAR8zIJxJ7Jcmr
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184c:b0:407:51a8:6b71 with SMTP id
 e9e14a558f8ab-40751a86cdemr137782995ab.28.1757475990722; Tue, 09 Sep 2025
 20:46:30 -0700 (PDT)
Date: Tue, 09 Sep 2025 20:46:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c0f496.050a0220.3c6139.0017.GAE@google.com>
Subject: [syzbot] [crypto?] KASAN: wild-memory-access Read in crypto_nhpoly1305_update_helper
From: syzbot <syzbot+634e67b3f57206befe3c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, davem@davemloft.net, david@redhat.com, 
	herbert@gondor.apana.org.au, jgg@ziepe.ca, jhubbard@nvidia.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, peterx@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: dpq3191dpojio3zss6gx5jih8prn44dx
X-Rspamd-Queue-Id: B93F4180002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757475991-394683
X-HE-Meta: U2FsdGVkX180Qc0jd7Y14Kw4C+46z0H6l/L93sksTc+ULipAAA+Z0gUgxDNg4gJ8VThAa2IQw81EdBpt44J0etmf+zosT9SDYnTT+VNfvASvb0YjVHz4s+LLjVFUS18WWUc2NN3z/VFTqVQxZ6nuPZCBC4MpPV2YRXzcAPtfDkzVkNKP5qUAHhb6aoCJIxOIgYlJgcYdtCt0IkiLQoMfXB/s8Czh4IVUTesOAsX72+fu5FXyXX0oiP/O0xvcRzhTf34bE8g6dWoF+tgQw65Z6O5b2fOGUjXN+QwHxzpCqi5GW9DwrqENO3p0YjbsuPGxWdPT5wHcSzRCcXOhnDBAJG75Rgoo2k4eHRzARGJoNMklGenm09YM13wL1abkURc2N0ywND9ASKU4eAxIiqfCV6VU6Wl2MAvGx2uvWHgK/z/tRlZyLKMbp6s9WJ0WIOGzPV6AbD56v+PDYKs2e1cHwwR3FQyhWATrE7F1TXfhEntCk7cTT4Fge0LKSLwYbs8uoEvoLMwhwA9O2d88zGBVtnK2HDhHGEYiF6U9+Hzr4wWWanAE/8uD/DA33yHb74x8M6gBvo+e9y1V3Gt11UGnHquw0jyI0PdFELoVmWMBEl+A3eSYnhpztWumyL61d/Mob3h4w33LyGQ+FmSI6pw+wHPaFaY+oerPuY60A9pyXsCDLEWhLDuqGkNh3X0JCV5mzbtN+JEpKn7s0UzwD8DNBUTQi92WEK0RNdZffF+fPrAGS8mziHXo53Qcvx78D1r2Kc+45ENvBCC6aX/fSor3S4DFo05JABZa0YfO7u+Zg+0+NOgE4rQNZ8qOouBxWOt+H80V+VcdKMe6EaW5Og7tKrzX0/ek4q9A6QfwQhMwbvkKzi9AHhJ+2cagTpFlsnvkSNrbZAOYLT64MKbE4opgUL35oy2R77jShuakCRq66CKPJKyqDp1BKNKWE+TcS4pe+uDSYLDH6t6i/B0A2J7
 44pGff9D
 UGexx6wz4Z9hrkKVevwBXfaZv6YPChEWDzg0kYmY+ZjBLTTMXszcx/fJXXWaWg3a+2Ee2/fINvu3FozGHwSJ541XoxWDZQvDAdfNq8cAX4yuBlIklgSayuXYdjWvjJazydYkUgfZ0SEFRYF5REfaMzpiVH9zLXM+TWB3Dl7CT+5gLyEZ35oIUvntjoHY6i4UuxoldLGt9QNiJQ5SF4Vd3B7Xe1bs2V+iFvWbxyWzW529PXzFodareg4jTxER9iscHdM6Usiy/GmoFju+dYop3mtQnFTjsc/1szbd5X6i6Zsitc1nt/Uhzs+3sRkzjpskxQP1lzmnisaRj1dZf4iXdI3SXV/sMJN51RSPccepBalQagzluTheU63txXBPsHEd7ErtStqN3NZedcdVdnP8nO3UV5oK91vO1FMnOJV9Yq6RSU56Wp7TMx2u90JXGqWweHmyNBcAcPKOjNoJZ2bX37VoYGWWplk5Vx3ZmtKnFbbWofoFJzSPZEAgWuvZEzxCpWQeuWH4ZJGg+AS43zBFHuLTtD9Kh3wYvnnykKZ+KZvZOf4vb4Og1cXfSBcfstnF+rMDAX/8ndt6mLmQtpVjVdLhW61ZBja5X2f9S1mPSa4ePGzW/qz2tTmaRvfdj6ihtcvHnLLxi4HrBmpnhcUJ7OGjPUhYriSrVMw15TvdFDoQxl+fc/T8AH1AydhRymZFB7meEWZnIAqaA1HsE+RQ46J9jpsYmIJlUgODw4T2OvrFFkf5wHlS1lXqjIN7/oRHavdXQCNucvVhwQQsF/sb289P2+yUjNM9tuqeBLMVTUqksWKyLS+IpVlgF3GA0taSKf9dFsn1fNRCZIfjpTl9SfwdtcGzmDJkImZmPgPRU/LNeNNjXXd5URergQ5+eSCpJeMmMXve6A4ws5Z770yrffwwoVMgzx5hHfdIn4CLEhXJQtAUa1By8Ah1AbWQmApsZTrwaL399yHyoEwzt8XiQp7YJ2tvZ
 8y2u+9+s
 839jK+Vro7fJnyfNTTB5/6CH00u2tr4lNP0N8TTnmq57pRF0EnZr/UTBDJ3Py/fXtd15kg+3P/og0hhI7GWqtR2Ul4zMfqN4JRzCYu7zvAf9v3Ar+ZXfgdnqH24gnnR6AQE3mmC2Jto29QM/C97eP4cp1/M2ma4aZwYzmAO13FmzyR236cby5s8hYAB93/NkPNf+04EoutZ4KdsCB6XzjZ1WW3ajb+ZcW+fHjYrzqRQu38kkbMPi+Dhy0vVv+HJGcbRKJyOztAYUugJ7pQFUAT+Ljq43HCBoHPoOIZPbmK5fbN3u4bWJl8eNkPUoqcLWigF6YJ6PsnRIUC+jfrtHrBd7Vv5WB3RZAYVzIFS4YeqnzhADxp+qftiYv99t52ORwZlD0pTTFEJONwCN/o8cuPc5qZSxOZ90YgMnGQ4g1aHiGB6lLY0cflvI/DrEWf0Wa6Q1ZDFbyNDJcFNXAKlAovQq8GegerOorrz0ciC39gEIduHoJWelroyGjf308yr+VduQvW2ZGRc+ZY5KnPiWOQ==
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
console output: https://syzkaller.appspot.com/x/log.txt?x=10f70962580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a726684450a7d788
dashboard link: https://syzkaller.appspot.com/bug?extid=634e67b3f57206befe3c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1247a962580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12751134580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f67121360b62/disk-be5d4872.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4f666ca2e57f/vmlinux-be5d4872.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e86b794b985e/bzImage-be5d4872.xz

The issue was bisected to:

commit db076b5db550aa34169dceee81d0974c7b2a2482
Author: David Hildenbrand <david@redhat.com>
Date:   Mon Sep 1 15:03:40 2025 +0000

    mm/gup: remove record_subpages()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=173c0642580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14bc0642580000
console output: https://syzkaller.appspot.com/x/log.txt?x=10bc0642580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+634e67b3f57206befe3c@syzkaller.appspotmail.com
Fixes: db076b5db550 ("mm/gup: remove record_subpages()")

==================================================================
BUG: KASAN: wild-memory-access in crypto_nhpoly1305_update_helper+0x156/0x390 crypto/nhpoly1305.c:165
Read of size 15 at addr 0005088000000000 by task syz.0.17/6036

CPU: 0 UID: 0 PID: 6036 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 crypto_nhpoly1305_update_helper+0x156/0x390 crypto/nhpoly1305.c:165
 nhpoly1305_sse2_update+0x68/0xb0 arch/x86/crypto/nhpoly1305-sse2-glue.c:29
 crypto_shash_update include/crypto/hash.h:1006 [inline]
 shash_ahash_update+0x213/0x2f0 crypto/ahash.c:178
 hash_sendmsg+0x96b/0x11d0 crypto/algif_hash.c:149
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x219/0x270 net/socket.c:729
 ____sys_sendmsg+0x52d/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmmsg+0x227/0x430 net/socket.c:2757
 __do_sys_sendmmsg net/socket.c:2784 [inline]
 __se_sys_sendmmsg net/socket.c:2781 [inline]
 __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2781
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdaa258ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc3b406218 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007fdaa27c5fa0 RCX: 00007fdaa258ebe9
RDX: 0000000000000001 RSI: 0000200000004140 RDI: 0000000000000006
RBP: 00007fdaa2611e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdaa27c5fa0 R14: 00007fdaa27c5fa0 R15: 0000000000000004
 </TASK>
==================================================================


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

