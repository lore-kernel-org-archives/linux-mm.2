Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2920DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80ADC8E001D; Tue, 11 Nov 2025 04:58:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2B68E0002; Tue, 11 Nov 2025 04:58:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71FCA8E001D; Tue, 11 Nov 2025 04:58:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60F8F8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:58:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22A24C0204
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:35 +0000 (UTC)
X-FDA: 84097876590.03.1A2C23F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4F882A0006
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=soBf3FcZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855113; a=rsa-sha256;
	cv=none;
	b=tKaQuI6+fGaolrZlfm2zJsj/ohPeCHPeSaxI+HC6uGqRfUuTPq2QryZVWRQBmLjbN1n82t
	mvQa+YTEkuE56XYJOZ3Mxc0WbM2CsClljZLhslT/PEyjpoBW7KzH2Sv2mIWoVl8np2/+i0
	YNpRwQgQFkEdDcumPJIuLjcAft7a9l0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=soBf3FcZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUec9HFTvNtF36yWfmoouWnZGwLlnj01bTYWVksnptc=;
	b=FHvH4inr0J7azCWmvHbdy42db4ZT77LFfrmIUyISZ719NlkLBsPSQrvJnfTY3lkpRfjtvN
	qx+X/e5LjUTqGqoLyZSI9/fY0RKUCnnA+PmSYsrBgHJ4YQlDFbVjBAgRfrYRC2/1LeYih/
	3os6d2cLJtcr6lQnjbHG17kSX9hZm0U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80C9942E41;
	Tue, 11 Nov 2025 09:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2142C116D0;
	Tue, 11 Nov 2025 09:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855112;
	bh=b7gz75KWDYFW7cwC57wJqWOmJpTgpfce3NwANuH5MII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soBf3FcZOGX+pdXCW8WioABKE3IvDooJvM6mWMgOdWncy9ZGIOpxnxCRl21kjdSJl
	 Dajk/Z1jjSHvDXY6dmF8v4GzAYzfBkAo+qsOTKWujiBLIC4uUHVHDrhaGEhn1T3H8N
	 OwoWXDJg7zHbyxnac0RYkhN2A5r2cHNSyU5k6ZjeHTXXzoqxGEfmFz7Sdv5Va0qxtY
	 4MUZRbCYMOyl+IkoeMC2f8Dw3PlVcyJZ3Tui9OjDI+4LsWl38mM/dw/l3b3wv/GHDx
	 EhWH2LCwJWJ0zB+RwnIJ0OJ/VxnaRSYUnkIGPLOClHlBDd0LkeemKOwV3bUbNi4HG1
	 SXSHacARTWGIg==
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
Subject: [PATCH v8 05/11] PCI/P2PDMA: Document DMABUF model
Date: Tue, 11 Nov 2025 11:57:47 +0200
Message-ID: <20251111-dmabuf-vfio-v8-5-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F882A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: dokom1otdgzh9mgr5jhz9tnk7t1dmctg
X-Rspam-User: 
X-HE-Tag: 1762855113-751670
X-HE-Meta: U2FsdGVkX1/c682CpHTJpa9HgJSQJKiCUU0klqZUcXmUr1GwfQAlD7lzGuOWUmK3mMVi0RJafvalssL1DLEcSYXdVG0gccP0Di2hjdxLGkYH5fofCSckdoa6ge+odTtXlTU4cZpWrxa+UvCX1h0m6serImHyYaE6+0zg3vW2mp5TUGKkkMKScfowIHPrAYgLs/VRn59gWLnqG2IpFpBRcNG1cnFR06T0qjeJKM9QE0rgDhogC3j1nYOkVCq3P1GPR60S++r147oA8cREa7q+fEthsikb48t9+s1kqE4RDAuSKp1qxIiB2KlrXqe3PksnyX2wKbIsuTXWjNmscFYwD0o/GGNgrn+AsjQ3mGAT6ym2GFecIf8AGkyszmvSw4jzOINzgJrYkpfsBjbLqK1CvzfXPkxbYPeUmhk0Vs46WS5U41tQB7J3OpzV1qV9tpQrUpahTNTuzOYZNke8n5VSjboJ6uX9DpDVo1pYQ3hA0RYI0hvWQF0kikUFxXMMkynXd8V/OPbb0RYZhcMs0w+0nIYLwuHkjsECE3PAlZMCezo47N6Gzy5wqM/rvCUZ9TLf6TsoS07h/dc3fDyrAGghKlpKq0kMmebLlHKXNQ+oMpK+9qTVVphsQda1TyfnvN8W2RphXFB4Kz2reS7U8tn2vhhMBEbPb/UARDO/YK3XEsqds6b092x8YV8uprmDEpzJ77a3J6bRMRg5jxtZMoRM9i/q8SzrGN+DZib9MahhW+qL7Glv6iWthtTEc2QkBykIpUQR2xlxFTTQVSsBZvV7yGPcMQofIMn1Y10NDwSdRw787sQfY/mWW2R3h21r1aNZEiAoVgFHChcgrrq0YBW8Lbtc3aJR30eRnTQZqYIncjQb6qefMJHrfb2PwGnznEbyN9qxVDq1/4Wp61EAy10lGSj2cmFaIoFiyho7VKO8LThFYAqMJWJenkJ2RGMEthhqtnCtBtZOlpGfNCARlhJ
 JBk3V7KO
 kJZGuEft4B7nbQAVpgbUifzRPtY3+9EV55DnmIUOFVaBRY4ZRjGbjRkU0o29zfYIt0YLEFUvPC6fCXqUveb2e8YavWYM/HGveKR2cHjrjXmMGhwblXnYU8uZ1o8vlzXwLVLZWZJjXgoc4Y2VgkTGCBcQY3aiNEVIihuRm/nM5lQdl7BU2gipOimciK0pDfufhHbdL0zSrRsWZqbo=
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
index d0b241628cf1..77e310596955 100644
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
+For PCIe the routing of Transaction Layer Packets (TLPs) is well-defined up
+until they reach a host bridge or root port. If the path includes PCIe switches
+then based on the ACS settings the transaction can route entirely within
+the PCIe hierarchy and never reach the root port. The kernel will evaluate
+the PCIe topology and always permit P2P in these well-defined cases.
+
+However, if the P2P transaction reaches the host bridge then it might have to
+hairpin back out the same root port, be routed inside the CPU SOC to another
+PCIe root port, or routed internally to the SOC.
+
+As this is not well-defined or well-supported in real HW the kernel defaults to
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
+kernel uAPIs that can accept pointers to them; in particular they cannot be used
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
+DMABUF provides an alternative to the above struct page-based
+client/provider/orchestrator system. In this mode the exporting driver will wrap
+some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
+
+Userspace can then pass the FD to an importing driver which will ask the
+exporting driver to map it.
+
+In this case the initiator and target pci_devices are known and the P2P subsystem
+is used to determine the mapping type. The phys_addr_t-based DMA API is used to
+establish the dma_addr_t.
+
+Lifecycle is controlled by DMABUF move_notify(). When the exporting driver wants
+to remove() it must deliver an invalidation shutdown to all DMABUF importing
+drivers through move_notify() and synchronously DMA unmap all the MMIO.
+
+No importing driver can continue to have a DMA map to the MMIO after the
+exporting driver has destroyed its p2p_provider.
 
 
 P2P DMA Support Library

-- 
2.51.1


