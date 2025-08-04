Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC9EC87FD1
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61ADA6B00B3; Mon,  4 Aug 2025 08:44:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB2A6B00B4; Mon,  4 Aug 2025 08:44:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493556B00B5; Mon,  4 Aug 2025 08:44:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3856D6B00B3
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:44:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0591B1A02C4
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:11 +0000 (UTC)
X-FDA: 83739042744.07.FE08F74
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf18.hostedemail.com (Postfix) with ESMTP id 40A741C000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jbu+qcbq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311450; a=rsa-sha256;
	cv=none;
	b=Yqpuwoq+kaiM4Iz+4bFy3x2jAXoqVTlygLtMZoa0vH3T6pF7b/Fr+lkseSoy5R7Butu6xp
	aeEiaL4n4C9kKJIk9RX75vBmH7Z8dFO4aRzUHtrS0olng7ahyljFhuE+ea+Og5NBJAlfYz
	crP7tRW8nn+qxZjegCEn4WgYRtd0A1Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jbu+qcbq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQkh9YNjcmK4oEE8V4mODzcz3fsK3O/5hMC+kUDPf80=;
	b=6Eo6yobK19VROX/SsSyAH25lkTGGMsDDKeACBO6GFMR/bwJ28VXQZWdai0doh4rnyZvlYt
	r4LveGL47hgsaRVhIv00Jwh6zyGX4Gbi4HTuIgBmd9R1F+FKPdwXGYWkbSVeYz/+7IV4fn
	c2sSvNj4rwW7ouIyO7daKNpMPSf68EA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id B24ACA55823;
	Mon,  4 Aug 2025 12:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41354C4CEE7;
	Mon,  4 Aug 2025 12:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311449;
	bh=71zLK4izXOep/KpMivpRm0s6UWtEl8Sf4NUkNJ/aIsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbu+qcbqIUowFpCDDbVzU+O+oDab7hCwuZ0M/xHzIA/m0ruu3KAVq7ylLBINY55If
	 bo9Tk+feiAbmQkF4YUkUgIp0MAGQcmiQI/Mcg1NkiXwovDTkgHpeGsJGSuvqbW4nNb
	 6fzLtf+WmA+A9sS3/Z9a3whJQW3+eizW1avVzK6HdjeWo/DTN9Zhf652jC0OiVqnIx
	 daQ4NzeFJg9jNTgGGI/AIUyWbdPkZPaelF6ZKtGOEKFXm1v4YI2nWf6GfMuCj7zPG3
	 LWho0rhThFQGEnh+1T8yylTXAtdwgRYiF8Q52vne/vV6b0+WWqLNv/LW3uBlxR2xc1
	 8NgN+JwChrndA==
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
Subject: [PATCH v1 12/16] mm/hmm: migrate to physical address-based DMA mapping API
Date: Mon,  4 Aug 2025 15:42:46 +0300
Message-ID: <6d5896c3c1eb4d481b7d49f1eb661f61353bcfdb.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 40A741C000C
X-Stat-Signature: itiwdjhswngrrmnkc1tgxf6woooa44og
X-HE-Tag: 1754311450-474195
X-HE-Meta: U2FsdGVkX19nOgb5LjhCB+C5Kdad3/1NqYcUFwgZtYxKMD92pHHn0ODZAvE/jYMu8dc5LUI6clUaPYp8uJ3FEU3wsBzbE+5tQX4b/nnck2e1tUUU1WSUp7kwJJdG5xLFiXB/FwTJ8OZYhzYGitO6gdgM0Zgo8rjRiuX06CJFJHXwem9666FXSycsmlZutX8nwfGTd6YGhwn9UDYt0PXuOlAuevlndH1GU99kuBYxMdYxMlKeyVzpmm7Tp5c6G1U4l9JTG/0iAvsAq4rwY1D31NonInY1pwZemeLkQ3SX0zG2afBzpJDuxvDYObenQUc4FGXidNUcSzsYlZzJYtbhBGnE372VFvNkLvPP1ingKfJzLTIjYDx9wU53r/kQNyHxsflNouwkNyY01w1bqvjs+sOWykqjCu8HBbi/lzb8jwRcKa4iFm8VKI07RydYrGo/Y6I2ZPTOn42JPjOa25IG47S87K8TB6rK9UoTZjBp4QYa71r6Fvu2Fo0AK3/k3Qd8YbykdOeVJLLtm74Gk5LZmCsG1RqQRx4Wm+F98M45sf52pus0QCq69ihIhxavZfMJtFCRvfU8z8/JDrfB/N85ZyithB+/fatEQbz2ljn9KCcNhLWJX5aqf6xJ0ujxK5IMDGykBT6TzFfgQfYaXbZK8uP8op6JqVi460jlMx8dYqRMFWEMY4RIGMd2fG79i2CA824m1XYakubaABNa5vJEd3wCVeljzUEDzrxnFCEzL8fY+w7jO9ejxi34UAFw+M0r/IT9bnhetMq1WS15M1xcKWBZSVxgadm8eCYu5dqMSa1oR3obHZsO+wq4l1UuhUbRYymP+hF1R/7B/oDjPDQ/efaEONVazrIZYzx3MAbOjLpMiNcQmHgm6JQKXuVnHZoO+CKtv53Px60SoXT0sI7c9hOObPvfrFCVbBBOJ8Sy9ZL/40AWqc7X85kq22Z01m9S+/EVcvVBbssEEGK0eB4
 yxEBbm22
 zYQI9ikuVnz8QbjlVXyThwgi8M1ABTVwdgKNYI68geiAPPYoE8aY0+yAlBFqCmAs0jYJ7EOZUZECYQGH6AkCPumhGKMgmCsL8vM6JpYIYmZnp6Xntg/2eUpufakuNVy6dO4eMzsU2PFAA0kcreyuuoQwOUvwtIQphL6kLW89eGZJQJ4UbWXelPrmq1Sd+Gsg8RdFPiGX4CGC57uHLMpcDDlbGWb6oapHCVmCJfrNNrKr+ycy7JgRq47MiKDgudCJmO5Gw7uD71Dsqz0/mtm30GKGz2QIfv3a+hBt8eTE9ROn/x/xHi1Ff+WkTqQ==
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
2.50.1


