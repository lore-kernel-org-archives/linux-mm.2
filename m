Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CC46CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 06:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522A78E0003; Fri, 26 Sep 2025 02:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9F98E0001; Fri, 26 Sep 2025 02:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40FAF8E0003; Fri, 26 Sep 2025 02:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3040C8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:45:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D680A16058A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:45:31 +0000 (UTC)
X-FDA: 83930465262.18.A3A5AE5
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3C5C6A0011
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:45:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3iTbWaAkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3iTbWaAkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758869130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=1veCcU3mH9oLnhdNlf6mJUGV7a4TAFPi+gLi5uVhv0M=;
	b=H/sqbQB6NS2eyIxz0D+62xwASJtsHhO2TRqr4d+Fuyy5xGLKYhmwPwyhFkpoi7jm5FCswp
	7WB7kN48Bw4VxaNMw2CO6u0nmC9prInW5+/6SG3ooctm609SQ88Km34FBG/F1DLQ/3HDID
	cYNCOLXOwLzA564z67sNgsK/e40WIKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758869130; a=rsa-sha256;
	cv=none;
	b=pbxRfvOT8ZKmEy7tAn7RXLmt29dMoHJMC8kER+w3ic8rZegiuzpu9ZitYE2wNJC1y/P2oU
	eG5sGhxBecBLzGZck0t5aKA5HaRVhmFGBJ3q87YST/Qf+zG1FZ/sk9TngkVZF+yLRCn/FV
	pZzxrAAZBbdZavaBm2VZudT+lMxqMZw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3iTbWaAkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3iTbWaAkbAJwOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-42640cbf7f2so32208705ab.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869129; x=1759473929;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1veCcU3mH9oLnhdNlf6mJUGV7a4TAFPi+gLi5uVhv0M=;
        b=Yli+ulyYNM+6FHgPnmlJPcS0RbJ+bM3bgqBMzodpGutK7F1jMnHROYryI07NQbooVx
         vdQYAIdtFPVmtVmK5OeTco/JTRfEkby4zbW1Rf4QcTJ4XE3pYLDskk97YLDkj0dgxPfJ
         bKfejXMY1H2E8r8ZE6vtvMoBseeVWixerWP8IV9ZPRIrXDmdhyFhYUiFUZ+GfkdCuIaV
         xnpkE/1YFrIgjFj5rzT41GTjiAAD2OannSUotYAAqG8AFfy7bcE6jeyxBIdD3kUk4ncV
         OIJM0W2wNoTTkxcMd1wgmYTt0FyMiYnFWZBBRYUChzuxSXZgZ+rojjvu7AiVjfXoZLTb
         FtKg==
X-Forwarded-Encrypted: i=1; AJvYcCW6r7qpUsKX0FNAZ00xPdsavR4A82GODHN4PXq2jV+oM11L4HLrc5rq4sM0fq/BJekd5O9fpL71FA==@kvack.org
X-Gm-Message-State: AOJu0YwSxent57QxtMWu/7G7zdur7zuK4fTXpJZXWad0Kgi8TRhJaeDI
	lK5pB/bBDIiS/0Bh1eCh0ER7aWNdSdVeVAwMQR3+CstvCdSPegsfOP+iPK4CLB28MrfKPlT+jV0
	met+U1LjM2axJvvn6WMLeQ61t1Nq55iB8heuwtclTTIGnZA6BUzCOiqwktjE=
X-Google-Smtp-Source: AGHT+IGt9fmY+fMre+iBYy4LP8OBoS/OyInBYpNKNG9zH0SZ97oV98zut4bI7DGrK0yZbXbA8dni2nbYBirwgoVX3tXsVCJw/Ahb
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:490d:b0:418:84eb:ea20 with SMTP id
 e9e14a558f8ab-4259562f43bmr90064995ab.15.1758869129365; Thu, 25 Sep 2025
 23:45:29 -0700 (PDT)
Date: Thu, 25 Sep 2025 23:45:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d63689.050a0220.25d7ab.00d9.GAE@google.com>
Subject: [syzbot] [mm?] KCSAN: data-race in try_to_compact_pages / try_to_compact_pages
From: syzbot <syzbot+20dd68d4ba19e8242c26@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bk5ay47rrt8mdojd7hiweor4jp6g378s
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C5C6A0011
X-Rspamd-Server: rspam10
X-HE-Tag: 1758869130-292966
X-HE-Meta: U2FsdGVkX19rEdyhsc5+80KeoUY2iO7UqyjQ0z7fm6RlUKiTQ+HprT61fSsc/5iE6BsQ7tHaX5Tnq5Ag3npO95CJm2rpsRJAksRCaH/qrB2TChUUgr5lsk518IcoTuF7Trn80i5dDPks2wNX3gyY2s7gO9+q11lp9HMwtd5G+DXJconjHLNnhZLSGI6qu9/iVeri0SGLioeT5UMf81nPz4QM4qz9AI+uVMnIezOfYt4GmFZtKlKWQHXmYBpsdEIe2Xg9jBeSOmR3UEHxNB3dDKl/IFQ4BRppqCPMr2OXi2bh8KayF/kz5fYpt+OWEJCoxBCVcmqe16xwXSTaqyfAyK3xJcAQveola3TD0aVejKtBegaayN8TfnSF/EKIY7SsVtAqY5UFP0CvhboEOiaQr9jaIcFcIpR0qX5yMoMcuCuPj5qH8xwWCEuZCxbah73ztQsp8p4HvgVtFlXDK0F9PvRBBi8fGw07A27L9y90wfl02futvsYRqK6M8BnmL5o+b6C/oQ10bH4oh7gAjxMUoktZ1ECPa5qMPHekmg0L/1IMXCIGcZScvmpu3LkAdKVapys38/jaUAVv07k91QlzYNsPqtkSLhdov89cwjDKBlph4QABJULKX1h/aQ2Q4wckZikIJBCdNk3XhIv+muJyaLUaj1rueG6+HeL2JBggx8K+5UXWX9jRfWLOcz2V6J6LxsgjE/05Q1rcv+om6XhcL0vHmT778damA2l52YN2wP8KxjmCTPrPTxsShA+US6cE1oMJSj6rsL+IK73albw6lHTT5vSEj5D+DfwoZdq1lAC5liwRX7PQFHwkOsGbuT2+DLByh9qTSBxi+cXPA1FZWtnhvQ4zFQHQ8ugwMxXI9FxWqeibRZxENFwa320v6veUJi5d+zl1LttjmnMYoNEcqlRs+TDzhE0wn27o86eUsqGKTH8dRwwCZFUYGCIULXXXgj4ky+aBLpam51Fi3o+
 E2LWMGoQ
 B48AsAGGWKMi/8QgeEfVrAfV2pHARAnYKW8OVXdedJYTR1PUQ/ntQpuDoxDNEGWMJDsuZZhVFpHFQNfIK+hjeuYxo2aP8tAN/kH4+akE+K/Y3mk0fdzONtfbF9mC46U/66mu9V4xgDsK8Ml4QcbacTVmnGw593CJbe/+e7vuHYyOPFbQA9UALDSaJBS/WW645jN0aKRMBF38H9rNkYh3vvGp75gShcB1sjmT1bKr4RIrXofiY4AyE0VVB+Xthm4A/3tHlwAqqhIqW7vtYsR/S22t8nYbyRSNq7UBBtaD57giNVqUzUPbWkJwASKvuh5w7EsN+HRQHs3yloMWEbbvvLfYZSfgMQPZNUclubqVULVH4qxkahw662Sd9Xkiwv2qVmjF4VSGmIFQrcDO6ktZrrqbr2VW251CxVWy0bYAwLxUaWamHmEm7QxfSs0q691DkYhS/KyjbF5E9aDBfVxViaItKKVONuEjfr6xIywtSL/Fs8ChKJ02L6FrrqJEd8KQqplmBR80DsPEG7cj6UPrCks7eob/6eghhaBYm/BbU+gMIBcEK2CqlXZvvo9h4v60bDR3kETeQtfMMZnW2SqVNqRmSw7iTXq4Vg+dRYEvHAwkBKai6O/o2vk/nl1b0xZbIhsA680rW2MWqal5tns0AzNjIUbm0uM0gXU3rUNPcZHURuLb/T5/2nFVuqOKAhXsWidWKi7/jVR+2RgzzR4+ufkUtTwzSoxHJ/JULJ/oVvO2UEE1ftkGg5XkR6QUmxJbWPrStkWzgXP7gX8Or1kyuyWNw4kdchnx0fin3etv3X/kKnokBW6UH1RPcCwQOT1sExXN2t8JepQkFSpiuVdYbLlLrik7f7ZyMTEGQW9xw/Jszit1HcNadvHV/ECU42kM9S3tPFSKd3qi71/XaUQ6Pnclrrs/NVjU4BByW8DAHGPxBohaNOj1WRge2AqI0FZLGMHSMOkx82O2hPYMcoIPOBRk9ucrF
 YqH2LW7i
 IDpoG3gzF3lXBDmb3Jm4ra01Pdhx/WytNLeMjkK/pMiUxAaLOj+p9MaIbSZKjLqdHwuNKFTnu14I4T3U6MT/lAVuElegbmXEYoBHxzvJXD/q13SLB8yx2YVw9W9zc1qpxMaz2hy/qvEegXcdUrnF5JYgEqtcsPeZ5yHb78Facy+NuoysqYz9Z/x0ZD1840/ILTIksYjblJwggmAADHh9GGar9p0R/wr0Xdst5ik4ZZGX51dqjXkBSBl7nYq351EhKgfCdUbmX9zJBT1QlOpw3/NSIgDaSyw3K+/cjsvWdPSSsU5fqNDJPJT5NUTz6MrFjCOWd0AJcuwU8+lLw9q9loTK+nNRoQrVf7KFlPPC33hGecVMRB+SS5bfzAeLwiJscAod19fdS9GeDElTEubzFT37eaVg/Mm9Fl79MR907PWGeEX17/2quoA0uxs9HMNBfH5EuXJ6fOYHndxpBcOUMhFQJF/pimzJjq2jekuZfrzAYnAZtkFDR97AyBKRB6v/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    cec1e6e5d1ab Merge tag 'sched_ext-for-6.17-rc7-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12448f12580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6e0c213d0735f5dd
dashboard link: https://syzkaller.appspot.com/bug?extid=20dd68d4ba19e8242c26
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/10b7c8fdfdec/disk-cec1e6e5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cbecc36962db/vmlinux-cec1e6e5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/214f107d0a3e/bzImage-cec1e6e5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+20dd68d4ba19e8242c26@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in try_to_compact_pages / try_to_compact_pages

read-write to 0xffff88823fffacf0 of 4 bytes by task 6757 on cpu 1:
 compaction_deferred mm/compaction.c:149 [inline]
 try_to_compact_pages+0x1be/0x940 mm/compaction.c:2838
 __alloc_pages_direct_compact+0x65/0x1d0 mm/page_alloc.c:4066
 __alloc_pages_slowpath+0x360/0x5f0 mm/page_alloc.c:4787
 __alloc_frozen_pages_noprof+0x270/0x360 mm/page_alloc.c:5161
 alloc_pages_mpol+0xb3/0x250 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof+0x90/0x110 mm/mempolicy.c:2487
 ___kmalloc_large_node+0x52/0x100 mm/slub.c:4317
 __kmalloc_large_node_noprof+0x16/0xa0 mm/slub.c:4348
 __do_kmalloc_node mm/slub.c:4364 [inline]
 __kmalloc_noprof+0x2ab/0x3e0 mm/slub.c:4388
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kmalloc_array_noprof include/linux/slab.h:948 [inline]
 io_vec_realloc io_uring/rsrc.c:1327 [inline]
 io_import_reg_vec+0x645/0xe80 io_uring/rsrc.c:1520
 io_sendmsg_zc+0x91/0x550 io_uring/net.c:1545
 __io_issue_sqe+0xfb/0x2e0 io_uring/io_uring.c:1771
 io_issue_sqe+0x53/0x970 io_uring/io_uring.c:1794
 io_queue_sqe io_uring/io_uring.c:2023 [inline]
 io_submit_sqe io_uring/io_uring.c:2283 [inline]
 io_submit_sqes+0x675/0x1060 io_uring/io_uring.c:2396
 __do_sys_io_uring_enter io_uring/io_uring.c:3463 [inline]
 __se_sys_io_uring_enter+0x1c1/0x1b70 io_uring/io_uring.c:3397
 __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3397
 x64_sys_call+0x2de1/0x2ff0 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd2/0x200 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

write to 0xffff88823fffacf0 of 4 bytes by task 6696 on cpu 0:
 compaction_deferred mm/compaction.c:150 [inline]
 try_to_compact_pages+0x207/0x940 mm/compaction.c:2838
 __alloc_pages_direct_compact+0x65/0x1d0 mm/page_alloc.c:4066
 __alloc_pages_slowpath+0x360/0x5f0 mm/page_alloc.c:4787
 __alloc_frozen_pages_noprof+0x270/0x360 mm/page_alloc.c:5161
 alloc_pages_mpol+0xb3/0x250 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof+0x90/0x110 mm/mempolicy.c:2487
 ___kmalloc_large_node+0x52/0x100 mm/slub.c:4317
 __kmalloc_large_node_noprof+0x16/0xa0 mm/slub.c:4348
 __do_kmalloc_node mm/slub.c:4364 [inline]
 __kmalloc_noprof+0x2ab/0x3e0 mm/slub.c:4388
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kmalloc_array_noprof include/linux/slab.h:948 [inline]
 io_vec_realloc io_uring/rsrc.c:1327 [inline]
 io_import_reg_vec+0x645/0xe80 io_uring/rsrc.c:1520
 io_sendmsg_zc+0x91/0x550 io_uring/net.c:1545
 __io_issue_sqe+0xfb/0x2e0 io_uring/io_uring.c:1771
 io_issue_sqe+0x53/0x970 io_uring/io_uring.c:1794
 io_queue_sqe io_uring/io_uring.c:2023 [inline]
 io_submit_sqe io_uring/io_uring.c:2283 [inline]
 io_submit_sqes+0x675/0x1060 io_uring/io_uring.c:2396
 __do_sys_io_uring_enter io_uring/io_uring.c:3463 [inline]
 __se_sys_io_uring_enter+0x1c1/0x1b70 io_uring/io_uring.c:3397
 __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3397
 x64_sys_call+0x2de1/0x2ff0 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd2/0x200 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x00000005 -> 0x00000004

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 6696 Comm: syz.2.1234 Not tainted syzkaller #0 PREEMPT(voluntary) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
==================================================================


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

