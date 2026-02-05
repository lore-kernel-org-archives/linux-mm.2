Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3803FECD986
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 16:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA966B0005; Thu,  5 Feb 2026 11:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98BEF6B008A; Thu,  5 Feb 2026 11:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882136B0092; Thu,  5 Feb 2026 11:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7776F6B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:32:21 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35B681C4D8
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:32:21 +0000 (UTC)
X-FDA: 84410945682.03.EA0F1F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D439180011
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:32:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MlLp2Za6;
	spf=pass (imf16.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770309139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCF5yGnEVNg96RnCNAiL9bJHwzbOma8W4avFbYeP3ZE=;
	b=V+GHwmSweQ/WNSnPdioGGy4lHu6wxb0oZ9m1BV1Ww60kmZrdb7AskMXC/Px8v7g05UGMZP
	4hKvGKIrmXielGpHcw5s7I97XkThxswwcFDrEXIKyuvVfFKt8h5ipRTqTjw5kI0vc8W5mt
	ozLxqFO51SahN+0DCgGToSiT0JAdfog=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MlLp2Za6;
	spf=pass (imf16.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770309139; a=rsa-sha256;
	cv=none;
	b=TqVGlsaN1fp9bImslZSm2uFlyE5PN1G3irySQKz6hye/oRbF5+bS4V71hKCfqmIODp3+NY
	0mofjJspfe+MRiashrKH5l1Svs3/BCzrHohiZyh51b+2X7ErDjpEKBUT73QAZDRcO2X8z6
	SHIJCaKL6TBTsi6MYdGBxIwJLUoyNhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 645754325E;
	Thu,  5 Feb 2026 16:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BFCC4CEF7;
	Thu,  5 Feb 2026 16:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770309138;
	bh=ox88WtHGiiYOhH4XqdUloyEH4N3O9sMbYGPBhwJX4g0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MlLp2Za6W5x+2McLgpSsTvMJpbAxSVZaRee1JEt6IBwhlzVZDa2wBdk+583Z0ILAk
	 9Zq+JNWNnu/UgH7ZoB0ZQ4RaiW69mH7Kk0/v6KJPTjzcOmiEZ32xgghNIfXWZqOh2O
	 hdDg1EFIXgmNh9Bt6zsC9bq6NgHmF8BeklvKk81oflkULGakWcYx8SXLisNltZPj+f
	 iZTQaVn7wW7Di7TFwnLrkiU3ng9a9kTCquMMj8v6Ob47LUn4MZ7ChCa2XZz9dV/lOj
	 kDeHBdZtqJWQhFjUVjPDkhwuxB9Px76fioXmwq5jZaS50G2kEaN1mWdMyENBapvO9y
	 1CswA5QUbsviw==
Date: Thu, 5 Feb 2026 08:32:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org,
	mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de,
	ritesh.list@gmail.com, dave@stgolabs.net, cem@kernel.org,
	wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and dirty-AG
 bitmap
Message-ID: <20260205163217.GP7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
 <20260116100818.7576-4-kundan.kumar@samsung.com>
 <20260129004404.GA7712@frogsfrogsfrogs>
 <90870969cb6f04346d6dba603838abf993a42f5b.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90870969cb6f04346d6dba603838abf993a42f5b.camel@gmail.com>
X-Stat-Signature: 3c86tccddfsj54eabq9eaezyshekcon5
X-Rspamd-Queue-Id: 6D439180011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770309139-566461
X-HE-Meta: U2FsdGVkX197CKOVYOycEqNavx7OVjQNCdboR3ZJt5fQsGc0v2krTOa0cyRGncxOCeFl8dfxR4sTQbYEPo0tM+fs6qSxldswgkHLbjtociE4eGUtH2D0UcOGDxePn//Q1wcLq1Weq25alEsEXYd/sBsUS21L018c1+6Gm7Kxt8rZJMTwX+RBrGQhm757YzLrtyYfgEfynzhjdNF8rzJIzeJISbU2Z7sjkuy5sbgD1a1j2XmpL1IgBIAuZ4zYo55FWJ7TvoAbi+MVC3IVUSqrpurr/EUJrJPo3AzEMXhe4R8XLiSMJ97S/CG3ZfpRNgsvPxlRsCpNt6J3BlHH7mbBC7tuVqwrY1Gl8OWgUrDkKjW17yW/IXh5l7vkzzBJ/EzF5op5KeDeToWLu7Ce9oSN8ZSf72TS4Kua9rMsvoX1/W4uO8YxtsXERQiO9ntT6Bs6ujZxeyqoKw6B1Tj6DB8Sf9mKEcZEWMUBKYA1PDkc82Yb9A29lnG47hm6uPTbPmBXAhKwIOPV3uB1LCPVWwWIypf7aaS/B7anDfm00ojiV25GXHyLj/UJxum5+8nM49u47HupuxacdQ7ssvgrRyc0hXQUyFhLGCXGy1U+Qc5lw8zxGcV7v+ef33/MkqOlE+9NUban7/+MJiiUR2yngyhSx6bKH/zKk/xZLYtxg03Pea5COWN5q1DzhvdHPJs/24WEZw72rx8eUXSIWrB0jBy9EpPF+zqbtnkjIBZrNRMCgzdV6rRVqTrRerQ4Nx/K9c2WUQlXixCDUuRPnhVSCUeWG2Ttw+C7Nw9RgXCKpHkaw1/ssw+tKbD/q8Az85vmcqcFBF3wncw6O8VKW483iDQ85XElZ6V4LEce4u0gkK0NwtQRTb09XtTUk9KhOubeQ59cCIbGwt2vV+0KpJY8T/iFuTx5vnsc9DYppfiFW1C2hrQdYCp19LS+X8BYsxFo0stx4oHnA39ywPZ8QsePZR8
 0jnPdwOz
 ZjQ9PbT+ERPA8Vv/lCOkDiVnISK2rjakTq1MauDHZyKJM8MpY1NzvUAiSx4cI4GXuzWIc2q0hT0f1w4f1ngzq8LI1hU6pet5VKjIGx+DPS4fvt9HDwsF9U3UW2ElAZsilKs+jNxaAnsGJysHS8tAzJDYMnwJS1XyVc2UVt3f8aA27wfTkATCbV1KgLO3BME8fdJkITeyaPjaAbIK9dkGOojKcEgY2clNYL3VuQq/WZanLfzZni/ILukT37rGzTP3t6uKp8CGqEcrTiNgJXKboSfnsmNEoOPJIU/VqxyHgdZLiI1uV6qHwTAq/iYX2fUNCADy9ZHk2gn7wnfyvLqoAPMgRcNmBhN1DCx66/HR0LfY37ddgGcovJYrKBQDTsrbKneV1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 12:14:35PM +0530, Nirjhar Roy (IBM) wrote:
> On Wed, 2026-01-28 at 16:44 -0800, Darrick J. Wong wrote:
> > On Fri, Jan 16, 2026 at 03:38:15PM +0530, Kundan Kumar wrote:
> > > Add per-inode structures to track predicted AGs of dirty folios using
> > > an xarray and bitmap. This enables efficient identification of AGs
> > > involved in writeback.
> > > 
> > > Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> > > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > > ---
> > >  fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
> > >  fs/xfs/xfs_inode.h  |  5 +++++
> > >  2 files changed, 32 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index e44040206851..f97aa6d66271 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
> > >  	return XFS_PERAG_BLOCKGC_MARK;
> > >  }
> > >  
> > > +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
> > > +{
> > > +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> > > +	unsigned int nlongs;
> > > +
> > > +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
> > 
> > This increases the size of struct xfs_inode by 40 bytes...
> > 
> > > +	ip->i_ag_dirty_bitmap = NULL;
> > > +	ip->i_ag_dirty_bits = bits;
> > > +
> > > +	if (!bits)
> > > +		return 0;
> > > +
> > > +	nlongs = BITS_TO_LONGS(bits);
> > > +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> > > +					GFP_NOFS);
> > 
> > ...and there could be hundreds or thousands of AGs for each filesystem.
> > That's a lot of kernel memory to handle this prediction stuff, and I"m
> > not even sure what ag_dirty_bitmap does yet.
> > 
> > > +
> > > +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
> > > +}
> > > +
> > >  /*
> > >   * Allocate and initialise an xfs_inode.
> > >   */
> > > @@ -131,6 +150,8 @@ xfs_inode_alloc(
> > >  	ip->i_next_unlinked = NULLAGINO;
> > >  	ip->i_prev_unlinked = 0;
> > >  
> > > +	xfs_inode_init_ag_bitmap(ip);
> > 
> > Unchecked return value???
> > 
> > > +
> > >  	return ip;
> > >  }
> > >  
> > > @@ -194,6 +215,12 @@ xfs_inode_free(
> > >  	ip->i_ino = 0;
> > >  	spin_unlock(&ip->i_flags_lock);
> > >  
> > > +	/* free xarray contents (values are immediate packed ints) */
> > > +	xa_destroy(&ip->i_ag_pmap);
> > > +	kfree(ip->i_ag_dirty_bitmap);
> > > +	ip->i_ag_dirty_bitmap = NULL;
> > > +	ip->i_ag_dirty_bits = 0;
> > > +
> > >  	__xfs_inode_free(ip);
> > >  }
> > >  
> > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > index bd6d33557194..dee449168605 100644
> > > --- a/fs/xfs/xfs_inode.h
> > > +++ b/fs/xfs/xfs_inode.h
> > > @@ -99,6 +99,11 @@ typedef struct xfs_inode {
> > >  	spinlock_t		i_ioend_lock;
> > >  	struct work_struct	i_ioend_work;
> > >  	struct list_head	i_ioend_list;
> > > +
> > > +	/* AG prediction map: pgoff_t -> packed u32 */
> > 
> > What about blocksize < pagesize filesystems?  Which packed agno do you
> > associate with the pgoff_t?
> Sorry but I am bit unfamiliar with the term packed agno? Can you please briefly explain does packed
> agno mean?

I was talking about the "xfs_agp" numbers introduced in the previous
patch, which seem to contain the bottom 25 bits of the ag number.

Really I was just asking about multi-fsblock folios -- which block
within that folio do we map to an AG for tagging purposes?

I think Kundan replied elsewhere that it's the first block.

--D

> --NR
> > 
> > Also, do you have an xarray entry for each pgoff_t in a large folio?
> > 
> > --D
> > 
> > > +	struct xarray           i_ag_pmap;
> > > +	unsigned long           *i_ag_dirty_bitmap;
> > > +	unsigned int            i_ag_dirty_bits;
> > >  } xfs_inode_t;
> > >  
> > >  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
> > > -- 
> > > 2.25.1
> > > 
> > > 
> 
> 

