Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEAFCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0378E0030; Tue, 19 Aug 2025 13:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26E328E0005; Tue, 19 Aug 2025 13:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DCE8E0030; Tue, 19 Aug 2025 13:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F28358E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:37:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6C17B69D2
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:37:55 +0000 (UTC)
X-FDA: 83794214910.05.1EC6891
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 18E7516000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:37:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KCfTK4M1;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qkotKjA29uhp00A8rkqHQXkiTzDF9Aqh1SY8eRdGdo=;
	b=TFqLRlpgHuzPaykSok5h8BqFbO9irlEg3kQUBaqTJm5peP09ALE4yVvR3Tu856jmzEHSPl
	pPr+j77maTkMNPNznoq8p7uZmzQeuJASA9WVauCE77xD1GigCRWZIYzIRvSKX7TkFhTi4e
	iD8holLcc6lxbd3+wq48wI/u8Gm2a3E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KCfTK4M1;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625074; a=rsa-sha256;
	cv=none;
	b=SFU8OhGZ02twh0wCjslBU2X4nqJgKAti3PxNzNoysnmLHETUriSMnIgfXffaiMq+udHF/6
	4at/Fc+904e66Sp5+I31Y8S0RYpkywsR0Pskgz7rRfgI4RRmOZwkO4xVVFMlJNG2JnyPpD
	Tx+TnYKLTZravbR+6gbarnQfgUApkrY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D1F260209;
	Tue, 19 Aug 2025 17:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E9AC4CEF4;
	Tue, 19 Aug 2025 17:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625073;
	bh=dJuAJRFwFKXIJkybNGJNx5df3xqMYXp7O5ndEMDZg04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCfTK4M16fZcS3idu4B2UtcPGBxqBCQW/ThUlPcSPjuZpk9imzaVn20BMZHpPLbyc
	 3sv0wYVSp65eod2nGPwJoVRbqWUP8iwVx1qGbM406J7EQpm2oXaICC90d6Ro5TVuLo
	 TYKUR+gfoaSSqlCAv5Zfuuwbhw+6pj13nHVJkk9nSAsT5zgqNZmrwO925lW0owpuEU
	 q+J3Pg0hHwFJc1ESksWCrS/+yq6AvaPGtnZ/mQ6gvtWd96ELDPoDM/2hRZRbzxrJGH
	 3nVNacD9SmUqnDN3yL+Ud7ESjKc3S/vPtHWyLZM7vnsGB7Xxfh7jUyQGNO7ifQQ+BT
	 knehqEHs781Uw==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v4 06/16] iommu/dma: extend iommu_dma_*map_phys API to handle MMIO memory
Date: Tue, 19 Aug 2025 20:36:50 +0300
Message-ID: <4f84639baf6d5d0e107fd2001dff91b6538ff9ae.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a7n39u5wmya7q1swkxoyoyqxgmu9gaoj
X-Rspam-User: 
X-Rspamd-Queue-Id: 18E7516000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1755625073-323824
X-HE-Meta: U2FsdGVkX1/9/+nMrdqRwme7Xwd5VyAF2JDWnH31AUpU0jbzW6DtGN21L6j4w44r2FHz9HdOAwmuoMOgm0bh34tcfqnyp1nORxA3sSg/HU2v9mEUsOGA778QgV1B7dUM1QJyTcPk0ACwUO6YvliAuDN7rtSVfwCkDzXeFp8iYmPfdQ+Ci/fZqMBasgOUNS2MBYeUfevITCYcC1rRPmnNuY6F6o7pcfpzMtvMNDbyP1vljyOq2ji0Xc77sLyEOb5qwLfgvZargq2kas2dkpvPYQIZ8Xj3KSd9G4lwXyVAEQmBRWQDo0ocGCDSr2ygrcRtDGvOzYx8f6KUY9Ctds/+knecWBBOF/MzMHplpju4fBL39wOyNeH1sFxlN6oQ+zXWfsD9hIPYquYAcMw1CDKR9Yui5VRCr9FQojedUyKaUKDNs++c3Y6DuJwF+Y/5KWpko36P9HaIEx9XLAS8yIn89LvsoXlP5ubRjikWxuSYNZE2wcxyujV7DGt01+Tv/Cq8iQOkucB7SAlp0MufdRbTIkUholBwe6NMK/qfh6Qf+TPtouo313dD85vPkEjvP019E1npEjTPUqlUkWSTHr2wASoyCLfFQkZC7oQR51i5Usid+eJ723OGIIbK6EhzpMIU8aSDDu6q43YtjPhG+DKjIhp7jTrgTADXWIGLood3cHLXeFvaVLGzOCudFTz7E8SqDLpVu6UCW03DhC5Zu5XscT+GQIbAKoIzck0ilQQIym3sNs07UR34fUvULlat7qTMr1h0fYDjjS26gLf4qu8ClAFsaSOdi32G3xi/b5EsXXB1U+fzH0tX42Togd9ZgWrPJPnnB901AD9gsguaEAGgXUmFTiBUNDeTrTkdwWP1pifYRuV0YPPPH2KpwbLRTPOYSZC1swXFjqZ6D1B6DrQXU3aLOsvOSuVQpddaARZ16f1Cy3970jmnp0FQ0/jox7Rb93A8k3F3TvftrN9f4AC
 PLaZ4oui
 yocRNOwJLXD8dW8GL+SWYjPnz3+sF5KggAK7ozD7fMx7iPRLuQ700DqL9eZxJjiKVVMT4GAYag0+WfUDmHe1kOZ6jFELlvU1kWgajF+pcJyu0cEGtEGAhRJybEtTqz/xMFquueR2+ZrHC/T/+ypwAI10HmcFL7YJ5fUL1VxrOAqQFJNjWS/VObMD/JzD0qRL1gitNfCsAKKNAqxfxNJHjpJZyZgNMHr1OtGxRXfGPH/ZKY5hlCEK2yhZBEESGZE2bUs8Sd53SftRLqZHksw1Eojes0QwsX0LUNkc0JX0U3Wn2ZyN1ypjBrAQHYl2uHAU99A/+kwfgsyt11jnbxuc5owRBRCDH7EPYIDTf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Combine iommu_dma_*map_phys with iommu_dma_*map_resource interfaces in
order to allow single phys_addr_t flow.

In the following patches, the iommu_dma_map_resource() will be removed
in favour of iommu_dma_map_phys(..., attrs | DMA_ATTR_MMIO) flow.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index aea119f32f96..6804aaf034a1 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1211,16 +1211,19 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 	 */
 	if (dev_use_swiotlb(dev, size, dir) &&
 	    iova_unaligned(iovad, phys, size)) {
+		if (attrs & DMA_ATTR_MMIO)
+			return DMA_MAPPING_ERROR;
+
 		phys = iommu_dma_map_swiotlb(dev, phys, size, dir, attrs);
 		if (phys == (phys_addr_t)DMA_MAPPING_ERROR)
 			return DMA_MAPPING_ERROR;
 	}
 
-	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+	if (!coherent && !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
 		arch_sync_dma_for_device(phys, size, dir);
 
 	iova = __iommu_dma_map(dev, phys, size, prot, dma_mask);
-	if (iova == DMA_MAPPING_ERROR)
+	if (iova == DMA_MAPPING_ERROR && !(attrs & DMA_ATTR_MMIO))
 		swiotlb_tbl_unmap_single(dev, phys, size, dir, attrs);
 	return iova;
 }
@@ -1228,10 +1231,14 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	struct iommu_domain *domain = iommu_get_dma_domain(dev);
 	phys_addr_t phys;
 
-	phys = iommu_iova_to_phys(domain, dma_handle);
+	if (attrs & DMA_ATTR_MMIO) {
+		__iommu_dma_unmap(dev, dma_handle, size);
+		return;
+	}
+
+	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
 	if (WARN_ON(!phys))
 		return;
 
-- 
2.50.1


