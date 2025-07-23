Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4490CC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6976B009D; Wed, 23 Jul 2025 09:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E596B009E; Wed, 23 Jul 2025 09:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB4C6B009F; Wed, 23 Jul 2025 09:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF9A06B009D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:02:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7640A1338B9
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:27 +0000 (UTC)
X-FDA: 83695543134.01.525C304
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf20.hostedemail.com (Postfix) with ESMTP id C964E1C0020
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=to57+Gtb;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753275745; a=rsa-sha256;
	cv=none;
	b=US0CFE09Qcus0/o4APkSRdZl6dG0H4Xb6RhdMauOxkk1nPVbECj6HAI2KRXnP5HLPBqL3U
	vzz/LTtrUX0O3zJsQb2C6L2Gv7/ZuV3SLGEeiCJKKoqu9BciqPN75v6gPv9xQNYTH+/ZPN
	Kxh3oRxEUVjnWYYfiQc2SSWnBcC6OlI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=to57+Gtb;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753275745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MijpNAvWsHFLvpEkXohMjeQWJQUa1JqvjfkFaT/AOM=;
	b=Z575sokJwEMNKyoFfUJf/mOOtSDpI30DliMktzqbGqojadCFKrBFxojY57GhvYFE1oZQO9
	qRlGJaDMVu0bTRfAGRz0Qxv1/4VlQFHwP3aPnphErK9yb+PXR6HLiOzsxvlOaCwBtvTjcR
	uHas+yq9TgqHTvMPxdHyesjjAEzZvUY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 0D33B5C5F7A;
	Wed, 23 Jul 2025 13:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC426C4CEE7;
	Wed, 23 Jul 2025 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275744;
	bh=6nRA10ywpK7SSRO/jFMyVT/cEz8hEByS2jaY5xZiXc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=to57+Gtb/kqx61u9wLvouYUY2r3rfu/wxYrNo5FftZKZzUMaadwbeJO7Fvzil43/3
	 AWa8IK+h1CT0qK5BjiHdWXKAbRXPY8yBWh2yelV64TCR8e7XICKlREhYh5x5HhCzTD
	 yv7uitdjloEM0UjQRFtyMTUY2BnLpDGa+mOPdgvSC8gki/HU0WdgMJN+OjLqJWiNa1
	 dfLitFrC/BRt3xcJ+C0G7LPmMwJbLTQUGj/ysphAitQuFV/pKbp8GK9fi3A47SLxl6
	 perEVWMTCR66ZhAhr2ZD35eqO0aHF3fNBcZl74gC3Yw/qyyElwragyVKfbzDkkcr6N
	 yZWP5Z2A8oaMQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
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
Subject: [PATCH 08/10] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Wed, 23 Jul 2025 16:00:09 +0300
Message-ID: <a55d0868fbf7e9000ed46c6d45928e5b9a5cae1f.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C964E1C0020
X-Stat-Signature: cuwg3yhoks59uq75cgckjisjbh8xu46q
X-HE-Tag: 1753275745-576978
X-HE-Meta: U2FsdGVkX1/qXH/HKWxDmoiq4/a9IHf26i6j0P9qNBpa/iC8yoT5qNSC8wVZ/bCjjw2saMTdEJ+uBn4MVFDTqxs+R4wQ0IG9SDp7OHjgWVUwW8aHR7PQHb1EG+Z5culOZWDOSRT2rrLf6bXtwWn0EzGxEz/XFr//BbU2RhJRlQNIxdfgFBXdVxEKabBt1frVnwZqtcli+AaOAtuvuv5jEtXVtel7TGMgch1PXXwDZSwVSP8uWiirsjy44/YMLxTAFRkc1uJuMlNrAlilK13zCzUKm9OGGf1pMQPE3s8yFoZw8pPi1FIqTVDFf/9xx2oOZPzAcJWMALTWHTRlYfX/DxlPxShPnve8nuQsZHpjJH1b3iwsWxOY2xSwGgZw73nlDMVjwTzsnYoAvoJwsHdGNqevSI6yoV3k1ntcsXiwN2oVmfO8CccNcsJuoMzoc8htwlC2EOjXR3/H4xcOZnL4cIr8LXyGjI7FR9SliMwKb2XFGIx5WqMvGy4cnJoB+A3IAmoVWzYW1MuKSu9auS95Y0Ape4Pfrf8FsOQiJqYyo4RBhN7mEgMYeGsBk5ZyL3bYrhM+Hbg0+fFjv+Kt1HgRRkmqXcwS6UBEeNRRqF9DmhwhqJdRAJ4NSpQvIBxYYVsiqEJxJvU1QcHNiG8TaXtGMCnGPVDEthMyVaIPPLAocOgi3UcdMLRxU0zao/C51bghH7fizz6Nb4EfsLnE44bxv1PuCGzj7QETgJo2O+J8alDCtFe7uND2EG/7xCEXF3eNYKjENaMhLenQIkumOOc7bxGEHoyXS4lLEDrhDi7TmBzuLMzLWv9nuEQQ4FLILSUcDuPsvnDpWyCP+L6ONSDt+Z9mNMVBWgCQT3TbJtIuM8TChqBqrhOb4sz3yJ/VVHYFpDgb8k0syaQSUv416y3wdvyM+sgFhV8PaT0FrOIWAURnVOxCALQcoKy7YZA0k7gJwAcYJ/MVXOu3ZcfwWss
 A9mq5u6d
 Y2m2gryYGvm1ujG6ozh95hUCJagSDCpvGbvVEXkEwhbpE6o75Ft6xfBvRvrFL2iE7Re+WE1XHfjvhGEUJ1AROUb8O5pMzoAyejEmr2JGM7my5+Nt5TvrV0mpujjGjR9lrlrkvT19xypJSNiIvbecki22qABjSy9mNjN8PL7VZEcH0s+siEtwE+bXHCInCoqk1LNQECUoRNjp9buBjnpUFsqqhd2O8znuEw8MOto8/flD383aFP7bnUIshDWWRowyMKTwCcet/HKfSvKg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Make sure that all VFIO PCI devices have peer-to-peer capabilities
enables, so we would be able to export their MMIO memory through DMABUF,

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 4 ++++
 include/linux/vfio_pci_core.h    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6328c3a05bcdd..1e675daab5753 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -29,6 +29,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#include <linux/pci-p2pdma.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -2091,6 +2092,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+	vdev->provider = pci_p2pdma_enable(vdev->pdev);
+	if (IS_ERR(vdev->provider))
+		return PTR_ERR(vdev->provider);
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index fbb472dd99b36..b017fae251811 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -94,6 +94,7 @@ struct vfio_pci_core_device {
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
+	struct p2pdma_provider  *provider;
 };
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.50.1


