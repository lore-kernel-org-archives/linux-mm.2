Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39712CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7A18E0003; Wed, 22 Oct 2025 10:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797F08E0002; Wed, 22 Oct 2025 10:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4F18E0003; Wed, 22 Oct 2025 10:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D16B8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:33:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09653BBB41
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:33:49 +0000 (UTC)
X-FDA: 84025994178.27.EB99176
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7880D1C001D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:33:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lt9seIbK
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761143627; a=rsa-sha256;
	cv=none;
	b=PQCe3MDMhRBTM378Ndb79wnLxZleeJS783gIsIGNVlsvlUGke/ufaX/Zy1KISc3vz4l1Ci
	0E/qAbmrzTjdIwheFsivCyitYj/IyQgP+YktzYCEVuf1G8ngf52+2T9LUsz7wDHhMe57Xc
	8/4l4vB+rfIVWojRPqZjwxtOEMYzGPs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lt9seIbK;
	dmarc=none;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761143627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+de7953ZHDTGM7dYRP0GLBq06V9zfPM2j99l94lng0=;
	b=SzqpbxVEwc78laldvFr+z2B4HVe614HZCgKofFf8GXYdkxvMJ8ZEd5spCSesih8/9g1KHU
	ubqoNnPBSrkfT/nmnQT4uJoEA//Z8708JjW1t6Lca+U97feQwI7o7UJ4uYVJ0qbeHi/Kt4
	nWMIpKmM8gIkJIMhetKykohB0ylvAus=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=S+de7953ZHDTGM7dYRP0GLBq06V9zfPM2j99l94lng0=; b=lt9seIbKzVzPgKtHKuRghpfJLg
	OqaNfpgAdosaB6hE9Dr4VxUYzadKi6BwoyRrZsAX821vsQuzBXpK24YZyAUUBHFuXuKT2arpgK/gq
	yn8Ycgid8qQMkxXgvlBWQWll29Di4yiK6nN5cLj/+TsP7sIdc5REyaZ9QOM9YSAjo1Of1bPaw2uqf
	IdfQdCpWQR0Gal4si6VFeOwnzLj0+47bjC4XuhB+4PjTnJ+ejO59i7pnkFWCltomMseMDMoP9rW6g
	QGhr5a/CMB/sSH70SB3dR5vZ1DacD43UwVS9X7G+Vv1zqezYHbHTjk7/9S1qW+zFg+MxEe9NhffG7
	96wkyhug==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBZuI-000000088vn-3Hov;
	Wed, 22 Oct 2025 14:33:42 +0000
Date: Wed, 22 Oct 2025 15:33:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aPjrRkjiIt6HmXmT@casper.infradead.org>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
 <20251021142436.323fec204aa6e9d4b674a4aa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021142436.323fec204aa6e9d4b674a4aa@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7880D1C001D
X-Stat-Signature: ixcswgi9bnjejoiadm3a3r7s8yq8zmgd
X-HE-Tag: 1761143626-281752
X-HE-Meta: U2FsdGVkX1/tRsby4XobtH2u423rnc2heSxGGrrppcM1tpo/HxDF/fkjx1HYbTGueLrxoRudr16kB76ifTMxnDuyP2atiF20JE7h/SMhMybswERBRnoTkW4jxVd41zGAtJmd09Gggo+wcne4j/mh8opewPQS/wRhFMefn4NIh3FO93WSZhqWnW8GXv2ZHXEJbYFKKXD40xMQfOoz3anMAPBxPeWRrEZKkS0+TBy3ScOtjMaA93u2XCnGK7vhpmgW2a1roINqZmONDgcmI+G+F9Zg23HheIdYKWgxSktzjW9dQYCAp4sfRf7H8zzfbHjbzeMjUXz6ka+7bbJ/JlgKO7De48s9vsXe/7bt7/bXbyneGTPusEZcnSpFA7223O1b3lktLHw8ubKcJXDPGTUp7dZx6zhjB7xgjE6Z/ncLEds+s/sqnRWebtvyI/fxUfAaZ17coCYBZ1SqggYwmF1lRmiQQDTpn7hLXOFkQ6esrH9w1lQf3Q54zhVYoIIHKkCwDHr0ZvljWcASYG21RDnUjuRYFbjvcpJTO6A4rW9hAld1PD2iSsVmcgTa1AUmm6pyVBU7tDy3bv+gXpNWsyVnzpp/kw8kazZm3sUL82I+YJaNQNu0bCxy+Iwyyf2uMOhL3KVCOIBnajohU6qOmZ3vJ+a+3zvSOZTxvUgS+c6RVOsAzHODIW6GuXoL8Ly/uPL31JcULoR8u7pFvhRv++z11n/6wpt8p/7Zg7myyLPIRXCpDiAqXRpWsPJgpb+xobmQVlShCpYBayQ7KwEEmpR6VPyuwaJRNyI7KMVMFh5oOeqzdVTcNlGWnDSd3pInzRpMGPWY7WTj0DVfg0OvNXTsi8485l/ce9azB2CR4UISu45R56e1auvK2WjGageaTP27Bpl9UfWzBDZLorgPdhb2kQtfpDoIEVpRkBJW+T6HZSmJjduia87Nu3VM5Yi/Dw8db9AbbJ+xLyjOtn178yx
 5xDVNCFy
 Gs0rzm8dEHGBYCAO7ZTY9TvRClqO54S/pGqR/V04PcwgBOO0cobmXNK9FwE1dk2urWvyMW59+IbQjLSXnrpQmrU/4rGXAWXL0BqkCTwW9Yr6yLZyCOBFGVFdpWsBSRmCz+txlMQwQNGrfDwAmzMWSGL+D2xzT0w8qee7Z0oLxOp6ZW0jhq+KAnqBvuK5n//rioTRpQWKJxWW9UkdeScKQ7qLjToozxzzb9aI4KnQrtuIU2IW32AKeLDiIbx1FlLAbXw+xAmu3HsQJ9Ys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:24:36PM -0700, Andrew Morton wrote:
> On Tue, 21 Oct 2025 12:44:56 -0700 "Vishal Moola (Oracle)" <vishal.moola@gmail.com> wrote:
> 
> > Sometimes, vm_area_alloc_pages() will want many pages from the buddy
> > allocator. Rather than making requests to the buddy allocator for at
> > most 100 pages at a time, we can eagerly request large order pages a
> > smaller number of times.
> 
> Does this have potential to inadvertently reduce the availability of
> hugepages?

Quite the opposite.  Let's say we're doing a 40KiB allocation.  If we
just take the first 10 pages off the PCP list, those could be from
ten different 2MB chunks, preventing ten different hugepages from
forming until the allocation succeeds.  If instead we do an order-3
allocation and an order-1 allocation, those can be from at most two
different 2MB chunks and prevent at most two hugepages from forming.

> > 1000 2mb allocations:
> > 	[Baseline]			[This patch]
> > 	real    46.310s			real    0m34.582
> > 	user    0.001s			user    0.006s
> > 	sys     46.058s			sys     0m34.365s
> > 
> > 10000 200kb allocations:
> > 	[Baseline]			[This patch]
> > 	real    56.104s			real    0m43.696
> > 	user    0.001s			user    0.003s
> > 	sys     55.375s			sys     0m42.995s
> 
> Nice, but how significant is this change likely to be for a real workload?

Ulad has numbers for the last iteration of this patch showing an
improvement for a 16KiB allocation, which is an improvement for fork()
now we all have VMAP_STACK.

> > +	gfp_t large_gfp = (gfp &
> > +		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
> > +		| __GFP_NOWARN;
> 
> Gee, why is this so complicated?

Because GFP flags suck as an interface?  Look at kmalloc_gfp_adjust().

> > +	unsigned int large_order = ilog2(nr_remaining);
> 
> Should nr_remaining be rounded up to next-power-of-two?

No, we don't want to overallocate, we want to precisely allocate.
To use our 40KiB example from earlier, we want to satisfy the allocation
by allocating a 32KiB chunk and an 8KiB chunk, not by allocating 64KiB
and only using part of it.

(I suppose there's an argument for using alloc_pages_exact() here, but
I think it's a fairly weak one)

