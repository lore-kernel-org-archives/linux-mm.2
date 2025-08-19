Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DE7CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE1A8E0052; Tue, 19 Aug 2025 13:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A115F8E0051; Tue, 19 Aug 2025 13:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83CEC8E0050; Tue, 19 Aug 2025 13:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9DA8E0045
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:38:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35C15160180
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:51 +0000 (UTC)
X-FDA: 83794217262.23.6609500
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D8541C0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bp6IjwCK;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4SM6zHJ9Q6ObBfi9kz8op3wvjKvHEZA6J8C6N7vBkM=;
	b=pAYWFyZRIAMOZ4o4cL2lf4pa8TGlWOGrCcho78gLmKEqaeIeAag5FUaSWMcj4mUh/GBTh2
	kosEqmdp25mLfl/4mP4B/QDfmorgu68QgztvlIVdDrg8VzI8+EA3B85llmitTLYe+FXI3o
	Ihs+hyG4wqBUESyyCqIjYm7UPW06emI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bp6IjwCK;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625129; a=rsa-sha256;
	cv=none;
	b=UAnVxI3w3slTLt9g5+0IZC1sOiLG1tRdBLwTYTEwkeuD8fy+QjyvFxI6LTrtLTLcVcWlOB
	W8b0QrrUi0/vS8LYTDvhkWO2Uv1IUwXzwXG9dNWxBst4krsG+L9g/RUUOdNNeWaIKahrUF
	nzQjtpwAW1b9BbpgO/1nKYqnGjG9JK0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1387861430;
	Tue, 19 Aug 2025 17:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8E5C4CEF4;
	Tue, 19 Aug 2025 17:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625128;
	bh=5GnXky7X8jRP4E4M761xyU7kxSqR5w3y9HvcAnisW/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bp6IjwCK6iikZBNKRNzlwQSTkIdVOg07zMkHxMwHx2bN8ViJPSPzqSH/QAyq4vh06
	 wQO6Ewlb0QQbKPmgYqrA9uKQ5ZlVlzrl395y0zlmmQVZo3cmxr2dce8aTWrEgEuVvU
	 PK81BrhFBj0Sb03L1mOYr5A5QlqVfAMBpJE1psdYb9zwXYegwG/tfmrm5FOWTNfeE8
	 iY+rPNAKXFYUB6cprmGsa0u1KrjeSM4hl6Yb32H9zVNhuHEbrWVA9oc/K4UQWl86vA
	 0GIK4Y52fniR/iFJCHHd5h1oBGaE5KSvHvvy9rnqAMrstqGlP8VTJe6ApXPe+l+dK9
	 yBb54yNAL7EtQ==
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
Subject: [PATCH v4 13/16] mm/hmm: properly take MMIO path
Date: Tue, 19 Aug 2025 20:36:57 +0300
Message-ID: <4b929da0b2dec4bccf489f35ee06098b437053b2.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9D8541C0011
X-Stat-Signature: 8dygnfekcjxbtfbmzrkh5crt934hbxqz
X-Rspam-User: 
X-HE-Tag: 1755625129-319916
X-HE-Meta: U2FsdGVkX1+FhJQ5loUhDrbsQ197Tg2hlHgGjp08cAqP3uCqlQUj0RI0mY2iGWDxciOA+dNGw9D7PRaz2/nfeCOpVYKKZ/h6t7npwiXg8wKjq/e5TUCRD2HVHmRxcFo+ro6r/icLS1QE6bbaffbu/qXSdHjZIRSf5KVPYGe2zpyND5pEIFr7L0Q21isM80rZdi8lCLWTivLV2Q7x6cO0XXki4/la39J4TS31BnvsMC8dUBxeFdW9GcFlUqANm1yNWLvwY0ix0dYNL4jZmwMKnFn6NGcLUOB8RZj4clCbMsw26Lurl3wyF60m6GW6I9yd8vIdYy4AS94pyvkCH9VQdLCYYd+jbQ92hjzJXU5aXdlJvagPGW3dfQ7v5KPOsESrTc0FrsnyG+862nVTsANPPDe4YnyUr8ebt42VXW3ZtgWIYfX0Etcj0K9roDXlKcv3VLLKVfNDlmF9yEKG986qhi9SIBBKo+vUNlg80mA1rzRU6Oa4TPB3BZRizWWibmVtDPeLiLeupCfSQ5M5GMS1TxXBE8T9ct/ALpb5Pf5/9gDyitSVOPVe+hq2l+8t9E2UJyKRRnlyCbMoQ4fvpNyD+EVgcfyKz9VW36GKHeZGu3RJv+SoqxrK/WZhNdflwCWaesJCrjwQYDlQj32XSgo6MrqZzpXqGzOyjL+fMxR4SpA0q3NXkpGCh86+ekTPrUKL+dVG9M4k/i8HMdXNn5feOdzywlKv3m3rgiJgcJ4iHKhUnLO2mBZRYbNDoxKj7XpR/qUpnk+lZ3axJYQlNu7E88ABrgv6TZ66B6Yd3/A+GVRncgcgO7erzJrFeyI1+rVUxv7Fyl6jUI6MfywFyh7+dGn4LUEGS5u4XDO2isUP6lEbU5tKt7LO9km0I8RZtPq6REgE3FKVVYzYM2u20Il98Jf1x0WC171ZO8/Rm7g+X9CVIxeGlSuKIOGxMaIy5NMFeb2sy5/I4mk0+fyusvl
 pkty5x9p
 x2Uw43aEEEpIhnLEeMVU4UeX6tPWtsYzADzOsOglJLmy5ArNiC3ac/cunlVm7BSKIuy1AlFydCJBWP3bmykJSgdJJHbnU7g9D8BhbVj/EFYKg0cnfvvltKb1vyRtxwOPVnKMjJ4MPJwLwOCMMlYMtkkaD29hbrESLmAUBEEGSaND49wYKOvedM6CpwZxMNvJ593DARRrkDQ5s2u6c1e98ZFT/6RogJtLv8xK6Mz1e17xOLFH+y2r4I9fiiOlF+4fFMTinvHvNqCvS6YTN0Lcp0+KxwOzty/IRVX35NsyOFyvzjIQ6V0L6r80rjQ==
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


