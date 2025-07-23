Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348C3C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5358E001B; Wed, 23 Jul 2025 09:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65A18E0002; Wed, 23 Jul 2025 09:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2D18E001B; Wed, 23 Jul 2025 09:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB3328E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:02:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 540E01DB430
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:19 +0000 (UTC)
X-FDA: 83695542798.17.5B7B9D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8D443A0012
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P9okemrw;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753275737; a=rsa-sha256;
	cv=none;
	b=mBlR4TVO01rYMBUfON1RgIhRQh1TJIk47AWA+lv6Z8zFu9Cn/jjJKhR1X1A677di+XI2Dl
	PKdDRnQLCqgn/eSBRnFj4p4BAq2zG7cwcLrM4Sy9xMuu0BVIDiLS00EVOT3hpO7f8CF1yg
	zGvf4W0aHX2ZKy5dvWOMbatM8hccWDI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P9okemrw;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753275737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/052x/6+eERFMk0m3OdEi0IaLU+6H6osBj1nzniwdA=;
	b=zuSeb0yI5TUUCSCablo/6b9lQJ9eiglquVvT1HyxHSRrdGI75fnXoc6FG3z126CbVghd1N
	rFivYA3w2IfWhKL1zpnKwcUNYWkiBx5k6tNwiXjqF1SrhtuuwWeUN6Pc7JowFp8u91xz6g
	SgUwL2SnFESTWlz0gWo3VW9kYIVP5tA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93182418DC;
	Wed, 23 Jul 2025 13:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A398C4CEE7;
	Wed, 23 Jul 2025 13:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275736;
	bh=pIL0Fal3Z10DtV64LPo4xcXkDTiYeS1pLWRBh1Fmrp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9okemrwBrufuczFpKQ4z/nyvZOuAUsniIYG3cqafaRjEVFv93g9VIuiDBgki0mYx
	 pE5Q7Y4okUQrm4OGrjVPt/WqPmzs8WpxvQy5y4AmoWiW9YvwIevxDj3bqFCe7zJ1OL
	 jHB5YeZIv6vBqbCXx1aL1GOiXbIKbUIewNTPuHTVWFYub4JPm+R40hj37X7on8IX04
	 QfALWITdB8aVKkdbV1hXj0S25+yVC4ZcbptopIBhEKrks82E4rExb+hSHqt3Kd7sL6
	 WlQFvqGfRHlnM8Brd6WJQa5xVhrU1/FK2oXlr249aAs3HbLWwGcfYL8+6dfBu+bdhP
	 9EC5hFbBQkFOw==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
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
Subject: [PATCH 06/10] types: move phys_vec definition to common header
Date: Wed, 23 Jul 2025 16:00:07 +0300
Message-ID: <e5bec6fc13ed352e2e00f84adc414e467ea94b08.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D443A0012
X-Stat-Signature: ayy5qyz9m8f8xcemioik9rfr9nzcn1gu
X-HE-Tag: 1753275737-918240
X-HE-Meta: U2FsdGVkX19z65D1R0DQ5zloxbw5FOpF8ziaJqj6noIGGZPF305Y16+uxvkKbC92hFONKB1B55/Wlyp+ZxVo/eYg+BLwpdlG1Cb7wBbzeQetSFU+q884vgRGYd3vI1wjgVwUu8U93aXELqJcfnzdGX30GLbQJEonwN6ej819ykws8MRUZuXdE7mK8D7fROsLwOgL8C+IbPQCGu0br6aE3KiAvjdnucznuj5st0RHLDW2U4yDoNYm35YRMDMyEm2ddObMJbnKUa02XNZ2ZB7rAs/6PG1ii6/fJrXRpdX1nmEIFAXJsQZmYQ2FTofpIOeN7Yg5ELKpqGO78IHLYgZKcKaF3+0x2oZ7XSkazi9FCygJX7gPj+EAhOhkEdNlyuMd50dJ3bO3p6Zm8YcPIUsrXoQe6njBkqjaMFkdDtjq2csjbZtNuWf55X3l799A0dzr/JgHXdk0XF+J0bryZQGYgfbyggdi908KE4RyHMJWwGUz0eqX288FCGfSZLw6tB8kQsjNKmmDmjXNinJx8eMSX+wHibO0FbOzeGOUQrGCsxzCAQ0SEKJ+F/SbZDkEullMnTCV9e82KdPOt4g2S1yVQyuW4F8zF/k6M2P76pKNBEGTh7rdOf/oviZofzn4intB9St96ThQ3VBMRgiDMUYO6B3OqW9dI8KrQX51QT4Pn5zBlY1y+SSzT7UvMugCnPM13IC7pUuKUV+Gtv2bDoDpXy+SEcSfvcnjgru/IHVWpcv8ePGZn4TwkuyrKNhA216KZhddR8S0Qsha7tE5rct4PsdMtEaJS6OOBjY/ENynzTFH33f3H+xB3jZSHdl6uXZrGQo1G6QE74iOOXNsz5k1OGNwLSJOi7BYsU1Enur4r4N1GMF9aN00BmKeRQRvvy6aj2crcYPt0T/z1GAfnk/EZXxK2oYipyBbTcaB0lnDGmZGjpOT6c4/dmVsoPlxR6ga7wP7V5/RoDJcu+I0fuu
 lKQmwD8F
 w4RePOyUv75id3uJjos63GKOP5rUb8TkNkKnGEPQHwoWsOacGNaIwDeT3cWQGUeDJ+vgUbkAtwCj2pEdKFNVQ9m8QaZrF73LR5GYzFNPbcuf3sG5KpW8T+Q2GaPE79fjxrNLpbf9Sc85gu5FFXcTqrCxYAqdn2hR+f0Y3s0x685i8wQHEqka+4/ckODuj2pXTP4h+3b3wBLTvNLQ8jH6EMyyipgZArUn8/xjs3qVnPEX+a0rMwtB4ivYkYw==
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
index eeac653e3f3bd..b0fa53c353d9d 100644
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


