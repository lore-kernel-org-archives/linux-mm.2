Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6043D46BED
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 00:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0EBC6B0088; Wed, 28 Jan 2026 19:44:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8EA6B0089; Wed, 28 Jan 2026 19:44:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D063B6B008A; Wed, 28 Jan 2026 19:44:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C9E96B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:44:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16D505B75C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:44:08 +0000 (UTC)
X-FDA: 84383154576.08.2EC52A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7E214140002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:44:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NI7vmT9C;
	spf=pass (imf26.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769647446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqSrsgpb1WsGpoWhyfTlBdkBSLXacmN5CFVaA3ukqqQ=;
	b=4aowol/WAsiLfytJXrf5oCuQI61aG3rLn9AnRy5a1siWeBFnX6Btkv95xVQ3jM19CNIXjJ
	jWkaIVlR3/oC/Y76fEIPXroBfRpC8/Y31Rf+HWOUOhRhW2MOkbZABzW3nj/b4Dt4iVJnWp
	tj4wFcbtG2bLDCInOLPho2lnOVKOV1M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NI7vmT9C;
	spf=pass (imf26.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769647446; a=rsa-sha256;
	cv=none;
	b=FOV2kdaYrFpL0bpNtvN6fBk7TK27LRdnp6/ZfGYzh57o2kAFUbMaYK6hVGugae6du0jVz3
	oSmqSVwe1ikv2zrwEaDk6RvtB/b/nnjTvYHdX1HM3U69+c0pH5lJ9LiIYLV3Qq5UGIKTQ2
	7J8AvMfi4uirMKmjQWacDVM8txbrBQI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BDF8160054;
	Thu, 29 Jan 2026 00:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D83AC4CEF1;
	Thu, 29 Jan 2026 00:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769647445;
	bh=du+Chat2KKUjWi9KMstZ4LpJLC7xzl/p+SbRJ5Wo4Zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NI7vmT9CRQFjO8mg1hFcsnq+/zwLSuSJG5XMxheGO3KEhe7eyZQdBY7VfZb+1nCGe
	 R9woJsKNb3DCaoOzYBoG/vEBz6HwICn+EunyGgRGlbqhx2UAmewFUiSdIJZmHZJDFz
	 MbCo2VP9ytTKwTlIePkAuci6DO7CYMhxir91QvsfJQhVaIk5fHM81UQd3OdOdJiYj2
	 uaTuRP+cbyJ6/d24vJgrmraoutXjgUHHfsutaqzIJ5i9nteMYtT7QxBzSxQ3papiPZ
	 WihvCxMaKaukGT/qogCcD6Vtgg0RXFDPE/CFY9yjx4v20buEFL4QTRGtIr0HCTv4Oz
	 7XF37cwgR/2FA==
Date: Wed, 28 Jan 2026 16:44:04 -0800
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
Message-ID: <20260129004404.GA7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
 <20260116100818.7576-4-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116100818.7576-4-kundan.kumar@samsung.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7E214140002
X-Stat-Signature: yatara5hd7f76gwpkbfd136egkee6gft
X-Rspam-User: 
X-HE-Tag: 1769647446-912801
X-HE-Meta: U2FsdGVkX1+oBbCzx0lqM/JjPqYHWCVA15wiqOFAsjkzgCRIw/QAGdcyW28oCqjADlrb1dsm6nAEbzyFoI8+PmaXDe4DuJLFNz02bAGocpRXm6IoJM9avc0j2YJOYGVeGahbk3lbfmu6rWDi+WeF9WlcfZRgdHPPbcZ+SHL43ikC0UnDcv7E++n07E/JcUvRrKflDyciEKTvq/efLessqaSaqi3AEn7LUirLj+7S4RnY3L8E7quJaSkKRq9V9ZiLwNVX+m+rg+hIITwZ87SvcsMYFl2qr6rSZRdDlOyq3k/N5gW2s2G7PcUJlvULYClT7kIGGhjKKCw/vuKgf2LW46GL9fMmIR87som3ngi3Oktmv3YuArrxoc1EnRqrMxL4owsxBR9nS7db/PpQQzGVvlXdWwhxn24EN/sG5j3tbY1r7d+DVLjm9ugRcD7FAo6zZnADRfJUkEORQDuS5ZFaG20os9dN4cLyginqjRWGWztLHlB/fHt9Z7xc8XQZIeOwL1fzaQhJTwLHt9at3VveSsXKAbI28yC2trPYikXSkst0vGh0zzMu0Dk48btxZ4JCjyyPXbLhhVKj7pd677J3KcAwsIbc4jpJkeAYORC8vZra53GTYhrgj426jcuYvUdYcG69pMyWZ1T9De7OIIgS3ZedimhySXTrFXMsmQyEFyVCsG8LJJIGwzKK0smi/5WsSpDQ26iDVeZptF1v6dwJg0uTCCYIYrfxEIxbdso92VY15g8eaWvpf5tUarZkDC0HTPF4kjLy4MipcCBKQil5qMEL5CL63H5n1It5/GrNx8W/f7vB00D2PqsnU2SkSvjMtC0bIqvg/SeMrsxO1JZnWBLWv15qvQdf3VFPuHAiJ5endTPlZFbD1fTOGPvERxVA6dvMqMv2Q+QlQIXdl6h7SpbWHPMPYiBhDv2Q0G9aUtSsgXM8+VTQr6YxN7eY19N6k+92mWMRhTnYsY7Jd3p
 3LJKCLJQ
 ZvDXu0ydwCLVXChg62z9BsDUO+dKEzUdmnmgmFgnb0o30py73FvFonm4X6dc7tEJwyWuaCsLeTYgNI7u2bc5svDs20TEGSTXJTNkhyunsgHdLwi3SvpxSqeraIBm98TsZHKqXZKCyFyDdC6qrkfAoHOa3I2lZd5Y4yH5fkBMcw3qtF2LitghfQfG6cHWC4BprpF15XHyzsXlLjP+v0zDbh+80hFp1ThZZVIg8vE9SE+H6eR9bNfE2jvsD7ERusj7gMW9aMl8V/gGW2922G6+hSLPjJiJjLe3FU7vfNdh7y8dFEHKQADp74DhH2050bgxVOXF1f8HttNWkS1+4lEXZ9JV4dbNNdv0Ttx4vjQ+jBFoIpAknKdPpe0GnJ/zgmN/ZCBLJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:38:15PM +0530, Kundan Kumar wrote:
> Add per-inode structures to track predicted AGs of dirty folios using
> an xarray and bitmap. This enables efficient identification of AGs
> involved in writeback.
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h  |  5 +++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e44040206851..f97aa6d66271 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
>  	return XFS_PERAG_BLOCKGC_MARK;
>  }
>  
> +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
> +{
> +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> +	unsigned int nlongs;
> +
> +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);

This increases the size of struct xfs_inode by 40 bytes...

> +	ip->i_ag_dirty_bitmap = NULL;
> +	ip->i_ag_dirty_bits = bits;
> +
> +	if (!bits)
> +		return 0;
> +
> +	nlongs = BITS_TO_LONGS(bits);
> +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> +					GFP_NOFS);

...and there could be hundreds or thousands of AGs for each filesystem.
That's a lot of kernel memory to handle this prediction stuff, and I"m
not even sure what ag_dirty_bitmap does yet.

> +
> +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
> +}
> +
>  /*
>   * Allocate and initialise an xfs_inode.
>   */
> @@ -131,6 +150,8 @@ xfs_inode_alloc(
>  	ip->i_next_unlinked = NULLAGINO;
>  	ip->i_prev_unlinked = 0;
>  
> +	xfs_inode_init_ag_bitmap(ip);

Unchecked return value???

> +
>  	return ip;
>  }
>  
> @@ -194,6 +215,12 @@ xfs_inode_free(
>  	ip->i_ino = 0;
>  	spin_unlock(&ip->i_flags_lock);
>  
> +	/* free xarray contents (values are immediate packed ints) */
> +	xa_destroy(&ip->i_ag_pmap);
> +	kfree(ip->i_ag_dirty_bitmap);
> +	ip->i_ag_dirty_bitmap = NULL;
> +	ip->i_ag_dirty_bits = 0;
> +
>  	__xfs_inode_free(ip);
>  }
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index bd6d33557194..dee449168605 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -99,6 +99,11 @@ typedef struct xfs_inode {
>  	spinlock_t		i_ioend_lock;
>  	struct work_struct	i_ioend_work;
>  	struct list_head	i_ioend_list;
> +
> +	/* AG prediction map: pgoff_t -> packed u32 */

What about blocksize < pagesize filesystems?  Which packed agno do you
associate with the pgoff_t?

Also, do you have an xarray entry for each pgoff_t in a large folio?

--D

> +	struct xarray           i_ag_pmap;
> +	unsigned long           *i_ag_dirty_bitmap;
> +	unsigned int            i_ag_dirty_bits;
>  } xfs_inode_t;
>  
>  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
> -- 
> 2.25.1
> 
> 

