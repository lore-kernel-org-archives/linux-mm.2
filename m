Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E7CCAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 22:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF25E8E0003; Thu, 11 Sep 2025 18:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9DC8E0001; Thu, 11 Sep 2025 18:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B072E8E0003; Thu, 11 Sep 2025 18:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A07B18E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:25:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 591E11DCFEE
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:25:48 +0000 (UTC)
X-FDA: 83878402776.19.1540BF8
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf24.hostedemail.com (Postfix) with ESMTP id 24F2C180007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:25:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=TYzap3cs;
	spf=pass (imf24.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757629546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKZpcAmq/bht8ZKkJqtZPTgOAGANcQvA5kKLVuXifcI=;
	b=8GDnAAObOBkeWIu7UXPCc9zKT0qZL4qg+zSkzSCUgZFfCJOk9uMqkWdl2oTZr7nl9LGzTu
	3KN1ZzHJZXfYDabKlyy7hM0CSJ+MKtw2fVN5KV3eISimvKH5OyWFJvnt8yh33IDkyUw7HO
	gISESStlYFMKxGsiKIeigS8zvemfV7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757629546; a=rsa-sha256;
	cv=none;
	b=ge3efTaiBoF8l+cLU/AQfrmr/8DFPcFu8HVqJMmNTtCHrOmokeAnqRkfVRivwwWvD7G9cw
	OBQlvk4Km1dzMcCAiwVwtKTEnP7zGyarGzMwAz0y5Mqx3ojqPQHBNAB5zEZhCApu0+gQfz
	lAqAoM+nE32XKRkLuPtzHAYgaHgV+Ic=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=TYzap3cs;
	spf=pass (imf24.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250911222543euoutp0181a9340dd64dc67c6339e0a47181ebf4~kWsHnYW5E2610126101euoutp01U;
	Thu, 11 Sep 2025 22:25:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250911222543euoutp0181a9340dd64dc67c6339e0a47181ebf4~kWsHnYW5E2610126101euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757629543;
	bh=pKZpcAmq/bht8ZKkJqtZPTgOAGANcQvA5kKLVuXifcI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=TYzap3cszLDOEgEsqU6EupJ7Zu8ir86kgd0ybK+4ACWZaOiATyvZFbUDShQ8MbR85
	 SejzQ/ANTvod+crbxkB+bIskmGYNCRGJfAnTK7Wx3EUgGfsfp9YrG/QNqAamMubhrs
	 7HS78hSROwDaJIS7uPVpylvDm+iDdZwL3r/+voe4=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250911222542eucas1p1fd99b15e46362a0af4417b04fa0c831b~kWsHKwmS41727217272eucas1p1e;
	Thu, 11 Sep 2025 22:25:42 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250911222538eusmtip17e16b44d9939848958cad6696cc3414c~kWsDGpMzk2282122821eusmtip1T;
	Thu, 11 Sep 2025 22:25:38 +0000 (GMT)
Message-ID: <0db9bce5-40df-4cf5-85ab-f032c67d5c71@samsung.com>
Date: Fri, 12 Sep 2025 00:25:38 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v6 00/16] dma-mapping: migrate to physical address-based
 API
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>, Alexander Potapenko
	<glider@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Danilo
	Krummrich <dakr@kernel.org>, David Hildenbrand <david@redhat.com>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>, Jens Axboe
	<axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet
	<corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
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
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250911222542eucas1p1fd99b15e46362a0af4417b04fa0c831b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250909132821eucas1p1051ce9e0270ddbf520e105c913fa8db6
X-EPHeader: CA
X-CMS-RootMailID: 20250909132821eucas1p1051ce9e0270ddbf520e105c913fa8db6
References: <CGME20250909132821eucas1p1051ce9e0270ddbf520e105c913fa8db6@eucas1p1.samsung.com>
	<cover.1757423202.git.leonro@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24F2C180007
X-Stat-Signature: 1n8sjina4p5pi1snj7rek4apicn9chj3
X-Rspam-User: 
X-HE-Tag: 1757629545-194236
X-HE-Meta: U2FsdGVkX18zbUUO+0g5L6UYa/QMXB4qnb1vGfyCjvpI0YadfXZhL9spBtG2XY+hNedXjQU2wqZCcMI/PYDGPlQuBtzWHxpuQZDPreoQ4QnqyMSzab3UBk93hFLMxf8mXC7rmh9xLZxMZiK/ZrQsyhGExfjW7HqY/WFPaCVg2M0KiWtY0CfwDj2FQZsyh4rNG+5wYEvdq6PoOf8b5JDJ1uEnJnjoHKTYy0pysIuxoT5zp5zZlwsYjNpMl8s5gS5OebMD/DgV2o9zOtwujml74cfg4xUn6Q6UUjseWoceA68YO2y3/e78GNyp7xo5LgQLttYQ4Jc4HrbpGidkP6z+4GbDczVSJUvKPiZwYmMu6cW6NjpdxGgA3GF8C5FVmCQVo8tE74J88qVqPFKDsu8J76bkQ+H9fkGVxBJv+PPjOtaNfjzyHDCKG9Rqx73FMBwGLcPnjTcOB1thQ22K8cImiw5xei3D5+0kUKS/IRCblXu+zJapAkCGJv1DpISakRLpIKifCnvU/HLrnEmlFeMrghDvlm5pmchKRg6pid4SCHHt5KBwe6PExtFfXntGSqokjWuu/O1DHMW9vdU8fBv7ZO++C/O9KOlKwyvzpJFC4inhZD6gG5IriaSjT7mklnumFAUPz3ksevrCpnp9NYoWj0/IY2Rhd8jOfLbnsFasmax6HefiI6mJ8BbhBTxxE/y1H4VTFdH85VsX2eIPG6XqSIJh7q+LUjueu2A8pWJj0BFdaJzLmdCaDTcAbssRWCQEX8xDR9s5zVhi/di1Kn6IwYb8IkoQ+U8WqieMMxWLiPheVqU6SRhpNduqh2Xzu9YVN0ajTpmHB9IocGP78mZwwCIH+2PeNwTrRCYzaJTdWTDmWl+5hjH1BClXoUKeKPKnV6qknNaI8b08kcQii4RVsROocAbk9SOYUeYTLW61+T4k0A81mlZu0QxzpELbzZxhyXwYbt3MQKyu6Iscct8
 O0p71LSK
 MLSafrrew/EM8CYYWx8XF9xj4X3U22lDNmK/Dvehr5A27sLsmptjyYQAz1mMnuWdsBRRUh8jnGB/qR+IVKQRrgXH8P1iyvjZoBzqYcbO4EDBkA2KtLmRPKraxdwuoBX/NE84T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.2025 15:27, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Changelog:
> v6:
>   * Based on "dma-debug: don't enforce dma mapping check on noncoherent
>     allocations" patch.
>   * Removed some unused variables from kmsan conversion.
>   * Fixed missed ! in dma check.
> v5: https://lore.kernel.org/all/cover.1756822782.git.leon@kernel.org
>   * Added Jason's and Keith's Reviewed-by tags
>   * Fixed DMA_ATTR_MMIO check in dma_direct_map_phys
>   * Jason's cleanup suggestions
> v4: https://lore.kernel.org/all/cover.1755624249.git.leon@kernel.org/
>   * Fixed kbuild error with mismatch in kmsan function declaration due to
>     rebase error.
> v3: https://lore.kernel.org/all/cover.1755193625.git.leon@kernel.org
>   * Fixed typo in "cacheable" word
>   * Simplified kmsan patch a lot to be simple argument refactoring
> v2: https://lore.kernel.org/all/cover.1755153054.git.leon@kernel.org
>   * Used commit messages and cover letter from Jason
>   * Moved setting IOMMU_MMIO flag to dma_info_to_prot function
>   * Micro-optimized the code
>   * Rebased code on v6.17-rc1
> v1: https://lore.kernel.org/all/cover.1754292567.git.leon@kernel.org
>   * Added new DMA_ATTR_MMIO attribute to indicate
>     PCI_P2PDMA_MAP_THRU_HOST_BRIDGE path.
>   * Rewrote dma_map_* functions to use thus new attribute
> v0: https://lore.kernel.org/all/cover.1750854543.git.leon@kernel.org/
> ------------------------------------------------------------------------
>
> This series refactors the DMA mapping to use physical addresses
> as the primary interface instead of page+offset parameters. This
> change aligns the DMA API with the underlying hardware reality where
> DMA operations work with physical addresses, not page structures.
>
> The series maintains export symbol backward compatibility by keeping
> the old page-based API as wrapper functions around the new physical
> address-based implementations.
>
> This series refactors the DMA mapping API to provide a phys_addr_t
> based, and struct-page free, external API that can handle all the
> mapping cases we want in modern systems:
>
>   - struct page based cacheable DRAM
>   - struct page MEMORY_DEVICE_PCI_P2PDMA PCI peer to peer non-cacheable
>     MMIO
>   - struct page-less PCI peer to peer non-cacheable MMIO
>   - struct page-less "resource" MMIO
>
> Overall this gets much closer to Matthew's long term wish for
> struct-pageless IO to cacheable DRAM. The remaining primary work would
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
> address have no cacheable mappings. This effectively removes any
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
> will give the same treatment to the legacy dma_ops implementation.

Applied patches 1-13 into dma-mapping-for-next branch. Let's check if it 
works fine in linux-next.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


