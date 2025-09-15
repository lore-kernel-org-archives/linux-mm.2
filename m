Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F34CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3788E0003; Mon, 15 Sep 2025 16:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B9A8E0001; Mon, 15 Sep 2025 16:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAC98E0003; Mon, 15 Sep 2025 16:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E22928E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:47:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B7B5160559
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:47:18 +0000 (UTC)
X-FDA: 83892669756.25.D9F4AFB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id B5ADF1C0007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:47:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Mnvfexft
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757969237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MwTJRT4h1O6UaYWP0BlK79M2H5OP55Nu3v4YH0QgOj0=;
	b=7rYXUQDGAepROiYwEGuMSS653eT+xUf2Zx5XsRrETZ+XCRRvKvxdb4xE0dIGwNUbHFws26
	lY9iIe65TIQx7p2FV+tuma4uFKREkBQavakZOl3Udvw6xl0igTv1afcJRZ06HGp4kpI8Dy
	RsOh130pQ2i+Z5vSAx8k2b3Hm7+NgIU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757969237; a=rsa-sha256;
	cv=none;
	b=dH3HdhZUoM6nMHf97LUoMiCSHrjkp631Da9TiS0RraebwxnyP3i2qegQycuhLajFaZZQmy
	tk5YxN7PtyiYVz4Ij83XrVhrCvk6F4YHYTwL2Yr942gQKuuSNPwvOtmztcm+Ye7Diyhfbw
	A1Fu59OO6k2T2isnmLttlwvqQ4FcAOs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Mnvfexft;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MwTJRT4h1O6UaYWP0BlK79M2H5OP55Nu3v4YH0QgOj0=; b=Mnvfexft4nqDCE4G082SbkCDUa
	+01vaHcfEL7uMGPvqylZliQzmXDiVZZ7rYo/RBQnvPK/7ONXg6B7jg/gj+UAIc/Dp3Jr5Q3nhmN0x
	KHBx5ZiXwBar+6JtrHX952/k93KamnuGw/3vQIJ49rYZvJb+ZyfAXlSQOiykDsQOe5M+gHOzXPcJq
	gYkAYP8q/bkI9vVI65O4tFsWmRdS3Z6tLXzfeYkvuuLZOJEL5nFWZa1XmPfoPPip7Z4UNCk0D220v
	BTuJd1A+wqHjR9IYE7qzOU13T7Ajhf0i8gt7yuZzN7OkLkW3+O88FOr57QscjReGgJdZRIVld8a8X
	jN8liUaA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyG6K-00000006bmk-1w1p;
	Mon, 15 Sep 2025 20:47:04 +0000
Date: Mon, 15 Sep 2025 21:47:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
	mhocko@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
Message-ID: <aMh7SAlitp5FqR-M@casper.infradead.org>
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
 <aMQ6bW-OoMWMVEFF@casper.infradead.org>
 <11629632-c652-460e-b617-3ec0c27969f5@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11629632-c652-460e-b617-3ec0c27969f5@linux.alibaba.com>
X-Rspamd-Queue-Id: B5ADF1C0007
X-Stat-Signature: azq7owg9d98ijbpur39ipj8g47mwo96i
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757969236-530360
X-HE-Meta: U2FsdGVkX19VwpS2pLG5SvAPPPlRn5+O/x1tPkYp/KnAMFqA7xEDsqYRAqmGRlwslj2BIw3fBzBpDhQhogou7/pMOF93RA3mtxDGQ+qX6hEHpQDRhYiqu1p0WR4ghtTqyPBjQT3dEqfr4kukSMt54YtwCVJo1aB14mAbhuGTmTqsbao1ZDRVNyQwO0rhfPX/tneTK3/cIP5HBD6Bj+s17ibJXa4kuihDxMta9151Ycy0gV9W37uTRnOPMytOl/vgPY3rV34Wk/MwtqGAkm58OqnEPTQphv3tuat+THhDPTkIiTzO8uV6avxU43iw5TZEwa8IICjpJRepd+/LiKJPhCL+0xJuOxXOnRKAxUzVH/esjndisDFh/GZnC9FtBsNAeDr9LRMm+rKokxoI0MUIzBfjLKUhsyLJTM7AE2VZ+ddLIxE3d9HxuYBus0b1qnl/Zu88+x/sw5cEHnrIp23K3mD1J/d7kIsTrr/sYDvEOkQ2TRF8oEq6LZBYQ862FICDwzPtX9l+p6X2PIsRIeFaewfRPCeEzePBAiyO9JCR5oaQ/4hCyxhpDYH4p1AtZA71wuqKmSJMc5WwN1bjB7wbb/3Ce2Rpq7isvCVddHGRc6cfbnbSKWXfFjfUmClUMbQHMWzeaeA0hdOsml+RWLsFxXOKyF10W88trC18t2vSdX0VJZS+ytUFHbEABMV/PqENBtK72KtKniT9lyve8CS5eWoRTnBrci04hs2ZQsnHJHpGhSzFGCW1Ul7XXqeytat6jLgnFc/Bsc/j6NeYBLsW6qHypNwJ8/JnyYMtYUWPbsKVwJntX8ca5v2DOxsgja/RsPEx/guZJ+FtaQBRKwCXQR4+Br+Yl/1EwWo6FG71T84BHON9gbx0Nvs2VYXN76tZputhIG9t65wbIR4T8CCHxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 13, 2025 at 11:04:48AM +0800, Baolin Wang wrote:
> On 2025/9/12 23:21, Matthew Wilcox wrote:
> > On Fri, Sep 12, 2025 at 11:45:07AM +0800, Baolin Wang wrote:
> > > @@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
> > >   	 * swap_backing_dev_info is bust: it doesn't reflect the
> > >   	 * congestion state of the swapdevs.  Easy to fix, if needed.
> > >   	 */
> > > -	if (!is_page_cache_freeable(folio))
> > > +	if (!is_page_cache_freeable(folio) || !mapping)
> > >   		return PAGE_KEEP;
> > 
> > I feel like we need to keep the comment (assuming it's still true ...
> > which it probably is, although there's nobody who would think to update
> > this comment if it became no longer true).  I would certainly wonder why
> > we can have this !mapping test.
> 
> I think the !mapping check is still needed here because the tmpfs/shmem
> folios truncation might race with folio reclamation, see shmem_undo_range().

I agree that we still need the !mapping check.  But it needs this comment
that you're deleting, because it's not obvious why we'd have a dirty
folio with a NULL mapping on the LRU list.

> > > -		/*
> > > -		 * Some data journaling orphaned folios can have
> > > -		 * folio->mapping == NULL while being dirty with clean buffers.
> > > -		 */

