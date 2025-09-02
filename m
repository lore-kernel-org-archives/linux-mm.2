Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06CD1CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67EF78E0018; Tue,  2 Sep 2025 10:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6568C8E0016; Tue,  2 Sep 2025 10:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C308E0018; Tue,  2 Sep 2025 10:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 44F1A8E0016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:49:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19D89139870
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:56 +0000 (UTC)
X-FDA: 83844594792.12.1EC7805
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4BCC6100013
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="i4LP/8sF";
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5yI4ppcUgD8Bd1a/05yP97T6Kybd80cY9LOjBBrnlQ=;
	b=mNBQ/HQPaLG2wztZAvULweWsits8IUccxXcFiidg5WsCZ+ylMjK8MzBEaRaEGo1xJGzEkB
	mZBtBgd66fIij9UUx9wVIdp+A9h8cobpAqDb+/UBNSIe8sxoQYne0gDtohlU9aBfzcYewi
	kAa/LcBqy+/d9yEIHFW/2IabEVwfHhI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="i4LP/8sF";
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824594; a=rsa-sha256;
	cv=none;
	b=0U/83yc8EYcXFHUfZRkVnAWj77325tECKDaimnFlfhGIS5quZ3xzOw3J/eWOCl2lB1sxLy
	L6O3tfZoHeg0mIFlX2V3a/lmP2SN79ja6PfrZqIqWrjDpM8i5X3dYDQ6hr0voRe1yQTQSh
	yXvgkn8NzKFy3ssGOC3riqAqhObvaZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DD06409E2;
	Tue,  2 Sep 2025 14:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5E9C4CEED;
	Tue,  2 Sep 2025 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824593;
	bh=O9XZOHlHvjORXmOt4kTIQrFLHTrONFqw1ae8lUbcYw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4LP/8sFn4GJsZ/wYwZJG+51+koOumcx5kwuswjw9uzDtXu5nJFVYiFdkD5Pd0XDV
	 CJojBBl/IcJFZ1DnDDaW5/OvJIPqgpfNaVsr+q2jlXPVvC5bdwVF7QKxf4Ph4v8jOj
	 2HjHKIF3azuV23NGrP/L0kmkIoLbU77FsGzLAIB4etR8CjLv/mm1W+Rm9wG7Wi20Qf
	 9bCfB5IoI0J0AUn4bKcg7P3o/CnocQo4hvP2QVxf1pC/4M65ApXfrRdTznGR7HL9EL
	 UCDZyXx1Bbm4fIIthh7q4BpOhb2peNDAk4t3Me9zhw16A5tgAwshGbvt8aoBahblXj
	 yINBs05SJGpZQ==
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
Subject: [PATCH v5 12/16] mm/hmm: migrate to physical address-based DMA mapping API
Date: Tue,  2 Sep 2025 17:48:49 +0300
Message-ID: <90d2f14352494d615d3a5d1251126c88f96a4171.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4BCC6100013
X-Stat-Signature: doerr1awgudm5khhxibt33awfk6wegww
X-Rspam-User: 
X-HE-Tag: 1756824594-18049
X-HE-Meta: U2FsdGVkX18cMz/aR422TzYsRu89q64zLPCXIKsCIM+MnezslQmZmDXipxyKykGF7ZgeYqudOrvJScd8sVBk3K4UjVoGeRI09rUlc8ODOXK72LR5/b+d+K7kDAeVTl8DFe4KRwWZVD6LtvbGPU9HZglrvkMHB4cfvMUPBEKSaue2DzBuVA6Z2ATXsvJhTrbWmB7WOCNm6bZesQ3vcItWRofCBPUaZ8as3wn5g1pXKni8d1PK2kzIAvfYPVzZ2bylZQv4rwCYdB4Rabq3T778o37WZXoyl/Ki8ek4sHSj+zVq6/wjU2LgdyfNfZiQCD7kWKFDWZh/RUrLAMDbIANcAxKa5AXlBkBCwup2Aecd+USZqvwN2Vp8GpNAAA+o3ssxBQQp1z0+lBcRS0W74BxEhvyU65rX/rqvKag5MBMo8ij+Mc0LZcgeI1Jn6CoPHUVFRWBobNNx0E5s5/f/wzIn7McD/5J2hV45dRGyc7SKnae7O0ujs3Xf/OUP2nRPfgQ/4Mn++XTxUpL6wOzIsST5oAuPjHiSG359SwfvOG8+x3+Tei3CivVBj87HcGh6oLf6YMaUSPjS6WwJAgrxNn8CNtdfZVQQCozirFS3vJp9GGdDfgDKjXF2f8g4PlFnAtr0raeQGdeldikx9hSVB3eD+/RABuvtKBhhd8qk+1BLvyyIwhbLJaSwA253dQW8U4BnGdAeufiHxMXf5BZGXqsj1r0KzKZytrn8ZFt6jWUw2AmptAfaaLN+NA8XDEUCgvQqLWCSMQJiosrRBD94uHeip3Y226i2DSMmvFkjHcU+lYfq8r+FMu9iXja+XJs7EHApc+sHoQkKZtQRmvVCVYAgeN3xPOYdV3bdOrbT3fzRtAx/seiCKSiRVJYK5kXa0Vkf43f3x+0kN6U1Aak+tGA/P1HYCavgDmjTr9Fj7JCAk4p0Gk73kZPcj9K4EswbYAwdo7eWHzH5EyhxdYhWVqS
 Kgvu1SQm
 ++YEU3Tb+e5HEGVhwCX6VodjUoTOgLxp0drBiJE02bvscr16U7JsNGClbijVVmgADcM4Lni5skuEphdezPA0RFZONlFMlbnoFWk67xEPlENCspu0+EgL7ROvGjc7ViSLwtBPlhDSFv5CRpb0B9PDeLV0VYmi9hERO0HpeTibKleO6atWOohNgL/258Q6xH9fkRm4GqMQEnGUFXsldVXpAcHQqkVkAlg57hNlT0nIngGgqM9mDgsZfwnvP78GOq/5uJ4hJDnCYhFP6F9o80kpnDp+S2XLuQJPzjV9jVKZ+549slsvrqBFUASbjxg==
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


