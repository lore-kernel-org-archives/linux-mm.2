Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFFBC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B80F6B00B8; Mon,  4 Aug 2025 08:44:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668256B00B9; Mon,  4 Aug 2025 08:44:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5300E6B00BA; Mon,  4 Aug 2025 08:44:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9E76B00B8
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:44:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0813C57A86
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:22 +0000 (UTC)
X-FDA: 83739043164.13.49F3EAF
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5A98540008
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=twziXknB;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vAkscLUbC2ztTvQppga8PLzPNKX2Zo6YASdCGH79rc=;
	b=sqS9IekEisPV+juT3hG7D4KW5wc46t3u1WDP4minnjpXTy8xo3tQjYBBSxsVzk/qrMfqCj
	NOh1PESIuU302C29C0Wu1pvUOcLp3lriSG5u54gkcdTeq2H7aTgmq+uuWuLE8Sp+uAL6sT
	6M+zW/EdZjNmMQZK0n9e4PeetL5cHlw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=twziXknB;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311460; a=rsa-sha256;
	cv=none;
	b=PKTCJ+xc2/3fUS4aoaGDw7kT2Lq6HLMyOXVTf0Es6fER783yCJoygNWD69sYVtCzAK37m7
	RO47J5T8pnUAIJI8Oa+9bLrFha9FAVeZoJH0d+tC99X17caq0+QmnhWCn0qTFme4gYTR9Z
	77/i/SWy/6LE2ftBaqcZx8WM8U0dN48=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 1404A5C5F2E;
	Mon,  4 Aug 2025 12:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4569C4CEE7;
	Mon,  4 Aug 2025 12:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311458;
	bh=dqwhbGWVl/oipogVPAPlJyJScmypxjmriuJlNMDqMFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twziXknBPqQkaMb4B7FpNHJ9HEUx7/M836/B/HOkWAaI0xU18AOGgranE1UPO3Z2A
	 qByqLoklhRYu6bnu+x5ETVJIc+P+0Ju1mUTlWesgsxm9Uw2nnAUHgWFFcvipLZWsPr
	 /X/Xgc0MrjwXWJE2eE8R2nPmVwtK2NoWOETrJzuVA7cF2pqqQw7TPbh3FX3McEN3on
	 SLv84u5z+pYu1j0JRSH5twhBbzvn9nXehFR206rnivCVd5lTNcN4IpS/pX3K4gEYJR
	 R30yvtOo8vlSCBPCeQNV8Tbj18sYkV187LjgCJFMSIphAwqv5UYBAvrh/Sqr87dLeL
	 XA2ufQWKM0AXg==
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
Subject: [PATCH v1 13/16] mm/hmm: properly take MMIO path
Date: Mon,  4 Aug 2025 15:42:47 +0300
Message-ID: <79cf36301cc05d6dd1c88e9c3812ac5c3f57e32b.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A98540008
X-Rspamd-Server: rspam06
X-Stat-Signature: wp7ish1a4kxwm5ekzckzk9is3pfqgikk
X-HE-Tag: 1754311460-481601
X-HE-Meta: U2FsdGVkX1+nzgxU1A497iA5sWyVUSZR/WIX0IR6Qb4jrPtmRkYQO8VVOinr4BIoKvGV5ixG3PUqBxaGSbbBcBorgf7C70tc4ZrbinjkIgHl9ZZHGs61knqjOXmg3yXvmVivcAoy2ZNRGOOHfzDoqWvrdz4Dzub1xWpdyBDxdtMn/v2QPzn0PVMK7SLwcxiIlicQ1vK8k/ZE4AET17Mw76OM4V8IB5On44R4wQOSYAacE45WQZQFYxp5M0C0uZ96VG9OcHX7Th0Ju3aAVDPyRFd5GzINR3NKjsXKXKNjM/8SWnPYZEgeTemXcsDJLUmZ7zslv6q1QOkb9HDU9XOeA7TgqAgl01fkSUZRuospEwulSbzH3aa3eYnWShJXfoQDxUVjguxBihjV1pyVqdduxU60p9JWsYnpetdBBGrV+3Xup6rb6uDbDLHJ2Qfvz99YlnbUKCURqEGLy8KGEWECP3UN/jTONX4IDbxUCxcA3BwZ7Wz6CnW3Bzx78UzCfEpwd58k79Z2X/+1h4XBrxAEyGL2tACPCzAz8i+iz2/k2NvGv4DGo4XRsq9LPK6weZOrBKS5K98Vv9lGdX3PbqzGF8XAdNPCYmM6LCjsrjesqzkisTvS2px2NfzQXxU3dGWBcrKITEVS6TNDcV/Lqmn0zTiApe5kmyPcHtU3BetHoBcnjl8+hWrOjVxGmwmXW2t2ExfK1xwvypTu+mzdCui755PyVgg31dPmAXNW7Z+rJINxEkCBMJHpCmBQm54dJCRGIbn/nj1Nh8Sd4myqATw8lxymI02BUkkdPKOjvwiasXSeOVZskIfdp9/5n1qeMQ6dgkxycL0BavDFkYAQlw7wEWaSclGv49+Z9/s7Ov7e5mzA1SLz98qf9qdmN3F6t2IhpARQrgXeu9tx+3llLbeKlA0n+/4kupGRKvxWDiJukkuWiV2f1K8ZlxgIIvVd59iEBQcm70VZdopWXUqGzkM
 qWHRiKm2
 KDfx0JKkEa/A05+Cia2b4M4kmLQtW6SSlq3S7+uSLXgRQD2/tayJBkh/TLS5o9HojNepsi2ia74HgLrL9u6Qr5JRdUg+4Ko/yQ84hKr3Htgl5fpSDR256a/SIlPaNG8BLd62aIQHQr2G93Im7oC3tIF0k+oZ7r7+x9DN+8lZ0LWQRRpSeg5t1nCfLHVTzU7YU0il8AinfgXVUUZfsmWS2nlJsV+p92DMJ7i3MjUHuj6N+6FKum40lU6G8EHld/1MZz0lB6Sq5O9hkeuVNyjuWyHT2p+19qJy+3/ZZhpH2h2FMxA9wWkJ3AlU0Vg==
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 mm/hmm.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 015ab243f0813..6556c0e074ba8 100644
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


