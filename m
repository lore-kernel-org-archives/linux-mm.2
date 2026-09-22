Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B4D6C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B4376B00AB; Tue, 22 Sep 2026 14:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68BBB6B00AC; Tue, 22 Sep 2026 14:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8D76B00AD; Tue, 22 Sep 2026 14:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2456B00AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:37:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A49EC40577
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:37:30 +0000 (UTC)
X-FDA: 85242256260.23.9C9CCF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C8D7EA000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:37:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Sv0bq229;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790102249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mu0Q0Us5oqehuvN1MkgAhz++2hs8x498+OX/TvKYCac=;
	b=dEBmx6Dy1F3U7OwtSwV9svoOPs/xWln39cXQMJsFDOX8RICcxDnNjksEHPOioJpPNyjdT3
	v6lc0wHtKY8hTsZeHa3qKigW4Di2dMXOZaEEVoQtQK8sryf8peQaiizirUs7KE6xjqQpJT
	OfR1dDOF2s3vYPR3UhxQbsJIWN79dTc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Sv0bq229;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790102249;
	b=q6vxdlVOmN/mYO5dPcYpzpHNgdxcdU+19D0IQIxnBRpgnfFtTlYQKYtSGpgxOOhBBxsIPq
	uYovbbzDOFPUYG8dvfdviocPBO2GqVKmM+OssTRsJzGStCyhG6iOt2IfydY9budt/bj4B9
	M2wjd6EJ2qrVLO8b9bFtmrGFFXRBF88=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D701F600E2;
	Tue, 22 Sep 2026 18:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8531F000FF;
	Tue, 22 Sep 2026 18:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790102247;
	bh=Mu0Q0Us5oqehuvN1MkgAhz++2hs8x498+OX/TvKYCac=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Sv0bq2298nj6nPGBCihQSrJ0oYpmkFOyU8RxLXjYLyR4MWXYdp5+9SXKP6oXeLg5X
	 4w9gJru9toJU7XoWCRQn9a9mh8l6m8j74t230LFHTNJ2VrTW7sQYwDoj5xpnUEjYbv
	 oU/Yf+ziI7SHrOng48chSTms77tGwE6O0hB57S+k=
Date: Tue, 22 Sep 2026 11:37:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-raid@vger.kernel.org, magiclinan@didiglobal.com,
 matthew.brost@intel.com, rakie.kim@sk.com, song@kernel.org,
 syzkaller-bugs@googlegroups.com, xiao@kernel.org,
 ying.huang@linux.alibaba.com, yukuai@fygo.io, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in setup_conf
Message-Id: <20260922113726.0436e8d4e9e04c79b632f086@linux-foundation.org>
In-Reply-To: <6ab28beb.a6af0033.177e91.0020.GAE@google.com>
References: <6a8cdbd6.dbb3a75c.7844.0013.GAE@google.com>
	<6ab28beb.a6af0033.177e91.0020.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3r6dxiqy6neb77p5jnyihjugfreqkxmh
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C8D7EA000B
X-HE-Tag: 1790102248-256274
X-HE-Meta: U2FsdGVkX1/kik1SVoh/Wuhlj4fh5BG7gTBkyXgGFrQd+dqyEUNm6WNllu2FUAeXtOUuY2zIq+xWJtHWygQpsgGFBQWh0rwmUi5h41IbGkfhaWSLOXDHmo8xeZZUjcIuhsowpuSa8mkDd/ySDzJvWVTa90IhsYD9kaQktkb/GaqE1qixsuamN/tJ9pANIzUDjdQ5CusNr7pLE/+4bKB71bXqguWYUL1mU31UWuLF0ayuo4NJeF0+G3PTTc14ioLzRS2SjAEG5rrToty8LuWBm0iZ79lRZRGGzxAd8b26QcRFEclcaCwFdaBcX3rzmuoxkkMBfe2z34Sx2Vo6CSHFeqWkxy6sqhvjEjlBqWX27UnxubVVQlA4sW/v/XMiXUKbyKjgTuEvKGR2ctPdSukLTAQM+KrPnddZ17nBbpnSitr2Dn9pKFr5/ggq1ZR2N8oiBSeABrFY19NWGUyULZZJx5RXJ+UPph0J1iRu9zuqVBPj6DETqb0tbmcN0iPTuEdmeoDd4cgMAMg1GUOBy8D82dh085pTfkhge/T7XHoWQAbpGKVa0TrjTdiG6X8WthfyxyR6AM2o9lEE1xTgFXneoxLOMPg3FzsYone+o5UBMymW0D1NCS/NzI4dL0sVfwcK8z26aYY/CZmDEgTo9hkYwKMPdoBsITMwLp5EeVEcO/2v1OBbQ3zkNlR7BmDQP+LLq0X3jn9iJ3RqaDgXr3PA5FP0c/AYq7Fsfc3R+6Ax2o7N7NUCPLVWEephbz3ls23nofOMa5yWPm3xZ1JBwArYnAigChXFS+yks+atBl44jpfdgGACeyy+eRSgORKbOwCXPez/kqSKCjjC98BzI0Bp3WrNHbGPEYwF0FsSFo63Xq8+nJixpmFnP/Mo7UIbg3cWkEmboZ0KQxkzfhTl0BlPy7pmfOeZV4XDr/W0BAUR8L7IvWuq6Csz2IAkoQA0zp/uL4R1FTvucEgQ03l9FU5
 kXY13xle
 q0xuIFZXKmU/QGvAyKGBvJdq2ZhUsjDvs9FjJkCQh/YSyimq4VhSMOqRdkdAbxxtzaLlbi37tBi1qOyQEYq11MaytsM1Okohy7pXxTuuWy4ZdNtpGK8sZsTGIuGp0J9YWsMRLHdlbBI1mGSPgyRNr96QTa13zaDLkhhlyKw7LuFgizTIXfiYPiPrxQLxmCzBWTM9ZBWPDKCtg5WqLcPocTOj8gF9+LHxXg8c2VVwpPxg9f3LLZ1FoTv6AM5TVvzofcnSNOxZX1RhcCQQCzW//13sJpSY99jPGBKgUL78u7Iua36uwJwoakGD2eh+niim+b3jzIkpKdSNoYz7MrRy2MNaXQMOw1tUhhg2tu9RK9/nur5M9xGP1C+RZcN/ACOIObwoXSYwaiUSmGc1CAt/rrSP9IwVufaL8RzZRLm1wljLkzdSbyTxlHpVxDWGxlTHCmW7LnJxrtIt8ITMVeraUCns5Yw2oOG5AgwR0iNyS1xkFf1EXNvlQOq8ISzDP6qoiBdMIFjIy3c+ITlMgnzkwtwBlk5r1kLVqjjhsMKJ5yDTAPazu1krsCsRxsgbAbqg5F7BwSOg1hizK83+xFtnvwDHBNq6cHp4nmGE/l6e4xPd7fRhCAu/ySgD7n8pcHguptQK8rXQdQ+HeuQlZrEN7F858JM5ltBQobj4RIBOn9B3a0pzHZubCKkCUL7x4oPEFBltb7wScOJyf8M3DMajWEWwgKQMlgF9XaK2JCTXyaiQC7sp340ZoffYBqgrcJyFEOATGTPTk+1CWtYJB7dNWiz4q9ocAot+E6oAaBC8dbWnQxm6DgfYwBHB9w4j5BxFvmB6GtCFgBB0bPWlTktD0pBJ0AqaoJIOlyDEbr07AqQtSu/Bj9fBAsR9zemx9q8KToK7Ch88NnhoCEH7CRMHZ69flLs4h3U5jUU5lesEkXXyeZlZdbGKCLLH1GuDIlgNgs7MeGZNiBESPPB9IF3rmFadaobEB
 u4I2iTOi
 JTVCPAfgf/UWPCM+t61y3N97e5ETRWB534oaYDH0K6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


tl;dr: a raid issue.

more below:

On Tue, 22 Sep 2026 07:08:43 -0700 syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com> wrote:

> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    f0100363d8c3 Merge tag 'xfs-fixes-7.3-rc5' of gitolite.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17971805580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2b924f079099ba6e
> dashboard link: https://syzkaller.appspot.com/bug?extid=75f49ec552cc74d9d69b
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b20c5e580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10720c5e580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f0100363.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/18fb2734cddb/vmlinux-f0100363.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/5737b586e7bc/bzImage-f0100363.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com
> 
> md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
> syz.0.17 uses obsolete (PF_INET,SOCK_PACKET)
> ------------[ cut here ]------------
> 1
> WARNING: mm/page_alloc.c:5340 at alloc_order_allowed mm/page_alloc.c:5340 [inline], CPU#0: syz.0.17/5462
> WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0x425/0x5a0 mm/page_alloc.c:5397, CPU#0: syz.0.17/5462
> Modules linked in:
> CPU: 0 UID: 0 PID: 5462 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:alloc_order_allowed mm/page_alloc.c:5340 [inline]
> RIP: 0010:__alloc_frozen_pages_noprof+0x425/0x5a0 mm/page_alloc.c:5397

Here, core MM is warning that it was asked to allocate a crazy amount
of memory.  By drivers/md/raid10.c:setup_conf().

It's root-only so "don't do that" is a respectable response.  But
adding some sanity check into setup_conf() would make the fuzzer emails
go away so we can concentrate on real stuff.


> Code: 90 e9 76 fe ff ff 41 81 e6 3f ff ff ff 44 89 f1 41 83 e6 f7 a9 00 00 00 10 44 0f 44 f1 e9 45 fd ff ff c6 05 2c 98 38 0e 01 90 <0f> 0b 90 e9 8b fe ff ff 48 8d 3d ac 09 54 0e 67 48 0f b9 3a e9 68
> RSP: 0018:ffffc90003b87520 EFLAGS: 00010246
> RAX: ffffc90003b87500 RBX: 1ffff92000770ea8 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 000000000000000e RDI: ffffc90003b87588
> RBP: ffffc90003b87618 R08: ffffc90003b87587 R09: 0000000000000000
> R10: ffffc90003b87560 R11: fffff52000770eb1 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000040dc0 R15: 0000000000000000
> FS:  00005555836a7500(0000) GS:ffff88808c2c0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4a2c07ae9c CR3: 000000003bff7000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x21e/0x390 mm/mempolicy.c:2486
>  ___kmalloc_large_node+0x4f/0x120 mm/slub.c:5353
>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5385
>  __do_kmalloc_node mm/slub.c:5402 [inline]
>  __kmalloc_noprof+0x3fb/0x720 mm/slub.c:5439
>  _kmalloc_noprof include/linux/slab.h:995 [inline]
>  _kzalloc_noprof include/linux/slab.h:1312 [inline]
>  setup_conf+0x28b/0xd30 drivers/md/raid10.c:3855
>  raid10_run+0x1d2/0x16c0 drivers/md/raid10.c:3955
>  md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
>  do_md_run+0x35/0x720 drivers/md/md.c:6880
>  md_ioctl+0x1e2b/0x2610 drivers/md/md.c:8515
>  blkdev_ioctl+0x5e3/0x740 block/ioctl.c:798
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7efcb939e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd8c37e488 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007efcb9625fa0 RCX: 00007efcb939e159
> RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
> RBP: 00007efcb943506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007efcb9625fac R14: 00007efcb9625fa0 R15: 00007efcb9625fa0
>  </TASK>
> 
> 
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

