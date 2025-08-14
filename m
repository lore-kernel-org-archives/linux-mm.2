Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FBACA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C46900137; Thu, 14 Aug 2025 06:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2CF6900121; Thu, 14 Aug 2025 06:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F58F900137; Thu, 14 Aug 2025 06:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79115900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DB221384C6
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:48 +0000 (UTC)
X-FDA: 83774954256.15.9371EDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A3CBA100006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GOIGZTAL;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4SM6zHJ9Q6ObBfi9kz8op3wvjKvHEZA6J8C6N7vBkM=;
	b=5Dr0xQIkwcgv6/UKT0j54/xuduOdw7DfHThEWEcSMPzb5JB0rc1hNt2MGdBm/mx5yXvRDu
	GOtJmWG0RDI9NXeoQjwJDPaboBS8RLdvQBJrq/Vg2mbzklyFPY581fzqW9jSa71dxLuNYD
	LHpNEfef4eMNONcpTpyLCZZLfTmlWZE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GOIGZTAL;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166485; a=rsa-sha256;
	cv=none;
	b=3E0GuyGANAssJa+p+5Ob/x9ddNnWRsZCdcOX8yam4tePQaQq1paGHZWhGnIw3A+EXvBkoQ
	9mcPkYaE6/VkmImDadTwUUicChpGGfXyeGLmKC+sXn+8b0fXyR///bDD8UAmozKxgvrVc0
	cajvVoS7PNKE7kDw30HnCYDqLCJRE28=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B7C19435C3;
	Thu, 14 Aug 2025 10:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2CAC4CEED;
	Thu, 14 Aug 2025 10:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166484;
	bh=5GnXky7X8jRP4E4M761xyU7kxSqR5w3y9HvcAnisW/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOIGZTALgEXO1yJmRnIppoU7sVnE9nGcbMZQVycIMrFkUkEsvGws6NRdpGbZwCPTD
	 EH5S4PsSjJiEFaVyEY/9QvsuOFrfrIM2jr1fwUPJMIPtWlonZgQ18Xyj8zfPOT0GQO
	 B+9AQ0omHzJngdLANyllOrFgvdhVO4L1z8Dmj1SkfIiVF4KS7xlgY6Wgp9XvUszA1i
	 GznzVHXHeBog8qvfnoLOoVf4oOMHY3auY/kzpXBELjlpw7gyiSs+6eMYW3loBSbwpm
	 bYNaIlcJU9Cdf+jNl6zgiiNsou0al6+23/rIuESPqXov8EgRibqQkm0IVOUThOkMc5
	 RHJ2gapPlrz5A==
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
Subject: [PATCH v2 13/16] mm/hmm: properly take MMIO path
Date: Thu, 14 Aug 2025 13:13:31 +0300
Message-ID: <1c5a07cc7b40e956b2d75328fc95e45e82d2da5d.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3CBA100006
X-Rspam-User: 
X-Stat-Signature: bj397b5kbik8nq85zni5q7meaaduzqao
X-Rspamd-Server: rspam09
X-HE-Tag: 1755166485-950198
X-HE-Meta: U2FsdGVkX19NhPEgCzRaWaSft5zz5mTion3lVSLxDffgMI5IPIuqsByZYMp8J3KLgT3d0hk1SPge4tCCdmN2AEogauohlY9/kkVY9UJnz/sCkYl0rMHmBCbU/fl7DmYi9MR0XyPMOLHQNX/lF6lS7eWBOLoz1E7KWaJqpJmkHpnC7JdazCs4rc3rNNjzCG7d2j7z5b0Hfm7PybxajKNpZZ7ySw8fnMTpssrTKAmt5Ys+71Jsj5+//U7lhPFj+KIVpAlfvcqoTWU/NRPd40wK1xb7i7RpwXREGVq4WOY55q6EzfEKGkD/BAkP21IpVi2JVJpBvXa5uA9CyT+sVcz6/tlXNvdiHt6ZEUyXGLOPFvO0ceF1w1Wb2OL0RaUEQLtaYBK4tSKT/1wJYQ3CthjMnahcsl3cSVT4UNyEfoIYa0nWtW+0eN+IRVB3k88f7tdVjCvd9lt4lwvE8OvZfmYxUt/Xw1YBgmRhqn/kAkXB7PN0CBMN0BeQPhVS5SfOweqrMi73gXMit7ne97sRkSniKzAvzMBhlxptpZ57iFeusY66sHY9ym2yJPbXyx4sr6BvqOneoBihFEIu6UOXusOnnhjXvx0oSWCsuusnhidZ4W/Sm2JJS6mOiR1rti6HceWtsbRiO4Q5RXucJXqqroWNGMa86BqkugVtM/eE8iuYI92OU4TsI4GMlMh7KDlRUmUx5FrVhRWwU8EZhbItcpB4cB7rZQFq+/VYzi+ObqdwRy8KraYpvHUdThuUns54kqaJ5fCUErJ2hU6wZiblkYpZu6HtAizz/WzK/avtAw0+h/0uYtxDAe69FPDLxsMhvzsq41Cl4u1apXoq5KFhh9oi/GXhtGw0QfW2p5SXXQTBUtnxjAsdFWmTzesPBtnpFIPfi/WUzApmZ/0iwVN62LJoXhN+UBOq43qWOWCCZOOln+HTa/l6wUvNOY7+EXaRfOTWe36/oCFFcFwUZP9PbOT
 d3NkhCTq
 sGamDw9oHzaivykXA/WMUWo34CEQhO9EtfylFAkgYWqQScCfGCPV5pSVFkxPmzE/A8PnXesApkzdSwmUSFUcYl3A1b93MJCePtgqC+ocPQhPEAQRFyBhhLO9PzCJJOFe9tmWxJiJcPMTTy4g/C7rXN/+W3Dcu8iH2AZYKU71IPmap4gTmrTo+mt+OTmjlQSUKgFoAMlZLnqRhotsSN3DZu8F0NBhpV/BZ3KCiRTq+Kr0Ucw91AVa6/xxNR0VM84ce9KIm4My5K+7nGeQEHGF60KumVjuU/b2vN0SBhghaZ8EUx42iSz4H5zp4Aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

In case peer-to-peer transaction traverses through host bridge,
the IOMMU needs to have IOMMU_MMIO flag, together with skip of
CPU sync.

The latter was handled by provided DMA_ATTR_SKIP_CPU_SYNC flag,
but IOMMU flag was missed, due to assumption that such memory
can be treated as regular one.

Reuse newly introduced DMA attribute to properly take MMIO path.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 mm/hmm.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 015ab243f081..6556c0e074ba 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -746,7 +746,7 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
 	case PCI_P2PDMA_MAP_NONE:
 		break;
 	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
-		attrs |= DMA_ATTR_SKIP_CPU_SYNC;
+		attrs |= DMA_ATTR_MMIO;
 		pfns[idx] |= HMM_PFN_P2PDMA;
 		break;
 	case PCI_P2PDMA_MAP_BUS_ADDR:
@@ -776,7 +776,7 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
 			goto error;
 
 		dma_addr = dma_map_phys(dev, paddr, map->dma_entry_size,
-					DMA_BIDIRECTIONAL, 0);
+					DMA_BIDIRECTIONAL, attrs);
 		if (dma_mapping_error(dev, dma_addr))
 			goto error;
 
@@ -811,16 +811,17 @@ bool hmm_dma_unmap_pfn(struct device *dev, struct hmm_dma_map *map, size_t idx)
 	if ((pfns[idx] & valid_dma) != valid_dma)
 		return false;
 
+	if (pfns[idx] & HMM_PFN_P2PDMA)
+		attrs |= DMA_ATTR_MMIO;
+
 	if (pfns[idx] & HMM_PFN_P2PDMA_BUS)
 		; /* no need to unmap bus address P2P mappings */
-	else if (dma_use_iova(state)) {
-		if (pfns[idx] & HMM_PFN_P2PDMA)
-			attrs |= DMA_ATTR_SKIP_CPU_SYNC;
+	else if (dma_use_iova(state))
 		dma_iova_unlink(dev, state, idx * map->dma_entry_size,
 				map->dma_entry_size, DMA_BIDIRECTIONAL, attrs);
-	} else if (dma_need_unmap(dev))
+	else if (dma_need_unmap(dev))
 		dma_unmap_phys(dev, dma_addrs[idx], map->dma_entry_size,
-			       DMA_BIDIRECTIONAL, 0);
+			       DMA_BIDIRECTIONAL, attrs);
 
 	pfns[idx] &=
 		~(HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA | HMM_PFN_P2PDMA_BUS);
-- 
2.50.1


