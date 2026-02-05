Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD37ECD981
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 15:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F906B0089; Thu,  5 Feb 2026 10:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD036B008A; Thu,  5 Feb 2026 10:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FBF56B0092; Thu,  5 Feb 2026 10:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5ED6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:56:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2ECF1A02E5
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:56:46 +0000 (UTC)
X-FDA: 84410856012.29.1439AE3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8880D20002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:56:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ilFoiW3n;
	spf=pass (imf13.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770307004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eUzdVsVgqGYxQMSlMfTZqWPBf2xiq3xt7FhI76ZwiI=;
	b=oF+HRkAGek5Ve1wKWbQOhElKi7hBecwgcyD6kdXOJiPOHj/CktdU4uvqJqdqwlSc9ngbOp
	IM95gJdlxuCa3BARbkahx86n+tdJ+JZKqwoEAPGZV+jkf7bJptENSdi0Ns9EQNOBOKDXh2
	iRByUkNezzP/p6YtAe8lqoax9cKgJa4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ilFoiW3n;
	spf=pass (imf13.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770307004; a=rsa-sha256;
	cv=none;
	b=7kHmqaaqTOu4LT2Th1wccrbzgHDtd7ViLD36dr14P2BS39G8iEBCM9begMveARXWVR2fJv
	e9rOdH0HA3skv77y8pxDvRvSfZXIUTB9dUvkdaJIUCHOYuDijAkWzf4Qu33gHzShBI46x6
	HMpT+8MMIH2EPIs3tCx7OA6/Ax+ZBBg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770307003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eUzdVsVgqGYxQMSlMfTZqWPBf2xiq3xt7FhI76ZwiI=;
	b=ilFoiW3n2K1GfGb+PSGW90aHtedUIGwQd/IJnTIGUSpUSA1qmrsFy39DhSsH2pEuTNvOzt
	j9rAk8EtUsUGXQurHim7QdKHOUVL6hJ20n9+Gr0u0lAfwKYnid0sGz0Ginh/LgZ31vG8Jm
	gpC3kDHFYHhceIS3VaW3wSD4mnMQELg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-AUlrj7mrP0CGSw1HpnAcmw-1; Thu,
 05 Feb 2026 10:56:36 -0500
X-MC-Unique: AUlrj7mrP0CGSw1HpnAcmw-1
X-Mimecast-MFC-AGG-ID: AUlrj7mrP0CGSw1HpnAcmw_1770306993
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 589AB1955F28;
	Thu,  5 Feb 2026 15:56:32 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.110])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0266300DDA1;
	Thu,  5 Feb 2026 15:56:26 +0000 (UTC)
Date: Thu, 5 Feb 2026 10:56:24 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org,
	mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de,
	ritesh.list@gmail.com, dave@stgolabs.net, cem@kernel.org,
	wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 4/6] xfs: tag folios with AG number during buffered
 write via iomap attach hook
Message-ID: <aYS9qOxsv-xoUwGZ@bfoster>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79@epcas5p2.samsung.com>
 <20260116100818.7576-5-kundan.kumar@samsung.com>
 <20260129004745.GC7712@frogsfrogsfrogs>
 <7dc267e7-b6e0-4be2-a60e-9d90dcf472eb@samsung.com>
MIME-Version: 1.0
In-Reply-To: <7dc267e7-b6e0-4be2-a60e-9d90dcf472eb@samsung.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 8yyyJlX010XbEUNqIJSWuawh7reuJ9mLM98ZGcv7TeY_1770306993
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: i4xbj39gghmd8y8n7phcrud671684gks
X-Rspam-User: 
X-Rspamd-Queue-Id: 8880D20002
X-HE-Tag: 1770307004-475037
X-HE-Meta: U2FsdGVkX18IjYb2KbnuLWTgCcDJMw0+QyyANcD1Sj1yz+K44CfDRhW380r8dOVFxhBtgLvBbnkfZuAEYcMPAbgHL/kMRYjmlM2hW0pQimoIwYYGPSb/OWnsSmtUDueD6J2YCiBACzbji4L5J2yJph1lGb8ko+TLgvzoHKFcaTb2FsvEAFd/zqoIaf+YIjUzxwFBloQMC8VZ8LERvgZhbRCZmRNI+5N3h8Pj9hveUB8uXzT8dYmS8SfTYq8RjBUkIRCU+RbudqSqX9JnfLx2RsZhLCDqOJKuR3wdq8uKbAg57+slk/QcpJlp6DVl5na9vi0opqW8lQMkN0x9UTMQY/cQTdyWqZdlzqKy3bmtC/6CuSd+cPnWqxfphTwhXBNhSj2hDUjYieSbdXVeGuAWSRBnKrxNqhlQdXBgsaB1IpueoyyLn2f6WVGtgdTBN6y6d+/vWKoTybtXW1jz6b587mSoxam6Wx9eTWMFbTzdn6nelzeIvCULY/WCsKYXQJyu+Rh+v0ECVC+NVT+z2yzwMMxrIQ0GAgXuc9trPKokR45ZpRTmd4XEeW6lPKVP3Rnkn634IQs6BRx+GRaZksiaDUhrv8A4Kv6zQhkQgc3idMx9OfwEtp0inJoiUH7lRy+1f/Bcfo+DhItC/dnecbBADOXVtwdlUbf9JOp9bbF20lpyGTOUtk1pADO7P34Xd3Kho2HPeX9BUzFMAPsyCkvoZr6kCveIUJZZuhTKmXY4wMlDlmlAiHopx9jnIlxOKEPYmPZXeiblt+sOkFCnHTTX01hCVcd1Ota/9xfO5ABKUWaBe4GiU8mAis8opy1zixMhvg0CHtuaQcWg2J2iZqFmd9ZNtRlnCqDTJLfy1yJqLOyCRoqZD7u0Vubg4aP01pntynomJDUj5i1tRUo2GjiaPx+wF7RGEG7Kq5hNBP6bPXHwBtM7f5Sbri/zA41aZbY0eyC8dPYOb/eMsrNZFLh
 GJjbriHQ
 zwqc7ybeRSZPncT/hbQWuSjt+eJu7XGYEfS+LcSYtoQW6KmRwwC/47w10oMPnFcvtrPnkP6BGT66ceLXYBDoc7083vMqlcUWpjsVFp4CuoUn+gD+cgdwAM6FsSp8uY7zsf6ahgCRVMboJrOpt61dt5h/N8dHfCQs54VV51ozYyYfebwXJU7KKxJ+btnRGKSFkzCRa1JXo4RqlFHF1N7yctSO0vj7vZouzD8/vCXxNwy/i7dr1H57ym353hA1qaSfrFFRedRHiMOV6yU5VpVK3bPwMsu0vDq1qKHT2+icBQyibQi3ZjU7KXK6hQq3Y2+/vGVlSDs3wObczvFhGz2bBmrlei5ncCbDOplti5RPj+ywd4/SwQsPOsfoIUuq6/otQJ8+IMyFbE+Tb73Q+FuoIxpRepk07kX2KmzIp2N1qqO92keS02Ugrm1wR83vKT8kgROodLxFtEeTuCFk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 12:58:34PM +0530, Kundan Kumar wrote:
> On 1/29/2026 6:17 AM, Darrick J. Wong wrote:
> > On Fri, Jan 16, 2026 at 03:38:16PM +0530, Kundan Kumar wrote:
> >> Use the iomap attach hook to tag folios with their predicted
> >> allocation group at write time. Mapped extents derive AG directly;
> >> delalloc and hole cases use a lightweight predictor.
> >>
> >> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> >> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> >> ---
> >>   fs/xfs/xfs_iomap.c | 114 +++++++++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 114 insertions(+)
> >>
> >> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> >> index 490e12cb99be..3c927ce118fe 100644
> >> --- a/fs/xfs/xfs_iomap.c
> >> +++ b/fs/xfs/xfs_iomap.c
> >> @@ -12,6 +12,9 @@
> >>   #include "xfs_trans_resv.h"
> >>   #include "xfs_mount.h"
> >>   #include "xfs_inode.h"
> >> +#include "xfs_alloc.h"
> >> +#include "xfs_ag.h"
> >> +#include "xfs_ag_resv.h"
> >>   #include "xfs_btree.h"
> >>   #include "xfs_bmap_btree.h"
> >>   #include "xfs_bmap.h"
> >> @@ -92,8 +95,119 @@ xfs_iomap_valid(
> >>   	return true;
> >>   }
> >>   
> >> +static xfs_agnumber_t
> >> +xfs_predict_delalloc_agno(const struct xfs_inode *ip, loff_t pos, loff_t len)
> >> +{
> >> +	struct xfs_mount *mp = ip->i_mount;
> >> +	xfs_agnumber_t start_agno, agno, best_agno;
> >> +	struct xfs_perag *pag;
> >> +
> >> +	xfs_extlen_t free, resv, avail;
> >> +	xfs_extlen_t need_fsbs, min_free_fsbs;
> >> +	xfs_extlen_t best_free = 0;
> >> +	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
> >> +
> >> +	/* RT inodes allocate from the realtime volume */
> >> +	if (XFS_IS_REALTIME_INODE(ip))
> >> +		return XFS_INO_TO_AGNO(mp, ip->i_ino);
> >> +
> >> +	start_agno =  XFS_INO_TO_AGNO(mp, ip->i_ino);
> >> +
> >> +	/*
> >> +	 * size-based minimum free requirement.
> >> +	 * Convert bytes to fsbs and require some slack.
> >> +	 */
> >> +	need_fsbs = XFS_B_TO_FSB(mp, (xfs_fsize_t)len);
> >> +	min_free_fsbs = need_fsbs + max_t(xfs_extlen_t, need_fsbs >> 2, 128);
> >> +
> >> +	/*
> >> +	 * scan AGs starting at start_agno and wrapping.
> >> +	 * Pick the first AG that meets min_free_fsbs after reservations.
> >> +	 * Keep a "best" fallback = maximum (free - resv).
> >> +	 */
> >> +	best_agno = start_agno;
> >> +
> >> +	for (xfs_agnumber_t i = 0; i < agcount; i++) {
> >> +		agno = (start_agno + i) % agcount;
> >> +		pag = xfs_perag_get(mp, agno);
> >> +
> >> +		if (!xfs_perag_initialised_agf(pag))
> >> +			goto next;
> >> +
> >> +		free = READ_ONCE(pag->pagf_freeblks);
> >> +		resv = xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
> >> +
> >> +		if (free <= resv)
> >> +			goto next;
> >> +
> >> +		avail = free - resv;
> >> +
> >> +		if (avail >= min_free_fsbs) {
> >> +			xfs_perag_put(pag);
> >> +			return agno;
> >> +		}
> >> +
> >> +		if (avail > best_free) {
> >> +			best_free = avail;
> >> +			best_agno = agno;
> >> +		}
> >> +next:
> >> +		xfs_perag_put(pag);
> >> +	}
> >> +
> >> +	return best_agno;
> >> +}
> >> +
> >> +static inline xfs_agnumber_t xfs_ag_from_iomap(const struct xfs_mount *mp,
> >> +		const struct iomap *iomap,
> >> +		const struct xfs_inode *ip, loff_t pos, size_t len)
> >> +{
> >> +	if (iomap->type == IOMAP_MAPPED || iomap->type == IOMAP_UNWRITTEN) {
> >> +		/* iomap->addr is byte address on device for buffered I/O */
> >> +		xfs_fsblock_t fsb = XFS_BB_TO_FSBT(mp, BTOBB(iomap->addr));
> >> +
> >> +		return XFS_FSB_TO_AGNO(mp, fsb);
> >> +	} else if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_DELALLOC) {
> >> +		return xfs_predict_delalloc_agno(ip, pos, len);
> > 
> > Is it worth doing an AG scan to guess where the allocation might come
> > from?  The predictions could turn out to be wrong by virtue of other
> > delalloc regions being written back between the time that xfs_agp_set is
> > called, and the actual bmapi_write call.
> > 
> 
> The delalloc prediction works well in the common cases: (1) when an AG 
> has sufficient free space and allocations stay within it, and (2) when 
> an AG becomes full and allocation naturally moves to the next suitable AG.
> 
> The only case where the prediction can be wrong is when an AG is in the
> process of being exhausted concurrently with writeback, so allocation
> shifts between the time we tag the folio and the actual bmapi_write.
> My understanding is that window is narrow, and only a small fraction of 
> IOs would be misrouted.
> 

I wonder how true that would be under more mixed workloads. For example,
if writeback is iterating AGs under a trylock, all it really takes to
redirect incorrectly is lock contention, which then seems like it could
be a compounding factor for other AG workers.

Another thing that comes to mind is the writeback delay. For example, if
we buffer up enough delalloc in pagecache to one or more inodes that
target the same AG, then it seems possible to hint folios to AGs that
are already full, they "just don't know it yet." Maybe that is more of
an odd/rare case though.

Perhaps the better question here is.. how would one test for this? It
might be interesting to have stats counters or something that could
indicate hits and misses wrt the hint such that this could be more
easily evaluated against different workloads (assuming that doesn't
already exist and I missed it).. hm?

Brian

> >> +	}
> >> +
> >> +	return XFS_INO_TO_AGNO(mp, ip->i_ino);
> >> +}
> >> +
> >> +static void xfs_agp_set(struct xfs_inode *ip, pgoff_t index,
> >> +			xfs_agnumber_t agno, u8 type)
> >> +{
> >> +	u32 packed = xfs_agp_pack((u32)agno, type, true);
> >> +
> >> +	/* store as immediate value */
> >> +	xa_store(&ip->i_ag_pmap, index, xa_mk_value(packed), GFP_NOFS);
> >> +
> >> +	/* Mark this AG as having potential dirty work */
> >> +	if (ip->i_ag_dirty_bitmap && (u32)agno < ip->i_ag_dirty_bits)
> >> +		set_bit((u32)agno, ip->i_ag_dirty_bitmap);
> >> +}
> >> +
> >> +static void
> >> +xfs_iomap_tag_folio(const struct iomap *iomap, struct folio *folio,
> >> +		loff_t pos, size_t len)
> >> +{
> >> +	struct inode *inode;
> >> +	struct xfs_inode *ip;
> >> +	struct xfs_mount *mp;
> >> +	xfs_agnumber_t agno;
> >> +
> >> +	inode = folio_mapping(folio)->host;
> >> +	ip = XFS_I(inode);
> >> +	mp = ip->i_mount;
> >> +
> >> +	agno = xfs_ag_from_iomap(mp, iomap, ip, pos, len);
> >> +
> >> +	xfs_agp_set(ip, folio->index, agno, (u8)iomap->type);
> > 
> > Hrm, so no, the ag_pmap only caches the ag number for the index of a
> > folio, even if it spans many many blocks.
> > 
> > --D
> > 
> 
> Thanks for pointing out, I will rework to handle this case.
> 
> >> +}
> >> +
> >>   const struct iomap_write_ops xfs_iomap_write_ops = {
> >>   	.iomap_valid		= xfs_iomap_valid,
> >> +	.tag_folio		= xfs_iomap_tag_folio,
> >>   };
> >>   
> >>   int
> >> -- 
> >> 2.25.1
> >>
> >>
> > 
> 
> 


