Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9616AC982DB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0471F6B0088; Fri, 16 Jan 2026 12:20:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F362F6B0089; Fri, 16 Jan 2026 12:20:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDB76B008A; Fri, 16 Jan 2026 12:20:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE8A46B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:20:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74B7F1ADBEE
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:20:56 +0000 (UTC)
X-FDA: 84338492112.14.B0C20E9
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7E1AB1C0010
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:20:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=gWEQpPZA;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.46 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768584054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ke97Rr0JZ7eY7fCVBJ0MTKU0b1sPJJtx1nolStxn4zc=;
	b=sN9RzkRsJyIrPfhFVPSKDKV6QDi6kyV0uqM4UpBSdMTSHb5sQczKil2Q++CD0WhsmjjjX+
	i1tuiAP6oiu6pBxRz7UvEJNpaYTTojVUedmd/+8ObmGZ6KwezyYG5qCPkbs/0Percv50lu
	HJzIizWgq59+4FqjGvc402YQJR2BTKk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=gWEQpPZA;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.46 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768584054; a=rsa-sha256;
	cv=none;
	b=FaHcer2ezV3e+peNtet3zFzZUg8qR/C8zAliuD1ujfQXOjcL3hfIvaX0OZCOUCiXyW8wJK
	Xw2cCRu6KGcRqQlav9YYABuvfOJq6Autr4hRlOei3FR74hTki8VLzHGqa9p/+C0K6RaTZ9
	ewvS6d/noDbK9tXVjXln/h33lktjYW0=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88a2f2e5445so27748756d6.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768584053; x=1769188853; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ke97Rr0JZ7eY7fCVBJ0MTKU0b1sPJJtx1nolStxn4zc=;
        b=gWEQpPZAhBQJcGbUyA2u1T6VQHFr821YTiYeTwB0t0j9pMjyYSJ5jPzgaYahvssBam
         qUUtWj2W3oaV43o5RzAL+5lW4L60DTv3XSWQew5n0UraD7e6+vVMZSgo1pvpxLyGqoLN
         AxSSYz2OEhVBxF4LjwGMCx3xnnQFKZpZAYdHXXMnhVVIKjAmJB/dzx8unsCfZnK/sFR6
         DNCLZ/c2/oC11od6Wz8kBK+/bQMoaadCSIPhgwbVvgfWfpyDtm+9yAY+7ZvP0+2QYgMk
         KAdNhOCSFFS99VUP3t0HCoq4CnmI6z0RKRhvPj9P3sC4xwD7/0vKXtZSnsfmoQEhS4md
         Pw3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768584053; x=1769188853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ke97Rr0JZ7eY7fCVBJ0MTKU0b1sPJJtx1nolStxn4zc=;
        b=Is9RvhJvN59x8oZFw/XCaaFqHj1E7WmxdS6CZF1mP/x9zBVEp765qoU5R0PIxTVErD
         r/atactr7EpN60WnaqqC3+CxdE4Rwj2dt2wFl9HkKnLvC8m5VR86XocH2d5gHlGHhTvj
         /vfEOmU+lb3aAISC8z3h1tZg7JCSu+4KuW5NU9HO6haHSbFgpX0Ny/IRJjOhiNeSptht
         8PRtrH/JXIkEAFrjGIcqwjK44j0wSTGpnymX4kfmffzSKz8cjXX4Jml6Xog/5Abi9RoN
         z3FDQXEllaJ6Jjuqgt7K44+TTGGrcTYYaqEJvUAdcm0n985a016+jP5rYakpmLlEBuEy
         5URA==
X-Forwarded-Encrypted: i=1; AJvYcCUWaScOwaiuSSOVgN+pDGyy1X1FH266Zh48s6JjmuW+blBb6wJmPrp5S4ta5vhQmtydLcCdAg102A==@kvack.org
X-Gm-Message-State: AOJu0Yxp6C54328FU2igKfU5umgUgvvK7KseW+PHvYZrWmFtYtAniF0c
	O9zv92YYCNr12h9Ji739D//XFgCVkeeCHAZYYDYIy43dFM/NMUWuTAILezM1rYTEX5o=
X-Gm-Gg: AY/fxX4NRxaE/OQGaqFPWNysQmsIrxDNPlWjHEdNzHLW8V8UJK/wQpJ7U62QtZxamk/
	dZDf5dnBQTQ2WuJT+FBCvYtgcfjLvWPDtunOr1YPImwvUKFpDHVcIVDCUMYqHYcdHmX0aHjJ9e+
	B09J8bI9J3WHwlAUa/S0kxX058awVKn0vkCME4Vnhqr+5d1MpB8uAg8ip31IOr5K72XS6cDZ2hr
	7cL9t0PtoPK63+fVsC7BOwjun322cRXUlUpXS0NCS86QvGr+CKkNyHG2VdGXgAW/+D8hOl7vetk
	c6s+LPjnZoE6fExCR2IWCnk+7CVsQO5LNdca+IpfQXdVR2h2644sjQoRUI1AGnTRLJIZdwFk1wi
	lYK5t09X1CMlznVHVcNMzsm/iYAhYubwCaSm0LShW10Eo33I8Ihcwn8CNtgBiDEDE4xarBU5YuK
	1Xxbp2mDdl5tZDAOSEwEckCK6GkGPsnGNQgd+IIeP8i5S49rJhEzpkkrvHHh+q49ccnTA=
X-Received: by 2002:a05:6214:d08:b0:88a:529a:a543 with SMTP id 6a1803df08f44-8942e543175mr46699756d6.69.1768584053510;
        Fri, 16 Jan 2026 09:20:53 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6ad606sm26895826d6.33.2026.01.16.09.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 09:20:52 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vgnVE-00000004kb4-0KMs;
	Fri, 16 Jan 2026 13:20:52 -0400
Date: Fri, 16 Jan 2026 13:20:52 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	adhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Balbir Singh <balbirs@nvidia.com>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	nouveau@lists.freedesktop.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-ID: <20260116172052.GC961572@ziepe.ca>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
 <20260116111325.1736137-2-francois.dugast@intel.com>
 <ed6ca250-67ee-4f7a-bc3b-66169494549a@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed6ca250-67ee-4f7a-bc3b-66169494549a@suse.cz>
X-Stat-Signature: 9gzc1qmtkzapficudrmr8e5bxr7hxdr6
X-Rspamd-Queue-Id: 7E1AB1C0010
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768584054-482478
X-HE-Meta: U2FsdGVkX194q0QX6PjgNhsi6tKzCCF6i+wQi6WvXyksLxqAY7fAHNX7PoeGjHT0nrEVmR00cnJHxzrj1UXPr/iDws3R9Zsm8Pzz91K4ROGH9b8ZyWXIoh0LdQ24xxbxyNWpKcvQrkQz8Cj7Az1zXLWc5lAPdZ6XulhQ+PfYisXoG1rPG2W5nNDS8c1cKHBmj8+pKH5NrH16nEQP50sJO6X1t3bogYGnx2I+WAcLZ8vhiAlQVztTDwKm2zHMZSzNSLglesoAL+wTJo6q4v3Vib2m7NeVQbfaPdAJ/46vS12TByWcGr57c7gCh9/g8O1RxmfVJB4GlVSGsj0dcfTxiPt0d78lnCgAjNkdyf8922O61qOfQNDFqqE9urthiGu8fXVHnkuJrjhBlYKZlEgvndNSOk/GKRkuSO4yfKQBUI+paZWtRTiqoqsAULTLinxc2Px/2pCME1uhqZBo20AgI9byNbex1EPn+5CZBB8WY3Gd2ddjDAui4GBi/2w0y/9sRThy4Qsv+ZpaDqeM0NZsAhl5s9+OtCuwzFaVoniTXeOBmWrRHXykRL51+s9c/QWawyt8v8bY6Q0jiKWpWFoa4XYn+DNefefa+dsI6v/I2tGl/TSleovojHeNK65CBtiGbJKHd6y/wQtORRoDqUng8gF5Zv+nV9wgUk1YfWmPOVvGw0l1hZLiwF01ISwMU/gI3o/sQLkBYuYSmf7FFvNOo/O+6ifq0lBTQni676ff/6HPtmwmplWLepSU+Scm3GsXPQ2Wk4NIc9GZvk0/6k9JVErKZCkTQ1Sfm/vtyvAwOzAfof6zyuar0vD0GodgulX8EPrY/QPJawhF8qENHLVTW/piwakeV87W2us1RHkfK4uD5s7p+dlVIxQdyxc0kr1M5aYeEyVORgj/Slh1JHJvHIkVQ+3UAl2SeebvJhi/2y0cdn7RGLW4JHQsqMz/8iWrHpIZu4yxuxKagTj7RZi
 3+fCNA+j
 dMGsrPb071qlDWwFQ0Rxo1KoXJrr1VRg19F2PeNxltSsmBm3XzqNv8gBQ3DHiAy1e2/SBcq+ZUWSb2GRBP0KFVHdmq1z6Xj5W1rC14GptCalxpktumYDxi+ujSnQR3Y7hZNry/DWbmPONDHQ/itEN3ntfrBnDLteHRfDZW9v7BgCfa0HrWNd5peQmne7utqv/DBzgP3Yucya7kI5/2A+vdOPO1jGvm7C9T+n3A74Qgef8oqq8dSOGXm9usaa64d3+oumLNz5NjlK3UfNeW3Ehbr8CgIIY0xKTbiGR1A0EgVHVowA94glGSwldLRXTgcmArJPxLzywD/ZfhOD+HoFDLrxAzxoDD5aej4HQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 05:07:09PM +0100, Vlastimil Babka wrote:
> On 1/16/26 12:10, Francois Dugast wrote:
> > From: Matthew Brost <matthew.brost@intel.com>
> > diff --git a/mm/memremap.c b/mm/memremap.c
> > index 63c6ab4fdf08..ac7be07e3361 100644
> > --- a/mm/memremap.c
> > +++ b/mm/memremap.c
> > @@ -477,10 +477,43 @@ void free_zone_device_folio(struct folio *folio)
> >  	}
> >  }
> >  
> > -void zone_device_page_init(struct page *page, unsigned int order)
> > +void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
> > +			   unsigned int order)
> >  {
> > +	struct page *new_page = page;
> > +	unsigned int i;
> > +
> >  	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
> >  
> > +	for (i = 0; i < (1UL << order); ++i, ++new_page) {
> > +		struct folio *new_folio = (struct folio *)new_page;
> > +
> > +		/*
> > +		 * new_page could have been part of previous higher order folio
> > +		 * which encodes the order, in page + 1, in the flags bits. We
> > +		 * blindly clear bits which could have set my order field here,
> > +		 * including page head.
> > +		 */
> > +		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
> > +
> > +#ifdef NR_PAGES_IN_LARGE_FOLIO
> > +		/*
> > +		 * This pointer math looks odd, but new_page could have been
> > +		 * part of a previous higher order folio, which sets _nr_pages
> > +		 * in page + 1 (new_page). Therefore, we use pointer casting to
> > +		 * correctly locate the _nr_pages bits within new_page which
> > +		 * could have modified by previous higher order folio.
> > +		 */
> > +		((struct folio *)(new_page - 1))->_nr_pages = 0;
> > +#endif
> > +
> > +		new_folio->mapping = NULL;
> > +		new_folio->pgmap = pgmap;	/* Also clear compound head */
> > +		new_folio->share = 0;   /* fsdax only, unused for device private */
> > +		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
> > +		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
> > +	}
> > +
> >  	/*
> >  	 * Drivers shouldn't be allocating pages after calling
> >  	 * memunmap_pages().
> 
> Can't say I'm a fan of this. It probably works now (so I'm not nacking) but
> seems rather fragile. It seems likely to me somebody will try to change some
> implementation detail in the page allocator and not notice it breaks this,
> for example. I hope we can eventually get to something more robust.

These pages shouldn't be in the buddy allocator at all? The driver
using the ZONE_DEVICE pages is responsible to provide its own
allocator.

Did you mean something else?

Jason
 

