Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2F1F532EB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB336B0005; Tue, 24 Mar 2026 04:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892C96B0088; Tue, 24 Mar 2026 04:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781D56B0089; Tue, 24 Mar 2026 04:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6753B6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:19:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E656CD808
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:19:15 +0000 (UTC)
X-FDA: 84580256670.25.CD29A39
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7CEB5C000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:19:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FYPfKRmV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BUqUOoHO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0alcf4kc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c6c7u0Gf;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774340353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0v24mcFE85qpxQPbThZCDF5Q7VhydgOrbXZl2rGPaF0=;
	b=jThARsDS5mvWEH+RXy7QqpgaEnmb7sEVoIt9MJgWk4g7axAsmevfdTqQfFluLGCLOajYAd
	PmV8ZWyBt9qMBDT8eNjOd/RxyFmpg7jfViz2nl9WKZMhkh+paZTdsoqDI3NPrDk8mJDJz+
	ntg69KkUVuJyI2sj/I5u7+GJABn3pE4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FYPfKRmV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BUqUOoHO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0alcf4kc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c6c7u0Gf;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774340353; a=rsa-sha256;
	cv=none;
	b=1IIMFXz5ADbii5+kz7LdRpS7P/Etxnqf1CFV4EkSmrGhf5JAFDwBMvOOGE2PU5Lgty2+GV
	wZ5NDYCIIMWIh7gviy/vD1+95DomYBD2DxTE8h6uzg3uRVvnbh3KPxmyOwrRa4VdCY1aZ6
	Ztxkf2yfqwZrbgq2V0z+kyJuU8RXPyU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3CF6C4D1C4;
	Tue, 24 Mar 2026 08:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774340349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0v24mcFE85qpxQPbThZCDF5Q7VhydgOrbXZl2rGPaF0=;
	b=FYPfKRmVskJAoE3WXj2gQJhX7mfeQt4h0vLq5cExVIPaggZWrzsSxeLdrISOjgNBGvPsgk
	W8a6Avp2ZFT5BpNlf+/k8Xc201HU+kG205ZWZ42JWaC+Lbi/N5kp4rKfQ4tY3ac52ch93y
	SO5uaG/5pdOGnSRXn5RVk0smOSNPjSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774340349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0v24mcFE85qpxQPbThZCDF5Q7VhydgOrbXZl2rGPaF0=;
	b=BUqUOoHO3TrGxAalTQJlIg7fczQ2pO7JcXd1SVmygbsTpvgmxm4jLTsag7eGytWebm2YsU
	gpbjhqBvDWst4KAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774340348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0v24mcFE85qpxQPbThZCDF5Q7VhydgOrbXZl2rGPaF0=;
	b=0alcf4kcauIMGNMtht5o3fHbVbQ8dtGsaXRSYqOylRdRRnBBTuhMhImrHsG7pErQeO7/8j
	F0nToIjKFHcpDFFUPdXQBuCyIMspMVWc0hfmChHGqAT5FcIscbysPb2qo5wceAwnFlVjOs
	uUl3Fcg1zsQGw7N1vlggkeEAnk2q540=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774340348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0v24mcFE85qpxQPbThZCDF5Q7VhydgOrbXZl2rGPaF0=;
	b=c6c7u0GfZwkqj3ph1XDJYtNgdXmf8/bBrR+vsVN2AwVFG0l93oG+sfI7BsOySO4df+a9bs
	yQOJ/BJRssGFi/AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2693E43D38;
	Tue, 24 Mar 2026 08:19:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lKBkCfxIwmk4WAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 08:19:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CEF78A0B32; Tue, 24 Mar 2026 09:18:59 +0100 (CET)
Date: Tue, 24 Mar 2026 09:18:59 +0100
From: Jan Kara <jack@suse.cz>
To: syzbot ci <syzbot+cie6df483244df2ff5@syzkaller.appspotmail.com>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	luckd0g@163.com, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: udf: Fix race between file type conversion and
 writeback
Message-ID: <vurapuxxb2hn3j2ic4giupyktbo43xb6e6kbfekegxw7fxulxr@7ffmoq22lk5e>
References: <20260323162617.2421-1-jack@suse.cz>
 <69c1c09b.a70a0220.59f55.0001.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69c1c09b.a70a0220.59f55.0001.GAE@google.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: t5zb8tswa79fgd83d4t1h3ua5me4j3bm
X-Rspamd-Queue-Id: 7CEB5C000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1774340352-752323
X-HE-Meta: U2FsdGVkX194X3M5TujI0kYYYkIKGOVGFcAKM/zaGeT1aCXQD8ty1ZQzipBtp0bIB394vRCuRY0LXR5G8kxfOrcECWf8bYh02GASSJ8tuHxrTIHLaZNfLvmiHCfhntEodSopVCq7v0/PHTwgu4iuqZPgloxr4NZeuvHiVU2l7ORtHMosayNGqFv2PyDCd9uN0PF8HHsiVfURn57wVCgDkPDAUSXoNBQSbN9GwV+AagXB9xvQrCHI/pUqHWm2X54gZH8N/z9HLTdKsi6VqGckFZ6E7LXtfzYPb9DxDMB4Y7sBU2sZFRCXQ8fPgbx2bzpxE4Wow3XkuhVPoMDJ2YNtHhxLgWmLY5oN1b4oeqiASXobkOntfGZLahNlO68dpUr80GlvXLiHKTX/mWf9LSqXMsEZelJEtFEJvVdfNLdDlMqzhLCAkG3Ezc9mw5K+TXK+Qfl3gSbcTz2yAc7xSbGbfYZamIaFo4jvj2D6kwo4PH1VCmrANywPX11PwV8cxb36mOgAnqYQj+yvNhuyrhtDf1lbQohLyVqhIaL/yKqr5AW/gCDfSoU7JAjkL2zK4lGVX9FvIk+4lSHNOTjGcP2+XE8+L9ZUZHUtH2N4RqCyKRFTt3DrUXW043vpzlNzkL89RnpUOjca8AI4iZmACLPHUggWZcopQAORkOe+CHeC6KKVV2DHtWjQ8PJtjGC87NI4qist3ZrBEc+L5XLa1hYc2HMnIRVC91aN4+DZ1hfMXV567qE68c0UkfdxHlXaWbtbPU39vpwnjLRegH5MC76RdVc8W+ULT15CDoKhud34XpD3BbU5cngZzgW5R9uor3vnZxbzNN1L4rsqsB8fc036ZWouF0ZP9htSKfXsX6VdGpkGIRaMbo5Zakqg57k/IMUrOd7WdefqU0nvkC7X0WX+QvT2uM4XXtJ6UgH3vze5U6p6ZDDCEyXx/dnvi3Us/+lUGvqdzHSbp1EPGg3OX/2
 T0MaUjw1
 PGiAJJQbRUI/0+Z6o5WqXrMc4F0pLT42TlJ7ZUR7x4M+qYavtKcRYg/r7bsZPNI+oMIUxQVSHkijLHp8jqsNi7lwlZb6lUUKrHd4/1iRDlg30QByYUtc8kHfAviZHM0sNWhdix314PeSMdQfvNiigfpOnZ3S8BM0pdkLWzJaV9iexG1hTZVqYNq88UL3FMU7axgt/keaiHfxEw3iJ8SLuhPolRCX5++AzqXsP3UjFIOX8m0mxHMfkcNcXg0pULY0MNUg51lf6eUk1p4GgYLzvsppHUs7dFxgYDlyPVSV4T8BEmDcUAUn4084EE4SnualyHiam5lUUPMKox0Nz503go6Aw9RIt8RnFjLeFhdoeN/W7N/npGgHoyrYjFybRjGRpUml5vCE90mT0d9+/GnMi+8ZC8RThACswdRWiMNLN/DAdahgNCb+DyEVGGuWk2Qot8/oGxgEENrFGDtXb/oO4QeI44xOXbNgaC8EAIq70CdgQ1zjXYtYq7qtfH51DAY7e4OzCCIkpZ3Pb8t3bMPLFZJBW/m+bBpXUA/xz6sUJAuHNMRa63DFEForNAAYKDrz2rU7huXnwhBiNU3vasQLpBrM2nl0XHttJnDMUiAkgdZtLYxE1o7tQ85y4/IiWbDtyO/KepXxB8fN97kpbfcyn9uUVYhG175ldtAnEvj4ed6cfCSRxqrWDsl4ADpSLVugvg7iW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 23-03-26 15:37:15, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] udf: Fix race between file type conversion and writeback
> https://lore.kernel.org/all/20260323162617.2421-1-jack@suse.cz
> * [PATCH 1/2] writeback: Export folio_prepare_writeback()
> * [PATCH 2/2] udf: Fix race between file type conversion and writeback
> 
> and found the following issue:
> general protection fault in folio_prepare_writeback
> 
> Full report is available here:
> https://ci.syzbot.org/series/03e405d8-f247-471a-8469-f544c8393300

Bah, stupid me. The result of filemap_lock_folio() must be checked with
IS_ERR(), not against NULL. Will send v2.

								Honza

> 
> ***
> 
> general protection fault in folio_prepare_writeback
> 
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      af5802cff33fe3c557dff87cd3897d14241a7c6d
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/d1944db2-4f63-4e26-b642-d71f55382c9d/config
> C repro:   https://ci.syzbot.org/findings/87b82667-f800-480e-b52a-38decce9e6c4/c_repro
> syz repro: https://ci.syzbot.org/findings/87b82667-f800-480e-b52a-38decce9e6c4/syz_repro
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 0 UID: 0 PID: 1860 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Workqueue: writeback wb_workfn (flush-7:0)
> RIP: 0010:folio_prepare_writeback+0x32/0x280 mm/page-writeback.c:2371
> Code: 56 41 55 41 54 53 50 48 89 d3 48 89 f5 49 89 fe 49 bd 00 00 00 00 00 fc ff df e8 f9 22 c2 ff 4c 8d 63 18 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 ef 6a 2c 00 4d 39 34 24 0f 85 bf
> RSP: 0018:ffffc9000901f1e8 EFLAGS: 00010203
> RAX: 0000000000000002 RBX: fffffffffffffffe RCX: ffff88810981ba80
> RDX: 0000000000000000 RSI: ffffc9000901f4e0 RDI: ffff8881a659bc48
> RBP: ffffc9000901f4e0 R08: ffff88810981ba80 R09: 0000000000000003
> R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000016
> R13: dffffc0000000000 R14: ffff8881a659bc48 R15: ffffc9000901f4e0
> FS:  0000000000000000(0000) GS:ffff88818de5e000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00001b4fda9cd4b8 CR3: 0000000110906000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  udf_writepages+0xce/0x3b0 fs/udf/inode.c:205
>  do_writepages+0x32e/0x550 mm/page-writeback.c:2554
>  __writeback_single_inode+0x133/0x11a0 fs/fs-writeback.c:1750
>  writeback_sb_inodes+0x992/0x1a20 fs/fs-writeback.c:2042
>  wb_writeback+0x456/0xb70 fs/fs-writeback.c:2227
>  wb_do_writeback fs/fs-writeback.c:2374 [inline]
>  wb_workfn+0x414/0xf50 fs/fs-writeback.c:2414
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:folio_prepare_writeback+0x32/0x280 mm/page-writeback.c:2371
> Code: 56 41 55 41 54 53 50 48 89 d3 48 89 f5 49 89 fe 49 bd 00 00 00 00 00 fc ff df e8 f9 22 c2 ff 4c 8d 63 18 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 ef 6a 2c 00 4d 39 34 24 0f 85 bf
> RSP: 0018:ffffc9000901f1e8 EFLAGS: 00010203
> RAX: 0000000000000002 RBX: fffffffffffffffe RCX: ffff88810981ba80
> RDX: 0000000000000000 RSI: ffffc9000901f4e0 RDI: ffff8881a659bc48
> RBP: ffffc9000901f4e0 R08: ffff88810981ba80 R09: 0000000000000003
> R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000016
> R13: dffffc0000000000 R14: ffff8881a659bc48 R15: ffffc9000901f4e0
> FS:  0000000000000000(0000) GS:ffff8882a945e000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00001b4fda9c7570 CR3: 0000000173314000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:	56                   	push   %rsi
>    1:	41 55                	push   %r13
>    3:	41 54                	push   %r12
>    5:	53                   	push   %rbx
>    6:	50                   	push   %rax
>    7:	48 89 d3             	mov    %rdx,%rbx
>    a:	48 89 f5             	mov    %rsi,%rbp
>    d:	49 89 fe             	mov    %rdi,%r14
>   10:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
>   17:	fc ff df
>   1a:	e8 f9 22 c2 ff       	call   0xffc22318
>   1f:	4c 8d 63 18          	lea    0x18(%rbx),%r12
>   23:	4c 89 e0             	mov    %r12,%rax
>   26:	48 c1 e8 03          	shr    $0x3,%rax
> * 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
>   2f:	74 08                	je     0x39
>   31:	4c 89 e7             	mov    %r12,%rdi
>   34:	e8 ef 6a 2c 00       	call   0x2c6b28
>   39:	4d 39 34 24          	cmp    %r14,(%r12)
>   3d:	0f                   	.byte 0xf
>   3e:	85                   	.byte 0x85
>   3f:	bf                   	.byte 0xbf
> 
> 
> ***
> 
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
> 
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

