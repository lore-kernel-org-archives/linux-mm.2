Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C09CDCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF57C6B0088; Thu, 18 Jun 2026 11:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A572E6B008C; Thu, 18 Jun 2026 11:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F6B6B0095; Thu, 18 Jun 2026 11:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CAA86B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:04:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD8D6163B93
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:04:16 +0000 (UTC)
X-FDA: 84893354112.26.827E86B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81510C000C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:04:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="SF/PORqp";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pj1LJnEZThUPRDCPw/ddyQud/xNuwBpvVNgUlXrrtvE=;
	b=wUL9mV6HWE396MCyL/s41aMXew3BTGf4bFcokrcBdCaokMUXQNxORhV7BI3xiOq47K5FBh
	9eXnVaOYKHchmTFzao6ncIdi4sEMX2PD1M9am50DrKdioKcqBthkzOPLtyGvXGj5Q1VmMS
	rENJkbD/af+FKPMWMPExodWn1N9L4co=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795055;
	b=wtbjN9i/kYRoepXP7tMV5EdoN/esJm55e+97fd8+bVrcrM8K1PKOnfuPMx2M5i4BN4AQ64
	A/GM6uAo92E1gbUsgURFHbFOJI6tPk9PsjkiYyEtPWNQeANTE/dgXrCTmY4eVg+cWAyW+Q
	6dtnv5eegdu2WbKmb3ZY7+9VkWEIf8I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="SF/PORqp";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pj1LJnEZThUPRDCPw/ddyQud/xNuwBpvVNgUlXrrtvE=; b=SF/PORqpkg0kCgRphkeuENfFd9
	wCXnMjP8c9ILbJLdRvs6FLh3y1X2oxLMpXHhH/IsY2Sff4mcf0IpgB6qVrUhZmkUYuqlOf+0+Vf6/
	9z322tTOb9G9IWnsLzKzBgrLPajTeLfq32luz0COaSbynUe8v++U41DSM5fSz2P2gv9n8jgovrprn
	Ul5IJVBr8OHC0tyt/HuPgNbd0q9wjmP4ykVlAeXt+ZLjVNFrblsNyn5tfjlYuh1M3bxVbpOz1oXV7
	3nTcYg/jzOPlEDXZFmJNSzvWx8MaSlCskF5Hu/aJ7SGxoZW3bqubI2nLENqLyOzApaw2XQH8davpw
	hLW+UDTA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waEHm-0000000EdL2-1a1t;
	Thu, 18 Jun 2026 15:04:06 +0000
Date: Thu, 18 Jun 2026 16:04:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Anthony Pighin <anthony.pighin@nokia.com>,
	linux-kernel@vger.kernel.org,
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <ajQI5jMJpxyNZCLN@casper.infradead.org>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajQDVAu9b-LX8gUQ@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 81510C000C
X-Stat-Signature: ff5ao49xt1z4a8w5s5ca941sk15wkepc
X-HE-Tag: 1781795054-472877
X-HE-Meta: U2FsdGVkX1/bzerAnIJnXlp8Py+22Jcb/xBO29Whpgz0zY3BlA0tgY6KVNq+v2fQeKmZn6SIHdPFx15XKmZRc5G1Eu6bYnV5BOdvdnb9jtLg5MhZMlAdXRAR7xaAQZr87z0YrL9EqMTvdQlUOe5SU4tENwjERzpYSZO9mLx8GS9R8BNfJyeSgUBbGLw3DUwiEKoXN7rCv1HfCr77ZlBLUacGtDKLYxpR/Jl0j5JI+i1TGXlrWbjVRdMqDI/D+ILDJyDYDPgUcjKc7KTy/XhQBe1zJO0zjIowpKzvY3C/il8YI62pQv+h1NJ3RNCoPoPnovAZLzEnK+roOAr8TU76PWIwB0Gp7bwAxkDPIXW63fxc1tOp8ZL+TL4B9w6PVYTjYWbNVX+5xRDcN3tLOczS4F528q5O1RWtZENga5xk9KD7GK+nQ+ZKkBFCdyhXM+bIAQ7Ss7AQRutAmRq4GNNlLI1uWBxAoxriXdQceASONZFtQmpQKibQnDLE9NWZDOa6j32osDRRjwihJP73VPtt1f/01iUuvGLAlCITyIYKFeJvm6EeWDFXZWmVwakxZDFGVHhzcj6I+JtDjX6kNGxnGD8Mjk47hpVuA2epTcqwUMfu1uf1Ru7wsUl07UxjfiLpIH65gdcliaGQsqEs7yJWmm/BCLSO2ZOXDVWbFPTDZ7tW1EjewdnblTLrqwT0OIhOTL8PESeqxICxVcb7mjsjeODk+NXiYXlOfadX35XPyZUmtoZ2+Lo6ExDumCBIPT0jn5V+w9dAwYqISOy5YYks4ApCDzyVmyDL/fIEtYqoMGF+WgmGpmBBB9m2Y9/xlJ+JBncKvD0iGkleyXiYQ4LI5qk2rH3UjRSESdf0X4nWdGDPwkZ9uCR4A3+CDmEM00u1NhQWTWWXzJUfqmd9x1+CwJ9c498tOZqS5aWfwrZtk93IrB1/F2IpMWt9Ra3oqriRAcaOrTNKcQwN8yDNx4r
 VPfvwhDE
 YALPg7MjZuanpYlqpbBTl8eTkkdDnim36GYK0PoEGGxZ8+LWNTCPYh7O+dAu3F/awiHpTpZkraIVotFWKfUuoJxYxuJkgJmR9YC3jf6ZGAcescXxKxFizxXNVlJ41I+a6SWNKWfBEArYmTkPvsZi/eHGeOd+PeTmjoMvfjsRBofDCYWYr83q2/hf/8ucebQ9EmJGHkJYAuef1FkfSJKI64m/rguitDusuwEA6b00+p9S05Gi/VG8M7SOFVf+Ro8jA7aTBcOmu3lejhukopN61KPr0Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 03:55:58PM +0100, Lorenzo Stoakes wrote:
> On Wed, Jun 17, 2026 at 04:29:28PM -0300, Jason Gunthorpe wrote:
> > On Wed, Jun 17, 2026 at 07:34:06PM +0100, Matthew Wilcox wrote:
> >
> > > I don't see this as being something that drivers should be involved with
> > > at all.  The MM should be able to get this right without any hints from
> > > the file-provider.  Yes, that means I also want to get rid of the setting
> > > of get_unmapped_area in ext4/xfs/other filesystems.
> > >
> > > Looking at generic_get_unmapped_area_topdown(), I think we can do this by
> > > making an additional call to vm_unmapped_area() before the existing two,
> > > setting info.align_mask and info.align_offset appropriately.
> > >
> > > Now, what's "appropriately"?  I think it's based on length (>= PMD_SIZE,
> > > then >= PUD_SIZE), but we should also take CONTPTE architectures into
> > > account.
> >
> > The info.align_mask and info.align_offset do need information from the
> > driver based on what it intends to map into the VMA that is being
> > created.

What you're saying is that offset 0 of the opened file might correspond
to a PFN that is not aligned in any way?  I had assumed that when trying
to do the mapping of (2MB+4KiB to 64MB), that the offset specified to
mmap was 2MB+4KiB.  But you seem to be saying that the offset in that
case would be 0 and someone needs to know that it corresponds to a PFN
that is misaligned?

> > Filesystems probably have quite different requirements than drivers
> > using remap_pfn() or vmf_insert_pfn() that have locked down pfn's.
> 
> I think part of the problem here is that we don't differentiate between
> drivers and filesystems, and what might be sensible for one is perhaps not
> sensible for another.
> 
> We're too generic really.
> 
> With mmap_prepare we have a lot of flexibility as to what we do. That
> callback is idempotent and as limited as possible, and actions like remap
> are achieved through calling a kernel function like mmap-action_remap().

mmap_prepare() is called too late.  We've already assigned the virtual
address range before we call __mmap_region(), and there's no attempt to
adjust 'addr' in __mmap_region() after calling mmap_prepare().


