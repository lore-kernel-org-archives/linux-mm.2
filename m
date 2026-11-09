Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCCF560A5BD5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X5zn6TKD
Received: by kanga.kvack.org (Postfix)
	id 4DFC76B05B2; Mon,  9 Nov 2026 13:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E1E6B05B3; Mon,  9 Nov 2026 13:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3336A6B05B4; Mon,  9 Nov 2026 13:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0444B6B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08F031A0779
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:41 +0000 (UTC)
X-FDA: 85416408882.07.6A66E9E
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id A76B440009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=X5zn6TKD;
	spf=pass (imf01.hostedemail.com: domain of 3IBDyagYKCGcQWNeeTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--lrizzo.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3IBDyagYKCGcQWNeeTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXbpKNTutM+q8EpPl46Tft0Cw/JJ6ViVyA1KiMY2C84=;
	b=b4oFcgcIm0YgaRxXQNeeGDSYplYhZyTnwtWlKeUSyzEQMbma5gxwnYIuVCJ3wqhHUG+H3k
	a7/2h0gCvd7XkYn7GcILyTtwff1VzKH6lNOv4/KdhuDFTKhoepIeXizFaSq64DtQVET1uJ
	bKdrS/yNl3O4cTLcvh3L6rgs/dVhNwg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=X5zn6TKD;
	spf=pass (imf01.hostedemail.com: domain of 3IBDyagYKCGcQWNeeTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--lrizzo.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3IBDyagYKCGcQWNeeTLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248738;
	b=m5b9BC6DmFRDQQWNwQgRebsDHWhCfmC6hh90ZuIlSWxiWSuIyW8SqdrPYxJQLAqgPOHLEK
	E+c//KNrla3vPvTPl/Umrua7CFWkcfxjJi1TT530oXEhFe2fuXm2vb8cf4JPqzI0WDMD7P
	wrLS4tDiUHW+c+xsLWg93tuSZ/YTc88=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b706aec65bso1054511a12.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248737; x=1794853537; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yXbpKNTutM+q8EpPl46Tft0Cw/JJ6ViVyA1KiMY2C84=;
        b=X5zn6TKDtl6uEnW5J3L5DqpeI9qJk0UAFWypnP/SMe+wX7tg1HLJkKbz5xXi+a1tGZ
         FFe/rO5twf7l9Wn25vC5bxItOI6msfflTmw4Zg6B8AgfFZgrB8EVbeOhDFSa3gZJCkLr
         D/BROcMFQFt5hVheI9mAEOAXkDxNc2JLUu8ZRGPpj3YdJdhbu1bnGLUrSczce2aq3FIM
         a3N2N2QNAV46E2ruRZyCHGRSmNCorqBJhk9waYcV9NSrZh+NEKNIcVX/Tn1q4A1oezcZ
         6CIWKCgm9fc9v9Jg0vRfdA4zBDeBeVgEnOrA45qSLY0SDi0oCOP6sAnXt6r6YieAcvD5
         8+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248737; x=1794853537;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yXbpKNTutM+q8EpPl46Tft0Cw/JJ6ViVyA1KiMY2C84=;
        b=Phml0cQs+1PBPIhAJC27Ev6cDMKffmiscJSQY/Ao9zPSKCsLfypeuDRyTQYMkeJ8Zr
         /9dLFCzW5+LiKd0WHTlqYgSIvd/DIc1tPHasb9leCz76a2fJKY5ZPROcnLUlEtEX7bQT
         lFZSw7a0vTrjeQbWpqFC2qsH8SwSwux9pQe3UIehRn2vVEMkxhHJV9h6DffcXkd1MX5T
         2EUNvj97xljYC+PHv4ASQBHvC+4IDLBI3nHIsYw5cSCSf7/x7DkpaP9x7f5ozYo1gF5w
         tEl/KOELKv/HORgWRuJyHDGPzzjrJKRTctkTikC4Vte5BmFFg6uTQLZxwls7HUv8Ffcz
         Oa2w==
X-Forwarded-Encrypted: i=1; AL+hErEcP7yIYlo2+FxUDImaxTnRBikGCHA0g6iT1kdQesTjDb8iTAVxfU8dt8OT9cEJFn9J8brZ6PCBfQ==@kvack.org
X-Gm-Message-State: APuU4Z8tfJmrFp/nyWKSv8JHy6uzM/csZ/oQBOvk9aspnhMKI0oAjWDs
	cVuY6TkaR89WYtshknMP+P2Dr4rAVCukOSHLHYaK/z31QOkOGHnG4Sc3ONS29M5VzOo3aOrcRUo
	YUemZkA==
X-Received: from edsu12.prod.google.com ([2002:aa7:d98c:0:b0:6ac:c4fc:4feb])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:234a:b0:6ac:8ef4:177d
 with SMTP id 4fb4d7f45d1cf-6b756ad59a4mr348040a12.20.1794248736768; Mon, 09
 Nov 2026 10:25:36 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:08 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-1-lrizzo@google.com>
Subject: [RFC PATCH v2 00/25] PISA: Pre-mapped IOVA Superpage Allocator for
 DMA and CoCo
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yybuosr1zaxroh94k9649fj5qegcfhse
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: A76B440009
X-HE-Tag: 1794248738-476530
X-HE-Meta: U2FsdGVkX19A8cm7k5+5Zn7VnwS5U1kJCQn35clRpNAaRULGzt9rNeiZVkBZur5SwfGU6J28ATfnIZqIK3DdHWFiFRv8MkS1BdsdKW9c3cHwfSvdur5kuWWb3/aVoPJ6Gq9fktTMOAebm/0n09ZrKR9BX/VJD9Q/tUXHT05wS/HKCPQoJ3GHAtzZLI9yRXlUupBvWks8Uv9qzDlUS1tM7wdifSusgHyLEO9rhZzj/JJtG63yeQb48KjSAGVb5tARSjDpNgWsnUE6D3QaIduwtxrM8gZ0eMlb1nSuD5kJX/WUZTWD6P+i4fazILnVHhDSQjyapemWMTIHYX3MwW/FWfAT/9qzS0KDFGD8WrgfabBwRubgrHvQPj5ZWVCattxga2837X5US73M/31iOiutXLhlb0N6tE/9IuH2dw6gspd2F1H1k6T29ZsVlqLZpYnhb9VhIfiD9FcY1KPgkY1SBoYkPq5UNaMuvLPqK4wkSeuy/uiHQxLD5H3FKt69ihjBIKQtty1VbQNsIg6QX4zSuzNixicB6DOdyJB2FmPWzVzbA860m4bzXisS8NYDJ0iJUDTkCNGR63aiePNFNBut2/dfyqjCzGiLGFO3xnrNwdNerCQ9v+VSDd86CXgCbtBYOkwAmhZCBDO8hYm96D0RXBZR2cSqTsKvbdcE/x3oZ2o6RAAz62XrX8U1eTbSRx/7+wHKzCrCoSEYYZggh3wvH7D4zOyUHTYu+NWKTHR2WyakgaOkonP8CLg9Iz1sRyku0VpnpKgIc5gk117dj5krT7u0gFtzyuZlxifzlH4gNEoa+jXwJ9WqPTkm8Ar0QXktDdpEwgpORNjyj4tr8B3oNQ28BhWnuJZd6WW58NC6ycqPG8HznWPswzNzg8++50IRcoWLAr4BIf0OU6/D7Vms4Fd76HHXdveV/gn2mxeey6FSFcKLa+EuJPT4+FGMqPgVi0PX63Fkpf9nwH9/zLG
 6rqlGTkW
 b78wpPgLwUzEBoS45s6UfXCY6tPpHCC4HZytBCXjbufO1qUWeXsqdswHa+Y2/I49YcfvdqdUg9lNcJOIKcGLwVPpkou6JxKWs33fYVTRQMln4N4+ySMOaVZR89pxoSLdcPNwt/fGXBC048Gx905AculKemawYrMMLkgkt+oTFk6TniWumxECaXIIL94FYoAp9wKM5mbpMbkKLdOEQMqNvfcqEYhY8u9ZbOANEkVHWO1e9wt1LfJVSxfaYq7rJchWbf9/QUTZs6/OwwJ4dZ7FyROPbhjd6vv+v6pOD3hXEbdTsbygJ5wV+RIt9uqslUDEmYMYKAtP0XgK39rjgmL6jVkLabCW8UO56IhW46Cp49pT6FzvjLeQa2QA7GzdmjscOubLIZVytU6dLh4MlpVc4GSo7mmXvHYkFyteK6/nX5OcahCVEKuGB1VaKA/vu4rpL/iGo+2yUgARuVyDtLVOWC7moNuCyWINYK3fXsCeOQ92NSfOl793QL6w7eEjHEvX2ircnYgoLhTzzKiMb8GkxESuK0s4uSUIBWDcZMizd9XXZocRIUdo0kyyBchh1aLUGmbleV0DePEze93QtgBW+qvhgaUKh7oP12VPS+gpkdi0z5ovzAIttVrHX+RjcdJstm8PTVC5S+E5X5w1cW+NidVG4mqhbimubH5GtjBsxIwwBWQGVwHxYNLjLoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is v2 of the RFC previously posted as DMA_PMD [0] (renamed to avoid
confusion with CPU page table PMD levels).

PISA stands for "Pre-mapped IOVA Superpage Allocator" and as the name
says, it is a specialized memory allocator. Invoked via __GFP_PISA* flag
to alloc_pages(), it returns pages ("PISA memory") that make DMA-related
operations on that memory a lot more efficient, both in software and
in hardware.

Specifically, PISA memory has the following properties:

- it is backed by 2MB contiguous physical pages, so the IOMMU can
  use large leaf mappings and significantly reduce IOTLB pressure see [1]

- IOMMU mappings are recycled while PISA memory is used for IO buffers,
  thus greatly reducing IOVA allocation and dma map/unmap costs.
  This includes cases (e.g. overcommitted VMs or Confidential Compute)
  where they would trigger expensive VM exits or bounce buffer copies.

- PISA memory is returned to the buddy allocator in background, and
  only after all existing IOMMU and IOTLB mappings have been flushed.
  This removes a significant security problem in DMA-FQ, which instead returns 
  pages before flushing the IOTLB, without the performance penalty of
  strict iommu (DMA) where the flushes are synchronous.

The pitch line remains:

  PISA has the performance of identity mapping, guarantees that only active
  I/O buffers have IOMMU/IOTLB mappings (unlike DMA-FQ), removes bounce-buffer
  copies in Confidential Computing VMs, and integrates transparently with
  existing kernel subsystems and drivers.

=== KEY IDEA: A SPECIALIZED MEMORY ALLOCATOR

For avoidance of doubt, PISA is NOT a new buffer cache, page_pool
replacement, slab allocator, or custom netdev feature. The kernel already
has plenty of specialized caches and pools (page_pool, socket page_frags,
SLUB, page cache) built on top of the buddy allocator.

Instead, PISA sits *below* those existing subsystems as a specialized
memory provider modeled after alloc_pages() and __free_pages_prepare().
It enforces a few properties on the memory it dispenses so that IOMMU
mapping, unmapping, and CoCo page decryption become nearly free:

1. PISA allocates order-N blocks out of physically contiguous 2MB pages that
   are mapped once per IOMMU domain using 2MB IOMMU leaf entries in a
   reserved per-domain IOVA window (and decrypted once upfront in CoCo
   guests). Subsequent dma_map_*() calls resolve the IOVA with a simple
   window offset calculation, and dma_unmap_*() is a no-op.

2. Freed blocks are intercepted in __free_pages_prepare() and recycled
   back into their PISA allocator while their 2MB IOMMU mappings remain
   active. A 2MB page is returned to the buddy allocator only when all
   of its blocks are idle, its IOMMU mappings have been removed from all
   domains, a synchronous IOTLB flush has completed, and an RCU grace
   period has elapsed.

3. Callers allocate from per-NUMA-node PISA allocators using standard page
   allocator calls with __GFP_PISA_RW (DMA_BIDIRECTIONAL) or __GFP_PISA_RO
   (DMA_TO_DEVICE, mapped IOMMU_READ-only so devices cannot overwrite
   shared/adjacent data), falling back to the buddy allocator on failure.

Because PISA operates at the page allocator and DMA mapping boundary,
existing clients require minimal changes. For example, the entire patch
integrating page_pool with PISA (patch 13/25) is just 3 lines:

  --- a/net/core/page_pool.c
  +++ b/net/core/page_pool.c
  @@ -16,6 +16,7 @@
   #include <net/page_pool/helpers.h>
   #include <net/page_pool/memory_provider.h>
   #include <net/xdp.h>
  +#include <linux/pisa.h>
  @@ -622,6 +623,8 @@ static noinline netmem_ref __page_pool_alloc_netmems_slow(...)
   	if ((gfp & GFP_ATOMIC) == GFP_ATOMIC)
   		gfp |= __GFP_NOWARN;
  +	if (dma_map)
  +		gfp |= pisa_rx_gfp(pool->p.dev);

Similarly:
- Coherent rings/queues (dma_alloc_attrs()) are served from the per-node
  order-0 PISA allocator when dev->pisa_coherent is enabled; no driver
  changes needed.
- Socket TX page fragments (skb_page_frag_refill()) use a per-task
  page_frag fed by __GFP_PISA_RO when the egress device has pisa_tx_bufs
  enabled; no driver changes needed.
- Small TX skb heads (kmalloc_reserve()) use a parallel
  skbuff_small_head_pisa SLUB cache backed by zeroed, read-only PISA
  folios (SLAB_CACHE_PISA_RO) when pisa_tx_skb_heads is enabled. This
  eliminates the per-driver TX header bounce-buffer patches from v1.
- TX MSG_ZEROCOPY, O_DIRECT, and buffered disk I/O migrates or allocates
  order-0 user and page-cache folios from per-node PISA allocators so
  zero-copy network sends and storage I/O also use 2MB IOMMU mappings.

All features are strictly opt-in per device via
/sys/devices/.../pisa_{coherent,rx_bufs,tx_bufs,tx_skb_heads} (and
pisa.user_max_4K_pages for user/page-cache folios). Until a device opts in,
PISA is gated off by a static key and allocates no metadata.

=== CHANGES SINCE v1 [0]

I have make use and applied several comments and suggestions received on
the previous version. The changes are massive so perhaps it makes sense
to look at the new code in isolation, unless you have already revised
in detail the previous version.

A high level summary is the following:

- Renamed DMA_PMD to PISA (CONFIG_PISA, include/linux/pisa.h,
  drivers/iommu/pisa-*.c, /sys/devices/.../pisa_*).

- Hooked __GFP_PISA_RO and __GFP_PISA_RW into __alloc_frozen_pages_noprof()
  and alloc_pages_bulk_noprof(), replacing custom pool calls in page_pool
  and socket TX refill.

- Added lockless per-CPU block caches (pisa_enable_pcp()) in front of the
  per-node order-0 RW and SKB_FRAG_PAGE_ORDER RO allocators.

- Added SLAB_CACHE_PISA_RO in SLUB and skbuff_small_head_pisa for small
  TX skb heads, dropping the per-driver TX header bounce-buffer patches.

- Added PISA support for MSG_ZEROCOPY user pages (madvise(MADV_PISA) and
  automatic upgrade on send) and block/page-cache I/O (O_DIRECT and
  buffered reads/writes), plus age/waste-based compaction and scrub
  migration (pisa.wasted_pct, pisa.old_ms, pisa.scrub_migrate).

- Made metadata table initialization and static key activation lazy on
  first device opt-in.

=== PERFORMANCE BENEFITS

Your mileage may vary. Enabling the IOMMU may have no throughput impact
until system components (bus, IOTLB, CPU) become overloaded. Aside from
throughput reduction, one key metric is IOTLB effectiveness. Below are SMMU
performance counters on a large ARM64 system with 2x200G NICs running
bidirectional traffic:

    === DMA-FQ MODE (total throughput ~440Gbps)
    25,757,488      smmuv3_pmcg_*/event=0x80/   IOTLB lookups
    16,634,941      smmuv3_pmcg_*/event=0x81/   IOTLB misses

    === PISA on top of strict DMA (total throughput ~745Gbps)
    22,693,218      smmuv3_pmcg_*/event=0x80/   IOTLB lookups
        30,536      smmuv3_pmcg_*/event=0x81/   IOTLB misses

The 2MB mappings make IOTLB misses almost non-existent because the working
set of IOTLB entries is reduced by a factor of ~512.

=== NOTES

[0] v1 (DMA_PMD):
    https://lore.kernel.org/all/20261003212241.3432303-1-lrizzo@google.com/

[1] IOMMU IMPACT AND IOTLB THRASHING
Documented in detail in Documentation/core-api/pisa.rst. In short, there
are three main costs with the IOMMU:
- CPU cost for dma_map/unmap
- CPU cost and latency for synchronous IOTLB flush (required for security)
- IOTLB thrashing when the working set of 4KB pages exceeds IOTLB capacity,
  causing IOMMU page walks that backpressure PCIe/bus traffic (30..60%
  throughput drop on high-speed NICs). See also:
  https://lore.kernel.org/all/4b42f2eb-dc29-153e-ace9-5584ea2e5070@redhat.com/
  https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10280580/

[2] WHY NOT USE PAGE_POOL FOR EVERYTHING
page_pool is a consumer of PISA (via __GFP_PISA_RW), not a replacement:
- page_pool does not split 2MB pages into order-N blocks or manage shared
  2MB IOMMU mappings across domains;
- page_pool pages cannot be managed by arbitrary get_page()/put_page()
  callers (socket TX fragments, SLUB slabs, user/page-cache folios);
- page_pool requires a single NAPI consumer with BH disabled and a known
  device at allocation time, whereas socket TX, SLUB, and dma_alloc_attrs()
  run in process/preemptible context across arbitrary devices.

Luigi Rizzo (25):
  iommu/dma: Introduce CONFIG_PISA and metadata table
  iommu/dma: Add PISA allocator lifecycle and page recycle hook
  iommu/dma: Add per-NUMA-node PISA page reservoir
  iommu/dma: Add PISA block allocation
  iommu/dma: Add global cap and shrinker for PISA pages
  iommu/dma: Reserve a per-domain IOVA window for PISA pages
  iommu/dma: Release PISA domain mappings on domain teardown
  iommu/dma: Use per-domain IOVA window to map PISA memory
  driver core: Add per-device pisa_* sysfs attributes for PISA optin
  iommu/dma: Use PISA for coherent DMA allocations
  iommu/dma: Add per-CPU block caches to PISA allocators
  net/core: Use per-node PISA allocators for skb_page_frag_refill()
  net/core: Use PISA for page_pool memory
  iommu/dma: Support decrypted PISA pages
  iommu/dma: Add background page scrubber for PISA allocators
  mm/slub: Add SLAB_CACHE_PISA_RO for PISA-backed slab caches
  net: Allocate small skb heads from PISA
  iommu/dma: Migrate user pages into PISA for TX zerocopy
  iommu/dma: Stop recycling old PISA pages when allocator waste is high
  net/libeth: Use GFP_KERNEL when pre-filling RX rings
  net/gve: Use GFP_KERNEL when pre-filling RX rings
  net/gve: Use PISA memory for RX buffers
  block, mm, iommu/dma: Support PISA for disk I/O and scrub migration
  Documentation: Add PISA architecture documentation
  iommu/dma: Add PISA statistics and debugfs

 .../admin-guide/kernel-parameters.txt         |    6 +
 Documentation/core-api/index.rst              |    1 +
 Documentation/core-api/pisa.rst               |  426 ++++
 block/bio.c                                   |   46 +
 drivers/base/core.c                           |   78 +
 drivers/iommu/Kconfig                         |   34 +
 drivers/iommu/Makefile                        |    5 +
 drivers/iommu/dma-iommu.c                     |   48 +-
 drivers/iommu/dma-iommu.h                     |   16 +
 drivers/iommu/iommu.c                         |   10 +-
 drivers/iommu/pisa-alloc.c                    | 2063 +++++++++++++++++
 drivers/iommu/pisa-kunit.c                    |  669 ++++++
 drivers/iommu/pisa-map.c                      |  553 +++++
 drivers/iommu/pisa-meta.c                     |  300 +++
 drivers/iommu/pisa-node.c                     |  378 +++
 drivers/iommu/pisa-priv.h                     |  511 ++++
 drivers/iommu/pisa-user.c                     |  662 ++++++
 .../ethernet/google/gve/gve_buffer_mgmt_dqo.c |    7 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |   40 +-
 include/linux/device.h                        |   27 +
 include/linux/gfp_types.h                     |   17 +-
 include/linux/netdevice.h                     |    4 +
 include/linux/pisa.h                          |  367 +++
 include/linux/sched.h                         |    4 +
 include/linux/skbuff.h                        |    2 +
 include/linux/slab.h                          |   10 +
 include/linux/swap.h                          |    1 +
 include/net/libeth/rx.h                       |   11 +-
 include/net/sock.h                            |  143 ++
 include/trace/events/mmflags.h                |   11 +-
 include/uapi/asm-generic/mman-common.h        |    2 +
 kernel/dma/direct.c                           |   14 +-
 kernel/exit.c                                 |    2 +
 kernel/fork.c                                 |    2 +
 mm/filemap.c                                  |   15 +-
 mm/madvise.c                                  |   11 +
 mm/page-writeback.c                           |    8 +
 mm/page_alloc.c                               |   59 +
 mm/readahead.c                                |    5 +-
 mm/slab.h                                     |    3 +-
 mm/slab_common.c                              |    5 +-
 mm/slub.c                                     |   14 +-
 net/core/datagram.c                           |   85 +-
 net/core/page_pool.c                          |    3 +
 net/core/skbuff.c                             |   42 +-
 net/core/sock.c                               |   62 +-
 net/ipv4/esp4.c                               |    4 +-
 net/ipv4/ip_output.c                          |   19 +-
 net/ipv4/tcp.c                                |   17 +-
 net/ipv4/tcp_output.c                         |   12 +-
 net/ipv6/esp6.c                               |    4 +-
 net/ipv6/ip6_output.c                         |   19 +-
 52 files changed, 6784 insertions(+), 73 deletions(-)
 create mode 100644 Documentation/core-api/pisa.rst
 create mode 100644 drivers/iommu/pisa-alloc.c
 create mode 100644 drivers/iommu/pisa-kunit.c
 create mode 100644 drivers/iommu/pisa-map.c
 create mode 100644 drivers/iommu/pisa-meta.c
 create mode 100644 drivers/iommu/pisa-node.c
 create mode 100644 drivers/iommu/pisa-priv.h
 create mode 100644 drivers/iommu/pisa-user.c
 create mode 100644 include/linux/pisa.h

-- 
2.56.0.542.g3ef89b7020-goog


