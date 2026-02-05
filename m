Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D4D7ECD986
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 16:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8BB6B0005; Thu,  5 Feb 2026 11:39:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590E46B008A; Thu,  5 Feb 2026 11:39:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA146B0092; Thu,  5 Feb 2026 11:39:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD406B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:39:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3E7E59A95
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:39:07 +0000 (UTC)
X-FDA: 84410962734.15.05A7EA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 141FF1C0003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:39:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t3WV8VyN;
	spf=pass (imf18.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770309546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FgrT2PezK9mYdnePKKHRQFBkkmCci15FlWryll3gzY=;
	b=bQIpql3nsi6kOKGPi3hJUlhGPetZAstE32GDdkaX8zjd3EOs6kIVS13gt3x+S6CZcDqZQd
	rjhcTdX4+5ZzQ+N47rH9R3qBpIBB7iaZ6dfTmuGHwZ72A3lBLvNKQLSnbqyT6UweVdmtWg
	C473leF/OcmcOQ2o0vjOLGNbaIqYIlY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t3WV8VyN;
	spf=pass (imf18.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770309546; a=rsa-sha256;
	cv=none;
	b=eLodFm6BRPCNakfD+/la90NKVE9hNPIgCq3zyfwKfWoBB2uAoyj9NZBFpknkqBICK4q61m
	aR7r2AMhcdWnVFns1SSUSaUgI7RxG/8c5gNGnRlLPi/FG7bW89P5eHY7LjgK9zcTZAuxyB
	IB0oTCplGKGSfxPjQIMvAjHp7NXe6O4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 79C71600AD;
	Thu,  5 Feb 2026 16:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC302C4CEF7;
	Thu,  5 Feb 2026 16:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770309545;
	bh=UcmZwxtVevu/4LmJwiavf3o+e72PF0+okJOM508h4sM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t3WV8VyNUEUimcDIrcCkevC+zvskn8I+KSeQJ8GZh3XXaNxGxwSYR2WQf+ennWmXn
	 dvkfUYd1YrrGsqA+2BM5Tv3B6z9x22eie/5OSWmrENMSYHHWQ11DeR2WJ7qgC/xwXx
	 IC1yB3pRoG2UwGkUB+yWpHofXG/gU30SGWlRhi6DWHzF85+f75DLjBFZJYLJtS1JEi
	 64GbIbUBD4MQmLdeT9IrxClslHB8F8VFjNXp5RclMzo2Jxu3NCnaBXoUGM+iXfiqXH
	 ViCai7tvqJwdwOalzp5+rG4m+4ncbkGyzRM1pizXA5ERD7dTV0zLjq0KBQmOfGtwMG
	 t+8gPSPNR3piA==
Date: Thu, 5 Feb 2026 08:39:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, dave@stgolabs.net,
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 2/6] xfs: add helpers to pack AG prediction info for
 per-folio tracking
Message-ID: <20260205163904.GR7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7@epcas5p3.samsung.com>
 <20260116100818.7576-3-kundan.kumar@samsung.com>
 <20260129004548.GB7712@frogsfrogsfrogs>
 <4a795b10-95ed-4bba-90c8-9fee57454948@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a795b10-95ed-4bba-90c8-9fee57454948@samsung.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 141FF1C0003
X-Stat-Signature: n9tykrueczsa7izufbuqkxs4pe9qznhz
X-Rspam-User: 
X-HE-Tag: 1770309545-873755
X-HE-Meta: U2FsdGVkX19x/4tcRVASUEPw7rLd+XcgAgR+ebu5XGyOIxtTvveE36yChPjd1cjuiub9dGD3Aogi/yLVoyBOwR6BmdmNqG+wkNKzjA48Xh65DyEPWYvA2uTYH6oP3ik16KlAVfWfFQT5WhklJSL3Vd/cSzCtHY6OwtNGX2X2K8C41JlhY9hzMxWHZjRVYv7PjRL0jtX+goqnJQXRuMBSreBrYyRYFgSyJMjbgHwDhuUL/yn3QgubvfdBG0bcmLR3LYByRd6DSiFjEv7+wpbDCAhtwio2KB0Hlt3kpYCTv4ZBscqsZA0vEftSQTtwYz+tgthyudNSeWjFO07fAx5xw/QIBfAUUA/3sZ5y4uJUrplo7GO2rqbKOpwc2mmrl1AZx3xt+wPJPIU5D7G2ztgPJsNlqw4HNl3H9nnotKI5AEz8q3JgTgIoKUrWsafqbbZXsVljRw1ruvR2Ntaj6pTlY00m3O5zVM9vkw1kf3Zin38QgoUZbqCXJEiHJWh7vSkzYZgkkTNeUZe2EDTrYnlbO+FP1ewQoOjYKvBc0RPRWfgWB9L1PFjpCke9mjd6Yk3N6+bUV8i8/ZSR+36BSk0Gu1b83lP7dWlbCXcerscsr7odVOXW8KgRT0zxpR2iM4dMeW8iPE/o3M9iGeR6FZ3rhpAnn7ZpdLhBXJkKYRdZ64XhBpQuBL3xzUQhpL3oIWHqd4dZb3Iwg6d43Mpb9LdTJAi73lz1CZKp4HeHfANWZHu3hvVQgvdvCmAVaBKLLWWk6WXsX+ZjJ+pjytr9FOLqX0igNHanB7q0jM7r2AVDgeL5Q6IO0Cl07RP0GmTVyjRocEc+u3Mok9IZXonAgZQcjc4SjQzaCqEm/927PN04KonsdLgP8KtOIZEzn/CpXFbr8WBVYGdSV5HoJXg4QU8MWRlkKjd/iA98tj5dn0t/NJKNfKYkrkAtkIgSfEyNDKr2DKLFA60gQCrJGuE9O16
 LaM4a355
 ESNcCo+QeV/ECi3g/9QhxwvgJFeh8kGUncgbpg6aTDk162kAoHDPoA7wDYQ3hZN99WW3VySzawOtGPyzT5o9pw80bi6x2ZFt/sdvVqDAnoyjZBRQwOL05WtWEjZSsHLRGM3UHxjS6EgFxcgZLpZp9QP+gl7eWS6ONg6C8a7ZDCSK5MwBmaVD8BW8K8KLHF/D8xLBDFtBlDwe2LRjL4D08NSxl2j07ToxkZuwkWkQRTK2faokCaRmD0yphbs81on95rVO4nebr5MZX50KdctsRzqFJHdfj1LoUIZvfFHidqCLD4EnFtUgSignCZpTrCiwNTIeXe9gtowtPSSrCKMBYphqIWqQK63GVnC70FYoX1p+/yVqR7RuPXUgDgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 12:45:33PM +0530, Kundan Kumar wrote:
> On 1/29/2026 6:15 AM, Darrick J. Wong wrote:
> > On Fri, Jan 16, 2026 at 03:38:14PM +0530, Kundan Kumar wrote:
> >> Introduce helper routines to pack and unpack AG prediction metadata
> >> for folios. This provides a compact and self-contained representation
> >> for AG tracking.
> >>
> >> The packed layout uses:
> >>   - bit 31	: valid
> >>   - bit 24-30	: iomap type
> >>   - bit 0-23	: AG number
> > 
> > There are only 5 iomap types, why do you need 7 bits for that?
> > 
> > Also, can you store more bits on a 64-bit system to avoid truncating the
> > AG number?
> > 
> > --D
> 
> I’ll reduce the type field to 3 bits (8 values).
> 
> For the AG number, I can drop the artificial 24-bit cap by packing into 
> an unsigned long and storing it via xa_mk_value(), which provides ~60 
> bits on 64-bit systems and ~28 bits on 32-bit systems.

<nod>

> > 
> >> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> >> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> >> ---
> >>   fs/xfs/xfs_iomap.h | 31 +++++++++++++++++++++++++++++++
> >>   1 file changed, 31 insertions(+)
> >>
> >> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> >> index ebcce7d49446..eaf4513f6759 100644
> >> --- a/fs/xfs/xfs_iomap.h
> >> +++ b/fs/xfs/xfs_iomap.h
> >> @@ -12,6 +12,37 @@ struct xfs_inode;
> >>   struct xfs_bmbt_irec;
> >>   struct xfs_zone_alloc_ctx;
> >>   
> >> +/* pack prediction in a u32 stored in xarray */
> >> +#define XFS_AGP_VALID_SHIFT 31
> >> +#define XFS_AGP_TYPE_SHIFT 24
> >> +#define XFS_AGP_TYPE_MASK 0x7fu
> >> +#define XFS_AGP_AGNO_MASK 0x00ffffffu
> >> +
> >> +static inline u32 xfs_agp_pack(u32 agno, u8 iomap_type, bool valid)
> >> +{
> >> +	u32 v = agno & XFS_AGP_AGNO_MASK;
> >> +
> >> +	v |= ((u32)iomap_type & XFS_AGP_TYPE_MASK) << XFS_AGP_TYPE_SHIFT;
> >> +	if (valid)
> >> +		v |= (1u << XFS_AGP_VALID_SHIFT);
> >> +	return v;
> >> +}
> >> +
> >> +static inline bool xfs_agp_valid(u32 v)
> >> +{
> >> +	return v >> XFS_AGP_VALID_SHIFT;

Isn't this just a mask?

	return v & (1U << XFS_AGP_VALID_SHIFT)

> >> +}
> >> +
> >> +static inline u32 xfs_agp_agno(u32 v)
> >> +{
> >> +	return v & XFS_AGP_AGNO_MASK;
> >> +}
> >> +
> >> +static inline u8 xfs_agp_type(u32 v)
> >> +{
> >> +	return (u8)((v >> XFS_AGP_TYPE_SHIFT) & XFS_AGP_TYPE_MASK);
> >> +}

And as Nirjhar noted, please try to use richer types when possible.
s/u32 agno/xfs_agnumber_t agno/

--D

> >> +
> >>   int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
> >>   		xfs_fileoff_t count_fsb, unsigned int flags,
> >>   		struct xfs_bmbt_irec *imap, u64 *sequence);
> >> -- 
> >> 2.25.1
> >>
> >>
> > 
> 
> 

