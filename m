Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF98CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856DF8E0006; Thu, 11 Sep 2025 07:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807678E0001; Thu, 11 Sep 2025 07:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8AB8E0006; Thu, 11 Sep 2025 07:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 568FE8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:34:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E89B7B993D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:03 +0000 (UTC)
X-FDA: 83876760366.30.7A70E9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E82840004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=POssaAIm;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757590442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zd1DHGtlXx2xZew3POQGC53F9AdCL5PolyCWESgyYu0=;
	b=ExxKiP2mndWpfXVL5W739Bo8R9vJIatU8OKEs7o5dALZX+LCaH21iGwYDszVAztbaEEnA1
	qbB9Zj1fHZuTEIj74+EuTohKOr957s/hF68UCY1ofbZcV+u9jJDSDcB3IcFzsGUkO4tieQ
	u6lvzJvOiGFphwOKWYmOOoCISuoBiW4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=POssaAIm;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757590442; a=rsa-sha256;
	cv=none;
	b=odyvHb6PQJTN10EUU2hTyNTIO9AR7KDoP4t97/HToYXzzzLHiH3gmSS0J//OeniXXHVYI5
	C9JN84CsVAZC4rEYzOWHBzY7Py7dezPRl2fIxGSCELvGvgr2oWQhGFNOJ+uq4KQcjwgQY9
	9BufZ1X0vpt3KT26R2K4UhR214tRhjI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D393560249;
	Thu, 11 Sep 2025 11:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCF4C4CEF1;
	Thu, 11 Sep 2025 11:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590441;
	bh=4Zq6h9bZhtbBadNPN71BbedaIVCHib6EpkAfWXyEd4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POssaAImuo77Xkm4xrUgHRmzE5nrnqsVY7qXWmRbo8QfaWXz9XAXmJDS3VzukCFi2
	 Glgwc4FjGRgiUvcuxmGo1LMNSDWBUv1kOZcAnhqlS44OSnvfSA9snuKJR/3qS7RJ2O
	 0iPVYxKpYtNLMdHBsq1HAcrPoPmECATRkIljjJJACnE4KpArqZLjlS2fPv8gItmHe0
	 6O60WlblZyoFp+SPvfZBk/sxpDVAjDsDqn8ieQy8M53QlizFKbwe5TED06eq7Iq0mB
	 93iYLrxNFssc8Xre6IRujiO5ImaWLdMIFMXqDrVrMAODCCVpEeIYnEhvGgq5jXfJJ0
	 fKJi4hKoNpDgw==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
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
Subject: [PATCH v2 05/10] types: move phys_vec definition to common header
Date: Thu, 11 Sep 2025 14:33:09 +0300
Message-ID: <84148ed07c52b5220524f3a4a7a81744afe7a52b.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E82840004
X-Stat-Signature: ta8eim7wo86ab347yi3r1dbdnmzd8cir
X-HE-Tag: 1757590442-446982
X-HE-Meta: U2FsdGVkX19Zxl+hp1HdBKwhdCxCji0boG6wyFizl5F866MjA2zDtLIo8oR401bXWgpA7WqfF9//QjGViVr9/AE8FN9CcmWumsYrfH/kC6EXwpBa7MZolhNLW0uXDA71wIdZxEaMt+Gg+IGUby24fADGxybDmKzhJGbNiEp7u+AcdEnDCH0QjzQkkPN6kPAFW11o/bg2CohnUvExbl8OsaTj/61iIj2fd81VyfCLjERurxpcGZeUKLImaFlCAzEPjfAl5XmFgJDXVfyCpT/OlUBeYCeJs3+T3TVluSjCb2K1xIh5TMl8DfsUxDAGG41ri74RFg2luHVO2/9BmZEDC+J6VkbpQwttgq2FUvRQQ399yP6KxZrfmgiob9PMG1OCWoq019Gdr6ZbSpBoegYUbeOSD3H8TrsGqW0quAp4TbIJv82GkBy+d57VTQS2lvaxk4KVVuZUjOAVnt3heeCth18mhlICZxVEjo9P1bQTf5g15cNO0okBSKreVthQ8FuBZBfHFEKTdpkKGkLHCnbm5b9vKM4B17Cs0DRs7hJLXXppzsueKqbEndn2ZVM9iUOCtCWVf4HHyyLvta84NjhnXBarI+yMBJ9pDwdib6zyvseWSM+YgfzE+LCLgpH0qj3dImdqRn2sdscbFhs5dclnCVqFcdTPC5ADgpw9eLMKs9FnJcnzzoZ5RGfJrhfSG+w8uHCfWA1iziudP3IPUoRwdJS9NPHxqVDG9TRoA9mKvVRr5Fnj9BSH7iaLqfhhleV8/3lVEE6pWzhCATuPaFfwgq2kMPbZtjwj96sRjaa+fPJc04ZVh5r29Epazs08/jRtYVGn4mxfGhYUl3YZvS4aQr7Ns6K6HPhOflzvDscGCFB1uSevG0IIsr+lwK190vPx8TYMewOXV3O/7WwF1nVz9fig1E2mrnNCNGNNuA/gSw6pX1lUfUQrQ01k1PgmufJW2sHm3kP16GAWD/lK9Lk
 aQBPd3QB
 th4T1X1VgJEUHBudnEi3zzN6VCdyuh73nfX0wHkO/WEfUnEH8cfaZVVh2VU03dkawO1kN5VA83Y15HbiTLL1o0TL9nK3CKZbyemZVAqrIuIEytH9nn1/m7nmJ5DDoxsf0cvup9ffjpPBRjaS1KAvlgY6N2zeGJ5ge+uN7hnX6JbL29I8RzlA8u2lO8omwqN2+/d3FOdY2nHe3gFLu36552bgQgxnwrbvWNQWl6pBtCigqjRJY61bUvj7GnWOXGWDzk4UylbSTaKTRtbDeEw6CoK9Kog==
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
2.51.0


