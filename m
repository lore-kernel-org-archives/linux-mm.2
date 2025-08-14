Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10833CA0EE8
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0D09001C1; Thu, 14 Aug 2025 13:54:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A151900172; Thu, 14 Aug 2025 13:54:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8416D9001C1; Thu, 14 Aug 2025 13:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FCD4900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:54:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D90E117EE9
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:50 +0000 (UTC)
X-FDA: 83776113540.07.66F0933
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7727810000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C6w4ugQY;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUWODOYu7xl20YNi/5H7WavDXD5EiHAIElpuMjzztLk=;
	b=HgCYr49+yIuWXLT2s8ipNwFLQE2z5XA0BToDTiNoGuHlaBWT0txQXMWOrFYMvGg1WQ9PtD
	5juP2o9ig5wmV5cg7NuiiNJhJFA+pWNE/jCnNEI07GiNuW1O+S6JhtSJSyfHT9xv9xasdA
	nzVHTXBPX6TLPjkocqQXHNmyA8M4wD4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C6w4ugQY;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194088; a=rsa-sha256;
	cv=none;
	b=ibGXmce3LSC9osZsdzGtLOq6o0u1la9s5uLa0+W8/eAX7ZXIam7aVq/zVnl/TNazFWN4KU
	0C2Mb4CYvg8UuX8vh9O0C4KqrcwCMAvhP5FYk4T19fuWsZjn1E5o08tbsn9sGhoHPvY7d0
	x+IsLu4TWuu3fzRfBS+6zC3MYH/71JI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id AD63A5C721E;
	Thu, 14 Aug 2025 17:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F749C4CEF6;
	Thu, 14 Aug 2025 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194087;
	bh=6kQRc8M4kSTN6oNlv6UupesxmLI8KrU+a1TL4nhd0iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6w4ugQYiUdcIBDBap/wpiQAIwZla3sL70dXT7fdDwlS8iAo7WkvllaYcXF4QU2M9
	 kt4WEnzYrIn4ZDZURbuikMUlP1Qp9CxkQOq+obTZHosuKzmVJJ0AF/lK9fQSX5YtoJ
	 kzMxjlyIoIy5MaeVth9MfY0uS93UJW4vr922gEZKEo2egnsKAq7kg8ZgHQF2XBxqCZ
	 F1uVGjeU46DFgcCqPy+lW15qydDCb2UvhK7t93bEVpZBLmZ+yVMS129GxQ41QBkFWL
	 CFslA3zPU9Peu4BjTd3+d/0rvdaudAz+bJ7W9WzhuA5hIM9mliO10n+CPNH4ALRsGy
	 OQQa8odedrzVg==
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
Subject: [PATCH v3 09/16] dma-mapping: handle MMIO flow in dma_map|unmap_page
Date: Thu, 14 Aug 2025 20:54:00 +0300
Message-ID: <ae473ed08a384bd70e3816cc74e11513213d71f4.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7727810000A
X-Stat-Signature: 8cy79kp4tnqraiztgunec5y7jxgs1qcg
X-Rspam-User: 
X-HE-Tag: 1755194088-609236
X-HE-Meta: U2FsdGVkX1+JilOL/Q2tSR7lUJ5SNTqdEK4uSLpUaUUoJpM4399gDOTs1NovmfpfV+46rKdR+6Hm9/cOdDDQS+0MVqobL079XXFsouZJVpdH02W+pXpeaQ4H+5Y5IM81bm0RTxDkl56LXTtArxa74+kK5WdAxi37Y9bzeDNlLWfMI2qoaFNwximnKI1bxQ3sbfQvtYhrPiDdsD41AgXZ4iznYPT+6Xp4WnLLUn7v4zo7vPLvUK8CgvrkIsE4/GuqbKNY9/d5meHsFuM9vT1zcH617GcwztJcj8WnCBjcqsZBsIqQI0f3wg+OtP4vaghFObyCxZx9awXpJozObxihSYVnzZldelkJCbaotwt6LdDibPd573OuQ9HzHo7/hGaqDBvs38IDT7rw05zAMgA7jqCFk4ZGkBVuIRH2Q4VU0J8mzV5pFsv8Zq2pBAbs5tjVrIasiOiTeAPokUeKruBnWTofNspkLDK9vB6qI21mJ6gkl42556zMQmJdb638ecjJIt6EEH/Lvfa5tuxzghlCD6Nwuk2CaLx5F9VcYnrWBKxJX6Jox/Rhisek18X1j7vBD4x4WV6aoC+hiTfFuD2kSVf8+H4kNHrVjc9WvV5aaCJSGoh73677Hb5adEc08rpRaTc77hKohrI6YOTdYU8l6YJKUPz4KTmTB6bDAQU8B8zvzZ/ZUs3FXaDyMGb6Si+IDc8Ou5sSfDGD0DcY0tTrGig+qJrRffFPzQPsbyce1hYfHS1qVd1uBYzq+GGLVTtpdlggwLCEgbp4c9fs8N0TalHGg3a0FBMKUgbpcaY4orjAuBT0f7J6bnSQjbjBtAR+5ObAWxud7kzcDxDua4VKtHc0+9tCvSft7DmJgabIK6vKZfW3DvzPpokjLSHeYL5bClyToXJ9+y1yFiMumAFTGpB5Mtya8vqQxZS0RFlPqNPKN/hOPRlWfbFSoyaKMT2pUM1HNEGsNRyFiD55o2A
 b3yvd61y
 Wh3rX/On1motFf4iKMAGtmy4ZQ3iYMqI/o8AHtY5kV9S53PRg5vdaIHGeGSOKI+yjBOdrjY9i/RSj9LI19A5pbJrhHWRhgB85IjL/wV6Ocn0/zAfYLcIZiZkgW0kksClU+uJFWKcmAjLv4bG6wZaGwsAOXhYCJUqo8uzU8kbO+1EvrRFnytt6s+D21Luxy6acl8vNEw6VvrtzZ9T8znBVmORJZwowdnMlo2udv6WEKuYbLK804aJGxiQ6L8a7MLmH9gunqXNu/2KnmPMGkxntnJOkZRNn2rK+Wm3pOa8f/+/TeIfiI1dJd4lDn+3cnZaCwkruJ3PxKgh2unD3W6mi5NtV8mahrhTz0YVD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Extend base DMA page API to handle MMIO flow and follow
existing dma_map_resource() implementation to rely on dma_map_direct()
only to take DMA direct path.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 kernel/dma/mapping.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 891e1fc3e582..fdabfdaeff1d 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -158,6 +158,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	phys_addr_t phys = page_to_phys(page) + offset;
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
@@ -166,14 +167,25 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		return DMA_MAPPING_ERROR;
 
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_map_phys_direct(dev, phys + size))
+	    (!is_mmio && arch_dma_map_phys_direct(dev, phys + size)))
 		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
-	else
+	else if (is_mmio) {
+		if (!ops->map_resource)
+			return DMA_MAPPING_ERROR;
+
+		addr = ops->map_resource(dev, phys, size, dir, attrs);
+	} else {
+		/*
+		 * The dma_ops API contract for ops->map_page() requires
+		 * kmappable memory, while ops->map_resource() does not.
+		 */
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
+	}
 
-	kmsan_handle_dma(phys, size, dir);
+	if (!is_mmio)
+		kmsan_handle_dma(phys, size, dir);
 	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
 	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
 
@@ -185,14 +197,18 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_unmap_phys_direct(dev, addr + size))
+	    (!is_mmio && arch_dma_unmap_phys_direct(dev, addr + size)))
 		dma_direct_unmap_phys(dev, addr, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		iommu_dma_unmap_phys(dev, addr, size, dir, attrs);
-	else
+	else if (is_mmio) {
+		if (ops->unmap_resource)
+			ops->unmap_resource(dev, addr, size, dir, attrs);
+	} else
 		ops->unmap_page(dev, addr, size, dir, attrs);
 	trace_dma_unmap_phys(dev, addr, size, dir, attrs);
 	debug_dma_unmap_phys(dev, addr, size, dir);
-- 
2.50.1


