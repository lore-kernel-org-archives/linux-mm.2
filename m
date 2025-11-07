Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D44CCFA19
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 06:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385628E0007; Fri,  7 Nov 2025 01:15:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E148E0002; Fri,  7 Nov 2025 01:15:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A0F8E0007; Fri,  7 Nov 2025 01:15:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 183DB8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:15:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A488712C72F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 06:15:25 +0000 (UTC)
X-FDA: 84082799010.04.201597F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id D12EE160004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 06:15:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wvMjfD9U;
	spf=none (imf08.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762496124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0pvYkku9B0Yn9Tva4Hva9YRPLFO4fPY61E/RWmTzPOE=;
	b=BKbZH6SdDFxQkw5DwKr3psdVb8OWUpfH3XpE1IB4t6c4ZMi/oDMuYXZ3oy1lsU+WDdWMzw
	IN65UF1qHvk8pfV8JGJt3i7YIM33oKZjH66tkUVJ6XRBWByXSWvUih2hU2De+zySBB7FoL
	7mXHzeyfkNNI+Uz34gME/jEusTAXjGU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762496124; a=rsa-sha256;
	cv=none;
	b=XCsB7Nt8iAbB++QTJjYq1A3B1OmC1Xq/R43LQyvsPFGXJixa3oXX1NUXZuiorbcBAjLJFT
	TyxMimAcqHAfaNjF2xqZa2N9JyAOqSTA/Qiy6ANXj2RHCIbY/xpETGkVj0wmnyT7wXww1m
	acW8p+jBixkPOABORB4zgoPQ/bZG0Rs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wvMjfD9U;
	spf=none (imf08.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=0pvYkku9B0Yn9Tva4Hva9YRPLFO4fPY61E/RWmTzPOE=; b=wvMjfD9UaT3srkTJPow+61yh3N
	OkqKLwST4F525xsesZaRDbQI9izo2FfdhHtCjqZ3ddTVdax7Lbdgnf3nwx9GqRsSsOg9py4xU5yxh
	bPCADIElPjneqxaGddELsdxhLXoiqP4M/8r7MreKn0SZbf+EhyjNv7u7QgJqPc2ZScsbeGgSGitqe
	Kp+se6E94iE6eytcZ6nxR+//81zWQ00AfcMbb5fV4pm5JvbLV6094pdLiv6j8n2ddM00wptAT43yq
	DfNQo+F2OVUd3YbNTBAvqviVZrXwl/dKKcX3sKfwlN3RPj1b1LBIVRhqzil1G0Ezlc9ba4An/rhpu
	5dyhj6jQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHFka-0000000Givm-3DWD;
	Fri, 07 Nov 2025 06:15:08 +0000
Message-ID: <135df7eb-9291-428b-9c86-d58c2e19e052@infradead.org>
Date: Thu, 6 Nov 2025 22:15:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/11] PCI/P2PDMA: Document DMABUF model
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>
Cc: Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251106-dmabuf-vfio-v7-5-2503bf390699@nvidia.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251106-dmabuf-vfio-v7-5-2503bf390699@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: D12EE160004
X-Stat-Signature: 1odrzj3ymoeqxps3zcwjfie1qgy4affc
X-HE-Tag: 1762496122-672625
X-HE-Meta: U2FsdGVkX18ioKfmmWqoGlRwOxV28NZ2kMWazROpmiE9BBnT5TqGt/rx5TJj9O+YFXnqu0ig2PH7cdNoSAg3Em9UHscaRJnf5J12aua0QpRiOFQjBI+dbFKLMIE8NXxp4Vl0KRvGk2UBW73aT7D/Zkgg+8QoK7Apoi/yYS3ThpnN746gXdpKYANmPu+X+bqnvI62Q3xZ68LpQvAvdD5xhkgPYfgRF9Uyy1oiGL6GgIXX0eKEjc6zMo8Nw+9CjS1OWHU7emiPCZBl5FYuNkt+RA6DHaXATwYiILRmooNGVCu237eflDjPvu105M9R+WKKi0eokMbV2spDIvWpOSNEOJaLu2mYT7KAw7K0fpI8j3ZbiZ9HHB+Qyaq0vrtSU3jc2JYH4fUXuYEohqy2qP1XHVcEFsycZJ0J/Iqr/6A/vkmnplIXHC7igTTYd+HTrdDyowusaHMpTm/wpFCqaKTP8jwpoDYbvN6Dg2Ocm+o9fadq+OgC2La3pctW72VM36El9zBW6g99cUFTHsFrndDEJUF+rtWSNqja+UrMtfuYvu0/TyAiF2P8OeVr6pJnPUeudf5IFz1jA0NaBz4GwBIFw/VNrSHJEjlC1Bqie34eajpDha2a/qklRq6NOwvEFRlOTs7WcbSjUHH1tfGiGvQ1DHJs8pPiTVDNWRokpnc5JGh2iTLBrfV3SfdgNw6xDkUH4ETU6M2kyWEcWRYF1L5ZLVUU0pDU/97SYj5pxjeAg0aWQRXfi12QQ7df9oGtYDjcdtlZr2LKXjy73zZAxvCgBBziKm0yp3/sDQZ05eudcit74Ugb2LUr2txH1ekaMwQpurapyTEEutvXPM5Z4luGOsyWsh58kiD1JWhbuMM1zXTCJZH0VMZOQfKm+Y5C1XMNqQYXBFXgFVpgNjfuskCYwMXG04UJ15dXcPh/VLCiO+YWDW43iPS/Pjlfj1tGv6UuVk4lvIHfVsDenVN+QpO
 cVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/6/25 6:16 AM, Leon Romanovsky wrote:
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
> index d0b241628cf1..69adea45f73e 100644
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

Define what TLP means?
                                   well-defined

> +or root port. If the path includes PCIe switches then based on the ACS settings
> +the transaction can route entirely within the PCIe hierarchy and never reach the
> +root port. The kernel will evaluate the PCIe topology and always permit P2P
> +in these well defined cases.

            well-defined

> +
> +However, if the P2P transaction reaches the host bridge then it might have to
> +hairpin back out the same root port, be routed inside the CPU SOC to another
> +PCIe root port, or routed internally to the SOC.
> +
> +As this is not well defined or well supported in real HW the kernel defaults to

                  well-defined or well-supported

> +blocking such routing. There is an allow list to allow detecting known-good HW,
> +in which case P2P between any two PCIe devices will be permitted.
> +
> +Since P2P inherently is doing transactions between two devices it requires two
> +drivers to be co-operating inside the kernel. The providing driver has to convey
> +its MMIO to the consuming driver. To meet the driver model lifecycle rules the
> +MMIO must have all DMA mapping removed, all CPU accesses prevented, all page
> +table mappings undone before the providing driver completes remove().
> +
> +This requires the providing and consuming driver to actively work together to
> +guarantee that the consuming driver has stopped using the MMIO during a removal
> +cycle. This is done by either a synchronous invalidation shutdown or waiting
> +for all usage refcounts to reach zero.
> +
> +At the lowest level the P2P subsystem offers a naked struct p2p_provider that
> +delegates lifecycle management to the providing driver. It is expected that
> +drivers using this option will wrap their MMIO memory in DMABUF and use DMABUF
> +to provide an invalidation shutdown. These MMIO pages have no struct page, and
> +if used with mmap() must create special PTEs. As such there are very few
> +kernel uAPIs that can accept pointers to them, in particular they cannot be used

                                            them;

> +with read()/write(), including O_DIRECT.
> +
> +Building on this, the subsystem offers a layer to wrap the MMIO in a ZONE_DEVICE
> +pgmap of MEMORY_DEVICE_PCI_P2PDMA to create struct pages. The lifecycle of
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
> +architectures, others will experience corruption or just crash in the kernel.
> +Supporting FOLL_PCI_P2PDMA in a subsystem requires scrubbing it to ensure no CPU
> +access happens.
> +
> +
> +Usage With DMABUF
> +=================
> +
> +DMABUF provides an alternative to the above struct page based

                                                      page-based

> +client/provider/orchestrator system. In this mode the exporting driver will wrap
> +some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
> +
> +Userspace can then pass the FD to an importing driver which will ask the
> +exporting driver to map it.
> +
> +In this case the initiator and target pci_devices are known and the P2P subsystem
> +is used to determine the mapping type. The phys_addr_t based DMA API is used to

                                              phys_addr_t-based

> +establish the dma_addr_t.
> +
> +Lifecycle is controlled by DMABUF move_notify(), when the exporting driver wants

                                     move_notify(). When

> +to remove() it must deliver an invalidation shutdown to all DMABUF importing
> +drivers through move_notify() and synchronously DMA unmap all the MMIO.
> +
> +No importing driver can continue to have a DMA map to the MMIO after the
> +exporting driver has destroyed its p2p_provider.
>  
>  
>  P2P DMA Support Library
> 

-- 
~Randy


