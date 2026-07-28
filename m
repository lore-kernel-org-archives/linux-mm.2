Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AB8C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D180D6B007B; Tue, 28 Jul 2026 10:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE9E6B0088; Tue, 28 Jul 2026 10:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8346B008A; Tue, 28 Jul 2026 10:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91CB56B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:55:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 272BE1C029C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:55:39 +0000 (UTC)
X-FDA: 85038484398.03.B600105
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 192641C000F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:55:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ujJawC2p;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785250537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrASS15C1zQ1LkyXbnVlgZHFDGNQ1RQT7sjDKG2TyJY=;
	b=nRbtjNflUDh6lEeDCAbV4k1AU0miqJLina9ibRFIFkIScoDZxECMnMWIeZmLMgwtnZkKvn
	g4pi3dPTM+QDzPjVWhKtxw7oJzaZ9Ic3Gg8dH+FO96WIF7G2HEAhq/2D7rp3f+yEtyVNBX
	9FSD9+JxRKso3utpKqtNOys3CVXMXXA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ujJawC2p;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785250537;
	b=gZe3JmyRDcjovdp8KAIDIQkmJUZqXhJHMdCaGwIDiTMNIm76A8Sh15WRRrCzoE9QGFM6ih
	rKpPPAyzP0Z0ndiNYxzA31v5o29G8IbCcu8BhfRNDzI2MPQuewBRgVMYedtdMLXmPE/pXm
	/F5RF9Q0dSFvQYLtzD7M+JP1Hu8Et1s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BrASS15C1zQ1LkyXbnVlgZHFDGNQ1RQT7sjDKG2TyJY=; b=ujJawC2pT3nI8cqS7IvGoyev6N
	OLY3Z+f3ZHQbC1iDXf17J/aVv0ZpMrhX99kMHcP4f34yPrOXVtNCT70l7JmKiwt2/zrHJM9xLGhf4
	sZ1MPNnTtDYO0y0XnJ//qIvidKsHerrrltoY1Sw6XG1ZiDwl/N+po0a6/Xn0I4VJkJ5deGl1AqArg
	U2tqDxUjfonb7qU/iNB86OkTDjllPDvOrcWc9wWZpiFWoiwazM6GOdUSqLWxZPG1cwJxnLEMmDUL5
	musVNmR/Q8rHKXDCqCMUF1qbY88oaS7TQTggu6WTMWK2KHn0Nlv6pue4FYEFia66TkKZ3ghCNDTNU
	oiuh4CUQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wojDN-0000000DVOp-0TPQ;
	Tue, 28 Jul 2026 14:55:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A48393004AB; Tue, 28 Jul 2026 16:55:28 +0200 (CEST)
Date: Tue, 28 Jul 2026 16:55:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <20260728145528.GI651302@noisy.programming.kicks-ass.net>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
 <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
 <20260728143135.GG651302@noisy.programming.kicks-ass.net>
 <amjAxhL-IeeJITEv@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amjAxhL-IeeJITEv@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 192641C000F
X-Rspam-User: 
X-Stat-Signature: 364eiyfygooi8tthuwi9pp46niguhszo
X-HE-Tag: 1785250536-545362
X-HE-Meta: U2FsdGVkX1+hcpkz2O18/8URpwGEA8EUF7CJZw4h3X3E5pEgW+VvTMQIL/eW0zfKZ2HOiXxRTFfvyGwvn8ozhlVH1igXxNuLDvNShYK3J8fBKRhBA0hc8SYYpfJVsZuoeBTWGu142XtEL0KFet1AHlF8Xo/SAw/mzYy002DxHz9igTirWbr+nmdBYLP9SdVGlSmCXpuB0zUNE6ofMscr9/SSnqH8kPtyOylk0KTAsvqix+UTMu0XwhvmRXIWSbf9zDZLaBtUHAHNlHV/Vx1B3FJHxlMfT0BC1ovydag8ZGhdEgPv+l8PmaHWnpXca4hCF6uoSabGPu+RC+R4vhfFykMm85gKOQ2xv2SFQTy8kqTc5SJKAI3jvLxVfJnNc3atw2Ohn/b0DWEKTmI555ERzfWJ5ovzfYlcsSS3cC43hazZfCQX3zaIRvw7pEc7fIrmEguLi0ro3WnPMmpV0KQ3wW0EqkT9gyFiQvg84Z2NILGpg6sZgy2OW6e8EbUdeHhCxEHGmDJar4vY4dnU43LhY/dXp1zADVWuBIzLCdgbnVTbxOgzmEPA7EBgOUXOATYHhxdfmU69BtYM7jzjbKkSR4pdhlCyubwg4dFOWgI+XkXxvQ07LclNuZHadbGXkrm7Nc7L9fw9Q+KQ7JSEhtorVgLYQocaM+CE5/ZDHCZoy8zC1jixICugq2Jlwu//2+UnxE02EhSqF6vlr6fpIVCy/CVps56EBAluz4pA9jfHCBq40ifXBMoBkC6XYqDxAah5781yEvrLDFsgf+Zeqw7VM1ILzF/YB+GkoAr5bZGsIxEVDbvUPMCwsEwpmwtcw1tEzFbsvRQ6urqSo3mdXgfuO7IKxv/zHvCVlOdv2ONuPQd3EcG+9zEIiTFESqhKshfOopOsnvliXNXnza9dP2geZhMruELPsCDugODz7Q8AiyZ2xh8WIlJtmG71AX4iowjCrxZzQ1wnzZpBpvZTgoc
 tg4F7Yix
 7lYs25DRhL0pzmbysJyEn6P7tXISQpV15jb4jf7Ge2pl+OqbM+4q9GsICNUqZ4i1s2IorhjZ4Bt/GraDOuexyJSiIGeUHFmLJO6ColjFQOthHt72718oMKPH88HYFDXcGEjWCHae3r7FNPB4N5FNiCQWt7/zkLNoW7/BQMcj9TXojPCUs23uXuiYx7uciqAVn09WLvZaX9NL0+SNjXtF9p4Y+vKKhYQqHAwIgfPAk89rXgiZBikRYJLDAA0v81QdpahkqmFX9TWqXsk5kgvEKLvZHmX+2SD7b1D/HEo7SocCZQ/o99Oaa3fKNL4ElYoKvLn0YuE/Tr5bVPTmgZ8QYncusP1zugmYILh/You3mrDr+bOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 05:46:30PM +0300, Mike Rapoport wrote:
> On Tue, Jul 28, 2026 at 04:31:35PM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 28, 2026 at 07:30:27AM -0700, Dave Hansen wrote:
> > > On 7/28/26 07:21, Peter Zijlstra wrote:
> > > > There was already a patch merged that removed the shole debug_pagealloc
> > > > exception. Is that not better?
> > > 
> > > As I'm scanning through email this morning, there's another issue that
> > > popped up with that patch. It's causing hangs on boot.
> > > 
> > > It's looking like debug pagealloc not taking the lock is actually
> > > functional, not an optimization. Although, I hesitate to say
> > > "functional" and would prefer to use much less nice words to describe it.
> > 
> > Yeah, lets figure out why that is before we retain this wart ;-)
> 
> As Lorenzo said:
> 
>   __kernel_map_pages() can be called from irq context:
> 
>   < GFP_ATOMIC context >
>   kfree() or whatever
>   -> ...
>   -> __free_pages_prepare()
>   -> debug_pagealloc_unmap_pages()
>   -> __kernel_map_pages()
>   -> __change_page_attr_set_clr()
>   -> cpa_lock
> 

The TLBI hack in __kernel_map_pages() makes me wonder how any of this is
correct to begin with. That comment isn't helping.


