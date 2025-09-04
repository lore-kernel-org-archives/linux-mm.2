Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27641CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 02:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8196B8E0007; Wed,  3 Sep 2025 22:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0938E0001; Wed,  3 Sep 2025 22:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D7E8E0007; Wed,  3 Sep 2025 22:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 620B28E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:52:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11DBF13BC3E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:52:14 +0000 (UTC)
X-FDA: 83850043788.05.0648E9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6490140003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:52:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zxkkfcvk;
	spf=pass (imf04.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756954332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+mYOj5URupG9CJcSDx0w4kw+gJPvykQGLePY0//CXks=;
	b=nPun2zqKUPlOpCa4YFSJFmfwB64c0TRjlhOOMQRPzWTkszVmSUw51bFuRCb6D48W02QCjT
	1dMBgvpdl6SnpZ2aLbY0uAhivE0e6aT0lPDwPZoZJYkyqiUAk5RB+BDnmQLyi/zZhCbasj
	J/AtDVk/9aGjaq1htieMyWzIkxZIRNQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zxkkfcvk;
	spf=pass (imf04.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756954332; a=rsa-sha256;
	cv=none;
	b=4e8ulEfeJrVb27+forZwrmG4d5483/ySXBA5bvOnT2CXsyYC6xNDcIhTRLdj31N5GGdkXi
	OfjrzJD9EozoQDvpDw1GnF+f1R4jwcKG3Ppy+fqdW8B/RIJa1HVTid0I/bAkC0VHfuwbvo
	+yGNwbIjkP26lHA+dd1NBKShcFfAV1M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7829C60193;
	Thu,  4 Sep 2025 02:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200EEC4CEE7;
	Thu,  4 Sep 2025 02:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756954331;
	bh=0i5DJbuZmuI9Lfzk2IUVqKWbuk8qk3AIewdepbN4OQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zxkkfcvk+tOhmVcWR5704KzmEJJAw2+QiJdUGDQ0qOTc/Ok3zL8ufJJpxoXJw+wkN
	 ylAbLjmwmdPOtKaTnNRx670rpJSeg9F1UCF4Q5veef5CvOQD1panwvLubGD+5mKbOF
	 8x5/Btpxxs1AFmRFRd6Am8FbwEKGTOh8E1yx8YittKk22VQFZia+1/3pz10YtBJPo7
	 yyfjuDDRDlymAbsQfSnUtbCNxH1b+GGRp1JnPcGlXrWfEY3oqmBmloiwkk07K7TRxq
	 jorh4ovJ7RK0EGwdUKmlf5dRu/PPiHiRsmTV00kE9t51bdtsZa7++LDANmt/adK8UH
	 V5Z9Dg9wATfBQ==
Date: Wed, 3 Sep 2025 19:52:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-mm@kvack.org,
	brauner@kernel.org, willy@infradead.org, jack@suse.cz,
	hch@infradead.org, jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 12/12] iomap: add granular dirty and writeback
 accounting
Message-ID: <20250904025210.GO8117@frogsfrogsfrogs>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-13-joannelkoong@gmail.com>
 <20250902234604.GC1587915@frogsfrogsfrogs>
 <aLiNYdLaMIslxySo@bfoster>
 <CAJnrk1Z6qKqkOwHJwaBfE9FEGABGD4JKoEwNbRJTpOWL-VtPrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1Z6qKqkOwHJwaBfE9FEGABGD4JKoEwNbRJTpOWL-VtPrg@mail.gmail.com>
X-Rspamd-Queue-Id: 6490140003
X-Rspam-User: 
X-Stat-Signature: h1jy4k4bay9pmuahmfkma6rxrmbsyuzz
X-Rspamd-Server: rspam09
X-HE-Tag: 1756954332-682567
X-HE-Meta: U2FsdGVkX1/ftkVh41XZkJbu85dNoCuaAzmnTkk6orhLH2FWtWUSefqVcBrUdoATzpOCUsOy8bL/E5d0ONxYLSIyYuthSdUIyHTS9UZCtjHlEuPs2D+PDHSAjzVdKA5CkoHeoENWnSc8DTHIIyPVMT7xOg2kTxr+Kjx20tUBBdFYiiN/d76vGnOOBCzLBOFkeoXJA1s6Jf15xSpvi1QQ0GqPQdbVHm16++9E8PWGs9MA/H1W3GZ1uPZppwwqbaJCTIsIbJje7kSuna/QRnE3itPIb29ZX1uiyry7QXOAuN/jwmKBBh29esmsX7X2afNvjD3fqZsp7cozNk8Hj+gSDVFe8dkQBCnxmHoK2AKxYy8jaFxOhYHEeBYDiwiVgWxzLOl0TFnPWyFW84lLqrNRwaz+kVDCu+hkfXzzimYeyHo+x+4tGghYCqnnGTJlL0UcSvKTBGEi+dNRs0JE12Vl0kme08LDJyyM4a/3TmZ1KZmX/slBx9DcZBTPbhtpHYgoyJhzQ8ntIXWqh2kB5qf74yoVEorfVpzE+XyMcR+Nfs3+st2gfs7KNwG4fGtUH7WEJjS5yB0GAx1FgER/+StnNn+Gf0I3dOovtux/+leKxHp66ZMtBNfGkODH1ixl523kfj3uWajVnDcJRZgFs9KZ8j1SuPzW/yGQ0Ce8qg5zSe+3a5dUAmEnSn7yr2P72wFIytNC9FQRrwQflOMFgdxp0QGlnNPFab0DaNEgA4BS2sY9fYqm/CCiZ22rZsssWwPwpid4qn1fheKWs0wFPiW9dX4DbkKI67eZDPb0FxCcATHF757D+dQhBTAxUCukLI/+r3UgJIOYi1qWaZZKYibVYZo0Q8oEsFWdMNntGY7J/GlceIkr898V75qdRYjtF/9fyhUOsLN24rAxUUV0vC8ZMqtLEOoYNOW8dEArmYeOyDiHQbRflYh9G/Gh8l4/WeEmBaqbT/JSawRKk2sP8JD
 pIFz03dx
 v7yuS3Qc8ny0NhaYWhH6ueZaNbeiVG6gRhr1J5v5/cEFMeR1MLNTXT1F22CKhuyzOPCznyOTLhAgYnxly6QjW9RuYjw7sF8NY8q/JnJCVu5XrlSPXts+iScyBUjn6maUdeZZdb+JSYPiPg7JyDJkySSOj3L9K7TdQ8mVHioaVQBAROLIgMxfeQXazlXZvWyIEu+F/v4DUq1l54wwbRBZTAGRyngaS7oaZCgDgE3W9xse4axupVI8tC1yfcgdv5abhi/QH3pvA/NhtgQzdmB0P5PtfvaDv8q+1xx7j3qQXhKwbDEdolKwWOV4u3Ry4xnfKgpKt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 05:35:51PM -0700, Joanne Koong wrote:
> On Wed, Sep 3, 2025 at 11:44 AM Brian Foster <bfoster@redhat.com> wrote:
> >
> > On Tue, Sep 02, 2025 at 04:46:04PM -0700, Darrick J. Wong wrote:
> > > On Fri, Aug 29, 2025 at 04:39:42PM -0700, Joanne Koong wrote:
> > > > Add granular dirty and writeback accounting for large folios. These
> > > > stats are used by the mm layer for dirty balancing and throttling.
> > > > Having granular dirty and writeback accounting helps prevent
> > > > over-aggressive balancing and throttling.
> > > >
> > > > There are 4 places in iomap this commit affects:
> > > > a) filemap dirtying, which now calls filemap_dirty_folio_pages()
> > > > b) writeback_iter with setting the wbc->no_stats_accounting bit and
> > > > calling clear_dirty_for_io_stats()
> > > > c) starting writeback, which now calls __folio_start_writeback()
> > > > d) ending writeback, which now calls folio_end_writeback_pages()
> > > >
> > > > This relies on using the ifs->state dirty bitmap to track dirty pages in
> > > > the folio. As such, this can only be utilized on filesystems where the
> > > > block size >= PAGE_SIZE.
> > >
> > > Er... is this statement correct?  I thought that you wanted the granular
> > > dirty page accounting when it's possible that individual sub-pages of a
> > > folio could be dirty.
> > >
> > > If i_blocksize >= PAGE_SIZE, then we'll have set the min folio order and
> > > there will be exactly one (large) folio for a single fsblock.  Writeback
> 
> Oh interesting, this is the part I'm confused about. With i_blocksize
> >= PAGE_SIZE, isn't there still the situation where the folio itself
> could be a lot larger, like 1MB?

Yes, that's quite possible.  IIRC you can get 2MB folios for 8k
fsblocks.

>                                  That's what I've been seeing on fuse
> where "blocksize" == PAGE_SIZE == 4096. I see that xfs sets the min
> folio order through mapping_set_folio_min_order() but I'm not seeing
> how that ensures "there will be exactly one large folio for a single
> fsblock"?

I misspoke -- should have said "there will be no more than one (large)
folio for a single fsblock".  Sorry about the confusion; my old brain is
still stuck in 2015 sometimes.

>           My understanding is that that only ensures the folio is at
> least the size of the fsblock but that the folio size can be larger
> than that too. Am I understanding this incorrectly?

Nope, your understanding is correct. :)

> > > must happen in units of fsblocks, so there's no point in doing the extra
> > > accounting calculations if there's only one fsblock.
> > >
> > > Waitaminute, I think the logic to decide if you're going to use the
> > > granular accounting is:
> > >
> > >       (folio_size > PAGE_SIZE && folio_size > i_blocksize)
> > >
> 
> Yeah, you're right about this - I had used "ifs && i_blocksize >=
> PAGE_SIZE" as the check, which translates to "i_blocks_per_folio > 1
> && i_block_size >= PAGE_SIZE", which in effect does the same thing as
> what you wrote but has the additional (and now I'm realizing,
> unnecessary) stipulation that block_size can't be less than PAGE_SIZE.

Oh!  Yes, that's right, they /are/ equivalent!

> > > Hrm?
> > >
> >
> > I'm also a little confused why this needs to be restricted to blocksize
> > gte PAGE_SIZE. The lower level helpers all seem to be managing block
> > ranges, and then apparently just want to be able to use that directly as
> > a page count (for accounting purposes).
> >
> > Is there any reason the lower level functions couldn't return block
> > units, then the higher level code can use a blocks_per_page or some such
> > to translate that to a base page count..? As Darrick points out I assume
> > you'd want to shortcut the folio_nr_pages() == 1 case to use a min page
> > count of 1, but otherwise ISTM that would allow this to work with
> > configs like 64k pagesize and 4k blocks as well. Am I missing something?
> >
> 
> No, I don't think you're missing anything, it should have been done
> like this in the first place.
> 
> > Brian
> >
> > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > ---
> > > >  fs/iomap/buffered-io.c | 140 ++++++++++++++++++++++++++++++++++++++---
> > > >  1 file changed, 132 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > > > index 4f021dcaaffe..bf33a5361a39 100644
> > > > --- a/fs/iomap/buffered-io.c
> > > > +++ b/fs/iomap/buffered-io.c
> > > > @@ -20,6 +20,8 @@ struct iomap_folio_state {
> > > >     spinlock_t              state_lock;
> > > >     unsigned int            read_bytes_pending;
> > > >     atomic_t                write_bytes_pending;
> > > > +   /* number of pages being currently written back */
> > > > +   unsigned                nr_pages_writeback;
> > > >
> > > >     /*
> > > >      * Each block has two bits in this bitmap:
> > > > @@ -139,6 +141,29 @@ static unsigned ifs_next_clean_block(struct folio *folio,
> > > >             blks + start_blk) - blks;
> > > >  }
> > > >
> > > > +static unsigned ifs_count_dirty_pages(struct folio *folio)
> > > > +{
> > > > +   struct inode *inode = folio->mapping->host;
> > > > +   unsigned block_size = i_blocksize(inode);
> > > > +   unsigned start_blk, end_blk;
> > > > +   unsigned blks, nblks = 0;
> > > > +
> > > > +   start_blk = 0;
> > > > +   blks = i_blocks_per_folio(inode, folio);
> > > > +   end_blk = (i_size_read(inode) - 1) >> inode->i_blkbits;
> > > > +   end_blk = min(end_blk, i_blocks_per_folio(inode, folio) - 1);
> > > > +
> > > > +   while (start_blk <= end_blk) {
> > > > +           start_blk = ifs_next_dirty_block(folio, start_blk, end_blk);
> > > > +           if (start_blk > end_blk)
> > > > +                   break;
> > >
> > > Use your new helper?
> > >
> > >               nblks = ifs_next_clean_block(folio, start_blk + 1,
> > >                               end_blk) - start_blk?
> > > > +           nblks++;
> > > > +           start_blk++;
> > > > +   }
> > > > +
> > > > +   return nblks * (block_size >> PAGE_SHIFT);
> > >
> > > I think this returns the number of dirty basepages in a given large
> > > folio?  If that's the case then shouldn't this return long, like
> > > folio_nr_pages does?
> > >
> > > > +}
> > > > +
> > > >  static unsigned ifs_find_dirty_range(struct folio *folio,
> > > >             struct iomap_folio_state *ifs, u64 *range_start, u64 range_end)
> > > >  {
> > > > @@ -220,6 +245,58 @@ static void iomap_set_range_dirty(struct folio *folio, size_t off, size_t len)
> > > >             ifs_set_range_dirty(folio, ifs, off, len);
> > > >  }
> > > >
> > > > +static long iomap_get_range_newly_dirtied(struct folio *folio, loff_t pos,
> > > > +           unsigned len)
> > >
> > > iomap_count_clean_pages() ?
> 
> Nice, a much clearer name.
> 
> I'll make the suggestions you listed above too, thanks for the pointers.
> 
> Thanks for taking a look at this, Darrick and Brian!
> > >
> > > --D
> > >

