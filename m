Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1910107527A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ACC66B0442; Thu, 19 Mar 2026 04:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3837F6B0444; Thu, 19 Mar 2026 04:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1126B0445; Thu, 19 Mar 2026 04:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B47F6B0442
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:53:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE1941A0436
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:53:46 +0000 (UTC)
X-FDA: 84562199652.07.1496A4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1A8331C0004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:53:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ma9gXRkp;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773910425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHWa9zaqyeI2x3QHVWvSs28BEFPKIuq5I5fptgYswcE=;
	b=Du0KjJNeb6JWeJ/zH8LiJ0tzl1+DrnFSIrHhzYGsG/9MNu1pqCnNwaYXYlWUz3rrovjzxg
	N2v6CgejfuUGPNha7SOQfj1Vx3jcVryA6+uHZk3iWDwF1LcvBEuis//N+/MiIQG8438eBd
	iwMvGQxRPIvRN2GoFFKWXb8c4gAUKyM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ma9gXRkp;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773910425; a=rsa-sha256;
	cv=none;
	b=3uXyvy6btE81TXUawGm2qTDPFpuwCNcVuU9dpysqx/Pau1Vnn4/POqpbExQuWw69oCrA/S
	WkACLx2S2pvn1lQq2+t5HfoPzJbbQKwzBb6kPEL+ydsvTB0Bz7wJAAjjBiXZE2V/0KYspC
	Px0h2+bvIlNLKwNBojjhSYxhmknWMJE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BDA843744;
	Thu, 19 Mar 2026 08:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9837BC19424;
	Thu, 19 Mar 2026 08:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773910424;
	bh=b6jw1AoG/ZY7qD5fzAagFDq+iHQYA+OyAMrY3lUNXsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ma9gXRkpYVYc5+8G4bgUa9aIWqZInDmT0nwCKMYS5VT8VBepeW51CUFD0W0iyT4YW
	 l+ZPQ7XXqqGDBJ1hmdxzricARR1wNxgRmkeMnQWPlhgmk93IPZreEg2FSXup8ARS5G
	 l3t2aPdNJNNWW+Km+p4qTymeZ3AF01+3e2DYpGVEJr564I8BXJke6H79Bs2dAnWWqT
	 NKcUGKBWN6verPWBGDGGa+ztmRknNvDya5Z36vUYmOeo6IrW50jq2/mQ6JCzgPt4T+
	 qV2hgAS0VMVyNZ4m9HDF4uYMwsycd8VQYPLSRg7zwlGb87MGf1VOU9+wXZw4x5xHC2
	 xjK/HdWw8TGPg==
Date: Thu, 19 Mar 2026 08:53:38 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>, 
	david@kernel.org, willy@infradead.org, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Message-ID: <10e5f1d6-077d-4783-aa16-6c8b98cb9e74@lucifer.local>
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
X-Stat-Signature: xt8ibunka3yjk3te1ym9yxppoabsgspa
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A8331C0004
X-HE-Tag: 1773910424-148825
X-HE-Meta: U2FsdGVkX180RRHVKdoGes6jCMZt4bpG2dFXBpfd81mYnvvSsIYC0jc+Tuj1Nl89boycFEKMpp2SqfQCd1j2HFrerTmXNtc7xWG+DEDDvxArhc02Fdtxb3pzQ3e4EGEFIXj2WLFlm6eurdTKFvWdApfydJ/BjOEwRM2ShTkh6/Ncf5gmO1jvyBrxUFwyxWIV4dBqiXFgT+rOvEKS61HOfhUhEmxl1Ngb8zHIpmTPg4ZtWgXiKSoxHWM53kWMu85pu1Gm1KBG04BHHLhua0VYHgaXo9abhVKPkXNMzuKzfnR27szACsRthP7x+Ql1Y6iJfIcSaosNnuS9mGudBZyQqexU0PoicbIOc/sNkh+fGlpsDbqv0LO0x9E77dI32rmrfgjJRyVThSO9zJsZdxxRtmtiLxvFT8SOxayEeQHXKm2b0E6N4j00jyRKWdmBwBS898DZzalfqQDYZ0oVFmXBECSB37eIrSZcteYfMmcu2ggOwkgY7ti2OfSP10yOGvBmMbbviIrDHexq9xScTuia989RDquSaw2DqPRZZ9AjFSM6A+X/nHyY5foIGfBov8KGvrPZtaOR22DPg9ysDTu0TtiskO0VzHCWH6WcmGSLpZt5d/bAQqUuMLeER6lyommlFIe7r9hRmeDMRtB9NNqHbBSKi4ZlfOA8G1p66CvURvY02pkS1Fb+J/EmOqLmfRBfOpsKKnWjas8PT3xk/DxfQ3fJoiSF5+77G5WfG6BvsEHiV8uhu9W2KQOquu+HUjZOuESUFsx2SAxjtZB3rekzIWE6rOeVIC7kGtqQN5F4fhcPCR9mPFsq6PUJUANJKiRZ4F7WfXVYW+04wM+xKWB5A4+bmkrw/3/9H8MiCkq4eP3f7Xwp8YoMMRLLqkJKIEfWUU5VobOEaHQE4+WbWCEuO7RqI6yjOJzDpxaAHBp6P3EOiMkoibbUrPmDQAeQHxS7v0u5HOpw1jw02PICXZ9
 L7VMzHJO
 xed+hMq7dy63baGZpXUIfV3rxzWw8IfxKQsoTROhcOESo4bgO6ue7Cb3ZVXR8nuB236AAY6VFqOYewJz6qrqp2RKnQylBRsk78s8eY27AozoSIXpRzHnmNNjYRMflgMbqYInpEyZXjM1VRk5h6qQE3eeoQBMFpDma23zFy2RVuRXvHkE7KnXy4lJ2856NzA8cJ6EMNFGTuR3gMWiXklENhJG326QYzelww5+2IYpuNRsUQW6G0yL+p1L0QmDFQ154LQxdH632b4D0ybQPgdIe514r/kM5wVkx0lzfSfokjSh8QUXAZf9hR6LQKU2pIP29a+YzCoackC4Sw9XeHIynmNpsGgvl2bIysViNbPd5BRoWz1IJBLPMd4FuV7POBSJswPOInJ+rt+imgmiYXZyOcMoYNWTRKJzAUYLUghxHVcm6iAd82EJjKWPx57/OE/eoiTRzqbpYM95dv7O/p59fjlwU+OPK4DIzuQT8idjXLy1KN4fQ6Vs1JkjPSW+RFO/5yzY/cRA0KBzedG/1SD+edUQj73CswGZmLoX84mq7geGPuMsSQLuI0upsw+Z4TaVtJnAHZ346R7OEY15wOy7s9p7qMMGoaf5kNdcW8mZgeB/BUYfCYlfMk4u1lqAyTaHjR+WDNzZTrvtVHIpWORFsz3u9qgTeEuHiOoVs9qzDC8M/KwAHu3/SZaIWJmHvgvE6is/jMAWImH1wbDjBPyW/20b8SDmV4R9oGZ5YLKsLsDBt5KkXlL+mfzY8EC4CYeCH7JyOsVgthekWhQ4/sM8+LIePXRm58lL6M8nYLTPjPy6rwiGYLGaPnp9pJxCVSMWr603OpFdGmbsPPdDy61/QQPQAcLv7ymbfGA/1qGfxh1GZ9JBeJMk4Q2jf2qaJ9nAVlNOI2Vy3cgoNKlIfmR7oJ+Qf/rJkNaLVizxu6jlM5ZBK9Jr/ILNwJXLPrUotKYHOoITTaIIKPF3a3ncYyQhJI4Gh0lQK
 jwAPOtGN
 OgbP23Lg3N7yDTi6eSrFahEmDeSOOQi0llsUZ7Q1X6EFtPajZZBMngg20L7VOZXzU6NaAsKoomD1SgxFw7i8bXhEPBdo16JQxzDBLvIBwxE9qwtDDM5CJVlEL9j57zt0ahwKNADDeEkCrDVRTNdHqQnGvhT6GXo5QrHQ7iOZxyz8Go0B4rCp/hmZJJlvo3Qdo0efBNEGJ1Gi/HlDHsBT1yutT3iKGGWCcYdJO5qfNUzo607NEqKoIoqNXx7Oq0Hm/y1YIyM7gJk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 04:05:38PM +0800, Lance Yang wrote:
> Ccing Willy
>
> IIUC, this is a dup of the earlier report[1], which I looked into back
> in January. The root cause is the same: collapse_file() calls
> xas_lock_irq() without resetting the xas state first, tripping the
> XAS_INVALID() assertion:
>
> #define xas_lock_irq(xas)	xa_lock_irq(XAS_INVALID(xas)->xa)
>
> static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
> {
> 	XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
> 	return xas;
> }
>
> Added by commit:
>
> commit 43b00759f21b10142094d1ae5ff65cbb368953a3
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Sun Dec 14 10:53:31 2025 -0500
>
>     XArray: Add extra debugging check to xas_lock and friends
>
>     While tracking down a recent bug, we discovered somewhere that had
>     forgotten to call xas_reset() before calling xas_lock().  Add a debug
>     check to be sure that doesn't happen in future and fix all the places in
>     the test suite which were carelessly doing just this.
>
>     Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>     Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>
> I posted a HACK fix at the time[2], but David pointed out that Willy
> had mentioned it likely needs more thought[3].

Hmm we shouldn't leave this bug in place while working for a fancier fix??

Can we get _something_ going as an upstream fix? We can improve whatever we do
later right?

David, thoughts?

>
> [1]
> https://lore.kernel.org/all/69757ea0.a00a0220.33ccc7.0017.GAE@google.com/
> [2] https://lore.kernel.org/all/20260125121001.32733-1-lance.yang@linux.dev/
> [3]
> https://lore.kernel.org/all/7bce9231-714c-424a-a4e3-dd42734fb767@kernel.org/
>
>
> Thanks,
> Lance
>

Cheers, Lorenzo

>
> On 2026/3/19 15:20, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    95c541ddfb08 Add linux-next specific files for 20260316
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15ccc216580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=ed431987028345c6
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8961cb270ae74b4129fb
> > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f778da580000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cc006a580000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/c40f27ad73d8/disk-95c541dd.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/bd811888f684/vmlinux-95c541dd.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/3b72363d7dbd/bzImage-95c541dd.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com
> >
> > node ffff88805d558b00 offset 0 parent ffff88805d558840 shift 0 count 3 values 0 array ffff88807a8195c0 list ffff88805d558b18 ffff88805d558b18 marks 0 0 0
> > ------------[ cut here ]------------
> > kernel BUG at ./include/linux/xarray.h:1441!
> > Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> > CPU: 0 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
> > RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
> > RIP: 0010:collapse_file mm/khugepaged.c:2055 [inline]
> > RIP: 0010:collapse_scan_file+0x4f98/0x5230 mm/khugepaged.c:2404
> > Code: ff 4c 89 e7 48 c7 c6 60 b2 dc 8b e8 82 62 f1 fe 90 0f 0b 48 85 db 0f 84 03 01 00 00 e8 71 e5 8f ff 48 89 df e8 a9 20 7b 09 90 <0f> 0b e8 61 e5 8f ff 48 89 df 48 c7 c6 60 b2 dc 8b e8 52 62 f1 fe
> > RSP: 0018:ffffc90003826e20 EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: ffff88805d558b00 RCX: a13f20bd39c5a100
> > RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> > RBP: ffffc90003827130 R08: ffffc90003826ba7 R09: 1ffff92000704d74
> > R10: dffffc0000000000 R11: fffff52000704d75 R12: ffffea0001b678f0
> > R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003827010
> > FS:  000055557e3c2500(0000) GS:ffff888125437000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000020000000b000 CR3: 000000007ac66000 CR4: 00000000003526f0
> > Call Trace:
> >   <TASK>
> >   collapse_single_pmd+0x22b/0x4510 mm/khugepaged.c:2437
> >   madvise_collapse+0x34c/0x820 mm/khugepaged.c:2859
> >   madvise_vma_behavior+0x1094/0x4460 mm/madvise.c:1362
> >   madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1711
> >   madvise_do_behavior+0x386/0x540 mm/madvise.c:1927
> >   do_madvise+0x1fa/0x2e0 mm/madvise.c:2020
> >   __do_sys_madvise mm/madvise.c:2029 [inline]
> >   __se_sys_madvise mm/madvise.c:2027 [inline]
> >   __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2027
> >   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >   do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
> >   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f90d419c799
> > Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffd50711398 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> > RAX: ffffffffffffffda RBX: 00007f90d4415fa0 RCX: 00007f90d419c799
> > RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000200000000000
> > RBP: 00007f90d4232c99 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007f90d4415fac R14: 00007f90d4415fa0 R15: 00007f90d4415fa0
> >   </TASK>
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
> > RIP: 0010:collapse_file mm/khugepaged.c:2055 [inline]
> > RIP: 0010:collapse_scan_file+0x4f98/0x5230 mm/khugepaged.c:2404
> > Code: ff 4c 89 e7 48 c7 c6 60 b2 dc 8b e8 82 62 f1 fe 90 0f 0b 48 85 db 0f 84 03 01 00 00 e8 71 e5 8f ff 48 89 df e8 a9 20 7b 09 90 <0f> 0b e8 61 e5 8f ff 48 89 df 48 c7 c6 60 b2 dc 8b e8 52 62 f1 fe
> > RSP: 0018:ffffc90003826e20 EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: ffff88805d558b00 RCX: a13f20bd39c5a100
> > RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> > RBP: ffffc90003827130 R08: ffffc90003826ba7 R09: 1ffff92000704d74
> > R10: dffffc0000000000 R11: fffff52000704d75 R12: ffffea0001b678f0
> > R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003827010
> > FS:  000055557e3c2500(0000) GS:ffff888125537000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f8156602000 CR3: 000000007ac66000 CR4: 00000000003526f0
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
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing.
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
>

