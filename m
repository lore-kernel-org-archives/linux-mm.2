Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 975DFC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A506B008C; Tue, 28 Jul 2026 11:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C906B0095; Tue, 28 Jul 2026 11:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754756B0096; Tue, 28 Jul 2026 11:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50ACB6B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:20:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCFAE1A041C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:20:33 +0000 (UTC)
X-FDA: 85038547146.29.7FBFAAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 333101C000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:20:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHXtPkLt;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785252032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pcgm/0NVuLY1iQXWdMHTbgGTyBAUcx9voeT3GqTNrW4=;
	b=0Kg7NfJcHsmfioPOEtoLk9ZKWHoG8ZzMsGgIVWppWeeU39Vnbhm4pIIitBHGdOA308WkcA
	RNH1mxVtBtFBdsTn9PMD4X5ojkJf40q6NoxyLAalGS6cM8XAmxwa2r+KLSofZCvtEhJh6m
	95vDgxQVQZtdFohaoPvPGquguTB93do=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHXtPkLt;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785252032;
	b=MVx+9YAWghC/bidJmly86l3uM1hvMpgWYNYr5VWCrzC5B+/umVGq+XGNoMvXvkMCoL8m93
	1MUE/XeofAJYyCDpp2v2d1AHG+XgrKjjli9md8zXTuXA8qW85AnaFNCg5xJHFIpkAq52zF
	/YdPZ902qb5u15FdcAmPaZXdeawW8HI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1007041E52;
	Tue, 28 Jul 2026 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5191F000E9;
	Tue, 28 Jul 2026 15:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785252030;
	bh=Pcgm/0NVuLY1iQXWdMHTbgGTyBAUcx9voeT3GqTNrW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nHXtPkLtRmjx3crBgajbkLZxNsA3m9uMCmmk+Zu1hXmHK+jqcSxKDyV8K2wEAn4ov
	 xAp4WJNCsT0bhLjmjM2bXP7jm36ow4Eez3+MwNxAabUGON2Ufr8GJ2fTQrTn4fM+PF
	 F2WRQZOsY7x8E5Gy4NkWKM1kXL/jUwoU3O/nmGJqaFskSIXPkooguA+E3Q6RPPrLJQ
	 ujd9oq3RqgGlSx9+LgrKyiPEIdHFc49+JhTl3UBJVbbO5EyeHdiyEQzge9D57ztibD
	 84Nd1+6QnDSM9g9sdyIoH5XrQdZnT8ObHMTB8lL1zvJ/aZlpBCRxbylGzEUz6Z1ubB
	 oyLbO8Xi/+Xzw==
Date: Tue, 28 Jul 2026 16:20:10 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Juergen Gross <jgross@suse.com>, 
	Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <amjHQtTRKKkxdaWC@lucifer>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
 <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
 <20260728143135.GG651302@noisy.programming.kicks-ass.net>
 <amjAxhL-IeeJITEv@kernel.org>
 <20260728145528.GI651302@noisy.programming.kicks-ass.net>
 <20260728150126.GC921102@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728150126.GC921102@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Queue-Id: 333101C000B
X-Rspamd-Server: rspam01
X-Stat-Signature: hdpgnif61a761sotb9t3ch59jp1n5hm1
X-HE-Tag: 1785252032-243039
X-HE-Meta: U2FsdGVkX1+Zz+HmVhHyr37pPNwK5IWhB6EoJZeAz8rBW93v+wdWMr3Pc3tTpX4mei4i6ZUGydt2hJNxOJOvcDHYHPi3YV3Gs8qghT9CoBiqurVMkuNLCF0Km2/+4by1bXp6ZXl+mvD8xl0rdMUkUGYKFDoPQWj+bAHIvek9ivFOTHeff/iISAT8VJAqqLpIUdXPSkdG9DGsdWEeXGocTpbt6Is2+PPw8DwinA8agjY5bakXhCorTvemwlJNzf8RWe4iRNHEvk07Atd9LcLOl8LGq1Ko0RxXwYLU9wqUyf4DEBShZl69WXUB/3ZBxNAwsDkaN4AMfdCBw1tJry8FruBdjbQ/Yj4tfCjm1TMt1/i2vKtB8+049mLtjah2q33FsxJoO06hgLxaOAQvqEi5KCt0obbdE/UTSLMf4uYQF7r/UXnkt2qNfYBk+Ovtq4IavrreuEAEuh1x4zT0U29/7f3HZCDaM5ecl3wMyUNUsGJYqqwA2M2FYsVwH1S90cgrb3ZEUv4IIisls53hmSz9XeIa6Lcyip8fEOpzKV0zTFIftgi0D6IDoYm9WXDL5P7yhBCV4e4Vsjjidhzy7I55f2+aF9lqseLelgspf4sXvkA3lSkeeqWWxft4IdTncqf5RNsL0QP5Ot8j6Y/rLkILpKZQFy2jzVuzhmcF2ltS5P9g9/5PhAb5lK2TVSHfrtPG/NPCFCOMUQFP7tY8USKkXpLsAlMJKcwWiz41vSOAqjeWFdTLlYsv5jPezFEEqDMpnlhm/SLaS1uXYgUGFz0AbWle8G//FaUfHEFR4IKC4Kx5cGEn05Tjhr9biS1h6DHa0KG18jEzctKFXo++K5ca0DYH3t6xkyR6PvEW9swjQKZS9jKeY+wugqpO0dCNF601aDr7boQ6hhqHDrZFDaQSa1u5BS8qkJG5MgM+ta5/7T0PyaELFA+Och8mJPi7Pbo8VPDfxKv/jFe5alU8MwM
 7uwKYqbE
 Ag+4WqiPypeAPuqgiyUjDy4HMOuG0oipuHaW0qSp1tT8pJ9rV2kzXQjEc5z6Ha0XugGnEYt5HPWC7O/8J2Xs8HozTCmrwTROHvWFwUAnDf2XicVQo2q5ixh6UqSNj2YSeiS7hdDrrScLvAlpZhh2eBxA9uMKcVxCzclxp+WPv5pI9TscziUYE5b1uvI0hg3mTyQqriCk5rEXa5mSPWeyTI1IVLSJfXeD/5etwcBcx+ah3OKHMCBPUXpLFnEsZOXNjmcVFVUi3gJ08NAS5W2KzhsT7GD9uRl+YsbFWWOmVtHg30zI6qURw62yT5PoLIM77kmgXsb3fTCKfmOkUSw/bFCMlhij96qV09quQpL5X042roE7bQRs6LO8mHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 05:01:26PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 28, 2026 at 04:55:28PM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 28, 2026 at 05:46:30PM +0300, Mike Rapoport wrote:
> > > On Tue, Jul 28, 2026 at 04:31:35PM +0200, Peter Zijlstra wrote:
> > > > On Tue, Jul 28, 2026 at 07:30:27AM -0700, Dave Hansen wrote:
> > > > > On 7/28/26 07:21, Peter Zijlstra wrote:
> > > > > > There was already a patch merged that removed the shole debug_pagealloc
> > > > > > exception. Is that not better?
> > > > >
> > > > > As I'm scanning through email this morning, there's another issue that
> > > > > popped up with that patch. It's causing hangs on boot.
> > > > >
> > > > > It's looking like debug pagealloc not taking the lock is actually
> > > > > functional, not an optimization. Although, I hesitate to say
> > > > > "functional" and would prefer to use much less nice words to describe it.
> > > >
> > > > Yeah, lets figure out why that is before we retain this wart ;-)
> > >
> > > As Lorenzo said:
> > >
> > >   __kernel_map_pages() can be called from irq context:
> > >
> > >   < GFP_ATOMIC context >
> > >   kfree() or whatever
> > >   -> ...
> > >   -> __free_pages_prepare()
> > >   -> debug_pagealloc_unmap_pages()
> > >   -> __kernel_map_pages()
> > >   -> __change_page_attr_set_clr()
> > >   -> cpa_lock
> > >
> >
> > The TLBI hack in __kernel_map_pages() makes me wonder how any of this is
> > correct to begin with. That comment isn't helping.
> >
>
> Also, the 'atomic context' usage hereabout seems confused. In particular
> the issue is with IRQ-disabled context, they are not the same thing.

I mean yeah the IRQs being off is the issue with holding the lock over an IPI, a
softirq allocating GFP_ATOMIC won't be a problem for that, but I think all the
conclusions are still the same.

>
> This confusion is seen in the existing comments in __set_pages_{p,np}()
> and in this patch series. It needs fixing.

