Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76ACDECD985
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 16:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35FC46B008A; Thu,  5 Feb 2026 11:36:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D8D6B0092; Thu,  5 Feb 2026 11:36:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20FCA6B0093; Thu,  5 Feb 2026 11:36:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6956B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:36:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55C2B1A050F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:36:54 +0000 (UTC)
X-FDA: 84410957148.02.67332F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A98B540011
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:36:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qWtP1fOV;
	spf=pass (imf01.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770309412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TX9HYmiN11BL41YYlqFO5dHNcvMBByBtBRTpQLlyTp8=;
	b=sQjzYNgnEv0gx4Ev8gKOyyApsTG98YKdE0cJUeEVrXA53G8MgC4iE7qeMdwNZJ3wJKHb6m
	esb6Nod2kNk+U1bvfZOipYzlIHblrY+YnoB3jelFFsyrSLgoqO3SoMRJTIrq2ODUlI28Vl
	Op0RE2NnnyuUd+JS4LzdV52JgPdqr4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770309412; a=rsa-sha256;
	cv=none;
	b=wb8/ihsbIdaaJmfKVVCR1lZ0aL5BO7HlB5+pGqQLgUhcpUUEXDCIsxiK5AUpe4XNqp90d8
	Z7hTW8DVyA1HFwA0sXn4oujP4D7BJoqhb8auByt8fEcLCjaAHyS5XfHkUNwXDBZXCptSzH
	ik96l2T0DuSL/5Nthl5Dh1wBl1e0hXc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qWtP1fOV;
	spf=pass (imf01.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE19C6011F;
	Thu,  5 Feb 2026 16:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E1EC4CEF7;
	Thu,  5 Feb 2026 16:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770309411;
	bh=PWHnFoAeT4ZzfE7wkU3YE+Odl1P4t4VqAmTRmpHKeo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qWtP1fOVcPQAT9Fo8KQ8aRmSIzoMldtPfGwNQacpf5/psLTp6UXgIGdQPH3lKec6i
	 i/6GuaUz6oiAGlvrVJFmqVLcLHOu3b9sgVBNQOs/SUxniOlKoNuv8XfJ9Q/9VKlhsn
	 VZzdmbkwK5/mAJ/Gk8dbvxh5pMOb7aajOWgBgE4ipFapG5+80QmOGMOkbV1KN/Jmc0
	 i/qOy+5V/v4LK5O7o2QWqSq9TnsLcBHqczeLE2iIzS/3zkU07YYCY1q4bhG8nDvNvf
	 lvL5h7O/hxgoYX2Ie8aNnDkUCAqVMLqv+vg/JN85o4qaJLquRtp4/BbsFDIS4UkOQr
	 ionNxzswwX7bQ==
Date: Thu, 5 Feb 2026 08:36:50 -0800
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
Message-ID: <20260205163650.GQ7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
 <20260116100818.7576-4-kundan.kumar@samsung.com>
 <87a16d4d9c1e568a37fa07a97dda5777e14e9a8b.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a16d4d9c1e568a37fa07a97dda5777e14e9a8b.camel@gmail.com>
X-Rspamd-Queue-Id: A98B540011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: swunacd5fxwsa5wbrwwaee8fp8by3rzj
X-HE-Tag: 1770309412-814361
X-HE-Meta: U2FsdGVkX1/8OLasndfDAm0qnNTm9fb4PrAJRV375Ezly2ttqT7jSdJuf1NvlQl5Ew4y2r0IvgsG3UzaWUIltBiWV26RRz3/hQEDLs+TV7UEG4fye6yL8gI5I1bG07GsoD/E1jvy+WTMos8ghpt8pxkpslOWCQPs7kTwuEHF3Q+YRiox7tppATYhJ66ISpJJY2TNVXniTU6jybedhlMOPujqyD5Lbsm2UKDEomAp4iR7FJ+VIF2lyP2TYpwKM0Lhry+XSnWiglZpMcKXZ4S6BEZSRo/dZE+21x8tqP+6cKJpCX8UTU5yt/Hn9jkMOwdI4K8ZK5uFD5wCqWCvwAZKW9xJrJbqObZQbXaaSzYA5/sgLjECSW3FE4ReTZ5oBl8601Zn5bDBMsrjv0B93lsLKby6xb7MvJFxXDsjm0Fqdim1poGHuVqGCH3V28c/9Pb1feljWPCDh9tGQcwhXUwUWjtYPgjJt2wE+7+oqdKlScjWQhn3ZfA9tCc0T2LF5LHLJJ5s3vQRIlaU/EXEWBR5+35SSdfccXrvCrP/947NHcvlv3Le0iggdnq6xyyNSQ5lesEFPi7j3sheWMgaDVMnclB3aprXqWgYrM8ObvB8V18Xef2dWyqJEtuM0iRdewEnkSNKNZJCHa++lyQIYNVzKykNBZuLu5xJuFgUJFZO/p1noOBOiEdwSHVeYtgV6WaFv1XYbiKDdzj6eDM2G39Z/9Cm/4cP6twfkvfgrL+bxxD/xQvEHiDJy2XTTWWCNjDTeeM9tL8gxM2CCjfbJkvDyfSpJ0cnRLaHgiaP0NPHr9jw4d4z0KT17a03U4PoCFND37oFlcgbFF/W23ejR7tlbGrzv2/EsQb9vK4KxE6Dq8tVPM1zZQK090nMAdgK8wXes+MnYqaOBlweBcqI96rr2YImkR3O2wtvStLjGdyTviu2LqaR9nDt/pc28GRyD7jZ7aIlfP1H/kt0ZHAsNle
 eZb9FJVc
 UXJlXdBo3a30/+delkqc4277/+Ku5U9nDSQpq/Uw2j3DOuou6uVJHSAJAV3jbTMrC7hlv7s4hm1X+rFMoL1kC9Xn+KlsaBm3PdYsXoU8fAvqhvHOgPunUjVQCv+6Q2J3Mi3LlXv8Y90duLBE8bDc0TF2T99QBRtE4XZFPlN8lVMXkmZj8zZGBwS/clrEx+JkQfxFCP0sJc9qu7rT1Q8A0hUiQ8O9D8ja9ttJiR/9i25AuHEIVGbH0Q0KFgcpVqi+r5pZ5CE9L66W2nSvrd6QqozZeQi/GArA5GMIZ+5mwibgmnWVDHhCabHTdokHc6l8ZJkFKmlzNudTW+/OOWvprB0XQmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 12:06:19PM +0530, Nirjhar Roy (IBM) wrote:
> On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
> > Add per-inode structures to track predicted AGs of dirty folios using
> > an xarray and bitmap. This enables efficient identification of AGs
> > involved in writeback.
> > 
> > Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > ---
> >  fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
> >  fs/xfs/xfs_inode.h  |  5 +++++
> >  2 files changed, 32 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index e44040206851..f97aa6d66271 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
> >  	return XFS_PERAG_BLOCKGC_MARK;
> >  }
> >  
> > +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
> Similar comment as before:
> static int
> xfs_inode_init...()
> > +{
> > +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> > +	unsigned int nlongs;
> > +
> > +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
> Nit: The name of the functions suggests that it is initializing the tracking bitmap which it does -
> however, the above line does slightly different thing? Maybe move the xarray init outside the bitmap
> init function? 

Or just call it something else?  xfs_inode_init_perag_wb?

> > +	ip->i_ag_dirty_bitmap = NULL;
> > +	ip->i_ag_dirty_bits = bits;
> > +
> > +	if (!bits)
> Umm, !bits means agcount is 0. Shouldn't we ASSERT that bits >= 2? Or am I missing something?

Technically you can have 1 AG, but you definitely can't mount a zero AG
filesystem.

> > +		return 0;
> > +
> > +	nlongs = BITS_TO_LONGS(bits);
> > +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> > +					GFP_NOFS);
> > +
> > +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
> > +}
> > +
> >  /*
> >   * Allocate and initialise an xfs_inode.
> >   */
> > @@ -131,6 +150,8 @@ xfs_inode_alloc(
> >  	ip->i_next_unlinked = NULLAGINO;
> >  	ip->i_prev_unlinked = 0;
> >  
> > +	xfs_inode_init_ag_bitmap(ip);
> xfs_inode_init_ag_bitmap() returns int - error handling for -ENOMEM?
> > +
> >  	return ip;
> >  }
> >  
> > @@ -194,6 +215,12 @@ xfs_inode_free(
> >  	ip->i_ino = 0;
> >  	spin_unlock(&ip->i_flags_lock);
> >  
> > +	/* free xarray contents (values are immediate packed ints) */
> > +	xa_destroy(&ip->i_ag_pmap);
> Nit:Maybe have a small wrapper for freeing it the prediction map? No hard preferences though.
> > +	kfree(ip->i_ag_dirty_bitmap);
> > +	ip->i_ag_dirty_bitmap = NULL;
> Nit: Usually while freeing the pointers I prefer:
> t = ip->i_ag_dirty_bitmap;
> ip->i_ag_dirty_bitmap = NULL;
> kfree(t);
> In this way, the pointer(i_ag_dirty_bitmap in this case) that I am freeing never points to an
> already freed address.
> 
> > +	ip->i_ag_dirty_bits = 0;
> > +
> >  	__xfs_inode_free(ip);
> >  }
> >  
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index bd6d33557194..dee449168605 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -99,6 +99,11 @@ typedef struct xfs_inode {
> >  	spinlock_t		i_ioend_lock;
> >  	struct work_struct	i_ioend_work;
> >  	struct list_head	i_ioend_list;
> > +
> > +	/* AG prediction map: pgoff_t -> packed u32 */
> > +	struct xarray           i_ag_pmap;
> > +	unsigned long           *i_ag_dirty_bitmap;
> > +	unsigned int            i_ag_dirty_bits;
> Not sure but, I mostly see the typedefed versions of data types being used like uint32 etc. Darrick,
> hch, are the above fine?

Yes, please don't mix types.  Pick one type and stick with it.

(and yes I wish we could struct bitmap_t(unsigned long))

--D

> --NR
> >  } xfs_inode_t;
> >  
> >  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
> 
> 

