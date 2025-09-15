Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 952BCCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 22:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3BD8E000A; Mon, 15 Sep 2025 18:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3FD8E0001; Mon, 15 Sep 2025 18:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA318E000A; Mon, 15 Sep 2025 18:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C6D328E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:46:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 538095ACAE
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:46:00 +0000 (UTC)
X-FDA: 83892968880.02.63F4A38
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 402E240004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:45:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A7ZS8GaM;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757976358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uR14VGW0/X0AylQCvnqkHSqGmKvFKN2TXdGehzTWgbM=;
	b=nkCBDFj5ZeQfWlDyAnZZsu7/IhYJwzvevHUSKJO8/Fgcl2CH8PIHXy2AnWNVxYfhBpwq2V
	0OgXY47kxbHor4gAol2usJlTR1m+7l/aYb0yBspyaeQwt72Bf05xzuTa4y2YIw7+8xirCG
	pcuLc9oEO0s+hNMfROAphbF3PfHppuc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A7ZS8GaM;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757976358; a=rsa-sha256;
	cv=none;
	b=XaZQ1a32ajcgPfe2QVQZoiTFESahcSE6sU2QRZ7GqiHK5DzijM6iGp0AatMBYw6Ev4/o3z
	m73DwaQ6p2Ha8OeCQlzgB4JY1SGyPiQscddeZ2SnXA7gYbGDuDEzj78Sz+C1XUtjIqwjxB
	IcD7Dj0Dmrid2HVPJ14Dh0YIZnj5lJ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757976357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uR14VGW0/X0AylQCvnqkHSqGmKvFKN2TXdGehzTWgbM=;
	b=A7ZS8GaMNdqgLwjs39mTzyP9FGafUpAies/75tywDvgsWJA2a2qC3CNnkkhgZjsIfh+/S+
	zgJEoieOrwkn3YwtJ16uoOtk5WuFbEzHWFjv5ddDeLuRpiwDSY8Yyv6SWnHy6Jjr45lbtd
	zJt1Ho+Lf3HJX9n6rcXja+jQE8ODEbA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-IoTvD8UMNiyCqJKe_odmbQ-1; Mon, 15 Sep 2025 18:45:56 -0400
X-MC-Unique: IoTvD8UMNiyCqJKe_odmbQ-1
X-Mimecast-MFC-AGG-ID: IoTvD8UMNiyCqJKe_odmbQ_1757976355
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b07ac4b9461so436531866b.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757976355; x=1758581155;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uR14VGW0/X0AylQCvnqkHSqGmKvFKN2TXdGehzTWgbM=;
        b=DeLKExvf4e2NlsnQSLCtqKBA4dg7679fjPvHONSYZXwHMh33BCaXb2xeh9G+8InKig
         P4Q6FBc7gOVPia2q09bQ4fFZxaQvR0OS176QYBdyaMMHlafwbhQT/96N9zephoDt6P0H
         LdRIlKtlf/2xv+sVF+2po5NRhPN9xgsJ5wEinMXDS30eUBkP5rlndpdpIfDMMzV8dXkh
         RWMI1bNtAEEWR7sWJpeljUvaMyv5O0+aR/SZduaZTX0zyNzzNgIfxotKF0dFEa6OKxSR
         vYHEzyYXych7nmNLmHHyHaQjvAEipDtPL6hbJB2TgHwwLgmK6nDYI0GJt8GTHSS8wel3
         Jq3A==
X-Forwarded-Encrypted: i=1; AJvYcCWgo+DuKRgZAcebGX7ViafA9Rn9oVSM+333GGVlOZhF5ugpUwrIEofXuf+qu8qjX4jc9/ufsFCZrQ==@kvack.org
X-Gm-Message-State: AOJu0Yyma9KUwYb4aF6ob/aH0L7VE9alc/Uj5RdWkie1Y9AZmeP57qWY
	9DB0StHDRQ4PLz5DWwmwAfgI5yT4/taXArGvRhBC4wKX2T9aqV6b/6M7TwZpT4j6UO+I3pNq3+Y
	FCyN5pWgcVbNrY2+F4qZInVRPGVebbDWqSOlN1zWwT4cWIYCfvpPN
X-Gm-Gg: ASbGnctdKfC3eADLc52Uf7rURErM3wBr78LqwJNl7xbUtBtgmiFbgA4TggDAsIK/R+K
	y63yMiTVfbgBO9Lo9U4Oo8fL5qweyLT0fivdDMc6RifTgTedkesLDOYDBCPKy4quuKqS8J4H9P6
	LaiEj2yXEW2g2xWflF8tx0zWoEscIEiJKTxN+krLS1tHOl5zU0iFDV8dccXbVi5Tf0IyPuyh2L4
	JMtw5zOUm3JHXzQ5X94RFQNfbPTDtsJNKuarbZsTKUy8DXZlsjY/ryJ4aWM0Wok9wfX3dGOtzoc
	JQoaqGhX+iOsZMvWQux23s4xlNDT
X-Received: by 2002:a17:907:3f07:b0:b04:7ad5:b567 with SMTP id a640c23a62f3a-b07c35be704mr1472539566b.16.1757976355137;
        Mon, 15 Sep 2025 15:45:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmaBx18ld1j9lPfAcqGZ9Y3KUZHbyO0pMr88z4kWYAY7x6NvXEEp1rRueqlASrcg16xLKuCQ==
X-Received: by 2002:a17:907:3f07:b0:b04:7ad5:b567 with SMTP id a640c23a62f3a-b07c35be704mr1472538266b.16.1757976354746;
        Mon, 15 Sep 2025 15:45:54 -0700 (PDT)
Received: from redhat.com ([31.187.78.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0cf2112639sm440073566b.104.2025.09.15.15.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 15:45:54 -0700 (PDT)
Date: Mon, 15 Sep 2025 18:45:51 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 7/7] virtio_balloon: Stop calling page_address() in
 free_pages()
Message-ID: <20250915184514-mutt-send-email-mst@kernel.org>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
 <20250826205617.1032945-8-vishal.moola@gmail.com>
 <5ee2b684-94d9-40be-b01c-b0538ced33bc@redhat.com>
 <aK9Ogjn71JoOM3w3@fedora>
MIME-Version: 1.0
In-Reply-To: <aK9Ogjn71JoOM3w3@fedora>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OIRmmLo0vNC4qUFtbhi-nkS39tyRfuGN8gZaOGRTuwo_1757976355
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 402E240004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: s5b3xtm8zkux6a5k8i81hrszajaqphkm
X-HE-Tag: 1757976358-936442
X-HE-Meta: U2FsdGVkX1+lxejGjqLhk6FYM9fVZ3oOEBZ0RkiqOtjMHTop/9QJMT5y1gW51s7SijQbCCTKvdnBaO+r1F6fhpYmUtdyPSMy3XxTB73GJvqSK85Qrz7WXfpzb5Qk/rAallGYe4ktL4Q1W19HlBhiFQgjlnakJS51h5xi+ZjgVLph3iQNEJGyUD2bZtQ4OT+u6hY2CyQDMq1J3Z7HtO3nEQUuijWJz9uw9W9ZuOJj151WGgKOhPtGvv3u4FmtkrA0V09HD/K1VW7T34TVEq7a7haHHRRigzp6RUqBieuu4MzwW6x+ri/VNp1zWd20VAwOZ0V6Ss/o8KNdNkVN4WEs33K0PArg+haffvIObb/4nf+ufxlt/Y760qgKEw8i62wGL62AAK5tnFQ2wBcCkkT1AfmZZQEsGNYj9KKVYx43jWDtcNRYKDx2ojKi68zrCncHfjjSne+vIHKNIsZf4+zIOO+UvTc33t3o/3xDasz9jwubTyBOjZhrkf58hVThPKvC/hCrRHEnPN0VDFAVeeuGSy+K6AqOQ0PHtauJ5+PD9OKwSovYJWPPkFsBjygmw7owXYu8yUWyOO/eWRbz9qb99Paz56UrgUPNg3ZFTIzMLoWbKKMwUL1JqPQOnDeKtOc7H+b1H05nsmDmaP+Par+3R9K1HDfJNnZblWWoGmh6PDP2mfxmtXhjDQmKeCwMMXu6LpEPtNtr+IhBi8fKaovA/p22ToIsv2+dt5Ay2+kOlnoFUPhJ+rZsRXz/ZK7ehlEY/MlgaL8KxR7rTrbNONGV0RqiCnJj1SJ5+8KfTe0S3+CdtSLKCgdIA+b+YliV8ndRE1k0TPI2Vrq6zrUBFYVQC3vV22ar+8qcS0Z9RXYPmIM6gVsInGBtXolAk7KhJ5feqtx3POynoBaOEewc5gdHQ/4H8Dc5D3cRFluAe1JNKJpdViDOj/qeQ/3datOnOK7bmB+GGqntQdpWN3dmH8g
 Yma71lyf
 KFy2L3aBnk2qAYg/s45VF9jl4as0I9Gbs8Mvwtz1vu+yVSwzWo6xrA9dwlQ28qoOxxKp3RMTeCJtZWFZlHQSyGddYF2EXsSDiAkGhfaS42oOejM0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:29:22AM -0700, Vishal Moola (Oracle) wrote:
> On Wed, Aug 27, 2025 at 02:01:01PM +0200, David Hildenbrand wrote:
> > On 26.08.25 22:56, Vishal Moola (Oracle) wrote:
> > > free_pages() should be used when we only have a virtual address. We
> > > should call __free_pages() directly on our page instead.
> > > 
> > > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > > ---
> > >   drivers/virtio/virtio_balloon.c | 3 +--
> > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > index eae65136cdfb..d4e6865ce355 100644
> > > --- a/drivers/virtio/virtio_balloon.c
> > > +++ b/drivers/virtio/virtio_balloon.c
> > > @@ -488,8 +488,7 @@ static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
> > >   		page = balloon_page_pop(&vb->free_page_list);
> > >   		if (!page)
> > >   			break;
> > > -		free_pages((unsigned long)page_address(page),
> > > -			   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> > > +		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> > >   	}
> > >   	vb->num_free_page_blocks -= num_returned;
> > >   	spin_unlock_irq(&vb->free_page_list_lock);
> > 
> > I think you missed another nastiness of similar kind in
> > get_free_page_and_send() where we do
> > 
> > 	p = page_address(page);
> > 
> > Just to call
> > 
> > 	free_pages((unsigned long)p, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> 
> Thanks for catching that. Andrew can you fold the attached patch into
> this one please? It looks like the page_address() call is needed for other
> things, but since we're changing the file we might as well clean these
> up as well.
> 
> I imagine theres more of these lingering in the kernel, but theres so
> many callers and I only looked for the ones that were calling
> page_address() inline :(.

Confused what is folded where.
If you want me to apply these things please just fold whatever
you want folded and post.
Thanks!


> >From a7d439154c7990418da976e5864b91fce9d49d58 Mon Sep 17 00:00:00 2001
> From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
> Date: Wed, 27 Aug 2025 11:10:22 -0700
> Subject: [PATCH] virtio_ballon: Call __free_pages() in
>  get_free_page_and_send()
> 
> free_pages() should be used when we only have a virtual address. We
> should call __free_pages() directly on our page instead.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  drivers/virtio/virtio_balloon.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index d4e6865ce355..7f3fd72678eb 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -718,8 +718,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
>  	if (vq->num_free > 1) {
>  		err = virtqueue_add_inbuf(vq, &sg, 1, p, GFP_KERNEL);
>  		if (unlikely(err)) {
> -			free_pages((unsigned long)p,
> -				   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> +			__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
>  			return err;
>  		}
>  		virtqueue_kick(vq);
> @@ -732,7 +731,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
>  		 * The vq has no available entry to add this page block, so
>  		 * just free it.
>  		 */
> -		free_pages((unsigned long)p, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> +		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
>  	}
>  
>  	return 0;
> -- 
> 2.51.0
> 


