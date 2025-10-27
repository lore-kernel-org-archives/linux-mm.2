Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA43CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 18:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A4280082; Mon, 27 Oct 2025 14:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AF38000A; Mon, 27 Oct 2025 14:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209C580082; Mon, 27 Oct 2025 14:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4248000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:15:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAB20140216
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:15:40 +0000 (UTC)
X-FDA: 84044697240.17.35A0C87
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id AD219140004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:15:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=osandov-com.20230601.gappssmtp.com header.s=20230601 header.b=Xv2AVSbz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761588938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4cQfaALGoc4/l8gySmGcJH2leMlkWogl7C+rSKi2tY=;
	b=Ts/e/gRr0Y3lXC5pA6uTMlCaa+SD+igDD4IKqdmdrnNT0091BEPwEJ94uyus7SA6ZAJJxy
	uzsrgG06DiCrps+5KekHDQJDkyMkzJ9a376zKD23Tu8BaFC2/4RsIJVZ4sBub9+hx46Jsz
	6vwbyF2zf+psQ4aCBdkHUi8XLKmU4k4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=osandov-com.20230601.gappssmtp.com header.s=20230601 header.b=Xv2AVSbz;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of osandov@osandov.com has no SPF policy when checking 209.85.214.176) smtp.mailfrom=osandov@osandov.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761588938; a=rsa-sha256;
	cv=none;
	b=HK3ozb6ums1EukIOTt0FxfDeRnIgCQjsYHsdnKRaZ47fPLRNq/izY2yXkfb5iJuPFiOMXk
	3V8JrSMLoey6tbfKxS9o3U3JBKBz+1aZAX1Q8OCKBXqiSk/khhXTu9ZciPEX8Of9PE35NA
	m5ZW3v7ki8Ki8M1uKte75/Bm4vdeHUs=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-27eca7297a7so5362275ad.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1761588937; x=1762193737; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U4cQfaALGoc4/l8gySmGcJH2leMlkWogl7C+rSKi2tY=;
        b=Xv2AVSbzZC6MbuSd81AJIOKl0qHftg/rDcN36Mno4ru04ieo0S5vC92iHxonrH6iPB
         XDhK3vI9hl8GywLOnYjUJNVnurlKG3hlHZYTKNS4i5Urv7viHi72899MHvewRgpX2hkL
         VV3zmgVGO9VobSWuYwlpOELz2nrqqzlibwqZfnt9AVEX/72Xx8uo/ziK1ewoVMJXO26g
         k4Mp3o0wnQBP8tOuQMP1jD0rRuOsNsmpz2KrInJJ/jpkOEOexa/a9B5/MiINB1hvxEPq
         zSj/zEwXOLLOikmRH0iGbG6WA229Qu+/COKa4cunO21dETMXZ7+5EhJHruQFKLQlBnFe
         IvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761588937; x=1762193737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U4cQfaALGoc4/l8gySmGcJH2leMlkWogl7C+rSKi2tY=;
        b=iX1DuJ/uoR9dQAhr5g+FbqWfkrneGxfdjyTM3oxsMb5XJ31jshEo0qx769vvz+IfJF
         iwH47vYWtTnPn8yttNgeYtrPU0C2Lju9H7McyXUHpySql0fBxHQw6ADjJLmfbqmGoT/y
         Qo0tfD0EGkfTLKNanOEJu2rX2U9G76n8MtT+04uTs4ZGqDe/tSd7HRIOioI4YrKRbjpI
         ssteRWcQLh7MS122kTOoporpKQUnPW4M/m/dk8rB+eP2ZaHZ4WhlueVLb0d3+3oh/b5/
         FyoTXfNusYIR6qvT8FXsc7Wy3V8uj015jMKJ+eDP51nMC7yfpAedsuo9kOtV4dsi09zn
         idcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWq4VPD+7UAm4bwdFdAMmqZQw02biwWYH6jaS2fTNGjILjVugQy6BZIl5bfZG4IlZZLbCOz4cInmA==@kvack.org
X-Gm-Message-State: AOJu0Yzw7sEBZtD+GvNtxIIOKRG9lUJM8CLQmfjYJ0D+vLiGHs6UiZQM
	XUMeFuthhlU5VjSsu/p+D5awJWavb7chso2+A97oPKsQt/ZfDoS2nLU89k7DdmrrUZk=
X-Gm-Gg: ASbGncsN6QpzDaXY9jjLzuuDURrK+VTd7EBoIKKVY1NbILh7qFmOsqwv0hrvXR22JFL
	rBuGMOIzlTER96q9B8dwkGJjSlLE+R8BM5DRIIkXj4i0U8M6xwFcygr/V/qea4hmdJZQ8dksuCr
	5yvbhtyCQO+4gIt3QK0z5292uaItrtIANFEsJg22cKZrnYeKc5TrffshN4B24TadNPIYdcPeK25
	FYCERh6aIRMmor/4bRh6KtTwG4Zg1FEoXYLgP1o80m8DrcfNUVSmic7Pc6B16QI39WpwJtdg8mh
	/bU1c1bz3mC6Eycb0/NvoQJ7v+KBMPQyfyPod37uT2l+N0xgeQloGkgPcWvOscOBBs5BhX3VNU5
	Udb11oYn/QAGGjzF68kwPUtw4UJP661nxo8W6wyytqXjeh2nKfbMNZ5Pl3VP++cSNico=
X-Google-Smtp-Source: AGHT+IErLx4Y+CSbvwTvDMkVz8jKZH2EyxwoVZhXlu4W9Ro2SZvylBJFK1+cynLtv1hH9V9kl98hhw==
X-Received: by 2002:a17:903:2f0d:b0:290:ccf2:9371 with SMTP id d9443c01a7336-294caca9e03mr5485335ad.0.1761588937149;
        Mon, 27 Oct 2025 11:15:37 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::4:c4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d4287bsm91043815ad.80.2025.10.27.11.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 11:15:36 -0700 (PDT)
Date: Mon, 27 Oct 2025 11:15:35 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Hildenbrand <david@redhat.com>
Cc: Israel Batista <linux@israelbatista.dev.br>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-debuggers@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
Message-ID: <aP-2x314BKks2_N9@telecaster>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: AD219140004
X-Rspamd-Server: rspam03
X-Stat-Signature: h8bkk5boexsod8owb69qs8ra7nxs5na6
X-HE-Tag: 1761588938-229538
X-HE-Meta: U2FsdGVkX19vl8fDAsqFy6QKPiVm9v8Fm+/GgOgWX1113gB0L944ZYRi4vo+Mp1sviB2xyD1ErjXsnKKGuEbqin+duEfUzl8E9HAVQyXsgPl8ONzc0S2RncZJjAk4Io36amU1KaXIfDRhkwf5sK0KHyjO9wgKun54Cr8bR1GFXZ1aBAUStW4ypHFNG+B+9G/cKZ8DPtYoixsSVRnnrSQl1f6QDmgqLdaDix5b595MZyarHMOrWliP+i07i+veF6Ffo78+GvpHQzKd0DvJAJG5Ov9gPXpUOwRFCAeaVZ985tZ0HmcEO40aWrFVIIzvZZYfXTfUJJq2bZGNmefNYYpjTg6LUevqLUEfbpN95n8YjqmFVNXYGEPcBvdWqNEa8yUje3pq0UNJ5eQeWZx3cZIstth4hpGegboTcCg6BQQd7JKgbyd2RaNzir0FJkGmLzQpSd2XY3BZJ7DhMgfvA1iM/qbkB1Vtfr8nvKSke4bHSDwkO5zw8VTArGZxHjmjbE3oJS+Zo5/vsKJF3/WPyLGIrZMXhvLnLGfCBu9BKHtgWQc2ZBvuC4fZSIjECLso4G37E9kqWFf2jslWGSa6Xd8Pp4aLj0vu0io7/GSpT8Me/aD1+fgIR9UnTZ0uB0X9CEByEE1TduQHGDPfQvrsCf0Werlk1em6kB0F8lBR3tN6IpUxDryj92/61lZnNjpN/awdxUuFk+ZJ+EVMAYcZq5azjCkBZeGfN+W+AtO8FTZsmbw3kjrZEheUaj1IUu19u5ojx0vmy8uZ24vTqQXOVj2HoG/tdXnvxHo2QxN9hzidoHxgeXnpzR/3BbmZFLKWVJkbB83rpM1MWp1o3qP+DRuZRY7hxWBT83VcWCT2FQdpzDALV8O5xT/Q5ShuOq83WW2nnGxP+9L0CwEUVKIqPh0ZuqtS8xXtN2oe3+xuvCo7sq6e1KztzSrZhjtN9TuItnL/3L7CzwI8Ku2iDWg25P
 Ki3Fx7HE
 J/iYRNlOfq5W4F+qGDPJyv9Amk/+74kKoQvgiKxJAZZ2bd7GRF0gCjwrHkNby4xLYz87chRBMnyxeqAuiEKHBj6Xo+vidwQkmesff5LcS+PiWH9EWrN4c6uk2ttyKcqPBQdSkHEeAuYw41k2OhJRMEOp4prCSv5bABI1HbIxf3JFcZSBAVrb5bn8FXc7JgaSsL/xxwNYVc59p0f8LCro30cQL3yZe8ZpyDXeKAU8qRlx6FCk1SEJ3owa4himfyjS4pPcZyF7l2RVDEd2xI9sS3G5Z+HUgXGP6unaF+NECecaNzd9EndLkaP5xnTZVNUcB3WoDTsU4yjLNhUHFZCKoD01wfoHdFEvGrog50E5Or4ZFktTwBqcjFgZ8NzzPLGsz3/pXRpz5E5pE+TFXKEFVdCZMOnuCdLuhjRALkkb4gaf25ttxA9D/DhxGyqD019r7/ogF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 10:29:15AM +0100, David Hildenbrand wrote:
> On 26.10.25 17:22, Israel Batista wrote:
> > The MEM_* constants indicating the state of the memory block are
> > currently defined as macros, meaning their definitions will be omitted
> > from the debuginfo on most kernel builds. This makes it harder for
> > debuggers to correctly map the block state at runtime, which can be
> > quite useful when analysing errors related to memory hot plugging and
> > unplugging with tools such as drgn and eBPF.
> > 
> > Converting the constants to an enum will ensure the correct information
> > is emitted by the compiler and available for the debugger, without needing
> > to hard-code them into the debugger and track their changes.
> > 
> > Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
> > ---
> >   include/linux/memory.h | 16 +++++++++-------
> >   1 file changed, 9 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/memory.h b/include/linux/memory.h
> > index ba1515160894..8feba3bfcd18 100644
> > --- a/include/linux/memory.h
> > +++ b/include/linux/memory.h
> > @@ -89,13 +89,15 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
> >   unsigned long memory_block_size_bytes(void);
> >   int set_memory_block_size_order(unsigned int order);
> > -/* These states are exposed to userspace as text strings in sysfs */
> > -#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
> > -#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
> > -#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
> > -#define	MEM_GOING_ONLINE	(1<<3)
> > -#define	MEM_CANCEL_ONLINE	(1<<4)
> > -#define	MEM_CANCEL_OFFLINE	(1<<5)
> > +enum mem_states {
> > +	/* These states are exposed to userspace as text strings in sysfs */
> > +	MEM_ONLINE		 = (1<<0), /* exposed to userspace */
> > +	MEM_GOING_OFFLINE	 = (1<<1), /* exposed to userspace */
> > +	MEM_OFFLINE		 = (1<<2), /* exposed to userspace */
> > +	MEM_GOING_ONLINE	 = (1<<3),
> > +	MEM_CANCEL_ONLINE	 = (1<<4),
> > +	MEM_CANCEL_OFFLINE	 = (1<<5),
> > +};
> >   struct memory_notify {
> >   	unsigned long start_pfn;
> 
> CCing Lorenzo, we recently had a discussion about such conversions.

Yeah, I've been asking people to send out these conversions as we
encounter them in drgn, but ONLY when the absence of a value in the
kernel debugging symbols causes actual problems for drgn. I want it to
be clear that we're not spamming these just to cause churn. This is an
unfortunate corner case of debug info that leaves us with no other
option.

> The states are mutually exclusive (so no flags), so I wonder if we can just
> drop the (1<< X) setting completely.

FWIW, putting my C standard committee hat on, there is nothing wrong
with combining flags in an enum. C11 is silent on the matter, but C23
made this explicit. Quoting 6.7.3.3, paragraph 16: "After possible
lvalue conversion a value of the enumerated type behaves the same as the
value with the underlying type, in particular with all aspects of
promotion, conversion, and arithmetic." Lorenzo may have been thinking
of the stricter rules in C++.

Of course, semantically, it makes more sense to use distinct values in
cases like this where the values are not actually flags.

> IIRC, these values are not exposed to
> user space, only the corresponding names are, see state_show().
> 
> 
> Won't the compiler now complain that e.g., kcore_callback() does snot handle
> all cases? (no default statement)

Only if the controlling expression of the switch statement actually has
the enum type. All existing code uses unsigned long, so the compiler
doesn't care.

> -- 
> Cheers
> 
> David / dhildenb
> 
> 

