Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42996C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0377C6B0088; Wed,  8 Jul 2026 04:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29FE6B008A; Wed,  8 Jul 2026 04:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65B96B008C; Wed,  8 Jul 2026 04:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD9156B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:32:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4622EA06D1
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:32:10 +0000 (UTC)
X-FDA: 84964942020.11.32FA1B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A3DD84000D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:32:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g/F6NZyn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783499528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4ESd5w+M2nYuptCS0AZ2uFcE5EIsy34u8jWL9YQIJs=;
	b=BlqFLx4GntjNA3+zN6wbDF0rVX2aVg8P0BTAXXCw8TvZ6YrNHh95IXPG2iINo/In2UbBaa
	LrxLl9b35gQbY//cuSDCeI+O31H7cP1JwD8EFiYY7tkmcDxfhNo5D/P7ntnkLDFs3HYHhH
	u6p9LRv2B3da0yxG3jWY/UgMw3wEpWY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g/F6NZyn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783499528;
	b=Q8Zo8UqZAxaPWTTw5EyyuzM6cOlm0wVjdk1Xy2KGN04Z54YoZYncjPqGToVekpxfC4waY6
	pP9SHBPhDravKAPqsF4Rg1pABpHF1iagNUnIZ26LSsgvvHFqYcikOdp5VyBC3E7I8XEuPa
	JEnX+4jEJLt0bLjOCrUq8YNZJVsqt64=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DAB054030E;
	Wed,  8 Jul 2026 08:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7831F000E9;
	Wed,  8 Jul 2026 08:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783499527;
	bh=c4ESd5w+M2nYuptCS0AZ2uFcE5EIsy34u8jWL9YQIJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g/F6NZynkHZZkdMtfyNvxGJ83yPjcmU31yD2r/fGncf00K1xWvN34mwxbRKQ4iSxC
	 G5hFe+apUbqNMCB9UyRUOxa6zNKzqCMz6tBRvAYoIrQSFIYfPdctennxQeO+G3Kk4k
	 irJDpo0mZ5/I8gFw6zSGfprFs6k+pbS0Dhj516GApTErgkop/C1Fm1yj+K6A8VBFN+
	 IhDLzOYO+ozJqAXJ245zl9cCajx8Lo17qbFs9AnGgOWIeKNmx/s04lzTTB7gxEcT8s
	 vPNDhuz8rbOZcR9IAXJp/Lm9zi4rXFb0MbiHaRfEcoKVB2Ua0+h2MFfwS9GTp9Cl8w
	 dsDJo4QXWiL6A==
Date: Wed, 8 Jul 2026 09:31:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Luiz Capitulino <luizcap@redhat.com>, Sourabh Jain <sourabhjain@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/util: don't read __page_2 for order-1 folios in
 snapshot_page()
Message-ID: <ak4KweoRcwnxZC-5@lucifer>
References: <20260708015252.296103-1-aboorvad@linux.ibm.com>
 <6fec660b-7c6b-44b1-a7bc-f4687cda734a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fec660b-7c6b-44b1-a7bc-f4687cda734a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3DD84000D
X-Stat-Signature: zbkau5g3gpai78bm3u394t5tox3976su
X-HE-Tag: 1783499528-521026
X-HE-Meta: U2FsdGVkX1+0LDiBNRONcPtco3EY+7ICsH4JVA5NoQFBFOyFqs/kBJtPlUaw4gH28m+y6mxIYj5ALE2OOSLHG61lp5icje7XvWnXNzIMTfw+EKDRoP7x7h1ZE01pE1PKeOcjy1sS6hG/l4n9D8Cdh6rs3ugTJM0puEM8lQSHnO5j31TaRWbJWsSYXaZS/ZiEjJmFpgGWgFZnvSrPYuhGMtyMNtYFTPjoIDioIsRgjmKI1QDK3hMrKmF/FoCd8u6Ob2vdaU0hbD9qTjWsJ9ybla0NGGUin/4OZ9aqGDUXNrkPoszbQ+htblluHOiEgXBjZLHLF5iRw0GunBL0b4eihwZ3WHfaWKS0X6PffA+QSjCjiFJ9TkmaksEgvO38gJBSKFbvzfG3UbH/tEtvq0uI9YcSediE7z6Jhy9nF1U8ppnqFN74rM+sGgFotADhUNr9yDiFkpM/IwXnMwm1obJTkEtmx7DQ/GwJpHa4r5Jal0hFjer2ieZBiWZNYPXZEfFdFx6zDsgBJ7Qh8Ge4UkYoPaUiQWgAeKx5tH6wJ1Zkiff8L+sJkX/zjOnNrZAppbjqFgDhw6Z4GdZgSekV5Op4+/RhwphO32OkjsBPK6AqGTy5ZgKNYhlh0kXP8TIwxdBFzZVrGzNUMbKIhKfN949ffidPTWNK2Fqgv6jtOJ91nIGKzCLK6B6jOQpU68fJ8gEULO1AxZnewZjrtr3l0PSfaRlIC5GopDRf0hTovATvoNlHwGIeUIFkKYgk+uf5/fZF+i7zNLRmm8k9moIswnNSpC83c9fLQail1ATjt4JA6jNgLS39Q3rVbkul0UKjPQvkJ3ii2/KQAtU6rW+CzNEXYRqk3VK9ozgzR7oWMWOSEgkrbQYrOILcbMWJktU1LNHBe9Gvs8kh+y6gcitHTQarN1CKUT7Z3DUc1jHSU+YCmrfsRxpx6YWy3O3yHCxPfPJkUW/0clQDXu2tCodODBW
 TOW8Qhve
 UThKjih45JfdvkWzVmFuLKEIbIxxN68sSJZpzdq+I2QmknoxDiB7k52TUeWF189s//Yl7dRqMxK4Jnh3Uv78M34xc9GES8/JKWAGgk5/1nUI0Ol9LWqVI94rBuLLL1Aew5le/PPJMfoY2pf+KFOEU9iaXIGCqlSTCH+ZfrAK+Km9q9yOeuPCvzIOv31J/SIYHf7pe1W+L5gGNOR+S0U6xOXA3325QcT6ZCTU7up7cxMJcrgy9Fp8w8hqVQBMiWnvO5fod2Z3C5CwXo9cei9IDxVw7f0+o9W/qmkSMXurWoK/aISzjKiM5ZWQdmdS1uX/uTDwtK1fo9BuZVBKOqeomeG9n0/7OsuIEMS3Ur0p+KbkNDu+wMTzMTxM6QwUo1MlLpsTGBlpvwWnu/r5fK9VI6W/uXQqLFOx0Nm3caRU+Er5mbvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 10:10:33AM +0200, David Hildenbrand (Arm) wrote:
> On 7/8/26 03:52, Aboorva Devarajan wrote:
> > snapshot_page() reconstructs a folio from a struct page.  After copying
> > the head and __page_1 it reads __page_2 whenever the folio has more than
> > one page:
> >
> > 	if (nr_pages > 1)
> > 		memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
> > 		       sizeof(struct page));
> >
> > __page_2 is the folio's third struct page, so it is part of the folio
> > only for order >= 2 (nr_pages > 2).  For an order-1 folio (exactly two
> > pages) __page_2 is not part of the folio at all, it is the struct page
> > of the following pfn.
> >
> > When such an order-1 head sits in the last struct page slots of a
> > populated section whose neighbouring section is absent (a memory hole),
> > __page_2 falls into the next section's unpopulated vmemmap and the
> > read oopses.
> >
> > Observed on a 22 TB ppc64le LPAR during DLPAR memory remove, on the page
> > isolation dump path:
> >
> > 	offline_pages -> start_isolate_page_range -> isolate_single_pageblock
> > 	  -> set_migratetype_isolate -> dump_page -> __dump_page -> snapshot_page
> >
> > 	NIP   = snapshot_page+264  (ld of __page_2)
> > 	r4    = foliop = head = 0xc00c0005a03fff80
> > 	DAR   = r4 + 0x88     = 0xc00c0005a0400008   (unmapped)
> > 	DSISR = 0x40000000                           (no translation)
> >
> > The faulting head was a free page that still carried PG_head with
> > _nr_pages == 2; its __page_2 is the first entry of the absent section.
> >
> > It is also reproducible deterministically in a VM by placing an order-1
> > folio in the last slots of a populated section adjacent to a hole
> > (memmap=nnM$ssM) and calling dump_page() on it.
> >
> > Only read __page_2 for order >= 2 folios (nr_pages > 2).
>
> Hi!
>
> Can you shorten that a bit? It's rather trivial, really.
>
> "snapshot_page() currently reads __page_2 after checking nr_pages > 1, whereby
> we really should only do so for nr_pages > 2. Let's fix that to avoid reading
> memmap that doesn't exist (e.g., vmemmap hole)
>
>
> Observed on a 22 TB ppc64le LPAR during DLPAR memory remove ...
> "
>
> >
> > Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit")
> > Cc: stable@vger.kernel.org # v6.15+
> > Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> > Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> > ---
> >  mm/util.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/util.c b/mm/util.c
> > index af2c2103f0d95..b3d48a05e6d82 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1353,7 +1353,13 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
> >  	if (ps->idx < MAX_FOLIO_NR_PAGES) {
> >  		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
> >  		nr_pages = folio_nr_pages(&ps->folio_snapshot);
> > -		if (nr_pages > 1)
> > +		/*
> > +		 * __page_2 is the folio's third struct page and is part of the
> > +		 * folio only for order >= 2 (nr_pages > 2).  For an order-1
> > +		 * folio it is not part of the folio and may fall into an
> > +		 * adjacent, possibly absent, section.
> > +		 */
>
> No need for the comment, really, this is rather trivial.
>
> > +		if (nr_pages > 2)
> >  			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
> >  			       sizeof(struct page));
> >  		set_ps_flags(ps, foliop, page);
>
>
> With a condensed patch description and the comment dropped
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> Thanks!
>
> --
> Cheers,
>
> David

Agree with everything David said :)

Patch looks good with changes David suggested applied, so feel free to add my
tag to v2 alongside David's:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Cheers, Lorenzo

