Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F3BAC98318
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 09:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE3F6B0005; Sat, 17 Jan 2026 04:30:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C256B0088; Sat, 17 Jan 2026 04:30:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08AAC6B0089; Sat, 17 Jan 2026 04:30:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E827B6B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 04:30:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65E3F588FB
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 09:30:28 +0000 (UTC)
X-FDA: 84340935336.04.8E3E01D
Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	by imf07.hostedemail.com (Postfix) with ESMTP id C1A234000A
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 09:30:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3sVZraQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.80 as permitted sender) smtp.mailfrom=3sVZraQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768642226; a=rsa-sha256;
	cv=none;
	b=ITBFCb8ObDrh9OovIFZRjUqkFkOHDnyH7MIv6a3qiRD7IDv23uduyWgoC5SlUN0Q4Q1OK4
	PXCigJfltNaq0Qw7soCuDbghePjxuyrZwurZah8L9ZBdEeGZ7CvDrnLJI3S3PDrOrgupGl
	jT/GyZvWgLrCAcv1zkJo+a7BLp1HKL0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3sVZraQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.80 as permitted sender) smtp.mailfrom=3sVZraQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768642226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=XB3GJ9jGo12ah0YoMousYr0on+EB70qgKXZwNDEX3ik=;
	b=g9J/UkXVuLVvsjnefFE4xnmvwPQ3ojQYyuVV0Kh6f4GZ08Pa31ReS/5TKFI+LqEcUA7SQj
	ik3/Iu438EHBfw4aRw9UjKvV0NL9vHD4VbtFzev/YuvfdZ9WqFPoQ/ImGp0zdeveVlun0h
	jJXoZpeEbMLS0R8c5BQn4NKQvPwONgw=
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-4040b9ea153so4182622fac.1
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:30:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768642225; x=1769247025;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XB3GJ9jGo12ah0YoMousYr0on+EB70qgKXZwNDEX3ik=;
        b=N0TDVmo6St/Ngeb2AN2kfHaR9QKuECGg2eI2q8MpizXkUmtKlUWpQFbZyXe/PV8Gtg
         SwCQIauxhMAFCOVeuBDFChlz+P5mbvez51DBiwcuZ7C1oaXHgvoPUQFKItVNVDxtDBCb
         SvhaK1nBVurITqUqc2zlffrf2ufXYe/zxgN1H1S4a/DUxxfcs4gRZYtp7HJ+5NGIw2uk
         7JI70tMD397z4J9T+BeXQmmU0ZcenO/Hbkpa2OR8nA7AEWR4a97Gri77fw12MIOfrye1
         FgWRQERzKnr/lqUxRX/Lw4oqUoaRAeEW6pDs1qWXIUsf887OrMkuxg8FgZGCVo6waLmU
         5/dg==
X-Forwarded-Encrypted: i=1; AJvYcCWdzalXlikpo47tsQ3tkHMXUabLT/tnXtsjOrgQzsMaLttT5e+0aq2yQQOWoE2QLxjadgyPhxRxYg==@kvack.org
X-Gm-Message-State: AOJu0Yz/Gjvo5+HiCzpr3yz6QIi9ne0Vzki2ErpVxcieWBilzri3ABaT
	9ufRdKKARPGv81XNYvtxQUgl3aZv6vEfKQ+8XhbBr6u4CHu6pwXWx4o/6gsV3wA3bNfI0SDvHBX
	pnTbj3sNbZtuwzOCdIpCcChk6qeSV/glJfjIHBytcb7sIxiVCKmTsG7qEwxU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1689:b0:659:9a49:8de3 with SMTP id
 006d021491bc7-6611891632fmr2171729eaf.37.1768642225708; Sat, 17 Jan 2026
 01:30:25 -0800 (PST)
Date: Sat, 17 Jan 2026 01:30:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
Subject: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
From: syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C1A234000A
X-Rspamd-Server: rspam06
X-Stat-Signature: imtsp3ayrr6mueniucw841ws4ojqcaor
X-Rspam-User: 
X-HE-Tag: 1768642226-191345
X-HE-Meta: U2FsdGVkX19M3fRYo2f0HtEjlH79424ZzhL+bjTrlnKyWQSKmQUCFR587dl1JvqzpxP6ROx0EqVFbyBABs0lTjloT+NcmcSqXo0mzzHNl2oMdlhVX5Ryb062BCuBK4kt2dnIFUNPYkzRMT4CohafwFS0HKeLI14/c6q3hXFUXsC0zDJAjXx0HP0qCX/5Xy49zd8RRIZa2iEOOKKx/Mk24coaKAmt0qLqXstQ/K6qmV1tSfoHBCD/ctnR8HBzHSEAHKJuo2hM2PZxha2uNn6j/AdG6TZLQQ8MkmesJcUOyx0rTXKFjoI2IUc/zgW9XNHlQm7a2pQBSvravIAHvcnJYw9za7CPjNpRELEEKQ1ZrHrAV5A4pjaAHIjWa0WoGHwtPtGLbYqol/QvXtEtYp1fPF3u26nu9aLEyQ0c72tyYZxMGr+la/5jPjmpXkg8NSveZDoaQ+7RUWc9v2zYOrgoavcI+ihcQo07NMpSZoO+LfVCJ7Ku5vDdFaNAjGR+y768F4nhml0IjlviCOiDs/m4xUsSXbAJ9BMTECMstHVkrCcCV0eLnJLq2fbQxeAiEnrxQ0eQovL2ysdIqyrbLZ7NUJVduj1cqLYCt/Uhv36ra7Pei62PbLO/0MNbGmT8Wp1lS+OA6sKuy+wsCtI3L6hPaEuQO7hjZYwNtaFzXQqPETzk5hPwC3txM20Ijx/Pf60Q8ISkHuCy/BRnw5XQWcQpsWeEI/S/uE/ZnuCDOg1uOlmOXlVZksZTsKNTsY/+0ET49spkdjYy4PWehBgDvL3ZqPF0jW8TDxydYUXlbPiuDNYTx2A7CItVijLoJYAPXxmtFWe4xBVhk6PxPNVQTJjH+2X6vAW2KtbFQ50H0nMiMN2G8IdnPhOsRHwlICBpY7u7Ns456U5NaeWVOWwgdH7GQrFZRLY1/ZKgNxJocrdN/aK9HZOAb0jwsX8pZhMwnzIVH8kqrwWwo+QFthKE3Zi
 d9W4y5td
 6MMpf75nhvS0+WW4Vxe01cROUngBBWK5+DXqEpw8aGhuD172PDYITfW1GSBxPMfZftLb5nK9EXNMNImGjBVXWt3QlpcqRhwnvVGUF13H15PE9gc4vqDxacJsJJdJEs1RVnHPNzlM4y1+1pC1ehudeN7WLsZk4A/f1lYB30v7qAFVl0R3AsIuGGUa3QGMAD8ho53/2FX8y5O57XVrDOxXjYWl7KcEJc9afU6a8j22EqzVLpfwvuxhwxWnkBYY3PyEStAtArHBo50jf3A7B2wHomorQPvs2rhVnU5SvJrMJeeWt49jR2HQnaIsGafbrmLR5i78vTMs28ihut0txiF4OToyAmfM/3QHD5ZJmtRHPsSjJ0dSL6oVcY69u67iC7NLMVlgkbMaxbvhtTSJhBnAaGcWKJoyOIf57hjghGkx8p6fZieQEyYXfmTWOhhwkeZw+r1JfnoDaGnWbh0RSbEE5oVhJlWbYcDKFagf1ljF3hlT506/s0hk4yujwpKJB3AtQkpszSrcENGRR+A06/FyByN6SCU8cbcKCmQrTmiZLsuFobqF6e42VK9o4OdZjQ2dwu54FyxkjhOdc6jzyCh/WsVNUl+D3hDlGBtU2mafZ6spFQSHtiKIYa404kMYQv+YsSTl85y61p57ghfzCHZAzfm0jFTTo7OEzxkmlxrRCOKCaTul3GMzqOHlt2FeyLqbsf6P2PVNvhV50pXqKTOnkT3ONQLDgHL60eu1H4WJJuaGtT0lnWz9Gw0+j1iRWvgHrarxkB898nFkNwkOX8BYIZurAya1HoFkpHRfpZjP6gkL3fR+pqV7Vj/NSE3YOEv05nLjbKU1vNDgx6CkZGg/T3xZa6X0qA+XKYTmiGlisrT7MOCisr6SMRvSPqhiuU2DQ7jUTn35FPqkC66pNLsBfdKW4Q6On4NoB5yxex78pB9hYNxirQ8XiekKZOXHyLgnWggNc4Xz4hCoiWyZ58iSweIHpGZct
 TNymlKp1
 SPrTIJQp9xqu8qIsbjLg5X82JH5DAwuA21R3t6BUJN5HBrxiPSDyW+9XIWYu67YwcwOor9bgxvEYvnssc/15im+6wTBjlPpzQyU1d0PAzD6dUopokkWo5RGWuIo/DdPHST9hycy5XnVjj2PTLCoPaeLRDGGG+Qbpcj/c45hLO4BT48dbsKsWLQK4yLfpKI98sRdbN9fax8+5hSzqDtQRHTyb3yi3n4nAxPI5lYkMXxsPB5D9zvUz5e/iLVTZO4dPGvbF4FO44ULOcMF42RlQ7knoOj+phJPkhu6uunlcg/pKXyahEiiiSuI/whJr0LvtZ/K8+78tqCuyt7U7xngFrR0Q9HFVL/3tH0CxEIeaKZRxcl42+ClJNAshgxmzXcx0ufX7gccCVn0jIueUAUpGw1pKWlt7hQ5y7nb4jwEB6WCbJuAHF8iEqEIdopPo9Qa5nCE7yn1TA4Kx653TyfFAageirvNEtTpV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    0f853ca2a798 Add linux-next specific files for 20260113
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14f7259a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8d6e5303d96e21b5
dashboard link: https://syzkaller.appspot.com/bug?extid=079a3b213add54dd18a7
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167ef922580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d295fa580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/480cd223f3f6/disk-0f853ca2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1ca2f0dbb7cc/vmlinux-0f853ca2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/60a0fef5805b/bzImage-0f853ca2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/memcontrol-v1.c:642 at memcg1_swapout+0x6c2/0x8d0 mm/memcontrol-v1.c:642, CPU#0: syz.4.233/6746
Modules linked in:
CPU: 0 UID: 0 PID: 6746 Comm: syz.4.233 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:memcg1_swapout+0x6c2/0x8d0 mm/memcontrol-v1.c:642
Code: 6d 5d 0d 00 0f 85 01 fa ff ff 48 89 df 48 c7 c6 a0 c3 98 8b e8 bf 8c f8 fe c6 05 77 6d 5d 0d 01 90 0f 0b 90 e9 e2 f9 ff ff 90 <0f> 0b 90 e9 eb fb ff ff 90 0f 0b 90 41 80 3c 2e 00 0f 85 d5 fe ff
RSP: 0018:ffffc9000bbae718 EFLAGS: 00010002
RAX: 0000000000000004 RBX: ffffea00017e9100 RCX: ffff888021f5c150
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffc9000b59b404
RBP: dffffc0000000000 R08: ffffc9000b59b407 R09: 1ffff920016b3680
R10: dffffc0000000000 R11: fffff520016b3681 R12: ffffea00017e9108
R13: 1ffffd40002fd220 R14: 1ffffd40002fd221 R15: ffff88805398b178
FS:  00007fdd6c81a6c0(0000) GS:ffff888125bf7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000009a000 CR3: 0000000075930000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __remove_mapping+0xac5/0xe30 mm/vmscan.c:764
 shrink_folio_list+0x28d8/0x5320 mm/vmscan.c:1542
 reclaim_folio_list+0xeb/0x4e0 mm/vmscan.c:2222
 reclaim_pages+0x454/0x520 mm/vmscan.c:2259
 madvise_cold_or_pageout_pte_range+0x19a0/0x1ce0 mm/madvise.c:563
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x1037/0x1d30 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma_unsafe+0x34c/0x400 mm/pagewalk.c:714
 madvise_pageout_page_range mm/madvise.c:622 [inline]
 madvise_pageout mm/madvise.c:647 [inline]
 madvise_vma_behavior+0x30c7/0x4420 mm/madvise.c:1366
 madvise_walk_vmas+0x575/0xaf0 mm/madvise.c:1721
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1937
 do_madvise+0x1bc/0x270 mm/madvise.c:2030
 __do_sys_madvise mm/madvise.c:2039 [inline]
 __se_sys_madvise mm/madvise.c:2037 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:2037
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdd6b98f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdd6c81a038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fdd6bbe5fa0 RCX: 00007fdd6b98f749
RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007fdd6ba13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdd6bbe6038 R14: 00007fdd6bbe5fa0 R15: 00007ffcd3996008
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

