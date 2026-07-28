Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D1BC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653A46B008C; Tue, 28 Jul 2026 11:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62AAC6B0093; Tue, 28 Jul 2026 11:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569896B0095; Tue, 28 Jul 2026 11:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4B46B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:30:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD8E81A03FF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:30:27 +0000 (UTC)
X-FDA: 85038572094.21.8233C4B
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6F9FDC0010
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:30:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=C+NTxpFk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785252625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7a5jh4qeutPWij5dNaVnpBg8RmqFNiNHJXuQhNtjlI=;
	b=Y64Q8Vr5y39BNsJQDr+1do/uu0nACimJG8pT5q3PjB7eAcKxr3Apin7xQIlbghsYWrvpFe
	qpVrwsf2u6lOTi/4ALwNGsSmJ6MzA0N09YyrswxNX61AGxzI9qO5UJWTiAy0HYdMAzGvOi
	omJKR27KWrKMo382JRx5hQ/CxsLaa2Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=C+NTxpFk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785252625;
	b=7s8SNV8tzmsU6vYrerxltEK5S2m6FqumFEegS7rLIkhevOLfNt1+7c701dx0xyo29+kH0g
	P60WPncpRhX/JsU5hJuxnWjD3PRC2Eod1Lh/+i8nT4jJW2yXx7Jt5tRIuwgtj8TlOFfQQH
	Cp1MFGKVPB/N+xqwRT9Xtz9JP3CCZ8c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r7a5jh4qeutPWij5dNaVnpBg8RmqFNiNHJXuQhNtjlI=; b=C+NTxpFk6RN70FEbbxxwCZACaE
	NKD0at/vSUIsbpF17jcNDIGkoYlGuJ5AWosQJ5EsVCZzWRFdtA3DJjcI8TBsWu2ja0A5VXsuxXbub
	LALrm0td7goVArnlPrHF6uiJmB32+SwGMdvQ0uqbN7hKgP3yhzLnVXvFiCy1NtgRBSbynF3/G/Jih
	JfAaHU0zd+25WVu9GnQQrsRy59s+M+tXRxEoS218dvjt82ncwTM+I8mpYTQjfJqt+ZoqU9um2Zxjt
	w5fbVe1PqoU22ZVBALqCI7H3jD4gCH1gYbx6hl6iIEkz9w+9nOo58UMDNYA+ZGPEd0EZVMsKLz+Pz
	S32mj23w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wojl3-000000054s3-1WyI;
	Tue, 28 Jul 2026 15:30:17 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8F4AE3004AB; Tue, 28 Jul 2026 17:30:15 +0200 (CEST)
Date: Tue, 28 Jul 2026 17:30:15 +0200
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
Message-ID: <20260728153015.GD921102@noisy.programming.kicks-ass.net>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
 <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
 <20260728143135.GG651302@noisy.programming.kicks-ass.net>
 <amjAxhL-IeeJITEv@kernel.org>
 <20260728145528.GI651302@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728145528.GI651302@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F9FDC0010
X-Rspam-User: 
X-Stat-Signature: iw3aukdfhs5g9eq45ank7xsrhuuxicih
X-HE-Tag: 1785252625-550281
X-HE-Meta: U2FsdGVkX1/F9bNq17BDWF7pS8N+WCo89G0id9UBivzwyZMe++fsOSV6vkSrcf5o1nK8W6Jg1l8S59Rr36U3u4SZeiMkHY4ttBK04xjz99V0V44rw7EpmpaYkrUmSnSFjdf5cWG3qrlgSD37CJlSpD2I3NTBk6BT9b4ZrYvHk8Mk8AIKQ91NRptKWWQ4VdRkbEznVHHofH7H+6+q7me3pjNRDf60a8sSETBdT8n/xhRj/Kx9Wmt8nOn09K+g6smnbGItpQPH9OEqfBG0wJgRDUZbyHBGd6j15UPKGFG26WASrhS5iwYc4WCihnJF2lQmN5V4V7+fD+u2QzTIQ8egu7biX4exBLU+kkiUl9UC0ouGrG0AqKTGmcszhkN6uIwY19TYAKRbRQty1Rp7sGJ/hXG1cYVr0OafG7qNNuL8GN2Je73EykeBPWsK2Pnm8Qm7jKtbkNvV4GsqARAog3CO0/vgc4zoudLh7ziEfL6okPwgr86SOPTMXB6xdI18VQzyR98QchqJjwn3sb9FI1ykGrHXfTRpkUciabwcznhpFViKgdltrN6/I+2FOMed4ggxFaS45xZG2SiU1VKM6tU+mRTBptC2mmR/rKF1S9pFvrxP7msc+a4DU6TEzuGu5cDGyBfKilyhoWfk6SeZK+k5otQ1T49NqzA0EZNiTOBFcw7GA59M6ZnGLnI8NoWUjKG+Bzm1iKJ0orLUkxtbhVPgEqeyinrQ0KcTd9z7wdyq3nZbaPDXMGSLAYgD+nkXCjuzI+dNi/TrNmt9i7xLUFMP1n/w9+wfAWbbYr3cv9bwDBNgK9qERiy4J3GEElubTQMb/aI0taN4lV/iKUxgVBJXCokIDoXXnuHJbonDjddM3AlrRi7GdPfx3c4IadmPybdjPHNbv6wHbuXzjIcPFcULu55NGG51MrXloYJcp6tTaqskC71BjorX+vC2wWG2h5Xp8W+a1ANwcipNa/j5rLD
 CYrT18+T
 JOlphiLWFpjHL9TcqrDOTSP9perTl0i3aP705cP92UUguiWyy9A97Sh/Clu1/nFmtswDvdT77akefGAr3mb7efPqe0AXiFkq9tztzstq7vk9wj/xgCLY6OerTKwf2zM7H5ZqhqFy9Pe1g0WIZ0Nrw88w0my83npstXlAm0TnfuhlWgDZH1KNL7H8bDDl4CKGhOF4HptxXMdgD/Ej2BaQw+9sWVXPlLP8F5R8C7aQFq34IFoYY8Cl0U12JfbIZhRnphAVj9tXGa8EkWWZp2A6LPFM/Rx/YbcFtfKcsPmguq3XV3PGLAAyJlr4U466M+QIHJqX8MgFhxeb0csw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 04:55:28PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 28, 2026 at 05:46:30PM +0300, Mike Rapoport wrote:
> > On Tue, Jul 28, 2026 at 04:31:35PM +0200, Peter Zijlstra wrote:
> > > On Tue, Jul 28, 2026 at 07:30:27AM -0700, Dave Hansen wrote:
> > > > On 7/28/26 07:21, Peter Zijlstra wrote:
> > > > > There was already a patch merged that removed the shole debug_pagealloc
> > > > > exception. Is that not better?
> > > > 
> > > > As I'm scanning through email this morning, there's another issue that
> > > > popped up with that patch. It's causing hangs on boot.
> > > > 
> > > > It's looking like debug pagealloc not taking the lock is actually
> > > > functional, not an optimization. Although, I hesitate to say
> > > > "functional" and would prefer to use much less nice words to describe it.
> > > 
> > > Yeah, lets figure out why that is before we retain this wart ;-)
> > 
> > As Lorenzo said:
> > 
> >   __kernel_map_pages() can be called from irq context:
> > 
> >   < GFP_ATOMIC context >
> >   kfree() or whatever
> >   -> ...
> >   -> __free_pages_prepare()
> >   -> debug_pagealloc_unmap_pages()
> >   -> __kernel_map_pages()
> >   -> __change_page_attr_set_clr()
> >   -> cpa_lock
> > 
> 
> The TLBI hack in __kernel_map_pages() makes me wonder how any of this is
> correct to begin with. That comment isn't helping.
> 

So in particular the from IRQ-disabled context thing seems to be
clearing the 'present' bit. Not doing a full TLBI on that would allow
other CPUs to still access the page, resulting a lack of faults.

I suppose that is a non-fatal case. It makes the debug code less robust
than it wants to be, but no malfunction.

But debug_page_alloc_map_pages() as used from post_alloc_hook() for a
GFP_ATOMIC alloc would result in not propagating the present bit,
resulting in concurrent faults. And I'm not immediately seeing a fixup
for that in the fault handler.

Hmm, perhaps spurious_kernel_fault() handles it, after all, it would not
actually observe !present anymore when reading the PTE, its just a stale
TLB entry at that point.

Hmmm...

