Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5498F5A8A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 18:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBAAF6B0088; Mon, 20 Apr 2026 14:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91C56B0089; Mon, 20 Apr 2026 14:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF1B6B008A; Mon, 20 Apr 2026 14:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E13C6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:09:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 445AE140B41
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:09:40 +0000 (UTC)
X-FDA: 84679722120.28.0567798
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F84940010
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:09:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of 34WvmaQkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=34WvmaQkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776708578; a=rsa-sha256;
	cv=none;
	b=WPyNE2p1Fsk1d99m3MwD7wtJO+Hv5bg5C2i7NHW7zFVNnL17BCD9Qwf/kHq02igEzbsSx7
	09WsVqstEzh8qDVoRShQz2QMHA/9gJtj/C9Xq+DXSq2TZBwZE3HCn26EvzOJxjDF3SEhXo
	IMRqzXRPrJ7X0gsc3L5uKWLOiTcD+V0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of 34WvmaQkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=34WvmaQkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776708578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=4NIQfN3DmsDKwdnjOyYbdUmi+3233KTMMvwmupv2AJk=;
	b=Vt6ve/UPH40QIHL1e/eagiwsrbPbVPzClI3Mm9y0uo6DGbp4E6pNBv4VGO4Ehkf7X8GwP5
	JRMCrHB2LxVl0szIW9xqS1y7QjRo9ZtvOhHS2O9IpPo5I0CbqcXoBJEMPzoMMpXW6FueMV
	FNqiF8NskP27iFWdvNlU+VunoiDIXWY=
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7dbe0e914adso4695604a34.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776708577; x=1777313377;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4NIQfN3DmsDKwdnjOyYbdUmi+3233KTMMvwmupv2AJk=;
        b=G12EQXiRn+UXMFRgDwvEKeAQNV/n4Yobnp5VWrW/CTGC0ITx4SYyBrzu9m173bS8oc
         tQqrZSF6ugz5cLBPijJp26snGyi6W2bVoeOIzqsegBEQb0KDLjuDuBjLuVQPzkpMmzdO
         EblE9jy/O6iYBRW4Z4dgZLL7HjvHzlzOKpfI5y5MBHXzSm70d+qb0MUoSRAa7Iu5N5Sl
         +izc6JTcYuMqsPRrvbQlyMTxwctB7s3IuCrpw5/w11qxZqBFf4PzteGkK/e4M1EJoL/3
         IAv/t+fNhiEeAHDKxHh9FhHdJ/isyQHeUcjCj5v7AWfPrdR67B9bkSZPU1kGCQO+mKeE
         BurA==
X-Forwarded-Encrypted: i=1; AFNElJ8lCjDfj7xcxerH7BOH3d8tQudKzQq+i2yKAxBvTC/OQ6ZxAmsBMAPQn5z0TjhlfZvE/xoeQEd9gw==@kvack.org
X-Gm-Message-State: AOJu0YziKz7x78+wyVput5HpZkxgxY1I40S1vKPDkR+lF3c6dr+K6RS+
	5g09A+K3K4rYIOigYlLyNONCv8scst6+Ci1q6G3BSoBGCzQJU12ScE7g6hU1c8gGnVp07+13kWI
	mM+CIdC6TDU6bFnd7hg7pDx33mrErh82q+oVaOmHViMaAFM2x7T0KZJg2Jjg=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:162a:b0:67e:fbc:de68 with SMTP id
 006d021491bc7-69462e7dbcemr7559850eaf.26.1776708577194; Mon, 20 Apr 2026
 11:09:37 -0700 (PDT)
Date: Mon, 20 Apr 2026 11:09:37 -0700
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e66be1.a00a0220.9259.0007.GAE@google.com>
Subject: [syzbot ci] Re: mm/virtio: skip redundant zeroing of host-zeroed
 reported pages
From: syzbot ci <syzbot+ci8c594ed0fdfcc0e4@syzkaller.appspotmail.com>
To: aarcange@redhat.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, chrisl@kernel.org, david@kernel.org, 
	dev.jain@arm.com, eperezma@redhat.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, jackmanb@google.com, jasowang@redhat.com, 
	joshua.hahnjy@gmail.com, kasong@tencent.com, lance.yang@linux.dev, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, matthew.brost@intel.com, mhocko@suse.com, mst@redhat.com, 
	muchun.song@linux.dev, npache@redhat.com, nphamcs@gmail.com, 
	osalvador@suse.de, rakie.kim@sk.com, rppt@kernel.org, ryan.roberts@arm.com, 
	shikemeng@huaweicloud.com, surenb@google.com, vbabka@kernel.org, 
	virtualization@lists.linux.dev, weixugc@google.com, 
	xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com, yuanchu@google.com, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4F84940010
X-Stat-Signature: b36jxb97edue57tgtit3y39qwdf8sr7g
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776708578-840357
X-HE-Meta: U2FsdGVkX190/nImDf39VyIKfPSGHJyXJrIDHZhlc9cfM1NNKyWOGF9pNuwKNIaDLjutg0U62N7Fqu7MBXBtjWyqHuVAKpsNzWwOGP1to5v9dvoS6C9FyoHgZonOdD1gjEfXkKT93a8Cw8/13TJ4WMahchKlh9snUUo8Fx3B02mjPnVGYAzwL3R8GWl6LO7i49qaNkAi9PaqrCmQ2QAG/y+7DgW1nL7J0SEioSkVgRmVwbyzDpTQIDYZZWkh/0KaVaefMk3TWYfCwRRPRq7Qq2IdWb13B7PzzTH2YXdhJD43J8R4Nd9MVVSkjAX4SP6+nSGv+VhEXYIKQNU2cb4S1E28SkwnuxQSiifnUbigKXF3zU4zMp6sq1DvtiGqKgXXAiiWOkQz2hnDfPcIaXUrbpl8be8EKhFGs+JXcI6PUNPx9HdT1iCZIYZSpDaMj1oDJhEagRoh7orA06Xtm3uOj+8hxlY9m/tbOekcYKkA2xGl4OllG5Hy25Xxpr2/JrFHjeYptu0PnXqowkTVD+tW/ZciV8GWaToLjIMve1CrcizPhJz1ANECZGJHlnResdqv71v07fTcnVGCQ8GZHv0tNLYD1pAQaSd7Fy/Xy5v7lT9ItUs/i9qtu4ISNe7vbLhxs6/MPjsb2OHbYBvU9a/cz9FJMkLcxZm17eND/3oJqo8R39TiCeKl+AHxHLtalw3UjemnQYyhTAGDorcADaGgRrBZk8aEBZoXvN1OvX/satT62dS4FpzMalijuysROPqdgz/I3necjdb+TYaYUHuMbr/KizPnM4LZ0KWPlTjm/sODQGoPxnv9kznHdUaKcEBb3RyUz1vH6NgdO65s9thGRhNG5CXCZUumzvVSt36oSto1NEIXL8RPuePUjRDZyBJVZ2zJBaJMmQDK6U3klrmkGwrI31WKZJf1X/Z2avBwhXUhUGh9mEFbsN5xp+JKGbJrPPpj4RHgAMCRuEs4rKm
 KKQFa8T3
 ruvWShTnIrZQ/Atx2VVLehe6OZ51aRgZMnPSzd5MDGpCqbb+iYkZv76KtzK7cmG3cCZ2sesxjcPUOVOphQWLxVzTbX6R8np2cyyL618Ye2ROElmp2RMN4ZtncN6ozJH/RlWUDubd1SwFwBGGKSNbTlIcprNAzhzX7x/UoYohHewEm3fDGdKp5NUobSpjtlZHh7hre6kGDPnJ7pSkfO+LcBWkNBw6USYelHpWTw2wsjENanSvAvqa/bdBkgCVWcF3csoXruhHGd7I7jA8kQ14QsStAg/9vToabn4YneE2k+p/f95roDX7xKl0J/lTOXFCZlnJRG844sAIbotUgM1J6byO/9qUyuqwEeUubW937jS5Nkeqoji+21bnA9thkSNCbArtpM+6HiKr8Wk8IRdMB1kYB7Ysa6n2ck94X17MgR/JdCbPmK2CNV62gZQefG16dENhgBCZySo/S9XprgpxrzvFze0siv4PkBcUkS7J8i9A/BiS1zVoF10CaAXBfMG2YEY65UD8gQDMU9iy4jNiaXAew7P4RIX4rrHdS6XiEYl8hK5D1uDD3wrlmhYjmp2a1MLI8f5YZZE3pJdjf52Ok5nXmLLfew568bMtqyjiKu9lI3KdTB6LUJfPBdKnk3/4d/ME+gqqNqkG5NQGcG5goE7MrbEMraIEcm5vrZf9c4jdceMWds0Tt1ltGmfmC0SExh4+X53e9Zyp/8RMF+W6VlQH4/IzzxypeR/z8QgZ6vChUhxgPXyaAOxnnPEQA7PvcDE2M+VH0PBEWFERwmzbRENtG6wgqLLT8bJP33V8nNLbWSvyzFQ9QNX5QyBmyG5mtO13jNvZ4FlCQFSBQWXVw4qHT5vVT+jK8YvurgcaxqOq//XhXE67JRqKr/gJwxtKlCflvomzkP2BJw3sI1DOIXsDC9z+U9YxuFY+oL1q1ypDtytD5r0OP0HJl/tQKQQDY1IRHLmma+QM/uwkkCgv13rQ0+0Us
 KAY5VqRx
 fJ1PZqGEKGXlcpOeLzqGul4YQvkMWzVlPGmxHlbaEB8kHYe56lVXRGjfHfotxhI60OwZmYrN670UV04l2s9RAiUsEbtyuYosBfC99PizCktD1fXSFHhkQZDuPoZcvizo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm/virtio: skip redundant zeroing of host-zeroed reported pages
https://lore.kernel.org/all/cover.1776689093.git.mst@redhat.com
* [PATCH RFC v2 01/18] mm: page_alloc: propagate PageReported flag across buddy splits
* [PATCH RFC v2 02/18] mm: add pghint_t type and vma_alloc_folio_hints API
* [PATCH RFC v2 03/18] mm: add PG_zeroed page flag for known-zero pages
* [PATCH RFC v2 04/18] mm: page_alloc: track PG_zeroed across buddy merges
* [PATCH RFC v2 05/18] mm: page_alloc: preserve PG_zeroed in try_to_claim_block
* [PATCH RFC v2 06/18] mm: page_alloc: thread pghint_t through get_page_from_freelist
* [PATCH RFC v2 07/18] mm: post_alloc_hook: use PG_zeroed to skip zeroing, return pghint_t
* [PATCH RFC v2 08/18] mm: hugetlb: thread pghint_t through buddy allocation chain
* [PATCH RFC v2 09/18] mm: hugetlb: use PG_zeroed for pool pages, skip redundant zeroing
* [PATCH RFC v2 10/18] mm: page_reporting: support host-zeroed reported pages
* [PATCH RFC v2 11/18] mm: skip zeroing in vma_alloc_zeroed_movable_folio for pre-zeroed pages
* [PATCH RFC v2 12/18] mm: skip zeroing in alloc_anon_folio for pre-zeroed pages
* [PATCH RFC v2 13/18] mm: skip zeroing in vma_alloc_anon_folio_pmd for pre-zeroed pages
* [PATCH RFC v2 14/18] mm: memfd: skip zeroing for pre-zeroed hugetlb pages
* [PATCH RFC v2 15/18] virtio_balloon: add host_zeroes_pages module parameter
* [PATCH RFC v2 16/18] mm: page_reporting: add flush parameter with page budget
* [PATCH RFC v2 17/18] mm: add free_frozen_pages_hint and put_page_hint APIs
* [PATCH RFC v2 18/18] virtio_balloon: mark deflated pages as pre-zeroed

and found the following issue:
kernel BUG in free_huge_folio

Full report is available here:
https://ci.syzbot.org/series/329d9cff-a0ad-46d2-8ff4-d9f4341a611f

***

kernel BUG in free_huge_folio

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      b8a5774cd49996e8ef83b1637a9b547158f18de9
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/60e99a0e-08bf-474f-b034-a8bfd2eb90b0/config
syz repro: https://ci.syzbot.org/findings/2868ce13-1752-4f9f-9aa9-c5ce89f01fc7/syz_repro

 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
page_owner free stack trace missing
------------[ cut here ]------------
kernel BUG at ./include/linux/page-flags.h:698!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6015 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__ClearPageZeroed include/linux/page-flags.h:698 [inline]
RIP: 0010:free_huge_folio+0xf93/0x12e0 mm/hugetlb.c:1749
Code: c7 c6 a0 64 db 8b e8 5c 9b fe fe 90 0f 0b e8 74 40 9c ff eb 05 e8 6d 40 9c ff 48 89 df 48 c7 c6 e0 63 db 8b e8 3e 9b fe fe 90 <0f> 0b e8 56 40 9c ff 48 89 df 48 c7 c6 40 64 db 8b e8 27 9b fe fe
RSP: 0018:ffffc90003a675b8 EFLAGS: 00010246
RAX: c71fb9abd148e700 RBX: ffffea0005808000 RCX: 0000000000000000
RDX: 0000000000000007 RSI: ffffffff8defcd3f RDI: 00000000ffffffff
RBP: 1ffffd4000b0101a R08: ffffffff9011ddb7 R09: 1ffffffff2023bb6
R10: dffffc0000000000 R11: fffffbfff2023bb7 R12: ffffea0005808008
R13: ffffea00058080d0 R14: ffffffff9a2e27c0 R15: 0000000000000040
FS:  00007fe11abed6c0(0000) GS:ffff8882a9453000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe119de9f00 CR3: 00000001ba914000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __folio_put+0xfc/0x4f0 mm/swap.c:105
 hugetlb_mfill_atomic_pte+0x130a/0x1730 mm/hugetlb.c:6294
 mfill_atomic_hugetlb mm/userfaultfd.c:601 [inline]
 mfill_atomic mm/userfaultfd.c:773 [inline]
 mfill_atomic_copy+0xe28/0x1420 mm/userfaultfd.c:872
 userfaultfd_copy fs/userfaultfd.c:1642 [inline]
 userfaultfd_ioctl+0x2c17/0x5130 fs/userfaultfd.c:2059
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe119d9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe11abed028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fe11a015fa0 RCX: 00007fe119d9c819
RDX: 00002000000000c0 RSI: 00000000c028aa03 RDI: 0000000000000003
RBP: 00007fe119e32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe11a016038 R14: 00007fe11a015fa0 R15: 00007ffe7cd6ce28
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ClearPageZeroed include/linux/page-flags.h:698 [inline]
RIP: 0010:free_huge_folio+0xf93/0x12e0 mm/hugetlb.c:1749
Code: c7 c6 a0 64 db 8b e8 5c 9b fe fe 90 0f 0b e8 74 40 9c ff eb 05 e8 6d 40 9c ff 48 89 df 48 c7 c6 e0 63 db 8b e8 3e 9b fe fe 90 <0f> 0b e8 56 40 9c ff 48 89 df 48 c7 c6 40 64 db 8b e8 27 9b fe fe
RSP: 0018:ffffc90003a675b8 EFLAGS: 00010246
RAX: c71fb9abd148e700 RBX: ffffea0005808000 RCX: 0000000000000000
RDX: 0000000000000007 RSI: ffffffff8defcd3f RDI: 00000000ffffffff
RBP: 1ffffd4000b0101a R08: ffffffff9011ddb7 R09: 1ffffffff2023bb6
R10: dffffc0000000000 R11: fffffbfff2023bb7 R12: ffffea0005808008
R13: ffffea00058080d0 R14: ffffffff9a2e27c0 R15: 0000000000000040
FS:  00007fe11abed6c0(0000) GS:ffff8882a9453000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe119de9f00 CR3: 00000001ba914000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

