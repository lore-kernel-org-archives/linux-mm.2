Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC54FCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC97900133; Thu, 14 Aug 2025 06:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFEB900121; Thu, 14 Aug 2025 06:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C800900133; Thu, 14 Aug 2025 06:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3FE7900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7B2F1A064B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:29 +0000 (UTC)
X-FDA: 83774953458.27.25F4A06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1D25CA0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eJTkq+GT;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Py7VOBxcd4HwAc7HHDB+PTMRXMSLHO8b88vcAnVEU6A=;
	b=P922HRj67BP0w5PyhiEZ+mU1MMjerHD/PG07lWlozm8P0rronyueDQOeKAKZDv7u4F5PYG
	xfTEEzMb12aYqnVasuXUulo9ip8zTqFw7tYQ97puUh/XW/yYAoGLb+zpha+sT7qEFBfa2s
	VoeKQlJlKXujCL3zgQMpGQriYUBFags=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eJTkq+GT;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166468; a=rsa-sha256;
	cv=none;
	b=jOxzrRXbUz6EdUXsZGmf1rheVaSqHRW3IZywomqrlFHC7e41K3qNW2EEFAFKu9yIG9eGle
	xMosozo5FJD2vCC/lITFuiiIM6/c6IMX/Q+OGc6E8eEUzf2FYH0TcE2i2ZD8543Rpx/qzO
	dWq02fd7CbHujGOgQ6NnsbVBIaQKIzI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9834F6020A;
	Thu, 14 Aug 2025 10:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAE6C4CEEF;
	Thu, 14 Aug 2025 10:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166467;
	bh=0mJoy+46tPnckyRiCMrZ6rM11HgiRAqoXhfeDURewQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJTkq+GT9lPiH1BMCYSYdr9IyCkKMaQqDKfwPPaRCMkbD4v0h9YvH91nKWU1NH6K7
	 I5BMIh+ts6dGIE4jr3PiHYNWZCZBovmGAqljV0Jx+HIKKGLbNxkXWTUSAWreVqM7Wn
	 Ff+yBy/tsnBCBiOSyTZFf4TKNIrSOPU5lbv4tT4dTtKD3ycTToNWuUWMRWF6V3Lc+x
	 z3E7g/NbjTu7bo8sOdAcpfBghsDHFWLzmA1Zl7LFyuX4jEKPi7VRRawDPIUw33ytqv
	 LZJ5VBTX7uvK57oduYiIJRUBvBYgp3d3u8K5OAn/LaIt2pXtt2VHD3V3k9To82OzIa
	 qqUQflDMHSkCQ==
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
Subject: [PATCH v2 10/16] xen: swiotlb: Open code map_resource callback
Date: Thu, 14 Aug 2025 13:13:28 +0300
Message-ID: <972e4cd98b0d3683e02d06b7a35a2c1d76a226e4.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1D25CA0002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qtyys14nj91tg8xor1jam19ozgdh3ctu
X-HE-Tag: 1755166467-902988
X-HE-Meta: U2FsdGVkX18OywlNwM6QYPVZnWCyS3TGee5N+lAuBO7SC81X1YJKV3QmS/fjNDPsdDvtgglkox1yz5nAlskaMvPbly+RMB+upd8wEwpylp8i2BrxMrKzpgJ0QNr9WQdQ6f3jBa1buoXsya2HQiuaq6CKpazyWEtH9RkAlI0ayBODfj0yqxYukWv0aoQJQ0ksSa77njSQ0mSKjizfT06IXH9J7ELPnw6K6y1eXrAoKZIYEU3ub/CEGIdW9cGNGkF2/KxtkQefLJHUIUQgV0Y8IdEWaWgx+yt1M18Wc0SS3GVLSGQZBBDhn8llX+jxx6UTlfLmU2avKWJkR9Q2SqY9DixPO9QtVt9pN4q0N5qH03I03Ybv1EE4DZ4UBHGJ/6zs6hQKLM1+fvl4W/zi9TfQ174AufBatCSj0Ajy12ZsdSQ0lTptbZxiDLGqFL58SQ9OAr8WtZYvhsTUXoIyA616x1qtgavi7snYRDTR7HeNExdZ/QTPm7mWnyLkxExDjPIQ6JVoRUXCYKFc1r0tB0deR9e2qtQqcZXcvn1q7UhmOI4Shd53khCWTLnmou4zYCcImku2gfdH8kFzti63FFJ7d2ojf8TLMAT9UqOvASn6nigwVC0J5isVAULGvbGqYGCd5t4ceEZcgFj2GNKpBRs2VLxdiIUso8NI5yn/vktE3IzNp8MEgmxy55kQFY7EXR8FHApcKczroOWjkGk0l4rAfWG78KVIhZyGJxxobiLjplhmlqEo8e6N4Qr2MM84eFhMq2gSusWdQUrJ8NJCbaeYQotJB/Qzh4H0FS5AVJ/g//rCn4A1g5kDYQElCQfxgT3pauRcgNGDftPVkJXaAeHSBlZfRgeVsPrrWKOeq4uoQXsPfgxg+Q/HxetzGCYwdShOCj+W2JK43F+xm6NX0juKZUTK9BE5lGZaEIr31FcdmiDLDeOeUQz3hL6gv6H21Le71qg73RuYGpnCmzWF8Q4
 //PDLtLV
 GKUBJiw0Qpfi7vFX1I7q6tYbPrBwXSiTDxOsRzcI57b+QI/+ka6cPlQSKLJxQqrfVTX5uS46HZJfUkU5qfHCHJ3+dCVJTaYORJiG2qrGucvgIJiGySbLAoRhEv0UVo9BRwcMy//liTG1zFvC8uWxFt5t/WHMf/zGohHRKd0tTCWSdKZD0jXk+drQK+MHgd/tERHGGgWX9P7wdVh7uTedhsaCFF3sr8L4qJp3T+jitcNgHM7xPVTo16edzX80OxVax7wX6xt7KMEdRWuPSnbxfvHSAvEERtxtOKZbm8Qv8bCnXNnKuPLY06f7tyO19BKjyd4r3dsJDSqy9KvF4pHHViT78Dh/2/OgteYpWqsgVTrblcI1h2gQ9DoUi8j1ITRgKnjsbhWHT64Gb32gj0rcNzSrsUg==
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


