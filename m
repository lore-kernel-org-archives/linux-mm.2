Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53FBCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5249001C4; Thu, 14 Aug 2025 13:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3854A900172; Thu, 14 Aug 2025 13:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276299001C4; Thu, 14 Aug 2025 13:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9AE900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:55:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D20061DDD06
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:01 +0000 (UTC)
X-FDA: 83776114002.08.34DE87B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2EC59A0008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CXSCeVE+;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5yI4ppcUgD8Bd1a/05yP97T6Kybd80cY9LOjBBrnlQ=;
	b=rWhEbYdTzFawSUgOOA0lkSZr6OCemp5RbUqObGe3o7lD8p0ZgK9oDhbWur3vkdxr87qlvG
	XT5aowVXR530ZBL5wC1YfFPy/9LI2nYJtB0u4KuA8C7//gN0Ge9qJUfT9Sgz7ja3ZWz7yd
	sP0ABNYEn+suGn7ktwF/bOKwD9+S1F4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CXSCeVE+;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194100; a=rsa-sha256;
	cv=none;
	b=R5lT5T++sjm6ssreLF6EnocF9lNq275YJ572nNl+0hp76tz+lEdFdQXH/21voaTxw4y0zt
	ozpaXP66TBGaWEZF9kkThl4+nH56/RXykSRTsdVzWdls3Amals1m/Ih/koEIc4McQKfPXv
	JLnCkVYJAb2r8sp4pBcdEK3lJptv3u8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 5CAFA5C723B;
	Thu, 14 Aug 2025 17:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D761DC4CEED;
	Thu, 14 Aug 2025 17:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194099;
	bh=O9XZOHlHvjORXmOt4kTIQrFLHTrONFqw1ae8lUbcYw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXSCeVE+Es9wrKuDcpfkRMTkDto/V48L8Ycdt4GtyNjxscvktn1Z99cFkFtRP/kln
	 U5W7nGDod+MKcDedvM3kM4XcOh+z9xIG9xfqQ5kYPENdCi5rtK4ZZJ/5GlccU2TLIL
	 GSv/FlkQP2WjCDMPWxMGzlIz8nzfEP21FesXi4YSi/jF97egAabTlDywP9rcOaQCcP
	 YZU5fh26G2OcRPElvsF04cBU7c8Fh/SKU+f9iW76za6qCT6dDUk96sGALBaDgg4JoR
	 XoGaGn+PfcZdzgjfNrD1EQJ+yZgEqghYXshQat2k4DW6G9UhYSMKSVOH4UIpz86afV
	 grufu+x+aFPlQ==
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
Subject: [PATCH v3 12/16] mm/hmm: migrate to physical address-based DMA mapping API
Date: Thu, 14 Aug 2025 20:54:03 +0300
Message-ID: <dfa67811bf82079e888fe9cb3fabbbc5a05776b4.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pb9dh8eqj4367p1yzforookksgwsx1qr
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EC59A0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755194100-762947
X-HE-Meta: U2FsdGVkX1+SdQ3ryIVNsCTmo1lCqe0/Sc3Krqu85kY06lndmGY/tKchgzlohjp8tpi2JawnqXBZ82ZEW6Zfw/HY62TBapCiiQ+uGaHqxXzDQaZoEQF0UnmDnZtLWqGw4d9X5T+Ivzc1+UdkPUVwcp24uPevW9cGky5gFOcE3I8QmBd5d3FHQuIVWJPvfX+1QloPFWUsGG+7P1XSisEwXV0vRfSemrdZerfieFwfC1zws3HjRKAkDxb7l+qs5FuXlNntn0BXKl/YCEjaUel8LiaQtznHuyjEYlCU7L/VyD+aekQNnSNc+i7c3k8iDyt6sFsxlRmcrkXWY9sc7diSxVEtX2KvHqkBbGiS2wppFjMdaBt1ijWxHctgGq0/GhIZ9YRDK5inZAhas5the7W/50sa1GteTHxQSfiUcpm83PZSwjAAcp8w0jlOGPiJiM4XLZCKlW7vABjfEti3krvroc8fl5c8ZJSWkACK6uitsnpPRetQ2qARpLL9gopvwDUsK2d8fMzbv2LjteaB3eT+pkTGQLpOfKfNGgqFZauepYYmOxOwEjjM34rcTbgs5i5h6ZtZAgwqouqSb6zavZQY5Yu58tElab7SMmh3yBYU5W8B5zGz+R+MoQ6PoTXXefQXp91gnsCzGWekawg2JvquafS62Ys0vK6Dkakyt9xa2tqSrJrjl11fQHK64F8oVJ1fo0wVGBXiZZMNbZXn+wb7Qem8xFmOIW1Y96V5/RcG1vMklQ18dTvIBikMkDyuQlRJj98ouSzy8Gjf1J1Zmun15L7sVSX/iaU1zUdh7FsbqEJu7VfwDmauOtwzLwK4fbGMAZsH4t9Vt+VdFPfSvwkypoYyKv/dGq1lkq1HKoxBGHqijFrchRK88dH5rfQVe+2i+YlooTO5UCDi5JQTh5t1s747xCdUGV1M/IDBrlI/NCcEGwnnyMAI9lOzStZqeNagBXxeDAmYNLQcsXimTTs
 lBKbJp0S
 WiN+F4Se88zQEESdP9RcfAsPVAVpdEb4vk2qoaOKjeYh9khKxwfP00MdkuSYKfb3O1b0AIUD6F2fXMxMKoDvHwRY4mnGk+E6mXHjne9IqNyDy9Mzn+ARux1PRSPtSaeIK5IQBGtmZ9nqSrCNAjvOE4UjTqBaHtGcvM6LMQKCnTF9/xaFkRtoozjAyKcOUS7Tv29gz4166H9D1WNDf1I0qoaZ8HM3uqNuQvr4ranHqDUalXJExBjzyGTyuUgMN7zzf25fsqakJdXTFBBPSiVw7WsCrgvv9gGqkGRvx6nXkg1x1AH8yKu4DkgvBJQ==
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


