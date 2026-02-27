Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3DDCFEFB56
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F5D6B008C; Fri, 27 Feb 2026 10:20:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163C96B0092; Fri, 27 Feb 2026 10:20:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0661B6B0093; Fri, 27 Feb 2026 10:20:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E293C6B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:20:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8397C21D9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:20:15 +0000 (UTC)
X-FDA: 84490597590.26.7D8B629
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1748F180006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:20:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BP9gWk1R;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772205614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=re+X6ck1AQZQchao0ynbIryXcVgPOwh7dKHH9EvgBr4=;
	b=Uk1A3n/4/fRzevunfh34ElXUZ8jN2HWoxYVU0DjrqnVt21RK9i7l82ZwGU+GzVJS2BnQDz
	RtqyTvBEYAHPcLVQ9NSQ8tV85laQ+a56olMDGVKetFjg1IfjxMm2vPc5hcTYKyJbsecRfk
	3KLTfmrTmYB6zOCppK+li9/iEQGP09U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772205614; a=rsa-sha256;
	cv=none;
	b=I/XwczPcHaN2V9nLB1GlXHWbOhwzjqbCSgeWliZTqAl194MhOAkT7VhrP9wzEq+LzIgGgA
	aw6kAoAGjTGbPYqeDiv2lbARa8jwBgSs95MiBNdDfK56NPD57nQGEa4v++nP9gyzAve9Dn
	WLiMxTC2FObT4v3YmPmopFmffinzRXU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BP9gWk1R;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=re+X6ck1AQZQchao0ynbIryXcVgPOwh7dKHH9EvgBr4=; b=BP9gWk1RTiW1qovhNGxhD9zEDq
	H24UnepRzhoEGp8jmVB75TB3tgUrUkwOAV2s9QulxkEWG6xFpqFV+BljiLpJeXGcWUKEFvcaq56lu
	UY7cbVSBEONJ5NmV88jrLLgL7aTMrnsHfRWRXhiQPguUjSctEqAFP83fM4tESFmHx/8kivPpdgi/y
	z7+zCF68ep7RIKRgMbJR6jrtlBmzgQQpUeA1dOv0RkmpzZF55PwtEjkyQUQcWmBd0J5Uf8cj9Uy7T
	ktLJUj8cXYEevOxSRDdzzqgJh2xXNECvf7M+7fVZgcCO9/eaovNg6sKxAryWF5DSt8RGXTqA0TxDC
	GB0qG6UQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvzdC-00000004kz2-17tX;
	Fri, 27 Feb 2026 15:19:54 +0000
Date: Fri, 27 Feb 2026 15:19:54 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Michal Hocko <mhocko@suse.com>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, mcgrof@kernel.org,
	gost.dev@samsung.com, kernel@pankajraghav.com, tytso@mit.edu
Subject: Re: [RFC v2 0/3] Decoupling large folios dependency on THP
Message-ID: <aaG2GkICML-St3B4@casper.infradead.org>
References: <20251206030858.1418814-1-p.raghav@samsung.com>
 <aaEsOu0hgCUznzl3@casper.infradead.org>
 <8ca84535-861c-4ab0-a46b-5dfe319ac8ac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ca84535-861c-4ab0-a46b-5dfe319ac8ac@kernel.org>
X-Rspamd-Queue-Id: 1748F180006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: a9t6m3kh77xjcbwiu9ukpiryi7n5t4wn
X-HE-Tag: 1772205612-979465
X-HE-Meta: U2FsdGVkX18x3LGErD2xnce++VqbMoHLIMQLdp8pTpSZXQdYg6jmWDbsl5yK0cDmQ1scqWedKxDIER9VR0b/+dgwzLVdJbCbZbcj8/O8T5vXUod28BlpTn87rdzMlHR4M2ZslTd0F28nH44qqBhShornVKVRhoLs7qphknGHgzqTcQruYN12v8S5Qsv1ky5HOfJPGEW9VMawsado/MoqXIpUBP6g0MRHkuv80n6Qaa5WWHkMep9/6j0dWmF8DqUrv/sWI1w3as5TaYz2ptOVqVHjxI2UDFfG8ZKzXhe3dg3p+4QuztpkHIqjap/One29kDUuJvYPCMAXiqouM/NTivRwPGMFLdO8QlJ2fPqCf4X7x0sFSIQrHLYFHsejkOCF+F2oNMRaVnPiMyz/uMUT9Gj5eJWxzZYkTtxbEdmEftHjen8yywTX1uGdlc5YqYqk0AY02oymUv2uoJrHSuT0OpUaSuNgdQCy89e8KBPYyLcPtgisOE0O5YB93xo4hwDhM7yDReHclzooeHFm6iG/KoM1VKE7gp9g9H1UiqCZGGqbQa12rEEe5Hk1gMW5knh8EPFmO/bQdp9h11SC9Uyny0eJiYYFZKGMBMn91fRte6nMXs+D1iSJ30AlMew/PgoxnsnWMbhCPTqiLhKCaTzQ2nG7XF4BK+Zzm03qC3BgZeeNug1UoNMwhAfUb0TyWzNVExGhdu9uIdrOl1qdjzl1IPGNonJ3aLWn9xnJ6LP1yxdsfTrWuWuJyOUP+H58vJ+FUhEg3oyjdQq64FCHFmmDQ9hAxjQsGklk3GFJS88d2GxcDEFflJJEe8zi2oMOv5UeNZ50nksdRsWSeVxRDUM+rvrmInmJKowp3Zb9ay21jlswE0mMwpuxgAjLEJPENXpdv9hKHznF6tujx4qBn6GdR1kWcYN37YOpKJEY0jW3v5j5X7JWNi1oLarSCjNIU0odoto+suAtgp4RtNOrkbd
 AkJo+l9V
 XOKf7K9jbQrtWGkqtwLX52YxkEyeaBvo+sLIft/o9w3MCApLEeSsCsFn39lNSY/LdgQVerb/sy9Ra/9LzmNtvf+JgMvfTZ+suKRCULo2Kh0Zrrw/YKTTrQzBvwTEhKhzgCLuesDGCexfxkB8gja4lgNV9z9gn3FJ445fjQAq1cxz0bc7Ui1T3phaIAuyqZ3e/PoDbzjha3eM4b/FGq8O7Qw/Aavf6Y/5cNie83j0ZCy0THfJ3e4rMiMufrtn2UyfWdQvl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:45:07AM +0100, David Hildenbrand (Arm) wrote:
> I guess it would be rather trivial to just replace
> add_to_page_cache_lru() by filemap_add_folio() in below code.

In the Ottawa interpretation, that's true, but I'd prefer not to revisit
this code when transitioning to the New York interpretation.  This is
the NOMMU code after all, and the less time we spend on it, the better.

> > So either we need to reimplement all the good stuff that folio_split()
> > does for us, or we need to make folio_split() available on nommu.
> 
> folio splitting usually involves unmapping pages, which is rather
> cumbersome on nommu ;) So we'd have to think about that and the
> implications.

Depending on your point of view, either everything is mapped on nommu,
or nothing is mapped ;-)  In any case, the folio is freshly-allocated
and locked, so there's no chance anybody has mapped it yet.

> ramfs_nommu_expand_for_mapping() is all about allocating memory, not
> splitting something that might already in use somewhere.
> 
> So I folio_split() on nommu is a bit weird in that context.

Well, it is, but it's also exactly what we need to do -- frees folios
which are now entirely beyond i_size.  And it's code that's also used on
MMU systems, and the more code that's shared, the better.

> When it comes to allocating memory, I would assume that it would be
> better (and faster!) to
> 
> a) allocate a frozen high-order page
> 
> b) Create the (large) folios directly on chunks of the frozen page, and
> add them through filemap_add_folio().
> 
> We'd have a function that consumes a suitable page range and turns it
> into a folio (later allocates memdesc).
> 
> c) Return all unused frozen bits to the page allocator

Right, we could do that.  But that's more code and special code in the
nommu codebase.

