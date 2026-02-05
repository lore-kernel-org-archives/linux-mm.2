Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECCDECD986
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 16:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC496B0089; Thu,  5 Feb 2026 11:42:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89AAE6B008A; Thu,  5 Feb 2026 11:42:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782496B0092; Thu,  5 Feb 2026 11:42:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 678286B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:42:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31EA914059C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:42:42 +0000 (UTC)
X-FDA: 84410971764.09.AD8039D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 63E9C4000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:42:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IIHoEhLf;
	spf=pass (imf27.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770309760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DyBpTsMkL0zMYGktUe7YqXj8yCO0aT+PkuhoQ5EZ7L4=;
	b=rlXcScsiLtpBtA1QLKu4lLljS8fuEQPlU/0doe84vwue6mXTHKkdehMPmR38tpFagdxsB9
	qQVL8btySDRmyuQKbN22XhGA04U1w94889m4WU3k+5AOU7ly5l3y1DhyYcBzoEAffK8qIv
	tdDUQQ6ubRWabz8rRtNRfe2jjd2Xv6U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IIHoEhLf;
	spf=pass (imf27.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770309760; a=rsa-sha256;
	cv=none;
	b=SP+zIKunaXRd+8GsIJqKeWwZ2n2IGIRUuVPEI4THH8cjCDGoBCdMS3B93PBxDwjZHcFS+N
	gdIx8D/v4aTd5Mposo7xDIhnAn8rFfqgobnP0kT3t4gJXh8VCL5utkuRbeTmg+RBggFSFc
	tcUItqtL+pj1QLLer0aqFAtIqxMd9aA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 793D140C5A;
	Thu,  5 Feb 2026 16:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A177C4CEF7;
	Thu,  5 Feb 2026 16:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770309759;
	bh=qtCIuwxbUz6nAxAm44y57E2QMBh06l1dKLAKWSKgEDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IIHoEhLfk5gLa6aiZb8rIG5WH5MvQz2EcqscXHWOJSfjO9XtyLKuihjRP4fkRIDuv
	 xQ5tqTAHKA7tlox5BoOiDOKTYW0zOvTxvWqnMz9Qk9kb+RBflXQnKCh3b9uPyhv6m6
	 NMXKGnyZJ9PlM1/e+12kS4IgXvVjWG9qnpSs55GwGz+obvdjAbjxLOJfoY9GE9A22j
	 IvLLS7PM5l7wfgzp/+Gqj8IIhKvGcMldeYPIXTFSfzSsNup6mjA3qymBryVRboUu3Z
	 iWcYvj3APifqtCh8ulKn0JM6Vxzm6tK1HNZp7+leExEEZYA9USJEbYOH4DYsEbIrYe
	 EVCVymgbXiqJQ==
Date: Thu, 5 Feb 2026 08:42:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, dave@stgolabs.net,
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and dirty-AG
 bitmap
Message-ID: <20260205164238.GS7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
 <20260116100818.7576-4-kundan.kumar@samsung.com>
 <20260129004404.GA7712@frogsfrogsfrogs>
 <2c485586-83c9-4697-91fc-7b0cee697704@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c485586-83c9-4697-91fc-7b0cee697704@samsung.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 63E9C4000C
X-Stat-Signature: jxn6gchprc7jw8xokqzfq5f68z7ozbrr
X-Rspam-User: 
X-HE-Tag: 1770309760-536517
X-HE-Meta: U2FsdGVkX19gY2tHsrjE59t5Dz7nDNWdPamvDPjF42cVmQotpdPYzAoPE1SITmMNaFD0degdkf0wsy0R46TfRtKkDyK57x7IEFznqR6kNyFQiXOMvZqhGhZ5v3tP3cdb3wIiDLf+3pfkb9NJ20vj6CqSn4NDTWOhOdDOyvqOCnOv37T040W79S9pV2yOZBZvhRGCllZ4hTIM3glXbq4W4JwjyPM4aZhVIDvyCRf05GWzH6k8CEVd5MJtlsYaWjU3QEy9kvq3+0Gc5EoCVAk3WssgOOEJOu9h7e5yJbwPRbhaBYfirIyVp12PvevK5IxScnhxjRnjXhj5T5oBF2iDAJDRCLClUtEkjD1dp7+Q7190RgZ7DizZKI+fZMyP7JKQYqUEoxQHc3ZuXWBwl+4njS2+Df/OlIFdWjwR7fPEOjRLrXnnFG3eImd1pOZcnIcIdRNbhgJmxUeCuzW8ucUOo7mUSF7xfzn0edUywLCUY2GHgEl8VSrU+JjAqbiSaiW3MSqL8LAJed3GpGdTm8AQdW1R/Yq87Ne8EtVL2U4M7bPrOjogGickh0lvb4m2vqlG222y6Xe9Q2j4UCQIxrf0CGe1DNCaj/IYb1AziFGSBkOPjAFmm5ox37z8anLXBtEP2KY30DKC916e4gvzFPmwDd1PPSSvv4Cvf1xBpswAqURpXbRKpE7ZGJSCUWUCfEVT806ks9hlkCci2PBgkbK9cF+rDr/ICqpXsfy38K3VC0SgCp0sA4OHgFQeFVf7dw23ikMnkz9sKUU+6qjg/xTvnQ5jZCW80kbnOXxaG9ZZea6+KvgQaWuHZUq2ZrHIK6siepYtIr2SBkus1SyZgvb68AJvhUh/28pWvvUOyvnyA8uvI/FPlycptYgMNS3pWt1uVQvAg6s4ENOsF8ec1+N6gtY4zRqP3W10s4MPP/i5yBMu4tmuBTvR/2WvScjYxv50TG9RiS5ZHj/Pef7sm3A
 /u816QC5
 JdW7qvJpr9H0UNvUOTskdoWwD9UIjndqMD4n3kkXn24iqfNaiRzPgl6H6greQVvuzafWKPYp2rxe2T+OGZfCz/S5DsAnFSeduBaG8tymO/poY6x5XuOM1jH4dtAiG0iqI3lckYXQB3YSVEdsxhTUZtsuSfTinfISfjElPZdCqd8bZ1BV+Wt9fLaPypVaK+Nii2N7kkbY/AApucxJgDNva+ailbKI671oatPJhh9W4GRMU29joduKCulouxIsXvA7S0HeQB6ru+/MpII16f8MJm5M7LndASmrWCUjbSgPMxn2vGu9N4xc14HdLquVNMTkSH5C3uzP0PED4nVCd4l9WWaHE+EhvPdT69Uz92z5D3sGMxbn7syM8s1E+jHSQW+xU+mpQURa1ukLYfqZNgsUxMMM+kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 12:50:53PM +0530, Kundan Kumar wrote:
> On 1/29/2026 6:14 AM, Darrick J. Wong wrote:
> > On Fri, Jan 16, 2026 at 03:38:15PM +0530, Kundan Kumar wrote:
> >> Add per-inode structures to track predicted AGs of dirty folios using
> >> an xarray and bitmap. This enables efficient identification of AGs
> >> involved in writeback.
> >>
> >> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> >> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> >> ---
> >>   fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
> >>   fs/xfs/xfs_inode.h  |  5 +++++
> >>   2 files changed, 32 insertions(+)
> >>
> >> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> >> index e44040206851..f97aa6d66271 100644
> >> --- a/fs/xfs/xfs_icache.c
> >> +++ b/fs/xfs/xfs_icache.c
> >> @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
> >>   	return XFS_PERAG_BLOCKGC_MARK;
> >>   }
> >>   
> >> +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
> >> +{
> >> +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> >> +	unsigned int nlongs;
> >> +
> >> +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
> > 
> > This increases the size of struct xfs_inode by 40 bytes...
> > 
> 
> I’ll make this lazy and sparse: move AG writeback state behind a pointer
> allocated on first use, and replace the bitmap with a sparse dirty-AG
> set(xarray keyed by agno) so memory scales with AGs actually touched by
> the inode.
> 
> >> +	ip->i_ag_dirty_bitmap = NULL;
> >> +	ip->i_ag_dirty_bits = bits;
> >> +
> >> +	if (!bits)
> >> +		return 0;
> >> +
> >> +	nlongs = BITS_TO_LONGS(bits);
> >> +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> >> +					GFP_NOFS);
> > 
> > ...and there could be hundreds or thousands of AGs for each filesystem.
> > That's a lot of kernel memory to handle this prediction stuff, and I"m
> > not even sure what ag_dirty_bitmap does yet.
> > 
> 
> The bit for an AG is set in ag_dirty_bitmap at write time. During
> writeback, we check which AG bits are set, wake only those AG-specific
> workers, and each worker scans the page cache, filters folios tagged for
> its AG, and submits the I/O.
> 
> >> +
> >> +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
> >> +}
> >> +
> >>   /*
> >>    * Allocate and initialise an xfs_inode.
> >>    */
> >> @@ -131,6 +150,8 @@ xfs_inode_alloc(
> >>   	ip->i_next_unlinked = NULLAGINO;
> >>   	ip->i_prev_unlinked = 0;
> >>   
> >> +	xfs_inode_init_ag_bitmap(ip);
> > 
> > Unchecked return value???
> 
> Will correct in next version
> 
> > 
> >> +
> >>   	return ip;
> >>   }
> >>   
> >> @@ -194,6 +215,12 @@ xfs_inode_free(
> >>   	ip->i_ino = 0;
> >>   	spin_unlock(&ip->i_flags_lock);
> >>   
> >> +	/* free xarray contents (values are immediate packed ints) */
> >> +	xa_destroy(&ip->i_ag_pmap);
> >> +	kfree(ip->i_ag_dirty_bitmap);
> >> +	ip->i_ag_dirty_bitmap = NULL;
> >> +	ip->i_ag_dirty_bits = 0;
> >> +
> >>   	__xfs_inode_free(ip);
> >>   }
> >>   
> >> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> >> index bd6d33557194..dee449168605 100644
> >> --- a/fs/xfs/xfs_inode.h
> >> +++ b/fs/xfs/xfs_inode.h
> >> @@ -99,6 +99,11 @@ typedef struct xfs_inode {
> >>   	spinlock_t		i_ioend_lock;
> >>   	struct work_struct	i_ioend_work;
> >>   	struct list_head	i_ioend_list;
> >> +
> >> +	/* AG prediction map: pgoff_t -> packed u32 */
> > 
> > What about blocksize < pagesize filesystems?  Which packed agno do you
> > associate with the pgoff_t?
> > 
> > Also, do you have an xarray entry for each pgoff_t in a large folio?
> > 
> > --D
> > 
> 
> pgoff_t here is the pagecache index (folio->index), i.e. file offset in
> PAGE_SIZE units, not a filesystem block index. So blocksize < PAGE_SIZE
> doesn’t change the association, the packed agno is attached to the folio
> at that pagecache index.

Ok, so the tag is entirely determined by the AG of the first fsblock
within the folio.

> We store one xarray entry per folio index (the start of the folio). We 
> do not create entries for each base-page inside a large folio. If a 
> large folio could span multiple extents/AGs, we’ll treat the hint as 
> advisory and tag it invalid (fallback to normal writeback routing) 
> rather than trying to encode per-subpage AGs.

Oh, ok, so if you have the mapping and the folio at the same time you
can determine that the entire large folio maps to a single extent, and
tag the whole large folio as belonging to a single AG.  That clears
things up, thank you.

It's only in the case of extreme fragmentation that a large folio gets
flung at the old writeback paths, which is probably good enough anyway.

--D

> >> +	struct xarray           i_ag_pmap;
> >> +	unsigned long           *i_ag_dirty_bitmap;
> >> +	unsigned int            i_ag_dirty_bits;
> >>   } xfs_inode_t;
> >>   
> >>   static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
> >> -- 
> >> 2.25.1
> >>
> >>
> > 
> 
> 

