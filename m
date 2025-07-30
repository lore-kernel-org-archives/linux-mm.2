Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CC9C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 13:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2CB06B008C; Wed, 30 Jul 2025 09:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDCD56B0095; Wed, 30 Jul 2025 09:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD17B6B008C; Wed, 30 Jul 2025 09:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9774A6B008C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:14:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5AF59140448
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:14:15 +0000 (UTC)
X-FDA: 83720974470.28.5DABB6C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7157440002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:14:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KCD+BQA2;
	spf=pass (imf07.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753881253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUCIaEJyhaToljdD0/skICMZCdaeVSBQUxuJSTTdgUo=;
	b=tUPtPKtdtbPT/GbVVfzq6Vus5AS2s5Zx2jY9FiyPa5M/kyXh7K/GZ74kCsxgZkRLIYAie/
	Q6P6kU1RI84u7JraCIgHqrV/PVJahWH0YSmg1Eum1YIS81IEQxfksDccFp35Yn/ugqd7IR
	j/c7uvFEqX5O4jDpw/ThsVskD3KQzv8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KCD+BQA2;
	spf=pass (imf07.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753881253; a=rsa-sha256;
	cv=none;
	b=vjMomJHPp3n+49qFUSAtfxIr9CGMY5sfU70dSx/engY8xgM3tx6amZvCLpy8TrC2HrKtlO
	zVRmKLlvzSrxe0gTAwUzPwXU0v6mvCvpugzyDMNKbvOc4DF6NlohvH7jusaI7c8rlVVm5u
	sS/ejvWs8Wl/NMriWLUuGH6SrLICRN4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753881252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yUCIaEJyhaToljdD0/skICMZCdaeVSBQUxuJSTTdgUo=;
	b=KCD+BQA2muUA5MsnPnCiFiI0TQLc1wzdePEIKZ9e8DeKgCWyZqMuPn0oGlA2AlfTovivTw
	+jd9mndPFpnjdUpYYIKHgHcdBw4iyEnxTPPdvWVu6lsQstUqSYTYvf538A+i7Qs1neOoQu
	htNSPw3bopGuEnDXco/phyc1a9Rgg5I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-M1cBZKM3PXyeMTJupq11eA-1; Wed,
 30 Jul 2025 09:14:09 -0400
X-MC-Unique: M1cBZKM3PXyeMTJupq11eA-1
X-Mimecast-MFC-AGG-ID: M1cBZKM3PXyeMTJupq11eA_1753881247
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 353EB1956089;
	Wed, 30 Jul 2025 13:14:07 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.142])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AD11180035E;
	Wed, 30 Jul 2025 13:14:05 +0000 (UTC)
Date: Wed, 30 Jul 2025 09:17:59 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, hch@infradead.org, willy@infradead.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH v3 3/7] iomap: optional zero range dirty folio processing
Message-ID: <aIobh49Bb0Vqz10I@bfoster>
References: <20250714204122.349582-1-bfoster@redhat.com>
 <20250714204122.349582-4-bfoster@redhat.com>
 <20250715052259.GO2672049@frogsfrogsfrogs>
 <e6333d2d-cc30-44d3-8f23-6a6c5ea0134d@huaweicloud.com>
 <aHpQxq6mDyLL1Nfj@bfoster>
 <09b7c1cf-7bfa-4798-b9de-f49620046664@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09b7c1cf-7bfa-4798-b9de-f49620046664@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: 7157440002
X-Rspamd-Server: rspam06
X-Stat-Signature: umwgaghhm4unq1h3fbcj6hzurryk84uc
X-HE-Tag: 1753881253-9378
X-HE-Meta: U2FsdGVkX18wWsjkWSYmr+PDwzBDu3nVyiuifr/JRsg5M+K7KGurkRIiUeeqOiCmbT+KqCTPn74qWAiOC1KxjpKOd/HG9VYLbuI8e8Pc/8DcHOfqJuh3+AqIRp/0Xh4c9tFEO3iFv9TA+PDLk7qLpPBEQLjvLaRCvuaMugPxetjvXutRLBCyyha81T5NDGFlLoRyiq0eZucH5dKa7uu1ZrTFVO2NaDNvUazrVqVS4z7Zi29T2t6a/K1LWW89Q6qGF7FskIQwl37s6xbSLsTCQmuAjKWvMMQ9V0a62XF07aV6HR1OkX8K1xBafoi4KtLCde7gvc+RlZKuDi6StAay/Ks/uhwRIrRHoAd4KkRJL1aD7CpeRIqJTCGWjm3Y5+aKTCHEYSW8nISvtiphJ3oDiA/zG5prb7XOIUAABYEQbtDDFYRDHolSplM5wPdDg8X6omqx8wgt+GXeMsPXMZEz6vZ0C36ikQa/30opfolABZMUtjWdl0srqE0IF85TRKG+M0xg/hnEc3XyxWdlCj36GO+EFKb8Uzayn5eOQ7pH+eKFzLKaz4nQONB8QE3J94RIDJfxpM8cxNaO4V6TBOII2ylRLMhS5k93bM0BY2Tn8L2iXbQX7yS5GS7z+S/j/S4ISeDs7Wy3zG0M9zpk/PvC+YxK7amMFHCGTmdNlgltvyIyYwYYlRUkyrMDDgXHpEG5PaPwzUik8rAKXZxCQOo6a9sXN4MvQGObLY/xPoMe922Nb1G+8a6dgqApmDWb/0E/Pzg/sYlxkeHl8kfly1TaVREbB/OnwuVZKCKo5cXB34Zhs/DVd9H+tLh5LjGi9My4TnQqREYZVV9Fxd9vSkRAWkmnzJUsxFLgdrPge2Eke3wZlLlaZCua7eE7MyhijP3DWQw7n7YnBm1HiLXuCKGYOPZvkVMxU+53MX/xnDFBAtvTmnXRwhuKvQVslVldF8Ynt2LuS5UdoKCWwOI7aDS
 j0MaawaV
 tsG6mGMocuequbCq+vGzp/+c63dDPcjwtZHavfI2Wlbx7SULidPzh/Q2neitLKSDksB7O6KqRq3tI2HcjpvNKsGRiSJIWrDCfPCllusMIGkRJQUskloWGWgJZvCd5KDS0Gr7cGduuzJJ4FAcLZeQuxHgCBbLTKJTHmBjKS8LMmtz3r2pBUlxum1lOGRMmjwFK6E20jpuyRJDHpNaYj50kOAZEQK9F9SJz4P5ZD1zZFU4HhhUvGGCoKrwVg19N1cAAzl9XOM+ipulffBrN7mCzTJmZ3Sye2R8EbR8a7R1MkPjevZdqpSZbUyxw6gBqhZZIyMmLANdmiAMWKOB31+6ktd6Ab9XAOGDZzzUZww1I40Jydw8ClTeqGQHdYflGbFJ9Q7+yGM8sbOEJr8CBFZPcUqqfO961A5slqpJOjonc87VxDbeJXFzt0DCvEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 19, 2025 at 07:07:43PM +0800, Zhang Yi wrote:
> On 2025/7/18 21:48, Brian Foster wrote:
> > On Fri, Jul 18, 2025 at 07:30:10PM +0800, Zhang Yi wrote:
> >> On 2025/7/15 13:22, Darrick J. Wong wrote:
> >>> On Mon, Jul 14, 2025 at 04:41:18PM -0400, Brian Foster wrote:
> >>>> The only way zero range can currently process unwritten mappings
> >>>> with dirty pagecache is to check whether the range is dirty before
> >>>> mapping lookup and then flush when at least one underlying mapping
> >>>> is unwritten. This ordering is required to prevent iomap lookup from
> >>>> racing with folio writeback and reclaim.
> >>>>
> >>>> Since zero range can skip ranges of unwritten mappings that are
> >>>> clean in cache, this operation can be improved by allowing the
> >>>> filesystem to provide a set of dirty folios that require zeroing. In
> >>>> turn, rather than flush or iterate file offsets, zero range can
> >>>> iterate on folios in the batch and advance over clean or uncached
> >>>> ranges in between.
> >>>>
> >>>> Add a folio_batch in struct iomap and provide a helper for fs' to
> >>>
> >>> /me confused by the single quote; is this supposed to read:
> >>>
> >>> "...for the fs to populate..."?
> >>>
> >>> Either way the code changes look like a reasonable thing to do for the
> >>> pagecache (try to grab a bunch of dirty folios while XFS holds the
> >>> mapping lock) so
> >>>
> >>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> >>>
> >>> --D
> >>>
> >>>
> >>>> populate the batch at lookup time. Update the folio lookup path to
> >>>> return the next folio in the batch, if provided, and advance the
> >>>> iter if the folio starts beyond the current offset.
> >>>>
> >>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
> >>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >>>> ---
> >>>>  fs/iomap/buffered-io.c | 89 +++++++++++++++++++++++++++++++++++++++---
> >>>>  fs/iomap/iter.c        |  6 +++
> >>>>  include/linux/iomap.h  |  4 ++
> >>>>  3 files changed, 94 insertions(+), 5 deletions(-)
> >>>>
> >>>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> >>>> index 38da2fa6e6b0..194e3cc0857f 100644
> >>>> --- a/fs/iomap/buffered-io.c
> >>>> +++ b/fs/iomap/buffered-io.c
> >> [...]
> >>>> @@ -1398,6 +1452,26 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> >>>>  	return status;
> >>>>  }
> >>>>  
> >>>> +loff_t
> >>>> +iomap_fill_dirty_folios(
> >>>> +	struct iomap_iter	*iter,
> >>>> +	loff_t			offset,
> >>>> +	loff_t			length)
> >>>> +{
> >>>> +	struct address_space	*mapping = iter->inode->i_mapping;
> >>>> +	pgoff_t			start = offset >> PAGE_SHIFT;
> >>>> +	pgoff_t			end = (offset + length - 1) >> PAGE_SHIFT;
> >>>> +
> >>>> +	iter->fbatch = kmalloc(sizeof(struct folio_batch), GFP_KERNEL);
> >>>> +	if (!iter->fbatch)
> >>
> >> Hi, Brian!
> >>
> >> I think ext4 needs to be aware of this failure after it converts to use
> >> iomap infrastructure. It is because if we fail to add dirty folios to the
> >> fbatch, iomap_zero_range() will flush those unwritten and dirty range.
> >> This could potentially lead to a deadlock, as most calls to
> >> ext4_block_zero_page_range() occur under an active journal handle.
> >> Writeback operations under an active journal handle may result in circular
> >> waiting within journal transactions. So please return this error code, and
> >> then ext4 can interrupt zero operations to prevent deadlock.
> >>
> > 
> > Hi Yi,
> > 
> > Thanks for looking at this.
> > 
> > Huh.. so the reason for falling back like this here is just that this
> > was considered an optional optimization, with the flush in
> > iomap_zero_range() being default fallback behavior. IIUC, what you're
> > saying means that the current zero range behavior without this series is
> > problematic for ext4-on-iomap..? 
> 
> Yes.
> 
> > If so, have you observed issues you can share details about?
> 
> Sure.
> 
> Before delving into the specific details of this issue, I would like
> to provide some background information on the rule that ext4 cannot
> wait for writeback in an active journal handle. If you are aware of
> this background, please skip this paragraph. During ext4 writing back
> the page cache, it may start a new journal handle to allocate blocks,
> update the disksize, and convert unwritten extents after the I/O is
> completed. When starting this new journal handle, if the current
> running journal transaction is in the process of being submitted or
> if the journal space is insufficient, it must wait for the ongoing
> transaction to be completed, but the prerequisite for this is that all
> currently running handles must be terminated. However, if we flush the
> page cache under an active journal handle, we cannot stop it, which
> may lead to a deadlock.
> 

Ok, makes sense.

> Now, the issue I have observed occurs when I attempt to use
> iomap_zero_range() within ext4_block_zero_page_range(). My current
> implementation are below(based on the latest fs-next).
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 28547663e4fd..1a21667f3f7c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4147,6 +4147,53 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
>  	return 0;
>  }
> 
> +static int ext4_iomap_buffered_zero_begin(struct inode *inode, loff_t offset,
> +			loff_t length, unsigned int flags, struct iomap *iomap,
> +			struct iomap *srcmap)
> +{
> +	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);
> +	struct ext4_map_blocks map;
> +	u8 blkbits = inode->i_blkbits;
> +	int ret;
> +
> +	ret = ext4_emergency_state(inode->i_sb);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
> +		return -EINVAL;
> +
> +	/* Calculate the first and last logical blocks respectively. */
> +	map.m_lblk = offset >> blkbits;
> +	map.m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
> +			  EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
> +
> +	ret = ext4_map_blocks(NULL, inode, &map, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * Look up dirty folios for unwritten mappings within EOF. Providing
> +	 * this bypasses the flush iomap uses to trigger extent conversion
> +	 * when unwritten mappings have dirty pagecache in need of zeroing.
> +	 */
> +	if ((map.m_flags & EXT4_MAP_UNWRITTEN) &&
> +	    map.m_lblk < EXT4_B_TO_LBLK(inode, i_size_read(inode))) {
> +		loff_t end;
> +
> +		end = iomap_fill_dirty_folios(iter, map.m_lblk << blkbits,
> +					      map.m_len << blkbits);
> +		if ((end >> blkbits) < map.m_lblk + map.m_len)
> +			map.m_len = (end >> blkbits) - map.m_lblk;
> +	}
> +
> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> +	return 0;
> +}
> +
> +const struct iomap_ops ext4_iomap_buffered_zero_ops = {
> +	.iomap_begin = ext4_iomap_buffered_zero_begin,
> +};
> 
>  const struct iomap_ops ext4_iomap_buffered_write_ops = {
>  	.iomap_begin = ext4_iomap_buffered_write_begin,
> @@ -4611,6 +4658,17 @@ static int __ext4_block_zero_page_range(handle_t *handle,
>  	return err;
>  }
> 
> +static inline int ext4_iomap_zero_range(struct inode *inode, loff_t from,
> +					loff_t length)
> +{
> +	WARN_ON_ONCE(!inode_is_locked(inode) &&
> +		     !rwsem_is_locked(&inode->i_mapping->invalidate_lock));
> +
> +	return iomap_zero_range(inode, from, length, NULL,
> +				&ext4_iomap_buffered_zero_ops,
> +				&ext4_iomap_write_ops, NULL);
> +}
> +
>  /*
>   * ext4_block_zero_page_range() zeros out a mapping of length 'length'
>   * starting from file offset 'from'.  The range to be zero'd must
> @@ -4636,6 +4694,8 @@ static int ext4_block_zero_page_range(handle_t *handle,
>  	if (IS_DAX(inode)) {
>  		return dax_zero_range(inode, from, length, NULL,
>  				      &ext4_iomap_ops);
> +	} else if (ext4_test_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP)) {
> +		return ext4_iomap_zero_range(inode, from, length);
>  	}
>  	return __ext4_block_zero_page_range(handle, mapping, from, length);
>  }
> 
> The problem is most calls to ext4_block_zero_page_range() occur under
> an active journal handle, so I can reproduce the deadlock issue easily
> without this series.
> 
> > 
> > FWIW, I think your suggestion is reasonable, but I'm also curious what
> > the error handling would look like in ext4. Do you expect to the fail
> > the higher level operation, for example? Cycle locks and retry, etc.?
> 
> Originally, I wanted ext4_block_zero_page_range() to return a failure
> to the higher level operation. However, unfortunately, after my testing
> today, I discovered that even though we implement this, this series still
> cannot resolve the issue. The corner case is:
> 
> Assume we have a dirty folio covers both hole and unwritten mappings.
> 
>    |- dirty folio  -|
>    [hhhhhhhhuuuuuuuu]                h:hole, u:unwrtten
> 
> If we punch the range of the hole, ext4_punch_hole()->
> ext4_zero_partial_blocks() will zero out the first half of the dirty folio.
> Then, ext4_iomap_buffered_zero_begin() will skip adding this dirty folio
> since the target range is a hole. Finally, iomap_zero_range() will still
> flush this whole folio and lead to deadlock during writeback the latter
> half of the folio.
> 

Hmm.. Ok. So it seems there are at least a couple ways around this
particular quirk. I suspect one is that you could just call the fill
helper in the hole case as well, but that's kind of a hack and not
really intended use.

The other way goes back to the fact that the flush for the hole case was
kind of a corner case hack in the first place. The original comment for
that seems to have been dropped, but see commit 7d9b474ee4cc ("iomap:
make zero range flush conditional on unwritten mappings") for reference
to the original intent.

I'd have to go back and investigate if something regresses with that
taken out, but my recollection is that was something that needed proper
fixing eventually anyways. I'm particularly wondering if that is no
longer an issue now that pagecache_isize_extended() handles the post-eof
zeroing (the caveat being we might just need to call it in some
additional size extension cases besides just setattr/truncate).

> > 
> > The reason I ask is because the folio_batch handling has come up through
> > discussions on this series. My position so far has been to keep it as a
> > separate allocation and to keep things simple since it is currently
> > isolated to zero range, but that may change if the usage spills over to
> > other operations (which seems expected at this point). I suspect that if
> > a filesystem actually depends on this for correct behavior, that is
> > another data point worth considering on that topic.
> > 
> > So that has me wondering if it would be better/easier here to perhaps
> > embed the batch in iomap_iter, or maybe as an incremental step put it on
> > the stack in iomap_zero_range() and initialize the iomap_iter pointer
> > there instead of doing the dynamic allocation (then the fill helper
> > would set a flag to indicate the fs did pagecache lookup). Thoughts on
> > something like that?
> > 
> > Also IIUC ext4-on-iomap is still a WIP and review on this series seems
> > to have mostly wound down. Any objection if the fix for that comes along
> > as a followup patch rather than a rework of this series?
> 
> It seems that we don't need to modify this series, we need to consider
> other solutions to resolve this deadlock issue.
> 
> In my v1 ext4-on-iomap series [1], I resolved this issue by moving all
> instances of ext4_block_zero_page_range() out of the running journal
> handle(please see patch 19-21). But I don't think this is a good solution
> since it's complex and fragile. Besides, after commit c7fc0366c6562
> ("ext4: partial zero eof block on unaligned inode size extension"), you
> added more invocations of ext4_zero_partial_blocks(), and the situation
> has become more complicated (Althrough I think the calls in the three
> write_end callbacks can be removed).
> 
> Besides, IIUC, it seems that ext4 doesn't need to flush dirty folios
> over unwritten mappings before zeroing partial blocks. This is because
> ext4 always zeroes the in-memory page cache before zeroing(e.g, in
> ext4_setattr() and ext4_punch_hole()), it means if the target range is
> still dirty and unwritten when calling ext4_block_zero_page_range(), it
> must has already been zeroed. Was I missing something? Therefore, I was
> wondering if there are any ways to prevent flushing in
> iomap_zero_range()? Any ideas?

It's certainly possible that the quirk fixed by the flush the hole case
was never a problem on ext4, if that's what you mean. Most of the
testing for this was on XFS since ext4 hadn't used iomap for buffered
writes.

At the end of the day, the batch mechanism is intended to facilitate
avoiding the flush entirely. I'm still paging things back in here.. but
if we had two smallish changes to this code path to 1. eliminate the
dynamic folio_batch allocation and 2. drop the flush on hole mapping
case, would that address the issues with iomap zero range for ext4?

> 
> [1] https://lore.kernel.org/linux-ext4/20241022111059.2566137-1-yi.zhang@huaweicloud.com/
> 
> > 
> > Brian
> > 
> > P.S., I'm heading on vacation so it will likely be a week or two before
> > I follow up from here, JFYI.
> 
> Wishing you a wonderful time! :-)

Thanks!

Brian

> 
> Best regards,
> Yi.
> 
> >>
> >>>> +		return offset + length;
> >>>> +	folio_batch_init(iter->fbatch);
> >>>> +
> >>>> +	filemap_get_folios_dirty(mapping, &start, end, iter->fbatch);
> >>>> +	return (start << PAGE_SHIFT);
> >>>> +}
> >>>> +EXPORT_SYMBOL_GPL(iomap_fill_dirty_folios);
> >>
> 


