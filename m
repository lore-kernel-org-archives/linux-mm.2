Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D17AC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 07:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97876B00A6; Wed,  6 Aug 2025 03:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6EFD6B00A7; Wed,  6 Aug 2025 03:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BABD06B00A8; Wed,  6 Aug 2025 03:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC6AD6B00A6
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:59:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24EF81DC0A0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:59:38 +0000 (UTC)
X-FDA: 83745583236.25.6764AB8
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf24.hostedemail.com (Postfix) with ESMTP id 21769180007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:59:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=0b2IpAP4;
	spf=pass (imf24.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754467176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Izcp9KuJI+N7osGOh6Vm4q57YAFEIRc/7Ly3D8UvEW0=;
	b=vzMzJRblj5e1LpUMxOyqI0nrHSYUMCgTS0k5hOwryXYftWWMifxwVstH2nj3CU6dY+3jOK
	4pdAfLTVmuvuQ65y41+VGNpKneb5jkxC/K10WNK1AGkwtyNbxedal+G2v/5oLejrmIyH8P
	OYlHS5UcfvUuGhc0gmOMHESKed4bYAY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=0b2IpAP4;
	spf=pass (imf24.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754467176; a=rsa-sha256;
	cv=none;
	b=I8208pINcbEwEjcyOaI7lS0Zy1vQXkKlE/h5tLfgI1iw68bfI6u7PYaemn/M7ivuFgkqGB
	cvvAel9bE+yCOut1xTwGu8DRG7mT8NRM6EbBnhcVe5Tg9D5yDYrxnTphg4xMVW8eQ6L6KN
	wIVapAoTz6yNy7QBhVy7wPZVdgoa9Tg=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4bxjPH4Y4lz9tBc;
	Wed,  6 Aug 2025 09:59:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754467171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Izcp9KuJI+N7osGOh6Vm4q57YAFEIRc/7Ly3D8UvEW0=;
	b=0b2IpAP4U2GqYHCfS3+UCXCCMobCaNQBdn2HGjCQ6RNQQ9gNcDTGQUO+CZEO3246QD63Ni
	fh6mCF9nihlKauPvY082zw9Nfx4EO6h2h/BpmtFKHsIkVLKZBLADDsL+VoinXKZhDSpX7c
	NU4zLg/9psNKroMwzfLs92f0IM/SBfNKzzfHi0l1Cw9z7R1hwpfuBtJxbZOR75G1TcreIz
	XtHEEsg404RxpgElhPyVSFsoWaJ6CRRgvKXkddHZ1XwHujLWm4ShBv/5oS3P8YELj1mb27
	MrRivpRTh+BcvvaumZ/v9iQ9sGZmesjimdBkYzHEfwFzC0wiy/CslvUT6CX2FA==
Date: Wed, 6 Aug 2025 09:59:15 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, x86@kernel.org, linux-block@vger.kernel.org, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 4/5] mm: add largest_zero_folio() routine
Message-ID: <ib67jxoli3qaw4ntmgrhhumlkrn4hicjnjzbocmwwi7t2vls73@fczc5msyhy37>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-5-kernel@pankajraghav.com>
 <b810103c-ee95-4cc9-8b59-4dc6b1847d1e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b810103c-ee95-4cc9-8b59-4dc6b1847d1e@intel.com>
X-Stat-Signature: 1pihjwba7fk3nh1n88uhpw9hufj968pw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 21769180007
X-Rspam-User: 
X-HE-Tag: 1754467175-883659
X-HE-Meta: U2FsdGVkX1/HCBszIBLQyL967Zv7awz411P0Be79E8Ar1IBuBC0MSEMXmV+kCZVBW+6cGAEaYl3Hjn2g2iOYiFUT3cIxrqc1qX7EexhOzeC1W7WD3vG3vJRvzXUyW9wzYDp6Hcrcwxu5a4k+JEBp/yAMMZtiAQg7u1c8UbUw/fwYYPMEkqTQbuXgYV4cfpkwgFxAjnNDeyCApCIhvFTYDzYz4vUDocj7RgBEIxnd0AtVb2Q26/1N+8sEtifHlnn9YLTONqUqoSCiKOjjF94+3NxP5eLNjcUpXRsHOcB7O004RiGPIJuyKvBdtU0uf2f8SrxEpCEQTjkKVdcw3tPDkDHVrGUuL2Uxn0DIiutcQ3emZ0RGr0F+g9DwQpGo6wv7mUwSbCfuQEG1CuIqt1tRjBrAt/iKdNT1NjZLvTPSNngNCuCNaO7pS5J2il1HFoLLXw1EYYbYOnHfC9kDbeOMzmBhxjBl8QGbsg91uyFbqWT12pSClrSSGylm7jmII0mbGu4RD6HxXrIp7slz0UmTKzL1GFm0lK0Pn+TJP1mQuKfbJ97sWhCx9m62Fl7hyMc41/Y5C4PUE/jSkFknu0wR8JswIUmdi5OHhPJH/ZAAQMkAl6H4uX5yIlvyGPOw7A4nipq8bk9sdBDjZSqZMNY4VxRS6wfam2ElsU5DI+hMyOGYz3siEyiwzjOB2F3Y/F7U2DEaOJHJgAWU6BsZOpOHD+dx8FAtoR2t1QTvADhCukQFdmW4x2Ra1WrJbM2lLn9vHw32fDNQQggjFcqqGCf6zb8J/2OJlH0U/MCIFrN9oQS8WBbsa/vWNoynhhlCmrs7cvFJl4/T7ifr8TwnYOCRV6pIusxWRfN2mBe/6NpyZX+8BtxTDpolkzyL8bLYFd5gpQYBoyCVe+u3ZbD8FOgjiQkKHWvyeox5rl6haCy/i2/shLLoqL3T9Q2VUeq1JuFp+PgoWCs0lv+ZYZJhG5F
 wpTuaHKA
 Ps+64gjJ/3AACHqu6/NW1bRybNHdVBH2ZEOqGGodRUcbW5yDHzi0xNBmfHwGlRY98TZEIxKcVIeR72OLDYkG2PMy3jBZf05iQC+PpjaBIdd3F+4bG802N3yPWZstq5DYXNlWuk3UWQxdUX4P2NHdg603Bj7vl/KKGZiF2eCOlr4aqGLqHIcOScOQ6wvUCBmRXwTxqYRf+DrLoMFlHOEYzHnrKssUHzqzv53s1rgGYcP251Ww5t41gWkix6v7SiFTzRxeKar2CjOfq5BnLwUVQGSZcjp/WwXK3DmLnOKQ16zPEl0PeXlqq7cLYckkCjhsmyUC8roudmYHcnaGbyWu4+blOU5fGZC/1xCXwSHYZyI1Cd8HhTCJJmq8ZXyH31xgxBemOvF9v2TKj6yyxYjeRCoLfdLaxGnu5A3aTvNXgG0cZ4or1y7zcNpYH5aLWbo63Cr/X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 09:42:14AM -0700, Dave Hansen wrote:
> On 8/4/25 05:13, Pankaj Raghav (Samsung) wrote:
> > From: Pankaj Raghav <p.raghav@samsung.com>
> > 
> > Add largest_zero_folio() routine so that huge_zero_folio can be
> > used directly when CONFIG_STATIC_HUGE_ZERO_FOLIO is enabled. This will
> > return ZERO_PAGE folio if CONFIG_STATIC_HUGE_ZERO_FOLIO is disabled or
> > if we failed to allocate a huge_zero_folio.
> 
> This changelog is telling a lot of the "what" but none of the "why".
> 
> The existing huge zero folio API is for users that have an mm. This is
> *only* for folks that want a huge zero folio but don't have an mm.
> That's _why_ this function is needed. It's in this series because there
> was no way to get a huge zero folio before the permanent one was
> introduced in this series.
> 
> Can we please get some of that into the function comment and changelog?
> It's critical.

Valid point. I will include that in the next version.

> 
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 78ebceb61d0e..c44a6736704b 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -716,4 +716,21 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
> >  	return split_folio_to_list_to_order(folio, NULL, new_order);
> >  }
> >  
> > +/*
> > + * largest_zero_folio - Get the largest zero size folio available
> > + *
> > + * This function will return huge_zero_folio if CONFIG_STATIC_HUGE_ZERO_FOLIO
> > + * is enabled. Otherwise, a ZERO_PAGE folio is returned.
> > + *
> > + * Deduce the size of the folio with folio_size instead of assuming the
> > + * folio size.
> > + */
> 
> This comment needs to get fleshed out. It at _least_ needs to say
> something along the lines of:
> 
> 	Use this when a huge zero folio is needed but there is no mm
> 	lifetime to tie it to. Basically, use this when you can't use
> 	mm_get_huge_zero_folio().
> 

Agreed.

> > +static inline struct folio *largest_zero_folio(void)
> > +{
> > +	struct folio *folio = get_static_huge_zero_folio();
> > +
> > +	if (folio)
> > +		return folio;
> 
> There needs to be a newline in here.
> 
> > +	return page_folio(ZERO_PAGE(0));
> > +}
> >  #endif /* _LINUX_HUGE_MM_H */
> 
> The code is fine, but the changelog and comments need quite a bit of work.

Sounds good to me. I will make the changes. Thanks Dave.

--
Pankaj

