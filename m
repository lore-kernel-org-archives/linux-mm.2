Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E357FCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F87A8E0019; Tue,  2 Sep 2025 10:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D00D8E0016; Tue,  2 Sep 2025 10:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5E18E0019; Tue,  2 Sep 2025 10:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2B28E0016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:50:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE2BEC020C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:59 +0000 (UTC)
X-FDA: 83844594918.05.A98EDDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 61D378000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eiIBn3T8;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+KXvB+QEcDzAMb/9fx1ro7jFsDuULFhvrraHykz/N4=;
	b=bMrfQ+QwC5x76om0n636+yo4w9hLsbTn3TCzP6VtN3fW19qg+qxnPOhzksrvCBw0+FciF1
	U0OknMBAPpTZCUlYvtv+vjCOMpeeyY7VY1N8FS+xHYdZwIZxoYJrKahGRJ3GmheyvKlCpJ
	dUGQcXtxKxA3rZlH7AjwYIH3df83PXA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eiIBn3T8;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824598; a=rsa-sha256;
	cv=none;
	b=LRmXrL466rZBQAhKFbUZ/i0pqNxroXl/ds8XGHoVdvwCTgIYyB425R6u1JUmwSzW6SBjmd
	DRV2vdPy2/hW/yy8Ir1V7IgmttBN24fCyuioIMXFbuhA0BVFmHMjVXuSHLraF3mciYnGJm
	LxAbHtcVvLsCmc2K+cAtQwgxU1EFLhs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E282C6021C;
	Tue,  2 Sep 2025 14:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E4CC4CEED;
	Tue,  2 Sep 2025 14:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824597;
	bh=/+yFJK+B9QWHuc4E4Qjbxe4FKpOF4Mx7ckvNMqksRwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiIBn3T8WJVWsk3+I+fWd3PcxI0MCgzuCoUFUQ6X0tpaWBWbgKoyqfqOHBiWDIDiz
	 8p2HzbdfWqrQ60dofPqEdpLkK9IHTbg+v0SJZIYuCE/Og1VxxZlScreKdr1eSpD3sv
	 /lx+bgPY7bT+Oe8q5/ipZoWvP5MZL/8U72Kogd0uDRyxsAmDtlwDjYXaLUb/vJvMBs
	 v49CTWymtxxZQxWHK2HkfHOmNrocouCJRvv5qbRPaGPjvko9idbzbdGVkH62OwjqKI
	 vcrbLiVodBbFcdGUzIrgeZ2fajxcWR0pq3lieMm1b99+a2xYHhXEQceE1aYKlKJK7C
	 vmv2Md05FkfjQ==
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
Subject: [PATCH v5 10/16] xen: swiotlb: Open code map_resource callback
Date: Tue,  2 Sep 2025 17:48:47 +0300
Message-ID: <7e3225a24df41b483d60d87450b610b399bc15ca.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 61D378000E
X-Stat-Signature: tjrz4rkozpgcuwm88rwkw89c47jneipw
X-Rspam-User: 
X-HE-Tag: 1756824598-905711
X-HE-Meta: U2FsdGVkX1+B4A7wqJsc4pVwV9l+5vCI9Ph2I4if++qxBriVKInpA0Np/5YVEWTrAkMntuFdTy+BRo74KrijSrCxuJ8cB6Cw46a76SEcF6QVvrjq3H9Tf8T+aNYlx/lbSJW+3txxz7/rUyVlmEw8V+Dz2G3NOWF2JqWi3BRM+WvXdvTfEo8y1zavdPEdChwGL7DAXtEDnDCqKmRcl6FzQz1PV/ClYQtg7BtkzD2UfQ3WAwMz05xvG91EKeGJSnVJ8Ve79L0MoyJO64zzUkjeNJvoSe9CUSopY+XxMW0w8RoqfnspAkb1GWWXRYpH0yrLd0yX0w9PgIB1Aeby+UwkLE6ldXp6pqb2MEZQBpqLjOvzQg+qhc9m9tZRVReWjJh04JvtfxfALJaVnt49NY9GEPUH33EotRG3A1iokURpicAB5byURTgyCqhXZK5AousMXw6y5+ktM4WFeeXa5+rZC8lg0vZ8YolF1dh2dQcgl8n4R0idov+bKkDuRgXHpkTw81Gi3F6xFOOdRAv+E+CgRkCOERgoupyLnpGhA8r+l6m1p/pr5WiONegr2Uf4AT01Q3KJKcPgPH+nfvlD6asCC5lRzxUzVMjLvDtueSXwFgEYViO9Vzced6zcXn8rPjWnnatmGZd40nS1sGMpt1ZF5nKYbdxyLB0WypWgA8lFi9jrzuo12NNliUxXPyyYkB8F+4VButuojtKhCMsKz8NNHSgbVW01w1363Km66hiKKCDCm6XVZPqio/aRBaxmUalwBpR1MTCEFwiw0wqiogDC85BGmdR62Q711FJ1P97LD2fl4s+xdPJ7J6QczfPitTpUqQFYki3N7cgTxBIi9zIPg01Dad4dLHMfks4p0E6jV5aalNn0iwLFMLKjgCfeU0y5p3kM0HN05WoxwTPrMpNhjeBbQjuN7D6EnHm6zix9LXOd806xvwfXB4CGRhkSjwDktn76/Ijgylfrj9Fh30p
 35Gh1TuP
 82u8VSidTbZsq019Y3hNpYuTw4ORus8E+ZsafEDqEtOZOcixeXR2L6jl0DrSzAKYLS1gkuRybURUedmDDmoI2YNGxAtaSqRbovEcp/4HgjVieXZJdl5+Crc2ttB6MBMlpFp3lXL29B+/dJ7ckQWxOtTlYQoAxbM9huW5paOWFOIBAXpTgmEuBllUbdtaJwZ3pa6QWcfA7bmpSN91RSkvz4JzR+z6/XQO01rp72Jxh+LA9+9qLOcy2eoTsDmkkUp5GSZ5UveJlVtzF8fU0cCKv/ynzmfGvRpx5+HY9o9Y+hxECF64XnXJRDvHMioBBz9LqtceogLGBvPyR7Smb5XbeF+9sdNKpijeGh/NLfxXBDYceiyMmGUWHmguvpli2ru1fkST54QMw8a1h7MwzaVNofCZZ8g==
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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


