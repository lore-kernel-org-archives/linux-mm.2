Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19F0ACAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730048E000F; Sun, 28 Sep 2025 10:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0568E0001; Sun, 28 Sep 2025 10:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CFC48E000F; Sun, 28 Sep 2025 10:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 498148E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:51:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEA081A0115
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:28 +0000 (UTC)
X-FDA: 83938947456.25.3D4945F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 85C9B1C0004
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLB5tQ50;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759071087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLs+9/QfZvjYcGZI0vNgljqTO8DzEAtYnlYfPoeOhc0=;
	b=DvmAaN58+yO3Ea2wtGgWzgxbe4U20TIhvE5KGZVPAeOAani5Q1O7PegHb4eq4pWf7/SNdE
	I7NtYyz36LcsCCGkTwZGtfx9j+6g1+VT6aUkh0zM0AY0QBa0oxQGuBgIYAZiHL/wo5I1me
	yuh8H8ESEMUjGgnCE9+AIpsijS708Ck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759071087; a=rsa-sha256;
	cv=none;
	b=cvYY+sUq7ULvmFjVMTUylLqABJK6duSE30dxP+LFrtkyre81By+Hwf3Fbc7/AjNGcZfqHE
	RlKuuY5353RHhU8k+M49PnBFKMwW5M6ryR4STI9PVU6nRYvGLmYpDyqy4ko+HEktdCreIa
	6gTyFMaS5SwQAtNCKdQ/sTuWoN5j6JQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLB5tQ50;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00D0E6217F;
	Sun, 28 Sep 2025 14:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23892C4CEF0;
	Sun, 28 Sep 2025 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071086;
	bh=DKvwpCnqloOQP4gNjx4LpWv4LaALSpED/WAUwRqb9RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLB5tQ504wyZ06bziwpYmGZs7d/65HLAkuIuZ2w4wn63OQWzA8bn3uwK2vY1fgyI7
	 YteGOFAlizroxNAAuzQVXbCY9BcNIxlVfue87ttl/p7PYCe+EKehOJBOf/gVZL7//D
	 n0laClD+mHZgAZM/Osi+VvseOvikIkXb3YMq3iu8apoVM0OBIeMSkcTfGVuSjG+EE9
	 3kEM4QUMzbWESQaHowjOKmhur2RNOJQhGfp4qdw9S7QyYrhUnGD0GXrNplr9mN60YV
	 6Lr/kXRnTMWDPREa03fJk816RxmBwA7pvVuO5H7m9HKib+l/yxguspmf3YaWOSj33n
	 pNZ5pv/0Y7MIw==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 07/10] vfio/pci: Add dma-buf export config for MMIO regions
Date: Sun, 28 Sep 2025 17:50:17 +0300
Message-ID: <b1b44823f93fd9e7fa73dc165141d716cb74fa90.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 85C9B1C0004
X-Stat-Signature: z4dygcoyon9fspg378p4p3ujczdwxxkm
X-Rspam-User: 
X-HE-Tag: 1759071087-816870
X-HE-Meta: U2FsdGVkX1/yVIq0OFa2IKDNUXsGkSmxuajTN5nmlMY9e/d9GzliFIpbI/OW4A/fri/fdw1sfn9g08ZGoqavRQDBZk7Bb7JDy5zJbt5pPjGgtl1QGfAKDCaLyOggUq4+BCqfDQ2iyjcR5W6pvWV+bO3g6RXL3M6hW7nuH+FO7fvHQbxGjooZwdZ/jXriGBDFeIJCkyJ19sbSrboUv97BNflgI+s+aYPSMHGNXfZU+PGgXx2y+uz/VquNxIQAluHWMzu7SdOjnGCp1DuWynRcDsY9BQqK7O3TjIUqDhAJJSX7v3OYn3GpBFpXr4uWa7eyRMSZJGZ8ZKQHyrluSgtfpT/ZBFNWemv/4OA7fV/l5lXCDn+IRR6/GYPhd3Phju24Sr8Ye5NziED77T5aamvDFWe4IbPJ0mDrsi8UrpPfd+LVfZ3bOrSjTxaZQ9mKaacBYa+PhBAfLp55LrE9g5WhNo0LhrnC9n2eob4LJNIhURdHPWOrr3sL1XCW5x83TsNF4VmlSHiT229drZZ8A44H6yKCh8wTqhzyIbbPxpDoJHngsrdjVx4Y5P565m0kIh7kYJzY1f2WvxHX1PFTq0RVNsf1F66CrC8JVD2jNrbr1T83qqm+fKVmrx8eIpdvxIEFzcz3x3EGkvwk2b2rAmyHmziVyDahCAYu5g/udpWOY238BTB029TmpgBcvy/ik1J4WAalGY0xhulZe8SUtDN+q32kOOakm41YpfiGByXNnKhe/QZYg3FW9Ok8n0y/gUbGVYIiVv1ZnQSt+F3PmkNrMsZdiufQxBcWcdnF7LzP8WD8dHmJhWyWV8srcbYZ+dGzvoKKZN/zIo3Au47P1eBBhoTFKArc515IiNqhZpgTEOtYlRSBZMuRDkApwHHeXKuPby5/mMlr/D68o3ZvMyjTZcyCpjMI3EJ2Su0Gbg185tOf7h2f+/AOJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Add new kernel config which indicates support for dma-buf export
of MMIO regions, which implementation is provided in next patches.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/Kconfig | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 2b0172f54665..55ae888bf26a 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -55,6 +55,26 @@ config VFIO_PCI_ZDEV_KVM
 
 	  To enable s390x KVM vfio-pci extensions, say Y.
 
+config VFIO_PCI_DMABUF
+	bool "VFIO PCI extensions for DMA-BUF"
+	depends on VFIO_PCI_CORE
+	depends on PCI_P2PDMA && DMA_SHARED_BUFFER
+	default y
+	help
+	  Enable support for VFIO PCI extensions that allow exporting
+	  device MMIO regions as DMA-BUFs for peer devices to access via
+	  peer-to-peer (P2P) DMA.
+
+	  This feature enables a VFIO-managed PCI device to export a portion
+	  of its MMIO BAR as a DMA-BUF file descriptor, which can be passed
+	  to other userspace drivers or kernel subsystems capable of
+	  initiating DMA to that region.
+
+	  Say Y here if you want to enable VFIO DMABUF-based MMIO export
+	  support for peer-to-peer DMA use cases.
+
+	  If unsure, say N.
+
 source "drivers/vfio/pci/mlx5/Kconfig"
 
 source "drivers/vfio/pci/hisilicon/Kconfig"
-- 
2.51.0


