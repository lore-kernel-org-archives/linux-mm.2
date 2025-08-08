Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E4FC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 18:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE0F6B0096; Fri,  8 Aug 2025 14:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487F96B0099; Fri,  8 Aug 2025 14:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F4C6B009A; Fri,  8 Aug 2025 14:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 119E66B0096
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:51:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85C13C0417
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 18:51:19 +0000 (UTC)
X-FDA: 83754483078.14.CFAAF4B
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id B930FC0005
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 18:51:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=WGyqUFMD;
	spf=pass (imf28.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754679077; a=rsa-sha256;
	cv=none;
	b=yJPlDX/ijOOCnSs76i1V/RKrqbGwkvMZjyuBDs9YtJ1+5+UsoUUWk3UgsuBMsunN+HCIxj
	9+6i/wvqpq65Ev/jmFmjem9sjLOpLLJdUijQopXt4es1pSkOWHAWcSDhLpHwioF+DhiCg+
	0pRzO+oviEzfrL1Cy9b0DrW8xh8IfYw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=WGyqUFMD;
	spf=pass (imf28.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754679077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZMpLLPpWLfEcYOqjTqa6+eB/bqRZJ+BbYqsgnnPbkY=;
	b=KGncuWCrGb29pSLud0UlDeGOcru/9qGbYrK6wpQNTwM4vygT6QtrNKHZUscLa7NaEFCISI
	LXaoOdy25kx7cMhwaCE9GNwdixZIDjEscUURuia7dn+EMEiS3gTlXe2YvwHHnvLXSIcp1r
	9NclWvfgWSugP0vAdWO2TAc9gTjEdLg=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250808185114euoutp0162c911292defe8bfee54f2309b1e8171~Z31I7WGpl0720707207euoutp01Y;
	Fri,  8 Aug 2025 18:51:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250808185114euoutp0162c911292defe8bfee54f2309b1e8171~Z31I7WGpl0720707207euoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754679074;
	bh=eZMpLLPpWLfEcYOqjTqa6+eB/bqRZJ+BbYqsgnnPbkY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=WGyqUFMDFBBsAtsI8xiD1Ayr7WYuZYdyBJMCoPCRGfrVxwAdMcl3GCV7Qwkcc4nI/
	 gnDfUeRP8iiJIUgEStFM4TfVVnoq/LDogKUpBA2D+NmwrtJRryBOG1ru2ITf74oehS
	 IO287BU42jFk8ZARXzvIDO/cRSfPjtUJVNlWylGo=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250808185112eucas1p285bfbeb3352a16df0b5c8f262fadbf2f~Z31Hzuzfc1555715557eucas1p2H;
	Fri,  8 Aug 2025 18:51:12 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250808185109eusmtip1cf791168d581e5b5b824a27d8cdd9069~Z31ElK-rK1126511265eusmtip1F;
	Fri,  8 Aug 2025 18:51:09 +0000 (GMT)
Message-ID: <a154e058-c0e6-4208-9f52-57cec22eaf7d@samsung.com>
Date: Fri, 8 Aug 2025 20:51:08 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v1 00/16] dma-mapping: migrate to physical address-based
 API
To: Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc: Abdiel Janulgue <abdiel.janulgue@gmail.com>, Alexander Potapenko
	<glider@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Danilo
	Krummrich <dakr@kernel.org>, iommu@lists.linux.dev, Jason Wang
	<jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
	<joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Juergen Gross
	<jgross@suse.com>, kasan-dev@googlegroups.com, Keith Busch
	<kbusch@kernel.org>, linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Masami Hiramatsu <mhiramat@kernel.org>, Michael
	Ellerman <mpe@ellerman.id.au>, "Michael S. Tsirkin" <mst@redhat.com>, Miguel
	Ojeda <ojeda@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Stefano
	Stabellini <sstabellini@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20250807141929.GN184255@nvidia.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250808185112eucas1p285bfbeb3352a16df0b5c8f262fadbf2f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250807141938eucas1p2319a0526b25db120b3c9aeb49f69cce1
X-EPHeader: CA
X-CMS-RootMailID: 20250807141938eucas1p2319a0526b25db120b3c9aeb49f69cce1
References: <cover.1754292567.git.leon@kernel.org>
	<CGME20250807141938eucas1p2319a0526b25db120b3c9aeb49f69cce1@eucas1p2.samsung.com>
	<20250807141929.GN184255@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B930FC0005
X-Stat-Signature: q83kn5u6q76e317samwsum9k3naekjy3
X-HE-Tag: 1754679076-484698
X-HE-Meta: U2FsdGVkX183tkM3R3wWnos+OUkiIPtCdkkq1ldgs6PDT20WQQ2/IGTAOhAg8GtRjAeN4u30iyF1z2Vq7K8TyYBEQQ485fr/4hbVrtM03iBZykVqGcRSmugl7elFbdkwF+dininTANdRsvowy0AFidrRGZObx//JaI5A75KFauBDhso6LuQlc0s+2Pl4/cN1jQ9eMpCYHgcLHs+GKNkyDiratKhwo3nizzRY6dpP3s+4zkSNyBmfVfRh36RSKYz8ar8cn6HwrpNS54ixQauYSq0p/lx2GvHRPiRlTiQBoNHMpe7nN/4q7kkpDinHz/Z0LsDG5cqsV2DMp92d5DlmvRUpfByjxiNe369NdLxWFAzvIPN5iMN2IpedEwxcFGyn1wPdk6q4+L4MthMB4basB8wGBVpQOKKn7H1WwVj/W6dLzXQGNNoXvaUGqq41/7PhQPfReY39Kz/6Z+cuJ9+fPCfNwuvdB/hKimhak6lrI4gvAf9PfS+zXk0Qj5sYl7PWU/lsNRvb5qR9X0Vp5CE/YP3OqrNoxP53cu/5sdVo+TluOr7BQXdLN5xzMLRcnzxW6DmDVt6ZLnutTat5zGebTGjzX6dGPeOX/dn4AaySdugFs16+9WKReO3dg8NN3equzcUVINMHDBByGYdfZvALEavnRO6913VUBogOzhs1lkMXQ09K+XJvfrsmes8ySrLBqlD8eygYpJEVdFbXDuGvPdc8B+b1oDonztZBMnSiyWZ94FoPLEgipsqmE9AN5X+TgHtTIP8+fKIdxIHwAWoOZ02D88ejLoUNRbhMkcACiWruuAUmKliVjVg2G4AzWKfhqKq++2U/q0r1A3szvTXjZ/S7aO+Er7E8ydA+70piqZIjrGAHdnhtiN19Rrpt29/EQ/sapChZzuIMoRaxhB65Z0kne1klqTJcYivZgs/coOlcR0B8rCnWLCABejH8MPqruj0kfWYmzGYbOqZnBUr
 DUrVj0K4
 q5MgnMT++k3D6J/gHG+u0RelfpcAxOqBUt4lMRyeszaHdf5Pren749ixKLdKMivP6D14i0n79FSk4wobCV7d6Wpk3cGz39RXlOcM+WetxPARVed5eAsKcv/QPvTbaymST/aV9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.2025 16:19, Jason Gunthorpe wrote:
> On Mon, Aug 04, 2025 at 03:42:34PM +0300, Leon Romanovsky wrote:
>> Changelog:
>> v1:
>>   * Added new DMA_ATTR_MMIO attribute to indicate
>>     PCI_P2PDMA_MAP_THRU_HOST_BRIDGE path.
>>   * Rewrote dma_map_* functions to use thus new attribute
>> v0: https://lore.kernel.org/all/cover.1750854543.git.leon@kernel.org/
>> ------------------------------------------------------------------------
>>
>> This series refactors the DMA mapping to use physical addresses
>> as the primary interface instead of page+offset parameters. This
>> change aligns the DMA API with the underlying hardware reality where
>> DMA operations work with physical addresses, not page structures.
> Lets elaborate this as Robin asked:
>
> This series refactors the DMA mapping API to provide a phys_addr_t
> based, and struct-page free, external API that can handle all the
> mapping cases we want in modern systems:
>
>   - struct page based cachable DRAM
>   - struct page MEMORY_DEVICE_PCI_P2PDMA PCI peer to peer non-cachable MMIO
>   - struct page-less PCI peer to peer non-cachable MMIO
>   - struct page-less "resource" MMIO
>
> Overall this gets much closer to Matthew's long term wish for
> struct-pageless IO to cachable DRAM. The remaining primary work would
> be in the mm side to allow kmap_local_pfn()/phys_to_virt() to work on
> phys_addr_t without a struct page.
>
> The general design is to remove struct page usage entirely from the
> DMA API inner layers. For flows that need to have a KVA for the
> physical address they can use kmap_local_pfn() or phys_to_virt(). This
> isolates the struct page requirements to MM code only. Long term all
> removals of struct page usage are supporting Matthew's memdesc
> project which seeks to substantially transform how struct page works.
>
> Instead make the DMA API internals work on phys_addr_t. Internally
> there are still dedicated 'page' and 'resource' flows, except they are
> now distinguished by a new DMA_ATTR_MMIO instead of by callchain. Both
> flows use the same phys_addr_t.
>
> When DMA_ATTR_MMIO is specified things work similar to the existing
> 'resource' flow. kmap_local_pfn(), phys_to_virt(), phys_to_page(),
> pfn_valid(), etc are never called on the phys_addr_t. This requires
> rejecting any configuration that would need swiotlb. CPU cache
> flushing is not required, and avoided, as ATTR_MMIO also indicates the
> address have no cachable mappings. This effectively removes any
> DMA API side requirement to have struct page when DMA_ATTR_MMIO is
> used.
>
> In the !DMA_ATTR_MMIO mode things work similarly to the 'page' flow,
> except on the common path of no cache flush, no swiotlb it never
> touches a struct page. When cache flushing or swiotlb copying
> kmap_local_pfn()/phys_to_virt() are used to get a KVA for CPU
> usage. This was already the case on the unmap side, now the map side
> is symmetric.
>
> Callers are adjusted to set DMA_ATTR_MMIO. Existing 'resource' users
> must set it. The existing struct page based MEMORY_DEVICE_PCI_P2PDMA
> path must also set it. This corrects some existing bugs where iommu
> mappings for P2P MMIO were improperly marked IOMMU_CACHE.
>
> Since ATTR_MMIO is made to work with all the existing DMA map entry
> points, particularly dma_iova_link(), this finally allows a way to use
> the new DMA API to map PCI P2P MMIO without creating struct page. The
> VFIO DMABUF series demonstrates how this works. This is intended to
> replace the incorrect driver use of dma_map_resource() on PCI BAR
> addresses.
>
> This series does the core code and modern flows. A followup series
> will give the same treatement to the legacy dma_ops implementation.

Thanks for the elaborate description, that's something that was missing 
in the previous attempt. I read again all the previous discussion and 
this explanation and there are still two things that imho needs more 
clarification.


First - basing the API on the phys_addr_t.

Page based API had the advantage that it was really hard to abuse it and 
call for something that is not 'a normal RAM'. I initially though that 
phys_addr_t based API will somehow simplify arch specific 
implementation, as some of them indeed rely on phys_addr_t internally, 
but I missed other things pointed by Robin. Do we have here any 
alternative?


Second - making dma_map_phys() a single API to handle all cases.

Do we really need such single function to handle all cases? To handle 
P2P case, the caller already must pass DMA_ATTR_MMIO, so it must somehow 
keep such information internally. Cannot it just call existing 
dma_map_resource(), so there will be clear distinction between these 2 
cases (DMA to RAM and P2P DMA)? Do we need additional check for 
DMA_ATTR_MMIO for every typical DMA user? I know that branching is 
cheap, but this will probably increase code size for most of the typical 
users for no reason.


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


