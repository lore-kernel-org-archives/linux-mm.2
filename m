Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE92107BCD3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 17:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 239816B0089; Fri, 13 Mar 2026 13:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0D36B008A; Fri, 13 Mar 2026 13:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7C76B008C; Fri, 13 Mar 2026 13:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB7BC6B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:39:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5AA98AC6A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:39:41 +0000 (UTC)
X-FDA: 84541752162.09.201AF63
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf29.hostedemail.com (Postfix) with ESMTP id D753612000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:39:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of 32ku0aQkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=32ku0aQkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773423580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=lIRSBckNjRBdzSzE/COdRjIvzNSUsSX2V4LmWy1PXTo=;
	b=E9+h91RSiG7jiL1fJCrpjCq0N2AITdxUPix1kygIQSKyN3SGLzkEpwMQp/0bQ0oUAj7Tfl
	aEJZk7Vm38ZUgJd5BZhTpSK10hxQqJhwV9jR50opClJg9qe9fVw8bUEBn94sAF5E4C68AY
	Oukc09tVkqV8AUsd+DP9uGQcXSyXAEs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of 32ku0aQkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=32ku0aQkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773423580; a=rsa-sha256;
	cv=none;
	b=YEAX+bl0Qg8VE1zesPPlGEguPWuOmIJqockkutl2BZdHWbKcDl6tawpWXVMUA2eUuPyM3H
	wv94uU140AN/TbUn63l80eikkhr1xUGMNXPVturiWFbNWx+JtU5q6fRpQYfZ9A4O3u4wCr
	YRPKI1r3nIFhDYdlqaihOrB6xJ0PWW0=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-463a075e177so10515037b6e.2
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:39:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773423579; x=1774028379;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lIRSBckNjRBdzSzE/COdRjIvzNSUsSX2V4LmWy1PXTo=;
        b=W71CZAWxP6Ox0drLMwfnsFtBlenhsfyHfO1MD8S0v+6tZvUjvYzKDQ3XqE6DF8A5tG
         AyA+hJVAKwizbV025RxvftXGOLSw+AZ0rL+eNEJpEDhpyqnvf9ClXsysM+JURl74C2hP
         XvuJGk8CQCDpzyWjqZzg4JJLbDfwsI8a/L7/F4GGsKp208zh43isIGWxluOQyJNl+0xp
         zhMeGH7GhuOWsNSUx9JXspl61PYDpJrRRY1HTANMCN6YQLympt1xOlGrUOGZQZQ1jHiB
         NuyJG4BVYKG8MInGIZk9sjPNZ4a5qSFR53ir7NIq1Hf0E2Yz7aW1Mt0Rdk+I4NLF0NPq
         pK3w==
X-Forwarded-Encrypted: i=1; AJvYcCW9P85qaRc6udABE1scAKphP3+xop2qyKgzmUy0tSQBWkUz0U0plNaLfp2+ewXd2tuCT6PDo29IPQ==@kvack.org
X-Gm-Message-State: AOJu0YxfudxXmfgme5ys8e3DiuFnx1dTQcgHokS8DLXSpmq3LFhKS/Ti
	Tql5PusNwGMVxLBwWYd6sWHjHQ2L5v1wVM3CLVORq6VhCMH0fauIqlIubYGUy/L0bCvU3GwflQu
	x1JGEkobjFuwE5rQL4EkfNTci+6JRP8WhOUvV2tnaRGY+3ODpqvaAJBGQfdE=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:498c:b0:679:97d5:dd28 with SMTP id
 006d021491bc7-67bda9dfbc7mr2072153eaf.30.1773423578897; Fri, 13 Mar 2026
 10:39:38 -0700 (PDT)
Date: Fri, 13 Mar 2026 10:39:38 -0700
In-Reply-To: <20260312205321.638053-1-hannes@cmpxchg.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b44bda.050a0220.36eb34.000d.GAE@google.com>
Subject: [syzbot ci] Re: mm: switch THP shrinker to list_lru
From: syzbot ci <syzbot+cidbbb79a1260c5a35@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, david@kernel.org, 
	hannes@cmpxchg.org, kas@kernel.org, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, usama.arif@linux.dev, yosry.ahmed@linux.dev, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D753612000D
X-Stat-Signature: zoh36iwsaxfthmmqh7g8xogz75a55ezm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773423579-631095
X-HE-Meta: U2FsdGVkX1/WlMrHxD4nAoN+znIlm6utoPsqaxTqSmqHgiJaKMo2Lil4kbFTsB4VFAxoIqIqKCNPOlJLGwqeKHCdKGj8HX84gYjU0ixsLk8jWMVWz0lq4QpRtBDlUJHk7oihAquDir6M7kZ7mZnoYQW6wUljQ09sLpUDTuYqqj/Qpfa8/7iBB4aD7RJlyUujq3RpTE8YSPQN2ny7kCb2luZuamIYgf0SlmQVVCfwqlgGXmbMu96V7botqNxhU3sM2/YLYWn4IUNkm220vmgsUDBEv/Hxqk9QCerwHu4mIx4ShmQj8OXnyZaS3019myuS8ZhpUBt5tAWJcNzZ/JJKKyV+kRJjOwW9Kzn2WZ4KvvUScbNlSaoQGGFpZxsr/SBOCAjYJRAd66tT7l8ehztbtH0S89KqffwIQm12TBFzcId19TkdNFJd7Tk9hCfM9a1Z5s2sSan84algcx/PQ4QTIPshsxhZMMVmSxE+IsuGPSMU7uy+tWhvRcSGiPHQb8J22orEgX73mImY31+eakupHXI8v5yTB/JU/VEwo3ta5cohSL+qN/QUs/AR6j42kvFRtucZefxv9jay/QjHnaDtzuLW2IP+8cKipTGjzM7oYP/sM/aQJhDi+rVV0QZQ/tt/7BPscPOTY0VzZv3BcURAQw5dkbnvG6QqvY+qRkjw6uTWWqHVf7zc2+OXOwpQL/+SAu4ho3hoMnwe7f6/sX/ayY/lQdLwMR8R6y3+Ys6vI+PydwprZ/dn0EX86V6mwkhJTeDG7XSVZfGuJq60j7m+gfXc/vt+3epXG7dHDWrDzCpIEgu88hTsNdNW7Gurpi15LOBTxjHbGWPemkYcQMwMPq56Jh6Mz13hthM1+x/oKD5nbejWYtm2JlvbAv+Kx+T9tdDNZPqvoSShPFYR/ET8n73o1Xt+sBQ/jeNU+yV8Ead9OmemRERiQhD3iYEhowdyit7z3TFLJWnSq+Js1qm
 6dF8qrVK
 6HZ389u4u6hBN4kHu3mHt4uvUvdD5A8sADXC1xe0sV93dizAmGcO8JH6Zq7wDleds6jOYWo4B9Gzrj6NP/ZhASvjy7h5kuEeBHXhOkPp07HrD6W8+9Bx0krCs8tWfNn+zeylL2P2lbgEhOoHJzcxNLPifP0YAb/vANBez7fmlJItUrZ55PFGmxrquxuz/G8kzYm6teZGe6R2dbaiAJyKSCJbGpPkNZZPEV9+XK8FySNYMTCbhfXN5+JjquG3s8BcMNLMsaaakPvJ01p6V4GvhaaoV8oKFI0e0V732e0/N9OZOJbxPYVsU9rAYRwpaypox6j0OxbUd4PiRgkEaZh219rwHxpnpsPjw5DLx0SXxZuhhF11p/uRvDzih06Z6pJYBahQ4GQICL+e+1RW3DKuTyJmmCJ6GbHkg6bPrQ8x0IcvP7prkjbYLkcc3wogERyxL8GdchA3m2iAcrzmiDnaDB9KthUyJyteahEv4XYT55N5uRnJW8bFiVE6W1Y1+xLIVI05Bgdk/WNfg03C2k+ZjkuuHm11Y1kElFerKAU6bgG+x9ALv2Xqr64X92sFwfON+lZ2w/mFMrSW4p9kM2Jq6D13M8f/ehYIbFV5RpHocXfCAsOdpzI8x49OhljJiI/yravbzWWhY9ZLPK4g76K7/ybQSQG24r5G6JJLNn+UrItPIXr3VxlPfXv7+3t3WCK0ZURsBhkNqChX/4Xbo36WAAQ3pFTCy8iVbw4wwSbICTuOeUnGzCetwtl/F2WCVzhTcgZPq1LW0f3Q9uuVTbRoXuWPPT6REC6m14uRBCvdAhU8pHFIyr4vqQcAUUhe9aiETRAYM1k73gVGI7ewMXDA3OTQS6Rfl4Ff35zCCT6QmFTfrFTkuwaYH78g9BQ65dyI9RIwKJMfulJqbmrl5NAuIBDC32ehJQmDEffFhs34ufTZSMC7TMuhnvkoYfERY2hY9lnsgwsnMk3WDLHkX8EsRDANNVywv
 1LbshQYz
 I/kgEtbVhuw0RT16XVWqh2JG2RuvaGWdTBhcSJzPy1S3SxoUiFEm+YsSHF+4y/HIJ7HKPpavn7HvroBavab2N0gXpGzlW2AZWnmr552B4/sYFFpB0zrq2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm: switch THP shrinker to list_lru
https://lore.kernel.org/all/20260312205321.638053-1-hannes@cmpxchg.org
* [PATCH v2 1/7] mm: list_lru: lock_list_lru_of_memcg() cannot return NULL if !skip_empty
* [PATCH v2 2/7] mm: list_lru: deduplicate unlock_list_lru()
* [PATCH v2 3/7] mm: list_lru: move list dead check to lock_list_lru_of_memcg()
* [PATCH v2 4/7] mm: list_lru: deduplicate lock_list_lru()
* [PATCH v2 5/7] mm: list_lru: introduce caller locking for additions and deletions
* [PATCH v2 6/7] mm: list_lru: introduce memcg_list_lru_alloc_folio()
* [PATCH v2 7/7] mm: switch deferred split shrinker to list_lru

and found the following issues:
* WARNING in lock_list_lru_of_memcg
* possible deadlock in __folio_end_writeback

Full report is available here:
https://ci.syzbot.org/series/e7f4d9e2-b111-4e6e-80f8-e762d8337560

***

WARNING in lock_list_lru_of_memcg

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7315345d-816f-4df6-a17e-355964ef03ca/config
C repro:   https://ci.syzbot.org/findings/28d9d87d-fee2-4068-a072-c8a3713d5f60/c_repro
syz repro: https://ci.syzbot.org/findings/28d9d87d-fee2-4068-a072-c8a3713d5f60/syz_repro

XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
------------[ cut here ]------------
!css_is_dying(&memcg->css)
WARNING: mm/list_lru.c:110 at lock_list_lru_of_memcg+0x33d/0x470 mm/list_lru.c:110, CPU#0: syz.0.17/5950
Modules linked in:
CPU: 0 UID: 0 PID: 5950 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:lock_list_lru_of_memcg+0x33d/0x470 mm/list_lru.c:110
Code: 3c 28 00 74 08 4c 89 e7 e8 b0 02 1d 00 4d 8b 24 24 48 8b 54 24 20 4d 85 e4 0f 85 00 fe ff ff e9 75 fe ff ff e8 d4 df b3 ff 90 <0f> 0b 90 eb c1 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 06 fe ff ff 48
RSP: 0018:ffffc90004017110 EFLAGS: 00010093
RAX: ffffffff8211b3ac RBX: 0000000000000000 RCX: ffff888104f057c0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff888104f057c0 R09: 0000000000000002
R10: 0000000000000406 R11: 0000000000000000 R12: ffff8881026d0d00
R13: dffffc0000000000 R14: ffffffff9a2de05c R15: 0000000000000002
FS:  0000555572bfe500(0000) GS:ffff88818de66000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 0000000112554000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __folio_freeze_and_split_unmapped+0x2ab/0x34b0 mm/huge_memory.c:3767
 __folio_split+0xae1/0x1570 mm/huge_memory.c:4033
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 iomap_write_failed fs/iomap/buffered-io.c:780 [inline]
 iomap_write_iter fs/iomap/buffered-io.c:1182 [inline]
 iomap_file_buffered_write+0x788/0xb30 fs/iomap/buffered-io.c:1220
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1013
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f81d019c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffee035cc08 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f81d0415fa0 RCX: 00007f81d019c799
RDX: 000000000000fdef RSI: 0000200000000140 RDI: 0000000000000005
RBP: 00007f81d0232c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000e7c R11: 0000000000000246 R12: 0000000000000000
R13: 00007f81d0415fac R14: 00007f81d0415fa0 R15: 00007f81d0415fa0
 </TASK>


***

possible deadlock in __folio_end_writeback

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7315345d-816f-4df6-a17e-355964ef03ca/config
C repro:   https://ci.syzbot.org/findings/8c08a79f-a08c-41d5-95e6-2860caf8744c/c_repro
syz repro: https://ci.syzbot.org/findings/8c08a79f-a08c-41d5-95e6-2860caf8744c/syz_repro

=====================================================
WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
syzkaller #0 Not tainted
-----------------------------------------------------
syz.0.17/5949 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
ffff88810c90c240 (&l->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
ffff88810c90c240 (&l->lock){+.+.}-{3:3}, at: lock_list_lru mm/list_lru.c:26 [inline]
ffff88810c90c240 (&l->lock){+.+.}-{3:3}, at: lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95

and this task is already holding:
ffff8881107ad160 (&xa->xa_lock#9){..-.}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
ffff8881107ad160 (&xa->xa_lock#9){..-.}-{3:3}, at: __folio_split+0xa2e/0x1570 mm/huge_memory.c:4025
which would create a new lock dependency:
 (&xa->xa_lock#9){..-.}-{3:3} -> (&l->lock){+.+.}-{3:3}

but this new dependency connects a SOFTIRQ-irq-safe lock:
 (&xa->xa_lock#9){..-.}-{3:3}

... which became SOFTIRQ-irq-safe at:
  lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
  _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:162
  __folio_end_writeback+0x157/0x770 mm/page-writeback.c:2946
  folio_end_writeback_no_dropbehind+0x151/0x290 mm/filemap.c:1667
  folio_end_writeback+0xea/0x220 mm/filemap.c:1693
  end_bio_bh_io_sync+0xbd/0x120 fs/buffer.c:2773
  blk_update_request+0x57e/0xe60 block/blk-mq.c:1016
  scsi_end_request+0x7c/0x820 drivers/scsi/scsi_lib.c:647
  scsi_io_completion+0x131/0x360 drivers/scsi/scsi_lib.c:1088
  blk_complete_reqs block/blk-mq.c:1253 [inline]
  blk_done_softirq+0x10a/0x160 block/blk-mq.c:1258
  handle_softirqs+0x22a/0x870 kernel/softirq.c:622
  __do_softirq kernel/softirq.c:656 [inline]
  invoke_softirq kernel/softirq.c:496 [inline]
  __irq_exit_rcu+0x5f/0x150 kernel/softirq.c:723
  irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
  instr_sysvec_call_function_single arch/x86/kernel/smp.c:266 [inline]
  sysvec_call_function_single+0xa3/0xc0 arch/x86/kernel/smp.c:266
  asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.h:704
  __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:179 [inline]
  _raw_spin_unlock_irqrestore+0x47/0x80 kernel/locking/spinlock.c:194
  spin_unlock_irqrestore include/linux/spinlock.h:407 [inline]
  ata_scsi_queuecmd+0x47b/0x590 drivers/ata/libata-scsi.c:4523
  scsi_dispatch_cmd drivers/scsi/scsi_lib.c:1647 [inline]
  scsi_queue_rq+0x1835/0x3330 drivers/scsi/scsi_lib.c:1904
  blk_mq_dispatch_rq_list+0xa70/0x1910 block/blk-mq.c:2148
  __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
  blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
  __blk_mq_sched_dispatch_requests+0xdcc/0x1600 block/blk-mq-sched.c:307
  blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
  blk_mq_run_work_fn+0x22e/0x300 block/blk-mq.c:2562
  process_one_work kernel/workqueue.c:3275 [inline]
  process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
  worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
  kthread+0x388/0x470 kernel/kthread.c:436
  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

to a SOFTIRQ-irq-unsafe lock:
 (&l->lock){+.+.}-{3:3}

... which became SOFTIRQ-irq-unsafe at:
...
  lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
  __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
  spin_lock include/linux/spinlock.h:341 [inline]
  lock_list_lru mm/list_lru.c:26 [inline]
  lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95
  list_lru_lock mm/list_lru.c:154 [inline]
  list_lru_add+0x46/0x260 mm/list_lru.c:208
  list_lru_add_obj+0x191/0x270 mm/list_lru.c:221
  d_lru_add+0xd6/0x160 fs/dcache.c:497
  retain_dentry fs/dcache.c:779 [inline]
  fast_dput+0x303/0x430 fs/dcache.c:866
  dput+0xe8/0x1a0 fs/dcache.c:924
  path_put fs/namei.c:717 [inline]
  put_link+0x112/0x190 fs/namei.c:1196
  walk_component fs/namei.c:2284 [inline]
  link_path_walk+0x1299/0x18d0 fs/namei.c:2644
  path_openat+0x2c3/0x3860 fs/namei.c:4826
  do_file_open+0x23e/0x4a0 fs/namei.c:4859
  do_open_execat+0x12b/0x580 fs/exec.c:781
  open_exec+0x29/0x40 fs/exec.c:817
  load_elf_binary+0x1aaf/0x2980 fs/binfmt_elf.c:908
  search_binary_handler fs/exec.c:1664 [inline]
  exec_binprm fs/exec.c:1696 [inline]
  bprm_execve+0x93d/0x1460 fs/exec.c:1748
  kernel_execve+0x844/0x930 fs/exec.c:1892
  try_to_run_init_process+0x13/0x60 init/main.c:1512
  kernel_init+0xad/0x1d0 init/main.c:1640
  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&l->lock);
                               local_irq_disable();
                               lock(&xa->xa_lock#9);
                               lock(&l->lock);
  <Interrupt>
    lock(&xa->xa_lock#9);

 *** DEADLOCK ***

5 locks held by syz.0.17/5949:
 #0: ffff88816931a980 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:592 [inline]
 #0: ffff88816931a980 (&mm->mmap_lock){++++}-{4:4}, at: madvise_lock+0x152/0x2e0 mm/madvise.c:1779
 #1: ffff8881107ad338 (&mapping->i_mmap_rwsem){++++}-{4:4}, at: i_mmap_lock_read include/linux/fs.h:532 [inline]
 #1: ffff8881107ad338 (&mapping->i_mmap_rwsem){++++}-{4:4}, at: __folio_split+0x11d7/0x1570 mm/huge_memory.c:3993
 #2: ffff8881107ad160 (&xa->xa_lock#9){..-.}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
 #2: ffff8881107ad160 (&xa->xa_lock#9){..-.}-{3:3}, at: __folio_split+0xa2e/0x1570 mm/huge_memory.c:4025
 #3: ffffffff8e75e460 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #3: ffffffff8e75e460 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #3: ffffffff8e75e460 (rcu_read_lock){....}-{1:3}, at: __folio_freeze_and_split_unmapped+0x1d3/0x34b0 mm/huge_memory.c:3766
 #4: ffffffff8e75e460 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #4: ffffffff8e75e460 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #4: ffffffff8e75e460 (rcu_read_lock){....}-{1:3}, at: lock_list_lru_of_memcg+0x34/0x470 mm/list_lru.c:91

the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
-> (&xa->xa_lock#9){..-.}-{3:3} {
   IN-SOFTIRQ-W at:
                    lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
                    __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
                    _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:162
                    __folio_end_writeback+0x157/0x770 mm/page-writeback.c:2946
                    folio_end_writeback_no_dropbehind+0x151/0x290 mm/filemap.c:1667
                    folio_end_writeback+0xea/0x220 mm/filemap.c:1693
                    end_bio_bh_io_sync+0xbd/0x120 fs/buffer.c:2773
                    blk_update_request+0x57e/0xe60 block/blk-mq.c:1016
                    scsi_end_request+0x7c/0x820 drivers/scsi/scsi_lib.c:647
                    scsi_io_completion+0x131/0x360 drivers/scsi/scsi_lib.c:1088
                    blk_complete_reqs block/blk-mq.c:1253 [inline]
                    blk_done_softirq+0x10a/0x160 block/blk-mq.c:1258
                    handle_softirqs+0x22a/0x870 kernel/softirq.c:622
                    __do_softirq kernel/softirq.c:656 [inline]
                    invoke_softirq kernel/softirq.c:496 [inline]
                    __irq_exit_rcu+0x5f/0x150 kernel/softirq.c:723
                    irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
                    instr_sysvec_call_function_single arch/x86/kernel/smp.c:266 [inline]
                    sysvec_call_function_single+0xa3/0xc0 arch/x86/kernel/smp.c:266
                    asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.h:704
                    __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:179 [inline]
                    _raw_spin_unlock_irqrestore+0x47/0x80 kernel/locking/spinlock.c:194
                    spin_unlock_irqrestore include/linux/spinlock.h:407 [inline]
                    ata_scsi_queuecmd+0x47b/0x590 drivers/ata/libata-scsi.c:4523
                    scsi_dispatch_cmd drivers/scsi/scsi_lib.c:1647 [inline]
                    scsi_queue_rq+0x1835/0x3330 drivers/scsi/scsi_lib.c:1904
                    blk_mq_dispatch_rq_list+0xa70/0x1910 block/blk-mq.c:2148
                    __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
                    blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
                    __blk_mq_sched_dispatch_requests+0xdcc/0x1600 block/blk-mq-sched.c:307
                    blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
                    blk_mq_run_work_fn+0x22e/0x300 block/blk-mq.c:2562
                    process_one_work kernel/workqueue.c:3275 [inline]
                    process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
                    worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
                    kthread+0x388/0x470 kernel/kthread.c:436
                    ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
                    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
   INITIAL USE at:
                   lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
                   __raw_spin_lock_irq include/linux/spinlock_api_smp.h:142 [inline]
                   _raw_spin_lock_irq+0x3d/0x50 kernel/locking/spinlock.c:170
                   spin_lock_irq include/linux/spinlock.h:371 [inline]
                   shmem_add_to_page_cache+0x7b2/0xd40 mm/shmem.c:904
                   shmem_alloc_and_add_folio+0x869/0xf80 mm/shmem.c:1998
                   shmem_get_folio_gfp+0x4d4/0x1420 mm/shmem.c:2549
                   shmem_read_folio_gfp+0x8a/0xe0 mm/shmem.c:5957
                   drm_gem_get_pages+0x263/0x9d0 drivers/gpu/drm/drm_gem.c:696
                   drm_gem_shmem_get_pages_locked+0x22b/0x480 drivers/gpu/drm/drm_gem_shmem_helper.c:222
                   drm_gem_shmem_pin_locked+0x251/0x4d0 drivers/gpu/drm/drm_gem_shmem_helper.c:283
                   drm_gem_shmem_vmap_locked+0x499/0x7d0 drivers/gpu/drm/drm_gem_shmem_helper.c:387
                   drm_gem_vmap_locked drivers/gpu/drm/drm_gem.c:1387 [inline]
                   drm_gem_vmap+0x10a/0x1d0 drivers/gpu/drm/drm_gem.c:1429
                   drm_client_buffer_vmap+0x6c/0xb0 drivers/gpu/drm/drm_client.c:355
                   drm_fbdev_shmem_driver_fbdev_probe+0x273/0x8a0 drivers/gpu/drm/drm_fbdev_shmem.c:159
                   drm_fb_helper_single_fb_probe drivers/gpu/drm/drm_fb_helper.c:1468 [inline]
                   __drm_fb_helper_initial_config_and_unlock+0x1421/0x1b90 drivers/gpu/drm/drm_fb_helper.c:1647
                   drm_fbdev_client_hotplug+0x16c/0x230 drivers/gpu/drm/clients/drm_fbdev_client.c:66
                   drm_client_register+0x172/0x210 drivers/gpu/drm/drm_client.c:143
                   drm_fbdev_client_setup+0x1a0/0x3f0 drivers/gpu/drm/clients/drm_fbdev_client.c:168
                   drm_client_setup+0x107/0x220 drivers/gpu/drm/clients/drm_client_setup.c:46
                   vkms_create+0x413/0x4d0 drivers/gpu/drm/vkms/vkms_drv.c:212
                   vkms_init+0x57/0x80 drivers/gpu/drm/vkms/vkms_drv.c:240
                   do_one_initcall+0x250/0x8d0 init/main.c:1384
                   do_initcall_level+0x104/0x190 init/main.c:1446
                   do_initcalls+0x59/0xa0 init/main.c:1462
                   kernel_init_freeable+0x2a6/0x3e0 init/main.c:1694
                   kernel_init+0x1d/0x1d0 init/main.c:1584
                   ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
                   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 }
 ... key      at: [<ffffffff9a2e8be0>] xa_init_flags.__key+0x0/0x20

the dependencies between the lock to be acquired
 and SOFTIRQ-irq-unsafe lock:
-> (&l->lock){+.+.}-{3:3} {
   HARDIRQ-ON-W at:
                    lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
                    __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
                    _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
                    spin_lock include/linux/spinlock.h:341 [inline]
                    lock_list_lru mm/list_lru.c:26 [inline]
                    lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95
                    list_lru_lock mm/list_lru.c:154 [inline]
                    list_lru_add+0x46/0x260 mm/list_lru.c:208
                    list_lru_add_obj+0x191/0x270 mm/list_lru.c:221
                    d_lru_add+0xd6/0x160 fs/dcache.c:497
                    retain_dentry fs/dcache.c:779 [inline]
                    fast_dput+0x303/0x430 fs/dcache.c:866
                    dput+0xe8/0x1a0 fs/dcache.c:924
                    path_put fs/namei.c:717 [inline]
                    put_link+0x112/0x190 fs/namei.c:1196
                    walk_component fs/namei.c:2284 [inline]
                    link_path_walk+0x1299/0x18d0 fs/namei.c:2644
                    path_openat+0x2c3/0x3860 fs/namei.c:4826
                    do_file_open+0x23e/0x4a0 fs/namei.c:4859
                    do_open_execat+0x12b/0x580 fs/exec.c:781
                    open_exec+0x29/0x40 fs/exec.c:817
                    load_elf_binary+0x1aaf/0x2980 fs/binfmt_elf.c:908
                    search_binary_handler fs/exec.c:1664 [inline]
                    exec_binprm fs/exec.c:1696 [inline]
                    bprm_execve+0x93d/0x1460 fs/exec.c:1748
                    kernel_execve+0x844/0x930 fs/exec.c:1892
                    try_to_run_init_process+0x13/0x60 init/main.c:1512
                    kernel_init+0xad/0x1d0 init/main.c:1640
                    ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
                    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
   SOFTIRQ-ON-W at:
                    lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
                    __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
                    _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
                    spin_lock include/linux/spinlock.h:341 [inline]
                    lock_list_lru mm/list_lru.c:26 [inline]
                    lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95
                    list_lru_lock mm/list_lru.c:154 [inline]
                    list_lru_add+0x46/0x260 mm/list_lru.c:208
                    list_lru_add_obj+0x191/0x270 mm/list_lru.c:221
                    d_lru_add+0xd6/0x160 fs/dcache.c:497
                    retain_dentry fs/dcache.c:779 [inline]
                    fast_dput+0x303/0x430 fs/dcache.c:866
                    dput+0xe8/0x1a0 fs/dcache.c:924
                    path_put fs/namei.c:717 [inline]
                    put_link+0x112/0x190 fs/namei.c:1196
                    walk_component fs/namei.c:2284 [inline]
                    link_path_walk+0x1299/0x18d0 fs/namei.c:2644
                    path_openat+0x2c3/0x3860 fs/namei.c:4826
                    do_file_open+0x23e/0x4a0 fs/namei.c:4859
                    do_open_execat+0x12b/0x580 fs/exec.c:781
                    open_exec+0x29/0x40 fs/exec.c:817
                    load_elf_binary+0x1aaf/0x2980 fs/binfmt_elf.c:908
                    search_binary_handler fs/exec.c:1664 [inline]
                    exec_binprm fs/exec.c:1696 [inline]
                    bprm_execve+0x93d/0x1460 fs/exec.c:1748
                    kernel_execve+0x844/0x930 fs/exec.c:1892
                    try_to_run_init_process+0x13/0x60 init/main.c:1512
                    kernel_init+0xad/0x1d0 init/main.c:1640
                    ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
                    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
   INITIAL USE at:
                   lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
                   __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
                   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
                   spin_lock include/linux/spinlock.h:341 [inline]
                   lock_list_lru mm/list_lru.c:26 [inline]
                   lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95
                   list_lru_lock mm/list_lru.c:154 [inline]
                   list_lru_add+0x46/0x260 mm/list_lru.c:208
                   list_lru_add_obj+0x191/0x270 mm/list_lru.c:221
                   d_lru_add+0xd6/0x160 fs/dcache.c:497
                   retain_dentry fs/dcache.c:779 [inline]
                   fast_dput+0x303/0x430 fs/dcache.c:866
                   dput+0xe8/0x1a0 fs/dcache.c:924
                   path_put fs/namei.c:717 [inline]
                   put_link+0x112/0x190 fs/namei.c:1196
                   walk_component fs/namei.c:2284 [inline]
                   link_path_walk+0x1299/0x18d0 fs/namei.c:2644
                   path_openat+0x2c3/0x3860 fs/namei.c:4826
                   do_file_open+0x23e/0x4a0 fs/namei.c:4859
                   do_open_execat+0x12b/0x580 fs/exec.c:781
                   open_exec+0x29/0x40 fs/exec.c:817
                   load_elf_binary+0x1aaf/0x2980 fs/binfmt_elf.c:908
                   search_binary_handler fs/exec.c:1664 [inline]
                   exec_binprm fs/exec.c:1696 [inline]
                   bprm_execve+0x93d/0x1460 fs/exec.c:1748
                   kernel_execve+0x844/0x930 fs/exec.c:1892
                   try_to_run_init_process+0x13/0x60 init/main.c:1512
                   kernel_init+0xad/0x1d0 init/main.c:1640
                   ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
                   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 }
 ... key      at: [<ffffffff9a2c9540>] init_one_lru.__key+0x0/0x20
 ... acquired at:
   __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
   spin_lock include/linux/spinlock.h:341 [inline]
   lock_list_lru mm/list_lru.c:26 [inline]
   lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95
   __folio_freeze_and_split_unmapped+0x2ab/0x34b0 mm/huge_memory.c:3767
   __folio_split+0xae1/0x1570 mm/huge_memory.c:4033
   shmem_writeout+0x570/0x1700 mm/shmem.c:1630
   writeout mm/vmscan.c:631 [inline]
   pageout mm/vmscan.c:680 [inline]
   shrink_folio_list+0x3380/0x5240 mm/vmscan.c:1401
   reclaim_folio_list+0x100/0x460 mm/vmscan.c:2172
   reclaim_pages+0x45b/0x530 mm/vmscan.c:2209
   madvise_cold_or_pageout_pte_range+0x1f7e/0x2220 mm/madvise.c:442
   walk_pmd_range mm/pagewalk.c:129 [inline]
   walk_pud_range mm/pagewalk.c:223 [inline]
   walk_p4d_range mm/pagewalk.c:261 [inline]
   walk_pgd_range+0x1032/0x1d30 mm/pagewalk.c:302
   __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
   walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:714
   madvise_pageout_page_range mm/madvise.c:620 [inline]
   madvise_pageout mm/madvise.c:645 [inline]
   madvise_vma_behavior+0x2883/0x44d0 mm/madvise.c:1356
   madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1711
   madvise_do_behavior+0x386/0x540 mm/madvise.c:1927
   do_madvise+0x1fa/0x2e0 mm/madvise.c:2020
   __do_sys_madvise mm/madvise.c:2029 [inline]
   __se_sys_madvise mm/madvise.c:2027 [inline]
   __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2027
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f


stack backtrace:
CPU: 0 UID: 0 PID: 5949 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_bad_irq_dependency kernel/locking/lockdep.c:2616 [inline]
 check_irq_usage kernel/locking/lockdep.c:2857 [inline]
 check_prev_add kernel/locking/lockdep.c:3169 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x2a94/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
 __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:341 [inline]
 lock_list_lru mm/list_lru.c:26 [inline]
 lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95
 __folio_freeze_and_split_unmapped+0x2ab/0x34b0 mm/huge_memory.c:3767
 __folio_split+0xae1/0x1570 mm/huge_memory.c:4033
 shmem_writeout+0x570/0x1700 mm/shmem.c:1630
 writeout mm/vmscan.c:631 [inline]
 pageout mm/vmscan.c:680 [inline]
 shrink_folio_list+0x3380/0x5240 mm/vmscan.c:1401
 reclaim_folio_list+0x100/0x460 mm/vmscan.c:2172
 reclaim_pages+0x45b/0x530 mm/vmscan.c:2209
 madvise_cold_or_pageout_pte_range+0x1f7e/0x2220 mm/madvise.c:442
 walk_pmd_range mm/pagewalk.c:129 [inline]
 walk_pud_range mm/pagewalk.c:223 [inline]
 walk_p4d_range mm/pagewalk.c:261 [inline]
 walk_pgd_range+0x1032/0x1d30 mm/pagewalk.c:302
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:714
 madvise_pageout_page_range mm/madvise.c:620 [inline]
 madvise_pageout mm/madvise.c:645 [inline]
 madvise_vma_behavior+0x2883/0x44d0 mm/madvise.c:1356
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1711
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1927
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2020
 __do_sys_madvise mm/madvise.c:2029 [inline]
 __se_sys_madvise mm/madvise.c:2027 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2027
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8b7939c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffefe994ff8 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f8b79615fa0 RCX: 00007f8b7939c799
RDX: 0000000000000015 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007f8b79432c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8b79615fac R14: 00007f8b79615fa0 R15: 00007f8b79615fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

