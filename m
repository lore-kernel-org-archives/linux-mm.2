Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E0ACAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ADE9900004; Thu, 11 Sep 2025 07:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E2A8E0001; Thu, 11 Sep 2025 07:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32657900004; Thu, 11 Sep 2025 07:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 207C68E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:34:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E41BE1A0487
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:11 +0000 (UTC)
X-FDA: 83876760702.22.D585A14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3D961100005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RZe3Hghg;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757590450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umpxH1rA0uc6khk9bUJY6s1FqGMiyqxhFpcVft9gd4I=;
	b=av92o+qnNA6AsR2WLpV3LZcHrOILOaFigha9LA544WHgDRJTtsMf2cLErOUjUfccbzaWso
	LL4odMU48JVFbRftGVs05TBZ9xED/4ViRB8kyym4QARStpq4jQXN8xVvnkvRQp7kHFIHNZ
	gTebVGHIYpyIQoix80ZktHtI/l5MdKU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RZe3Hghg;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757590450; a=rsa-sha256;
	cv=none;
	b=ywGRS2969FSfVzJlfDn5wVmRGi5ssHc4B/WSBpRCTmzy0lnYcDu+XT3Mikhg5IL65N63Az
	6kFLBG/o4rsQbljw7H5Ekiei+BNrdwrTDxEPnD2mhfPe9PxIuf+q83WrTbTbOYP+wZjCzV
	OortYcaAIYsMzEL1WfnqcCOyOtXBovQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CD6E44EA9;
	Thu, 11 Sep 2025 11:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D78C4CEF1;
	Thu, 11 Sep 2025 11:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590449;
	bh=J3JcsAko8zSIGuiXV9DflNw5AuJmzcXfJS1bY+J5d1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZe3Hghg8tuilG38NUupXeM//AvgeiRR0kwGj/2e8WXc5R8k2LXEtxylcKu0V7VR4
	 1FL71pt5mLy3q7tg9mEDnGu1K88Gjtgeu2UYS8C2bKbKCCRRb9g+8K76CZAztiQE4R
	 zdqO+vDPlmfczjhKjstsRUe+TJcL8TsKnPJphvQgKiSQraI79PT0SA713CHwIloZ1b
	 QjKoUmsx9DTS6kou4xIZNyzUdbLcMrmVlBlLOlxFHYRxg+hUASmotNa3o3ZOLnAna3
	 tmduKfLeIIC88uvLVpyqh0eIdL4F2g8wYiqMwsjlbdIeqNN/nVtXrzcn3ko/5wuWDV
	 Cj92uwQIUWB2g==
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
Subject: [PATCH v2 07/10] vfio/pci: Add dma-buf export config for MMIO regions
Date: Thu, 11 Sep 2025 14:33:11 +0300
Message-ID: <e15b8a93822a69041e616edbea16e22644023be9.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D961100005
X-Stat-Signature: 7ucepcj1a8ag56de9dmn71nzcerisatq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757590450-140739
X-HE-Meta: U2FsdGVkX1+2jx0oQY8+3aQB2pbwd0iCO4QDdwFMN1OjLHuoVy+m0/LypjjrcPgealNC4lr8zgo4OzvAVCA380I2yWnv9++HdG5umHK2aqyzq6lqe002NC2DJQ6Gj7fiD8xUQoEs76RVDCX7z7HeuPrq3+1jhzDr2XrLGiU6Q0GAQnSnXXM5Aj1eGLLhStgfIOp+6oSvoNPJ8DWXtAQmexNZ54NwgbSs+ZvLyuvmbn7EN6nXXs65QJn5is3CRaQRjFOvVR3LOSI4+/k+pPVKKYrr6qzvwVdUzlSNUc+znul9fK198fQUa6A3qINgWdFKdHSA0A8YrcuRoYDKjksyKyG+fUleMVs5P1xCKvSKWEkF82lwUtSDbghkbxCLe5TN+O2ReYkzNkMnA21hGMfm9izC8qXu9IeuUiIMB7CiEXeJX8Rb38CsFd3mrOOROIPfCCbu/NKhpK/c42rGgMnmkmT3UaWGAKX76KNpMf4hAtS02GQl2IX7zXYNDTwWEg3TQUMY0H+lD/yITUQK7DGYgYE4/aNibz2ZDGdr3kRBz1VtwawoRQt389yRz3/ixIX1pDHDY9JVjdEbEf0LiZ1bULDQgC8gg3fyIqiABuP2x3lrodFLzzK4rD2FKbzCcWq+/WAJh0GCS1XrDjkcHIovnywAxrEx02FWIdjVtmexXTLDjXBDW54/93Qg6ceY5Uu4w+8Wso1dqp0HDv3Z7WOplPATzETMVRrWUxAjMGrAFlIHiXzE/Cv+/fpe9ecEO0c1JMhAhF8jIycNMIyD30b+9n+Ev9UGuXSbyKw8TmIl0u6XCD0/27MWUfOdwG5B9+kgja3dnyROgdwtbMV1rWDWG4kF9nTxuSOCG8CQJapmVrR8keWyq1Fh3trv6fBB+KjWUBcVAns1Pnh4az75eBvM3/bMno+kVpPkVRwKoziF4IZPUFM9+9K1jTWTdVdGyoRGsmjFWD3KhIAiob17tNS
 ZlhvBSex
 RdhnUjl45GF180Q2IEkGfxlkImLFCXuANb9Zw6IfadtHeF0m1k2Xo/4plWi6clWNDmSbfxYss/6j/L4VPKTi9U75h0M2xAYx228TWTj0NT/rK5pPo8GQ3FY6CZZwxxMW63i+2vkLgkOd8y1BGXpsO5KSPVTgt94Fp896HQbbQKNpFp/9pNfqGIVZm0FUwrKfThUKyEI8Wkt4CtHb0c4aEIs1ub5xwDzrACVoeQoQ7S9s+ki8=
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
index 2b0172f546652..55ae888bf26ae 100644
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


