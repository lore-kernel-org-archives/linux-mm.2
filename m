Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399FDD3B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 10:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5856B0005; Mon,  8 Dec 2025 05:31:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756A36B0007; Mon,  8 Dec 2025 05:31:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644FB6B0008; Mon,  8 Dec 2025 05:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 52ECF6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 05:31:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3108160A1C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:31:05 +0000 (UTC)
X-FDA: 84195936090.22.C7F8A18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EDD02C000B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:31:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n/Qob695";
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765189864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4VBxsYf/aLLFtUfrWcSySFWRdZhUspJwMScjIFXpu4=;
	b=PlLtsIL3ETBaTze34idkCu0wBFYYHS1uKmiqWJR16F5+8+DhMBn8lLXI72AlARKPmRnqOv
	E9NST/jD/WVSZ7gB1FZv+i6vmRemH16F7C47q4wyJ35FnHTNbkXes7alyoDydYYTwc5wgq
	n/9QmAJAIxY3YSGYcrlff4MrnkvkaII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765189864; a=rsa-sha256;
	cv=none;
	b=rCikjuvSJ8NSpFVlEe54eKvi9DYbs0TUC5sisjbtJpN/gIph3VNJ4fAkzfAkFa3HOFKPL4
	2TN92bQxoC3DqzEfPtjG+JAi9FOyx2L73uTBMqvJgZdpCpi/q4jUrtolqIMTERokbGC9fJ
	gv15uA9sOO1AjTHANH70PONYcC0w/EY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n/Qob695";
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E868343B96;
	Mon,  8 Dec 2025 10:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418CBC4CEF1;
	Mon,  8 Dec 2025 10:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765189862;
	bh=MPhbQ8w2PifKk8ZZOySwJrX1kc9ihTIUWTezaz6STOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n/Qob695pgyiOrhNolFB/2eLD10InyU/e/1uUDs9SE9EXRsQr+EQUptNo30Xi0m0j
	 7iH9KA9sqrCVie+PBYqngneecGb4wSTl1YBbFHr1aDMiM/SvFIoYupUEATHT1HiL7U
	 WpgmmcBak+grdPOMuiBXumtlYInFe6OccQ6IG6ySpdQDpIdWXmVDysD+OfagiCMxdv
	 fRSUQSVnpYaQVLs2r7P1Ta4q8TeMBSvefGHij9EgSTq395BuBpsJWwr9uwMnwOdSdw
	 TCU59KjJVGQNq0u57c6lX0ou/hGoPjEYi3Fvp9DjKHhBs3p+OMHkX5LrImrduMtBAY
	 c0atgL1MFRgSg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6FE89F40079;
	Mon,  8 Dec 2025 05:31:01 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 08 Dec 2025 05:31:01 -0500
X-ME-Sender: <xms:5ag2aflgg-acM0NFDRwtBqWcll-CxCkWcbJKfBAbOS8ORZtuMP45MQ>
    <xme:5ag2aZplvCaT8rVhuEPT5h8GTHYOn73g_zCRnMJlW-O86ncm80ShNF37ngOC4r8HU
    26BUkurv-Tp19SfEjY5-kiNg-lJU22baR_wLpwrc-5vJd-_yEz5XwQ>
X-ME-Received: <xmr:5ag2aek0BdXCKYYCL-YCtZqLXp6t5tyDzuebajliYXZPtS8tu2poKtGUT0BdSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieeggecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghkph
    hmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehmuhgthhhu
    nhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphht
    thhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuh
    hsvgdrtgiipdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgv
    rdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:5ag2aaaojk1yMYZUmuR4gcwcj4Nzlr6grY8mKIHbxxgIQ5Z4EjXjEg>
    <xmx:5ag2aSF2-71kqmjbmPvB46sRM-Ms6Nf6m09bhPfmHwAHbI3_YXr3Dw>
    <xmx:5ag2aVNajbfjPDA86e7Ow1XGd_sJep1qy6vq7YfbTw8_YIT6H4UUkQ>
    <xmx:5ag2aQxEmm-vXUeuqHyqJEHpffIBkQ1Z2djO2MC1s3XH_sfMuyENaA>
    <xmx:5ag2aakJS9SKMS1Fr164VYepjZi8wwszVq9mjeWefIgC3C56YIjFfc9E>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Dec 2025 05:31:00 -0500 (EST)
Date: Mon, 8 Dec 2025 10:30:59 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 05/11] mm/hugetlb: Refactor code around vmemmap_walk
Message-ID: <4zxckhvzzb6xag2pxcu5eimeuru6iauae4dlar3mmc3wrrnbwq@ddbzmgjuxego>
References: <20251205194351.1646318-1-kas@kernel.org>
 <20251205194351.1646318-6-kas@kernel.org>
 <3ed10ea4-347f-4d01-82aa-1d92d2804ced@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ed10ea4-347f-4d01-82aa-1d92d2804ced@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EDD02C000B
X-Stat-Signature: yu7rwizszoxanfxjtwapnsjb6m9nu737
X-Rspam-User: 
X-HE-Tag: 1765189863-868390
X-HE-Meta: U2FsdGVkX19vz1zyO+YNpLHUbjfLNnYdGHUxtvX0/afJVNjHNx24k0h9C365DBBVtse1oYPeTwX2Je750v5yHjAD5dHZcZXurYMjKfYUyhVGxp1cvpYWfrdYcczGVkdMuMeoG1WsUQfvsupCTuzpHhxVrDQgDqEv+k0sazev7ov8e5Tu3giKnLbxreYvlgL2dyOqu0oQQVzIwM3vFy3MHGEX6NZx4MTz04MyZU6NOQ8lSAgffHVejBLFh3QyJYPcLtaI2gSgYei8pPLYZhK+jHKLjpjWoca+SOPOP+SD1EnpZYY0nvgOMd6xXwLzUd1VE+69b/Gl0FXgJr44tZWccdabd19UDBaEJvQfDtp6x2MusWSr0SQb1/7nK/bYWtAs3pTYeDMzEqvUXzsbjbAFFODvYjRPq2lXSWfbdL4SJkZjhWL1wiPjfln3eyIeEo6yhNFCzK2DiZQ4BCN9bDa0DqBZKWuZaF+pa3GhEJ3kHWOFIYGwLJhexy/eNriXoigi6JQa4HrrfAk8Si2AByBbm29nhAFNdkN+kDYTZpjir6R0hAtS6eZdOf3WNoOOFCGISy6HhgaTkUY5As9+9Sfwk0flYPDusZHOBqKk8dher7FPnjm5R2nDJxzjnQi5dbn/CIkNYjPee8Ix0NOs4ylEcg/J/umL//lE4HFmpDtIH6Izrf1Jq34VqlcKOePqavIpZeD0wDUDq1HAjgyVJur7yG0lIGBWkYmAI6ZZCOH2ZqnbtZ2+9YRHsKlg97PWtjHMLLtuRlZdRM9cYjICTOO+XB7BQ+GIZVi2acGhKHk9+JnRrlfD21aTL/KpHp35US8POzpC0K65ePrRzr2D9jjt2o2OmC3Y9kVOzTFVx2ZpmBfqCy9OEuCck/21iUmIJiCTfuP7vjTL1ArE7ib3P9XnuiJgfzDRrFvMhUcSZNiAPL+VamFgRO0zsGqr2u5MLo93nCzr64T6bdYa7zpfbya
 aNYz4JDE
 ctOQ3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 06, 2025 at 04:42:30PM +0000, Usama Arif wrote:
> > @@ -308,7 +298,8 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end,
> >   *		to remap.
> >   * @end:	end address of the vmemmap virtual address range that we want to
> >   *		remap.
> > - * @reuse:	reuse address.
> > + * @vmemmap_head: the page to be installed as first in the vmemmap range
> > + * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
> >   * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
> >   *		responsibility to free pages.
> >   * @flags:	modifications to vmemmap_remap_walk flags
> > @@ -316,69 +307,40 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end,
> >   * Return: %0 on success, negative error code otherwise.
> >   */
> >  static int vmemmap_remap_free(unsigned long start, unsigned long end,
> > -			      unsigned long reuse,
> > +			      struct page *vmemmap_head,
> > +			      struct page *vmemmap_tail,
> >  			      struct list_head *vmemmap_pages,
> >  			      unsigned long flags)
> 
> Need to fix the doc above vmemmap_remap_free as it mentions reuse.

Ack.

> > +	vmemmap_remap_range(start + PAGE_SIZE, end, &walk);
> 
> 
> I think this should be vmemmap_remap_range(start, end, &walk)? Otherwise if start failed to remap,
> you wont restore it?

I think it should be safe to keep newly allocated vmemmap_head there and
free the old one.

I will add a comment.

> > @@ -592,9 +550,21 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
> >  	 */
> >  	folio_set_hugetlb_vmemmap_optimized(folio);
> >  
> > +	nid = folio_nid(folio);
> > +	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
> 
> Should we add __GFP_NORETRY | __GFP_NOWARN here? It was there in the previous code. I am guessing
> that it was there in the previous code as its an optimization and if it fails its not a big issue.

I removed the fallback. Being noisy if we actually hit this in practice
makes sense to me. We can re-consider fallback path if we see it being a
problem.

> > @@ -602,8 +572,10 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
> >  	 * mapping the range to vmemmap_pages list so that they can be freed by
> >  	 * the caller.
> >  	 */
> > -	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse,
> > +	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
> > +				 vmemmap_head, vmemmap_tail,
> >  				 vmemmap_pages, flags);
> 
> The doc above this also mentions vmemmap_reuse.

Ack.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

