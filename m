Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C0B0EB28CB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1A16B0096; Fri,  6 Feb 2026 01:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F5B6B009D; Fri,  6 Feb 2026 01:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E1E6B009E; Fri,  6 Feb 2026 01:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FC686B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:44:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D342D13BA9A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:44:37 +0000 (UTC)
X-FDA: 84413093394.10.5D7966F
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id DD47140005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:44:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SxGTm9ih;
	spf=pass (imf01.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770360275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lk9u4ICPZk54rPPfUJcalYjNGp53FK+yZW2KfFesx1I=;
	b=za9CP53pJOWLAr4AnkXpNP9orM5JfAOPhaCypqmTMfLurw0EbHhnUTw7a13Nkz3oyMRAhl
	CMbr/V0wjZMXYyIgJmPS6aezAQEviGDa+mPTz1fCAlxuJ+SAtfwAuqd/2aCSfNtmHJjgJl
	icgx1JYLnMZE4ogxyWJbOtg0Dm9ceCY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SxGTm9ih;
	spf=pass (imf01.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770360276; a=rsa-sha256;
	cv=none;
	b=itpqeXbqGw6scVdDm+xQaZElGbkHQeBEhP/E4wbIBt12RLZdTXsH3VgprKiG04wdUPenYL
	s+hL/YB4kLkbfhdau/kBFSN6SE+4OWYo2k6XqxR6YEQH1RLMc5/UnBp5PGx4og+04IlwcJ
	FTfjwls1o58kXdfS2fZFl8/3AmHlO/g=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a929245b6aso3350015ad.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 22:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770360275; x=1770965075; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lk9u4ICPZk54rPPfUJcalYjNGp53FK+yZW2KfFesx1I=;
        b=SxGTm9ihZ9GHdrq5//zFunm3+maPcRyQRo4SfrlzCM5z45Uw7c7fNN/sO3TzsogggY
         NSahBKVaDc6ujgu0CTjO4fvdeEu72pco9cerEq5KptaJCTIyQXIlkCY2gLNGaL04Frv5
         hBzJNHUugu1XPp6T3JuKJa16t+UUUF2qW83oA9fA8yqGU0ajvjpK5Mqk9ataqCEJGI8Q
         4XeT+VtJM0s2KSr2w5wXn/ljLrR721UDHFIM5HENbC81E5asvxFqmyJg1xIo8ICJndY2
         ZNT61aeXrP9m2HYd+zsUYSyuvz2L1JEeS0r3fzUlGa5nJKLIuee21/0iEPK05RaLGAwB
         k5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770360275; x=1770965075;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lk9u4ICPZk54rPPfUJcalYjNGp53FK+yZW2KfFesx1I=;
        b=LLydhDr2g8sMaUsBC/xXJzNri4/2axniCgEqIIg2Kqc4YUGOiYNHT0PKyEwIMo9olh
         5VODGvmp874SIbYKDr65bYzE0fMmoQgc8TGiMIrg6s/47SlrtOuRH6IqRZ7dPjU/0Q10
         zzwa6aTsnrfBDD9e8wzr+ITiTYwpKcQqxipOa/gtdYszplHlMm14I2z6BkLJQm1eAMUW
         cO5xfe4lm1Ucz1ZpR9uoabN2S2vba9Ef4hku3/J77iDF+EDL2ci+B3XWBJlkp/uyvoYc
         nwjHH8+QURIhBO0BwyjwYgx9Tss9iyZwVPJZjjgKf3Q1sztqWnS9/oovTLUSNQBrJ+rs
         0Rpg==
X-Forwarded-Encrypted: i=1; AJvYcCUNp2diYZFkGr7ReJv9OIKXm4lLf99XEPDR9OPvN3f9M5P5A0mogQusip3+wUTDOKycGR/nei/Mew==@kvack.org
X-Gm-Message-State: AOJu0YxA9X0TrrH+9fQAxBs+7zg7mpC6Hh2/Nxn6K11q9aPN1MVi+I9E
	f9XXV3/UoPD9UloMHe4QSMp0rX01wV3fEXdEY7il1yMNun9tibHm0KN6
X-Gm-Gg: AZuq6aKwwq1C6XbkugRHNjFr+M0Ix/bMdT17yvxQDmTm68mdtEe685dKgWAj4MFKXBT
	QCfpj5rB3y7bPqCf3wz74q+ok1luSidq1ZIldyiRZF9MnEkkksd0i3tmqfkpgJDhEmnRYhZ8Sip
	mMREmT56MgShyhbl6p6WJ/lTmCjAAzTmmJvUe9iQ9Em2/AsHmmyzr4Y9qKsty1WbD8Y1L+vq7vH
	4772llHU+0WCQdBJnrSAJjKXiRLKt77O5++kxZI1Gh5inX5/S5vTNnP79EWS6cTCOlSRRzREA4Z
	B3HItUl/funrkZhS9Wps0UXPVCnRI+aew2oBLCncxmcVv2Hc2nQhgBK2D3IWcbdGWxBLzhoKsK1
	4uwpytepqIiDXccA5kGWLnrvBFtbgnEqjTMdGIR3BOJBTqpS7zLhIEw1sFVEUMXdgC1nW0Et0x6
	X/kBpJazizDBoPf4JopDRqyis1yW/2e3oN8YSWdmEhrKuLOB7f7Ol2/JZwtK9b9eYk
X-Received: by 2002:a17:902:ef45:b0:2a0:9ca7:7405 with SMTP id d9443c01a7336-2a95192a3d3mr26109155ad.36.1770360274531;
        Thu, 05 Feb 2026 22:44:34 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a952205e83sm16689695ad.81.2026.02.05.22.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 22:44:34 -0800 (PST)
Message-ID: <c400d2a68d87a29e17a08ed03489ca33ea46a8f4.camel@gmail.com>
Subject: Re: [PATCH v3 4/6] xfs: tag folios with AG number during buffered
 write via iomap attach hook
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
 cem@kernel.org,  wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com, 
	vishak.g@samsung.com, joshi.k@samsung.com
Date: Fri, 06 Feb 2026 12:14:24 +0530
In-Reply-To: <20260116100818.7576-5-kundan.kumar@samsung.com>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79@epcas5p2.samsung.com>
	 <20260116100818.7576-5-kundan.kumar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD47140005
X-Stat-Signature: 4g5mqxc6jd4p8qk631pq9e3p4qkc5u8g
X-Rspam-User: 
X-HE-Tag: 1770360275-887121
X-HE-Meta: U2FsdGVkX18kjijSyyMVbmhg9HU1Eh6MTf/3oMUTbA7j8bopuxaMyRZxoyWLm5l5ViUUGgKYR4e6OUJEqOUUmdqxiHeBekfHuSeaK1Zr8uqqrsP9wNA200mETzPI/51YKVBmUmfC5ob410UhrwwOV53Gko5ROPadOp1q5agjE5h4MufAwFxDMvS6641qpl90QDm20Ww+xr8UeLuqIMRu8HSm0gzPPDnlPYcIB1AYY+QPSSrJ16ELnJ3+7mrc6yaMo1fJF6C5cvT0iua7CCn5oAuxCvRF1/8OZDkJkwzHKrk+ZexYBOH/Lrd2XY5sx+IoXS5HHJbCYCmPHUdV+/cQ/nAk9WchJZGSJ/Bs0ZlSmMS9qvwXHdbs8EWfLXza8XnVoc0UTxHYqb9b/rWwgKwkK3VjPviMsEONqHL0YBmKlbuoSji0OMWSbOALT9wNoKbdZg5NL8fjxCHqLZuxa/medrPPsZU0nl/FFwWXgVLy33S3uPVqvh4QDrwA/uh7MhKv9pNybJ/xvFkg+ezTfx2jpbgXY632XYayhbcBSS7Lqr7oyq9DXkqjrB9sorb1NIJn6+K0oK/9Y0ClJZaPvD+4c95uL+V6d5CIIheg9H4z8Wh5VAdDfy7A7kwwPt0bBSRgm1oYPjhPzwct6EySR6Mc8Y7MNoRMmN/zuz2ylWO5L8DauvV1jhmLmWhjknfAvbC4Y/G4CmLnG8+PylIA50r5kDuTQpHHAYE70fQjbph1MqO5EdbTck3ySYpx1Fv5o22vv7pQ6UYqW9rdm9pWrgehsmVZt0Cco9aqSnTi6vJL6FV4G1LtbC7DzP1rg49+DmwkMIvf7kmehdwDGhjyuHETdPvs1eLIAgwyHP2TAg1DQ/SC9D3oNEfTSPq1pwvATIs12RArV2EUzXEU2Z48nHsrtKOt/yfZC6qJiHmtztphc+AIhlqiNgt5z87wZIjQZRKPxT3WdB7tEW7GmwSsVEJ
 YhMvFdP/
 jR8tv/oXI2GnZDVDEnXsNp0axAh11oGrexzl8ovIiCReIwDHVnzEvCT7gqN4hct4zeqFnTOdO8L0bLPdMf3XCLtu3Oi7YUmF9ftC0i/9lWLR5E84AgEipSgNcuQieiSHZo0KixRMdWj+qhnQw65k3VcI6E8GIPzFebwDMCAcE/DtQmt6gPEddnr0CMraL9s6Ooqgh0xfxxcwuhJmJ1dUGjYowqDh/q/4OoxOFF2dhpo8fC39QuU4aESCI8c7zUQ8QcbU5pKF4YVC6jCqwpKiMGvcw1YhX7x8zNAkSIjc+6Rkjf/oqfAEG5m0MeHYBJ8dmhRzG0hWN5x5nTnPaRYIJJYFCm5RQ8yS7sCVodJjGLxaam54Ah0CyPpaPBIe4x5fVpKvp2JyKkab1Kxuxa85IYoAmbMdtUiZibo491VH89CJ/0gd6oqN9BPXZHK7yJhv8F5iWZeDJIWL/LurHgK9Bxth1SVLBL/pTN1UHLvtX/03EAqGr2UnZop60JqmfAL0fMfI/AiBUtW6AnYTE89LHvvKEzrFRDlwtvNk/r4tDz+B13CyUVSVdBeGpfNxgpVLgnx7m4zTaANR3/Obqf3jGOQb1IrnwwqYaGFIxCjwLJJkQHBP1LYwcLTlC150wAtpPyneCzTYS1MrUwglUxVmqPzwWEzHRSQMWjLZb4RRN6OZ8/M8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
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
Nit: Coding style - I think XFS uses a tab between the data type and the identifier and makes all
the identifier align. Something like
int			a;
struct xfs_mount	*mp;
> +
Nit: Extra blank line?
> +	xfs_extlen_t free, resv, avail;
> +	xfs_extlen_t need_fsbs, min_free_fsbs;
> +	xfs_extlen_t best_free = 0;
> +	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
Similar comment as above
> +
> +	/* RT inodes allocate from the realtime volume */
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		return XFS_INO_TO_AGNO(mp, ip->i_ino);
What are we returning for realtime volume? AG sizes and rtgroup sizes may be different, isn't it?
Can we use the above macro for both? Also, rt volume work with extents (which can be more than the
fsblock size) - so will the above work? 
> +
> +	start_agno =  XFS_INO_TO_AGNO(mp, ip->i_ino);
> +
> +	/*
> +	 * size-based minimum free requirement.
> +	 * Convert bytes to fsbs and require some slack.
> +	 */
> +	need_fsbs = XFS_B_TO_FSB(mp, (xfs_fsize_t)len);
> +	min_free_fsbs = need_fsbs + max_t(xfs_extlen_t, need_fsbs >> 2, 128);
A short comment explaining the above?
> +
> +	/*
> +	 * scan AGs starting at start_agno and wrapping.
> +	 * Pick the first AG that meets min_free_fsbs after reservations.
> +	 * Keep a "best" fallback = maximum (free - resv).
> +	 */
> +	best_agno = start_agno;
> +
> +	for (xfs_agnumber_t i = 0; i < agcount; i++) {
Maybe use for_each_perag_wrap_range or for_each_perag_wrap (defined in fs/xfs/libxfs/xfs_ag.h)?
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
Just for my understanding - we are doing a largest fit selection, aren't we?
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
Maybe nit: Unhandled return from xa_store() - It returns void *
> +
> +	/* Mark this AG as having potential dirty work */
> +	if (ip->i_ag_dirty_bitmap && (u32)agno < ip->i_ag_dirty_bits)
if agno >= i_ag_dirty_bits, then shouldn't we throw a warn or an ASSERT() or XFS_IS_CORRUPT() -
Darrick, any thoughts?
> +		set_bit((u32)agno, ip->i_ag_dirty_bitmap);
> +}
> +
> +static void
> +xfs_iomap_tag_folio(const struct iomap *iomap, struct folio *folio,
> +		loff_t pos, size_t len)
Nit: Coding style:
I think xfs functions declares 1 parameter in each line with the ")" just after the last parameter
on the same line. Look at something like xfs_swap_extent_rmap() defined in fs/xfs/xfs_bmap_util.c.
Not sure if the maintainers have hard preferences with this - so better to cross check.
> +{
> +	struct inode *inode;
> +	struct xfs_inode *ip;
> +	struct xfs_mount *mp;
> +	xfs_agnumber_t agno;
Coding style as mentioned before:
struct inode		*inode;
struct xfs_inod		*ip;

--NR 
> +
> +	inode = folio_mapping(folio)->host;
> +	ip = XFS_I(inode);
> +	mp = ip->i_mount;
> +
> +	agno = xfs_ag_from_iomap(mp, iomap, ip, pos, len);
> +
> +	xfs_agp_set(ip, folio->index, agno, (u8)iomap->type);
> +}
> +
>  const struct iomap_write_ops xfs_iomap_write_ops = {
>  	.iomap_valid		= xfs_iomap_valid,
> +	.tag_folio		= xfs_iomap_tag_folio,
>  };
>  
>  int


