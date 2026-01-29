Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AABED46C01
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 00:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3D86B0088; Wed, 28 Jan 2026 19:45:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E536B0089; Wed, 28 Jan 2026 19:45:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7C56B008A; Wed, 28 Jan 2026 19:45:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3756B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:45:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAE768C5EB
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:45:51 +0000 (UTC)
X-FDA: 84383158902.17.7B42381
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5EAFB180007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:45:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qkw6C1bg;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769647550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+0wVWPrWHMCGRbxLyFhZBgzDO6Q+zXVgZL3MyqtlYQ=;
	b=doQC9fjD5UVMO3TQ6RyZ1lV7kHpDEL8aa4AUcJy3DZ+wEsYYnn64A5Aw+xUFjTeX0YhBMv
	lSGoaayZchWnBOaA7ONav8lzkWxb/KdW4Gmm4v/H/h4us7429hJOVSVcDQz/8TEn7QPAIo
	/RiUyJdjRsKirZaQ9KHBIZMW0GX5S94=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qkw6C1bg;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769647550; a=rsa-sha256;
	cv=none;
	b=Wy8vBwaH60HEzETjfNeYmC7RSMpwLopE6lhWnydHE9xHvH2AxtEEDr8DsZpc7pHP+ZTvQ/
	ErqFSH4JtrBHqMh6Zg614aHJODYiD3BUa4uJMGiUOA192JxUonPVakNY6UAMPoV3V4Vwni
	7KbvajBqDFQoRYxtY9050033WoVKnQ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A399960126;
	Thu, 29 Jan 2026 00:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542C5C4CEF1;
	Thu, 29 Jan 2026 00:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769647549;
	bh=521PB98LoQFeuzDL2y570ukegXohZNWvlq4XD6gGUZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qkw6C1bgR0YIMU/zkUe+tRHdDbV35uLOcxW6te6qYu1/CKpSxonhKeEtZs0FTCmb2
	 Nzor5bkcAJYlBk/eUA+gi85CY3bVIfB4ZgrVV71iHKKaVNsIUC95bofSmGo6Df05W4
	 VlZDGL4GV+zSIn5X/dI1zcHO5sjJsHQVjgooXShytu4Qn423C04pcaKW0w7gfDgWF8
	 fuozlF2hduYUZ3YT5CqP4ASngpHf29aIOYswugnWnJY8zhiZRF3S+mdZ1LXVEu8BJc
	 OcuU9S7oxoNN9+s4jOr6Viu8WHiWLwa2D6pV/vHocRDyqUpBinm8f+2mAVFvX9BJY/
	 ZYtfME5TmowVA==
Date: Wed, 28 Jan 2026 16:45:48 -0800
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
Message-ID: <20260129004548.GB7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7@epcas5p3.samsung.com>
 <20260116100818.7576-3-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116100818.7576-3-kundan.kumar@samsung.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5EAFB180007
X-Stat-Signature: uqw4kcay6aqxybkkr7xh61c3ayss89i3
X-Rspam-User: 
X-HE-Tag: 1769647550-254458
X-HE-Meta: U2FsdGVkX1+dL0pGvc4UhFIMb+Xb4BKrwgxMDk01XmoouC8Er8x6HzyR0wT4sJ3bzE9bmC5k0xthcyY1wzk2V51AsyTfT51IOHt4O/48lzJltyL2gsFhADDI11cKMKVGmjyCCzouBfkEiYqT/ZX0speyKzAr2HExA4dLHS8Er8guSFamNIQONZndKwQusqlLeGVkVc3kRQF1Tmjf83Z/EemEdm7NZxDi+290XEujOzjxQ416LujdEd9rZxuDgKKxnL+Uz3aixfqVjitKRoAHRSYZ/kG7bT4fUAap53nAN8yrEAO98O+fk+EJfyxyVGzRZbykPEqVepzMFrtLpFpKk3gmyvo94D8kIeS7/L/RsCqwPDU2gUTKL6XQz5s9jjHI3/m1lNog2p1NmQtS33bpLwYFbJ7B+isIVcLTTLsRLYb1rG1Zd85mUt5pHEkG7+2ipKrwHBegQzFYA/aRMuT/WC+iQXM5zeAusYyhyeH58hdnC9Tg10VFpSSK18BgltImSY2Ba1LtMyfVJw12ww86l+Z0T5+AcuFuY023ty8v3yTfEu3PogMkIsET55Qfr5+XAHjG4kblRwZh7LXOjk+fX377n014/ePSfW1z6/wgB5kN2nHWmDi1sGuCpV6onQpCZPA1mAilqzcNUU51OAl7oPLvB83Rz1576sBeu4H7Ef4m9hYZOTjVn7NgR/nSKrW/I0ax+17rSCUsJsuCMLM1wv9lhKHcePeSgLgZSiuaXg/nRCNtmtqDaPtQrZnzsmM3AZYxy5cw8YKGdZ0lxjFWO+mS/FwZfrhM3OJ+XSf6Ig1dIRRvB0ZTOriwnWcQQvYijURRMjVYw9oAwnMg61Ja4RswzqAymiV5+dJUdXjKYpCKFNlLWxGJrg99XbOaK/zJvuCkq5aNukjnHbMKvMP06Z2e42xXXq1th2dmOSNzIwMFwTToAjp2x9aJP0KkXsadfw1D27p9ADur6yCZPpr
 jL+IB985
 WB4KU/VHnamT55rJ5yZDad9x2ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:38:14PM +0530, Kundan Kumar wrote:
> Introduce helper routines to pack and unpack AG prediction metadata
> for folios. This provides a compact and self-contained representation
> for AG tracking.
> 
> The packed layout uses:
>  - bit 31	: valid
>  - bit 24-30	: iomap type
>  - bit 0-23	: AG number

There are only 5 iomap types, why do you need 7 bits for that?

Also, can you store more bits on a 64-bit system to avoid truncating the
AG number?

--D

> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_iomap.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index ebcce7d49446..eaf4513f6759 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -12,6 +12,37 @@ struct xfs_inode;
>  struct xfs_bmbt_irec;
>  struct xfs_zone_alloc_ctx;
>  
> +/* pack prediction in a u32 stored in xarray */
> +#define XFS_AGP_VALID_SHIFT 31
> +#define XFS_AGP_TYPE_SHIFT 24
> +#define XFS_AGP_TYPE_MASK 0x7fu
> +#define XFS_AGP_AGNO_MASK 0x00ffffffu
> +
> +static inline u32 xfs_agp_pack(u32 agno, u8 iomap_type, bool valid)
> +{
> +	u32 v = agno & XFS_AGP_AGNO_MASK;
> +
> +	v |= ((u32)iomap_type & XFS_AGP_TYPE_MASK) << XFS_AGP_TYPE_SHIFT;
> +	if (valid)
> +		v |= (1u << XFS_AGP_VALID_SHIFT);
> +	return v;
> +}
> +
> +static inline bool xfs_agp_valid(u32 v)
> +{
> +	return v >> XFS_AGP_VALID_SHIFT;
> +}
> +
> +static inline u32 xfs_agp_agno(u32 v)
> +{
> +	return v & XFS_AGP_AGNO_MASK;
> +}
> +
> +static inline u8 xfs_agp_type(u32 v)
> +{
> +	return (u8)((v >> XFS_AGP_TYPE_SHIFT) & XFS_AGP_TYPE_MASK);
> +}
> +
>  int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
>  		xfs_fileoff_t count_fsb, unsigned int flags,
>  		struct xfs_bmbt_irec *imap, u64 *sequence);
> -- 
> 2.25.1
> 
> 

