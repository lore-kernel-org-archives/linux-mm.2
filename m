Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2470CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 05:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B756B0098; Fri, 15 May 2026 01:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D016B0099; Fri, 15 May 2026 01:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C233B6B009B; Fri, 15 May 2026 01:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B09D36B0098
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:43:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC0428ECA7
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:43:29 +0000 (UTC)
X-FDA: 84768561738.16.BDA8172
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id A8CBC80002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:43:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kxy/4Esu";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778823808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZV9qpUxgwNTdiW6770LA+y9TmWtjhD445HqaVmW9eQ=;
	b=xwPa3H2eExmxo2QoU9Wyt8e0hhV0qb4lMT9+TggkGDvHgvUYd0+fCnaHpKA9XNG5hkwEp9
	mRLykoCGxhiuIu5+PIr5UQwV8cHTsnp/fO1FctWGtKDd/0rtxYgZ2cslpEb8cFkLNuqBcx
	Y+FBVNHhYNW8eLVxuDJov34w+G9TMrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778823808; a=rsa-sha256;
	cv=none;
	b=pjeYcQpQECoUEQyQzaJVZgZgESzbcGGsIkYPB1Ls3JhBmg0z1F/ouafxnr/p1s5VAD2UBh
	EmGw3ItAwn2IeChBsU6RvUoTmPCZ1zKaq6xy9uP4YyIboASOb46kHJX7+tQhJ1j4FKrz8C
	MJ+r4vxDKRfhEDHBwC4cazRfxbR63wE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kxy/4Esu";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
Date: Fri, 15 May 2026 13:43:18 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778823805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ZV9qpUxgwNTdiW6770LA+y9TmWtjhD445HqaVmW9eQ=;
	b=kxy/4EsuFBleWBFg4bofQSoVwmIAGS4m+89f7JWMV1+0sUstE0dgbayPfJVB0MLhClhd7T
	9Axzx0PlgcKWwQAR/6z3Xdl1hjaWiSTwCviQVH1PRlTT86f8FFmYyAe+JxyckASIy8kLV4
	3ta3NBTu8ggu6OWTiFFT2uzbYZ32MeY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com, hch@infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/3] mm/swap: add unplug callback to swap_ops to fix
 leaky abstraction
Message-ID: <agaydgMX_-db-OQL@MiWiFi-R3L-srv>
References: <20260515015737.890994-1-baoquan.he@linux.dev>
 <20260515015737.890994-4-baoquan.he@linux.dev>
 <CAGsJ_4wNtLaq1e=8YUTMtro+4oxSrue1OdpuyzyiNWt=RZC+dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wNtLaq1e=8YUTMtro+4oxSrue1OdpuyzyiNWt=RZC+dA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A8CBC80002
X-Stat-Signature: hqr36eefrxwiztnfaw5z4dfx9dknd9jg
X-Rspam-User: 
X-HE-Tag: 1778823807-59953
X-HE-Meta: U2FsdGVkX1/wovKDcZyah+8nu6+0HuBDSzWL48zH+YhClVGKxJx2Z85nKAdrmnszGuxmP0yY/Ca3sIqZqfHc3520OGqxt6wujyoq4RU7HqXlswU+5V5LLksBQY3uY9oTK5aixi8Ge3RBmt+pY64GC8tDt41RJS8hXUdgjjiWd/YmLrjQiULkm/J3S7SLtdzPDJb1jN1xF5umlNb3KrvsUAWqBv8lkHdTBoPe1V9gf//Pna6/i3uhPCl5ZripPzLbcJSeccAYK1oXHUBxrhZJQ2LQvMBcb3H2J/fSeXuOz1MKns/P7uJhhBg0DbvkTzC38hO5dKTgYXghe+ckp2IgD3oJmdszkEATYOhG42KE0/HK8P3ozzM+sjW1wAQKoAptnCsNP1rgDN1skE6199+1yx6MmQyMprPHh7APC0/bo1wNDLO0NnuSc+Y8MDKwxMb6NMnHyFC5KeGyQL8ZO7uN7tC8u2z2QX5MwrdowyCR/9Fgwn3O55q+r5IW1hyOmjuZ4kO+0XJCO2LLK2xDBeHRmSetOCLoyAjzfihpkaLFGw7FroUfxBjqM2wji48yjJtSAxhQ5jQe4UK2zMPiR7n84SMj9ovyBfRsZKeK5tiE/h7fDADv2Hzx8Bvs5qFzAaQ6EQ+F5BKtRuwfdYBxhi7S9MvfxwTP4wuiU0N252+QTKuO42j/0lxgaByfzDy5q/ZWRLR3Wa6J6QAe9bxMZ0LHxTv5X6RMyICm9K0fGtC0fSbUfs7UsOlG+55DhcHcPXphBqxGhGpXo21CS9VKSkc0gqG8+B1Fa20SnzgxRZ98nwlT9UnA4pO5rR5najpHO7g7BS4LIKOV/7hpjHmR2cNY5iIYk2mZ6HkCM+idc/pCJSfSgT+0x27WpB6E3Ra9IHfT3FLHeeD4VtiEDon8YIAvL1AXTTI7ZYBvG1ckVENDzJqhnM2O2C5+Q93KFTh9NwMft2RGD4xkH9p7bJRhu+r
 i6s7MCmP
 eN4zz3P5/MDIUEUktFgX+ru/Iv2KiL8M+8hwzPF63ugSfea7cpGtV/2NOk4ojl0kPO9KeJbUXnZ3qPgrcXM/YIxm9ZXCyWab1ps+m25Nzdc7NRjPtOcBCay54ZKmoYDk9UKg0l1V9YM4RImi0sPcmHrJOKFPPtqe4r41m3YY/XKgtijIO67Gah7eRcxzteI4K8p2GVPtgMR+O9jcuj26ulrE3Au2w8201scZppL298vXv/HfKp141SIXzKRA1BjakD9tzM1sHZA03VGHpZW5c+YR+xqm+KH7+CC2MIm458vN5rMNAwTVM4/anrYabe/80a/Lo
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

That's a good point, and no, I dont' think we need it. I will fix it in
v8. Thanks.

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

