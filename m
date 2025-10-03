Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E98CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 03:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31FFC8E0005; Thu,  2 Oct 2025 23:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D06C8E0001; Thu,  2 Oct 2025 23:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E71C8E0005; Thu,  2 Oct 2025 23:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F071F8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 23:32:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 837A911AB4C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 03:32:47 +0000 (UTC)
X-FDA: 83955381174.03.4D4A6FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id F385B140009
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 03:32:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cOp8nugQ;
	spf=pass (imf23.hostedemail.com: domain of mcgrof@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mcgrof@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759462366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CrrxdNJl0qNMWCotNO6t3F2vvc+vVus288/HH8Em4us=;
	b=RDUsn5E9+I91T9R74yKnpWyFjhG0zc/sKTqf22LxtYJufO5wsA9ZMqd6Dg6szavFF6CvW3
	+d+p7EvEqmLvHSCc5nwGdIZ8tr1QHmS1aNncdHg1TDIIxxp+tqk5zoyKwSCG5CW3RbdqzZ
	gXhVJ50z2AQ8kvUPq8BfXLUT5EwXGtc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cOp8nugQ;
	spf=pass (imf23.hostedemail.com: domain of mcgrof@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mcgrof@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759462366; a=rsa-sha256;
	cv=none;
	b=f1sZYtMpi8Q4o+el3q3/+99mgjcTi1zpagfHzVqjYZoWGx9FsRzkgMH1LaOI4Qlue6scGe
	kTLmOm/cWoPi25v+Ci3CWvcm9wo3wp6EcWD1mxXwdMPjtGGUSWhIUApdRCncGdvBEkCpuL
	nlMlzAoEEXAMaenpUYoJzLdtCkDbLpc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE87060266;
	Fri,  3 Oct 2025 03:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3F8C4CEF4;
	Fri,  3 Oct 2025 03:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759462364;
	bh=96e3HGl+7WhLYhSvukvzteCOQvbteUjJBOeOHHD/CPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cOp8nugQ/AOVVf5et4wxbMCmSkHuQdiTWYTVenPTeMrV6f7Ne6yks+sOabLJ7zuoy
	 SNewlwWW3Uk4+033GyFyM2BtfDs+ColjEiA60PGpjcf35+DyHwxkFuiC+r1L6Iozas
	 pZzKNql0z4hzlk+6A4n77Vd3JjiWBLjoCf7w47Fm2X9JkLnuPbUfbaUQvna8buXi83
	 wCuWjdlfVKeezTwC0i1GMznrCTiZhk9kGS467SEi/j6MW0pAyhexpnrYDlZd/UA6xA
	 kLtlMjUUhVaVvXoNYLTTwVFAySrN4762XA7aA7GNYgLE+u4GKbNFyA5/QDj0lWbvNo
	 bZnmdFDkRA0ig==
Date: Thu, 2 Oct 2025 20:32:42 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Linux-MM <linux-mm@kvack.org>,
	Swarna Prabhu <s.prabhu@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Devasena Inupakutika <devasena.i@samsung.com>
Subject: Re: Optimizing small reads
Message-ID: <aN9D2i4qOroaktSc@bombadil.infradead.org>
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
X-Rspamd-Queue-Id: F385B140009
X-Stat-Signature: he8prpcahw8j4zii68ypb4rt3wtqkg7h
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759462365-439179
X-HE-Meta: U2FsdGVkX18Qxpm3fadXfFt3mM9sXZblkLlfzJrCw5S4jRnWabbYviUBf8PeDU+pNIlz3Tw9jV48593yH+TX1wg0JXJOh0sWw/xjCE1aJsQbcgRd/Sb7IaiqkOmHa660WaD6AFCVZ7von5IybQctp1MztFqwzMkvhHh1hio2z3jrl8Z73E1I4MkjgK89Pz1ySk1Qf3qBiCoozcTwNl4o/0MSg0ni4YW1JGCe7aODEW5ki4X33JECbRfUMElXZ1AppGHooOcFRnRGIPaYOdv/PNvIq3yGuNJgrEM/13YG4dBg+anwnX6bYOoX8OuJqbh+jgXMLX/Sxc9iVnt8MuZQQ/1ssYKrBViIyYSlCHRE+dS+JqnIDkbQ0HAaUW4wbDx7/+8dPZ8W22FvqqTn5RXbe03pZmEUtlKl4OIIS5Z9f06oiXc1S4kgSg/S6NYjsD+jFxS3BmrhpTQ/d1zFpGpg3dIGPCkdH3RYqZI/Zs9XSLh2Xgj2MInuvBjs0HyCWxhVfpwb4sP/GQKX91ybsd+OsuP9FyCZRbb+MtTukRHiHWaUhahfcy8hK6KbG1axG+N5PiHiU3CSO6AzGwJLTXgfGEOnF0fkPUKLwbM0ovgDD1IbzvhqkTBtylbIu5qmQoYp57CXzqjisquxdnuhauOdhq5ipLvN0coRhjxx+B3NyUWIjpkDYr0ehs2S4YdI7sBLqaclSIc1FwjauUtAIhQLJc7Q4tP3yo3unTnBiUjLUnsk2CAKxjZg54o1TYAuucE/jsKBHmiLrpPI9x3+r9WqPPOv9EskCfN+uqf47sxE68CENs+zhypvoMIcwgoteopeokY5xtL8ExUItHFqRxm5GdrDmBX7km5d0Iv8B4nVqsW/8bcDVPZuswfuCY0CXRJ8pHPsrKXQ4kDw5gMgk+QTYdIlcQT7A4UJ414LssWfVk/yKULW+aWTBKlPAVp9PdwYHroHn4OPOpmFeTt+GrJ
 u6Xq+PdK
 qblQIrceKxnByLNLJAs9zJINxydouD+R8puaSb8XF/t0c/OgXdy2+bIKn2F2Rd98sOtZRQcDleRZJLZcrAeFEDhi1pk/4+a8uA6IBh4xPgjD7wcz+bj6QXkyZqVR/0eKMPQC8wqEolIEKeayz5Zygo7+PeTjkd95HakjTZjXVLDP0ylVRsEI74YjjxNeY6d67G0rhC/iW/otZ21iu2+fEZmL4jC82lp4FJ0b7SgDlJvxnSmLSWrI3wj3cxSihulUE3/fePBaF26Hb0wYW3ksABV3WbZy24bMPX0rw1GdGsIT9pMCr4kHU2GqVDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 07:18:35PM -0700, Linus Torvalds wrote:
> Willy,
>  I've literally been running this patch in my tree now for 18 months,
> and have never seen any issues. However back when I posted it
> originally, Luis reported that it caused failures on xfstest
> 
>   * generic/095
>   * generic/741
> 
> although I still have no idea how that could happen. I've looked at
> the patch occasionally over the months I've been carrying it, trying
> to figure out how it could possibly matter, and have never figured it
> out.
> 
> I'm not planning on moving it to my mainline tree now either, but I
> decided I might as well at least repost it to see if somebody else has
> any interest or comments on it.

Indeed, we do, I had asked our of new hires to verify the above two test
failures, as it seems like a good candidate for someone new to jump in
and analyze.

> The impetus for this patch is
> obviously from your posting back in early 2024 about some real user
> that did a lot of really small reads. It still sounds like a very odd
> load to me, but apparently there was a good real-life reason for it.

Its actually not odd, I've been trying to dig into "what workload could
this be", and there a few answers. The top one on my radar is the read
amplification incurred through through vector DBs on billion scale low
latency requirements, due to re-ranking due to PQ compression. Since PQ is
lossy, even if you want the top k candidates you need to re-rank, and
k_candidates is much larger than k. The issue it each candidate may lie in
different disk LBAs. PQ compressed vectors are kept in GPU memory and
their raw vectors on SSDs.

I found a clever algorithm callfed FusionANNs which shows how you can
optimize the vectors which are likely related to each other so they are
placed near each other [0] proving the software sucks and could be
improved. However I'm not aware of an open source version of this
algorithm, so we're looking to write one and test its impact.

> I still think this patch actually looks quite nice - which surprised
> me when I wrote it originally. I started out writing it as a "let's
> see what this hacky thing results in", but it didn't turn out very
> hacky at all.

Yes, its a quite bueatiful hack.

> And it looks ridiculously good on some strange small-read benchmarks,
> although I say that purely from memory, since I've long since lost the
> code that tested this. Now it's been "tested" purely by virtue of
> basically being something I've been running on my own machine for a
> long time.
> 
> Anyway, feel free to ignore it. I can keep carrying this patch in my
> local tree forever or until it actually causes more conflicts than I
> feel comfortable keeping around. But so far in the last 18+ months it
> has never caused any real pain (I have my own tree that contains a few
> random patches for other reasons anyway, although lately this has
> actually been the biggest of that little lot).

Trust me that this is being looked at :)

We had some other ideas too... but this is far out from anything ready.

However since there was no *rush* I figured its a nice candidate effort
to get someone new to hack on the kernel. So give us a bit of time and
will surely justify its merit with a clear workload, and with a thorough
dig why its failing on the above.
 
  Luis

> 
>              Linus

> From bf11d657e1f9a010ae0253feb27c2471b897d25d Mon Sep 17 00:00:00 2001
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 26 Feb 2024 15:18:44 -0800
> Subject: [PATCH] mm/filemap: do small reads in RCU-mode read without refcounts
> 
> Hackety hack hack concept from report by Willy.
> 
> Mommy, I'm scared.
> 
> Link: https://lore.kernel.org/all/Zduto30LUEqIHg4h@casper.infradead.org/
> Not-yet-signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  mm/filemap.c | 137 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 127 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a52dd38d2b4a..f15bc1108585 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2677,6 +2677,96 @@ static void filemap_end_dropbehind_read(struct folio *folio)
>  	}
>  }
>  
> +/*
> + * I can't be bothered to care about HIGHMEM for the fast read case
> + */
> +#ifdef CONFIG_HIGHMEM
> +#define filemap_fast_read(mapping, pos, buffer, size) 0
> +#else
> +
> +/*
> + * Called under RCU with size limited to the file size and one page
> + */
> +static inline unsigned long filemap_folio_copy_rcu(struct address_space *mapping, loff_t pos, char *buffer, size_t size)
> +{
> +	struct inode *inode;
> +	loff_t file_size;
> +	XA_STATE(xas, &mapping->i_pages, pos >> PAGE_SHIFT);
> +	struct folio *folio;
> +	size_t offset;
> +
> +	/* Limit it to the file size */
> +	inode = mapping->host;
> +	file_size = i_size_read(inode);
> +	if (unlikely(pos >= file_size))
> +		return 0;
> +	if (size > file_size - pos)
> +		size = file_size - pos;
> +
> +	xas_reset(&xas);
> +	folio = xas_load(&xas);
> +	if (xas_retry(&xas, folio))
> +		return 0;
> +
> +	if (!folio || xa_is_value(folio))
> +		return 0;
> +
> +	if (!folio_test_uptodate(folio))
> +		return 0;
> +
> +	/* No fast-case if we are supposed to start readahead */
> +	if (folio_test_readahead(folio))
> +		return 0;
> +	/* .. or mark it accessed */
> +	if (!folio_test_referenced(folio))
> +		return 0;
> +
> +	/* Do the data copy */
> +	offset = pos & (folio_size(folio) - 1);
> +	memcpy(buffer, folio_address(folio) + offset, size);
> +
> +	/*
> +	 * After we've copied the data from the folio,
> +	 * do some final sanity checks.
> +	 */
> +	smp_rmb();
> +
> +	if (unlikely(folio != xas_reload(&xas)))
> +		return 0;
> +
> +	/*
> +	 * This is just a heuristic: somebody could still truncate and then
> +	 * write to extend it to the same size..
> +	 */
> +	if (file_size != inode->i_size)
> +		return 0;
> +
> +	return size;
> +}
> +
> +/*
> + * Iff we can complete the read completely in one atomic go under RCU,
> + * do so here. Otherwise return 0 (no partial reads, please - this is
> + * purely for the trivial fast case).
> + */
> +static inline unsigned long filemap_fast_read(struct address_space *mapping, loff_t pos, char *buffer, size_t size)
> +{
> +	unsigned long pgoff;
> +
> +	/* Don't even try for page-crossers */
> +	pgoff = pos & ~PAGE_MASK;
> +	if (pgoff + size > PAGE_SIZE)
> +		return 0;
> +
> +	/* Let's see if we can just do the read under RCU */
> +	rcu_read_lock();
> +	size = filemap_folio_copy_rcu(mapping, pos, buffer, size);
> +	rcu_read_unlock();
> +
> +	return size;
> +}
> +#endif /* !HIGHMEM */
> +
>  /**
>   * filemap_read - Read data from the page cache.
>   * @iocb: The iocb to read.
> @@ -2697,7 +2787,10 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  	struct file_ra_state *ra = &filp->f_ra;
>  	struct address_space *mapping = filp->f_mapping;
>  	struct inode *inode = mapping->host;
> -	struct folio_batch fbatch;
> +	union {
> +		struct folio_batch fbatch;
> +		__DECLARE_FLEX_ARRAY(char, buffer);
> +	} area __uninitialized;
>  	int i, error = 0;
>  	bool writably_mapped;
>  	loff_t isize, end_offset;
> @@ -2711,7 +2804,31 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  		return 0;
>  
>  	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
> -	folio_batch_init(&fbatch);
> +
> +	/*
> +	 * Try a quick lockless read into the 'area' union. Note that
> +	 * this union is intentionally marked "__uninitialized", because
> +	 * any compiler initialization would be pointless since this
> +	 * can fill it will garbage.
> +	 */
> +	if (iov_iter_count(iter) <= sizeof(area)) {
> +		unsigned long count = iov_iter_count(iter);
> +
> +		count = filemap_fast_read(mapping, iocb->ki_pos, area.buffer, count);
> +		if (count) {
> +			size_t copied = copy_to_iter(area.buffer, count, iter);
> +			if (unlikely(!copied))
> +				return already_read ? already_read : -EFAULT;
> +			ra->prev_pos = iocb->ki_pos += copied;
> +			file_accessed(filp);
> +			return copied + already_read;
> +		}
> +	}
> +
> +	/*
> +	 * This actually properly initializes the fbatch for the slow case
> +	 */
> +	folio_batch_init(&area.fbatch);
>  
>  	do {
>  		cond_resched();
> @@ -2727,7 +2844,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  		if (unlikely(iocb->ki_pos >= i_size_read(inode)))
>  			break;
>  
> -		error = filemap_get_pages(iocb, iter->count, &fbatch, false);
> +		error = filemap_get_pages(iocb, iter->count, &area.fbatch, false);
>  		if (error < 0)
>  			break;
>  
> @@ -2755,11 +2872,11 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  		 * mark it as accessed the first time.
>  		 */
>  		if (!pos_same_folio(iocb->ki_pos, last_pos - 1,
> -				    fbatch.folios[0]))
> -			folio_mark_accessed(fbatch.folios[0]);
> +				    area.fbatch.folios[0]))
> +			folio_mark_accessed(area.fbatch.folios[0]);
>  
> -		for (i = 0; i < folio_batch_count(&fbatch); i++) {
> -			struct folio *folio = fbatch.folios[i];
> +		for (i = 0; i < folio_batch_count(&area.fbatch); i++) {
> +			struct folio *folio = area.fbatch.folios[i];
>  			size_t fsize = folio_size(folio);
>  			size_t offset = iocb->ki_pos & (fsize - 1);
>  			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
> @@ -2790,13 +2907,13 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  			}
>  		}
>  put_folios:
> -		for (i = 0; i < folio_batch_count(&fbatch); i++) {
> -			struct folio *folio = fbatch.folios[i];
> +		for (i = 0; i < folio_batch_count(&area.fbatch); i++) {
> +			struct folio *folio = area.fbatch.folios[i];
>  
>  			filemap_end_dropbehind_read(folio);
>  			folio_put(folio);
>  		}
> -		folio_batch_init(&fbatch);
> +		folio_batch_init(&area.fbatch);
>  	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
>  
>  	file_accessed(filp);
> -- 
> 2.51.0.419.gf70362ddf4
> 


