Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E809FCF8577
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519C66B00AA; Thu, 20 Nov 2025 04:29:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9F46B00AB; Thu, 20 Nov 2025 04:29:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B2D6B00AD; Thu, 20 Nov 2025 04:29:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 230A66B00AA
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:29:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EAF4C140821
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:20 +0000 (UTC)
X-FDA: 84130462080.18.AE32ECD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 22E8740006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FjXS5xxg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630959; a=rsa-sha256;
	cv=none;
	b=khcrt5Pruy0nT0+McpiqKLvb7HOqYeLyybdMFUQ7JBZwI5QQ5isjFHTCyTX2vyTetnyjAH
	iwSJ1W2Y7qVdBtgzeavtgVUYiNL2hLYjBm4DCnL4YojLd9Egr+fpPiRug9OGoa+08RxoSx
	bkRHu1rCWNJHdRQSoQ7Y8dgrJH5XDfE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FjXS5xxg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xi26Nj+mH9pkAMVtOJnxESIRzgA0tKu+e5NP/e+kAOc=;
	b=v1fxEeHN69LNTjkn4Ndx3gTTyyWvB93mARQIYXaXT986Z55kL3ynO2Q90WEQkeiX1XGF3p
	hLzEYlqVto6k9GDxrjv5UPOmiY/R/cTfux3uK37fBBxok3EtA9Ldn0fb/u/8K65q3veTyX
	MfsTPSm8u5inJSnpxf2DOEIBQcn0RhQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A66C443A2;
	Thu, 20 Nov 2025 09:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666AEC116B1;
	Thu, 20 Nov 2025 09:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630958;
	bh=HbIAswutZmHU50WkZwFvvW+Z9rofGYNf3OvdcoEIs14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjXS5xxgFO4vMVtP85WQadTqG8gg4I9D0CEQ4OYdSQUlg4NebyiNP+thVdrHCtEXN
	 krgA3LbE5JxM6EIcu6lQBr2cei5bh9JZea+OkLP7wM7SJ+NEhmrTNHdf1RKcBpASOd
	 QpWBo/ZVsHYmVPZUKsyQ2SI1KPum+cqOunGafihNsIwU3Jpt4TEopC2AYU/h2KeTm+
	 PAm4bNu23/2CagotptU5Lum9kkY30kXiYrrQE2yQyC9s/PBDfJ+wxB0omFiFQ5UNI/
	 dKV2W35qoFuGqmNact03CmAJeH8Q4ebcU+lULCP4em0Mllng4q2ukLxTcphNzYisFR
	 vkqQuydaeoS/Q==
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
Subject: [PATCH v9 05/11] PCI/P2PDMA: Document DMABUF model
Date: Thu, 20 Nov 2025 11:28:24 +0200
Message-ID: <20251120-dmabuf-vfio-v9-5-d7f71607f371@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 22E8740006
X-Stat-Signature: iwzpxfhu1w7qq6dnahfhck1j9wuuh3c1
X-Rspam-User: 
X-HE-Tag: 1763630958-333916
X-HE-Meta: U2FsdGVkX19poR06ObAJGkmnsYYsXY7nUSFejCGQAxDRhT2auLq7O5e2IwICDYkHBCoU/yIieXWM5mCMpbuMdikOV0z+eKPshuKOCn5rg74MVzLLUuBBdeqnVoeBcTJzO1Slbd/oRHtJGf9WbGcxPiiTQHuMsZxT3/lIsqzA5y0OCmQRRoZpeNvXFbES5dl/3ji+6oQqXs2SHLBoHMjlJf5hQc08v6dyVXI5tvmmDT1zplAULHszX1Dy0YyugZSDOK+278wXS+NnCVl+GBkb4nfalg4/rbCGqnU19x5mCAV+kL5fwu0EFJxyhSOJ+K5QaqR9ZscqBqD/Be9X0u3/9eNiNCrIFt0ZLyJ8DVeMDWFuvyap3mtO5wFthUCB3+hJ7TADEJicVMZ9kb3iArO54a0y1wI3afzVZ2RlcIfyppEG4eP347dkVUFTQm6MAJZWdpbjuvZ0eiBQgPP034MJpNk52m7AbOX00N/8IAbzGcJ6Xe+geEawjMKmAmpLMj0dszLtm24q9UsDqmiONVtFjF5ybjPup0s6bvQwRbJp6aF17CxTD+zyF3ch7EOm2yp7i/h2yK30dXbHsu3Ojj3oCD0ML+Q2PGJ6eI3woiP9eicaOqMyy4eI7pTxdkV+UBuXCbhISOJO9g2zbCtHrzKPKbiYs3nu0sLrJjVhWTIqJUsO3BNn6sbTo3Uu8i0I/LyJEiDob7mojWARB8pI1gYF94GY73ZSE41MlkX0vXGsAPkwGtSvD7J9WbrZ9v4JhIwh+8cPKeW+rzS1eJevFB6LMnqiUh3c0RVovwilxKoJViWwlcnOU4R5hDMYJyRNZ8WXutg1AH2kI0pDhZeNV+EptdZ5Ju6Cg3pcieXnntSUY9ElejymQ5XYR73K/cf3OlU/DuIu0aT+Lu4cD6oRPqbL9mrzA2Jk8CICH30TwmdsQaDOV/ysSM/Bmi03p8GhT1N1Y7lUcT+E7atCIHYTZZy
 xTtNHJsk
 EAy4zA11xmmJ1yablvXVru9P6C/ZWXC3vLzMCMIhmmuG5k2Ui6JZKsccqXBJ+BvAPIldAZfbv5SQS0cECn6fh+1HyXmgb52iPL6xvXGlwqqUMys6prpsPVUdgnrDjy4uc3rjwy0uAA4qblCo+psNJyF4wg/nXfdA+9wfSChD8G5r4Kt0e3zLWy4fzWyFtwXEtnCYS28wONtHYLZ8=
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
 Documentation/driver-api/pci/p2pdma.rst | 97 +++++++++++++++++++++++++--------
 1 file changed, 74 insertions(+), 23 deletions(-)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index d0b241628cf1..280673b50350 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -9,22 +9,48 @@ between two devices on the bus. This type of transaction is henceforth
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
+The PCIe specification doesn't define the forwarding of transactions between
+hierarchy domains and kernel defaults to blocking such routing. There is an
+allow list to allow detecting known-good HW, in which case P2P between any
+two PCIe devices will be permitted.
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
+to provide an invalidation shutdown. These MMIO addresess have no struct page, and
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
@@ -114,14 +140,39 @@ allocating scatter-gather lists with P2P memory.
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
+client/provider/orchestrator system and should be used when struct page
+doesn't exist. In this mode the exporting driver will wrap
+some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
+
+Userspace can then pass the FD to an importing driver which will ask the
+exporting driver to map it to the importer.
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


