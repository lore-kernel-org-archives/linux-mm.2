Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3305CA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C21D900136; Thu, 14 Aug 2025 06:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57107900121; Thu, 14 Aug 2025 06:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411B5900136; Thu, 14 Aug 2025 06:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 290C9900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC1D0117B04
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:42 +0000 (UTC)
X-FDA: 83774954004.17.05347DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 47A432000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eWNP8pfq;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5yI4ppcUgD8Bd1a/05yP97T6Kybd80cY9LOjBBrnlQ=;
	b=bq/OJWPDOuL5wCTi+EhY+SkyUHaYCpOibigQP6iMPks3h3lcMoyx9jm+4Y4ObdsOSMatj+
	vkL0soUYrdSH6lP4XA0IVqbL+LRGoDIqxYLWrHcQ8Z+ZpAiJN96XkbOzh0g0ci/d5Dqlzy
	ZdVykTA/oYWwlBEQDBC4vZiqx7mF60E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eWNP8pfq;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166481; a=rsa-sha256;
	cv=none;
	b=qxoqaYDmu7eC0KUWNAyxxTorBUGt1yuunSbtRTWgmAeLxGVsSb6dadoI6kQscDS/mbO+zZ
	qxhUPRY+LVpmx4nw0Zt5C8XEjbryr/59Q8fN7QyQ7Kp1WJ9Jqcf3UMERO3jn4ox4XRv9I5
	jYssfQW+uvBa1cI0SERmIMdOMQNEjW0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E066445B7;
	Thu, 14 Aug 2025 10:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27028C4CEED;
	Thu, 14 Aug 2025 10:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166480;
	bh=O9XZOHlHvjORXmOt4kTIQrFLHTrONFqw1ae8lUbcYw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWNP8pfq7yUM25kUsbm3T+cq953aNotFNHBqMxVlWCtlUYOt5Rw3JG6yLlkJyNYia
	 0DPFRhoAzA9uIWb4p7LPAYf9xIZ391Hkz/Tpf2xoI+iUWSIU2W7lzjQ54XlYOKvAbM
	 b6GPu27TSwCixhdzxPCCW+NF4MA4gs0/au8J3ut9S/JCFvIyeiBlUMgoXmOuZQu/o4
	 Wnziz3n69of8QUiKZhOoPQzzbBclfAGwMqIbjxwm2VdCvmOPiOo0ennsGFEuIXJEy/
	 dMZv2hpRL9zGOuGaoy7hht/3GW82juz30t3Cp/uMMdSOa2W43Gw2TJip6DKEh1GJ+X
	 yPFpfFYdC1pBA==
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
Subject: [PATCH v2 12/16] mm/hmm: migrate to physical address-based DMA mapping API
Date: Thu, 14 Aug 2025 13:13:30 +0300
Message-ID: <259668e7a332148edf8738b7b4637c2b264f51ea.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 47A432000A
X-Stat-Signature: afsgzzzeaudfckjah43949k4bnu77wqr
X-Rspam-User: 
X-HE-Tag: 1755166481-761466
X-HE-Meta: U2FsdGVkX1+M8clm/FQcuit3cmdAYOl/H2uGXbqYaHLzv3TYi3ONTjgN8nPpfzDaBg/LdaYXf1hvxxlcgd20sCcwHSveGoHDZj8RUJbvgkAhdIKQxgRY7lJlqVi9pqPndcf3nJFCNq1i23ZJl22bTglLupAwe1USpExC53PGQl6VqgjHJbEI0VVmQLbuz1yjT+/wcdQ9VynClEwhIDZt2vuKb1QRuVUo4M9gcuMA5/EVnfjv1k10rlYHNXO6BqwEmRFdxERzw5tOXI4K/lUVEKINXRh9E7b02Xds0vOHLqK9+D04em3HzmhntyrBaIzqX8kq6UdmbID10ta4krsEDOvLfyWLE2hLo8/YXUtqPp1zoFlTRdICPh7+Ks2trV4V4/wx55A5seg1EsVQeT7X1W8zVbsAT+MDBf4yngaYs3dnTkqt+X68lpteTbXEPcZVT60ZskeZORJZKFQLKqjKVNHtbi1Nj9aKXVPm1tEWua9bCeoIuMaCTRx/eM7JadAZMmlMVCXxqQHnaSbUEd5EDZXNBgmuwPY1JSiOfBfFeR05rPXSzwCtA/lbquxvYoGEYJIFqMn2zyMZpXZUsA+QCGmXLwJGhWkI3HU7xCmky0AYQbx887nRHhv+i+Vqor/jGBS6Jla/c7U6+p2Tk4oBCK3AaPQSdyW9xwGGWbkJ3jV1zepKNwoxW1ZiDy1bc5zNddNt1Ezbrc2BPndXoi0sH6kYNC4wCKsKiDAVTDPvJVTMuuyNxkYzixx3LIOqgVUuBY5yBc44n8kZsMJf6DTfvDwWMFoak6iAdEp9xOLBEd1rUCCdea+vOW1/vwbZdhxDnem8EyFu10/Pkfzohz+V7anyyVHV8XlapDYBfzF7eUl6DO43NdTx9UuXqrcX4G5Vv8frVno9tfRWfCB+mb1lrWVI5uLoEwfjgVrdmPuW/UCO/1N1/EbANcnvWkThRtrXRcaB1qZR6/EHeHAOjaL
 ZlP3S5uJ
 59+lBpO/KHHTn5NiMrt5QRdQDtn9HjTaNVFewH5rvs8xstWRo3uQif9S6r373EnAKIUxkZV+VujHrAp4McgMNZXE8cFqnDZSHCTYT7PRpbI8BTdW+kleF63jiPk84IYcvkgfPKL1Zsd0DWbMh0Kxg/8ah915l6KZzjrmWZFZpZBvwhvnvPeo98hO/JQCr/4VeyvRfAfQ2sEFMAF64uGLFlofYp7xMm2/ED72zZ+5xfo7OTp/syS2LUzcnpjsAaToKOh6QLUvmtgaQsSLlfuiZDKWuGxX0Z/EVZqZualEO8OuFLhiaBCAZduhAlA==
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
index d545e2494994..015ab243f081 100644
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
2.50.1


