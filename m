Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B15ECD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA846B0005; Fri, 12 Jun 2026 13:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B3C6B0088; Fri, 12 Jun 2026 13:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681486B008C; Fri, 12 Jun 2026 13:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ACCE6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:49:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AEA41C2631
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:49:40 +0000 (UTC)
X-FDA: 84871998120.20.50535C9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3BB9D1A000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:49:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uy6OGp6s;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781286578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZyVuCnHa7QBq1nhUt/O8UjE6IoC36HDSwKIPmuVqNo=;
	b=4t8qyTZR9+E0KnS32rqKcRjmMSb+ULvd0LqPRkAXrPedVwz4GOXMWHMwURUEYaUR+YaHkE
	vVV7K3WskpynoLpkNKUg8hp7uL02HpX1r9aelIcwmAGowtxgOFC86HJwOkkjqPoQwG7vtz
	4gAYl8VcBy/jlTRvTdonEJ8NOcpZe7E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uy6OGp6s;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781286578;
	b=qkMSXfFZaN+CGJpUm1ynQfW6Ae0G6FuNqrD/T7XMS4TCd1OdCjwwaDgi8unQRZMCvekE4p
	pzVbxjY6kcq62S/NJczGLSMPNJqKmxueSv2juMEgr2G+7UGiHGUYfhTrWZe6/g4Jav13jF
	urq+s7spZLkLa83soIMdnUr4pFLsNkY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 560E322EA;
	Fri, 12 Jun 2026 10:49:32 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6EC83FAA1;
	Fri, 12 Jun 2026 10:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781286577; bh=S1PIlzk8vGChQ04VWrfS3SSCm8k5SS5ze78gg8eQ4iE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uy6OGp6sf2LANX/v1lPC+CjkVElax8HpROBJYsFdfEoQTcjHKYfpSsAZQW2I6/mnk
	 DuOxFOY9rbNiWlQyd6WPeyxZ4VqSaZES7REmNf2Q/oY5ujJ866IrsEpHGDO70h32qg
	 qSDwXZW+ZgwGbxDT6BgaVVARLOeURjr7wyfjFyKM=
Date: Fri, 12 Jun 2026 18:49:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kameron Carr <kameroncarr@linux.microsoft.com>,
	akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rppt@kernel.org, mhklinux@outlook.com,
	linux-coco@lists.linux.dev,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and
 vzalloc_decrypted()
Message-ID: <aixGqCqKkQeDfUST@arm.com>
References: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
 <aibhnnDFQTHWMEFe@arm.com>
 <20260611114954.GC1066031@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611114954.GC1066031@ziepe.ca>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3BB9D1A000A
X-Stat-Signature: e8apg8fq1tupycaa1mimzifib5egi1ot
X-Rspam-User: 
X-HE-Tag: 1781286578-189310
X-HE-Meta: U2FsdGVkX18bZg4AeSRh8jaadQju5IiN8osBbuaSTNZWkBPCTLoZ95UX282rhizAL97tlVYwEqsib6X19H8MqlOB/2zXff5XTltKKWYCLtxtsoEcJJHkpnoP2TnxbN8DPHb/8REw4fbb8EMhde383o8ztnqkQZwQVSYxE2hE2pWZY1pJNM92W4lKaAlSTd3HlEcwNVUXn/wSb9Pun7LZe6X3Q81lRFdbHSqrV9o1NXYap67AOyp9fDkuCZ8Sb+puxED1IgKcPUCEDWjerqJpaWBFOex7anPeEKKjKh1YvoGTZGrot3ydPHaEdAB9BAtEnp6ekopYgwRu3aqEyv6TdqRTEEnTVtiY/5i3VsS/bpI1KEBUmyOMdyOgnlj8d6cmsvzPSQYBK5JF9ldgMBNPmKWM4AiXw7A7WY6TlXfy+pujOoijMLYHJNsCwSMRbJ8604EIRjzgNWmKGmGG6LJqbgkT+72hzSR8RXBcjP0YRui7tLfDVeTRt9p9s45B1Y4CVgZnJV/WVFWefmGFqzrQXC4WGET1do3DoYmMB5oGqnqXoKu+iDuUXWRGisaPHUPTed2GsfYikpPqqMy8IFt+GGLReOL9zo8kKLCDq9DL0SNXpzkNdGh3AabMJVLCWEhLKzELWgEqQ4TekjliTKI8KMLeEgI5FgyZ53UkKyQn/mOpAA9R+hZE2wkAdy1LRxBkb0J04+qv1zP91FJ+MYnECLh+ZsIaT1KfJjZCkpNpSqwPriRk7+sMDN/jOBLydUYRtJzuvRyVZW/8lj0+n0j5v7rGiQiRxY9gxluW/iNBXtYfcDZ2PWqlIguiAZCB0dL7vo7xRW282n7X6j0FqLSaJqFwTR4IeuNxe7N3vjmkVOZIH9y5lhhyLW3XPQOZU+ODDWpxcbmTyMKTZkCzh+hLurwren9bWXkgcLesMvMIK/OaMHCZ9qF15fLXsEt4MYWeU8Wwrqhg4w0eGlEYBoe
 +HGN2k5C
 sf3tTro+iNuBvg3j95Y8wecbcPzjdG0J9BG9HW19vGw5cZpBRRKA7cpx1LdWtsQF7lK6qUcsbHGZJV9m5rLBeo1Yrasf79sGKkku4p2yh2teNMIN6JA3IF9/4xutA/ZFgFY6uGJLsLM8tCS2P4Y03a57qPjLrYsN4gh024N5JGAHgzpwLgSwfC+a95KjkBNTSkEu2D6qJ60C2weRmTc2nibwLRhIOgbHXw65OOfHUrRki9uoE4M9B6m7iVooKhWr4ItftfEbpL8jqGD5bvU8PN5SlrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 08:49:54AM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 08, 2026 at 04:37:02PM +0100, Catalin Marinas wrote:
> > > +/**
> > > + * vzalloc_decrypted - allocate zeroed virtually contiguous decrypted memory
> > > + * @size:    allocation size
> > > + *
> > > + * Like vmalloc_decrypted(), but the memory is set to zero.
> > > + *
> > > + * Return: pointer to the allocated memory or %NULL on error
> > > + */
> > > +void *vzalloc_decrypted_noprof(unsigned long size)
> > > +{
> > > +	void *addr;
> > > +
> > > +	addr = __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
> > > +					   GFP_KERNEL,
> > > +					   pgprot_decrypted(PAGE_KERNEL),
> > > +					   VM_DECRYPTED, NUMA_NO_NODE,
> > > +					   __builtin_return_address(0));
> > > +	if (addr)
> > > +		memset(addr, 0, size);
> > 
> > Talking to Suzuki, the small window between set_memory_decrypted() and
> > memset() potentially exposing stale data is safe, at least for Arm CCA
> > as the memory would be scrubbed (there are other places in the kernel
> > where we do something similar). I assume that's also the case for other
> > architectures, although not sure what pKVM does.
> 
> It seems like a poor practice though, this should probably be
> re-organized to use __GFP_ZERO so things are ordered sensibly.

__GFP_ZERO doesn't work if the intermediate set_memory_decrypted()
mangles the data (e.g. changes encryption keys) and it no longer reads
as zeros.

> But what is the purpose of this? I guess some hyperv thing - but
> shouldn't we have a more structured way to "DMA map" things for the
> hypervisor instead of stuff like this? Why can't you use
> dma_alloc_coherent() which actually gives you an address that is
> sensible to pass to the hypervisor?

IIRC netvsc_init_buf() uses vzalloc() to allocate some memory and that
buffer ends up in set_memory_decrypted() via vmbus_establish_gpadl().
arm64 does not support changing the decrypted/shared attributed of
vmalloc mappings and I don't think we should add it. Better to just
allocate it properly upfront.

We might be able to use the DMA API but we won't get something like
vmalloc() - physically non-contiguous. I think dma_alloc_noncontiguous()
just falls back to dma_direct_alloc_pages() in the absence of an iommu.

-- 
Catalin

