Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D535C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 11:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BE266B0095; Tue,  5 Aug 2025 07:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195FD6B0096; Tue,  5 Aug 2025 07:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2E06B0098; Tue,  5 Aug 2025 07:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00E5E6B0095
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 07:25:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A05B0B77AB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:25:14 +0000 (UTC)
X-FDA: 83742472548.02.826BEBD
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf10.hostedemail.com (Postfix) with ESMTP id A06C9C0002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:25:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=PtgDFKnz;
	spf=pass (imf10.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754393113; a=rsa-sha256;
	cv=none;
	b=P14+ZQVQR2TnKUrOOYcl9jeqN9Hruepsq6dhqfBj5BVUd3Y0UYDLN2dORtqERHd3Z4Cj5U
	CWaRYBtcPnJoJZ5/ym7uvhHKLJZIQXEiW6URMk/fcy/QnbEPDmZKIJcyw1uczkTpzY3FM1
	/YPwxEhjzyJABvHDByFrqZU6nqUwKPw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=PtgDFKnz;
	spf=pass (imf10.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754393113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pUqghyW3Gb16EpTzfk2IyTRYy66SrKEo+Ar4DAbeucY=;
	b=45Ut2F0cLb1myAMmV6isAj9zhlfG/2s2HHD2VJns7uRfeo9SdumsB3CPRycapSItC65MmS
	/AmMiBb0LI7U1ZjRFSa/N9ugTAHEefvfgZ+jO+21cZz4lza4aVDKHQ+/heYjb3f93+CWmM
	MzAL9vYXeuXGRcZgbJIpRIWK7p6+kZU=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4bxB0z6nbYz9t6m;
	Tue,  5 Aug 2025 13:25:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754393108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pUqghyW3Gb16EpTzfk2IyTRYy66SrKEo+Ar4DAbeucY=;
	b=PtgDFKnz1FTIzGDYS+qF37UY4zwnjW+1Of3QbKKYeiHOuVqz60tfycdjsMLn31ptCKJCXI
	MCcdzweG19TGdEGmh02rzNll96Wn/rPTEFMJ4e9j2fH+d9sEXXRDmVXl8jhFaROD+xgNlm
	elM0yU3OPkf2Fmnh/F20D9s/Kx4mccUq7pdQlDyq6IZQgPqigw/BVxgfa/amyYplMiuazy
	X/u4zPJPGjs2xtg9i+zZhh+7yK/gIOAshYZz5svDFiZWOy87yPvhLOgiBD7h6dN+BJNQUz
	CYl37Hp4D5yMNssgTN9aAEeGePrhQq87dgwCedPTncwHfoeTLNkafkzPqlJrfQ==
Date: Tue, 5 Aug 2025 13:24:53 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, x86@kernel.org, linux-block@vger.kernel.org, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 4/5]  mm: add largest_zero_folio() routine
Message-ID: <tg6papaakluarhu4cz6tmu2ukgjlyzonvxjdgylbjefl6fmjy3@l6jre7k7sois>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-5-kernel@pankajraghav.com>
 <bcb9940a-18ae-48e6-b000-53fca461fff8@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcb9940a-18ae-48e6-b000-53fca461fff8@lucifer.local>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A06C9C0002
X-Stat-Signature: o8kujmze99dfm6w6abcgkz4josj43q8c
X-HE-Tag: 1754393112-130345
X-HE-Meta: U2FsdGVkX18WX7qAyxPyn8sbq0PTTof7yxOYG05trKDLav8wZdfuL+4133HsLZcShpb/GT7MZYeHFzwIJKd1FiFTfRX3cscCHq92zpzIDvqVoeaK1HCzM3m5JO4IU2XecOQKZmd1oc13ayqby6VRl1sNV9BIMWnl4YCCrLJWUbFJJPom0tqA7QBSCsJ2scEcz2/TayvpUNo3JEoRlePIFp48N+Ag74n2Z2cQbiwFZaRBYSFDhJDlW7gU3JdmAbA0gcc9ooENfabIblYOHxQ7ApNDZthc6x0QtmkPFFNpY/ZPKygSRdHpw4EmR0xelhj4GmOkhfR5kJkKVNLt1VCZPUZ04/5MlOX7vBlkRuiUEe2ByeJJemdoyqElgZNOn115npieRg9mU39ctyNRJNgyHDJdNjYB9kWxrCRgblWvoHu2cZKRyVWUIKVc2h59aQqQ77IWJTsl5xY3DqPFeeeMwcXCamcQlpxL7Yf1DRxBLl04e+L2VXN8R1+IzvURFbGCcJWwJlktL1u/ZTxtl7AgcQ/8EfrsNv+hIeNCL7wGeAJNyD+/FpuWL+Ls8ziCWFIyRWnsTeKCJuEHhfFfCFwFA5aJIk6Xt0+LidVtlPvvjlK2Os05mHPATW3WvNEJpme5qXllnGK+MgCHT7IR6ADEqOyk5GJ/HxJ9e4mdUNBDl4rV+jaI2rKhledeylyUe0rt6VJDBKCCYuAmUZki80t7pizHHUh3i+rJ5eMqxlA7h194mjDKFmPAdWAXyBwv9hCrGCKICVh40HqBgvqyYooa6b2dNhoUsNOm1kYuSIltSJzABpETu4FZXFPCjpe2U7sF52vD8gRLXDIcG5MicAYDW/YxqFvywOdaBccvoYfHvqXJtkDnDSVsz8ovyzlhyZ0fPjwFmI6ZUaAll+BXChf0A0jTazm2F+WkvWuguiWy9WyMBvQ5ShNVZa2wRKO5rahwG+ST8Yo0uUM8bDOd6SV
 KQ8W1+aW
 Loal1giVPIzaVDD7i1Iy0V9z9a1MSzp8NviHK+X/66dNMFjnXc0EVMoCQ6MaiQbC0MT9a6wNtRrMW5VF4siBl2CIQLerLQt8AvbW/nqh81xz5g9pvQORnftC4JYMyYpFUe7uBdAJkWKGgM8rumgNLKUCpP188AreBMaAs2Iu46iwr7RWFbOLaqolqI4DcARNTIb3fwWcLYd2EMNvcHn1tdvYVXvRtTMarn3Pv8oxWVOYmxWrmTxTBEPZVahC2L4PQ9CyloFEQA5XH1NIeKmavw7iXaYJFyH5MI1a5SGzqTQlYMrpSgGWiIUt4m9/AGz2e5REubpQ6sqNxESERxOVcBFVUG9LpJifW7dI4YSn9BKfYdh3IjVRLwlHLD9D/snZFp4Euk5DGgw1uI8Jo/ZRi0ITli10E54OBSLYYSWIWVMXJtY+THW49xUQfVNF8XQgWbOhwqX7DYctXbUjfK1sr912pUDHtzQiOkarkHErQDeG9kAZfN7DVBFXUT/kidevMaHGjm59ZjktfqdM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 05:50:46PM +0100, Lorenzo Stoakes wrote:
> On Mon, Aug 04, 2025 at 02:13:55PM +0200, Pankaj Raghav (Samsung) wrote:
> > From: Pankaj Raghav <p.raghav@samsung.com>
> >
> > Add largest_zero_folio() routine so that huge_zero_folio can be
> > used directly when CONFIG_STATIC_HUGE_ZERO_FOLIO is enabled. This will
> > return ZERO_PAGE folio if CONFIG_STATIC_HUGE_ZERO_FOLIO is disabled or
> > if we failed to allocate a huge_zero_folio.
> >
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> 
> This looks good to me minus nit + comment below, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
Thanks.
> > ---
> >  include/linux/huge_mm.h | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 78ebceb61d0e..c44a6736704b 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -716,4 +716,21 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
> >  	return split_folio_to_list_to_order(folio, NULL, new_order);
> >  }
> >
> > +/*
> 
> Maybe let's make this a kernel doc comment?
Yes, I will change it in the next version :)
> 
> > + * largest_zero_folio - Get the largest zero size folio available
> > + *
> > + * This function will return huge_zero_folio if CONFIG_STATIC_HUGE_ZERO_FOLIO
> > + * is enabled. Otherwise, a ZERO_PAGE folio is returned.
> > + *
> > + * Deduce the size of the folio with folio_size instead of assuming the
> > + * folio size.
> > + */
> > +static inline struct folio *largest_zero_folio(void)
> > +{
> > +	struct folio *folio = get_static_huge_zero_folio();
> > +
> > +	if (folio)
> > +		return folio;
> > +	return page_folio(ZERO_PAGE(0));
> 
> Feels like we should have this in a wrapper function somewhere. Then again it
> seems people generally always open-code 'ZERO_PAGE(0)' anyway so maybe this is
> sort of the 'way things are done'? :P
> 
> > +}
> >  #endif /* _LINUX_HUGE_MM_H */
> > --
> > 2.49.0
> >

