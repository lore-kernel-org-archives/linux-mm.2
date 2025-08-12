Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550D0CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E07018E00F3; Tue, 12 Aug 2025 04:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDED28E00E4; Tue, 12 Aug 2025 04:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BE78E00F3; Tue, 12 Aug 2025 04:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE4418E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:15:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C68E14021A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:15:14 +0000 (UTC)
X-FDA: 83767395348.11.5624BA7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6D6E01C0011
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:15:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=FrxgrVtU
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754986512; a=rsa-sha256;
	cv=none;
	b=XhyFFtYd8fnoaaiWQ+LBIdSd3MAG9J1IFqaoeNV7G+Jh1jlGM4+TRVINM0jCu39Q6sUPn4
	K9unVB4ipiY/JT8zjbmQNvDpi7kELQgycbK2McN7K0v7AddCuzifdmWNdC7eczrIpwGRg+
	BA+qsP3zm3afCzvgdMGF7VBwwcZx9zA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=FrxgrVtU;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754986512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1a5Sy4YXsTFeKN4+P/fLFTUGtAtBymy9RHHSvlwq08=;
	b=tV0J4uCrHL4zmx1EBLAxn1pwLRLK8yUqfeMuS/wOZ1ReqmVfSQGovDPe1p2FpCrh0ATsDx
	ny6/pPOnEqNRWj6dggn8zf5SfRPcjZ+V0MI7Y2AtwJSyThNLO0x+87Z0lKYabACHWEq0uQ
	dDZci1X6gBz/5HcfOOcZG6lMYVMGq3U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i1a5Sy4YXsTFeKN4+P/fLFTUGtAtBymy9RHHSvlwq08=; b=FrxgrVtUVjW5SqogYthsgZQlMi
	3p9g3b7adEh2YYSjclbIwZ0WhtVD9/BX8CHMnZekNVB8i/LiykRD/TCPmp26qfayA8QiJ2ggmxaUK
	8ysWryy8KrFCGC6y8hhuG3dugZ3mimUXurnGuDuRaf0CMwajEfIpVYZ50/zhErLLCo/OUx8d0KLpO
	CeyNsDeGsLhVwMOxpTQD7eAtGX5AkcsPUmt0Ob2GgPcr4a5vHaxbhkqqTCrqNsKmh4h9h2SXALsYQ
	Gd70A9nI4eGUBST4exzrVi1Fy82LRkw35oXoAQFj8HegkAjInKfHMw6ASYQiRC/t0pCW0uoSLSdxh
	2UWM/1cg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulkA3-0000000ADHX-22WD;
	Tue, 12 Aug 2025 08:15:11 +0000
Date: Tue, 12 Aug 2025 01:15:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org,
	jack@suse.cz, hch@infradead.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH v1 10/10] iomap: add granular dirty and writeback
 accounting
Message-ID: <aJr4D9ec7XG92G--@infradead.org>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-11-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801002131.255068-11-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D6E01C0011
X-Stat-Signature: 4wmmtjk9qozbw3gi36tts7ndf1ohc4xf
X-HE-Tag: 1754986512-715644
X-HE-Meta: U2FsdGVkX19735nDJN6TYsPBeea6t7QP7+YjLoMmSfWYAbKKN1P9Z2eTbgmE48MxaeyIeeIHZYU7GYToe3JlCfhtkHKcNPHxuK+n/QF2RfL60QO6YgcMQHNkcYRnUA6Rw3wgncc/UOg8dA9E0/DQEkxQ/iobhjhtWR+faan0YreZ5umSjsFzIwTX+qkTBmJZJBXShyxnNYOa0xdpPNF38OhXmhRgP5dCSYVL3C5YCA1djc3RNbOJHKeJENbRVN8Q5K/ca8uzSYsRLxuoQxtrVOpd6vE4ctFCEKccjMLTpzY+dX82vJBgA6of3eVGzmbtbpYY3dY2yLQ+hDSz7/jpaFZ+tY2zbW/LrnjdDzNZ3IHEZZxGFs3WdGMOOX/DYCc7hp1GniRqvqPdQ81cQmZGLxeoJO6Pbj7DVHf0vQU5OXPIt8yYjCeKJP25KPD3Iqn+bZJPii+8DeWBximCH6XaggBxMuCmLKyOGlvjsNGDlmn6CWXWfyfEeeynWSmKYSa/BtnB3fj+UnQ5kTPHF0z9B9dKVXLwA9q/hnWxMLKKVTF+m8lJ0YsrsKMeF7T+SqGgG/s0eiP7zJgPcsjolJzoCtLv+z6x/jG+uAXqIyqDtN1uthUB2BfaG0WLUtwI+dIaggzX2EBXxMxwjOqwLLGeY+KeqJl5x+qxY8ilrzxUweh2TQtA2800NM2Kqap3gZDowVuDWAz3aJc2KvgWYQ7xcry6B+U12If2JGgyaf7mSLOy/G6uZV20qUXaVn5jR1QbEjbDfRMqIbrNrO0VcczIaPAWjA5lGz80lEYiWypnsNCX/FKvbxtjCtIntGMpT6AxcDFO2zaWg9rLAQ4JkyA6UXZ9Ph8L2NBzBy99X/E8tmP7A7Ad3fa90fZmivV/CfFq1Rq6V/o9JmvgBst2ncyGMEqcGPzsA3nWIsr4tp7W+NaOJlOJrAu+Q00URxlpqY5zry67Yl654KTby+4EuuX
 lJ/6fgjo
 xy/KbI4pUosWt+2J7PXHHoKCdkAHzI1fbP9Dt+L40p40O9V2RfNW80WfjEFhGKfrXC7KNTpYsOOIb+0YqLCUkF8q1AwTHZuNRS7kjErU0OXCeoNpUF9yamh2JDkewM3RWKdUODZudU04ZHZZf/uQfcOqxs7v+ZDu9O/cen+E+ITUMa3Z9pbWRblfco/OjyWQU6aVzEWsF0AGs8Z5HcZFX6wv0HJdtgxWSV0cD8eWNVy8KHX/6krac5KbI+OCILdE5brS6q77HJMgDoRYVa+TZkveEbwkVWYZ2aCSli+KxAit7yYoq3tNXzSC4Omdhn7am36wvp5u+mZeJixT9FG5wAYKRBC3dOZhYDiikIknewSrQ51A9DgfOkiSj/N50dC4N/lrIgzf5TusJnerkTq7wVj6dm8C4gI9lzqRpFxM1x5zCh2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index bcc6e0e5334e..626c3c8399cc 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -20,6 +20,8 @@ struct iomap_folio_state {
>  	spinlock_t		state_lock;
>  	unsigned int		read_bytes_pending;
>  	atomic_t		write_bytes_pending;
> +	/* number of pages being currently written back */
> +	unsigned		nr_pages_writeback;

This adds more sizse to the folio state.  Shouldn't this be the same
as

    DIV_ROUND_UP(write_bytes_pending, PAGE_SIZE)

anyway?

> +	unsigned end_blk = min((unsigned)(i_size_read(inode) >> inode->i_blkbits),
> +				i_blocks_per_folio(inode, folio));

Overly long line.  Also not sure why the cast is needed to start with?

> +	unsigned nblks = 0;
> +
> +	while (start_blk < end_blk) {
> +		if (ifs_block_is_dirty(folio, ifs, start_blk))
> +			nblks++;
> +		start_blk++;
> +	}

We have this pattern open coded in a few places.  Maybe factor it into a
helper first?  And then maybe someone smart can actually make it use
find_first_bit/find_next_bit.

> +static bool iomap_granular_dirty_pages(struct folio *folio)
> +{
> +	struct iomap_folio_state *ifs = folio->private;
> +	struct inode *inode;
> +	unsigned block_size;
> +
> +	if (!ifs)
> +		return false;
> +
> +	inode = folio->mapping->host;
> +	block_size = 1 << inode->i_blkbits;
> +
> +	if (block_size >= PAGE_SIZE) {
> +		WARN_ON(block_size & (PAGE_SIZE - 1));
> +		return true;
> +	}
> +	return false;

Do we need the WARN_ON?  Both the block and page size must be powers
of two, so I can't see how it would trigger.  Also this can use the
i_blocksize helper.

I.e. just turn this into:

	return i_blocksize(folio->mapping->host) >= PAGE_SIZE;


> +static bool iomap_dirty_folio_range(struct address_space *mapping, struct folio *folio,

Overly long line.

> +	wpc->wbc->no_stats_accounting = true;

Who does the writeback accounting now?  Maybe throw in a comment if
iomap is now doing something different than all the other writeback
code.


