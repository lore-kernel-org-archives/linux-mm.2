Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8ED5D232EF
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 08:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D4D6B0088; Fri,  9 Jan 2026 03:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E676B008C; Fri,  9 Jan 2026 03:57:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0673F6B0092; Fri,  9 Jan 2026 03:57:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA8866B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:57:22 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB66D1B799
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:57:22 +0000 (UTC)
X-FDA: 84311821524.07.5FC976C
Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	by imf06.hostedemail.com (Postfix) with ESMTP id 22004180003
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:57:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 38MJgaQkbAEs5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=38MJgaQkbAEs5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767949041; a=rsa-sha256;
	cv=none;
	b=tlwhLnKNcmmjjrlpD7sMQxmUS91CMKaqExKPcQXd8i1y3P/hkTH/HpBk7DAPtTFxpqOZxu
	83uPRlxiNYkOhu9HQlN5gLDKH9eAjfofLbVlNLvSvt+zJlSRJ3HdNWxiolHIhdyA3ZJWFw
	GaJqjLNKo0v7Im/kP2bRSqABPL4po/Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 38MJgaQkbAEs5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=38MJgaQkbAEs5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767949041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=7W86WjpQ/KJudncm4mQNaQd0Gv5QEx6xj10h2rWhamY=;
	b=2wr/C5+PwjqttRZk3+vSV5GMyeXrpCPwh+rIVeo/1xvnpwQ8C8a91ZnzGB3di+vw9SRfvr
	OUflY3S0INLMiHpwy9vd1lTem5VixNGW9dSLFRaObLmnmwmEZa2moYg1CZpFT6r9VAPAmB
	HS8AYBfByGCqYIlkbR2zKd+8WCJ/Tt0=
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-450178eaf86so5536775b6e.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 00:57:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767949040; x=1768553840;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7W86WjpQ/KJudncm4mQNaQd0Gv5QEx6xj10h2rWhamY=;
        b=ZohxYccVkHQNnswOjbTkghqu9y3bv7RhscrR3g4aNsGveRX/VgRNLZRXJb8AaMGxAE
         ZkZXKOzxYqQu0fApvSls/elqfxdvYc9mj8GBEmu+JQHc2y/yT9XhjYq3TPTM2k9rmDqY
         uSH3qcBeNU7VVEMzLbFYZA3EgAYzPsnUtWKx/LEJzcNP04pqbPLft6G04mkf5rr/vX9L
         nhMHqZrADnSTHbMUTUQMypTyJ230Upnqcy9v7MC8+6ErzZhEGQovr4GzSmn1qsmcPytq
         NLunxr6XIdyPeM1I5D7ApH/LLBFvzYNBT6vgHDafSIDpV1XfOFctdUWaJ9Oj5+Y6zByy
         PboA==
X-Forwarded-Encrypted: i=1; AJvYcCWf5uX0atlQn4ZV2BkCKIqEFUy6RpkZSjNTKTnuil0ybdEVFnH+7NFKKIYWqb9mpwZj4Akf8NpC+w==@kvack.org
X-Gm-Message-State: AOJu0Yz81WVg5bUJxHbsF7oxfAh9RvIx/EbvJZK4ZJ4Bc2+Ni3xKTCZ/
	N75jdUp0es5adh53lmHTaL+jyUdsPb7+74YwfdI3TtI/AOG/svLm0xajD4j8aV1K+rwj37eicMA
	fWyURRs4v3FKSDlE62fExiRqf35AfjLG1I3e/K9A6n/GueCj2WvJpSlUUq8E=
X-Google-Smtp-Source: AGHT+IH94OxYqGbW8rUXBldeb7R123k2f0gTWOONAkk7FH6lMOxKPV7NFmPRoRd/t3wxr3ON97DuEnjmjXHuAuTjwsD9ch3UBkn9
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1599:b0:45a:5584:9bf6 with SMTP id
 5614622812f47-45a6be3f8b8mr4481115b6e.39.1767949040140; Fri, 09 Jan 2026
 00:57:20 -0800 (PST)
Date: Fri, 09 Jan 2026 00:57:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6960c2f0.050a0220.1c677c.03be.GAE@google.com>
Subject: [syzbot] [mm?] [cgroups?] kernel BUG in swap_cgroup_record (2)
From: syzbot <syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xh3pxsyek1ptrhd1ij5wdy4uegnbypyd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 22004180003
X-Rspam-User: 
X-HE-Tag: 1767949040-772582
X-HE-Meta: U2FsdGVkX18PaOy176bEbuI5QLy2pggjXxVjS3IqUVR6UXtgtmsXfRdp68tzL2JBZYdTWEU1SuerZpquqxXGxE55htffaKWcN69y/JIp5MkNatFn0FzsYmhdckoQlIMJ2MfUNnV//Tf3ICw9Eq5fPel/EqN0BI7GO38FD9dKvS/KVTUv0qXxVp5GmGS0rSqnh8FoUUwlYBUyB8GiErip6mlGlP8Rh9D0OzHdDWCzB+GXC3VmTQ4Jf5gFhjbcKCe24cZGGDI1OKJGlyXRdtG2GrYs954mvNCac/L/S6hzYOj6N/1YHqsLRlBAi/w7Lrj7PUuxieCkIj/248JsIt6yFhyT7KFEY/F3c99JBQc48aoLT7LKDNT4oWCGbk03bIC+esDF/WzLusNHHKZjJYULaiySrSQq1rdVrLPj6qsW9/zjUTHBbnbHRSFqqVOiUcIoUdkwVFpjq49UjUQfJ/KboIWw9IYL0E3OXDT6P3DFChzB0+AQP7P8YJiIURppk0XPf95qGBU9qUUXIlh4gHR/DKyG+YrYRlvo2RxgrF4ltyuvCslB5ChUN+hdXoxEnSvzTR4clTylSsjf7zxQNyzgFEpQnkd7O0RcponLkbSxyCAH3QiiC/XuIJgV530pQGo1Vcc4+5gw+VmJs/Rz4l7ys+ttjod94bPisHtw1Msb5tw0taKmtAJyLdu6LwxXtHUXYbJe8FvYYSGm+dgfceJB9ZYo+EMcsXY+T4gqf+Z1RP1d0uCbJLdVhBIqkkNj9NCRFalWfLIpqqoTJHttvTPDMbNxQGY5slgvp1zlG/ozkMoCTqN4hv4c3Uv5Jjv47bsuZGGFCGvxnoR//AVielNHK/8Ayg0TncgQ3dgieDyjo0c6EmgJi+BoZEwouoQbZZKUdOhzcDUSgvVbBfBtVMZJnJ4YVg/Y34tllAfBDsxxECOgPuuv9/Tb1oVLuUBDFcC03p0ZZ3u+uPuoUvPQcFH
 wZBfnrpc
 Gdlr/CstLFk3oL1WWzt7WYbRvBqaBLq+FHXk0NEEQhwQ85bqX4l/7kC1uatDX0asLjGnZ9EssXPFlag+73Zje5OHlhXOdfP0YCcejDLg8zjNTKA2VSp2LmkPl5K82LgHcS+/QQ2Uu3nDM/FxAr6EAA7cWznSL4U7k+eIDN8M21wxRwnCz7ZAs2ZGvaZhHdXOcyGjJUyzwGgnVxcuJQjB6gMqt0jAJ9no+BDJcVpU8LwkfVsbz/KMsmcgDjANcXuHN0RwxLPqcNPAzYaA6rXO5GAu3+h1UAWM4KR7b1sHqefe2MaMEZLesil0eu40URE4lcV54zKJNhvI15XonDBl7wnhiNTyxPrODAbEpdEIMyL0bcdFRGAMLCNla/akNOwREj9K77XAScLWUJLkSBGSmUlx3IuCkRLCG+oqmI8zyZ1mThONmiPP1uItcUbCwp0bawrjnVNpyq82100Xw3bXd2KO55t4vfnDAIYt4HH4bCIL4mrE2QnSYS7roRQpn0qYBDu4P73fk1MEtBADUqyLYEtfZ3lkvAgv1MF4m+OlyGzu1VHQfrIL4pp0PYmKo4FuiQnUJ+aqOsTK0/kiJssTw7XF3J17i0nLxdqrfGkoauYo0eiQb8kYokqwnSMWel4l/ZMcBmuEh7+t1+uGimtnwtaNsBUlONv/mW7r50YrYwh5eS0+rho9enHj7gj8MRPjPY+8iRzAXcDsAHosPUsUBMosPVNx+goUOi+DFrc8Jv8KIn3MgUyyCB80lEpr88Nc0bF8TDVC2W3TY5Qza2MQOSMdTs0Ep08gRCFjIIG/tnBLxXCRM0rfOOudwz1YzsXpuOr4HftPuRJZkwMoUuMniLqGMMxDsIVGD16aVoP7gvumfL0C2MoKZ3+J11cp++BJDa8BtpPd2/gJgZ5rQyfXi732iBss7o2MEMkkY5VvoHxp1fMenTlrDwq9fxLXdBKN7gL+il4iJ+4n1FwPZMudsPFslsJbK
 zHSoDnSs
 WkU2SeGaDLKE3XvMYxHqvmGJ94OKwpzFEiCX53JY36k1EvnDWzzOrmPRJ7HXl4uJpUfr1qNOwTjKtX9C+NWqHwijp59IHLvVI79PJu2zTfHDr8P9jQRyuHjyrJRtZtvUBuqByahLel2t+xu0Ec/rLp5eUXA0F9h7X3i59xnE+nogZhc6F30zlLQsUDybURcLbZVenLHwhqz/3EQvpPPJ6DAws6c6FalmHQ1Cmu9BqSklHCNpdu9uMPBIxoqWyf9/UUYW3vs5J0uO6va54U+fFVFL/W/m1DmIxGs1Gp0JQsGhQ5KfeXiHsIazTp1L5WOA9t0uJnWHEVrCiCTmkVcooOYl1RyTXhmlwvok7QBxatuSX5DiDFBBJ5Dz9fqHxq26SqIhzCa9TwgfMgdAZs6Sp9OUtkJpBbtymFn2mR5AEVQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    f8f97927abf7 Add linux-next specific files for 20260105
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=131ff69a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0672dd8d69c3235
dashboard link: https://syzkaller.appspot.com/bug?extid=d97580a8cceb9b03c13e
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17065efc580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176c9e9a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1837bbc8e23e/disk-f8f97927.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/07390717f7e4/vmlinux-f8f97927.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f4a72ec80dc/bzImage-f8f97927.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at mm/swap_cgroup.c:78!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6176 Comm: syz.0.30 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:swap_cgroup_record+0x19c/0x1c0 mm/swap_cgroup.c:78
Code: 02 e9 6d ff ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 35 ff ff ff 4c 89 f7 e8 cf 84 f6 ff e9 28 ff ff ff e8 e5 c1 8f ff 90 <0f> 0b e8 dd c1 8f ff 4c 89 f7 48 c7 c6 80 f6 98 8b e8 de d4 f6 fe
RSP: 0018:ffffc90003176720 EFLAGS: 00010093
RAX: ffffffff8231359b RBX: 0000000000001b88 RCX: ffff8880351f9e40
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: 0000000000000002 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff5200062ecd4 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffc900041b1000 R15: 0000000000000002
FS:  00007feeba18f6c0(0000) GS:ffff8881259c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feeba18ef98 CR3: 0000000077742000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 memcg1_swapout+0x2fa/0x830 mm/memcontrol-v1.c:623
 __remove_mapping+0xac5/0xe30 mm/vmscan.c:773
 shrink_folio_list+0x2786/0x4f40 mm/vmscan.c:1528
 reclaim_folio_list+0xeb/0x4e0 mm/vmscan.c:2208
 reclaim_pages+0x454/0x520 mm/vmscan.c:2245
 madvise_cold_or_pageout_pte_range+0x19a0/0x1ce0 mm/madvise.c:563
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x1037/0x1d30 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma_unsafe+0x34c/0x400 mm/pagewalk.c:714
 madvise_pageout_page_range mm/madvise.c:622 [inline]
 madvise_pageout mm/madvise.c:647 [inline]
 madvise_vma_behavior+0x3132/0x4170 mm/madvise.c:1366
 madvise_walk_vmas+0x575/0xaf0 mm/madvise.c:1721
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1937
 do_madvise+0x1bc/0x270 mm/madvise.c:2030
 __do_sys_madvise mm/madvise.c:2039 [inline]
 __se_sys_madvise mm/madvise.c:2037 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:2037
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feeb938f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007feeba18f038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007feeb95e6090 RCX: 00007feeb938f749
RDX: 0000000000000015 RSI: 0000000000800000 RDI: 0000200000000000
RBP: 00007feeb9413f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007feeb95e6128 R14: 00007feeb95e6090 R15: 00007ffd48399048
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:swap_cgroup_record+0x19c/0x1c0 mm/swap_cgroup.c:78
Code: 02 e9 6d ff ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 35 ff ff ff 4c 89 f7 e8 cf 84 f6 ff e9 28 ff ff ff e8 e5 c1 8f ff 90 <0f> 0b e8 dd c1 8f ff 4c 89 f7 48 c7 c6 80 f6 98 8b e8 de d4 f6 fe
RSP: 0018:ffffc90003176720 EFLAGS: 00010093
RAX: ffffffff8231359b RBX: 0000000000001b88 RCX: ffff8880351f9e40
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: 0000000000000002 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff5200062ecd4 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffc900041b1000 R15: 0000000000000002
FS:  00007feeba18f6c0(0000) GS:ffff8881259c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feeba18ef98 CR3: 0000000077742000 CR4: 00000000003526f0


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

