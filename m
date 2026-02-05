Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C3B1EC1EA5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8016B0005; Thu,  5 Feb 2026 06:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7653D6B0088; Thu,  5 Feb 2026 06:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647696B0092; Thu,  5 Feb 2026 06:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51F0D6B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:36:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBEBE14045B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:36:01 +0000 (UTC)
X-FDA: 84410198922.11.2F39456
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E2837180006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:35:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cu7s1t/w";
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770291359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMihYGbDg77uRU1zVwkgutHH8FV1ulypyq9/n+xDWkE=;
	b=CUXQG4QVnukt9q89BB63ep1TMNdMMkWvpWc6rbAWvmuMoJYyA0Rxl3MvbNTvO6wTaLuYut
	wLiEgBnuWK5bj2zuZ47rdMlTp1BcHfz6R2HyuSbBTa7DsAbYoR9CyPKTjzQjenVN5nn3Ly
	vdRRU4dxOEdLOWJm/24ALQNxtJD3nXA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cu7s1t/w";
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770291359; a=rsa-sha256;
	cv=none;
	b=VLovpzLP/daYLnxBATQTmZWucceWvJi4P6r8KL3lbmaOMHdMCzzfijrDz6b3Ej8G9eSXeh
	jFSfIaIbshH4VI5oe4Hmfk57GFD00jKtfG8bR9I5vSz5HaSjcwCwCNDM5CgUx+L/CQ3wKC
	QSyaiGSAqOmSm+pltzTwoCkLf++2qoc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D6A260122;
	Thu,  5 Feb 2026 11:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E695BC4CEF7;
	Thu,  5 Feb 2026 11:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770291359;
	bh=3sMz1aXuuijzMsHvvObi2VXR9fx4WgEVichiU4CKZDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cu7s1t/w6916Ya6ixpS6ttgjpMI2URV57aNBympnofTya/gxFpRRp61I06akmavdL
	 eQu0GohOQWs/g6dXAoYwIi5nj7gz2j0M7LOYJZJ5sO9IqcKJrdbCLpskJNbMSlFWLX
	 UG82wzpZSIE1w8UVOTbUcAxsMVVkI/nPtrOynuoG/DJFIg48BaVfjnNV+Nmj2kH21A
	 EQ3LaZKgCM/XBi+WtrdE/qdIFQLWJC8TURH7/eQznHgVg9EwRXhzMmSgN1/e7LpGdL
	 He24meVNRkv/Ke8oXQ6sEJ2GN+y3q74OQtXvENKyJXDzJ3ctLSrOyGZyQdaKGC3nch
	 Pv/Wt/rESj1UQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id EDAACF4006C;
	Thu,  5 Feb 2026 06:35:56 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 05 Feb 2026 06:35:56 -0500
X-ME-Sender: <xms:nICEaW_GvSSBINXf0ofq_x-yLSb58h8Og9sxOg20LDUUqtVKPd2rGw>
    <xme:nICEaS84tMRreNW5lZJAPhpBScOsKOGhe6iSr3R_x1nVEK-b0PtH-38d0qQvhAlfd
    3s4NizCjv59vM_uLsgD3MC1EKHuXUlovGPmlKJdkjJUzkee04UF42Q>
X-ME-Received: <xmr:nICEaVquclR8ZwZTFgdXvcQmyteANYL9y2MDtUACN47OUj1NDZeNvAxb9eMqNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeehvddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeigfdvtdekveejhfehtdduueeuieekjeekvdfggfdtkeegieevjedvgeetvdeh
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeehiedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlih
    hnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehmuhgthhhunhdrshho
    nhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtoh
    hmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthho
    pehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgtphhtthhopehfvhgulh
    esghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdgu
    vgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:nICEaexJkDciWL0gFKUnWwSDONB_D9Vg9IWhiPLedXxhJBnzDgZGKg>
    <xmx:nICEaUn-QwjMmOgHFazrgt66R5nUW1MxGWRvDl-sNftjNrODSjgR2w>
    <xmx:nICEaanFFBKtYwPiT8WBYCH1FdMASU4t8LDB18cpKxTCSriwe6BV7g>
    <xmx:nICEaazz6wcm51a7dwkOdM8i3af2JSfws-k5O4hX_h4YlCy-sTkk0g>
    <xmx:nICEaRZub43Z5DZ1aTG6jE-RP89KGBpGg0cgqYFgv_KJH-iiJipqwpQ_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 06:35:54 -0500 (EST)
Date: Thu, 5 Feb 2026 11:35:50 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Subject: Re: [PATCHv6 02/17] mm: Change the interface of prep_compound_tail()
Message-ID: <aYR-YULI3lBtl9y_@thinkstation>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-3-kas@kernel.org>
 <a61bc0a8-cf5a-418a-aeb4-96553b87f043@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a61bc0a8-cf5a-418a-aeb4-96553b87f043@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: E2837180006
X-Rspamd-Server: rspam07
X-Stat-Signature: a8sdko3fqpz8jk1w7u45fo99qat18nre
X-HE-Tag: 1770291359-178477
X-HE-Meta: U2FsdGVkX1/I/E7t6Xp/+caSJzbjfLflMXI3D7HNBATNpSI5OU/AInbZY3U2BSLDQyGEyYuDNNN9T3o0SrD3wBFWagLa1uIg6/TW67dHt3ssdmk+dDymGrufn4QldkbdUEft2WR18liCBWErYvkCo1RTsvDUxzIxVwo+DWgLDtboiR0/gtqyxpOuNDhiGDKUbjeJ8HW73YlZHIojvD2BpgFOIsgkXvGTOZdsV2mTX+tIj1iH84i8Dtau8oWcPhiSgnCF0Sj0PcCEgHxUjQk/j7uRUEBUdK8JbbwukNfqa3oaGzesLszGMS6Gv/pBDNln9JvahY4ssZwZdEkxYfU6rc1++duguUQTP1FUygsfRMtD7R/78709m7nT6jm8B+43iqTfdUAgR/ssfkGvGjqsxr7u0L20eoYFtF48hhdpo2SyQ7NY4O+l7O/03P3m//ei12Qx1lP+7RlMW2i4Sk0pLHs5Ci7OtUW16Ur0FNO2iO3QstoWqqU7Ti8m0oCQbGIT+lCy/yHEKXXKO9hvgtmzH3xMfwEt887HFT/7VHHHMopNw1NdL5VwzE38orZsPS6zS1Hghn2wLZ391wcmz4E2pbnODxcRusy25ejpdQFUvRWTc83ifa4IhCOjYBw17f7skWXOPm2Mid9VqJi39gr/tlxvPmpiMydijT3BQERyIk64TwbiFDginEd+XfncqnvOlVjtVPshr0f2bdKJSnAKuV8ww9qnti9TFZLSsNxHP6YfUPi4a6gDP69GDiLpS28Rn0yq4jCuaYwgx643VnkT6dL0Oc93mYxxHChfgAWgF5coQeAsdsUK0nM68j5SIVGEq2sAfweUMebKTeSxSH/ul1QYEprrSQJt69YkRpOQ+thmNs8DblcguLEjgQQ0PG/Kqm0TzzNj9h8ktVZTSx9UIVspUXbMeKSLaRWN8mBfpfP3cy1zw0NFV2Q0yB53f593WHb0zTpcd7YybI+QZSI
 Iqw2/v4L
 22RDKg7ktlt4gHbGZx5zV+9yem0bmjZzTMaBt1cCcLbe8DTd2NhGJNsAjR6pQIqpwqHgX8V8KH7DwuYQaU/nA2tgjsDqmaPrfDh4Q6hiDfMMTSQLJ0kHXy5FRIz3tOs8nrKhFc7iaMZtuMvwPWiFE2bEoW2oDqS9CKvLcC5pubCi8o1Qf7GwTRLj4ieleohqtNaUCCKW4bd1c1MB+03K23GIqD2skqUwPu+0NmfN8Bagwyy3gMqjubvjBSieBE9rmikCDe4S+yf4rtC+xXLpixyWMDYTjLbTPVPJSefO/YgKl5d3x/Lm35CT8vYOgkpPaVdys97IhIIdQ7Eetd7xSt7I4lpq/mhZC0mzev5hduHq1olisyQF+BNTOLw0BhXDVjSN4srYeVQJ5VxA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 05:14:12PM +0100, David Hildenbrand (arm) wrote:
> On 2/2/26 16:56, Kiryl Shutsemau wrote:
> > Instead of passing down the head page and tail page index, pass the tail
> > and head pages directly, as well as the order of the compound page.
> > 
> > This is a preparation for changing how the head position is encoded in
> > the tail page.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Reviewed-by: Muchun Song <muchun.song@linux.dev>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > ---
> >   include/linux/page-flags.h |  4 +++-
> >   mm/hugetlb.c               |  8 +++++---
> >   mm/internal.h              | 12 ++++++------
> >   mm/mm_init.c               |  2 +-
> >   mm/page_alloc.c            |  2 +-
> >   5 files changed, 16 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index f7a0e4af0c73..8a3694369e15 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -865,7 +865,9 @@ static inline bool folio_test_large(const struct folio *folio)
> >   	return folio_test_head(folio);
> >   }
> > -static __always_inline void set_compound_head(struct page *page, struct page *head)
> > +static __always_inline void set_compound_head(struct page *page,
> > +					      const struct page *head,
> > +					      unsigned int order)
> 
> Two tab indents please on second+ parameter list whenever you touch code.

Do we have this coding style preference written down somewhere?

-tip tree wants the opposite. Documentation/process/maintainer-tip.rst:

	When splitting function declarations or function calls, then please align
	the first argument in the second line with the first argument in the first
	line::

I want the editor to do The Right Thing™ without my brain involvement.
Having different coding styles in different corners of the kernel makes
it hard.

> 
> >   {
> >   	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
> >   }
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 6e855a32de3d..54ba7cd05a86 100644
> 
> 
> [...]
> 
> > diff --git a/mm/internal.h b/mm/internal.h
> > index d67e8bb75734..037ddcda25ff 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -879,13 +879,13 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
> >   		INIT_LIST_HEAD(&folio->_deferred_list);
> >   }
> > -static inline void prep_compound_tail(struct page *head, int tail_idx)
> > +static inline void prep_compound_tail(struct page *tail,
> 
> Just wondering whether we should call this "struct page *page" for
> consistency with set_compound_head().
> 
> Or alternatively, call it also "tail" in set_compound_head().

I will take the alternative path :)

> 
> > +				      const struct page *head,
> > +				      unsigned int order)
> 
> Two tab indent, then this fits into two lines in total.
> 
> >   {
> > -	struct page *p = head + tail_idx;
> > -
> > -	p->mapping = TAIL_MAPPING;
> > -	set_compound_head(p, head);
> > -	set_page_private(p, 0);
> > +	tail->mapping = TAIL_MAPPING;
> > +	set_compound_head(tail, head, order);
> > +	set_page_private(tail, 0);
> >   }
> Only nits, in general LGTM
> 
> Acked-by: David Hildenbrand (arm) <david@kernel.org>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

