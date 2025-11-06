Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 190B3CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775348E000F; Thu,  6 Nov 2025 09:17:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D1F8E0002; Thu,  6 Nov 2025 09:17:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63BC68E000F; Thu,  6 Nov 2025 09:17:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 534858E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:17:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 008865A95E
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:21 +0000 (UTC)
X-FDA: 84080384682.11.E350300
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 40982A0017
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EVBBjh9M;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762438640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vegjbXQ7c2+fl4QQE4CgAqiS6UfBU3ykBZXo4M1E5F4=;
	b=QonW1nofGDXeQLG85crS4CX4tUvaqt12b8XX+Tqr4SFEiKTFOvYxK6CQqwwRS4YogEBytv
	h0H6imMcpCZ39BPpJzzVx8fNv7lK9qACiGMBGRhEJ2TTplj6LbBZFhfuBWMrgaGhSzBFTD
	4Q88Edz5mCvGM/nbgtXAB3er/Io/fME=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EVBBjh9M;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762438640; a=rsa-sha256;
	cv=none;
	b=a/dXop771gz3wNJ+vj+KtFiINp0KSiC1QpWSpofzZ4oI1JkGliAEaBJGxJJKWrVm7wfL22
	P8OF/FKyp8JQMO+xvkpPQRJ32ArQhy7WePfjT0H9yD0Dj0xpEcvCUn10hnJ7lGdg9qRS3E
	HmMEFgKlqFrJCFd0ybmJ7Uy7jgZlXs8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B8EA06023B;
	Thu,  6 Nov 2025 14:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6B0C116C6;
	Thu,  6 Nov 2025 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762438639;
	bh=onb2Sujb111P2CO88DPIeX8mZgFkrHXz9Iju6/1tMSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVBBjh9MYGe2n4pRrl4zubjJVj73VuXok0tD6kvzYqCV8uHogzKmk3cN1oR79IbWS
	 SLgvhoyqxEvHtbEjJ3lCaB5wQbk4E4RL+ijuKXFkK4/fJazaj/Db2p0LtGTs/M/Uz3
	 EPdODgiGxIz51iQmfc7R2i/+38ihmy0E8TEXZbvHGKS3ouS3xLdG/IdNd3RabySUeN
	 9PxUucNCFmVMZM44R5Ws/lMGd1gbrEzp1aYwSCFcVaSiUV5ai6bNtbpJkSBL7JyukC
	 1SZFyDycrQ5LURbrFSpWUpIBGhzuhCSSX69o1MJoAkmLvNNlxDsMjgvIva5svyon7Y
	 y5BVKnnw4koeg==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Cc: Krishnakant Jaju <kjaju@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v7 05/11] PCI/P2PDMA: Document DMABUF model
Date: Thu,  6 Nov 2025 16:16:50 +0200
Message-ID: <20251106-dmabuf-vfio-v7-5-2503bf390699@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40982A0017
X-Stat-Signature: y1dqdaexd6g97sibrhgf91ks7o4eauhf
X-Rspam-User: 
X-HE-Tag: 1762438640-219575
X-HE-Meta: U2FsdGVkX19+VJtGJ/LLVXBHdein9wFyXwxrI2IVpdUNSAmIpY5+tDGSddTc4wKz4Q86jk1aFysPhHXuDxBvfVE03ikrD4r0lzMkUQ26bY17NpesnY7zKWw28LtM3BFnIEntPLqhpI7PQKAAKju8rFS8/jRNa9spAZMMYxgu81ADJzIORHqVhkpeYCCB1B6aO+4YUhITos0VGlGmlsD2LYncN/KJRdm4qdMSGRjPuR4ZIDZ8twn/P630UemnXIZ552me4km221Oxz+2lrjbU1h8pukxUon0mg3cA881laAmRtjiHlnSWkrlL2HfZgPYKyyRO+xumj46lTsMtezTpXnyfl+olCsD0x8KMd8Xi85jdOgDFCdg2Kx/eKudcGXghMVw/7tLtqtRALursugZfBiHkx6Hi3Kt4+iCd/YSINyI+1T+n5yVuZWOWBilBLzLxUQq7O+H6ZswbRT5IpGweSHkdNa8i4lUSN4/lNu17WAcg/IaeLQ4eAhJ5fKdwGYXCXni8ZKTApdGD9mw7hI0yc+LvaOHh7LednGQ5V67SxXt4dWCNO/wIPM+T7mGkbILcMnyilRThNCIZxq55eQFp34BbsvlslzcMBmq0XMd28EWhG/PGUvvcXaHiP1JW8IFdCQ1717CUzzgZkDzMVEZt00Kls5WXKYgna8A3KcsK1GVfKKYG7P49pvSuqwV7mMODCZCfac4f36S2XARtlfiQfKG+i0szZmEJeCOpC/l4xB7rIPGcxgMOzr2G5IabUY8dB/MHGGdwUpFYy5TEmesvqRGswBovY5FqaDP1byl3ZYIKtD43yhev8EIwBsDzY7TzA6aC4nijl+TfuM8KJ19rVOjCO/imDFP/pomAK2Mf4hPzZkdmwGarWOtuIlUJS7IfxmkW3F1KEw+zRGpdufpfIVDmA2gpXn5A+WjdN/oFPJ0JlnzMl7teU7CHfdOfNRkSukzbp7VNfKmnSHS41KA
 5LZoCRnn
 gnwVvhNxEPiF1zrvYQ7kIKoSDep53yABcCKi2k8EqmIJ4vWU1tSZE8GzlUXCj3ahaL0T6kOeEnVAIgczTBf5dVjkJvc+n8tzIJkPqMqmDIVQpwXk7M86WIsIm5EC13EM+7T7CiRLr/nKkn68rI3c27GSXKysSNI34USgbGzrVajXUOkq9hGC0Km2xN7YU+UcbhqJmStSm5Hedl8Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jason Gunthorpe <jgg@nvidia.com>

Reflect latest changes in p2p implementation to support DMABUF lifecycle.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
 1 file changed, 72 insertions(+), 23 deletions(-)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index d0b241628cf1..69adea45f73e 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -9,22 +9,47 @@ between two devices on the bus. This type of transaction is henceforth
 called Peer-to-Peer (or P2P). However, there are a number of issues that
 make P2P transactions tricky to do in a perfectly safe way.
 
-One of the biggest issues is that PCI doesn't require forwarding
-transactions between hierarchy domains, and in PCIe, each Root Port
-defines a separate hierarchy domain. To make things worse, there is no
-simple way to determine if a given Root Complex supports this or not.
-(See PCIe r4.0, sec 1.3.1). Therefore, as of this writing, the kernel
-only supports doing P2P when the endpoints involved are all behind the
-same PCI bridge, as such devices are all in the same PCI hierarchy
-domain, and the spec guarantees that all transactions within the
-hierarchy will be routable, but it does not require routing
-between hierarchies.
-
-The second issue is that to make use of existing interfaces in Linux,
-memory that is used for P2P transactions needs to be backed by struct
-pages. However, PCI BARs are not typically cache coherent so there are
-a few corner case gotchas with these pages so developers need to
-be careful about what they do with them.
+For PCIe the routing of TLPs is well defined up until they reach a host bridge
+or root port. If the path includes PCIe switches then based on the ACS settings
+the transaction can route entirely within the PCIe hierarchy and never reach the
+root port. The kernel will evaluate the PCIe topology and always permit P2P
+in these well defined cases.
+
+However, if the P2P transaction reaches the host bridge then it might have to
+hairpin back out the same root port, be routed inside the CPU SOC to another
+PCIe root port, or routed internally to the SOC.
+
+As this is not well defined or well supported in real HW the kernel defaults to
+blocking such routing. There is an allow list to allow detecting known-good HW,
+in which case P2P between any two PCIe devices will be permitted.
+
+Since P2P inherently is doing transactions between two devices it requires two
+drivers to be co-operating inside the kernel. The providing driver has to convey
+its MMIO to the consuming driver. To meet the driver model lifecycle rules the
+MMIO must have all DMA mapping removed, all CPU accesses prevented, all page
+table mappings undone before the providing driver completes remove().
+
+This requires the providing and consuming driver to actively work together to
+guarantee that the consuming driver has stopped using the MMIO during a removal
+cycle. This is done by either a synchronous invalidation shutdown or waiting
+for all usage refcounts to reach zero.
+
+At the lowest level the P2P subsystem offers a naked struct p2p_provider that
+delegates lifecycle management to the providing driver. It is expected that
+drivers using this option will wrap their MMIO memory in DMABUF and use DMABUF
+to provide an invalidation shutdown. These MMIO pages have no struct page, and
+if used with mmap() must create special PTEs. As such there are very few
+kernel uAPIs that can accept pointers to them, in particular they cannot be used
+with read()/write(), including O_DIRECT.
+
+Building on this, the subsystem offers a layer to wrap the MMIO in a ZONE_DEVICE
+pgmap of MEMORY_DEVICE_PCI_P2PDMA to create struct pages. The lifecycle of
+pgmap ensures that when the pgmap is destroyed all other drivers have stopped
+using the MMIO. This option works with O_DIRECT flows, in some cases, if the
+underlying subsystem supports handling MEMORY_DEVICE_PCI_P2PDMA through
+FOLL_PCI_P2PDMA. The use of FOLL_LONGTERM is prevented. As this relies on pgmap
+it also relies on architecture support along with alignment and minimum size
+limitations.
 
 
 Driver Writer's Guide
@@ -114,14 +139,38 @@ allocating scatter-gather lists with P2P memory.
 Struct Page Caveats
 -------------------
 
-Driver writers should be very careful about not passing these special
-struct pages to code that isn't prepared for it. At this time, the kernel
-interfaces do not have any checks for ensuring this. This obviously
-precludes passing these pages to userspace.
+While the MEMORY_DEVICE_PCI_P2PDMA pages can be installed in VMAs,
+pin_user_pages() and related will not return them unless FOLL_PCI_P2PDMA is set.
 
-P2P memory is also technically IO memory but should never have any side
-effects behind it. Thus, the order of loads and stores should not be important
-and ioreadX(), iowriteX() and friends should not be necessary.
+The MEMORY_DEVICE_PCI_P2PDMA pages require care to support in the kernel. The
+KVA is still MMIO and must still be accessed through the normal
+readX()/writeX()/etc helpers. Direct CPU access (e.g. memcpy) is forbidden, just
+like any other MMIO mapping. While this will actually work on some
+architectures, others will experience corruption or just crash in the kernel.
+Supporting FOLL_PCI_P2PDMA in a subsystem requires scrubbing it to ensure no CPU
+access happens.
+
+
+Usage With DMABUF
+=================
+
+DMABUF provides an alternative to the above struct page based
+client/provider/orchestrator system. In this mode the exporting driver will wrap
+some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
+
+Userspace can then pass the FD to an importing driver which will ask the
+exporting driver to map it.
+
+In this case the initiator and target pci_devices are known and the P2P subsystem
+is used to determine the mapping type. The phys_addr_t based DMA API is used to
+establish the dma_addr_t.
+
+Lifecycle is controlled by DMABUF move_notify(), when the exporting driver wants
+to remove() it must deliver an invalidation shutdown to all DMABUF importing
+drivers through move_notify() and synchronously DMA unmap all the MMIO.
+
+No importing driver can continue to have a DMA map to the MMIO after the
+exporting driver has destroyed its p2p_provider.
 
 
 P2P DMA Support Library

-- 
2.51.1


