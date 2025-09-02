Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF32DCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349226B0006; Tue,  2 Sep 2025 10:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9C78E0015; Tue,  2 Sep 2025 10:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8978E0007; Tue,  2 Sep 2025 10:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7696B0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:49:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC58AB6DFC
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:20 +0000 (UTC)
X-FDA: 83844593280.11.9552ECA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0CBDA80006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jZmeCwVF;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824559; a=rsa-sha256;
	cv=none;
	b=U4Kk3aN9E0UfV2w2ubq3RLn1LfFWXxt7NMl4EjfFVUMGlM1YH+lz/1upcpm4MHUiNxs5Re
	oksD4QKdKTGOPWZPeRpXebRosGs1Su9jZqW9e/oU6UMjeSoLLIikBJJhm2R1w13VCQr7pc
	3eXqivrfqMjOziCjpEOpXXv3tUmWZVU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jZmeCwVF;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/hlUPkO7h8DBhJNx9gpER7mP0DqTJkgE9FjVOPyX1w=;
	b=j3rseqRG03o7FBSNpwadI1lnWEuhC2LbEHUkMYJQLfjreVTJ1bC1X6A6Ottp6Fon2mNSQg
	TR3C6uoViTmpyhxrAfvl5VVZTnSObn7J1gKbd9BLDrPLJ0uel9BDskPw6BKlyFTaypBvxB
	Odg07kta90xPUl9ephzDNrXivT2vfVg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EA356021C;
	Tue,  2 Sep 2025 14:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2D4C4CEED;
	Tue,  2 Sep 2025 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824558;
	bh=ZQFwkiDPp1GyvHCZ7R7ij52YlSaCwxtclFyfGHPImis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZmeCwVFRuH1q78msLckvRK79MBxGIRsQSWl7GBnGjpSqFOv2UDpkk6433cUWOsEL
	 l9FnZk3/0IIfwIr220SmWYn2k3PyNggQq6bLFnvgo1KPA8d0QkcJIRT0vceLl2NBv3
	 AyLz46HnllepaRbuN6Ht7Y/oPR7+rcoH7rVDA85AS1gdZ8v7IiwFHbwzMgE1Q2HXAx
	 ZKVBRm1t0pVDRP6Kla06+MrDCyH7a11ZlI1r1bp8YNmS2rKCfQW03E6fHoFyIWG1eL
	 Gf1sYErqR105oSaj09oPpOBM+XoEwrPIL4YnSSFSWBAOhlLxm/x9zMzxsifJI16EZE
	 Wv26+f+T2tyxA==
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
Subject: [PATCH v5 04/16] dma-mapping: rename trace_dma_*map_page to trace_dma_*map_phys
Date: Tue,  2 Sep 2025 17:48:41 +0300
Message-ID: <7b4656d5f6392486f28f71ad600a95e6690e2f41.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0CBDA80006
X-Stat-Signature: iu9gq6h9s6opssw7nu1iu71a51cass7f
X-Rspam-User: 
X-HE-Tag: 1756824558-576203
X-HE-Meta: U2FsdGVkX1/eaIhJye+V7tjYb99BaKZ+ccZ9bCr1G8DcP1zpui2nIbcEkYfKHrcbAeMqrC46+ZBji3dbRmJbn3qQ5wVGbJdMQJ0jH/BoggKqvtqfwsf48LVRRkO7fOb2yg5sFnWj4SLeLOOQ7M2F4D5lAoPvHYyHo97Ec1KunaJi+7Dhrr7AawEyOrcBEMokGuD+NrPB17pBtqwlr3IejmJCMtQZpRgts1sCJv88bgYj61NLodhNb/aJndmMTDGd32Ej66n9PooqjncTvM5x8luMxb9wdh8NLJz9RxWKAgWeULNKFtGaFfjAwwM9e/z62v9ObCJ6h8DOWp7WiB/D7labSCBp1ZI6ZErWHkAOcc3amNgXv/hqSxZOkZhpSm8f9wO27rgJlmvpWOohpcTVJuknH7YVIAr8q+gJ7Qgamafkyt0tzE3cq05LxpOJpysjn5TNjg0i2dVUkkTo+eM2VutrXX9x/CALktbmb67t9W2fsUjujzrA6X8ENETwFxOTpvSs7LZ3xcvGFVxVNXO/i9WqWmqNCYBcMILlr5xwvrtwymsDjqwQ0uLUX3ho9ebVOwMWPzMUIV5icKhD06wZFfzvn7MtXxE+lvFHTm6CsVjgwqzKuIQAxmWgkOm7+uYRmVx9zLT/jW/wVxqbROlLxjXCef71m0V7UP5cmFKOTs8YSKanUZJ3GB3Mlo9QZIPNA2ZHVOIpd6auTJr3DsARTfuqJF3XU+OdmYR+1UaQsXqMId4g4qHr9IFdSjNdKwoQ8NEaNsp+bvQ0S3Lk90Lf5I5ITq1q/yq2B1lxJawAT4wKazY1YH/cnuosyUdZPrZPkadvV34Jf4Z/kWKETxVF7fDqqfIQc3R1L0rKiqNjlLumWR0Xuc9hjapIqVozlGISqKPb7Y0aTjm8Ko379ZYQXNkeN68ZWAsatYNPqf6ApLLALqRP8E3sjnLqVL2PJsyMLVVC9/IjkxaiML2HxOe
 9XsA0ih7
 /9lCetR1qcngE3tVAyr/sGvx9hwMKZgPbnREmlJ6ec0HuOgRKzRaUZVjf9ElJzRFa7SW0k/Zt1bBOY73EwX6M+aBHXaqyed12EJek9D8XvPomk46JU09Vb+UUtvqv9xqouc/SSIjQ1ivmLAs2qT/LY1KO+nORziiSMH4cFePU59Aq10bWfyR6erhPq9aE+en0/y7flWHMrwxL7vosTJDO/6VRXGHWkwYgkaQ5KuFST9NyDb/SXNptvh5SXwZHMyasoGZYgFT88gm2/72uPBOQCsUGgQWnPnPJtBFGRQoo+StBhfbUWsQDiQ5624FfbkNKYIGnEj6TRYfsjyhHYRTGhOyqlE0QprpbBrjj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

As a preparation for following map_page -> map_phys API conversion,
let's rename trace_dma_*map_page() to be trace_dma_*map_phys().

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/trace/events/dma.h | 4 ++--
 kernel/dma/mapping.c       | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index ee90d6f1dcf3..84416c7d6bfa 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -72,7 +72,7 @@ DEFINE_EVENT(dma_map, name, \
 		 size_t size, enum dma_data_direction dir, unsigned long attrs), \
 	TP_ARGS(dev, phys_addr, dma_addr, size, dir, attrs))
 
-DEFINE_MAP_EVENT(dma_map_page);
+DEFINE_MAP_EVENT(dma_map_phys);
 DEFINE_MAP_EVENT(dma_map_resource);
 
 DECLARE_EVENT_CLASS(dma_unmap,
@@ -110,7 +110,7 @@ DEFINE_EVENT(dma_unmap, name, \
 		 enum dma_data_direction dir, unsigned long attrs), \
 	TP_ARGS(dev, addr, size, dir, attrs))
 
-DEFINE_UNMAP_EVENT(dma_unmap_page);
+DEFINE_UNMAP_EVENT(dma_unmap_phys);
 DEFINE_UNMAP_EVENT(dma_unmap_resource);
 
 DECLARE_EVENT_CLASS(dma_alloc_class,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 4c1dfbabb8ae..fe1f0da6dc50 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -173,7 +173,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 	else
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
 	kmsan_handle_dma(page, offset, size, dir);
-	trace_dma_map_page(dev, phys, addr, size, dir, attrs);
+	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
 	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
 
 	return addr;
@@ -193,7 +193,7 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 		iommu_dma_unmap_page(dev, addr, size, dir, attrs);
 	else
 		ops->unmap_page(dev, addr, size, dir, attrs);
-	trace_dma_unmap_page(dev, addr, size, dir, attrs);
+	trace_dma_unmap_phys(dev, addr, size, dir, attrs);
 	debug_dma_unmap_phys(dev, addr, size, dir);
 }
 EXPORT_SYMBOL(dma_unmap_page_attrs);
-- 
2.50.1


