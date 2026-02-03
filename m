Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1548E8304A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 03:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9A66B0005; Mon,  2 Feb 2026 22:48:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D19D6B0088; Mon,  2 Feb 2026 22:48:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D04A6B008A; Mon,  2 Feb 2026 22:48:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69F776B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:48:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC68D160377
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:48:31 +0000 (UTC)
X-FDA: 84401763222.21.3B6CC92
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1A691A0006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:48:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fwu+OLDJ;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770090510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/YhbipGK3yzOWCZPNSR+5jNjtsi6pizEcTS8DCADz0=;
	b=2oOICm7Kn/mX1v9WpDKJRI8m4XHAByqmPqSDxBzVDCc9S8ITJ4iJyiu/K33Hq45KPtaaiv
	rK0WcsXWlOm24kSGDK1X7mGMHcTD95QySo7U/JyZAxRyV2mizPF++Iv3wqurQx7qVEvghH
	zUZQsOtAZk5qo5e5tT4VR4OstdnTaG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770090510; a=rsa-sha256;
	cv=none;
	b=uue6gqn6m1XbszUJhUJpZk1+IFwaTHNAmjgcUyMDq6kbG2LKpTIh37Rq8BirbT18W50sYy
	jxE2MGnYqU/8WWSWwQAf+XtsAfla7/rqPkzixVsLY5zNO8mr62+sQNSZEyc9VYEU3UiBle
	mZmm2S3LbLN1YYWsu5UXj/RzKwv28UA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fwu+OLDJ;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c5513f598c0so2149751a12.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 19:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770090509; x=1770695309; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S/YhbipGK3yzOWCZPNSR+5jNjtsi6pizEcTS8DCADz0=;
        b=fwu+OLDJDSFryfnoV+hCm2T1FwAPvKox6utx47Pfsyh+XIXCOkAqRKGQMwRbCQk0qf
         RgFb3t04gD1tP6pT8iC83nyDcia8X2TewD6c2lK6b2PksJk9Aj4mKoQ9dFJZ2fdY5iOS
         yjUGquLsk9R7oePbeYAj2RU4NF4VNFoTSMmhN9LQmsG0w6b3vbbkOIahGL9COa666mKO
         309A4JQPmAGQ8igAOR90uUZBUWqwGeM/qA3bQtKU4yWFkiwkthXHnHdPHH6rJS/sVLO+
         niGYGXM8gT9pyQin8s/17psLoxBFEGvlEozQ+NJW8ayOxQZU+O6YcgN5xwHsrzkPleeW
         iz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770090509; x=1770695309;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S/YhbipGK3yzOWCZPNSR+5jNjtsi6pizEcTS8DCADz0=;
        b=B1aNcgRdKXwiQ1Eefi3Q5uFTDYuc+pEpn/H1bjUA9TrDtLXC/szwDrQS0iat6lawtQ
         3nGXfi9U+YpgjGgfBYcIzgD1dMHGkrjQ6bIi8qYgqwG5D1SJVnbIZHQYvzejZr0E5xsb
         gs5lAVrmi+PQrnbm8FB8d7P/+fxamePu4RGwmjBhjuUbC8oNSRSRssPmM1Qd0eZYNXuc
         oNvqi37vAavzWgzgYsBbzFI2rS3tOWtrjXCdKPHjEU8DdftlFsIoNJu3rsda+1JWwSAk
         GlYR815DUU1gVA53gttfUWFVpc1Wq5fIY6kVbpOwzHe6iAIUn7+VWgI8gIhoWaV9N67O
         +n2w==
X-Forwarded-Encrypted: i=1; AJvYcCWJEXIAMX6oi91+OUVHmYQJUQyJO/x5iPWLB5jqZA5Q0s39ra0VFyJ3g6FERKNnRBAy/liaYDCC2w==@kvack.org
X-Gm-Message-State: AOJu0YxIeoEs6VtGqcOXNyu8pRWYrVHFeM4yhX3mELq/WOw3FKaSN5Lx
	TCGcaITJJXVzWGot6VtQTg3zfLDbW6JshvbL91/fZRBcY2KjDPy9LhLo
X-Gm-Gg: AZuq6aLTOx4tOna+aqWKSoMLUgZB9ygJZSaKRgKyo+FUmox1ugM3FxXIU6n6JhNhES3
	7Xa761xtQGcprFVs1sixeBkRV06XJsb5b/BOsQn7RQCsTvvzXS3LHDo8saP6OoSPSViEvrVOWXs
	gIYekcAVYmVudSvFtu5q4RU1bpvfFhOxsAN4Cj8gZ2GWFNpUKHePOcxioNTTXCepROSfcfR5qI+
	eL+53g+6+uPTpDqc+E22Vwj1+0rZkYrUd6JukKtlpNlYHsI5Oq7i33layLNOkT4xq1BYx/8e0aj
	8zFeNQFhMk0A/1IF1jVqmYwGo01tW652oJi0QYsRjeOyxzXMRY+McHiKzP1+kDPlXkohNimL3ck
	l+lB2jf7dMEfB1AkEup25vDUMegCaVLix1FaekGhWBbBg2n0JVEIqBWZGccZFtT0P4h5+8tuNUp
	f+AXKBfzTV25rcsOpDVH/Nc6o=
X-Received: by 2002:a05:6a21:1709:b0:366:14ac:e207 with SMTP id adf61e73a8af0-392e018d2ecmr15054792637.69.1770090508715;
        Mon, 02 Feb 2026 19:48:28 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c642add55adsm15082350a12.32.2026.02.02.19.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 19:48:28 -0800 (PST)
Date: Tue, 3 Feb 2026 11:47:46 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: =?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>, 
	syzkaller@googlegroups.com, vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Message-ID: <fwutwpejyptpo6gqv75zanqciv3fmxvillomwcjvtz4auebbc2@vazub2ct7pa2>
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
 <aYBiza9L1hmhmXbb@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYBiza9L1hmhmXbb@hyeyoo>
X-Rspamd-Queue-Id: 1A691A0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: k514shtn3kk8pkuyzy65gpar9ip69wip
X-HE-Tag: 1770090509-360737
X-HE-Meta: U2FsdGVkX18rWOts3NfM3vZion8mOeq5XC1gJMWiie/Vevp6QlgOvTpZMHDEteOdiAclsXdWQcBQ32pws84NnmDnAj0dFZOhC+JhS9aWOvL1+eaApU+t50JJYZ3lcW88jeieQotpGxQotGMJpewfEwMRALssbftVn6GLKdooHgJlFWVip+ISNis4mvE3iA2ckGIqTN29fvc5ejMieVKTILLuuiW67qb4lB8pQ5+nH4vopchLY5dwoF4hmMjrjJKSY+2eElLXZMiRKNpT9HpUZEwUdqGQ1XRhnMTKI4iGjl7w3XSBLGLyXNsp60T9O8K1wfqf+YbAN+vF+w2Cb/EcwDt7aGBYI6MfGEse96+6tam6twe5D0I8L5MClW3Vmit/hFMN0ITinYqTWPWI2j4dCY9QVwjnb//UKlB1gATtAV4KcanpAAFt/1FJO1LPEhM9w8rxkvfIcEIUU8Hvsa37ffnd7zrEq5bVkM4cDooanPswuM2jNiyfg6LWJnFsjVpGUKmMZ/O65usjultiQyGfMLzkyv4ipWK/vgoSb3/bOu92De9jMAhLQ9jOrwDmvEc1vpGtA7wwq1Ui+UkQarfPgQgfJgZFCCIpFH7dxQp6nER85DU3zch6QW/tKg7pA1laqXxZKuxbN9wTT5ZcX+kjwo4sZbYANoya6sarbEiALeVPC3BY7uACGcljUbjYxtJtuaqlO6XN1ZefUfo5pM7rNCcs3qUCxHenx58o87UmgceXSNdBDb383yd4FisgshD0vojUrc0M7qtGnP3CYq06S+cHPCFNCqQA8/3f34VXgu5Ax8KfYr8B2+fQIrMEvGfRZylpwesmPP5AACZB+fR4wFFAq/74VAy/4ddwUyeAgitrgKmZWiHbUd5Gva6IP8Bx9S44EbtsZMDyayPHcwbwAfYp2BsxcIH+aAF6em1OrA6bCr5GZvemYVHovq9QMaDUYp9kcmB/WMLKCz7s15s
 D4+RsS1u
 qet1mIpoHC6qA9in3evsu6E02Sfz6q9zch2PPd56MUNnIO8JCc9vOyaHfw6Cuw+L3MIVhZP8Twa6r8Uxx2e77nFCTyioWevW6g4UzHZOXeFn4GgaGTg0g7HUfC6M2kvZuZfU1o6W0shnlpIgOxRqAAbJKhqxiBcjPuJ209+mj0gIqA76rJaF81yHjv8eKuvtpbWcz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-02, Harry Yoo wrote:
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

LGTM. I wrote a fix pacth, as below.

---

From 9131e1b26b1ec55dd38ab08512ed6da0fa7a21f0 Mon Sep 17 00:00:00 2001
From: Vernon Yang <yanglincheng@kylinos.cn>
Date: Tue, 3 Feb 2026 10:51:45 +0800
Subject: [PATCH] mm: mempool: remove __GFP_NOFAIL gfp_mask when first
 allocation

page allocator triggers a warning when __GFP_NOFAIL is set but
__GFP_DIRECT_RECLAIM is not set.

The user of the mempool (f2fs_encrypt_one_page) passed
__GFP_DIRECT_RECLAIM, but mempool temporarily cleared it when
first allocate memory.

    gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO)

Make mempool also clear __GFP_NOFAIL as well when clearing
__GFP_DIRECT_RECLAIM.

Closes: https://lore.kernel.org/linux-mm/CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com
Suggested-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/mempool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index c290e5261b47..679ab4a2cc5f 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -472,7 +472,7 @@ static unsigned int mempool_alloc_from_pool(struct mempool *pool, void **elems,
 static inline gfp_t mempool_adjust_gfp(gfp_t *gfp_mask)
 {
 	*gfp_mask |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
-	return *gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_IO);
+	return *gfp_mask & ~(__GFP_NOFAIL | __GFP_DIRECT_RECLAIM | __GFP_IO);
 }

 /**
--
2.51.0

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

--
Thanks,
Vernon

