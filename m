Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB88CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115D39001C5; Thu, 14 Aug 2025 13:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A5C900172; Thu, 14 Aug 2025 13:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8FD9001C5; Thu, 14 Aug 2025 13:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D556B900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:55:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E74EC037D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:05 +0000 (UTC)
X-FDA: 83776114170.11.4E08EC4
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf06.hostedemail.com (Postfix) with ESMTP id C05CF18000C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q5y8UPYb;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Py7VOBxcd4HwAc7HHDB+PTMRXMSLHO8b88vcAnVEU6A=;
	b=sBHDxHSnEUzwJWWpvdMg8CeSi94Z9qItXoaHdsvo7+yeYeh1RoleK46ZpFVicLzxmb72Mt
	dreHFDBUu+KQ55ADcSMtzd3o2MnT6OIIy8A3l/OPFr/EC9FYeVURXBZqtL4UZ970/qkSgI
	GIGlpuxvCm+3PiJj6x7kymgNKqgy4+E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q5y8UPYb;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194103; a=rsa-sha256;
	cv=none;
	b=b++VqxMxa8jjMMzbrmV6MWVfqVfe0CDHo5dHp52Uyycc7bKi2L1eAGIAd5K5oqI+pYM2ax
	x8/AYZEP9pfcV7JuBL4mTYbW1GxYtrAo3ZFlFcjJWdTvae86D1XWH+T9cQ2e9menzZ0pPP
	SWofdrZRP85Y09JEnZPLTCakKk/VaQY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id ED6975C71E8;
	Thu, 14 Aug 2025 17:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7099C4CEF6;
	Thu, 14 Aug 2025 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194102;
	bh=0mJoy+46tPnckyRiCMrZ6rM11HgiRAqoXhfeDURewQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5y8UPYbkB2gzf2uIya/X3vdHYBLt5p8f2+4LvAOXumYTMXCUY8KcMUO+hVWuG5Mi
	 7MzmZa8BOiq3ncXs0zot46eTEMUqsrH0jSfmEBc4Rd3RC/EnHrCaD8bS0umwGI1rMd
	 UdLZ+i6qVKHnzlk0T5qsMDg7gCo2PKlNRDcnn29eXsO4dvTPBeiyKX3kJYqrunChzP
	 vBTtaqwfzFacD2KSsvNKIuqP2BySwh9+2MLpaW2otrJlck+iVxAf0mH6nSYGwNIHe7
	 pVOlSpgYbdrZ6NMFd3ZlatqJdHDz1ybQq38chzBmAVKpPy4QK8iQXExLGVHCiU/RcX
	 j/D9of2rZm+xA==
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
Subject: [PATCH v3 10/16] xen: swiotlb: Open code map_resource callback
Date: Thu, 14 Aug 2025 20:54:01 +0300
Message-ID: <be7c97a559d2482c99e41b7714400934251c53cd.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C05CF18000C
X-Rspam-User: 
X-Stat-Signature: ppih7knfuy5jdxn7mbg4r3cxksugnmm5
X-Rspamd-Server: rspam09
X-HE-Tag: 1755194103-308683
X-HE-Meta: U2FsdGVkX19uGpJq1ZIXaFNjBOXMUGBHNSwxxeXOswv7O1bkI4RAccIX8FKfGJk93Lj2zOvoxAwJ9m6SHeKNze7LPF4U5lrJg/rO35VZIbdVi7DyeQsto3UHD56ifegdd1RdXTOCFJsFGQZKoi/SDLSmCHU0uWVgwWuXrR0ziJWetYXzUrnKcr8BGPlrZP1LTvPXAG+kS8+sOLfgRr1K64hSHtDcmvjtz0OGw0fBcIl+f7NgM/yjQlBnLOHyicgZQhF6y3tSrTbTnyHvjpZbe4sOc7YYBrVIXzFQXvsuIo7jlFTQFv11VpPlYkSD0jEssBwprhsokqjZtgI2FrBVBvHRIxtG7XTjUbvnNXUnBvRRI512MOny3VSa921E56/ghQpieBMg2v79IOEOPFzNDcTQuxxpkF84Xaaqhpi3tNbsEzlzP9CU1zVirxSUaHJkh+cvqODk8kIJq3hcPY++JdHb+U4OBdYL3TtI5OnBdLsrMVaasjaa8eyZojqWZNEyU3C4Z/78D/0okOlCPJ5h6ECo/12PHR4A6EdCV1a7kMzlTazDVX8cm4LDpz2wdsDTPZxMonxq9yDesOAxfmwilqIqjqhJ/RBtbR41X3PHfyMyCVoi2SsA3WnpdpILg2wZmLeJs2t5NP982OLN6ryXtvdYCydwuJbrU2vA2elRfeC+w2QBkwJ2ykyczE5DaQ8HnIecBj5RNr1F1TEPbWwMvI08om5X8CjAe1VRmCXrzFt+tVMqHJ+EQkyGb/1CkYs893i6OojmSEbHk6i8MDds3UJ4O9CjnATKHDIqf4E4gc6fnNZgZ5YDoZtBIY+Ts3UNFWzD548cyUJveaxv5mQ2hubj9Lhhvkvfc7IrHeT+i8dfZcKLwMdoUiQZOxWWY8cd/5PVdo3ESEor+ncVWr8rjoBmM3KmwDx1C/JEu8WaDo0/vzvBidBBneVYwohdckV71BbgtounLwPwunRX8vD
 vd5sYpTS
 CsZUTKiY1YJLEMn75qM3LS36AZuBD4QuY9CYmcAF3ZLboSEdAo45kzduvPr1gBYQKBRM8EEYSQNzxmyWD3nLPwdYgc756oQBvBC23OmHm8iGFbBFgWXfM47IvMfqUUExLhCFDO1USNU5Kg4b7TpeKUv+WXHaCHMMLF5bsLNH2tIN/8lo4tldKUBc8jlBsLwSjsAFKAKnEccVRUSektGhqEGMr9+HZEOxlYrSfraLiYt6hyJceW2jnov1R4TCvgeQUVH6ydQGNPf7wVAgFfVJD3HtYW66/8EClTCG0hOLVAVuDe+7kBAMJN3SvySFrJIATe7ib1R2WGkA3/3LHd+VdP/nTKGtczI2+KxVHBMZyV2Y5xJPxCYetPPnAIoJeAAm+ctCK5EijKJaORXMGcjCSFerRlDbjtDLiO1rJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

General dma_direct_map_resource() is going to be removed
in next patch, so simply open-code it in xen driver.

Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/xen/swiotlb-xen.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index da1a7d3d377c..dd7747a2de87 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -392,6 +392,25 @@ xen_swiotlb_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
 	}
 }
 
+static dma_addr_t xen_swiotlb_direct_map_resource(struct device *dev,
+						  phys_addr_t paddr,
+						  size_t size,
+						  enum dma_data_direction dir,
+						  unsigned long attrs)
+{
+	dma_addr_t dma_addr = paddr;
+
+	if (unlikely(!dma_capable(dev, dma_addr, size, false))) {
+		dev_err_once(dev,
+			     "DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
+			     &dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
+		WARN_ON_ONCE(1);
+		return DMA_MAPPING_ERROR;
+	}
+
+	return dma_addr;
+}
+
 /*
  * Return whether the given device DMA address mask can be supported
  * properly.  For example, if your device can only drive the low 24-bits
@@ -426,5 +445,5 @@ const struct dma_map_ops xen_swiotlb_dma_ops = {
 	.alloc_pages_op = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 	.max_mapping_size = swiotlb_max_mapping_size,
-	.map_resource = dma_direct_map_resource,
+	.map_resource = xen_swiotlb_direct_map_resource,
 };
-- 
2.50.1


