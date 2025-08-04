Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2EBAC87FD1
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6696B00AC; Mon,  4 Aug 2025 09:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F976B00AE; Mon,  4 Aug 2025 09:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137BF6B00CE; Mon,  4 Aug 2025 09:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F22B06B00AC
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:01:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6D101149B6
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:30 +0000 (UTC)
X-FDA: 83739086340.19.7E7F0FF
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01FC9180013
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6NzdtAJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312489; a=rsa-sha256;
	cv=none;
	b=nlcczjTnWgCnREX7apmostmqFR8vm59W8GGTh2CNwyYt0oSy+N2ac+0BQPLizGx2pEfGAv
	jxzDdTGrv7Y5qHOrz1iDF++1CYj+3Pn1f4Twl5+kn12A/ppK0Fg68B72z68MA+shKHtYlx
	taRedsQyhwvqQALayf2t4SR3EbD0Wi8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6NzdtAJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAZ23+hmJ7HhPUUyQM2H4e4scpNdTsZODWi8ZNlFzI4=;
	b=SnRu0WyPxJ1MXnKlxcv5H5v5okazUymn+StoBvd5SWwvFK7+5fnHia0wWMZsTRbpqhwDwh
	4PCZ9DygT8sZFOlbnKgLz//kwLLOJrzqzyJneVEF44133ZLR6za6qujLhRSMLGpCm+M3Ul
	Shcx5i1u/H52yFp0gEqYuAynHo/ywcE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 016255C5F62;
	Mon,  4 Aug 2025 13:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7276EC4CEE7;
	Mon,  4 Aug 2025 13:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312487;
	bh=WJztkfF0BW2A+ySSaoquKg9YWNFPhQS7np0spIG94dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6NzdtAJjvKqDoK99gNW74qBu86eRI6rmFzBpM7IVvzJUQY7rqGAQN18dEvkubRN+
	 Y+m2Fo7Oc72hbCrN1FXqElv4W8T7JunoHZHZdBliXv/iTcRC1rPep8PUQrlubuEuZr
	 cFwuGmfnVgmrhV2o9d1afCl0k/XMtlNsC9nLQmxEP2s24dFZ8n2RnfdUPpO2rn7dOB
	 MoocxgPp8LpCToe04kCbNp1Hzh4v8k8j5zfoFKNLnSjxSqf3tAvHQoqcLLzkSvxwBO
	 AgExQp/Jj/LmCw9WJJmASCHqMVlKFvPl6JCk9IDacM3Sbg4LjdbUwhrCzOddAfA3am
	 cOY6O/a9VKDKg==
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
Subject: [PATCH v1 06/10] types: move phys_vec definition to common header
Date: Mon,  4 Aug 2025 16:00:41 +0300
Message-ID: <b78237112cbc8cd4c52cc5f606f325da768ae8fa.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01FC9180013
X-Stat-Signature: c6ustmw8q5izxxgbwrtazrj7h4soh97g
X-HE-Tag: 1754312488-548633
X-HE-Meta: U2FsdGVkX1/qbhv0yfSYa5hN9CiLJ+swwSAu0jkfdhPChTUc3hJPTjr9kmgPtgg9iD5O58WR6mtH503UpSxxxLF3XGCa/B+qYET9SWtm00GfAQHn7SgKPuAIVIt7N5XxJR3JoDHa67+7dbUsSFb9U5EJEIdqGkHaz6gnO1OQq0ZdrWUJBBN3iNOr0PaOgqNz7hDfc+UY1srjteFiSexKsQWmMtc61ARHCGgfdO+/dQjGg1FfCDoZ0h2nhVYTiPgG5bTXRQzuDqpJIPcBD7phd9rZxsCmK+7KUQ6E9oylJLeMexkG4axF6tbimBARW1wK/PBzFk8XjK+wNyHoD0AUrPmUgUPrKY+3axIF5CcSQ4musQL6t9LeRe5nowEXw1BdIB5oTQo3CbDEV3nOQ610S/XjBZayOmiMVIo0wL3uNbVNuH+Yis9UGMOBs6ub9/HXLuTdgbnenbHnJwYOYa6YI5fip+I+b4Xx4nGk8pZdVuqVW9Xrda7kYDirLc89Tj57VU8y/tdjcbOeS3cp3+AIL1H+6FWLruo+XHnFAFCuh8IGAV0E2Gfuuq9DTfq8K1Hz5dYFBERjy5ktrBamJllN0LLMcH3KHZ3wVEuCtDXCpokYFUykzvwpCLumPOJxj8UIi94ekOeOiX0HC+5E1BonES3oMUTEfNjbrLz1E1WTU/cFjRiUkpdUILLpbrL89WmyvFTyVuqZ27iGEZ+IZLweCLzwjm92uWRauu8x8qtAJvfx41N8T0G2izshjFNxAKlmcW39jmo0GJIxmUs7jGHqxQsL7qHr1FAHmxSKnwIMk6+yI1HvkIjCIK2zpZZreXaXQOViY7qE+M/I/cfZx35CZE8aJq93eJjFj14F+X/dfygh18OYs/pQpfSv2EgNqxCOWBkHSYEWqMnOrZTUmumLMBzRqTkFOzBvqZYoZ3zyGWUZIk/noxxRW7YC++JX2MYwTeDFqHoyHU8Y4aZJOAU
 H8Xb3bh9
 0Jm651D5+6UdS1mO2D8LT+wr1yTmNvzU0BlhTqaYC8IHiIMYQ5J2/nIhFOWaa7wd2p40PuPsdsPlc65BBwjL6cBs90pMSP/OLC5C7Or5GfLnqt+ne0+D3X5uImgxQvkpjNz/4Ws7LUs8a7xcA1l3188CvYH+mnuc2On/xf9HTpGxEnIsxvphDSKV1apP+2XXXNes3eQQ1//7J6P29T06o5dW7lyI2h6vKvLhP/iQcwJgdx8zcyZPM/aTIVH1nnU440k2v0PYss696nwMvP4kKinC79Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Move the struct phys_vec definition from block/blk-mq-dma.c to
include/linux/types.h to make it available for use across the kernel.

The phys_vec structure represents a physical address range with a
length, which is used by the new physical address-based DMA mapping
API. This structure is already used by the block layer and will be
needed by upcoming VFIO patches for dma-buf operations.

Moving this definition to types.h provides a centralized location
for this common data structure and eliminates code duplication
across subsystems that need to work with physical address ranges.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-mq-dma.c    | 5 -----
 include/linux/types.h | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index 430e51ec494a6..8d2646ab27953 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -5,11 +5,6 @@
 #include <linux/blk-mq-dma.h>
 #include "blk.h"
 
-struct phys_vec {
-	phys_addr_t	paddr;
-	u32		len;
-};
-
 static bool blk_map_iter_next(struct request *req, struct req_iterator *iter,
 			      struct phys_vec *vec)
 {
diff --git a/include/linux/types.h b/include/linux/types.h
index 6dfdb8e8e4c35..2bc56681b2e62 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -170,6 +170,11 @@ typedef u64 phys_addr_t;
 typedef u32 phys_addr_t;
 #endif
 
+struct phys_vec {
+	phys_addr_t	paddr;
+	u32		len;
+};
+
 typedef phys_addr_t resource_size_t;
 
 /*
-- 
2.50.1


