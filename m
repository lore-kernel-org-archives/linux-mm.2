Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A31DCAC580
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 23:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99B98E0003; Fri,  5 Sep 2025 19:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49F08E0001; Fri,  5 Sep 2025 19:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86E18E0003; Fri,  5 Sep 2025 19:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A85888E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:01:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 486CE1DD13A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:01:23 +0000 (UTC)
X-FDA: 83856719646.22.C86A81A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B9799140011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:01:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FKhh4N0Y;
	spf=pass (imf23.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757113281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZoercRzV+9gES767UN4t02R1PKB+nn+QIHkF8YGS5E=;
	b=dWGBO9cnDDOvw6R6Gpe6AuSMMAqWeZ98P1oQpLbsTH9J0wLWKLRrpzjwUjeBuFW1d8wgs0
	1F3r2rLgNGN/Qd3lDo22hmZZy8T50iwObGMAfuyz9TV+n7bZG5xfMMq3fPPj/Uui888iz2
	CLDwgkSDaBeUqHfGlBrP35EAPraBPeg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FKhh4N0Y;
	spf=pass (imf23.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757113281; a=rsa-sha256;
	cv=none;
	b=zK3DwJFC4qcxVQX5vBXxAI+/1QzkzyPAl6Ep1JTt22oH6D5OHnR+H+ARY/LrFDHdRe4NWD
	8/ALgSgQXfvnVNiZwrh4+gzCxqq3jkEuA852SBh0p4/f93GKdbJRPksdgi7YAHWK6JZ4ND
	bc3O/IUAO29oFg6uwQ783YjrvNHUVho=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CBCC2601AA;
	Fri,  5 Sep 2025 23:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CEDC4CEF1;
	Fri,  5 Sep 2025 23:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757113280;
	bh=+lhopyxIHPkimkHLqjBagKsowbxPduHdhl1alB5XIHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKhh4N0YC7rktiPdXEfXclWanEDKYne9TN6cdcuCjqPCtcq4Rn0r96yLuECJbiw+4
	 LjwCnjQtLBAm0edveUnCZZYiNonj/7aqKLJr2wGtnUHH+scBK/7r7JUigttXLAScDm
	 pXeFnpIPvL1/rZKX9LdznwwDYBYkDL4/X0Q74Dlpx/NmySnEYO46ImCPWzvWXVlUfn
	 7nKQ1fERSefzbF0N9pUOtT2Ew99OpHStRZ+01KHKpecJw2kFIukduhp+K3hQulq8o0
	 47VhyxuU+d72ralUlgkhIgcgxiZyD9aQX9YFUuu3Ep7hq8BTDKfbNp6DFssdME8qWg
	 uTEId8/MJZDQg==
Date: Fri, 5 Sep 2025 16:00:06 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
Message-ID: <20250905230006.GA1776@sol>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
X-Rspamd-Queue-Id: B9799140011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: w9m9izbirzatd8bgz61omzscsnyubsxt
X-HE-Tag: 1757113281-832887
X-HE-Meta: U2FsdGVkX1+bLypUCHVX8NsHcRz3yuUXT0Uv6guQ+GvIt4eYtu+gExOZb4wClaSIDhDwDW2+Bc/Sb10bhPS5YhNnJOCubYruEY2XGv0JRS4huGP/oDdE5oXHmSbRNurXVs1DsI0vnFCHgEut7BGU/+KuJKrLNMQI+9/MuDs0/hGl1HV8Tjwh4ihX++b9P/Gf80n30KjIJKnCsdWIoJYxfjwDaEwd9jWTGmyVoN+CLBLBIbzra/RK8V8nazIf52gd0NCTrGkzrF8QbCwDPLEaCeYh5gXcx0+mrf24Er60cL4t2dGC262zTiEGJsx2FYAtMJ0khQiqhazCoExkxXO1I4gf2m9BtgUK9b1dCMEDYm6CI+Y/CduK326CXeBLamV0QKWK+/Mi7dcojCNEjTFQzJm1BcRtbslAW9SHns1Di/HtRZDBkaWDdPDyJmWLDRm14DKm7AErruyTMoLpazEX64ARfzV3c0GSFJkeiVCLehM7yc1NNZJ/37ZIPAFeLPkExCY3uIF2FYsPPF+WocFsrYfAKaSkgJXzsIv4cBLuOvx0jyYF/WKpBmLQM9/e2V1umWhvY4L4KVE28z3luT6slpd98A+ZhiBYKih1lSVlIcMuCDImLZPfynvbUhJgjAVm5R7O09M/fV21n37KXy9BszFEiFfZI25NxXyOIsP6QOvQmrdeeVq5oSlwM37N2qXgFTm1gKGF6f1v1LtKKrIDlyRjf0gGJcaABU3UuaTn0ZXTiEdZOcDY8gj0oLjfokrI7l2QXLAYS6zffay2i/YNeRs3iat78X/WQWdS5ZjGK1tgmFOnA+a+bFMbbBbLUhpmBYf8JnsBnOh1Fgf0EuDkbVI+YsEDINOGNJOh79l43/XokSiOxE7dp/EqjV5x9NCBubPYu7X4F2763ADYS3o3n9As3I5/1updDy82pB0VFuLHtBgHAUdoecrg3jLhMqrcZHlHpBwuMMMgP3hDavk
 yVeEtflm
 2waDd9IxyOeSDo7pjwZxoag4v6ZPNMFQ4v1VRPqMUo6NMUEPhNH5UB/qX0Ht4Q0QTfbRTDEypMxyZblbiYhQom9MaE1CJ/G6QFW6wICgg4RFeGsCr1VQz1F6whsv71NU3UtD513o14uqRO2AfzvJlfaL4S7vxXGQAKcfGDqcoLBpcG1cF5eKYy/8dSUixCwNb/ezakOlZ7zSw0Mgq1TXBdx7gPkLX5Mkt0O4QfM7yeClWr72HTqJbjs15Dd152g2I7n88RJBdrWh66Ll7xrH2pi5EQ92E8Kr1QwaB1r6Atu1G2tmxlfg3mCAJbph6B5liEvKQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 08:41:23AM +0200, David Hildenbrand wrote:
> On 01.09.25 17:03, David Hildenbrand wrote:
> > We can just cleanup the code by calculating the #refs earlier,
> > so we can just inline what remains of record_subpages().
> > 
> > Calculate the number of references/pages ahead of times, and record them
> > only once all our tests passed.
> > 
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > ---
> >   mm/gup.c | 25 ++++++++-----------------
> >   1 file changed, 8 insertions(+), 17 deletions(-)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index c10cd969c1a3b..f0f4d1a68e094 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
> >   #ifdef CONFIG_MMU
> >   #ifdef CONFIG_HAVE_GUP_FAST
> > -static int record_subpages(struct page *page, unsigned long sz,
> > -			   unsigned long addr, unsigned long end,
> > -			   struct page **pages)
> > -{
> > -	int nr;
> > -
> > -	page += (addr & (sz - 1)) >> PAGE_SHIFT;
> > -	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
> > -		pages[nr] = page++;
> > -
> > -	return nr;
> > -}
> > -
> >   /**
> >    * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
> >    * @page:  pointer to page to be grabbed
> > @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> >   	if (pmd_special(orig))
> >   		return 0;
> > -	page = pmd_page(orig);
> > -	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
> > +	refs = (end - addr) >> PAGE_SHIFT;
> > +	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
> >   	folio = try_grab_folio_fast(page, refs, flags);
> >   	if (!folio)
> > @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> >   	}
> >   	*nr += refs;
> > +	for (; refs; refs--)
> > +		*(pages++) = page++;
> >   	folio_set_referenced(folio);
> >   	return 1;
> >   }
> > @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> >   	if (pud_special(orig))
> >   		return 0;
> > -	page = pud_page(orig);
> > -	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
> > +	refs = (end - addr) >> PAGE_SHIFT;
> > +	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
> >   	folio = try_grab_folio_fast(page, refs, flags);
> >   	if (!folio)
> > @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> >   	}
> >   	*nr += refs;
> > +	for (; refs; refs--)
> > +		*(pages++) = page++;
> >   	folio_set_referenced(folio);
> >   	return 1;
> >   }
> 
> Okay, this code is nasty. We should rework this code to just return the nr and receive a the proper
> pages pointer, getting rid of the "*nr" parameter.
> 
> For the time being, the following should do the trick:
> 
> commit bfd07c995814354f6b66c5b6a72e96a7aa9fb73b (HEAD -> nth_page)
> Author: David Hildenbrand <david@redhat.com>
> Date:   Fri Sep 5 08:38:43 2025 +0200
> 
>     fixup: mm/gup: remove record_subpages()
>     pages is not adjusted by the caller, but idnexed by existing *nr.
>     Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 010fe56f6e132..22420f2069ee1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>                 return 0;
>         }
> +       pages += *nr;
>         *nr += refs;
>         for (; refs; refs--)
>                 *(pages++) = page++;
> @@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>                 return 0;
>         }
> +       pages += *nr;
>         *nr += refs;
>         for (; refs; refs--)
>                 *(pages++) = page++;

Can this get folded in soon?  This bug is causing crashes in AF_ALG too.

Thanks,

- Eric

