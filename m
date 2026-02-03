Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF27E8305C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 07:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30126B008A; Tue,  3 Feb 2026 02:28:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07BF6B0092; Tue,  3 Feb 2026 02:28:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34546B0093; Tue,  3 Feb 2026 02:28:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1FCE6B008A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:28:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C2F358AC2
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:28:48 +0000 (UTC)
X-FDA: 84402318336.05.FDE2CEF
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf28.hostedemail.com (Postfix) with ESMTP id 16BDDC0004
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:28:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=WX4Yqe79;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf28.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770103726; a=rsa-sha256;
	cv=none;
	b=QPwNP5sh4JDwAGuv7EZZrCs/7wyJtEBRN/dgLwAp1Z/R3pAIgjup+/pz+/6werOTjYaEcP
	Mi/lt3/waPhgWLbpLSzBtP3uTt/BWGrxAnHpqbaaS9oU8VTxrpmQ3xXygahX/oJKnmw5BD
	Z8yQ18Pk3q3Hry4Gq2Adl30SnRxZ1bE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=WX4Yqe79;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf28.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770103726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVnXV5I1ungw4oMzJjmOhnnPWVP5XkxXpd/tF3zKk2U=;
	b=gG0km+XfiizILjKn0lcStHeDNW2JbxysI+p1SaBsk/i0rKMwNJa9V4mFz/zvM/EBb7qGmw
	Z7G494htqfOKh22nAwIeb0kDPEa7cbjq3SHeDgLRMGrGkf/cgNtCFjw8PuSjUmzhnv1pMo
	T4busyVjRs/rU2LhRzc/tf3iWFpQtIU=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260203072841epoutp01d7f0e3d862b4c7e57d2dd6a8b86a5ff7~Qq-S-q2uP1056910569epoutp01e
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:28:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260203072841epoutp01d7f0e3d862b4c7e57d2dd6a8b86a5ff7~Qq-S-q2uP1056910569epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770103721;
	bh=hVnXV5I1ungw4oMzJjmOhnnPWVP5XkxXpd/tF3zKk2U=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=WX4Yqe79e+sqXjef+Sh+x/yUXP/GYVAitaXMBt05wbkhGni2dyzuxqIa/b+Io0X8l
	 4BBr/zf2CGXlQqXqaA3y50iKZQwJRI9GQiq8wMipWYgdmHFIKDsWxMR3YfDyxKSNx4
	 He9vfRFZhbgXyq+GLOz4Exfvzxo9R9auvz98CR1U=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260203072840epcas5p3b5d281879db8a64669f9c7123300df04~Qq-SYfO8L0974709747epcas5p34;
	Tue,  3 Feb 2026 07:28:40 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.92]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4f4w872S54z2SSKb; Tue,  3 Feb
	2026 07:28:39 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260203072838epcas5p1076f207b2f19cada65df4a04ead3408e~Qq-QP4EUR2252922529epcas5p1l;
	Tue,  3 Feb 2026 07:28:38 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260203072835epsmtip1689fa13a25b0afd7d679874f42ec2e2e~Qq-Ndf7TL2522925229epsmtip1U;
	Tue,  3 Feb 2026 07:28:35 +0000 (GMT)
Message-ID: <7dc267e7-b6e0-4be2-a60e-9d90dcf472eb@samsung.com>
Date: Tue, 3 Feb 2026 12:58:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] xfs: tag folios with AG number during buffered
 write via iomap attach hook
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20260129004745.GC7712@frogsfrogsfrogs>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260203072838epcas5p1076f207b2f19cada65df4a04ead3408e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79@epcas5p2.samsung.com>
	<20260116100818.7576-5-kundan.kumar@samsung.com>
	<20260129004745.GC7712@frogsfrogsfrogs>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 16BDDC0004
X-Stat-Signature: 53nw6wig9b7rbuih8kumcnpceczqa7tk
X-HE-Tag: 1770103724-675270
X-HE-Meta: U2FsdGVkX1+vkYLhXsCg0ZXba+HTurdX7+R0ta+FHA5ORRwsAFp2UUS/AlydXPv0u1I5lyN8+WB/zhb2g6GeS5rjxNpb4H6e3dphm1fkRUyF9X2I75uJPVPwmiTpkwV8eH8w7MWvTpP1g3BW33IX5haR9kS/D6hybwx0eeYAn0wPYDfmowJ6+7gmJNstLI/tbN7P35tof+hnyU+K1CyFX2ivEwsHPQWmnxppSGe374F3pMrM5S+ZDn5yHFw0afoLddkstiw5PsX+nAU4DsOgfPsKCfAuMM8ofbAIiYMBkFTTnE6xFX0kIP9dDagEjGKqfSW12T6HRqhx9zMKft7a/+XN+puzdyDr+9syP2/dwjbijwEEFwwq4NxHCdjM40yOhbX+j/dZW5t/4XrJQiy14LPMeOgUIcHcWRAutDzMc8OIkszHo8V0YvGgZbvycU2xuyHfnCX1N/MIOsoymg+tOyhFQRS5A7YftGSY3mX4QiAse4+9wwvJ6Mrc+5eWSVblFATzHP1qJEvxdbZsM4aTlRe5svdDIj1cnfW3ZiA9TD59o0PV+Xn3Z8imLHHtlANbwb96b7kEfLJx/pAiR/4ZfkZnHpnwMpONrrIO6RJGWEZKOJ56lSnW47B/Y2qhv/Vdz4SGXNuK3wCVqIZ9UUh+aXOzON3jf1JAic5v3GAONYkuMraV4kVR+wBEdpt7VTrPzicAYhSUO2RYocK01iknGs1GdzK45mVUrf0NrNW7gdWmIuNZ+blFWqTrt8d/+tIeYygsP0rC9WmvjYs8IryLji/Y6YLsek5wxkTo/uhSkX/SfZR8dblAP/2fSDqfzJrQg4COK1UZ4hrlBMM/jqyy9favsXu9mVOmqXG0LdUQXcLD/oY78fwp2q7JmZvQf2joGHzJxPQg4JsRYe/Y/Lcz9zymqQhvA8K9p+0jhuj2WfOM9kfHfXUEPDEZRlYTv3/tTrYE1lqODuRa2MZcBPt
 Bx5eYIfF
 +sFhQxpYF4nerl86tVMFmKP5hbsduOuMcG/1/Sp9Keep3C0Gg+7wHIulHa/R9UK+M8lkO/fikzcbNj2wWsKi9gLaCRJ/CtaqHn3SmhPt3xBvYWiwxzt9rxJ5Vm5uGKoIsRPpGa36YkOZ3Y2eP62Fy4J/LvZefhPD6hkpVjedlJ9zSmv9aAFqpfhuTv4LODkn6M+iv+n3FVKAnBgs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/2026 6:17 AM, Darrick J. Wong wrote:
> On Fri, Jan 16, 2026 at 03:38:16PM +0530, Kundan Kumar wrote:
>> Use the iomap attach hook to tag folios with their predicted
>> allocation group at write time. Mapped extents derive AG directly;
>> delalloc and hole cases use a lightweight predictor.
>>
>> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>   fs/xfs/xfs_iomap.c | 114 +++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 114 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
>> index 490e12cb99be..3c927ce118fe 100644
>> --- a/fs/xfs/xfs_iomap.c
>> +++ b/fs/xfs/xfs_iomap.c
>> @@ -12,6 +12,9 @@
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_alloc.h"
>> +#include "xfs_ag.h"
>> +#include "xfs_ag_resv.h"
>>   #include "xfs_btree.h"
>>   #include "xfs_bmap_btree.h"
>>   #include "xfs_bmap.h"
>> @@ -92,8 +95,119 @@ xfs_iomap_valid(
>>   	return true;
>>   }
>>   
>> +static xfs_agnumber_t
>> +xfs_predict_delalloc_agno(const struct xfs_inode *ip, loff_t pos, loff_t len)
>> +{
>> +	struct xfs_mount *mp = ip->i_mount;
>> +	xfs_agnumber_t start_agno, agno, best_agno;
>> +	struct xfs_perag *pag;
>> +
>> +	xfs_extlen_t free, resv, avail;
>> +	xfs_extlen_t need_fsbs, min_free_fsbs;
>> +	xfs_extlen_t best_free = 0;
>> +	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
>> +
>> +	/* RT inodes allocate from the realtime volume */
>> +	if (XFS_IS_REALTIME_INODE(ip))
>> +		return XFS_INO_TO_AGNO(mp, ip->i_ino);
>> +
>> +	start_agno =  XFS_INO_TO_AGNO(mp, ip->i_ino);
>> +
>> +	/*
>> +	 * size-based minimum free requirement.
>> +	 * Convert bytes to fsbs and require some slack.
>> +	 */
>> +	need_fsbs = XFS_B_TO_FSB(mp, (xfs_fsize_t)len);
>> +	min_free_fsbs = need_fsbs + max_t(xfs_extlen_t, need_fsbs >> 2, 128);
>> +
>> +	/*
>> +	 * scan AGs starting at start_agno and wrapping.
>> +	 * Pick the first AG that meets min_free_fsbs after reservations.
>> +	 * Keep a "best" fallback = maximum (free - resv).
>> +	 */
>> +	best_agno = start_agno;
>> +
>> +	for (xfs_agnumber_t i = 0; i < agcount; i++) {
>> +		agno = (start_agno + i) % agcount;
>> +		pag = xfs_perag_get(mp, agno);
>> +
>> +		if (!xfs_perag_initialised_agf(pag))
>> +			goto next;
>> +
>> +		free = READ_ONCE(pag->pagf_freeblks);
>> +		resv = xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
>> +
>> +		if (free <= resv)
>> +			goto next;
>> +
>> +		avail = free - resv;
>> +
>> +		if (avail >= min_free_fsbs) {
>> +			xfs_perag_put(pag);
>> +			return agno;
>> +		}
>> +
>> +		if (avail > best_free) {
>> +			best_free = avail;
>> +			best_agno = agno;
>> +		}
>> +next:
>> +		xfs_perag_put(pag);
>> +	}
>> +
>> +	return best_agno;
>> +}
>> +
>> +static inline xfs_agnumber_t xfs_ag_from_iomap(const struct xfs_mount *mp,
>> +		const struct iomap *iomap,
>> +		const struct xfs_inode *ip, loff_t pos, size_t len)
>> +{
>> +	if (iomap->type == IOMAP_MAPPED || iomap->type == IOMAP_UNWRITTEN) {
>> +		/* iomap->addr is byte address on device for buffered I/O */
>> +		xfs_fsblock_t fsb = XFS_BB_TO_FSBT(mp, BTOBB(iomap->addr));
>> +
>> +		return XFS_FSB_TO_AGNO(mp, fsb);
>> +	} else if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_DELALLOC) {
>> +		return xfs_predict_delalloc_agno(ip, pos, len);
> 
> Is it worth doing an AG scan to guess where the allocation might come
> from?  The predictions could turn out to be wrong by virtue of other
> delalloc regions being written back between the time that xfs_agp_set is
> called, and the actual bmapi_write call.
> 

The delalloc prediction works well in the common cases: (1) when an AG 
has sufficient free space and allocations stay within it, and (2) when 
an AG becomes full and allocation naturally moves to the next suitable AG.

The only case where the prediction can be wrong is when an AG is in the
process of being exhausted concurrently with writeback, so allocation
shifts between the time we tag the folio and the actual bmapi_write.
My understanding is that window is narrow, and only a small fraction of 
IOs would be misrouted.

>> +	}
>> +
>> +	return XFS_INO_TO_AGNO(mp, ip->i_ino);
>> +}
>> +
>> +static void xfs_agp_set(struct xfs_inode *ip, pgoff_t index,
>> +			xfs_agnumber_t agno, u8 type)
>> +{
>> +	u32 packed = xfs_agp_pack((u32)agno, type, true);
>> +
>> +	/* store as immediate value */
>> +	xa_store(&ip->i_ag_pmap, index, xa_mk_value(packed), GFP_NOFS);
>> +
>> +	/* Mark this AG as having potential dirty work */
>> +	if (ip->i_ag_dirty_bitmap && (u32)agno < ip->i_ag_dirty_bits)
>> +		set_bit((u32)agno, ip->i_ag_dirty_bitmap);
>> +}
>> +
>> +static void
>> +xfs_iomap_tag_folio(const struct iomap *iomap, struct folio *folio,
>> +		loff_t pos, size_t len)
>> +{
>> +	struct inode *inode;
>> +	struct xfs_inode *ip;
>> +	struct xfs_mount *mp;
>> +	xfs_agnumber_t agno;
>> +
>> +	inode = folio_mapping(folio)->host;
>> +	ip = XFS_I(inode);
>> +	mp = ip->i_mount;
>> +
>> +	agno = xfs_ag_from_iomap(mp, iomap, ip, pos, len);
>> +
>> +	xfs_agp_set(ip, folio->index, agno, (u8)iomap->type);
> 
> Hrm, so no, the ag_pmap only caches the ag number for the index of a
> folio, even if it spans many many blocks.
> 
> --D
> 

Thanks for pointing out, I will rework to handle this case.

>> +}
>> +
>>   const struct iomap_write_ops xfs_iomap_write_ops = {
>>   	.iomap_valid		= xfs_iomap_valid,
>> +	.tag_folio		= xfs_iomap_tag_folio,
>>   };
>>   
>>   int
>> -- 
>> 2.25.1
>>
>>
> 


