Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2860C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815576B00A5; Mon,  4 Aug 2025 09:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5E16B00C5; Mon,  4 Aug 2025 09:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4E06B00C6; Mon,  4 Aug 2025 09:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 576E46B00A5
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:01:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 217FD58630
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:04 +0000 (UTC)
X-FDA: 83739085248.11.2B09E0A
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf28.hostedemail.com (Postfix) with ESMTP id 26C21C000E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2heiyEq;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZXS59dNhRLgyTs/B5iuQ/7K8awlPVDX93icVtAf8ts=;
	b=s3WNBbk6/Mrvw6RAByPV8X1clqu7ny3x5zjBW7KRF1W+D9e9XhsF6M8Rrfd1dx+++C2eT4
	uQ0G3yf8nUm70mNLw8+/CRy3aKt2u5ww/xekOcYCRYyWluN7b4wkps8mKC49bVs4dq24Xi
	4yooU1JCn79zPqIOGjY6ENGtWCgcnZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312462; a=rsa-sha256;
	cv=none;
	b=OwLMPI/oIoz/zS04+gxKJvZf2IUk7APnNckmVZRHAC8hPrcKSQHLLJZRQ8LGjP0RrJOJmt
	xdmHqXNAYrAI4edJSTSppr1gFhXG4VKgCoxrheBitBTsFkqcUvW0zyIQAZYElZkzFgzrEU
	pB3RQoBPv4MUKQxIrMbYvLbn0kX1hl8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2heiyEq;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 63060A558C7;
	Mon,  4 Aug 2025 13:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FECEC4CEF7;
	Mon,  4 Aug 2025 13:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312461;
	bh=NGf1AYRJqA3TDpKjHdv56/eFxItdmJcxurU8Pl18z1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2heiyEqDcV3a7/Mlnc3aDnSnlB91n/iIZskVpJMq07doaJ4Y/+n8z6i9uQQ97TTI
	 Jwn0N16sASMrrNaXjxejbTLPAT9lGF7/gcaarJFfI95wEN2Kz7h6p1b0JkTfrEfX1D
	 VmbMlwmvB94SRPw2Xf00i3CbnZQu4DmD3LJOwOg2/BnEk/zOGMDtR/fPvAMB7TZrjt
	 D2BZw3t3cwdHCfJg4yEMRZxnPlAGDpPyhGUZmjuuOELZDDsSP1Cj+D3TXKyV+f0pZ3
	 MnJhHXzeBublwqXE+kDR1RxC/k4p4smIMvq4VeNTH7oDc1ta1AFC3kGqyk5VZsiQTO
	 Ve6+Tt4c6rKlg==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v1 01/10] PCI/P2PDMA: Remove redundant bus_offset from map state
Date: Mon,  4 Aug 2025 16:00:36 +0300
Message-ID: <c9b6237964b9606418af400bb6bec5178fcffff2.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26C21C000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: sdd4gdicntq19rxkjb8fo1k9391h1nbf
X-HE-Tag: 1754312461-624564
X-HE-Meta: U2FsdGVkX1+BvtDLxjshV2gnvREyF/dQM5zPXP6//Tmx6ONSgy+MO4xze5QIZ03HFMuz20xw+m8KRxiLtp9nKfB+oRhyaANA06S3GxRkpiapvZYMB1+hnD+krRT8hizXUwK2KQmSPttonCYpTJvzWA4GCNpvcoScPjAou1j9LfdfhHGqILuW969B5PNqFAKCzfuOT3o1Uxgg4s51qG7zd+sIcsBcIobuf4Yyts318bo0Iy39nMjcqWQa3UfVJAIKlRZxT+DSfjF4tQU8J98IFdN5Mf3p8CyFpKXXoRoc/Vmpot1Wnq7LF/isdsKVswSRNwqLcEXpW+rDf/3HI8tCbCWBEqAiUFvxbIfxMnQZE5/P/1NhBReGKSn9z3t3kasBXkuiXjJb2QIwq0YAlHR862SnL3NVpFNSJ803li+wBrItNXLoPgeL7VjBpuKCE/AEdEyJ56t295guvFQGbKzIimNb8zIMC+LrpOYCLC1MITz84riVnB0Y8cCudmti7FhbnO2J+MV8n4Ahx0lQLBchPLtivZBQrc3y80uRauBnVOKmN8ySNHLWE+ov79QRNoho5wDRh3WoCnVpA49r89NaEJlgiiMDixE1YdOfm3HffPW5TUCn7t8kcN19JRDMzv3XpahfRSMRFY69EyzAmUgxNeoUZi1DGR4zZV+C222kAjDlv+skHdGr+aF5LHsy/CTEjgAOuceev1Qvo8R+Md0oGI4Zpd+PEmqkYZYUOglicVkk9BqZtqbb/lqyKM7ERzlygXsiIL+k5zdNKoqQzuXRzxo2e5WXL3M4RjUbBd1XQZRR4mdVXg2xxWJTiWV/eAycKGoBBIPlJKoHRk7FvwIeFLoacCX8XGyqpMYhnZmWLgqg2VhYe+N6zlk3PRd2s8OhAsIjlwysev9AxTCdaN1u1eDm1s/Au+rMokYdrD9B2ioZcOucP9lCKbUEDaVUxPa4z09de4SBiHT+XPDt5h+
 VKLDOhMV
 mwtRtSO4qh6KWJ6xPOeKJD2rbay0zWTBfSDEfswX0CmJtubH9MJs4j/M/7lo6V/nuYNZqz9J+W4znMM1GbZobjDSnoWr7Egk1ot8wF3g3gpXu6wswJAOk8zdUCoDH5QyF3JfevaSpzQcSUITv1M+8aGI4iXKyHF8HQmKRcH0XHDdCkYqkHuf3kd7L+zicFRQIRmTm0PuSABPMFFZHKdrWQMYbfTqCQOf7Ibp7aaYAX9BOsjzbn0YzdIpk5IoTjNkKsUGmz2uLsy/7PY8hZto0rVUD1MLqHolVeApfEQrS8Dk2q1OoPRv8ZrxK9XmdhRgySakP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Remove the bus_off field from pci_p2pdma_map_state since it duplicates
information already available in the pgmap structure. The bus_offset
is only used in one location (pci_p2pdma_bus_addr_map) and is always
identical to pgmap->bus_offset.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 1 -
 include/linux/pci-p2pdma.h | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index da5657a020074..274bb7bcc0bc5 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1009,7 +1009,6 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 {
 	state->pgmap = page_pgmap(page);
 	state->map = pci_p2pdma_map_type(state->pgmap, dev);
-	state->bus_off = to_p2p_pgmap(state->pgmap)->bus_offset;
 }
 
 /**
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 075c20b161d98..b502fc8b49bf9 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -146,7 +146,6 @@ enum pci_p2pdma_map_type {
 struct pci_p2pdma_map_state {
 	struct dev_pagemap *pgmap;
 	enum pci_p2pdma_map_type map;
-	u64 bus_off;
 };
 
 /* helper for pci_p2pdma_state(), do not use directly */
@@ -186,7 +185,7 @@ static inline dma_addr_t
 pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
 {
 	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
-	return paddr + state->bus_off;
+	return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
 }
 
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.50.1


