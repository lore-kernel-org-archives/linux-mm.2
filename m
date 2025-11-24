Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98416CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 04:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EEE26B0011; Sun, 23 Nov 2025 23:28:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F926B0022; Sun, 23 Nov 2025 23:28:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5716B0023; Sun, 23 Nov 2025 23:28:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BACE6B0011
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 23:28:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 282F212F958
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:28:30 +0000 (UTC)
X-FDA: 84144219180.18.3F2C184
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4075414000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:28:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YUZEid1p;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763958507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srYDs3N17c/LMXsTNhpR4pAyhQEFbr855gNJVIBMtnE=;
	b=G5DXcrQINQBHjBr8kbJCydvdEDPb1qjOcvrRHed57yIL4YFjZpPZsY9uk1OGDn0CsOYCR4
	Zi2Bs0izU7tXFeu91vaAwskb39W1WYfVkvyd6QhQXv5/VY5sy21z7i4umdumWhGqE5ruai
	wxacQ7o5qCY+rylgCtkM8+I4++6GUr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763958507; a=rsa-sha256;
	cv=none;
	b=8fuQidtFYBHkP6NBRz7YF2tjMPw4n2khV2DUnE0H/AQFAl1MOlNVOtd3Dj85pYhAoQRsza
	a1o+JjIt4EyxZ8kN6oN3oz3eEGyD8iXMXtm0+sYmvD0klmTIgqy/InYGsK7EJHoMIRpusK
	N8inPyCskE+CmLHmQfwFmPARMFNrUQ8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YUZEid1p;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=srYDs3N17c/LMXsTNhpR4pAyhQEFbr855gNJVIBMtnE=; b=YUZEid1pl6TcQAkWbdpljd9vCD
	d89lFjHClB320Dz82F+kc0CWp8wzIqCZ01lpJWSW7+n1Qg/hg4dyf3RcaZP6d1S7FWSdqp5X8hcoP
	5iGyd/qfn66uIsyxM8/KuL6mse5tQycA/7Py6Zj4w5rPv4sSYUn4O1vqE9EO3izBaU9U66JxmNXcD
	OlvM5d08+m/Guipv91qMe4erL6Wzf4Yd+c7NEx6w8NahIs9tDQMzCZjcMPk1MMB9XDM/8EH1p5tO1
	qQdr3IxtMaz27qg6TnhkCESAs2NWxzC06pNSfpD8+N6H9fK7+pEwZhz4iW9d4JeWao9rAy3RY+2X1
	98TqDC+w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNOBY-00000006RgQ-3Vfw;
	Mon, 24 Nov 2025 04:28:20 +0000
Date: Mon, 24 Nov 2025 04:28:20 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 02/16] slab: Remove folio references from __ksize()
Message-ID: <aSPe5P9Oo9ToafiS@casper.infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-3-willy@infradead.org>
 <aSPDauAEYs_RVNW1@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSPDauAEYs_RVNW1@hyeyoo>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4075414000A
X-Stat-Signature: txowgmosrwtpfixgi1gt9c3wpz3qnu3h
X-HE-Tag: 1763958507-740454
X-HE-Meta: U2FsdGVkX1+TxYgezSA8vxsIfRMcWLYGerWo8PNbTkZEh4opkRwnNJDDov9B6qqVMATx1XkUZEeteFoQjR7YPqMU1FUtPEMVBTlheSfat8Vsx+Y/nl6EI+D5ZQZQohVpmTXv7+pO1/fnd/52wbVnE0WgTIOHJwqhcfgH4GSWX9VLdUMxZr9WkUOgT9GJTVcBehR4c5dadmw3B9SNPCbqT+7CGZF34RO0oL/L4oTZjnRhRnjfDQLRN1lLCQReV+w7JQ5roQgw0CiqaFoxClxV4wAGzwti7hmzOMefanuveUeaZWZ+C3Kezjqz4uLDp4EkWJEn3ebiNkWWxozSISd55ZRwbPW1q8m4NJy6qxhJtebwC277KA5cjtmKiz1KC4hQPrY0MswjzMMNXL9mNH6pTwrdLdGydauhHjfsiJWLn3I161A036/5or6D5nXqG6WpOk/+7fx5LMGixS/D1/tUgCCo3Tpgsd70Sv63oyN7DcgcIHtTO/xsN8MCu4sGj2ByE5nhBEd8ZbjsHsdWnsbmERXEDyuo3IdIK/0YUikHloAflmJqZDqBnlz6Nwo8B1/5qSu6UG4xiOzeTJJU9UK8OfH8F95Ab08t0+7ZqNVfqqTy4d7kmIWaB4ij6GLOwxQzUHkBRYySLnabnmGvxIS90jHXsLV47+RvUYkRJ0i3lISEBiipKzUmhazxFu7Ghzk27ZYrn7VwU7mPezgr4HZLTOrlxuDsT+mt5VoIxyBe2uAzOmO0g7qjH23iAUlzaOzxkvFBOoOMCd9qfqotT1cxRORGnrDQw/rMOTQnPTsHWElfcB1QaYLWRXsq63IdidR492gBThF7gKv3f/siCY/pEcXiVdCwE+k9w3LcgbJ4AE5zQAqbE22X0depPjc9eMzCOk1ASJDGFCWG4LBmkIepU0LtZyKR8slcp7XPCaoSt+UjnGSlkjArZbff3kwXdj2Igamv1sxIi1rR/zjwwp/
 3Ijvt2V2
 U27d6sYN8hbWVduDZkG4MkK0+4ljXweEqoBfBveGwjfA+nSdNLz8Y4ucy5ZYxw9xqeOYnw97LYgg73KHRzlUCJDZfsoWXIU38btRp+ROZt+bKkMxwLoHB9aVjdM/Bm8RfiU5sykFdILU39cougAgGmfbDjC7uBXxnMHxR7V9duBUX1H+eSwTUfLPOGeOvlm83EUTyxA7Z5zulNjTKd7DuQUrFSTgnPygEg0QsK2+r14rw46HsUxC3cucy0rXyzJZMdVUWAKFiiphpSQ+PBB6e7OZDNYU+ACVXWcgwgvJIU1T9DNc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 11:31:06AM +0900, Harry Yoo wrote:
> >  size_t __ksize(const void *object)
> >  {
> > -	struct folio *folio;
> > +	const struct page *page;
> > +	const struct slab *slab;
> >  
> >  	if (unlikely(object == ZERO_SIZE_PTR))
> >  		return 0;
> >  
> > -	folio = virt_to_folio(object);
> > +	page = virt_to_page(object);
> >  
> > -	if (unlikely(!folio_test_slab(folio))) {
> > -		if (WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE))
> > -			return 0;
> > -		if (WARN_ON(object != folio_address(folio)))
> > -			return 0;
> 
> nit: we can still have these sanity checks even when we're not converting it
> to folio?
> 
> size_t size = large_kmalloc_size(page);
> if (WARN_ON(size <= KMALLOC_MAX_CACHE_SIZE))
>     return 0;
> if (WARN_ON(object & (size - 1))
>     return 0;
> return size;

We could!  However, I decided that we had these extra warnings to catch
some uses of ksize() on non-kmalloc-large objects, and so they were
really caught by the new:

+       if (WARN_ON(!slab))
+               return page_size(page);

Now, you could argue that we're now not warning for ksize(kmalloc() + N)
for N in the range 1..4095.  But I'm not sure it's particularly useful
to be warning for those cases.

I suppose size <= KMALLOC_MAX_CACHE_SIZE would also catch an internal
bug in kmalloc where we set PageLargeKmalloc on a small allocation,
but given how few places actually call ksize(), I doubt this would be
a useful self-check either.

