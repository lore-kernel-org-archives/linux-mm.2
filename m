Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FA5CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 22:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAE18E0007; Tue, 23 Sep 2025 18:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184C08E0001; Tue, 23 Sep 2025 18:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BE18E0007; Tue, 23 Sep 2025 18:53:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1CBF8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:53:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9781E140641
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:53:56 +0000 (UTC)
X-FDA: 83922019272.19.98F8CAE
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id D5A2F1A0007
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:53:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3ASXTaAkbAOQYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3ASXTaAkbAOQYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758668034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=/wNTZlN6qLp4sqdyo6QTG1IaiR5Ni0PqLyc9Tnrd6w0=;
	b=bvIw+JU3/RNiptA6prUX1FdjgSMJ9bPpHZKWQFnV6/uKELXY0UzZ6TZzQ95ffZSPjCJCA+
	3yFaKhNWWymLMERUoAi6pJoBl/WGa0+K6ZEHunjRaqrDUqyMsMBL0aPTRE/udoSQNiDrpO
	ng9hAF1lwdgKSQHodgIZxncljhiZkpA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3ASXTaAkbAOQYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3ASXTaAkbAOQYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758668034; a=rsa-sha256;
	cv=none;
	b=lkE2bObqDByY/gExy3dWTRHgwz3K9F2gJHlitoU2j2Agfw3ysbDp6RWJ+XiuXV87rYynO3
	zfkeLQ2pk4aZrgAXLTCk47s4PU9Vv4hnUTyNCy5XYHYrFGCv749ypTTe27oCuPtsaLHcrZ
	7ZCXjQBFq+qJ4NavaYXJn+hE+jTqvV0=
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42570afa5d2so101386805ab.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758668034; x=1759272834;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/wNTZlN6qLp4sqdyo6QTG1IaiR5Ni0PqLyc9Tnrd6w0=;
        b=H+Xa+LUXZg9nXQnY0IUjzEyMq58Q8/gg5vgQAmXjd5NSpOCW5rwLlm4dtzZfc9QliM
         bxDJClodO7Dk6LQRlsoE5/fwY3evyT+DMH8iRiArtkH2D0CxYNwQlVqOpyF57Ul5h9WB
         Y2A+66j1bSPpLvdqdvpGSjmqOdCGz25u+5ghbNaQwYQpD+2nZgPV2Ycf74rI6Z/X+fbG
         IWrXt2v6kNACvEobXpLo663tfbVccXyV0WgInS9LKyBaTULQIxOvKuJsPrDuozgb/GtH
         oUZg21GjpPDcq5mSC86etV7yygwYCcrAJcGlR6XZY/tYRRlObwH/ZD16ZTlHYYAe5BAq
         eqCg==
X-Forwarded-Encrypted: i=1; AJvYcCXA9kOYVbVKlMIZ89wEWfCBIuXQenRUJMeyOZ+oKbYbsXw0ltpkeYOU0dc+6cjwPF0wHC/ipiopgQ==@kvack.org
X-Gm-Message-State: AOJu0YxqtyyEz8YzFwmIAQwucivYxjIWEmkGYkvScHUEXUkFfZSuvJrP
	8xawP8rGCpPgz26kRJt72VTHhI+4svNBwvU4T0AbJoCbR1UmNV703MryqnBpiWkh8O1gxAC2QkF
	RPKnb0PLBsMvp3N08wE7VVavdp8YDuIChKURbjuWk3gTthU77d2rWWXFfWz4=
X-Google-Smtp-Source: AGHT+IGM2aCp+eZxlq2lYE2sv5q3yAtCF346ZsErV/J6qoFUIgD7WjAxOqZ9UCXOlxf3mNdh2dP0thvuweiArcx6FLx35qJXyTJ2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2b:b0:425:7ae2:b8c1 with SMTP id
 e9e14a558f8ab-42581e10bfamr72471655ab.13.1758668033945; Tue, 23 Sep 2025
 15:53:53 -0700 (PDT)
Date: Tue, 23 Sep 2025 15:53:53 -0700
In-Reply-To: <20250923133104.926672-1-yintirui@huawei.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d32501.a70a0220.4f78.0011.GAE@google.com>
Subject: [syzbot ci] Re: mm: add huge pfnmap support for remap_pfn_range()
From: syzbot ci <syzbot+ciae73d4d89faf898f@syzkaller.appspotmail.com>
To: abrestic@rivosinc.com, akpm@linux-foundation.org, alex@ghiti.fr, 
	anshuman.khandual@arm.com, aou@eecs.berkeley.edu, apopple@nvidia.com, 
	ardb@kernel.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	catalin.marinas@arm.com, chenjun102@huawei.com, david@redhat.com, 
	dev.jain@arm.com, liam.howlett@oracle.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	lorenzo.stoakes@oracle.com, luxu.kernel@bytedance.com, mhocko@suse.com, 
	npache@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com, 
	rppt@kernel.org, ryan.roberts@arm.com, samuel.holland@sifive.com, 
	surenb@google.com, vbabka@suse.cz, wangkefeng.wang@huawei.com, 
	will@kernel.org, willy@infradead.org, yangyicong@hisilicon.com, 
	yintirui@huawei.com, yongxuan.wang@sifive.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D5A2F1A0007
X-Stat-Signature: rw1ikn7e1ak1mnnw5gibxzk1dfeqmnz1
X-HE-Tag: 1758668034-953788
X-HE-Meta: U2FsdGVkX18rOzNVShmXTL75SnGl32Yj73xt3jazSLXmezao0s83TIJ1ME76Y3oaCyAFi18o6n7PGUVaPA5GLITP31beXdsSaV9T0eQsq3DspLh92CvXYHglm/XOSC1kNGj7vi8nJ4cQ3Mw3Y8mcGnb6LUkD5KXTLSiNq/5ZOXPKlEnwULIn1B1IbRApDkVHNgRwWsr96n/K3nACICicP9Pun67qhS9ibPhT4pDi24kU7YTGu02chsQJ0htxJ6LklHr4g2y/MoWAlCYaNjByQa+R/8o08mr0UdJYZ6dSJ+A1DVXSOUazhy4Sc4T0Jt73vw/mLtQMEg3fL6+2svnHnFCc1QwkErLYLkts7httv0BgdwcB/rzs/TvP4ciMZVxAM4+xd3aprOKdhqxUGQ2iyQuTDkmcTrm8TrhDAApnpgXINV5dVhASlmUDaR/5Nd0l/rk8cnwLSy1qQDbeY6CezzLcuMdAMl7gBFot+j0+W88gKNj7qoU1k4h0yttrFelL3nWE6ZyWjWCRnKpPrXeTQXEvjpl1grb7VgvOmQjYIELg4SwSOx4cOW20XDctOa3Expu96VjBUWwWZyevB+RrGI1NX2EmJJfCm8iXb9DC+zANse25oTJs+u3hQZGxbpUQIhZ1n2mdKDDoIJdm5bLqUEjV9K73jpBqW+j4YenUq5A2YIhP8BhzDLMb1WJXRCoCN4YMHYvU9SgVoDobM4k6aBUZ0SJ3/NGtt07WXkBrUnhTMdg21S47eoMYdLKf1ZaGX3VWylWMBQSAMgUwrWE6Cxjie31LCkA/gdXAmdYW44oIdB5Dca7phcLT+WtglfvQwMQcmHqcUZS+2Fq/P23YCtlLsqU7UoezjiPRDDH00pTcmLVHMrOEMarRvuVJwAfyij8wsZw958KlWkY2vI0wauW1iIFo5IfLsx7ybcFZ8muhGYqs7VzDuQxr81Ate4KRwiejtGIIlCJDpJmw0I6
 g5P2JelI
 Fe3MeJb47M+9uo29i0uGPvT06NXNFglDrdNJcq0AQeBO42W990Bj8BwR1k77okUeqwxRo4nP/IQpXU880uFAHJET6X/b6TY2nMyKC/LONo1I/x1DJQSpaS/3GEvkUAtFH0rVaChhi/tam0E73ho7DjZAz7+bIOgj4J/YDsJFv0ZbNphUxsPXzBxlRR7I1hjNOQMGWPXsCxQ3GpAUAV3yltAzkScYpPF6KmWHM6tswWNvxPk98/jpDBJ76l2zOiYhGwFqQ7XgXzaUjp3ekS0pVR96eDoMKCvMFOD/l021Iew/c5rzbg6nS/XVdK2C93LqwuA43xWRbyQTSiEP3X120foi1Locg4Sex4ER9LscWbVzT+836gjcuh9Edx1yYWoAfNl3hP2IEGaIhNsuBivvOTvcw/eJ7ox6R6mHneaoLAQSdpTTiEy+xh6SdkuFDCsIt+BhNWY3gggVhj/S46pBoOVDSnUP4vH0joMMUi6WPcv87MuuFx91i6vkL3IZ7HEH0I7ljvoJ9V88skemsQpDiN05RJ3+/SOmzYad4z26YjeXaOIC179Ynz0I2yt95j/2BH6Ud0i1yrcCzc2EScLl8ShFaI99o4tSAsrFmQzuPsySE81GvF2nFdkuvyK2nEAf7jF6P33zXD6YcDPQp8bzFv0viGvvnDQ5T0hF9c53kszpFjHyaTdmRaUC4DuCdldFooKc9ROyOfPOJzqN3LFO0471yIUnfKABo48MryfhyG+w4LYHP5qCjIUHpVfrOZ+7qteI7FeZTPsZCOKUxjwoP0sIk7J8gRKjdoLVwE+8AEo08TMcVDa5Ycs1kpv4geE5pKY6+z5l2WHguUrITE5pBq9n+n0A8Ks7xz3CQ7y6fGhpML6JehRRPcIfB1xY8Fr7ISv+/408ajRcLyaQGUFIeZjFMEB77x0EMvkEbUK0gob0tlPF/qKeXSoSuFhVQQbwSEb4j7klv7kMby6WNe9PuvorRWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm: add huge pfnmap support for remap_pfn_range()
https://lore.kernel.org/all/20250923133104.926672-1-yintirui@huawei.com
* [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for arm64 and riscv
* [PATCH RFC 2/2] mm: add PMD-level huge page support for remap_pfn_range()

and found the following issues:
* BUG: non-zero pgtables_bytes on freeing mm: NUM
* stack segment fault in pgtable_trans_huge_withdraw

Full report is available here:
https://ci.syzbot.org/series/633cbff7-ef54-4f3a-9133-71cc271396ee

***

BUG: non-zero pgtables_bytes on freeing mm: NUM

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/72b4b6cf-5400-40d6-94b6-1cfc0e85050d/config
C repro:   https://ci.syzbot.org/findings/3450ef75-3540-4c00-8b33-5625d4aa40ef/c_repro
syz repro: https://ci.syzbot.org/findings/3450ef75-3540-4c00-8b33-5625d4aa40ef/syz_repro

BUG: non-zero pgtables_bytes on freeing mm: 4096


***

stack segment fault in pgtable_trans_huge_withdraw

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/72b4b6cf-5400-40d6-94b6-1cfc0e85050d/config
C repro:   https://ci.syzbot.org/findings/dcfb72b5-c263-48da-830a-7f51aaa927db/c_repro
syz repro: https://ci.syzbot.org/findings/dcfb72b5-c263-48da-830a-7f51aaa927db/syz_repro

Oops: stack segment: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6000 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:188
Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 5d 38 13 00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00 00 74 08 4c 89 ff e8 3b 38 13 00 49 8b 07 48 8d 48
RSP: 0018:ffffc90002d5f300 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea0000fb3dd0 RCX: ffff888107769cc0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff888022b90843 R09: 1ffff11004572108
R10: dffffc0000000000 R11: ffffed1004572109 R12: ffff88803ecf7000
R13: dffffc0000000000 R14: ffff88803ecf7000 R15: 0000000000000008
FS:  0000555576e7a500(0000) GS:ffff8880b8612000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000107d74000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 zap_deposited_table mm/huge_memory.c:2177 [inline]
 zap_huge_pmd+0xa25/0xf50 mm/huge_memory.c:2205
 zap_pmd_range mm/memory.c:1798 [inline]
 zap_pud_range mm/memory.c:1847 [inline]
 zap_p4d_range mm/memory.c:1868 [inline]
 unmap_page_range+0x9fe/0x4370 mm/memory.c:1889
 unmap_single_vma mm/memory.c:1932 [inline]
 unmap_vmas+0x399/0x580 mm/memory.c:1976
 exit_mmap+0x248/0xb50 mm/mmap.c:1280
 __mmput+0x118/0x430 kernel/fork.c:1129
 copy_process+0x2910/0x3c00 kernel/fork.c:2454
 kernel_clone+0x21e/0x840 kernel/fork.c:2605
 __do_sys_clone kernel/fork.c:2748 [inline]
 __se_sys_clone kernel/fork.c:2732 [inline]
 __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2732
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f96b638ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc07e618c8 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f96b65d5fa0 RCX: 00007f96b638ec29
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000002001000
RBP: 00007f96b6411e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 00007f96b65d5fa0 R14: 00007f96b65d5fa0 R15: 0000000000000006
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:188
Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 5d 38 13 00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00 00 74 08 4c 89 ff e8 3b 38 13 00 49 8b 07 48 8d 48
RSP: 0018:ffffc90002d5f300 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea0000fb3dd0 RCX: ffff888107769cc0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff888022b90843 R09: 1ffff11004572108
R10: dffffc0000000000 R11: ffffed1004572109 R12: ffff88803ecf7000
R13: dffffc0000000000 R14: ffff88803ecf7000 R15: 0000000000000008
FS:  0000555576e7a500(0000) GS:ffff8880b8612000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000107d74000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	c3                   	ret
   1:	10 48 89             	adc    %cl,-0x77(%rax)
   4:	d8 48 c1             	fmuls  -0x3f(%rax)
   7:	e8 03 42 80 3c       	call   0x3c80420f
   c:	28 00                	sub    %al,(%rax)
   e:	74 08                	je     0x18
  10:	48 89 df             	mov    %rbx,%rdi
  13:	e8 5d 38 13 00       	call   0x133875
  18:	48 8b 03             	mov    (%rbx),%rax
  1b:	48 89 04 24          	mov    %rax,(%rsp)
  1f:	4c 8d 78 08          	lea    0x8(%rax),%r15
  23:	4c 89 fd             	mov    %r15,%rbp
  26:	48 c1 ed 03          	shr    $0x3,%rbp
* 2a:	42 80 7c 2d 00 00    	cmpb   $0x0,0x0(%rbp,%r13,1) <-- trapping instruction
  30:	74 08                	je     0x3a
  32:	4c 89 ff             	mov    %r15,%rdi
  35:	e8 3b 38 13 00       	call   0x133875
  3a:	49 8b 07             	mov    (%r15),%rax
  3d:	48                   	rex.W
  3e:	8d                   	.byte 0x8d
  3f:	48                   	rex.W


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

