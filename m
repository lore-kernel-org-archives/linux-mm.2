Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA57CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB05E8E000E; Fri,  7 Nov 2025 11:01:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D615C8E0002; Fri,  7 Nov 2025 11:01:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77188E000E; Fri,  7 Nov 2025 11:01:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7FBF8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:01:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C53D1A0553
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:01:28 +0000 (UTC)
X-FDA: 84084275856.19.96F11F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F8D7140029
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:01:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1OqoxtV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762531286; a=rsa-sha256;
	cv=none;
	b=UpC9i0xTaZUNE5jd3w5k9tYdOgSk2QITWqyVxYH2wV14pxNDqGtwRPi735rjsjheb/y3/4
	3etYlHeR0CocaIJj5Wj2Y6Ldd4nALl7avtKzvILUOvsCmJUtafMzLutNdzzDlqMqTdBnXz
	8aEK2p9UyYy3iIlym7RS1FNJFz791r0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G1OqoxtV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762531286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3Dsmj2ftRNMUdUGJSJ8SqA72nOEiJpkEJOcUv1RyR4=;
	b=E8NjDIEfky7+mIVNgLyWeRNgSoiWFwHNiRLecqr5OXoEIDrbBMBUvCvk7nSF60civWjK2+
	1dmY0AYkBkxSNGgtyqJXLz9B028DZVuESadYlMV3m4ZrXyo7fGgsHFTQY9/9pXVevRV7nU
	E7kfkSNkjBC7Usa8L13bmE4mCQ84jOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DBCC861913;
	Fri,  7 Nov 2025 16:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30C3C4CEF8;
	Fri,  7 Nov 2025 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762531285;
	bh=SAXkSml11M5xQ5oAowfwGP1WfIbbhD9Zwsc1+gFtZVE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G1OqoxtV7XlT2wwuQ5Uez60kwG8g2e3K4oXYvr5lCUmDLnRe2lDqJfqpdyozZ9Kfs
	 9cK/Pp4gs2exlM5ZaZgfE/mSts/OwwIwkCNUlopoOf55C/E/oCxFH4g1GkpuhBOQLc
	 GevH4WEkQ/xUCsGWGMcEuw40zHNAV2BFJUHAJFbr5fa5pHtu6BKUEsKKzGsJoGHBVK
	 LIruon02MTTCyGk7ziSVANwsf4TxGmKVozxHLsq3vvxJUR+H9wB9GZSvIotqrUV4ud
	 cVhLCCIpj3frChH2BVoHb8jxb4jO/OzKabXV1PHaTXuqZVIniF59yBQsetybD1Wq21
	 bF79hpL4xdXKw==
Date: Fri, 7 Nov 2025 18:01:20 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v7 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251107160120.GD15456@unreal>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251106-dmabuf-vfio-v7-5-2503bf390699@nvidia.com>
 <135df7eb-9291-428b-9c86-d58c2e19e052@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <135df7eb-9291-428b-9c86-d58c2e19e052@infradead.org>
X-Rspamd-Queue-Id: 8F8D7140029
X-Rspamd-Server: rspam07
X-Stat-Signature: k3xuypr9p9jh4gfi6ppf316j59k9dbbf
X-Rspam-User: 
X-HE-Tag: 1762531286-165395
X-HE-Meta: U2FsdGVkX198Dv0mkuPDyrjw9uvAIM9NvRxGw9lOj8IyQga4RlzDcZU44Vu5zwyWmDj52SEsVGHL/9kuzH1tugAPJIrhA0rDKtQdSznCT7D54zYvp9Jc5hjMtd6Qt+aQaVqbseUqLFG3OCZGPqkwENbRrNbk6yw5p/K9LiwwfCMskh8ZpgQSJ9aAx4+6tisJ39OrpRMd+coQHahbZFVlozNjGdLokY5cUMlCayPk0MRoTMupB8e28HG0HTOoBj6c+g5tdat538s0WTMWrp6thR/0dKbEkqGaizsChxxYD92USovU2Fe+9LSSGNVdgHSBWK/+yg0Fy5LHOxnHzMqglcVWFiHewiSnebkVLhhL6ttUbRzUEXNP/nCjgL/SzjfwmyGHoVvaf3JS/Hd6fxuxMRkr4R/fs6yYP2vq7m4zDsUS9WOfqJ29UxS/kUVwwH8nX+onA/x39r/btw3ff95hAP5BOwEtYkzRY3t73ekEmjO9PEcN/pHwscYpbhAroVBzatcqRrDJrlAuXVqzeuRN3O3bwhdqM6EVcLWxFvmQt7c0dcHqoMT1JKoGOenN9byURzgy5+UsPGDjBfIU6qOJNqNSULEhav/sCJG4Oh1E/AxAQwXNvK+ERLK8/b9KqiGixwLyWUFgbNbFZ3hUm4WfDM9IurRei7XnSxCjaNlBLHYBmOmyWE5GG6THLfK1VnEYRY3dRfCcgK2yZfnQTTxJff1gD6T7xwv6RJ5cyOAVuKrBreiQtWwbkbHUUQWbXZb3SWjC1Jlv3fpah8YYOMI4g0p3HcI7ZdFXOi8xhTmCSwkWuGVfuQdgWNx+vruexgB8fWdnalj2yJ4L8zJHbA89IDDQuYXBmhmtklBOsj9J3U8+PrL0AOKV9NkKjqyxwitmcqcxpfKEs9jTqceiK3U0zK4sAUZfqNfyTppEIXPcRAxQQE8CW5yt/7ChUMLR1oR522OnxFdxF8ugUf64M9u
 BQoMuyBy
 zYshY6q0C1MlMm1mGneqWsh7vLBTiV0u/4et6uzDEINKUY7y3rKo4Vu+hxDhGsjEYelch6+1lRa0blLWE/qMo3hGdFhnoKvQ5c7FDOVrg1xpAL5St2Hk/VJ98VDBxdj+ZsU6xl8hK6v7wr8wWmHA4OXUvTnYoqvlnQ6ftVpA0WFJVFj6PDteMllhbGd9I8u1rnWR06PFpEYRUibrPaxtaHuPXOxR8aBWExZ9NhMzOffR5ctLS/sKKGv1ncaSegyABnN/3s/7wIonvi1kY9oeeYPQdmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 10:15:07PM -0800, Randy Dunlap wrote:
> 
> 
> On 11/6/25 6:16 AM, Leon Romanovsky wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Reflect latest changes in p2p implementation to support DMABUF lifecycle.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
> >  1 file changed, 72 insertions(+), 23 deletions(-)
> > 
> > diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> > index d0b241628cf1..69adea45f73e 100644
> > --- a/Documentation/driver-api/pci/p2pdma.rst
> > +++ b/Documentation/driver-api/pci/p2pdma.rst
> > @@ -9,22 +9,47 @@ between two devices on the bus. This type of transaction is henceforth
> >  called Peer-to-Peer (or P2P). However, there are a number of issues that
> >  make P2P transactions tricky to do in a perfectly safe way.
> >  
> > -One of the biggest issues is that PCI doesn't require forwarding
> > -transactions between hierarchy domains, and in PCIe, each Root Port
> > -defines a separate hierarchy domain. To make things worse, there is no
> > -simple way to determine if a given Root Complex supports this or not.
> > -(See PCIe r4.0, sec 1.3.1). Therefore, as of this writing, the kernel
> > -only supports doing P2P when the endpoints involved are all behind the
> > -same PCI bridge, as such devices are all in the same PCI hierarchy
> > -domain, and the spec guarantees that all transactions within the
> > -hierarchy will be routable, but it does not require routing
> > -between hierarchies.
> > -
> > -The second issue is that to make use of existing interfaces in Linux,
> > -memory that is used for P2P transactions needs to be backed by struct
> > -pages. However, PCI BARs are not typically cache coherent so there are
> > -a few corner case gotchas with these pages so developers need to
> > -be careful about what they do with them.
> > +For PCIe the routing of TLPs is well defined up until they reach a host bridge
> 
> Define what TLP means?

In PCIe "world", TLP is very well-known and well-defined acronym, which
means Transaction Layer Packet.

>                                    well-defined

Thanks

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 69adea45f73e..7530296a5dea 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -9,17 +9,17 @@ between two devices on the bus. This type of transaction is henceforth
 called Peer-to-Peer (or P2P). However, there are a number of issues that
 make P2P transactions tricky to do in a perfectly safe way.

-For PCIe the routing of TLPs is well defined up until they reach a host bridge
-or root port. If the path includes PCIe switches then based on the ACS settings
-the transaction can route entirely within the PCIe hierarchy and never reach the
-root port. The kernel will evaluate the PCIe topology and always permit P2P
-in these well defined cases.
+For PCIe the routing of Transaction Layer Packets (TLPs) is well-defined up
+until they reach a host bridge or root port. If the path includes PCIe switches
+then based on the ACS settings the transaction can route entirely within
+the PCIe hierarchy and never reach the root port. The kernel will evaluate
+the PCIe topology and always permit P2P in these well-defined cases.

 However, if the P2P transaction reaches the host bridge then it might have to
 hairpin back out the same root port, be routed inside the CPU SOC to another
 PCIe root port, or routed internally to the SOC.

-As this is not well defined or well supported in real HW the kernel defaults to
+As this is not well-defined or well supported in real HW the kernel defaults to
 blocking such routing. There is an allow list to allow detecting known-good HW,
 in which case P2P between any two PCIe devices will be permitted.

@@ -39,7 +39,7 @@ delegates lifecycle management to the providing driver. It is expected that
 drivers using this option will wrap their MMIO memory in DMABUF and use DMABUF
 to provide an invalidation shutdown. These MMIO pages have no struct page, and
 if used with mmap() must create special PTEs. As such there are very few
-kernel uAPIs that can accept pointers to them, in particular they cannot be used
+kernel uAPIs that can accept pointers to them; in particular they cannot be used
 with read()/write(), including O_DIRECT.

 Building on this, the subsystem offers a layer to wrap the MMIO in a ZONE_DEVICE
@@ -154,7 +154,7 @@ access happens.
 Usage With DMABUF
 =================

-DMABUF provides an alternative to the above struct page based
+DMABUF provides an alternative to the above struct page-based
 client/provider/orchestrator system. In this mode the exporting driver will wrap
 some of its MMIO in a DMABUF and give the DMABUF FD to userspace.

@@ -162,10 +162,10 @@ Userspace can then pass the FD to an importing driver which will ask the
 exporting driver to map it.

 In this case the initiator and target pci_devices are known and the P2P subsystem
-is used to determine the mapping type. The phys_addr_t based DMA API is used to
+is used to determine the mapping type. The phys_addr_t-based DMA API is used to
 establish the dma_addr_t.

-Lifecycle is controlled by DMABUF move_notify(), when the exporting driver wants
+Lifecycle is controlled by DMABUF move_notify(). When the exporting driver wants
 to remove() it must deliver an invalidation shutdown to all DMABUF importing
 drivers through move_notify() and synchronously DMA unmap all the MMIO.


