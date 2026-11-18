Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9222B606A334
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hf/HT3xD
Received: by kanga.kvack.org (Postfix)
	id B39516B05B3; Wed, 18 Nov 2026 14:04:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3246B05B4; Wed, 18 Nov 2026 14:04:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98AF46B05B5; Wed, 18 Nov 2026 14:04:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73F6B6B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:04:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DEDB1C3EBA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:04:06 +0000 (UTC)
X-FDA: 85449164892.16.AFD4161
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6FC8D40006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:04:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hf/HT3xD";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795028644;
	b=iaOwUBJS8Z5RlvnbEc/FG3iFzEjJHy8StqfOgYYB9JLYfRLX3Tb3a9+HEBTfTuqMzWtoLc
	Mc+Yj1jhMqhHqiUATfVvXjoTPMNKhss7t/mopOn2IyONbBkloJTWeleJ7gHMyLbfNUsThB
	6Y3qRJltMqTGKalKh8hUrV/YXnZ7DCs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hf/HT3xD";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795028644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8TBn9ubKDLYTz56NEzeNdxWEl3UJisiQtWy9Az8Fes=;
	b=V16FaxDNEaahGaXsxHfNHvQXoiQSCRbgakQWNDtlEscTOrFUSvBl+JCwy5OZFyUGj+n0jR
	XkbEEsziIWlg1knmSt8BerPav3i5dewNC2TUIqiUQK+DqAs/LPxqm8dYgz5pRkr+wpQwlc
	f0nY455eFDRaQglmFOhl9ZvilomuZ+4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D769A401BF;
	Wed, 18 Nov 2026 19:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153DC1F000C5;
	Wed, 18 Nov 2026 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795028642;
	bh=Q8TBn9ubKDLYTz56NEzeNdxWEl3UJisiQtWy9Az8Fes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hf/HT3xDB2Pi3lfXWtso17LwDxUnrHlSV61cn70iJMfDo0CMpHaClOs/z09FJNAzT
	 3JOTEDkxPohQigfU5UkFK6cGTmPJT5xXWQk0ujZI7KiJVC8YbNcVbSrkGGJPxwe+xr
	 Mh1+shtCkM83jgtfy2fVf3x6DZ+T12QstaIgvKdSfK7whOr4UrPrYNLpTUxwVlzytW
	 Qc67JPOt0UqfuFdhngtW4MmODE7597ZsjHCBxBcnh42oERDV6ucAJ2UMPLOnn3696Q
	 dw/VTwIgI6blwV2Ejya7jYgO3KkAIwvqbjHEWfppyz5ojLv+W547233hDCoS5yDUxK
	 p5dGd3uWal6jQ==
Date: Wed, 18 Nov 2026 21:03:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/7] mm/page_ext: allocate page extensions early for
 SPARSEMEM
Message-ID: <av32ls56XJmaAO8C@kernel.org>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-6-songmuchun@bytedance.com>
 <av20jiGZH5uYV6LT@kernel.org>
 <7f651049-f0dd-4053-a666-ea1c5d49669e@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f651049-f0dd-4053-a666-ea1c5d49669e@linux.dev>
X-Stat-Signature: rddkt9i58964azyw7i5j4cu6am8zphse
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6FC8D40006
X-HE-Tag: 1795028644-727693
X-HE-Meta: U2FsdGVkX1+ZZosdKxDtD/x3OvMMBMoU98xJ2mkhPGhaW14V4vAWcxNh1AjbvoCmSBghGP04lB+ha+DaPUxMOjvvJ90roC5v5Nv+mXJ9T3cTK4nfZoKjuDa20klc9kyEk2WwMzgazNHyfD2xadh3mOFezhF9r9v8/374LRQt9gKa53DmKlOWPXkkf/c7ONqohoPMkox8duOD5QynpHGjUi8bGCzn73p2iY5yrC9L0VHqnHlaXli2nTNLi25g5IY307SzaDum7KPRWWOXJfK/mt/4v20IBWb+PbhsufRkntrEB3zKweNr3TZ1MXfbv3IaVKsKJiEAuCQ1MV3586xPTnppRhnwZNpOWj5ulvzfmF5fdim70/bfLHdx7oPjrOcP/jDkV6oqSudiMNJZqJHw/j/zpJdIOzqmMPzYBRbHvLp9sdTo9rSBakztYBcagbGGN4wIH0vzP7fPHqIvWlYprvGwTX35r5XxWK3bRoNv+a5AqRfsfExbuC0kEFVVpRz5jm1s5Umvx/G5upwxBowuXg/4sX8Vf8NoeMiBjqGvK/VhODIITtTckeschpP0P5pnvkzom5Z1NefEnZ9O7lT8caU3QGMjGZYLf2lvkNrs+1sH3JJWMltSIa2fSd1rHUJswlQbdVJ0Zo/Fr1DI2QMyvIK/Bnunxx19IG5w37jteC9KitOdWsimthRyD8ASlg70jI4FWYkjK7vSUwjJS+0jSGdvunc3nD1uUeRQCUuE8bWeG83I/PCuChi628Fe+EHntmWG9H5nKMZ2GLDfYDBXMzKZJkd+zHUSIBszqILoy322/y9qIOzYIqv0yX51jDCnuuE/kAg0XUrrPx25GhQQIar6ACWgJbziKodGEO0qJ9N/08c3UrGh2gTC8RJE2qHtb9DU5MGxpSimC07PS355A8pGwAQtnU1w/7E7iRmv1eS+e1Q4f8Q/ap4AgHXpAblVLOrpoPzdVpC83JpVJQS
 rYylUQ+I
 z6CUlU6/ibYvjeWwc6DtPZAqA77gg/HHxzkviI0pjaEL47EAWcfsY2qRMZAhCfmomeYQFa0zG208Oa59M5ExRvDiXiui2z/Sc8aOcIagqvIICqK7+8y1JRuBeRFKf5UJaJIAITJVpf0xWba2DHjg55Om4CZL/jMjIJh5KapF2a8Qf5Hg8j31SUmxZnlaBjlfOls6xDhbtzllep7rzmOlaei/bP2ACoPvln6L2XW9dKZrhpWxQcVHvi9w2lKkmwzdD8NxEQM8xdm78zaApLhf0Mf7vMPmdCO8F2auwiDI79WcpkiDUGKK5GvbqzdKc4XpF1EkZ+u0EQ4f17hFrs8VZJIcZVtpVUJOotYhP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 11:13:29PM +0800, Muchun Song wrote:
> 
> 
> On 2026/11/18 22:22, Mike Rapoport wrote:
> > On Tue, Nov 17, 2026 at 08:06:25PM +0800, Muchun Song wrote:
> > > KMSAN needs page extensions when kmsan_init_shadow() installs per-page
> > > metadata, before memblock_free_all() releases memory to the buddy
> > > allocator.  FLATMEM makes page extensions available by this point,
> > > whereas SPARSEMEM initializes them later in boot.
> > > 
> > > Allocate boot-time SPARSEMEM page extensions from memblock to match
> > > FLATMEM's initialization timing.  This gives early clients the same
> > > page_ext availability guarantee across both memory models, while runtime
> > > memory hotplug continues to use vmalloc.
> > > 
> > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thanks for reviewing.
> 
> > 
> > with a nit below
> > 
> > > ---
> > > v2:
> > > - Allocate all boot-time SPARSEMEM page extensions from memblock
> > >    (suggested by Mike Rapoport)
> > > - Keep memblock allocations above DMA and suppress per-section free
> > >    messages (suggested by Chris Down)
> > > ---
> > >   include/linux/page_ext.h |   9 +--
> > >   mm/mm_init.c             |   4 --
> > >   mm/page_ext.c            | 119 +++++++++++++++++++--------------------
> > >   3 files changed, 60 insertions(+), 72 deletions(-)
> > > 
> > > +static __ref void *alloc_page_ext(size_t size, int nid)
> > >   {
> > >   	void *addr;
> > > +	if (!slab_is_available()) {
> > > +		addr = memblock_alloc_try_nid(size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
> > > +					      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
> > > +		if (addr)
> > > +			memmap_boot_pages_add(size / PAGE_SIZE);
> > I think it should be DIV_ROUND_UP().
> 
> size is currently page-aligned by init_section_page_ext(), so both forms are
> equivalent here. Is the suggestion to avoid relying on this caller-side
> invariant and make it more robust? If so, I'll use DIV_ROUND_UP() for both
> accounting calls.

Yeah, keeping it here does not cost much and whatever
init_section_page_ext() does we still count the pages right.

Especially if we move the whole thingy to memmap_alloc().
 
> Thanks,
> Muchun
> 
> > 
> > > +		return addr;
> > > +	}
> > > +
> > >   	addr = vzalloc_node(size, nid);
> > >   	if (addr)
> > > -		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
> > > +		memmap_pages_add(size / PAGE_SIZE);
> > And here too.
> > 
> > >   	return addr;
> > >   }
> > > @@ -304,7 +300,7 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
> > >   	if (section->page_ext)
> > >   		return 0;
> > > -	table_size = page_ext_size * PAGES_PER_SECTION;
> > > +	table_size = PAGE_ALIGN(page_ext_size * PAGES_PER_SECTION);
> > >   	base = alloc_page_ext(table_size, nid);
> > >   	/*
> 

-- 
Sincerely yours,
Mike.

