Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4593DCA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 19:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D198E000A; Wed,  3 Sep 2025 15:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED868E0001; Wed,  3 Sep 2025 15:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B0E8E000A; Wed,  3 Sep 2025 15:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 826588E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:59:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BC2D1A086F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:59:17 +0000 (UTC)
X-FDA: 83849003154.19.C115407
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 76B47C0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:59:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bX63U8aU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756929555; a=rsa-sha256;
	cv=none;
	b=X0LFxZIeH5p19Qq11DpiSP8o5Vh7zSFCVPn6GvEsRm7N4VYQ+Hep3wbsW+rtJDW+v4ygrn
	6Sdh25ykfRqGq75NL0tAx6nqkLFfXs2AU9oWr4xClyNZ3prly4i93HgVnF0YiFfAR+AgYA
	hsuq9ig1ZS89jJ5QKd8ZkmszCgnR+I0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bX63U8aU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756929555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6qXBxUtO5lCHnfICV1SkqXW5RoXvSvvwOdRQPrRlpk=;
	b=MGF5KOzPLoB01z4q+ym4ZscnzYzkpZbZesjfkINvMPGW6UkqclIz1SnV5YxOpmdxkR6b6Z
	S2tSOm2LIamjTDxVI0cV9r/P+8C0Ia3lfCW+hC3jp7JwA4i56jD9WrXD5DLevk2aO9xyJ/
	HXkJpT7ozwHV+X8kufL6qurL2PAUgv0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 163AE433AB;
	Wed,  3 Sep 2025 19:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57F9C4CEE7;
	Wed,  3 Sep 2025 19:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756929554;
	bh=2z9kS7xFX2YHHT9aFQOsDh2+yGO/NVq4empiwKxtveM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bX63U8aU7N0uHcqoesYm9ICut+eUMp10p2j2uLfFeXed7mIRBiENbsPMq1xhtchPj
	 AlX+c6OaQSbM8oE8GKksb38cdxmrvny9py6TyZIJCCKX8KOF5v6TEoYVS/PrPSxvkD
	 pXbidS31hWJQkiic7Y1q/1/NUIWSO64NEyHimCz906LOJuQ+tcxbKropQhp+tKdygz
	 oM5yHbr4xuiJg05hB2sjt1kQpcuytA5lEWDSYs0hs09Fvuw+ycB95Tu+rxJxjCgr46
	 Sbl5caqVzm5xWKOnv1sEqtLvfmNn9WFeMwN1c8kvvIsoyGm3EjHCIEPf3E8aTugQtR
	 NfTBF7fvzbzJg==
Date: Wed, 3 Sep 2025 12:59:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
	brauner@kernel.org, willy@infradead.org, jack@suse.cz,
	hch@infradead.org, jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 10/12] iomap: refactor dirty bitmap iteration
Message-ID: <20250903195913.GI1587915@frogsfrogsfrogs>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-11-joannelkoong@gmail.com>
 <aLiOrcetNAvjvjtk@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLiOrcetNAvjvjtk@bfoster>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 76B47C0002
X-Stat-Signature: yxdm41ys15atpwq93ymo9xiwo6kkn7i8
X-HE-Tag: 1756929555-103886
X-HE-Meta: U2FsdGVkX18HvRuKP6j958dJFmxEQELmQcleEws2cicKxJemu2vx3lsZZV8EfWJ50c9VWkNAVq+bTFYcl6pHdodXUDSWIh6TD2zbQ6oyF+b64Riq+Pb9ss9PVKZIJMhhv0LAEYiigQnE0vs2EhmaeXw7eAEg05NnJP+n07osvBosoIYb5CPa7323cr6rKvEp8lXExAy69UX7LICTlX/8L7GKXNitK0wvm+lnE5mcSesrv9WzaeZ/NqvHOGvDrTwfqup/XGM9oUXsd/FuJdVbTcKx1GcMMnb2IDjged99Wm+hTTRUYH1DpCQmUBupFwanSfRGfs9KD7h/dMC/aFXDpT0lZT3/2gieBXt8UYmqiKVpsyQfUlUk3j/XfuYo5GRc3bzuvnqDOGa3LdVqvtU1sC3sSGNt4/igNQ+CpuPKpdr1pmZFKJyK4V45aed8JSCBvzGm1cZv4NyjkvOBUP6Giwyz0a9FVXwn7Pnn0kIWlOragPY0wbiM+r7V0aCALjet7srhpenYctICRSWjuY3zMRxzZDXS7jKJeh4kKV5xwUI+DHGS3w5WT4RX+exBmR+tWkXDfMgfWD0sitN1uINSuyJeFsnABRRQq0sjdqZXzs306E6Cs7UY6ECuJgKWcTc28Me56HwbUaimmZDRBWqmLf9Z6OJZX0d4ivQ/vP80rrpxN0rBCaw1kiwu4A2p1IS2lznGzjCk/fD0liY+chNs5dwvPpRN/vDDd5ZSElCAtL9otZy6yUJorbeYi9GSnTYo8LnI+5J3EAfap6meSWpp9Vx6U5YruRcw+Ku37T0Lk8i8WTl66MLQZ+AniChoN+evW2j0A/vdKoL9vwWnkagY98xFTFHtH4UtwquRroR967ZraX4J6yLAvDaIiPpsIfjmo560CN2Uo/j5WHD3JO1AC8SwiYK/thPvnFU4hf6c+ZYmI0VGa9xbbY8zlQ7JV97aWjmkzs4+i7+rlHUyZpC
 4aoXbRpI
 Gj/+Dt+t+rbJlUXWsGjQ3Vah7/ZlhBpxXhaaQ9KAvtrFEtMyLy59i/TQf6zNPFDYeS+PW2sDhUNFnCmYziAw9ShA8e4uBwE6i8PUIWTm+AOOr3sXteJxM9JRgBDgvSFdEQafoN0LzTcl+3oCaBJZ48P6fRbQBgIe1V2LZwLKoORgMu3zN7bSu5iBplFMx9nEcwvY+fnHEiTGFe+xoILDQ+VNR6D+3wA/g2m0M3KBR18hhw2nKFxDWaZt2SjU35vBCuX4vWFg0RE9icJVIGwaoklfwNPmIwbEBb4OU1p7HM3cwsz5SRETj5bnPq3BsjdRoWDK8I0CCgYdLXbPpgsvY81VDZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 02:53:33PM -0400, Brian Foster wrote:
> On Fri, Aug 29, 2025 at 04:39:40PM -0700, Joanne Koong wrote:
> > Use find_next_bit()/find_next_zero_bit() for iomap dirty bitmap
> > iteration. This uses __ffs() internally and is more efficient for
> > finding the next dirty or clean bit than manually iterating through the
> > bitmap range testing every bit.
> > 
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > ---
> >  fs/iomap/buffered-io.c | 67 ++++++++++++++++++++++++++++++------------
> >  1 file changed, 48 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index fd827398afd2..dc1a1f371412 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -75,13 +75,42 @@ static void iomap_set_range_uptodate(struct folio *folio, size_t off,
> >  		folio_mark_uptodate(folio);
> >  }
> >  
> > -static inline bool ifs_block_is_dirty(struct folio *folio,
> > -		struct iomap_folio_state *ifs, int block)
> > +/**
> > + * ifs_next_dirty_block - find the next dirty block in the folio
> > + * @folio: The folio
> > + * @start_blk: Block number to begin searching at
> > + * @end_blk: Last block number (inclusive) to search
> > + *
> > + * If no dirty block is found, this will return end_blk + 1.
> > + */
> > +static unsigned ifs_next_dirty_block(struct folio *folio,
> > +		unsigned start_blk, unsigned end_blk)
> >  {
> > +	struct iomap_folio_state *ifs = folio->private;
> >  	struct inode *inode = folio->mapping->host;
> > -	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> > +	unsigned int blks = i_blocks_per_folio(inode, folio);
> > +
> > +	return find_next_bit(ifs->state, blks + end_blk + 1,
> > +		blks + start_blk) - blks;
> > +}
> > +
> > +/**
> > + * ifs_next_clean_block - find the next clean block in the folio
> > + * @folio: The folio
> > + * @start_blk: Block number to begin searching at
> > + * @end_blk: Last block number (inclusive) to search
> > + *
> > + * If no clean block is found, this will return end_blk + 1.
> > + */
> > +static unsigned ifs_next_clean_block(struct folio *folio,
> > +		unsigned start_blk, unsigned end_blk)
> > +{
> > +	struct iomap_folio_state *ifs = folio->private;
> > +	struct inode *inode = folio->mapping->host;
> > +	unsigned int blks = i_blocks_per_folio(inode, folio);
> >  
> > -	return test_bit(block + blks_per_folio, ifs->state);
> > +	return find_next_zero_bit(ifs->state, blks + end_blk + 1,
> > +		blks + start_blk) - blks;
> >  }
> >  
> >  static unsigned ifs_find_dirty_range(struct folio *folio,
> > @@ -92,18 +121,15 @@ static unsigned ifs_find_dirty_range(struct folio *folio,
> >  		offset_in_folio(folio, *range_start) >> inode->i_blkbits;
> >  	unsigned end_blk = min_not_zero(
> >  		offset_in_folio(folio, range_end) >> inode->i_blkbits,
> > -		i_blocks_per_folio(inode, folio));
> > -	unsigned nblks = 1;
> > +		i_blocks_per_folio(inode, folio)) - 1;
> > +	unsigned nblks;
> >  
> > -	while (!ifs_block_is_dirty(folio, ifs, start_blk))
> > -		if (++start_blk == end_blk)
> > -			return 0;
> > +	start_blk = ifs_next_dirty_block(folio, start_blk, end_blk);
> > +	if (start_blk > end_blk)
> > +		return 0;
> >  
> > -	while (start_blk + nblks < end_blk) {
> > -		if (!ifs_block_is_dirty(folio, ifs, start_blk + nblks))
> > -			break;
> > -		nblks++;
> > -	}
> > +	nblks = ifs_next_clean_block(folio, start_blk + 1, end_blk)
> > +		- start_blk;
> 
> Not a critical problem since it looks like the helper bumps end_blk, but
> something that stands out to me here as mildly annoying is that we check
> for (start > end) just above, clearly implying that start == end is
> possible, then go and pass start + 1 and end to the next call. It's not
> clear to me if that's worth changing to make end exclusive, but may be
> worth thinking about if you haven't already..

<nod> I was also wondering if there were overflow possibilities here.

> Brian
> 
> >  
> >  	*range_start = folio_pos(folio) + (start_blk << inode->i_blkbits);
> >  	return nblks << inode->i_blkbits;
> > @@ -1077,7 +1103,7 @@ static void iomap_write_delalloc_ifs_punch(struct inode *inode,
> >  		struct folio *folio, loff_t start_byte, loff_t end_byte,
> >  		struct iomap *iomap, iomap_punch_t punch)
> >  {
> > -	unsigned int first_blk, last_blk, i;
> > +	unsigned int first_blk, last_blk;
> >  	loff_t last_byte;
> >  	u8 blkbits = inode->i_blkbits;
> >  	struct iomap_folio_state *ifs;
> > @@ -1096,10 +1122,13 @@ static void iomap_write_delalloc_ifs_punch(struct inode *inode,
> >  			folio_pos(folio) + folio_size(folio) - 1);
> >  	first_blk = offset_in_folio(folio, start_byte) >> blkbits;
> >  	last_blk = offset_in_folio(folio, last_byte) >> blkbits;
> > -	for (i = first_blk; i <= last_blk; i++) {
> > -		if (!ifs_block_is_dirty(folio, ifs, i))
> > -			punch(inode, folio_pos(folio) + (i << blkbits),
> > -				    1 << blkbits, iomap);
> > +	while (first_blk <= last_blk) {
> > +		first_blk = ifs_next_clean_block(folio, first_blk, last_blk);
> > +		if (first_blk > last_blk)
> > +			break;

I was wondering if the loop control logic would be cleaner done as a for
loop and came up with this monstrosity:

	for (first_blk = ifs_next_clean_block(folio, first_blk, last_blk);
	     first_blk <= last_blk;
	     first_blk = ifs_next_clean_block(folio, first_blk + 1, last_blk)) {
		punch(inode, folio_pos(folio) + (first_blk << blkbits),
		      1 << blkbits, iomap);
	}

Yeah.... better living through macros?

#define for_each_clean_block(folio, blk, last_blk) \
	for ((blk) = ifs_next_clean_block((folio), (blk), (last_blk));
	     (blk) <= (last_blk);
	     (blk) = ifs_next_clean_block((folio), (blk) + 1, (last_blk)))

Somewhat cleaner:

	for_each_clean_block(folio, first_blk, last_blk)
		punch(inode, folio_pos(folio) + (first_blk << blkbits),
		      1 << blkbits, iomap);

<shrug>

--D

> > +		punch(inode, folio_pos(folio) + (first_blk << blkbits),
> > +			1 << blkbits, iomap);
> > +		first_blk++;
> >  	}
> >  }
> >  
> > -- 
> > 2.47.3
> > 
> > 
> 
> 

