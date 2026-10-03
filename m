Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B765CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02B686B00A2; Sat,  3 Oct 2026 17:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003596B00A3; Sat,  3 Oct 2026 17:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33EE6B00A4; Sat,  3 Oct 2026 17:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFE476B00A2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D4AA40A58
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:07 +0000 (UTC)
X-FDA: 85282590414.19.02DD7D6
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7831120002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ASAmvzJx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3N3LBagYKCH4ntk11qiqqing.eqonkpwz-oomxcem.qti@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3N3LBagYKCH4ntk11qiqqing.eqonkpwz-oomxcem.qti@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062585;
	b=tUNZeaE5i/BI60fb+ai4/H8UZAvmcP+pBnov3z5j2LT5hUkEZWIpMFEWUmNV98XIlwCGuz
	PwLNQaIUcrgM3bu8kVNGu72jTpCzks3Ao7C507Zt77+Vi4pEd4X6Di/apMOvsC9AYXKGLw
	A+2D05GzPPli4s/ZKSwj9IYWez5JAlg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ASAmvzJx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3N3LBagYKCH4ntk11qiqqing.eqonkpwz-oomxcem.qti@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3N3LBagYKCH4ntk11qiqqing.eqonkpwz-oomxcem.qti@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8y+NqNGWEVo5m0sdN+ejiIJNOP7rTpNObbOwi7GoT0=;
	b=yTMg8f/aeUoeWirh90py/2+ndIxjFnCvdtfdBFxIxGU+pD/oylFE/hTyIZzD48eL5tXp2K
	88XKcDlQQCRaBg5DWMrANObQ4HG1QaoKYfqI9n67MN0yy3p9BLjflBqQTz3FarjjOib5io
	Zy+zS1qShozX9iUmix8CbuTQSFV9dys=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6ae18a3adaeso964745a12.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062584; x=1791667384; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A8y+NqNGWEVo5m0sdN+ejiIJNOP7rTpNObbOwi7GoT0=;
        b=ASAmvzJx7bzFrspMI45T6H7Fz6PBNnhddxvQhxwJe+qHiQfTNFBDQhzAXhLSB0fe0d
         8tCKPgUZvWW2PAo8KuBs61Tbi/Y3H4pAcy19A6Kng9onrRUINMAbJKFFR9G0Nlh50BkK
         T2VKytJV5dhT87mQKVavWT5Rgi80YykgNwEPlCuceKJX+kM5Y9CuxLr9DBwOkTF9n7CZ
         bZ5Xs4tyTo8hWNxU7XNUQSkwQK8iLiqtxN5sPU76CE0M5M6Mv9INMc3pEIkL2fbtjTpq
         FQx0S4aDGP68XOIHA+woQTsxLbWLNRqmOgljcPYrknWzB+1BkZx1FnX+Ls/6DLwchsN7
         zBtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062584; x=1791667384;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A8y+NqNGWEVo5m0sdN+ejiIJNOP7rTpNObbOwi7GoT0=;
        b=djtE9QfzX6nqlVrqzLbb9nznawg9Yzwa/cSJ1FpApmH7KN0r3RtY2CJZcNcRwshDyY
         kz5yjF7TBfiB/t4m9c3ayh5OeRu5OyjdeLklWPAT1vhfRcWytouF9BnRdFY12FXIjOL1
         EQ5SQm9SjctACro86iSkocfFI/WSb4XZqAnJvl+SHULXnXWf1WeeOqbSvRNdWMZcOoIR
         pDQnoEMYzhxbhzi3f9xB6PESLwDNMsJgQ0BWBfG/UUMMD2G8W5Yu/C1vMb5fhmwCsdRr
         q4UYS8CkWOWqlRIMJ+wzKGdKT9TYjK1+vGkOgzHzhNX+5ACF91yO18RKMEcUJwzHYyEe
         3U6Q==
X-Forwarded-Encrypted: i=1; AKwUvBzgeP4BApw2bIYBkp8n6UKFe4XDmj0yOc1ipQglB1Xnip0qFz0F3Tcy+cxnKrGeSLmZfGNCpvuRXA==@kvack.org
X-Gm-Message-State: AFuF++mnmY7qLrt6iozu/AW8XaT19nZftInycYbc8rKd80tVKxG5cAn0
	uoHVZsbN3dfb4xeQxqQFvwJUn61OOcx2IEmjCrJqJE2iqXn+TBBpMm6MErI+NfNQY1vqBjGf4Kl
	4RouUMg==
X-Received: from edse14.prod.google.com ([2002:aa7:d7ce:0:b0:6ae:2c82:36b6])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:97c7:b0:c2e:22f7:59c5
 with SMTP id a640c23a62f3a-c2e33ef144dmr845653066b.7.1791062583666; Sat, 03
 Oct 2026 14:23:03 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:32 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-14-lrizzo@google.com>
Subject: [RFC: DMA_PMD 13/22] net/core: Use DMA_PMD for page_pool memory
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: r4sbrcjz8g6841s3q39qnxg9wtfyknax
X-Rspam-User: 
X-Rspamd-Queue-Id: 7831120002
X-HE-Tag: 1791062585-745285
X-HE-Meta: U2FsdGVkX1/7LCUvruZ20+E/BzOPrIlGaAylgn+STilvb0uUh4uitMcqgN1u2blwF8Ejqy/pdu4kuvbRYugBWrcqc75SlYaf+upbBCW8VIyJtDQC29spdr4vitQ+dmYkbF6rtaE5hRmgQss0rjXd3kHjwZ2zLOI8+Qjft9clvrLfr8fE+ON2vKlqRHYfdw5SE7JvApUyONq2cSRqQjv3G/Vd+5RnxYL8uBLKdy/yBxJPEkMC01OwVD+1pGPrJn6TkjAVnXfgY7gNIxS3hGXgRjS5zHYi9ywn64vc+dT78bOkWsAO0BDQWJ1BD+0YjJAcWEdBN/PTdmGYoyKSM/busdo3VCe5+TJ/zCJ/uEu7yvsle2Ztp5OsHtLiwnmg4ISviSl+e+3ODgk2In+FQ6SlY1zTbcdqPFmb6CmJe5IYgXKVqDMzhckFOP8Fiwpuqe5k3CygeysThU2eS7ISBtn4Q0iPXndnJ5obpjTzVl5XzXcOES/YAeYObMwGuYSaPF+OjnB31mBN7FuPbgszF6puPyw0FaEwV6oyFd6v4N6kux7Za1T2D4DXA43wAd8gkQ6D1Pn/XA2ti96qf5Vh13R5p6khBK8Ox2ksVNFFmctVOlVkkMlBN29YHjZExRUOo/BMusWGsywKQlS59Y870forCvrvRbbb5ipdBLBqHo6fdnX94H9rbEYCKRFFJtJCOV3osFRh8EqRAqr5vf92yStQfwUaE0I5Dzc43oOizK5ZlKQkVdj3J2yJzS23a1UihRrrF9Ltu4A2GRyaRfxeFTNOUXPiuMl8lDY9jx06gGL/sz4CnHcAGM/y8PhAtDwilgOb3Lp8ZAKFjh7xAub7GfhyZaIMuh6vQBAbgipw55EVUiOl7D2bguv3xkopKDfC8vI9R0X5aTdONa06EISBTR9o3E4FW+R3CcCPpmJ4hxQkXqP2ogqWk6y/7dApXuZuNmpPMFFubOCbNTqmR3pxwpy
 GtPckdrt
 ogtI9QVNbWwB6r76tn4Sggo2W9r9kC52cHzNDMLRHbj3FphKYEeeVuE/boP+0aIR7SRWXT0JMWupmtklVX5Hm7e+aaYYCfZKqzEDV34lE++/I19GodIqI6uMtNBNsz0QRJjE4c+A7FeY8njW0MwxM4h6BHPAAMN9YNy2goQCAo8SX/xCPzvHTxeR24cIlyb6x7Y63APmZvrZ8XXZqXKO+f9QQQRsSh5JOQZVbwLEhgg9u61BJZglXTkQddgY3gQomkxQrLgF3Le0Q6ab4U62uV9YysN1bXlJdd61Nzw9nrx3A9fe8t7wE18vuUl12dlyeFdI4aHHilfqa6V0DelqQQLEf7dWnJrqTnuRg6JWOpheG23x5h1w8utMWOkfV0Z2YVpesdKNM7oseIvTQ6Jn3M5cAxRLIQYMDDZ7nn15ioO647ynOvYK6xE549pf9qRDIJqqy3w2jmbFzAUg8o84y/TL1iyq/PA+IAtW2q5MIqfKb3unF7GnMjJNnrvT0kyhvv9jO9ObBWZf5jJc3DN7z5IFOIigpj85UyQpmRKijPZtxAtZhslYjmzB/ejOzS8F19l28oGkaDQV9MbTfpTIHd8R3oAEh0ZNAlG02gsr1CvgRI9tqduMDvqf1WVkfGBb+l9tDSMcHU8/IF3B+r6dvc0dquiSckufDw+VL+cvMV4QY2b0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When dev->dma_pmd_rxbuf is enabled on the pool device,
use a per-page_pool DMA_PMD pool for page_pool allocations
(__page_pool_alloc_netmems_slow() and __page_pool_alloc_page_order()).

When enabled, pages leaving the page_pool cache (e.g. held by socket
buffers beyond NAPI) return to the DMA_PMD pool on final put_page(),
retaining their cached IOVA mapping, avoiding per-page 4KB IOMMU
PTE updates and IOTLB flushes on replenishment. Plain 4KB pages are
opportunistically replaced in __page_pool_page_can_be_recycled() when
free pooled blocks are available.

Also skip inserting and erasing DMA_PMD pages in the pool->dma_mapped
XArray (used for DMA_ATTR_SKIP_CPU_SYNC tracking), as dma_unmap_page_attrs()
is a no-op for DMA_PMD pages and skipping the XArray avoids xa_lock
contention on refill and release.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/net/page_pool/types.h |  3 ++
 net/core/page_pool.c          | 61 ++++++++++++++++++++++++++++-------
 2 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 03da138722f58..62a5c50dda43f 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -34,6 +34,8 @@
 #define PP_FLAG_ALL		(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV | \
 				 PP_FLAG_SYSTEM_POOL | PP_FLAG_ALLOW_UNREADABLE_NETMEM)
 
+struct dma_pmd_pool;
+
 /* Index limit to stay within PP_DMA_INDEX_BITS for DMA indices */
 #define PP_DMA_INDEX_LIMIT XA_LIMIT(1, BIT(PP_DMA_INDEX_BITS) - 1)
 
@@ -234,6 +236,7 @@ struct page_pool {
 
 	void *mp_priv;
 	const struct memory_provider_ops *mp_ops;
+	struct dma_pmd_pool *dma_pmd_pool;
 
 	struct xarray dma_mapped;
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index d7c88c0b67e53..5774247a06291 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -22,6 +22,7 @@
 #include <linux/page-flags.h>
 #include <linux/mm.h> /* for put_page() */
 #include <linux/poison.h>
+#include <linux/dma-pmd.h>
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
 
@@ -304,6 +305,10 @@ static int page_pool_init(struct page_pool *pool,
 		goto free_ptr_ring;
 	}
 
+	if (pool->dma_map && pool->p.dev && !pool->mp_ops &&
+	    READ_ONCE(pool->p.dev->dma_pmd_rxbuf))
+		pool->dma_pmd_pool = dma_pmd_pool_create(pool->p.order, 8);
+
 	return 0;
 
 free_ptr_ring:
@@ -318,6 +323,7 @@ static int page_pool_init(struct page_pool *pool,
 
 static void page_pool_uninit(struct page_pool *pool)
 {
+	pool->dma_pmd_pool = dma_pmd_pool_destroy(pool->dma_pmd_pool);
 	ptr_ring_cleanup(&pool->ring, NULL);
 	xa_destroy(&pool->dma_mapped);
 
@@ -406,7 +412,9 @@ static noinline netmem_ref page_pool_refill_alloc_cache(struct page_pool *pool)
 		if (unlikely(!netmem))
 			break;
 
-		if (likely(netmem_is_pref_nid(netmem, pref_nid))) {
+		if (likely(netmem_is_pref_nid(netmem, pref_nid)) ||
+		    (pool->dma_pmd_pool &&
+		     dma_is_pmd_page(page_to_pfn(netmem_to_page(netmem))))) {
 			pool->alloc.cache[pool->alloc.count++] = netmem;
 		} else {
 			/* NUMA mismatch;
@@ -565,9 +573,20 @@ static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem, gfp_t g
 		goto unmap_failed;
 	}
 
-	err = page_pool_register_dma_index(pool, netmem, gfp);
-	if (err)
-		goto unset_failed;
+	/*
+	 * DMA_PMD mappings are owned by dma_pmd_pool (and torn down on pool or
+	 * IOMMU domain release without pool->p.dev), not unmapped per-page in
+	 * page_pool_scrub(). Leave dma_index == 0 so page_pool_release_dma_index()
+	 * skips dma_unmap_page_attrs() without dereferencing pool->p.dev on
+	 * late returns after device removal.
+	 */
+	if (pool->dma_pmd_pool && dma_is_pmd_dma(pool->p.dev, dma)) {
+		netmem_set_dma_index(netmem, 0);
+	} else {
+		err = page_pool_register_dma_index(pool, netmem, gfp);
+		if (err)
+			goto unset_failed;
+	}
 
 	page_pool_dma_sync_for_device(pool, netmem, pool->p.max_len);
 
@@ -585,10 +604,13 @@ static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem, gfp_t g
 static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 						 gfp_t gfp)
 {
-	struct page *page;
+	struct page *page = NULL;
 
 	gfp |= __GFP_COMP;
-	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
+	if (pool->dma_pmd_pool)
+		page = dma_pmd_pool_alloc_node(pool->dma_pmd_pool, gfp, pool->p.nid);
+	if (!page)
+		page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
 	if (unlikely(!page))
 		return NULL;
 
@@ -634,8 +656,14 @@ static noinline netmem_ref __page_pool_alloc_netmems_slow(struct page_pool *pool
 	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk */
 	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
 
-	nr_pages = alloc_pages_bulk_node(gfp, pool->p.nid, bulk,
-					 (struct page **)pool->alloc.cache);
+	nr_pages = 0;
+	if (pool->dma_pmd_pool)
+		nr_pages = dma_pmd_pool_alloc_bulk_node(pool->dma_pmd_pool, gfp,
+							pool->p.nid, bulk,
+							(struct page **)pool->alloc.cache);
+	if (!nr_pages)
+		nr_pages = alloc_pages_bulk_node(gfp, pool->p.nid, bulk,
+						 (struct page **)pool->alloc.cache);
 	if (unlikely(!nr_pages))
 		return 0;
 
@@ -825,9 +853,18 @@ static bool page_pool_recycle_in_cache(netmem_ref netmem,
 
 static bool __page_pool_page_can_be_recycled(netmem_ref netmem)
 {
-	return netmem_is_net_iov(netmem) ||
-	       (page_ref_count(netmem_to_page(netmem)) == 1 &&
-		!page_is_pfmemalloc(netmem_to_page(netmem)));
+	struct page *page;
+
+	if (netmem_is_net_iov(netmem))
+		return true;
+
+	page = netmem_to_page(netmem);
+	if (page_ref_count(page) != 1 || page_is_pfmemalloc(page))
+		return false;
+	if (page->pp->dma_pmd_pool && !dma_is_pmd_page(page_to_pfn(page)) &&
+	    dma_pmd_pool_has_free(page->pp->dma_pmd_pool))
+		return false;
+	return true;
 }
 
 /* If the page refcnt == 1, this will try to recycle the page.
@@ -1178,7 +1215,7 @@ static void page_pool_scrub(struct page_pool *pool)
 			 * if there are no outstanding mapped pages.
 			 */
 			if (dma_dev_need_sync(pool->p.dev) &&
-			    !xa_empty(&pool->dma_mapped))
+			    (pool->dma_pmd_pool || !xa_empty(&pool->dma_mapped)))
 				synchronize_net();
 		}
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


