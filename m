Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F66CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 23:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE7B8E0009; Tue,  2 Sep 2025 19:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6278E0001; Tue,  2 Sep 2025 19:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2D58E0009; Tue,  2 Sep 2025 19:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E62F8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:46:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25170119E51
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:46:08 +0000 (UTC)
X-FDA: 83845946016.03.F0EDA55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9299D120003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:46:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QX7CUFku;
	spf=pass (imf29.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756856766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDXgYpGmGUItWrKJNRE6I0I8C9RbQCNweIjKCGGf6gU=;
	b=75AMhUMAkqQx0QQgdVN4bu7IcDnyucxktzAPA15p3aWrlgE74yx9ICp1sK/r3jLyDXb45X
	7SlIB7wmmehtCVWYirg+BgpwzteR9q4lsb+Rkbi3+/3lufVXIflfsob/Bbk+/SONKiFYds
	ssY1+HHbZJZgPjhE5Ub+PyrkdDXYMWI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756856766; a=rsa-sha256;
	cv=none;
	b=lHVJ4ulastkmu0s6YCxOzUdEK4GZQ57Mt4O5E0ZCfPbGCO213qOR9FLvr9xvkLCW/j9r9a
	OCfETmZRN7+vFnMa4vP25HIji8VbXqdrU51Q8unWy7jTTgKebUf2DDZ3r36ev7I18XWgLP
	StQMfigojHOppok14a3Nd3EdUNiJ7X8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QX7CUFku;
	spf=pass (imf29.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B65C960139;
	Tue,  2 Sep 2025 23:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEAAC4CEED;
	Tue,  2 Sep 2025 23:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756856765;
	bh=SJvsnIHwyoUT8q290OO+hZX+QlYIP0py+Y694P7LuLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QX7CUFkuPZWAAVO2rTPabUBttB2edEDs99WM8aqeNaiJtYNgXFHBm3iA9CzFWoUy5
	 Gm+9nuB8c3B/5uFjXCRITnJyUqKSg6lqFNwOu45d4hSZGgTaO4pUkOKIsZkTugmAZi
	 K92ys0MWafTXiRr2jBxuZ2QQeLEqoNmqeKjTJwyBRmCzhoNFOXiHmBcOYuPYqFzgAm
	 3iDYTOT6k/8J+9HLGxp/MibaTKxaZ5sU2JZv+08u5xJioKWamHeyIG44khiQdaFxdQ
	 xkblgOrC0+Nz0xIUoC/9OwLhOr+GgUSCwjMcCH/wQ5zv17EBuIN8i8ZpJybXHhL8rw
	 uQQO2jI6+EWfA==
Date: Tue, 2 Sep 2025 16:46:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org,
	jack@suse.cz, hch@infradead.org, jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 12/12] iomap: add granular dirty and writeback
 accounting
Message-ID: <20250902234604.GC1587915@frogsfrogsfrogs>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-13-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829233942.3607248-13-joannelkoong@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9299D120003
X-Stat-Signature: ihu7z1hjfiqps7a4at4ecdcf3yaqb5w3
X-Rspam-User: 
X-HE-Tag: 1756856766-93289
X-HE-Meta: U2FsdGVkX1+3DXaiM7Sx3EBsQQiooX+ic6P0QS0qPxM7ielUbog6m15L27TrGehHas9PFfnDYCPloDWa7BQYaz27Vgox1k4DIWjpKmGE6pbblZlDy6ejCWKC72xICT8Sn6Hytx5gWC0mMxHT/G/em1VOs8sDFqvZDaHQ20L3AKb3NXslaz9N+dIeHxA0luyod1h9PG7Je9esbQOHa50kcdRJ8udYdYIBnMZAI0WH0u2vYzOHe9QkQWporTQLLVWrCOhyprNqiXpABh+K7SoKFwTkOT889lT6zykhObKipNrMKPmwxNwqIraoGQtCs43wrruHsAK5tTqnnjX7atUdvVlKDW3y6aS5n4ATXtWnx9/2/MYvASikBPm62ZJUbOU9gRwTwh6xrC8avq7FvjV+8s6AwNJ4y5lUHW6EqFpFjir6j+4fTcY3VDnDyHk5K+x4iA/tiHiShD2YLWgnda6soH1OUOQSXpQeyt2aCBcoveK3Xqp4SXIPrDeGalWmGtRWbYLK69/i6e0jXeU2qn4eP+yUrUJLR1r0FdKfM7Wu8uNiwp39IwNv3QH4A01Uwf2nlUfPi2kkQX9YLahkl6i5DmuE6wpNbOKl4sbgxRLAjai9UKkiQtOSPF96WlduKk63WBwgQQe6oev57Fichvo79yMc7FMUbO11Acej7RvnJHUzK62J6sC3WcBXBxpCETRk6G9HZbpM95lXBJdolRIHzu7utzYKCdJvsDJ1KFZ6wCdEe81eUBjPQ0L/yjyyEuHHM30WmdCXRhEXvqpru6jKn7zG+5JwwOn5gny24Zs70X8UA15Cc2FwpBX+e2k4dUb9kmTMcL/C8iwcIVOSXk5kJ2dsbJESQ4XQBWeQeW1xF/1Kr9zm2/X9mUIM/YNFYcmtavfruQ2NbHxuAxtKTjUL1zfUtE/v0sPbAACYcdU315BJrywO21xIiu8fagilXgt0LYr7bk/hvPSEAX4kwIt
 Nni22ifo
 +/K+qqM4D4mc/EXGcPjU7d6CF5gtICcYucEtrNwcMWZUEUl3qToZCPdcH1VXo+qP7pafTHUTfyOfph4gh7T8hAtLhF42T6R1RxXsVb/fjizZubcGhlv2UeoWFWIbMpon+t7XSzGAOmRastZ1rjsjCRHqJss5fSRyuqy++zDMUST8AZBrQhG2vZ95SPLcUISyO7OgP+UlR7yABdD18WNYGP6ItqhaVyDaOjkfj9gcOU/PJhYcb/y58wOAStbNbKMG4A83MtsMiiRCC5PkMS4Slasse9HGEUv4mg504wEoQgaxARzFTuT0gq02NyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 04:39:42PM -0700, Joanne Koong wrote:
> Add granular dirty and writeback accounting for large folios. These
> stats are used by the mm layer for dirty balancing and throttling.
> Having granular dirty and writeback accounting helps prevent
> over-aggressive balancing and throttling.
> 
> There are 4 places in iomap this commit affects:
> a) filemap dirtying, which now calls filemap_dirty_folio_pages()
> b) writeback_iter with setting the wbc->no_stats_accounting bit and
> calling clear_dirty_for_io_stats()
> c) starting writeback, which now calls __folio_start_writeback()
> d) ending writeback, which now calls folio_end_writeback_pages()
> 
> This relies on using the ifs->state dirty bitmap to track dirty pages in
> the folio. As such, this can only be utilized on filesystems where the
> block size >= PAGE_SIZE.

Er... is this statement correct?  I thought that you wanted the granular
dirty page accounting when it's possible that individual sub-pages of a
folio could be dirty.

If i_blocksize >= PAGE_SIZE, then we'll have set the min folio order and
there will be exactly one (large) folio for a single fsblock.  Writeback
must happen in units of fsblocks, so there's no point in doing the extra
accounting calculations if there's only one fsblock.

Waitaminute, I think the logic to decide if you're going to use the
granular accounting is:

	(folio_size > PAGE_SIZE && folio_size > i_blocksize)

Hrm?

> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/iomap/buffered-io.c | 140 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 132 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 4f021dcaaffe..bf33a5361a39 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -20,6 +20,8 @@ struct iomap_folio_state {
>  	spinlock_t		state_lock;
>  	unsigned int		read_bytes_pending;
>  	atomic_t		write_bytes_pending;
> +	/* number of pages being currently written back */
> +	unsigned		nr_pages_writeback;
>  
>  	/*
>  	 * Each block has two bits in this bitmap:
> @@ -139,6 +141,29 @@ static unsigned ifs_next_clean_block(struct folio *folio,
>  		blks + start_blk) - blks;
>  }
>  
> +static unsigned ifs_count_dirty_pages(struct folio *folio)
> +{
> +	struct inode *inode = folio->mapping->host;
> +	unsigned block_size = i_blocksize(inode);
> +	unsigned start_blk, end_blk;
> +	unsigned blks, nblks = 0;
> +
> +	start_blk = 0;
> +	blks = i_blocks_per_folio(inode, folio);
> +	end_blk = (i_size_read(inode) - 1) >> inode->i_blkbits;
> +	end_blk = min(end_blk, i_blocks_per_folio(inode, folio) - 1);
> +
> +	while (start_blk <= end_blk) {
> +		start_blk = ifs_next_dirty_block(folio, start_blk, end_blk);
> +		if (start_blk > end_blk)
> +			break;

Use your new helper?

		nblks = ifs_next_clean_block(folio, start_blk + 1,
				end_blk) - start_blk?
> +		nblks++;
> +		start_blk++;
> +	}
> +
> +	return nblks * (block_size >> PAGE_SHIFT);

I think this returns the number of dirty basepages in a given large
folio?  If that's the case then shouldn't this return long, like
folio_nr_pages does?

> +}
> +
>  static unsigned ifs_find_dirty_range(struct folio *folio,
>  		struct iomap_folio_state *ifs, u64 *range_start, u64 range_end)
>  {
> @@ -220,6 +245,58 @@ static void iomap_set_range_dirty(struct folio *folio, size_t off, size_t len)
>  		ifs_set_range_dirty(folio, ifs, off, len);
>  }
>  
> +static long iomap_get_range_newly_dirtied(struct folio *folio, loff_t pos,
> +		unsigned len)

iomap_count_clean_pages() ?

--D

> +{
> +	struct inode *inode = folio->mapping->host;
> +	unsigned block_size = i_blocksize(inode);
> +	unsigned start_blk, end_blk;
> +	unsigned nblks = 0;
> +
> +	start_blk = pos >> inode->i_blkbits;
> +	end_blk = (pos + len - 1) >> inode->i_blkbits;
> +	end_blk = min(end_blk, i_blocks_per_folio(inode, folio) - 1);
> +
> +	while (start_blk <= end_blk) {
> +		/* count how many clean blocks there are */
> +		start_blk = ifs_next_clean_block(folio, start_blk, end_blk);
> +		if (start_blk > end_blk)
> +			break;
> +		nblks++;
> +		start_blk++;
> +	}
> +
> +	return nblks * (block_size >> PAGE_SHIFT);
> +}
> +
> +static bool iomap_granular_dirty_pages(struct folio *folio)
> +{
> +	struct iomap_folio_state *ifs = folio->private;
> +
> +	if (!ifs)
> +		return false;
> +
> +	return i_blocksize(folio->mapping->host) >= PAGE_SIZE;
> +}
> +
> +static bool iomap_dirty_folio_range(struct address_space *mapping,
> +			struct folio *folio, loff_t pos, unsigned len)
> +{
> +	long nr_new_dirty_pages;
> +
> +	if (!iomap_granular_dirty_pages(folio)) {
> +		iomap_set_range_dirty(folio, pos, len);
> +		return filemap_dirty_folio(mapping, folio);
> +	}
> +
> +	nr_new_dirty_pages = iomap_get_range_newly_dirtied(folio, pos, len);
> +	if (!nr_new_dirty_pages)
> +		return false;
> +
> +	iomap_set_range_dirty(folio, pos, len);
> +	return filemap_dirty_folio_pages(mapping, folio, nr_new_dirty_pages);
> +}
> +
>  static struct iomap_folio_state *ifs_alloc(struct inode *inode,
>  		struct folio *folio, unsigned int flags)
>  {
> @@ -712,8 +789,7 @@ bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio)
>  	size_t len = folio_size(folio);
>  
>  	ifs_alloc(inode, folio, 0);
> -	iomap_set_range_dirty(folio, 0, len);
> -	return filemap_dirty_folio(mapping, folio);
> +	return iomap_dirty_folio_range(mapping, folio, 0, len);
>  }
>  EXPORT_SYMBOL_GPL(iomap_dirty_folio);
>  
> @@ -937,8 +1013,8 @@ static bool __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
>  	if (unlikely(copied < len && !folio_test_uptodate(folio)))
>  		return false;
>  	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
> -	iomap_set_range_dirty(folio, offset_in_folio(folio, pos), copied);
> -	filemap_dirty_folio(inode->i_mapping, folio);
> +	iomap_dirty_folio_range(inode->i_mapping, folio,
> +			offset_in_folio(folio, pos), copied);
>  	return true;
>  }
>  
> @@ -1613,6 +1689,29 @@ void iomap_start_folio_write(struct inode *inode, struct folio *folio,
>  }
>  EXPORT_SYMBOL_GPL(iomap_start_folio_write);
>  
> +static void iomap_folio_start_writeback(struct folio *folio)
> +{
> +	struct iomap_folio_state *ifs = folio->private;
> +
> +	if (!iomap_granular_dirty_pages(folio))
> +		return folio_start_writeback(folio);
> +
> +	__folio_start_writeback(folio, false, ifs->nr_pages_writeback);
> +}
> +
> +static void iomap_folio_end_writeback(struct folio *folio)
> +{
> +	struct iomap_folio_state *ifs = folio->private;
> +	long nr_pages_writeback;
> +
> +	if (!iomap_granular_dirty_pages(folio))
> +		return folio_end_writeback(folio);
> +
> +	nr_pages_writeback = ifs->nr_pages_writeback;
> +	ifs->nr_pages_writeback = 0;
> +	folio_end_writeback_pages(folio, nr_pages_writeback);
> +}
> +
>  void iomap_finish_folio_write(struct inode *inode, struct folio *folio,
>  		size_t len)
>  {
> @@ -1622,7 +1721,7 @@ void iomap_finish_folio_write(struct inode *inode, struct folio *folio,
>  	WARN_ON_ONCE(ifs && atomic_read(&ifs->write_bytes_pending) <= 0);
>  
>  	if (!ifs || atomic_sub_and_test(len, &ifs->write_bytes_pending))
> -		folio_end_writeback(folio);
> +		iomap_folio_end_writeback(folio);
>  }
>  EXPORT_SYMBOL_GPL(iomap_finish_folio_write);
>  
> @@ -1710,6 +1809,21 @@ static bool iomap_writeback_handle_eof(struct folio *folio, struct inode *inode,
>  	return true;
>  }
>  
> +static void iomap_update_dirty_stats(struct folio *folio)
> +{
> +	struct iomap_folio_state *ifs = folio->private;
> +	long nr_dirty_pages;
> +
> +	if (iomap_granular_dirty_pages(folio)) {
> +		nr_dirty_pages = ifs_count_dirty_pages(folio);
> +		ifs->nr_pages_writeback = nr_dirty_pages;
> +	} else {
> +		nr_dirty_pages = folio_nr_pages(folio);
> +	}
> +
> +	clear_dirty_for_io_stats(folio, nr_dirty_pages);
> +}
> +
>  int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
>  {
>  	struct iomap_folio_state *ifs = folio->private;
> @@ -1727,6 +1841,8 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
>  
>  	trace_iomap_writeback_folio(inode, pos, folio_size(folio));
>  
> +	iomap_update_dirty_stats(folio);
> +
>  	if (!iomap_writeback_handle_eof(folio, inode, &end_pos))
>  		return 0;
>  	WARN_ON_ONCE(end_pos <= pos);
> @@ -1734,6 +1850,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
>  	if (i_blocks_per_folio(inode, folio) > 1) {
>  		if (!ifs) {
>  			ifs = ifs_alloc(inode, folio, 0);
> +			ifs->nr_pages_writeback = folio_nr_pages(folio);
>  			iomap_set_range_dirty(folio, 0, end_pos - pos);
>  		}
>  
> @@ -1751,7 +1868,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
>  	 * Set the writeback bit ASAP, as the I/O completion for the single
>  	 * block per folio case happen hit as soon as we're submitting the bio.
>  	 */
> -	folio_start_writeback(folio);
> +	iomap_folio_start_writeback(folio);
>  
>  	/*
>  	 * Walk through the folio to find dirty areas to write back.
> @@ -1784,10 +1901,10 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
>  	 */
>  	if (ifs) {
>  		if (atomic_dec_and_test(&ifs->write_bytes_pending))
> -			folio_end_writeback(folio);
> +			iomap_folio_end_writeback(folio);
>  	} else {
>  		if (!wb_pending)
> -			folio_end_writeback(folio);
> +			iomap_folio_end_writeback(folio);
>  	}
>  	mapping_set_error(inode->i_mapping, error);
>  	return error;
> @@ -1809,6 +1926,13 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
>  			PF_MEMALLOC))
>  		return -EIO;
>  
> +	/*
> +	 * iomap opts out of the default wbc stats accounting because it does
> +	 * its own granular dirty/writeback accounting (see
> +	 * iomap_update_dirty_stats()).
> +	 */
> +	wpc->wbc->no_stats_accounting = true;
> +
>  	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error))) {
>  		error = iomap_writeback_folio(wpc, folio);
>  		folio_unlock(folio);
> -- 
> 2.47.3
> 
> 

