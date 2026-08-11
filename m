Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55486C5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 00:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7E16B0092; Mon, 10 Aug 2026 20:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167B86B0093; Mon, 10 Aug 2026 20:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A53C6B0095; Mon, 10 Aug 2026 20:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB2256B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:13:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 414481402BF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:13:32 +0000 (UTC)
X-FDA: 85087064664.12.CBE33A8
Received: from mail-oa1-f77.google.com (mail-oa1-f77.google.com [209.85.160.77])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9073CC0005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:13:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3KWl6agkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.77 as permitted sender) smtp.mailfrom=3KWl6agkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786407210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=wKqHDM6kFIbgjm3bxpK4dktxANqlyo+NQnIku9ZyIwY=;
	b=ruz9qoJIfAiRpP9fiSBhTthfA/H0cvqDfNNn7klmrKjsOA8KeapsMSOoRoqDWOdEeyQCSo
	f5vM1KkovQC2vHGYrg7kc/FQ+LCgP88KDJ7dHt2FfdhTgXwvgN29jSFxkzzlrM6Y3EH8B1
	UuLrRzR2nntApcUUkyc0xMj43tPhk/g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786407210;
	b=vUFALieeml+lPXA9dTjJ8I5fZzT2wmJaBkimHrftghYVRmVIxhes37vJWcyUbk19KAmvhw
	aTFTlJAFbtTl62U7xhB4YXOduqI9CuOw8objW+PQBdpGZYE/pQGzshxc7WifvcKpZoZIt4
	/m9nZM25nB72T269JGb5kAhG8B9V9Xw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3KWl6agkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.77 as permitted sender) smtp.mailfrom=3KWl6agkbAEAu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oa1-f77.google.com with SMTP id 586e51a60fabf-459b87acd2fso795953fac.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:13:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786407209; x=1787012009;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wKqHDM6kFIbgjm3bxpK4dktxANqlyo+NQnIku9ZyIwY=;
        b=njZshIIteQtzdtQ1nRHvQdtv/fvMJ/ImCnFEjIlo3SAbetWqZr5wF2tqMXloPBslwV
         3QcMT5zHlufcZanyf3yADEpWtieRHJujYh011GYVfMsw0f3rIeieeJJWNHAPQF5cG++T
         eWUFCUlbv3/BYohcR1ATQuYhLtT/vKqDKDsdw8jolSsm0vKg5/fUaDDr2qH545I9hkfA
         jp3oYs6GTg7Vx0W1IxD1JshSW25ZvetHyVOC5GRX7XKdqrsZVGspHcTXL0VlGybZWwJl
         d3QmM5+eZxKmWXW16VklGs2vL/Nq2IslrlCZWDgNvN2RJtj0YXXCjQ/zpzkTlcWyD68u
         JZ2A==
X-Forwarded-Encrypted: i=1; AHgh+RqcekJ5Z3j8pXlWMwRV2m2bfeP14BLJEtm8u9jCDoOXq2REMyMcnGbTVtxr7LsT8213HaGn/XKBSw==@kvack.org
X-Gm-Message-State: AOJu0YxeVfpZxj+XmB0snA4WRtYk8EGUBdotKUV9bHcMMtq2Qjty603e
	lxzphSNQ0kJ+Z53Oei2RTVSSCXPDZo9HfQo8IOgSfDSiLKRi1mNRTH0WM2qE95mn/J8xLWXRe7z
	+94Ih4u/DxZZ9uO5M2w1NxEzurfHXlRT2oBvIMb7VPWj0xIQAJAujggm50/E=
MIME-Version: 1.0
X-Received: by 2002:a4a:e908:0:b0:6a3:d77e:725a with SMTP id
 006d021491bc7-6b04213b952mr12333927eaf.20.1786407209671; Mon, 10 Aug 2026
 17:13:29 -0700 (PDT)
Date: Mon, 10 Aug 2026 17:13:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in set_mm_walk
From: syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9073CC0005
X-Stat-Signature: z9br49gpk8yn1dmg8dwocbgmdaif8kpk
X-Rspam-User: 
X-HE-Tag: 1786407210-147100
X-HE-Meta: U2FsdGVkX18OzuP/H0C3HK8GhaybE1u96tlSXgPnPBG8b+fky3+fFVR5GANOHZJ30+Oircrgx9pmCG/isyX7x3s2f7Meto2IafwQWWYtDnvHEQcZHJZWfCJJTwzQJCbDKWoV0WOXgvuSrzgW3ZyrMGFjiUlPsD0rVoAiKjJK5bRev9Oc5XkRl89CKGCSQQ5BDbw0evNPTxMHRtpm5xUMk+bz9rIv26InzyUphACFh6t4elTjcDHk6hrrXnMF3TKFSV3yoKBhhABx7DWl7jq+SE7EhOMAG9nkRAXgYS4oqwCIaE0uMT4gobfz2CguWhkwqdHlkCnJOmMLZC6gwjqwSNajW+tjWzm9C+y3Kj9e8RO1BuzfUP5PMdoGROEtCz9iedZznwgerTxx/p7iSThRh8NfWuXKogZs7hRUcn5abuAm3WzAYWiMFehYclpJ0/ySBf9sf621B4RjYwcsCR1InZZy3vw3vqUENFL2uJK7VWJQ0wQ1yGC44iI09KO8nBvFLiOziH+/pWhb+ZJe1mE+FnaFpw7vDIdWBXT87Fp1e9HZrw6RCgecDup+oyH6z/jg1VnL0nE7cL7URnsX/KiodStbjH2KsQdb766JyDMw1ycyQA1gB2uRZN+05aHVOJxsVkjnA0u9XfcJHYReAgJXDbKqw/oq8jGCcK5MHF6x+8SZE2/uw2957jN/JxsnHJ9OpWzeJxFBYSi0QInpcaVSSOuL0H1z7JNdwS1Gb3ew4jXN+qxs4eyp4fnnSOM4Z1NLUYcoJCuFZHFPSoMYKjsdLgM1h4wcEtf9q107HKjSZ4CTFbr0XjZ4t9MGUyBYAQwZqeFY3H63KTFbit2I8l2z9OGLqJNJpyUCybIBpX0RqScGIElLqgrmm2iXge3stVUZwkhJQWssNpL58PGxEbO/bWafsXPh09uLvDq/k9IlBnqG9ptoPNdHJbIyq93ynHmGrDrmCNewlVXKykHBk5X
 HIAJgClo
 cp/NyEhWn1GbrGXqeQ9nvuWC11ZmuvV+v0ScLmje8/cOM/4GrmPrU/WGwk1uAksoyKTyD6xcdufr/k+nVnIPv6px8Iwc6aEsrUyu//cddjcvXOj5J9KdaLUrWt6jwULDCSIveSe4nYu2BqyVyB9cmO+HWoevv6vZTvNyaGP/KLCFPyC3CU7svxBr+9hC8/A8YLt5xdungUX3vi82/iXDPp2vVTj4z7Q53Vyu2pfLShaAJ+KEMYx1iTVgWWfZfRv59d1Ix0UX1g9Eh2+iLBad8wysXRAwVjY4rzPfaZld5aa5hsewwFQj7puFKb2H02VBMHOCFZ48h8NpSZpC96dwHwteDKm7c2ufUQ69ZTFK0XsxE/Tg76hQwRe+CDCePRp6t3cQHzshSY1Ofmbar387KRUeM6ZLcH+/SFl4zJ86L80pTxR16N+FpNj73T+t8Hb8MgaLiKffus1eZvzD+3/w7ovDby2q1tRz48Xm5xpl9pD4dI99fI2oJ4xzQSCTktHQfniIUb69DDUslOaLL9KjnEppogTR/dwwnMXMiF/MMmh08PUG96zPTnPc/AY7tq21iD3gVL6SD3QbrqBrglO6ce13nFvaOadosxgHos6zxCYxA7+rZH3mBtCnVBUSG8j0JA03nMqEGwuKFu+nV7AKWDJ8sh0m07Mb5xmtSKOJVlTDKpclVFhsUc4Vn9AShUj4/NnhuBk+0l/pJyAFKPfB1graK0JUzGPLcz+AM/0RdyTyqm7Kh8eh34Gl7fLC8mNe51BRpqf3b//haWVxaiZpsyZjgX3ipObmIPRCARfm4DaQ3AHcvNkHPlO/r01onRbmA+IvKg9iJ0LtL28RwF7oQB+bj9ImxQIBsyjpSG5nhsYwopGG26AFh6tSlRmA1BCObeUl2LcYGpeQZZwRuB6zn4yaHYLV5tPSjzdZ7hj1lET+BgmTKn7ZQ4jAYT+KbE/6amQf26s+l++UWVWPB7tzh6xkJmpro
 6QZUwE4g
 2JJIM2L+/Fgz37iQ6PNRJeTrT4WnsukELR9siYGzNNY1fh+Qp0M4GxEWedSahc/6GpA+SCE5jhNXoNvvI0P8jgjhVRy4xjBMy3m2adCAzovbYaZur+r48hVKnbuM3+UvhqTGDWfGihmW/Y5jxoqlIaATJ2+8/6c6XmlrfXjOEGtqoXFXWENyIYM2bzjH79k1cJc99K88O3llhIRaexzVj1BQaYajj8RQxDuM2uuT5g5pUHiSyINLp7nC41sIYRfAhZ24Na3EkBP8Xq2Qsufrbfksv8qstFT7kL6aoQN6MZ9xrNKU3egTLRq1xvVkYH3X76t2vmfLhPicl62zVj1XWlTZMueEHEk0iAiecmUxtYh3wXj3T6Zm/KwrgddKu3r523kfRpDk1B7t6FgKsSO7pU08MvTvN0kwiGZzNVEFABZaj53x/+Bzaw2PaxsNU04AZHi+BNr3IsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    562bfb501c54 Merge tag 'integrity-v7.2-rc7' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a8cbb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
dashboard link: https://syzkaller.appspot.com/bug?extid=12ee2725d5fde63a9c96
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-562bfb50.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9cbf6ef0490e/vmlinux-562bfb50.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7ee52864c79a/bzImage-562bfb50.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com

------------[ cut here ]------------
current_is_kswapd()
WARNING: mm/vmscan.c:3800 at set_mm_walk+0x210/0x270 mm/vmscan.c:3800, CPU#1: kswapd0/110
Modules linked in:
CPU: 1 UID: 0 PID: 110 Comm: kswapd0 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:set_mm_walk+0x210/0x270 mm/vmscan.c:3800
Code: 13 00 00 4d 8d 7d 08 e9 f7 fe ff ff e8 79 f5 2a 00 e9 b7 fe ff ff e8 7f 6b ba ff 90 0f 0b 90 e9 d2 fe ff ff e8 71 6b ba ff 90 <0f> 0b 90 e9 74 ff ff ff 4c 89 ff e8 80 f5 2a 00 e9 4e fe ff ff 48
RSP: 0018:ffffc900027772b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888024934a80 RCX: ffffffff824ff8e8
RDX: ffff888024934a80 RSI: ffffffff824ff96f RDI: ffff888024934a80
RBP: 0000000000020000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000020000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc90002777c38 R14: 0000000000000001 R15: ffffc90002777c40
FS:  0000000000000000(0000) GS:ffff8880d5ed8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31923ffc CR3: 0000000109695000 CR4: 0000000000352ef0
DR0: 0000000000000005 DR1: 0000000000000005 DR2: 0000000020040004
DR3: 0000000000000056 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 try_to_inc_max_seq+0xf0/0x1090 mm/vmscan.c:4023
 try_to_shrink_lruvec+0x4bd/0x6b0 mm/vmscan.c:4977
 lru_gen_shrink_lruvec mm/vmscan.c:5128 [inline]
 shrink_lruvec+0x31e/0x25b0 mm/vmscan.c:5888
 mem_cgroup_shrink_node+0x227/0x6a0 mm/vmscan.c:6753
 mem_cgroup_soft_reclaim mm/memcontrol-v1.c:312 [inline]
 memcg1_soft_limit_reclaim+0x2d5/0x830 mm/memcontrol-v1.c:362
 balance_pgdat+0xa11/0x1f00 mm/vmscan.c:7177
 kswapd+0x556/0xb50 mm/vmscan.c:7462
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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

