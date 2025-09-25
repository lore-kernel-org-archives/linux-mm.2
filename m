Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0111DCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BBA8E000E; Thu, 25 Sep 2025 09:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B998E0001; Thu, 25 Sep 2025 09:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414878E000E; Thu, 25 Sep 2025 09:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6388E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:18:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEFEF86308
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:54 +0000 (UTC)
X-FDA: 83927827788.23.88EEEE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 492661C0018
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nyyiardu;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umpxH1rA0uc6khk9bUJY6s1FqGMiyqxhFpcVft9gd4I=;
	b=F2CnIsJY9Xl8MBeBt+tTWFexCvhmaNPtQA1V+1BVht6wro09xc61jNPsmas7e3NEkuBUNe
	VCf0JnuOyjpVxHkgE+4KProBLB1m8arhVd4dSC4FH1iBTjqAPtFwK/4BHHdejljNVc8R38
	Nxg8LLGuP2q64FGVvsR50x3ucFGCh3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806333; a=rsa-sha256;
	cv=none;
	b=cv7ERj2uC+gclrm1mq1GYVGh54/YWPaSIF7yT2wiDXWCx5MqQ+/+7Py2elqKrJse6zLBxz
	TbbzIRqDIPdoxmlpQ0rt7DzWfebDG0lLesWXkYI6kg6JEQ8SUktQJTUx9BlYYUy086NUjm
	xQ3i/zNwf/xHvCQSWLlfT4sTxi0mJY4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nyyiardu;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B58F26058A;
	Thu, 25 Sep 2025 13:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDB3C4CEF7;
	Thu, 25 Sep 2025 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806332;
	bh=J3JcsAko8zSIGuiXV9DflNw5AuJmzcXfJS1bY+J5d1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nyyiardu2Jm2P99Ky9DPkc45OpBK6VXC2cDJ2ntyOymvqcGgd7qxrLq7aOKcpmvrB
	 5XtWc3qlZGvSsKGzKNx+xxbBh9eXebQcre8M4Bb/SEeFez1GqGCqP9IYRto9erX4mA
	 xMbo23J/F/gS9OYPIVigsvaRVXoubU6we02xEUbwHPq2xk6hXv4kjVijzWspwlc1DQ
	 i35RE92E6sbTQMb59F66xvBBp/vg5DYOswYfaxASsoGs62yrjSwe8ELTEJGw6PkZ4a
	 C+Bv9QieZeKuF7wRH7Mb2kELbArKXalgOTpImh/q8etNoCarPsndtLwMReFQauTWd0
	 bwvkCQ5iBtzuQ==
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
Subject: [PATCH v3 07/10] vfio/pci: Add dma-buf export config for MMIO regions
Date: Thu, 25 Sep 2025 16:14:35 +0300
Message-ID: <b3b718403b85e792ddc8a8a1c47ff214b416eb7b.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 492661C0018
X-Stat-Signature: he8prq11s43xhcjqigp56h4txyf8ku7d
X-Rspam-User: 
X-HE-Tag: 1758806333-852227
X-HE-Meta: U2FsdGVkX1/6N/l30BLQNurQI1nBnVmd1XFR74k20O2OS4DN5HF79w5BCEiGK14eGzwvhvidXJMcNuhnXw3XIxaMsJmB+p3vDuVhXQGNgAwgBhcoztJwaB8yBtS+OvYx81T1Qez/2r5CbGwtvTHBTyC9XvXd/QOJWSql2E9GCvx8TW/I2LIAUqOXvESdpP264a8ICiAhqeybIbNcNeufLL3e20i6TGJozf0JpirckTu2EnWkCiVgMl3SCSmOERn+DBXw+DhOycjE/CUg/46Sglhy2QT1ODGS/Ck8GrGl4H902JSmyHqG2n8XFFpDqHmzgNdNJBxeikzhbp3ZWzGFd9mDv2lg0gCKN0J3g5oqHdFqhSJj0+wz2KvjO1Oj8VMh1CGc+Z1vyqYm/D+avmWoYdNthZ6nYFbKZewpiOPIG/TUcCQd3wcOYzRiVd/mfZ0wpXp6CmJ/XMw3KOCUmOhwy+S0jfs92yOWxHebBPQZuaS607r09fYE6QcFx/Kgf2O68ThgqjgHGH1CXnYK/fCnu3ffHj6BGbTH7xP2vRAfogG5IpjTFiije7IbhXIzFNA5RYAm2QnKXh1NZ6Rvt0yGe/7Lnd6VIQLtbPJ9VgCCKwvYDzyzC+pM9dOsOUaSFtixQ0U+WqhKqB3Kmk2vaKUKeKnSLSmwyU0tSBOoPxlYWXAkNK/a7BZahBJ/0UpsjkyU2M2J5fGChh3EYkxX50wtIDVjGpG+ON9mw3itU9Zt35e2KFA4MwGx+SPg6cZbP/cHj5zBWNZtOLfF9gPLEwdCK0POzETRqGEaBS7aaSg97sZIdCCxUQzK0UTH0U6bXrpO53tB+J4I++mqbnivqzB9IhybCphV6mY6ceU58P4gzIuZJ4dzPFRvD4LN+qGkL/AgbNb/8WnyOYDxU71UWEfm6GUd8A46KatA6kclxR+3U/qyTKsvOLuXxjbbmoLXQja9W+zahTxfwRH8rOIWdTG
 Jrcaqhkp
 82utsVmnY0utZcmc8zN03E/SGXr94gz9GboAOfKo3kHqlc36zXwMD0+P6aXsmWjBluwEGdKzdAv0JOommCU4drEhM9A3yUAkoeD6n/AUG14GIePwtAvZSobHiMVTp0F6JbFEaH6KLI2CwiF1+4CMwM9BYeTa57jtaMosTV6xJprBEWqSbNaT+Kt1jso1zpZThHgO9m7l9kkNsiAEJ7WGiwQlhdfZz7H7Otdd2HsirIrOx6zs=
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


