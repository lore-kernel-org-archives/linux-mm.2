Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7854CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6508E0050; Tue, 19 Aug 2025 13:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBBAA8E0045; Tue, 19 Aug 2025 13:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC788E0050; Tue, 19 Aug 2025 13:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 936AF8E0045
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:38:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56DBCC018B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:51 +0000 (UTC)
X-FDA: 83794217262.10.93EA533
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 92B1F1C000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ATZH+tt0;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5yI4ppcUgD8Bd1a/05yP97T6Kybd80cY9LOjBBrnlQ=;
	b=Vx9Yh4mZCNkv2Eg/4mlaUjUCZr/q8cAkIpX9bEiMyZ58Fy/hpeHr/hCUQZEdePObo0jmFg
	mrMJ7d2ucOXl7ZRtE6xbygJRhkdILWdVtHM9A2AE9/5aa/xlOmyyVIWi7UnvMxXQyD3Qne
	kBMcyh8CiZyA3Q25H8/lUwHnyZke2a0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625129; a=rsa-sha256;
	cv=none;
	b=7YtJr9SJM/spBmh2+derExpnRVYaoRbd2Iob9bAeijFG3HeYsweoJB4YhSGTIYI0dtm+VC
	1DH/0MZYzmBf4CYo6sEn8ZmJqIPO0Cqpdwb3UklgaqXrbpL69lRT4baJTUwsivo0z/o+k2
	iJsiPBi9yKyZd4uskbeBVIIFa1JiXMM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ATZH+tt0;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7C374552E;
	Tue, 19 Aug 2025 17:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9165BC4CEF1;
	Tue, 19 Aug 2025 17:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625116;
	bh=O9XZOHlHvjORXmOt4kTIQrFLHTrONFqw1ae8lUbcYw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATZH+tt0E0CIypcrTSNKTLVbz11CKQWPuWVv8Uj9hFXpVu8WhMldVqGJubdEEOKA5
	 ihrhveF/7PK4ciLaP1743VsR6NY/mkFLhxNufmCXwfsaz906MGNVzEujW1yZCGg7UJ
	 V0f9Op2bM/LDCmIDoTw89nki6nqBzfilToxhqaVR8w0WmvQL8B8EY2oxWuG20cX/6j
	 TL1fryJQsGuMrJZkOQ1NbVtcj71sbARhi2TXWmqIIZ9BTi18mEhP8usOCf32R7gnLD
	 uaTJdR9D9iuPFRWq/Gj2stVOJgLdUiBmlsVIk3TNaKhBqMgGSVJIQ5h9MDirkdjHNx
	 bZTvCl5dJvTcQ==
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
Subject: [PATCH v4 12/16] mm/hmm: migrate to physical address-based DMA mapping API
Date: Tue, 19 Aug 2025 20:36:56 +0300
Message-ID: <18165db0ff83f8222bfd05c4807cda206bec02f7.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92B1F1C000D
X-Stat-Signature: 3jbspyhiz3oowdxgathhj9p388o7efby
X-HE-Tag: 1755625129-724807
X-HE-Meta: U2FsdGVkX18a4E1Gts3S+EerzDC3c8+qTQfHRATQS/jRoYBlSqtGP4TzgF+cARFO2qCfwpHzwte229Sn/k9TmN7XX251zlxj5AzJx34st1NBj4OInwSRO86yiOkcz1uCsc07R9yVD/ljCniraok7HX8ExB2xblOgYiGpn01uzB7h4fBXMIThl+x7lZmQwXvn7CAlVAGafRDZLcy00uC4t3kC00kryiAN5ae0F3ULo4tMcGMXiCZil83DGrlqK7DT3/mv+X2on1/Qp6z0NXFKx9uKRzARfwl4EVZx6wQH1bBboRonchMk6zMNV4Ukh7gTtNgz2satVvfh7npHpWcXm1dzWJWDlz+hed8QSKIvH6WFjSSUFwAq0JHbnZ5JHcnjJqGTdGQxsefKcooVSGzs2Xp7HOHYcZZNFO2ICltvSP7n1Dxhf4jk9fRKEY5IpZ1g3xHMrpqwj++dRLqZbsNlM1SPV0v559K6zYBXpInN4ZJYYaHcz+bsujGRq2p0sinkoGG/gXBX5PhsM6oLfY7xe2+WwJRNvp7T5/GmNwwGuVhoTK1B/EQS9niQNEJrtfXUE1Agbg42kbyTmONiStev+Lud++9q2DjSlwYPDsmg8pibizOCYKG4syzWu2o4caMuAYv0XX8LUzknpS7CDMFj4u1DZhUEQ+jhiE+S3UEZVD+p4wiZ6NfGpl3AwtLHX+l+2+xBrOCnwU0pESmkWCWxSmBm2b3RkPiHMIiWm2iBhD4P63pS86fVUi1AijddSldNXCC/nyz8NA10CQzVR10CWmLQUX3ETAJMh/E3VKFbPkqtce+u3+8Q8EDntQqQGhwvPp7CC3Qr42lqflUKhC9A6JGmB4ypI5+VGpqhAQd2jPY+aipWl27dDhpUgrus8cUTBnM8VTPJ3cHDu2W7IvN8aESwp9y9ooGGcQ2o1U1ROvvVF6PFIPc8ey41iHNb5d+aJZ5dK8Ew821PYPo+v/G
 AOST2/1q
 cn3B2/7EBOxRUtcn/R3UIrC28xVMoMyi7jfCAMig4HSHmUXnLSjeOaHxu2u8Rqfi5TCx2GwbwiTXrizjnj7YT+4tibMbFjcfKbqXm823Nj0v0hsPW6CW1ogaVLKcdJcQc+3LeMIPyQw/jOLuLj7feSPpLguqbIW7YjnsFcU/cDRT1NKzdBQFzaP+Tbr5K61N17xD1YC+pmGfuWmZec8NRGucfWli/MSdCi4n0smBI8Y/qs6B45TgorW2C/EpVH59ZxfMwz9SUxzAuMsxc5cvBXe24Wnam4R326fVZbtgRbgUu5epBhaAjkjfwVw==
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


