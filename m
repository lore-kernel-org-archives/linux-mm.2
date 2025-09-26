Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A94ECAC5AC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20148E0008; Fri, 26 Sep 2025 05:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD12E8E0001; Fri, 26 Sep 2025 05:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E688E0008; Fri, 26 Sep 2025 05:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF72D8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:01:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A77B873D3
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:01:36 +0000 (UTC)
X-FDA: 83930808192.20.6C044BE
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id EF49840003
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:01:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=cO5PlMgx;
	spf=pass (imf11.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.173 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758877294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/GFYlKX8sXH9/MVnPU5JNJW5GLLJS28gOFEuvHHi/s=;
	b=6Z46fEv8mxevaL/wwMcgP/YhZVt9jmg9L0v+1oOeC2QPmNGRdqm32IR8NnKtgJxmLXv9PE
	LFwGUgHFt7kEZCSifn1nCQLHp/T50rCoT01i9mnnSTbnQuZkmtzJ75nGrxBGH+EZZO9gAg
	NhYbepKkYRDsSoUx+DB3yp0SxXG17dU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758877294; a=rsa-sha256;
	cv=none;
	b=m9y0Cy30TxLLlsF93fdWIQ+SsACe6W4hQbQe6TPHC4ckfI18nSLGWZIdxTlpZh79grrULO
	+5/rx9BP2vQ9p03GrbRtvDIP9GZkWZSMctv5XZh+Rz/FOQCWBx+z2m70L0CP+0q752UUUs
	R5vqOnJ4E8zzH+J/c81Vyw6oznWHuCU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=cO5PlMgx;
	spf=pass (imf11.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.173 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b548745253so30201351cf.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758877293; x=1759482093; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G/GFYlKX8sXH9/MVnPU5JNJW5GLLJS28gOFEuvHHi/s=;
        b=cO5PlMgx3tLYKLx0s5Oew6A4BgYm0dLoaV/QFrH9mHF8nFEp+5jaUEteyTzCQXlKZZ
         iuEvHqYAMOh+GXPPX7btnO0rUzHLIf/77DqsL62DIkStlwYNWabFyVOBixgZ7vTmsQek
         /MR+3eJamh5YQ85UircWoDEQniVgujCj1X+UY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758877293; x=1759482093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/GFYlKX8sXH9/MVnPU5JNJW5GLLJS28gOFEuvHHi/s=;
        b=n264ZoN/Khn6X7sr5No3CxZektab2ad0Jk/+NEhvnw/w7ggnXIbIA92XgfEAnr/rnX
         MeEFH+Y1eQL2d3wogmJp90WDxoxPa/Sc3vI4MgQyULtHxHzp4iHZAt0PlrCC91UMJVhC
         7d8krpA7OutZXTZyQO5BXx90reh9dxhQYblnW4/UDHJiRC8YG4isH6h/UnPR2t02Mzls
         HdqPW9hHv86S71/wg6gaTwv/QPcLLTvjb0RdS8ehtBj3hg919MgtqR0K9yITR50Q4WVT
         jX3nUn+Ub0Um0FrA5VtChYsprUg839VJTxvyO3S6lddVKNfmV8wg/YEHfuFOFBEHX3Yg
         U0Qw==
X-Forwarded-Encrypted: i=1; AJvYcCXDPqYjlpuXAVZeMwibyLQxY64A+xeX8aNPSGtbNVLcTCdNV0pqopL8anbDzkD5lia0HcNXk7dN4w==@kvack.org
X-Gm-Message-State: AOJu0Ywl1awfKccE3jHuzbQkDUCYNy59ljJljngZPBBv4CD7zevzltNu
	g5Tw9vpBGBjWewAIvwczaPkx2oxvYZg8rWUoGPUHf5oya5CuUtbpcI89hu9eRWGCbGnbmQi0SDT
	kKHsEgcE4VzfBzQOoK6p9YHqUq5CmqzwQmFswnJ0OXg==
X-Gm-Gg: ASbGncsGF+DO1Bu7cGqUdVEttT+2KkjaA9D7vorz7VqwjeKtrS8qsnen722zA+kJo1b
	sFbDoCb1Z3H4DaXi44nA4ek9NxFatek1eLujsizdVSwVw4Q6seh59CSQP56IHv7DmG5VFVNhNQS
	0G/VLZh808+tzbwt+hQ/BXihftk/Txhq1xCRncP4IvL8ljElrUzSyVvTZdFL080jwq2MlHIYEpb
	ZqNq0JNjdSQi+v6VoWGZ4bgVaf6Xa3WYKZF5/FUC6pFPuiWkg==
X-Google-Smtp-Source: AGHT+IHzalmSFeS2hW534mTf27M196Uxb8VIlcKO6L9aIo/0iAFRQkxP8597Cv2HReRDKaD5Ym4wy+usutK7h7mOOb4=
X-Received: by 2002:ac8:5fd3:0:b0:4b7:ac70:d7ee with SMTP id
 d75a77b69052e-4da47c0570cmr76627321cf.14.1758877292711; Fri, 26 Sep 2025
 02:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250925224404.2058035-1-joannelkoong@gmail.com>
In-Reply-To: <20250925224404.2058035-1-joannelkoong@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 26 Sep 2025 11:01:21 +0200
X-Gm-Features: AS18NWDzpmIFyfqJed-8UXKwoNHRrfCxmto9gvn_Hs3Vc9F5z9XP26K83W96iB4
Message-ID: <CAJfpegvM48p__QALuxH_PBGcyNR2JYvJCav4Ug05SZYg1ZSRgw@mail.gmail.com>
Subject: Re: [PATCH] fuse: fix readahead reclaim deadlock
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, osandov@fb.com, kernel-team@meta.com, 
	Matthew Wilcox <willy@infradead.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: oh6b6t5e6nym74a3pgjd7gp8cyd94wuc
X-Rspamd-Queue-Id: EF49840003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758877293-859845
X-HE-Meta: U2FsdGVkX18kYR6A/wkoeCA+WpHTenYXn4q3hTewbiGwlR1a3bIEVbgm/e+WTqulh7aM1AcUh4GcOE1P2VI/g+T6gZMPXLHt+aj7oCpIGbrNJjYznVf/DVfj7jOPaS7NqiIGBhGu7UMykwnrF+/S1hbZLRGi9FC1TrQNHBcd9i1fXhn0uaKSFUaZhehOJ+Fg8IolHYrU9F34YikcCyRdyBH8/AVNZKyy/FxRPJMB4bisYogEEbVyUo429SmjlaelQVw6Wjg93HKaJ0XDyHxg5XFR2GPM1DfP9g8JS4wpvoTEEQovT59sxCrpPmsaAopko0k0bFstjuFx1x7kqyZPODZtznd47x4NJg2d/Z0XtUlcDHhrM3YeuzL6QvD3kQbPM4LNEhOPYfODp1Ld2V0n4TYTx97qVc7+1MPc/tn6G2iiBuR7QT3WUgZicY+1IC+QnE3DpBgDQvQ6cpwrVRF3g4EuJ5CqRdVzCcKZ6THsBPge/UoxogpMevGsQo8g4OUtnv/WGQPmwQmqvCgaapvnaZPb+Cxl4eVx4yGDWA5Y3n44wt56yvJZa3NDM+uS/mh0B5yUw73KQzDZgjzhkZ8Bkf5+zxupKxmHbGVLlYBvdCdcBNuA+Yu28QSec7RkFMm+/be+UGdfspt9YTtP51flxsPQwFLKFo8m4WqcbvWYnBM5mbLSWHTK9LuaQD+zZOOkYdyxaWhs7EbXqWrBYYCgK8T4rrFWF8RpZJvX1V6iKJUGRE6TTWlmXyMQwcOqW+ZiRYN8QZcYTOzoHr/XepqG+RztVv5V8UJKJLeAVYtnYco8Vjl2iSrHdMSmOH+kQneGv1McNj7VFOpdIbI0/8Infwg2dNsZjDtmiYvxITeZTzyVjS8rwdL4TtQrvTs+vbGYZ9neiV3u3O6ThX0VrqIepv96XHenYK03S3vsmp1fbVJ6WYizBphsKFhNpolLcnY02U8PwLfs9aeoCW5eQUZ
 zXTmdkBp
 lzgMhrgY6Qt58zFgz3BDy2dCsBirmehxM3YyDN3WcJ4FtRVj+x+JJ44rQA5pndH8JU5avjJICQV9pCq64VV3rA2tpReobW4e3p86FYWxhcEO3zS/c+099Cr/7Uwblt7/AXF+0mCGw/lMv1NJeuO8uclivm5Hyl1sJnzwnlhRkVY1YIufp4I1eS17DC9bLPhtBodP2TuAcu9JLSrdTRzOr9xs4JmORyC0kaJsl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Sept 2025 at 00:45, Joanne Koong <joannelkoong@gmail.com> wrote:
>
> A deadlock can occur if the server triggers reclaim while servicing a
> readahead request, and reclaim attempts to evict the inode of the file
> being read ahead:
>
> >>> stack_trace(1504735)
>  folio_wait_bit_common (mm/filemap.c:1308:4)
>  folio_lock (./include/linux/pagemap.h:1052:3)
>  truncate_inode_pages_range (mm/truncate.c:336:10)
>  fuse_evict_inode (fs/fuse/inode.c:161:2)
>  evict (fs/inode.c:704:3)
>  dentry_unlink_inode (fs/dcache.c:412:3)
>  __dentry_kill (fs/dcache.c:615:3)
>  shrink_kill (fs/dcache.c:1060:12)
>  shrink_dentry_list (fs/dcache.c:1087:3)
>  prune_dcache_sb (fs/dcache.c:1168:2)
>  super_cache_scan (fs/super.c:221:10)
>  do_shrink_slab (mm/shrinker.c:435:9)
>  shrink_slab (mm/shrinker.c:626:10)
>  shrink_node (mm/vmscan.c:5951:2)
>  shrink_zones (mm/vmscan.c:6195:3)
>  do_try_to_free_pages (mm/vmscan.c:6257:3)
>  do_swap_page (mm/memory.c:4136:11)
>  handle_pte_fault (mm/memory.c:5562:10)
>  handle_mm_fault (mm/memory.c:5870:9)
>  do_user_addr_fault (arch/x86/mm/fault.c:1338:10)
>  handle_page_fault (arch/x86/mm/fault.c:1481:3)
>  exc_page_fault (arch/x86/mm/fault.c:1539:2)
>  asm_exc_page_fault+0x22/0x27
>
> During readahead, the folio is locked. When fuse_evict_inode() is
> called, it attempts to remove all folios associated with the inode from
> the page cache (truncate_inode_pages_range()), which requires acquiring
> the folio lock. If the server triggers reclaim while servicing a
> readahead request, reclaim will block indefinitely waiting for the folio
> lock, while readahead cannot relinquish the lock because it is itself
> blocked in reclaim, resulting in a deadlock.
>
> The inode is only evicted if it has no remaining references after its
> dentry is unlinked. Since readahead is asynchronous, it is not
> guaranteed that the inode will have any references at this point.
>
> This fixes the deadlock by holding a reference on the inode while
> readahead is in progress, which prevents the inode from being evicted
> until readahead completes. Additionally, this also prevents a malicious
> or buggy server from indefinitely blocking kswapd if it never fulfills a
> readahead request.

I don't see a better way to fix this, but Cc-ing Willy as the
readahead/mm expert.

> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Reported-by: Omar Sandoval <osandov@fb.com>

This is not a new bug, right?  So at least add a

Cc: stable@vger.kernel.org

Thanks,
Miklos

> ---
>  fs/fuse/file.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index f1ef77a0be05..8e759061b843 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -893,6 +893,7 @@ static void fuse_readpages_end(struct fuse_mount *fm, struct fuse_args *args,
>         if (ia->ff)
>                 fuse_file_put(ia->ff, false);
>
> +       iput(inode);
>         fuse_io_free(ia);
>  }
>
> @@ -973,6 +974,12 @@ static void fuse_readahead(struct readahead_control *rac)
>                 ia = fuse_io_alloc(NULL, cur_pages);
>                 if (!ia)
>                         break;
> +               /*
> +                *  Acquire the inode ref here to prevent reclaim from
> +                *  deadlocking. The ref gets dropped in fuse_readpages_end().
> +                */
> +               igrab(inode);
> +
>                 ap = &ia->ap;
>
>                 while (pages < cur_pages) {
> --
> 2.47.3
>

