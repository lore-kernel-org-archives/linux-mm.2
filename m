Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C967CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D3C6B000E; Thu, 28 Aug 2025 04:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04FD6B0010; Thu, 28 Aug 2025 04:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF39A6B0011; Thu, 28 Aug 2025 04:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB2066B000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:06:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CE8C119813
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:06:25 +0000 (UTC)
X-FDA: 83825433930.04.336C829
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 94C3E180016
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:06:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vBGjtF+G;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756368383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDvtHRzQtU3kCixyIjuOCQ09hTrFj2+oewMln+u6hX4=;
	b=gGOdxG50Qw88NHz67YOAlWu9txFLY1y7uJW5X3U1wRxoU/nagvk0SukdC3SZdfl/FSwWzZ
	G9j/viRq7JQEA1f8obfGo+uB3EjWLumDFdGxxrIh4Myruv3lWIvGqRsXBe+F60mhLeQegr
	3OOd1JdCT8w0beO5VyO8c25zCIooF6s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vBGjtF+G;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756368383; a=rsa-sha256;
	cv=none;
	b=i6/VEdh7ATeGlRg7b1AXID4lWZ6M02SOiR2WghW9bB8LUGe6C/vTcxSoYs0MjcalEgg16U
	ugyIRCedCKTuZ+Fzqv8IpZrnF5iC5aCZRnaL7yW3pZWLL8A1gpn9U+idaiYbfXxIhpZUmW
	N9xGvao4nL+V5u8pSCwlLCzk8XMIr0E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62110417C0;
	Thu, 28 Aug 2025 08:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04174C4CEEB;
	Thu, 28 Aug 2025 08:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756368382;
	bh=8h3kXegWoTZB71c0/EOwOGHCDp9sWcsK0sA1Fhv8ieM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vBGjtF+Gn0Ojo1KVedpXcUo5UNPKTP/e/wulKW1x/vz4AZ2m1wZ6thc/Lps+xlQF6
	 DwTPlbi9e+FvV8tPla4md0hJavNfKkFh5xzuaITPDW7oEVPRJuMnRQWVL0KaIZNEg4
	 4T8RWZ0Rh3tP7DQ1cUFf+tX54SzZArEKNTK8B97r3LwqCLB/OYDUdoSALNtM9+F5Dv
	 KS7BJVC9pXBz7unzWbhSWZxMJ+vW4HayoOqIpbx1GOFj1iYowGmGtL7JMjJ/av8GLW
	 NBVH9qH0fuKVNbHUV4tP2RMgGBJTXgbSoYrIDxxmnUwirlVFE2Z9r3rXRQTzilPCUm
	 zB6/THzmytDdA==
Date: Thu, 28 Aug 2025 11:06:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 13/36] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
Message-ID: <aLAN7xS4WQsN6Hpm@kernel.org>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-14-david@redhat.com>
 <aLADXP89cp6hAq0q@kernel.org>
 <377449bd-3c06-4a09-8647-e41354e64b30@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <377449bd-3c06-4a09-8647-e41354e64b30@redhat.com>
X-Rspamd-Queue-Id: 94C3E180016
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: utxmqma4d5rdp76rkby9o17xqtynge7f
X-HE-Tag: 1756368383-484603
X-HE-Meta: U2FsdGVkX18i+sra7xfZAi6exnD6xzgGbIh7feGhNppCbWUppwnJIyIR44mwLDwtS/h60EOhd/E9k4njJ6M/Db1nFinnCCf+vLzMA79d1LdX3PkA1rFTBSW0V5dUwNsX/jD0pAkdkn3nktPK/QiBsWs76O41vO9xdDlI5La9HIvkRSkW6M6efIftdFj5hlCL7pWJyBXF5PZP/nJiERc82ErB4aNtYa9SjN1zNDYmcm89FYOdCNJ7EogxYKMLRq8pJx3UV6oF+3ghVf5mPjyyx8friHwhTfUtBhNgNsFH23YHw45VF4gCm5C0p7iyvXr6VnzMlLzNbkA94NCwPGpIhLSEyjiSTjy7Tt+qtpPjk5ydjSHdI8AVwuW7Boov2/ffllYsYngwk6cVlxbkTIdXTFhEyfqzQkK8X8A90Wmfmubjn5tVnoMoJ12eG5s0LaiLmI8GuhytTQ4oWHuS627FL/naB+fmsGKmG8V34E7z1lWvPPbcz3vs08ErAiuo6vrtU70hVjfLki6j6yIoIYUD9Tg+MMCJwuN+g0iIu+HDfFkC6TKSWgHAGNGygLPY9zFYvA+QkMHrHgEtEtsf/yvOvysfsFCmD0cjP/NORvSrjXLCKaqL58zaX8svzEi5xBKsfTvOhnr8EmfWnAl5JtAXwY4wc30wiFxHEPfCXYMAEkch+hfhj+8VfWoAEA7tjMItRifzYiHQfk4Xmvyneu6ZXiH/SJG8MLIa03Qmg3FjL3FRmXG2l9mnv+KZOKGG/SgRLSbgFRDqwC17gcqMEEMucppAaqRPa7hjz4t/NGIDcRGzZmW+NHsW1KCRw3EBnyQeCNhES/PkJu3Bz3/8T35dX7gKBCINyF3TioXr+nHtEjNLInsX3PG7O2UDwRxh1Krq8I1zhwYsucFN20BhfY1f1HWW7PmjnHp0fvzuY1ojW0xJXLbjPG/ZR7mH0L+Xw/MEwgJH+oQr6W5iQgqg+jF
 ZOz2ynUk
 WnNTOik23t7rmXGr4uxgoYJQ5MxQjvWh7hBfnG2cHcFhmL/YzrSaw3P3ADp7Rp6KBfYXA0dP1A9ZSL/j/s+uCwybaDMgMgWRTsjM83TMl3KsS4prRiUjFkKJPrHSgUZiJCIYXnxeejkMEFqEiwsvLo1ZU2FHLz4UTCsFbCqlFGNQ/h8tNoGt6H5sSENrhP7iShDGRQQdAVYZycci+SaDiKbKi2t+ocjQ+pXDOPg6eyFzULeiJayyY3W6j4zGh/kMKw+5nyBMv3QOgsYfTZdnR62MiiXXbSufdRo2xz+ly2uUY1QHyJ03/avKCT0hWKlh61akPQlMFvFkvSsY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 09:44:27AM +0200, David Hildenbrand wrote:
> On 28.08.25 09:21, Mike Rapoport wrote:
> > On Thu, Aug 28, 2025 at 12:01:17AM +0200, David Hildenbrand wrote:
> > > We can now safely iterate over all pages in a folio, so no need for the
> > > pfn_to_page().
> > > 
> > > Also, as we already force the refcount in __init_single_page() to 1,
> > > we can just set the refcount to 0 and avoid page_ref_freeze() +
> > > VM_BUG_ON. Likely, in the future, we would just want to tell
> > > __init_single_page() to which value to initialize the refcount.
> > > 
> > > Further, adjust the comments to highlight that we are dealing with an
> > > open-coded prep_compound_page() variant, and add another comment explaining
> > > why we really need the __init_single_page() only on the tail pages.
> > > 
> > > Note that the current code was likely problematic, but we never ran into
> > > it: prep_compound_tail() would have been called with an offset that might
> > > exceed a memory section, and prep_compound_tail() would have simply
> > > added that offset to the page pointer -- which would not have done the
> > > right thing on sparsemem without vmemmap.
> > > 
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > ---
> > >   mm/hugetlb.c | 20 ++++++++++++--------
> > >   1 file changed, 12 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > > index 4a97e4f14c0dc..1f42186a85ea4 100644
> > > --- a/mm/hugetlb.c
> > > +++ b/mm/hugetlb.c
> > > @@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
> > >   {
> > >   	enum zone_type zone = zone_idx(folio_zone(folio));
> > >   	int nid = folio_nid(folio);
> > > +	struct page *page = folio_page(folio, start_page_number);
> > >   	unsigned long head_pfn = folio_pfn(folio);
> > >   	unsigned long pfn, end_pfn = head_pfn + end_page_number;
> > > -	int ret;
> > > -
> > > -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
> > > -		struct page *page = pfn_to_page(pfn);
> > > +	/*
> > > +	 * We mark all tail pages with memblock_reserved_mark_noinit(),
> > > +	 * so these pages are completely uninitialized.
> > 
> >                               ^ not? ;-)
> 
> Can you elaborate?

Oh, sorry, I misread "uninitialized".
Still, I'd phrase it as 

	/*
	 * We marked all tail pages with memblock_reserved_mark_noinit(),
	 * so we must initialize them here.
	 */

> -- 
> Cheers
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.

