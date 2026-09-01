Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C9DC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECF476B025E; Tue,  1 Sep 2026 10:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E809D6B025F; Tue,  1 Sep 2026 10:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F146B0260; Tue,  1 Sep 2026 10:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A76FF6B025E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:41:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3630E14042A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:41:43 +0000 (UTC)
X-FDA: 85165457286.20.59EA1C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9B457C000C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:41:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DCkYCgJH;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273701;
	b=FwYI3KvgwbljFPOF7ypg14OvMoVyaakO1unljGDlvEF2poE1Dc5Uq67NEkaL4q8w8iyHT8
	Wm5gpxdAyj/stmUYxOud1k/xPJVUq9h6CovL/vjRuOLYH95oZlUdrozzcdGKTLRcn8pZ7G
	vOaF06/PJ3I4TFub02noCohNm17BcRo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DCkYCgJH;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aD1aeCXoZUTVkYkw8DYLgpTcX29H0YL7tFV55GqLOUs=;
	b=KccHpm+OEY3uWiL0qa7Ti+5pwCl9DPslszcfUKUD9A31mko6+1khh0qJQYB5YwX4FNj5Wu
	EEuHWMUJizqhxGyQHnhp+qQ5fOe17n/34Y6bpmODEO/JPjGBTCd2Nc7AA5kVSpmf4vCKz7
	1EWgS+TC+EGoPsQi7Y1XQVnGC7zYG3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEA18602BE;
	Tue,  1 Sep 2026 14:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A26C1F000E9;
	Tue,  1 Sep 2026 14:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788273700;
	bh=aD1aeCXoZUTVkYkw8DYLgpTcX29H0YL7tFV55GqLOUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DCkYCgJHTMeXpcfI011IFyZWluRGgMafgbwW8u29qgQBVZ9Dxsno0gDXnl7hHZ0m+
	 lkqnWV4wHDwKSWKnoQda11OIQ06fvWLfa32Ye05qYmX1Z7boJPT6aJZEl4EVv8r+G6
	 Q8c5h5Eq9o8u4IVkNkDvCB17dlRL52JTqjsLsbOVCb03G2bti6Yh9u4sRvw0rWJ1Ca
	 qwHtYbfIXyVj5uLcNFlMoaGF0xHllKs6NACCcVCPrJufvl5Fed3xFkkaUWs7j7W7ZV
	 siJKVu6dFavxSGvLfYUXvuVBZcE7zllPLV8WeZFb1IHv1rO4zZ/Mqb/Gua1p6L6cXY
	 pVvsocfBPnW+w==
Date: Tue, 1 Sep 2026 15:41:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, 
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
Message-ID: <apbiB51hjm-9pRzf@gremlin>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
 <apbOlyF77yDCV4cF@thinkstation>
 <apbcoMTVlL42G5tg@gremlin>
 <20260901142408.GA56830@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901142408.GA56830@ziepe.ca>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B457C000C
X-Stat-Signature: f53esnrw3gfzor1irqemrefwxesh9mou
X-Rspam-User: 
X-HE-Tag: 1788273701-846243
X-HE-Meta: U2FsdGVkX1+7yFwj7xnXjAM1dxwAHWJkHYnUTV0yeH80xIkAekJ2yAGIofRj91+z+OoA4nVwt72nLWquDSU67/0KXjbuk6En6Ne2lDDVQP8XidfWfyj9iaWdZaMe+ciEf/1IDwQrbjDps/Uec5XkBQsVpkof1n148otwFyTQ+l5tHti4cEvGoNCSFLASGnIBwDz4EJGhI+GUU0WgeoE0d3+8HyyE+6lhU+Cy2iWea8WD/bUmt9C/yQy2h7AuyCxpOAuXc88zo5tIn1dRfAtBPMiUJr1U3Y/XDFC4i0M1rR13SHdV9PYJhYfgR7CKdliEiN4HG6s1C7XN+W41kTGwlNbh/ZPKEoBBg2QlFaD+iohz1ba9fFn7tqLJo6jFLI1QVY6oDYkSl0QwRamvDX1Hexi4rOgbKqeZBebquWtPUGMt4eY96sXPrmDlDPIBhuHMwSqgqApHki9mjPJHnaESmvHa/dcNtTc7JJWNhlf4orSXhU6hXedMUI3jL/W2XZY3QSsui2qvwtk4xSRKgWNfHIvOp5+sQwdTKnR9PQmEMIcc4j4AFdh03XGHBiG2XnPYHPNIBYMObJd17p3V/Spk3+8uCnqSLf6BKccqsrI86RMmaalPSkeszhYt5EiUAheLdiZjmefkU8MU8cJD4hlPeFgeGE23h/vVoc9YzVUe7OrTSA+qnuIUAIg5+OsoUyPQG+h1jOTXcefoLXOnCfMQmwaQLuiLi0OQky5EM6sJbfWZ4I8RO9aC7FMe35pPkOnko6Nr+3/qT2B8oBzn90CxqPfZUiNN4z7MEMbRaXt5d+bKB3ERT+7faKk09sK91kpSKKrkr9u5p41MNvd+zlFrlgVQmZieR7aRPIjZ7TvOYbB1MESRWDwKb03PYZbVygLSDmQrOEY4e0tvM/WmT83ARccoVIMlE/8cAHDQXLzE7bvHD+m+lCPyEWGc7SXbFPU2m01QNil+IghLpHcvIg4
 kOYDvRVo
 hp+GoLsyjEjdREGwUjKR9MMWgDFxSmwCcQvfTbxqofX3YKshpL3Lx253qjmGC5DWANUfQdH47uHEmssH4N+hjdvrEtlNwBIuaDr6FPJco40pOE+uSGga5KqYN+2BIajfYPlulLV6UIh4goIbo/TKUwSrIyA5vH7h6THnUlcMmH5Mdu6xvgWPU91RA0ebWie38buiz0i9aFwdRNeT76FYI2hk+Ktl5P22bcTN7gk2rbdxynI7BkRkovF5eVDsn5TXbDEA0Xh6dkRgJXxom93FBInmmzpdjoJLd1M79bVXzk2PREoyZ1NF+PhhNz8Bzygs6++2qKjpXyOz4JZq7VxtS1lIy6PrX2xnbgyqoyDOu/cGgOoCo0TLwKlINfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 11:24:08AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 01, 2026 at 03:12:45PM +0100, Lorenzo Stoakes (ARM) wrote:
>
> > It won't be costly at the time of the calls obviously as its deferred. Maybe
> > increase some time spent in softirq but again is 512x that big of a deal?
> >
> > I'm not sure how you'd both defer the free and somehow utilise mmu_gather here
> > either really, certainly not without it becoming extremely messy.
>
> The less costly version is to thread the page to be freed onto the
> mmu_gather through a linked list in the struct page memory. This is
> super cheap since it is just a singly linked list operation.
>
> Then when the mmu_gather is flushed it does a single call_rcu using
> the rcu head of the struct page of the head of the list. The callback
> clears the entire linked list of pages.
>
> Since you have to tlb flush anyhow, it makes sense to always use the
> mmu_gather. For example the design I ended up with for iommupt
> accumulates all the invalidations and all the free-able memory into a
> gather then invalidates and frees.
>
> This allows maximizing the tlbi efficiency too. You can't do call_srcu
> until you flush the tlb and if you call once per table then you are
> also tlb flushing once per table too.
>
> So if the kernel really does want to clear out 512 leaf tables the
> optimal implementation is one range tlbi for 512 entries followed by
> one call_rcu to free the memory. Hence the gather..

I think there's some confusion here.

This isn't the path in which a page table is being freed, the _deposited_
table is zapped, in zap_deposited_table().

That is, the page table kept in reserve for THP split, that is not
currently mapped.

It amounts to a __free_pages() call.

The TLB operations are in e.g. zap_huge_pmd() etc. and nobody has
complained about inefficiencies there.

So, unless I'm missing something here, TLB flushes play no role in this
whatsoever.

The issue Kiryl raised was that instead of immediately freeing page tables,
they are now batched up individually by call_rcu().

I personally find it difficult to imagine the numbers here would be
problematic or certainly cause anything observable beyond what is
observable now.

So I'm going to have to say, unless it can be clearly demonstrated this is
problematic, I don't think there's any reason to add additional complexity
here.

>
> Jason

--
Cheers, Lorenzo

