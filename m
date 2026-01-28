Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77F9D3F098
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 16:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4F06B0005; Wed, 28 Jan 2026 11:53:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C526E6B0089; Wed, 28 Jan 2026 11:53:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5EA76B008A; Wed, 28 Jan 2026 11:53:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD736B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:53:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6528B5A556
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:53:08 +0000 (UTC)
X-FDA: 84381967656.15.64D9FB6
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id A19242000B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:53:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aC04p602;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769619186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VIwZPYuTL84mdN01DfXHCnboBlP6LUsRJWXcsio5Wo=;
	b=WqrzytvUiaLptnsfuIN0jhj7p1rqGppUnZs5D8nEDmR8+S76jj90bLh86cRljAODpd+G1K
	IaUlCd7E6AT2azNLz0/yGu4HY8FVwt6YzXIe9yte9kyJS6KRApWzdY+kyKqit3v10nlSmi
	/1RfrOYye8lS1UIl2u9vj8xHA9AlPL4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aC04p602;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769619186; a=rsa-sha256;
	cv=none;
	b=oypcAPtP2TFNt4yzO2mWyDHtEnoAl8U6Q0xvcytqAMIUjHd38b5a3CTfrPHCjRkmWT+P40
	xRPIUYTvTlmHCGP4EKTfl3XJTH84bPPm0qQ2XCvwewJRlg/iavU8x5WpLkSMLKwn46XVDa
	y9IDCH0y0ECAB03UTuU/QjdZlmWmlVE=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-81e9d0cd082so28857b3a.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769619185; x=1770223985; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+VIwZPYuTL84mdN01DfXHCnboBlP6LUsRJWXcsio5Wo=;
        b=aC04p60226nayL916Hnda22Iy1OEJm6dl7AR0UEyUOjNx+vQ/E0TakDN0ijW/VHDez
         PLtb77hCSFZ11feX9FMbfdvOcnvFC4wCknUcb0YoChvZI06nLW+0vRU9QqQPsNoy8ZPB
         CjzVfSia8ZooLBJuj8BYcfeeUf2bevdRYtVd6U3pjgdXS69LF+b/2oDFoJ4mw85ay7NR
         ThwWEvjbHs6UAgdgo2Yg22AYdETiWkkNoVRsk2lEUZZeMIUaBp7So4F3VHeCau3TZPFb
         k1rk6FHciOJ9G7zA6Bi57ImbEun97GOn9KNhhc/ZzWTI86Ect27dmUmbqbkhj6maDXvm
         eA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769619185; x=1770223985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+VIwZPYuTL84mdN01DfXHCnboBlP6LUsRJWXcsio5Wo=;
        b=Hb2IIYjxEmMWJGA8YXHlJWJ6FlgPxmRkC9mIZ/vsImdkUtGkxJL2jgdV7ZlySa+pt6
         B3593QrE1zYCym0j23vKJM/MJdEjAGLEbGeidNqu3l7LlJt96UP7zEbo+cA7GUcko4m5
         56r2Yb/696HQylwReqiacOroxsdJkhUccel9aq0U1K7GmlUr8MZdx3nP5bqLmGwf25M6
         BA3cRFCFf6BGtjKKn8edQ7VHPMCrx8869xD3PGPTtIMaT3wDU9gosItLjlo1UWXssI+Q
         1BdceeWuW2NryuHXl3NtWH6CUkTlJC9RopbWuaYGU048lnrj86pjB5dCPJgc+3191Biw
         YJ7A==
X-Gm-Message-State: AOJu0YzdsPMd32xTh6U4sudJs6rLk4hPFIkg19iewpWF7KEFT/25b6uC
	eXQZiFLWrNTijeGW+Z1IMfWsREDkq9RrUoJJsuvxJHxCCIyRvtVIxc3B
X-Gm-Gg: AZuq6aJU5GIwfrhZ7mlQ6htzf3I5iMDvjXAa/XlqhqK4vUquK+c+yB2PzooeV6P3Lej
	HPKY9SbDegpOdyI9J0kqacTYzB4G7ClPCI7W7g3ZBKaQI8fYbrT7pWocElykyFk5yUL9KLCyyn8
	PjIbKmsCz/fsbkfZIfPrbQJiHms7EZYc15J8edHChfc/sXeNE7SNPPBJjMJ537AsWUX+8OPXTEF
	rRyf2iJTgzdw7v9AISnXd3KtAWkGayDM1buYCuaBLQHzSLqnRNh5pd7ztOylo8oJ44gFnvztR+V
	eshiJkak0D07FAwJ88k6aU3OkXkyvXjSa9BoIeVHHujmUfYjQVcT6kfOKBaLo3nQIc3r83P9bu1
	UPQD8H3OamvMaPATdCOqJGPrXZPic1gn/tqSOpEXe3ac2bz6wyZ91inhdXl+0zOF5nkVfqOxTFd
	rj/EqJy+2YKtIstTPMhyY18HZt5kE2GiIaWL5NF3cd01SGvnM=
X-Received: by 2002:a05:6a00:4fcc:b0:7aa:4f1d:c458 with SMTP id d2e1a72fcca58-823691849afmr5864355b3a.19.1769619185349;
        Wed, 28 Jan 2026 08:53:05 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b1f188sm3546757b3a.13.2026.01.28.08.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 08:53:04 -0800 (PST)
Date: Thu, 29 Jan 2026 00:52:59 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Chris Mason <clm@meta.com>, linux-mm@kvack.org, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/shmem, swap: fix race of truncate and swap entry
 split
Message-ID: <aXo6ltB5iqAKJzY8@KASONG-MC4>
References: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
 <20260128130336.727049-1-clm@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128130336.727049-1-clm@meta.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A19242000B
X-Stat-Signature: t3qhu166s7k448a91gh78pzomamqkjk8
X-Rspam-User: 
X-HE-Tag: 1769619186-634013
X-HE-Meta: U2FsdGVkX19fNqToaJORjz466AUQHmkQDbJRlkXQVzjjvonBYp+MdttDekuXsPDwc0R66mZx2bhYMB5XNzf2GgHL+VEgqplYxNkr7//MxcBY0SpN6WDngItAU+/MP7vTEXdzdydiElgJaop2W219JlMsvad2eQsfJOnr5ikmwW/CCHjGkEKLTyRafeNL3KhxlwVy8QtAneLmUpu5qHJdMcM0FkjsjGowhc27g4CV4ZLoWo/zW+Ss7MPULsB52a6k++j/EfNaVhpNX85gtxQWG82ZK0tCgfXYAKdVptgy299GM5oVHLDtNmmu7F4EXoTZantaLdkChUj949tFYbA9oriPqY03NrcAKIA6PEIX5H1rgRvlRDj/fRGbxddSFbpWy8AH8c7Ci8qb4Y8hDXUmA1/Tk1cj4PvNycaI4OVSu8E29vkJSg+uU7e+TxxIBnob+aWVRyK3h5+K41eyu9Q3pfelyCoQ2PWnQ3fM8qs5educaDtXHCZJVeievNd92Bk4IvTEjIeWxt8jcnJlSd/H9r9Q/3HwA0AG1erhB2bKan0TnFnvufR39m8E6Pb9Vaw6CbbcMJHXnKC5doH4rXBwNiRBV27BczNWwjpYxwkQYpBRCAKFgXebVDKZrp3arUzsSrE3B4VsitkbIqMBOvrmgxNNMyoYWBC4OyeYDJ6Tr6Ya4mvsNMyNbpE/yveo6HCGj3X9B+x5hTH4YAM4A4VWC7DPv+fv94QPy1wqCbh5PQKQYWOWr6pHmhFIinU1dX2One5wakz/pgdxHhYouyt/kynKMkUkHKVP2jAu4LTTVvUiokGDyURjL3oHYFyqAdH1Mvgtr2B+clGmVfxGhLEXhtQOJs9Hfcd7YdFjS4hOxjm2RdAvghwCS5pYZo1SMQy1nTVMP0BbPYskrUVRvAXxWIJhPGpBwNp7lOnSHwvQZ+n7Njeids3xeynR2ydaWwGhIpkNj9IXvpqdIGCwJFR
 gAPIqHDt
 lhf5k3yg5pL2Cx5igKSLjcJNbrytdVATEypkTq+XFT9bBVyKLJXBcufsYZoXVWeZi5PXSLA42DHHnzBmmACea2BGOY/DG3HYu/CfK0+TLJRJaOhm/7DTKc2kCPD02WVObRtLQ5o2KpKW51Yfxyqw8JViv7DOkLv3uriTmki0by9QZsjrFWGEIQtNvLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 05:02:34AM +0800, Chris Mason wrote:
> 
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> 
> [ ... ]
> 
> > @@ -1191,12 +1203,23 @@
> >  		folio = fbatch.folios[i];
> >
> >  		if (xa_is_value(folio)) {
> > +			int order;
> >  			long swaps_freed;
> >
> >  			if (unfalloc)
> >  				continue;
> > -			swaps_freed = shmem_free_swap(mapping, indices[i], folio);
> > +			swaps_freed = shmem_free_swap(mapping, indices[i],
> > +						      end - 1, folio);
> >  			if (!swaps_freed) {
> > +				/*
> > +				 * If found a large swap entry cross the end border,
> > +				 * skip it as the truncate_inode_partial_folio above
> > +				 * should have at least zerod its content once.
> > +				 */
> > +				order = shmem_confirm_swap(mapping, indices[i],
> > +							   radix_to_swp_entry(folio));
> > +				if (order > 0 && indices[i] + (1 << order) > end)
> > +					continue;
> >  				/* Swap was replaced by page: retry */
> >  				index = indices[i];
> >  				break;
> 
> Could this code infinite loop if a large swap entry crosses the START
> boundary instead of the END boundary?

Thanks for the review! It's really helpful :)

> When shmem_free_swap() returns 0, it could be either because:
> (a) The entry was replaced by a page, or
> (b) The entry failed the boundary check (base < index ||
>     base + nr_pages - 1 > end)
> 
> The boundary check here only handles case (b) for entries crossing the
> END boundary:
> 
>     if (order > 0 && indices[i] + (1 << order) > end)
>         continue;
> 
> But what happens if the entry crosses the START boundary? If
> find_get_entries() returns a large swap entry at indices[i] where
> the entry's base (calculated as indices[i] & ~((1 << order) - 1)) is
> less than the truncation start point, then shmem_free_swap() will
> return 0 due to the "base < index" check. The code will then call
> shmem_confirm_swap(), get the order, check if it crosses the END
> boundary (which it doesn't), and retry with the same index:
> 
>     index = indices[i];
>     break;
> 
> The next iteration will find the same entry again at the same index,
> leading to an infinite loop. For example:
> 
> - Truncating range [18, 30]
> - Large swap entry at [16, 23] (order 3, 8 pages)
> - indices[i] = 18
> - shmem_free_swap() sees base=16 < index=18, returns 0
> - Check: 18 + 8 > 30 is false (26 <= 30)
> - Retries with index=18
> - Loop repeats indefinitely

I think this is a valid issue. And it's worse than that, during the `while (index < end)` loop a new large entry can land anywhere in the range, if one interaction's starting `index` points to the middle of any large entry, an infinite loop will occur: indices[0] are always equal to the `index` iteration value of that moments, shmem_free_swap will fail because the swap entry's index doesn't match indices[0], and so the `index = indices[i]; break;` keep it loop forever.

The chance seems very low though.

> Should the boundary check also handle the START case, perhaps:
> 
>     if (order > 0) {
>         pgoff_t base = indices[i] & ~((1UL << order) - 1);
>         if (base + (1 << order) - 1 > end || base < start)
>             continue;
>     }

This still doesn't cover the case when a new large entry somehow lands in the range during the loop.

> where 'start' is preserved from before the loop?

How about following patch:

From 863f38c757ee0898b6b7f0f8c695f551a1380ce8 Mon Sep 17 00:00:00 2001
From: Kairui Song <kasong@tencent.com>
Date: Thu, 29 Jan 2026 00:19:23 +0800
Subject: [PATCH] mm, shmem: prevent infinite loop on truncate race

When truncating a large swap entry, shmem_free_swap() returns 0 when the
entry's index doesn't match the given index due to lookup alignment. The
failure fallback path checks if the entry crosses the end border and
aborts when it happens, so truncate won't erase an unexpected entry or
range. But one scenario was ignored.

When `index` points to the middle of a large swap entry, and the large
swap entry doesn't go across the end border, find_get_entries() will
return that large swap entry as the first item in the batch with
`indices[0]` equal to `index`. The entry's base index will be smaller
than `indices[0]`, so shmem_free_swap() will fail and return 0 due to
the "base < index" check. The code will then call shmem_confirm_swap(),
get the order, check if it crosses the END boundary (which it doesn't),
and retry with the same index.

The next iteration will find the same entry again at the same index with
same indices, leading to an infinite loop.

Fix this by retrying with a round-down index, and abort if the index is
smaller than the truncate range.

Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/linux-mm/20260128130336.727049-1-clm@meta.com/
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/shmem.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b9ddd38621a0..fe3719eb5a3c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1211,17 +1211,22 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				swaps_freed = shmem_free_swap(mapping, indices[i],
 							      end - 1, folio);
 				if (!swaps_freed) {
-					/*
-					 * If found a large swap entry cross the end border,
-					 * skip it as the truncate_inode_partial_folio above
-					 * should have at least zerod its content once.
-					 */
+					pgoff_t base = indices[i];
+
 					order = shmem_confirm_swap(mapping, indices[i],
 								   radix_to_swp_entry(folio));
-					if (order > 0 && indices[i] + (1 << order) > end)
-						continue;
-					/* Swap was replaced by page: retry */
-					index = indices[i];
+					/*
+					 * If found a large swap entry cross the end or start
+					 * border, skip it as the truncate_inode_partial_folio
+					 * above should have at least zerod its content once.
+					 */
+					if (order > 0) {
+						base = round_down(base, 1 << order);
+						if (base < start || base + (1 << order) > end)
+							continue;
+					}
+					/* Swap was replaced by page or extended, retry */
+					index = base;
 					break;
 				}
 				nr_swaps_freed += swaps_freed;
-- 
2.52.0

And I think we really should simplify the whole truncate loop.

