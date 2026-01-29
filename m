Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F4ED46C15
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 00:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005B56B0088; Wed, 28 Jan 2026 19:47:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5936B0089; Wed, 28 Jan 2026 19:47:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E015F6B008A; Wed, 28 Jan 2026 19:47:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9C2F6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:47:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 986DC160357
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:47:48 +0000 (UTC)
X-FDA: 84383163816.17.861EC69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2CFD240011
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:47:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H2wFOWTM;
	spf=pass (imf04.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769647667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95hS9JjkjMlSys5J/q3kfQrZl+9w91aYtQWMCKAi+Z4=;
	b=zVRW4Z3uyLoABZQeX/xENf+lwiWztoxPXETd2haebNuplXXqNdNxeQiS0pxtX0Qkjo0ixs
	z3fvUlFnHEipE/zCoQUq1G5ko16kKJFELCQCH1cAtIx3YD5yt3MZTcCZ39XdgAIeRJhFzh
	9mClCIhhkCljNTYHR0A5jDp8ypEUfjI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H2wFOWTM;
	spf=pass (imf04.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769647667; a=rsa-sha256;
	cv=none;
	b=8IsT8/cK0xL5HzMpI+vGqOviziUjIB5ZHpNkkwQh+4wRGXR8yjUzfMZSwPdPT9dN+Oq84t
	q+zkNQCqlWkPisTsQIrxOFG2rrLCvi/QzvUeQsPkLaW6c2Kpt5DanTZCncacMUCykweJCL
	Ii3tjS/o58htFNP8FTdTVT/oarFI2nE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BC4B60126;
	Thu, 29 Jan 2026 00:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFBDC4CEF1;
	Thu, 29 Jan 2026 00:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769647665;
	bh=79HatW7wzep6sdlj/zotqs1dVxY3UNi7aebf5KrPHR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H2wFOWTMwXnJONNciKNdXhjKStW9jkG5iLaO9EtX71yy7Ye1gthzH5SI9dXKLWYkr
	 8Y8yrdEnTtN0+OJtvpx40wdBLR1DqmbzxQbAIKgBlwPOpYebdBPoxSTTSxSqFR+tu3
	 uskw7bhYB7my30G0BlINE6R1Q3GdQymQ+0g2HROWPjJZt+Jj3xU/o3j5MUHoAIX8U8
	 32joMiaNmmgp/Fw19QjDXx82fe/x+CtT/daAx45otmmxfRZTQgajXEQWeIxJQ6wMZZ
	 M8/3Swg6kh55iN6FL5drVRvkxqIj0uzviBP4UGQBceC2XCKp3O0J3B6rtq0BBiQtWS
	 l4gv88XOeoKHQ==
Date: Wed, 28 Jan 2026 16:47:45 -0800
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
Message-ID: <20260129004745.GC7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79@epcas5p2.samsung.com>
 <20260116100818.7576-5-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116100818.7576-5-kundan.kumar@samsung.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2CFD240011
X-Stat-Signature: r5wnapb3yhgg7gqn4fe3yoknnue6b333
X-Rspam-User: 
X-HE-Tag: 1769647666-272533
X-HE-Meta: U2FsdGVkX18jx1Tc48EFiWSXe5qR5fma6one4qn2pMeQoG83gfz31xooyVg87QUoAgVFp87sf1FQS0sTWUgN8XyM4HMBdjarp1zyMiw7tjMorgWRVXs6wYtrV5lc6lKixlqR/HXUHvIdlB1VLIvzP1FTsygdLSbmc6R4iqNiVS9rKrsZDE1nP9CwvmzDhSBx6tN6oJxRIge0eCVu2YS7i/F8oSKQh9B+jt9k+nONDOf+xQS1tmAGZk3SxVX+m+VMCIgskzacKLMVYAdfxxazyT7SkMdUJ4zzKSfXlArZ22WqCz2vG02KUFkFIAtA4WuoZRmlpeOgDa0GsRRvQAk6VUi6ey49wlJ1NCGeT9OlABcTVl4V3ZiYqyj9xPf47gQZS4HZs5YbK8RIkSWwdrjjwSNXjm8rOyIY/yiU3H3FYSGfN8132cTMaY6xvy5f+1D/bfuTxS1fy1C2U3A5jdcpD148Kv2y6Ir4RR1LwZxIl4GFxZzuKYTrVaPmIVniti+HBw4fRwQzcUA7Cw3fMFXUu4khuxwVQ4blhuDujuXsm1Kn0B59U/Ba9ZKzFfFDxGVd2SUEEIICpxnzqNQgV0wYqyh/BQLHBASnnav2jNCP7D6Pi8EqdSt9ENSPXbTvbLmACwsg6nYX9dGB+vK7q9KSYZLcTw5jo3BBWMpCvcg3+6zc72WBfs20UccgDbJDyKNWVMV75YzRwk2CqQro7qriTOsnGvYpvTfbzwpz2osP6W061rWG41QfItmB4ZCAQPRJ2la9qSBC7zsSsxHe7951DfesEl8a1f+GcGg6s3WVKj8va0SkMBPXKkISYuG6iXLx8ZJjbQjGIS9zspE6IULMCoH+8rmWltxeaAqOetmjdyYyuxnd2EZ/5Dcvp1CiQQv2EoHwMsGIA4C+jZ2Z3OTTipEPTM/5q2CjJNY4L8YzywzMLCrKuG/UDI/mKwzoj4J9Kt5jQWQu+rg0bZkHTR4
 rWxzhEB1
 jEQUEmXF/qfEwxz9YrM0V1IQScQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:38:16PM +0530, Kundan Kumar wrote:
> Use the iomap attach hook to tag folios with their predicted
> allocation group at write time. Mapped extents derive AG directly;
> delalloc and hole cases use a lightweight predictor.
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_iomap.c | 114 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 490e12cb99be..3c927ce118fe 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -12,6 +12,9 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_alloc.h"
> +#include "xfs_ag.h"
> +#include "xfs_ag_resv.h"
>  #include "xfs_btree.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_bmap.h"
> @@ -92,8 +95,119 @@ xfs_iomap_valid(
>  	return true;
>  }
>  
> +static xfs_agnumber_t
> +xfs_predict_delalloc_agno(const struct xfs_inode *ip, loff_t pos, loff_t len)
> +{
> +	struct xfs_mount *mp = ip->i_mount;
> +	xfs_agnumber_t start_agno, agno, best_agno;
> +	struct xfs_perag *pag;
> +
> +	xfs_extlen_t free, resv, avail;
> +	xfs_extlen_t need_fsbs, min_free_fsbs;
> +	xfs_extlen_t best_free = 0;
> +	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
> +
> +	/* RT inodes allocate from the realtime volume */
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		return XFS_INO_TO_AGNO(mp, ip->i_ino);
> +
> +	start_agno =  XFS_INO_TO_AGNO(mp, ip->i_ino);
> +
> +	/*
> +	 * size-based minimum free requirement.
> +	 * Convert bytes to fsbs and require some slack.
> +	 */
> +	need_fsbs = XFS_B_TO_FSB(mp, (xfs_fsize_t)len);
> +	min_free_fsbs = need_fsbs + max_t(xfs_extlen_t, need_fsbs >> 2, 128);
> +
> +	/*
> +	 * scan AGs starting at start_agno and wrapping.
> +	 * Pick the first AG that meets min_free_fsbs after reservations.
> +	 * Keep a "best" fallback = maximum (free - resv).
> +	 */
> +	best_agno = start_agno;
> +
> +	for (xfs_agnumber_t i = 0; i < agcount; i++) {
> +		agno = (start_agno + i) % agcount;
> +		pag = xfs_perag_get(mp, agno);
> +
> +		if (!xfs_perag_initialised_agf(pag))
> +			goto next;
> +
> +		free = READ_ONCE(pag->pagf_freeblks);
> +		resv = xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
> +
> +		if (free <= resv)
> +			goto next;
> +
> +		avail = free - resv;
> +
> +		if (avail >= min_free_fsbs) {
> +			xfs_perag_put(pag);
> +			return agno;
> +		}
> +
> +		if (avail > best_free) {
> +			best_free = avail;
> +			best_agno = agno;
> +		}
> +next:
> +		xfs_perag_put(pag);
> +	}
> +
> +	return best_agno;
> +}
> +
> +static inline xfs_agnumber_t xfs_ag_from_iomap(const struct xfs_mount *mp,
> +		const struct iomap *iomap,
> +		const struct xfs_inode *ip, loff_t pos, size_t len)
> +{
> +	if (iomap->type == IOMAP_MAPPED || iomap->type == IOMAP_UNWRITTEN) {
> +		/* iomap->addr is byte address on device for buffered I/O */
> +		xfs_fsblock_t fsb = XFS_BB_TO_FSBT(mp, BTOBB(iomap->addr));
> +
> +		return XFS_FSB_TO_AGNO(mp, fsb);
> +	} else if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_DELALLOC) {
> +		return xfs_predict_delalloc_agno(ip, pos, len);

Is it worth doing an AG scan to guess where the allocation might come
from?  The predictions could turn out to be wrong by virtue of other
delalloc regions being written back between the time that xfs_agp_set is
called, and the actual bmapi_write call.

> +	}
> +
> +	return XFS_INO_TO_AGNO(mp, ip->i_ino);
> +}
> +
> +static void xfs_agp_set(struct xfs_inode *ip, pgoff_t index,
> +			xfs_agnumber_t agno, u8 type)
> +{
> +	u32 packed = xfs_agp_pack((u32)agno, type, true);
> +
> +	/* store as immediate value */
> +	xa_store(&ip->i_ag_pmap, index, xa_mk_value(packed), GFP_NOFS);
> +
> +	/* Mark this AG as having potential dirty work */
> +	if (ip->i_ag_dirty_bitmap && (u32)agno < ip->i_ag_dirty_bits)
> +		set_bit((u32)agno, ip->i_ag_dirty_bitmap);
> +}
> +
> +static void
> +xfs_iomap_tag_folio(const struct iomap *iomap, struct folio *folio,
> +		loff_t pos, size_t len)
> +{
> +	struct inode *inode;
> +	struct xfs_inode *ip;
> +	struct xfs_mount *mp;
> +	xfs_agnumber_t agno;
> +
> +	inode = folio_mapping(folio)->host;
> +	ip = XFS_I(inode);
> +	mp = ip->i_mount;
> +
> +	agno = xfs_ag_from_iomap(mp, iomap, ip, pos, len);
> +
> +	xfs_agp_set(ip, folio->index, agno, (u8)iomap->type);

Hrm, so no, the ag_pmap only caches the ag number for the index of a
folio, even if it spans many many blocks.

--D

> +}
> +
>  const struct iomap_write_ops xfs_iomap_write_ops = {
>  	.iomap_valid		= xfs_iomap_valid,
> +	.tag_folio		= xfs_iomap_tag_folio,
>  };
>  
>  int
> -- 
> 2.25.1
> 
> 

