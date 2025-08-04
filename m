Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A410C87FD1
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E606B00A0; Mon,  4 Aug 2025 08:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5AC6B00A1; Mon,  4 Aug 2025 08:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4DA6B00A2; Mon,  4 Aug 2025 08:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD7ED6B00A0
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:43:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63F09B7EE1
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:21 +0000 (UTC)
X-FDA: 83739040602.15.794B99E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9CEA540006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QrFIfUaO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311399; a=rsa-sha256;
	cv=none;
	b=5Powibfuo3GzuDejA5BzoX5gUE0M1gMZWLg3RmL1+l7Yp6qkFmkSNS2/Nvf62TUpZ5I418
	/wNYDzOfL0zmBd9Cut0UWbsthjG8RGlqcEN7U5rHA+mypjCK8nvPkpS1toh1+Q7TghuJbW
	2DnbhsjD7LGV+Z9nOHIiS4rwG4EWGzE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QrFIfUaO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AS9Yc3IoSR3Vqk1MHpbcTKCwde8JIMHurGCZB+n6Y8=;
	b=nESLJqwIPPdDw7NRE0x9tpx6oC2Fbs6M0gDhvFBpCznfMU7uJ0kb1xR8kBD1NQsj3iDyzo
	GoUPyXfdfLoCB7Bk537GZYcA89lqPwbCehW43+9q6gqaz6/wzEy5VfI4h1bEz9gtsSBb1+
	2wGoOtXlE43b6dK4xK5Zm2Oser9JFcc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56FE04423C;
	Mon,  4 Aug 2025 12:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B783C4CEF0;
	Mon,  4 Aug 2025 12:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311398;
	bh=rlkoLHmieI8GnOBig0uhL3NMd0vvRWDvv2oEih0mzFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrFIfUaOpq0zgYoSf2B1eOFHhzxa8uJ9rI7ao3LQ15JdOAmXwx/vS3c+eYH6QTWOC
	 CZmPIb28BNkyQUhEkXmvY3ou31ivX2Y6W+QyRQ5lEcadqA118EYMjd4CMO32TmndIt
	 q9x/mE/Grc0mkPr/feAp0D8366SSjD6FCJuMLM/iEpxRFuKKQJHqb6OZAv8QT4n2gA
	 l8UYQWJxtJiMLDORYH+k0vFOc3W5LIKBdC/UjGKILIXxW7YyF57t2tVDzjmI4Hs2SY
	 Y6Y7brOxqet5SSMB18NQiaM/FfQfmONk81U59gW5ymq8VCTWf5/3zTUjdvPe68z/B6
	 YFqU3TERLKLDQ==
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
Subject: [PATCH v1 02/16] iommu/dma: handle MMIO path in dma_iova_link
Date: Mon,  4 Aug 2025 15:42:36 +0300
Message-ID: <52e39cd31d8f30e54a27afac84ea35f45ae4e422.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9CEA540006
X-Stat-Signature: z5rzump44a58muyz4hjmbhu74jiegoju
X-HE-Tag: 1754311399-244675
X-HE-Meta: U2FsdGVkX1+6PfwHxXWVZlCToD4QLbc5F3Kr1o4K4pldfD0Nx/8kEwFE0YhEx98mr0RITJJOdSlQsNNqUFSMVwajREADtjxpw3+cWPmwTz0OLpCJOYwW+z+S2zcLo0CqXponLsZAZS3OlSJN6qgl+2IX0giS0zOsscZZpRahsd9CWt3Usy5HboZJZK2bHA9SmjhzpSg+eTStAUjxEvfv3ynK6cV5Lhz4Q3PzI3QYoTyU0PLGph4ISlosp150ZThXfQvTyJ57xM1KxgsR0wTuJlaGNleETznnDpr1NYcul6jMHl48CsQPEVzwraqHqrtoDt5MoRw4ia8Mjbykq3tqFnOKVG6kyO7qWT/MHsSqfdZmYw5nByxmLri1oPWufk9YNj+mU4jVxk8cXXya3hFpu2aSIi1Q4BxoGzfvW6TC7ifXxFrmW3Oa+bFXdyUXmBEDNoNRgD3PDxTgTKTyFmW+FCvXNiH0JlA8ybjBJIzQHX+wTJhsEpqi3c7LfDYO5LNBA4q4a7SnIJheOn46FTGKL91wJlAs99JRxk8DTVGRHWDWnNVHYGFHoL65sw16YltW1O2w7YH+oJohu4cXbLRvkH/kO/MhOfQ7mLjxRF/l3y0hcZpSMI9GBcq5f/ZCqbeansKMTrLXm2KlsNr5T0vGFSgISvsM09XdqZGTQoGr0EAodOoIgoAV1B6KDIUEVJc/EZ19U9r44PzupJEDPsG5ty6/E0+JEZ7BZskyRBrjYFLToAIJT+/Wbb4kARS5AXC9L8TDgx8CXrqp83bsQHtKiJTk2wy3Y6FKveHAgpqiTmrXcdU/+cLSXcpU/QfWC7lhcYoEyVqqACv9b4DXd7YoLsS9dgIzJjeJjqSTWA5i5L5NqKa7Mb3RHE2TV+fvteQTBoezugqBUun5uMLKxEZAIx0oxhtAAJ7IZ/JIjau7TGEOCV5RFRBzKEQ49rY3WO3bcgQKgUECGthrepKaPQy
 UgufNxFD
 LVtgDW2FLN6mA5eVrfY0tcb5bAoNZEp1/rbNYrJrX3B0+8hgOp203gTtTgr6zOZac9f4uM3icI5LK2Hp751LiFElaAGFgNhnZB/4Bs+4rsIpEsCiRbpmiMXWP4rsVu5pYOHP6ncfePSogbbQjlvBCzSU8GNpMtBjDtLjWBO6svaFSKYKQQDRPihBnzhrGFrUcBogcq9a9XBQTzKMn1cinJJO6jTVsdGd8LTVnp8YYksTteE4qdYhWGFogbVtV/v1J4Vs0sWI1sq3Fa3/b+HiJZ8PezAGr2JWWd51Dsji8ZZVm8X51EcTGrnW3G0UDxGtNo8p5igpImknqDqo3GHyThvqOj6GxW2qwUIpm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Make sure that CPU is not synced if MMIO path is taken.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index ea2ef53bd4fef..399838c17b705 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1837,13 +1837,20 @@ static int __dma_iova_link(struct device *dev, dma_addr_t addr,
 		phys_addr_t phys, size_t size, enum dma_data_direction dir,
 		unsigned long attrs)
 {
-	bool coherent = dev_is_dma_coherent(dev);
+	int prot;
 
-	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-		arch_sync_dma_for_device(phys, size, dir);
+	if (attrs & DMA_ATTR_MMIO)
+		prot = dma_info_to_prot(dir, false, attrs) | IOMMU_MMIO;
+	else {
+		bool coherent = dev_is_dma_coherent(dev);
+
+		if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+			arch_sync_dma_for_device(phys, size, dir);
+		prot = dma_info_to_prot(dir, coherent, attrs);
+	}
 
 	return iommu_map_nosync(iommu_get_dma_domain(dev), addr, phys, size,
-			dma_info_to_prot(dir, coherent, attrs), GFP_ATOMIC);
+			prot, GFP_ATOMIC);
 }
 
 static int iommu_dma_iova_bounce_and_link(struct device *dev, dma_addr_t addr,
@@ -1949,9 +1956,13 @@ int dma_iova_link(struct device *dev, struct dma_iova_state *state,
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
2.50.1


