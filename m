Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422E6CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 16:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962AD8E0003; Fri,  5 Sep 2025 12:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913BA8E0001; Fri,  5 Sep 2025 12:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8295A8E0003; Fri,  5 Sep 2025 12:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBD48E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:20:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F616C02E4
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:20:59 +0000 (UTC)
X-FDA: 83855710638.01.095D912
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf11.hostedemail.com (Postfix) with ESMTP id 79D0940011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:20:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=BH1gDTlm;
	spf=pass (imf11.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757089257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+uJO0KPgHoqZtk4UB2d6cw6Lk6DbEyEjBWC0P92zgA=;
	b=OroKSl25DbCLHuJOfNci/ocxqzANb6c+i64zAjU1bt6CGQQPhA9hf18MhBBlKWxFYsM3+N
	VgFwNwSNORQgYWdQpho50x6szInp9+bRHDVWFARE7OU/xW8+zMhlLDYT+cxH2BgxZ0ZTCH
	nFdWtw/706o+166USfVU7fEvwXRlWgg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757089257; a=rsa-sha256;
	cv=none;
	b=GPAHFsMtHQzpbkkqfwEzeHkfgcUilAVZjs60SAnmAi6t0AiFImp0wsnSrsU2mZRCVM99iK
	/F1N3vtWF6Km9JyDCrkEUu1vJiOIaXLnWbkMoAQ9SGzXIWgiO/Zo+8neRZDbBVzBqId6Dx
	ew8sjGsdmGCLvGqp6JqhP2n8u7QOikE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=BH1gDTlm;
	spf=pass (imf11.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250905162054euoutp02e77d244e0cafd5d952c3328dee47f20d~ib14B25gK1750017500euoutp02R;
	Fri,  5 Sep 2025 16:20:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250905162054euoutp02e77d244e0cafd5d952c3328dee47f20d~ib14B25gK1750017500euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757089254;
	bh=r+uJO0KPgHoqZtk4UB2d6cw6Lk6DbEyEjBWC0P92zgA=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=BH1gDTlm5/u+/rXGc9JT+K9NjInJASEOMUNJK2lpN97zPJKhgFZ4BwyWAKG5fWJ4U
	 SwthcsWnGvBGq4ZFisO0dXzRvPNenkJ22SKsGAEN3TZeM/LeDo1/zUbv9zcz1Jnd3W
	 ZVdWIWrJTUMJGFYQL2lzvf5ASBpb6d4tBQU3KY7E=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250905162053eucas1p1b9fec0adff4c7d35b6b6add1249d881b~ib13cmmn22364123641eucas1p1e;
	Fri,  5 Sep 2025 16:20:53 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250905162051eusmtip1e4d21f9bc61a423579ce48c4e618b6af~ib11sI1Nb2344623446eusmtip1s;
	Fri,  5 Sep 2025 16:20:51 +0000 (GMT)
Message-ID: <7557f31e-1504-4f62-b00b-70e25bb793cb@samsung.com>
Date: Fri, 5 Sep 2025 18:20:51 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v4 00/16] dma-mapping: migrate to physical address-based
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
In-Reply-To: <20250829131625.GK9469@nvidia.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250905162053eucas1p1b9fec0adff4c7d35b6b6add1249d881b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250829131641eucas1p2ddd687e4e8c16a2bc64a293b6364fa6f
X-EPHeader: CA
X-CMS-RootMailID: 20250829131641eucas1p2ddd687e4e8c16a2bc64a293b6364fa6f
References: <cover.1755624249.git.leon@kernel.org>
	<CGME20250829131641eucas1p2ddd687e4e8c16a2bc64a293b6364fa6f@eucas1p2.samsung.com>
	<20250829131625.GK9469@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79D0940011
X-Stat-Signature: hw76kfmsq1fnc45bwb7dp4i9qgxmiwti
X-Rspam-User: 
X-HE-Tag: 1757089256-375091
X-HE-Meta: U2FsdGVkX18/pivkOn3IV8r3kTDEgsJifjtPveQcBIQCwgW+Z+FPSCpUhBHXeFP/RFjR0F+qS5ukkx1Zw2dZXYnG6SNhPJSARfxH5yqdV0UWCa+tXruCeyR24h5bHdWOutx8Oz69nXd2CI6XC6C9Ez+mUntP7nnZVwuMUufyVBOUF7L7yG+p4Sbt0YokWAH1qCGY9dKRNZAlyo6PWmw6WyIHpmZ0lHX8GZOTbc4J9qAStWGPmxpAH0IUKdX115KMGt1ws4AyTJGg0ybv1LKMaH5jAzP7zz8WnTxRgSzq617L6MlfbZyTzeTNb8yIucuumcUGVOv4FdP5HEZv8Kgf2zY2p8dStt+eTUPl/Fz+UjqERYGTCIEVUWbjobhQqUweCXQ715gdPITvOScpGVKGqC08RjZCToN2Vmxe6LYXi1CQ9QieAH49Nzi4IwPF56pPPxnxLd1Htc2fLuKiTHxd8XSHkZovYq1VmY+56e+V/+viy2qtiEhjhkHzjzwgvl7VoUPqwFX2pBoMeceql6rvN1+xGHMNmrNxke+7ZVfk2pTv+F2EK8jbxMWi6Us9iJBZ263eyGby4b4qXjSpPM0D7GtqMVVhByRWN5n4uEOtlYZZIJya1+5BuPjg6DHqA73StG3E6qi8Sk4E9dOsdpki7R/hLosmlqw7Rlg7edd6gzt2kCSpYqiCg47RzUKDTxhCmxmT6OxBML0lHdq56D3OlvvbTEhaWVK0n1QNlzNSg3KzkHYI3D2x5pkN/cPSS7PjbYxfFqJ2x4vL9LIMMiBs3sBGduLnBglWB2tMBl64jqT/l+9G0ALEN9vmiQsG5KrhiKCemsYGpVmyuiuaZosqyzTCr/X0rzGJ/7pnBI2BNUqftEtrywoMDWqIPRDlF1+EiX1X0J5d3zAKlFFd8gztIJvlGg+THs4zAJsiG4GjppyDYMyfIWe+66wPWzJ/PCw90SWrtlWJUnLUiW1ApHK
 0tepRf27
 0M5TalgAH15tXD3VJUbvKncSJ8fqbdVXKHGR9Km8ZbCB3ExyrsbQPUZf9m7t1vqPUbrrThQ/Yrs7rSIrIcNwHBqlzXG40+94TqdP9LXsyXplpSCZPCMsooCsPOMi1MBh2uqv/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.2025 15:16, Jason Gunthorpe wrote:
> On Tue, Aug 19, 2025 at 08:36:44PM +0300, Leon Romanovsky wrote:
>
>> This series does the core code and modern flows. A followup series
>> will give the same treatment to the legacy dma_ops implementation.
> I took a quick check over this to see that it is sane.  I think using
> phys is an improvement for most of the dma_ops implemenations.
>
>    arch/sparc/kernel/pci_sun4v.c
>    arch/sparc/kernel/iommu.c
>      Uses __pa to get phys from the page, never touches page
>
>    arch/alpha/kernel/pci_iommu.c
>    arch/sparc/mm/io-unit.c
>    drivers/parisc/ccio-dma.c
>    drivers/parisc/sba_iommu.c
>      Does page_addres() and later does __pa on it. Doesn't touch struct page
>
>    arch/x86/kernel/amd_gart_64.c
>    drivers/xen/swiotlb-xen.c
>    arch/mips/jazz/jazzdma.c
>      Immediately does page_to_phys(), never touches struct page
>
>    drivers/vdpa/vdpa_user/vduse_dev.c
>      Does page_to_phys() to call iommu_map()
>
>    drivers/xen/grant-dma-ops.c
>      Does page_to_pfn() and nothing else
>
>    arch/powerpc/platforms/ps3/system-bus.c
>     This is a maze but I think it wants only phys and the virt is only
>     used for debug prints.
>
> The above all never touch a KVA and just want a phys_addr_t.
>
> The below are touching the KVA somehow:
>
>    arch/sparc/mm/iommu.c
>    arch/arm/mm/dma-mapping.c
>      Uses page_address to cache flush, would be happy with phys_to_virt()
>      and a PhysHighMem()
>
>    arch/powerpc/kernel/dma-iommu.c
>    arch/powerpc/platforms/pseries/vio.c
>     Uses iommu_map_page() which wants phys_to_virt(), doesn't touch
>     struct page
>
>    arch/powerpc/platforms/pseries/ibmebus.c
>      Returns phys_to_virt() as dma_addr_t.
>
> The two PPC ones are weird, I didn't figure out how that was working..
>
> It would be easy to make map_phys patches for about half of these, in
> the first grouping. Doing so would also grant those arches
> map_resource capability.
>
> Overall I didn't think there was any reduction in maintainability in
> these places. Most are improvements eliminating code, and some are
> just switching to phys_to_virt() from page_address(), which we could
> further guard with DMA_ATTR_MMIO and a check for highmem.

Thanks for this summary.

However I would still like to get an answer for the simple question - 
why all this work cannot be replaced by a simple use of dma_map_resource()?

I've checked the most advertised use case in 
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=dmabuf-vfio 
and I still don't see the reason why it cannot be based 
on dma_map_resource() API? I'm aware of the little asymmetry of the 
client calls is such case, indeed it is not preety, but this should work 
even now:

phys = phys_vec[i].paddr;

if (is_mmio)
     dma_map_resource(phys, len, ...);
else
     dma_map_page(phys_to_page(phys), offset_in_page(phys), ...);

What did I miss?

I'm not against this rework, but I would really like to know the 
rationale. I know that the 2-step dma-mapping API also use phys 
addresses and this is the same direction.

This patchset focuses only on the dma_map_page -> dma_map_phys rework. 
There are also other interfaces, like dma_alloc_pages() and so far 
nothing has been proposed for them so far.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


