Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371AFCAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731C88E0001; Tue,  9 Sep 2025 09:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1068E000F; Tue,  9 Sep 2025 09:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7D78E0001; Tue,  9 Sep 2025 09:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 401468E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:28:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0273859476
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:33 +0000 (UTC)
X-FDA: 83869791348.21.1121374
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5417F4000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tCpUTcP9;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jDbBJ37dc+Sn0sIm6dEeCMOCCyfIxOldox5rGsCCSk=;
	b=ysMFizpUzSpaRfr4CQBJPs3B7op95E6mAX97h+0KHEoprfG2a5rHz6knF3E0TE2sVLbaeZ
	0FIvZYKToSuXBDvTKPaytl/eTJcuuxoHliBmPOt/knqxucdwqqBzKFfV3ebk792T/i+iX2
	d3fsnebIA69Opa2jTO61UKn8kFjNPXs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424512; a=rsa-sha256;
	cv=none;
	b=xWoqykuNekBS6FjPOFC/+dlPptUwhNn6m3SfzFdflZ9eoxcbYzWnN7lL3DVSJ1fZZJB0kP
	Gx0/ZSQSLSflek553hLmWjXFDmfI5XVvda/A1yWxc1OpON/91ORhZOkR9REutSZGjH6iJQ
	L37CQHEDNCswQjddWM735ZZVVuHE/jc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tCpUTcP9;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D46A36022B;
	Tue,  9 Sep 2025 13:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE634C4CEF4;
	Tue,  9 Sep 2025 13:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424511;
	bh=4mltAvyMabIGEImaWuSSJtalttkzAHCWh/Fw+6N32DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCpUTcP9jO+9dsDDMtGfIjYcTNxitYgY+NyJLSaMvdcTJcdQ0eSFy/DQmzBDm2ZFR
	 GrUGVtXFkVPPjioBPZdc4zSec+IoGRCm/dW6ymp6AA5RlfNqRUUd7ZH9DBIlr6R4W7
	 IEsUYyFc07xgmZuhDfMQHV+BCte69Vi5MSizfFKTtm+tTWXqLb0Ui3bSWuWJ45Iw2Q
	 6f/ensYXk8TsYGeyrMrF0qcfNbx2ZHeDWJZMokK2P3cpAWKpMuXdcKrrY8UcJjMM7s
	 uks/fzjkj7BLsj+kh+MxLEhV2XiEu6To6Ul4To3CgbdtkzwXIwBZNHKVr8p0u6r5LE
	 ifao53nreLEHQ==
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
Subject: [PATCH v6 02/16] iommu/dma: implement DMA_ATTR_MMIO for dma_iova_link().
Date: Tue,  9 Sep 2025 16:27:30 +0300
Message-ID: <17ba63991aeaf8a80d5aca9ba5d028f1daa58f62.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d9sfpjkgnkjux89h6my9zfx9oem7jc1q
X-Rspam-User: 
X-Rspamd-Queue-Id: 5417F4000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1757424512-325661
X-HE-Meta: U2FsdGVkX1/irDyQ/v9O8Us/mDuSwEOmkpd+I4lu/m7z3+4CkYS1sExDGQdlHjwuJJqo9yY9xN6L3nDXoaiGOuJzrewzWOXv5Tu1FpzLTMfxzm+fBeEcjn/BScG1FIYL7Wo41jQH3UDHcYgdrUzNWHcZ1nzNGwzXk77yrzLW1jRHzEpjLIm9ellG44NjNJUbgguEG9wFUDK1UvHwsuSPbd+mt0kLDrgZf28ZJ5nOhQovVJEuhllpBJX6JcOxwBuTmCIusUEJVWj6V9oimlLCdjHqBey1j8KovPiOgpoFC5UgE2/OcEXdZIkRAZ3IXEhT9bqiGxencBssJG7HZXMXxu6Pzux5dXTvJRDAKhFdFrEqoJ1xAmFzM2sW5SykVUFIwwuYQ+yseDgJpmzxlItcZjPxf3IBfqrXZYPsS6vZFh3Pc6jWQh3F6iJ0YXjs0lItVQJmsfuY97dRT+2mJItedGOIyUErn6gBOPhrdd9io7J7Q3/zpiJCLaeNAz4iY6pVp06tJ5J4uDD5q6+z7JQ8G3AJOERefZGRn3m1Y4jFNUBA21YBxrNgWwQU/fNDYE5wTFH0WzVBuJir4h70EROqkUxLt6+mqSda3iCLlbV/601P9nEigzSLPTspgla8oeLDN7DWX+SET9TIhcjsgIFqW0RktgnTlDqZ5UAMefBCepVA0ESgb8wRuVIAKYkCrW4CedgVflu4DGZDoZoSuUvRLDIKq1QdSV5VYSMOAndwhOg4gTinzWfIiuX4ESxgrh0T4Q/+g5sin5xF8Emioie0wK7s0JqAb2wvStTnxNiZ6wPFKt2dALf83ooSicHJBgK51riUdyle1oakr5bEgR+GNcBEoxjW3kQ0VDwbFwPw/o+NCedlQu7t3Yhn1lWgfZ+ETmrUo278tpegCTLjTUtssL5ull7LV9GyhHf0t0yknq0+e9hHAFP7eF09RYNFMV/9iSbG+b0d3JnTAfMO3pc
 tyvPK321
 BzDZCDyAX1xS2mFClklY6eIQDo0P+7HSKyRxnCFHXAH4WgPKI1FlFtQzBqZzc+xzPFFl8ljZW0w03noCY6zq33fBVTzzqJSJ5IEcZSckmKl3st6BqvC0Etylll6OeS/SJNX5F+QYaqHgj/wkXy5wXiJ1+CfbKOYRRAWsiHxdDFS/noCtIcLhkJcAhK8uT7rroyfPJr/mKlOacx4RiQUX1DiyTQMcIw5fn6XpCZmDZymPUIn6ZeFu3N+5vo49PLXYNP3wEZJ/7SnxAJ4ZwhUHthCO+ibTfAgHvljgtL/Rib6udgjZm/i6ZhKcz8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

This will replace the hacky use of DMA_ATTR_SKIP_CPU_SYNC to avoid
touching the possibly non-KVA MMIO memory.

Also correct the incorrect caching attribute for the IOMMU, MMIO
memory should not be cachable inside the IOMMU mapping or it can
possibly create system problems. Set IOMMU_MMIO for DMA_ATTR_MMIO.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index ea2ef53bd4fef..e1185ba73e23a 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -724,7 +724,12 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, struct device *dev
 static int dma_info_to_prot(enum dma_data_direction dir, bool coherent,
 		     unsigned long attrs)
 {
-	int prot = coherent ? IOMMU_CACHE : 0;
+	int prot;
+
+	if (attrs & DMA_ATTR_MMIO)
+		prot = IOMMU_MMIO;
+	else
+		prot = coherent ? IOMMU_CACHE : 0;
 
 	if (attrs & DMA_ATTR_PRIVILEGED)
 		prot |= IOMMU_PRIV;
@@ -1838,12 +1843,13 @@ static int __dma_iova_link(struct device *dev, dma_addr_t addr,
 		unsigned long attrs)
 {
 	bool coherent = dev_is_dma_coherent(dev);
+	int prot = dma_info_to_prot(dir, coherent, attrs);
 
-	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+	if (!coherent && !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
 		arch_sync_dma_for_device(phys, size, dir);
 
 	return iommu_map_nosync(iommu_get_dma_domain(dev), addr, phys, size,
-			dma_info_to_prot(dir, coherent, attrs), GFP_ATOMIC);
+			prot, GFP_ATOMIC);
 }
 
 static int iommu_dma_iova_bounce_and_link(struct device *dev, dma_addr_t addr,
@@ -1949,9 +1955,13 @@ int dma_iova_link(struct device *dev, struct dma_iova_state *state,
 		return -EIO;
 
 	if (dev_use_swiotlb(dev, size, dir) &&
-	    iova_unaligned(iovad, phys, size))
+	    iova_unaligned(iovad, phys, size)) {
+		if (attrs & DMA_ATTR_MMIO)
+			return -EPERM;
+
 		return iommu_dma_iova_link_swiotlb(dev, state, phys, offset,
 				size, dir, attrs);
+	}
 
 	return __dma_iova_link(dev, state->addr + offset - iova_start_pad,
 			phys - iova_start_pad,
-- 
2.51.0


