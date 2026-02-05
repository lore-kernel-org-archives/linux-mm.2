Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A22FBE9126A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 06:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FF3B6B009B; Thu,  5 Feb 2026 01:44:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882896B009D; Thu,  5 Feb 2026 01:44:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756DD6B009E; Thu,  5 Feb 2026 01:44:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD5D6B009B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:44:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1ABA61C201
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:44:48 +0000 (UTC)
X-FDA: 84409465056.29.9BED339
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 58087C0008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:44:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZrvlyBnj;
	spf=pass (imf28.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770273886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNsGJHU6ZAGPYFrstJF6T+pTydSAytWmzby0uKhCanI=;
	b=0a7ClAsOL2x1taP6gWZtGnAAqANpitYWZx1CWDXemf1xx6Bs+X5022U23GLFNX7de6IS4v
	RGYPhPrg6JU+Gb8h7mmQEi6jFv+vH7xzhR4G2dyY+m/YLDlke4o1CLlpwyPolpqxcxMI8F
	HyPsLXggzPrdIK6L5EBNb5vtfE6nY4k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZrvlyBnj;
	spf=pass (imf28.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770273886; a=rsa-sha256;
	cv=none;
	b=eObgpcf8u/42gcHa1mYBo+eswoApFZwLJFqeERqX7mBXBuM2DqxfoYwnkvkGYU8Ux+XUsG
	gwg4qXPUymPB5ye1GSQbztlkSTZ8C4y7nmcpbbMf3Fvv81PoWgiPDD8JhAA02ufzkJRBzm
	jbUNIiGU7k4T58CdJUkQL3gg/PqkeoM=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35456fcb79cso386137a91.3
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 22:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770273885; x=1770878685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VNsGJHU6ZAGPYFrstJF6T+pTydSAytWmzby0uKhCanI=;
        b=ZrvlyBnjyD39v8DQqR/dHEwUTqZXsC6v9qzRQTGmcgIkpihDeXnPhhFR1mJ1/PR+9/
         7xEEJkGdKaUzvOREcCE/rAosg6LhZvEkhz7FWK1S7RrgiaQtQc9XF3sb4vdXwyHaIDs9
         xTati8dH6Fg39o+a8iue/bc4Qo0Fkk5IE6TcL0b9HwO8bdkw9og6BsmZrSydHNE6FeTc
         yYM+R0ICu6IKJAISlEML3oQ/+SDRbNTE22V4k+v2I1g696WUfS/j4hyEL2/C2Jp6iNZQ
         osuTV5Ke1f9LAVnfNW24hNTs6YnM1RV9+uBq1bLxD5u0i2Oc/tV58ATgbQciqnvWPnjd
         OhYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770273885; x=1770878685;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VNsGJHU6ZAGPYFrstJF6T+pTydSAytWmzby0uKhCanI=;
        b=rQP1n/ltCfZvw+iXx9VyvG7enaobth80vzbkPlx27pYHcgjOP9AGRVbMyjLAAAVO6R
         TgxcvNccc7LmuOTBvDKsTUcT0jA7xAOWnMWr2roR+iShbVxWmzyUHGhI34AJnGmQLAKg
         /Ww27VHyPYP5zcMOBqkOHt1OrokEdBDFi5AVVrb5VVQ7xSWHfCbiHm3Uu3ydBIrrx3sy
         n4h+9BRI24h/xZ2kfiTodUbNTXjli8cKCv8JHKJQGblQi8eN7V0dSuGFBj+/TPIusne3
         bSFqTbLYMtpnXHDlIK6lkww+QxljjCaIW4o0MFpOVCrgIxytxhNwjicYGHMcPylVeIm3
         ac+g==
X-Forwarded-Encrypted: i=1; AJvYcCUasl3gn9s1uhBd1Yb0+L9VXWU9wFyKeSEqyl0guTbCmIBjfsMLMVAIfm5cDwGjmIQowDtb565xkg==@kvack.org
X-Gm-Message-State: AOJu0Yw2WujK7QeNYd/9nc9HHqbdu6S9Kz0l1CiCn61DrPxnpsG3dVVd
	tzH6txFzrzH+VHbI83w1AZUx7pvr8hP6Eg4LA1em6gIESokvvfLvy9fA
X-Gm-Gg: AZuq6aKC/pDAYyqqZ4WJ6cf6VO5XjVlT8v5s5FRGy2zgVN/v9vfBq7emLP/mCmN+qZ/
	tjYP+H1eFD5qh8pTdHLiGKWGgQQDKh5zJldf/gfrJtl91GAMb+kPKQMfnLg1TPGCz4r4dkOlCaT
	54EW5ft1hLcnSMFx6EhPOgNqmyx218LZghgua+MACUjFamrT3VAleYk7c43l0M3prQo1sRFlttv
	T3xxawAkiNyWVIPtkVJ/Mk9YgK8n+M0z8DjWUuunbHAPma5Pc6+VsJtL/zv6DvuH6FBL2qRLGxb
	gFZYagaL8BtzWonmBjWIE3iKkJaf3xYKdQqq9qiGLwH9AkZ4t8rfd4IWTN7N4mV7K0dkYGZmcry
	jZVHTte2Pz5qDqjwhFq18R8URsAZgyxKF4eRX+v1+N6wScZdPl+JYhtxB2Af5Rb9o/3LSIleaUE
	MKwH/tCl+yeIJgdG1nW5DYIbAqqHrxV7XSjfpeDANsYnT1QTx3ieSj/uVxMJWTvZ1L
X-Received: by 2002:a17:90b:5201:b0:353:100:2f20 with SMTP id 98e67ed59e1d1-354870eb37bmr4927223a91.10.1770273885118;
        Wed, 04 Feb 2026 22:44:45 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c28204esm1389041a91.10.2026.02.04.22.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 22:44:44 -0800 (PST)
Message-ID: <90870969cb6f04346d6dba603838abf993a42f5b.camel@gmail.com>
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and
 dirty-AG bitmap
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Kundan Kumar
	 <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
 willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com, 
 amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com, 
 dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org,  gost.dev@samsung.com, anuj20.g@samsung.com,
 vishak.g@samsung.com,  joshi.k@samsung.com
Date: Thu, 05 Feb 2026 12:14:35 +0530
In-Reply-To: <20260129004404.GA7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
	 <20260116100818.7576-4-kundan.kumar@samsung.com>
	 <20260129004404.GA7712@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: gr859rncaeixkgiw9yd8f6kwb3xwewd4
X-Rspam-User: 
X-Rspamd-Queue-Id: 58087C0008
X-HE-Tag: 1770273886-662117
X-HE-Meta: U2FsdGVkX19wOmGj5uzn9x7Za+/71B6IFvWM17i6B4jhUmusLjzCDqyOHY7kYjA8l4WuJ/fKXFTmCVR3Uqt0YYabWJBxZWKDMEQcGKF+2m4gdpacXUMpi7NlAd8DwrdUZwn2ltIbUjo9P6e0YeWQ/D04J6/KnBTDvb1rpaTvRGLpVDNnEYVHywMYNrb+Nn/aLk/rUs4MKfWSLafmVwb+FcqNAzfXZgmTa+TSFUg73rRiuil3fTgt1t9JLSZ8iLJakbfsqKPFQh4N0QFiarH0n3bEPRMUTmLRj5orOrhbIKQwLFDIsj/87Dg0vStRxrKOQC6w2DM14UUeNDUqi5SfeMj1bScTVQRrAUsR//4w14bi6kELq8XaehC+HKkaiUwEyMleb53FFOHMdacLhr2iqfCmacWQSLvBpLKaynIU0GhI18WpCe/s2tnzsGRxmEQAK751iMLw3B1IrqrRSFvehnDqbSvCJB1bW5RMTN3t+snb0PaSsHHjZpfkS6B56YQUeb3FxTehOnKMs7dV9FXGxaKb7I08z28hvobwG9NkUMA8EutbTdvWDBddvc1JcjxVJqHQxpmcE+3pefVYINtN/4GaXBzCoa9o6tubMNd6eYSQYKj26Iblp3jXAikZu/HRU/WBYU16lKZ571gFPYBacqzpYFdRMFForw8ut03+mk6+2Ms68eb77isIz1o9efU0Xy+ge1Au7HKsiqW9VuOBVzQTpvevPnP5bMDLGNQjB5eA41wScIFx1KO4Xcg7gZL1EjaClosxCl6tWa+UGyqBuiCrYmB6Y5yW6yvWeHtOslGvSoRn7H8SYOHNks584CILcfZ0B7ivZ9AkcHxi+ULZSapS291o+D3GLqC3f1+5E8MqdrfjOS+BXsx0gehw+BmZMQMHMk9ztl+6ONMOp19zzi1QS0SfxcMf8BFa6Ojqa3RGHH/1rrrEslJuq6WsWu2FKjPvonWi9VU3hsNomTH
 8+qijbm5
 Sg23m/CT042U9xrOcLhq2iqY6WFm5n7US6mpUoSPJ6CRulEPXCeO4pCFg2w71kWThsCff0zF933uyXX0PAyDQmN2EGxYfS83qhE/d09VGJ+Prnq6QJxyjzlwWQQtUmFZyTBCDmsOE90y5gsPn6mRSgl5h/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-01-28 at 16:44 -0800, Darrick J. Wong wrote:
> On Fri, Jan 16, 2026 at 03:38:15PM +0530, Kundan Kumar wrote:
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
> > +{
> > +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> > +	unsigned int nlongs;
> > +
> > +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
> 
> This increases the size of struct xfs_inode by 40 bytes...
> 
> > +	ip->i_ag_dirty_bitmap = NULL;
> > +	ip->i_ag_dirty_bits = bits;
> > +
> > +	if (!bits)
> > +		return 0;
> > +
> > +	nlongs = BITS_TO_LONGS(bits);
> > +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> > +					GFP_NOFS);
> 
> ...and there could be hundreds or thousands of AGs for each filesystem.
> That's a lot of kernel memory to handle this prediction stuff, and I"m
> not even sure what ag_dirty_bitmap does yet.
> 
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
> 
> Unchecked return value???
> 
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
> > +	kfree(ip->i_ag_dirty_bitmap);
> > +	ip->i_ag_dirty_bitmap = NULL;
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
> 
> What about blocksize < pagesize filesystems?  Which packed agno do you
> associate with the pgoff_t?
Sorry but I am bit unfamiliar with the term packed agno? Can you please briefly explain does packed
agno mean?
--NR
> 
> Also, do you have an xarray entry for each pgoff_t in a large folio?
> 
> --D
> 
> > +	struct xarray           i_ag_pmap;
> > +	unsigned long           *i_ag_dirty_bitmap;
> > +	unsigned int            i_ag_dirty_bits;
> >  } xfs_inode_t;
> >  
> >  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
> > -- 
> > 2.25.1
> > 
> > 


