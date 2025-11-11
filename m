Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3A44CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 15:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F60E8E0008; Tue, 11 Nov 2025 10:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD078E0002; Tue, 11 Nov 2025 10:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209E48E0008; Tue, 11 Nov 2025 10:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0158E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:03:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A62E7140364
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:03:31 +0000 (UTC)
X-FDA: 84098645022.24.C2E5662
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0EF6680003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:03:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 3QFATaQkbAH0tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3QFATaQkbAH0tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762873410; a=rsa-sha256;
	cv=none;
	b=BR2BceOUX+8th82ErlNwBlCM2WV+fRlL5MfjX4Q5DtibDBgHXD+aMQPHk6X6zsKuT1k1Do
	LevzxdRww+xFu5ctE8xE/yzf61SjE4wTOldIG/TtsBIF3929YPwkt6gOWbtVorqCE3mixg
	xdewTPf32XF0OZlY6wVDkSQAg859QbM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 3QFATaQkbAH0tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3QFATaQkbAH0tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762873410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=VWIKko+/f7wc1ywhv8E+Wq3D2G+PPdWhYhHhlr/Wf/0=;
	b=vJTRf809MYXJ0QXB24zxeSMd0XROqRTtuaNrh/DFZXJYSfVJJlgpxijFRckEJ8pqpIhH2b
	JRaiur7x7pwVJwRcynuiKbKG6x+9Su7yg/L1UQA+bzR6R1hqyVxWtYGg2UVMBfaxOliwqk
	9ll4BNtPbPJ+n0ZBXoUZyJKmJ9Ui9sg=
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-43329b607e0so61646785ab.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:03:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762873409; x=1763478209;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VWIKko+/f7wc1ywhv8E+Wq3D2G+PPdWhYhHhlr/Wf/0=;
        b=Irb4bLThxMQCsfBbNIYSGHS5eLRyFj7D9iXkDzLgWxDNW6mjVBud27U5Gbbe5FWBG3
         /4xrlGFAuteAgvOjLFc0TGDdJ6qpClXCPGRZ9RxQqjjyyhcg803BlYq9Nf1ACjLaeKwV
         9rDB4yo6fgXC6oCF7KUzIcEN5Kb8jZeB1HS2Cw+uK9aLz7HGH57ddQeqY2oJNWciYoeE
         gp45rEsYFfMM2UWnfUFhNRdXTXF1TYhpbf3ZazdHwfWm50C0KRKQzKeCJAb7maz/d3UU
         izobXE19YwuLThWv12cYukQ4w15iPLkTjGU7PU/7Lvm7Mi0TizxBzhBisFL/g0KdDgVe
         WBfA==
X-Forwarded-Encrypted: i=1; AJvYcCUtuYuKopDM/2UkLdIGPyODO5ZL7BNIR6CSptj9WqAjiuRVElNyV6BMFUSqBKDbPSnU4/VMw3GZEw==@kvack.org
X-Gm-Message-State: AOJu0Yxa5ckmgZ6EGPY3e9XsuKO4lKHOiviZKBEpifCZg2//pPKVoWWs
	MxUOERf9PM994H0G5sACdsIO+NuysHkb1VOBABHCX1FxhG32uRehYGNNVdnixOi3P6qdR+2Jbf7
	dhIU1KCP7uhq/c9uOSiVpFJ/zWAZMhBOQ3d5kOTPD484/WI6BzCgPLddY0DM=
X-Google-Smtp-Source: AGHT+IENJ936kW7WzuEjQC+SSyFflsRYlWjNqxIz+22D2/kU0o9wO1DV5AoyZKptNtCYWA+ibYQGku8g4phivNClA661eTyDbu0q
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:318b:b0:433:23f0:1ebf with SMTP id
 e9e14a558f8ab-43367dd8574mr190866465ab.9.1762873408970; Tue, 11 Nov 2025
 07:03:28 -0800 (PST)
Date: Tue, 11 Nov 2025 07:03:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69135040.a70a0220.22f260.013d.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in swap_cache_get_folio
From: syzbot <syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, bhe@redhat.com, 
	chrisl@kernel.org, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0EF6680003
X-Rspamd-Server: rspam07
X-Stat-Signature: tt7ni8zrzg9w9b3eny8sxqe4fsj6sjwp
X-Rspam-User: 
X-HE-Tag: 1762873409-618122
X-HE-Meta: U2FsdGVkX188ZzFH5vtrGrtkt9/OjqAO1L0du26dCNAYFGTRKTyVsjv36hOFiOHZUb++MuWNnVUxkJgAiKzw/+VsozZgDTj54w/LJZa/RS9piEpQqLP3GSpEwoaHQ/gXt2KedOC5UiQ2ZzW4wBlVLHHW/vkhM3a56Bqx+r5MgJg2WGa75Tls2zaJeBevJCTvlFZSfjJq3hUDaaYzseFBiXuw9LvmZOSREh2SXmRYbXd1XMX7qmclaJBlAyAXnDF5Is17S51HQIt5XT3z42KW1D2uOn/zeUZ/WIXXLQlmz+c3qZzBbU6EFG114JHppUOyBdIORLoPEOhzA2dn/qiLFKMWkxwqb/DWob/VDtYpLtPtikIQpVo8cvi6tK4q7uGlCqpZnpkqa0tWrKfImTUMT7gfLR2M5SylzJuPuz5pAykDEcmIwNQOr6xDbbt+tT4UWclv7GP5egBRVR/ydtHjAfnEm2eoiiZqybV6NQKVG+jHXLQtk5V+r77foJV3vF1T7o/W36hHSp6DGPMy+Ao/ovE8fE7rwhmkcgK2SCt1zQiGFvgFa/fEbKOhRpD5sgf+cSEMg3sr3n/H96vqdKLjSRMmxn9rui+5VexiYdwSHK7eawbMrcYYVlvqccTG9dMLEYyMdKqQk1Ou8XgvZE9M4+fxsLmPc9Zb6/iSCO3ylOy0tQjI82GZ6FQ/n4dz+dh8/ibFk97Iqnpgs8kBksI7pDisap4jX0wTfnfa9DevogljH6WD+F2NKqEHeSF3Nxglty0EeJb3ixp4lSkX5q2n2HGF394T1Hqryh1fQ+yrqgdvJAjC6Ro8Qfzy5M02zgWXKSmKgFWIIop5A7E/00Jv/Y4mVe+6qY+xTcLzV6qgkmssVjGH5bQBpXobTJflIphkPo4tPrqjqEnmrV3uUNV/lJmVOyj29SlLjT/mgocxd317q+tTBJjYYFTAkffjFc3QrS0XQO9GJLfJbMqC75x
 2te5ODZy
 dF0w2iual5AScZx2Mrkb8DjLuMc42hZHIROoAfG1+q5In6ot1A5jR0ygog0C7GJ/hKNcJBrez4K8I9Tj+4RoR6ljdA2dcTITJJ8oHSmOr6rTuedDKPxThzZtrccXWEo7M8tfmZnKcctMVFF/uUl6invMZ6dVy7QsDewQ3nwGv8vURcOdvx0dwOeY23PmhhGDUXNJ3x/wKdfYY3vH80A38CJurrficQP1RHuhOgdtKgkOqXplPvJPjj2VNAU2eL/YxCCKZy5L/JNP4mIMxyVFm85ejubp27neAKQUGts1iDbJAwON1GlGzdDUcjDdEWF1Np9sNfRvBLGKBBDBd5EqwEwF70jjR0q3DdXuhuD1F1qmlJ0xTipSUgfl3fvy8P5yBUx031ek0GfVtYnmisjxCrs76iANzpBPs12o9rWu3fXWDCuhsta+tO+jLt4A8+7fYYJvdM1oa02j7ptRy6nvZ5UbUlBTRaPQAQxFNrqeIdPTAw8vDI2Ie3Ctd4b9SumrFjjYtZrZf0jZiq3rLgybctlseQWilLk7UfOKK5h38imojLDcO3FNNO3YF6wirvLfxSmSNJrFei11y9/wpTJKJcoHzLlURxmh67euVpYl59niF4iBvDVYJVrPEhuqEtB2iBH3U4GWxyrd5+DeXuvzHhbyvsb1n7iLRrdj/gblWBYEOxr4FQQjSZmm5kQa8i7DZA+nmKHNP0tEUFh0lLOO129IGAuPPkYhdFWXDJuyH7C7gvQQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    ab40c92c74c6 Add linux-next specific files for 20251110
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17f69a58580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=84a798f69f994783
dashboard link: https://syzkaller.appspot.com/bug?extid=d7bc9ec4a100437aa7a2
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/34ed0f0c2fd0/disk-ab40c92c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a781fa106d0c/vmlinux-ab40c92c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/367c75242dc9/bzImage-ab40c92c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/swap.h:87 at __swap_offset_to_cluster mm/swap.h:87 [inline], CPU#0: swapoff/15184
WARNING: mm/swap.h:87 at __swap_entry_to_cluster mm/swap.h:93 [inline], CPU#0: swapoff/15184
WARNING: mm/swap.h:87 at swap_cache_get_folio+0x365/0x530 mm/swap_state.c:94, CPU#0: swapoff/15184
Modules linked in:
CPU: 0 UID: 0 PID: 15184 Comm: swapoff Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:__swap_offset_to_cluster mm/swap.h:87 [inline]
RIP: 0010:__swap_entry_to_cluster mm/swap.h:93 [inline]
RIP: 0010:swap_cache_get_folio+0x365/0x530 mm/swap_state.c:94
Code: ff 31 ed e9 2a ff ff ff e8 a8 d5 a2 ff 90 0f 0b 90 e9 3d fd ff ff e8 9a d5 a2 ff 90 0f 0b 90 e9 44 fd ff ff e8 8c d5 a2 ff 90 <0f> 0b 90 e9 6b fd ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 3e
RSP: 0018:ffffc90003237a40 EFLAGS: 00010293
RAX: ffffffff821e8784 RBX: 00000000000001ff RCX: ffff88802e633d00
RDX: 0000000000000000 RSI: 0000000000007a12 RDI: 0003ffffffffffff
RBP: ffffffff99cad4e0 R08: 0000000000000000 R09: ffffffff82139c79
R10: dffffc0000000000 R11: fffff9400022a327 R12: ffff8880317bf000
R13: dffffc0000000000 R14: 0000000000007a12 R15: 0003ffffffffffff
FS:  00007f3bed90fc80(0000) GS:ffff888125a83000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005640123d7005 CR3: 0000000034d9a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 unuse_pte_range mm/swapfile.c:2282 [inline]
 unuse_pmd_range mm/swapfile.c:2332 [inline]
 unuse_pud_range mm/swapfile.c:2352 [inline]
 unuse_p4d_range mm/swapfile.c:2372 [inline]
 unuse_vma mm/swapfile.c:2393 [inline]
 unuse_mm mm/swapfile.c:2411 [inline]
 try_to_unuse+0xd6f/0x2ce0 mm/swapfile.c:2488
 __do_sys_swapoff mm/swapfile.c:2884 [inline]
 __se_sys_swapoff+0x431/0xa10 mm/swapfile.c:2824
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3bedad6ed7
Code: 00 66 90 48 83 fe 01 48 8b 15 1d 1f 0d 00 19 c0 83 e0 f0 83 c0 26 64 89 02 b8 ff ff ff ff c3 0f 1f 40 00 b8 a8 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f1 1e 0d 00 f7 d8 64 89 01 48
RSP: 002b:00007ffd9a359118 EFLAGS: 00000246 ORIG_RAX: 00000000000000a8
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3bedad6ed7
RDX: 0000564029c35a70 RSI: 00007f3bedc5c4e8 RDI: 0000564029c35a20
RBP: 0000564029c35a20 R08: 0000000000000100 R09: 00007f3bedba9ac0
R10: 0000000000000004 R11: 0000000000000246 R12: 00007ffd9a359338
R13: 0000564029c352a0 R14: 00007f3bedcb9000 R15: 00005640123d8d98
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

