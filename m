Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428E0F53D8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB876B035C; Mon, 16 Mar 2026 15:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA31D6B035E; Mon, 16 Mar 2026 15:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CFAC6B035F; Mon, 16 Mar 2026 15:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 880F26B035C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:07:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50DDB160491
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:47 +0000 (UTC)
X-FDA: 84552860574.13.38D6EFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 94537A0003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DRyYIodO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9F0/0YFKIQg/pZ5hM1h37PKyle3mw6hE7MlEYQVBudE=;
	b=QiRrWxqIWlScztBk3QdUZlCP5+c/H0VJZd721/70nPyyOvFrVAO7OpxgfWF8MXtnS9ZgzH
	zZDem+j7/wq2y8FDnETcgQNBnUpH5Tomv4qUPltvy+z9XBj1PDw1Hzii83G/i7vMZHIsol
	FyPsjlPM3ym+IdL/81Jv9IB3RqZQO4w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688065; a=rsa-sha256;
	cv=none;
	b=CahXtnUSoet3CFjvUnRpzu/AHJ1/Gg+smKNh6OPCFnogyjsFPyjmYEr2zutft0jzlv/kPe
	yj8pOdlukTJKRZopLl6TbQQdD6Re7lJmL2Zlbc/V0DFbnNbyn55VfhPYPRQf0W5yytz6YX
	CSedczbLS6iN9fLDScXLWquhzoQk6dk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DRyYIodO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B718A444C6;
	Mon, 16 Mar 2026 19:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0505C2BC9E;
	Mon, 16 Mar 2026 19:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773688064;
	bh=ZPv8i4FB+9gmQ6im9/gIYrUtjuhhh3DQksE2tI3ZIHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRyYIodOfdcUjLcCDu/jidDUh2A0CrnVqmtrZoS38nnxbv1K9xKH4U2nERAxw5Dnr
	 xpZMTzOwGgNefLLEJdu7kIACNybDBIMeL2gjYa/WsKkEztHVvNTf3FGyuY67ZRhp+B
	 VVAoPRKw7x3JJlrrtCVE+XCdZ9KBdWNwdoyr/19oYyN0h4MOOzpQgv0brQidAnBnWt
	 IAidaFL/EszVCVmuUZfxp1MrjtA+RoOGA+j/sIW0az0Wpz08Zo769/4qrzdnIx+1mD
	 unjW1nqdLdGReK4dBwDjXVamQtoCFyEea/CaTevOe/aCsHEI+wMr6SICzVMhes72VG
	 AYqyNZR5FO0ow==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 8/8] mm/hmm: Indicate that HMM requires DMA coherency
Date: Mon, 16 Mar 2026 21:06:52 +0200
Message-ID: <20260316-dma-debug-overlap-v3-8-1dde90a7f08b@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 94537A0003
X-Stat-Signature: 1sqwumo6e6dabnup3z3gchqpae756iu8
X-Rspam-User: 
X-HE-Tag: 1773688065-834242
X-HE-Meta: U2FsdGVkX1871/Heux0OrUrTgvBfTps3jt5U+2FLVZcMMyYBtSxtoOUnivC2pgmbByTkL6cMC2sBRqU8lK51ugj+IEzgF11RugZD0Wntb9kV1R43Ccdh5i9S2eX6cPeiXjw1hHjh7+EYr+80KMZp4sHxm4Dl60+kkCbmA0Wv6/H7DItske3e9jqR03pIROWf+V9F6xa7Hjqtt3Jrss9jvqIILvB5HdU83aSuv65SzKY+dvQAeJeC/GsmjFjZOyT81fYyFGgT1RarfYuge6WzFqAfE/GfEOGDsK7K/YSY94J00inuF+luTz0w8g/AwL6CPv/KPkexkZzQm6a2EJY7WhY17X/nSYcc4P+gWalg1lY+lRQO9Va3HVGioAxOihZ60mfNTIcQNaoucxabKSv03xqvCBBMD1vWB4uBeB3f8cnxGTmdz6C0gAahjfEfBI+QvPt+gj6Qc4re2DhtmemKkKG0zqoCh/vlM1xw8aaAUtMAJLbzD04vTsbPV7CbH2Vz44q4FiIQGIDdv8ib1faQU5q6jvyKkbwxzaTXRASY11cAQOEW4v3islp56q85hWCC0+yU376T3/AeM6cppx2gGW2Uqwr+slH3NBpeOoFQwQGvsibTA4F8GOp2eZ2cAR8VnT9Qor9VEvj26953kxuyadOb6ym5s6UqdTBlmYE509LAQppTECkJ8LMoguMdj0vjqNDpyU6Ni7Fq+xmiaKWU92lMjf7TCFds2u1XIryckCKNL7OK5A9LxChRV8RVffOVt/w5a8+OY3ofz9yFt+Du3J9g5OP2me1m89AxUcf/pcEKi2x2mobDqZyfljhAXJPqElqEgDGetq4c3RreDXWYLgFGDQ+0setgMV/Qk2XY2a1C6Q6To47XpuzlwkwWZGeVd+VzLfmQ6ZhWHBlcS4m7b8MjnauZNK17uRxO35WSQLVWvWI/xBlCs1AWOhek5B4nAyhst0DLWeUaE9U1jJw
 uKlkySb5
 pncxbDR0GoUyHV4DQZ7oyYj3tETMRy2eRkImFzHffdYYFjTKJ2xa885b+I8aaPnwockZHly3lqAenKovKa38slYScznt/pEg8s3Uufee3Xs+JTGtvmBEPHOnncelOIulp0mg1cc5nBKAlikcn28wJWYzKGf+pHNZeQXgo1QKW9H4iGCGUNVp+qO4laGlpEd9WftWKOZm5RKdU5BOKwZtZB51B7Gh/MJa8X6/P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

HMM is fundamentally about allowing a sophisticated device to perform DMA
directly to a process’s memory while the CPU accesses that same memory at
the same time. It is similar to SVA but does not rely on IOMMU support.
Because the entire model depends on concurrent access to shared memory, it
fails as a uAPI if SWIOTLB substitutes the memory or if the CPU caches are
not coherent with DMA.

Until now, there has been no reliable way to report this, and various
approximations have been used:

int hmm_dma_map_alloc(struct device *dev, struct hmm_dma_map *map,
                      size_t nr_entries, size_t dma_entry_size)
{
<...>
        /*
         * The HMM API violates our normal DMA buffer ownership rules and can't
         * transfer buffer ownership.  The dma_addressing_limited() check is a
         * best approximation to ensure no swiotlb buffering happens.
         */
        dma_need_sync = !dev->dma_skip_sync;
        if (dma_need_sync || dma_addressing_limited(dev))
                return -EOPNOTSUPP;

So let's mark mapped buffers with DMA_ATTR_REQUIRE_COHERENT attribute
to prevent silent data corruption if someone tries to use hmm in a system
with swiotlb or incoherent DMA

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 mm/hmm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index f6c4ddff4bd61..5955f2f0c83db 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -778,7 +778,7 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
 	struct page *page = hmm_pfn_to_page(pfns[idx]);
 	phys_addr_t paddr = hmm_pfn_to_phys(pfns[idx]);
 	size_t offset = idx * map->dma_entry_size;
-	unsigned long attrs = 0;
+	unsigned long attrs = DMA_ATTR_REQUIRE_COHERENT;
 	dma_addr_t dma_addr;
 	int ret;
 
@@ -871,7 +871,7 @@ bool hmm_dma_unmap_pfn(struct device *dev, struct hmm_dma_map *map, size_t idx)
 	struct dma_iova_state *state = &map->state;
 	dma_addr_t *dma_addrs = map->dma_list;
 	unsigned long *pfns = map->pfn_list;
-	unsigned long attrs = 0;
+	unsigned long attrs = DMA_ATTR_REQUIRE_COHERENT;
 
 	if ((pfns[idx] & valid_dma) != valid_dma)
 		return false;

-- 
2.53.0


