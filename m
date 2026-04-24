Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352DDFF8855
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DFBB6B0005; Fri, 24 Apr 2026 17:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990836B008A; Fri, 24 Apr 2026 17:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6F06B008C; Fri, 24 Apr 2026 17:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9176B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:56:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 191F9140129
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:56:52 +0000 (UTC)
X-FDA: 84694809864.04.E1D95B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4DE0A8000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:56:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EP5Ta0oM;
	spf=pass (imf30.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777067810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFecVaYsuECpctf0QhYvVkLu5CS6EBXCOaM+RvJC/fs=;
	b=4zdIqw+A5i4Uec9jkmI5KoTX1TO8mBcYatZCBBBK//xVzODQ8mISQmkiBx/xrG7miHzPuG
	+aafsEmlrb9z2FOvNzw+J3iPi3eYHkSDIufCM0DArhe5MLF9i7kBumdLOSswC39mV2VwLf
	c06o5N8/AJlfLyZHJEnkYnhVKTj3rfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777067810; a=rsa-sha256;
	cv=none;
	b=29V0zDiPaulNEt8tdRnqniesneekolJdEy0OrdWWHSwHSy0t/PWrimPGFbd2QcUzRLem6M
	PMVaDqIO1nhMVe+0UQ91qljFF7AI4hchkAzk14IaMBIiUfmsNRWxIvxjr4wOah2BAdEIFA
	8ZXimEHPufwII+Fk0yCLa+zJNdc3ETo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EP5Ta0oM;
	spf=pass (imf30.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05B4C41955;
	Fri, 24 Apr 2026 21:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78664C19425;
	Fri, 24 Apr 2026 21:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067808;
	bh=bDOd/gakIbkBKObfCe2HtqThY9/sGAFIg0LgcuIt8Wc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EP5Ta0oMk2Y+untGzKqrixCmcUbFndrmsNr6pjlfH0xBaEOhKEZjBLObEo1ab3r5a
	 VcnLsFYRL4Yq9sG999Igj9FIXZQN7oRALgrvT8iOisTIKWQk7/IDBL3nxSu1LnEPL5
	 h7wT/AhjwNzVUFrMPDFiNXLwf101hJoCwmesVRw1WC7Cvx4zSIks9qByQMX0r8/Lrp
	 Yzf4M1fBzi3S4+ClbXww0DBvvndtWUsRWpq2CqhSdBSg/y7D/Wj5BE+Rz/3bfdIn+a
	 sensTX9uA/2CMzrcTLVikpmvhOd25qH00TaSUQkHItwFR+oJEoERHQaEr2My+tyic3
	 l5yTdF8zC0k0A==
Date: Fri, 24 Apr 2026 14:56:47 -0700
From: Minchan Kim <minchan@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com,
	brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 1/3] mm: process_mrelease: expedite clean file folio
 reclaim via mmu_gather
Message-ID: <aevnH-0yVstaPjiJ@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-2-minchan@kernel.org>
 <aevFb-ZemUo4nB3I@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aevFb-ZemUo4nB3I@casper.infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4DE0A8000B
X-Rspam-User: 
X-Stat-Signature: oi4c9gu1njsgq54pxtn7puowhiwu899j
X-HE-Tag: 1777067810-521815
X-HE-Meta: U2FsdGVkX18/Pre/rOFwqqlA9aPbi3NMMxF33Y7e5I6MtSbn07zl/ZFb6jfNDn+EIHLLAXtN10plVVMnUhGu2DxrAUlUZ7+mjINvVDPr5EZHNX1NouqrrrV9WBuaCh3S3oeQn2+XLrxp7Ymx2CLmaiQMlH9oY28e5HC+pNty/c8+GrIGTepKQPDVqhucvoKl2fZN8IMzt9YtkfRp7sUJN8If5s2z7FGkR4XXpwVdlXlOVVtUGrd5ukOrbSBFy9xqJK4OYW5K6f3S9NOtzAXCG1755zMh7B+WKcMBmhTfrhErv+KuWLUIiaQHhFZFZtspoubBwOKbAgBbI3xWm8HEROYPIpxIqg6XxrKdlqG3lqAGQ+8By0UDhom3QbdQbtCjub+UNX6C257AmqrNbw38hap0Xx5F9hdB6Tiuw43eziZU0dlSMvplvdDOwMveYJ/pVop38AZTodKcRnYIeyi8NZvYALzPpQjs54uiEoff7Ed6Fo92VE/CShX3f8ks9j7C2b85armVcfboTfHxpf52LRE6uNFI3wYz0uAgLQ9OyTLTkPsf+xMTePVJsDUrf+OoXNRQHZUEGGJEZpuWtxN7mY73YEwG8gXK6c3EUMVZv8BZTfMJfKPrUvhKYsv6Nz1SnqnNaf/UCz2zY+DLSPIk5besDitp5H7yRgVFk2ebrdr78NzMRODEi/biJELiCNhjlWzZP5fgkdpy08iQwJii13GCO8xZQeLe0ZTeRXZPGDpvOjsR9aiELj1G3alF76onsXKaRwbuAg3DLZUBjZsaonP10R95oy1Tve/hYK1jX0RzgLKKzSC54xNvq1m8Ue8R9/v6wjHW60g0h2IKogn42xQhtcG1viPlgp68gHofBJVB+VrOI9QUHAwDoUAYXqvWtZCEsqqqltxjJSMBQsBqEgfJPa/wW7HmYgjT43RqPAeMQUAgqffteIe0Saz6qn9Kplrs5m37EchgCsBSaB6
 sH86eA6B
 F/YHY05ZIRyIfgkSFzeeNHZlrTsxat3cN9qADjeJi9UXV5L9cyLP3ur7sP+mVvbmqPtaJLbxjWhpzKjBNsXNXVpNK6bI132+9nmfiaHRdoJ3XNwyBYHxC0wG1mKh4JwPtpFJc7hVGo4Y6qvQdREZ2vm5MyIiLh5cD1XE9hIyUH7QB25JcrD7+Q9vrIXNKUtt2qR79sgXdw2NAcEud5ROKpT2VAdlpkdzUwInIZfP18vJ+fKIWijU8L6amxtr4FxvtJXdbeM4In1Pkz4hWDXuqFZWp+/Z/f32n627BzJkzFSFQJXrR5u2gg5TDUqG/zKJLO9wRfoArQbTJ2Ug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 08:33:03PM +0100, Matthew Wilcox wrote:
> On Tue, Apr 21, 2026 at 04:02:37PM -0700, Minchan Kim wrote:
> > +++ b/mm/swap.c
> > @@ -1043,6 +1043,48 @@ void release_pages(release_pages_arg arg, int nr)
> >  }
> >  EXPORT_SYMBOL(release_pages);
> >  
> > +static inline void free_file_cache(struct folio *folio)
> > +{
> > +	if (folio_trylock(folio)) {
> > +		mapping_evict_folio(folio_mapping(folio), folio);
> 
> If we already know that the folio is for a file (and I think we do?)
> then we can just use folio->mapping here.  On the other hand, if it
> could be KSM or something else weird, carry on.

Thanks for the review. It made me think about the shmem corner cases.

Since we already check folio_test_anon(folio) before calling this path,
we know we are dealing with non-anonymous folios.

My specific concern was shmem folios, which are not anonymous but can
be in the swap cache. While mapping_evict_folio() might technically work
for them at this point (since remove_mapping handles it but I might miss),
it feels unintentional and fragile because mapping_evict_folio() is
primarily designed for page cache eviction, not swap cache.

To make this robust and safely adopt your suggestion of using folio->mapping
directly, I think we should handle swap cache folios explicitly
in the main loop like this:

void free_pages_and_caches(struct encoded_page **pages, int nr,
		       bool try_evict_file_folios)
{
    for (int i = 0; i < nr; i++) {
	    struct folio *folio = page_folio(encoded_page_ptr(pages[i]));

	    if (folio_test_anon(folio) || folio_test_swapcache(folio))
		    free_swap_cache(folio);
	    else if (unlikely(try_evict_file_folios))
		    free_file_cache(folio);
	    ...
    }
}

And then we can use folio->mapping directly in the helper:

static inline void free_file_cache(struct folio *folio)
{
    if (folio_trylock(folio)) {
	    mapping_evict_folio(folio->mapping, folio);
	    folio_unlock(folio);
    }
}

This way, we are guaranteed that anything reaching free_file_cache() is a
non-swapcache file folio, making the direct use of folio->mapping safe.

Please let me know if I am missing something here.

