Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19481CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9138E001B; Tue,  9 Sep 2025 09:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A98B8E000F; Tue,  9 Sep 2025 09:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4997D8E001B; Tue,  9 Sep 2025 09:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32BB38E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:29:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFBF88635D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:29:07 +0000 (UTC)
X-FDA: 83869792734.14.837270B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 600674000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:29:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tnTViotB;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hT6tMxxj7QGpFRMwj1+ZfG20o1qByFSHIC0k6CdAwac=;
	b=OFNaDBd5VCMYnIbmXDBbuSh28sGpQfCXR1zCvNugOXwzYWr218QgXJPWWOmh8TEQXw1wbG
	x6yl0gv3jS1JKOYCr4KNqaxqF+VuoTVQaULd8sD/bNKuO1GMKonEQXsj8EUHkQfopWUn+a
	LjZI9LEaXE5CxPPhilhLeEqz/3ZvefU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tnTViotB;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424546; a=rsa-sha256;
	cv=none;
	b=ygbhE2lPx98xMfWz0zNRnqn8QcmNXRjGBFkUekqUg3aKQ943MM6MpDz5hWPXmOZ5IAPpv7
	T04avJgL8E4jPsSpm7sUHO0N92HVJbD2bn80SLyVQPW1fSJBCqK3k5TW5+r6X5BpsxKSWg
	aIYvQKeTEzC0NS2vdbSmqrH3Tmm9se8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D79DA601AB;
	Tue,  9 Sep 2025 13:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE671C4CEF4;
	Tue,  9 Sep 2025 13:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424545;
	bh=ThC+GnSzG3vqrBq8iTzTPlcPa91tU2BQkMRg6ndRAuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnTViotBzgzX8VJMiUdP1iBUBwTcHGl4cXP5/xMCQJd3NuJ+v83PZRp+IV4I6m6Oo
	 rii0+a9xxI6kUod6ywO0FDmoTZ6nHn1Sm9TRhAhDLtUAwTh72wrfQLc04U7MeCpJP7
	 S+VB1HVBG2J4AB5r/4HEc/HDCNwV9/HfLsWB9aqhPOk5wvZ5OXodZEfSrk5TQI0YSe
	 2rgbYngdJVyQWuu3KtxqmyHFWhVGXg7iRlR+oGtwNzAeTNGHstyq5kW2vRrVG1sC4O
	 sQLrmM3sgvgI/IElfjSWQ/akyQs02UZyEB+0KaMdypAsViiUDxdz4nCkmXQU4JWJEG
	 mVUoTlUsHhrUw==
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
Subject: [PATCH v6 13/16] mm/hmm: properly take MMIO path
Date: Tue,  9 Sep 2025 16:27:41 +0300
Message-ID: <998251caf3f9d1a3f6f8205f1f494c707fb4d8fa.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 600674000E
X-Stat-Signature: wkkttiusec6hzdtaaixftd51x1j8hsc5
X-HE-Tag: 1757424546-13832
X-HE-Meta: U2FsdGVkX1+S8OTMu+1nqNJhUqaf99HDIxgmrwCFsIyysLs+0BxFq1oRpnSJ8Kk9ngqn8ap0zoT5m4FOwxZeuSUMtAYT1c4C+QPzqH1HlU2twbCsdKYJLmoySZz8EJozgJsk9d+DuzyqY20Sg4ffNRPPCVywISRms4s3ydSmtcNtEn8bIlyJTMUDXw9WWhZtpQacbyKWRyzZtYWF9hwOrXIBZL5zSCWwiD617/ZjW28eCU7GauckA+x9cRoXoeaGWLtmuNP5DhxUxqvWM1jsnaR3odEP5uIAboYN59f8lsIJsplgu3p2Q2QFaziPQM7Ih4wgk+9KtIpazzDQx0QlYgW6hE4qF0O+DGimH16Fs4MITiFnXEc+vCuTLpPFh4FJp9OgAPU9cyWGA8gzt6XrvV19cNSo8hhQRsiJx89rEMGG1OvoDUz676gYiIfUE2/cpUWpQkMQacpwSEEU5SD0SGY7KgkDKnTkE/TB1xkINMZMF4jAGO8W9NLzb0vvdaPZ+jMPJhKO+z1fM0H2092d1PxvWtb4HaRf7k8Vq+f7M9S26MzzhAeNWBDdthaptesu2LDvNePOhXZDMxISb733Auq1+dqr5w7FhuMyYEOTaIQzBsyIjej6vAPiqCOHnJXtGGVIP5IySEm8L6pWGOrNsK1mDHk2T5iIwpMQY687Cickz0DnZUPlqRfIw4zTDmJYnm+OLvltkN0Nf+k8ts5IKsKTOJjvbwfilZyucckFqNcHzTq/jUS5eTnKxViGu/YksZHH42eoBza4s0lajHeBCec6+ZtJdnmcov9oZnkTTffZ0hjcYtuSxsQ4LK7E2/BQljUdLeodM4TsUZR/zyLNdsQfMScD6MHhW5nGB/tVU1ucHDzyUoSux3sZESVLaxNrAMd6vDkniH25Esd1iR+APznvb9hSnlYcF++FdeHEvU1OAL0YhLsGmETZn6HQUb5kjJ8p3HlrrOvzEXU5I7u
 gKjH9aIv
 Pvmq3YQuXi2AEpJwXoeqIRcNioDKR4A78R/r0McZl5LuWl8bFMa48VdWehpXUDMbyDVSvyvKK2S7HO/mqitQ1o6y6VmEHOkZ94Ibf/O6skshp9/uwh+Q5WoDxwA914ZJPfEus9hBk6JP6jZRv4ahA0b0g2TOiK71xMxyFCRBrNHBrFwVsWJpIaCbTuwP3XU1DJh86JSaarShWEIZilGEb1HHKYYhdidLnAsYSQEs0eKVvWLPT39q1leOG03MtFQ4+QPV9FgojSZUe37o=
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
2.51.0


