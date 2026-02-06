Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781ACEB28CB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 05:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9427E6B0005; Fri,  6 Feb 2026 00:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0946B0088; Fri,  6 Feb 2026 00:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF356B0089; Fri,  6 Feb 2026 00:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF9B6B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 00:57:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08AFA1A0731
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:57:50 +0000 (UTC)
X-FDA: 84412975500.27.907FC4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4E7FD40008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:57:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oR0LqKAc;
	spf=pass (imf04.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770357468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvXGhmPgHktq4Q0M3fpnV6HmpERBRON4q/rlePx5Jw0=;
	b=TFk5B6p8rG9YWI2iG5q4qQE0x0TLmX69pbVkT1q4P2Q5Hvv0QSmQ1GI78+b9rBjmEM1PPr
	OWTmeKcKKD3BQVXRQyiO9m0359PKV1Pw22Hh7pM5KouPYbaSM4v7Do9KkY+9mwB5iinxca
	Eix7fTBxghj/OacgdmuPRssC9qNxGP4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oR0LqKAc;
	spf=pass (imf04.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770357468; a=rsa-sha256;
	cv=none;
	b=cAwHCowNKNsfZb9YezmdSNrHX/ImK8r8JWATu5PsZEwCzE3MAoO8LC4c4ey71hj+vZ7zYL
	Eal+ONkVPxGDohviUT5H40GeooCGmAP1XdM/jVY42LGjPvLDqa95/kUyWiJBqCponvp6UZ
	cKmSEkznVnFcUN2L4Tc9CPZw4TwZrmc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 17470418CB;
	Fri,  6 Feb 2026 05:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8A4C116C6;
	Fri,  6 Feb 2026 05:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770357466;
	bh=oYL20gj3/vQJmBknDkEoqDhmY9er8aGSnGFscJ9Oh6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oR0LqKAcS9X16qr1qQJHruGs2nDKJ04RRniQXKwzP86qxGWh9O6h5b+I6htfXh26f
	 PkGET2RH+i4keAimTDz/3T5GSzSLqA1lU9cQrkiz8g8lm88AJ1Za9LLKSFHDPb99JG
	 +Cw6vZoOckf9/z9NnCjS0LBy7QCA4VUCuCfcZ9B5lNvtYN1B8khoe71nzPqMWEGftM
	 z2Ihc0zs6BuHsWQNJiz6b6i/o2eiU6V8wSb9QLYZrnqsF3/L4FqenwNygFcmB3Vsjr
	 5i/1wMOHalz3NSANkLmsooHp4jk5jpxGLUepeINn6KV4MRwO1FmnKYFgZyDodPK61w
	 mrUIqPcU8IPXA==
Date: Thu, 5 Feb 2026 21:57:45 -0800
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
Message-ID: <20260206055745.GV7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
 <20260116100818.7576-4-kundan.kumar@samsung.com>
 <87a16d4d9c1e568a37fa07a97dda5777e14e9a8b.camel@gmail.com>
 <20260205163650.GQ7712@frogsfrogsfrogs>
 <a017b49e0fb5b9f1a4f6929d7fb23897c98e2595.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a017b49e0fb5b9f1a4f6929d7fb23897c98e2595.camel@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E7FD40008
X-Stat-Signature: jdfpasy7soujn4by8xg7epwpoustjifp
X-Rspam-User: 
X-HE-Tag: 1770357468-522159
X-HE-Meta: U2FsdGVkX1/rkALNpZ34X89qnmmXOnllnyHOQIDWbxeAgRiKtjUXWeIQ8dzokXsUYVZ5r+tWnT0IggQt/wKM5SDAHab8NskKUW9t8hGmtgyTPTK1EkfbtLBx8toWSmsH95U7n0KauT+3Gr5GxhJxx1XfWEWyMuCg0c8jpruk7UyXG+76JQjIxqbO9xnFqTwVPLh4b8lgzKuttC8+xVbkrN26B2rsXTXm7bLuAcRu/vlJlnyK0dMOmc0sxXWHoJHLNe+vJFL2o7YWwrwNIR7esFnuP6x5+mi+UqBpc0Gz9Gvq8RPodsRTgUj6eM+pyOdbm8AYz7/vjRODU8fqB9sp/5ysJjlIMyy2Exhlt8U4hxVaqOtO6pfuTQq/lrluaRxaMDG6qWovfsg8vH9Wq0/jt4QtX0SyTkwg5jnhfYcAY8CBTQ2IS1i/bNcSW21eMKd08sUWVxj/UaCQLePseMIL3yzPldhjlJ9TR0iDuPGSch5+SAHH6z6K1fOdNsas1ZbZR4QFqMsGL8CHJRxujFDMC7n+4XhDTppSNHrClRhF1RuFcClku+U8Vd0EGuWOUk9Ch+sLV+aVTg/udNSKZ7SZEzlC/lT70UFvb8KFdyBsZn/Yem6XRj8efscmX9Jq5JSSEoU/n0EIG3gxsoY5Rs1jww1WuF0/YDp0GnZ7NYReVZKvzjhWOTs/Y5lTUWArbp19B9D3VNbxerA2j6S+FFz7AcoMpLQfUVUDdybPGGwL9WGD8E+ZKmv152YQOL829z6HkejorJIvy6ebTuq765Q64D1pbW2NOHZEWkU/MzSdni4ktN/9LKC4r47N7ZHUgy56OEAzUs2RiffQTJfPegZrAghjRgc8u82mY0ZGp9gQp+sHGV5tDilZTAEfkPGLBttw8qNFJbbjVCBZJU+zJeTNcLnZmoxNVDTkK7QkagzYEMTzvN/eufnx/GDGEFf/BVgmrkztvDU9iXpFDf+BapD
 HGZLRdjW
 AUiD6jANeNTJWcBnRDI1Q+P+CtLzhnwZ99QJfPwxVVEiDuWqSUapLZANloxTbuaqNJThh1H2x/6nqz1u7F/H3OeP3H09EOafsvJyD3AWQmxiYUqauNf1rGePHMJe+QXDrXaIEkt9PreCTZdXKxsZcH8ZiX42Nny+kG1mqsh/M6w6QGgI57io5iaKOAjlY16StBt4Gx2BeMpmesFoaMRA4WX1H4hxrzGon1nueJ06p3KcVLSwSvokEestMVyOhfQ25F/cNKykn7m/674yVPcDAv/6FkM/V5fA/qiCJIS3uws9Jq8EPnaiSHfGAilVm7Yq65b6ym2uPj1EZGIWjcBiinwTFn/Ed1KBNaHO0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:06:03AM +0530, Nirjhar Roy (IBM) wrote:
> On Thu, 2026-02-05 at 08:36 -0800, Darrick J. Wong wrote:
> > On Thu, Feb 05, 2026 at 12:06:19PM +0530, Nirjhar Roy (IBM) wrote:
> > > On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
> > > > Add per-inode structures to track predicted AGs of dirty folios using
> > > > an xarray and bitmap. This enables efficient identification of AGs
> > > > involved in writeback.
> > > > 
> > > > Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> > > > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > > > ---
> > > >  fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_inode.h  |  5 +++++
> > > >  2 files changed, 32 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > index e44040206851..f97aa6d66271 100644
> > > > --- a/fs/xfs/xfs_icache.c
> > > > +++ b/fs/xfs/xfs_icache.c
> > > > @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
> > > >  	return XFS_PERAG_BLOCKGC_MARK;
> > > >  }
> > > >  
> > > > +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
> > > Similar comment as before:
> > > static int
> > > xfs_inode_init...()
> > > > +{
> > > > +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> > > > +	unsigned int nlongs;
> > > > +
> > > > +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
> > > Nit: The name of the functions suggests that it is initializing the tracking bitmap which it does -
> > > however, the above line does slightly different thing? Maybe move the xarray init outside the bitmap
> > > init function? 
> > 
> > Or just call it something else?  xfs_inode_init_perag_wb?
> > 
> > > > +	ip->i_ag_dirty_bitmap = NULL;
> > > > +	ip->i_ag_dirty_bits = bits;
> > > > +
> > > > +	if (!bits)
> > > Umm, !bits means agcount is 0. Shouldn't we ASSERT that bits >= 2? Or am I missing something?
> > 
> > Technically you can have 1 AG, but you definitely can't mount a zero AG
> > filesystem.
> Okay, but:
> /home/ubuntu$ mkfs.xfs -f  -d agcount=1 /dev/loop0
> Filesystem must have at least 2 superblocks for redundancy!
> Usage: mkfs.xfs
> Or maybe this restriction is just at the userspace tool level?

Yeah.  If the only super dies then the filesystem is completely
unrecoverable, which is why you have to really fight mkfs to spit out
single-AG filesystems.

--D

> > > > +		return 0;
> > > > +
> > > > +	nlongs = BITS_TO_LONGS(bits);
> > > > +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> > > > +					GFP_NOFS);
> > > > +
> > > > +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
> > > > +}
> > > > +
> > > >  /*
> > > >   * Allocate and initialise an xfs_inode.
> > > >   */
> > > > @@ -131,6 +150,8 @@ xfs_inode_alloc(
> > > >  	ip->i_next_unlinked = NULLAGINO;
> > > >  	ip->i_prev_unlinked = 0;
> > > >  
> > > > +	xfs_inode_init_ag_bitmap(ip);
> > > xfs_inode_init_ag_bitmap() returns int - error handling for -ENOMEM?
> > > > +
> > > >  	return ip;
> > > >  }
> > > >  
> > > > @@ -194,6 +215,12 @@ xfs_inode_free(
> > > >  	ip->i_ino = 0;
> > > >  	spin_unlock(&ip->i_flags_lock);
> > > >  
> > > > +	/* free xarray contents (values are immediate packed ints) */
> > > > +	xa_destroy(&ip->i_ag_pmap);
> > > Nit:Maybe have a small wrapper for freeing it the prediction map? No hard preferences though.
> > > > +	kfree(ip->i_ag_dirty_bitmap);
> > > > +	ip->i_ag_dirty_bitmap = NULL;
> > > Nit: Usually while freeing the pointers I prefer:
> > > t = ip->i_ag_dirty_bitmap;
> > > ip->i_ag_dirty_bitmap = NULL;
> > > kfree(t);
> > > In this way, the pointer(i_ag_dirty_bitmap in this case) that I am freeing never points to an
> > > already freed address.
> > > 
> > > > +	ip->i_ag_dirty_bits = 0;
> > > > +
> > > >  	__xfs_inode_free(ip);
> > > >  }
> > > >  
> > > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > > index bd6d33557194..dee449168605 100644
> > > > --- a/fs/xfs/xfs_inode.h
> > > > +++ b/fs/xfs/xfs_inode.h
> > > > @@ -99,6 +99,11 @@ typedef struct xfs_inode {
> > > >  	spinlock_t		i_ioend_lock;
> > > >  	struct work_struct	i_ioend_work;
> > > >  	struct list_head	i_ioend_list;
> > > > +
> > > > +	/* AG prediction map: pgoff_t -> packed u32 */
> > > > +	struct xarray           i_ag_pmap;
> > > > +	unsigned long           *i_ag_dirty_bitmap;
> > > > +	unsigned int            i_ag_dirty_bits;
> > > Not sure but, I mostly see the typedefed versions of data types being used like uint32 etc. Darrick,
> > > hch, are the above fine?
> > 
> > Yes, please don't mix types.  Pick one type and stick with it.
> > 
> > (and yes I wish we could struct bitmap_t(unsigned long))
> > 
> > --D
> > 
> > > --NR
> > > >  } xfs_inode_t;
> > > >  
> > > >  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
> 
> 

