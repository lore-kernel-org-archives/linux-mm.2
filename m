Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1766CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DBA6B00C2; Tue, 26 May 2026 10:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF696B00C5; Tue, 26 May 2026 10:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CC96B00C6; Tue, 26 May 2026 10:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4DD26B00C2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:37:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 839654043E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:37:08 +0000 (UTC)
X-FDA: 84809823336.14.33830BE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id CB8C8100011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:37:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gOI0vew9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779806226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJaZ+OE0ZGmNTJCjsYLk6Pu4+0UCvjIDTJFLwXjyNL4=;
	b=s6E3H39WsYE0YJpypTTv0GBP8sDA/B0zYvdlhPm21yrkejQ8r4m0ZxviEN3p5TH1XSKFk3
	yBQH7l6+3Xc5EBVe9iSNXfjtUYyVJjw8FejNhSXDyLggoNLjOUM+L1sh/04A0iJoOQvGMH
	NQONJBx3At6ybMTOUDQRaaa7kNQWL/k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gOI0vew9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779806226; a=rsa-sha256;
	cv=none;
	b=ckgKBgoA0mdwiGPT/2xwucRDYC0bQJ+fgnZlxhjKcgvfKwPweVbwpCt1evL4hqIMtOFuls
	ayHjCFTltt2jN8WfI8TpSGYOdMT9MqORZxD8vJKKV/d5QisOWjm1jaw6jyp8DagsnZtGzN
	CnMQU3Yt5GapfL4HoMLqPrZujcXEDso=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bJaZ+OE0ZGmNTJCjsYLk6Pu4+0UCvjIDTJFLwXjyNL4=; b=gOI0vew9WF6yswl1zd53yvsYHt
	D3Vjm3LzNUc9byMS603ZNDkea548xyV8Oz9LZUAtwQJwZgExb8792DXfNFAhIZlANzn5/uD+kCyHM
	E+zqVWUXXH3K4s3oGjQ39g2kSndqH9z8xchUaZu2yxxOKjaDIW1JBBe2ln+SqSEcLZj1uflWbhL0m
	Av2QyEngm71fvI+SKwsmcttdl/T5m/bYU9ZDFz2llYcWOKgh7OedO+2vwvqLePzRzizjboxGu9ac5
	H44X8bfjfLaR8feSgjAxM+ph90jTnlmWkdDH9fCT5dS8h4qKj1X68fDf9Fa3W7f2pkiJSmwf3V1Qw
	kd8Qz7QQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRstz-00000001AVM-15vB;
	Tue, 26 May 2026 14:37:03 +0000
Date: Tue, 26 May 2026 15:37:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
Message-ID: <ahWwD0eqj3cUgaKn@casper.infradead.org>
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
 <ahPnX-CwVgK-9chp@infradead.org>
 <ahPxmSqT4Y4jcAbQ@kernel.org>
 <ahP3R2nH8-bHMVf0@infradead.org>
 <ahQX_JCgS9JWIhY-@kernel.org>
 <1dea9df9-18c2-46f5-bf47-abb3f088574b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dea9df9-18c2-46f5-bf47-abb3f088574b@suse.com>
X-Stat-Signature: tm5iyhc755cga7wfzjjkyr6od68emgez
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB8C8100011
X-Rspam-User: 
X-HE-Tag: 1779806225-377861
X-HE-Meta: U2FsdGVkX1/7L88J521ZSsHJ0486eXLS1SZtDJc0W4+4/eTvA8Ay4aG4MvUuxMyMqRa0NT+DtvIvhAGtRdezmszmWQ4HgqoBfmDFYpe9yEbRkxRPXX78qoKV+TGWMKacP7KmY2FoGcAztnDPGD8o2td3zY4GQjBR9zK0jK8OfKijkuDpBf+VsXNCXS6mGx5o9swCTRw4GHZnUncy79aERDWJHBj0cy4GCjBEUaPAz1R6JmWu4nYj/RYhH3X1an6EZJVYcHVNH/DJRpte4z0Y/qpexbA7TXRTyz0hXSq8DCngpoPIl7T6Z7I/Zj8PJhQa/uVz6T5wyWgD6O52JeInu1ossJRetqBrhZkcuso0wJZ2ruLLepfjGvgKV9ZC/mQM+4/arh3fKB7NF1b4S60IrRd23kkQGlrXl9ufITZ/46nEGN+ZajLwJS+KWKpEQkIWyuU3RWOjZ7Qf7i3aRsacIFNwwegXSMWbUwhlasqxIh0fMlzeFaLdWBKmw7tlFGjOpBswPa2p0OWHxFuph+dt9eacUe2GCWn4l9q3MUEM2iEK2y3mEe7fJiGqo7TyV6plekcNGq7tSTTFuMfEgYU+Ox5Leo76uJkm/csFoOvbog0mBfX9AIczimyGoMTElBwp/K5rIbQtQo84KBrmfh4H/ifDIL4IWeMhVAO1yKWZE1kSA9LwwD7SGXwn8ld9ga5sZKvl1b4cZ1VwDOg8or9GSQYXrj5rRUOo3DDMlxbkmqOVsJSIxy6gkPgbgpRMIMx/rhHcMrwLNY1WPklgNqAv9yUyhkfXAjx7RhomipCuwHRaiAG51kTQiSF83EqJ67UdZL2vLPJUqY9zB1N5e90imjeBLmPT/tm0fBi6YcnNpd+v9GiBNdpl1X4FW9N6myj7C2AreYyjp3qRvaP6NWC/w9SEsp0bP60PkSH+ZymRHF0ixz//46f9asxVCKfNM/VzC8l9XaxQo3EdbV3Hjzv
 E0lhi1w4
 Twr7j1J9qU4NrTZnR4WfybwvbDxWu5PskXFFkr8CjaqmiGuriabM016d28R0Okm3YK6JhDfvMK1RzVpBffecEYqp/x26fux/E8W+4iY9xYtJVFS+X35xG3sSyyLWi8ShI3rau6GAiJCf1Kga+F5BsTdPrYcSsikExsuPmmd0bBKRtQodZTo7Sz7Sw7C46UXW9PUvXewawtwZ7Q1WYosM44VDk9nr/GBQhIXq1nGscyOBigr8zFUK5oZCbTM5HTKKc9Y1UEFC0cehHeVFI6r2YCZO2nM2E0pTDi0nEW1IeBn+bDBJVvdxoykreizpnLPhE/XLGsT6DwDywKgS2JZqKtOi2GJyfXTs3REel
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 02:07:36PM +0200, Vlastimil Babka wrote:
> The main reasons for switching AFAIU would be related with the
> folio/memdesc conversions? If one needs just a kernel memory buffer,
> kmalloc() it is, even if it happens to be page size. Page allocator
> should be only used if you need e.g. the refcounting or anything else
> that struct page provides. But then in some cases the memdesc conversion
> would need adjustments at some point. With kmalloc() we can forget about
> this user.

No, I think this is unrelated to memdescs.

I've seen a few people say slightly wrong things about
folios/pages/memdescs recently, so let me try to clarify the end state.

I do not intend to get rid of the ability to allocate a bare page of
memory with something like alloc_pages() or get_free_page().  It's
just that the struct page associated with it will contain far less
information (because it's smaller).

https://kernelnewbies.org/MatthewWilcox/Memdescs has a bit more
information, but to distill it:

You get a u64 worth of data (technically one per page, but if you
allocate multiple pages, they're all going to be the same).
Bits 0-3 will be type 0 (to indicate that it has no memdesc).  
Bits 4-10 will be subtype 2 (to indicate no information about owner).
Bit 11 will be clear to indicate that this page should not be mappable
to userspace.
Bits 12-17 will store the allocation order.
The top few bits will encode zone/node/section like page->flags
do today.

That doesn't leave many free bits for the user, but that's OK because
most allocations don't actually need any bits in struct page.  If you do
want something like a refcount or list_head, see the "Managed memory"
section on that page.  If you actually want a full-fat folio, well,
allocate a folio, not a page.

