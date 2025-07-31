Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D0BC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 17:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E7D6B007B; Thu, 31 Jul 2025 13:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76656B0088; Thu, 31 Jul 2025 13:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4546B0089; Thu, 31 Jul 2025 13:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFF36B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:37:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BD97BC611
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:37:43 +0000 (UTC)
X-FDA: 83725267206.07.4FB1CDD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4E826180012
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:37:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iKWwh1a8
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753983461; a=rsa-sha256;
	cv=none;
	b=6lRfuIKyt+lwdiNai+ZsWy3d++emam5wWQ+trGrY5uxRxO72ppq8FMKkhJAk6MVrT9y+kl
	WBQ/OwaJtabKRZ2w2foAruWuiubQ2mOk4gtCfaKXiTq9lOddWrpfUr3knAeZzQd4mGCeTS
	6LOGwsBjwsZerWrGoQj6FemIbfI7mZ8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iKWwh1a8;
	dmarc=none;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753983461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p81bLGAEXCTve0S2bSlDolWBTWQ0gkC1ozZDbrTl9gw=;
	b=vyYkU9GNDU13Ah5iFVq3vmlLd7KYwBv2xMbhRJaJU51vkXx2JbU7PbmEKCTScVD3p1Lj1v
	P0ung8fCN/ghbwOceYOLG4k1UPVZS7v5l//IQ4/ZR8D7TUR0QSFrZ1bEu5c3LFFsceA/FU
	izW0OiRk1x0CJp24nrTJGFLgut10fhk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p81bLGAEXCTve0S2bSlDolWBTWQ0gkC1ozZDbrTl9gw=; b=iKWwh1a88Q0pAf4bvxfAD5Txdc
	EE90MjrkC8Uduz8SZ6vXiansbV8frsRKlWXThc48w73PhEqccyoX4tMljfHq+8Rhz9i2ceiiTpnNQ
	7hjsoOf+OUPX+pHbDNVQLDykrMSNBfUePqaONzx/4EcyEuzR/wo0kYwvkbEPCkU9M1bzxAWY1d2bj
	ohP5kNlKgUTJVA9ZUQHkyV+nsX3SWV9d4/YDSTVwIwFe2VNJRwzXwJ/sEIwEa9qaSxvuX+eYykKKV
	Yo/BB2cxQ9KFglR+QaHCwdd6BFZFTPe+0RrFxYMe0Vnzv0Y1POwKGhi1jrFc7WsVSY+Z/IRvpV2Bt
	sXEcrVpw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uhXDL-0000000H6sX-2SDg;
	Thu, 31 Jul 2025 17:37:11 +0000
Date: Thu, 31 Jul 2025 18:37:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, iommu@lists.linux.dev,
	virtualization@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/8] dma-mapping: migrate to physical address-based API
Message-ID: <aIupx_8vOg8wQh6w@casper.infradead.org>
References: <CGME20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf@eucas1p2.samsung.com>
 <cover.1750854543.git.leon@kernel.org>
 <35df6f2a-0010-41fe-b490-f52693fe4778@samsung.com>
 <20250627170213.GL17401@unreal>
 <20250630133839.GA26981@lst.de>
 <69b177dc-c149-40d3-bbde-3f6bad0efd0e@samsung.com>
 <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4E826180012
X-Stat-Signature: drdaj6rib7rtmamyjhk7d9qek3hmxyhe
X-Rspam-User: 
X-HE-Tag: 1753983461-274818
X-HE-Meta: U2FsdGVkX1/VdxM6nCshg+/X9jwZWmBsMf143XhZOTcBC7q6W6N0ZVG9s8jVnnHW0X9Nd4m5be5S7lfcmC6fXKGdwfMGofE7dsjI1X6g+dI/b/GaG00XMDu0w44iBRlt4T1RoFdABnDkQsBzsELL77cd6/nB6R5vAeWfgj2J3QOwsLiHIRLCkPgfh148R/yssiz0BVZaKJhqyh7QoNmNaBNjgscBSZYhILzW7EkzioVcIjYZrqU5gqctnsRXpxoOEenc7FmIni3HW9tZJp+1tSvbMBnlBxxnsygyiLyNwFoJeWg4ff2tW2FG5bSvwBLlxiq3gys6Gq/aWiLft3T8GRh1pYEg7dAtPGcVfA/8pw37zID6TwZn+NLF/RvCvv8EGL8qcJVcb1vxyL/tEIt87T4xaWs8lgFvxdaVEe9n8K2pdLdQ5ZubIBX5vmPQ8WgkH8ni2rkqu8CJCC4dlcRNPxq7w1BItoUNaOz6KINYbTRVCZ1WY6zD5+KDB4/52zEDb4UsmKaEB2q6kXwsJIcef+4Jz4/a6jZxPDFFsU4IdRnkV9AyVGYO59SMJL6CJ2UoEBTaxGaPcaH0LXUXe7OJ+mVjwFK5wxhINm7p6kgdafyulon2qEtOrAMakOGWidu3Jgoxy/zO5dj40FkGGv+WkE2Vqbin+zcpqADOG+9/HIBGpRu1rk5+7RIt9McUpnOshjoIzFa/wdYa45wAYXSDJMqEQ7Ez48gQqfr+Tm4EZR8nhdzUtuTJhCuZH/2fvh64VLeV2Fqvms7Sp8KbT4cP8siqnuLztgKUidNwERlI+eoeEBICjrKX+gA6DF1RuzZlUA5TwFw6a8CLfByQSgxvCCoose0ApT5p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Robin,

I don't know the DMA mapping code well and haven't reviewed this
patch set in particular, but I wanted to comment on some of the things
you say here.

> Marek, I'm surprised that even you aren't seeing why that would at best be
> pointless churn. The fundamental design of dma_map_page() operating on
> struct page is that it sits in between alloc_pages() at the caller and
> kmap_atomic() deep down in the DMA API implementation (which also subsumes
> any dependencies on having a kernel virtual address at the implementation
> end). The natural working unit for whatever replaces dma_map_page() will be
> whatever the replacement for alloc_pages() returns, and the replacement for
> kmap_atomic() operates on. Until that exists (and I simply cannot believe it
> would be an unadorned physical address) there cannot be any *meaningful*
> progress made towards removing the struct page dependency from the DMA API.
> If there is also a goal to kill off highmem before then, then logically we
> should just wait for that to land, then revert back to dma_map_single()
> being the first-class interface, and dma_map_page() can turn into a trivial
> page_to_virt() wrapper for the long tail of caller conversions.

While I'm sure we'd all love to kill off highmem, that's not a realistic
goal for another ten years or so.  There are meaningful improvements we
can make, for example pulling page tables out of highmem, but we need to
keep file data and anonymous memory in highmem, so we'll need to support
DMA to highmem for the foreseeable future.

The replacement for kmap_atomic() is already here -- it's
kmap_(atomic|local)_pfn().  If a simple wrapper like kmap_local_phys()
would make this more palatable, that would be fine by me.  Might save
a bit of messing around with calculating offsets in each caller.

As far as replacing alloc_pages() goes, some callers will still use
alloc_pages().  Others will use folio_alloc() or have used kmalloc().
Or maybe the caller won't have used any kind of page allocation because
they're doing I/O to something that isn't part of Linux's memory at all.
Part of the Grand Plan here is for Linux to catch up with Xen's ability
to do I/O to guests without allocating struct pages for every page of
memory in the guests.

You say that a physical address will need some adornment -- can you
elaborate on that for me?  It may be that I'm missing something
important here.

