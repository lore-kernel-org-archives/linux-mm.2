Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E1DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C206B010D; Tue, 30 Jun 2026 11:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16F66B010E; Tue, 30 Jun 2026 11:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06716B010F; Tue, 30 Jun 2026 11:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 985CA6B010D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:36:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F5F84055E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:36:47 +0000 (UTC)
X-FDA: 84936981654.29.2D2AFB3
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3E918C000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:36:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=b3m0Yrpd;
	spf=pass (imf10.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.221.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782833805;
	b=BAw68sHAIYMwb6XM8a/mOxw5fM1la+pBnb+FJ5xw5LmAWtgZ1tJvan26daaCAnRkz0y0ra
	7w6ty2t7Gz6vJTjcWiAnKB2u1wLhn65AtucthqkEwB9KEowcuNgZRHZagXWHlBorEPMSPv
	DDeRnOHVviFjjhxdLUDEXggns5EbzsY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782833805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOotVAkov7vZS3oHX7LedVS6qWxqMk2u2b36hVEW5oU=;
	b=S4z+hsLYTlCXhHLPYYZaC7kzq4F9G9qo7jz3Ssd9DMf1x0So4SmQg6RfqN1yPVP0z7tgL1
	7MLSzi5arTmNcZBX94sr6+nEzjNouULU86+/iKdPfhOeisgNzSQPBtsvHa1aQJn7nw7Utn
	L0u+dOwBho9YmuL5opSjbIWt6ZcwnNI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=b3m0Yrpd;
	spf=pass (imf10.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.221.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-59ccf81e74bso1419284e0c.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1782833804; x=1783438604; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bOotVAkov7vZS3oHX7LedVS6qWxqMk2u2b36hVEW5oU=;
        b=b3m0YrpdpymUC+DvIz3qqs6cuQtwxx4j+cP9igq5O9MuJJv7d1F4LZHRZ1KG8u3ClC
         ZSol7u7TfZ4tUA+MD3RwiI5wXlnlfNvc1bcBx1fmgpb3SFSm4ldWWkbFj0/QT9FqS5Dq
         k0dadbgQVtRnb+WTnH+a1n3QQMT87KnT/z3IeyXLj5vlEnSy1+J2FjinpCEhBYuYjruL
         B9iE8B1IZBYG1qmvRmSB7lqG0yoI/U+RDYul5dB8LyPgoyH+vZP5KflgG6Mi4KhTmWZ2
         1CrdwqhrobQmGkN2qI67gKxEy6CzLbg7MK2W4yZHICNH1CCXHM28PAfIwBKpYKLs+f71
         ih/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782833804; x=1783438604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOotVAkov7vZS3oHX7LedVS6qWxqMk2u2b36hVEW5oU=;
        b=pTbIqOH7AMWS1QHkwprJO+r5NUEWOnvM7iPPqh5s3ga87IbRvcg4fzEk2L7Qj+6NkT
         4acdGUJo5vqIzoCCxwIKtIb9EVpzZJ9H7dgTALJ1J3uygB6ycnPvz0qJdBuX6t3Hfhzl
         KUhH4IKXZOOIJE40gs1yJeTaWXm1D5BPj4R97Wl5NogHvnCWrXvdaAEDc2V+BT0zxmNC
         FJeveH4RzqdReVSOcA1FVjEMsfQTA/hXcYQhIrd1DYtQAtvmTzCahweVAV+MjEaqYV0p
         /bXzJ1lIlBpI2cpIfpseImgqTrG1qGjjbgMrBaTgNkzTi/0b2ImjJhu9ZhtuwQV3RsMZ
         k1bw==
X-Forwarded-Encrypted: i=1; AHgh+RpZaiHxi3RFOBBvYYAuD8gpWi4Ev24Vuyx+7ewQ4B9cW4lWkk7jUkJwJb9NHdWTBJ0sVowpRbO+KQ==@kvack.org
X-Gm-Message-State: AOJu0Yy/aUw6JOvHab2Y6FbqaYNxe+zShFa25foaB9CCGEBgvXE16GEV
	oMxI3IcLbMrcme5aDrrVamZviEdVV/zirkZzdLxR74YXcr+U/l/e8FVxAqU8zF7lvJo=
X-Gm-Gg: AfdE7cnbU3+aEnwHyyCyFESMWMZa+bCpREiTqeHI4Ur8kF/U7diH9I1qMYtFb7wb/so
	dckBMnxMYhqOWAqIBRuoPCKxFLsrPUr3aof/+dzc3HqWcM9DhCthraAwNnUcgBaEIJNOrYyDesG
	+wkEnn9E56klPcDcZl6+nlzmI/sL/weKWJkHp2WruPtznmCrJ1IhHAwKSoJjhb3kGLtK9wDNDlP
	0FwAfg56rHB7fNKPYtZGQdMtobjSPETRNQ7Xnwcg2I6Ab5AjA5MnLSzz4cZhLoZWitSF8BW6ABB
	lwL/u/Vrs2G0bZovBMfmz+HeJuABiRH6+mNssj5aVT4nhmjY8RuVtFLQWstyTXqi7gdkgq/4Kkd
	Bbj8Q1pw3dybaFKOgxiX0bCAfzH2ktRkjNqR124v44RbafNfI8qicaA04iSJUkkyu9sD8hBGNB2
	Toqet93uNVw6+g2jyDQR8KhI+iUm3LVhEPXz+ggrCRZTD9hgYvnxvlosaGYDIddmz1vfU=
X-Received: by 2002:a05:6122:6595:b0:5a0:afff:78a6 with SMTP id 71dfb90a1353d-5bdbee055cbmr1681151e0c.14.1782833799373;
        Tue, 30 Jun 2026 08:36:39 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a69c283fsm27620016d6.26.2026.06.30.08.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:36:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1weaVq-000000024yv-0mtk;
	Tue, 30 Jun 2026 12:36:38 -0300
Date: Tue, 30 Jun 2026 12:36:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Message-ID: <20260630153638.GG7525@ziepe.ca>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
 <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
 <20260630123150.GB7525@ziepe.ca>
 <akPaAp-0Zul8uVga@kernel.org>
 <akPaPaCJdYINBEEV@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPaPaCJdYINBEEV@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3E918C000C
X-Rspam-User: 
X-Stat-Signature: kea615xdnpz6rixi989j7ahpqw4siqc6
X-HE-Tag: 1782833805-175084
X-HE-Meta: U2FsdGVkX1+qa9Uxn0VaZzbArjmQYisYUCqq/McT6/fUrohA77MDaPTSgJKRrsrv+7o+1cjULvFXMaVfD6DJFM7VeYGULUewh48Ayue9oIR7ZLpChmE6K/73yfrwSIpfC3c30sQlYPj0fSogRTQX0PQ4Md1v/IzVOzJ9jKqM/ezbzcF88aGtviIHFQTeEFQ+KxOWXjon3efkPFhy/8ObpbnvP6ceWBbUOdFrSeUEmz9YGOoxfrXxf2aBhIu4q2mZ83nZcvRMsiCa3IjHhizHNyg84/8jRDyEkYFcGsTVQaL/rFml5DpnL29+iBRTyBK4Q8tl5mKbx/H7VaXoM/zGhn8C8/1PuEB768gLVnXIfTyapsgxoxHSALGNlHpBFcPQ6Lc7/FqWv6JGoqUwqB+Zxteg7md3YEnOWQ+F692rUL5eG5iddzHg4gHtKw6TKEC/qkQzwi6ftvpbcS3EnarFNsYA2Bl8UJd1htbBM077BdAIQPmVH78f3RA6t0IE7HUPFSKW9YBWN2smaFUcKJhWg73v/2yo7saQLpaf/YJ5KoDHF1+wdkPxSEgPPYAUqrHGW48pVEb9/54SDZehb+TvKUONV73NJ9PsvAtHnh2P23ODAn42u1Ph8gBkCBCJfTO4QxunhRoevoK0/4Ygy1qZiLyxE1gdZa84EqMMwnNDuTr8d1RAc9YeO8zOc8SLlbBKH0X259xJjr3iLGHI8p8JxHaejOy7sFe1NztaCvdxvI8mzquWUgcQFDsgnJ7vBWVyR1DXSUuGhXUgOGmJ9xHEB/ht+oeE/T6y7seo0z+GPba0R4d+4bdiqbb9a068TlzeKz5SjuEZ33pmd7+RA2AWC/F299+Y6ND7OinosnWjz1dq2dC3cx8KwP1FdHQTDWtxup3pX/BoMlRo6kJsaItQ3EbFxDsEIsmvxID7KF6GLsCC4kO2+G45u2/1yOeDv+g9ZzviFy6fZi0yBoI9SfZ
 GbbVRLIi
 aKEbNWWipK1vD7si43YucCX6gc3yJX9dvQITZ3YHG95dfadcmqEqLnYepEddU9/Ef+wN8QivQMG3d+OZn2c2LwGHoVhqHsctfuaBSXWbw+xPE3EgXuclLzb66rWdTv1ntqJRwmNlu+5BThR9kkEX0MJTi5kMX5pGj1iEwhcwwPubtIXy3qvLK5IKxqtiHn/f2YP1cNpYEdfX7ICRF0+i2PM1EIHnNYgxMikpyaX2jtl+P/lUFloGAfDg+yoa6HGFuG/eKhPNy1l6CftaLZbIVonTVGNscNgYW0kFkUgY2jiMioS9dhmGFuJK9a8FBPPUbZYBs0myB6mZ8pdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 06:01:17PM +0300, Mike Rapoport wrote:
> (actually adding Vlastimil :) )
> 
> On Tue, Jun 30, 2026 at 06:00:24PM +0300, Mike Rapoport wrote:
> > (adding Vlastimil)
> > 
> > On Tue, Jun 30, 2026 at 09:31:50AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Jun 30, 2026 at 01:52:29PM +0300, Mike Rapoport (Microsoft) wrote:
> > > > ib_umem_get() allocates an array of pointers to struct page for
> > > > pin_user_pages_fast() calls during memory registration.
> > > 
> > > A whole bunch of these use cases in rdma are really "give me some
> > > temporary memory, I want it fast and as large as possible. In a
> > > syscall context I will free it before returning back to userspace"
> > 
> > Not sure I follow where "as large as possible" comes from. Here it's
> > explicitly a page.

It is a page because that is "fast"

There will be a calculation what the upper limit of memory is that
this algorithm can use.

> > And does "fast" mean that vmalloc() is not an option?

Yes. The trade off is you do fewer iterations of some loop if you have
a bigger temporary buffer. But if it takes longer to allocate than the loop
iterations then it doesn't help.

> > > So, how would you feel about a new API?
> > > 
> > >  void *kmalloc_temporary(size_t min_size, size_t max_size, size_t *actual_size, gfp);
> > > 
> > > I know of a few other cases like this in the kernel at least.
> > > 
> > > The implementation could try to find an available high order page and
> > > immediately return it, otherwise do a small reclaim allocation?
> > 
> > How do you suggest to decide how much of reclaim should happen?
> > With the usual semantics of gfp?

Yeah, when all options are exhausted you do some allocation with the
usual GFP options.

Jason

