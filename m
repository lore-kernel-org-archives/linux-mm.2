Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F85CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4DA8E0016; Mon, 11 Aug 2025 04:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EAA8E000A; Mon, 11 Aug 2025 04:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5DAB8E0016; Mon, 11 Aug 2025 04:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1F68E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:33:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FDD014073F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:33:45 +0000 (UTC)
X-FDA: 83763813210.29.7B34DC1
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4F4A41C0004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:33:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=XtS6umrv;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf18.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754901223; a=rsa-sha256;
	cv=none;
	b=HdSrEjEnPZSYgEchPntuU63NkvPEjNvrhNM9nVTo2XpKMVsnAJNYTkqcfW6e22qG5BwcDv
	p8g5wmLDzG6z5PaLPurHg6d2FRkCmgwaAN4S72zHOpoRy0FyF/7lfJ72jDjoWbjHJd5q2+
	XNSObLIGJ3BERNdOGvHDqqidJ4Y+q2c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=XtS6umrv;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf18.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754901223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4ETZNjirUvV9akuA5/N3WpKRJ7fdFCPYyiPJLhsHNM=;
	b=JIyJaJSu7qPX7qjAi6rqcdm/iRT9RiVWyWmoLKRU7wmPJjtmitZJCjPHjrQt/6Y2yhjmX2
	wvA4GJPAhHJYjjlcuC6sh0a+NKXQQSULKqa/+ZEbA/mmvQ+EWQZg6dJRR0mA0GXPKaKmW3
	qU84OdR/o+aWXvjdZTN+k+/ZsfnrYIw=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4c0nwL3hDmz9t8p;
	Mon, 11 Aug 2025 10:33:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754901218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a4ETZNjirUvV9akuA5/N3WpKRJ7fdFCPYyiPJLhsHNM=;
	b=XtS6umrvBfaWyDKYetycnjHwPkC7sF9zvwuGE7ixK0REHwd2OC63DMCH25SJePZjgrWytT
	/kUhKVKi20Cf6AhWAPcckzhfQePFOjfVHApRENh33pJnvaAO80tVRpCEo9wb+pdQcZJjxD
	IxKy8X58dewt+Z9LvOMZu3YT6x2rAUDXG3Mz8XemXCvXP4K6p/FJk0q3CfzmAWIdCJFY1f
	hfmen7ObaUdD5QWi/DH4XScjSiLfn6xE1p/3YkOo4PFodddJxFgxQZjI8zSsZlVY0/WMnu
	grRVLKhscyOIf1L8kX/6SpnQTSsA98QRgK/EZFA8PEavFD8dmIhQ55jU7GHdWg==
Date: Mon, 11 Aug 2025 10:33:08 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>, 
	David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	willy@infradead.org, linux-mm@kvack.org, Ritesh Harjani <ritesh.list@gmail.com>, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2 3/5] mm: add persistent huge zero folio
Message-ID: <cgtgtq7ctkouzu6ki3nvzugw5txcgygtf6nducrqvbok7ajuhd@cqjtygxpsgnr>
References: <20250808121141.624469-1-kernel@pankajraghav.com>
 <20250808121141.624469-4-kernel@pankajraghav.com>
 <731d8b44-1a45-40bc-a274-8f39a7ae0f7f@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <731d8b44-1a45-40bc-a274-8f39a7ae0f7f@lucifer.local>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4F4A41C0004
X-Stat-Signature: zi7oidway77is5g8opkym34pxmjqxyue
X-HE-Tag: 1754901223-440021
X-HE-Meta: U2FsdGVkX1+8xv7txtUbCRQtxVZcdo4iXdOhsRfaNSxjaMQXAgKaUW8DbixrU1y3bsxTLCOd72w/6iR6TCxTg7V81U+t8Be3uE+uDa6ZIFSBozOJkmqddrVzi/k8TqQBsE+sz1phyMr5SgqwXJX+McDU9rlqN3MZx6lhp0GHeFnh77JS7SY2+Xyxm/kXH8E5w8Ph+aNW/dIT3MYzapf689k+kUvIJAAQMTgnLoo+GttwosWLMbGAbC2Mr1B7ch+ZMDpkL5lAw9FOJwtEbdAVuov/FdLzOhMi5rmSypONsUwlYPvZv/VVZeVA8pupS408hlZV3JWe4Yi6b4u31clBEQHC5ueDZux0V+J6mEUEUGQkgjkQOlgeerAMIF7G7p3gGVptnn+vBCVUkgq6hH1Kkakqc5NXHmdb5SRu7zdzylKtAnsE/DoC64cILMUFy4Vg8AFdySzIVEaQVIDHUoH2JZpIkhj53B1d4BIwS1Ly01KcOw5J5Zfy2SYUKAFRszoLR66jjlEwlTK+3FI5u4GBBH1ix7MECaFJ6G+adnOZL7EqRmq5Wib23pGLUDzwNY8Zas2jt9I/UhwSyuvRLuWTKxCd8dGfthzVlvgL12Gz1pyOz0ev+a+v/BT2JahB/XKLoYOAl8SiT77KnSsASpa7ncxtMxWoxqJap9Lck3ikiANRT3H6nnupVLC0n6Bs20SfdD/ugWCIziI4EZrlWNBy1Hxr3XkGBn35bXyqBzGCERFXBETEWT4ZoNSCMuFmltIEfW3SJB3+5Rrhdd05vezXjC/KfSAkRqgGN4Ph6ba9W2vXI+W1+W3aNL2B1nIaOe4OyakJRvQnwJBv84wDArWCK3iC6n9eR7B9k4dILOgUQ3Jp5M4RhovFF23qS1SptlfdvAclgeTLj73fawMarMZTINdu/N/Qp06s6RnM0M4Ouby1TdWRLZu0fsTQo15gyPefKVw+G6XdpikCeCqC1l0
 RHZkICDj
 uP4PEp/CnoYobBo5qJW1f5IVY3PkRBKWY9pgpjjdIkYqPI2QdH9+USEKHc9t+KDih4BOxuG61ye15tGFPJulSOJIx8spR673ukIgm/qJKmTb4A3WX5eGDvUvB5Lwhhc1Do9xJXwDxOvmmAWrcT1pWePWR/XG2txY0FHPkgXIefFd5OpMl14TIwVvJ9V+KZxJvl23ulWurM3TE/X1ePwy5gutkrIM1/a+ry9CuVMzxKNwJE4IeORCQ6DbYbNtrtH2zSKQZqAH997C9L4j2g+4ntOoorMTZpi49kyZcWwgFIrqo3SUqt1Uc1y1n1sEU5yLsWEohu1LOmh8OXGxjCTB5ZhOu0Lj3hIs3hlAQLxfwvoRSsDg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This is much nicer and now _super_ simple, I like it.

Thanks to you and David :)

> 
> A few nits below but generally:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks.
> 
> > ---
> >  include/linux/huge_mm.h | 16 ++++++++++++++++
> >  mm/Kconfig              | 16 ++++++++++++++++
> >  mm/huge_memory.c        | 40 ++++++++++++++++++++++++++++++----------
> >  3 files changed, 62 insertions(+), 10 deletions(-)
> >
> >  static inline int split_folio_to_list_to_order(struct folio *folio,
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index e443fe8cd6cf..fbe86ef97fd0 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -823,6 +823,22 @@ config ARCH_WANT_GENERAL_HUGETLB
> >  config ARCH_WANTS_THP_SWAP
> >  	def_bool n
> >
> > +config PERSISTENT_HUGE_ZERO_FOLIO
> > +	bool "Allocate a PMD sized folio for zeroing"
> > +	depends on TRANSPARENT_HUGEPAGE
> 
> I feel like we really need to sort out what is/isn't predicated on THP... it
> seems like THP is sort of short hand for 'any large folio stuff' but not
> always...
> 
> But this is a more general point :)

I already brought this topic once during THP cabal. I am thinking of
submitting a talk about this topic for LPC Memory Management MC.

> 
> > +	help
> > +	  Enable this option to reduce the runtime refcounting overhead
> > +	  of the huge zero folio and expand the places in the kernel
> > +	  that can use huge zero folios. This can potentially improve
> > +	  the performance while performing an I/O.
> 
> NIT: I think we can drop 'an', and probably refactor this sentence to something
> like 'For instance, block I/O benefits from access to large folios for zeroing
> memory'.
> 
> > +
> > +	  With this option enabled, the huge zero folio is allocated
> > +	  once and never freed. One full huge page worth of memory shall
> > +	  be used.
> 
> NIT: huge page worth -> huge page's worth
> 

Thanks for the comments. I will make those changes and send a new
version.

--
Pankaj

