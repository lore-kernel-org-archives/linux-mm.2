Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D898AC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 21:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77DDA6B008C; Mon, 24 Aug 2026 17:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72EA06B0092; Mon, 24 Aug 2026 17:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61EB76B0095; Mon, 24 Aug 2026 17:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7186B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:57:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A4C24022A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:57:44 +0000 (UTC)
X-FDA: 85137525648.02.A86A909
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9518180002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:57:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=FNWWEQmz;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="lBGAw/I3";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of boris@bur.io designates 103.168.172.152 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787608662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=br0ZJAK4IXIy8kwo/WXMM3d+veAzs8uRALVZi5vGptg=;
	b=CSNPVJmZrXvobimxglnjV1PvNHT6SnszYmxvuz3ppXCOhtfldOPerFy8FxT0mcGGJZ0SYc
	HgEROg78E/4DC42z/cCH823K5NQNvxE1xieU+EuKVSYMlSpkOeMtGWHpsKs1yMT0WK9qAi
	p0gSnlAaJTPhRei7OFv6KDC2W6DxU0E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=FNWWEQmz;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="lBGAw/I3";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of boris@bur.io designates 103.168.172.152 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787608662;
	b=5w2X8Vqq+Z3RCaJlItRPbNAvmytViEPO4T2RGDeB+WR3cg/IwGAuHBae05iWclJkmikE+d
	wRphLoqM9bQ52ALis6cvwyTSx+6b5MgFvqY/zOHCNFR81i6pYs1IVRr4hv5WTZmEftuLx/
	N9mdT7n2HrLN/1IdnqKS5eNKA1cxbhE=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id EC0D11400077;
	Mon, 24 Aug 2026 17:57:41 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 24 Aug 2026 17:57:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1787608661; x=1787695061; bh=br0ZJAK4IX
	Iy8kwo/WXMM3d+veAzs8uRALVZi5vGptg=; b=FNWWEQmzEd1qyyWvePwgFcmcRh
	SdTDISybhfuzBDdmuAewb/cNV6JpywabKgINVGDt/mXC5iKLkoixZCqYTKSelNPv
	ID0CdT8x+xKk2a7u/Qz7eYSUC1zDP0YEjo9ovUSxa6Agb02107/i6t1pghkfTNo4
	S/aayMIdKpP+GmjCY2zjGCmLuzD+6jveuz9D6APJkZD7WgiXR6P1/8AEptFFgA4H
	6a4SUGB/lto+DQ4FZIn9jnXlxjpTtB+M/WYty/5vF23TL13CwGLIl6z3r+4pEq/h
	OO+CHgFFDFZlJhV1Y7ketuL1Mn3uDE5XqvQMVf7MH0ySgg/VH1g2AFw4lA0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787608661; x=1787695061; bh=br0ZJAK4IXIy8kwo/WXMM3d+veAzs8uRALV
	Zi5vGptg=; b=lBGAw/I3t+Yi/Sa+CxZeHVLqcCILr01czD893qqjA/TQO2J4IIw
	gVRcqlfrl7adfTsSSDhyCO1z0e6UeRN8DBRx61Bt54/oL19d+wlImKQCzHpG4ebk
	bs2Hmwj3sjRVqC9i7JAMUtLpo5YDTmgvAg7Ty2DsT4SRlFRbtaV103OTSxps17F4
	1/jZhb8e1zOXuhkm3TfZkLF5t/I8ewYwJD/yl7H3N4GHyqrQ6dWrxKOMepJxtd+V
	iybomIDebQNbzDC8OYaoWtRaYf1STThFACe8GhfTsQrzhikbbeL7a8LKW+imudS9
	1lCaPnsW07m3pFu7NBbxZJe0TMVX0uW7yoQ==
X-ME-Sender: <xms:Vb6MalmfLtI5O3lhLKcjJBpP5ZQHMiyr9OdA7Tdj-KidFuypOQRBHg>
    <xme:Vb6MavO4gshkSaUOWeUmZCS4bIluvEcak3ALc9fEdVyoCGcxqoGBGkioGd7UY8MBB
    xPHx9kYhixyxOi2jblgox_CKME1Et5-33PT8HD5r7R41bhxXSJznvFw>
X-ME-Received: <xmr:Vb6ManrKQoe3zrAuft29csb52t9_1qGksWDUCPA2Uu3l_9rUI71v-dX0KmNRWFZRuvRlFSgmJqxOJbRQXzfh5Rl4OmY>
X-ME-Proxy-Cause: dmFkZTGqEyykA1sOnyeBdFBZbfPmYjAPXliUF3xVtonO1PONGbI/HUGTKz6CIcPE+ajJlB
    NRtYDck65qi3MRs/v8pzQmypGRsZnzqLrTPndbJdH0iMs1/XferK9Goja2IhbuucbvTeio
    8llUXcBogYs8jeock4al/vTTHwQMI8F20qW31IP7lUOqoxCtO1FlvbDi+N6vYBf0AtuHYC
    7T8hWs3larCSIVbNRk90Chci+p1tEbOw0kOHJBezbzGjy/LoOrwIv6fFy9Rt0gkFZYJr/+
    sVOYT9XIYiN/uRpl+moQAzWBuRCvhNb1BKtrEQ/nMKescxsUFQx3y6BtJY7woG1AyXyRY4
    WQrwGGkB4FAANePkMLJvqrgeghrxhIhk6yku5ckvUjzvWjULHY2tjiFr645hy4CRDoksui
    Ovyh6g9964Dx/QNTR67/D6ZfdRVVTCebqaSia7BlC/LYInTMZM6lVpuFZeU2JaJAovOMiJ
    eWvKOGHING1/fEtAQ3TZ44gRNp/N15HgZALUY6lVOcfoWxY7Yh4ZKUIAwNoL5cPX/yHNEI
    dZUIhEJHn4Idf1f+3nTmbYo9i+vVsCDQXL8o685j6dtPl7NtWPttejm8nImb+s4SsM5twl
    Y1L8+7Vfud+fozVFi4u8vSHoxFtG6LbO8WNNYIy2CY8fWyAEwN6FhC6esujA
X-ME-Proxy: <xmx:Vb6MaotoLc5Iylk5B3iqY4LVqkDX5waHOQx8_FVFV2BbPZ4X9WlamQ>
    <xmx:Vb6Mar6GMInl1Bg16G_pevTsi0NFwJQQShIEap_ntUGiPbZlqHwckQ>
    <xmx:Vb6MahTH7sc7AdPsKNDf2HLH7AIDMtgk9h5amFGI2sQf4kprdkaMpA>
    <xmx:Vb6MajnJsAQ4_iHX2Ra1JlfwYjgRLsPZJqYR60rbpMPkbBrOgbUeGw>
    <xmx:Vb6ManxzZpL2hhuKnDhTCvNtQwDsEsq-Do7OwmbG9vZbFUEUQzrwfIWi>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 17:57:40 -0400 (EDT)
Date: Mon, 24 Aug 2026 14:57:13 -0700
From: Boris Burkov <boris@bur.io>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org,
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 3/7] btrfs: Use filemap_invalidate_pages()
Message-ID: <20260824215713.GB3664690@zen.localdomain>
References: <20260820193343.3852967-1-willy@infradead.org>
 <20260820193343.3852967-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820193343.3852967-4-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9518180002
X-Rspamd-Server: rspam07
X-Stat-Signature: uxcr64p7iqj4mefh1g7j4npr9mryznmk
X-HE-Tag: 1787608662-65725
X-HE-Meta: U2FsdGVkX1/K2UP7PdamIS6GGtmAEZtTDJhOfVd12qjOAnu31Hfp0IMkTjnT4UvM8m7wD9JSBhPO3jo+DGDuzFekOqaHE2lerHKv3TtMJZtrgjcX0ZxzBNF2s+gqE69LYGwCMttzevXcte1X8eLANaKvXsOvipyAp9UCP/K2IRwjLX5LaWAq6hidHX5F1G6tgBMrIoFlnZVCEv26MJXZGcqHWkN5w+qdBNWoeHNxuTRx6ziONJ/gKT/UiRPrEJPlK5qjXlX1ziKJf7TAPEyToffZhrxpt7E2AmdqXBf+QFrb5QOYZz5ALEEgncFnK8Q2pZDITKNDW8v3DujwbTw1DjKp71xUdKBxVilGdzIFZVuUbt8ppsBNLOT96Nf6Aq3JqYmMHJ7m+p8oJd8BTKKDrxGo/IRAH9fD9xLX5k8KJ4q8B64OMKKgdG9FEEOqhGX472o5eRfxT0VHpxiGTG1jNdyQlNuodsoYD4kuphf/XZXYpYIsnJ5sgI9SFghk15pMBqZSm77eY5m6/Tsza5FUapkIoa3rDVyOVe5AMK2SASFuGUgxY2lKC1lgUi4x+DsCnDTq5du1gbMxG2kox5C6zZvsbrnyelL67ok3ys4BYMb245i5ofCh2bSU74pBbD/Hh5Qx+XfIBKe0Q7mCIjxkDsX85ml8+dkpXjvxLcgeoAsuS+Jl/SatNgZPl9QqxtA5SsxPOaLAgWwDCVQXpk1ABVnGW3fWgrqHmpNkM9WbbgU/7f4Ks4v3ZR6M8gL44h0grdDfdvCNcHS8gM3miWqTMsqtK48+drNqn3QGQ8Ta7N147IPnEWps/zjiIPTgitGZBmp1Pj0EAVJxcq5FpGctEzPKgXM7rGLHusiyGDT1iURhlQTeIWEDfqBUdOfveHYvexcqZIFgLXcUKHLw28p53VvJsU5fyBFiYhWoDHUlauZ7lf0cml0RyzazZQYLubxsepXltM1TEDLhAIHfAzx
 TkvnjCWV
 OlpHyLcjnBd2oJ22WH7+SRryIYiHx4QiFnLB3xDPI4YaZDBoWPVArOefaSwWXeLOUCEX8Lj5DSfZ1tbf262GO7vqaE0Y7zDv0pAnTo+d+Q92n6siN04U5qUYEsWxAxgqW1++18tvdz6mq+RFQWOiEkt+/dtXeUlBYBUM8s3rpwt8wasdWSZv1RPHwb+QiM2m2DRhvQSo67NL1mObZZh6/ie7wYPQQEoCQICHtm3Zhn4ZjhImadgB7kLNh84CRDrUiqV2nDRbKeVJgsuMjPmUnDFla2mW0n+CHbda99FMuitlcx2NTj1lUdeLAXLHBlRuTemOT1aNcYGzilud7lwPdwKbfNCCjy2gzb7Rtj7+g4rsZP6VTy+rOSVoxstRkHM03fW8E6F1+oR+PWf7jVz9jFPtyK8MMBUgD+Zx1R7tYmtIorv4EZ0E7dabPHiD1LOD0m98AO31K2sViNx6m3jQ89wDpww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 08:33:36PM +0100, Matthew Wilcox (Oracle) wrote:
> btrfs relies on invalidate_inode_pages2() /
> invalidate_inode_pages2_range() doing writeback by calling
> btrfs_launder_folio().  While this works, it is inefficient as each

I don't believe btrfs_launder_folio() is doing writeback, it is just
dropping otherwise leaked qgroup reservation. So this part of the
commit message feels inaccurate to me, at least.

> folio is written back and waited for individually.  Far better to call
> filemap_invalidate_pages() which will do a bulk write first, then remove
> the page cache.
> 
> With this done, btrfs_launder_folio() no longer needs to exist so
> delete it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/btrfs/direct-io.c        |  2 +-
>  fs/btrfs/disk-io.c          | 11 +++++++----
>  fs/btrfs/free-space-cache.c |  4 ++--
>  fs/btrfs/inode.c            | 12 ++----------
>  fs/btrfs/volumes.c          |  4 ++--
>  5 files changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 460326d34143..4bb5890d0898 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -115,7 +115,7 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
>  			/*
>  			 * We could trigger writeback for this range (and wait
>  			 * for it to complete) and then invalidate the pages for
> -			 * this range (through invalidate_inode_pages2_range()),
> +			 * this range (through filemap_invalidate_pages()),
>  			 * but that can lead us to a deadlock with a concurrent
>  			 * call to readahead (a buffered read or a defrag call
>  			 * triggered a readahead) on a page lock due to an
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 2f1666d9544e..2cf9189225c9 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3304,7 +3304,8 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
>  	struct extent_buffer *eb;
>  	int ret;
>  
> -	ret = invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +	ret = filemap_invalidate_pages(fs_info->btree_inode->i_mapping, 0,
> +			OFFSET_MAX);
>  	if (likely(ret == 0))
>  		return;
>  
> @@ -3339,7 +3340,8 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
>  		rcu_read_lock();
>  	}
>  	rcu_read_unlock();
> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +	filemap_invalidate_pages(fs_info->btree_inode->i_mapping, 0,
> +			OFFSET_MAX);
>  }
>  
>  static u32 calc_block_max_order(u32 sectorsize_bits)
> @@ -4739,7 +4741,8 @@ static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
>  			unsigned int nofs_flag;
>  
>  			nofs_flag = memalloc_nofs_save();
> -			invalidate_inode_pages2(inode->i_mapping);
> +			filemap_invalidate_pages(inode->i_mapping, 0,
> +					OFFSET_MAX);

I believe that this was the original motivating call to
invalidate_inode_pages2 that I cared about. The context it runs in is
when the filesystem has failed on a transaction and needs to invalidate
the remaining dirty pages that have delalloc associated with them.

I am trying to figure out if trying to force the writeback in this
semi-failed context will also result in freeing the reservation, and
also testing this patch series on the test that I originally fixed with
launder_folio().

With all that said, thank you for working on cleaning up the mess I made
by adding this "creative" usage of ->launder_folio(). Hopefully we can
figure this out cleanly.

Thanks,
Boris

>  			memalloc_nofs_restore(nofs_flag);
>  			iput(inode);
>  		}
> @@ -4837,7 +4840,7 @@ static void btrfs_cleanup_bg_io(struct btrfs_block_group *cache)
>  		unsigned int nofs_flag;
>  
>  		nofs_flag = memalloc_nofs_save();
> -		invalidate_inode_pages2(inode->i_mapping);
> +		filemap_invalidate_pages(inode->i_mapping, 0, OFFSET_MAX);
>  		memalloc_nofs_restore(nofs_flag);
>  
>  		BTRFS_I(inode)->generation = 0;
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index e2af75a205ea..a5d5eba2c85d 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1307,7 +1307,7 @@ static int __btrfs_wait_cache_io(struct btrfs_root *root,
>  				io_ctl->entries, io_ctl->bitmaps);
>  out:
>  	if (ret) {
> -		invalidate_inode_pages2(inode->i_mapping);
> +		filemap_invalidate_pages(inode->i_mapping, 0, OFFSET_MAX);
>  		BTRFS_I(inode)->generation = 0;
>  		if (block_group)
>  			btrfs_debug(root->fs_info,
> @@ -1500,7 +1500,7 @@ static int __btrfs_write_out_cache(struct inode *inode,
>  	io_ctl->inode = NULL;
>  	io_ctl_free(io_ctl);
>  	if (ret) {
> -		invalidate_inode_pages2(inode->i_mapping);
> +		filemap_invalidate_pages(inode->i_mapping, 0, OFFSET_MAX);
>  		BTRFS_I(inode)->generation = 0;
>  	}
>  	btrfs_update_inode(trans, BTRFS_I(inode));
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2534cd9284d5..a1bb73f083aa 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7616,12 +7616,6 @@ static void wait_subpage_spinlock(struct folio *folio)
>  	spin_unlock_irq(&bfs->lock);
>  }
>  
> -static int btrfs_launder_folio(struct folio *folio)
> -{
> -	return btrfs_qgroup_free_data(folio_to_inode(folio), NULL, folio_pos(folio),
> -				      folio_size(folio), NULL);
> -}
> -
>  static bool __btrfs_release_folio(struct folio *folio, gfp_t gfp_flags)
>  {
>  	if (try_release_extent_mapping(folio, gfp_flags)) {
> @@ -10027,9 +10021,8 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>  		ret = btrfs_wait_ordered_range(inode, start, num_bytes);
>  		if (ret)
>  			goto out_cb;
> -		ret = invalidate_inode_pages2_range(inode->vfs_inode.i_mapping,
> -						    start >> PAGE_SHIFT,
> -						    end >> PAGE_SHIFT);
> +		ret = filemap_invalidate_pages(inode->vfs_inode.i_mapping,
> +				start, end);
>  		if (ret)
>  			goto out_cb;
>  		btrfs_lock_extent(io_tree, start, end, &cached_state);
> @@ -10782,7 +10775,6 @@ static const struct address_space_operations btrfs_aops = {
>  	.writepages	= btrfs_writepages,
>  	.readahead	= btrfs_readahead,
>  	.invalidate_folio = btrfs_invalidate_folio,
> -	.launder_folio	= btrfs_launder_folio,
>  	.release_folio	= btrfs_release_folio,
>  	.migrate_folio	= btrfs_migrate_folio,
>  	.dirty_folio	= btrfs_data_dirty_folio,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6eab4cc73ce4..0301465ab87f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1370,8 +1370,8 @@ struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
>  		 * Drop the page of the primary superblock, so later read will
>  		 * always read from the device.
>  		 */
> -		invalidate_inode_pages2_range(mapping, bytenr >> PAGE_SHIFT,
> -				      (bytenr + BTRFS_SUPER_INFO_SIZE) >> PAGE_SHIFT);
> +		filemap_invalidate_pages(mapping, bytenr,
> +				bytenr + BTRFS_SUPER_INFO_SIZE - 1);
>  	}
>  
>  	filemap_invalidate_lock_shared(mapping);
> -- 
> 2.47.3
> 

