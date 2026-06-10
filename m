Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D8DBCD8C90
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 18:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A389A6B0005; Wed, 10 Jun 2026 14:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10196B0088; Wed, 10 Jun 2026 14:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925F76B008C; Wed, 10 Jun 2026 14:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 820A66B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:11:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2397A4026C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:11:06 +0000 (UTC)
X-FDA: 84864794532.07.C818D02
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id 572D22000F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:11:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="DouEq/+y";
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781115064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCD6fQlo+amCuh2MJv98stulEbrclG69/C//PGhk/Sw=;
	b=NAZjWOzZmHhQNR4lfXL6nzUoJ/0unxmfo9t6FlxhqV585kQ2qbhJz44XlVuks/0x60wciU
	pR4+mxZIHE+TkyqZUcd7LZ04dKSXWONZFLHQFalEiZP+IrZRYnxHRBKjf+FkPLX6UD/UV9
	0+aZcqa0VuaeoWDbSozZygyz/c+3t6E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781115064;
	b=anunbfj0daN5EUzoalJzLf0wN/gVQtE0FHSkLL/cAmqh5CEhcY52cxScIcajM9uvGURQfM
	xuoQIpZyLWLx4AMKnB2+mjU9A9rZI2i7L+77D2gyptsQGqVnfV4zMnwkeikxhy8TbnCRcO
	pSebP64L2fRyZjHoiwK0Jdq2V9aA0Bc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="DouEq/+y";
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cCD6fQlo+amCuh2MJv98stulEbrclG69/C//PGhk/Sw=; b=DouEq/+yDo0pRJvgQ60O6kXBai
	Ukq/D/vSXod6hUKOikuCeKPo8Me471D5X/InNXt9Mrw+d3nqA2q6LmVviXuqIRJzb65ymoXVaC6cu
	I6I+MoIg4gwlIY9+c4q1/WILLKuesO+b4sus1NrvzKylUGGa4Ycq3nFf6n82n1PIdefK8QxRK8C/T
	sow1zS8+CmxK6d94lM+hTMbNCTKWsosT0gqP88ddvHWhb5PMoZqydmsOBLxFxCxpkbMY9S6gxWIfE
	AHD8TvWg6WlBgMeSfQW4RU0U0yZCJ2iwnv96dTNtAd64zHaFESP+O8jl4LDzmO3a5APYn9T4fPEjG
	Swb+A1sg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXNOB-00000000QeG-3Mrs;
	Wed, 10 Jun 2026 18:10:55 +0000
Date: Wed, 10 Jun 2026 19:10:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, sw.prabhu6@gmail.com,
	axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, dave@stgolabs.net,
	dongjoo.seo1@samsung.com, Swarna Prabhu <s.prabhu@samsung.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
Message-ID: <aimor-73_1ij8Nbx@casper.infradead.org>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
 <c924fb59-be47-4fa5-adbf-a50a831ccd7b@kernel.org>
 <aikBIESiJftxBdfL@infradead.org>
 <f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org>
 <ailLu70plC9WK2dB@infradead.org>
 <d80bb796-3cac-4de2-8bc2-cc799e5bbeb1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d80bb796-3cac-4de2-8bc2-cc799e5bbeb1@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 572D22000F
X-Stat-Signature: etfpry9xxzz197tcbipd8y6tsszoqqam
X-HE-Tag: 1781115063-929071
X-HE-Meta: U2FsdGVkX1/UY/5UFnzFIH4YWKpM0Q8srsV1XblKWYVf6KaXD4mUZsE2rR9Y+vIDWHyYeBxm4Ybdw6jFSJwCTtbBTbeOdibrUZwM5KSQSKqdlOhvkWhhO6e5rKyiIH3jRr/x/pub1zGIB/PtzIXTV7vpLqEXfprXfSXTubM+kGxnXVxKw+CfNzgS8QzeQ0Aq7G8bYbJW6cQIm7dUUZQ4Hwl6Fy8ZymMvCOrUvPbq5VSrKob/qTSTwc5wa6JYxAPrWnuK2l+uXdmZfsICSPdtrB+0l6Z1+g4zgv0CTtrXyTIEBLtMUY30IyMDjeVEufgv0qR1dZ01CKOqz7D1ZjmQsOzrKStwL/FCa8jt8nWXHguboVKQgR27eVrQFw/+pm9HOehxSQe3Fd1PruhFRciFB3RTKmRFlQAvm0bKh4iGyIl0Q8rwH8wqwmzSsxGO11iRUMD6Kgn2wScG37vxblEm+Vyr7oP0G+6HxM5568HvcKgra2a+TK+vZ2WPjWdO+A1WnuhosDpz8c7YCcBFjgJtfZw3HgsY5821yl6ZDaf5mu1aS/i7o2KFIrpbWywqhWl76aJpr2q6do7pT1IX4/+Rakr0nGbb3Vlp1CXq27aOIJta3P2Gu32acOYNFuPLW8vwclt8JnCMTJ4mFxJalNzfQuJYlDXTLQEM5gdG1LOPzdYSPEj0rHb5LNtmT+WiBNJ1mIM7iLlrEhjWhMLzE7lTIwUbWgHjSsSUJfn1yiRLz9mCohwIm1CI1mtncxQSYu+jpg7FXFXqK1Vezeiwe5ULCVzIRlHOK7LOexN2knjl7eSAJncatGbJ5YbHg8k0kpnpqwug9MCiAq4t5LGhj+FQM8pL2prSgdkqYDs01NOy4GrLclrW/LdM2hkHJaPBI27S+orcTyT4WhiS2Kii3GUoACHo9wS0tHCRTJ7Fd1DqkZTU8RAQtvUFHRvjBH2owBUNw9Irqnq8/2NYwVx4qBy
 XrVo6Pcl
 s1N27W26P5ejXlSNXC7GLlGrhTkoIn+SlnwRif2cCCXu9RopLDgtOboeRx4xlgFw9+SWbW3yqjl6865M4S00uvpeapwriZhBlUG6GnHR2Gx6X2A/OA7LLW3wxhL3gCzlnmS9rCt1cwtH5YDlSip6CgJ3rZ6CXx3HRWjzdoFx0HIcaS16ouQQ9jiUDdHhPRNv04ZE5Cn/XOsTbuV0+4NIIbhv/EYFdTWoRjgVuyL2PeLk8JccRmDRofY4HwEEXrnRgHBsGliCEatk28lbUK2akCXWm0V7CAiKRAtcsQxm6VhxbpNdAxDiYRgNHHJaI3nQA+VKEbAQEbLD8p+dHqSKfzzfy+xAJ5G75s9QhgdLbGIJFLkvi92pkmP3kS7yvMhmbPEy+huKrF9A2nOIhI/u/+6Sj99O4FBWIounRCSqPhaxwOrg4KePSzQuu6uNdNKJxw9CAXJAWwqAdN0jrZVoz0LOv8m67+REs5SByZpPsF0Y1r1TfWe5kt/TyGA2VekQl3VZRxLVNssAAasM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 03:18:52PM +0200, David Hildenbrand (Arm) wrote:
> On 6/10/26 13:34, Christoph Hellwig wrote:
> > On Wed, Jun 10, 2026 at 11:54:01AM +0200, David Hildenbrand (Arm) wrote:
> >> There are some long-term plans on providing an interface that would abstract how
> >> you refcount something you GUP'ed. (because, some pages we GUP in the future
> >> might not even have a dedicated refcount, all still fairly unclear). But it's
> >> all not really finalized I think.
> >>
> >> For now, we could expose a folio+page/offset+nr_pages interface, where we,
> >> long-term, would not be able to return non-folio pages (e.g., vm_insert_page())
> >> and would instead, in the future, fail the request if we stumble over a
> >> non-folio thing in the page tables. That sounds reasonable for now.
> > 
> > I think whatever we're going to use for direct I/O has to also support
> > non-folio pages, especially PCI P2P memory.  So coming up with an
> > interface that support this ASAP would be helpful.
> 
> Yes.
> 
> I think we can keep returning pages as long a the unpin interface knows the
> right thing to do to unpin them.

This would be the get_user_phyrs() interface I've talked about before.

https://lore.kernel.org/all/ZbVO2RKhw-dLUMvf@casper.infradead.org/
and the long thread:
https://lore.kernel.org/all/YdyKWeU0HTv8m7wD@casper.infradead.org/

> Would there be users for a new interface that returns page ranges as described
> above, that would want to still unpin stuff partially? E.g., we give them a page
> range that belongs to the same folio with only a single pin/reference, but they
> would want to logically split that range and unpin pages individually?

Urgh, no, we shouldn't do that.  ranges should be pinned / unpinned
as a whole.  I'm sympathetic to "for this special operation we need to
create a new range from this existing range and adjust the refcount(s)
appropriately so each of the two rangees can be put separately", but
I'm not sympathetic to "we need to allow each page to be individually
refcounted".

