Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FEB1CAC594
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 05:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67F68E000C; Mon, 15 Sep 2025 01:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E185D8E0001; Mon, 15 Sep 2025 01:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2E7A8E000C; Mon, 15 Sep 2025 01:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0CE58E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:48:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F027C0472
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:48:26 +0000 (UTC)
X-FDA: 83890404612.09.0BA4A32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7C4AE10000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:48:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LY4R44OP;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757915304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXL3zMOfk7HJmj1hH5tcjC1ukwS1rzTdhMLd/yhlMo8=;
	b=lCdeQxB05BKOcqdpZqYUE6VXy1mDPfInCBpn8qnEpNUnzNrt3TiaInrpWafAv26YnK0uU2
	RgmT2+6dAKA+MwsBqeLvnQlnMJw13+ngyKfSn6biRt7nnkwGepSGMKRXEmK5aaFZt/vxZN
	WaUQYuTf3j557KhFLN0oOOBrLluba8U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LY4R44OP;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757915304; a=rsa-sha256;
	cv=none;
	b=aoJtRhp8ScXXy2mNve87WxUuCJH0qVWaxs1m/Mnv9oMhh1lPGFe/LjKc5RVHjENPXjdoyW
	HnW3910QTwgsUt2S1Jt8ObFUaWvxM+nifBwpCBCZDnBK0GwTF7sNqDY++t90Le45oFwV8N
	ZAUcw4WWrIMn8fn0v5i7hfst7iIyT2Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05E2143F68;
	Mon, 15 Sep 2025 05:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FCDC4CEF1;
	Mon, 15 Sep 2025 05:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757915302;
	bh=QmA1uWtopyZKqYFa3aB5R38vcRhwp6UNA5QEhCCpxlY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LY4R44OPNzL3Qer2vVNQup9uUTcNx43gZqh5FwLU0Oh1PdFVX0Y/KMu9Uvifa32bq
	 LKQg8b7U2pc5ik4+PxHv4Vxaw4OOg+vsmxh8TnpYqhx/pMCEM27S4kfw09R8Z3+SrS
	 WOCH3NphTYB7cis3wXHahmF9XEuFQFnTdwnEgrsxicfvxKQHyvsgH5+RBeSZZNlt+1
	 jN5OeNDI/I13LeozFgh3Z/w6y7Zqmf8gbZ1coqUma25WZo+AQ3j6hF69NbTonbiUow
	 a8r0c3Mzdr4L7umKhPtyml+GICc0Iz7CXrXjBFFY5PAmWMihDcJf2V0TWoeJPC1g6V
	 RKkFNq598mfYQ==
Date: Fri, 12 Sep 2025 12:03:27 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>, kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v6 00/16] dma-mapping: migrate to physical address-based
 API
Message-ID: <20250912090327.GU341237@unreal>
References: <CGME20250909132821eucas1p1051ce9e0270ddbf520e105c913fa8db6@eucas1p1.samsung.com>
 <cover.1757423202.git.leonro@nvidia.com>
 <0db9bce5-40df-4cf5-85ab-f032c67d5c71@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0db9bce5-40df-4cf5-85ab-f032c67d5c71@samsung.com>
X-Rspamd-Queue-Id: 7C4AE10000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wojj1jo9i7jabbbxr6uf1431emi7t49a
X-HE-Tag: 1757915304-583981
X-HE-Meta: U2FsdGVkX1/KovakCbof/+prhm3AFu4/f4hex9a3cp5rPDk2nBL0weBCtIQNVaXbhTSX1kkDd5lx6QkwMPAL7vxec4Bh/NHi4GMSDL5jo1ZgtJyRuHGWpxKv8OS4f5tZgndxnQkWwS5y2IX+rnCqruFA6j+lYD+96nGJ9nim4/dIBo1FSd6ljstAS8F+zKrsFDIf6A/JKkjLhmk3Y6nmjj+M6j34VBzIEYMHVE/o2yFY4f/RAajR6BlNtK2z+WCg1U4LNa85gGA4te9uGDp/nFYHPPGA2rCXx3hhA7bWW4ErIKuLDoimpAflhkhdVmlGlsrBRcjSbP+e9ofIcZPDLeojHXLPMmTkIRu92o4VkPQBuaMeGb720M1X+fVhCTptYqoAl+ttAAvEAgSSoDxfudRO4oG8RUYvn6vyz+6Oqrh9NMQvM/kp4l8RBsrDHlvt+8PSOaBA2aSVJWScYJXCMrQe9VQZVN/UK6Um5WScVFcqFVaUgRejSxsAJvLN+OxZ8lc85gOfzNARxokElSVb16lz0v1CEbidFrIieXxB6fB2aR25CmxQQ1YbKBb9azsrl7s++JkPD4ecbnyfRfNgXn7sBvLdabLvyGB/UtUBHK8neK9t8GHB4UquNCwP1joqE1+f5z4CTztqNs9VyYT01Debev2EmOrGpCA9NU98ypEwdW5GmXMwzfSWDzhuNVrGN4X0JtAItRSkk4wBWBfA0O+/bJGGWpZvPDuQKE/kTyDm0hX5BR0MjEL/aeRee2xavK4Ybry607gEpgrDpbm6QrNAn8VPAyXqVLxmPAJ4Qsi426weanxjrYU++116lU3CwrCc6i1knz7Ry9+BXciYZNsO7VCbRzuhTYwFKhT5zWf/sjtYFOLeDiCRMF4S6kEF5aA8c6QYRfZ/h9NlpyzfX3EskeN/7cKO+z9oQbGYE6FTEuaTEVzl968Wz3qzG4pM38/IGyJblQjUlQuJlfV
 s5I4jTD2
 B7CiWg2rmAnIyvLrYpPg0HiTrWhGlAu+VYxnshEXWGtuQbVRv2X6CXE2GB5cZkBOGUjpwHRm9VWfS36Ya3n2SVJqI8qxy2a/Sew6U+DIhvaZDWAILmrbEUTRTpBIETvoB0fEFxCZ9tyevAcUSES3/crH33vZXLEfDMBslZ/VBJ/F0oXt1lhcZQgsTpN9cot4W+/r5FiHq51I4eBu3nwaJ1C4oZh/jmhLsa0GCpjwCyF5UPx8YlK+OnnXF0KGa+pQiiv+cHpvx2MFGm0rXLW9zz2zBQT4BqH5GtAoqNzHdwSTLwHesfYn4T6eGTCSWwiTeogmqOdUv3Zqx80mY+j6lXY+/jyKouzGMlCeu6YvKdjpVenEGatmKGInrwezq91kSSfpq8sg/2CTwtuXDDlscYZR01g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 12:25:38AM +0200, Marek Szyprowski wrote:
> On 09.09.2025 15:27, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Changelog:
> > v6:
> >   * Based on "dma-debug: don't enforce dma mapping check on noncoherent
> >     allocations" patch.
> >   * Removed some unused variables from kmsan conversion.
> >   * Fixed missed ! in dma check.
> > v5: https://lore.kernel.org/all/cover.1756822782.git.leon@kernel.org
> >   * Added Jason's and Keith's Reviewed-by tags
> >   * Fixed DMA_ATTR_MMIO check in dma_direct_map_phys
> >   * Jason's cleanup suggestions
> > v4: https://lore.kernel.org/all/cover.1755624249.git.leon@kernel.org/
> >   * Fixed kbuild error with mismatch in kmsan function declaration due to
> >     rebase error.
> > v3: https://lore.kernel.org/all/cover.1755193625.git.leon@kernel.org
> >   * Fixed typo in "cacheable" word
> >   * Simplified kmsan patch a lot to be simple argument refactoring
> > v2: https://lore.kernel.org/all/cover.1755153054.git.leon@kernel.org
> >   * Used commit messages and cover letter from Jason
> >   * Moved setting IOMMU_MMIO flag to dma_info_to_prot function
> >   * Micro-optimized the code
> >   * Rebased code on v6.17-rc1
> > v1: https://lore.kernel.org/all/cover.1754292567.git.leon@kernel.org
> >   * Added new DMA_ATTR_MMIO attribute to indicate
> >     PCI_P2PDMA_MAP_THRU_HOST_BRIDGE path.
> >   * Rewrote dma_map_* functions to use thus new attribute
> > v0: https://lore.kernel.org/all/cover.1750854543.git.leon@kernel.org/
> > ------------------------------------------------------------------------
> >
> > This series refactors the DMA mapping to use physical addresses
> > as the primary interface instead of page+offset parameters. This
> > change aligns the DMA API with the underlying hardware reality where
> > DMA operations work with physical addresses, not page structures.
> >
> > The series maintains export symbol backward compatibility by keeping
> > the old page-based API as wrapper functions around the new physical
> > address-based implementations.
> >
> > This series refactors the DMA mapping API to provide a phys_addr_t
> > based, and struct-page free, external API that can handle all the
> > mapping cases we want in modern systems:
> >
> >   - struct page based cacheable DRAM
> >   - struct page MEMORY_DEVICE_PCI_P2PDMA PCI peer to peer non-cacheable
> >     MMIO
> >   - struct page-less PCI peer to peer non-cacheable MMIO
> >   - struct page-less "resource" MMIO
> >
> > Overall this gets much closer to Matthew's long term wish for
> > struct-pageless IO to cacheable DRAM. The remaining primary work would
> > be in the mm side to allow kmap_local_pfn()/phys_to_virt() to work on
> > phys_addr_t without a struct page.
> >
> > The general design is to remove struct page usage entirely from the
> > DMA API inner layers. For flows that need to have a KVA for the
> > physical address they can use kmap_local_pfn() or phys_to_virt(). This
> > isolates the struct page requirements to MM code only. Long term all
> > removals of struct page usage are supporting Matthew's memdesc
> > project which seeks to substantially transform how struct page works.
> >
> > Instead make the DMA API internals work on phys_addr_t. Internally
> > there are still dedicated 'page' and 'resource' flows, except they are
> > now distinguished by a new DMA_ATTR_MMIO instead of by callchain. Both
> > flows use the same phys_addr_t.
> >
> > When DMA_ATTR_MMIO is specified things work similar to the existing
> > 'resource' flow. kmap_local_pfn(), phys_to_virt(), phys_to_page(),
> > pfn_valid(), etc are never called on the phys_addr_t. This requires
> > rejecting any configuration that would need swiotlb. CPU cache
> > flushing is not required, and avoided, as ATTR_MMIO also indicates the
> > address have no cacheable mappings. This effectively removes any
> > DMA API side requirement to have struct page when DMA_ATTR_MMIO is
> > used.
> >
> > In the !DMA_ATTR_MMIO mode things work similarly to the 'page' flow,
> > except on the common path of no cache flush, no swiotlb it never
> > touches a struct page. When cache flushing or swiotlb copying
> > kmap_local_pfn()/phys_to_virt() are used to get a KVA for CPU
> > usage. This was already the case on the unmap side, now the map side
> > is symmetric.
> >
> > Callers are adjusted to set DMA_ATTR_MMIO. Existing 'resource' users
> > must set it. The existing struct page based MEMORY_DEVICE_PCI_P2PDMA
> > path must also set it. This corrects some existing bugs where iommu
> > mappings for P2P MMIO were improperly marked IOMMU_CACHE.
> >
> > Since ATTR_MMIO is made to work with all the existing DMA map entry
> > points, particularly dma_iova_link(), this finally allows a way to use
> > the new DMA API to map PCI P2P MMIO without creating struct page. The
> > VFIO DMABUF series demonstrates how this works. This is intended to
> > replace the incorrect driver use of dma_map_resource() on PCI BAR
> > addresses.
> >
> > This series does the core code and modern flows. A followup series
> > will give the same treatment to the legacy dma_ops implementation.
> 
> Applied patches 1-13 into dma-mapping-for-next branch. Let's check if it 
> works fine in linux-next.

Thanks a lot.

> 
> Best regards
> -- 
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
> 
> 

