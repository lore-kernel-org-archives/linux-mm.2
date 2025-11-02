Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B147ECCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 18:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF268E0003; Sun,  2 Nov 2025 13:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92778E0002; Sun,  2 Nov 2025 13:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A58C8E0003; Sun,  2 Nov 2025 13:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 885FC8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 13:17:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2900213BEFD
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 18:17:23 +0000 (UTC)
X-FDA: 84066474366.21.23D50D3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B31A100009
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 18:17:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4FI+yGp9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762107441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6RCmAWijCnvF4Bo5wOHGcYuLeUjw8rFoqEsFyghVK4=;
	b=XzOU/2vrCDpuUoZgjQ0cPRLnvjJ77ABHCanyj68zRntxBMT4kAR5cZgfn+Q4xVz/8uKyKc
	ltNwA5NhKTuXaCHq0bIiubKMqfOAvOyfcL65CcX+FBpLfGPBOcA2RepMtStQ2Bt4sU4hJk
	FOBcdCSLLwK3RzZ6zQo3AwZxsTd50Aw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4FI+yGp9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762107441; a=rsa-sha256;
	cv=none;
	b=NSC1bXvEBPe7eM43QEnXgZJhmv1gALOl/mvcJvZN1Uy+j1QgCjWyFRB90VXXwWwMlsMNkd
	52phaVqSccNrZpo7WZU9p9HowDi0HNsFZepwy5MHO1p7uENWqoskREFVOZTB+Ukcsc/VGK
	0kS/AbyMxj56liFmUNR7jpaVK87YnSY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=L6RCmAWijCnvF4Bo5wOHGcYuLeUjw8rFoqEsFyghVK4=; b=4FI+yGp97huIAfdBGGco3fbw7P
	ax4P2Kwz3qaUaWjAc4X5stCOM77TA8aotCPc0/LJL1M6jg37tryJvE4GmlP0aMSIdlw80SMhjyWy9
	qYg6UM66XyF7z99G58anT9hMLHPdBHoo8cAE9aY+0f3mUrzHQil/uk78McmuRIFi6SBLkKYAjtSIh
	Gs8ZlKmtjdrktIa4nv91/stIbGVM1MKlP/mQCnhC58HSSPqVE335UExcQIfPTBg7Fvizl64v5Wrz0
	dOra08BphEOrFjTCza+MY/qowMuTfEdEY+OrdbGxEtOhbYbO+klb3ZnJQbQZycRlhojckBsTIrbKq
	H5HDZiMA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFcdQ-00000008ixQ-0jc1;
	Sun, 02 Nov 2025 18:17:00 +0000
Message-ID: <86383031-807e-43d9-976e-dd955d79dc52@infradead.org>
Date: Sun, 2 Nov 2025 10:16:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/11] PCI/P2PDMA: Document DMABUF model
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>
Cc: Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <20251102-dmabuf-vfio-v6-5-d773cff0db9f@nvidia.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251102-dmabuf-vfio-v6-5-d773cff0db9f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B31A100009
X-Rspamd-Server: rspam03
X-Stat-Signature: cmdcjccqxemepq47f6p6tuifu51ygjxw
X-HE-Tag: 1762107439-702822
X-HE-Meta: U2FsdGVkX1+Ov/ZObBvDoRoluTNzhmk/aarTGsU6aXAylf2ml3FC3+kOL7ozVWThCmr+YzyEzHmf69AP0xbM4HC41U8Em6flYMV6qFokmSx/plsin4ktL9HmXniflP+ByVM782gjHQkq2Rvv8eQrxejXzNRyfE5oaLZLBb+t+wR1mG0WICQt57H/b+LyR7KZ4rakRoZffIzXUjixdOvU36npkbokf58Sh7yo8k3zBz8Y5x35ynzzwe7Ojsz/S9ur9cgflgs/8GsgnV8CeyrRv9hZK9C4Pvw4mpGM2kX45x3MIMyA6Sl3/X3CozHjR6GPMM5V5KzOdycqcE+vrNHAKbhTceBrXX0B3/8FnmK2jT2fpDBqDm6qSNKhZShOoi9TpYwdMUpirZz15wYb5V3ntnSWLNjIRxj9XW3YD+ce9OiJ1zsS+qTGiRjqjIFC3+2eF3YsKf3oC3obSIk2lWGvGeXelMG7ZUISwyhlN8a/uN25bJTwjAYN6bVdt/IQb0JS6B0qHoIxUHcTTgaTchHcXctHeauxruzNj9rFgX9anXARC7wXpwLRdVmhzPrCGel6xI2mWC1jePxxpkpEqvWi2Nm+Q4t24MKYBgF7ytJS8oebhOqgtduWrOB6kbgPSueb85mXqlc6HCBsU8zlc6VXT0vLD9tqyZpCnIRJjM9zBr/LtzdRkNsNh7QgEN4fG2PmEX3cJAvQsatuWyqgjA3+x6ANav7+dQFXpx9d9qY4eDiEctVGPIxEyU8oF92WPtSzG2a/cTfpe9vLbGjlHHM4NA1zpi7jOf3+HblQkRFdTUAWW2iJ3aiq8bxN1CVKDLU02A1Qww1R9reBFXSspWLP7Fj461fzegDWV14EReOvdPULkYyvjcpYNCeJ0oe9XVRqcCZJBLZRzcsgIqgUyMnYjapy2dgtgjsItGO+HguYj3+en73jDotV+THPLlOcv/B4OZbN2u9bkU2JiDtDdTP
 AMvkszCS
 1LBeUzTpCN0fi9b03+kYSS8OtcvTnByUgdJudmzp8NvGeD6D/7Zu3OdxeJnKeu9EytU+pg+4V2pxvxWqW8mlO9rCr1ZOIkmV4TZ+MuHY9CIv3sHjbR9xTlV4QdEUbTQv7abXDfrO271JnXqeBBdLRx6JEi7mfpYrbgJa/8O8mR6wcws1lCf0iYWhTwl08QwLS1GZK6yhfrvkZO/GfT0IEAY4qE7KZIzGu13cgfIwZ/xD7t37CtTe0MLYqw/TLe5Q2xDpgiZ5VB+Coz4W0Gkep9wHw+yWt7Dkq4ke/jhkrAAF+8KYX5ksziAdHc0ydwWUdx2M3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/2/25 1:00 AM, Leon Romanovsky wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Reflect latest changes in p2p implementation to support DMABUF lifecycle.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
>  1 file changed, 72 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> index d0b241628cf1..c43ec1356471 100644
> --- a/Documentation/driver-api/pci/p2pdma.rst
> +++ b/Documentation/driver-api/pci/p2pdma.rst
> @@ -9,22 +9,47 @@ between two devices on the bus. This type of transaction is henceforth
>  called Peer-to-Peer (or P2P). However, there are a number of issues that
>  make P2P transactions tricky to do in a perfectly safe way.
>  
> -One of the biggest issues is that PCI doesn't require forwarding
> -transactions between hierarchy domains, and in PCIe, each Root Port
> -defines a separate hierarchy domain. To make things worse, there is no
> -simple way to determine if a given Root Complex supports this or not.
> -(See PCIe r4.0, sec 1.3.1). Therefore, as of this writing, the kernel
> -only supports doing P2P when the endpoints involved are all behind the
> -same PCI bridge, as such devices are all in the same PCI hierarchy
> -domain, and the spec guarantees that all transactions within the
> -hierarchy will be routable, but it does not require routing
> -between hierarchies.
> -
> -The second issue is that to make use of existing interfaces in Linux,
> -memory that is used for P2P transactions needs to be backed by struct
> -pages. However, PCI BARs are not typically cache coherent so there are
> -a few corner case gotchas with these pages so developers need to
> -be careful about what they do with them.
> +For PCIe the routing of TLPs is well defined up until they reach a host bridge
> +or root port. If the path includes PCIe switches then based on the ACS settings
> +the transaction can route entirely within the PCIe hierarchy and never reach the
> +root port. The kernel will evaluate the PCIe topology and always permit P2P
> +in these well defined cases.
> +
> +However, if the P2P transaction reaches the host bridge then it might have to
> +hairpin back out the same root port, be routed inside the CPU SOC to another
> +PCIe root port, or routed internally to the SOC.
> +
> +As this is not well defined or well supported in real HW the kernel defaults to
> +blocking such routing. There is an allow list to allow detecting known-good HW,
> +in which case P2P between any two PCIe devices will be permitted.
> +
> +Since P2P inherently is doing transactions between two devices it requires two
> +drivers to be co-operating inside the kernel. The providing driver has to convay

                                                                             convey

> +its MMIO to the consuming driver. To meet the driver model lifecycle rules the
> +MMIO must have all DMA mapping removed, all CPU accesses prevented, all page
> +table mappings undone before the providing driver completes remove().
> +
> +This requires the providing and consuming driver to actively work together to
> +guarentee that the consuming driver has stopped using the MMIO during a removal

   guarantee

> +cycle. This is done by either a synchronous invalidation shutdown or waiting
> +for all usage refcounts to reach zero.
> +
> +At the lowest level the P2P subsystem offers a naked struct p2p_provider that
> +delegates lifecycle management to the providing driver. It is expected that
> +drivers using this option will wrap their MMIO memory in DMABUF and use DMABUF
> +to provide an invalidation shutdown. These MMIO pages have no struct page, and
> +if are used with mmap() must create special PTEs. As such there are very few

   if used

> +kernel uAPIs that can accept pointers to them, in particular they cannot be used
> +with read()/write(), including O_DIRECT.
> +
> +Building on this, the subsystem offers a layer to wrap the MMIO in a ZONE_DEVICE
> +pggmap of MEMORY_DEVICE_PCI_P2PDMA to create struct pages. The lifecylce of

   pgmap ?                                                        lifecycle

> +pgmap ensures that when the pgmap is destroyed all other drivers have stopped
> +using the MMIO. This option works with O_DIRECT flows, in some cases, if the
> +underlying subsystem supports handling MEMORY_DEVICE_PCI_P2PDMA through
> +FOLL_PCI_P2PDMA. The use of FOLL_LONGTERM is prevented. As this relies on pgmap
> +it also relies on architecture support along with alignment and minimum size
> +limitations.
>  
>  
>  Driver Writer's Guide
> @@ -114,14 +139,38 @@ allocating scatter-gather lists with P2P memory.
>  Struct Page Caveats
>  -------------------
>  
> -Driver writers should be very careful about not passing these special
> -struct pages to code that isn't prepared for it. At this time, the kernel
> -interfaces do not have any checks for ensuring this. This obviously
> -precludes passing these pages to userspace.
> +While the MEMORY_DEVICE_PCI_P2PDMA pages can be installed in VMAs,
> +pin_user_pages() and related will not return them unless FOLL_PCI_P2PDMA is set.
>  
> -P2P memory is also technically IO memory but should never have any side
> -effects behind it. Thus, the order of loads and stores should not be important
> -and ioreadX(), iowriteX() and friends should not be necessary.
> +The MEMORY_DEVICE_PCI_P2PDMA pages require care to support in the kernel. The
> +KVA is still MMIO and must still be accessed through the normal
> +readX()/writeX()/etc helpers. Direct CPU access (e.g. memcpy) is forbidden, just
> +like any other MMIO mapping. While this will actually work on some
> +architectures, others will experiance corruption or just crash in the kernel.

                              experience

> +Supporting FOLL_PCI_P2PDMA in a subsystem requires scrubbing it to ensure no CPU
> +access happens.
> +
> +
> +Usage With DMABUF
> +=================
> +
> +DMABUF provides an alternative to the above struct page based
> +client/provider/orchestrator system. In this mode the exporting driver will wrap
> +some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
> +
> +Userspace can then pass the FD to an importing driver which will ask the
> +exporting driver to map it.
> +
> +In this case the initator and target pci_devices are known and the P2P subsystem

                    initiator

> +is used to determine the mapping type. The phys_addr_t based DMA API is used to
> +establish the dma_addr_t.
> +
> +Lifecycle is controlled by DMABUF move_notify(), when the exporting driver wants
> +to remove() it must deliver an invalidation shutdown to all DMABUF importing
> +drivers through move_notify() and synchronously DMA unmap all the MMIO.
> +
> +No importing driver can continue to have a DMA map to the MMIO after the
> +exporting driver has destroyed it's p2p_provider.
                                  its

-- 
~Randy


