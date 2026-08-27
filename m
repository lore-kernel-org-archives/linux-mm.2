Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC14C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0576B008A; Thu, 27 Aug 2026 12:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3811E6B008C; Thu, 27 Aug 2026 12:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295DD6B0092; Thu, 27 Aug 2026 12:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9276B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91664A011A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:33:25 +0000 (UTC)
X-FDA: 85147594770.09.279F82C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA1A640011
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:33:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lIAmOY8W;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787848403;
	b=5jb6AIZYSdDpuby/sUVc8E0f1pnI2vTUCjlk7uLBIZ26oSPHAuXhBwW4q0K2LU/iY6OTjR
	esTEmjTPpUAv2l/otSm959ALvSRMFcWMdukYCwsSwC6r9khPmtsPKd7cVNFrtpBu+q+sTY
	xhaKVJLI0RbvvZRUwNRKNhksFHdPABg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lIAmOY8W;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787848403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDF430L9eL17qkXvJWF4I/+5SoLvT5ASA6u8T+S5+DM=;
	b=rFT/+wHtB41x7r7EBNhBWSrgkE26+kqnq3MeHGO6EeunEgnMq1Q6G0OXHYRUVleWRHmK4O
	n76if+f1svUNmnu9RyCntJ3ujL0b6HlqBPYNsZZ8CVHNaWv/a0NjucpLRWFEIeHyoRNh4H
	4rlHXcM1kLQQtohlz8Gpf5YucvGRDao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 083124142F;
	Thu, 27 Aug 2026 16:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A251F000E9;
	Thu, 27 Aug 2026 16:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787848402;
	bh=vDF430L9eL17qkXvJWF4I/+5SoLvT5ASA6u8T+S5+DM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lIAmOY8W7LKUCKU2gMhg6cObfeD7bpLl8Jz8Ugv3lydn9tmYVzG6k2DPNOtqMwgwV
	 jnlBbEcCQDWiyrLzXBWOanA8LOejEtz+RQyATcoJPA0W1k1DbHppN5Xrl0fV87cWiu
	 8B0cvqZuWNDwdluVLu3TST4jSTNX0UTw+IZQxk2c=
Date: Thu, 27 Aug 2026 09:33:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+5c417b73ac02e0e352c4@syzkaller.appspotmail.com>
Cc: jannh@google.com, liam@infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in __split_vma
Message-Id: <20260827093322.f99541b28aad2a3c069ed155@linux-foundation.org>
In-Reply-To: <6a8ff666.27659fcc.2ceef7.000f.GAE@google.com>
References: <6a8ff666.27659fcc.2ceef7.000f.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA1A640011
X-Stat-Signature: bwaizs8pxfbg4y4grtfnx9qg4nc17fsz
X-Rspam-User: 
X-HE-Tag: 1787848403-840696
X-HE-Meta: U2FsdGVkX1+Sv9cczkjECNR7b4KPgHv9LHM63jyFlG38hwbqDm4TwlCFV7Fj+arSPTGFHrSaNQ6u0uScqS9wTry6mOfsHzXXbr7TOc0DgD4AMW76yLo5MEvAwj06zkJC16pUAEnszl+IfpwGPlDyN/e/DxY6SEKqquh5Y7Bbg2fE8iCZlXWI96vYVeKrFblgK7cTWuk1agJNcw7ipoq6RVqPYDZhr7JGfP7mQtEmEBdVHJjImBN5KZ8kq9kOv++/kc74ABQ3pudSbDGLYJ3qpEEQAKyaeM2GSPgFkd7sVGw76f/u26fv/oAVOyPR9RGpcKdMgAcrLM0sLb8/jYhMStYsvAoq6fYERuB6TpLKLkpUH1wCJoj4FSuSYwP5C/xvEALogO8Al3B/lJyHCL36M6cLByEEIFGSCZC0xnyS73XF1J01gDVtJgBTj1sFCOnYXE8p9na3sy/k0pR6qc8l6KFyH3VA1jeZvrqbBcMUtNIbPdui38ofKh28QftuvBH2O3e2yZEliSnNs1vQTAfdnYO3kPoesF7979NbWubFfPhGMFpF9lRCpSmiMHx0xNNF2AP2BAETh1Ur3zIT7dXSFATAcEPJS//Wl2I7e255oyMKViJkfQn5HzIXbp6JoHaSpUBmE+oeNgkkttUhAUNgMkAOOqTdtyHId2ESNt5XrK3S3XC6NFLV3mCyr9v2Ie48r5zks00e8qTu6FyZfwnFIdr3UYoxHOjd7u+59E2GFNorpVvuGaRCBP45ib/6KEd6r7B9x+b31ZZcz1OiwIdUuTKj/Hwkzbvu1+A99ND4jCqCAOG3viSxWn7PJTOB7rM1hwEnQr0agjeIRze1yV2dRzFH7lYhbyw05pMbM95VuzbUSCDHDA9UIDO5sSsACSTumcs/ycqpj8jTf5XiYcY5XY7iGSwnmeEqAf4Lll5wyYULmWCL694WVliMdgdO+FlaFZLCZz35tUTXrNk7Nlx
 m9doUHwW
 qYuutHGsoSzMfTMtTt9r/TXyku9XJFfJTox2YLYFbYGk+lJ0tEYke4wHD7BhrbyilvmAzT0jKuxffvX0hm/0iAHjMn9zVRsYh5IPNgNa7UXzLwzZhZjM3WCv6b+7NzQ/v55q3hRq/8BbcKcjTvTb8nknyBLiOds1OEPPY34N4E2T4prmf+OVFx/FHtZoCFnIo/dp3MtrFa50FXF9UP5Ikkd2MZN6fo29/r0Kmysf0w18LnOrhZCS0AAuOs8WLNRpMFYk31wjXXzrTnN6zm+2p7hRe3YWSTxoJx/dkwOSlE6c64MtonE3XKxeR9lfYLCssG3jtiq7Ln72O6q4t49jveTMyev1CPHkybASvc7pg5d1mVp3QOseP4IyoUpaKKB1uR14UB5Jpp+EAuSZQrSc+5CIIuFhpbMX1qW3SDN3e/nnhcXtoVgkvMweeZ+khoVy/7nlaRGCa/Zh/oD+A669cySdwKUlLIFZ7EzpDkL1UpJw23IXt4cA2CHQMEtbZWys3RrF4bnix54VO+x4+sRzgMsfm2Djn3VVa6YVb+hPiyRUOvIGBikg1U4Ay+unX82ZXuDJK1iRUuo5vHbLXD+SJ+ORNREmOS9PThAyF93xRTOKJP+KiF7H8AkDOakKMj5GttjqDaszq7ej8bFw63fCzYul/qT2YClHYH1wTaqKCxIdgkFZrLLF1IcBoN+hfGova6KqP3gAri4HN2i32HSLpK6BinGjaBuu29nmKaG96ZHCaA1CWodzT7mXGEXPtqQDPL6V6oB5pAKcB23XHDQ5WIefLOh/4PDZ6FTJXJJ4lKEounzWobCjPRCtaR5s8NGD7yB4yWM27jedWgc4jY5JWgqDujQvB/FN20llutU8yo3iCTadfK9ZcNI9UM0fUDwIZbZifrgMaP+CpAuMZlUoR0XSzk/ll4YSX1kGpu+wSwo/JRTXw68iO2WBs4L/g5RKCFz0iWoGpOxcIZqfjm79ywRKHcLSy
 xqpiYNJv
 8HLzATyGiTK3G6e6TtGHQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 01:33:42 -0700 syzbot <syzbot+5c417b73ac02e0e352c4@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1645f979580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
> dashboard link: https://syzkaller.appspot.com/bug?extid=5c417b73ac02e0e352c4
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104a0d49580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f35979580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-818bebeb.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6e4100526b12/vmlinux-818bebeb.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/723c4783ee96/bzImage-818bebeb.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5c417b73ac02e0e352c4@syzkaller.appspotmail.com

Thanks.

Hopefully fixed by the pending "mm/mremap: reset unfaulted VMA page
offset for MREMAP_DONTUNMAP".

https://lore.kernel.org/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org


