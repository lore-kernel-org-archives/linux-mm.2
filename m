Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72379E83057
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 06:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936EB6B0089; Tue,  3 Feb 2026 01:45:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA3E6B008A; Tue,  3 Feb 2026 01:45:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6356B008C; Tue,  3 Feb 2026 01:45:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD5A6B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:45:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EC8EC1AAF
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:45:29 +0000 (UTC)
X-FDA: 84402209178.09.0DAFBFA
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3C85D160007
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:45:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rxMfmGnA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770101127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lht7XPkNc89Qfw9Oe7k3UNCkolK1+9yKK0+K9UAL+ao=;
	b=49v7nW/cOZC2i1Q/q+6IygYN5OlJO+GrNpQ5MFysKNm0LnwQ6PNJ4KxwGkoWf/fTzRgDAX
	JQYKxdICc3oZvOnzV2KM4/l/VCABlplXOTk8ayvTjUwOdH1DfwyqNK4OuSX8hIOGereqlK
	Qd1si0W8R6WnW2Ov04HtLi1NGOcw1ZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770101127; a=rsa-sha256;
	cv=none;
	b=g/oqbpyCqx/8GNJsKBzNlUO/6HDb2Z5irExanG/BXd8/hOkmm5HxaqP7eQBsJKrqXCwWbU
	SuhuOZL0pBlMTvYR3FKBb0cwskJdSMGaS/zJZ855TADhKcebvlCL0aE/EdoNdzznIKJK/1
	1K4v5TwynJjNKAURHahdQCwE+67foZc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rxMfmGnA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770101125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lht7XPkNc89Qfw9Oe7k3UNCkolK1+9yKK0+K9UAL+ao=;
	b=rxMfmGnAc/dqppQdwY1kmMnInapfvmE7JR/bns6yHc2extzs6mJU0KpbwUSKQorFDKAMwt
	k/UHaYgnjM5bSze9jnWyK8NTrt+jhEnTtltjhvYFbjh6RVbxOKR4WpMy/PhOENMJolu/g+
	zpmep+wel8UWOTz5EySzz44j4h2hiIU=
From: Lance Yang <lance.yang@linux.dev>
To: harry.yoo@oracle.com
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	coregee2000@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	syzkaller@googlegroups.com,
	vbabka@suse.cz,
	vernon2gm@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Date: Tue,  3 Feb 2026 14:44:59 +0800
Message-ID: <20260203064505.47693-1-lance.yang@linux.dev>
In-Reply-To: <aYBiza9L1hmhmXbb@hyeyoo>
References: <aYBiza9L1hmhmXbb@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3C85D160007
X-Stat-Signature: c7ekn1s5nws6s3sxhgapos5pzcw7shxi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770101127-57648
X-HE-Meta: U2FsdGVkX191juYIvda9fjIEoprjSXCv/rjDEHtAfwb/yddBEIWcLAXSgnFl4g7ZOZDTvNLFhEfCCSmlC6vBPv7BIC274AEY1ULKjpd0/tATgb6c9wrsEHwq5Uc7NGjt+jwcBybTK8E0p72NAMQ1/WiB3tLu1OxBRMqZ91B2txQJ3bQj3Lbfthlye5+YZjEytaKSHWjdQGkV/K2NwwLEe/iwGpwK7PQGqdPPhwdFiEZX6pHHL1W/35W1haj/vVYPmJkOAizR1DOIlTZJt7g1Hx4f9zm7fE3ESZsqtXTcZ3SWBQugakyUTJbvSZIx5jXayWQ8eeLYg7QDovAzCWoi/htePIqeADw+Oo8IItQ0cF/ms2DDckv3CwlVksB9N9IvWNy+cLpHLXPGUp7bpt2lIXkJjHpBb2VN74tFm3jFWHSQUZUNnLR5VaFT9i1LlVNtW2noElKIzAoNMVBkzo6maC2oIM4W9sWjGeEvjsyuH9YXEssWH+eusvc99YgzUzLRhltzSDhdGK//3YrPGlHjPW2Z/G1g+0/Xxe34FshG0PlJU3l9FTJIpVnhyD7N9B9wuAmrZpI9UTpytqV28BxlQlQa3zvNdesAYnY+avklj3NIX2yeBzCqvH0nDgDbXNgm8AWiuVcmMmGe5VWX53XXprmQ9R6itMOo273+80NzDzw4CC7M3Kl+KRHvULI8mW3k2tDlofa4w2sd/s5bS6O31KIaG6BTS3qeLgVGXuNFMFTY4eUonWit4ONCOiOD7MjUD7Li0KXOsNHe9Shq/Ebhk7mgVZhbyxFXeyjEWnfpGSRNmApMqMsfWhrXdPZNFfJA10iwO1F7yFDAS2KHz6GrSPpHVHRNouKhmJv/lPngyb3saTfAQhyDZ/J4+jVuj07H5HPQ3ABK4HUas5LlKx5ZI5zzmiwjHUgTiVExAR3ilGkLZrhnFHcXSm+GuwMZtT6cC55FWu4CG6F9KEFKMXY
 V1s0X0BQ
 2A+H5Q6wqU8vxreUMR0IRX9zRInB3A3eauJeO5zD5vDgNWGWfup4cIq1twboATF3cqN1/F3ZbL/Q4DNIgeWYmtdoFrhAlfZJnve0QpzFU9k/FD/FcKHhTrpgi/qqnhN76dbe+mNp/JZm2ouWxVLwXAEa6biNYv9usWAHOFLRcDTPaf0bbraETM9S1+yht8D5eB+PXQwrWU7zKJLQQeFBIZAifG09GAzdKzvy7tkFKwBNSWcgqCHxlU+lgpMfNkmal718+WLmKwMGNi7bakCdyGEtNq0zE/Bijhga9zEXUrG9GwchcEt1KxSSqN4SQ+AXJhtIVhhGwW+a+KSs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 2 Feb 2026 17:39:41 +0900, Harry Yoo wrote:
> On Mon, Feb 02, 2026 at 02:40:14PM +0800, 李龙兴 wrote:
> > Dear Linux kernel developers and maintainers,
> > 
> > We would like to report a new kernel bug found by our tool. WARNING in
> > mempool_alloc_noprof. Details are as follows.
> > 
> > Kernel commit: v6.12.11
> > Kernel config: see attachment
> > report: see attachment
> > 
> > We are currently analyzing the root cause and  working on a
> > reproducible PoC. We will provide further updates in this thread as
> > soon as we have more information.
> > 
> > Best regards,
> > Longxing Li
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 362734 at mm/page_alloc.c:4234
> > __alloc_pages_slowpath mm/page_alloc.c:4234 [inline]
> > WARNING: CPU: 1 PID: 362734 at mm/page_alloc.c:4234
> > __alloc_pages_noprof+0x2025/0x25a0 mm/page_alloc.c:4766
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 362734 Comm: syz-executor.5 Not tainted 6.12.11 #1
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > RIP: 0010:__alloc_pages_slowpath mm/page_alloc.c:4234 [inline]
> > RIP: 0010:__alloc_pages_noprof+0x2025/0x25a0 mm/page_alloc.c:4766
> 
> page allocator triggers a warning when __GFP_NOFAIL is set but
> __GFP_DIRECT_RECLAIM is not set.

Good catch!

> 
> > Code: 10 00 00 00 44 8b 74 24 48 41 89 c5 0f b6 c0 44 8b a4 24 84 00
> > 00 00 89 44 24 28 e9 e5 f6 ff ff 90 0f 0b 90 e9 f1 f6 ff ff 90 <0f> 0b
> > 90 e9 1e fb ff ff e8 2e a4 38 09 e9 5e ed ff ff 4c 89 f7 e8
> > RSP: 0000:ffffc9003ce9e7d0 EFLAGS: 00010246
> > RAX: 0000000000008000 RBX: 0000000000000000 RCX: ffffc9003ce9e8fc
> > RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88813fff99c8
> > RBP: 0000000000000000 R08: 000000000000028d R09: 0000000000000000
> > R10: ffff88807fffbc17 R11: 0000000000000000 R12: 000000000009a800
> > R13: 000000000009a800 R14: 1ffff920079d3d0e R15: 0000000000000001
> > FS:  00007f1784eff640(0000) GS:ffff888135e00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055bb25a85a28 CR3: 0000000096938000 CR4: 0000000000752ef0
> > PKRU: 55555554
> > Call Trace:
> >  <TASK>
> >  alloc_pages_mpol_noprof+0x2c9/0x610 mm/mempolicy.c:2269
> >  mempool_alloc_noprof+0x176/0x390 mm/mempool.c:402
> 
> the user of the mempool (f2fs_encrypt_one_page) passed __GFP_DIRECT_RECLAIM,
> but mempool temporarily cleared it, but not __GFP_NOFAIL:
>    gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO)
> 
> Hmm perhaps mempool should clear __GFP_NOFAIL as well when clearing
> __GFP_DIRECT_RECLAIM?

Right. Clearing __GFP_NOFAIL together with __GFP_DIRECT_RECLAIM should fix
it, IIUC.

I saw that Vernon's patch does exactly that.

> 
> >  fscrypt_alloc_bounce_page+0x28/0x60 fs/crypto/crypto.c:59
> >  fscrypt_encrypt_pagecache_blocks.cold+0x567/0x6da fs/crypto/crypto.c:202
> >  f2fs_encrypt_one_page+0x187/0x630 fs/f2fs/data.c:2516
> >  f2fs_do_write_data_page+0x7b4/0x1900 fs/f2fs/data.c:2706
> >  f2fs_write_single_data_page+0x1454/0x1c30 fs/f2fs/data.c:2872
> >  f2fs_write_cache_pages+0xd6e/0x24e0 fs/f2fs/data.c:3166
> >  __f2fs_write_data_pages fs/f2fs/data.c:3321 [inline]
> >  f2fs_write_data_pages+0x4af/0xdd0 fs/f2fs/data.c:3348
> >  do_writepages+0x1a3/0x7f0 mm/page-writeback.c:2683
> >  filemap_fdatawrite_wbc mm/filemap.c:398 [inline]
> >  filemap_fdatawrite_wbc+0x148/0x1c0 mm/filemap.c:388
> >  __filemap_fdatawrite_range+0xb3/0xf0 mm/filemap.c:431
> >  file_write_and_wait_range+0xca/0x140 mm/filemap.c:788
> >  f2fs_do_sync_file+0x2dc/0x1ed0 fs/f2fs/file.c:278
> >  f2fs_sync_file+0x13a/0x1a0 fs/f2fs/file.c:395
> >  vfs_fsync_range+0x136/0x220 fs/sync.c:188
> >  generic_write_sync include/linux/fs.h:2871 [inline]
> >  f2fs_file_write_iter+0x12ba/0x2370 fs/f2fs/file.c:5057
> >  new_sync_write fs/read_write.c:590 [inline]
> >  vfs_write+0x5ae/0x1150 fs/read_write.c:683
> >  ksys_write+0x12f/0x260 fs/read_write.c:736
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x471ecd
> > Code: c3 e8 17 28 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f1784eff058 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > RAX: ffffffffffffffda RBX: 000000000059bf80 RCX: 0000000000471ecd
> > RDX: 0000000000000002 RSI: 00000000200003c0 RDI: 0000000000000004
> > RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059bf8c
> > R13: 000000000000000b R14: 000000000059bf80 R15: 00007f1784edf000
> >  </TASK>
> > 
> > https://drive.google.com/file/d/17HbDTI_iPjA72SkV5MnO-_w7IQZ9HIHW/view?usp=drive_link
> > 
> > https://drive.google.com/file/d/19pMiWedcVz8nFrj9jiJXuCjyPbNjYQqq/view?usp=drive_link
> 

