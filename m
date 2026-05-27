Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83BFECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56096B009D; Wed, 27 May 2026 08:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06DD6B009E; Wed, 27 May 2026 08:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C6E6B009F; Wed, 27 May 2026 08:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 939736B009D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:19:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3811712059C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:19:26 +0000 (UTC)
X-FDA: 84813105132.20.FF48044
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7434140014
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:19:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779884364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aQcLKj4QHULtvvOFxjPbv6OfmtiH86l4vC0X7se3eTI=;
	b=ngfaJNdKNwOu0kcY2iKAyWxcSm4Fdq9cK9OzuCUIBOwJAJ7XR+/aTZQDNUO1O/8UJ4+QP5
	+v3WfNoZ6W+62bCFST8ldDW95cAs/2UvYUSCwd1PdvXizl2M2MJsvcBU/6nYiaiWFcRPco
	KgkHZfa96Cr2vyBUV662OA/W/v15JGc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779884364; a=rsa-sha256;
	cv=none;
	b=qX6k55lm/xgq7NB7EsNSLEa7Bhs3upfNZvPvXyy67Uv30agki0hffTwT/jabvovFUr/pd0
	/dha2TNsMlDxcNvXaZ2w2+8WELXlrJr4yMNV30CK0t7l3N6PyzdPhCqFNyfniKtPrV0Kow
	hecxlPtExZYQ0F4Z8aVankB6rIXdQTo=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 88C4468BEB; Wed, 27 May 2026 14:19:20 +0200 (CEST)
Date: Wed, 27 May 2026 14:19:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: revisiting alloc_pages_bulks semantics?
Message-ID: <20260527121920.GB6079@lst.de>
References: <20260527071816.GA17632@lst.de> <df21e8b0-a67b-4b71-8178-91221b596949@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df21e8b0-a67b-4b71-8178-91221b596949@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: h5te9z3cnxkqpy8x4yghi67w6t31rsbw
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7434140014
X-Rspam-User: 
X-HE-Tag: 1779884364-647749
X-HE-Meta: U2FsdGVkX199ISQTRTR9ki4DHlctqKAV91bza5THU2OTSZFF3CsU4423g2A1xce5VomeD7k27fJJzjvrhKCqDISsjg9F2ErINIPpfpb+2Stia8glLxx2d3hJXHMtOaCGsHt/BJeuO62dy36I6vm4zemzBEk36fPBv978OOmGigMq475pkK2B6DyZdyGp5RNI5Ml2EYOtPn7Ip5GUmnyPoOKct2YFlwo8hofoT21Lg5gmjw4U+buI3CaN2LorCNLN/l7xMYRtEUfgAlUbkj00f3aIea5bLs4vxuwiQ4X+HunxWkT685AOYwnknBMnF+cuP2JnBzTaJgXpIiJgexO2D3t+AkjhccFtkXziOQb3DFNyS11lgW31YoNvTVcveeF9G+AKPO78mapSpOtOsCUNpglD6KlSfeK8mRiFIgcz5LhGEEexGHf4q/41i5fv3XjRtUZAy/7QJu01GhYnfJhAJy7B3cAsHpyBotoITloYkVIHfs2Z0g3p+ICcoMwgJRiQhpX1LjjlYdX45CZtdcqeKEcC0umzzCq3bkkNQWJgo0AQdO/YeLtCRcEaKtBwHA25gXMV4t7OpHKgKyz+hKw4mRIz6qnpniPtf/c4yM5hnarUuxRdjdGR9GsHYx4IS3udZLwLmBVJIhYUpbB7enNxgsNTFl/2qECFT+LhLT6RjsBLwENr1eNNtyquLGQRXSF0u1kSAMuEHbIkVScoGMIfldEMbesUHWfVL75pneAMLveSYU6DIb4q6jN/1NfdYDACdwRGLpJojagqgXXmJRUZI10uBlqTzQ96DWBTEJzcp62QEKr1NIc+73IWBfT9VY2X5gHb0jjMHm0v45dGOHfi2ZIBhehKT5P+NdDyBI3trZWMseXD9ebvxRpjDlAmDNEtnflObXkDTv8gzGpY9HdkxYq3gGfNEjOVlCqGOI6GxT1iXGWMt0APsgXNFJEMmEXjz39LfG1+3yuSB0q/W2u
 8h9BtQuv
 9Sd/GqmSfQGnHIL4xyV2YhlirH4qzdamhM9YWgN/Vabalal7GdRktawCp6rgFMa3hm2g3nBiX72hlNwnfsM2ZwlPw2sD+qVteH8GFR7d8whjlu57SSUTEfnac2pkKR5X2NMuC07Aq/qfQYHW5p6w1VKgWivOawPksVMXzS9tiFRIC+zFb2/Nh+9Af1kSg6uSse+Ay
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 12:06:08PM +0200, Vlastimil Babka (SUSE) wrote:
> > alloc_pages_bulks can do partial allocations for some reasons, and
> > users usually have a fallback by either looping and calling it again
> > or falling back to single page allocations.  This sucks!  Why can't
> > we get our usual try as hard as you can semantics, requiring
> > GFP_NORETRY or similar to relax it?
> 
> If we do that, do we keep the possibility of partial success, i.e. return
> how many were allocated? Seems wasteful to suceed N-1 and then throw all
> away, if the caller can use a fallback only for the last one.
> Do some callers need all-or-nothing semantics? Should a flag indicate which
> one to use?

A lot of callers (but not all) need all or nothing semantics.  But
freeing already allocated pages is the not a major problem - the caller
just has to add a release_pages call if it didn't already have one
for cleaning up later failures.

> > There is one single user (svc_fill_pages in sunrpc) that relies on it.
> > For everyone else it creates extra burden and is very error prone
> > (speaking from experience).
> 
> Sounds good to me. Will sunrpc be easy to convert, or should it be another
> flag to opt-in to the current behavior, that it would use?

I've added Chuck to the Cc list, but from memory sunrpc actually does
make use of this feature and he objected to previous attempts to
change it.  So a first step would be to have a lower-level helper
that works as-is and a wrapper that zeroes the array, even if that
doesn't feel as efficient as it could be.

> > 3) page instead of folio
> > 
> > We're allocating folios, so we should have a folio API.
> 
> Hm, folios initially started as "base or compound page" but then the
> semantics shifted and now they are also rmappable. See how
> folio_alloc_noprof() does page_rmappable_folio(). The differences might grow
> further with memdesc conversion I think.
> So do all the callers actually want folios? If not, we could have both
> alloc_pages_bulk() and folio_alloc_bulk()?

I can't speak for all of them, but many do.


