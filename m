Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B169C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6282B6B009F; Tue, 11 Aug 2026 00:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8F06B00A0; Tue, 11 Aug 2026 00:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EDC66B00A3; Tue, 11 Aug 2026 00:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20B156B009F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:39:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F2971A0341
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:39:17 +0000 (UTC)
X-FDA: 85087734354.20.893D63F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7859120002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:39:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JTFIQ0uP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786423156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqyB7l5JARgmuNwy6huEPya9hEyjEHfHRNvZHwghGkQ=;
	b=d3Rhk2/nVWqMRe3uiO+j4rN6SGPCss2iwHPczyLP6EgBLyAJMZppPCU2pxynC1QQHtCnWC
	03nrnVdZD3cWpaNF08MFxOugd5SVBwjVH0S59DtjrUdAbgW6J9PWQK6Hle9KCT6unHnxSW
	F6GXKRftgPSnEUGYmcLZkWYGiHGEgCs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JTFIQ0uP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786423156;
	b=jYcxHuKNQiRuEq57bMR1iOs4ApdBgA5lIejVceSGwxzp7YPkUITyGTDjGnMO3As3a0P5dE
	FgEOt5/pgHgCz2gjtjcXI72VLujOeJAltzPjTRXylGNbjveLhVyv68sDSiU93MTtTnWKpP
	yxEWmHGSL/VbDmV2lz49Y3iqF9/HmSg=
Date: Mon, 10 Aug 2026 21:39:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786423153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RqyB7l5JARgmuNwy6huEPya9hEyjEHfHRNvZHwghGkQ=;
	b=JTFIQ0uPxQ6htOgyGyLO9f5mv2ThRC5UhxtwdkaQBo7eC6lQTEeqmEpko5GXrWhHeSAxvw
	x7RRUNePtngG2BA2XFWpnWzObQqPBqcBzjl8Ur65FuvgSOfsBBfyd7hkXKl/+Ud3a3zY4R
	eVj+P855KSBT4zwD5ewtl0zObRMmvg8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>, 
	axelrasmussen@google.com, baohua@kernel.org, david@kernel.org, hannes@cmpxchg.org, 
	kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, syzkaller-bugs@googlegroups.com, 
	weixugc@google.com, yuanchu@google.com. r: Yuanchu Xie <yuanchu@google.com>
Subject: Re: [syzbot] [mm?] WARNING in set_mm_walk
Message-ID: <anqnAoFUUESi5Qe7@linux.dev>
References: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
 <20260810174852.aca0f73ab7ad71c70dcdefda@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810174852.aca0f73ab7ad71c70dcdefda@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C7859120002
X-Stat-Signature: jkqcruf85nngkkgysacqhbhsfwn7wkx1
X-Rspam-User: 
X-HE-Tag: 1786423155-779924
X-HE-Meta: U2FsdGVkX19iMuAq2sEa0hIsufXZWe04qkt2cssFcKJBnW/5d1Z1iuORdqfHqjqAdxCEBTdO/tuw4rkCf8Jplw54PgP8/mm2UinorrqlVCDCLRuMAXeb2iV2FR2ZRu7IwJfWPS7enEyheToG3xbFO3K36ux9Idy7kFOL6lPyLcjAd2+iOlUvuZ7D5GZBBnTh51bXHOELReV+Uj6txp+c3eSone+usAklF/Z+GGVnEaE706Tb9cK9ZmvTVD+0A+G0/mR1VVEo3D9vPM2DRpI4n+XimNZrBUVqL7m6XRgBkhjpGqRsmW6oOgkDkMZ9L2VjNMtC/XTxpNWUm0XY5+wGk9xztHPDEdFhfm/k2XNLkv02XZq9W7kbIvw6mfXrFHC3QToE/uFjqdLsm9Xrl6/Gp7W11featFblCSha+uCHpvKEZTxEz6+yLDe518BvesIUwgo9rmm7uOFqYXcCs2PJV0augtmsUnnL7mtkQv7aaOkbF/U5JTr2ocAHkRQdARr5+zmams3oa49ylHvV5zIyR6LLZ5aHw/lR3kfeG7nPV/gpzyjwYFQ+P4tt0Mt17+NdtEkFcFfvQiawngasBuKCc+CeBHB64v7b0sMM2SslMS0oqrunAXdI8Tgawmt3gZmzhW5ZAbJ7bE1erWvEvo7a/kXy5Y9roh61ppx/RZO5szBCjvFxEYfe73VidaAfGvkAv012sxAQ9RRzjpqNGVu4q9fYmEZ1uLt0pPSQA4slezIKtnD5KLWGYqcIvGNpFxi2BcmygfHwCjCQf70SDaFbIOyqunF+m8/5RaVUzQH1ybf609cyagNM4Fnx/LzN6Wv8jnD2D8FzFZbZjlCUu7yuRwCCibZfl08lToLY6PxVGT5CpjxT00UZl1x5W9OP8n3bUaBGlrGHBW5bn96rVkD7bJhHo02kG+JTQC+9PjpYNC31AVlMh5fIkL8o0lq8CSTg/whuKppv9dqUb8UjtdI
 oqjpmd93
 ScY+5lTEKPeFAol090qCLZaTjRmyBYojZGjYxZWnyNfcqZgr+PwzW0TVJ6HeQatR+JVhgfLdHIMe5NB3knCA0tCk6i1wC6SpEzJcUbUtodTrfI2slM0fjFnRFNqpmptjgGSflRO9NMbBpVPvZJ0u2hoNPG8Bkx5YQI8N5ibPCaZBDMWT+X43stZ4F8R5OckjuRO0wSZvHDbFM8ST1Pw/hQAGx9PWPkndgmeig9QWOIw0s3ljSPTmFvBifWEDvMXI/PltljIN5fcr+6Dsin0lAX7ebqYxSw1rFEO2xzi8iVZBS3AARhuhZ1lHNfnKeaKs7U7ysZVffCtW9D+Z/vln8LdVpzMoxo0H/F9F6tEBH4c3gkaqDKlmHpHBQzuOGn8cCayB3Asd5WRfY/2zsKTD82vYKq+FPt99wZSA6DWc2/a4EUQ1QnLFf2YD4j7jXf+gF7i4fRZ8LHdrT+BNNc1YXKia1cqX7obNRDiE5uebmcsCIcGWtRtNv+baYNDiL0YhK9R8QACzOxM8R4pSLTxFxf4bfPHOAiaYYe+uv9v6p67H0/P25o+RpD6JUb1N907JqrLQ2Hkef77z+59ZFfvJG45mzJBo6vvbTmVpKWNvhrW+SW12jWdHEUFVq85HLZr5pzrIjX9EzQDeWYzkK6lXpU55Fze8knAF39PnRiQMrHIeC5dio/WoRtWwveZ/8JRgkXWJPBmEccAqYaBdkiplafW/8y+x2rs+VC0yPublaVYK60fSf31TsqyL4tuXjpeZlOewjNsCAFmgRoqGLSUuhF4+XPfnLjRtArF3TNEdEb9Jd+VHadewYm4aykVTPFQyVyL0/jBVlL9DX+g/OsEPywqDV9wRy9pR2rtu2NiUmsSpxiFxiAmy1rnalKn41F4d03gF9Sbon7VFt7HCyB0PfrlUNvIYw0PjZd73AnsSSkCLpU2jMrEBvM63l0i87FpYjAamPFLR0sIFL3HwgK/3zjaeh7nII
 U1Ptw1hT
 nqN/Xc8MtuAU4qnofKi6tWaTG8sFUyHFWCiOEYC2cPyEhWYs/gQC5zb4f6l3eGDo+4uaY2tJQZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 05:48:52PM -0700, Andrew Morton wrote:
> On Mon, 10 Aug 2026 17:13:29 -0700 syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    562bfb501c54 Merge tag 'integrity-v7.2-rc7' of git://git.k..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11a8cbb9580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
> > dashboard link: https://syzkaller.appspot.com/bug?extid=12ee2725d5fde63a9c96
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Thanks.  One for the MGLRU develoeprs, it seems.
> 
> https://share.gemini.google/Wg4a5ns7E0LF might save a bit of time figuring this out.
> 

This is memcg-v1's soft limit which is deprecated. I am more inclined to simply
remove this code instead of fixing it.

I will take a stab at removal.

> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-562bfb50.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/9cbf6ef0490e/vmlinux-562bfb50.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/7ee52864c79a/bzImage-562bfb50.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > current_is_kswapd()
> > WARNING: mm/vmscan.c:3800 at set_mm_walk+0x210/0x270 mm/vmscan.c:3800, CPU#1: kswapd0/110
> >
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 110 Comm: kswapd0 Tainted: G             L      syzkaller #0 PREEMPT(full) 
> > Tainted: [L]=SOFTLOCKUP
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > RIP: 0010:set_mm_walk+0x210/0x270 mm/vmscan.c:3800
> > Code: 13 00 00 4d 8d 7d 08 e9 f7 fe ff ff e8 79 f5 2a 00 e9 b7 fe ff ff e8 7f 6b ba ff 90 0f 0b 90 e9 d2 fe ff ff e8 71 6b ba ff 90 <0f> 0b 90 e9 74 ff ff ff 4c 89 ff e8 80 f5 2a 00 e9 4e fe ff ff 48
> > RSP: 0018:ffffc900027772b8 EFLAGS: 00010293
> > RAX: 0000000000000000 RBX: ffff888024934a80 RCX: ffffffff824ff8e8
> > RDX: ffff888024934a80 RSI: ffffffff824ff96f RDI: ffff888024934a80
> > RBP: 0000000000020000 R08: 0000000000000005 R09: 0000000000000000
> > R10: 0000000000020000 R11: 0000000000000000 R12: 0000000000000000
> > R13: ffffc90002777c38 R14: 0000000000000001 R15: ffffc90002777c40
> > FS:  0000000000000000(0000) GS:ffff8880d5ed8000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000001b31923ffc CR3: 0000000109695000 CR4: 0000000000352ef0
> > DR0: 0000000000000005 DR1: 0000000000000005 DR2: 0000000020040004
> > DR3: 0000000000000056 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  try_to_inc_max_seq+0xf0/0x1090 mm/vmscan.c:4023
> >  try_to_shrink_lruvec+0x4bd/0x6b0 mm/vmscan.c:4977
> >  lru_gen_shrink_lruvec mm/vmscan.c:5128 [inline]
> >  shrink_lruvec+0x31e/0x25b0 mm/vmscan.c:5888
> >  mem_cgroup_shrink_node+0x227/0x6a0 mm/vmscan.c:6753
> >  mem_cgroup_soft_reclaim mm/memcontrol-v1.c:312 [inline]
> >  memcg1_soft_limit_reclaim+0x2d5/0x830 mm/memcontrol-v1.c:362
> >  balance_pgdat+0xa11/0x1f00 mm/vmscan.c:7177
> >  kswapd+0x556/0xb50 mm/vmscan.c:7462
> >  kthread+0x370/0x450 kernel/kthread.c:436
> >  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >  </TASK>
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > 
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> > 
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> > 
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> > 
> > If you want to undo deduplication, reply with:
> > #syz undup

