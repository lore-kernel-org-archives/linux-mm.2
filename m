Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136C1CA0EE6
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18589001C8; Thu, 14 Aug 2025 13:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C81D900172; Thu, 14 Aug 2025 13:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6CA9001C8; Thu, 14 Aug 2025 13:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 78524900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:55:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E2D6C0747
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:16 +0000 (UTC)
X-FDA: 83776114632.26.300F430
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf14.hostedemail.com (Postfix) with ESMTP id B73B6100003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EroDnati;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4SM6zHJ9Q6ObBfi9kz8op3wvjKvHEZA6J8C6N7vBkM=;
	b=z93FFOEa5pjwK2n9mJhn7x5oZWDdtUKF2NpxtkRdw0XlWuJSSJcFMwMPvYrvl8wjU0pZ7d
	REU6v+x8Pwo9LzC+NdZPMkOh7/WOVS+1CPpGvoKEHf+pAfiIDT4IRyzCt4SZl1MchtwtCM
	npDC10yu6/1oiZVedoaNadzZikmOdR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194114; a=rsa-sha256;
	cv=none;
	b=JY7qpyPqvgUUmAm1iTwwWUU5YkR7VN88+tfPfr6syCiwMq9sTXpxQ+miEZSzZlNm87a4q2
	spb0yp49kJfW0oDx+FlQS2D8tbwIEPhRm1KC1CMIkIYtGEKeeY5jpBncbbVvcQiIhxi7zJ
	JKzvE+I0LpgaUP7DpqtfYe/75dyhVCM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EroDnati;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 2FF73A56B3C;
	Thu, 14 Aug 2025 17:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062CDC4CEED;
	Thu, 14 Aug 2025 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194113;
	bh=5GnXky7X8jRP4E4M761xyU7kxSqR5w3y9HvcAnisW/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EroDnatiN77eyZc8zegeMwy59a5Enwcm/becY+2cM1xEQlBxk+b21KJgmglXV2ov/
	 UAq+7q6G8szT9ayGDwFdvye3DpNCa5azL0+oeplA5ykwR8qtY9MvyiRAvK1RJTTt60
	 jj1ueyGIbIKDB1TT1kqbUgqL2YySpHz93UkSkKkL6xA+IHZdU8xkZSmEu2K1L+CEMn
	 eDkihXiVUo3ItXvnErhHX0b7l7LtSk6nXO1O/r3RjsejOHSUTXBk2C+n6YTghAKVqs
	 DX2mYrIvGKys5EbD3n5M3UUHcOrr0vXJlHcNVB+uJ6D/mQ4AC0WOIDOFe67q5ODvW8
	 tXLnC/0mn7J0g==
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
Subject: [PATCH v3 13/16] mm/hmm: properly take MMIO path
Date: Thu, 14 Aug 2025 20:54:04 +0300
Message-ID: <44e4937b3d906a77a6b905946f8a74b49659b0c7.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B73B6100003
X-Stat-Signature: pzodts197zm8q6tfdgbtpqk5ncm4t37g
X-Rspam-User: 
X-HE-Tag: 1755194114-574741
X-HE-Meta: U2FsdGVkX1+QYGOth5tIwrvBfwb6/PP+WDkAGAVvqH0+X4yinnvrVvwQ1cMzkdy2zxFrLwcQUx2sIjUEULsjEb+r9dsZ05wKQtG79HGR08Hyi+OHOIUR5wmzYd3RzARrMIkg7f2UEIeLUVoTYoL3SP7NZ/2L6JCEzIEa1pEnXeUtWbGw74eAMfMFw5gg2+wVlMnQEH9fr8SBrbuXEzz+cw1psJ7fi6ASacH1AvgYRpSs5wUTcIWM8EwYWPLMg8x22Zznstmxcj7/hYOtVXmPv/dm+FXti7Zo2i8aaLo6LzEMi1poTt5t3WEwuxi50Zgy5CWjlCpeYY1RDyVrTbNKd11FmO8AZfrqPYIGvzDfze2Jn1O649HBTuwoNAwCgRosnL/xsiGF5OIG9sc81tdkdgmYLDf9AV3Fh1m53lYGpi3s86xz8dCCmrDPxj2KhJx7JwAfpuQccABMQd9vnMLItzl8+zYRTAjV2ktIvkNK2ine42vclnSedhi/SQbNvhb1wHNxhw0m/eXwbUkjw2Q1sXC1haR2ey60WAwQqTkUdyoLjhWlgRBh+BvKWdiz8WPeIRy+qh4ioRTEZOwSkBjlZRaqogRs4g4erM3Ne23io7SEIHjqicrpwaITUrHysZzhZua6AJOQUjK0VY2raGS7syVpqjVlHsXqAETCiGVOvSZPzjZRan3+zeRo4hJ/iTj+/Hvod7xmu6rSSDIatOq9avl2dgQwPI1tQeB7HmTGegtxkQONxwuvpoVznJzHmo+ZEG0hQeWVqnVDtNa7RqksffwUrKeGTL9s32eOL0nLAWl+za972Y6RALwZdw1DGa1zLMNvsWPU58GD2yWkHofuOZeWVASbKhFi0URWjpvtOKyG+8tbJiF9J2EQY7kL0vd9bOnCj3vHU1/lD1scs1e5++Mq6Dz5VimbsLGNyqb7l1whfdmojN+oEyWUYtKvXB1qcToAYsRm7yVf4OYxiXy
 yfEvQhWX
 mG6x08NmoEQdew3+50Xsa+0XQLUOIYUMXKkdklAdcZYFxeOG6BcNFfeNOYTd8QSGAm2iuhpLO0h9lBsgJt94a/M847XfSljsgMiwkRnYfTwbMZwn+TmCKXe+32oWG3R2r0QIpOlWVANgSCaZIH1NHWV/QDm06vcRFXSz8+7RSTxAQWtRMu4BPoDAL7VtOUk+ioML8duC/Dk/L+6ZReq31/VAHTK4Bo80HJizH+vHq7aF2PLkB+3KMxoshtUJZspSklHfrgiGXgAV+yZ+qbv2+7RMgWvB/+pSJPbwaQYqO1llsl8Mz9P0BBbbftQ==
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


