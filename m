Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1357D73E9B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F70F6B00A2; Thu, 29 Jan 2026 17:40:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5826B00A3; Thu, 29 Jan 2026 17:40:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5BA6B00A4; Thu, 29 Jan 2026 17:40:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7E756B00A2
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:40:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83FD0B857E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:40:05 +0000 (UTC)
X-FDA: 84386470770.03.1C88AE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D2381180009
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:40:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gHizMVO2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769726404; a=rsa-sha256;
	cv=none;
	b=jEgmUWvCR8O9SfS0KsP2tryc6xrVgHLWToFYZbLnDiFrWJmi4aOHeoWJpnnrlRZyVqHpbg
	LTtXORRCPK1CEEIRYejlJrZKquBwv3//IYL3kit6lHYkdcYpM9ibNyJ1B3jDMeaKdTnRWh
	2vpJb+1NYSXxG2JB4Lyp+6ZUGVi8fXM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gHizMVO2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769726404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Lrhhu6XmWv7OTU5/9Ja0WrG88EliA5kUrzcY7VP+ZQ=;
	b=R3LH8+zI1rOfeASp6KoR7Y4VedTtqrXx40kTUMOcnBOAZ/H+1GJAAbkm8JD9WKB2mjvqCD
	gUGhQP1Z7Vrm4obXgQbvR5+0PpUWBbn0/6o/0UT9Zn/G8XjJwFc9+MlNdLr6+r8zElxwAj
	+kcYOzjZmeG6vTKgfBsTmso2RZT0kFs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D766143E3F;
	Thu, 29 Jan 2026 22:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19DDC4CEF7;
	Thu, 29 Jan 2026 22:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769726402;
	bh=BqkteKKVuUUOcgw6u2zVTG6WPapeUuB+aD1Cf5Sx/8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gHizMVO2HJWJqiINHz4+5vg3OB8LqGRiJ1ybfQnAWx3pVa4d0q/NrAbYu4FYV5/Ob
	 PA2NpfUU9vT23BAxSp7YX05+L+TgmkMdrzdjY2zSVH1q03vv22GG/Y60MRmp15mwVY
	 GUzlICSHnwhwFyhAKKbgGA/YlqfGHWVrYolBeCwSefMHeN7A2Ca7pSstQUNvcKblta
	 mXSu1MeW6RbdgFswh21LiyZTceTCP+n+0Kwdk5DfEGuvgHeBfbgHJNk0d/ENTnlXh5
	 QnvbRZOb0v30uqqShEjE2rVXpxoyp2WMucuSKC5twALr7b+ZBOAu6TWdf9q9PJXrD7
	 j1kVyWf/mdZdQ==
Date: Thu, 29 Jan 2026 14:40:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, dave@stgolabs.net,
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 4/6] xfs: tag folios with AG number during buffered
 write via iomap attach hook
Message-ID: <20260129224002.GF7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79@epcas5p2.samsung.com>
 <20260116100818.7576-5-kundan.kumar@samsung.com>
 <20260129004745.GC7712@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129004745.GC7712@frogsfrogsfrogs>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D2381180009
X-Stat-Signature: 3h9ebsysy45k8fmmwie9z89r8q8o87e5
X-HE-Tag: 1769726403-520344
X-HE-Meta: U2FsdGVkX18RU55scX+WI6gIjrKOhb8Rkvw9zX2YSBtxfqsQ69+2ZxYlKkiQxfzKsLY/OvenGktvZSS0MeHK7O7UKoQCntUs474CmP82O0wlO2tuitvSnTURxtr8lbLnBzD7FZRJiRnkR15hmQ5UfDXDbiAdpyKEIYtZS1SOdNX6lyNhapSeR+VjjLAcMo6u02JjTs0m3uxzQcfZggtzgRHVCWYuehV1+XYdFvx4bsnG882A+vA1kPktrO9DihC8I2PW5hj7J1lc+OwaE0+pF+pH+4gzrwGlpWASU7WE5fFDp39IqiMKdaGGmhFqHBUiSmKo8+0YQQFOTMGCXW+pvgmuvEAyNA3xGU71CfDanx6VWJ74ZoKi7cqizF/5n0xqebbpOgD+w5eJazwEU4w2q2XwvJukKat0q4kFI/cPS8xZqOWhS9iZX9LLwGLknjLJ4uXCw7qG04qLkSWjxpyLjMJsbqZTV79VF1g/kBhhY+9YEC4ySnKuRTgHVKti6zEkgzI51GmIDAH9+0Y86U5GBEOhIQ/+HJCRlu9bxnmXccqy8PAmgAAqeo5JBvCSmiPSRfRXD7eycluBy5kzW/9AA1xL/sCIW7GMEPHNR1tIcLNQGROn3e0qaF/Ro9+IHF1RDZT7kvMPKj8dV3X/RCyf4869pnQPFjHB/ObpEQ18Gzb5Hda2BgRXuAINAcTyMutkASNaCCbdukO/vftNAJRJ2LPsOKoImZFjUp9hMAxeGNLuDrEYrCM/91aRy6Wt37CUYgz4t1LLshVjG+LYL5JVf54iXK3vbtuy92PMdJj2OUMk2w5Gs0px89exQ+/eHiFOExV38IyY7+g5H4C/+d/bUCU6ZDilVzorqX3CAi+m8xH7nYDVkE6NaZhixk1qVdeI4tdgt6I1of9XYaZf6e15YXfHOaN8hdxrDjcLfTwLZPU4bSDM7dGiGc4rnZLOgNAbA3FDMEPc28w3fTboQ6j
 gjRRoemc
 e+QUFdNCgVmbjQ5+a0RuVuli63sLmQMQyWenI4saGBy5QpzvEg6Cih3YtmYen6Q2g275TwJR+r4RLSDzeVksUt8wKjmD9wgJjEQxLK973oedzzMxNx8LiFEiGro+2ZFCz666jQ8GlYNZjqAJnqL8cdMpNRsSK+8QKOF6JmHilSOCHARlNnelm6cA0OUL27dv6z6mmUuC/SnNwbGJ73uWmgx0gQCqpzaIj20frgeHfjU82LpczPc6tvmjJyzyXJd+TiAEHBAdsTNy5P2Ns1QtfWtlYgPAUtP6IELMVfhqjBh0cquwFSi7ITSRx4X3U2kx5XNNu5y1J5Ekllr9JhWUQi3OZQPxKZUrk0RFt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 04:47:45PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 16, 2026 at 03:38:16PM +0530, Kundan Kumar wrote:
> > Use the iomap attach hook to tag folios with their predicted
> > allocation group at write time. Mapped extents derive AG directly;
> > delalloc and hole cases use a lightweight predictor.
> > 
> > Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > ---
> >  fs/xfs/xfs_iomap.c | 114 +++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 114 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 490e12cb99be..3c927ce118fe 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -12,6 +12,9 @@
> >  #include "xfs_trans_resv.h"
> >  #include "xfs_mount.h"
> >  #include "xfs_inode.h"
> > +#include "xfs_alloc.h"
> > +#include "xfs_ag.h"
> > +#include "xfs_ag_resv.h"
> >  #include "xfs_btree.h"
> >  #include "xfs_bmap_btree.h"
> >  #include "xfs_bmap.h"
> > @@ -92,8 +95,119 @@ xfs_iomap_valid(
> >  	return true;
> >  }
> >  
> > +static xfs_agnumber_t
> > +xfs_predict_delalloc_agno(const struct xfs_inode *ip, loff_t pos, loff_t len)
> > +{
> > +	struct xfs_mount *mp = ip->i_mount;
> > +	xfs_agnumber_t start_agno, agno, best_agno;
> > +	struct xfs_perag *pag;
> > +
> > +	xfs_extlen_t free, resv, avail;
> > +	xfs_extlen_t need_fsbs, min_free_fsbs;
> > +	xfs_extlen_t best_free = 0;
> > +	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
> > +
> > +	/* RT inodes allocate from the realtime volume */
> > +	if (XFS_IS_REALTIME_INODE(ip))
> > +		return XFS_INO_TO_AGNO(mp, ip->i_ino);
> > +
> > +	start_agno =  XFS_INO_TO_AGNO(mp, ip->i_ino);
> > +
> > +	/*
> > +	 * size-based minimum free requirement.
> > +	 * Convert bytes to fsbs and require some slack.
> > +	 */
> > +	need_fsbs = XFS_B_TO_FSB(mp, (xfs_fsize_t)len);
> > +	min_free_fsbs = need_fsbs + max_t(xfs_extlen_t, need_fsbs >> 2, 128);
> > +
> > +	/*
> > +	 * scan AGs starting at start_agno and wrapping.
> > +	 * Pick the first AG that meets min_free_fsbs after reservations.
> > +	 * Keep a "best" fallback = maximum (free - resv).
> > +	 */
> > +	best_agno = start_agno;
> > +
> > +	for (xfs_agnumber_t i = 0; i < agcount; i++) {
> > +		agno = (start_agno + i) % agcount;
> > +		pag = xfs_perag_get(mp, agno);
> > +
> > +		if (!xfs_perag_initialised_agf(pag))
> > +			goto next;
> > +
> > +		free = READ_ONCE(pag->pagf_freeblks);
> > +		resv = xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
> > +
> > +		if (free <= resv)
> > +			goto next;
> > +
> > +		avail = free - resv;
> > +
> > +		if (avail >= min_free_fsbs) {
> > +			xfs_perag_put(pag);
> > +			return agno;
> > +		}
> > +
> > +		if (avail > best_free) {
> > +			best_free = avail;
> > +			best_agno = agno;
> > +		}
> > +next:
> > +		xfs_perag_put(pag);
> > +	}
> > +
> > +	return best_agno;
> > +}
> > +
> > +static inline xfs_agnumber_t xfs_ag_from_iomap(const struct xfs_mount *mp,
> > +		const struct iomap *iomap,
> > +		const struct xfs_inode *ip, loff_t pos, size_t len)
> > +{
> > +	if (iomap->type == IOMAP_MAPPED || iomap->type == IOMAP_UNWRITTEN) {
> > +		/* iomap->addr is byte address on device for buffered I/O */
> > +		xfs_fsblock_t fsb = XFS_BB_TO_FSBT(mp, BTOBB(iomap->addr));
> > +
> > +		return XFS_FSB_TO_AGNO(mp, fsb);

Also, what happens if this is a realtime file?  For pre-rtgroups
filesystems there is no group number to use; and for rtgroups you have
to use xfs_rtb_to_rgno.  The i_ag_dirty_bitmap and the m_ag_wb array
will be the wrong size if rgcount != agcount; and also you probably
don't want to have in the same per-group writeback list two inodes with
folios having the same group number but writing to two different devices
(data vs. rt).

--D

> > +	} else if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_DELALLOC) {
> > +		return xfs_predict_delalloc_agno(ip, pos, len);
> 
> Is it worth doing an AG scan to guess where the allocation might come
> from?  The predictions could turn out to be wrong by virtue of other
> delalloc regions being written back between the time that xfs_agp_set is
> called, and the actual bmapi_write call.
> 
> > +	}
> > +
> > +	return XFS_INO_TO_AGNO(mp, ip->i_ino);
> > +}
> > +
> > +static void xfs_agp_set(struct xfs_inode *ip, pgoff_t index,
> > +			xfs_agnumber_t agno, u8 type)
> > +{
> > +	u32 packed = xfs_agp_pack((u32)agno, type, true);
> > +
> > +	/* store as immediate value */
> > +	xa_store(&ip->i_ag_pmap, index, xa_mk_value(packed), GFP_NOFS);
> > +
> > +	/* Mark this AG as having potential dirty work */
> > +	if (ip->i_ag_dirty_bitmap && (u32)agno < ip->i_ag_dirty_bits)
> > +		set_bit((u32)agno, ip->i_ag_dirty_bitmap);
> > +}
> > +
> > +static void
> > +xfs_iomap_tag_folio(const struct iomap *iomap, struct folio *folio,
> > +		loff_t pos, size_t len)
> > +{
> > +	struct inode *inode;
> > +	struct xfs_inode *ip;
> > +	struct xfs_mount *mp;
> > +	xfs_agnumber_t agno;
> > +
> > +	inode = folio_mapping(folio)->host;
> > +	ip = XFS_I(inode);
> > +	mp = ip->i_mount;
> > +
> > +	agno = xfs_ag_from_iomap(mp, iomap, ip, pos, len);
> > +
> > +	xfs_agp_set(ip, folio->index, agno, (u8)iomap->type);
> 
> Hrm, so no, the ag_pmap only caches the ag number for the index of a
> folio, even if it spans many many blocks.
> 
> --D
> 
> > +}
> > +
> >  const struct iomap_write_ops xfs_iomap_write_ops = {
> >  	.iomap_valid		= xfs_iomap_valid,
> > +	.tag_folio		= xfs_iomap_tag_folio,
> >  };
> >  
> >  int
> > -- 
> > 2.25.1
> > 
> > 
> 

