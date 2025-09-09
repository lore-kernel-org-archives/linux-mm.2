Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68477CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B4E8E001E; Tue,  9 Sep 2025 09:29:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C134C8E000F; Tue,  9 Sep 2025 09:29:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB858E001E; Tue,  9 Sep 2025 09:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AF3A8E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:29:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47A66160522
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:29:20 +0000 (UTC)
X-FDA: 83869793280.23.56F13D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A4FEA40005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:29:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RO8Swnvn;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jO1Pi8Tcbmgxlie5tqgLJ/N340a3rHV4szArIgb964=;
	b=rKujNyCt55zGDb4vhcHXJW51ilI1VZVtVHAcQ9ELDsJEIS5xjW6lWA0RrYRS45InvvxHcE
	DehansrpJH3NVA5rsXoIyTHtn+4WMGl+bTMvTb4ZaNptDny1otpH/MX9xIelAFIVSWEjlV
	eaU4JxdNAAoW1rOa3wNhYsyTEa2yRs0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RO8Swnvn;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424558; a=rsa-sha256;
	cv=none;
	b=yaKyMTEvCSkobYUNN+KI94zx1N070v3PftnGCDfO5GJ2WXZfdaut4y+7oSESUjTla7RQ1n
	roJy40XoG0AjJUrX5Lu5GJRxm38+pe8+pj7GZXQmbpHP9whxdi2wzSSEFaXwTDez9yd9nx
	SvA3nR9Wj3cNjipW0x8bb0dv7BfjTHY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C05D3419CF;
	Tue,  9 Sep 2025 13:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F67C4CEF5;
	Tue,  9 Sep 2025 13:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424557;
	bh=wtwQANAMZgZyvB6tiFp96jG3UeEes+qCqSz/NoS3UPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RO8SwnvnOfqCFFo/OQtuk43y08F/9NiC0qo46QlPcxTa4eGVUHYLlbxNnl6dZ85H0
	 x20F6dmOkEPcmpHsf5R+/6fXBIjXKuBiWRMkaWwUQubRdIinqe54Txa6tN8WlX2eCE
	 TjNCykXDXDAKP22rhADMYKKG4IeQ/xdqjUNB9nFAhHvWm8XVmqmTnjP+KsZMgXmxER
	 U9ohR1NuEHfgYDgyAZHMIK03b2sbV6Yt6fuGDW5ZtsOhCz1qoFNEVy4A6MCZp4MaVA
	 K+CH97tUymCL5/6yV3iWa8ebvxIWwf3QpaIqoywL+4IYTWGZmoJfNhPPhhg16fdKRx
	 XixjO6eOuMVKQ==
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
	David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v6 12/16] mm/hmm: migrate to physical address-based DMA mapping API
Date: Tue,  9 Sep 2025 16:27:40 +0300
Message-ID: <d45207f195b8f77d23cc2d571c83197328a86b04.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A4FEA40005
X-Stat-Signature: 5uyhjrkonzshoot8nq9hfpkt4rz897uj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757424558-863488
X-HE-Meta: U2FsdGVkX19Gi6v3ZuQoPYgTIe5I4pGrtuBxim6wpD9u5Z2TJd1hSNlwK4px80D0iMCx57PDBkyoJT+iDQRbS8VOsZMTl9qACfaxqfDw96rOyt+kQQGgFMzx1qVHMT0LbNqgoXkerprKVty9CSkc2ARZAkcRNmbtgJE46WNT34XFkHuCch6cXCXmMm4R5rcZLjRq5vUdUVrdpj0k1kQp8Xa9LE+loXAa0+KiC/TYV+1Q51HmVPzWw5KCK5c3ait5o0l51Y0qtlRtH3umpGOi8bynub7otPrMeCY1saJMtSoAbBSbsDGShQkDsDhEHlzCBFz/eqjM7e9sZfed09phtR8xT9XL5Vgk0jXitxOqVmjiKMELcubwuS3AHrjmp6vIEkipxps2Blavcah6JjdF56UdlMKGWkyn0jkoFhXz8P5izR1mfcHhN6KF/pGWHCkxOTGaSJ1mH1d/B6TRUj9CHV2BjpsLbUd6yQOyLF5GzO2zs4yCKBZXKKF8sHCs/oXRuiTpmHEcmEAsSD2bJeh3ipBE9IZqkQ+KUiA+fv0JdvAN0rYp6BMCZOkjP9uSDeodHnNhCgPUp2XWC4l4DVtrp9OQyXe7vwDXX+1L5jWnFUL3UrurwXRBMBXCpq1okmPzNHcvogaXAT8DW0u7o3YV1p+e/fozHw5xmCSRxKc6htY40vpcmgHG8AuY1oH5mPRMaeLwNb0T+E+RKI6naJMzv7dnmG7C6mycFX9AIErng6kp19DJprNrGmfZWH18+3tbnBrjXoLY2OFaviWrnDUGrM9tNxFfU0B/9r91vpvzRFLMIow6EN+1Q6e9uEJUawqENjLtrbiBL9+zZ1PEOVLrbP0g995QJNpGlhsjMhasNmlPsSqTMNm5CF6fArN+jOCwuzlnh4RzAD4GUpEFEaQ5DYjh9WcBlOLs/E6timbgGYQMotfwWeC99VDwfE6l1MckSzEXa5s06bhRU+W2Usm
 Xfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Convert HMM DMA operations from the legacy page-based API to the new
physical address-based dma_map_phys() and dma_unmap_phys() functions.
This demonstrates the preferred approach for new code that should use
physical addresses directly rather than page+offset parameters.

The change replaces dma_map_page() and dma_unmap_page() calls with
dma_map_phys() and dma_unmap_phys() respectively, using the physical
address that was already available in the code. This eliminates the
redundant page-to-physical address conversion and aligns with the
DMA subsystem's move toward physical address-centric interfaces.

This serves as an example of how new code should be written to leverage
the more efficient physical address API, which provides cleaner interfaces
for drivers that already have access to physical addresses.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 mm/hmm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index d545e24949949..015ab243f0813 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -775,8 +775,8 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
 		if (WARN_ON_ONCE(dma_need_unmap(dev) && !dma_addrs))
 			goto error;
 
-		dma_addr = dma_map_page(dev, page, 0, map->dma_entry_size,
-					DMA_BIDIRECTIONAL);
+		dma_addr = dma_map_phys(dev, paddr, map->dma_entry_size,
+					DMA_BIDIRECTIONAL, 0);
 		if (dma_mapping_error(dev, dma_addr))
 			goto error;
 
@@ -819,8 +819,8 @@ bool hmm_dma_unmap_pfn(struct device *dev, struct hmm_dma_map *map, size_t idx)
 		dma_iova_unlink(dev, state, idx * map->dma_entry_size,
 				map->dma_entry_size, DMA_BIDIRECTIONAL, attrs);
 	} else if (dma_need_unmap(dev))
-		dma_unmap_page(dev, dma_addrs[idx], map->dma_entry_size,
-			       DMA_BIDIRECTIONAL);
+		dma_unmap_phys(dev, dma_addrs[idx], map->dma_entry_size,
+			       DMA_BIDIRECTIONAL, 0);
 
 	pfns[idx] &=
 		~(HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA | HMM_PFN_P2PDMA_BUS);
-- 
2.51.0


