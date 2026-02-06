Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06697EB28C7
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 05:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BA506B0089; Fri,  6 Feb 2026 00:36:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467C36B0092; Fri,  6 Feb 2026 00:36:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3666D6B0093; Fri,  6 Feb 2026 00:36:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 288A56B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 00:36:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C93E13BAA1
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:36:16 +0000 (UTC)
X-FDA: 84412921152.16.C8A2C3B
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81671A0008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:36:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gdEGwA4w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770356174; a=rsa-sha256;
	cv=none;
	b=MEZO0iygZUeMcqHVtnrAlqps/RqSR8CgGFhJuw/fwtU+Poa6BoANO8EwWxl/iMg4n8iYDk
	7NxLAMNIm420F+vuQaXty1o9l9mYH6ER3YjXIHRXp3vO1tZAvTQmT7OmNDVoch+mNd7OBY
	fco00UNq6UhQJtzXrYUoITTSpjZCXTo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gdEGwA4w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770356174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRGlRAio2Tk60tj3s00QBPQfJSe7aETEyN4NWVC2M0I=;
	b=ofzd6b7FOoNZnDKKIXIld7noH3a79SVaCFy8gt/EhUf7ZRjQOcxMQHMsoCPdSEHEdBsFPY
	HRSJwyu7teqF4xJYnuPZcNxTMcc/ckobVEtCYubjcJ3OlKO72JgNErv+Bgk60Zd6t8aAHr
	yMvvZPMEVBeBD+5KVu76KivLCYBDHBs=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a7d98c1879so10908065ad.3
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 21:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770356173; x=1770960973; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fRGlRAio2Tk60tj3s00QBPQfJSe7aETEyN4NWVC2M0I=;
        b=gdEGwA4wtlQXtOIkLGyFrNseDHigT3IiyCFYzagLD+p5KyMDoXyaXA9Tx/RjTenAJs
         zj5wnmQ8Vb1nYgRiVo6Yh3KdkBN4vseNy7tTJBnht4i/P6CFE2NVQPcrglX6iN5xSkjm
         4Hprg7RXmZoOY8BTolTE+dvL6+ly70fVz0ypvGZmsdhgtMFqepzMUPXPV4JwfpNKZy99
         2Salx/n3UGI2esv67ZNJCMP2bFeeBXykg7zE3sIGizKbSvsqILajwCR76saNNKtfyKi9
         04hJvFD5EVWShTUQ67WLHuEW4kdQ4gUBhleghOZ/LjLdJ1YplIyyIcOBk1PkOUkcuqqB
         K7dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770356173; x=1770960973;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRGlRAio2Tk60tj3s00QBPQfJSe7aETEyN4NWVC2M0I=;
        b=pkrh2CVDpGbSdFjKKXrTdDwkT7xr2I8SyjNqQ0gOsCZWFk2ISO+Z6y78ncGwkhurYa
         Ms7xKfqA2cDUYStoGKqQhHPdVlZ+IuC05WOJ/N3SjfNVGWiQlpTTkDN8FWQN4vaLsC0U
         YZ2DEyMZWYYYDK7CXVhhJseJsp8FkaxxLjyAujeIJY6Gg2T14ZKxclTQv+xwI4nrGdTH
         jyrJRIR64FROXx5cb2gDs3FKFITpNCGnvLESUAkzLjjPzieP/Q5+DG0Lm/CWlic269V5
         r8oABZ49iUdwpFkUm33i7bLh6UDA660iZQiz8LDa5VZeIC0RAG9hbsY/Pih1nDZpui2N
         /wCg==
X-Forwarded-Encrypted: i=1; AJvYcCWf5llPKkOBlfpEgVXi7yurLhXgn8rT5e0vazLS8Tvm789hIcwJL7aHbfij7RZK3XQ0dD7sc7IsaA==@kvack.org
X-Gm-Message-State: AOJu0YzBeSShGkkQsUVym+DFzWqvQ6KibxKVMbsBTEXWVtZIx1Oej+N2
	TRdeg8eAHmYHg4k2kUlpO2obmv9TdNFQTHuM89Gs5xKWm3s6tS1vytpt
X-Gm-Gg: AZuq6aI3QVEDEgkpIDR+Nv1ROw5PX/gL/fg5gA3oHn4cTAWkiIiwbvgjGSweC+jf31J
	XEh9UrlwtEUxktxLbHjQ0nwQIqMAFMk/u4qP9LnuFY+HBiK7BaCp1AJJLPpSXQu8BLfb7XeOiL3
	j7tvV7Afg0L3a7i5/AMMBPiTdRFiCfBGuVfChd8vhtzFszkMBvNZy4x+d7PfsBK2HPhp19vgGoo
	xWokh7ctx+Jja6+rpfxAYapQous3exPcukgReqETytpbDHAl1aIudVV1bwqaapgEB0YP84sPA3r
	uIepX9wftOSEGqzCBRAMryGBQJ0gGRAczEmU5rywtGyB6xq22LZGzINsNNbUE2aiL5WRJ5YYR4O
	+rOKocy9vzXYywmOLPo/Bpj/htoKML7t0xjJgmoz1ilYdJ+H5yVMmtfDlyAvDhXzE5owWtlVWY4
	x+p8QQApxAvHnG74e+yxDDtL5/3BEL0MmP2blc36iCKIOFl8VDYYYOjsaB4EbyyL20
X-Received: by 2002:a17:902:da8f:b0:2a7:80bf:3131 with SMTP id d9443c01a7336-2a95196c7a7mr18061535ad.58.1770356173033;
        Thu, 05 Feb 2026 21:36:13 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a951a64ebesm11846575ad.2.2026.02.05.21.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 21:36:12 -0800 (PST)
Message-ID: <a017b49e0fb5b9f1a4f6929d7fb23897c98e2595.camel@gmail.com>
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and
 dirty-AG bitmap
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, dave@stgolabs.net, cem@kernel.org,
 wangyufei@vivo.com,  linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org,  gost.dev@samsung.com, anuj20.g@samsung.com,
 vishak.g@samsung.com,  joshi.k@samsung.com
Date: Fri, 06 Feb 2026 11:06:03 +0530
In-Reply-To: <20260205163650.GQ7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
	 <20260116100818.7576-4-kundan.kumar@samsung.com>
	 <87a16d4d9c1e568a37fa07a97dda5777e14e9a8b.camel@gmail.com>
	 <20260205163650.GQ7712@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 81671A0008
X-Stat-Signature: ny471o64nmdsgegdxzmeq8iiz4qp6kys
X-HE-Tag: 1770356174-285797
X-HE-Meta: U2FsdGVkX19sFRYytVKFFvrl+H98MAw8nhUq+lqKms6LyShDccZ+yEWWDe22d1MIfe73pAKCJI6h82/ACExcOH5LkE/Zx2+9xMPpEc2DGUstxv5mv0IiayjoGw4OpaqKNiuv6uM97/1xRaQEOoaPsIDOorqhFgd3OuE6IyIZo7L1nedDlK+1aXlim4ZVEpy/KvQEx3ZJXlvP/Ac7/WLvA1Pl6OPhKFyHE8RpsmoW4nZrJrkm3dP+nJdOvGH52l7+L452ymf3vrE7IZ7ONpK86q4nkTK7GS5JuiqrBizncivwA4T3RwskaXYgweU6kh0ZQFjeRUAvaySbenKEFC1EePCfbronW41VdC1UEqd9O4Af0RRGsjw++f1AEmpFzzXG5sbbp6ExCGcltyAMRWQg776qxPeuqAHYfMkad7hin79jfg2dBr4JV4twm8tskTQZe1BkHgmU+sXNQP8c8ZyLIm2nxP0OFlbDzKL1yxr6cXFJ1PCF9Ad2NO8GkiVK6QIHadwmE+ojKPhB5dzPOzTupEWpi3p9FQrMgvM9mfT2gdsLo/Wssiz9xzddEbwV/4ILaVnPk1A6zqZVerWO8TkkMGpmLa1wjt6NW4wZrp1SfMAYXhiSgRvPKLrDntFdPSZ+0Tva8UjcskSfdzyhQoJadRIAp0NHWd4ybVwbGbWMU4Lq6/vllKvC/UvNm/mtYN0JXEnGA1aI/90/9BO28qWq0D3RhaWjT5+T1bqBKcSfEucitDSxzK1xCpAm5OWzYuEZ/QXfMWsZsJu9Z3Zh3muFomCxC5xpV0mdemTW3QoRam0P4vneiQm3L8ICuSN4PiyOA/db4SqvcRUseT/gbvjOLFRpPAZN0Au2X5MWzJs1LTFkHLLChgS+rrrBFgsFWq8UTg0tBS7qT4oshZ+BMbySVoTq1akc81byvctr/xQuD92MzIAgouCGYCLnXTBRFhIHkMqHHFQY9sZQvpmy2Vo
 16mqDicY
 cqyGcNfii1kcYMqcB7Sa29cNeI8Em63iTxa3WI9B3MQmw9AptkCOy/MSOS/Z5Iv+bZHm5o/yq8+uF05RoXqUpGipQHJQaUsTNhxCzyi40Se1lqXpTCxDCb+hRZCZUoHYRikthQ0UOBFVYzx/lFKmwG965xCLbml6t7fQa0y8obzY61/8HLyzrErifKHVxgbWXR+sx6pl7WnB9EOsyybHjZPPZ9QXBIyjNFgNk3c9nfaLsI6o/Ykd3x8WyB7p/7usuoFGvhUS5++xAwp5LmCTrpYqNSv8THS0kaCNsIFxDHTSSMzkjSkxYwUBCTKBO2eep/ml4zAWyJbC7ThzS42VJbnFWDdlZ+Fno0DwCxONzWkoyTiqUHuEP8hmaSJXFXPl4xPjiNykbaVIwgqo/x3pRv2BTu9+u5e0uyEsD8se1KFNC3TkQxpzTM1HCuWJjiUaDWrnQ6qvunXkm8DoFHH4CL35jgqdw5WHMd7yoEMsXw1A3wQGnq92JRaNc9OoSFFRo0NLIj8B1noF1Qq7GH2F6yNv5P9J0bVxohAROnGPLDwretXE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-02-05 at 08:36 -0800, Darrick J. Wong wrote:
> On Thu, Feb 05, 2026 at 12:06:19PM +0530, Nirjhar Roy (IBM) wrote:
> > On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
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
> > Similar comment as before:
> > static int
> > xfs_inode_init...()
> > > +{
> > > +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> > > +	unsigned int nlongs;
> > > +
> > > +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
> > Nit: The name of the functions suggests that it is initializing the tracking bitmap which it does -
> > however, the above line does slightly different thing? Maybe move the xarray init outside the bitmap
> > init function? 
> 
> Or just call it something else?  xfs_inode_init_perag_wb?
> 
> > > +	ip->i_ag_dirty_bitmap = NULL;
> > > +	ip->i_ag_dirty_bits = bits;
> > > +
> > > +	if (!bits)
> > Umm, !bits means agcount is 0. Shouldn't we ASSERT that bits >= 2? Or am I missing something?
> 
> Technically you can have 1 AG, but you definitely can't mount a zero AG
> filesystem.
Okay, but:
/home/ubuntu$ mkfs.xfs -f  -d agcount=1 /dev/loop0
Filesystem must have at least 2 superblocks for redundancy!
Usage: mkfs.xfs
Or maybe this restriction is just at the userspace tool level?
> 
> > > +		return 0;
> > > +
> > > +	nlongs = BITS_TO_LONGS(bits);
> > > +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> > > +					GFP_NOFS);
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
> > xfs_inode_init_ag_bitmap() returns int - error handling for -ENOMEM?
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
> > Nit:Maybe have a small wrapper for freeing it the prediction map? No hard preferences though.
> > > +	kfree(ip->i_ag_dirty_bitmap);
> > > +	ip->i_ag_dirty_bitmap = NULL;
> > Nit: Usually while freeing the pointers I prefer:
> > t = ip->i_ag_dirty_bitmap;
> > ip->i_ag_dirty_bitmap = NULL;
> > kfree(t);
> > In this way, the pointer(i_ag_dirty_bitmap in this case) that I am freeing never points to an
> > already freed address.
> > 
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
> > > +	struct xarray           i_ag_pmap;
> > > +	unsigned long           *i_ag_dirty_bitmap;
> > > +	unsigned int            i_ag_dirty_bits;
> > Not sure but, I mostly see the typedefed versions of data types being used like uint32 etc. Darrick,
> > hch, are the above fine?
> 
> Yes, please don't mix types.  Pick one type and stick with it.
> 
> (and yes I wish we could struct bitmap_t(unsigned long))
> 
> --D
> 
> > --NR
> > >  } xfs_inode_t;
> > >  
> > >  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)


