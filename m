Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3AAC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A086B009B; Mon, 21 Sep 2026 09:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DAA76B00A1; Mon, 21 Sep 2026 09:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9756B00A4; Mon, 21 Sep 2026 09:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4A96B009B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:42:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46A54A018C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:42:19 +0000 (UTC)
X-FDA: 85237883598.22.ECD542E
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7579040005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:42:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3ODSxagkbAMEz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3ODSxagkbAMEz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=z0xyx2CKUzUlO7trGYHo+WhwXNQQH0QF0bBAisIrr6k=;
	b=2EdGSyUfyerOjUUGahlvfUBHYe3bMMryxSLu7t6LOm0fnGU2Iu2tW/Lkl9IduGhrO5znte
	4k18u65wT3+aanRuA0TitnXPvra1kNrI6doJFAFXpu8eMFh5nnyh3YIx/feTUEdplC6CFO
	Ey267vwu2PE8I39ZLJ7/YEIdheVWzh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998137;
	b=bEPO1/j9OXNgmyW/RiYvaazKxWVf4Pe9zOQEnteRv6FraL+YA/5TafiWPCdHunhIF9jU/d
	sfqezujTWvzEeeK+COl4BiPgdlIHx+ErGZwYlwD54lgfaaHIcNMOcwxIX9Dvgd/IRJhN90
	zp8YkZv9xuxIKqjxgIuczQDx3y50LUw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3ODSxagkbAMEz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3ODSxagkbAMEz56rhsslyhwwpk.nvvnsl1zlyjvu0lu0.jvt@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a41f46d629so3772610b6e.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:42:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789998136; x=1790602936;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z0xyx2CKUzUlO7trGYHo+WhwXNQQH0QF0bBAisIrr6k=;
        b=LYPllPEl0PEhxHAhvFp5aX1nCVuP5soXIAtpPxKD2yDIpCdGS4CbICzi3DSrTXTPx7
         iEzUZZFSA1p9iJw3mpT5nhMYAx645wsdVOcMGnr9NGQjY7EYdaN/fbAXxg/bBlJIRAIO
         j5bWxpnPuLk2zdqpFwIrBa0QewoHMciN32+k4wBShrC29PNzekwXySfCFAcwr8ZvoHF5
         w/s1N0UzTJRG6aArbwRCAyNmr+OtGOKLIBB+7hbJd+J1FRTycYUN978WHbPjzdhlmzcI
         GZ7JvGK46uZoN4qGXE0mrQ/kgUbfEksmWfF6g6wfoXJdQIHjWJtdsmDpldmwaf4NpoWX
         kbeQ==
X-Forwarded-Encrypted: i=1; AKwUvBzSp95l84HdLtVajvF46IJKQ7E4x5edeRi/GZCxZLgTsewaQd340s8fTbcsz5xr+b0SeMjcwcUCUg==@kvack.org
X-Gm-Message-State: AFuF++n6xK+bag6xE0Xy/5+ApFDAYf4m+BFApQWhJTOns21qKYLOZmn0
	B9WDSzy8SIGmDUdH8E2aglmIErF3Rrn7YhM0c2fOs3Y/RjYG3MahDMBNp9NRZk5MKs7mX3dubxk
	d1MEnA74ep4AKFdN58xPNsaq3lq3XBloBvLaI93NLnijJZdRGarc7DEasJL4=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2084:b0:6c2:6f93:389f with SMTP id
 006d021491bc7-6ca9bd48180mr11162028eaf.37.1789998136361; Mon, 21 Sep 2026
 06:42:16 -0700 (PDT)
Date: Mon, 21 Sep 2026 06:42:16 -0700
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab13438.71f81b7d.15fa6d.002c.GAE@google.com>
Subject: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
From: syzbot ci <syzbot+cid08c37b8dadb4c43@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	gourry@gourry.net, hannes@cmpxchg.org, haowenchao22@gmail.com, 
	hughd@google.com, kasong@tencent.com, kernel-team@meta.com, 
	kunwu.chan@linux.dev, liam@infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, nphamcs@gmail.com, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	skhan@linuxfoundation.org, surenb@google.com, tj@kernel.org, 
	vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3737tczt1bnieme4thh1tcxkmbgq4t7u
X-Rspamd-Queue-Id: 7579040005
X-HE-Tag: 1789998137-263021
X-HE-Meta: U2FsdGVkX1/RJda1emfZQvpvRhLIh14pphUNFC1YFs1F+16yGiVn1b4RhLDYROHhPrvg5q/+dxRvyWV3me0qQsYsfnNdhXkp9M/WhOJknH1u4hGhv+ud7LkJ25dudw24vjoOCN3etJmIaSYvHH124fZJwiJ4kkNJ4smRYmCkjNILp6bkdqiadcomO6jt1cOM6yf55c3CdcRngnpwWP6apRTduBTCUOezWC9yetX5ucBOVcchXpeEt1nVCvLqPXi4F0h+ZhWkOZX6HGbdXxx0SgFSaQNDOzUSEPmL0CkkT81431YURpnDTL8uO32q3DvRxGS2lbUVJ/Xf/D2i5dCFjA+Wgx/yY0Q74XWCtyVXMPmcWxOUygFbYdPkacGHtWtia4zt84kPrDMKOXcu13hommi78nWYQ1khZrPE22Acs9ZtxRdySS2kULU/woQCisNyafyqMnQ9NIZfJ99V6BSVpnRe7LmwySlSCCtIEIyRh81rDZhkL45eJ3jsIWiqvBpPG8VMBg7knx67n7+SGtEmdAwIXegAOrnpwQAcbN3tOzO4ITkx1M+SK3MWdz4N8IE6GT/MCy4Qe4aeZQpin+761pZ32QO4/M7VgVZ40YVQIEUfDnlcFE9WaN9k/dPesX1jDf0ZDbvDKGy/S9LtE0vNGQ7ATQO0fneZ7+4U+Wp31va4GpgA29gIBdYwDA+aOGG3e5j66shksPZMth6PSbCo4gYkHDsIMZdb5S+akq4z0fbyKcA+ck94UIept/0PmD99Lfx9QIrdK3IxH+HHEvPHW1c7f7dqhxGFI+zYX2QYGh0rv/FL+u3VEKGaEPWz+veW/HPvfpWqXg4NhhYZKVXkcWo4j/BMcvR7usLMRASlpY3fypz7gfym/DoSgXIMjLIiPcp6n5eSYkjOPU+KxER7Lod0UwP4lZ2VCLHqbYq7MYCqyPn0houQ8Xxd398Lhu8FgrXv13ryJeinCneX4V1
 hpeJqp4U
 hLi5IqPWtq/Gu6jszO4UZoCI+b2IYWIswgHVPKZUEbWxgp6/vkh84YWgDo+xymVQTaE0KUMkrG1pkG4pYh1hU8Yqn2B9q/9zCnDneDRbvoHYh3vw4tK+86K0nMfEfl9kaovn6zGl1LJCMkP4t2xCfPjcsS6LLMTvyJqgVvnxL7ECBNnJXsmjH7Ba0fNv9vnSBcsinl82jYh5Vuq/L7f5cYHj7sLKCimuX/E9F4G4DZg9W3OavKFnHR0iEf+G0JOOP9WT9sIvHdCpw5qtv6L/2J7kGk8JA/d7DBnsLe+6UKbrYb5kus7mLp4GVDj+m3RkyLsO5QioZlvsTd3vXwa3VnPYO+jLKd/h7mHRUlm+2xy1UxvMRzblrsJFzD8cFvWDHrq8vRdd9smnzkDBYfTub29eLbo0VzyBrC+JlfL9tw9NiCZPthkoq7piskDwbd/02qiRTKcBlbfZR6E46YTXlqsRZR4x51+zAT2cK9KUMCmiQuGLA3DcDOCrhY968yZqn9/jCW59AthCo72YdkTRppce7Ys+JKPa8FWOUQ1o+7GtvMxcQ06Xb5d09kLpGZ45BmpGagCppkSc/0TdjHX8Xg1Rw6oda1fdWGp3QibnfvV8rDs1tKHUGJxABm+0nCGZKFwy5LwQqHHD31L5v/P9yuwxvRLE/V29O6uMZEJWltZLNGHj19XNqMYPQZDg1g4352N/gjylmoqGZcl5pRgSOwrjxO2ipLBV/Whs1rpcfR3Cl9LIKfYizHXK6qfCVxValWude+rhdtuB3+6oksh0Nex6QggZ3Oi/BgLQn/XT6xx/dbtSE85rocMETtBbQ5Z9bZxgFv4Ze6Lkx5VCoVnuyXy3tNIFBLWWi0WgNaIDca+1eJ0zTCSEockXrALbA3EujamtDyw+Gm1K82VNHzz72H6SWWwZLbQFykeicN6gVfJ1c/GS24GKF6x3vQKd4PvSakmChdqpUuOM1NHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v5] Virtual Swap Space (Swap Table Edition)
https://lore.kernel.org/all/20260918180241.3424851-1-nphamcs@gmail.com
* [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
* [PATCH v5 02/11] mm, swap: support zswap and zero-filled swap pages as vswap backends
* [PATCH v5 03/11] mm, swap: prepare the swap IO path for vswap
* [PATCH v5 04/11] mm, swap: support physical swap as a vswap backend
* [PATCH v5 05/11] mm, swap: enable THP swapin for vswap entries
* [PATCH v5 06/11] mm, swap: write back vswap zswap entries to physical swap
* [PATCH v5 07/11] mm, swap: reclaim physical slots backing cache-only vswap entries
* [PATCH v5 08/11] mm, swap: only charge physical swap entries
* [PATCH v5 09/11] mm, swap: add debugfs counters for vswap
* [PATCH v5 10/11] mm, swap: defer memcg_table allocation for physical swap clusters
* [RFC PATCH v5 11/11] mm, swap: back vswap clusters with a VM_SPARSE array

and found the following issue:
KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

Full report is available here:
https://ci.syzbot.org/series/713f2473-328a-4c16-8bce-63005d15a338

***

KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      27e4e1835109ef599d72abe6c09711e0b1916033
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/26b06329-3b1c-4c73-8ee3-64c53b995186/config
syz repro: https://ci.syzbot.org/findings/f743742b-1934-4b4e-a590-9a36592da902/syz_repro

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:82 [inline]
BUG: KASAN: null-ptr-deref in atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
BUG: KASAN: null-ptr-deref in __vtable_get mm/vswap.h:163 [inline]
BUG: KASAN: null-ptr-deref in vswap_to_phys mm/vswap.h:202 [inline]
BUG: KASAN: null-ptr-deref in swap_entry_backend_has_flag+0xea/0x210 mm/vswap.h:409
Read of size 8 at addr 0000000000000e00 by task syz.1.38/5916

CPU: 1 UID: 0 PID: 5916 Comm: syz.1.38 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
 __vtable_get mm/vswap.h:163 [inline]
 vswap_to_phys mm/vswap.h:202 [inline]
 swap_entry_backend_has_flag+0xea/0x210 mm/vswap.h:409
 do_swap_page+0x767/0x5a20 mm/memory.c:5042
 __collapse_huge_page_swapin mm/khugepaged.c:1152 [inline]
 collapse_huge_page mm/khugepaged.c:1271 [inline]
 mthp_collapse mm/khugepaged.c:1469 [inline]
 collapse_run_pmd+0xaf1/0x5d90 mm/khugepaged.c:2811
 madvise_collapse mm/madvise.c:1026 [inline]
 madvise_vma_behavior+0x17cf/0x4d80 mm/madvise.c:1548
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1896
 madvise_do_behavior+0x385/0x540 mm/madvise.c:2091
 do_madvise+0x26f/0x330 mm/madvise.c:2189
 __do_sys_madvise mm/madvise.c:2198 [inline]
 __se_sys_madvise mm/madvise.c:2196 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2196
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7b5939e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7b5a1ff028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f7b59625fa0 RCX: 00007f7b5939e159
RDX: 0000000000000019 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007f7b5943506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7b59626038 R14: 00007f7b59625fa0 R15: 00007ffe5f2d8d38
 </TASK>
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

