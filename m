Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E834CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 05:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 022626B009B; Fri, 15 May 2026 01:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B816B009F; Fri, 15 May 2026 01:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78BB6B00A1; Fri, 15 May 2026 01:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9DBA6B009B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:51:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A5CC140883
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:51:58 +0000 (UTC)
X-FDA: 84768583116.02.42A6B2E
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 64912A0007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:51:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h7UaCRrV;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778824316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UIOk2al9Vt/sBz7YJF+EdQDyWvBFeXp9LuduC5T9qX4=;
	b=Mt9S+SScG2dcF2dAptIkvL+tyK6ZATFQJzYYpCmSXRlQFO98DTOL/fhMu4pRWEwn1kPUDo
	UWy98x9X91xNPc4iMzR+QuTpd/Q+K4BdXYKDMOqdwd3g2shOuNfK2BFy4Ehtvx6VtwmgIi
	jV9dUER5k0qkKX8bDiUaOqV1CCUPWAQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h7UaCRrV;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778824316; a=rsa-sha256;
	cv=none;
	b=HlurzjNkjI2jpAf1PKj/UmqLdqeQhkCKsJmlejJHVM1qaPkW+IIT3RurGpytgy4YjYdwCR
	3lNo36aCnys+MeVeS++i4uFccm3HWquQGbAr+Lme/b1vdudyMjbA1yOZdivCTH4olF+9Bs
	OPFiI8sSROQMfktnE5jzv1jIleofpYE=
Date: Fri, 15 May 2026 13:51:49 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778824314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UIOk2al9Vt/sBz7YJF+EdQDyWvBFeXp9LuduC5T9qX4=;
	b=h7UaCRrVzqm5T4YnE+NWwhgpv3YQM+ORdMqOcFKf2tbIlbSOZ35B+sa4KfC/nG4Xv0t3KL
	kim4NK36cJGGFpsLWyQsvsPpBESL6J3OrWckyKDWH6Bx5YNyKBDrTz68VEQo/uqZs6qKsc
	6ZLBGf6CHNHMNuuOzd9Ew/5hoWl2F+8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com, hch@infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/3] mm/swap: add unplug callback to swap_ops to fix
 leaky abstraction
Message-ID: <aga0dTuxW8IrPmLQ@MiWiFi-R3L-srv>
References: <20260515015737.890994-1-baoquan.he@linux.dev>
 <20260515015737.890994-4-baoquan.he@linux.dev>
 <CAGsJ_4wNtLaq1e=8YUTMtro+4oxSrue1OdpuyzyiNWt=RZC+dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wNtLaq1e=8YUTMtro+4oxSrue1OdpuyzyiNWt=RZC+dA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1fpqbsch9htbyt4pub63nyw5zw68f7eb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 64912A0007
X-Rspam-User: 
X-HE-Tag: 1778824316-798295
X-HE-Meta: U2FsdGVkX1/YhV1PEvcAaTXKInmUHtf3gp4Q+u6CCJkRuyDG2ZzLdlI7BkQ4PrsFgSvxEb1soa3gak2DSVkNOwVUv8IBRqAk2Isw9FBYZOfJlEk8a0A+vABuB6l5fRldR266NsZ9D0k1sJ+GcZJw5rLYokOm4r81R3AqbjOUFyjk6x2sn3vGGyDZjk/2jyjLvtt4MeHm2CE1E4+omZ82u+q1w44GhPhGAFRy/KiYlrs/DS6jszfT2c0NihdbEBlvfjuPspu71xwN+hU7u+TAoO1qumEfQj7PM2wyzZiTBrGUJ/4TYa5RNS5R0ejcFc/kJ5JCYoGWNfbjnKWDpSrUE5D4K/rS+T23KeQiLnN6Qan/QUGiJb6feETGTyvbWVNsfE9dv7ZrMTVcJ7kLtmONn+UPHvE0SLuoYjxTG1Ulo+/Pv7YF+7wnKNTZcRjOxBhzMrMpdCbf+34QjfIP9l1Czgr8PZVLriAni8MTGEZbxhs6c32mtI2yLW/4RXLFg9KCfE4E+pSjkB7Y43kOIE6wevxVzj86A2fZTvD31QXI0/Lh3mLZoS0uSL48TSlrs44aLK9fDpb1fPK2LQPAUZqNNAcoVyGx3zHvayTYrXnk8JA412pFC7TX0tDpW8OsduKzE0ijP6B/Veaco2bOO1RKOaH4sSw2ylu4W2ZJ5MZK60myrNyShV8dAkQL/CakBEJ4fiLUoQBU3DhAc6RCxmssF+OB07Vig9xWxF65MGSKmYNIHfOhsRMmQehwrrK1qmaufKnpOkvPcxZglyFDMJWsX/D5p2ahvDxPQpN6frb4q5tgw8GXsKJ9T+Cn903yBBmce2lzB32ViFN/iPS+Lje1nTBMfrqzhWA+dYe628uC9znsJ8u4xSk4VYNuZhvfCMXKDiunWMh5Mes/k/PH5dKYDEzKOm+0MTm1isbsIMCgl3Sf5Oy7daGa5z6nt9i5xusHgE5J4/N0ZL8IpZw/qvP
 jKhH74XC
 tYzvU8YRSqkqFRbfllCetyYviEXDfYqH3ypRGcKato6bzVtRjg987j35qSu75ope2kAZ9TCQXXLCc8HsF6qCXsB1TDYyEiSXO9gCuY+qrl1bZ1xDoKXkf5Hb/KA3NEOBvH3c6Nr00pk4eqen8sbJxLrRp6lFEZhP7kE3+6SMyxeG4Jdis6NeNShv+l7KmB2/16NKTIAjPyOdGKf74N7UXs7sRu/dqOI5TMqQfWEFnTVZUbk2apapePiLS7LuYEy3snzPTsGkdrvobsKn2448geC94ybdAW9hjkxFgchH/R7N0oR4IqRtPdf8FhkmPmNWLUZCc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/15/26 at 12:39pm, Barry Song wrote:
> On Fri, May 15, 2026 at 9:58 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > When swap_ops was introduced, the FS-swap batch submission remained
> > as a standalone swap_write_unplug() that directly called
> > mapping->a_ops->swap_rw(). This meant callers still had implicit
> > knowledge of filesystem internals rather than going through the
> > swap_ops abstraction.
> >
> > Fix this by adding an unplug callback to struct swap_ops.
> > Each ops table provides its own implementation:
> >  - bdev_fs_swap_ops uses the existing FS batch-submission logic
> >  - bdev_sync/bdev_async_swap_ops leave it NULL since block-layer
> >    plugging handles their I/O
> >
> > The swap_iocb now carries a pointer to its ops table so that
> > swap_write_unplug() can dispatch through the callback without
> > the caller needing to know the swap device type.
> >
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> > ---
> >  mm/page_io.c | 11 ++++++++++-
> >  mm/swap.h    |  1 +
> >  2 files changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/page_io.c b/mm/page_io.c
> > index 38b94c560c37..2c36d261ad98 100644
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -329,6 +329,7 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
> >
> >  struct swap_iocb {
> >         struct kiocb            iocb;
> > +       const struct swap_ops   *ops;
> >         struct bio_vec          bvec[SWAP_CLUSTER_MAX];
> >         int                     pages;
> >         int                     len;
> > @@ -401,6 +402,7 @@ static void swap_fs_write_folio(struct swap_info_struct *sis,
> >                 init_sync_kiocb(&sio->iocb, swap_file);
> >                 sio->iocb.ki_complete = sio_write_complete;
> >                 sio->iocb.ki_pos = pos;
> > +               sio->ops = sis->ops;
> >                 sio->pages = 0;
> >                 sio->len = 0;
> >         }
> > @@ -454,7 +456,7 @@ static void swap_bdev_async_write_folio(struct swap_info_struct *sis,
> >         submit_bio(bio);
> >  }
> >
> > -void swap_write_unplug(struct swap_iocb *sio)
> > +static void swap_fs_write_folio_unplug(struct swap_iocb *sio)
> >  {
> >         struct iov_iter from;
> >         struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
> > @@ -466,6 +468,12 @@ void swap_write_unplug(struct swap_iocb *sio)
> >                 sio_write_complete(&sio->iocb, ret);
> >  }
> >
> > +void swap_write_unplug(struct swap_iocb *sio)
> > +{
> > +       if (sio->ops && sio->ops->unplug)
> > +               sio->ops->unplug(sio);
> > +}
> > +
> 
> Hi Baoquan,
> 
> we have already "sis->ops" check in init_swap_ops, do we need !sis->ops
> again?

Well, I just double checked it, the "sis->ops" check in init_swap_ops is a
embeded pointer in struct swap_info_struct. While here it's checking
pointer embeded inside struct swap_iocb, it's different thing, isn't it?

> 
> +int init_swap_ops(struct swap_info_struct *sis)
> +{
> + ...
> +
> + if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
> + return -EINVAL;
> +
> + return 0;
> +}

