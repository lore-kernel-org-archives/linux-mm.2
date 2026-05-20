Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF1BCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 04:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8436B008A; Wed, 20 May 2026 00:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380246B008C; Wed, 20 May 2026 00:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297006B0092; Wed, 20 May 2026 00:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1813E6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 00:49:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4C9316037B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:49:40 +0000 (UTC)
X-FDA: 84786570120.12.8910BC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF6CF40006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:49:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZTGSwtJw;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779252578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tk2ES+Q3aJ0Hik8oCA5uTW4MnCjo5aHhcTtkv4972Ck=;
	b=zCfOJ2gGDECan23HIpTjroNM0qw51fnVuKM5/I2DK9rj4fv6yCvwSB21uh8TMcd4CF0pjS
	K0lm8G9dgHyFPjTQSs82HKt/bn7wvh00e2IF8HossH9ygvOADz/t+rBgTJcgHtcGaxNthp
	DJJYujSXelk70I6ulCMYzej7uEikaxQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779252578; a=rsa-sha256;
	cv=none;
	b=4aKpbzi+t/eUQYQkdcOvT9GNqMrHd9/2LmOl0JZuYGnQmoAQUHFE3jspmiBGmPrBtpCFm4
	85GJnGJbNebSgtLt5Cxoi5PS8Psl/acuij8YYxePCsA/GYK4BYoM7+MNJ46o8VLrBELpcA
	wn79xuwj690tn2TGtzHV1lxrK6M1a04=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZTGSwtJw;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E46044065E;
	Wed, 20 May 2026 04:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDE41F000E9;
	Wed, 20 May 2026 04:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779252577;
	bh=Tk2ES+Q3aJ0Hik8oCA5uTW4MnCjo5aHhcTtkv4972Ck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZTGSwtJwOo8pDeyMJs2WKS4u/0mO8JTu5XBp2wgVPVK8YtwUxoDHAW1cFpv1T8rcM
	 hmPKJRUDOpSaG8VQmetvCbeNXtV0w7oqEW5Zh6YE1pt/yUqM7TMkT5gaALgw0blL1P
	 biDwfFU5xLlGfnVut3my08IajnDqDr/LV51SbgIqGjZBLjLvU97TCzOL9cLVBPMGeu
	 xy8icAcL7LjpfY8ySeVxmFRBS2QfANLgUFCyjX4rj24rX6UXyP38OL2d4BBP3qK5gk
	 SVreGzzqfmkk41m43iY6FajidL64ANLCAxa4bSTUWbWX4DFeo+ypJCArXndJCQQokd
	 lCzkWMDVcCFeA==
Date: Wed, 20 May 2026 07:49:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Juhyung Park <qkrwngud825@gmail.com>,
	Vishal Moola <vishal.moola@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
	stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
Message-ID: <ag09V3UyN2aWA7Wb@kernel.org>
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
 <5d00b63c-1802-450f-8e54-8da6c0aeedc2@intel.com>
 <CAD14+f2p7D6eco+-O0X6zWwi-XaxGLs0nQKDAC8eVWhQmB1VhA@mail.gmail.com>
 <e38e5fd0-db57-417b-a2d1-0521333ae7cb@intel.com>
 <CAD14+f3sohXj9SKEkRXGK_Mpbp73R5az-tsiHnHkj0poBHwpvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD14+f3sohXj9SKEkRXGK_Mpbp73R5az-tsiHnHkj0poBHwpvw@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CF6CF40006
X-Rspam-User: 
X-Stat-Signature: fq3daus7waxiyd64138u4khwzaxtrcc8
X-HE-Tag: 1779252578-44510
X-HE-Meta: U2FsdGVkX1/cuhtHx4WmhR8qrp5u8t7fxAadccCwbRDrzDGNhvRnxmwW1E/GEQ2VSKeexYZ7rKs1WkbqES7o6w2rMh3ZJCv7C8BZ89NGqqk71tU3XDpzkcApDNFe60D3/GC4BH/tfSPEODCq5BWGhtSHte1Jyw+tsbs7+FgLgYjogY3S/hLihOv34Iv4a0RAmfyFMcdIIk+LULK1Fjwcgaz0C+EFC8jiOVcMnuP3+wxc5f+VomVt8oNYif3te3BWPY5E1oDaPXvE5+Nj/bp0ruOslHcNd+8nDFbtNeo9HigSX56ikfD+Pg1jqHXzpxTJtiAjzToCAAgybkU4vPIDs9i2+kMjYLsRHzUFZy/NLIUPdIbnozhgzInk2Uh9z7o/zzpEk/DgdbYGrTBBVT+LsMiNJ4UN433UK0Qd10JKsUBnFZaim2+N6OKCYsOgg0+116+c18xrMELKNczGVZ0PBZFrkoFjwfdQAiutvmRln7g81JyItpVPK0D+PSvcZVi3GqcK4ZofPCGF2tfPTvjegGAirPuNdi78rR/20PeqR7tDSB51ntHe6keTRW9PD2dMHlLbomjBdkvrxhP77oog9rQrPAGxvXeOXnsQ1BbHJ1j54XQfFSryfUuR5ODRu+XqoOMGy41Xj3Iri/ZsL9MLzqq+Wv3ke/NlIpDMebbBvAb267GwVXnL9ONSb9qSCsqA5HXGtKslQKFDmWFjV0crMHroNEVEERmzTspgDtJxxbXG3s7qqrw8HH9PFt1e/snUWMHinXpZXgM62D66DSyLV/HfSW48LKzIRmi73tveKuLcUtfDxDCxTFsWKQ+GRNg0L4Pghj0eMyL/g2+e6qh8+ktQNqweNfPIKPJ6o9vxnUX5qXuxJsNF1p1J9TMRn1uJasZZ7FFwiZfTDuzlR4jd4ylOkthxM2Us/9fXd1tLAzVln8DPozU+k9yOqOikJfYJjpWRqjfd53hgQKnUiZD
 Joara4ib
 W+8Y/pg1MVPd5q/pBQCI8tubb/hYBKQEWVOt6orgDNKzve+uMq5T5CaLPPd0JGK9P+iQyb03rAFzyZ2jilJrLSOr1bjMdfAAB8SV9VeB9vPWvIEQkwfKcE3Fi+8k6YDusz6VEC16zk9ck1NJKoe0jRFyZDUxsGpS39Oofs0TraxX6vYMmAECA/qfFLD15OtD60LKVfUzGza4mYyh5cNsgETKcaFji6aHnYh9YlsfG5bjBRmwK2A98kIutc1y5K5ochVMSmBJ4PM2PpZNiTmdlOx2YQNakFxvJzt9HIedEPmK8FzuWvQ9m2+5DPofn/h83ef53bZ+u5zy0WBxQqUla+ky+rgTaPa3LfOkGbHHUNX2S4kziemFMqdm6xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(adding Vishal)

On Wed, May 20, 2026 at 01:59:49AM +0900, Juhyung Park wrote:
> On Wed, May 20, 2026 at 1:41 AM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 5/19/26 09:27, Juhyung Park wrote:
> > > Hi Dave,
> > >
> > > On Wed, May 20, 2026 at 1:02 AM Dave Hansen <dave.hansen@intel.com> wrote:
> > >>
> > >> On 5/19/26 08:10, Juhyung Park wrote:
> > >>>  #endif
> > >>>       } else {
> > >>> -             pagetable_free(page_ptdesc(page));
> > >>> +             /*
> > >>> +              * Use __free_pages() to honor @order: vmemmap PMD leaves
> > >>> +              * freed here are not compound pages, so pagetable_free()
> > >>> +              * would lose leak 511 of 512 pages per 2 MB chunk.
> > >>> +              */
> > >>> +             __free_pages(page, order);
> > >>>       }
> > >>>  }
> > >>
> > >> I find myself really wondering how much of this came from a human and
> > >> how much from the LLM. Could you share that with us?
> > >
> > > Not my first kernel contribution, just so you know. (first in mm tho)
> > >
> > > I asked Claude to write both the commit body and comment and it was
> > > too verbose. I manually trimmed it down.
> > > Sorry if it still sounds too LLM-ish.
> >
> > Yeah, it still sounded really LLM-ish to me. Still rather chatty.
> >
> > > This was tested on a VM with virtualized CXL device and toggling it
> > > back and forth was visibly causing leaks. kmemleak was unable to catch
> > > this (rightfully so), so I skeptically asked Claude to see if it can
> > > figure it out while pwd was the kernel source the VM was running.
> > > "Access the VM at "ssh -p2223 root@192.168.0.185". There's a memory
> > > leak whenever CXL memory switches modes via: daxctl reconfigure-device
> > > --mode=system-ram dax0.0 --force, daxctl reconfigure-device
> > > --mode=devdax dax0.0 --force. Figure out why. If you need to reboot
> > > the VM, do not do it yourself and ask me."
> > >
> > > It did in 6 minutes and it basically told me to revert bf9e4e30f353. I
> > > was very skeptical and reviewed manually (with my short knowledge of
> > > mm) why this would be a correct fix.
> >
> > Neato.
> >
> > >> We're trying to get _away_ from using the 'struct page' APIs on page
> > >> tables. This goes backwards. Worst case, do:
> > >>
> > >>         /* vmemmap PMD leaves are not compound pages */
> > >>         for (i = 0; i < 1<<order; i++)
> > >>                 pagetable_free(page_ptdesc(&page[i]));
> > >>
> > >> Right?
> > >
> > > Shouldn't I worry about the loop overhead? With order == 9, that's 512
> > > iterations. That's compounded to O(N) when the entire memory size is
> > > in consideration.
> >
> > Is it optimal? No.
> >
> > Will anybody ever notice? Also no.
> >
> > Will anybody ever care? No sir.
> 
> Just spun a test with that loop. It doesn't fix the leak.
> 
> I hate to be the guy that copy-pastas LLM but this is outside my
> knowledge of mm. Claude suggests:
> "Each pagetable_free() on the tails is a no-op: When
> alloc_pages_node(node, gfp, order=9) returns without __GFP_COMP, the
> buddy allocator only sets _refcount = 1 on the head page. The other
> 511 pages (page[1] … page[511]) have _refcount = 0. There's no
> compound metadata, so they aren't "tails" in the folio sense either —
> they're just contiguous pages whose refcounts the allocator never
> touched."
> 
> Any ideas?
> 
> Thanks.
> 
> >
> > Can you measure the difference? I'd wager a beer: No again.
> >
> > Even if someone manages to notice, then you have a clear path to fix it
> > *right*: fix the ptdesc data structure to represent high-order allocations.

-- 
Sincerely yours,
Mike.

